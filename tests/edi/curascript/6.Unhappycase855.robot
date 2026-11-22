*** Settings ***
Documentation      Create PO not in system with 855
Library    BuiltIn
Library    DatabaseLibrary
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810_unhappycase.py
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_856_unhappycase.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords    Login To Fusebox    user_name=${Username}    password=${Password}    AND
        ...    Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Edi

*** Variables ***
${RO_PONumber}    //*[@id="body"]/div/div[1]//div[1]/div[1]/h4
${RO_AccountNumber}    //*[@id="body"]//div[1]/div/span
${RO_UoM}    //*[@for="UoM"]
${IN_PONumber}    //*[@id="body"]//div[2]/div[1]/h4
${IN_InvoiceNumber}    //*[@id="InvoiceNumber"]
${IN_InvoiceTotal}    //*[@id="InvoiceTotal"]
${IN_AccountNumber}    //*[@id="invoiceTab"]//div[3]/div[3]
${CF_PO_Number}    //h4[@class='InvoiceReconcileSmallHeaders']    
${CF_AccountNumber}    //*[@id="body"]//div[3]/div[1]/div[3]/div[3]
${CF_ConfirmationNumber}    //*[@id="ConfirmationNumber"]
${LineIndex}    1

*** Test Cases **
Create PO with 855
	[Documentation]   Process 855, 856, 810 happycase
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Update Edi Message    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Check Label and Status
    Open ReceiveOrder Page
    Check UI with Message 855 on ReceiveOrder
    EDI Open Order and Search PO Number
    Open Order Confirmation
    Check UI with Message 855 on Confirmation

    Generate EDI 856 From 855
    Put EDI 856 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 856 status
    Open ReceiveOrder Page
    Check UI with Message 856

    Generate EDI 810 From 855
    Put EDI 810 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 810 status
    Open Order Invoice Page
    Check UI with Message 810

    Delete All Files In Directory

Create and Process 855 Incorrect Item Price
	[Documentation]   Process 855 with Incorrect Item Price
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Incorrect Item Price    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Open Order Confirmation
    # Check Price Confirmation
    Delete All Files In Directory

Create and Process 855 PO Blank
	[Documentation]   Process 855 with PO Blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Po Blank    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    Open EDI Tools
    Filter 855
    Check PO Blank
    Delete All Files In Directory

Create and Process 855 ReceiveId Blank
	[Documentation]   Process 855 ReceiveId Blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Receiveid Blank    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    Open EDI Tools
    Filter 855
    Check ReceiveId Blank
    Delete All Files In Directory

Create and Process 855 ReceiveId Incorrect
	[Documentation]   Process 855 ReceiveId Incorrect
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Receiveid Incorrect    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    Open EDI Tools
    Filter 855
    Check ReceiveId Incorrect
    Delete All Files In Directory

Create and Process 855 Incorrect Vendor Item
	[Documentation]   Process 855 Incorrect Vendor Item
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Incorrect Vendor Item    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    Open EDI Tools
    Filter 855
    Check Vendor Item In EDI Tools
    # Check Message on EDITools
    Delete All Files In Directory

Create and Process 855 Vendor Item Blank
	[Documentation]   Process 855 Vendor Item Blank
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message Vendor Item Blank    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    Open EDI Tools
    Filter 855
    Check Vendor Item In EDI Tools
    Delete All Files In Directory

Create and Process 856 New Line Item
	[Documentation]   Process 856 New Line Item
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message 855 Case 856    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Check Label and Status
    Open ReceiveOrder Page
    Check UI with Message 855 on ReceiveOrder
    EDI Open Order and Search PO Number
    Open Order Confirmation
    Check UI with Message 855 on Confirmation

    Generate EDI 856 Unhappycase From 855
    Connect to SFTP CuraScriptSD
    Put EDI 856 Unhappycase to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 856 status
    Open Order Confirmation
    Check New Line Item
    Delete All Files In Directory

