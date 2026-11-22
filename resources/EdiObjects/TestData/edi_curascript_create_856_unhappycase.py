from datetime import datetime
from decimal import Decimal
import os
import edi_curascript_create_855_856_810_unhappycase
import edi_curascript_create_855_856_810
import edi_mckessonsh_create_message
import edi_callggsheetapi

def get_output_path(edi_po_number):
    exec_dir = os.getcwd()
    return os.path.join(exec_dir, "tests", "edi", "message_ui", f"{edi_po_number}_856.txt")

def update_edi_856(env, row_key, column_key):
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
        elif parts[0] == 'BSN':
            if len(parts) > 3:
                parts[3] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'DTM' and len(parts) > 1 and parts[1] == '011':
            if len(parts) > 2:
                parts[2] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PRF':
            if len(parts) > 4:
                parts[1] = edi_po_number
                parts[4] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

    print(f"EDI message has been updated and saved to {output_path}")

def create_856_receiveid_incorrect(env, row_key, column_key):
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
                parts[6] = "SENDERID       "
            if len(parts) > 9:
                parts[9] = current_date_ISA09
            if len(parts) > 10:
                parts[10] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'GS':
            if len(parts) > 2:
                parts[2] = "SENDERID"
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BSN':
            if len(parts) > 3:
                parts[3] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'DTM' and len(parts) > 1 and parts[1] == '011':
            if len(parts) > 2:
                parts[2] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PRF':
            if len(parts) > 4:
                parts[1] = edi_po_number
                parts[4] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

    print(f"EDI message has been updated and saved to {output_path}")

def create_856_receiveid_blank(env, row_key, column_key):
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
            if len(parts) > 2:
                parts[2] = "               "
            if len(parts) > 4:
                parts[4] = current_date
            if len(parts) > 5:
                parts[5] = current_time
            segments[i] = '*'.join(parts)
        elif parts[0] == 'BSN':
            if len(parts) > 3:
                parts[3] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'DTM' and len(parts) > 1 and parts[1] == '011':
            if len(parts) > 2:
                parts[2] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PRF':
            if len(parts) > 4:
                parts[1] = edi_po_number
                parts[4] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

    print(f"EDI message has been updated and saved to {output_path}")

def create_856_po_empty(env, row_key, column_key):
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
        elif parts[0] == 'BSN':
            if len(parts) > 3:
                parts[3] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'DTM' and len(parts) > 1 and parts[1] == '011':
            if len(parts) > 2:
                parts[2] = current_date
            segments[i] = '*'.join(parts)
        elif parts[0] == 'PRF':
            if len(parts) > 4:
                parts[1] = ""
                parts[4] = current_date
            segments[i] = '*'.join(parts)

    new_edi_message = '~\n'.join(segments)

    output_path = get_output_path(edi_po_number)
    with open(output_path, 'w') as file:
        file.write(new_edi_message)

    print(f"EDI message has been updated and saved to {output_path}")

