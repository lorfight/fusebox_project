import gspread as gs
from oauth2client.service_account import ServiceAccountCredentials
import json
import pandas as pd
import os

if os.environ.get('BROWSER_TYPE') is None:
    # Login Page Test Data
    Browser = os.environ.get('BROWSER_TYPE',"Chrome")    #"headlessChrome"
    SiteUrl = os.environ.get('FUSEBOX_URL',"https://fusebox-portal-dev.azurewebsites.net")
    Username = os.environ.get('FUSEBOX_USERNAME',"")
    Password = os.environ.get('FUSEBOX_PASSWORD',"")
else:
    Browser = os.environ.get('BROWSER_TYPE')
    SiteUrl = os.environ.get('FUSEBOX_URL')
    Username = os.environ.get('FUSEBOX_USERNAME')
    Password = os.environ.get('FUSEBOX_PASSWORD')
def connect_gsheet(env):
    current_working_dir = os.getcwd()
    with open(f'{current_working_dir}/configs/{env}.json', 'r') as config_file:
        config = json.load(config_file)
    google_config = config['google']
    scope = ['https://www.googleapis.com/auth/spreadsheets','https://www.googleapis.com/auth/drive']
    creds = ServiceAccountCredentials.from_json_keyfile_dict(google_config, scope)
    client = gs.authorize(creds)
    return client


if "qa" in SiteUrl:
    environment = "QA"
    globals()["env"] = "qa"
elif "secure" in SiteUrl:
    environment = "prod"
    globals()["env"] = "prod"
elif "staging" in SiteUrl:
    environment = "Staging"
    globals()["env"] = "staging"
elif "dev" in SiteUrl:
    environment = "Dev"
    globals()["env"] = "dev"
client = connect_gsheet(env)
# Set up credentials
def get_data_from_sheets(suite,source):
    # Select a specific worksheet
    sheet = client.open(environment)
    worksheet = sheet.worksheet(source.split(os.sep)[-2].lower())
    sheet_data  =  pd.DataFrame(worksheet.get_all_records()).to_dict(orient='records')
    suite = [record for record in sheet_data if record.get('Test Suite') == suite][0]
    return json.loads(suite['data input'].replace("\n",""))

def get_data_from_sheets_custom(suite_name, source):
    sheet = client.open(environment)
    worksheet = sheet.worksheet('edi')
    sheet_data  =  pd.DataFrame(worksheet.get_all_records()).to_dict(orient='records')
    suite_name = 'CreateOrder'
    suite= [record for record in sheet_data if record.get('Test Suite') == suite_name]
    return json.loads(suite[0]['data input'].replace("\n", ""))

def get_path_config():
    current_dir = os.path.dirname(__file__)
    project_root = os.path.abspath(os.path.join(current_dir, "..", "..", ".."))
    file_path = os.path.join(project_root, "configs")
    return file_path

def get_edi_configs(env):
    config_dir = get_path_config()
    file_path = os.path.join(config_dir, f"{env}.json")
    with open(file_path, "r") as config_file:
        config = json.load(config_file)
    return config