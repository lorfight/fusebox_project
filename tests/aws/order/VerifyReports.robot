*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Ordering/Reports/Reports.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyAccount/MyAccount.resource


Test Tags    Prime    REP_100    report.label.owner:Cuong Pham    test:retry(2)
Suite Setup    Suite Setup
Test Setup    Go To Home
Suite Teardown    Close All Browsers


*** Test Cases ***
Verify Create New Report
    [Documentation]    REP_1    
    Reports.Go to Reports
    Reports.Create New Report
    [Teardown]    Close Modal

Verify Scheduled Report Settings
    [Documentation]    REP_2
    Reports.Go to Reports
    Reports.Scheduled Report Settings
    [Teardown]    Close Modal

Verify Comprehensive Excel Reports
    [Documentation]    REP_4
    Reports.Go to Reports
    @{comprehensive_excel_reports}    Create List    Dispense    Patient    Inventory    Purchase Order
    ${report_generate}    Evaluate    random.choice(${comprehensive_excel_reports})
    @{select_report_webelements}    Get WebElements    //button[contains(text(),"${report_generate}")]/following::ul[1]/li/a
    @{select_reports}    Create List
    FOR    ${select_report_webelement}    IN    @{select_report_webelements}
        ${select_report}    Get Element Attribute       ${select_report_webelement}    text
        Collections.Append To List    ${select_reports}    ${select_report}
    END
    ${select_report}    Evaluate    random.choice(@{select_reports})
    Reports.Comprehensive Excel Reports    ${report_generate}    select_report=${select_report}
    
    ${generate_report}    Run Keyword And Return Status     Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[contains(text(),"Generate")]    10s
    Run Keyword If    "${generate_report}" == "True"    Wait Until Keyword Succeeds    3times    3s    Generate Report Success
    Waiting For Loading
    # Close Modal

Verify Report Queue
    [Documentation]    REP_5
    Go Report Queue
    Waiting For Loading
    Cancel Queue
    
    
*** Keywords ***
Go To Home
    Click Element    Link: Home
    Waiting For Loading

Suite Setup
    Login To Fusebox    ${Username}    ${Password}
    Go To My Account
    Util.Scroll Into View    locator="//input[@id='UtilizeReportQueue']"    inline=end
    Select Checkbox    locator=//input[@id='UtilizeReportQueue']
    Click Button    Save
    
Generate Report Success
    Wait Until Element Is Enabled    //*[@aria-hidden="false"]//*[contains(text(),"Generate")]
    Click Element    //*[@aria-hidden="false"]//*[contains(text(),"Generate")]
    Wait Until Page Contains    Report Added to the Queue

Go Report Queue
    Click Element    link: Ordering
    Click Element    link: Report Queue
    Switch Window    Queued Reports

Cancel Queue
    Click Element    //*[@id="QueueList"]//*[@title="Cancel"]
    Wait Until Page Contains    Report Canceled    5s

Close Modal
    Wait Until Element Is Enabled    //*[@aria-hidden="false"]//*[text()="Close"]    15s
    Click Element    //*[@aria-hidden="false"]//*[text()="Close"]