Create and Process 856 Difference Qty
	[Documentation]   Process 856 Difference Qty
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message 855 Case 856    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Check Label and Status
    Open ReceiveOrder Page
    Check UI with Message 855 on ReceiveOrder
    EDI Open Order and Search PO Number
    Open Order Confirmation
    Check UI with Message 855 on Confirmation

    Generate EDI 856 Difference Qty
    Connect to SFTP CuraScriptSD
    Put EDI 856 Unhappycase to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 856 status
    Open Order Confirmation
    Check New Line Item
    Delete All Files In Directory


Check Line Item Status Process 855
	[Documentation]   Process 856 and Check Line Item Status
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    ${statuses}    Create List    AC    IA    AR    BP    IB    ID    IR
    FOR    ${status}    IN    @{statuses}
        Message Line Item Status    ${status}    ${env}    855    Curascript
        Connect to SFTP CuraScriptSD
        Put EDI 855 to SFTP
        Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
        EDI Open Order and Search PO Number
        Check button 855 status
        Open Order Confirmation

        ${line_count}    Get Element Count    xpath=//select[contains(@id, 'ItemStatus_')]/*[@selected]

        FOR    ${index}    IN RANGE    1    ${line_count + 1}
            ${line_item_status}    Get Text    xpath=//*[@id="ItemStatus_${index}"]/*[@selected]
            
            IF    '${status}' == 'AC'  
                Should Contain    ${line_item_status}    Accepted
            ELSE IF    '${status}' == 'IA'  
                Should Contain    ${line_item_status}    Accepted
            ELSE IF    '${status}' == 'AR'  
                Should Contain    ${line_item_status}    Shipping Soon
            ELSE IF    '${status}' == 'BP'  
                Should Contain    ${line_item_status}    Partial Shipment
            ELSE IF    '${status}' == 'IB'  
                Should Contain    ${line_item_status}    Backordered
            ELSE IF    '${status}' == 'ID'  
                Should Contain    ${line_item_status}    Deleted
            ELSE IF    '${status}' == 'IR'  
                Should Contain    ${line_item_status}    Rejected
            END
        END
    END
    Delete All Files In Directory

Create PO with 855 and Validate Invoice
	[Documentation]   Create PO with 855 and Validate Invoice
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Message 855 Case 856    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Check Label and Status
    Open ReceiveOrder Page
    Check UI with Message 855 on ReceiveOrder
    EDI Open Order and Search PO Number
    Open Order Confirmation
    Check UI with Message 855 on Confirmation

    Generate EDI 856 From 855
    Put EDI 856 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 856 status
    Open ReceiveOrder Page
    Check UI with Message 856

    Generate EDI 810 Unhappycase
    Put EDI 810 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 810 status
    Open Order Invoice Page
    Check UI with Message 810 Unhappycase
    Delete All Files In Directory

Create PO with 855 and 810 Incorrect Vendor Item
	[Documentation]   Process 855 and 810 Incorrect Vendor Item
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Update Edi Message    ${env}    855    Curascript
    Connect to SFTP CuraScriptSD
    Put EDI 855 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 855 status
    Check Label and Status
    Open ReceiveOrder Page
    Check UI with Message 855 on ReceiveOrder
    EDI Open Order and Search PO Number
    Open Order Confirmation
    Check UI with Message 855 on Confirmation

    Generate EDI 856 From 855
    Put EDI 856 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 856 status
    Open ReceiveOrder Page
    Check UI with Message 856

    Generate EDI 810 Incorrect Vendor Item
    Put EDI 810 to SFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${jenkins_job_name}
    EDI Open Order and Search PO Number
    Check button 810 status
    Open Order Invoice Page
    Check UI with Message 810 Incorrect Vendor Item
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

