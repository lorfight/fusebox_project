import edi_curascript_create_855_856_810

def create_855_takeda(parsed_850_data):
    edi_855 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    if len(isa) >= 9:
        isa[6], isa[8] = isa[8], isa[6]
    edi_855.append(f"{'*'.join(isa)}~")
    
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
    bak = ['BAK', '06', 'AH', beg[3], beg[5], '', '', '', '0212750707', beg[5]]
    edi_855.append(f"{'*'.join(bak)}~")

    # N9 Segment
    edi_855.append(f"N9*PO*{beg[3]}~")

    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    edi_855.append(f"{'*'.join(n1)}~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # PO1 Segment
        po1[6] = 'VC'
        po1[8] = 'N4'
        po1[10] = 'IN'
        po1[11] = po1[9] if len(po1) > 9 else ''
        edi_855.append(f"{'*'.join(po1)}~")

        # PID Segment - tương ứng với PO1
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_855.append(f"{'*'.join(pid)}~")

        # ACK Segment        
        edi_855.append(f'ACK*IA*{po1[2]}*{po1[3]}~')

    # N9 Segment
    edi_855.append(f'N9*BV*1~')

    # N1 Segment
    edi_855.append(f'N1*WH**91*7866~')

    # CTT Segment
    total_items = len(po1_segments)
    edi_855.append(f"CTT*{total_items}~")

    # AMT Segment
    edi_855.append(f'AMT*B*4490.11~')

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_855.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    edi_855.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    edi_855.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_855[2:-2])
    se[1] = str(segments_count)
    edi_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_855)

def create_856_takeda(parsed_850_data):
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
    bsn = ['BSN', '00', '5012087281', beg[5], '2126', '0004', 'AS']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S*1~")

    # TD1 Segment
    edi_856.append("TD1*CTN*3~")

    # TD5 Segment
    edi_856.append("TD5*O*2*00*M*UPS*CC~")

    # REF Segment
    edi_856.append('REF*CN*1Z093EV20170007611~')

    # DTM Segment
    edi_856.append(f'DTM*011*{beg[5]}~')
    edi_856.append(f'DTM*017*{beg[5]}~')
    
    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    n1[3] = '91'
    edi_856.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_856.append(f"{'*'.join(n3)}~")

    # N4 Segment
    edi_856.append('N4*CINCINNATI*OH*45211~')

    # N1 Segment
    edi_856.append('N1*BY*HORIZON INFUSION LLC*91*386890~')

    # N3 Segment
    edi_856.append('N3*5177 N BEND RD STE 2~')

    # N4 Segment
    edi_856.append('N4*CINCINNATI*OH*45211~')

    # N1 Segment
    edi_856.append('N1*SF*RxCrossroads*11*BR9439096~')

    # N3 Segment
    edi_856.append('N3*5101 Jeff Commerce Drive~')

    # N4 Segment
    edi_856.append('N4*Louisville*KY*40219~')

    # YNQ Segment
    edi_856.append('YNQ**Y***Seller has complied with each applicable subsection of FDCA Sec. 581(27)(A)-(G)***99*TS~')

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    edi_856.append(f'PRF*{beg[3]}***{beg[5]}~')

    # REF Segment
    edi_856.append('REF*VN*0212750707~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 3}*2*I*0~')

        # LIN Segment
        lin = ['LIN', str(index + 1), 'N4', po1[9], 'LT', 'BE12E178AB']
        edi_856.append(f"{'*'.join(lin)}~")

        # PID Segment
        sn1 = ['SN1', str(index + 1), po1[2], po1[3], '', po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # DTM Segment
        edi_856.append('DTM*208*20270605~')

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

def create_810_takeda(parsed_850_data):
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

    # BIG Segment
    beg = parsed_850_data['BEG'][0]
    edi_810.append(f'BIG*{beg[5]}*0099439157*{beg[5]}*{beg[3]}*0000000356036517**DO~')

    # NTE Segment
    edi_810.append(f'NTE*ADD*Products listed on this invoice that are required by the PPPA to be in~')
    edi_810.append(f'NTE*ADD* CR (child resistant) packaging comply with CPSC CR standards.~')
    edi_810.append(f'NTE*ADD*For General Certificate of Conformance see www.takeda.com/CPSIA~')

    # REF Segment
    edi_810.append('REF*SW*0212750707~')

    # N1 Segment
    edi_810.append('N1*RE*Takeda Pharmaceuticals America, Inc.*21*9E0DJP800~')

    # N2 Segment
    edi_810.append('N2*28499 Network Place~')

    # N4 Segment
    edi_810.append('N4*Chicago*IL*60673~')

    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    n1[3] = '91'
    edi_810.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_810.append(f"{'*'.join(n3)}~")

    # N4 Segment
    edi_810.append('N4*CINCINNATI*OH*45211~')

    # N1 Segment
    n12 = parsed_850_data['N1'][1]
    n12[3] = '91'
    edi_810.append(f"{'*'.join(n12)}~")

    # N3 Segment
    edi_810.append('N3*4260 GLENDALE MILFORD RD~')

    # N4 Segment
    edi_810.append('N4*CINCINNATI*OH*45211~')

    # ITD Segment
    edi_810.append('ITD*03*3*2*20241014*25*20241103*45*6~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*000011*{po1[2]}*{po1[3]}*{po1[4]}**N4*{po1[9]}~')

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            pid[2] = '08'
            edi_810.append(f"{'*'.join(pid)}~")

    # TDS Segment
    edi_810.append(f'TDS*449011*449011*442276*449011~')

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
