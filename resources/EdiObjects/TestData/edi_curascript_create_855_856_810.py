from decimal import Decimal
import os

def read_edi_file(file_path):
    with open(file_path, 'r') as file:
        edi_data_850 = file.read()
    return edi_data_850

def parse_edi_850(edi_data_850):
    segments = edi_data_850.split('~\n')
    parsed_850_data = {}

    for segment in segments:
        elements = segment.split('*')
        seg_id = elements[0]

        if seg_id not in parsed_850_data:
            parsed_850_data[seg_id] = []

        parsed_850_data[seg_id].append(elements)

    return parsed_850_data

def is_empty_segment(segment):
    fields = segment.rstrip('~').split('*')
    return all(field == "" for field in fields[1:])

def ensure_list_length(lst, index):
    while len(lst) <= index:
        lst.append("")  # Add element null

def get_ref_value(parsed_data, ref_id):
    ref_value = None
    for ref_item in parsed_data.get('REF', []):
        if ref_item[1] == ref_id:
            ref_value = ref_item[2] if len(ref_item) > 2 else None
            break
    return ref_value

def create_edi_855(parsed_850_data):
    master_855 = [
        "ISA****************~",
        "GS********~",
        "ST**~",
        "BAK*********~",
        "N1****~",
        "PO1*********~",
        "PID*****~",
        "REF**~",
        "ACK**********~",
        "N9**~",
        "CTT*~",
        "SE**~",
        "GE**~",
        "IEA**~"
    ]
    
    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    if len(isa) >= 9:
        isa[6], isa[8] = isa[8], isa[6]
    master_855[0] = f"{'*'.join(isa)}~"
    
    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'PR'
    gs[2], gs[3] = gs[3], gs[2]
    master_855[1] = f"{'*'.join(gs)}~"
    
    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = '855'
    master_855[2] = f"{'*'.join(st)}~"
    
    # BAK Segment
    beg = parsed_850_data['BEG'][0]
    bak = ['BAK', '06', 'AC', beg[3], beg[5]]
    master_855[3] = f"{'*'.join(bak)}~"
    
    # N1 Segments
    n1 = parsed_850_data['N1'][0]
    n1[1] = 'ST'
    master_855[4] = f"{'*'.join(n1)}~"

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    
    edi_855_body = []  # To save PO1, PID, REF, ACK

    for index, po1 in enumerate(po1_segments):
        # PO1 segment
        po1_segment = f"{'*'.join(po1)}~"
        if not all(field.strip() == '' for field in po1):
            edi_855_body.append(po1_segment)

        # PID segment corresponds to PO1
        if index < len(pid_segments):
            pid = pid_segments[index]
            # Check if all fields in PID are empty
            if not all(field.strip() == '' for field in pid):
                edi_855_body.append(f"{'*'.join(pid)}~")

        # REF segment
        ref = ['REF', 'CO', '8286681']
        if not all(field.strip() == '' for field in ref):
            edi_855_body.append(f"{'*'.join(ref)}~")

        # ACK segment
        ack = ['ACK', 'IA', po1[2], po1[3]]
        if not all(field.strip() == '' for field in ack):
            edi_855_body.append(f"{'*'.join(ack)}~")

    # Insert segment PO1, PID, REF, ACK into master_855
    master_855 = master_855[:5] + edi_855_body + master_855[5:]

    # CTT Segment
    total_items = len(po1_segments)
    master_855[-4] = f"CTT*{total_items}~"

    # SE Segment
    se = parsed_850_data['SE'][0]
    master_855[-3] = f"{'*'.join(se)}~"

    # GE Segment
    ge = parsed_850_data['GE'][0]
    master_855[-2] = f"{'*'.join(ge)}~"

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    master_855[-1] = f"{'*'.join(iea)}~"

    # Filter segment null
    master_855 = [segment for segment in master_855 if not is_empty_segment(segment)]
    segments_count = len(master_855[2:-2])
    se[1] = str(segments_count)
    master_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(master_855)

