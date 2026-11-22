from decimal import Decimal
import edi_curascript_create_855_856_810

def get_n1_with_st(parsed_850_data):
    if 'N1' in parsed_850_data:
        for n1_segment in parsed_850_data['N1']:
            if n1_segment[1] == 'ST':
                return n1_segment
    return None

def create_header_message(parsed_850_data):
    header = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[5], isa[7] = isa[7], isa[5]
    isa[6], isa[8] = isa[8], isa[6]
    header.append(f"{'*'.join(isa)}~")

    return header

def create_footer_message(parsed_850_data):
    footer = []

    # SE Segment
    se = parsed_850_data['SE'][0]
    footer.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    footer.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    footer.append(f"{'*'.join(iea)}~")

    return footer

def create_855_cencora_besse(parsed_850_data):
    edi_855 = []

    # Header message: ISA Segment
    edi_855.extend(create_header_message(parsed_850_data))

    # GS Segment
    gs = parsed_850_data['GS'][0]
    gs[1] = 'PR'
    gs[2], gs[3] = gs[3], gs[2]
    edi_855.append(f"{'*'.join(gs)}~")

    # ST segment
    st = parsed_850_data['ST'][0]
    st[1] = '855'
    edi_855.append(f"{'*'.join(st)}~")

    # BAK Segment
    beg = parsed_850_data['BEG'][0]
    bak = ['BAK', '06', 'AC', beg[3], beg[5], '', '', '', '', beg[5]]
    edi_855.append(f"{'*'.join(bak)}~")

    # N1 Segment
    n1 = get_n1_with_st(parsed_850_data)
    edi_855.append(f"{'*'.join(n1)}~")
    edi_855.append(f"N1*SE*AMERISOURCEBERGEN*91*{parsed_850_data['GS'][0][2]}~")

    po1_segments = parsed_850_data.get('PO1', [])

    for index, po1 in enumerate(po1_segments):
        # PO1 Segment
        edi_855.append(f"PO1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**VN*{po1[7]}*N4*{po1[9]}~")

        # ACK Segment        
        edi_855.append(f"ACK*IA*{po1[2]}*{po1[3]}****VN*{po1[7]}*N4*{po1[9]}~")

    # CTT Segment
    total_items = len(po1_segments)
    edi_855.append(f"CTT*{total_items}~")

    # Footer message: SE, GE, IEA Segment
    edi_855.extend(create_footer_message(parsed_850_data))

    segments_count = len(edi_855[2:-2])
    se = parsed_850_data['SE'][0]
    se[1] = str(segments_count)
    edi_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_855)

