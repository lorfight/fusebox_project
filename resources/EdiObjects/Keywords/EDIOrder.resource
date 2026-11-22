*** Settings ***
Library    SeleniumLibrary
Library    SSHLibrary
Library    ../TestData/list_utils.py
Library    ../TestData/process_file.py
Library    ../TestData/EdiTestdata.py
Library    ../TestData/edi_callggsheetapi.py
Library    ../../PageObjects/Locators/CreateOrderLocator.py
Variables    ../../PageObjects/Locators/OrderLocator.py
Resource    ../../PageObjects/Keywords/LoginKeywords.resource
Resource    ../../PageObjects/Keywords/CommonKeywords.resource
Resource    ../../PageObjects/Keywords/OpenOrder.resource
Resource    ../../PageObjects/Keywords/Order.resource
Resource    ../../PageObjects/Keywords/InventoryLevel.resource
Resource    ../../EdiObjects/Keywords/CallAPIAndRunWebjob.resource

*** Variables ***
${FileContent}    //div[contains(@class,"fade in")]//*[@id="FileContent"]
${remote_dir}    /outbound
${ClearButton}    //*[@id="ClearButton"]
${timeout}    60

*** Keywords ***

EDI Create Order
	EDI Built Order CuraScriptSD

EDI Create Order MCKessonSH
	EDI Built Order MCKessonSH

EDI Create Order Takeda
	EDI Built Order Takeda   

EDI Create Order Biocare
	EDI Built Order Biocare   
EDI Create Order Cencora_Besse
	EDI Built Order Cencora_Besse   

EDI Create Order McKesson Medical Surgical
    EDI Built Order McKesson Medical Surgical

EDI Create Order FFF
    EDI Built Order FFF

EDI Create Order Medline
    EDI Built Order Medline

Open Order and Get msg 850
    # Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${edi_po_number}
    Wait Loading
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Enabled    ${EDI_Details}    ${timeout}
    WHILE    '${status}' == 'False'
        EDI Search For An Order ${edi_po_number}
        ${status}=    Run Keyword And Return Status    Wait Until Element Is Enabled    ${EDI_Details}    ${timeout}
    END
    Check Order Send Message Status
    Wait Until Page Contains Element    ${OrderSendMessage}    ${timeout}    error=OrderSendMessage is not enable
	Click Element    ${OrderSendMessage}
	Copy File Content    ${FileContent}

Clear Button
    Wait Until Element Is Enabled    ${ClearButton}    ${timeout}
    Click Element    ${ClearButton}
    Wait Loading

Wait Loading
    Wait Until Element Is Visible    ${Find_SearchOrder_LoadingIndicator}    ${timeout}
    Wait Until Element Is Not Visible    ${Find_SearchOrder_LoadingIndicator}    ${timeout}

Filter Distributor
    Click Element    //*[@data-id="DistributorId"]
    Click Element    ${Filter_Distributor}
    Sleep    2

Filter Location
    Click Element    //*[@data-id="MemberId"]
    Click Element    ${Filter_Location}
    Sleep    2

Handle Alert Open Order
    Click Element    //*[@id="item_StatusId"]
    Click Element    //*[@id="item_StatusId"]/option[5]
    Handle Alert
    Sleep    5

EDI Open Order
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${edi_po_number}
    Sleep    3
    Handle Alert Open Order
    Check Order Confirmation Message Status
    Open Order Confirmation

Open Order 856
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${edi_po_number}
    Sleep    3s
    Check Order Shipping Message Status
    
Open Order 810
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${edi_po_number}
    Sleep    3s
    Check Order Invoice Message Status

Check Order Send Message Status
    Wait Until Element Is Enabled    ${OrderSendMessage_Status}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderSendMessage_Status}
    Run Keyword If    ${status}    Log To Console    Element with class 'btn-success' is present.
    IF    ${status} == ${False}
        Fatal Error    msg = Button status fail
    END