Put EDI 855 to SFTP
    ${edi_855}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    Set Global Variable    ${edi_855}
    Put File    ${edi_855}    ${inbound_path}
    Close All Connections
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parsed_data}    Parse Edi 855    ${edi_855_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    BAK
    ${po_number}=       Get From List    ${bak_segment[0]}    3
    Set Global Variable    ${po_number}

Put EDI 856 Unhappycase to SFTP
    ${edi_856}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    Set Global Variable    ${edi_856}
    Put File    ${edi_856}    ${inbound_path}
    Close All Connections
    ${edi_856_content}    Read Edi File    ${edi_856}
    ${parsed_data}    Parse Edi 855    ${edi_856_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    PRF
    ${po_number}=       Get From List    ${bak_segment[0]}    1
    Set Global Variable    ${po_number}

EDI Open Order and Search PO Number
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${po_number}
    Wait Until Element Is Not Visible    ${Find_SearchOrder_LoadingIndicator}    timeout=10s

Check button 855 status
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderConfirmationMessage_Status}
    IF    ${status} == ${True}
        Log To Console    Element with class 'btn-success' is present.
    ELSE
        Fatal Error    msg = Error Processer
    END
Check Label and Status
    ${label}    Get Text    //*[@id="OrderList"]//tr[1]//span
    ${status}    Get Text    //*[@id="item_StatusId"]/option[@selected="selected"]
    ${createdby}    Get Text    //*[@data-itemid="LTE_"]
    Should Contain    ${label}    Order Placed from Different System
    Should Contain    ${status}    Confirmed
    Should Contain    ${createdby}    System

Check UI with Message 855 on ReceiveOrder
    ${ui_poNumber}    Get Text    ${RO_PONumber}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO Number: ', '')
    ${ui_accountNo}    Get Text    ${RO_AccountNumber}
    ${ui_accountNo}    Evaluate    "${ui_accountNo}".replace('Test Account 2 (Acct #: ', '').replace(')', '')

    ${edi_855}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parsed_data}    Parse Edi 855    ${edi_855_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    BAK
    ${msg_poNumber}=       Get From List    ${bak_segment[0]}    3
    ${n1_segment}=    Get From Dictionary    ${parsed_data}    N1
    ${msg_accountNo}=       Get From List    ${n1_segment[0]}    4

    Run Keyword And Continue On Failure    Should Be Equal    ${ui_poNumber}    ${msg_poNumber}
    Run Keyword And Continue On Failure    Should Be Equal    ${ui_accountNo}    ${msg_accountNo}

    ${uom_result}    Run Keyword And Return Status    Element Should Be Visible    ${RO_UoM}
    
    IF    '${uom_result}' == ${True}
        Fatal Error    msg = ${False}
    ELSE
        Log    PO is created without an orderline item
        RETURN    ${True}
    END

Check UI with Message 855 on Confirmation
    ${ui_poNumber}    Get Text    ${CF_PO_Number}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO#: ', '')
    ${ui_accountNo}    Get Text    ${CF_AccountNumber}
    ${ui_accountNo}    Evaluate    "${ui_accountNo}".replace('Account #: ', '')

    ${edi_855}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parsed_data}    Parse Edi 855    ${edi_855_content}
    ${bak_segment}=    Get From Dictionary    ${parsed_data}    BAK
    ${msg_poNumber}=       Get From List    ${bak_segment[0]}    3
    ${n1_segment}=    Get From Dictionary    ${parsed_data}    N1
    ${msg_accountNo}=       Get From List    ${n1_segment[0]}    4
    
    ${po1_segment}=    Get From Dictionary    ${parsed_data}    PO1
    ${line_item}    Get Length    ${po1_segment}

    ${items}=    Get From Dictionary    ${parsed_data}    PO1
    ${index_item}    Set Variable    0

    ${total}    Set Variable    0.00

    FOR    ${index}    IN RANGE    1    ${line_item} * 3    3
        ${cf_price_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${index}]/td[5]/div[1]
        ${cf_price}    Get Text    ${cf_price_xpath}
        ${price}    Evaluate    "${cf_price}".replace('$', '').replace(',', '')

        ${cf_qty_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${index}]/td[6]/div[1]
        ${cf_qty}    Get Text    ${cf_qty_xpath}
        ${qty}    Evaluate    int("${cf_qty}")

        ${item_total}    Evaluate    float(${price}) * ${qty}
        ${total}    Evaluate    "{:.2f}".format(float(${total}) + ${item_total})

        ${cf_itemNo_xpath}    Set Variable    //*[@id='body']//div[3]/div[3]//tr[${index}]/td[3]/div[1]
        ${cf_itemNo}    Get Text    ${cf_itemNo_xpath}
        ${itemNo}    Evaluate    "${cf_itemNo}".replace('Item No: ', '').replace('-', '')

        ${item}    Get From List    ${items[${index_item}]}    9
        Run Keyword And Continue On Failure    Should Be Equal    ${item}    ${itemNo}

        ${index_item}    Evaluate    ${index_item} + 1
    END

    ${cf_po_total_xpath}    Set Variable    //*[@id="POTotal"]
    ${cf_po_total}    Get Text    ${cf_po_total_xpath}
    ${cf_po_total}    Evaluate    "${cf_po_total}".replace('$', '').replace(',', '')


    Run Keyword And Continue On Failure    Should Be Equal    ${ui_poNumber}    ${msg_poNumber}
    Run Keyword And Continue On Failure    Should Be Equal    ${ui_accountNo}    ${msg_accountNo}
    Run Keyword And Continue On Failure    Should Be Equal    ${cf_po_total}    ${total}

    ${uom_result}    Run Keyword And Return Status    Element Should Be Visible    ${RO_UoM}
    
    IF    '${uom_result}' == ${True}
        Fatal Error    msg = ${False}
    ELSE
        Log    PO is created without an orderline item
        RETURN    ${True}
    END

    ${item_checkbox}    Run Keyword And Return Status    Element Should Be Visible    //*[@id[contains(., 'AcceptedItem_')] and @checked]
    ${qty_checkbox}    Run Keyword And Return Status    Element Should Be Visible    //*[@id[contains(., 'AcceptedQty_')] and @checked]

