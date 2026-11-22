*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Progress Note Suite
Test Setup    Test Setup Progress Note Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_003    patient    Admin

*** Test Cases ***
Verify Elements Are Visible In Progress Note Tab
    [Documentation]    PN-1    PN-2    PN-3    PN-4    PN-11
	[Tags]    Regression    Progress Note    report.label.owner: Hai Nguyen
    The Subject Filter Dropdown Is Visible
    Choose Date In Date Picker Table    date_arg=${note_start_date}
    Choose Date In Date Picker Table    date_arg=${note_end_date}
    Verify A Form Is Visible When Click Add Note
    Click Cancel Progress Note Button
    Wait Until Page Does Not Contain    Add Progress Note    30s

Add Note Unsuccessfully Without Note Textbox
    [Documentation]    PN-5    PN-6    PN-7    PN-8
	[Tags]    Regression    Progress Note    report.label.owner: Hai Nguyen
    Click Add Note Button
    Add New Subject
    Choose Date In Date Picker Table    date_arg=${follow_up_date}
    Click Save Progress Note Button
    Common.Page Alert Message    The Note field is required.
    Click Cancel Progress Note Button

Add Note Successfully With Valid Data
    [Documentation]    PN-9    PN-10
	[Tags]    Regression    Progress Note    report.label.owner: Hai Nguyen
    Click Add Note Button
    Add New Subject
    Choose Date In Date Picker Table    date_arg=${follow_up_date}
    Input Progress Note Textbox
    Click Save Progress Note Button
    Common.Page Alert Message    Progress Note Successfully Saved

*** Keywords ***
Suite Setup Progress Note Suite
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
    ${patient_info_txt}    Set Variable    //h3[contains(text(),'${PatientCreate.first_name} ${PatientCreate.last_name} - DOB: ${PatientCreate.dob} - MRN: ${PatientCreate.mrn}')]

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]
    Set Suite Variable    ${patient_info_txt}

Test Setup Progress Note Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Progress Note Tab    ${patient_info_txt}