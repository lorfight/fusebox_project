*** Settings ***
Documentation      Order Shipping
Library    BuiltIn
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Library    ../../../resources/EdiObjects/TestData/edi_mckessonsh_create_message.py
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Resource   ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    MSH_856    msh

*** Variables ***
${CloseBtn}    //div[contains(@class,"fade in")]//*[@id="CloseBtn"]
${OO_PONumber}    //*[@id="frm_OrderTrackSingleView"]//div/div[1]/div[1]/div[1]
${RO_PONumber}    //*[@id="body"]/div/div[1]//div[1]/div[1]/h4
${RO_AccountNumber}    //*[@id="body"]//div[1]/div/span

*** Test Cases ***
Generate msg 856 and Send to sFTP
	[Documentation]   Generate msg 856 from 850 and Send to sFTP
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Generate msg 856 from msg 850
    Validate 856 GAP
    Send msg 856 to sFTP

Build Jenkins
	[Documentation]   Build Jenkins
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Trigger Jenkins MirthProcessor Build    ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}    ${JOB_NAME_MCKessonSH}

Verify PO Number on TrackPackage
    [Documentation]    Verify PO Number on TrackPackage with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Open Order 856
    Verify PO Number on TrackPackage

Verify Item on TrackPackage
    [Documentation]    Verify Item on TrackPackage with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Item on TrackPackage

Verify Quantity on TrackPackage
    [Documentation]    Verify Quantity on TrackPackage with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Quantity on TrackPackage

Verify PONumber on ReceiveOrder
    [Documentation]    Verify PONumber on ReceiveOrder with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify PONumber on ReceiveOrder

Verify AccountNumber on ReceiveOrder
    [Documentation]    Verify AccountNumber on ReceiveOrder with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify AccountNumber on ReceiveOrder

Verify Item on ReceiveOrder
    [Documentation]    Verify Item on ReceiveOrder with msg
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Verify Item on ReceiveOrder 


*** Keywords ***

Set Up Suite
    ${data_input}    ${data_configs}    Get Data EDI
    Set Suite Variable    ${jenkins_url}    ${data_configs}[edi][jenkins_url]
    Set Suite Variable    ${jenkins_user}    ${data_configs}[edi][jenkins_user]
    Set Suite Variable    ${jenkins_api_token}    ${data_configs}[edi][jenkins_api_token]
    Set Suite Variable    ${job_name_mckessonsh}    ${data_configs}[edi][mckessonsh][job_name]
    Set Suite Variable    ${mckessonsh_hostname}    ${data_configs}[edi][mckessonsh][hostname]
    Set Suite Variable    ${mckessonsh_username}    ${data_configs}[edi][mckessonsh][username]
    Set Suite Variable    ${mckessonsh_password}    ${data_configs}[edi][mckessonsh][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]

Generate msg 856 from msg 850
    ${edi_po_number}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\PONumber.txt
    Set Global Variable    ${edi_po_number}
    ${edi_data_850}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    ${parsed_850_data}    Parse Edi 850    ${edi_data_850}
    ${edi_data_856}    Create Edi 856 MCKessonSH    ${parsed_850_data}
    Create File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_856.txt    ${edi_data_856}

Send msg 856 to sFTP
    Connect to SFTP MCKessonSH
    Put File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_856.txt    ${inbound_path}
    Close All Connections

Prepare Data for 856 and UI Comparison
    ${edi_data_856}    edi_curascript_create_855_856_810.Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_856.txt
    ${parsed_856_data}    Parse Edi 850    ${edi_data_856}
    [Return]    ${parsed_856_data}

Get PO Number UI
    Open TrackPackage
    Wait Until Element Is Visible    ${OO_PONumber}    timeout=5s
    ${oo_poNumber}    Get Text    ${OO_PONumber}
    ${oo_poNumber}    Evaluate    "${oo_poNumber}".replace('PO #: ', '')
    [Return]    ${oo_poNumber}

Verify PO Number on TrackPackage
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${oo_PONumber}=    Get PO Number UI
    Should Be Equal    ${parsed_856_data['PRF'][0][1]}    ${oo_PONumber}

