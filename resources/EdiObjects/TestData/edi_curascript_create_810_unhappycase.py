from datetime import datetime
from decimal import Decimal
import os
import edi_callggsheetapi
from datetime import datetime
import os

def get_output_path(edi_po_number):
    exec_dir = os.getcwd()
    return os.path.join(exec_dir, "tests", "edi", "message_ui", f"{edi_po_number}_810.txt")

def create_810_unhappycase(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)
        
def create_810_senderid_blank(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 6:
                parts[6] = "               "
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def create_810_senderid_incorrect(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 6:
                parts[6] = "123456789abcdef"
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def create_810_accountnumber_blank(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)
        elif parts[0] == 'REF' and len(parts) > 2:
            if parts[1] == 'AP':
                parts[2] = '      '
            segments[i] = '*'.join(parts)
        elif parts[0] == 'N1':
            if parts[1] == 'ST':
                parts[4] = '      '
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def create_810_accountnumber_incorrect(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)
        elif parts[0] == 'REF' and len(parts) > 2:
            if parts[1] == 'AP':
                parts[2] = 'acbde'
            segments[i] = '*'.join(parts)
        elif parts[0] == 'N1':
            if parts[1] == 'ST':
                parts[4] = 'abcde'
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def create_810_different_price_contract(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    current_date_ISA09 = datetime.now().strftime('%y%m%d')
    current_date = datetime.now().strftime('%Y%m%d')
    current_time = datetime.now().strftime('%H%M')

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'ISA':
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BIG':
            if len(parts) > 4:
                parts[1] = current_date
                parts[3] = current_date
                parts[4] = edi_po_number
            segments[i] = '*'.join(parts)
        elif parts[0] == 'IT1':
            if len(parts) > 4:
                original_value = float(parts[4])
                updated_value = original_value - 20.00
                parts[4] = f"{updated_value:.2f}"
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)