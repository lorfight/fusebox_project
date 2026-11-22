*** Settings ***
Library    SeleniumLibrary

Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    LG_100    login

*** Variables ***
${data_input}


*** Test Cases ***
Verify Login Successfully As ${Userrole}
    [Documentation]    Login Test
    [Tags]    Admin
    ...    test_id:[TC_001]
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:critical
    ...  report.label.epic:User Authentication
    ...  report.label.feature:Login Functionality
    ...  report.label.story:Successful Login
    Login To Fusebox    user_name=${Username}    password=${Password}