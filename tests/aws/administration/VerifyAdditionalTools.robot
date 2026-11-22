*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/AdditionalTools/AdditionalTools.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    ClinicSmokeLogImp    test:retry(3)    ADM_06

*** Test Cases ***
Verify Display Order Invoice Ledger
    [Documentation]    ADM-6: Display Invoice Ledger
    [Tags]    Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.Go To Invoice Ledger
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Invoice Ledger
    InvoiceLedger.Click Filter Search Button
    Wait Until Element Is Visible    //*[@id='InvoiceLedgerList']//*[@class='order-row'][1]    60s

Verify Display Reconciled Invoices
    [Documentation]    ADM-7: Display Invoice Ledger
    [Tags]    Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.View Reconciled Invoices
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Invoice Ledger
    List Selection Should Be    id=StatusID    Reconciled

Verify Display Fee Tracker
    [Documentation]    ADM-8: Display Fee Tracker
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.Go To Fee Tracker
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Fee Tracker
    FeeTracker.Click Filter Search Button
    ${is_available}    Run Keyword And Return Status    Wait Until Element Is Visible    //*/*[@data-feeid][1]
    Run Keyword If    ${is_available} == ${False}    Wait Until Element Is Visible    //*[contains(text(),'No Fees Found')]    60s

Verify Display Order History
    [Documentation]    ADM-9: Display Order History
    [Tags]    Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.Go To Order History
    OrderHistory.Filter Status    status=Received
    OrderHistory.Click Filter Search Button
    Wait Until Element Is Visible    //tbody/*[1]/*[@class='DateOfServiceRow']/following::*[@href and text()='Review Order'][1]    60s

Verify Send Test Order
    [Documentation]    ADM-10: Send Test Order
    [Tags]    Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.Click Send Test Order
    Set Selenium Timeout    30s
    ${alert}    Wait Until Keyword Succeeds    20 times    3s    Util.Handle Alert And Return Its Text
    Should Be Equal    ${alert}    Test Order successfully sent    ignore_case=True
    Set Selenium Timeout    5s

Verify Display Barcode Configuration Report
    [Documentation]    ADM-11: Display Barcode Configuration Report
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    AdditionalTools.Go To Additional Tools
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Tools
    AdditionalTools.Go To Report Viewer
    Switch To Another Window    title=Report Viewer
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Report Viewer
    Wait Until Element Is Visible    //*[@style and contains(text(),'DS8178 Barcode Scanner Configuration')]    60s
    ${text}    Get Step Text    step=Step 1    line=//*[@style and text()='\${step}:']/following::*[1]/*
    Should Match Regexp    ${text}    .*charging.*plugged.*USB.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 2    line=//*[@style and text()='\${step}:']/parent::*/preceding-sibling::*[1]/*
    Should Match Regexp    ${text}    .*scanner.*charged.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 3    line=//*[@style and text()='\${step}:']/following::*[1]/*
    Should Match Regexp    ${text}    .press.*scan.*red.*laser.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 4    line=//*[@style and text()='\${step}:']/parent::*/preceding-sibling::*[1]/*
    Should Match Regexp    ${text}    .*scan.*settings.*barcode.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 5    line=//*[@style and text()='\${step}:']/following::*[1]/*
    Should Match Regexp    ${text}    .*low.*high.*beep.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 6    line=//*[@style and text()='\${step}:']/parent::*/preceding-sibling::*[1]/*
    Should Match Regexp    ${text}    .*scan.*back.*charger.*QR.*light.*green.*beep.*    flags=IGNORECASE
    ${text}    Get Step Text    step=Step 7    line=//*[@style and text()='\${step}:']/following::*[1]/*
    Should Match Regexp    ${text}    .*home.*scan.*barcode.*scanner.*running.*    flags=IGNORECASE
    Close Window

*** Keywords ***
Suite Setup Keyword
    [Documentation]    Suite Setup
    [Tags]    Setup
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    LoginKeywords.Check Newsletter

Test Setup Keyword
    ${check}    Run Keyword And Return Status    Switch To Another Window    Home
    Return From Keyword If    ${check} == ${True}
    Open New Window    ${SiteUrl}
    Close Window
    Wait Until Keyword Succeeds    20 times    3s    Switch To Another Window    Home

Open New Window
    [Arguments]    ${url}
    Execute Javascript    window.open('${url}','_blank')
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Set Window Size    1920    1080
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title}
    Switch Window    ${title}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    ${title}
    Wait Until Keyword Succeeds    10 times    3s    LoginKeywords.Check Newsletter
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

Setup Data
    ${data_input}    CommonKeywords.Get Data
    Set Suite Variable    ${mode}    headless
    Set Suite Variable    ${location_id}    ${data_input}[location_id]

Get Step Text
    [Arguments]    ${step}    ${line}
    ${text}    Set Variable    ${EMPTY}
    ${line}    Replace Variables    ${line}
    ${lines}    Get Element Count    ${line}
    FOR    ${i}    IN RANGE    ${lines}
        Scroll Element Into View    ${line}\[${i+1}]
        ${text_line}    Get Text    ${line}\[${i+1}]
        ${text}    Set Variable    ${text} ${text_line}
    END
    RETURN    ${text}
