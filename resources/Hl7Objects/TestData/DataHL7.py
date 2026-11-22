import gspread as gs
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
import json
import re
from collections import defaultdict
from faker import Faker
from hl7apy.core import Message
from datetime import datetime

json_path = "D:\\Fusebox Automation Testing\\configs\\dev.json"

with open(json_path, "r", encoding="utf-8") as file:
    data = json.load(file) 
google_service_account = data.get("google", {})

def get_data_from_ggsheet(spreadsheet_key, worksheet_name, columns=None, index_colum=None):
    # Auth and fetch worksheet data
    scope = ['https://www.googleapis.com/auth/spreadsheets','https://www.googleapis.com/auth/drive']
    creds = ServiceAccountCredentials.from_json_keyfile_dict(google_service_account, scope)
    client = gs.authorize(creds)
    worksheet = client.open_by_key(spreadsheet_key).worksheet(worksheet_name)
    data = worksheet.get_all_values()
    df = pd.DataFrame(data[1:], columns=data[0])

    if index_colum:
        return df.set_index(index_colum)['Value'].to_dict()
    elif columns:
        return df[columns].to_dict(orient='records')
    else:
        return df.to_dict(orient='records')

def generate_json_data(key_object_values):
    """
    Generate a nested JSON structure from a dictionary of key-object values.

    Args:
        key_object_values (dict): A dictionary where keys are dot-separated paths (e.g., 'key1.key2[0].key3')
                                   and values are the corresponding values.

    Returns:
        dict: A nested JSON structure.
    """
    def process_key(current_dict, keys, value):
        """
        Process a single key and update the current dictionary.

        Args:
            current_dict (dict): The current level of the JSON structure.
            keys (list): A list of keys representing the path.
            value: The value to set at the final key.
        """
        for key in keys[:-1]:
            match = re.match(r'(\w+)\[(\d+)\]', key)
            if match:
                key_name, index = match.groups()
                index = int(index)

                if key_name not in current_dict:
                    current_dict[key_name] = []

                while len(current_dict[key_name]) <= index:
                    current_dict[key_name].append({})

                current_dict = current_dict[key_name][index]
            else:
                current_dict = current_dict.setdefault(key, {})

        # Handle the last key
        last_key = keys[-1]
        match = re.match(r'(\w+)\[(\d+)\]', last_key)
        if match:
            key_name, index = match.groups()
            index = int(index)

            if key_name not in current_dict:
                current_dict[key_name] = []

            while len(current_dict[key_name]) <= index:
                current_dict[key_name].append(None)

            current_dict[key_name][index] = value
        else:
            current_dict[last_key] = value

    # Main logic
    json_data = {}
    for key_object, value in key_object_values.items():
        if not key_object or value in [None, '']:
            continue

        keys = key_object.split('.')
        process_key(json_data, keys, value)

    return json_data

def save_json_to_file(json_data, file_name):
    with open(file_name, 'w', encoding='utf-8') as json_file:
        json.dump(json_data, json_file, ensure_ascii=False, indent=4)

def parse_hl7_message(hl7_message):
    """
    Parse an HL7 message string into a dictionary.
    Each segment type (e.g., 'PID') maps to a list of its fields.
    If multiple segments of the same type exist, they are stored as a list of lists.

    Args:
        hl7_message (str): The HL7 message string.

    Returns:
        dict: Parsed HL7 message.
    """
    segments = hl7_message.strip().split('\n')
    parsed_message = {}
    for segment in segments:
        fields = segment.split('|')
        segment_type = fields[0]
        # Support multiple segments of the same type
        if segment_type in parsed_message:
            if isinstance(parsed_message[segment_type], list) and isinstance(parsed_message[segment_type][0], list):    
                parsed_message[segment_type].append(fields[1:])
            else:
                parsed_message[segment_type] = [parsed_message[segment_type], fields[1:]]
        else:
            parsed_message[segment_type] = fields[1:]
    return parsed_message

def get_hl7_field_value(parsed_message, segment_type, field_index, segment_order=0):
    """
    Get the value of a field from a parsed HL7 message.

    Args:
        parsed_message (dict): Parsed HL7 message.
        segment_type (str): Segment type (e.g., 'PID').
        field_index (int): Index of the field (0-based).
        segment_order (int): Which segment to use if multiple exist (default 0).

    Returns:
        str or None: Field value or None if not found.
    """
    if segment_type in parsed_message:
        segment = parsed_message[segment_type]
        # Handle multiple segments of the same type
        if isinstance(segment, list) and isinstance(segment[0], list):
            if segment_order < len(segment):
                fields = segment[segment_order]
            else:
                return None
        else:
            fields = segment
        if field_index < len(fields):
            return fields[field_index]
    return None

