*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_107
*** Test Cases ***
Verify Product Preference Management
    [Documentation]    Product Preference Management
    [Tags]    Admin
    ...    test_id:[ADM-99]    [ADM-100]    [ADM-101]    [ADM-102]
    ...  report.label.owner:Nga Phan
    Go To Product Preference Management
    ${preference}    Create Preference    
    ${preference}    Edit Preference    ${preference}
    Delete Preference    ${preference}

*** Keywords ***
Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
