*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Billable Events
Test Setup    Open New Window    title_arg=Billable Event Ledger
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_BLE    report.label.owner: Hai Nguyen

*** Test Cases ***
View Billable Event List Successfully
	[Documentation]    DIS-6    DIS-7    DIS-8
	...    smoke    Billable Events    
    Filter Billable Event    
        ...    location_arg=${data_input}[location]      
        ...    medication_arg=${data_input}[medication]         
        ...    mrn_arg=${data_input}[patient_mrn]          
        ...    start_date_arg=${date_time}    
        ...    end_date_arg=${date_time}
    Dispense Appointment    ${date_time}
    Open Document Popup Successfully In Billable Events List    ${date_time}
    Click Unlock Button    ${date_time}
    Click Add Line Button    ${date_time}
    Add Cpt Code Successfully    
        ...    cpt_code_arg=${data_input}[cpt_code]     
        ...    day_unit_arg=5
    Click Lock Button    ${date_time}
    Verify Change History Loads Correctly    
        ...    ${date_time}
        ...    cpt_code_arg=${data_input}[cpt_code]     
        ...    day_unit_arg=5

*** Keywords ***
Suite Setup Billable Events
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Create Patient
    ${appointment_dict}    Create New Appointment
    Set Suite Variable    ${date_time}    ${appointment_dict.apt_date}
    BillableEvents.Go To Billable Event Ledger Page

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]

Create New Appointment
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
    RETURN    ${appointment_dict}

Dispense Appointment
    [Arguments]    ${apt_date_arg}
    Open Appointment In Billable Event Ledger Page    ${apt_date_arg}
    ${dispense_dict}    OpenAppointment.Dispense Created Appoinment
    Common.Close Modal Popup

Open Appointment In Billable Event Ledger Page
    [Arguments]    ${apt_date_arg}
    Click Open Appointment Button In Billable Event Ledger Page    ${apt_date_arg}
    LedgerView.Check Appointment Popup Is Visible
    Wait Until Element Is Visible    //div[@id="ModalPopup"]    30s

Open Document Popup Successfully In Billable Events List
    [Arguments]    ${apt_date_arg}
    Click Document Button In Billable Event Ledger Page    ${apt_date_arg}
    Documents.Verify Document Popup Shows Remain Fields
    Common.Close Modal Popup
