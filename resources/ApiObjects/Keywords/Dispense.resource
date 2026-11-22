*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    FakerLibrary
Library    ../../PageObjects/TestData/Fakedata/FakeData.py
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Resource    ../../../resources/ApiObjects/Keywords/Appointment.resource
*** Variables ***
@{list_status_enum}    
...    RequiresApproval
...    Approved
...    AwaitingOrder
...    Ordered
...    AwaitingDispense
...    Dispensed
...    Administering
...    Administered
...    Canceled
...    Historical
...    Rescheduled
...    Open
...    Closed
${errors_out_range}    
...    {
...        "appointment.PatientMRN": [
...            "The field PatientMRN must be a string or array type with a maximum length of '50'."
...        ],
...        "appointment.DoseQuantity": [
...            "The value must commence at 0 and reach a maximum of 1000000."
...        ],
...        "appointment.Patient.LastName": [
...            "The field LastName must be a string or array type with a maximum length of '50'."
...        ],
...        "appointment.Patient.FirstName": [
...            "The field FirstName must be a string or array type with a maximum length of '50'."
...        ],
...        "medicationDispenses[0].Quantity": [
...            "The value must commence at 1 and reach a maximum of 50."
...        ]
...    }
${errors_start_end_time}
...    {
...      "treatmentEndTime": [
...        "TreatmentStartTime and TreatmentEndTime must be on the same date",
...        "TreatmentStartTime must be less than or equal to TreatmentEndTime"
...      ],
...      "treatmentStartTime": [
...        "TreatmentStartTime and TreatmentEndTime must be on the same date",
...        "TreatmentStartTime must be less than or equal to TreatmentEndTime"
...      ]
...    }
@{list_not_string_field_path}    
...    treatmentStartTime    treatmentEndTime
...    appointment.icdCodes    appointment.startTime    appointment.doseQuantity
...    appointment.patient.dob
...    medicationDispenses[0].lotExpirationDate    medicationDispenses[0].quantity    medicationDispenses[0].wasteDose    medicationDispenses[0].billForWaste
@{list_all_field_path}    
...    accountNumber    emrAppointmentID    
...    appointment.type    appointment.icdCodes    appointment.startTime    appointment.doseQuantity        appointment.primaryMedication    appointment.patientMRN    
...    appointment.patient.firstName    appointment.patient.lastName    appointment.patient.dob    appointment.patient.gender 
...    medicationDispenses[0].ndc    medicationDispenses[0].lotNumber    medicationDispenses[0].lotExpirationDate    medicationDispenses[0].quantity    medicationDispenses[0].wasteDose    medicationDispenses[0].billForWaste    medicationDispenses[0].barcodes
...    treatmentStartTime    treatmentEndTime
@{list_required_field_path}   
...    emrAppointmentID    
...    appointment.primaryMedication    appointment.patientMRN    
...    appointment.patient.firstName    appointment.patient.lastName    appointment.startTime    appointment.patient.dob    appointment.patient.gender  
...    medicationDispenses   
...    medicationDispenses[0].ndc    medicationDispenses[0].lotNumber    medicationDispenses[0].quantity    medicationDispenses[0].lotExpirationDate 
@{list_not_required_field_path}
...    appointment.type    appointment.icdCodes   appointment.doseQuantity
...    medicationDispenses[0].wasteDose    medicationDispenses[0].billForWaste    medicationDispenses[0].barcodes
...    treatmentStartTime    treatmentEndTime 
@{medication_dispense_type}    
...    Primary    Secondary    
*** Keywords ***
Get TreatmentStartDate And TreatmentEndDate
    ${result}    Get Next Date Timezone
    ${treatment_start_date}    Get From Dictionary    ${result}    start_date
    ${treatment_end_date}   Add Time To Date    ${treatment_start_date}    4 hours
    ${treatment_next_date}    Get From Dictionary    ${result}    end_date
    Set Test Variable    ${treatment_start_date}
    Set Test Variable    ${treatment_end_date}
    Set Test Variable    ${treatment_next_date}
Validate JSON List Errors
    [Arguments]    ${response_errors}    ${schema_errors}
    ${parsed_schema}    Convert String To JSON    ${schema_errors}
    Validate Json By Schema    ${response_errors}    ${parsed_schema}
