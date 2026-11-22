from decimal import Decimal
import edi_curascript_create_855_856_810
import edi_mckessonsh_create_message
import edi_cencora_besse_create_message
import edi_callggsheetapi
from datetime import datetime
import os
from pathlib import Path

def get_latest_file(folder_path):
    try:
        files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]
        
        if not files:
            print("The folder contains no files.")
            return None

        latest_file = max(files, key=os.path.getmtime)
        return latest_file
    except Exception as e:
        print(f"An error occurred: {e}")
        return None
    
def get_output_path(edi_po_number):
    exec_dir = os.getcwd()
    return os.path.join(exec_dir, "tests", "edi", "message_ui", f"{edi_po_number}_855.txt")
    
def update_edi_message(env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            if len(parts) > 5:
                parts[5] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def message_incorrect_item_price(env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PO1':
            if len(parts) > 4:
                parts[4] = str(float(parts[4]) + 1)
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            if len(parts) > 5:
                parts[5] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def message_po_blank(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    now = datetime.now()
    current_date_ISA09, current_date, current_time = now.strftime('%y%m%d'), now.strftime('%Y%m%d'), now.strftime('%H%M')

    segment_map = {
        'ISA': [(9, current_date_ISA09), (10, current_time)],
        'GS': [(4, current_date), (5, current_time)],
        'BAK': [(3, ''), (4, current_date)],
        'ACK': [(5, current_date)]
    }

    segments = []
    for segment in edi_message.split('~'):
        parts = segment.strip().split('*')
        for index, value in segment_map.get(parts[0], []):
            if len(parts) > index:
                parts[index] = value
        segments.append('*'.join(parts))

    output_path = get_output_path(edi_po_number)
    output_path.write_text('~\n'.join(segments))

def message_receiveid_blank(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    now = datetime.now()
    current_date_ISA09, current_date, current_time = now.strftime('%y%m%d'), now.strftime('%Y%m%d'), now.strftime('%H%M')

    segment_map = {
        'ISA': [(6, '               '), (9, current_date_ISA09), (10, current_time)],
        'GS': [(4, current_date), (5, current_time)],
        'BAK': [(3, edi_po_number), (4, current_date)],
        'ACK': [(5, current_date)]
    }

    segments = []
    for segment in edi_message.split('~'):
        parts = segment.strip().split('*')
        for index, value in segment_map.get(parts[0], []):
            if len(parts) > index:
                parts[index] = value
        segments.append('*'.join(parts))

    output_path = get_output_path(edi_po_number)
    output_path.write_text('~\n'.join(segments))

def message_receiveid_incorrect(env, row_key, column_key):
    date_time = datetime.now().strftime("%m%d%Y%H%M")
    edi_po_number = f"AT_DL_{date_time[:8]}_{date_time[8:]}"

    edi_message = edi_callggsheetapi.get_message_ggsheet(env, row_key, column_key)
    edi_message = edi_message.replace('\n', '').replace('\r', '').strip()

    now = datetime.now()
    current_date_ISA09, current_date, current_time = now.strftime('%y%m%d'), now.strftime('%Y%m%d'), now.strftime('%H%M')

    segment_map = {
        'ISA': [(6, 'abcdefghijklmno'), (9, current_date_ISA09), (10, current_time)],
        'GS': [(4, current_date), (5, current_time)],
        'BAK': [(3, edi_po_number), (4, current_date)],
        'ACK': [(5, current_date)]
    }

    segments = []
    for segment in edi_message.split('~'):
        parts = segment.strip().split('*')
        for index, value in segment_map.get(parts[0], []):
            if len(parts) > index:
                parts[index] = value
        segments.append('*'.join(parts))

    output_path = get_output_path(edi_po_number)
    output_path.write_text('~\n'.join(segments))

def message_line_item_status(status, env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            parts = ["ACK", status, "1", "EA", "", current_date]
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)
    file_name = f"{edi_po_number}_855_LIS_{status}"
    exec_dir = os.getcwd()
    output_path = os.path.join(exec_dir, "tests", "edi", "message_ui", f"{file_name}.txt")
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def message_incorrect_vendor_item(env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            if len(parts) > 5:
                parts[5] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PO1':
            if len(parts) > 7:
                parts[7] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)
    file_name = f"{edi_po_number}_855_InVI"
    exec_dir = os.getcwd()
    output_path = os.path.join(exec_dir, "tests", "edi", "message_ui", f"{file_name}.txt")
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def message_vendor_item_blank(env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            if len(parts) > 5:
                parts[5] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PO1':
            if len(parts) > 7:
                parts[7] = ''
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)
    file_name = f"{edi_po_number}_855_NoVI"
    exec_dir = os.getcwd()
    output_path = os.path.join(exec_dir, "tests", "edi", "message_ui", f"{file_name}.txt")
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def message_855_case_856(env, row_key, column_key):
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
        elif parts[0] == 'BAK':
            if len(parts) > 3:
                parts[3] = edi_po_number
            if len(parts) > 4:
                parts[4] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'ACK':
            if len(parts) > 5:
                parts[5] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

def parse_edi_855(edi_data_855):
    edi_data_855 = edi_data_855.replace('\n', '')
    segments = edi_data_855.split('~')
    parsed_855_data = {}

    for segment in segments:
        elements = segment.split('*')
        seg_id = elements[0]

        if seg_id not in parsed_855_data:
            parsed_855_data[seg_id] = []

        parsed_855_data[seg_id].append(elements)

    return parsed_855_data

def parse_test(edi_data_855):
    edi_data_855 = edi_data_855.replace('\n', '')
    return edi_data_855

def parse_edi_db(edi_data_db):
    segments = edi_data_db.split('~')
    parsed_db_data = {}

    for segment in segments:
        elements = segment.split('*')
        seg_id = elements[0]

        if seg_id not in parsed_db_data:
            parsed_db_data[seg_id] = []

        parsed_db_data[seg_id].append(elements)

    return parsed_db_data

def create_856_from_855_curascript(parsed_855):
    edi_856 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_856.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'SH'
    edi_856.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = "856"
    edi_856.append(f"{'*'.join(st)}~")

    # BSN Segment
    bak = parsed_855['BAK'][0]
    bsn = ['BSN', '00', '9241549', bak[4], '073008', '0001', 'AS']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S*1~")

    # TD1 Segment
    edi_856.append("TD1*PKG*1****G*1.088*LB~")

    # TD5 Segment
    edi_856.append("TD5**2*FEDEX**UPS NxD 10:30*PR~")

    # REF Segment
    edi_856.append('REF*BM*00100861056000279854~')
    edi_856.append('REF*2I*778108927733~')

    # DTM Segment
    edi_856.append(f'DTM*011*{bak[4]}*214327~')
    edi_856.append('DTM*017*20250826~')

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # REF Segment
    ref_11 = ['REF', '11', n1[4]]
    edi_856.append(f"{'*'.join(ref_11)}~")

    # N1*SF, N4 Segment
    edi_856.append("N1*SF*PRIORITY HEALTHCARE DISTRIBUTION, INC.*11*RP0334540~")
    edi_856.append("N4*GROVE CITY*OH*43123-1822~")

    # N1*SE, N3, N4 Segment
    edi_856.append("N1*SE*CURASCRIPT SD SPECIALTY DIST*91*59-3761140~")
    edi_856.append("N3*255 Technology Park~")
    edi_856.append("N4*Lake Mary*FL*32746~")

    # N1*BY, N3, N4 Segment
    edi_856.append("N1*BY*AASC - Baum*91*120094274~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # N1*BT, N3, N4 Segment
    edi_856.append("N1*BT*ALLERGY ASSOCIATES PA*91*0900134208~")
    edi_856.append("N3*6701 BAUM DR STE 140~")
    edi_856.append("N4*KNOXVILLE*TN*37919~")

    # YNQ Segment
    edi_856.append('YNQ**Y***Seller has complied with each applicable subsection of FDCA Sec. 581(27)(A)-(G)***99*TS~')

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    prf = ['PRF', bak[3], '', '', bak[4]]
    edi_856.append(f"{'*'.join(prf)}~")

    # HL Segment
    hl_pack = ['HL', '3', '2', 'P', '1']
    edi_856.append(f"{'*'.join(hl_pack)}~")

    # MAN Segment
    man = ['MAN', 'GM', '00100861056000279854']
    edi_856.append(f"{'*'.join(man)}~")

    po1_segments = parsed_855.get('PO1', [])
    pid_segments = parsed_855.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 4}*2*I*0~')

        # LIN Segment
        edi_856.append(f"LIN*{index + 1}*ND*{po1[9]}*VN*{po1[7]}*LT*K347A8141~")

        # SN1 Segment
        sn1 = ['SN1', '', po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # DTM Segment
        dtm = ['DTM', '036', '20260228']
        edi_856.append(f"{'*'.join(dtm)}~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = str(len(po1_segments))
    edi_856.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_856.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_856.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_856.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_message_856_unhappy(parsed_855):
    edi_856 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_856.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'SH'
    edi_856.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = "856"
    edi_856.append(f"{'*'.join(st)}~")

    # BSN Segment
    bak = parsed_855['BAK'][0]
    bsn = ['BSN', '00', '9241549', bak[4], '073008', '0001', 'AS']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S*1~")

    # TD1 Segment
    edi_856.append("TD1*PKG*1****G*1.088*LB~")

    # TD5 Segment
    edi_856.append("TD5**2*FEDEX**UPS NxD 10:30*PR~")

    # REF Segment
    edi_856.append('REF*BM*00100861056000279854~')
    edi_856.append('REF*2I*778108927733~')

    # DTM Segment
    edi_856.append(f'DTM*011*{bak[4]}*214327~')
    edi_856.append('DTM*017*20250826~')

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # REF Segment
    ref_11 = ['REF', '11', n1[4]]
    edi_856.append(f"{'*'.join(ref_11)}~")

    # N1*SF, N4 Segment
    edi_856.append("N1*SF*PRIORITY HEALTHCARE DISTRIBUTION, INC.*11*RP0334540~")
    edi_856.append("N4*GROVE CITY*OH*43123-1822~")

    # N1*SE, N3, N4 Segment
    edi_856.append("N1*SE*CURASCRIPT SD SPECIALTY DIST*91*59-3761140~")
    edi_856.append("N3*255 Technology Park~")
    edi_856.append("N4*Lake Mary*FL*32746~")

    # N1*BY, N3, N4 Segment
    edi_856.append("N1*BY*AASC - Baum*91*120094274~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # N1*BT, N3, N4 Segment
    edi_856.append("N1*BT*ALLERGY ASSOCIATES PA*91*0900134208~")
    edi_856.append("N3*6701 BAUM DR STE 140~")
    edi_856.append("N4*KNOXVILLE*TN*37919~")

    # YNQ Segment
    edi_856.append('YNQ**Y***Seller has complied with each applicable subsection of FDCA Sec. 581(27)(A)-(G)***99*TS~')

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    prf = ['PRF', bak[3], '', '', bak[4]]
    edi_856.append(f"{'*'.join(prf)}~")

    # HL Segment
    hl_pack = ['HL', '3', '2', 'P', '1']
    edi_856.append(f"{'*'.join(hl_pack)}~")

    # MAN Segment
    man = ['MAN', 'GM', '00100861056000279854']
    edi_856.append(f"{'*'.join(man)}~")

    # Hardcode segment HL, PO1, PID, REF, ACK
    edi_856.append("HL*4*2*I*0~")
    edi_856.append("LIN*1*ND*00069080901*VN*10001078*LT*K347A8141~")
    edi_856.append("SN1**1*EA~")
    edi_856.append("PID*F****INFLECTRA infliximab-dyyb 100mg in a 20mL Vial Lyophilized~")
    edi_856.append("DTM*036*20260228~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = "1"
    edi_856.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_856.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_856.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_856.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_856_different_qty(parsed_855):
    edi_856 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_856.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'SH'
    edi_856.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = "856"
    edi_856.append(f"{'*'.join(st)}~")

    # BSN Segment
    bak = parsed_855['BAK'][0]
    bsn = ['BSN', '00', '9241549', bak[4], '073008', '0001', 'AS']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S*1~")

    # TD1 Segment
    edi_856.append("TD1*PKG*1****G*1.088*LB~")

    # TD5 Segment
    edi_856.append("TD5**2*FEDEX**UPS NxD 10:30*PR~")

    # REF Segment
    edi_856.append('REF*BM*00100861056000279854~')
    edi_856.append('REF*2I*778108927733~')

    # DTM Segment
    edi_856.append(f'DTM*011*{bak[4]}*214327~')
    edi_856.append('DTM*017*20250826~')

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # REF Segment
    ref_11 = ['REF', '11', n1[4]]
    edi_856.append(f"{'*'.join(ref_11)}~")

    # N1*SF, N4 Segment
    edi_856.append("N1*SF*PRIORITY HEALTHCARE DISTRIBUTION, INC.*11*RP0334540~")
    edi_856.append("N4*GROVE CITY*OH*43123-1822~")

    # N1*SE, N3, N4 Segment
    edi_856.append("N1*SE*CURASCRIPT SD SPECIALTY DIST*91*59-3761140~")
    edi_856.append("N3*255 Technology Park~")
    edi_856.append("N4*Lake Mary*FL*32746~")

    # N1*BY, N3, N4 Segment
    edi_856.append("N1*BY*AASC - Baum*91*120094274~")
    edi_856.append("N3*6701 Baum Drive Ste 140~")
    edi_856.append("N4*Knoxville*TN*37919~")

    # N1*BT, N3, N4 Segment
    edi_856.append("N1*BT*ALLERGY ASSOCIATES PA*91*0900134208~")
    edi_856.append("N3*6701 BAUM DR STE 140~")
    edi_856.append("N4*KNOXVILLE*TN*37919~")

    # YNQ Segment
    edi_856.append('YNQ**Y***Seller has complied with each applicable subsection of FDCA Sec. 581(27)(A)-(G)***99*TS~')

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    prf = ['PRF', bak[3], '', '', bak[4]]
    edi_856.append(f"{'*'.join(prf)}~")

    # HL Segment
    hl_pack = ['HL', '3', '2', 'P', '1']
    edi_856.append(f"{'*'.join(hl_pack)}~")

    # MAN Segment
    man = ['MAN', 'GM', '00100861056000279854']
    edi_856.append(f"{'*'.join(man)}~")

    po1_segments = parsed_855.get('PO1', [])
    pid_segments = parsed_855.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 4}*2*I*0~')

        # LIN Segment
        edi_856.append(f"LIN*{index + 1}*ND*{po1[9]}*VN*{po1[7]}*LT*K347A8141~")

        # SN1 Segment
        sn1 = ['SN1', '', '2', po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # DTM Segment
        dtm = ['DTM', '036', '20260228']
        edi_856.append(f"{'*'.join(dtm)}~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = str(len(po1_segments))
    edi_856.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_856.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_856.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_856.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_810_from_855_curascript(parsed_855):
    edi_810 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    bak = parsed_855['BAK'][0]
    edi_810.append(f"BIG*{bak[4]}*90031258*{bak[4]}*{bak[3]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_810.append(f"REF*AP*{n1[4]}~")
    edi_810.append(f"REF*CO*13581~")
    edi_810.append(f"REF*OI*90031258~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{n1[4]}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"{'*'.join(n1)}~")
    edi_810.append(f"N3*6701 Baum Drive Ste 140~")
    edi_810.append(f"N4*Knoxville*TN*37919*US~")

    # N1*RE, N2, N3, N4 Segment
    edi_810.append(f"N1*RE*PRIORITY HEALTHCARE DIST~")
    edi_810.append(f"N2*DBA CURASCRIPT SD~")
    edi_810.append(f"N3*P.O. BOX 978510~")
    edi_810.append(f"N4*DALLAS*TX*75397~")

    # N1*SF, N3, N4 Segment
    edi_810.append(f"N1*SF*CURASCRIPT SD SPECIALITY DIST*11*RP0334540~")
    edi_810.append(f"N3*2297 SOUTHWEST BLVD STE D~")
    edi_810.append(f"N4*GROVE CITY*OH*43123*US~")

    # ITD Segment
    edi_810.append(f"ITD*14*3*0**90*20241119**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*20250331~")
    edi_810.append(f"DTM*011*20241222~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")
    
    po1_segments = parsed_855.get('PO1', [])
    pid_segments = parsed_855.get('PID', [])
    po_total = Decimal('0.0')
    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**ND*{po1[9]}*****UI*{po1[9]}*VC*{po1[7]}~')
        po_total += Decimal(po1[2]) * Decimal(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

        # REF Segment
        edi_810.append(f"REF*0B*0000021247~")
        edi_810.append(f"REF*ZZ*0090031258000010~")
        edi_810.append(f"REF*LT*K347A8141~")
        edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
        edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

        # DTM Segment
        edi_810.append(f"DTM*008*20240821~")
        edi_810.append(f"DTM*208*20261121~")
        edi_810.append(f"DTM*132*20261121~")

    # TDS Segment
    po_total = str(po_total).replace('.', '')
    edi_810.append(f"TDS*{po_total}*{po_total}~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = str(len(po1_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)

def create_810_incorrect_vendor_item(parsed_855):
    edi_810 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    bak = parsed_855['BAK'][0]
    edi_810.append(f"BIG*{bak[4]}*90031258*{bak[4]}*{bak[3]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_810.append(f"REF*AP*{n1[4]}~")
    edi_810.append(f"REF*CO*13581~")
    edi_810.append(f"REF*OI*90031258~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{n1[4]}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"{'*'.join(n1)}~")
    edi_810.append(f"N3*6701 Baum Drive Ste 140~")
    edi_810.append(f"N4*Knoxville*TN*37919*US~")

    # N1*RE, N2, N3, N4 Segment
    edi_810.append(f"N1*RE*PRIORITY HEALTHCARE DIST~")
    edi_810.append(f"N2*DBA CURASCRIPT SD~")
    edi_810.append(f"N3*P.O. BOX 978510~")
    edi_810.append(f"N4*DALLAS*TX*75397~")

    # N1*SF, N3, N4 Segment
    edi_810.append(f"N1*SF*CURASCRIPT SD SPECIALITY DIST*11*RP0334540~")
    edi_810.append(f"N3*2297 SOUTHWEST BLVD STE D~")
    edi_810.append(f"N4*GROVE CITY*OH*43123*US~")

    # ITD Segment
    edi_810.append(f"ITD*14*3*0**90*20241119**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*20250331~")
    edi_810.append(f"DTM*011*20241222~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")
    
    po1_segments = parsed_855.get('PO1', [])
    pid_segments = parsed_855.get('PID', [])
    po_total = Decimal('0.0')
    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**ND*{po1[9]}*****UI*{po1[9]}*VC*abcd~')
        po_total += Decimal(po1[2]) * Decimal(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

        # REF Segment
        edi_810.append(f"REF*0B*0000021247~")
        edi_810.append(f"REF*ZZ*0090031258000010~")
        edi_810.append(f"REF*LT*K347A8141~")
        edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
        edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

        # DTM Segment
        edi_810.append(f"DTM*008*20240821~")
        edi_810.append(f"DTM*208*20261121~")
        edi_810.append(f"DTM*132*20261121~")

    # TDS Segment
    po_total = str(po_total).replace('.', '')
    edi_810.append(f"TDS*{po_total}*{po_total}~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = str(len(po1_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)

def create_810_invoice_new_item(parsed_855):
    edi_810 = []

    # ISA Segment
    isa = parsed_855['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_855['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_855['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    bak = parsed_855['BAK'][0]
    edi_810.append(f"BIG*{bak[4]}*90031258*{bak[4]}*{bak[3]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_855)
    edi_810.append(f"REF*AP*{n1[4]}~")
    edi_810.append(f"REF*CO*13581~")
    edi_810.append(f"REF*OI*90031258~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{n1[4]}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"{'*'.join(n1)}~")
    edi_810.append(f"N3*6701 Baum Drive Ste 140~")
    edi_810.append(f"N4*Knoxville*TN*37919*US~")

    # N1*RE, N2, N3, N4 Segment
    edi_810.append(f"N1*RE*PRIORITY HEALTHCARE DIST~")
    edi_810.append(f"N2*DBA CURASCRIPT SD~")
    edi_810.append(f"N3*P.O. BOX 978510~")
    edi_810.append(f"N4*DALLAS*TX*75397~")

    # N1*SF, N3, N4 Segment
    edi_810.append(f"N1*SF*CURASCRIPT SD SPECIALITY DIST*11*RP0334540~")
    edi_810.append(f"N3*2297 SOUTHWEST BLVD STE D~")
    edi_810.append(f"N4*GROVE CITY*OH*43123*US~")

    # ITD Segment
    edi_810.append(f"ITD*14*3*0**90*20241119**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*20250331~")
    edi_810.append(f"DTM*011*20241222~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")
    
    # IT1 Segment
    edi_810.append(f'IT1*1*1*EA*261.00**ND*00069080901*****UI*00069080901*VC*10001078~')

    # PID Segment
    edi_810.append(f"PID*F****INFLECTRA infliximab-dyyb 100mg in a 20mL Vial Lyophilized~")

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*K347A8141~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*20240821~")
    edi_810.append(f"DTM*208*20261121~")
    edi_810.append(f"DTM*132*20261121~")

    # TDS Segment
    edi_810.append(f"TDS*26100*26100~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    ctt = parsed_855['CTT'][0]
    ctt[1] = '1'
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_855['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_855['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_855['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)

def get_value_by_ref_key(n1_segment, ref_key='11'):
    for segment in n1_segment:
        if segment[0] == 'REF' and segment[1] == ref_key:
            return segment[2]
    return None

if __name__ == "__main__":
    # update_edi_message()
    # message_incorrect_item_price()
    # message_po_blank()
    # message_receiveid_blank()
    # message_line_item_status(status='IR')
    # message_incorrect_vendor_item()
    # message_855_case_856()
    # create_message_856_unhappy()
    create_810_invoice_new_item('')
    # newest_file = get_latest_file("D:\\MSG850UI")
    # print(str(newest_file))
    # edi_data = edi_curascript_create_855_856_810.read_edi_file(newest_file)
    # parsed_850_data = edi_curascript_create_855_856_810.parse_edi_850(edi_data)
    
    # edi_810_data = create_810_from_855_curascript(parsed_850_data)
    # with open(newest_file, 'w') as file:
    #     file.write(str(edi_810_data))