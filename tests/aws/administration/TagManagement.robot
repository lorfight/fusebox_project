*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_110

*** Test Cases ***
Verify Tag Management
    [Documentation]    Tag Management
    [Tags]    Admin
    ...    test_id:[ADM-64]    [ADM-65]
    ...  report.label.owner:Nga Phan
    Go To Tag Management
    ${tag_desc}    Create Tag Management
    Find Tag Management    ${tag_desc}
    ${tag_desc}    Edit Tag Management
    Find Tag Management    ${tag_desc}
    Click Delete


*** Keywords ***
Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{ad_data}    Create Dictionary
    Set Suite Variable    ${ad_data}