Verify Item on TrackPackage
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${item_count}    Get Length    ${parsed_856_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${item_index_ui}    Evaluate    3 + ${index} * 3
        ${oo_item}    Get Text    xpath=//*[@id="frm_OrderTrackSingleView"]//tr[${item_index_ui}]/td[3]
        ${oo_item}    Evaluate    "${oo_item}".replace('-', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${oo_item}    ${parsed_856_data['LIN'][${index}][3]}
    END

Verify Quantity on TrackPackage
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${item_count}    Get Length    ${parsed_856_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${item_index_ui}    Evaluate    3 + ${index} * 3
        ${qty_index_ui}    Evaluate    3 + ${index} * 3
        ${oo_qty}    Get Text    xpath=//*[@id="frm_OrderTrackSingleView"]//tr[${qty_index_ui}]/td[6]/div[1]
        Run Keyword And Continue On Failure    Should Be Equal    ${oo_qty}    ${parsed_856_data['SN1'][${index}][2]}
    END
    Wait Until Element Is Visible    ${CloseBtn}    timeout=5s
    Click Element    ${CloseBtn}

Verify PONumber on ReceiveOrder
    Open ReceiveOrder Page
    ${ro_poNumber}    Get Text    ${RO_PONumber}
    ${ro_poNumber}    Evaluate    "${ro_poNumber}".replace('PO Number: ', '')
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    Should Be Equal    ${ro_poNumber}    ${parsed_856_data['PRF'][0][1]}

Verify AccountNumber on ReceiveOrder
    ${ro_accountNumber}    Get Text    ${RO_AccountNumber}
    ${ro_accountNumber}    Evaluate    "${ro_accountNumber}".replace('Test Account 2 (Acct #: ', '').replace(')', '')
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${msg_accountNumber}    Get N1 Values    ${parsed_856_data}    ST
    Run Keyword And Continue On Failure    Should Be Equal    ${ro_accountNumber}    ${msg_accountNumber}

Verify Item on ReceiveOrder
    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${item_count}    Get Length    ${parsed_856_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${ro_item}    Get Text    xpath=//*[@id="LineNumber${index + 1}ReceiptsDiv"]/div[1]/div[2]/div[2]
        ${ro_item}    Evaluate    "${ro_item}".replace('-', '')
        Run Keyword And Continue On Failure    Should Be Equal    ${ro_item}    ${parsed_856_data['LIN'][${index}][3]}
    END

Verify on Track Order
    Click Element    link: Track Orders
    Wait Until Page Contains Element    //*[text()="Home"]    ${timeout}
    Click Element    //*[@id="ClearButton"]
    Wait Until Element Is Not Visible    //*[@id="loading-indicator"]    ${timeout}
    FOR    ${i}    IN    2
        Input Text    //*[@id="SearchValues"]    ${edi_po_number}
        Sleep    10
        Click Element    //*[@id="FindButton"]
        Wait Until Element Is Not Visible    //*[@id="loading-indicator"]    ${timeout}
        Sleep    5
    END

    ${parsed_856_data}=    Prepare Data for 856 and UI Comparison
    ${ui_poNumber}    Set Variable    //*[contains(@href, '/Order/OrderConfirmation')]
    ${ui_poNumber}    Get Text    ${ui_poNumber}
    ${msg_poNumber}    Set Variable    ${parsed_856_data['PRF'][0][1]}
    Run Keyword And Continue On Failure    Should Be Equal    ${ui_poNumber}    ${msg_poNumber}

    ${item_count}    Get Length    ${parsed_856_data['LIN']}
    FOR    ${index}    IN RANGE    ${item_count}
        ${item_index_ui}    Evaluate    3 + ${index} * 3
        Sleep    1
        ${to_item}    Get Text    //*[@id="OrderList"]//tr[3]//tr[${item_index_ui}]/td[3]
        ${to_item}    Evaluate    "${to_item}".replace('-', '')
        ${msg_item}    Set Variable    ${parsed_856_data['LIN'][${index}][3]}
        Run Keyword And Continue On Failure    Should Be Equal    ${to_item}    ${msg_item}

        ${qty_index_ui}    Evaluate    ${index} + 1
        ${to_qty}    Get Text    //*[@data-row='${qty_index_ui}']//*[contains(@class, 'ItemDetails') and contains(@class, 'Qty')]
        ${msg_qty}    Set Variable    ${parsed_856_data['SN1'][${index}][2]}
        Run Keyword And Continue On Failure    Should Be Equal    ${to_qty}    ${msg_qty}

        ${status_index}    Evaluate    ${index} + 1
        ${to_status}    Get Text    //*[@data-row='${status_index}']//*[@id="Status"]/*[@selected="selected"]
        Run Keyword And Continue On Failure    Should Be Equal    ${to_status}    Shipped
    END