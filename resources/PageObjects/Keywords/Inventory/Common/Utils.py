BARCODES_TRANSFER = ['01003031017303032108400466291424|1727063010TB0015','01003031017303032108400466291427|1727063010TB0015','01003031017303032108400466291428|1727063010TB0015','01003031017303032108400466291436|1727063010TB0015','01003031017303032108400466291437|1727063010TB0015','01003031017303032108400466291438|1727063010TB0015']

from bs4 import BeautifulSoup
import pandas as pd
import re
import math
from datetime import datetime


def get_data_in_html_table_in_reconcile_screen(html_content: str):
    list_ndc_reconcile = []
    list_item_reconcile = []
    html_content_soup = BeautifulSoup(html_content, "lxml")
    for input_id in html_content_soup.find_all("input", id=True):
        if "ReconcileLine_" in input_id["id"]:
            input_id.replace_with(input_id.get("value", ""))
    for input_class in html_content_soup.find_all("input", class_=["FooterCountedQty"]):
        value = input_class.get("value", "") if input_class.get("value", "") != "" else "0"
        input_class.replace_with(value)
    for span_class in html_content_soup.find_all("span", class_="fa fa-camera"):
        span_class.replace_with(" Camera")
    table_df = pd.read_html(str(html_content_soup))[0]
    result = table_df.to_dict(orient='records')
    for item_reconcile in result:
        if("Line #" in item_reconcile):
            if str(item_reconcile["Line #"]).isdigit():
                last_ndc = item_reconcile["NDC"].split(" ")[0]
            if "Item:" in str(item_reconcile["Item"]):
                last_uom = item_reconcile["NDC"].split(" ")[2]
                discrepancy = next((str(item_reconcile[k]) for k in ["Discrepancy", "Expected New Total"] if k in item_reconcile), None).replace(" ", "")
                actual_qty = next((item_reconcile[k] for k in ["Actual Qty On Hand  Actual Qty", "Adding Qty  Adding Qty"] if k in item_reconcile), None).split(" ")[0]
                if discrepancy != "-" and discrepancy.lstrip("+-").isdigit():
                    discrepancy = int(float(discrepancy))
                if actual_qty.isdigit():
                    actual_qty = int(float(actual_qty))
                item_reconcile_converted = {
                    "index": item_reconcile["Line #"].split(" ")[0],
                    "lot": item_reconcile["Lot # / Exp"].split(" ")[0],
                    "expired_date": re.findall(r"(?<=Exp:\s)(\d{1,2}/\d{1,2}/\d{4})(?=\s])",item_reconcile["Lot # / Exp"])[0],
                    "last_qty": int(float(item_reconcile["Last Qty On Hand  Last Qty"])),
                    "received": int(float(item_reconcile["Received"])),
                    "dispense": int(float(item_reconcile["Dispensed"])),
                    "other_changes": int(float(item_reconcile["Other Changes"])),
                    "expected_qty": int(float(item_reconcile["Expected Qty On Hand  Expected Qty"])),
                    "actual_qty": actual_qty,
                    "discrepancy": discrepancy
                }
                list_item_reconcile.append(item_reconcile_converted)

        if("Hard Count:" in str(item_reconcile["Other Changes"])):
            ndc_reconcile_converted = {
                "ndc": last_ndc,
                "uom": last_uom,
                "list_item": list_item_reconcile,
                "hard_count": {
                    "expected_qty":int(float(item_reconcile["Expected Qty On Hand  Expected Qty"])),
                    "actual_qty": next((int(float(item_reconcile[k])) for k in ["Actual Qty On Hand  Actual Qty", "Adding Qty  Adding Qty"] if k in item_reconcile), None),
                    "discrepancy": next((int(float(item_reconcile[k])) for k in ["Discrepancy", "Expected New Total"] if k in item_reconcile), None)
                }
            }
            list_ndc_reconcile.append(ndc_reconcile_converted)
            list_item_reconcile = []
    return list_ndc_reconcile

def get_data_in_html_table_in_view_backstock(html_content: str):
    list_item = []
    html_content_soup = BeautifulSoup(html_content, "lxml")
    for input_id in html_content_soup.find_all("input", class_=["BackstockQty"]):
        input_id.replace_with(input_id.get("value", ""))
    table_df = pd.read_html(str(html_content_soup))[0]
    result = table_df.to_dict(orient='records')
    for item in result:
        if "Item:" in str(item["Item"]):
            item_covert = {
                "index": item["Line #"],
                "ndc": item["NDC"].split(" ")[0],
                "uom": item["NDC"].split(" ")[2],
                "lot": item["Lot # / Exp"].split(" ")[0],
                "expired_date": re.findall(r"(?<=Exp:\s)(\d{1,2}/\d{1,2}/\d{4})(?=\s])",item["Lot # / Exp"])[0],
                "price": float(item["Price"].split(" ")[1]),
                "qty_on_hand": int(float(item["Qty On Hand"])),
            }
            list_item.append(item_covert)
    return list_item

