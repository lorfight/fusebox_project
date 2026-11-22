*** Settings ***
Documentation    Create PO not in system with 856

Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_856_unhappycase.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810_unhappycase.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Library    ../../../resources/EdiObjects/TestData/edi_cencora_besse_create_message.py
Library    BuiltIn
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords    Login To Fusebox    user_name=${Username}    password=${Password}    AND
        ...    Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Edi

*** Variables ***
${CloseBtn}    //div[contains(@class,"fade in")]//*[@id="CloseBtn"]
${OO_PONumber}    //*[@id="frm_OrderTrackSingleView"]//div/div[1]/div[1]/div[1]
${RO_PONumber}    //*[@id="body"]/div/div[1]//div[1]/div[1]/h4
${RO_AccountNumber}    //*[@id="body"]//div[1]/div/span
${IN_PONumber}    //*[@id="body"]//div[2]/div[1]/h4
${IN_InvoiceNumber}    //*[@id="InvoiceNumber"]
${IN_InvoiceTotal}    //*[@id="InvoiceTotal"]
${IN_AccountNumber}    //*[@id="invoiceTab"]//div[3]/div[3]

*** Test Cases ***
Create PO and Process 856
	[Documentation]   Process 856, 810 happycase
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Update Edi 856    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    EDI Open Order and Search PO Number
    Check Order Shipping Message Status
    Check Label and Status
    Check UI with Message 856

    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check Order Invoice Message Status
    Open Order Invoice Page
    Check UI with Message 810

    Delete All Files In Directory

Process 856 SenderId Incorrect
	[Documentation]   Process 856 with senderid incorrect
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 856 Receiveid Incorrect    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 856
    Check EDI Tools with 856 SenderId Incorrect
    Delete All Files In Directory

Process 856 SenderId Blank
	[Documentation]   Process 856 with senderid blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 856 Receiveid Blank    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 856
    Check EDI Tools with 856 SenderId Blank
    Delete All Files In Directory

Process 856 PO Empty
	[Documentation]   Process 856 with PO empty
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 856 Po Empty    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 Po Empty to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 856
    Check EDI Tools with 856 Po Empty
    Delete All Files In Directory

# Create PO and Process 856 New Line Item
# 	[Documentation]   Process 856 with new line item
# 	[Tags]    Integration    Regession    Order
#     ...  allure.label.owner:Do Luong
#     Update Edi 856    ${env}    856    Curascript
#     Connect to SFTP CuraScriptSD
#     Send 856 to sFTP
#     Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
#     EDI Open Order and Search PO Number
#     Check Order Shipping Message Status
#     Check UI with Message 856

#     Connect to SFTP CuraScriptSD
#     Send 810 new line item to sFTP
#     Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
#     EDI Open Order and Search PO Number
#     Check Order Invoice Message Status
#     Open Order Invoice Page
#     Check UI with Message 810


Create PO and Process 856 810 Difference Qty
	[Documentation]   Process 856, 810 Difference Qty
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Update Edi 856    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    EDI Open Order and Search PO Number
    Check Order Shipping Message Status
    Check Label and Status
    Check UI with Message 856

    Connect to SFTP CuraScriptSD
    Send 810 difference qty to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check Order Invoice Message Status
    Open Order Invoice Page
    Check UI with Message 810
    Delete All Files In Directory

Create PO and Process 856 810 Difference Price
	[Documentation]   Process 856, 810 Difference Price
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Update Edi 856    ${env}    856    Curascript
    Connect to SFTP CuraScriptSD
    Send 856 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    EDI Open Order and Search PO Number
    Check Order Shipping Message Status
    Check Label and Status
    Check UI with Message 856

    Connect to SFTP CuraScriptSD
    Send 810 difference price to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check Order Invoice Message Status
    Open Order Invoice Page
    Check UI with Message 810
    Delete All Files In Directory

*** Keywords ***
Set Up Suite
    ${data_input}    ${data_configs}    Get Data EDI
    Set Suite Variable    ${jenkins_url}    ${data_configs}[edi][jenkins_url]
    Set Suite Variable    ${jenkins_user}    ${data_configs}[edi][jenkins_user]
    Set Suite Variable    ${jenkins_api_token}    ${data_configs}[edi][jenkins_api_token]
    Set Suite Variable    ${jenkins_job_name}    ${data_configs}[edi][curascript][job_name]
    Set Suite Variable    ${curascript_hostname}    ${data_configs}[edi][curascript][hostname]
    Set Suite Variable    ${curascript_username}    ${data_configs}[edi][curascript][username]
    Set Suite Variable    ${curascript_password}    ${data_configs}[edi][curascript][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]

