import json, os, traceback
from urllib.parse import urlparse, parse_qs
from datetime import datetime, timedelta
from robot.libraries.BuiltIn import BuiltIn

ROBOT_LISTENER_API_VERSION = 2
RESULTS = []
TARGET_APIS = {}
TARGET_API_SEQUENCE = []
TARGET_ACTION_SEQUENCE = []
CURRENT_SCOPE = ""
CURRENT_ROLE = ""
CURRENT_SUITE = ""
CURRENT_TESTCASE = ""
CAPTURE_ACTIVE = False
API_CAPTURE = {}
CAPTURED_REQUESTS = []
AFTER_SUITE_ACTIVE = False
TESTCASE_ACTIVE = False
TEARDOWN_DEPTH = 0

def normalize_role(role):
    return str(role or "").split(":")[-1]

def convert_time(timestamp):
    dt = datetime.fromtimestamp(timestamp) - timedelta(hours=12)
    return f"{dt.month}/{dt.day}/{dt.year} {dt.strftime('%I').lstrip('0')}:{dt.strftime('%M:%S %p')}"

def get_endpoint(url):
    parts = [p for p in urlparse(url).path.split("/") if p]
    if len(parts) >= 2:
        return f"{parts[-2]} -- {parts[-1]}"
    return parts[0] if parts else url

def get_payload(request):
    if request.get("method", "").upper() == "GET":
        query = parse_qs(urlparse(request["url"]).query, keep_blank_values=True)
        return {k: v[0] if len(v) == 1 else v for k, v in query.items()}

    post_data = request.get("postData", "")
    if not post_data:
        return {}

    try:
        return json.loads(post_data)
    except Exception:
        try:
            form = parse_qs(post_data, keep_blank_values=True)
            return {k: v[0] if len(v) == 1 else v for k, v in form.items()}
        except Exception:
            return {"raw": post_data}

def get_output_path():
    role_name = normalize_role(CURRENT_ROLE)
    output = os.path.join("results", "api_logs", f"{role_name}.json")
    os.makedirs(os.path.dirname(output), exist_ok=True)
    return role_name, output

def load_json(path, default=None):
    if not os.path.exists(path):
        return {} if default is None else default

    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError):
        return {} if default is None else default

def save_json(path, data):
    def format_json(obj, level=0):
        indent = "    " * level
        next_indent = "    " * (level + 1)

        if isinstance(obj, dict):
            if set(obj.keys()) == {"status"}:
                return json.dumps(obj, ensure_ascii=False)

            lines = ["{"]
            items = list(obj.items())

            for i, (key, value) in enumerate(items):
                comma = "," if i < len(items) - 1 else ""

                if key == "apis" and isinstance(value, list):
                    if not value:
                        lines.append(f'{next_indent}"{key}": []{comma}')
                    else:
                        lines.append(f'{next_indent}"{key}": [')
                        for j, api in enumerate(value):
                            api_comma = "," if j < len(value) - 1 else ""
                            lines.append(
                                f'{"    " * (level + 2)}'
                                f"{json.dumps(api, ensure_ascii=False)}{api_comma}"
                            )
                        lines.append(f"{next_indent}]{comma}")

                elif isinstance(value, list) and not value:
                    lines.append(f'{next_indent}"{key}": []{comma}')

                else:
                    lines.append(
                        f'{next_indent}"{key}": '
                        f"{format_json(value, level + 1)}{comma}"
                    )

            lines.append(f"{indent}}}")
            return "\n".join(lines)

        if isinstance(obj, list):
            if not obj:
                return "[]"

            lines = ["["]

            for i, item in enumerate(obj):
                comma = "," if i < len(obj) - 1 else ""
                lines.append(
                    f'{"    " * (level + 1)}' f"{format_json(item, level + 1)}{comma}"
                )

            lines.append(f"{indent}]")
            return "\n".join(lines)

        return json.dumps(obj, ensure_ascii=False)

    os.makedirs(os.path.dirname(path), exist_ok=True)

    with open(path, "w", encoding="utf-8") as f:
        f.write(format_json(data) + "\n")

