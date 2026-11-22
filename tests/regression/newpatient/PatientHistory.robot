*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient History Suite
Test Setup    Test Setup Patient History Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_016    patient    Admin

*** Test Cases ***
Verify Summary Table Displays Correctly
    [Documentation]    PH-1    PH-2    PH-3    PH-4    PH-5    PH-6    PH-7    PH-8    PH-9    
                ...    PH-10    PH-11    PH-12    PH-13    PH-14    PH-16    PH-17
    [Tags]    Regression     Patient History    report.label.owner: Hai Nguyen
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Has No Office Visit With Past Date
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[drug_po]  
        ...    dose_arg=10
        ...    loops=3
        ...    po_number_arg=${provider_dict.po_num}
    Sleep    5s
    Reload Page
    Open Appointments Tab
    Dispense Appointment For Patient History    dict_arg=${appointment_dict}    loops=3
    Open Patient History Tab
    ${treatment_list}    Get Data From Summary Of All Treatments Table    med_arg=${data_input}[drug_po]
    Expand Encounter Summary Table    med_arg=${data_input}[drug_po]
    ${row_total}    Calculate Treatment Row Total In Encounter Table
    ${previous_treatment_row_list}    Create Dictionary
    ${last_treatment_row_list}    Create Dictionary
    ${previous_treatment_row}    Set Variable    (//div[contains(@id,"EncounterSummaryList")]//child::tbody//tr)[last()]
    Get Data From Treatment Row In Encounter Table    
        ...    row_arg=${previous_treatment_row}    
        ...    list_arg=${previous_treatment_row_list}
    ${last_treatment_row}    Set Variable    (//div[contains(@id,"EncounterSummaryList")]//child::tbody//tr)[1]
    Get Data From Treatment Row In Encounter Table    
        ...    row_arg=${last_treatment_row}    
        ...    list_arg=${last_treatment_row_list}
    Verify All Column In Summary Of All Treatments Table   
        ...    treatment_list=${treatment_list} 
        ...    first_row_list=${previous_treatment_row_list}    
        ...    last_row_list=${last_treatment_row_list}
        ...    row_total=${row_total}

Verify Treatment Data Is Validated Based On Treatment Notes
    [Documentation]    PH-18    PH-19    PH-20    PH-21    PH-22    PH-23    PH-24    
                ...    PH-25    PH-26    PH-27    PH-28    PH-29    PH-30
    [Tags]    Regression     Patient History    report.label.owner: Hai Nguyen
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Has No Office Visit With Past Date
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[drug_po]  
        ...    dose_arg=10
        ...    po_number_arg=${provider_dict.po_num}
    Sleep    5s
    Reload Page
    Open Appointments Tab
    Dispense Appointment For Patient History    dict_arg=${appointment_dict}    loops=1
    Open Patient History Tab
    Expand Encounter Summary Table    med_arg=${data_input}[drug_po] 
    ${formmated_apt_date}     Convert Date    ${appointment_dict.apt_date}     result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    Click View Appointment Button In Patient History    date_arg=${formmated_apt_date}  
    Handle Data Appoinment Information    dict_arg=${appointment_dict}
    Handle Data Treatment Note    dict_arg=${appointment_dict}
    ${encounter_list}    Get Encounter Summary Treatment Data    
        ...    apt_date_arg=${formmated_apt_date}
        ...    med_arg=${data_input}[drug_po] 
    Compare Encounter Summary Data With Treatment Note Data    ${encounter_list}    ${appointment_dict}    ${provider_dict}

*** Keywords ***
Suite Setup Patient History Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[drug_po]   
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    
    ${original_window}    Get Window Handles
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${provider_dict}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Patient History Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]

Dispense Appointment For Patient History
    [Arguments]    ${dict_arg}    ${loops}
    FOR    ${loop}    IN RANGE    ${loops}
        IF    "${loops}" == "1"
            LedgerView.Open Appointment    ${dict_arg.apt_date}
        ELSE
            ${loop}    Set Variable    ${loop+1}
            LedgerView.Open Appointment    ${dict_arg.apt_date_${loop}}
        END
        ${dispense_dict}    OpenAppointment.Dispense Created Appoinment
        ${quantity_therapy_value}    OpenAppointment.Get Dosage Quality Therapy
        Common.Close Modal Popup
        Set To Dictionary    ${dict_arg}    quantity_therapy_value=${quantity_therapy_value}
    END
    Sleep    5s
    Reload Page

Handle Data Appoinment Information
    [Arguments]    ${dict_arg}
    ${assigned_dxcode_txt}    Get Dx Code In The Appointment Information Tab
    ${patient_weight_txt}    Get Patient Weight In The Appointment Information Tab
    ${base_qty_txt}    ${unit_therapy_value}    Get Total Dispensed Dose Of Primary Medication In The Appointment Information Tab
    Set To Dictionary    ${dict_arg}    
        ...    assigned_dxcode_txt=${assigned_dxcode_txt}
        ...    patient_weight_txt=${patient_weight_txt}
        ...    base_qty_txt=${base_qty_txt}
        ...    unit_therapy_value=${unit_therapy_value}

Handle Data Treatment Note 
    [Arguments]    ${dict_arg}
    Open Treatment Note Tab
    ${treatment_clinician_value}    Get Treatment Clinician In The Treatment Note Tab
    Select Pain Scale In The Assessment Tab    ${dict_arg}
    Go To Assessment
    ${starttime_value}    Input Appointment Start Time In Assessment Modal 
    ${endtime_value}    Input Appointment Stop Time In Patient Discharge Modal    ${starttime_value}
    Sleep    1s
    ${treatment_duration_value}     Get Treatment Duration Value
    Common.Close Modal Popup
    Reload Page
    Set To Dictionary    ${dict_arg}    
        ...    treatment_clinician_value=${treatment_clinician_value}
        ...    treatment_duration_value=${treatment_duration_value}