EDI Open Order and Search PO Number
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${po_number}
    Wait Until Element Is Not Visible    ${Find_SearchOrder_LoadingIndicator}    timeout=10s

Check Label and Status
    ${label}    Get Text    //*[@id="OrderList"]//tr[1]//span
    ${status}    Get Text    //*[@id="item_StatusId"]/option[@selected="selected"]
    ${createdby}    Get Text    //*[@data-itemid="LTE_"]
    Should Contain    ${label}    Order Placed from Different System
    Should Contain    ${status}    Shipped
    Should Contain    ${createdby}    System

Check UI with Message 856
    ${edi_856_content}    Read Edi File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt
    ${parsed_data}    Parse Edi 855    ${edi_856_content}
    ${prf_segment}=    Get From Dictionary    ${parsed_data}    PRF
    ${msg_poNumber}=       Get From List    ${prf_segment[0]}    1
    ${msg_accountNumber}    Get Ref Value    ${parsed_data}    11

    Open TrackPackage

    Wait Until Element Is Visible    ${OO_PONumber}    timeout=5s
    ${oo_poNumber}    Get Text    ${OO_PONumber}
    ${oo_poNumber}    Evaluate    "${oo_poNumber}".replace('PO #: ', '')
    Run Keyword And Continue On Failure    Should Be Equal    ${msg_poNumber}    ${oo_PONumber}

    ${item_count}    Get Length    ${parsed_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${item_index_ui}    Evaluate    3 + ${index} * 3
        ${oo_item}    Get Text    xpath=//*[@id="frm_OrderTrackSingleView"]//tr[${item_index_ui}]/td[3]
        ${oo_item}    Evaluate    "${oo_item}".replace('-', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${oo_item}    ${parsed_data['LIN'][${index}][3]}
        
        ${item_index_ui}    Evaluate    3 + ${index} * 3
        ${qty_index_ui}    Evaluate    3 + ${index} * 3
        ${oo_qty}    Get Text    xpath=//*[@id="frm_OrderTrackSingleView"]//tr[${qty_index_ui}]/td[6]/div[1]
        Run Keyword And Continue On Failure    Should Be Equal    ${oo_qty}    ${parsed_data['SN1'][${index}][2]}
    END
    Wait Until Element Is Visible    ${CloseBtn}    timeout=5s
    Click Element    ${CloseBtn}

    Open ReceiveOrder Page

    ${ui_poNumber}    Get Text    ${RO_PONumber}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO Number: ', '')
    ${ui_accountNo}    Get Text    ${RO_AccountNumber}
    ${ui_accountNo}    Evaluate    "${ui_accountNo}".replace('Test Account 2 (Acct #: ', '').replace(')', '')

    Run Keyword And Continue On Failure    Should Be Equal    ${ui_poNumber}    ${msg_poNumber}
    Run Keyword And Continue On Failure    Should Be Equal    ${ui_accountNo}    ${msg_accountNumber}
    
    ${item_count}    Get Length    ${parsed_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${ro_item}    Get Text    xpath=//*[@id="LineNumber${index + 1}ReceiptsDiv"]/div[1]/div[2]/div[2]
        ${ro_item}    Evaluate    "${ro_item}".replace('-', '')
        ${msg_item}    Set Variable    ${parsed_data['LIN'][${index}][3]}
        Run Keyword And Continue On Failure    Should Be Equal    ${ro_item}    ${msg_item}
        
        ${ro_orderd_qty}    Get Text    xpath=//*[@id="LineNumber${index + 1}ReceiptsDiv"]/div[1]/div[2]/div[6]
        ${ro_orderd_qty}    Evaluate    "${ro_orderd_qty}".replace('.0', '')
        ${msg_item_qty}    Set Variable    ${parsed_data['SN1'][${index}][2]}
        Run Keyword And Continue On Failure    Should Be Equal    ${ro_orderd_qty}    ${msg_item_qty} 
    END

Send 856 to sFTP
    ${edi_856}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${check}    edi_callggsheetapi.Validate Field 856    ${edi_856}    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 856 fail
    END
    Set Global Variable    ${edi_856}
    Put File    ${edi_856}    ${inbound_path}
    Close All Connections
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_data}    Parse Edi 855    ${edi_856_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    PRF
    ${po_number}=       Get From List    ${bak_segment[0]}    1
    Set Global Variable    ${po_number}

Send 810 to sFTP
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_856}    Parse Edi 855    ${edi_856_content}
    ${edi_810}    Create 810 From 856    ${parsed_856}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${inbound_path}
    Close All Connections

Send 810 new line item to sFTP
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_856}    Parse Edi 855    ${edi_856_content}
    ${edi_810}    Create 810 With 856 Diff Line Item    ${parsed_856}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${inbound_path}
    Close All Connections

Send 810 difference qty to sFTP
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_856}    Parse Edi 855    ${edi_856_content}
    ${edi_810}    Create 810 Diff Qty    ${parsed_856}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${inbound_path}
    Close All Connections

