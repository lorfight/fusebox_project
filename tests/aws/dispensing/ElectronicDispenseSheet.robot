*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
Test Setup    Test Setup Electronic Dispense Records
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Prime_physician    DIS_EDR

*** Test Cases ***
Scheduled Appointments List Is Displayed Correctly In Electronic Dispense Records
	[Documentation]    DIS-1
	[Tags]    smoke    Electronic Dispense Records    report.label.owner: Hai Nguyen
    Go To Electronic Dispense Sheet
    Go To Electronic Dispense Records Page
    Verify Appointment List View Successfully
    Close Electronic Dispense Records Window    window_arg=${original_window}[1]

*** Keywords ***
Test Setup Electronic Dispense Records
    Open New Window    title_arg=Home
    Check Newsletter
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}