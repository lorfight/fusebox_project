*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Available Kits
Test Setup    Open New Window    title_arg=Available Kits
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Prime_physician    DIS_AVK

*** Test Cases ***
CRUD And Confirm Kit Is Visible In Available Kits List
	[Documentation]    DIS-23    DIS-24
	[Tags]    smoke    Available Kits    report.label.owner: Hai Nguyen
    Open Create A New Kit ModalPopup
    ${created_kit_number}    ${created_kit_description}    Prepare Data For Kit
    Create A New Kit    
        ...    ${created_kit_number}    
        ...    ${created_kit_description}
    Open Update Kit ModalPopup    ${created_kit_number}
    ${update_kit_number}    ${update_kit_description}    Prepare Data For Kit
    Edit Kit Row Is Visible In Available Kits List    
        ...    ${update_kit_number}    
        ...    ${update_kit_description}
    Delete Kit Row Is Visible In Available Kits List    ${update_kit_number}  

*** Keywords ***
Suite Setup Available Kits
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Go To Available Kits Page