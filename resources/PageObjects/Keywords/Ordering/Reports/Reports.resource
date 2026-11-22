*** Settings ***
Resource    ../Common/OrderUtils.resource
Resource    Patient/PriorAuthorizationOrNextDOS.resource

*** Keywords ***
Go to Reports
    Click Element    link: Ordering
    Click Element    link: Reports
    Switch Window    Reports

Create New Report
    Click Element    link: Create New Report
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[text()="Create Report"]

Scheduled Report Settings
    Click Element    link: Scheduled Report Settings
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[text()="Automated Scheduled Report Modal Settings"]

Comprehensive Excel Reports
    [Arguments]    ${report_generate}    ${select_report}
    IF    "${report_generate}" == "Dispense"
        Comprehensive Excel Reports Dispense    select_report=${select_report}
    ELSE IF    "${report_generate}" == "Patient"
        Comprehensive Excel Reports Patient    select_report=${select_report}
    ELSE IF    "${report_generate}" == "Inventory"
        Comprehensive Excel Reports Inventory    select_report=${select_report}
    ELSE IF    "${report_generate}" == "Purchase Order"
        Comprehensive Excel Reports Purchase Order    select_report=${select_report}
    ELSE IF    "${report_generate}" == "Log"
        Comprehensive Excel Reports Log    select_report=${select_report}
    ELSE
        Log    Fail Comprehensive Excel Reports
    END
    
    
Comprehensive Excel Reports Dispense
    [Arguments]    ${select_report}
    Click Element     //button[contains(text(),"Dispense")]
    Click Element     //button[contains(text(),"Dispense")]/following::a[contains(text(),"${select_report}")]
    Waiting For Loading

Comprehensive Excel Reports Patient
    [Arguments]    ${select_report}
    Click Element     //button[contains(text(),"Patient")]
    Click Element     //button[contains(text(),"Patient")]/following::a[contains(text(),"${select_report}")]
    Waiting For Loading
    
Comprehensive Excel Reports Inventory
    [Arguments]    ${select_report}
    Click Element     //button[contains(text(),"Inventory")]
    Click Element     //button[contains(text(),"Inventory")]/following::a[contains(text(),"${select_report}")]
    Waiting For Loading
    
Comprehensive Excel Reports Purchase Order
    [Arguments]    ${select_report}
    Click Element     //button[contains(text(),"Purchase Order")]
    Click Element     //button[contains(text(),"Purchase Order")]/following::a[contains(text(),"${select_report}")]
    Waiting For Loading

Comprehensive Excel Reports Log
    [Arguments]    ${select_report}
    Click Element     //button[contains(text(),"Log")]
    Click Element     //button[contains(text(),"Log")]/following::a[contains(text(),"${select_report}")]
    Waiting For Loading