Check Order Received Message Status
    Wait Until Element Is Enabled    ${OrderReceivedMessage_Status}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderReceivedMessage_Status}
    Run Keyword If    ${status}    Log To Console    Element with class 'btn-success' is present.
    IF    ${status} == ${False}
        Fatal Error    msg = Button status fail
    END

Check Order Confirmation Message Status
    Wait Until Element Is Enabled    ${OrderConfirmationMessage_Status}    ${timeout}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderConfirmationMessage_Status}
    Run Keyword If    ${status}    Log To Console    Element with class 'btn-success' is present.
    IF    ${status} == ${False}
        Fatal Error    msg = Button status fail
    END

Check Order Shipping Message Status
    Wait Until Page Contains Element    ${OrderShippingMessage_Status}    ${timeout}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderShippingMessage_Status}
    Run Keyword If    ${status}    Log To Console    Element with class 'btn-success' is present.
    IF    ${status} == ${False}
        Fatal Error    msg = Button status fail
    END

Check Order Invoice Message Status
    Wait Until Page Contains Element    ${OrderInvoiceMessage_Status}    ${timeout}
    ${status}=    Run Keyword And Return Status    Element Should Be Visible    ${OrderInvoiceMessage_Status}
    Run Keyword If    ${status}    Log To Console    Element with class 'btn-success' is present.
    IF    ${status} == ${False}
        Fatal Error    msg = Button status fail
    END

Open Order Invoice Page
    Wait Until Element Is Enabled    ${Invoice}    ${timeout}
    Click Element    ${Invoice}
    Switch Tab
    Wait Until Page Contains Element    //*[text()="Home"]    ${timeout}

Open Order Confirmation
    Click Element    ${Confirmation}
    Switch Tab
    Sleep    5
    Wait Until Page Contains Element    //*[text()="Home"]    ${timeout}

Open ReceiveOrder Page
    Wait Until Element Is Visible    ${OO_ReceiveOrder}    ${timeout}
    Click Element    ${OO_ReceiveOrder}
    Wait Until Page Contains Element    //*[text()="Home"]    ${timeout}

Open TrackPackage
    Sleep    5s
    Click Element    ${TrackPackage}

Open EDI Tools
    Click Element    link: Administration
    Click Element    link: EDI Tools
    Title Should Be    Edi Tools

Filter 855
    ${datenow}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}  Get Current Date    result_format=%m/%d/%Y    increment=-1 days
    ${end_date}  Get Current Date    result_format=%m/%d/%Y    increment=1 days
    Click Element    //*[@data-id="EdiFileTypeId"]
    Click Element    //*[@role='combobox']//*[text() = 'Order Confirmation (855)']
    Sleep    5
    Select Checkbox    //*[@id="ViewUnknownRecipients"]
    Select Checkbox    //*[@id="ViewFailedOnly"]
    Sleep    5
    Input Text    //*[@id="StartDate"]    ${start_date}
    Input Text    //*[@id="EndDate"]    ${end_date}
    Click Element    //*[@id="SearchButton"]
    Sleep    5

Filter 856
    ${datenow}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}  Get Current Date    result_format=%m/%d/%Y    increment=-1 days
    ${end_date}  Get Current Date    result_format=%m/%d/%Y    increment=1 days
    Click Element    //*[@data-id="EdiFileTypeId"]
    Click Element    //*[@role='combobox']//*[text() = 'Order Shipping Notice (856)']
    Sleep    5
    Select Checkbox    //*[@id="ViewUnknownRecipients"]
    Select Checkbox    //*[@id="ViewFailedOnly"]
    Sleep    5
    Input Text    //*[@id="StartDate"]    ${start_date}
    Input Text    //*[@id="EndDate"]    ${end_date}
    Click Element    //*[@id="SearchButton"]
    Sleep    5

Filter 810
    ${datenow}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}  Get Current Date    result_format=%m/%d/%Y    increment=-1 days
    ${end_date}  Get Current Date    result_format=%m/%d/%Y    increment=1 days
    Click Element    //*[@data-id="EdiFileTypeId"]
    Click Element    //*[@role='combobox']//*[text() = 'Order Invoice (810)']
    Sleep    5
    Select Checkbox    //*[@id="ViewUnknownRecipients"]
    Select Checkbox    //*[@id="ViewFailedOnly"]
    Sleep    5
    Input Text    //*[@id="StartDate"]    ${start_date}
    Input Text    //*[@id="EndDate"]    ${end_date}
    Click Element    //*[@id="SearchButton"]
    Sleep    5

