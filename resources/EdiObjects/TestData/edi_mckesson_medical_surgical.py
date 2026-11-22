from decimal import Decimal
import edi_cencora_besse_create_message
import os

def isa_segment(parsed_850_data):
    isa_seg = []

    isa = parsed_850_data['ISA'][0]
    isa[5], isa[7] = isa[7], isa[5]
    isa[6], isa[8] = isa[8], isa[6]
    isa_seg.append(f"{'*'.join(isa)}~")

    return isa_seg

def ge_iea_segment(parsed_850_data):
    ge_iea_seg = []

    ge = parsed_850_data['GE'][0]
    ge_iea_seg.append(f"{'*'.join(ge)}~")

    iea = parsed_850_data['IEA'][0]
    ge_iea_seg.append(f"{'*'.join(iea)}~")

    return ge_iea_seg

def create_855_McKesson_Medical_Surgical(parsed_850_data):
    edi_855 = []

    # ISA Segment
    edi_855.extend(isa_segment(parsed_850_data))

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'PR'
    gs[2], gs[3] = gs[3], gs[2]
    edi_855.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = '855'
    edi_855.append(f"{'*'.join(st)}~")

    # BAK Segment
    beg = parsed_850_data['BEG'][0]
    edi_855.append(f"BAK*06*AC*{beg[3]}*{beg[5]}****34047181*{beg[5]}~")

    # N1 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_850_data)
    edi_855.append(f"{'*'.join(n1)}~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # PO1 Segment
        edi_855.append(f"PO1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**IN*{po1[7]}*ND*{po1[9]}*VC*{po1[7]}~")

        # PID Segment match PO1
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_855.append(f"{'*'.join(pid)}~")

        # ACK Segment        
        edi_855.append(f'ACK*IA*{po1[2]}*{po1[3]}~')

    # CTT Segment
    total_items = len(po1_segments)
    edi_855.append(f"CTT*{total_items}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_855.append(f"{'*'.join(se)}~")

    # GE, IEA Segment
    edi_855.extend(ge_iea_segment(parsed_850_data))

    segments_count = len(edi_855[2:-2])
    se[1] = str(segments_count)
    edi_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_855)

def create_856_McKesson_Medical_Surgical(parsed_850_data):
    edi_856 = []

    # ISA Segment
    edi_856.extend(isa_segment(parsed_850_data))

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'SH'
    gs[2], gs[3] = gs[3], gs[2]
    edi_856.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = '856'
    edi_856.append(f"{'*'.join(st)}~")

    # BSN Segment
    edi_856.append(f"BSN*00*48385877*{gs[4]}*063126*0001*SH~")

    # DTM Segment
    edi_856.append(f"DTM*009*{gs[4]}*063126~")

    # HL Segment
    edi_856.append(f"HL*1**S*1~")

    # TD5 Segment
    edi_856.append(f"TD5**2*UGRN**UPS GROUND*SH~")

    # DTM Segment
    edi_856.append(f"DTM*011*20240404~")
    edi_856.append(f"DTM*067*20240404~")

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_850_data)
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append(f"N3*11002 VEIRS MILL RD STE 414*11002 VEIRS MILL RD STE 414~")
    edi_856.append(f"N4*SILVER SPRING*MD*20902-5919~")

    # N1*BY, N3, N4 Segment
    edi_856.append(f"N1*BY*INSTITUTE FOR ASTHMA & ALLERGY*91*157352~")
    edi_856.append(f"N3*11002 VEIRS MILL RD #414*11002 VEIRS MILL RD #414~")
    edi_856.append(f"N4*SILVER SPRING*MD*20902~")

    # N1*SF, N3, N4 Segment
    edi_856.append(f"N1*SF*MCKESSON MEDICAL SURGICAL*91*4006411~")
    edi_856.append(f"N3*9954 MAYLAND DRIVE~")
    edi_856.append(f"N4*RICHMOND*VA*23233~")

    # N1*SE, N2, N4 Segment
    edi_856.append(f"N1*SE*MCKESSON MEDICAL SURGICAL*91*4006411~")
    edi_856.append(f"N3*9954 MAYLAND DRIVE~")
    edi_856.append(f"N4*RICHMOND*VA*23233~")

    # HL Segment
    edi_856.append(f"HL*2*1*O*1~")

    # PRF Segment
    beg = parsed_850_data['BEG'][0]
    edi_856.append(f"PRF*{beg[3]}***{beg[5]}~")
    
    # REF Segment
    edi_856.append(f"REF*VN*19152908*SO~")

    # DTM Segment
    edi_856.append(f"DTM*003*{gs[4]}~")

    # HL Segment
    edi_856.append(f"HL*3*2*P*1~")

    # MAN Segment
    edi_856.append(f"MAN*GM*1Z88W8R40351122563~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 3}*2*I*0~')

        # LIN Segment
        lin = ['LIN', str(index + 1), 'VC', po1[11], 'MG', po1[9], 'LT', 'K347A8141']
        edi_856.append(f"{'*'.join(lin)}~")

        # PID Segment
        sn1 = ['SN1', str(index + 1), po1[2], po1[3], '', po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")
    # CTT Segment
    total_items = len(po1_segments)
    edi_856.append(f"CTT*{total_items}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_856.append(f"{'*'.join(se)}~")

    # GE, IEA Segment
    edi_856.extend(ge_iea_segment(parsed_850_data))

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_810_McKesson_Medical_Surgical(parsed_850_data):
    edi_810 = []

    # ISA Segment
    edi_810.extend(isa_segment(parsed_850_data))

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'IN'
    gs[2], gs[3] = gs[3], gs[2]
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_850_data['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    beg = parsed_850_data['BEG'][0]
    edi_810.append(f"BIG*{gs[4]}*65866255**{beg[3]}***DI~")

    # N1*BT Segment
    edi_810.append(f"N1*BT*MULTISPECIALTY PHYSICIAN PARTNERS LLC*91*60979592~")

    # N1*RE, N3, N4 Segment
    edi_810.append(f"N1*RE*MCKESSON MEDICAL SURGICAL*91*MCKESSON~")
    edi_810.append(f"N3*PO BOX 660266~")
    edi_810.append(f"N4*DALLAS*TX*75266-0266~")

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_850_data)
    edi_810.append(f"{'*'.join(n1)}~")
    edi_810.append(f"N3*116 MILLBURN AVE STE 108~")
    edi_810.append(f"N4*MILLBURN*NJ*07041-1919~")

    # ITD Segment
    edi_810.append(f"ITD*01*3*****30~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    po_total = Decimal('0.0')
    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*{index+1}*{po1[2]}*{po1[3]}*{po1[4]}**VC*{po1[7]}*{po1[8]}*{po1[9]}*LT*K347A8141~')
        po_total += Decimal(po1[2]) * Decimal(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            pid[3] = 'ZZ'
            edi_810.append(f"{'*'.join(pid)}~")

    # TDS Segment
    po_total = str(po_total).replace('.', '')
    edi_810.append(f'TDS*{po_total}~')

    # TXI Segment
    edi_810.append(f"TXI*ZZ*5.24~")

    # SAC Segment
    edi_810.append(f"SAC*C*D240*AX*DL*167**********FUEL SURCHARGE~")

    # CTT Segment
    total_items = len(po1_segments)
    edi_810.append(f"CTT*{total_items}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE, IEA Segment
    edi_810.extend(ge_iea_segment(parsed_850_data))

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)

def update_po():
    exec_dir = os.getcwd()
    file_path = os.path.join(exec_dir, "tests", "edi", "PONumber.txt")
    with open(file_path, 'r') as file:
        po_number = file.read()
    return po_number

def replace_po(edi_message):
    edi_message = edi_message.replace('\n', '').strip()

    new_po = update_po()

    segments = edi_message.split('~')

    for i, segment in enumerate(segments):
        parts = segment.strip().split('*')
        if parts[0] == 'BIG':
            if len(parts) > 4:
                parts[4] = new_po
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PRF':
            if len(parts) > 1:
                parts[1] = new_po
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)
    return new_edi_message