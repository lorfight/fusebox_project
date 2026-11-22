*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
Test Setup    Test Setup View Patient History
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_VPH    report.label.owner: Hai Nguyen

*** Test Cases ***
Report Viewer Is Displayed Correctly In Patient History Log
	[Documentation]    DIS-3
	...    smoke    View Patient History    
    Go To View Patient History
    Go To Patient History Log Page
    # Verify Patient History Log Sheet Page Is Visible
    Close Patient History Log In Report Reviewer Window    window_arg=${original_window}[1]

*** Keywords ***
Test Setup View Patient History
    Open New Window    title_arg=Home
    Check Newsletter
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