Generate EDI 856 From 855
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_856}    Create 856 From 855 Curascript    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${edi_856}
    ${check}    edi_callggsheetapi.Validate Field 856    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 856 fail
    END

Generate EDI 856 Unhappycase From 855
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_856}    Create Message 856 Unhappy    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${edi_856}
    ${check}    edi_callggsheetapi.Validate Field 856    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 856 fail
    END

Generate EDI 856 Difference Qty
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_856}    Create 856 Different Qty    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${edi_856}
    ${check}    edi_callggsheetapi.Validate Field 856    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 856 fail
    END

Put EDI 856 to SFTP
    Connect to SFTP CuraScriptSD
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt    ${inbound_path}
    Close All Connections

Check button 856 status
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderShippingMessage_Status}
    IF    ${status} == ${True}
        Log To Console    Element with class 'btn-success' is present.
    ELSE
        Fatal Error    msg = Error Processer
    END

Check UI with Message 856
    ${ui_poNumber}    Get Text    ${RO_PONumber}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO Number: ', '')
    ${ui_accountNo}    Get Text    ${RO_AccountNumber}
    ${ui_accountNo}    Evaluate    "${ui_accountNo}".replace('Test Account 2 (Acct #: ', '').replace(')', '')

    ${edi_856_content}    Read Edi File    ${EXECDIR}/tests/edi/message_ui/${po_number}_856.txt
    ${parsed_data}    Parse Edi 855    ${edi_856_content}
    ${prf_segment}=    Get From Dictionary    ${parsed_data}    PRF
    ${msg_poNumber}=       Get From List    ${prf_segment[0]}    1
    ${msg_accountNumber}    Get Ref Value    ${parsed_data}    11

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

Generate EDI 810 From 855
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_810}    Create 810 From 855 Curascript    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    ${check}    edi_callggsheetapi.Validate Field 810    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 810 fail
    END

Generate EDI 810 Unhappycase
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_810}    Create 810 Invoice New Item    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    ${check}    edi_callggsheetapi.Validate Field 810    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 810 fail
    END

Generate EDI 810 Incorrect Vendor Item
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parse_855}    Parse Edi 855    ${edi_855_content}
    ${edi_810}    Create 810 Incorrect Vendor Item    ${parse_855}
    Create File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${edi_810}
    ${check}    edi_callggsheetapi.Validate Field 810    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 810 fail
    END

