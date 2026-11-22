*** Settings ***
Documentation      Warm up to Fusebox
Variables   ../../../resources/PageObjects/TestData/Testdata.py
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Resource	../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource    ../../../resources/PageObjects/Keywords/Order.resource

Suite Setup    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session


*** Test Cases ***
Check page
    [Tags]    Smoke    Admin
    ...  report.label.owner:Hieu Huynh
    ...  report.label.severity:normal
    ...  report.label.epic:Web interface
    ...  report.label.feature:Essential features
    ...  report.label.story:General
    ${param}    Create List    /PatientOrder/Index/MTM0NjQ_    /PriorAuthorization/Index/MTM0NjQ_    
    ...    /Appointment/Index/MTM0NjQ_    /Billing/Index/MTM0NjQ_    
    ...    /Patient?accountId=MTM0NjQ_    /Order/Index/MTM0NjQ_?vt=2    /Inventory/Levels/MTM0NjQ_
    
    FOR    ${element}    IN    @{param}
        Go to page and Wait    ${SiteUrl}    ${element}
    END

*** Keywords ***
Go to page and Wait
    [Arguments]    ${start_point}    ${end_point}
    Go To    ${start_point}${end_point}
    Wait For Condition    condition=return document.readyState == 'complete';    timeout=60s