def create_edi_856(parsed_850_data):
    master_856 = [
        "ISA****************~",
        "GS********~",
        "ST**~",
        "BSN******~",
        "HL*1**S*1~",
        "TD1*PKG*1****G*8.35*LB~",
        "TD5**2*UPSN**UPS-PRIORITY OVRNT*CC~",
        "REF*BM*9241549000190056000190056~",
        "REF*2I*745253190759~",
        "DTM*011**185900~",
        "DTM*017*20240606~",
        "N1*ST*KANSAS CITY PHYSICIAN PARTNERS*11*FJ1431600~",
        "N3*8350 N ST CLAIR AVE STE 100~",
        "N4*KANSAS CITY*MO*64151~",
        "REF*11*~",
        "N1*SF*CURASCRIPT SD SPECIALTY DIST*11*RP0334540~",
        "N3*2297 SOUTHWEST BLVD STE. D~",
        "N4*GROVE CITY*OH*43123~",
        "N1*SE*CURASCRIPT SD SPECIALTY DIST*91*59-3761140~",
        "N3*255 TECHNOLOGY PARK~",
        "N4*LAKE MARY*FL*32746~",
        "N1*BT*KANSAS CITY PHYSICIAN PARTNERS*91*141325~",
        "N3*4440 BROADWAY~",
        "N4*KANSAS CITY*MO*64111~",
        "YNQ**Y***Seller has complied with each applicable subsection of FDCA Sec.-581(27)(A)-(G).***99*TS~",
        "HL*2*1*O*1~",
        "PRF****~",
        "HL*3*2*P*1~",
        "MAN*GM*00007654320045896241~",
        "HL****~",
        "LIN*******~",
        "SN1***~",
        "PID*****~",
        "DTM*036*20260228~",
        "CTT*~",
        "SE**~",
        "GE**~",
        "IEA**~"
    ]

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    if len(isa) > 9:
        isa[6], isa[8] = isa[8], isa[6]
    master_856[0] = f"{'*'.join(isa)}~"

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'SH'
    gs[2], gs[3] = gs[3], gs[2]
    master_856[1] = f"{'*'.join(gs)}~"

    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = "856"
    master_856[2] = f"{'*'.join(st)}~"

    # BSN Segment
    beg = parsed_850_data['BEG'][0]
    bsn = ['BSN', '00', '9241549', beg[5], '073008', '0001', 'AS']
    master_856[3] = f"{'*'.join(bsn)}~"

    # Add the new DTM*011 segment
    master_856[9] = f"DTM*011*{parsed_850_data['BEG'][0][5]}*185900~"

    # REF Segment
    ref_11 = ['REF', '11', parsed_850_data['N1'][0][4]]
    master_856[14] = f"{'*'.join(ref_11)}~"

    # PRF Segment
    prf = ['PRF', parsed_850_data['BEG'][0][3], '', '', parsed_850_data['BEG'][0][5]]
    master_856[27] = f"{'*'.join(prf)}~"

    hl_pack = ['HL', '3', '2', 'P', '1']
    master_856[28] = f"{'*'.join(hl_pack)}~"

    # MAN Segment
    man = ['MAN', 'GM', '00007654320045896241']
    master_856[29] = f"{'*'.join(man)}~"

    # Handle HL and item segments based on the PO1 and PID segments
    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        start_index = 30 + index * 5
        ensure_list_length(master_856, start_index + 4)

        # HL Segment
        hl_item = ['HL', str(4 + index), '3', 'I', '0']
        master_856[start_index] = f"{'*'.join(hl_item)}~"

        # LIN Segment
        lin = ['LIN', f"{index+1}", po1[8], po1[9], po1[6], po1[7], 'LT', '234225']
        master_856[start_index + 1] = f"{'*'.join(lin)}~"

        # SN1 Segment
        sn1 = ['SN1', '', po1[2], po1[3]]
        master_856[start_index + 2] = f"{'*'.join(sn1)}~"

        # PID Segment
        if index < len(pid_segments):
            pid = ['PID', 'F', '', '', '', pid_segments[index][5]]
            master_856[start_index + 3] = f"{'*'.join(pid)}~"

        # DTM Segment
        dtm = ['DTM', '036', '20260228']
        master_856[start_index + 4] = f"{'*'.join(dtm)}~"

    # CTT Segment
    ctt = parsed_850_data['CTT'][0]
    ctt[1] = str(len(po1_segments))
    master_856.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    master_856.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    ge[2] = gs[6]
    master_856.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    iea[2] = isa[13]
    master_856.append(f"{'*'.join(iea)}~")

    master_856 = [segment for segment in master_856 if not is_empty_segment(segment)]
    segments_count = len(master_856[2:-2])
    se[1] = str(segments_count)
    master_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(master_856)

