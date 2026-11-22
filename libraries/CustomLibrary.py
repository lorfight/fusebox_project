import regex
import datetime
import os
import inspect
import re
from datetime import datetime, timedelta

from pandas.compat import is_platform_linux
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.opera import OperaDriverManager
import chardet
import pytz
import pandas
from openpyxl import Workbook
from fpdf import FPDF
from robot.libraries.BuiltIn import BuiltIn
# import win32com.client

def get_webdriver_instance():
    return BuiltIn().get_library_instance('SeleniumLibrary').driver

def set_driver_timezone(driver,timezone):
    driver.execute_cdp_cmd('Emulation.setTimezoneOverride',timezone)
    
# from resources.PageObjects.TestData.Testdata import connect_gsheet
def lib_keyword(string):
    print(string)
    return string+"1"

dict_MSG = {"a1":"a",
"a2":"b",
}

def getTimeNow(time_zone='America/Chicago', result_format="%Y-%m-%d %H:%M:%S.%f"):
    if time_zone:
        tz = pytz.timezone(time_zone)
        date_Now = datetime.now(tz)
    else:
        date_Now = datetime.now()

    date_Now = date_Now.strftime(result_format)
    return date_Now

def getTimeZone(time_zone='America/Chicago', result_format="%I:%M %p"):
    if time_zone:
        tz = pytz.timezone(time_zone)
        time_now = datetime.now(tz)
    else:
        time_now = datetime.now()

    time_now = time_now.strftime(result_format)
    return time_now
    
def readTxt(str_Path):
    file = open(str_Path, encoding="utf8")
    data = file.read()
    return data

#write txt file
def writeTxt(str_Path, str_Data):
    file = open(str_Path, "w")
    file.write(str_Data)
    file.close()

def readMSG(i_File_Input):
    data_File_Input = readTxt(i_File_Input)
    list_data_Input = regex.split(r'\n',data_File_Input)
    dict_MSG = {}
    for i_data_Input in list_data_Input:
        print(i_data_Input)
        if i_data_Input == "":
            continue
        list_data_Segment = regex.split(r'\|',i_data_Input)
        if list_data_Segment[0] == 'MSH':
            list_data_Segment.insert(0,'MSH')
        count_Name_Segment = len(regex.findall(list_data_Segment[0],str(dict_MSG.keys())))+1
        dict_MSG[list_data_Segment[0]+"-"+str(count_Name_Segment)] = list_data_Segment
    return dict_MSG

def getSubField(str_Input,index_Input):
    index_Input = int(index_Input)
    if str_Input != "":
        if "~" in str_Input:
            str_Result = regex.split(r'\~',str_Input)[0]
            if "^" in str_Result:
                list_Result = regex.split(r'\^',str_Result)
                if len(list_Result) > index_Input-1:
                    return list_Result[index_Input-1]
                else:
                    return ""
            else:
                list_Result = regex.split(r'\^',str_Result)
                if len(list_Result) > index_Input-1:
                    return str_Result
                else:
                    return ""
        else:
            if "^" in str_Input:
                list_Result = regex.split(r'\^',str_Input)
                if len(list_Result) > index_Input-1:
                    return list_Result[index_Input-1]
                else:
                    return ""
            else:
                list_Result = regex.split(r'\^',str_Input)
                if len(list_Result) > index_Input-1:
                    return str_Input
                else:
                    return ""
    

    else:
        return ""

def create_excel_file(filepath, data):
    wb = Workbook()
    ws = wb.active
    for row in data:
        ws.append(row)
    wb.save(filepath)

def get_path():
    path_CurDir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
    return  path_CurDir


def parse_ean128(barcode):
    str_Code_item = re.findall(r'(?<=^01)\d{14}',barcode)[0]
    str_Date_expirate = re.findall(r'(?<=17)\d{6}',barcode)[-1]
    str_Lot = re.findall(r'(?<=17\d{6}10).*(?=\|)|(?<=17\d{6}10).*|(?<=\|10).*(?=\|)|(?<=\|10).*$',barcode)[-1]
    return {'01':str_Code_item,'17':str_Date_expirate, '10':str_Lot}