Copy File Content
    [Arguments]    ${selector}
    Wait Until Keyword Succeeds    ${timeout}    3s    Click Element    ${FileContent}
    ${content}    Get Text    ${FileContent}
    ${file_handle}    Set Variable    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_850.txt
    Create File    ${file_handle}    ${content}
    Click Element    //div[contains(@class,"fade in")]//*[@id="CloseBtn"]

EDI Built Order CuraScriptSD
    Go Order
    ${ndc_list}    Create List    ${CuraScriptSD_ndc1}    ${CuraScriptSD_ndc2}
    EDI Config Order   ${location}    ${ndc_list}    ${vendor}    1
    EDI Config My Cart
    EDI Submit Order

EDI Built Order MCKessonSH
    Go Order
    ${ndc_list}    Create List    ${MCKessonSH_ndc}
    EDI Config Order  ${location}    ${ndc_list}    ${vendor}    1
    EDI Config My Cart
    EDI Submit Order

EDI Built Order Takeda
    Go Order
    ${ndc_list}    Create List    ${Takeda_ndc1}
    EDI Config Order   ${location}    ${ndc_list}    ${vendor}    2
    EDI Config My Cart
    EDI Submit Order

EDI Built Order Biocare
    Go Order
    ${ndc_list}    Create List    ${Biocare_ndc1}    ${Biocare_ndc2}
    EDI Config Order   ${location}    ${ndc_list}    ${vendor}    1
    EDI Config My Cart
    EDI Submit Order

EDI Built Order Cencora_Besse
    Go Order
    ${ndc_list}    Create List    ${Cencora_Besse_ndc1}    ${Cencora_Besse_ndc2}
    EDI Config Order   ${location}    ${ndc_list}    ${vendor}    2
    EDI Config My Cart
    EDI Submit Order

EDI Built Order McKesson Medical Surgical
    Go Order
    ${ndc_list}    Create List    ${McKessonMS_ndc1}    ${McKessonMS_ndc2}
    EDI Config Order    ${location}    ${ndc_list}    ${vendor}    2
    EDI Config My Cart
    EDI Submit Order

EDI Built Order FFF
    Go Order
    ${ndc_list}    Create List    ${FFF_ndc1}    ${FFF_ndc2}
    EDI Config Order    ${location}    ${ndc_list}    ${vendor}    1
    FFF Config My Cart
    EDI Submit Order

EDI Built Order Medline
    Go Order
    ${ndc_list}    Create List    ${Medline_ndc1}    ${Medline_ndc2}
    EDI Config Order    ${location}    ${ndc_list}    ${vendor}    1
    EDI Config My Cart
    EDI Submit Order

EDI Submit Order
    Wait Until Element Is Enabled    link:Submit Order
    Wait Until Keyword Succeeds    15s    15s    Click Element    link: Submit Order
    Wait Until Keyword Succeeds    15s    15s    Handle Alert And Return Its Text
    Wait Until Element Is Not Visible    //*[@id="processing-indicator"]    ${timeout}

