*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Diagnosis Suite
Test Setup    Test Setup Diagnosis Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_015    patient    Admin

*** Test Cases ***
ICD-10 Code Search Field Behavior And Validation
    [Documentation]    PP-214    PP-215    PP-216    PP-218
    [Tags]    Regression     Diagnosis    report.label.owner: Hai Nguyen
    Verify System Returns The Corresponding Result With Valid Input    icdcode_arg=${data_input}[icd10_code]  
    Verify System Displays Message With Invalid Input    icdcode_arg=${data_input}[icd10_code_invalid]
    Unassigned Diagnosis    icdcode_arg=${data_input}[icd10_code]
    
Assigning And Marking ICD-10 Codes As Primary For The Patient 
    [Documentation]    PP-217    
    [Tags]    Regression     Diagnosis    report.label.owner: Hai Nguyen
    Find Diagnosis    icdcode_arg=${data_input}[icd10_code]
    Click Assigned Checkbox    icdcode_arg=${data_input}[icd10_code]
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
    Check Diagnosis Is Assigned To Patient In Appointment Tab    
        ...    icdcode_arg=${data_input}[icd10_code]
        ...    apt_date_arg=${appointment_dict.apt_date}
    Open Diagnosis Tab
    Unassigned Diagnosis    icdcode_arg=${data_input}[icd10_code]

*** Keywords ***
Suite Setup Diagnosis Suite
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
    ${original_window}    Get Window Handles
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Diagnosis Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Diagnosis Tab
