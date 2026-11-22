*** Settings ***
Documentation      Order Confirmation
Library    BuiltIn
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Cura_855    curascript

*** Variables ***
${CF_PO_Number}    //h4[@class='InvoiceReconcileSmallHeaders']    
${CF_AccountNumber}    //*[@id="body"]//div[3]/div[1]/div[3]/div[3]
${CF_ConfirmationNumber}    //*[@id="ConfirmationNumber"]
${LineIndex}    1


*** Test Cases ***
Generate msg 855 and Send to sFTP
	[Documentation]   Generate msg 855 and send sFTP
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Generate msg 855 from msg 850
    Validate 855 GAP
    Send msg 855 to sFTP

Build Jenkins
	[Documentation]   Build Jenkins
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}

Open Order
	[Documentation]   Open Order and Switch Order Confirmation Tab
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    EDI Open Order

Verify PO Number
    [Documentation]   Verify Item Number in msg with UI
    [Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify PO Number

Verify Item Number
    [Documentation]   Verify Item Number in msg with UI
    [Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Item Number

Verify Vendor Item
    [Documentation]   Verify Vendor Item in msg with UI
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Vendor Item

Verify Price
    [Documentation]   Verify Price in msg with UI
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Price

Verify Quantity
    [Documentation]   Verify Quantity in msg with UI
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Quantity

Verify Contract Price
    [Documentation]   Verify Price in msg with UI
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Contract Price


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

Generate msg 855 from msg 850
    ${edi_po_number}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\PONumber.txt
    Set Global Variable    ${edi_po_number}
    ${edi_data_850}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    ${parsed_850_data}    Parse Edi 850    ${edi_data_850}
    ${edi_data_855}    Create Edi 855    ${parsed_850_data}
    Create File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.txt    ${edi_data_855}

Send msg 855 to sFTP
    Connect to SFTP CuraScriptSD
    Put File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.txt    ${inbound_path}
    Close All Connections
    
Prepare Data for 855 and UI Comparison
    ${edi_data_855}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_855.txt
    ${parsed_855_data}    Parse Edi 850    ${edi_data_855}
    ${msg_po_number}    Set Variable    ${parsed_855_data['BAK'][0][3]}
    ${num_po1_segments}    Get Length    ${parsed_855_data['PO1']}
    ${LineIndex}    Set Variable    1
    [Return]    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}

Verify PO Number
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    ${ui_poNumber}    Get Text    ${CF_PO_Number}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO#: ', '')
    Should Be Equal    ${ui_poNumber}    ${msg_po_number}

Verify Item Number
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_itemNo_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${LineIndex}]/td[3]/div[1]
        ${cf_itemNo}    Get Text    ${cf_itemNo_xpath}
        ${itemNo}    Evaluate    "${cf_itemNo}".replace('Item No: ', '').replace('-', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${itemNo}    ${parsed_855_data['PO1'][${index}][9]}
        ${LineIndex}    Evaluate    ${LineIndex} + 3
    END

Verify Vendor Item
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_vendorItem_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${LineIndex}]/td[3]/div[3]
        ${cf_vendorItem}    Get Text    ${cf_vendorItem_xpath}
        ${vendorItem}    Evaluate    "${cf_vendorItem}".replace('Vendor Item #: ', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${vendorItem}    ${parsed_855_data['PO1'][${index}][7]}
        ${LineIndex}    Evaluate    ${LineIndex} + 3
    END

Verify Price
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_price_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${LineIndex}]/td[5]/div[1]
        ${cf_price}    Get Text    ${cf_price_xpath}
        ${price}    Evaluate    "${cf_price}".replace('$', '').replace(',', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${price}    ${parsed_855_data['PO1'][${index}][4]}
        ${LineIndex}    Evaluate    ${LineIndex} + 3
    END

Verify Quantity
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_qty_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${LineIndex}]/td[6]/div[1]
        ${cf_qty}    Get Text    ${cf_qty_xpath}
        Run Keyword And Continue On Failure    Should Be Equal    ${cf_qty}    ${parsed_855_data['PO1'][${index}][2]}
        ${LineIndex}    Evaluate    ${LineIndex} + 3
    END

Verify Contract Price
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_contractPrice_xpath}    Set Variable    //*[@id='body']//div[3]//tr[${LineIndex}]//div[2]/div[2]
        ${cf_contractPrice}    Get Text    ${cf_contractPrice_xpath}
        ${contractPrice}    Evaluate    "${cf_contractPrice}".replace('Contract Price: ', '').replace('$', '').replace(',', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${contractPrice}    ${parsed_855_data['PO1'][${index}][4]}
        ${LineIndex}    Evaluate    ${LineIndex} + 3
    END