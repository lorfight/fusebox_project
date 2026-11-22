*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Insurance Verifications
Test Setup    Open New Window    title_arg=Insurance Verification Ledger
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_ISV    report.label.owner: Hai Nguyen

*** Test Cases ***
View And Update Insurance Verifications Successfully
	[Documentation]    DIS-22
	...    smoke    Insurance Verifications    
    Filter By Location In Insurance Verification Ledger Page    ${data_input}[location]
    # Filter By Patient In Insurance Verification Ledger Page    ${data_input}[patient_mrn]
    # Click Insurance Verification Tools Button    ${data_input}[first_name]    ${data_input}[last_name]
    # Verify Insurance Information    
    # ...    expect_patient_name=${data_input}[first_name] ${data_input}[last_name]
    # ...    expect_dob=${data_input}[dob]    
    # ...    expect_mrn=${data_input}[patient_mrn]
    # Update Insurance Successfully    method_arg=discovery

*** Keywords ***
Suite Setup Insurance Verifications
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Go To Insurance Verification Ledger Page