def create_810_from_856(parsed_856):
    edi_810 = []

    # ISA Segment
    isa = parsed_856['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_856['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_856['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    prf = parsed_856['PRF'][0]
    edi_810.append(f"BIG*{gs[4]}*{isa[9]+isa[10]}*{gs[4]}*{prf[1]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    acctNo = edi_curascript_create_855_856_810.get_ref_value(parsed_856, '11')
    edi_810.append(f"REF*AP*{acctNo}~")
    edi_810.append(f"REF*CO*15381~")
    edi_810.append(f"REF*OI*{isa[9]+isa[10]}~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{acctNo}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"N1*ST*Test Account 2*91*{acctNo}~")
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
    edi_810.append(f"ITD*1*1*0**90*20251111**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*{gs[4]}~")
    edi_810.append(f"DTM*011*{gs[4]}~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")

    # IT1 Segment
    lin = parsed_856['LIN'][0]
    sn1 = parsed_856['SN1'][0]
    edi_810.append(f"IT1*1*{sn1[2]}*{sn1[3]}*150.00**ND*{lin[3]}*****UI*{lin[3]}*VC*{lin[5]}~")

    # PID Segment
    pid = parsed_856['PID'][0]
    edi_810.append(f"{'*'.join(pid)}~")

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*{lin[7]}~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # TDS Segment
    edi_810.append(f"TDS*15000*15000~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    lin_segments = parsed_856.get('LIN', [])
    ctt = parsed_856['CTT'][0]
    ctt[1] = str(len(lin_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_856['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_856['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_856['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"
    
    return '\n'.join(edi_810)

def create_810_with_856_diff_line_item(parsed_856):
    edi_810 = []

    # ISA Segment
    isa = parsed_856['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_856['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_856['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    prf = parsed_856['PRF'][0]
    edi_810.append(f"BIG*{gs[4]}*{isa[9]+isa[10]}*{gs[4]}*{prf[1]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*percentage rate of 18%. FOB: SHIPPING POINT~")

    # REF Segment
    acctNo = edi_curascript_create_855_856_810.get_ref_value(parsed_856, '11')
    edi_810.append(f"REF*AP*{acctNo}~")
    edi_810.append(f"REF*CO*15381~")
    edi_810.append(f"REF*OI*{isa[9]+isa[10]}~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{acctNo}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"N1*ST*Test Account 2*91*{acctNo}~")
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
    edi_810.append(f"ITD*1*1*0**90*20251111**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*{gs[4]}~")
    edi_810.append(f"DTM*011*{gs[4]}~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")

    # IT1 Segment
    edi_810.append(f"IT1*1*1*EA*150.00**ND*50242004062*****UI*50242004062*VC*10005726~")

    # PID Segment
    edi_810.append(f"PID*F****XOLAIR   150mg in a 14mL vial~")    

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*K347A8141~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # IT1 Segment
    edi_810.append(f"IT1*2*11*EA*4768.47**ND*00310173030*MF*00310173030*VN*00310173030***VC*274887~")

    # PID Segment
    edi_810.append(f"PID*F****FASENRA 30MG/ML PFS~")    

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*K347A8141~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # TDS Segment
    edi_810.append(f"TDS*15132*15132~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    lin_segments = parsed_856.get('LIN', [])
    ctt = parsed_856['CTT'][0]
    ctt[1] = str(len(lin_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_856['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_856['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_856['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"

    return '\n'.join(edi_810)

def create_810_diff_qty(parsed_856):
    edi_810 = []

    # ISA Segment
    isa = parsed_856['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_856['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_856['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    prf = parsed_856['PRF'][0]
    edi_810.append(f"BIG*{gs[4]}*{isa[9]+isa[10]}*{gs[4]}*{prf[1]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    acctNo = edi_curascript_create_855_856_810.get_ref_value(parsed_856, '11')
    edi_810.append(f"REF*AP*{acctNo}~")
    edi_810.append(f"REF*CO*15381~")
    edi_810.append(f"REF*OI*{isa[9]+isa[10]}~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{acctNo}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"N1*ST*Test Account 2*91*{acctNo}~")
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
    edi_810.append(f"ITD*1*1*0**90*20251111**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*{gs[4]}~")
    edi_810.append(f"DTM*011*{gs[4]}~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")

    # IT1 Segment
    lin = parsed_856['LIN'][0]
    sn1 = parsed_856['SN1'][0]
    edi_810.append(f"IT1*1*{int(sn1[2]) + 1}*{sn1[3]}*150.00**ND*{lin[3]}*****UI*{lin[3]}*VC*{lin[5]}~")

    # PID Segment
    pid = parsed_856['PID'][0]
    edi_810.append(f"{'*'.join(pid)}~")

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*{lin[7]}~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # TDS Segment
    edi_810.append(f"TDS*15000*15000~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    lin_segments = parsed_856.get('LIN', [])
    ctt = parsed_856['CTT'][0]
    ctt[1] = str(len(lin_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_856['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_856['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_856['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"
    
    return '\n'.join(edi_810)

def create_810_diff_price(parsed_856):
    edi_810 = []

    # ISA Segment
    isa = parsed_856['ISA'][0]
    edi_810.append(f"{'*'.join(isa)}~")

    # GS Segment
    gs = parsed_856['GS'][0]
    gs[1] = 'IN'
    edi_810.append(f"{'*'.join(gs)}~")

    # ST Segment
    st = parsed_856['ST'][0]
    st[1] = '810'
    edi_810.append(f"{'*'.join(st)}~")

    # BIG Segment
    prf = parsed_856['PRF'][0]
    edi_810.append(f"BIG*{gs[4]}*{isa[9]+isa[10]}*{gs[4]}*{prf[1]}***PR~")

    # NTE Segment
    edi_810.append(f"NTE*GEN*The prices listed may reflect discounts or other reductions in~")

    # REF Segment
    acctNo = edi_curascript_create_855_856_810.get_ref_value(parsed_856, '11')
    edi_810.append(f"REF*AP*{acctNo}~")
    edi_810.append(f"REF*CO*15381~")
    edi_810.append(f"REF*OI*{isa[9]+isa[10]}~")
    edi_810.append(f"REF*IT*120094274~")
    edi_810.append(f"REF*TJ*TN04700000~")
    edi_810.append(f"REF*PN*DC3010~")

    # N1*BT, N3, N4 Segment
    edi_810.append(f"N1*BT*ALLERGY ASSOCIATES PA*91*{acctNo}~")
    edi_810.append(f"N3*6701 BAUM DR STE 140~")
    edi_810.append(f"N4*KNOXVILLE*TN*37919*US~")

    # N1*ST, N3, N4 Segment
    edi_810.append(f"N1*ST*Test Account 2*91*{acctNo}~")
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
    edi_810.append(f"ITD*1*1*0**90*20251111**0****NET 90 DAYS~")

    # DTM Segment
    edi_810.append(f"DTM*036*{gs[4]}~")
    edi_810.append(f"DTM*011*{gs[4]}~")

    # FOB Segment
    edi_810.append(f"FOB*CC*OR*Costs and FreightCFR~")

    # IT1 Segment
    lin = parsed_856['LIN'][0]
    sn1 = parsed_856['SN1'][0]
    edi_810.append(f"IT1*1*{sn1[2]}*{sn1[3]}*155.00**ND*{lin[3]}*****UI*{lin[3]}*VC*{lin[5]}~")

    # PID Segment
    pid = parsed_856['PID'][0]
    edi_810.append(f"{'*'.join(pid)}~")

    # REF Segment
    edi_810.append(f"REF*0B*0000021247~")
    edi_810.append(f"REF*ZZ*0090031258000010~")
    edi_810.append(f"REF*LT*{lin[7]}~")
    edi_810.append(f"REF*BV**OCTAPHARMA USA INC~")
    edi_810.append(f"REF*FC**ITEM ILLEGIBLE FOR FCD~")

    # DTM Segment
    edi_810.append(f"DTM*008*{gs[4]}~")
    edi_810.append(f"DTM*208*{gs[4]}~")
    edi_810.append(f"DTM*132*{gs[4]}~")

    # TDS Segment
    edi_810.append(f"TDS*15500*15500~")

    # TXI Segment
    edi_810.append(f"TXI*LS*0~")

    # SAC Segment
    edi_810.append(f"SAC*C*ZZZZ***8480~")

    # CTT Segment
    lin_segments = parsed_856.get('LIN', [])
    ctt = parsed_856['CTT'][0]
    ctt[1] = str(len(lin_segments))
    edi_810.append(f"{'*'.join(ctt)}~")

    # SE Segment
    se = parsed_856['SE'][0]
    edi_810.append(f"{'*'.join(se)}~")

    # GE Segment
    ge = parsed_856['GE'][0]
    ge[2] = gs[6]
    edi_810.append(f"{'*'.join(ge)}~")

    # IEA Segment
    iea = parsed_856['IEA'][0]
    iea[2] = isa[13]
    edi_810.append(f"{'*'.join(iea)}~")

    segments_count = len(edi_810[2:-2])
    se[1] = str(segments_count)
    edi_810[-3] = f"{'*'.join(se)}~"
    
    return '\n'.join(edi_810)