def create_856_cencora_besse(parsed_850_data):
    edi_856 = []

    # Header message: ISA Segment
    edi_856.extend(create_header_message(parsed_850_data))

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
    beg = parsed_850_data['BEG'][0]
    edi_856.append(f"BSN*00*7168021636*{beg[5]}*1630*0004*AS~")

    # HL Segment
    edi_856.append(f"HL*1**S*1~")

    # TD1 Segment
    edi_856.append(f"TD1*CTN*1****G*10*LB~")

    # TD5 Segment
    edi_856.append(f"TD5*O*2*UPS Next Day Air*M~")

    # REF Segment
    edi_856.append(f"REF*BM*3187999609~")
    n1 = get_n1_with_st(parsed_850_data)
    edi_856.append(f"REF*11*{n1[4]}~")

    # DTM Segment
    edi_856.append(f"DTM*011*{beg[5]}~")
    edi_856.append(f"DTM*017*{beg[5]}~")

    # N1*ST, N3, N4 Segment
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append(f"N3*2305 CAMINO RAMON STE 225~")
    edi_856.append(f"N4*SAN RAMON*CA*945831394*US~")

    # N1*BY , N3, N4 Segment
    edi_856.append(f"N1*BY*ALLERGY & ASTHMA MEDICAL GROUP*21*{n1[4]}~")
    edi_856.append(f"N3*2305 CAMINO RAMON STE 225~")
    edi_856.append(f"N4*SAN RAMON*CA*945831394*US~")

    # N1*SF , N3, N4 Segment
    edi_856.append(f"N1*SF*MONTCLAIR D&S*11*RA0626183~")
    edi_856.append(f"N3*5566 ARROW HWY~")
    edi_856.append(f"N4*Montclair*CA*91763*US~")

    # N1*SE , N3, N4 Segment
    edi_856.append(f"N1*SE*CENCORA INC*1*006906614~")
    edi_856.append(f"N3*1 WEST FIRST AVE~")
    edi_856.append(f"N4*Conshohocken*PA*19428*US~")

    # YNQ Segment
    edi_856.append(f"YNQ**Y***Cencora Inc has complied with each applicable subsection of FDCA Sec. 581 (27) (A)-(G).***99*TS~")
    edi_856.append(f"YNQ**Y***This wholesale distributor, or a member of the affiliate of such wholesale distributor, purchased the product directly from the manufacturer, exclusive distributor of the manufacturer, or repackage that purchased the product directly from the manufacturer.***99*DPS~")
    
    # HL Segment
    edi_856.append(f"HL*2*1*O*1~")

    # PRF Segment
    edi_856.append(f"PRF*{beg[3]}***{beg[5]}~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 3}*2*I*0~')

        # LIN Segment
        lin = ['LIN', str(index + 1), 'UI', po1[9], '', '', 'VN', po1[7], 'LT', '3607563']
        edi_856.append(f"{'*'.join(lin)}~")

        # PID Segment
        sn1 = ['SN1', str(index + 1), po1[2], po1[3], po1[2], po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # REF Segment
        edi_856.append(f"REF*IV*3187999609~")
        edi_856.append(f"REF*BM*1Z08YW032498579305~")

        # MAN Segment
        edi_856.append(f"MAN*GM*00007161630016076028~")

        # DTM Segment
        edi_856.append('DTM*208*20250731~')

    # N1*MF, N3, N4 Segment
    edi_856.append(f"N1*MF*GENENTECH USA, INC~")
    edi_856.append(f"N3*1 DNA WAY~")
    edi_856.append(f"N4*SOUTH SAN FRANCISCO*CA*940804918*US~")

    # YNQ Segment
    edi_856.append(f"YNQ**Y******99*DIR~")

    # CTT Segment
    total_items = len(po1_segments)
    edi_856.append(f"CTT*{total_items}~")

    # Footer message: SE, GE, IEA Segment
    edi_856.extend(create_footer_message(parsed_850_data))

    segments_count = len(edi_856[2:-2])
    se = parsed_850_data['SE'][0]
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_810_cencora_besse(parsed_850_data):
    edi_810 = []

    # Header message: ISA Segment
    edi_810.extend(create_header_message(parsed_850_data))

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
    edi_810.append(f'BIG*{beg[5]}*3187999609**{beg[3]}***PR~')

    # N1, N3, N4 Segment
    edi_810.append(f'N1*RE*AMERISOURCEBERGEN*11*RA0626183~')
    edi_810.append(f'N3*PO BOX 100741~')
    edi_810.append(f'N4*PASADENA*CA*91189~')

    # PER Segment
    edi_810.append('PER*CR**TE*1-502-955-3600~')

    # N1 Segment
    n1 = get_n1_with_st(parsed_850_data)
    n1[3] = '21'
    edi_810.append(f"{'*'.join(n1)}~")

    # N3 Segment
    edi_810.append(f"N3*2305 CAMINO RAMON STE 225~")

    # N4 Segment
    edi_810.append(f"N4*SAN RAMON*CA*94583~")

    # REF Segment
    edi_810.append(f"REF*IT*{n1[4]}~")

    # ITD Segment
    edi_810.append('ITD*05*3****20241209~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    po_total = Decimal('0.0')
    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*{index+1}*{po1[2]}*{po1[3]}*{po1[4]}**ND*{po1[9]}*VN*{po1[7]}*IN*{po1[7]}*ND*{po1[9]}***LT*3607563~')
        po_total += Decimal(po1[2]) * Decimal(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            pid[3] = 'ZZ'
            edi_810.append(f"{'*'.join(pid)}~")

        # DTM Segment
        edi_810.append(f"DTM*208*20250731~")

    # TDS Segment
    po_total = str(po_total).replace('.', '')
    edi_810.append(f'TDS*{po_total}~')

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