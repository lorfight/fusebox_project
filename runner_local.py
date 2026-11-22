import argparse
import logging
import platform
import shutil
import smtplib
import time
import xml.etree.ElementTree as xmlElementTree
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from glob import glob
import os
import json
import requests
from azure_boards_automation import AzureBoardsClient
from libraries.CustomLibrary import *
from concurrent.futures import ThreadPoolExecutor, as_completed
import boto3
from botocore.exceptions import ClientError
from datetime import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail, Attachment, FileContent, FileName, FileType, Disposition
import base64
import zipfile
import subprocess

path_cur_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))

ROBOT_LISTENER_API_VERSION = 3
ORGANIZATION = "fabricius-software"
PROJECT = "Fusebox Improvement Tracker" 
TEAM = "Automation Team"
MAX_WORKERS = 4


def get_secret(secret_name):
    """Retrieve secret from AWS Secrets Manager"""
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=REGION)
    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
        secret = get_secret_value_response['SecretString']
        return json.loads(secret)
    except ClientError as e:
        print(f"Error retrieving secret: {e}")
        raise e

def generate_presigned_url(bucket_name: str, s3_key: str, expiration: int = 3600):
    s3_client = boto3.client('s3', region_name=REGION)
    try:
        response = s3_client.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket_name, 'Key': s3_key},
            ExpiresIn=expiration
        )
        return response
    except ClientError as e:
        print(f"Error generating presigned URL: {e}")
        return None

def generate_s3_key(report_name = "report.zip"):
    now = datetime.now()
    timestamp = now.strftime("%Y/%m/%d/%H%M%S")
    return f"{timestamp}-report/{report_name}"