EDI Config My Cart
    # Wait Until Element Is Enabled    link:Order Note    timeout=60s    error=Loading page takes too long
    # Wait Until Keyword Succeeds    ${timeout}    3s    Click Button     id=SetDistibutorPONumberButton
    # Wait Until Page Contains Element    //*[@id="modalDialogLabel"]    ${timeout}    error=Loading page takes too long
    # Wait Until Keyword Succeeds    ${timeout}    3s    Element Text Should Be    //*[@id="modalDialogLabel"]    ${vendor} : PO Number
    # ${edi_po_number}=    Get Value    //*[@id="modalDialogText"]

    # Wait Until Element Is Enabled    //*[@id="SetDistibutorPONumberButton"]    ${timeout}
    # ${edi_po_number}=    Get Text    //*[@id="SetDistibutorPONumberButton"]
    # Set Global Variable    ${edi_po_number}
    # Create File    ../PONumber.txt    ${edi_po_number}
    # Click Button    Save

    Wait Until Element Is Enabled    link:Order Note    timeout=15s    error=Loading page takes too long
    ${date_time}=    Get Time Now   result_format=%m%d%Y%H%M
    ${edi_po_number}=    Set Variable    AT_DL_${date_time[:8]}_${date_time[8:]}
    Set Global Variable    ${edi_po_number}
    Log To Console     PO#: ${edi_po_number}
    Log To Console    Distributor: ${vendor}
    Create File    ${EXECDIR}/tests/edi/PONumber.txt    ${edi_po_number}
    Wait Until Element Is Enabled    id=SetDistibutorPONumberButton
    Click Button     id=SetDistibutorPONumberButton
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[@id="modalDialogText"]    timeout=15s    error=Loading page takes too long
    Sleep    5s
    Util.Input Text When Enabled    locator=//*[@aria-hidden="false"]//*[@id="modalDialogText"]    text=${edi_po_number}
    Click Button    Save

FFF Config My Cart
    Wait Until Element Is Enabled    //*[@id="SetDistibutorPONumberButton"]    ${timeout}
    ${edi_po_number}=    Get Text    //*[@id="SetDistibutorPONumberButton"]
    Set Global Variable    ${edi_po_number}
    Create File    ${EXECDIR}/tests/edi/PONumber.txt    ${edi_po_number}

EDI Search For An Order ${edi_po_number}
    Wait Until Element Is Enabled    id=SearchValues    ${timeout}
    Input Text    id=SearchValues    ${edi_po_number}
    Wait Until Element Is Visible    //*[@id="FindButton"]    ${timeout}
    Wait Until Element Is Enabled   //*[@id="FindButton"]    ${timeout}
    Click Element    //*[@id="FindButton"]

Connect to SFTP CuraScriptSD
    Open Connection    ${curascript_hostname}
    Login    ${curascript_username}    ${curascript_password}

Connect to SFTP MCKessonSH
    Open Connection    ${mckessonsh_hostname}
    Login    ${mckessonsh_username}    ${mckessonsh_password}

Connect to SFTP Takeda
    Open Connection    ${takeda_hostname}
    Login    ${takeda_username}    ${takeda_password}

Connect to SFTP Biocare
    Open Connection    ${biocare_hostname}
    Login    ${biocare_username}    ${biocare_password}
    
Connect to SFTP Cencora_Besse
    Open Connection    ${cencora_besse_hostname}
    Login    ${cencora_besse_username}    ${cencora_besse_password}

Connect to SFTP McKesson_Medical_Surgical
    Open Connection    ${MCKessonMS_hostname}
    Login    ${MCKessonMS_username}    ${MCKessonMS_password}

Connect to SFTP Van
    Open Connection    ${Van_hostname}
    Login    ${Van_username}    ${Van_password}

Connect to SFTP FFF
    Open Connection    ${fff_hostname}
    Login    ${fff_username}    ${fff_password}

Connect to SFTP Medline
    Open Connection    ${medline_hostname}
    Login    ${medline_username}    ${medline_password}

Get Before Order File List sFTP
    [Documentation]    Get the list of files in the remote directory before the order.
    ${before_files}=    SSHLibrary.List Directory    ${outbound_path}
    Set Suite Variable    ${before_files}

Get After Order File List sFTP
    [Documentation]    Get the list of files in the remote directory after the order
    ${after_files}=    SSHLibrary.List Directory    ${outbound_path}
    Set Suite Variable    ${after_files}

Find Difference File
    [Documentation]    Find the new file added after the order.
    ${dif_files}=    Get Difference Between Lists    ${after_files}    ${before_files}
    Set Global Variable    ${file_name}    ${dif_files}[0]
    SSHLibrary.Get File    /${outbound_path}/${file_name}    ${EXECDIR}/tests/edi/message_sftp/${file_name}

