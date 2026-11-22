import edi_curascript_create_855_856_810

def create_855_medline(parsed_850_data):
    edi_855 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[5], isa[7] = isa[7], isa[5]
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
    edi_855.append(f"BAK*06*AD*{beg[3]}*{beg[5]}****11042472002*{beg[5]}~")

    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    edi_855.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_855.append(f"{'*'.join(n3)}~")

    # N4 Segment
    n4 = parsed_850_data['N4'][0]
    edi_855.append(f"{'*'.join(n4)}~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # PO1 Segment
        edi_855.append(f"PO1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**VC*{po1[7]}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_855.append(f"{'*'.join(pid)}~")

        # ACK Segment        
        edi_855.append(f'ACK*IA*{po1[2]}*{po1[3]}*068*{beg[5]}~')

    # CTT Segment
    total_items = len(po1_segments)
    edi_855.append(f"CTT*{total_items}~")

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

def create_856_medline(parsed_850_data):
    edi_856 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[5], isa[7] = isa[7], isa[5]
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
    bsn = ['BSN', '00', '8232216021', beg[5], '0723']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1*0*S~")
    
    # TD5 Segment
    edi_856.append('TD5**2*FDXG**FEDEX GROUND~')

    # REF Segment
    edi_856.append('REF*2I*ABC001~')
    
    # DTM Segment
    edi_856.append(f'DTM*011*{beg[5]}~')
    
    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    n1[2] = ''
    n1[3] = '92'
    edi_856.append(f"{'*'.join(n1)}~")
    edi_856.append(f"N1*BT**92*0001988416~")

    # HL Segment
    edi_856.append('HL*2*1*O~')

    # PRF Segment
    edi_856.append(f'PRF*{beg[3]}***{beg[5]}~')

    # REF Segment
    edi_856.append(f"REF*BM*00000001000~")
    edi_856.append(f"REF*CN*437756752279~")
    edi_856.append(f"REF*VN*0770963330~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 3}*2*I~')

        # LIN Segment
        lin = ['LIN', str(index + 1), 'VC', po1[7], '', '', 'LT', 'K347A8141']
        edi_856.append(f"{'*'.join(lin)}~")

        # SN1 Segment
        sn1 = ['SN1', '', po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # DTM Segment
        edi_856.append('DTM*036*20260731~')

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

def create_810_medline(parsed_850_data):
    edi_810 = []

    # ISA Segment
    isa = parsed_850_data['ISA'][0]
    isa[5], isa[7] = isa[7], isa[5]
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
    edi_810.append(f'BIG*{beg[5]}*2333539706*{beg[5]}*{beg[3]}***DI~')

    # REF Segment
    n1 = parsed_850_data['N1'][0]
    edi_810.append(f"N1*ST*HORIZON INFUSIONS - AKRON*91*{n1[4]}~")

    # N3 Segment
    edi_810.append(f"N3*51 PARK WEST BLVD STE 100~")

    # N4 Segment
    edi_810.append(f"N4*AKRON*OH*44320~")

    # ITD Segment
    edi_810.append('ITD*03*3*****30*****Up to 02/28/2025 without deduction~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*000010*{po1[2]}*{po1[3]}*{po1[4]}**VC*{po1[7]}~')

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

    # TDS Segment
    edi_810.append(f'TDS*209514~')

    # TXI Segment
    edi_810.append('TXI*LS*7.91~')

    # SAC Segment
    edi_810.append('SAC*C*D240***LKIUPOUTRKGG**********Shipping and Handling~')

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