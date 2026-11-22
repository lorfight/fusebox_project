import requests
from requests.auth import HTTPBasicAuth
import shutil
from datetime import datetime, timezone
from dateutil import parser
import base64
import os
import inspect

class AzureBoardsClient:
    def __init__(self, organization: str, project: str, personal_access_token: str):
        self.organization = organization
        self.project = project
        self.pat = personal_access_token
        self.base_url = f"https://dev.azure.com/{organization}/{project}/_apis"      
        self.headers = {
            "Content-Type": "application/json-patch+json"
        }
    
    def get_iteration_path(self, team: str) -> str:
        url = f"{self.base_url}/work/teamsettings/iterations?api-version=7.0"
        response = requests.get(
            url,
            headers={"Content-Type": "application/json"},
            auth=HTTPBasicAuth("", self.pat)
        )

        if response.status_code == 200:
            data = response.json()
            now = datetime.now(timezone.utc)
            for it in reversed(data.get("value", [])):
                attrs = it.get("attributes", {})
                start = datetime.fromisoformat(attrs["startDate"].replace("Z", "+00:00"))
                end = datetime.fromisoformat(attrs["finishDate"].replace("Z", "+00:00"))
                
                if start <= now <= end:
                    return it["path"]
            raise ValueError(f"Failed to get iterations for team '{team}'")
        else:
            raise Exception(f"Failed to get iterations")
    
    def upload_attachment(self, file_path: str):
        url = f"{self.base_url}/wit/attachments?api-version=7.0"
        with open(file_path, "rb") as f:
            response = requests.post(
                url,
                headers={"Content-Type": "application/octet-stream"},
                auth=HTTPBasicAuth("", self.pat),
                data=f
            )
        if response.status_code == 201 or response.status_code == 200:
            return response.json()["url"]
        else:
            raise Exception(f"Failed to upload attachment")

    def build_taskboard_url(self, team, iteration, task_id):
        base_url = f"https://dev.azure.com/{self.organization}/{self.project}"
        return (f"{base_url}/_sprints/taskboard/"
                f"{team}/{self.project}/{iteration}"
                f"?System.WorkItemType=Product%20Backlog%20Item%2CTask"
                f"&workitem={task_id}")
        
    def create_task(self, team: str, pbi_id: int,config_testing_type: str, fusebox_environment: str, fusebox_version: str) -> str:
        date = datetime.now().strftime("%d%m%y%H%M%S")
        iteration_path = self.get_iteration_path(team)
        url = f"{self.base_url}/wit/workitems/$Task?api-version=7.0"
        path_cur_dir = os.getcwd()
        report_dir = os.path.join(path_cur_dir, "results", "report")
        zip_path = shutil.make_archive(
            base_name=os.path.join(path_cur_dir,"results","report_archive","report_archive"),
            format="zip",
            root_dir=report_dir,
        )
        sprint_name = '-'.join(iteration_path.split('\\')[-1].split())
        attachment_url = self.upload_attachment(zip_path)
        payload = [
            {
                "op": "add",
                "path": "/fields/System.Title",
                "value": f'[AT][{fusebox_environment.strip()}][{config_testing_type.upper()}] Automation Report - Fusebox ver. {fusebox_version}'
            },
            {"op": "add", "path": "/fields/System.AreaPath", "value": f"{self.project}\\Automation Testing"},
            {
                "op": "add",
                "path": "/fields/System.Description",
                "value": ''
            },
            {
                "op": "add",
                "path": "/fields/System.IterationPath",
                "value": iteration_path
            },
            {
                "op": "add",
                "path": "/relations/-",
                "value": {
                    "rel": "System.LinkTypes.Hierarchy-Reverse",
                    "url": f"https://dev.azure.com/{self.organization}/{self.project}/_apis/wit/workItems/{pbi_id}"
                }
            },
            {
                "op": "add",
                "path": "/relations/-",
                "value": {
                    "rel": "AttachedFile",
                    "url": attachment_url,
                    "attributes": {
                        "comment": "Automation test report",
                        "name": f'Report_{config_testing_type.capitalize()}_{sprint_name}_{date}.zip'
                    }
                }
            },
            {
                "op": "add",
                "path": "/fields/Microsoft.VSTS.Scheduling.OriginalEstimate",
                "value": 2
            }
        ]

        response = requests.post(
            url,
            headers=self.headers,
            auth=HTTPBasicAuth("", self.pat),
            json=payload
        )

        if response.status_code == 200:
            task = response.json()
            build_taskboard_url = self.build_taskboard_url(team, iteration_path.split('\\')[-1], task['id'])
            print(f"Task created: ID {task['id']}, URL: {build_taskboard_url}")
            return build_taskboard_url
        else:
            print(f"❌ Failed to create task")
            return None