Compare Files
    [Documentation]    Compare the content of two files.
    ${file_ui}    process_file.Read File To String    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    process_file.Split Content And Write To File    ${EXECDIR}\\tests\\edi\\message_sftp\\${file_name}
    ${file_sftp}    process_file.Remove Last Two Chars    ${EXECDIR}\\tests\\edi\\message_sftp\\${file_name}
    ${file_sftp}    process_file.Read File To String    ${EXECDIR}\\tests\\edi\\message_sftp\\${file_name}
    Should Be Equal As Strings    ${file_ui}    ${file_sftp}

Validate 850 GAP
    [Documentation]    Validate field on msg 850
    ${check}    edi_callggsheetapi.Validate Field 850    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_850.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 850 fail
    END
EDI Config Order
    [Arguments]    ${location}    ${ndc_list}    ${vendor}    ${order_qty}
    EDI Select Customer Account    ${location}
    Wait Until Element Is Not Visible    ${History_LoadingIndicator}    ${timeout}
    EDI Filter By Vendor   ${vendor}
    Wait Until Element Is Not Visible    ${History_LoadingIndicator}    ${timeout}
    Wait Until Element Is Not Visible    ${Search_LoadingIndicator}    ${timeout}
    FOR    ${ndc}    IN    @{ndc_list}
        EDI Find NDC   ${ndc}
        Sleep    5
        Wait Until Keyword Succeeds    10 times    5s    EDI Add Quality    ${order_qty}
    END

EDI Find NDC
    [Arguments]    ${ndc}
    Wait Until Element Is Enabled    id=SearchValues    ${timeout}
    Input Text    id=SearchValues    ${ndc}
    Click Button    //*[@id="FindButton"]
    Sleep    5

EDI Filter By Vendor
    [Arguments]    ${vendor}
    Set Test Variable    ${vendor}
    Click Element    //*[@data-id='VendorAccountId']
    Input Text    ${input_Vendor}    ${vendor}
    ${Select_Vendor}    Replace Variables    ${Select_Vendor}
    Click Element    ${Select_Vendor}
    Sleep    5

EDI Add Quality
    [Arguments]    ${order_qty}
    Util.Scroll To Bottom
    Util.Verify Loading And Select By Label    item_DefaultContractAndVendor    ${vendor}
    Wait Until Element Is Not Visible    ${History_LoadingIndicator}    ${timeout}
    Wait Until Element Is Not Visible    ${Search_LoadingIndicator}    ${timeout}
    Input Text    ${SearchOrder_input}    ${order_qty}
    Wait Until Element Is Enabled    ${AddQty_button}
    Click Element     ${AddQty_button}
    Sleep    5

EDI Select Customer Account
    [Arguments]    ${location}
    Set Test Variable    ${location}
    Click Element    //*[@data-id='CustomerId']
    Input Text    ${Input_Account}    ${location}
    Sleep    5
    Click Element    ${Select_TestAccount2}

Validate 810 GAP
    [Documentation]    Validate field on msg 810
    ${check}    edi_callggsheetapi.Validate Field 856    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_810.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 810 fail
    END

Validate 855 GAP
    [Documentation]    Validate field on msg 855
    ${check}    edi_callggsheetapi.Validate Field 855    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_855.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 855 fail
    END

Validate 856 GAP
    [Documentation]    Validate field on msg 856
    ${check}    edi_callggsheetapi.Validate Field 856    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_856.txt    ${env}
    IF    ${check} == ${False}
        Fatal Error    msg = Message 856 fail
    END

Delete All Files In Directory
    Delete All Files In Folder    ${EXECDIR}/tests/edi/message_ui
    Delete All Files In Folder    ${EXECDIR}/tests/edi/message_sftp

Get Data EDI
    ${data_input}    EdiTestdata.Get Data From Sheets Custom    suite='CreateOrder'    source=${SUITE_SOURCE}
    ${data_configs}    EdiTestdata.Get Edi Configs    env=${env}
    RETURN    ${data_input}    ${data_configs}