Send 810 difference price to sFTP
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_856}    Parse Edi 855    ${edi_856_content}
    ${edi_810}    Create 810 Diff Price    ${parsed_856}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${inbound_path}
    Close All Connections
    
Send 856 Po Empty to sFTP
    ${edi_856}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    Set Global Variable    ${edi_856}
    Put File    ${edi_856}    ${inbound_path}
    Close All Connections

Check UI with Message 810
    ${in_poNumber}    Get Text    ${IN_PONumber}
    ${in_poNumber}    Evaluate    "${in_poNumber}".replace('PO#: ', '')
    ${edi_810_content}    Read Edi File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt
    ${parsed_810_data}    Parse Edi 855    ${edi_810_content}
    ${msg_poNumber}    Set Variable    ${parsed_810_data['BIG'][0][4]}
    Run Keyword And Continue On Failure    Should Be Equal    ${in_poNumber}    ${msg_poNumber}

    ${in_invoiceNumber}    Get Value    ${IN_InvoiceNumber}
    ${msg_invoiceNumber}    Set Variable    ${parsed_810_data['BIG'][0][2]}
    Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceNumber}    ${msg_invoiceNumber}

    ${in_accountNumber}    Get Text    ${IN_AccountNumber}
    ${in_accountNumber}    Evaluate    "${in_accountNumber}".replace('Account #: ', '')
    ${msg_accountNumber}    Get Ref Value    ${parsed_810_data}    AP
    Run Keyword And Continue On Failure    Should Be Equal    ${in_accountNumber}    ${msg_accountNumber}

    ${in_invoiceTotal}    Get Value    ${IN_InvoiceTotal}
    ${in_invoiceTotal}    Evaluate    "${in_invoiceTotal}".replace('$', '').replace(',', '')
    ${msg_invoiceTotal}    Set Variable    ${parsed_810_data['TDS'][0][2]}
    ${msg_invoiceTotal}    Evaluate    "${msg_invoiceTotal}"[:-2] + '.' + "${msg_invoiceTotal}"[-2:]
    Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceTotal}     ${msg_invoiceTotal}

    ${item_count}    Get Length    ${parsed_810_data['IT1']}
    ${msg_item}    Set Variable    ${parsed_810_data['IT1'][0][7]}
    ${msg_qty}    Set Variable    ${parsed_810_data['IT1'][0][2]}
    ${msg_price}    Set Variable    ${parsed_810_data['IT1'][0][4]}

    FOR    ${index}    IN RANGE    1    ${item_count + 1}
        ${in_item}    Get Text    xpath=//*[@id="invoiceTab"]//div[3]//tr[${index}]/td[1]
        ${in_item}    Evaluate    "${in_item}".replace('-', '')
        ${msg_item}    Set Variable    ${parsed_810_data['IT1'][${index}-1][7]}
        Run Keyword And Continue On Failure    Should Be Equal    ${in_item}    ${msg_item}

        ${in_qty}    Get Text    xpath=//*[@id="invoiceTab"]//div[3]//tr[${index}]/td[5]
        ${in_qty}    Evaluate    "${in_qty}".replace('.0', '')
        ${msg_qty}    Set Variable    ${parsed_810_data['IT1'][${index}-1][2]}
        Run Keyword And Continue On Failure    Should Be Equal    ${in_qty}    ${msg_qty}

        ${in_invoiceAmount}    Get Text    xpath=//*[@id="invoiceTab"]//div[3]//tr[${index}]/td[8]
        ${in_invoiceAmount}    Evaluate    "${in_invoiceAmount}".replace('$', '')
        ${msg_price}    Set Variable    ${parsed_810_data['IT1'][${index}-1][4]}
        ${result}    Evaluate    float(${msg_qty}) * float(${msg_price})
        ${result_msg_price}    Evaluate    "{:.2f}".format(${result})
        Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceAmount}    ${result_msg_price}
    END

Check EDI Tools with 856 SenderId Incorrect
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'EDI Address: SENDERID - Not found distributors from EDI Address')]
    Should Contain    ${text}    EDI Address: SENDERID - Not found distributors from EDI Address

Check EDI Tools with 856 SenderId Blank
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'The EDI Address is empty')]
    Should Contain    ${text}    EDI Address:  - The EDI Address is empty

Check EDI Tools with 856 Po Empty
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'PO is empty; Invalid PO')]
    Should Contain    ${text}    [856] Line 27: PO is empty; Invalid PO