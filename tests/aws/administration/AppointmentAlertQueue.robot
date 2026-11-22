*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_101    report.label.owner:Nga Phan

*** Test Cases ***
Verify Alert Queue History Displays Successfully
    [Documentation]    Appointment Alert Queue
    ...    Admin
    ...    test_id:[ADM-109]
    
    Go To Appointment Alert Queue
    Check Alert Queue History Displays    ${AlertQueueData.location}


*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${AlertQueueData}
    ...    location=${data_input}[location] 

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{AlertQueueData}    Create Dictionary
    Set Suite Variable    ${AlertQueueData}
    Setup Data
