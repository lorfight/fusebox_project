import edi_cencora_besse_create_message
import edi_curascript_create_855_856_810

def create_fff_855(parsed_850_data):
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
    edi_855.append(f"BAK*00*AD*{beg[3]}*{beg[5]}~")

    # REF Segment, Confirmation Number
    edi_855.append(f"REF*IL*1001938849~")

    # DTM Segment
    edi_855.append(f"DTM*002*20250330~")

    # N1*VN segment
    edi_855.append(f"N1*VN*FFF Enterprises*92*45303~")

    # N1*ST, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_850_data)
    n1[3] = '92'
    edi_855.append(f"{'*'.join(n1)}~")
    edi_855.append(f"N3*202 Birch St*Unit 5~")
    edi_855.append(f"N4*Denver*CO*20815*US~")

    # N1*BT, N3, N4 Segment
    edi_855.append(f"N1*BT*Test Account 2*92*{n1[4]}~")
    edi_855.append(f"N3*202 Birch St*Unit 5~")
    edi_855.append(f"N4*Denver*CO*20815*US~")

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    total_price = 0.00

    for index, po1 in enumerate(po1_segments):
        # PO1 Segment
        po17, po19 = po1[7], po1[9]
        po1[6] = 'N4'
        po1[7] = po19
        po1[8] = 'VN'
        po1[9] = po17
        edi_855.append(f"{'*'.join(po1)}~")

        total_price += float(po1[2]) * float(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_855.append(f"{'*'.join(pid)}~")

        # ACK Segment        
        edi_855.append(f"ACK*IA*{po1[2]}*{po1[3]}*017*{beg[5]}**VN*{po17}*N4*{po19}~")

    # CTT Segment
    total_items = len(po1_segments)
    edi_855.append(f"CTT*{total_items}~")

    # AMT Segment, Total Price
    edi_855.append(f"AMT*GV*{total_price:.2f}~")

    # SE Segment
    se = parsed_850_data['SE'][0]
    edi_855.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_850_data['GE'][0]
    edi_855.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_850_data['IEA'][0]
    edi_855.append(f"{'*'.join(iea)}")

    segments_count = len(edi_855[2:-2])
    se[1] = str(segments_count)
    edi_855[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_855)

def create_fff_856(parsed_850_data):
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
    edi_856.append("N1*SF*FFF Enterprises*92*45303~")

    n1 = parsed_850_data['N1'][0]
    edi_856.append(f"{'*'.join(n1)}~")

    # HL Segment
    edi_856.append('HL*2*1*O*1~')

    # PRF Segment
    edi_856.append(f'PRF*{beg[3]}~')

    # REF Segment
    edi_856.append('REF*SW*4010459759~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])

    for index, po1 in enumerate(po1_segments):
            # HL Segment
        edi_856.append(f'HL*{3 + index}*2*I*0~')

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
    edi_856.append(f"{'*'.join(iea)}")

    segments_count = len(edi_856[2:-2])
    se[1] = str(segments_count)
    edi_856[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_856)

def create_fff_810(parsed_850_data):
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
    edi_810.append(f'BIG*{beg[5]}*0091740221*{beg[5]}*{beg[3]}***DI~')

    # PER Segment
    edi_810.append(f'PER*AR*Angela Morgan*TE*1-800-843-7477~')

    # N1*BT, N3, N4 Segment
    n1 = edi_cencora_besse_create_message.get_n1_with_st(parsed_850_data)
    edi_810.append(f"N1*BT*Test Account 2*92*{n1[4]}~")
    edi_810.append(f"N3*202 Birch St*Unit 5~")
    edi_810.append(f"N4*Denver*CO*20815*US~")

    # N1*ST, N3, N4 Segment
    n1[3] = '92'
    edi_810.append(f"{'*'.join(n1)}~")
    edi_810.append(f"N3*202 Birch St*Unit 5~")
    edi_810.append(f"N4*Denver*CO*20815*US~")

    # N1*RE, N3, N4 Segment
    edi_810.append(f"N1*RE*FFF Enterprises~")
    edi_810.append(f"N3*DEPT 70150~")
    edi_810.append(f"N4*LOS ANGELES*CA*90084 0150~")

    # ITD Segment
    edi_810.append(f'ITD*01*3*.25*{beg[5]}**{beg[5]}******0.25% 20 DAYS Due 30 DAYS~')

    # DTM Segment
    edi_810.append(f'DTM*011*{beg[5]}~')

    po1_segments = parsed_850_data.get('PO1', [])
    pid_segments = parsed_850_data.get('PID', [])
    total = 0.00

    for index, po1 in enumerate(po1_segments):
        # IT1 Segment
        edi_810.append(f'IT1*{index + 1}*{po1[2]}*{po1[3]}*{po1[4]}**VP*{po1[7]}*N4*{po1[9]}~')

        total += float(po1[2]) * float(po1[4])

        # PID Segment
        if index < len(pid_segments):
            pid = pid_segments[index]
            edi_810.append(f"{'*'.join(pid)}~")

        # SAC Segment
        edi_810.append(f"SAC*A*C310***24524~")

        # SLN Segment
        edi_810.append(f"SLN*1**O*{po1[2]}*{po1[3]}****LT*C22G115AAA~")

    # TDS Segment
    total = str(total).replace('.', '')
    edi_810.append(f'TDS*{total}*{total}*{total}*{total}~')

    # SAC Segment
    edi_810.append(f"SAC*C*G740***0*******06***External Shipping~")

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
    edi_810.append(f"{'*'.join(iea)}")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"
    
    return '\n'.join(edi_810)