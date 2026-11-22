*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_113    report.label.owner:Nga Phan
*** Test Cases ***
Verify Add Newsletter And Open PDF Successfully 
    [Documentation]    Newsletter
    ...    Admin
    ...    test_id:[ADM-93]    [ADM-94]
    ...  report.label.owner:Nga Phan
    Go To Newsletter
    ${pdf_path}    Add Newsletter Successfully    ${AdminData}
    Verify Newsletter PDF Opens Successfully    ${AdminData.active_date}
    Delete Newsletter Successfully    ${AdminData.active_date}    ${pdf_path}

*** Keywords *** 

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{AdminData}    Create Dictionary
    Set Suite Variable    ${AdminData}