def parse_barcode(barcode):
    str_Code_item = re.findall(r'(?<=^01)\d{14}',barcode)[0]
    str_Date_expirate = re.findall(r'(?<=17)\d{6}',barcode)[-1]
    str_Lot = re.findall(r'(?<=17\d{6}10).*(?=\|)|(?<=17\d{6}10).*|(?<=\|10).*(?=\|)|(?<=\|10).*$',barcode)[-1]
    return {'exp_date':str_Date_expirate, 'lot':str_Lot}

barcode1 = "01003494011010161723040010KH5A|2155VWN45D·Đ0"

def process_item_number(item_number: str):
    item_list = []
    if item_number[3] in ['0', '8']:
        item_list.append('0'+item_number[3:7])
        item_list.append(item_number[7:11])
        item_list.append(item_number[11:13])
    else:
        item_list.append(item_number[3:8])
        if (item_number[8] == "0" and item_number[9] == "0" and item_number[10] != "8") or (item_number[8] == "8" and item_number[10] != "0"):
            item_list.append(item_number[8:12])
            item_list.append('0'+item_number[12:13])
        else:
            item_list.append('0'+item_number[8:11])
            item_list.append(item_number[11:13])
    print("-".join(item_list))
    return "-".join(item_list)

list_barcode = ['01003031017303032108400466291404|1725063010TB0015', '01003031017303032103955221124050|1725063010TB0015', '01003031017303032107882108800171|1725063010TB0015', '01003031017303032102289848041538|1725063010TB0015', '01003031017303032103615916680994|1725063010TB0015', '01003031017303032108661774744072|1725063010TB0015', '01003031017303032100515694754076|1725063010TB0015', '01003031017303032100762023602076|1725063010TB0015', '01003031017303032100215713727137|1725063010TB0015', '010035846800411621122128TC3N7RAG|1722083110BY0238', '010035846800411621122128TC3MYD1A|1722083110BY0238', '0100358468004017211221298W3EFD80|1722073110BY0206', '0100358468004017211221298W0NKCV5|1722073110BY0206', '010037598708010021247650174737|17220204109265A', '010037598708010021224620942568|17220204109265A', '010036332371050721100000820946|17211130106123060', '010036332371050721100000820928|17211130106123060', '010037127435002421158120048071|10M1911-01|17231031', '010037127435002421201911035756|10M1911-01|17231031', '010037127435002421214845891413|10M1911-01|17231031', '0100368982840046213943651369038|1721060110M922B8441', '0100368982850038213593679665892|1721101510M942B8541', '010036420882357221264397060474|10GSB19376|17221029', '010036420882357221101072536791|10GSB19376|17221029', '010036420882357221153269733217|10GSB19376|17221029', '01003094427000741722090421000004473387|10LE12V203AB', '01003094427000741722090421000004473383|10LE12V203AB', '01003094427000741722090421000004473392|10LE12V203AB', '0100368982850045213621388840513|1721102810K944A8561', '0100368982850045213621381606610|1721102810K944A8561', '01003064103762552110036429834777|1721043010049343', '010036440600801621236904528219|1722113010PC0131', '01003494011010161723040010KH5A|215X5R8R45PN', '01003494011010161723040010KH5A|2155VWN45D·Đ0', '01003494011010161723040010KH5A|215NCK7T5FZN', '010035789403001021100032243955|172211301019MD54291', '010035789403001021100032243954|172211301019MD54291', '010035789403001021100032243957|172211301019MD54291', '010035789403001021100032243950|172211301019MD54291', '010035789403001021100032243900|172211301019MD54291', '010035789403001021100032243949|172211301019MD54291', '010035789403001021100032243956|172211301019MD54291', '010035789403001021100032243952|172211301019MD54291', '010035789403001021100032243951|172211301019MD54291', '010035789403001021100032243958|172211301019MD54291', '010030069080901421976487352362|1725033110FD1726', '010030069080901421928659169864|1725053110EY1084', '010030069080901421824563097379|1725033110FD1726', '010030069080901421617257441979|1725033110FD1726', '010030069080901421981151825487|1725033110FD1726', '010030069080901421327065937032|1725033110FD1726', '010030069080901421934264842628|1725033110FD1726', '010030069080901421233911954164|1725033110FD1726', '010030069080901421959967895443|1725022810EY1079', '010030069080901421184687857908|1725053110EY1084', '010030069080901421925648754164|1725033110FD1726', '010030069080901421763868762817|1725033110FD1726', '010030069080901421705888222426|1725033110FD1726', '010030069080901421737549881881|1724123110EL6030', '010030069080901421928457520744|1725022810EY1079', '010030069080901421809851126691|1725053110EY1084', '010030069080901421480961378228|1725022810EY1079', '010030069080901421768413618011|1725033110FD1726', '010030069080901421625287076859|1725033110FD1726', '010030069080901421440249964388|1725033110FD1726', '010030069080901421209996850255|1725033110FD1726', '010030069080901421977872113044|1725022810EY1079', '010030069080901421436530333351|1725033110FD1726', '010030069080901421531240959435|1725033110FD1726', '010030069080901421735456247144|1725033110FD1726', '010030069080901421818154450413|1725033110FD1726', '010030069080901421117408683997|1725033110FD1726', '010030003218713821100004517722|10ABW3082|17240331', '010030003218713821100004517727|10ABW3082|17240331', '010030003218713821100004560995|10ABX4547|17240331', '010030003218713821100004560996|10ABX4547|17240331', '010030003218713821100004517724|10ABW3082|17240331', '010030003218713821100004517721|10ABW3082|17240331', '010030003218713821100004517728|10ABW3082|17240331', '010030003218713821100004561001|10ABX4547|17240331', '010030003218713821100004560993|10ABX4547|17240331', '010030003218713821100004560997|10ABX4547|17240331', '010030003218713821100004560992|10ABX4547|17240331', '010030003218713821100004560235|10ABX4547|17240331', '010035789435001921183075738705|1722113010JLS0910', '010035789435001921196877388353|1722113010JLS0910', '010035789435001921105277985951|1722113010JLS0910', '010035789435001921158002029112|1722113010JLS0910']

