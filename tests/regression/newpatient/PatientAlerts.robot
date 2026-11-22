*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Alerts Suite
Test Setup    Test Setup Patient Alerts Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_013    patient    Admin

*** Test Cases ***
Verify Date Field Format And Picker
	[Documentation]    PAlert-1    PAlert-2    PAlert-3    PAlert-4
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    ${start_date}    ${end_date}    Handle Data Timestamp
    Filter By Event Timestamp And Check Datepicker In Patient Alerts    ${start_date}    ${end_date}
    Verify The Date Fomat Is MM/DD/YYYY In Patient Alerts

Verify Patient Information Exists
    [Documentation]    PAlert-20
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    ${dob}    Convert Date    ${PatientCreate.dob}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${expected_value}    Set Variable    ${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} \(${dob}\) MRN: ${PatientCreate.mrn} - (${data_input}[location])
    Check Patient Field Correct Information    ${expected_value}
    Element Should Be Disabled    ${alert_patient_input}

Verify Dropdown Contains Only
    [Documentation]    PAlert-21    PAlerts-23    PAlert-24
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    Verify Dropdown Has Only Option    
        ...    ${alert_event_description_select}    
        ...    ${alert_event_description_select_option}    
        ...    This is a Test Event Description
    Verify Dropdown Has Only Option    
        ...    ${alert_priority_select}    
        ...    ${alert_priority_select_option}    
        ...    Test High Priority
	Check Event Date Field Fomat

Create Patient Alert Unsuccessfully When Missing Each Required Field 
    [Documentation]    PAlert-22    PAlert-25    PAlert-27    PAlert-28    PAlert-30
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    Check Error If Missing Field
    Click Close Patient Alert Button

Verify That Select Any Action Duration
    [Documentation]    PAlert-9    PAlert-10    PAlert-11    PAlert-13    PAlert-14    PAlert-26    PAlert-29    PAlert-31    PAlert-32
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    Input Required Field In PAlert Popup    ${patientalerts_dict}
    Check Action Duration Options
    Input Over 255 Characters In Action Reason Input
	Verify Textarea Allows Max 255 Characters In Reason Action Column
    Verify Completed Alerts Visible
    ${expected_patient_information}    Set Variable    ${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name}\nMRN: ${PatientCreate.mrn}
    Check The Patient Column    ${expected_patient_information}
    Check The Event Column    ${patientalerts_dict}

Verify Alert No Action Duration
    [Documentation]   PAlert-12    PAlert-15    PAlert-16    PAlert-17    PAlert-18    PAlert-19    
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    Create Patient Alerts No Action Reason And Check Event Timstamp Value    ${data_input}[utc]
    Verify Completed Alerts Hide
    ${completed_timestamp_txt}    Get Text    ${completed_timestamp_column}
    Should Be Equal    ${completed_timestamp_txt}    N/A
    Check Confirm Button Disable
    Check Completed Timestamp Column Updated    ${data_input}[utc]

Verify System Displays Alerts Within The Selected Date Range
    [Documentation]    PAlert-5    PAlerts-6    PAlert-7
	[Tags]    Regression    Patient Alerts    report.label.owner: Nga Phan Hai Nguyen
    Open Create Patient Alert Popup
    Create Patient Alerts Successfully    ${data_input}[utc]
    Check Filter Alerts Using Both Start Date And End Date

*** Keywords ***
Suite Setup Patient Alerts Suite
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

Test Setup Patient Alerts Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${patientalerts_dict}    Created Patient Alerts Dictionary
    Set Test Variable    ${patientalerts_dict}
    Open Patient Alerts Tab