Get URL API Dispense
    ${config_path}    Testdata.Get Api Configs     ${env}
    ${json_data}    Set Variable    ${config_path}
    ${base_url}    Get From Dictionary    ${json_data}    baseUrl
    ${dispense_path}    Get From Dictionary    ${json_data}    dispense
    ${dispense_medicine_path}    Get From Dictionary    ${json_data}    dispenseMedication
    ${token_url}    Get From Dictionary    ${json_data}    tokenUrl
    Set Suite Variable    ${base_url}
    Set Suite Variable    ${dispense_path}
    Set Suite Variable    ${dispense_medicine_path}
    Set Suite Variable    ${token_url}

Get Access Token
    [Arguments]    ${head_account}
    Create Session    auth_session    ${base_url}
    ${headers}    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${response}    POST On Session    auth_session    ${token_url}    data=${head_account}    headers=${headers}    expected_status=200
    ${access_token}    Set Variable    ${response.json()["access_token"]}
    Set Suite Variable    ${access_token}
    
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${primaryMedication}    ${data_input}[primaryMedication]
    Set Suite Variable    ${emrMedication}    ${data_input}[emrMedication]
    Set Suite Variable    ${scope}    ${data_input}[scope]
    Set Suite Variable    ${grantType}    ${data_input}[grantType]
    Set Suite Variable    ${referringProviderNPI}    ${data_input}[referringProviderNPI]
    Set Suite Variable    ${preferredInternalProviderNPI}    ${data_input}[preferredInternalProviderNPI]
    Set Suite Variable    ${merge_apt_mrn}    ${data_input}[merge_mrn]
    # Have headoffice and list account > 1
    Set Suite Variable    ${head_multi_headoffice}    ${data_input}[accounts][0][headOffice]
    Set Suite Variable    ${head_multi_acc1}    ${data_input}[accounts][0][listAccounts][0]
    Set Suite Variable    ${head_multi_acc2}    ${data_input}[accounts][0][listAccounts][1]
    Set Suite Variable    ${head_multi_PO1}    ${data_input}[accounts][0][locationPO][0]
    Set Suite Variable    ${head_multi_PO2}    ${data_input}[accounts][0][locationPO][1]
    Set Suite Variable    ${head_multi_clientid}    ${data_input}[accounts][0][clientId]
    Set Suite Variable    ${head_multi_clientsecret}    ${data_input}[accounts][0][clientSecret]
    # Have headoffice and list account = 1
    Set Suite Variable    ${head_1_headoffice}    ${data_input}[accounts][1][headOffice]
    Set Suite Variable    ${head_1_acc1}    ${data_input}[accounts][1][listAccounts][0]
    Set Suite Variable    ${head_1_PO1}    ${data_input}[accounts][1][locationPO][0]
    Set Suite Variable    ${head_1_clientid}    ${data_input}[accounts][1][clientId]
    Set Suite Variable    ${head_1_clientsecret}    ${data_input}[accounts][1][clientSecret]
    # Have head office and list account = 0
    Set Suite Variable    ${head_0_headoffice}    ${data_input}[accounts][2][headOffice]
    Set Suite Variable    ${head_0_acc1}    ${data_input}[accounts][2][listAccounts][0]
    Set Suite Variable    ${head_0_PO1}    ${data_input}[accounts][2][locationPO][0]
    Set Suite Variable    ${head_0_clientid}    ${data_input}[accounts][2][clientId]
    Set Suite Variable    ${head_0_clientsecret}    ${data_input}[accounts][2][clientSecret]
    # No head office and list account = 1
    Set Suite Variable    ${nohead_1_headoffice}    ${data_input}[accounts][3][headOffice]
    Set Suite Variable    ${nohead_1_acc1}    ${data_input}[accounts][3][listAccounts][0]
    Set Suite Variable    ${nohead_1_PO1}    ${data_input}[accounts][3][locationPO][0]
    Set Suite Variable    ${nohead_1_clientid}    ${data_input}[accounts][3][clientId]
    Set Suite Variable    ${nohead_1_clientsecret}    ${data_input}[accounts][3][clientSecret]
    # Have headoffice and list account > 1
    ${head_multi_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_multi_headoffice=${head_multi_headoffice}
    ...    head_multi_acc1=${head_multi_acc1}
    ...    head_multi_acc2=${head_multi_acc2}
    ...    head_multi_PO1=${head_multi_PO1}
    ...    head_multi_PO2=${head_multi_PO2}
    ...    client_id=${head_multi_clientid}
    ...    client_secret=${head_multi_clientsecret}
    Set Suite Variable    ${head_multi_data}

    # Have headoffice and list account = 1
    ${head_1_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_1_headoffice=${head_1_headoffice}
    ...    head_1_acc1=${head_1_acc1}
    ...    head_1_PO1=${head_1_PO1}
    ...    client_id=${head_1_clientid}
    ...    client_secret=${head_1_clientsecret}
    Set Suite Variable    ${head_1_data}

    # Have head office and list account = 0
    ${head_0_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_0_headoffice=${head_0_headoffice}
    ...    head_0_acc1=${head_0_acc1}
    ...    head_0_PO1=${head_0_PO1}
    ...    client_id=${head_0_clientid}
    ...    client_secret=${head_0_clientsecret}
    Set Suite Variable    ${head_0_data}

    # No head office and list account = 1
    ${nohead_1_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    nohead_1_headoffice=${nohead_1_headoffice}
    ...    nohead_1_acc1=${nohead_1_acc1}
    ...    nohead_1_PO1=${nohead_1_PO1}
    ...    client_id=${nohead_1_clientid}
    ...    client_secret=${nohead_1_clientsecret}
    Set Suite Variable    ${nohead_1_data}

Get NDC Information
    ${data_input}    Get Data
    # Medicine Primary
    ${ndc_primary}    Set Variable    ${data_input}[medicine_primary][ndc]
    ${lotNumber_primary}    Set Variable    ${data_input}[medicine_primary][lotNumber]
    ${lotExpirationDate_primary}    Convert Date    ${data_input}[medicine_primary][lotExpirationDate]    date_format=%m/%d/%Y
    ${wasteDose_primary}    Convert To Number    ${data_input}[medicine_primary][wasteDose]
    ${billForWaste_primary}    Convert To Boolean    ${data_input}[medicine_primary][billForWaste]
    ${quantity_primary}    Convert To Integer    ${data_input}[medicine_primary][quantity]
    ${barcode_primary}    Create List    ${data_input}[medicine_primary][barcode]
    ${medicine_primary}    Create Dictionary
    ...    ndc=${ndc_primary}
    ...    lotNumber=${lotNumber_primary}
    ...    lotExpirationDate=${lotExpirationDate_primary}
    ...    wasteDose=${wasteDose_primary}
    ...    billForWaste=${billForWaste_primary}
    ...    quantity=${quantity_primary}
    ...    barcodes=${barcode_primary}
    Set Suite Variable    ${medicine_primary}
    # Medicine Secondary
    ${ndc_secondary}    Set Variable    ${data_input}[medicine_secondary][ndc]
    ${lotNumber_secondary}    Set Variable    ${data_input}[medicine_secondary][lotNumber]
    ${lotExpirationDate_secondary}    Convert Date    ${data_input}[medicine_secondary][lotExpirationDate]    date_format=%m/%d/%Y
    ${wasteDose_secondary}    Convert To Number    ${data_input}[medicine_secondary][wasteDose]
    ${billForWaste_secondary}    Convert To Boolean    ${data_input}[medicine_secondary][billForWaste]
    ${quantity_secondary}    Convert To Integer    ${data_input}[medicine_secondary][quantity]
    ${barcode_secondary}    Create List    ${data_input}[medicine_secondary][barcode]
    ${medicine_secondary}    Create Dictionary
    ...    ndc=${ndc_secondary}
    ...    lotNumber=${lotNumber_secondary}
    ...    lotExpirationDate=${lotExpirationDate_secondary}
    ...    wasteDose=${wasteDose_secondary}
    ...    billForWaste=${billForWaste_secondary}
    ...    quantity=${quantity_secondary}
    ...    barcodes=${barcode_secondary}
    Set Suite Variable    ${medicine_secondary}
    # Medicine Not Drug
    ${ndc_not_drug}    Set Variable    ${data_input}[medicine_not_drug][ndc]
    ${lotNumber_not_drug}    Set Variable    ${data_input}[medicine_not_drug][lotNumber]
    ${lotExpirationDate_not_drug}    Convert Date    ${data_input}[medicine_not_drug][lotExpirationDate]    date_format=%m/%d/%Y
    ${wasteDose_not_drug}    Convert To Number    ${data_input}[medicine_not_drug][wasteDose]
    ${billForWaste_not_drug}    Convert To Boolean    ${data_input}[medicine_not_drug][billForWaste]
    ${quantity_not_drug}    Convert To Integer    ${data_input}[medicine_not_drug][quantity]
    ${barcode_not_drug}    Create List    ${data_input}[medicine_not_drug][barcode]
    ${medicine_not_drug}    Create Dictionary
    ...    ndc=${ndc_not_drug}
    ...    lotNumber=${lotNumber_not_drug}
    ...    lotExpirationDate=${lotExpirationDate_not_drug}
    ...    wasteDose=${wasteDose_not_drug}
    ...    billForWaste=${billForWaste_not_drug}
    ...    quantity=${quantity_not_drug}
    ...    barcodes=${barcode_not_drug}
    Set Suite Variable    ${medicine_not_drug}
    # Medicine Not Therapy
    ${ndc_not_therapy}    Set Variable    ${data_input}[medicine_not_therapy][ndc]
    ${lotNumber_not_therapy}    Set Variable    ${data_input}[medicine_not_therapy][lotNumber]
    ${lotExpirationDate_not_therapy}    Convert Date    ${data_input}[medicine_not_therapy][lotExpirationDate]    date_format=%m/%d/%Y
    ${wasteDose_not_therapy}    Convert To Number    ${data_input}[medicine_not_therapy][wasteDose]
    ${billForWaste_not_therapy}    Convert To Boolean    ${data_input}[medicine_not_therapy][billForWaste]
    ${quantity_not_therapy}    Convert To Integer    ${data_input}[medicine_not_therapy][quantity]
    ${barcode_not_therapy}    Create List    ${data_input}[medicine_not_therapy][barcode]
    ${medicine_not_therapy}    Create Dictionary
    ...    ndc=${ndc_not_therapy}
    ...    lotNumber=${lotNumber_not_therapy}
    ...    lotExpirationDate=${lotExpirationDate_not_therapy}
    ...    wasteDose=${wasteDose_not_therapy}
    ...    billForWaste=${billForWaste_not_therapy}
    ...    quantity=${quantity_not_therapy}
    ...    barcodes=${barcode_not_therapy}
    Set Suite Variable    ${medicine_not_therapy}


Get Random Data
    [Arguments]    ${fake_data}
    # ${data}    Generate Data
    ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
    RETURN    ${fake_data}

Create Fake Data List
    Get NDC Information
    ${data}    Generate Data
    Set Test Variable    ${data}
    ${first_name_fake}    Get Random Data    fake_data=first_name
    ${last_name_fake}    Get Random Data    fake_data=last_name
    ${MRN_fake}    Get Random Data    fake_data=MRN
    ${DOB_fake}    Get Random Data    fake_data=DOB
    ${gender_value}    Get Random Data    fake_data=gender
    ${emrPatientID}    Get Random Data    fake_data=emrPatientID
    # Appointment Data
    ${emrPatientID_fake}    Get Random Data    fake_data=emrPatientID
    ${emrAppointmentID_fake}    Get Random Data    fake_data=emrAppointmentID
    ${locationNumber_value}    Get Random Data    fake_data=locationNumber
    ${icdCodes_value}    Get Random Data    fake_data=icdCodes
    ${types_value}    Get Random Data    fake_data=types
    ${num_rand}    Get Random Data    fake_data=num_rand
    ${sentence_str}    Get Random Data    fake_data=sentence
    ${rand_str_3}    Get Random Data    fake_data=rand_str_3
    ${rand_str_15}    Get Random Data    fake_data=rand_str_15
    ${rand_str_51}    Get Random Data    fake_data=rand_str_51

    &{appointment_dispense_dict}    Create Dictionary
    # Patient
    ...    first_name_fake=${first_name_fake}    
    ...    last_name_fake=${last_name_fake}    
    ...    MRN_fake=${MRN_fake}    
    ...    DOB_fake=${DOB_fake}     
    ...    gender_value=${gender_value}     
    ...    emrPatientID=${emrPatientID}
    ...    num_rand=${num_rand}
    ...    rand_str_3=${rand_str_3}
    ...    rand_str_15=${rand_str_15}
    ...    rand_str_51=${rand_str_51}
    # Appointment
    ...    emrPatientID_fake=${emrPatientID_fake}    
    ...    emrAppointmentID_fake=${emrAppointmentID_fake}   
    ...    sentence_str=${sentence_str}
    ...    locationNumber_value=${locationNumber_value}    
    ...    icdCodes_value=${icdCodes_value}    
    ...    types_value=${types_value}
    ${medication_dispenses}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${list_medication_dispenses}    Create List    ${medication_dispenses}
    Set To Dictionary    ${appointment_dispense_dict}
    ...    medication_dispenses_list_default=${list_medication_dispenses}    
    Get TreatmentStartDate And TreatmentEndDate
    Set Suite Variable    ${appointment_dispense_dict}
    
Sending Body Request To Save Patient
    [Arguments]    
    ...    ${head_data}=${head_multi_data}    
    ...    ${head_acc}=${head_multi_acc1}
    # Patient.Get URL API Patient
    # Patient.Get Access Token    head_account=${head_data}
    # Create Session    mysession    ${base_url}
    # ${headers}    Create Dictionary
    # ...    Authorization=Bearer ${access_token}
    # ...    Content-Type=application/json
    Patient.Sending Body Request With Required Fields
    ...    head_acc_arg=${head_data}
    ...    account_number_arg=${head_acc}
    ...    first_name_arg=${appointment_dispense_dict.first_name_fake}
    ...    last_name_arg=${appointment_dispense_dict.last_name_fake}
    ...    dob_arg=${appointment_dispense_dict.DOB_fake}
    ...    mrn_arg=${appointment_dispense_dict.MRN_fake}
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${appointment_dispense_dict.emrPatientID}
    ...    gender_arg=${appointment_dispense_dict.gender_value}
    ...    expected_status=200
    # ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}
    # ${response_json}    Set Variable    ${response.json()}
    # Set Test Variable    ${response_json}
    Add Patient To List    ${response_json["accountNumber"]}    ${response_json["mrn"]}
Sending Body Request To Save Appointment
    [Arguments]    
    ...    ${head_data}=${head_multi_data}    
    ...    ${head_acc}=${head_multi_acc1}
    Appointment.Get URL API Appointment
    ${icd_code_arg}=    Create List    ${appointment_dispense_dict.icdCodes_value}
    Create New Appointment
    ...    head_account_arg=${head_data}
    ...    account_number_send=${head_acc}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=${appointment_dispense_dict.types_value}
    ...    start_date_send=${treatment_start_date}
    ...    end_date_send=${treatment_next_date}
    ...    med_send=${emrMedication}
    ...    dose_send=${appointment_dispense_dict.num_rand}
    ...    emrAptID_send=${appointment_dispense_dict.emrPatientID_fake}
    ...    note_send=${appointment_dispense_dict.sentence_str}
    ...    location_num_send=${appointment_dispense_dict.locationNumber_value}
    ...    icd_code_send=${icd_code_arg}
    ...    referringProviderNPI_send=${referringProviderNPI}
    ...    preferredInternalProviderNPI_send=${preferredInternalProviderNPI}
    ...    reason_send=Testing
Sending Body Request With All Dispense Fields
    [Arguments]    
    ...    ${head_data}=${head_multi_data}    
    ...    ${account_number_arg}=${head_multi_acc1}    
    ...    ${emr_apt_arg}=${APT_response_json["emrAppointmentID"]} 
    ...    ${type_arg}=${body_request_APT["type"]}
    ...    ${icd_code_arg}=${body_request_APT["icdCodes"]}
    ...    ${start_time_arg}=${APT_response_json["startTime"]}
    ...    ${pri_med_arg}=${emrMedication}
    ...    ${dose_arg}=${APT_response_json["dosage"]}
    ...    ${patient_mrn_arg}=${APT_response_json["patientMRN"]}
    ...    ${first_name_arg}=${response_json["firstName"]}
    ...    ${last_name_arg}=${response_json["lastName"]}
    ...    ${dob_arg}=${response_json["dob"]}
    ...    ${gender_arg}=${response_json["gender"]}
    ...    ${medication_arg}=${appointment_dispense_dict.medication_dispenses_list_default}
    ...    ${treatment_start_time_arg}=${treatment_start_date}
    ...    ${treatment_end_time_arg}=${treatment_end_date}
    ...    ${removed_field_list_arg}=@{EMPTY}
    ...    ${expected_status}=200
    ${body_request_dispense}    Create Dictionary    
    ...    accountNumber=${account_number_arg}
    ...    emrAppointmentID=${emr_apt_arg}
    ...    treatmentStartTime=${treatment_start_time_arg}
    ...    treatmentEndTime=${treatment_end_time_arg}
    
    ${appointment_arg}    Create Dictionary
    ...    type=${type_arg}
    ...    icdCodes=${icd_code_arg}
    ...    startTime=${start_time_arg}
    ...    primaryMedication=${pri_med_arg}
    ...    doseQuantity=${dose_arg}
    ...    patientMRN=${patient_mrn_arg}
    ${patient_arg}    Create Dictionary
    ...    firstName=${first_name_arg}
    ...    lastName=${last_name_arg}
    ...    dob=${dob_arg}
    ...    gender=${gender_arg}
    Set To Dictionary    ${appointment_arg}
    ...    patient=${patient_arg}
    Set To Dictionary    ${body_request_dispense}
    ...    appointment=${appointment_arg}
    ...    medicationDispenses=${medication_arg}
    FOR    ${field}    IN    @{removed_field_list_arg}
        Remove Fields Using Paths    ${body_request_dispense}    ${field}  
    END
    Set Test Variable    ${body_request_dispense}
    Dispense.Get Access Token    head_account=${head_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${response}    POST On Session    mysession    ${dispense_path}    json=${body_request_dispense}    headers=${headers}    expected_status=${expected_status}
    ${appoinment_dispensing_response_json}    Set Variable    ${response.json()}
    Set Test Variable    ${appoinment_dispensing_response_json}
Sending Body Request To Dispense Medication
    [Arguments]
    ...    ${head_data}=${head_multi_data}
    ...    ${account_number_arg}=${head_multi_acc1}    
    ...    ${emr_apt_arg}=${appoinment_dispensing_response_json["emrAppointmentID"]}
    ...    ${removed_field_list_arg}=@{EMPTY}
    ...    ${expected_status}=200
    ${body_request_dispense_medication}    Create Dictionary
    ...    AccountNumber=${account_number_arg}
    ...    EMRAppointmentID=${emr_apt_arg} 
    FOR    ${field}    IN    @{removed_field_list_arg}
        Remove Fields Using Paths    ${body_request_dispense_medication}    ${field}  
    END
    Set Test Variable    ${body_request_dispense_medication}
    Get Access Token    head_account=${head_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${response}    GET On Session    mysession    ${dispense_medicine_path}    params=${body_request_dispense_medication}   headers=${headers}    expected_status=${expected_status}
    ${medication_dispensing_response_json}    Set Variable    ${response.json()}
    Set Test Variable    ${medication_dispensing_response_json}
Remove Fields Using Paths
    [Arguments]    ${json_data}    ${field_path}
    ${keys}    Split String    ${field_path}    .
    ${current}    Set Variable    ${json_data}

    FOR    ${index}    ${key}    IN ENUMERATE    @{keys}
        ${is_list}    Run Keyword And Return Status    Should Contain    ${key}    [

        IF    ${is_list}
            ${key_name}    Get Substring    ${key}    0    ${key.find("[")}
            ${index_str}    Get Substring    ${key}    ${key.find("[") + 1}    -1
            ${index}    Evaluate    int(${index_str})
            ${current}    Set Variable    ${current}[${key_name}][${index}]
        ELSE
            IF    ${index} == ${keys.__len__()} - 1
                Run Keyword If    "${key}" in ${current}    Remove From Dictionary    ${current}    ${key}
                RETURN    ${key}
            ELSE
                ${current}    Set Variable    ${current}[${key}]
            END
        END
    END
Verify Successful Response In Appoinment Dispensing
    [Arguments]    ${apointment_dispensing_response_json}
    Should Be Equal As Integers    ${apointment_dispensing_response_json["accountNumber"]}    ${APT_response_json["accountNumber"]}
    ${startTime_format}    Convert Date    ${APT_response_json["startTime"]}    date_format=%Y-%m-%dT%H:%M:%SZ    result_format=%Y-%m-%dT%H:%M:%S
    ${endTime_format}    Convert Date    ${APT_response_json["endTime"]}    date_format=%Y-%m-%dT%H:%M:%SZ    result_format=%Y-%m-%dT%H:%M:%S
    Should Be Equal    ${apointment_dispensing_response_json["startTime"]}    ${startTime_format}
    Should Be Equal    ${apointment_dispensing_response_json["endTime"]}    ${endTime_format}
    Should Be Equal    ${apointment_dispensing_response_json["patientMRN"]}    ${APT_response_json["patientMRN"]}
    Should Be Equal    ${apointment_dispensing_response_json["emrAppointmentID"]}    ${APT_response_json["emrAppointmentID"]}
    Should Be Equal    ${apointment_dispensing_response_json["patientID"]}    ${APT_response_json["patientID"]}    
    Should Be Equal    ${apointment_dispensing_response_json["primaryMedication"]}    ${APT_response_json["primaryMedication"]}
    Should Be Equal   ${apointment_dispensing_response_json["dosage"]}    ${APT_response_json["dosage"]}
    Should Be Equal    ${apointment_dispensing_response_json["dosageUOM"]}    ${APT_response_json["dosageUOM"]}
    Should Be Equal    ${apointment_dispensing_response_json["locationNumber"]}    ${APT_response_json["locationNumber"]}
    Should Be Equal    ${apointment_dispensing_response_json["referToProviderNPI"]}    ${APT_response_json["referToProviderNPI"]}    
    Should Be Equal    ${apointment_dispensing_response_json["referringProviderNPI"]}    ${APT_response_json["referringProviderNPI"]}    
    List Should Contain Value    ${list_status_enum}    ${apointment_dispensing_response_json["status"]}
    Should Be Equal    ${apointment_dispensing_response_json["id"]}    ${APT_response_json["id"]}   
Verify Successful Response In Medication Dispensing
    [Arguments]    ${medication_dispensing_response_json}
    FOR    ${index}    ${response}    IN ENUMERATE    ${medication_dispensing_response_json}
        Should Be Equal    ${response[${index}]["lotNumber"]}    ${body_request_dispense["medicationDispenses"][${index}]["lotNumber"]}
        ${covert_date_response}    Convert Date    ${response[${index}]["lotExpirationDate"]}    date_format=%m/%d/%Y %I:%M:%S %p    result_format=%Y-%m-%d %H:%M:%S
        ${covert_date_request}    Convert Date    ${body_request_dispense["medicationDispenses"][${index}]["lotExpirationDate"]}    date_format=%Y-%m-%d %H:%M:%S.%f    result_format=%Y-%m-%d %H:%M:%S
        Should be Equal    ${covert_date_response}    ${covert_date_request}    
        List Should Contain Value    ${medication_dispense_type}    ${response[${index}]["medicationDispenseType"]}
        Variable Should Exist    ${response[${index}]["medicationStockText"]}
        Variable Should Exist    ${response[${index}]["medicationProprietaryName"]}
        Variable Should Exist    ${response[${index}]["siteOfAdministration"]}
        Variable Should Exist    ${response[${index}]["dosePerContainer"]}
        Variable Should Exist    ${response[${index}]["doseUnit"]}
        Should Be Equal    ${response[${index}]["ndc"]}    ${body_request_dispense["medicationDispenses"][${index}]["ndc"]}
        Variable Should Exist    ${response[${index}]["hcpcsCode"]}
        Should Be Equal As Numbers    ${response[${index}]["usedContainerQuantity"]}    ${body_request_dispense["medicationDispenses"][${index}]["quantity"]}  
        Variable Should Exist    ${response[${index}]["usedDose"]}
        Should Be Equal    ${response[${index}]["wasteDose"]}    ${body_request_dispense["medicationDispenses"][${index}]["wasteDose"]}
        Variable Should Exist    ${response[${index}]["totalDose"]}
    END    

Sending Request To Dispense Appointment
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Dispense.Create Fake Data List
    Get TreatmentStartDate And TreatmentEndDate
    Sending Body Request With All Dispense Fields
    ...    head_data=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    emr_apt_arg=${APT_response_json["emrAppointmentID"]}
    ...    type_arg=${body_request_APT["type"]}
    ...    icd_code_arg=${body_request_APT["icdCodes"]}
    ...    start_time_arg=${APT_response_json["startTime"]}
    ...    pri_med_arg=${emrMedication}
    ...    dose_arg=${APT_response_json["dosage"]}
    ...    patient_mrn_arg=${APT_response_json["patientMRN"]}
    ...    first_name_arg=${response_json["firstName"]}
    ...    last_name_arg=${response_json["lastName"]}
    ...    dob_arg=${response_json["dob"]}
    ...    gender_arg=${response_json["gender"]}
    ...    medication_arg=${appointment_dispense_dict.medication_dispenses_list_default}