import  pandas as pd

# Initialize a dictionary to count the occurrences
def parse_barcode_scanned(bar_codes: list):
    count_dict = {}
    for a in bar_codes:
        result = parse_ean128(a)  # Replace with your barcode parsing logic
        if '01' in result and '10' in result and '17' in result:
            gtin = process_item_number(result['01'])
            date_string = result['17']
            expire_date = datetime.strptime(date_string[2:4] + "/" + ("01" if date_string[4:6] == "00" else date_string[4:6]) + "/" + date_string[0:2], "%m/%d/%y")
            if expire_date and date_string[4:6] == "00":
                expire_date = expire_date.replace(day=28) + timedelta(days=4)
                expire_date = expire_date - timedelta(days=expire_date.day)
            # Format the parsed time as '3/31/2024'
            formatted_time = expire_date.strftime('%m/%d/%Y')

            key = (gtin,result['10'], formatted_time)
            count_dict[key] = count_dict.get(key, 0) + 1
    return dict(sorted(count_dict.items()))

# print(parse_barcode_scanned(list_barcode))

def get_data_from_html_table(html_content: str, dict_actual_qty_on_hand: dict):
    count_dict = {}
    result = read_table_from_html(html_content)
    for row in result:
        print(row)
        if("Add" in str(row["Line #"]).split(" ")):
            Line = row["Line #"].split(" ")[0]
            NDC = row["Item"].split(" ")[1]
            EXP = datetime.strptime(re.findall(r"(?<=Exp:\s)(\d{1,2}/\d{1,2}/\d{4})(?=\s])",row["Lot # / Exp"])[0],'%m/%d/%Y')
            LOT = row["Lot # / Exp"].split(" ")[0]
            # count = int(row['Expected Qty On Hand  Expected Qty']) + int("".join(row['Discrepancy'].split()))
            if dict_actual_qty_on_hand['ReconcileLine_'+Line] != '':
                count = int(dict_actual_qty_on_hand['ReconcileLine_'+Line])
            else:
                count = 0
            key = (NDC,LOT, EXP.strftime('%m/%d/%Y'))
            count_dict[key] = int(count)
    return dict(sorted(count_dict.items()))

