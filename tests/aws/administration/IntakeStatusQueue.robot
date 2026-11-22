*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_105    report.label.owner:Nga Phan
*** Test Cases ***
Verify Intake Status Queue Displays Successfully
    [Documentation]    Intake Status Queue
    ...    Admin
    ...    test_id:[ADM-109]
    ...  report.label.owner:Nga Phan
    Go To Intake Status Queue
    Check Intake Status Queue Displays    ${IntakeData.location}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${IntakeData}
    ...    location=${data_input}[location] 

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{IntakeData}    Create Dictionary
    Set Suite Variable    ${IntakeData}
    Setup Data