def get_item_barcode_data_from_html_table_in_serialized_item_tracker(html_content: str):
    list_reconcile = []
    html_content_soup = BeautifulSoup(html_content, "lxml")
    for span_tag in html_content_soup.find_all("span"):
            if span_tag["data-barcode"]:
                barcode = span_tag.get("data-barcode", "")
                span_tag.replace_with(barcode)
    table_df = pd.read_html(str(html_content_soup))[0]
    result = table_df.to_dict(orient='records')
    for item_barcode in result:
        item_barcode_covert = {
            "barcode": item_barcode["Barcode"],
            "ndc": item_barcode["NDC"],
            "uom": item_barcode["UOM"].split(" ")[0],
            "lot": item_barcode["Lot #"],
            "expired_date": item_barcode["Expiration Date"].split(" ")[0],
        }
        list_reconcile.append(item_barcode_covert)
    return list_reconcile

def get_data_lot_breakout_inventory_level(html_content, list_properties):
    data_lot_breakout_col = {}
    soup = BeautifulSoup(html_content, 'html.parser')
    cols = soup.find_all('div')
    property_indices = {
        'lot': 1,
        'expired_date': 2,
        'price': 3,
        'qty_on_hand': 4,
        'cost': 5,
    }
    for property_name in list_properties:
        if property_name in property_indices:
            index = property_indices[property_name]
            text = cols[index].get_text()
            
            if property_name == 'price' or property_name == 'cost' or property_name == 'qty_on_hand':
                data_lot_breakout_col[property_name] = float(re.sub(r'[^\d.]', '', text))
            else:
                data_lot_breakout_col[property_name] = text
    return data_lot_breakout_col

def get_transaction_inventory_level(html_content, list_properties):
    inventory_transaction_col = {}
    soup = BeautifulSoup(html_content, 'html.parser')
    cols = soup.find_all('div')
    property_indices = {
        'type': 1,
        'created_by': 2,
        'timestamp': 3,
        'description': 4,
        'adjustment': 5,
        'price': 6,
        'lot_no': 7,
        'expiration': 8
    }
    for property_name in list_properties:
        if property_name in property_indices:
            index = property_indices[property_name]
            text = cols[index].get_text()
            
            if property_name == 'adjustment':
                inventory_transaction_col[property_name] = int(float(text))
            elif property_name == 'price':
                inventory_transaction_col[property_name] = float(re.sub(r'[^\d.]', '', text))
            else:
                inventory_transaction_col[property_name] = text
    return inventory_transaction_col

def get_all_appointment_dos_in_inventory_reconcile(html_content: str):
    html_content_soup = BeautifulSoup(html_content, "lxml")
    table_df = pd.read_html(str(html_content_soup))[0]
    result = table_df.to_dict(orient='records')
    for item_apppointment in result:
        for key, value in item_apppointment.items():
            if isinstance(value, float) and math.isnan(value):
                item_apppointment[key] = "N/A"
        item_apppointment["Date Of Service"] = datetime.strptime(item_apppointment["Date Of Service"], "%m/%d/%Y %I:%M %p").strftime("%m/%d/%Y %I:%M %p")
        item_apppointment["Status / Type"] = item_apppointment["Status / Type"].title()
    return result

def get_data_in_inventory_transfer_report(html_content):
    soup = BeautifulSoup(html_content, 'html.parser')
    divs = []

    for div in soup.find_all("div"):
        classes = div.get("class", [])
        if isinstance(classes, str):
            classes = [classes]
        
        if any(c.startswith("textBox") for c in classes):
            divs.append(div.get_text())

    num_labels = 6
    num_columns = 7
    labels = divs[:num_labels]

    labels.append("Date")

    data_values = divs[num_labels:]

    rows = []
    temp_row = []

    for value in data_values:
        temp_row.append(value)
        if len(temp_row) == num_columns:
            row_dict = dict(zip(labels, temp_row))
            rows.append(row_dict)
            temp_row = []
    convert_data_transfer_items = []
    for row in rows:
        convert_data_transfer_item = {
            "ndc": row["Item"],
            "uom": row["UOM"].split(" ")[0],
            "lot": row["Lot Number"],
            "expired_date": row["Expires"],
            "transfer_qty": int(row["Qty"].split(" ")[0]),
        }
        convert_data_transfer_items.append(convert_data_transfer_item)
    
    return convert_data_transfer_items

def get_all_data_from_html_table_before_reconciled(html_content: str, input_actual_qty_on_hand: list):
    list_reconcile = []
    table_df = pd.read_html(html_content)[0]
    result = table_df.to_dict(orient='records')
    for item_reconcile in result:
        if("Item" in str(item_reconcile["Item"]).split(":")):
            item_reconcile_converted = {
                "Line #": item_reconcile["Line #"].split(" ")[0],
                # "Item":item_reconcile["Item"],
                "NDC":item_reconcile["NDC"].replace(" Uom:","-"),
                "Lot": item_reconcile["Lot # / Exp"].split(" ")[0],
                "Date Expired": re.findall(r"(?<=Exp:\s)(\d{1,2}/\d{1,2}/\d{4})(?=\s])",item_reconcile["Lot # / Exp"])[0],
                "Last Qty On Hand":float(item_reconcile["Last Qty On Hand  Last Qty"]),
                "Received":int(item_reconcile["Received"]),
                "Dispensed":int(item_reconcile["Dispensed"]),
                "Other Changes":int(item_reconcile["Other Changes"]),
                "Expected Qty On Hand":int(item_reconcile["Expected Qty On Hand  Expected Qty"]),
                "Actual Qty On Hand": input_actual_qty_on_hand[int(item_reconcile["Line #"].split(" ")[0]) - 1],
                # "Discrepancy":str(item_reconcile["Discrepancy"]),
            }
            list_reconcile.append(item_reconcile_converted)
    return list_reconcile