*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_106
*** Test Cases ***
Verify Fax Queue List Displays Successfully
    [Documentation]    Outbound Fax Queue
    [Tags]    Admin
    ...    test_id:[ADM-92]
    ...  report.label.owner:Nga Phan
    Go To Outbound Fax Queue
    Check Fax Queue List Displays    ${FaxQueueData.account}


*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${FaxQueueData}
    ...    account=${data_input}[account] 

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{FaxQueueData}    Create Dictionary
    Set Suite Variable    ${FaxQueueData}
    Setup Data
