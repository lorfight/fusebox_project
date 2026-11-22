*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Vital Signs Suite
Test Setup    Test Setup Vital Signs Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_005    patient    Admin

*** Test Cases ***
Verify The Vital Signs Lines Are Ordered By Decreasing DOS
    [Documentation]    VS-1    VS-4
	[Tags]    Regression     Vital Signs    report.label.owner: Hai Nguyen
    Appointments.Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
        ...    loops=3
    ${apt_date_list}    Create List    
        ...    ${appointment_dict.apt_date_1}
        ...    ${appointment_dict.apt_date_2}
        ...    ${appointment_dict.apt_date_3}
    Reload Page
    Appointments.Open Appointments Tab
    Input Data In Procedural Details For All Created Normal Appointments    ${apt_date_list}
    Open Vital Signs Tab
    Verify The Vital Sign Table Displays All Columns
    Verify The Vital Signs Lines Are Ordered By Decreasing DOS    loops=3

Verify Vital Signs Value Columns Are Retrieved And Updated From Procedural Details
    [Documentation]    VS-2    VS-3    VS-7    VS-8    VS-9    VS-10    VS-12    VS-13    VS-15    VS-16    VS-18    VS-19
                ...    VS-21    VS-22    VS-24    VS-25    VS-27    VS-28    VS-29    VS-30    VS-31    VS-32    VS-33    VS-34
	[Tags]    Regression     Vital Signs    report.label.owner: Hai Nguyen
    Appointments.Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]
        ...    dose_arg=10
    Reload Page
    # Vital Sign Create
    Appointments.Open Appointments Tab
    ${TreatmentNote_create_dict}    ${Assessment_create_dict}    ${ProceduralDetails_create_dict}    Input And Get Data In Treatment Note With Created Appointment    ${appointment_dict.apt_date}
    &{expected_compare_create_data}    Evaluate    {**$TreatmentNote_create_dict, **$Assessment_create_dict, **$ProceduralDetails_create_dict}
    Reload Page
    Open Vital Signs Tab
    ${VitalSign_create_dict}    Get Data In Vital Signs tab    ${appointment_dict.apt_date}
    Compare Values Of Vital Signs Tab With Treatment Note Information    ${VitalSign_create_dict}    ${expected_compare_create_data}
    # Vital Sign Update
    Appointments.Open Appointments Tab
    ${TreatmentNote_update_dict}    ${Assessment_update_dict}    ${ProceduralDetails_update_dict}    Input And Get Data In Treatment Note With Created Appointment    ${appointment_dict.apt_date}
    &{expected_compare_update_data}    Evaluate    {**$TreatmentNote_update_dict, **$Assessment_update_dict, **$ProceduralDetails_update_dict}
    Reload Page
    Open Vital Signs Tab
    ${VitalSign_update_dict}    Get Data In Vital Signs tab    ${appointment_dict.apt_date}
    Compare Values Of Vital Signs Tab With Treatment Note Information    ${VitalSign_update_dict}    ${expected_compare_update_data}

Verify Corresponding Vital Signs Line Removed When The Procedural Details Deleted
    [Documentation]    VS-6
	[Tags]    Regression    Vital Signs    report.label.owner: Hai Nguyen
    Appointments.Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]
        ...    dose_arg=10
    Reload Page
    Appointments.Open Appointments Tab
    ${TreatmentNote_dict}    ${Assessment_create_dict}    ${ProceduralDetails_dict}    Input And Get Data In Treatment Note With Created Appointment    ${appointment_dict.apt_date}
    Open Vital Signs Tab
    Verify Vital Sign Is Created    date_arg=${TreatmentNote_dict.treatment_date_of_service_txt}
    Appointments.Open Appointments Tab
    LedgerView.Open Treatment Note    ${appointment_dict.apt_date}
    ${note_time_value}    Get Time Value
    Click Delete Action    ${note_time_value}
    Common.Close Modal Popup
    Reload Page
    Open Vital Signs Tab
    Verify Vital Signs Line Removed    date_arg=${TreatmentNote_dict.treatment_date_of_service_txt}

