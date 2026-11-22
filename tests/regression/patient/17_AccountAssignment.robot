*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Account Assigned
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_017    patient    Admin

*** Test Cases ***
Verification Of 'Adjust Default Location' Button And Dropdown Behavior
    [Documentation]    AA-1    AA-2    AA-3    AA-4    AA-5    AA-7    AA-8    AA-9
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Verify Default Account Select Shows All Locations Have Same HeadOffice
    Selecting Defualt Account Triggers A Confirmation Popup    location_arg=${PatientData.account_name2}    status=yes
    Check The Default Account Remains Changed    location_arg=${PatientData.account_name2}

Verify That Canceling At Any Confirmation Step Does Not Change The Patient's Default Account
    [Documentation]    AA-10
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Selecting Defualt Account Triggers A Confirmation Popup    location_arg=${PatientData.account_name2}    status=no
    Check The Default Account Remains Changed    location_arg=${PatientData.account_name1}
    
Verify That The Assigned Account Table Displays All Locations Listed In The Default Account Dropdown
    [Documentation]    AA-13
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Compare Account Name List With Default Location Select

Verify That The "Assigned" Column Allows Multiple Selections Using Checkboxes
    [Documentation]    AA-14
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Select Multiple Checkboxes In "Assigned" Column

Verify That The "Default Location" Checkbox Is Disabled
    [Documentation]    AA-15
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Account Name Has Disabled Checkbox

Handle Checkbox Of Accounts And Observe Result
    [Documentation]    AA-16    AA-17
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Checking An "Assigned" checkbox    status=select    msg=Patient Account Successfully Assigned    location_arg=${PatientData.account_name2}
    Checking An "Assigned" checkbox    status=unselect    msg=Patient Account Removed    location_arg=${PatientData.account_name2}

Verify That The "Account Name" Column Displays The Account Name And Account ID
    [Documentation]    AA-18
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Verify "Account Name" Shows Fomat Exactly

Actions When Saving The "Note" Textbox
    [Documentation]    AA-19    AA-20    AA-21
    [Tags]    Regression     Account Assignments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Account Assignments Tab
    Save "Note" Textbox By Clicking Outside
    Save "Note" Textbox By Pressing Tab Key

*** Keywords ***
Test Teardown Account Assigned
    Return Defualt Location
    Test Teardown Keyword

Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${account_name1}    ${data_input}[account_name1]
    Set Suite Variable    ${account_name2}    ${data_input}[account_name2]
    Set Suite Variable    ${account_name3}    ${data_input}[account_name3]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    account_name1=${account_name1}    
    ...    account_name2=${account_name2}    
    ...    account_name3=${account_name3}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}