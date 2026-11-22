import gspread
from google.oauth2 import service_account
from datetime import datetime
from decimal import Decimal
import edi_curascript_create_855_856_810
import os
import json
import sys

folder_path = os.path.abspath(os.path.join(os.path.dirname(__file__), ".." ".." , "EdiObjects", "TestData"))
sys.path.append(folder_path)
import EdiTestdata

def validate_type(data, vtype):
    if vtype == '':
        return True
    if vtype == 'Numeric':
        data_str = str(data)
        return data_str.isdigit()
    elif vtype == 'Identifier':
        return data.isalnum()
    elif vtype == 'String':
        return isinstance(data, str)
    elif vtype == 'Date':
        for fmt in ('%Y%m%d', '%y%m%d'):
            try:
                datetime.strptime(data, fmt)
                return True
            except ValueError:
                continue
        return False
    elif vtype == 'Time':
        for fmt in ('%H%M', '%H%M%S'):
            try:
                datetime.strptime(data, fmt)
                return True
            except ValueError:
                continue
        return False
    elif vtype == 'Decimal number':
        try:
            Decimal(data)
            return True
        except (ValueError, TypeError):
            return False
    elif vtype == 'N2':
        return data.isdigit()
    return False

def validate_length(data, min_length=None, max_length=None):
    data_length = len(data)
    if min_length is not None and isinstance(min_length, int):
        if data_length < min_length:
            return False
    if max_length is not None and isinstance(max_length, int):
        if data_length > max_length:
            return False
    return True

def process_segments(edi_data, is_850):
    edi_data = edi_data.strip()
    segments = edi_data.split('~')
    segment_info = {}
    
    for segment in segments:
        segment = segment.strip()
        segment = segment.replace('\n', '')
        if segment:
            fields = segment.split('*')
            segment_type = fields[0]

            if segment_type not in segment_info:
                segment_info[segment_type] = []

            field_data = {}

            for i, field in enumerate(fields):
                key = f"{segment_type}{i:02d}"
                field_data[key] = field
            segment_info[segment_type].append(field_data)

    return segment_info

def extract_keys(segment_info):
    keys = []
    for segment_type, entries in segment_info.items():
        for entry in entries:
            keys.extend(entry.keys())
    return keys

def validate_data(data, segment_info):
    keys_in_segment = extract_keys(segment_info)
    errors = []

    for item in data:
        key = item['Key']
        if key not in keys_in_segment:
            continue

        for segment_type, entries in segment_info.items():
            for entry in entries:
                if key in entry:
                    value = entry[key]
                    vtype = item['Type']
                    vmin = item['Min']
                    vmax = item['Max']
                    vrequired = item['Requirement']

                    if vrequired == "TRUE" and value == "":
                        errors.append(f"Validation failed for key: {key}, no value provided but required")

                    if value:
                        # print(f"Validating key: {key}, value: {value}, type: {vtype}")
                        if not validate_type(value, vtype):
                            errors.append(f"Value for {key} is not of type {vtype}")

                        if not validate_length(value, vmin, vmax):
                            errors.append(f"Length of value for {key} is not within the range {vmin}-{vmax}")
    if errors:
        print("Errors List:")
        for error in errors:
            print(error)
        return False
    else:
        print("All values are valid")
        return True

def connect_gsheet(env):
    edi_config = EdiTestdata.get_edi_configs(env)
    google_config = edi_config.get("google", {})
    scopes = [
        'https://www.googleapis.com/auth/spreadsheets',
        'https://www.googleapis.com/auth/drive'
    ]

    creds = service_account.Credentials.from_service_account_info(google_config, scopes=scopes)

    client = gspread.authorize(creds)
    return client

def get_sheet_data(client, spreadsheet_key, sheet_name):
    workbook = client.open_by_key(spreadsheet_key)
    sheet = workbook.worksheet(sheet_name)
    return sheet.get_all_records()

def validate_field(client, file_path, spreadsheet_key, sheet_name, is_850=False):
    data = get_sheet_data(client, spreadsheet_key, sheet_name)

    edi_data = edi_curascript_create_855_856_810.read_edi_file(file_path)
    segment_info = process_segments(edi_data, is_850)
    
    return validate_data(data, segment_info)

def validate_field_850(file_path, env):
    client = connect_gsheet(env)
    edi_config = EdiTestdata.get_edi_configs(env)
    spreadsheet_key = edi_config.get("edi", {}).get("spreadsheet_key", "")
    sheet_850 = edi_config.get("edi", {}).get("sheet_850", "")
    return validate_field(client, file_path, spreadsheet_key, sheet_850, is_850=True)

def validate_field_855(file_path, env):
    client = connect_gsheet(env)
    edi_config = EdiTestdata.get_edi_configs(env)
    spreadsheet_key = edi_config.get("edi", {}).get("spreadsheet_key", "")
    sheet_855 = edi_config.get("edi", {}).get("sheet_855", "")
    return validate_field(client, file_path, spreadsheet_key, sheet_855, is_850=False)

def validate_field_856(file_path, env):
    client = connect_gsheet(env)
    edi_config = EdiTestdata.get_edi_configs(env)
    spreadsheet_key = edi_config.get("edi", {}).get("spreadsheet_key", "")
    sheet_856 = edi_config.get("edi", {}).get("sheet_856", "")
    return validate_field(client, file_path, spreadsheet_key, sheet_856, is_850=False)

def validate_field_810(file_path, env):
    client = connect_gsheet(env)
    edi_config = EdiTestdata.get_edi_configs(env)
    spreadsheet_key = edi_config.get("edi", {}).get("spreadsheet_key", "")
    sheet_810 = edi_config.get("edi", {}).get("sheet_810", "")
    return validate_field(client, file_path, spreadsheet_key, sheet_810, is_850=False)

def get_message_ggsheet(env, row_key, column_key):
    client = connect_gsheet(env)
    edi_config = EdiTestdata.get_edi_configs(env)
    spreadsheet_key = edi_config.get("edi", {}).get("spreadsheet_key", "")
    sheet_name = edi_config.get("edi", {}).get("message_unhappycase", "")

    sheet = client.open_by_key(spreadsheet_key).worksheet(sheet_name)
    data = sheet.get_all_values()

    header_row = data[0]
    column_index = -1
    for idx, value in enumerate(header_row):
        if value.strip().lower() == column_key.strip().lower():
            column_index = idx
            break

    if column_index == -1:
        raise ValueError(f"Column not found '{column_key}'.")

    row_index = -1
    for idx, row in enumerate(data):
        if len(row) > 0 and row[0].strip() == str(row_key):
            row_index = idx
            break

    if row_index == -1:
        raise ValueError(f"Row not found '{row_key}'.")

    try:
        return data[row_index][column_index]
    except IndexError:
        return ""