Verify Vital Signs Columns Are Not Entered When Corresponding Values Are Missing In Treatment Note
    [Documentation]    VS-11    VS-14    VS-17    VS-20    VS-23    VS-26
	[Tags]    Regression    Vital Signs    report.label.owner: Hai Nguyen
    Appointments.Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]
        ...    dose_arg=10
    Reload Page
    Appointments.Open Appointments Tab
    ${TreatmentNote_dict}    ${Assessment_dict}    ${ProceduralDetails_dict}    Input And Get Data In Treatment Note With Created Appointment    ${appointment_dict.apt_date}
    &{expected_compare_data}    Evaluate    {**$TreatmentNote_dict, **$Assessment_dict, **$ProceduralDetails_dict}
    LedgerView.Open Treatment Note    ${appointment_dict.apt_date}
    ProceduralDetails.Go To Procedural Details
    Open New Window    title_arg=Update Patient
    Open Vital Signs Tab
    ${VitalSign_dict}    Get Data In Vital Signs tab    ${appointment_dict.apt_date}
    Compare Values Of Vital Signs Tab With Treatment Note Information    ${VitalSign_dict}    ${expected_compare_data}
    ${original_window}    Get Window Handles

    ${method_list}    Create List    
        ...    Input Blood Pressure (mmHg)
        ...    Input Heart Rate (bpm)
        ...    Input Respiratory Rate
        ...    Input Temp (F)
        ...    Input SPO2 %
        ...    Input Oxygen (L/min)

    ${vital_sign_column_list}    Create List
        ...    Get Blood Pressure (mmHg) Column
        ...    Get Heart Rate (bpm) Column
        ...    Get Resp Rate (per minute) Column
        ...    Get Temperature Column 
        ...    Get SpO2 Column
        ...    Get O2 Flow Rate (L/min) Column

    FOR    ${method}    ${vital_sign_column}    IN ZIP    ${method_list}    ${vital_sign_column_list}
        Switch Window    ${original_window}[1]
        Run Keyword    ${method}    ${ProceduralDetails_dict.note_time_value}    ${EMPTY}
        Switch Window    ${original_window}[2]
        Reload Page
        Open Vital Signs Tab
        ${vital_sign_column_txt}    Run Keyword    ${vital_sign_column}    ${appointment_dict.apt_date}
        Should Be Equal    ${vital_sign_column_txt}    Not Entered
    END

*** Keywords ***
Suite Setup Vital Signs Suite
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
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]
    Set Suite Variable    ${PatientCreate}
    
Test Setup Vital Signs Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]

Input Data In Procedural Details For All Created Normal Appointments
    [Arguments]    ${apt_date_list}
    FOR    ${apt_date_index}    IN    @{apt_date_list}
        ${apt_date}    Convert Date    ${apt_date_index}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        ${Fake_dict}    Generate Fake Data    decimal_3d_2f    demical_3d    integer_decimal_ratio    decimal_2d_2f
        LedgerView.Open Treatment Note    ${apt_date}
        ${ProceduralDetails_dict}    ProceduralDetails.Input Data In Procedural Details
            ...    drip_rate_arg=${Fake_dict['decimal_3d_2f']}
            ...    blood_pressure_arg=${Fake_dict['integer_decimal_ratio']}
            ...    heart_rate_arg=${Fake_dict['demical_3d']}
            ...    temperature_arg=${Fake_dict['decimal_3d_2f']}
            ...    respiratory_rate_arg=${Fake_dict['demical_3d']}    
            ...    spo2_arg=${Fake_dict['decimal_2d_2f']}
            ...    oxygen_arg=10
            ...    delivery_method_arg=random
        Common.Close Modal Popup
    END

Input And Get Data In Treatment Note With Created Appointment
    [Arguments]    ${apt_date}
    ${apt_date}    Convert Date    ${apt_date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
    ${Fake_dict}    Generate Fake Data    decimal_3d_2f    demical_3d    integer_decimal_ratio    decimal_2d_2f
    LedgerView.Open Treatment Note    ${apt_date}
    ${treatment_date_of_service_txt}    TreatmentNote.Get Date Of Service Text
    ${TreatmentNote_dict}    Create Treatment Note Dictionary
    Set To Dictionary    ${TreatmentNote_dict}    treatment_date_of_service_txt=${treatment_date_of_service_txt}
    ${Assessment_dict}    Get Data In Assessment
    ${ProceduralDetails_dict}    ProceduralDetails.Input Data In Procedural Details
        ...    drip_rate_arg=${Fake_dict['decimal_3d_2f']}
        ...    blood_pressure_arg=${Fake_dict['integer_decimal_ratio']}
        ...    heart_rate_arg=${Fake_dict['demical_3d']}
        ...    temperature_arg=${Fake_dict['decimal_3d_2f']}
        ...    respiratory_rate_arg=${Fake_dict['demical_3d']}    
        ...    spo2_arg=${Fake_dict['decimal_2d_2f']}
        ...    oxygen_arg=10
        ...    delivery_method_arg=random
    Common.Close Modal Popup

    RETURN    ${TreatmentNote_dict}    ${Assessment_dict}    ${ProceduralDetails_dict}
