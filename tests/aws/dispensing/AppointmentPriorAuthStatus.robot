*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
Test Setup    Test Setup Appointment Prior Auth Status
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_APS    report.label.owner: Hai Nguyen

*** Test Cases ***
Report Viewer Is Displayed Correctly In Condensed Appointment Prior Authorizations
	[Documentation]    DIS-5
	...    smoke    Appointment Prior Auth Status    
    Go To Appointment Prior Auth Status
    Go To Condensed Appointment Prior Authorizations Page
    Verify Condensed Appointment Prior Authorizations Is Displayed All Fields Correctly
    Verify Condensed Appointment Prior Authorizations Document Map Area Is Displayed All Fields Correctly
    Close Condensed Appointment Prior Authorizations Window    window_arg=${original_window}[1]

*** Keywords ***
Test Setup Appointment Prior Auth Status
    Open New Window    title_arg=Home
    Check Newsletter
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}