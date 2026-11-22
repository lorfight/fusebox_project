import edi_curascript_create_855_856_810

def create_855_biocaresd(parsed_850_data):
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
    bak = ['BAK', '06', 'AC', beg[3], beg[5]]
    edi_855.append(f"{'*'.join(bak)}~")

    # DTM Segment
    edi_855.append(f"DTM*002*{beg[5]}~")

    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    n1[3] = '21'
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
        po1[6] = 'VC'
        po1[7], po1[9] = po1[9], po1[7]
        po1[8] = 'N4'
        edi_855.append(f"{'*'.join(po1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_855.append(f"{'*'.join(pid)}~")

        # REF Segment
        edi_855.append(f"REF*CO*000020~")

        # ACK Segment        
        edi_855.append(f'ACK*IA*{po1[2]}*{po1[3]}~')

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

def create_856_biocaresd(parsed_850_data):
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
    bsn = ['BSN', '00', '0080012154', beg[5], '200326', '0001']
    edi_856.append(f"{'*'.join(bsn)}~")

    # HL Segment
    edi_856.append("HL*1**S~")
    
    # TD5 Segment
    edi_856.append('TD5***FedEx~')

    # REF Segment
    edi_856.append('REF*2I*ABC001~')
    
    # DTM Segment
    edi_856.append(f'DTM*011*{beg[5]}~')
    
    # N1 Segment
    n1 = parsed_850_data['N1'][0]
    n1[3] = '92'
    edi_856.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_856.append(f"{'*'.join(n3)}~")

    # N4 Segment
    n4 = parsed_850_data['N4'][0]
    edi_856.append(f"{'*'.join(n4)}~")

    # REF Segment
    edi_856.append(f'REF*11*{n1[4]}~')

    # HL Segment
    edi_856.append('HL*2*1*O~')

    # PRF Segment
    edi_856.append(f'PRF*{beg[3]}***{beg[5]}~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # HL Segment
        edi_856.append(f'HL*{index + 3}*2*I~')

        # LIN Segment
        lin = ['LIN', str(index + 1), 'ND', po1[7], 'VC', po1[9], '', '', 'LT', 'K347A8141']
        edi_856.append(f"{'*'.join(lin)}~")

        # SN1 Segment
        sn1 = ['SN1', str(index + 1), po1[2], po1[3]]
        edi_856.append(f"{'*'.join(sn1)}~")

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_856.append(f"{'*'.join(pid)}~")

        # DTM Segment
        edi_856.append('DTM*208*20260731~')

        # YNQ Segment
        edi_856.append('YNQ**Y******99*DIR~')

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

def create_810_biocaresd(parsed_850_data):
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
    edi_810.append(f'BIG*{beg[5]}*90047704*{beg[5]}*{beg[3]}***DI*00~')

    # REF Segment
    n1 = parsed_850_data['N1'][0]
    edi_810.append(f"REF*AP*{n1[4]}~")

    # N1 Segment
    n1[3] = '92'
    edi_810.append(f"{'*'.join(n1)}~")

    # N3 Segment
    n3 = parsed_850_data['N3'][0]
    edi_810.append(f"{'*'.join(n3)}~")

    # N4 Segment
    n4 = parsed_850_data['N4'][0]
    edi_810.append(f"{'*'.join(n4)}~")

    # ITD Segment
    edi_810.append('ITD**3****20250203*90*****Net Due in 90 Days~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*000010*{po1[2]}*{po1[3]}*{po1[4]}**VC*{po1[9]}*N4*{po1[7]}~')

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

        # REF Segment
        edi_810.append(f"REF*CO*000010~")
        edi_810.append(f"REF*LT*237466~")

        # DTM Segment
        edi_810.append(f"DTM*208*20270430~")


    # TDS Segment
    edi_810.append(f'TDS*17256280~')

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
