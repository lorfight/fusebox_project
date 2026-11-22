*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Account Assignments Suite
Test Setup    Test Setup Account Assignments Suite
Test Teardown    Test Teardown Account Assignments Suite
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_017    patient    Admin

*** Test Cases ***
Verification Of 'Adjust Default Location' Button And Dropdown Behavior
    [Documentation]    AA-1    AA-2    AA-3    AA-4    AA-5    AA-7    AA-8    AA-9
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    ${accounts_have_same_headoffice}    Create List    ${data_input}[account_name_first]    ${data_input}[account_name_second]    ${data_input}[account_name_third]
    Verify Default Account Select Shows All Locations Have Same HeadOffice    ${accounts_have_same_headoffice}
    Selecting Default Account Triggers A Confirmation Popup    ${data_input}[account_name_second]    status=ACCEPT
    Check The Default Account Remains Changed    ${data_input}[account_name_second]

Verify That Canceling At Any Confirmation Step Does Not Change The Patient's Default Account
    [Documentation]    AA-10
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    Selecting Default Account Triggers A Confirmation Popup    location_arg=${data_input}[account_name_second]    status=DISMISS
    Check The Default Account Remains Changed    location_arg=${data_input}[account_name_first]
    
Verify That The Assigned Account Table Displays All Locations Listed In The Default Account Dropdown
    [Documentation]    AA-13
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    Compare Account Name List With Default Location Select

Verify That The "Assigned" Column Allows Multiple Selections Using Checkboxes
    [Documentation]    AA-14
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    ${location_list}    Create List    ${data_input}[account_name_second]    ${data_input}[account_name_third]
    Select Multiple Checkboxes In "Assigned" Column    ${location_list}

Verify That The "Default Location" Checkbox Is Disabled
    [Documentation]    AA-15
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    ${location_name}    Set Variable    ${data_input}[account_name_first]
    Account Name Has Disabled Checkbox    ${location_name}

Handle Checkbox Of Accounts And Observe Result
    [Documentation]    AA-16    AA-17
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    Checking An "Assigned" checkbox    status=select    msg=Patient Account Successfully Assigned    location_arg=${data_input}[account_name_second]
    Checking An "Assigned" checkbox    status=unselect    msg=Patient Account Removed    location_arg=${data_input}[account_name_second]

Verify That The "Account Name" Column Displays The Account Name And Account ID
    [Documentation]    AA-18
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    ${location_name}    Set Variable    ${data_input}[account_name_second]
    Verify "Account Name" Shows Fomat Exactly    ${location_name}

Actions When Saving The "Note" Textbox
    [Documentation]    AA-19    AA-20    AA-21
    [Tags]    Regression     Account Assignments    report.label.owner: Hai Nguyen
    ${location_name}    Set Variable    ${data_input}[account_name_first]
    Save "Note" Textbox By Clicking Outside    ${location_name}
    Save "Note" Textbox By Pressing Tab Key    ${location_name}

*** Keywords ***
Suite Setup Account Assignments Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${original_window}    Get Window Handles

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Account Assignments Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Account Assignments Tab

Test Teardown Account Assignments Suite
    ${location_arg}    Set Variable    ${data_input}[account_name_first]
    Return Default Location    ${location_arg}
    Common.Return Previous Window    window_arg=${update_patient_window}