*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_108

*** Test Cases ***
Verify Room Temp Storage Management
    [Documentation]    Room Temp Storage Management
    [Tags]    Admin
    ...    test_id:[ADM-103]    [ADM-104]    [ADM-105]    [ADM-106]
    ...  report.label.owner:Nga Phan
    Go To Room Temp Storage Management
    ${room_temp}    Create Room Temp Storage    
    ${room_temp}    Edit Room Temp Storage    ${room_temp}
    Delete Room Temp Storage    ${room_temp}

*** Keywords ***

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