Put EDI 810 to SFTP
    Connect to SFTP CuraScriptSD
    Put File    ${EXECDIR}/tests/edi/message_ui/${po_number}_810.txt    ${inbound_path}
    Close All Connections
    
Check button 810 status
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderInvoiceMessage_Status}
    IF    ${status} == ${True}
        Log To Console    Element with class 'btn-success' is present.
    ELSE
        Fatal Error    msg = Error Processer
    END

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
        ${in_invoiceAmount}    Evaluate    "${in_invoiceAmount}".replace('$', '').replace(',', '')
        ${msg_price}    Set Variable    ${parsed_810_data['IT1'][${index}-1][4]}
        ${result}    Evaluate    float(${msg_qty}) * float(${msg_price})
        ${result_msg_price}    Evaluate    "{:.2f}".format(${result})
        Run Keyword And Continue On Failure    Should Be Equal    ${in_invoiceAmount}    ${result_msg_price}
    END

Check PO Blank
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'PO is empty; Invalid PO')]
    Should Contain    ${text}    PO is empty; Invalid PO

Check ReceiveId Blank
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'The EDI Address is empty')]
    Should Contain    ${text}    EDI Address: - The EDI Address is empty

Check ReceiveId Incorrect
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'Not found distributors from EDI Address')]
    Should Contain    ${text}    Not found distributors from EDI Address

Check Price Confirmation
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    xpath=//*[@style="color:firebrick;" and @class="adjustedPrice"]    timeout=5s
    Log To Console    The item price is displayed in red

Check Vendor Item In EDI Tools
    ${text}    Get Text    //tr[2]//*[@id="ErrorDetail"]/*[contains(text(), 'Item Missing from system')]
    Should Contain    ${text}    Item Missing from system

Check Message on EDITools
    Wait Until Element Is Enabled    //tr[2]//*[contains(text(), 'View Details')]
    Click Element    //tr[2]//*[contains(text(), 'View Details')]
    Sleep    3
    ${content}    Get Text    //div[contains(@class,"fade in")]//*[@id="FileContent"]

    ${edi_855}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${edi_855_content}    Read Edi File    ${edi_855}
    Should Be Equal    ${content}    ${edi_855_content}

Check New Line Item
    ${line_item}    Get Text    //tr[4]/td[1]
    ${itemNo}    Get Text    //tr[4]/td[3]/div[1]
    ${vendorItem}    Get Text    //tr[4]/td[3]/div[3]

    ${ui_poNumber}    Get Text    ${CF_PO_Number}
    ${ui_poNumber}    Evaluate    "${ui_poNumber}".replace('PO#: ', '')
    ${ui_accountNo}    Get Text    ${CF_AccountNumber}
    ${ui_accountNo}    Evaluate    "${ui_accountNo}".replace('Account #: ', '')

    ${edi_855}    Get Latest File    ${EXECDIR}\\tests\\edi\\message_ui\\
    ${edi_855_content}    Read Edi File    ${edi_855}
    ${parsed_data}    Parse Edi 855    ${edi_855_content}
    ${prf_segment}=    Get From Dictionary    ${parsed_data}    PRF
    ${msg_poNumber}=       Get From List    ${prf_segment[0]}    1
    ${n1_segment}=    Get From Dictionary    ${parsed_data}    REF
    ${msg_accountNo}=    Get Value By Ref Key    ${n1_segment}

    Should Be Equal    ${ui_poNumber}    ${msg_poNumber}
    Should Be Equal    ${ui_accountNo}    ${msg_accountNo}
    Should Not Be Empty    ${line_item}

Check UI with Message 810 Unhappycase
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

    ${line_item}    Get Text    //tr[1]/td[15]
    Run Keyword And Continue On Failure    Should Be Equal    ${line_item}    1

Check UI with Message 810 Incorrect Vendor Item
    Element Should Not Be Visible    //tr[1]/td[15]