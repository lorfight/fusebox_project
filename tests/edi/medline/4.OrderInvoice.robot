*** Settings ***
Documentation      Order Invoice
Library    BuiltIn
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Library    ../../../resources/EdiObjects/TestData/edi_mckessonsh_create_message.py
Library    ../../../resources/EdiObjects/TestData/edi_medline_create_message.py
Library    ../../../resources/EdiObjects/TestData/edi_takeda_create_message.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    ML_810    medline

*** Variables ***
${IN_PONumber}    //*[@id="body"]//div[2]/div[1]/h4
${IN_InvoiceNumber}    //*[@id="InvoiceNumber"]
${IN_InvoiceTotal}    //*[@id="InvoiceTotal"]
${IN_AccountNumber}    //*[@id="invoiceTab"]//div[3]/div[3]

*** Test Cases ***
Generate msg 810 and Send to sFTP
	[Documentation]   Generate msg 810 from 850 and Send to sFTP
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Generate msg 810 from msg 850
    Validate 810 GAP
    Send msg 810 to sFTP Medline

Build Jenkins
	[Documentation]   Build Jenkins
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}

Verify PO Number
    [Documentation]   Verify PO Number UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Open Order 810
    Verify PO Number

Verify Invoice Number
    [Documentation]   Verify Invoice Number UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Invoice Number

Verify Account Number
    [Documentation]   Verify Account Number UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Account Number

Verify Invoice Total
    [Documentation]   Verify Invoice Total UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Invoice Total

Verify Quantity
    [Documentation]   Verify Item Number UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Quantity

Verify PO Price
    [Documentation]   Verify PO Price UI with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify PO Price
    Delete All Files In Directory

*** Keywords ***

Set Up Suite
    ${data_input}    ${data_configs}    Get Data EDI
	Set Suite Variable    ${jenkins_url}    ${data_configs}[edi][jenkins_url]
    Set Suite Variable    ${jenkins_user}    ${data_configs}[edi][jenkins_user]
    Set Suite Variable    ${jenkins_api_token}    ${data_configs}[edi][jenkins_api_token]
    Set Suite Variable    ${jenkins_job_name}    ${data_configs}[edi][medline][job_name]
    Set Suite Variable    ${medline_hostname}    ${data_configs}[edi][medline][hostname]
    Set Suite Variable    ${medline_username}    ${data_configs}[edi][medline][username]
    Set Suite Variable    ${medline_password}    ${data_configs}[edi][medline][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]

Generate msg 810 from msg 850
    ${edi_po_number}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\PONumber.txt
    Set Global Variable    ${edi_po_number}
    ${edi_data_850}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    ${parsed_850_data}    Parse Edi 850    ${edi_data_850}
    ${edi_data_810}    Create 810 Medline    ${parsed_850_data}
    Create File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_810.txt    ${edi_data_810}

Send msg 810 to sFTP Medline
    Connect to SFTP Medline
    Put File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_810.txt    ${inbound_path}
    Close All Connections

Prepare Data for 810 and UI Comparison
    ${edi_data_810}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_810.txt
    ${parsed_810_data}    Parse Edi 850    ${edi_data_810}
    [Return]    ${parsed_810_data}

Verify PO Number
    Open Order Invoice Page
    ${in_poNumber}    Get Text    ${IN_PONumber}
    ${in_poNumber}    Evaluate    "${in_poNumber}".replace('PO#: ', '')
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_poNumber}    Set Variable    ${parsed_810_data['BIG'][0][4]}
    Should Be Equal    ${in_poNumber}    ${msg_poNumber}

Verify Invoice Number
    ${in_invoiceNumber}    Get Value    ${IN_InvoiceNumber}
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_invoiceNumber}    Set Variable    ${parsed_810_data['BIG'][0][2]}
    Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceNumber}    ${msg_invoiceNumber}

Verify Account Number
    ${in_accountNumber}    Get Text    ${IN_AccountNumber}
    ${in_accountNumber}    Evaluate    "${in_accountNumber}".replace('Account #: ', '')
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_accountNumber}    Get N1 Values    ${parsed_810_data}    ST
    Run Keyword And Continue On Failure    Should Be Equal    ${in_accountNumber}    ${msg_accountNumber}

Verify Invoice Total
    ${in_invoiceTotal}    Get Value    ${IN_InvoiceTotal}
    ${in_invoiceTotal}    Evaluate    "${in_invoiceTotal}".replace('$', '').replace(',', '')
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_invoiceTotal}    Set Variable    ${parsed_810_data['TDS'][0][1]}
    ${msg_invoiceTotal}    Evaluate    "${msg_invoiceTotal}"[:-2] + '.' + "${msg_invoiceTotal}"[-2:]
    Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceTotal}     ${msg_invoiceTotal}

Verify Quantity
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_qty}    Set Variable    ${parsed_810_data['IT1'][0][2]}
    ${item_count}    Get Length    ${parsed_810_data['IT1']}
    FOR    ${index}    IN RANGE    1    ${item_count + 1}
        ${in_qty}    Get Text    xpath=//*[@id="invoiceTab"]//div[3]//tr[${index}]/td[5]
        ${in_qty}    Evaluate    "${in_qty}".replace('.0', '')
        ${msg_qty}    Set Variable    ${parsed_810_data['IT1'][${index}-1][2]}
        Run Keyword And Continue On Failure    Should Be Equal    ${in_qty}    ${msg_qty}
    END

Verify PO Price
    ${parsed_810_data}=    Prepare Data for 810 and UI Comparison
    ${msg_price}    Set Variable    ${parsed_810_data['IT1'][0][4]}
    ${item_count}    Get Length    ${parsed_810_data['IT1']}
    FOR    ${index}    IN RANGE    1    ${item_count + 1}
        ${in_poPrice}    Get Text    xpath=//*[@id="invoiceTab"]//div[3]//tr[${index}]/td[4]
        ${in_poPrice}    Evaluate    "${in_poPrice}".replace('$', '').replace(',', '')
        ${msg_price}    Set Variable    ${parsed_810_data['IT1'][${index}-1][4]}
        Run Keyword And Continue On Failure    Should Be Equal    ${in_poPrice}    ${msg_price}
    END