def initialize_role_log():
    global API_CAPTURE

    role_name, output = get_output_path()
    API_CAPTURE = load_json(output)
    BuiltIn().set_global_variable("${API_CAPTURE}", API_CAPTURE)

def load_api_config():
    base_path = os.path.join(os.getcwd(), "configs", "api")
    role_name = normalize_role(CURRENT_ROLE)
    action_config_path = os.path.join(base_path, "api_actions", f"{role_name}.json")
    define_path = os.path.join(base_path, "api_define.json")

    try:
        action_config = load_json(action_config_path)
        api_define = load_json(define_path)
        return action_config.get(role_name, {}), api_define
    except Exception:
        traceback.print_exc()
        return {}, {}

def start_api_capture(scope="", testcase_name=None):
    global RESULTS, TARGET_APIS, TARGET_API_SEQUENCE, TARGET_ACTION_SEQUENCE
    global CURRENT_ROLE, CURRENT_SUITE, CURRENT_TESTCASE, CURRENT_SCOPE
    global CAPTURE_ACTIVE, CAPTURED_REQUESTS

    RESULTS = []
    CAPTURED_REQUESTS = []
    TARGET_APIS = {}
    TARGET_API_SEQUENCE = []
    TARGET_ACTION_SEQUENCE = []

    CURRENT_ROLE = BuiltIn().get_variable_value("${TargetRole}")

    if not CURRENT_SUITE:
        CURRENT_SUITE = BuiltIn().get_variable_value("${SUITE NAME}")

    CURRENT_TESTCASE = testcase_name or BuiltIn().get_variable_value("${TEST NAME}")
    CURRENT_SCOPE = scope

    role_config, api_define = load_api_config()
    suite_config = role_config.get(CURRENT_SUITE, {})
    target_list = suite_config.get(scope or CURRENT_TESTCASE, [])

    for item in target_list:
        if not isinstance(item, str) or "." not in item:
            continue

        group, action_name = item.split(".", 1)
        action_apis = api_define.get(group, {}).get(action_name, [])

        if not isinstance(action_apis, list):
            continue

        TARGET_ACTION_SEQUENCE.append({"action": item, "apis": action_apis})

        for api in action_apis:
            if not isinstance(api, dict) or not api.get("url"):
                continue

            url = api["url"]
            TARGET_API_SEQUENCE.append(url)
            TARGET_APIS.setdefault(url, []).append({"action": item, "api": api})

    CAPTURE_ACTIVE = True

def collect_api_logs():
    if not CAPTURE_ACTIVE:
        return

    try:
        driver = BuiltIn().get_library_instance("SeleniumLibrary").driver
        logs = driver.get_log("performance")
    except Exception:
        return

    for log in logs:
        try:
            message = json.loads(log["message"])["message"]

            if message["method"] != "Network.requestWillBeSent":
                continue

            params = message["params"]
            request = params["request"]
            url = request["url"]

            matched_url = next(
                (target_url for target_url in TARGET_APIS if target_url in url), None
            )

            if not matched_url:
                continue

            result = {
                "requestTime": (
                    convert_time(params["wallTime"]) if params.get("wallTime") else ""
                ),
                "url": matched_url,
            }

            if any(
                item["api"].get("verifyPayload", False)
                for item in TARGET_APIS[matched_url]
            ):
                result["payload"] = get_payload(request)

            CAPTURED_REQUESTS.append(result)

        except Exception:
            traceback.print_exc()

def build_action_results():
    action_results = []
    used_indexes = set()

    for action in TARGET_ACTION_SEQUENCE:
        action_data = {"action": action["action"], "apis": []}

        for expected in action["apis"]:
            target_url = expected.get("url")

            if not target_url:
                continue

            found_index = -1

            for index, captured in enumerate(CAPTURED_REQUESTS):
                if index in used_indexes:
                    continue

                if captured.get("url") == target_url:
                    found_index = index
                    break

            if found_index != -1:
                result = dict(CAPTURED_REQUESTS[found_index])
                result = {
                    "status": result.pop("status", "FOUND"),
                    "uiStatus": result.pop("uiStatus", "NOT_VERIFY"),
                    **result,
                }
                result["url"] = target_url
                used_indexes.add(found_index)
            else:
                result = {
                    "status": "NOT_FOUND",
                    "uiStatus": "NOT_FOUND",
                    "requestTime": "",
                    "url": target_url,
                }

            action_data["apis"].append(result)

        action_results.append(action_data)

    return action_results