def create_edi_810(parsed_850_data):
    master_810 = [
        "ISA****************~",
        "GS********~",
        "ST**~",
        "BIG*******~",
        "REF*CO*8286681~",
        "REF*IT*141325~",
        "REF*AP*~",
        "REF*TJ*59-3761140~",
        "REF*PN*2006011265~",
        "PER****~",
        "N1*BT*KANSAS CITY PHYSICIAN PARTNERS*91*141325~",
        "N3*4440 BROADWAY~",
        "N4*KANSAS CITY*MO*64111*USA~",
        "N1*ST*KANSAS CITY PHYSICIAN PARTNERS*91*~",
        "N3*8350 N ST CLAIR AVE STE 100~",
        "N4*KANSAS CITY*MO*64151*USA~",
        "N1*RE*PRIORITY HEALTHCARE DIST~",
        "N2*DBA CURASCRIPT SD~",
        "N3*P.O. BOX 978510~",
        "N4*DALLAS*TX*753978510*USA~",
        "N1*SF*CURASCRIPT SD SPECIALTY DIST*11*RP0334540~",
        "N3*2297 SOUTHWEST BLVD STE. D~",
        "N4*GROVE CITY*OH*43123*USA~",
        "ITD*01*3*2*20240910*90*20240910*90*66138****~",
        "DTM*036*20251031~",
        "DTM*011*20240603~",
        "FOB*CC*OR*FOB Shipping Point~",
        "IT1***************~",
        "PID*****~",
        "REF**~",
        "DTM**~",
        "TDS**~",
        "SLN*********~",
        "SAC***************~",
        "CTT*~",
        "SE**~",
        "GE**~",
        "IEA**~"
    ]

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[6], isa[8] = isa[8], isa[6]
    master_810[0] = f"{'*'.join(isa)}~"

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'IN'
    gs[2], gs[3] = gs[3], gs[2]
    master_810[1] = f"{'*'.join(gs)}~"

    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = '810'
    master_810[2] = f"{'*'.join(st)}~"

    # BIG Segment
    big = ['BIG', gs[4], '9241549', gs[4], parsed_850_data['BEG'][0][3], '', '', 'PR']
    master_810[3] = f"{'*'.join(big)}~"

    # REF Segment
    n1 = parsed_850_data['N1'][0]
    master_810[6] = f"REF*AP*{n1[4]}~"

    # N1 Segment
    master_810[13] = f"N1*ST*KANSAS CITY PHYSICIAN PARTNERS*91*{n1[4]}~"

    # IT1 Segments và PID, REF, DTM, TDS for each (PO1)
    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    po_total = Decimal('0.0')
    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        it1 = ['IT1','1', po1[2], po1[3], po1[4], '', po1[8], po1[9], 'MF', '69800025001', po1[6], '69800025001', '', '', 'VC', po1[7]]
        master_810.append(f"{'*'.join(it1)}~")
        po_total += Decimal(po1[2]) * Decimal(po1[4])

        # PID Segments
        if index < len(pid_segments):
            pid = ['PID', 'F', '', '', '', pid_segments[index][5]]
            master_810.append(f"{'*'.join(pid)}~")

        # REF Segments for IT1
        ref_it1_segments = [
            ('0B', '2006039224'),
            ('LT', '234225'),
            ('BV', '1108492', 'ADMA BIOMANUFACTURING LLC'),
            ('ZZ', '2557817'),
            ('LX', '', 'Item eligible for Forfeited Cash Discount')
        ]
        for ref in ref_it1_segments:
            if len(ref) == 3:
                master_810.append(f"REF*{ref[0]}*{ref[1]}*{ref[2]}~")
            else:
                master_810.append(f"REF*{ref[0]}*{ref[1]}~")

        # Additional DTM Segments
        additional_dtm_segments = [
            ('208', '20261130'),
            ('008', '20240502'),
            ('132', '20261130')
        ]
        for dtm in additional_dtm_segments:
            master_810.append(f"DTM*{dtm[0]}*{dtm[1]}~")

    # TDS Segment
    po_total = str(po_total).replace('.', '')
    master_810.append(f"TDS*{po_total}*{po_total}~")

    # SAC Segment
    master_810.append("SAC*C*ZZZZ***92717*******06***FORFEITED CASH DISCOUNT~")

    # CTT Segment
    ctt = parsed_850_data['CTT'][0]
    ctt[1] = str(len(po1_segments))
    master_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    master_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    ge[2] = gs[6]
    master_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    iea[2] = isa[13]
    master_810.append(f"{'*'.join(iea)}~")

    master_810 = [segment for segment in master_810 if not is_empty_segment(segment)]
    segments_count = len(master_810[2:-2])
    se[1] = str(segments_count)
    master_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(master_810)

def create_edi_997(parsed_850_data):
    edi_997 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[6], isa[8] = isa[8], isa[6]
    isa[5], isa[7] = isa[7], isa[5]
    edi_997.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_850_data['GS'][0]
    ak1_01 = gs[1]
    gs[1] = 'FA'
    gs[2], gs[3] = gs[3], gs[2]
    edi_997.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_850_data['ST'][0]
    ak2_01 = st[1]
    st[1] = '997'
    edi_997.append(f"{'*'.join(st)}~")

    # AK1 Segment
    edi_997.append(f"AK1*{ak1_01}*000000001~")

    # AK2 Segment
    edi_997.append(f"AK2*{ak2_01}*000000001~")

    # AK5 Segment
    edi_997.append(f"AK5*A~")

    # AK9 Segment
    edi_997.append(f"AK9*A*1*1*1~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_997.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    ge[2] = gs[6]
    edi_997.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    iea[2] = isa[13]
    edi_997.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_997[2:-2])
    se[1] = str(segments_count)
    edi_997[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_997)

def delete_all_files_in_folder(folder_path):
    try:
        for file_name in os.listdir(folder_path):
            full_path = os.path.join(folder_path, file_name)
            if os.path.isfile(full_path):
                os.remove(full_path)
        print(f"All files deleted in: {folder_path}")
    except Exception as e:
        print(f"Error deleting files: {e}")