*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
Test Setup    Test Setup Dispense, Inventory, and Billing Status
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_IBS    report.label.owner: Hai Nguyen

*** Test Cases ***
Report Viewer Is Displayed Correctly In Daily Dispense, Inventory, and Billing Status
	[Documentation]    DIS-4
	...    smoke    Dispense, Inventory, and Billing Status    
    Go To Dispense, Inventory, and Billing Status
    Go To Daily Dispense, Inventory, and Billing Status Page
    Verify Dispense, Inventory, and Billing Status Is Displayed All Fields Correctly
    Verify Dispense, Inventory, and Billing Status Document Map Area Is Displayed All Fields Correctly
    Close Daily Dispense, Inventory, and Billing Status Page Page In Report Reviewer Window    window_arg=${original_window}[1]

*** Keywords ***
Test Setup Dispense, Inventory, and Billing Status
    Open New Window    title_arg=Home
    Check Newsletter
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}