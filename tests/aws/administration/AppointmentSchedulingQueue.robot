*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Appointment Scheduling Queue
Test Setup    Open New Window    title_arg=Update Patient
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    ADM_ASQ    report.label.owner: Hai Nguyen

*** Test Cases ***
Schedule New Appointment In Appointment Scheduling Queue
    [Documentation]    ADM-108    smoke     Appointment Scheduling Queue    
    ${provider_dict}    Create Provider Order For Created Patient
    Change Prior Authorization Status    po_num=${provider_dict.po_num}
    Go To Appointment Scheduling Queue
    Filter By Location In Appointment Scheduling Queue Page    ${data_input}[location]
    Filter By Patient In Appointment Scheduling Queue Page    ${data_input}[mrn] 
    AppointmentSchedulingQueue.Click Search Button
    Open Schedule Appointment Button In Appointment Scheduling Queue Page    mrn_arg=${data_input}[mrn] 
    Wait Until Element Is Visible    ${shcedule_appointment_title}    30s
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-4x fa-spin"]
    Sleep    5s
    ScheduleNewAppointment.Click Approve Therapy And Begin Scheduling Button
    Schedule New Appointment
    Verify Created Appointment Is Visible In Appointment List

*** Keywords ***
Suite Setup Appointment Scheduling Queue
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Create Patient
    PatientList.Navigate to Patient by Generated MRN    mrn_arg=${data_input}[mrn]     location_arg=${data_input}[location]
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    
Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]

Create Provider Order For Created Patient
    ProviderOrders.Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[mrn] 
        ...    drug_arg=${data_input}[medication]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[npi_number] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    RETURN    ${provider_dict}

Change Prior Authorization Status
    [Arguments]    ${po_num}
    ${pa_dict}    Create Prior Authorizations Dictionary
    PriorAuthorizations.Open Prior Authorizations Tab
    PriorAuthorizations.Click Edit PA Button    ${po_num}
    PriorAuthorizations.Select Prior Auth Status In PA Status and Confirmation    Approved
    PriorAuthorizations.Select PA Medication Type    dict_arg=${pa_dict}
    Common.Scroll And Click Element    ${pa_update_btn}
    Common.Page Alert Message    Prior Authorization Successfully Updated
    Common.Close Modal Popup

Schedule New Appointment
    ${appointment_dict}    Create Appointment Dictionary
    ${apt_date}    Get Current Date    result_format=%m/%d/%Y
    ScheduleNewAppointment.Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${appointment_dict}
    ScheduleNewAppointment.Click Add To Queue Button
    ScheduleNewAppointment.Handle DOS Before Suggested Alert
    ScheduleNewAppointment.Click Random Button
    ScheduleNewAppointment.Scheduling Alert
    Set To Dictionary    ${appointment_dict}    apt_date=${apt_date}
    Set Test Variable    ${appointment_dict}

Verify Created Appointment Is Visible In Appointment List
    PatientList.Navigate to Patient by Generated MRN    mrn_arg=${data_input}[mrn]     location_arg=${data_input}[location]
    Appointments.Open Appointments Tab
    LedgerView.Verify Appointment Is Visible    ${appointment_dict.apt_date}
