*** Settings ***
Documentation      Order Confirmation
Library    BuiltIn
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Library    ../../../resources/EdiObjects/TestData/edi_mckesson_medical_surgical.py
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Resource   ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    MMS_855    mms

*** Variables ***
${CF_PO_Number}    //*[@id="body"]//div[3]/div[1]//div[4]
${CF_AccountNumber}    //*[@id="body"]//div[3]/div[1]/div[3]/div[3]
${CF_ConfirmationNumber}    //*[@id="ConfirmationNumber"]
${LineIndex}    1


*** Test Cases ***
Generate msg 855 and Send to sFTP
	[Documentation]   Generate msg 855 and send sFTP
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Generate msg 855 from msg 850
    Validate 855 GAP McKesson Medical Surgical
    Send msg 855 to sFTP McKesson Medical Surgical

Build Jenkins
	[Documentation]   Build Jenkins
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Trigger Jenkins MirthProcessor Build   ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}    ${JENKINS_JOB_NAME}

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

Verify Confirmation Number
    [Documentation]   Verify Confirmation Number in msg with UI
    [Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Comfirmation Number

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
    Set Suite Variable    ${jenkins_job_name}    ${data_configs}[edi][van][job_name]
    Set Suite Variable    ${van_hostname}    ${data_configs}[edi][van][hostname]
    Set Suite Variable    ${van_username}    ${data_configs}[edi][van][username]
    Set Suite Variable    ${van_password}    ${data_configs}[edi][van][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]

Generate msg 855 from msg 850
    ${edi_po_number}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\PONumber.txt
    Set Global Variable    ${edi_po_number}
    ${edi_data_850}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    ${parsed_850_data}    Parse Edi 850    ${edi_data_850}
    ${edi_data_855}    Create 855 McKesson Medical Surgical    ${parsed_850_data}
    Create File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.edi    ${edi_data_855}

Validate 855 GAP McKesson Medical Surgical
    [Documentation]    Validate field on msg 855
    ${check}    edi_callggsheetapi.Validate Field 855    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.edi    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 855 fail
    END

Send msg 855 to sFTP McKesson Medical Surgical
    Connect to SFTP Van
    Put File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.edi    ${inbound_path}
    Close All Connections
    
Prepare Data for 855 and UI Comparison
    ${edi_data_855}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_855.edi
    ${parsed_855_data}    Parse Edi 850    ${edi_data_855}
    ${msg_po_number}    Set Variable    ${parsed_855_data['BAK'][0][3]}
    ${num_po1_segments}    Get Length    ${parsed_855_data['PO1']}
    ${LineIndex}    Set Variable    1
    [Return]    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}

Verify PO Number
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    ${ui_poNumber}    Get Text    ${CF_PO_Number}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('System Order #:', '').strip()
    Should Be Equal    ${ui_poNumber}    ${msg_po_number}

Verify Comfirmation Number
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    ${ui_confirmationNo}    Get Value    ${ConfirmationNumber}
    Run Keyword And Continue On Failure    Should Be Equal    ${ui_confirmationNo}    ${parsed_855_data['BAK'][0][8]}   

Verify Item Number
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_itemNo_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${LineIndex}]/td[3]/div[1]
        ${cf_itemNo}    Get Text    ${cf_itemNo_xpath}
        ${itemNo}    Evaluate    "${cf_itemNo}".replace('Item No: ', '')
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
        ${cf_price_xpath}    Set Variable    //*[@data-row='${LineIndex}']//*[contains(@class, 'ItemDetails') and contains(@class, 'Price')]
        ${cf_price}    Get Text    ${cf_price_xpath}
        ${price}    Evaluate    "${cf_price}".replace('$', '').replace(',', '')
        ${po1_price}    Set Variable    ${parsed_855_data['PO1'][${index}][4]}
        Run Keyword And Continue On Failure    Should Be Equal    ${price}    ${po1_price}
        ${LineIndex}    Evaluate    ${LineIndex} + 1
    END

Verify Quantity
    ${parsed_855_data}    ${num_po1_segments}    ${LineIndex}    ${msg_po_number}    Prepare Data for 855 and UI Comparison
    FOR    ${index}    IN RANGE    0    ${num_po1_segments}
        ${cf_qty_xpath}    Set Variable    //*[@data-row='${LineIndex}']//*[contains(@class, 'ItemDetails') and contains(@class, 'Qty')]
        ${cf_qty}    Get Text    ${cf_qty_xpath}
        ${po1_qty}    Set Variable    ${parsed_855_data['PO1'][${index}][2]}
        Run Keyword And Continue On Failure    Should Be Equal    ${cf_qty}    ${po1_qty}
        ${LineIndex}    Evaluate    ${LineIndex} + 1
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