def get_hl7_component_value(field_value, component_index):
    """
    Get the value of a component from a field value (split by '^').

    Args:
        field_value (str): The field value string.
        component_index (int): The index of the component (0-based).

    Returns:
        str or None: Component value or None if not found.
    """
    if not field_value:
        return None
    components = field_value.split('^')
    if component_index < len(components):
        return components[component_index]
    return None

def generate_hl7_msg(spreadsheet_key, worksheet_name, message_type, HL7OutboundStagingID=None):
    """
    Generate an HL7 message by combining static data from ggsheet and dynamic fake data.
    Args:
        spreadsheet_key (str): The key of the ggsheet.
        worksheet_name (str): The name of the worksheet to fetch data from.
        message_type (str): The type of message ('inbound' or 'outbound').
        HL7OutboundStagingID (str, optional): ID for outbound messages.

    Returns:
        str: The generated HL7 message in ER7 format.
    """
    if message_type not in ["inbound", "outbound"]:
        raise ValueError("message_type must be 'inbound' or 'outbound'")
    
    # Fetch data from ggsheet
    field_values = get_data_from_ggsheet(spreadsheet_key, worksheet_name, columns=["Element_Name", "Field_Name", "Value"])
    
    fake = Faker()
    msg = Message()
    currentDate = datetime.now().strftime('%Y%m%d%H%M%S')

    for item in field_values:
        element_name = item['Element_Name']
        name = item['Field_Name']
        value = item['Value']

        if element_name in ('Patient_Account_Number', 'Insurance_1_Plan_ID', 'Insurance_2_Plan_ID', 'Insurance_3_Plan_ID'):
            if element_name == 'Patient_Account_Number':
                value = fake.bothify(text='##########')
            else:
                value = fake.bothify(text='???-########')

        elif element_name in ('PlaceAppointmentID', 'Attending_Physician_NPI', 'Referring_Physician_NPI'):
            value = fake.bothify(text='##########')

        elif element_name in ('ProcessedDate', 'MessageControlID', 'Appointment_StartTime'):
            value = currentDate

        # elif element_name == 'MessageControlID' and message_type == 'outbound':
        #     if HL7OutboundStagingID:
        #         value = f"{HL7OutboundStagingID}{currentDate}"
        #     else:
        #         raise ValueError("HL7OutboundStagingID is required for outbound messages")
            
        # elif name == 'SCH-0-SCH_11-0-SCH_11_4-3' and message_type == 'outbound':
        #     value = datetime.strptime(value, '%Y-%m-%d %H:%M:%S').strftime('%Y%m%d%H%M%S')

        # Parse field name into components
        segment_name, segment_index, field_name, field_index, component_name, component_index = name.split('-')

        segment_list = getattr(msg, segment_name)
        segment_index_int = int(segment_index)
        while len(segment_list) <= segment_index_int:
            msg.add_segment(segment_name)
        segment = getattr(msg, segment_name)[segment_index_int]

        field_list = getattr(segment, field_name)
        field_index_int = int(field_index)
        while len(field_list) <= field_index_int:
            segment.add_field(field_name)
        field = getattr(segment, field_name)[field_index_int]
        
        order_children = getattr(field, 'ordered_children')        
        datatype = field.datatype

        if datatype == 'SI':
            value = int(segment_index) + 1

        if order_children is not None:
            try:
                component = getattr(field, order_children[int(component_index)])
            except (AttributeError, IndexError):
                # if order_children != None:
                component = field.add_component(order_children[int(component_index)])
                component = getattr(field, component)[int(component_index)]
        else:
            component = field.add_component(datatype)
            component = getattr(field, datatype)

        component.value = str(value)
        
    return msg.to_er7().replace('\r', '\n')
    

# json_data = generate_json_data(get_data_from_ggsheet("1cr3EC_muIIHvgQnbG1uj2jlMEiFEyYFwLl7Q-ne6P80", "ADT_Inbound", index_colum="Key_Object"))
# print(json.dumps(json_data, indent=4))

# key_object_values = get_data_from_ggsheet("1cr3EC_muIIHvgQnbG1uj2jlMEiFEyYFwLl7Q-ne6P80", "ADT_Inbound", columns=["Key_Object", "Value"])
# print(key_object_values)

# spreadsheet_key = "1cr3EC_muIIHvgQnbG1uj2jlMEiFEyYFwLl7Q-ne6P80"
# worksheet_name = "SIU_Inbound"  
# message_type = "inbound"

# hl7_message = generate_hl7_msg(spreadsheet_key, worksheet_name, message_type)
# print(hl7_message)

# PO_Dataa = generate_hl7_data("PO")
# print({PO_Dataa['drug']})
# print({PO_Dataa['referring'][0]})