def get_ndc_from_html_table(html_content: str, screen: str):
    list_ndc = []
    result = read_table_from_html(html_content)
    for row in result:
        match screen:
            case "reconciled_table":
                if("Add" in str(row["Line #"]).split(" ")):
                    NDC = row["Item"].split(" ")[1]
                    list_ndc.append(NDC)
            case "serialized_table":
                NDC = row["NDC"]
                list_ndc.append(NDC)   
    return set(list_ndc)


def read_table_from_html(html_content):
    table_df = pd.read_html(html_content)[0]
    return table_df.to_dict(orient='records')

from bs4 import BeautifulSoup
def get_max_page_size(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    page_links = soup.find_all('a', {'data-pageno': True})
    # Extract maximum page number
    max_page = max(int(link['data-pageno']) for link in page_links)
    return int(max_page)

def get_transaction_inventory_level(html_content, list_properties):
    inventory_transaction_col = {}
    soup = BeautifulSoup(html_content, 'html.parser')
    cols = soup.find_all('div')
    property_indices = {
        'Type': 1,
        'Created_By': 2,
        'Timestamp': 3,
        'Description': 4,
        'Adjustment': 5,
        'Price': 6,
        'Lot_No': 7,
        'Expiration': 8
    }
    for property_name in list_properties:
        if property_name in property_indices:
            index = property_indices[property_name]
            text = cols[index].get_text()
            
            if property_name == 'Adjustment':
                inventory_transaction_col[property_name] = int(float(text))
            else:
                inventory_transaction_col[property_name] = text
    return inventory_transaction_col

def get_last_reconcile_inventory(data):
    # Find the index of the first dictionary with Type 'Inventory Reconcile'
    target_index = None
    for i, entry in enumerate(data[2:], start=2):
        if entry.get('Type') == 'Inventory Reconcile':
            target_index = i
            break
    if target_index is not None and target_index > 1:
        return data[:target_index]
    return []


def get_chromedriver_path(type_browser="Chrome"):

    if is_platform_linux():
        linux_chrome_driver_path ="/usr/bin/chromedriver"
        return linux_chrome_driver_path

    if type_browser == "Chrome" or type_browser == "headlesschrome" or type_browser == "headlessChrome" or type_browser == "chrome":
        driver_path = ChromeDriverManager().install()
        driver_path = re.sub(r'THIRD_PARTY_NOTICES.chromedriver', 'chromedriver.exe', driver_path)
        
    elif type_browser == "Edge":
        driver_path = webdriver.Edge(EdgeChromiumDriverManager().install())
    elif type_browser == "Firefox":
        driver_path = webdriver.Firefox(executable_path=GeckoDriverManager().install())
    else:
        driver_path = ChromeDriverManager().install()
    print(driver_path)

    return  driver_path

from enum import Enum
def sort_serialize_item_by(member):
    return sortSerializedItemsBy[member].value


class sortSerializedItemsBy(Enum):
    Item_No = 0
    Pricing = 1

def read_file_csv(csv_path):
    df = pd.read_csv(csv_path)
    list_item = df.to_dict(orient='records')
    return list_item

import pandas as pd

def convert_file_csv_inventory_report(filename):
    list_item= read_file_csv(filename)
    data = []
    for item in list_item:
        data.append({csv_inventory_report[key]: value for key, value in item.items()})
    data = map(lambda e: 
            { 
            "NDC": str(e['NDC']),
            "Origin":str(e["Origin"]),
            "Lot #":str(e["Lot #"]),
            "Total Value":str(e["Total Value"]),
            "Deviation":float(e["Deviation"]),
            "Par-Level":float(e["Par-Level"]),
            "Qty":float(e["Qty"]),
            "Storage Location":str(e["Storage Location"]),
            "Unit Of Measure":str(e["Unit Of Measure"]),
            }
            , data)
    return list(data)

csv_inventory_report = {
    "textBox18":"TextBox18",
    "textBox19":"TextBox19",
    "textBox21":"TextBox21",
    "textBox22":"TextBox22",
    "textBox23":"TextBox23",
    "textBox7":"TextBox7",
    "textBox6":"TextBox6",
    "textBox9":"TextBox9",
    "textBox8": "NDC",
    "textBox13": "Origin",
    "textBox29": "Lot #",
    "textBox20": "Total Value",
    "textBox24": "Deviation",
    "textBox26": "Par-Level",
    "textBox28": "Qty",
    "textBox25": "Storage Location",
    "textBox27": "Unit Of Measure"
}

# declare dict for csv_complete_log
csv_complete_log = {
    "textBox23": "Inventory Name",
    "textBox6": "Line #",
    "textBox28": "Item",
    "textBox27": "NDC",
    "textBox16": "Lot # / Exp",
    "textBox26": "Last Qty On Hand  Last Qty",
    "textBox13": "Received",
    "textBox11": "Dispensed",
    "textBox25": "Other Changes",
    "textBox10": "Expected Qty On Hand  Expected Qty",
    "textBox8": "Actual Qty On Hand  Actual Qty",
    "textBox7": "Discrepancy"
}

def convert_file_csv_complete_log(filename):
    list_item= read_file_csv(filename)
    data = []
    for item in list_item:
        data.append({csv_complete_log[key]: value for key, value in item.items()})
    data = map(lambda e: 
            { 
            "Line #": str(e['Line #']),
            "NDC":str(e["NDC"]),
            "Last Qty On Hand  Last Qty":float(e["Last Qty On Hand  Last Qty"]),
            "Received":float(e["Received"]),
            "Dispensed":float(e["Dispensed"]),
            "Other Changes":float(e["Other Changes"]),
            "Expected Qty On Hand  Expected Qty":float(e["Expected Qty On Hand  Expected Qty"]),
            "Actual Qty On Hand  Actual Qty":float(e["Actual Qty On Hand  Actual Qty"]),
            }
            , data)
    return list(data)

def get_data_from_html_table_reconciled(html_content: str):
    list_reconcile = []
    result = read_table_from_html(html_content)
    for item_reconcile in result:
        if("Item" in str(item_reconcile["Item"]).split(":")):
            item_reconcile_converted = {
                "Line #": item_reconcile['Line #'],
                # "Item":item_reconcile["Item"],
                "NDC":item_reconcile["NDC"].replace(" Uom:","-"),
                "Last Qty On Hand  Last Qty":float(item_reconcile["Last Qty On Hand  Last Qty"]),
                "Received":float(item_reconcile["Received"]),
                "Dispensed":float(item_reconcile["Dispensed"]),
                "Other Changes":float(item_reconcile["Other Changes"]),
                "Expected Qty On Hand  Expected Qty":float(item_reconcile["Expected Qty On Hand  Expected Qty"]),
                "Actual Qty On Hand  Actual Qty":float(item_reconcile["Actual Qty On Hand  Actual Qty"].split()[0]),
                # "Discrepancy":str(item_reconcile["Discrepancy"]),
            }
            list_reconcile.append(item_reconcile_converted)
    return list_reconcile
def get_data_from_html_table_reconciled_test(html_content: str):
    list_reconcile = []
    result = read_table_from_html(html_content)
    for item_reconcile in result:
        if("Item" in str(item_reconcile["Item"]).split(":")):
            item_reconcile_converted = {
                "Dispensed":int(item_reconcile["Dispensed"]),
                "Received":int(item_reconcile["Received"]),
                "Other Changes":int(item_reconcile["Other Changes"]),
                "Expected Qty On Hand": int(item_reconcile["Expected Qty On Hand  Expected Qty"]),
                "Last Qty On Hand": int(item_reconcile["Last Qty On Hand  Last Qty"])
            }
            list_reconcile.append(item_reconcile_converted)
    return list_reconcile[0]

from tabula import read_pdf
def read_file_pdf(pdf_path):
    dfs = read_pdf(pdf_path,pages='all', stream=True)
    return dfs

import json
def get_chrome_option():

    appState = {
        "recentDestinations": [
            {
                "id": "Save as PDF",
                "origin": "local"
            }
        ],
        "selectedDestinationId": "Save as PDF",
        "version": 2
    }
    return json.dumps(appState)

def is_linux_platform():
    return is_platform_linux()

def get_file_report_Name(report_type):
    return File_Report_Name["_".join(report_type.split(' '))].value
    
class File_Report_Name(Enum):
    Grams_On_Hand = 'GramsOnHandToPDF.pdf'
    Print_Inventory = 'ManualInventoryCheckToPDF.pdf'
    Inventory_In_Transit = 'InventoryInTransitToPDF.pdf'
    Print_Detailed_Inventory= 'InventoryDetailCheck.csv'
    Inventory_Transaction_Report= 'InventoryDetailCheck.csv'
    Inventory_History_Report= 'InventoryDetailCheck.csv'

    
# --- HÀM HỖ TRỢ ---
def read_json(str_Path):
    with open(str_Path, 'rb') as data_file:
        raw = data_file.read(32) # at most 32 bytes are returned
        encoding = chardet.detect(raw)['encoding']
    with open(str_Path, encoding=encoding) as data_file:
        data = json.loads(data_file.read())
    return data

def write_json(dic_Data, str_Path = "file.txt"):
    # Serializing json
    json_object = json.dumps(dic_Data, indent=4)
    
    # Writing to sample.json
    with open(str_Path, "w") as outfile:
        outfile.write(json_object)


# read file environment.properties and edit value
def read_file_properties(file_path):
    with open(file_path, 'r') as file:
        data = file.readlines()
    return data

def edit_file_properties(file_path, key, value):
    data = read_file_properties(file_path)
    for i in range(len(data)):
        if key in data[i]:
            data[i] = key + "=" + value + "\n"
    with open(file_path, 'w') as file:
        file.writelines(data)

# def update_user_gs(env,user_name,pwd):
#     client = connect_gsheet()
#     worksheet = client.open('data_test').worksheet(f"user {env}")
#     index_cell_available= len(worksheet.get_all_records())+2
#     worksheet.update([[user_name,pwd]],f"A{index_cell_available}:B{index_cell_available}")

def readExcelFile(path,header=0):
    df = pandas.read_excel(path,header=header)
    return  df

def saveExcelFile(path, df):
    df.to_excel(path,index=False)
    return df

def editExcelField(df, field, value):
    df.loc[0,field] = value
    return  df

def convert_price_string_to_float(value: str) -> float:
    is_negative = '(' in value and ')' in value  # Check for accounting-style negative
    cleaned = ''.join(char for char in value if char.isdigit() or char in [',', '.'])
    normalized = cleaned.replace(',', '')
    result = float(normalized)
    if is_negative:
        result = -result
    return result

def edit_excel_field_and_save(data, row, field, value, path, sub_field=None):
    keys = data.keys()
    for key in keys:
        if field in key:
            if sub_field == None:
                break
            else:
                if sub_field in key:
                    break
    data.loc[row,key] = value
    data.to_excel(path,index=False)
    return  data

def get_excel_field(data, field, field_value=None, field_reference=None, row=None, sub_field=None, sub_field_reference=None):
    keys = data.keys()
    for key in keys:
        if field in key:
            if sub_field == None:
                break
            else:
                if sub_field in key:
                    break
    if row != None:
        row = int(row)
        value = data.loc[row,key]
    else:
        for row in range(data.shape[0]):
            if data.loc[row,key] == field_value:
                break
        for key in keys:
            if field_reference in key:
                if sub_field_reference == None:
                    break
                else:
                    if sub_field_reference in key:
                        break
        value = data.loc[row,key]
    assert  data.loc[row,key] == field_value, "field not found"
    return  value

def get_excel_field_no_header(data,row,col):
    row = int(row)
    col = int(col)
    val = data.iloc[row,col]
    return  val

def create_pdf(filename, text):
    path = os.path.abspath(os.path.join(os.getcwd(), filename))
    pdf=FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    pdf.cell(0, 10 ,txt=text, ln=True)
    pdf.output(path)
    return path

from openpyxl import load_workbook
from openpyxl.utils import get_column_letter

def safe_rgb(color):
    try:
        if not color:
            return None
        if hasattr(color, "type") and color.type == "rgb":
            return color.rgb
        return None
    except:
        return None

def get_excel_data(
        path,
        *filters,
        cells=None,
        format=False,
        sheet_name=None):

    path = path.strip()

    if not os.path.exists(path):
        raise Exception(f"File not found: {path}")
    if cells and filters:
        raise Exception(
            "Cannot use both 'cells' and filters together."
        )
    wb = load_workbook(
        filename=path,
        data_only=False
    )
    ws = wb[sheet_name] if sheet_name else wb.active

    if cells:
        if isinstance(cells, str):
            cells = cells.split()
        elif isinstance(cells, tuple):
            cells = list(cells)
        result = {}
        for cell in cells:
            c = ws[cell]
            value = c.value
            if isinstance(value, (datetime, pd.Timestamp)):
                value = value.strftime("%m/%d/%Y")
            if not format:
                result[cell] = value
            else:
                result[cell] = {
                    "value": value,
                    "font_name": c.font.name,
                    "font_size": c.font.sz,
                    "bold": c.font.bold,
                    "italic": c.font.italic,
                    "font_color": (
                        c.font.color.rgb
                        if c.font.color
                        and hasattr(c.font.color, "type")
                        and c.font.color.type == "rgb"
                        else None
                    ),
                    "fill_type": c.fill.fill_type,
                    "fill_color": (
                        c.fill.fgColor.rgb
                        if hasattr(c.fill.fgColor, "rgb")
                        else None
                    ),
                    "horizontal": c.alignment.horizontal,
                    "vertical": c.alignment.vertical,
                    "wrap_text": c.alignment.wrap_text,
                    "data_type": type(c.value).__name__,
                    "border_left_style": c.border.left.style,
                    "border_left_color": (
                        c.border.left.color.rgb
                        if c.border.left.color
                        and hasattr(c.border.left.color, "type")
                        and c.border.left.color.type == "rgb"
                        else None
                    ),
                    "border_right_style": c.border.right.style,
                    "border_right_color": (
                        c.border.right.color.rgb
                        if c.border.right.color
                        and hasattr(c.border.right.color, "type")
                        and c.border.right.color.type == "rgb"
                        else None
                    ),
                    "border_top_style": c.border.top.style,
                    "border_top_color": (
                        c.border.top.color.rgb
                        if c.border.top.color
                        and hasattr(c.border.top.color, "type")
                        and c.border.top.color.type == "rgb"
                        else None
                    ),
                    "border_bottom_style": c.border.bottom.style,
                    "border_bottom_color": (
                        c.border.bottom.color.rgb
                        if c.border.bottom.color
                        and hasattr(c.border.bottom.color, "type")
                        and c.border.bottom.color.type == "rgb"
                        else None
                    ),
                    "diagonal_up": c.border.diagonalUp,
                    "diagonal_down": c.border.diagonalDown,
                }
        return result
    pandas_sheet = sheet_name if sheet_name else 0
    df = pd.read_excel(path, sheet_name=pandas_sheet, header=10)
    df["excel_row"] = df.index + 12
    for filter_item in filters:
        column, value = filter_item.split("=", 1)
        column = column.strip()
        value = value.strip()
        if column not in df.columns:
            raise Exception(
                f"Column '{column}' not found."
            )
        df = df[
            df[column]
            .astype(str)
            .str.strip()
            .str.lower()
            == value.lower()
        ]
    if not format:
        result = (
            df
            .drop(columns=["excel_row"])
            .to_dict("records")
        )
        for row in result:
            for key, value in row.items():
                if isinstance(
                    value,
                    (datetime, pd.Timestamp)
                ):
                    row[key] = value.strftime(
                        "%m/%d/%Y"
                    )
        return result
    result = []
    excel_columns = [
        col
        for col in df.columns
        if col != "excel_row"
    ]
    for _, row in df.iterrows():
        excel_row = int(row["excel_row"])
        row_result = {}
        for col_idx, column_name in enumerate(
                excel_columns,
                start=1):
            cell_ref = (
                f"{get_column_letter(col_idx)}"
                f"{excel_row}"
            )
            c = ws[cell_ref]
            value = row[column_name]
            if isinstance(
                value,
                (datetime, pd.Timestamp)
            ):
                value = value.strftime(
                    "%m/%d/%Y"
                )
            row_result[column_name] = {
                "value": value,
                "font_name": c.font.name,
                "font_size": c.font.sz,
                "bold": c.font.bold,
                "italic": c.font.italic,
                "font_color": (
                    c.font.color.rgb
                    if c.font.color
                    and hasattr(c.font.color, "type")
                    and c.font.color.type == "rgb"
                    else None
                ),
                "fill_type": c.fill.fill_type,
                "fill_color": (
                    c.fill.fgColor.rgb
                    if hasattr(c.fill.fgColor, "rgb")
                    else None
                ),
                "horizontal": c.alignment.horizontal,
                "vertical": c.alignment.vertical,
                "wrap_text": c.alignment.wrap_text,
            }
        result.append(row_result)
    return result

def get_freeze_panes(path, sheet_name=None):
    path = path.strip()
    if not os.path.exists(path):
        raise Exception(f"File not found: {path}")
    wb = load_workbook(
        filename=path,
        data_only=False
    )
    ws = wb[sheet_name] if sheet_name else wb.active
    return (
        str(ws.freeze_panes)
        if ws.freeze_panes
        else None
    )


def excel_color_to_hex(color):
    try:
        color = int(float(color))
    except Exception:
        return None

    red = color & 255
    green = (color >> 8) & 255
    blue = (color >> 16) & 255

    return f"#{red:02X}{green:02X}{blue:02X}"

# def get_excel_display_format(path,*filters,sheet_name=None):
#     path = path.strip()
#     if not os.path.exists(path):
#         raise Exception(f"File not found: {path}")
#     pandas_sheet = sheet_name if sheet_name else 0
#     df = pd.read_excel(path,sheet_name=pandas_sheet,header=10)
#     df["excel_row"] = df.index + 12
#     for filter_item in filters:
#         column, value = filter_item.split("=", 1)
#         column = column.strip()
#         value = value.strip()
#         if column not in df.columns:
#             raise Exception(
#                 f"Column '{column}' not found."
#             )

#         df = df[
#             df[column]
#             .fillna("")
#             .astype(str)
#             .str.strip()
#             .str.lower()
#             == value.lower()
#         ]
#     if len(df) == 0:
#         raise Exception("No matching row found.")
#     if len(df) > 1:
#         raise Exception(
#             f"Found {len(df)} matching rows."
#         )
#     excel_row = int(df.iloc[0]["excel_row"])
#     excel = win32com.client.gencache.EnsureDispatch("Excel.Application")
#     wb = excel.Workbooks.Open(path)
#     try:
#         ws = (
#             wb.Worksheets(sheet_name)
#             if sheet_name
#             else wb.ActiveSheet
#         )
#         result = {}
#         excel_columns = [
#             col
#             for col in df.columns
#             if col != "excel_row"
#         ]
#         for col_idx, column_name in enumerate(
#                 excel_columns,
#                 start=1):
#             cell = ws.Cells(excel_row, col_idx)
#             result[column_name] = {
#                 "cell": cell.Address,
#                 "value": cell.Value,
#                 "fill_color":
#                     excel_color_to_hex(cell.DisplayFormat.Interior.Color),
#                 "font_color":
#                     excel_color_to_hex(cell.DisplayFormat.Font.Color),
#                 "bold":
#                     bool(cell.DisplayFormat.Font.Bold),
#                 "italic":
#                     bool(cell.DisplayFormat.Font.Italic )
#             }
#         return result
#     finally:
#         wb.Close(False)
#         excel.Quit()