def upload_report_to_s3(
    file_path: str,
    bucket_name: str,
    s3_key: str
):
    if not os.path.isfile(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    s3 = boto3.client("s3")
    print(file_path,bucket_name,s3_key)
    s3.upload_file(
        Filename=file_path,
        Bucket=bucket_name,
        Key=s3_key
    )
    print(f"Uploaded report to s3://{bucket_name}/{s3_key}") 
    try:
        s3.head_object(Bucket=bucket_name,Key=s3_key)
        return True
    except ClientError as e:
        if e.response["Error"]["Code"] == "404":
            return False
def update_test_report_to_azure_board(fusebox_version, rest_result):
    try:
        url = f"{os.environ.get('AZ_DEVOPS_CONNECTOR_URL')}/automation-testing-report"
        token = os.environ.get('AZ_DEVOPS_CONNECTOR_TOKEN')

        headers = {
            "Content-Type": "application/json",
            "Authorization": token
        }

        data = {
            "tag": fusebox_version,
            "result": rest_result
        }

        response = requests.post(url, json=data, headers=headers)

        if response.status_code == 200:
            print("Response:", response.json())
        else:
            print("Request failed with status code:", response.status_code)
            print("Error:", response.text)
    except Exception as e:
        print(f"Error updating test report to Azure Board: {e}")    

def send_email(configs, config_testing_type, results, total_time, config_env, zip_path=None):
    recipient_email = configs['recipient']
    properties = read_file_properties(f'{path_cur_dir}/results/temp_report/environment.properties')
    fusebox_environment = config_env
    fusebox_version = 'N/A'

    # Send the test results to Azure Board
    # client = AzureBoardsClient(configs['ADO']['organization'], configs['ADO']['project'], configs['ADO']['pat'])
    # attachment_link = client.create_task(configs['ADO']['team'], PBI_ID, config_testing_type, fusebox_environment, fusebox_version)

    # Build HTML content
    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Allure Report Email</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                color: #333;
                padding: 20px;
            }
            h1 {
                color: #007bff;
            }
            h2 {
                color: #28a745;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #f8f9fa;
            }
            ul {
                list-style: none;
                padding-left: 0;
            }
            li {
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <h1>Robot Report - Test Results</h1>
        <p><strong>Enviroment:</strong></p>
        <ul>
            <li>Fusebox URL: """ + re.split(r'=', properties[2])[1] + """</li>
            <li>Fusebox Environment: """ + re.split(r'=', properties[0])[1] + """</li>
            <li>Fusebox Version: """ + re.split(r'=', properties[1])[1] + """</li>
            <li>Fusebox Automation: """ + re.split(r'=', properties[2])[1] + """</li>
            <li>Browser Type: """ + re.split(r'=', properties[3])[1] + """</li>
            <li>Browser Version: """ + re.split(r'=', properties[4])[1] + """</li>
        </ul>
        <p><strong>Test Summary:</strong></p>
        <ul>
            <li>Total Tests: """ + str(results['total']) + """</li>
            <li>Passed Tests: """ + str(results['passed']) + """</li>
            <li>Failed Tests: """ + str(results['failed']) + """</li>
            <li>Skipped Tests: """ + str(results['skipped']) + """</li>
            <li>Manual Test Link: <a href='https://docs.google.com/spreadsheets/d/1eXG3gnRC_08DG0IM9xtKYphcb5aNl7Pl/edit?pli=1&gid=704330884#gid=704330884'>Click here</a></li>
            <li>Total Test Time: """ + str(total_time) + """s</li>
        </ul>
        <p><strong>Test Summary percentage:</strong> """ + str((results['passed'] / results['total']) * 100) + """ %</p>
        <h2>Test Cases:</h2>
        <table>
        <thead>
            <tr>
                <th>Test Case</th>
                <th>Owner</th>
                <th>Status</th>
                <th>Elapsed Time (seconds)</th>
            </tr>
        </thead>
        <tbody>
    """
    for test_case in results['test_cases']:
        html += f"""
                <tr>
                    <td>{test_case['name']}</td>
                    <td>{test_case['owner']}</td>
                    <td>{test_case['status']}</td>
                    <td>{test_case['elapsed_time']:.2f}</td>
                </tr>
        """
    html += """
        </tbody>
        </table>
    </body>
    </html>
    """
    # <p><a href = '""" + attachment_link + """' > Task Item </a></p>
    try:
        secret_data = get_secret(configs['secret_key'])
        message = Mail(
            from_email=secret_data['SendGridFrom'],
            to_emails=recipient_email,
            subject=f'[AUTOMATION TESTING][{fusebox_environment.strip()}][{config_testing_type.upper()}] Test Result - Fusebox ver. {fusebox_version} - {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
            html_content=html
        )

        # Add attachment if zip_path is provided
        if zip_path and os.path.exists(zip_path):
            with open(zip_path, 'rb') as f:
                file_data = f.read()
                encoded_file = base64.b64encode(file_data).decode()

            attached_file = Attachment(
                FileContent(encoded_file),
                FileName(os.path.basename(zip_path)),
                FileType('application/zip'),
                Disposition('attachment')
            )
            message.attachment = attached_file
            print(f"Attached file: {zip_path}")

        sg = SendGridAPIClient(secret_data['SendGridApiKey'])
        response = sg.client.mail.send.post(request_body=message.get())

        print(f"Results have been sent to {' '.join(recipient_email)} email!")
        print(f"Email sent successfully. Status code: {response.status_code}")
    except Exception as e:
        print(f"Failed to send email. Error: {e}")

    # Send the test results to Azure Board
    if config_testing_type == 'smoke':
        update_test_report_to_azure_board(fusebox_version, html)

def calculate_elapsed_time(start_time, end_time):
    """
    Calculate the elapsed time in seconds between two timestamps.
    :param start_time: Start time as a string (e.g., '20250324 14:15:06.136').
    :param end_time: End time as a string (e.g., '20250324 14:15:16.313').
    :return: Elapsed time in seconds as a float.
    """
    try:
        # Define the timestamp format
        time_format = "%Y%m%d %H:%M:%S.%f"

        # Parse the start and end times
        start = datetime.strptime(start_time, time_format)
        end = datetime.strptime(end_time, time_format)

        # Calculate the elapsed time in seconds
        elapsed_time = (end - start).total_seconds()

        return elapsed_time
    except Exception as e:
        print(f"Error calculating elapsed time: {e}")
        return None

def get_owner_from_test_tags(test_element):
    """
    Extract the owner from the <tag> elements in a <test> element.
    :param test_element: The <test> element from the XML.
    :return: The owner value if found, otherwise 'None'.
    """
    for tag in test_element.findall("tag"):
        if tag.text.startswith("report.label.owner:"):
            # Extract the owner value after "report.label.owner:"
            return tag.text.split("report.label.owner:")[1]
    return "None"

def get_result_test_from_file_xml(file_path):
    try:
        stats = {
            "total": 0,
            "passed": 0,
            "failed": 0,
            "skipped": 0,
            "total_elapsed_time": 0.0,
            "test_cases": []
        }
        xml_result = glob(os.path.join(f'{file_path}','*.xml'))[0]
        tree = xmlElementTree.parse(xml_result)
        root = tree.getroot()

        # Iterate through all test cases
        for test in root.findall(".//test"):
            test_name = test.attrib.get("name")
            status = test.find("status").attrib.get("status")
            start_time = test.find("status").attrib.get("starttime")
            end_time = test.find("status").attrib.get("endtime")
            owner = get_owner_from_test_tags(test)
            # Calculate elapsed time in seconds
            elapsed_time = calculate_elapsed_time(start_time, end_time)

            # Update statistics
            stats["total"] += 1
            if status == "PASS":
                stats["passed"] += 1
            elif status == "FAIL":
                stats["failed"] += 1
            else:
                stats["skipped"] += 1

            # Add to total elapsed time
            stats["total_elapsed_time"] += elapsed_time

            # Add test case details
            stats["test_cases"].append({
                "name": test_name,
                "owner": owner,
                "status": status,
                "elapsed_time": elapsed_time
            })
        print(f"Stats: {stats}")
        return stats
    except Exception as e:
        print(f"Error reading XML file: {e}")
        return None, None

def load_json(file_path):
    try:
        with open(file_path) as f:
            return json.load(f)
    except Exception as e:
        print(f'Failed to load {file_path}. Error: {e}')
        return {}

def remove_and_create_dir(directory):
    shutil.rmtree(directory, ignore_errors=True)
    os.makedirs(directory, exist_ok=True)

def run_robot_framework(robot_path,suite_ids,save_report,test_execution_type,user=None,target_user=None,):
    if target_user is None:
        target_user = user

    if suite_ids == ["*"]:
        include_suite_ids = f'-i "{target_user["role"]}"'
    else:
        include_suite_ids = (
            f'-i "{target_user["role"]}AND'
            + "OR".join(suite_ids)
            + '"'
        )
    robot_command = (
        f'python -m robot {include_suite_ids} '
        f'--variable Userrole:"{user.get("role","")}" '
        f'--variable Username:"{user.get("username","")}" '
        f'--variable Password:"{user.get("password","")}" '
        f'--variable UserAccount:"{user.get("account","")}" '
        f'--variable Secret:"{user.get("secret","")}" '
        f'--variable MFA:"{user.get("MFA",False)}" '
        f'--variable TargetRole:"{target_user.get("role","")}" '
        f'--variable TargetUsername:"{target_user.get("username","")}" '
        f'--variable TargetPassword:"{target_user.get("password","")}" '
        f'--variable TargetAccount:"{target_user.get("account","")}" '
        f'--variable save_report:"{save_report}" '
        f'--variable test_execution_type:"{test_execution_type}" '
        f'--outputdir "{save_report}" '
        f'--listener RetryFailed '
        f'"{robot_path}"'
    )
    os.system(robot_command)

def run_robot_framework_api(robot_path, save_report, type_test, test_execution_type):
    robot_command = (
        f"python -m robot -i {type_test} "
        f"--variable save_report:{save_report} "
        f"--variable test_execution_type:{test_execution_type} "
        f"--outputdir {save_report} "
        f"{robot_path}"
    )
    os.system(robot_command)

def post_process_results(results_dir, config_testing_type, config_env):
    # shutil.copytree(f'{results_dir}/temp_report', f'{results_dir}/history', dirs_exist_ok=True)
    combine_report_command = (
        f"python -m robot.rebot "
        f"--name {config_testing_type.capitalize()} "
        f"--outputdir {os.path.join(results_dir,'report',config_env,config_testing_type)} "
        f"--output output.xml "
        f"{os.path.join(results_dir,'robotframework',config_env,config_testing_type,'*','*','*.xml')}"
        )
    print(f"Executing command: {combine_report_command}")
    result = os.system(combine_report_command)
    print(f"Command exit code: {result}")

    output_dir = os.path.join(results_dir, 'report')
    print(f"Checking output directory: {output_dir}")
    if os.path.exists(output_dir):
        files = os.listdir(output_dir)
        print(f"Files created in output directory: {files}")
        for file in files:
            file_path = os.path.join(output_dir, file)
            print(f"  - {file} (size: {os.path.getsize(file_path)} bytes)")
    else:
        print(f"Output directory does not exist: {output_dir}")

def get_info_environment(file_path, environment='QA', execution_url=''):
    # Get system information
    os_platform = platform.system()
    os_release = platform.release()
    os_version = platform.version()
    python_version = platform.python_version()
    browser_type = os.environ.get('BROWSER_TYPE', 'chrome')
    browser_headless = os.environ.get('BROWSER_HEADLESS', 'False')
    if browser_type == 'headlesschrome':
        browser_type = 'chrome'

    # Prepare data to write
    data = [
        f'fusebox_environment = {environment.upper()}',
        f'fusebox_version = {"tag_name"}',
        f'fusebox_automation = {os.environ.get("SCRIPT_VERSION", "")}',
        f'browser_type = {browser_type.upper()}',
        f'browser_version = N/A',
        f'browser_headless = {browser_headless}',
        f'os_platform = {os_platform}',
        f'os_release = {os_release}',
        f'os_version = {os_version}',
        f'python_version = {python_version}'
    ]

    # Write data to properties file
    with open(file_path, 'w') as f:
        f.write('\n'.join(data))

    categories_json = readTxt(f"{path_cur_dir}/profiles/categories.json")
    # print(categories_json)
    writeTxt(f"{path_cur_dir}/results/temp_report/categories.json", categories_json)

    executor_json = read_json(f"{path_cur_dir}/profiles/executor.json")
    # print(executor_json)
    try:
        executor_json["url"] = f"https://mbjenkins.vbpo-st.com/view/Automation%20Test/"
        executor_json["buildOrder"] = int(re.findall(r'\d+', execution_url)[0])
        executor_json["buildName"] = f"robot-report_deploy#" + str(re.findall(r'\d+', execution_url)[0])
        executor_json["buildUrl"] = execution_url
        executor_json["reportUrl"] = f"https://mbautomation-testing.vbpo-st.com/"
        executor_json["reportName"] = f"Robot report - Automation Testing - Fusebox"
    except:
        executor_json["url"] = f"https://mbjenkins.vbpo-st.com/view/Automation%20Test/"
        executor_json["buildOrder"] = 0
        executor_json["buildName"] = f"report-report_deploy#0"
        executor_json["buildUrl"] = f"index.html"
        executor_json["reportUrl"] = f"https://mbautomation-testing.vbpo-st.com/"
        executor_json["reportName"] = f"Robot report - Automation Testing - Fusebox"

    # convert json to string
    executor_json = json.dumps(executor_json)
    writeTxt(f"{path_cur_dir}/results/temp_report/executor.json", executor_json)

def get_version_fusebox(url):
    import requests
    from bs4 import BeautifulSoup
    print(url)
    response = requests.get(url + 'User/Login')
    response.raise_for_status()  # CHECK ERROR HTTP

    soup = BeautifulSoup(response.content, 'html.parser')
    version = soup.find('input', {'id': 'app-version'}).get('value')
    print(version)
    return version

def get_config(config_env):
    config_path = f'{path_cur_dir}/configs/site/{config_env}.json'
    print("Config path: ", config_path)
    return  load_json(config_path)

def set_runtime_variables(configs):
    for key, value in configs.items():
        if type(value) == dict:
            for key2, value2 in value.items():
                print(f"Set Runtime Variable: {key.upper()}_{key2.upper()}")
                os.environ[f"{key.upper()}_{key2.upper()}"] = str(value2)
        else:
            print(f"Set Runtime Variable: {key.upper()}")
            os.environ[key.upper()] = str(value)
    return 

def map_users_to_tests(config_testing_role, list_users, list_robots, path_cur_dir):
    user_test_mapping = {}
    for user in [u["role"] for u in list_users]:
        if user not in list_robots:
            continue
        if user == "Impersonate":
            for role in config_testing_role.split(","):
                role = role.strip()
                if role not in list_robots:
                    continue
                test_files = list_robots[role].values()
                test_paths = [os.path.join(path_cur_dir, "tests", test_file) for test_file in test_files]
                user_test_mapping[f"Impersonate.{role}"] = test_paths
            continue
        test_files = list_robots[user].values()
        test_paths = [os.path.join(path_cur_dir, "tests", test_file) for test_file in test_files]
        user_test_mapping[user] = test_paths
    return user_test_mapping

def execute_robot(user,suite_ids,user_test_mapping,config_testing_type,config_test_execution_type,config_env,configs,):
    role = user["role"]
    if role == "Impersonate":
        run_roles = [key for key in user_test_mapping.keys() if key.startswith("Impersonate.")]
    else:
        run_roles = [role]
    for run_role in run_roles:
        if run_role not in user_test_mapping:
            continue
        if run_role.startswith("Impersonate."):
            target_role = run_role.split(".", 1)[1]
        else:
            target_role = run_role
        target_user = next((u for u in configs["fusebox"]["users"] if u["role"] == target_role),user)
        for path_robot in user_test_mapping[run_role]:
            save_name = os.path.basename(path_robot).replace(".robot", "")
            save_report = os.path.join("results","robotframework",config_env,config_testing_type,run_role,save_name,)
            run_robot_framework(path_robot,suite_ids,save_report,config_test_execution_type,user,target_user,)
        
def init_and_clean_up_directories(result_folders, results_dir):
    try:
        for folder in result_folders:
            remove_and_create_dir(os.path.join(results_dir, folder))
    except Exception as e:
        print(f'Failed to init and clean up directories. Error: {e}')

def run_api_tests(path_cur_dir, config_testing_type, config_test_execution_type):
    with open(f'{path_cur_dir}/configs/type/tests_api.json') as f:
        list_robots = json.load(f).values()
    for path_robot in list_robots:
        robot_base = os.path.basename(path_robot)
        save_name = robot_base.replace('.robot', '')
        save_report = os.path.join('results', 'robotframework', 'api', save_name)
        run_robot_framework_api(os.path.join(path_cur_dir, 'tests', path_robot), save_report, config_testing_type, config_test_execution_type)

def run_impersonate_robot_framework(robot_path,suite_ids,save_report,test_execution_type,user,target_user):
    if suite_ids == ["*"]:
        include_suite_ids = f'-i "{target_user["role"]}"'
    else:
        include_suite_ids = f'-i "{target_user["role"]}AND' + "OR".join(suite_ids) + '"'
    api_capture_path = os.path.join(path_cur_dir, "libraries", "ApiCapture.py")
    robot_command = (
        f'python -m robot {include_suite_ids} '
        f'--variable Userrole:"{user.get("role","")}" '
        f'--variable Username:"{user.get("username","")}" '
        f'--variable Password:"{user.get("password","")}" '
        f'--variable UserAccount:"{user.get("account","")}" '
        f'--variable Secret:"{user.get("secret","")}" '
        f'--variable MFA:"{user.get("MFA",False)}" '
        f'--variable TargetRole:"{target_user.get("role","")}" '
        f'--variable TargetUsername:"{target_user.get("username","")}" '
        f'--variable TargetPassword:"{target_user.get("password","")}" '
        f'--variable TargetAccount:"{target_user.get("account","")}" '
        f'--variable save_report:"{save_report}" '
        f'--variable test_execution_type:"{test_execution_type}" '
        f'--outputdir "{save_report}" '
        f'--listener RetryFailed '
        f'--listener "{api_capture_path}" '
        f'"{robot_path}"'
    )
    os.system(robot_command)

def map_impersonate_tests(config_testing_role,list_robots,path_cur_dir):
    user_test_mapping = {}
    roles = config_testing_role.replace("Impersonate:","",1).strip()
    if roles == "*":
        roles = ",".join(list_robots.keys())
    for role in [r.strip() for r in roles.split(",") if r.strip()]:
        if role not in list_robots:
            print(f"[IMPERSONATE] Role not found in robot config: {role}")
            continue
        test_files = list_robots[role].values()
        user_test_mapping[f"Impersonate.{role}"] = [os.path.join(path_cur_dir,"tests",test_file) for test_file in test_files]
    return user_test_mapping


def get_target_user(configs,target_role):
    return next((u for u in configs.get("fusebox",{}).get("users",[]) if u["role"] == target_role),None)


def execute_impersonate_robot(user,suite_ids,user_test_mapping,config_testing_type,config_test_execution_type,config_env,configs):
    for run_role,test_paths in user_test_mapping.items():
        target_role = run_role.split(".",1)[1]
        target_user = get_target_user(configs,target_role)
        if not target_user:
            print(f"[IMPERSONATE] Target user not found: {target_role}")
            continue
        for path_robot in test_paths:
            save_name = os.path.basename(path_robot).replace(".robot","")
            save_report = os.path.join("results","robotframework",config_env,config_testing_type,run_role,save_name)
            print(f"[IMPERSONATE] User: {user.get('username','')} -> Target: {target_role} -> {save_name}")
            run_impersonate_robot_framework(path_robot,suite_ids,save_report,config_test_execution_type,user,target_user)


def clear_impersonate_api_logs(target_role):
    role = str(target_role or "").split(":")[-1]
    api_log_dir = os.path.join(path_cur_dir, "results", "api_logs")
    api_log_file = os.path.join(api_log_dir, f"{role}.json")
    os.makedirs(api_log_dir, exist_ok=True)
    if os.path.exists(api_log_file):
        os.remove(api_log_file)
        print(f"[API LOG] Deleted: {api_log_file}")

def run_impersonate_ui_tests(configs,suite_ids,config_testing_role,path_cur_dir,config_testing_type,config_test_execution_type,config_env):
    with open(f"{path_cur_dir}/configs/type/{config_testing_type}.json") as f:
        list_robots = json.load(f)
    impersonate_user = next((u for u in configs.get("fusebox",{}).get("users",[]) if u["role"] == "Impersonate"),None)
    if not impersonate_user:
        print("[IMPERSONATE] User with role 'Impersonate' not found.")
        return
    clear_impersonate_api_logs(config_testing_role)
    user_test_mapping = map_impersonate_tests(config_testing_role,list_robots,path_cur_dir)
    if not user_test_mapping:
        print(f"[IMPERSONATE] No test found for role: {config_testing_role}")
        return
    execute_impersonate_robot(impersonate_user,suite_ids,user_test_mapping,config_testing_type,config_test_execution_type,config_env,configs)


def run_ui_tests(configs,suite_ids,config_testing_role,path_cur_dir,config_testing_type,config_test_execution_type,config_env,):
    with open(f"{path_cur_dir}/configs/type/{config_testing_type}.json") as f:
        list_robots = json.load(f)
        original_testing_role = config_testing_role
        if config_testing_role == "*":
            config_testing_role = ",".join(list_robots.keys())
        role_filter = None
        if ":" in config_testing_role:
            config_testing_role, role_filter = config_testing_role.split(":", 1)
            role_filter = [r.strip() for r in role_filter.split(",")]
        expanded_roles = []
        for role in config_testing_role.split(","):
            role = role.strip()
            if isinstance(list_robots.get(role), list):
                roles = list_robots[role]
                if role_filter:
                    roles = [r for r in roles if r in role_filter]
                expanded_roles.extend(roles)
            else:
                expanded_roles.append(role)
        config_testing_role = ",".join(expanded_roles)
    if original_testing_role.startswith("Impersonate"):
        user_role = "Impersonate"
    elif ":" in original_testing_role:
        user_role = original_testing_role.split(":", 1)[0]
    else:
        user_role = config_testing_role

    list_users = [
        user
        for user in configs.get("fusebox", {}).get("users", [])
        if user["role"] in [r.strip() for r in user_role.split(",")]
    ]
    user_test_mapping = map_users_to_tests(config_testing_role,list_users,list_robots,path_cur_dir,)
    results = {}
    future_to_user = {}
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        for user in list_users:
            future = executor.submit(execute_robot,user,suite_ids,user_test_mapping,config_testing_type,config_test_execution_type,config_env,configs,)
            future_to_user[future] = user["username"]
        for future in as_completed(future_to_user):
            username = future_to_user[future]
            try:
                future.result()
                results[username] = "SUCCESS"
                print(f"[PASS] Tests completed for user: {username}")
            except Exception as e:
                print(f"[FAIL] Tests failed for user: {username}. Error: {e}")

def main():
    parser = argparse.ArgumentParser(description='A program that reads input file and writes output file.')
    parser.add_argument('-e', type=str, help='<environment>')
    parser.add_argument('--test-ids', required=True, type=str,
                        help='List of test ids to run, separated by comma. Ex: 1,2,3,4,5')
    parser.add_argument('--max-execution-time', required=False, type=str, default=60,
                        help='Maximum execution time for all tests in minutes')
    parser.add_argument('--execution-url', required=False, type=str, help='Jenkins execution URL')
    parser.add_argument('--testing-type', required=False, type=str,
                        help='Type of testing: sanity, regression, smoke, etc.')
    parser.add_argument('--test-execution-type', required=False, type=str,help='Type of testing: sequential, parallel, etc.')
    parser.add_argument('--testing-role', required=False, type=str,
                        help='Test role to run: Admin,Accounting,Manager,Contractadmin,Techsupport,Advanced,Limited,Standard')

    args = parser.parse_args()
    config_env = args.e
    configs = get_config(config_env)
    config_test_ids = args.test_ids if args.test_ids is not None else None
    config_testing_type = args.testing_type if args.testing_type is not None else None
    config_test_execution_type = args.test_execution_type if args.test_execution_type is not None else None
    config_testing_role = args.testing_role if args.testing_role is not None else None
    suite_ids = config_test_ids.split(',')
    os.environ["SCRIPT_VERSION"] = ""
    time.sleep(5)
    print("*" * 50)
    print("Environment: ", config_env)
    print("Test IDs: ", config_test_ids)
    print("Max execution time: ", args.max_execution_time)
    print("Execution URL: ", args.execution_url)
    print("*" * 50)
    path_cur_dir = os.getcwd()
    results_dir = os.path.join(f'{path_cur_dir}','results')
    result_folders = ['robotframework', 'report', 'report_archive', 'temp_report', 'history','export']
    # init_and_clean_up_directories(result_folders, results_dir)
    get_info_environment(f'{os.path.join(results_dir,"temp_report","environment.properties")}', config_env, args.execution_url)
    set_runtime_variables(configs)
    start_time = datetime.now()
    if config_testing_type == 'api':
        run_api_tests(path_cur_dir, config_testing_type, config_test_execution_type)
    elif config_testing_role and config_testing_role.startswith("Impersonate"):
        run_impersonate_ui_tests(configs,suite_ids,config_testing_role,path_cur_dir,config_testing_type,config_test_execution_type,config_env)
    else:
        run_ui_tests(configs,suite_ids,config_testing_role,path_cur_dir,config_testing_type,config_test_execution_type,config_env)
    end_time = datetime.now()
    total_time = round((end_time - start_time).total_seconds())
    print(f"Total time to run tests: {total_time} seconds")
    post_process_results(results_dir, config_testing_type,config_env)
    zip_path = os.path.join(path_cur_dir, "results", "report_archive", "report_archive.zip")
    source_dir = os.path.join(results_dir, "report")
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
        for root, dirs, files in os.walk(source_dir):
            for file in files:
                if file.lower().endswith('.html'):
                    file_path = os.path.join(root, file)
                    # Calculate the archive name (relative path from source_dir)
                    arcname = os.path.relpath(file_path, source_dir)
                    zipf.write(file_path, arcname)
    print(f"Created compressed archive: {zip_path}")
    print(f"File size: {os.path.getsize(zip_path) / (1024 * 1024):.2f}MB")

if __name__ == '__main__':
    main()