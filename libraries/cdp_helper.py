import json
def enable_network(driver):
    driver.execute_cdp_cmd("Network.enable",{})
    
def get_document_requests(driver):
    logs = driver.get_log("performance")
    results = []
    requests= {}
    for log in logs:
        msg = json.loads(log["message"])["message"]
        method = msg.get("method")
        params = msg.get("params", {})

        # START
        if method == "Network.requestWillBeSent":
            if params.get("type") == "Document":
                request_id = params["requestId"]
                requests[request_id] = {
                    "url": params["request"]["url"],
                    "start": params["timestamp"]
                }

        # END
        if method == "Network.responseReceived":
            request_id = params["requestId"]

            if request_id in requests:
                start_time = requests[request_id]["start"]
                end_time = params["timestamp"]

                duration = (end_time - start_time) * 1000  # ms

                results.append({
                    "url": requests[request_id]["url"],
                    "duration_ms": duration
                }) 
    return results