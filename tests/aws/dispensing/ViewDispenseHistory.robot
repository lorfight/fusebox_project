*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
Test Setup    Test Setup View Dispense History
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_VDH    report.label.owner: Hai Nguyen

*** Test Cases ***
Report Viewer Is Displayed Correctly In Patient Dispense Log
	[Documentation]    DIS-2
	...    smoke    View Dispense History    
    Go To View Dispense History
    Go To Patient Dispense Log Page
    Verify Patient Dispense Log Sheet Page Is Visible
    Close Patient Dispense Log In Report Reviewer Window    window_arg=${original_window}[1]

*** Keywords ***
Test Setup View Dispense History
    Open New Window    title_arg=Home
    Check Newsletter
    ${original_window}    Get Window Handles
    Set Suite Variable    ${original_window}