*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Appoinment Ordering Ledger
Test Setup    Open New Window    title_arg=Appointment Ordering Ledger
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_AOL    report.label.owner: Hai Nguyen

*** Test Cases ***
Dispense Window Opens Successfully
	[Documentation]    APT-1
	...    smoke    Dispense Now    
    AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
    AppointmentOrderingLedger.Go To Dispense Now

Verify New Apointment Is Scheduled Successfully
	[Documentation]    APT-2    APT-3
	...    smoke    Scheduled New Appointment    Reschedule    Cancel Appointment    report.label.owner: Hai Nguyen
    ${appointment_dict}    Verify New Appointment Is Scheduled Successfully
    ${new_date}    Rechedule Appointment Successfully    ${appointment_dict.apt_date}
    Cancel Appointment Successfully    ${new_date}

Dispense Apointment Successfully
	[Documentation]    APT-4
	...    smoke    Dispense Appointment    report.label.owner: Hai Nguyen
    ${appointment_dict}    Verify New Appointment Is Scheduled Successfully
    LedgerView.Open Appointment    ${appointment_dict.apt_date}
    ${dispense_dict}    OpenAppointment.Dispense Created Appoinment
    Common.Close Modal Popup

View Therapy Management Modal
	[Documentation]    APT-5
	...    smoke    Therapies    report.label.owner: Hai Nguyen
    AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
    AppointmentOrderingLedger.Go To Therapy Management Modal
    Common.Close Modal Popup

View Protocol Management Modal
	[Documentation]    APT-6
	...    smoke    Protocols    report.label.owner: Hai Nguyen
    AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
    AppointmentOrderingLedger.Go To Protocol Management Modal
    Common.Close Modal Popup

# View And Update Number of Nurses Available Modal
# 	[Documentation]    APT-7
# 	...    smoke    Nursing Schedule
#       report.label.owner: Hai Nguyen
#     AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
#     AppointmentOrderingLedger.Go To Number of Nurses Available Modal
#     NursingSchedule.Select Account In Number of Nurses Available Modal    ${data_input}[location]  
    # ${current_date}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=+7
#     NursingSchedule.Select Number Of Nurses In Number of Nurses Available Modal    date_arg=${current_date}    number_arg=3
#     Common.Close Modal Popup

CRUD Regimen Management Modal
	[Documentation]    APT-8
	...    smoke    Regimens    report.label.owner: Hai Nguyen
    AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
    AppointmentOrderingLedger.Go To Regimen Management Modal
    ${Fake_dict}    Generate Fake Data    sentence
    ${desc_create}    Set Variable    ${Fake_dict['sentence']}
    Regimens.Create Regimen    
        ...    location_arg=${data_input}[location]      
        ...    medication_arg=${data_input}[medication]      
        ...    desc_arg=${desc_create}
        ...    maintenance_arg=Maintenance Dose
    ${Fake_dict}    Generate Fake Data    sentence
    ${desc_update}    Set Variable    ${Fake_dict['sentence']}
    Regimens.Edit Regimen    
        ...    desc_create_arg=${desc_create}    
        ...    desc_update_arg=${desc_update}
    Regimens.Delete Regimen    ${desc_update}
    Common.Close Ultra SubModal Popup

CRUD Template In Encounter Note Visibility Settings Modal
	[Documentation]    APT-9
	...    smoke    Encounter Note Visibility    report.label.owner: Hai Nguyen
    AppointmentOrderingLedger.Filter By Location    ${data_input}[location]
    AppointmentOrderingLedger.Go To Encounter Note Visibility Settings Modal
    ${encounter_dict}    Create Dictionary
    ${Fake_dict}    Generate Fake Data    sentence
    ${template_name_create}    Set Variable    ${Fake_dict['sentence']}
    EncounterNoteVisibility.Create Template In Encounter Note Visibility Settings Modal    
        ...    template_name_arg=${template_name_create}    
        ...    proprietary_name_arg=${data_input}[medication]      
        ...    dict_arg=${encounter_dict}    
        ...    dxcode_arg=${data_input}[dx_code]   
    ${Fake_dict}    Generate Fake Data    sentence
    ${template_name_update}    Set Variable    ${Fake_dict['sentence']}
    EncounterNoteVisibility.Update Template In Encounter Note Visibility Settings Modal    
        ...    template_name_create_arg=${template_name_create}
        ...    template_name_update_arg=${template_name_update}
    EncounterNoteVisibility.Click Delete Template Button    ${template_name_update}
    Common.Close SubModal Popup

*** Keywords ***
Suite Setup Appoinment Ordering Ledger
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Create Patient
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]

Verify New Appointment Is Scheduled Successfully
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
    AppointmentOrderingLedger.Filter Appointment In Ledger View    
        ...    status_arg=-- All Statuses --   
        ...    location_arg=${data_input}[location]      
        ...    patient_mrn_arg=${data_input}[patient_mrn]       
        ...    apt_date_arg=${appointment_dict.apt_date}
    LedgerView.Verify Appointment Is Visible    ${appointment_dict.apt_date}
    RETURN    ${appointment_dict}

Rechedule Appointment Successfully
    [Arguments]    ${apt_date}
    ${new_date}    Add Time To Date    ${apt_date}    1 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    LedgerView.Open Appointment    ${apt_date}
    OpenAppointment.Click Rechedule Appoinment Button In Assign Dosage To Appointment Modal
    ${reschedule_appointment_dict}    RescheduleAppointment.Rechedule Appointment    
    ...    location_arg=${data_input}[location]    
    ...    date_arg=${new_date}
    ...    time_arg=12:20 am
    Common.Close Modal Popup
    AppointmentOrderingLedger.Filter Appointment In Ledger View
        ...    status_arg=-- All Statuses --   
        ...    location_arg=${data_input}[location]      
        ...    patient_mrn_arg=${data_input}[patient_mrn]       
        ...    apt_date_arg=${new_date}
    LedgerView.Verify Appointment Is Visible    ${new_date}
    RETURN    ${new_date}

Cancel Appointment Successfully
    [Arguments]    ${apt_date}
    LedgerView.Open Appointment    ${apt_date}
    OpenAppointment.Click Cancel Appoinment Button In Assign Dosage To Appointment Modal
    CancelAppointment.Cancel Appointment
    ...    reason_arg=Cancellation
    ...    note_arg=Testing
    Common.Close Modal Popup
