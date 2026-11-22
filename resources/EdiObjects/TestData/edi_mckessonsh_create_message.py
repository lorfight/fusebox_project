import edi_curascript_create_855_856_810

def get_n1_values(parsed_data, n1_id):
    for n1 in parsed_data.get('N1', []):
        if len(n1) >= 2 and n1[1] == n1_id:
            if len(n1) >= 5:
                return n1[4]
    return None

def create_edi_855_mckessonsh(parsed_850_data):
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
    bak = ['BAK', '06', 'AC', beg[3], beg[5], '', '', '', '', beg[5]]
    master_855[3] = f"{'*'.join(bak)}~"
    
    #REF Segment
    ref = ['REF', 'PO', '4010459759']
    master_855[4] = f"{'*'.join(ref)}~"

    # N1 Segments
    n1 = parsed_850_data['N1'][0]
    n1[1] = 'BY'
    master_855[5] = f"{'*'.join(n1)}~"

    n12 = ['N1', 'SE*McKesson Specialty Health', '11', 'RO0338889']
    master_855[6] = f"{'*'.join(n12)}~"

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
        ack = ['ACK', 'IA', '1', po1[3], '', '', '', 'VC', po1[7], po1[8], po1[9]]
        if not all(field.strip() == '' for field in ack):
            edi_855_body.append(f"{'*'.join(ack)}~")

    # Insert segment PO1, PID, REF, ACK into master_855
    master_855 = master_855[:7] + edi_855_body + master_855[7:]

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
    master_855 = [segment for segment in master_855 if not edi_curascript_create_855_856_810.is_empty_segment(segment)]
    segments_count = len(master_855[2:-2])
    se[1] = str(segments_count)
    master_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(master_855)

def create_edi_856_mckessonsh(parsed_850_data):
    edi_856 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[6], isa[8] = isa[8], isa[6]
    edi_856.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'SH'
    gs[2], gs[3] = gs[3], gs[2]
    edi_856.append(f"{'*'.join(gs)}~")

    # ST segment
    st = parsed_850_data['ST'][0]
    st[1] = '856'
    edi_856.append(f"{'*'.join(st)}~")

    # BSN Segment
    beg = parsed_850_data['BEG'][0]
    bsn = ['BSN', '00', '475621989001', beg[5], '0000', '0001', 'AS']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S*1~")

    # N1 Segment
    edi_856.append("N1*SF*McKesson Specialty Health - LaVergne*92~")

    n1 = parsed_850_data['N1'][0]
    edi_856.append(f"{'*'.join(n1)}~")

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    edi_856.append(f'PRF*{beg[3]}~')

    # REF Segment
    edi_856.append('REF*SW*4010459759~')

    edi_856.append('REF*ZZ*UNKNOWN~')

    # HL Segment
    edi_856.append('HL*3*2*I*0~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # LIN Segment
        lin = ['LIN', str(index + 1), po1[8], po1[9], 'LT', '1255210']
        edi_856.append(f"{'*'.join(lin)}~")

        # SN1 Segment
        sn1 = ['SN1', str(index + 1), po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # TD5 Segment
        edi_856.append('TD5*****FedEx Priority Alert~')

        # REF Segment
        edi_856.append('REF*CN*723913863582~')

        # DTM Segment
        edi_856.append('DTM*036*20260430~')

    # CTT Segment
    total_items = len(po1_segments)
    edi_856.append(f"CTT*{total_items}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_856.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    edi_856.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    edi_856.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_edi_810_mckessonsh(parsed_850_data):
    edi_810 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[6], isa[8] = isa[8], isa[6]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'IN'
    gs[2], gs[3] = gs[3], gs[2]
    edi_810.append(f"{'*'.join(gs)}~")

    # ST segment
    st = parsed_850_data['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BSN Segment
    beg = parsed_850_data['BEG'][0]
    big  = ['BIG', gs[4], '0336659428', gs[4], beg[3], '', '', 'DO']
    edi_810.append(f"{'*'.join(big)}~")

    # REF Segment
    edi_810.append('REF*SW*4010459759~')

    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    edi_810.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_810.append(f"{'*'.join(n3)}~")

    # N4 Segment
    n4 = parsed_850_data['N4'][0]
    edi_810.append(f"{'*'.join(n4)}~")

    # N1 Segment
    edi_810.append('N1*RE*McKesson Specialty Care Dist.*11*RM0546056~')

    # N3 Segment
    edi_810.append('N3*15212 Collections Center Drive~')

    # N4 Segment
    edi_810.append('N4*Chicago*IL*60693~')

    # ITD Segment
    edi_810.append('ITD*01*3*2*20241202*90~')

    # DTM Segment
    edi_810.append('DTM*011*20240903~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        it1 = ['IT1', str(index + 1), '1', 'EA', po1[4], '', 'N4', po1[9]]
        edi_810.append(f"{'*'.join(it1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

        # SLNSegment        
        edi_810.append('SLN*1**O*1*EA****LT*1255210~')

        # DTM Segment
        edi_810.append('DTM*208*20260430~')

    # TDS Segment
    edi_810.append('TDS*867347~')

    # SAC Segment
    edi_810.append('SAC*C*ZXTO***17347~')

    # CTT Segment
    total_items = len(po1_segments)
    edi_810.append(f"CTT*{total_items}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)


