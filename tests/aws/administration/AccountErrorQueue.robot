*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_100    report.label.owner:Nga Phan

*** Test Cases ***
Verify Account Error List Displays Successfully
    [Documentation]    Account Error Queue
    ...    test_id:[ADM-98]
    Go To Account Error Queue
    Check Account Error List Displays    ${AccountError.emr_mapping}    ${AccountError.location}    

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${AccountError}
    ...    emr_mapping=${data_input}[emr_mapping]
    ...    location=${data_input}[location]  

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{AccountError}    Create Dictionary
    Set Suite Variable    ${AccountError}
    Setup Data