*** Settings ***
Documentation    Create PO not in system with 810

Library    BuiltIn
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_810_unhappycase.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810_unhappycase.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Edi

*** Variables ***
${IN_PONumber}    //*[@class="InvoiceReconcileSmallHeaders" and contains(text(), 'PO#:')]
${IN_InvoiceNumber}    //*[@id="InvoiceNumber"]
${IN_InvoiceTotal}    //*[@id="InvoiceTotal"]
${IN_AccountNumber}    //*[@id="invoiceTab"]//div[3]/div[3]


*** Test Cases ***
Create PO and Process 810
	[Documentation]   Process 810 unhappycase
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 Unhappycase    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    EDI Open Order and Search PO Number
    Check Order Invoice Message Status
    Open Order Invoice Page
    Check UI with Message 810
    Delete All Files In Directory

Create PO and Process 810 SenderId Blank
	[Documentation]   Process 810 SenderId Blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 Senderid Blank    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 810
    Check SenderId Blank
    Delete All Files In Directory

Create PO and Process 810 SenderId Incorrect
	[Documentation]   Process 810 SenderId Incorrect
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 Senderid Incorrect    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 810
    Check SenderId Incorrect
    Delete All Files In Directory

Create PO and Process 810 Account Number Blank
	[Documentation]   Process 810 Account Number Blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 AccountNumber Blank    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 810
    Check Account Number Blank
    Delete All Files In Directory

Create PO and Process 810 Account Number Incorrect
	[Documentation]   Process 810 Account Number Incorrect
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 AccountNumber Incorrect    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name} 
    Open EDI Tools
    Filter 810
    Check Account Number Incorrect
    Delete All Files In Directory

Create PO and Process 810 Difference Price Contract
	[Documentation]   Process 810 Difference Price Contract
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Create 810 Different Price Contract    ${env}    810    Curascript
    Connect to SFTP CuraScriptSD
    Send 810 to sFTP
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
    
Send 810 to sFTP
    ${edi_810}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${check}    edi_callggsheetapi.Validate Field 810    ${edi_810}    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 810 fail
    END
    Set Global Variable    ${edi_810}
    Put File    ${edi_810}    ${inbound_path}
    Close All Connections
    ${edi_810_content}    Read Edi File    ${edi_810}
    ${parsed_data}    Parse Edi 855    ${edi_810_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    BIG
    ${po_number}=       Get From List    ${bak_segment[0]}    4
    Set Global Variable    ${po_number}

EDI Open Order and Search PO Number
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${po_number}
    Wait Until Element Is Not Visible    ${Find_SearchOrder_LoadingIndicator}    timeout=10s

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

Check SenderId Blank
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'The EDI Address is empty')]
    Should Contain    ${text}    EDI Address: - The EDI Address is empty

Check SenderId Incorrect
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'Not found distributors from EDI Address')]
    Should Contain    ${text}    Not found distributors from EDI Address

Check Account Number Blank
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'The Account Number is empty')]
    Should Contain    ${text}    The Account Number is empty

Check Account Number Incorrect
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'Not found sender account by distributor')]
    Should Contain    ${text}    Not found sender account by distributor