def save_api_capture(collect_logs=True):
    global RESULTS, API_CAPTURE, CAPTURE_ACTIVE

    if not CAPTURE_ACTIVE:
        return

    if collect_logs:
        collect_api_logs()

    RESULTS = build_action_results()

    role_name, output = get_output_path()
    output_data = load_json(output)

    output_data.setdefault(role_name, {}).setdefault(CURRENT_SUITE, {})

    key = CURRENT_SCOPE or CURRENT_TESTCASE
    output_data[role_name][CURRENT_SUITE][key] = RESULTS

    save_json(output, output_data)

    API_CAPTURE = output_data
    BuiltIn().set_global_variable("${API_CAPTURE}", API_CAPTURE)

    CAPTURE_ACTIVE = False

def save_after_suite_api():
    try:
        save_api_capture()
    except Exception:
        traceback.print_exc()

def save_api_capture_verification(verify_result):
    global API_CAPTURE

    try:
        role_name, output = get_output_path()

        suite_data = API_CAPTURE.setdefault(role_name, {}).setdefault(CURRENT_SUITE, {})

        API_CAPTURE[role_name][CURRENT_SUITE] = {
            "verification": {"status": "PASSED" if verify_result else "FAILED"},
            **{
                key: value for key, value in suite_data.items() if key != "verification"
            },
        }

        save_json(output, API_CAPTURE)
        BuiltIn().set_global_variable("${API_CAPTURE}", API_CAPTURE)

    except Exception:
        traceback.print_exc()

def start_suite(name, attrs):
    global CURRENT_SUITE, CURRENT_ROLE

    try:
        CURRENT_SUITE = name.split(".")[-1]
        CURRENT_ROLE = BuiltIn().get_variable_value("${TargetRole}")

        initialize_role_log()
        start_api_capture("beforeSuite")

    except Exception:
        traceback.print_exc()

def start_test(name, attrs):
    global TESTCASE_ACTIVE

    try:
        TESTCASE_ACTIVE = True

        save_api_capture()
        start_api_capture("", testcase_name=name)

    except Exception:
        traceback.print_exc()

def end_test(name, attrs):
    global TESTCASE_ACTIVE
    try:
        save_api_capture()
    except Exception:
        traceback.print_exc()
    finally:
        TESTCASE_ACTIVE = False

def start_keyword(name, attrs):
    global AFTER_SUITE_ACTIVE, TEARDOWN_DEPTH
    try:
        keyword_type = str(attrs.get("type", "")).upper()

        if keyword_type == "TEARDOWN":
            if TESTCASE_ACTIVE:
                return

            if not AFTER_SUITE_ACTIVE:
                AFTER_SUITE_ACTIVE = True
                TEARDOWN_DEPTH = 1
                start_api_capture("afterSuite")
            else:
                TEARDOWN_DEPTH += 1

            return

        if AFTER_SUITE_ACTIVE:
            TEARDOWN_DEPTH += 1

    except Exception:
        traceback.print_exc()

def end_keyword(name, attrs):
    global AFTER_SUITE_ACTIVE, TEARDOWN_DEPTH

    try:
        if not AFTER_SUITE_ACTIVE or TESTCASE_ACTIVE:
            return

        keyword_type = str(attrs.get("type", "")).upper()

        collect_api_logs()

        if TEARDOWN_DEPTH > 1:
            TEARDOWN_DEPTH -= 1
            return

        if keyword_type == "TEARDOWN":
            save_api_capture(collect_logs=False)
            AFTER_SUITE_ACTIVE = False
            TEARDOWN_DEPTH = 0

    except Exception:
        traceback.print_exc()

def end_suite(name, attrs):
    global AFTER_SUITE_ACTIVE, TEARDOWN_DEPTH

    try:
        if AFTER_SUITE_ACTIVE:
            collect_api_logs()
            save_api_capture(collect_logs=False)
            AFTER_SUITE_ACTIVE = False
            TEARDOWN_DEPTH = 0

    except Exception:
        traceback.print_exc()