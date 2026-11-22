** Settings **
Documentation      Full Integration
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Resource    ../../../resources/ApiObjects/Keywords/Appointment.resource
Resource    ../../../resources/ApiObjects/Keywords/Medication.resource
Resource    ../../../resources/ApiObjects/Keywords/Dispense.resource
Resource    ../../../resources/ApiObjects/Keywords/Billing.resource
Resource   ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup
Test Setup    Test Setup
Suite Teardown    Suite Teardown
** Test Cases **
Validate Successful Full Flow Using 6 APIs
    [Documentation]
	[Tags]    API    Full Integration
    ...  report.label.owner: Hai Nguyen
    Create Patient With All Valid Fields    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Verify Created Patient On FuseBox    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Verify Created Appoinment On FuseBox    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Scan Barcode    head_account_arg=${head_multi_data}
    Verify Barcode Response
    Dispense Appoinment     head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Verify The Appointment Status After The Appoinment Has Been Dispensed    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Dispense Medication     head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Verify The Appointment Information After The Medication Has Been Dispensed    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Get Billing For Medication     head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}    locationPO_arg=${head_multi_PO1}
    Verify Bill Information

*** Keywords ***
Suite Setup
    Setup Data For Full Integration
    Get URL API Patient
    Get URL API Appointment
    Get URL API Medication
    Get URL API Dispense
    Get URL API Billing
    ${patient_list}=    Create List
    Set Suite Variable    ${patient_list}

Test Setup
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window

Suite Teardown
    Delete Patient
    Close Browser

Delete Patient
    FOR    ${patient}    IN    @{patient_list}
        ${account_number}=    Get From Dictionary    ${patient}    accountNumber
        ${mrn_patient}=    Get From Dictionary    ${patient}    MRN
        IF    '${account_number}' == '${head_multi_acc1}'
            ${account_number}    Set Variable    ${head_multi_PO1}
        ELSE IF    '${account_number}' == '${head_multi_acc2}'
            ${account_number}    Set Variable    ${head_multi_PO2}
        ELSE IF    '${account_number}' == '${head_1_acc1}'
            ${account_number}    Set Variable    ${head_1_PO1}
        ELSE IF    '${account_number}' == '${head_0_acc1}'
            ${account_number}    Set Variable    ${head_0_PO1}
        ELSE IF    '${account_number}' == '${nohead_1_acc1}'
            ${account_number}    Set Variable    ${nohead_1_PO1}
        END
        Create Merge Patient    ${account_number}    ${merge_apt_mrn}
        Delete Created Patient    account_number=${account_number}    mrn_arg=${mrn_patient}
    END


Create Patient With All Valid Fields
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Patient.Create Fake Data List
    Patient.Sending Body Request With All Fields
    ...    head_acc_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    id_arg=${None}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    middle_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    emr_patient_id_arg=${Fake_dict.emrPatientID}
    ...    mrn_arg=${Fake_dict.MRN_fake}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    ssn_arg=${Fake_dict.SSN_fake}
    ...    race_arg=${Fake_dict.race_value}
    ...    ethnicity_arg=${Fake_dict.ethnicitie_value}
    ...    marital_status_arg=${Fake_dict.marital_status_value}
    ...    spouse_first_name_arg=${Fake_dict.first_name_fake}
    ...    spouse_middle_name_arg=${Fake_dict.first_name_fake}
    ...    spouse_last_name_arg=${Fake_dict.last_name_fake}
    ...    referringProviderNPI_arg=${referringProviderNPI}
    ...    preferredInternalProviderNPI_arg=${preferredInternalProviderNPI}
    ...    height_arg=${Fake_dict.height_fake}
    ...    weight_arg=${Fake_dict.weight_fake}
    ...    weight_unit_arg=${Fake_dict.weight_units}
    ...    phone_arg=${Fake_dict.phone_fake}
    ...    email_arg=${Fake_dict.email_fake}
    ...    notes_arg=${Fake_dict.sentence_str}
    ...    occupation_arg=${Fake_dict.job_fake}
    ...    employer_name_arg=${Fake_dict.full_name_fake}
    ...    work_phone_arg=${Fake_dict.phone_fake}
    ...    emergency_contact_name_arg=${Fake_dict.full_name_fake}
    ...    emergency_contact_phone_arg=${Fake_dict.phone_fake}
    ...    emergency_contact_relationship_arg=${Fake_dict.relationship_fake}
    ...    primary_address_line1_arg=${Fake_dict.address_fake}
    ...    primary_address_line2_arg=${Fake_dict.address_fake}
    ...    primary_city_arg=${Fake_dict.country_fake}
    ...    primary_state_province_arg=${Fake_dict.state_province_value}
    ...    primary_postal_code_arg=${Fake_dict.zip_fake}
    ...    primary_country_region_arg=${Fake_dict.country_fake}
    ...    expected_status=200
    ...    active=${True}
    Add Patient To List    ${response_json["accountNumber"]}    ${response_json["mrn"]}
    
Create New Appointment
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    I10    E11.9    A01.02
    Set Test Variable    ${icd_code_value}
    Get StartDate And EndDate
    Appointment.Create New Appointment
    ...    head_account_arg=${head_account_arg}
    ...    account_number_send=${account_num_arg}
    ...    id_send=${None}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    # ...    type_send=ThreeFourtyB
    ...    type_send=${APT_dict.types_value}
    ...    start_date_send=${start_date}
    ...    end_date_send=${end_date}
    ...    med_send=${emrMedication}
    ...    dose_send=${APT_dict.num_rand}
    ...    emrAptID_send=${APT_dict.emrPatientID_fake}
    ...    note_send=${APT_dict.sentence_str}
    ...    location_num_send=${APT_dict.locationNumber_value}
    ...    icd_code_send=${icd_code_value}
    ...    referringProviderNPI_send=${referringProviderNPI}
    ...    preferredInternalProviderNPI_send=${preferredInternalProviderNPI}
    ...    reason_send=Testing
    ...    expected_status=200

Scan Barcode
    [Arguments]    ${head_account_arg}
    Medication.Get Access Token    ${head_account_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${scan_exp}    Convert Date    ${end_date}    date_format=%Y-%m-%dT%H:%M:%SZ    result_format=%y%m%d
    Set Test Variable    ${scan_exp}
    ${barcode}    Set Variable    ${barcode}17${scan_exp}10${lotnum}
    ${body_request_medication}    Create Dictionary    barcode=${barcode}
    ${scan_response}=    POST On Session    mysession    ${medication_path}    json=${body_request_medication}    expected_status=200    headers=${headers}
    ${scan_response_json}    Set Variable    ${scan_response.json()}
    Set Test Variable    ${scan_response_json}

Verify Barcode Response
    Open Therapy With Valid NDC    ${scan_response_json["ndc"]}
    Check Short Description Value    ${scan_response_json["description"]}
    Scroll Element Into View    ${APT_page_close_PO_btn}
    Wait Until Keyword Succeeds    30s    1    Click Button    ${APT_page_close_PO_btn}
    Check Scan Lot Number Value
    Check Scan Lot Expiration Date Value
    
Check Scan Lot Number Value
    Should Be Equal    ${lotnum}    ${scan_response_json["lotNumber"]}

Check Scan Lot Expiration Date Value
    ${lotExpirationDate}    Convert Date    ${scan_response_json["lotExpirationDate"]}    date_format=%Y-%m-%dT%H:%M:%S    result_format=%y%m%d
    Should Be Equal    ${lotExpirationDate}    ${scan_exp}

Dispense Appoinment
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
    ...    treatment_start_time_arg=${treatment_start_date}
    ...    treatment_end_time_arg=${treatment_end_date}
    ...    removed_field_list_arg=@{EMPTY}
    ...    expected_status=200

Dispense Medication 
    [Arguments]    ${head_account_arg}    ${account_num_arg} 
    Sending Body Request To Dispense Medication  
    ...    head_data=${head_account_arg}
    ...    account_number_arg=${account_num_arg}    
    ...    emr_apt_arg=${appoinment_dispensing_response_json["emrAppointmentID"]}
    ...    removed_field_list_arg=@{EMPTY}
    ...    expected_status=200

Get Billing For Medication
    [Arguments]    ${head_account_arg}    ${account_num_arg}    ${locationPO_arg}
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    emr_apt_id_arg=${APT_response_json["emrAppointmentID"]}
    ...    expected_status=200

Verify Created Patient On FuseBox
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Appointment.Go To Patients Page
    Filter Location And Mrn    ${locationPO_arg}    ${mrn_arg}
    RePatient.Select Patient From List    MRN_arg=${mrn_arg}
    Check DOB Value
    Check Race Value
    Check Weight Value
    Check Height Value
    Check preferredInternalProviderNPI Value
    Check Select Value
    Check Input Value
    Check Phone Value
    Check Work Phone Value
    Check Primary Address Value
    Create New Payer Plan    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=2

Filter Location And Mrn
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}

Check BMI
    Scroll Element Into View    ${BMI_text}
    ${BMI_text}    Get Text    ${BMI_text}
    IF    "${response_json["weightUnit"]}" == "Pounds"
        ${BMI_value}    Evaluate    round((${response_json["weight"]} * 703) / ((${response_json["height"]}) ** 2), 1)    # (lb * 703) / (inch)^2
    ELSE
        ${BMI_value}    Evaluate    round(${response_json["weight"]} / ((${response_json["height"]} * 0.0254) ** 2), 1)    # (kg) / (inch * 0.0254)^2
    END
    ${BMI_value}    Convert To String    ${BMI_value}
    Should Be Equal    ${BMI_value}    ${BMI_text}

Check Weight Value
    Scroll Element Into View    ${weight_LP_input}
    IF    "${response_json["weightUnit"]}" == "Pounds"
        ${weight_LB_text}    Get Element Attribute    ${weight_LP_input}    value
        ${weight_LB_text}    Convert To String    ${weight_LB_text}
        Should Be Equal As Strings    ${weight_LB_text}    ${response_json["weight"]}
    ELSE
        ${weight_KG_text}    Get Element Attribute    ${weight_KG_input}    value
        ${weight_KG_text}    Convert To String    ${weight_KG_text}
        Should Be Equal As Strings    ${weight_KG_text}    ${response_json["weight"]}
    END

Check Select Value
    @{select_var_list}    Create List
        ...    ethnicity    gender    maritalStatus
    @{select_xpath_list}    Create List
        ...    ${Ethnicity_Select}    ${Gender_Select}    ${MaritalStatus_Select}
    FOR    ${xpath_element}    ${var_element}    IN ZIP    ${select_xpath_list}    ${select_var_list}
        Scroll Element Into View    ${xpath_element}
        ${selected_value}    Get Selected List Label    ${xpath_element}
        ${selected_value}    Replace String    ${selected_value}    ${SPACE}    ${EMPTY}
        Should Contain    ${selected_value}    ${response_json["${var_element}"]}
    END

Check Race Value
    Scroll Element Into View    ${Race_Select}
    ${selected_value}    Get Selected List Label    ${Race_Select}
    ${selected_value}    Replace String    ${selected_value}    ${SPACE}    ${EMPTY}
    IF    "${selected_value}" == "BlackorAfricanAmerican"
        ${selected_value}=      Replace String    ${selected_value}    or    ${EMPTY}   
    END
    Should Contain    ${selected_value}    ${response_json["race"]}

Check Input Value
    @{input_xpath_list}    Create List
        ...    ${First_Name_Input}    ${Middle_Name_Input}    ${Last_Name_Input}    ${MRN_Input}    ${SSN_Input}    
        ...    ${Spouse_First_Name_Input}    ${Spouse_Middle_Name_Input}    ${Spouse_Last_Name_Input}
        ...    ${email_input}    ${additional_notes_input}    ${occupation_input}
        ...    ${employer_name_input}    ${emergency_name_input}    ${emergency_relationship_input}

    @{input_var_list}    Create List
        ...    firstName    middleName    lastName    mrn    ssn    spouseFirstName    spouseMiddleName
        ...    spouseLastName    email    notes    occupation
        ...    employerName    emergencyContactName    emergencyContactRelationship

    FOR    ${xpath_element}    ${var_element}    IN ZIP    ${input_xpath_list}    ${input_var_list}
        ${input_value}    Get Value    ${xpath_element}
        Should Contain    ${input_value}    ${response_json["${var_element}"]}
    END

Check DOB Value
    ${dob_value}    Get Value    ${DOB_Input}
    ${dob_formmated}    Convert Date    ${response_json["dob"]}    date_format=%Y-%m-%dT00:00:00    result_format=%m/%d/%Y
    Should Be Equal    ${dob_value}    ${dob_formmated}

Check preferredInternalProviderNPI Value
    ${selected_value}    Get Selected List Label    ${physician_select}
    ${provider_npi_value}    Convert To String    ${response_json["preferredInternalProviderNPI"]}
    Should Contain    ${selected_value}    ${provider_npi_value}

Check referringProviderNPI Value
    ${refering_value}    Get Value    ${reffering_provider_input}
    ${refering_npi_value}    Convert To String    ${response_json["referringProviderNPI"]}
    Should Contain    ${refering_value}    ${refering_npi_value}

Check Height Value
    ${height_value}    Get Value    ${Height_Input}
    Should Be Equal As Strings    ${height_value}    ${response_json["height"]}

Check Phone Value
    ${input_value}    Get Value    ${home_phone_input}
    ${phone_fommated}=    Remove String Using Regexp    ${input_value}    [^0-9]
    Should Contain    ${phone_fommated}    ${response_json["phone"]}

Check Work Phone Value
    ${input_value}    Get Value    ${work_phone_input}
    ${work_phone_fommated}=    Remove String Using Regexp    ${input_value}    [^0-9]
    Should Contain    ${work_phone_fommated}    ${response_json["workPhone"]}

Check Emergency Phone Value
    ${input_value}    Get Value    ${emergency_phone_input}
    ${emergency_phone_fommated}=    Remove String Using Regexp    ${input_value}    [^0-9]
    Should Contain    ${emergency_phone_fommated}    ${response_json["emergencyContactPhone"]}

Check Primary Address Value
    @{input_xpath_list}    Create List
        ...    ${default_address1_input}    ${default_address2_input}    ${default_city_input}    
        ...    ${default_state_input}    ${default_zipcode_input}    ${default_country_input}

    @{input_var_list}    Create List
        ...    addressLine1    addressLine2    city    stateProvince    postalCode    countryRegion
    FOR    ${xpath_element}    ${var_element}    IN ZIP    ${input_xpath_list}    ${input_var_list}
        Scroll Element Into View    ${xpath_element}
        ${input_value}    Get Value    ${xpath_element}
        Should Contain    ${input_value}    ${response_json["primaryAddress"]["${var_element}"]}
    END
    
Create New PO
    [Arguments]    ${locationPO_arg}    ${mrn_arg}    ${reffering_arg}    ${med_arg}    ${PO_dosage_arg}    ${status}
    Appointment.Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    RePatient.Select Patient From List    MRN_arg=${mrn_arg}
    Appointment.Open Provider Orders tab
    Wait Until Keyword Succeeds    30    1    Click Element    ${create_PO_btn}
    Create PO    med_arg=${med_arg}    reffering_arg=${reffering_arg}    PO_dosage_arg=${PO_dosage_arg}    status=${status}

Verify Created Appoinment On FuseBox
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Open Created Appointment    ${locationPO_arg}    ${mrn_arg}
    Check Patient MRN Value
    Check Diagnosis Value
    Check Refering Provider Value
    Check Refer to Provider Value
    Check Appointment Note Value
    Check Service Type Value
    Check Primary Medication Value
    Check Dosage Value
    Check Status Value    status_arg=${APT_response_json["status"]}
    Check Location Number
    Select Rendering Provider

Verify The Appointment Status After The Appoinment Has Been Dispensed
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Open Created Appointment    ${locationPO_arg}    ${mrn_arg}
    Check Service Type Value
    Check Diagnosis Value
    Check Status Value    status_arg=${appoinment_dispensing_response_json["status"]}
    Check Treatment StartTime, Treatment EndTime And Treatment Duration
    Check Primary Medication Value
    Check Dosage Value
    Check Patient MRN Value
    Open Appointment ModalPopup
    Check Lot Number Value    ${body_request_dispense["medicationDispenses"][0]["lotNumber"]}
    Check Expiration Date After Appointment Dispensed
    Check Vials Dispensed Value
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${APT_page_close_PO_btn}
    Wait Until Keyword Succeeds    30s    1    Click Button    ${APT_page_close_PO_btn}

Check Patient MRN Value
    ${mrn_txt}    Get Text    ${APT_row}//following::span[contains(text(),'MRN')]//parent::div
    ${mrn_value}    Evaluate    "${mrn_txt}".split("MRN:")[-1].strip()
    Should Be Equal    ${mrn_value}    ${APT_response_json["patientMRN"]}

Check Diagnosis Value
    ${diagnosis_txt}    Get Text    ${APT_row}//following::span[contains(text(),'Diagnosis:')]//parent::div
    ${diagnosis_txt}      Evaluate    '${diagnosis_txt}'.split('Diagnosis: ')[1]
    ${diagnosis_list}    Evaluate    [x.strip() for x in '''${diagnosis_txt}'''.split(',')]
    Should Be Equal    ${body_request_APT["icdCodes"]}    ${diagnosis_list}

Check Refering Provider Value
    ${refering_provider_txt}    Get Value    ${APT_row}//following::*[contains(@class, 'ReferringPhysicianSelector input')][2]
    Should Contain    ${refering_provider_txt}    ${APT_response_json["referringProviderNPI"]}

Check Refer to Provider Value
    ${refer_to_provider_txt}    Get Value    ${APT_row}//following::*[contains(@class, 'PhysicianSelector input')][2]
    Should Contain    ${refer_to_provider_txt}    ${APT_response_json["referToProviderNPI"]}

Check Appointment Note Value
    ${apt_note_txt}    Get Text    ${APT_row}//following::*[contains(@id, 'ApptNoteTextArea')]
    Should Be Equal    ${apt_note_txt}    ${body_request_APT["note"]}

Check Service Type Value
    ${service_type_txt}    Get Text    ${APT_row}//following::*[contains(text(),'Service Type: ')]//following::strong[1]
    ${service_type_txt}    Replace String    ${service_type_txt}    ${SPACE}    ${EMPTY}
    ${type_service_request}    Set Variable    ${body_request_APT["type"]}
    Log To Console    ${type_service_request}
    IF    "${type_service_request}" == "Specialty"
        Should Contain    ${service_type_txt.lower()}    ${type_service_request.lower()}
    ELSE IF    "${type_service_request}" == "MedProvided"
        ${type_service_request}    Replace String    ${type_service_request}    Med    ${EMPTY}
        Should Contain    ${service_type_txt.lower()}    ${type_service_request.lower()}
    ELSE IF    "${type_service_request}" == "ThreeFourtyB"
        ${type_service_request}    Replace String    ${type_service_request}    ThreeFourtyB    340B
        Should Be Equal    ${service_type_txt.lower()}    ${type_service_request.lower()}
    ELSE
        Should Be Equal    ${service_type_txt.lower()}    ${type_service_request.lower()}
    END

Check Primary Medication Value
    ${med_txt}    Get Text    ${APT_row}//following::*[contains(@id, 'ApptMedColumn')]
    Should Contain    ${med_txt}    ${APT_response_json["primaryMedication"]}

Check Dosage Value
    ${med_txt}    Get Text    ${APT_row}//following::*[contains(@id, 'ApptMedColumn')]
    ${dosage_value}    Evaluate    str(int(${APT_response_json["dosage"]}))
    Should Contain    ${med_txt}    ${dosage_value} ${APT_response_json["dosageUOM"]}

Check Location Number
    ${location_value}    Get Text    ${APT_row}//following::strong[contains(text(),'ROOM')]
    Should Contain    ${location_value}    ${APT_response_json["locationNumber"]}
    
Check Status Value
    [Arguments]    ${status_arg}
    ${status_value}    Get Text    ${APT_row}//following::*[contains(@class, 'appointmentStatusBadge')]
    ${status_value}    Replace String    ${status_value}    ${SPACE}    ${EMPTY}
    Should Contain    ${status_value}    ${status_arg}

Check Treatment StartTime, Treatment EndTime And Treatment Duration
    ${treatment_starttime}    Get Value    ${APT_row}//following::div[contains(text(),'Start Time: ')]//following::input[1]
    ${starttime_value}    Convert Date    ${body_request_dispense["treatmentStartTime"]}    date_format=%Y-%m-%dT%H:%M:%SZ   result_format=%#H:%M
    Should Contain    ${treatment_starttime}    ${starttime_value}
    ${treatment_stoptime}    Get Value    ${APT_row}//following::div[contains(text(),'Stop Time: ')]//following::input[1]
    ${stoptime_value}    Convert Date    ${body_request_dispense["treatmentEndTime"]}    date_format=%Y-%m-%d %H:%M:%S.%f   result_format=%#H:%M
    Should Contain    ${treatment_stoptime}    ${stoptime_value}
    ${treatment_duration}    Get Value    ${APT_row}//following::div[contains(text(),'Treatment Duration: ')]//following::input[1]
    ${duration_time}     Subtract Time From Time    ${stoptime_value}    ${starttime_value}
    ${hours}    Evaluate    int(${duration_time} // 60)
    ${minutes}  Evaluate    int(${duration_time} % 60)
    Should Be Equal    ${treatment_duration}    ${hours} Hours, ${minutes} Minutes

Check Vials Dispensed Value
    ${vials_value}    Get Text    ${APT_row}//following::strong[@class="vialCount"]
    Should Be Equal As Integers    ${vials_value}    ${body_request_dispense["medicationDispenses"][0]["quantity"]}
    
Open Created Appointment
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Appointment.Go To Patients Page
    Filter Location And Mrn    ${locationPO_arg}    ${mrn_arg}
    RePatient.Select Patient From List    MRN_arg=${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_tab}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${APT_note_label}
    ${APT_datetime}    Convert Date    ${APT_response_json["startTime"]}    date_format=%Y-%m-%dT%H:%M:%SZ   result_format=%m/%d/%Y
    Set Test Variable    ${APT_datetime}
    ${APT_row}    Util.Replace Xpath    ${APT_row}
    Set Test Variable    ${APT_row}
    Scroll Element Into View    ${APT_row}//following::tr[1]

Verify The Appointment Information After The Medication Has Been Dispensed
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    Open Created Appointment    ${locationPO_arg}    ${mrn_arg}
    Open Appointment ModalPopup
    Check Lot Number Value    ${medication_dispensing_response_json[0]["lotNumber"]}
    Check Expiration Date After Medication Dispensed
    Check Medication Dispense Type    ${medication_dispensing_response_json[0]["medicationDispenseType"]}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${APT_page_close_PO_btn}
    Wait Until Keyword Succeeds    30s    1    Click Button    ${APT_page_close_PO_btn}
    Open Therapy With Valid NDC    ${medication_dispensing_response_json[0]["ndc"]}
    Check Short Description Value    ${medication_dispensing_response_json[0]["medicationStockText"]}
    Check Proprietary Name Value
    Check Site Of Admin Value
    Check NDC Pkg Code Value
    Check HCPCS Code Value
    Check Dosage Total Value
    Scroll Element Into View    ${APT_page_close_PO_btn}
    Wait Until Keyword Succeeds    30s    1    Click Button    ${APT_page_close_PO_btn}

Open Appointment ModalPopup
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_row}//following::a[contains(text(),'Open Appointment')]
    ${check}    Run Keyword And Return Status    Wait Until Page Contains    Warning - Opening Future Appointment    2s
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    30s    1s    Click Button    //button[contains(text(),'Yes / Continue')]
    END
    Wait Until Page Contains Element    //a[@id="AppointmentInfo"]    30s
    
Check Lot Number Value
    [Arguments]    ${lotnumber_response}
    Wait Until Page Contains Element    //select[@name="LotID"]    30s
    ${lotNumber_txt}    Get Selected List Label    //select[@name="LotID"]
    ${lotNumber_value}    Fetch From Left    ${lotNumber_txt}    \ --\
    Should Be Equal    ${lotNumber_value}    ${lotnumber_response}
    Set Test Variable    ${lotNumber_txt}

Check Expiration Date After Appointment Dispensed
    ${lot_exp_value}    Fetch From Right    ${lotNumber_txt}    \Exp: \
    ${lot_exp_value}    Fetch From Left    ${lot_exp_value}    \]\
    ${lotExpirationDate}    Convert Date    ${body_request_dispense["medicationDispenses"][0]["lotExpirationDate"]}    result_format=%#m/%#d/%Y
    Should Be Equal    ${lotExpirationDate}    ${lot_exp_value}

Check Expiration Date After Medication Dispensed
    ${lot_exp_value}    Fetch From Right    ${lotNumber_txt}    \Exp: \
    ${lot_exp_value}    Fetch From Left    ${lot_exp_value}    \]\
    ${lotExpirationDate}    Convert Date    ${medication_dispensing_response_json[0]["lotExpirationDate"]}    date_format=%m/%d/%Y %I:%M:%S %p    result_format=%#m/%#d/%Y
    Should Be Equal    ${lotExpirationDate}    ${lot_exp_value}

Check Medication Dispense Type
    [Arguments]    ${med_response}
    IF    "${medication_dispensing_response_json[0]["medicationDispenseType"]}" == "Primary"
        ${dispense_type_txt}    Get Text    //a[@id="AppointmentPrimaryMedication"]
        ${dispense_type}    Fetch From Left    ${dispense_type_txt}    \ \
        Should Be Equal    ${dispense_type}    ${medication_dispensing_response_json[0]["medicationDispenseType"]}
    ELSE
        ${dispense_type_txt}    Get Text    //a[@id="AppointmentAdditionalMedications"]
        ${dispense_type}    Fetch From Left    ${dispense_type_txt}    \ \
        Should Be Equal    ${dispense_type}    ${medication_dispensing_response_json[0]["medicationDispenseType"]}
    END

Select Rendering Provider
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${APT_note_label}
    Wait Until Keyword Succeeds    30s    1s    Input Text    //label[contains(text(),'Rendering (Billable) Provider: ')]//following::*[contains(@class, 'RenderingProvider ')][2]    ${referringProviderNPI}
    ${rendering_option}    Util.Replace Xpath    //label[contains(text(),'Rendering (Billable) Provider: ')]//following::strong[contains(text(), '${referringProviderNPI}')]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${rendering_option}
    Handle Alert    ACCEPT
    Wait Until Page Contains    Rendering Provider Added!    30s
    Wait Until Page Does Not Contain    Rendering Provider Added!    30s
    ${rendering_value}    Get Value    //label[contains(text(),'Rendering (Billable) Provider: ')]//following::*[contains(@class, 'RenderingProvider ')][2]
    Set To Dictionary    ${APT_response_json}    rendering_value=${rendering_value}
    Set Test Variable    ${APT_response_json}

Open Therapy With Valid NDC
    [Arguments]    ${ndc_response}
    Wait Until Keyword Succeeds    30s    1    Click Element    //a[contains(text(),' Administration ')][1]
    Scroll To Bottom And Click Element    (//a[contains(text(),'Inventory Items')])[1]
    Wait Until Page Does Not Contain    Loading Inventory Items    30s
    Wait Until Keyword Succeeds    30    1    Input Text    //input[@id="SearchValues"]    ${ndc_response}
    Wait Until Keyword Succeeds    30    1    Click Button    //button[@id="FindButton"]
    ${ndc_row}    Util.Replace Xpath    (//*[contains(text(),'${ndc_response}')])[1]
    Wait Until Keyword Succeeds    30    1    Click Element    ${ndc_row}
    Wait Until Element Is Visible    //h4[contains(text(),'Edit Inventory Item')]    30s

Check Short Description Value
    [Arguments]    ${description_arg}
    ${medicationStockText_txt}    Get Value    //input[@id="ShortDescription"]
    ${medicationStockText_txt}    Replace String    ${medicationStockText_txt}    ${SPACE}    ${EMPTY}
    ${medicationStockText_value}    Replace String    ${description_arg}    ${SPACE}    ${EMPTY}
    Should Be Equal    ${medicationStockText_txt}    ${medicationStockText_value}

Check Proprietary Name Value
    ${medicationProprietaryName_txt}    Get Value    //input[@id="ProprietaryName"]
    Should Be Equal    ${medicationProprietaryName_txt}    ${medication_dispensing_response_json[0]["medicationProprietaryName"]}

Check Site Of Admin Value
    Should Be Equal    ${None}    ${medication_dispensing_response_json[0]["siteOfAdministration"]}
    
Check NDC Pkg Code Value
    ${ndc_txt}    Get Value    //input[@id="NDCPackageCode"]
    Should Be Equal    ${ndc_txt}    ${medication_dispensing_response_json[0]["ndc"]}

Check HCPCS Code Value
    ${hcpcsCode_txt}    Get Value    //input[@id="HCPCS"]
    Should Be Equal    ${hcpcsCode_txt}    ${medication_dispensing_response_json[0]["hcpcsCode"]}

Check Dosage Total Value
    ${sum_dosage}    Evaluate    int(${medication_dispensing_response_json[0]["usedDose"]}+${medication_dispensing_response_json[0]["wasteDose"]})
    Should Be Equal As Integers    ${medication_dispensing_response_json[0]["totalDose"]}    ${sum_dosage}

Create New Payer Plan
    [Arguments]    ${locationPO_arg}    ${mrn_arg}    ${loop_arg}
    Repatient.Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    Repatient.Select Patient From List    MRN_arg=${mrn_arg}
    Open Payer Information Tab
    FOR    ${i}    IN RANGE    1    ${loop_arg}
        Add Payer
        Billing.Select Plan    index=${i}
        ${num_rand}    Appointment.Get Random Data    fake_data=num_rand
        Select Date In Payer
        &{old_medical}    Create Dictionary
        Set Suite Variable    ${old_medical}
        Fill Medical Info    subscriber=${num_rand}    group=${num_rand}    dict=${old_medical}    btn_arg=${payer_create_btn}
    END
    Open Patient Information Tab
    RePatient.Scroll To Bottom And Click Element    ${primary_assign_select}
    Select From List By Index    ${primary_assign_select}    1
    IF    ${i} > 1
        Select From List By Index    ${secondary_assign_select}    2
        Select From List By Index    ${tertiary_assign_select}    3
    END    
    RePatient.Scroll To Bottom And Click Element    ${Patients_Update_Btn}
    
Verify Bill Information
    Open Billable Event    account_num_arg=${head_multi_acc1}
    Check Appointment ID Billing
    Check MRN Billing
    Check StartTime And EndTime Billing
    Check DX Code Billing
    Check Rendering Billing Provider
    Check HCPCS Billing
    Check cptCodes Billing
    Check Payor Value

Open Billable Event
    [Arguments]    ${account_num_arg}
    Wait Until Keyword Succeeds    30    1    Click Element    //a[contains(text(),'Dispensing')]
    Scroll To Bottom And Click Element    //a[contains(text(),'Billable Events')]
    Wait Until Element Is Visible    //h2[contains(text(),' Billable Events')]    30
    Wait Until Keyword Succeeds    30    1    Click Button    //button[@data-id="MemberId"]
    Wait Until Keyword Succeeds    30    1    Input Text    //button[@data-id="MemberId"]//following::input[@aria-label="Search"][1]    ${account_num_arg}
    ${locationPO_option}    Util.Replace Xpath    //button[@data-id="MemberId"]//following::span[contains(text(),'${account_num_arg}')]
    Wait Until Keyword Succeeds    30    1    Click Element    ${locationPO_option}
    Wait Until Keyword Succeeds    30    1    Click Button    //button[contains(@class,'patientClearButton')]
    Wait Until Keyword Succeeds    30    1    Input Text    //input[@id="BillingLedgerPatientId"]    ${response_json["mrn"]} 
    Wait Until Keyword Succeeds    30    1    Click Element    //div[@tabindex="-1"]
    Wait Until Keyword Succeeds    30    1    Click Element    //a[contains(text(),'Search')]
    Wait Until Element Is Visible    //a[contains(text(),'Open Appointment')]    30

Check Appointment ID Billing
    ${bill_apt_id_txt}    Get Text    ${APT_row}//preceding::strong[2]
    Should Contain    ${bill_apt_id_txt}    ${bill_response_json["appointmentID"]}
    
Check MRN Billing
    ${bill_mrn_txt}    Get Text    ${APT_row}//following::span[contains(text(),'MRN')]//following::strong[1]
    Should Be Equal    ${bill_mrn_txt}    ${bill_response_json["mrn"]}

Check StartTime And EndTime Billing
    ${bill_starttime_txt}    Get Value    ${APT_row}//following::input[@id="ApptStartTime"]
    ${bill_endtime_txt}    Get Value    ${APT_row}//following::input[@id="ApptStopTime"]
    ${bill_starttime_resonse}    Convert Date    ${bill_response_json["treatmentStartTime"]}    date_format=%Y-%m-%dT%H:%M:%S   result_format=%#H:%M %p
    ${bill_endtime_resonse}    Convert Date    ${bill_response_json["treatmentEndTime"]}    date_format=%Y-%m-%dT%H:%M:%S   result_format=%#H:%M %p
    Should Be Equal    ${bill_starttime_txt.lower()}    ${bill_starttime_resonse.lower()}
    Should Be Equal    ${bill_endtime_txt.lower()}    ${bill_endtime_resonse.lower()}

Check DX Code Billing
    ${dxcode_txt}    Get Text    ${APT_row}//following::span[contains(text(),'DX Code:')]//following::div[1]
    ${icdCode_lenght}    Get Length    ${bill_response_json["icdCodes"]}
    FOR    ${i}    IN RANGE    ${icdCode_lenght}
        Should Contain    ${dxcode_txt}    ${bill_response_json["icdCodes"][${i}]}
    END

Check Rendering Billing Provider
    ${rendering_txt}    Get Selected List Label    ${APT_row}//following::select[@id="PhysicianName"]
    ${rendering_value}    Get Regexp Matches    ${APT_response_json["rendering_value"]}    \\d+
    ${rendering_value}    Get From List    ${rendering_value}    0
    Should Contain    ${rendering_txt}    ${rendering_value}

Check HCPCS Billing
    ${lenght}    Get Length    ${bill_response_json["hcpcSs"]}
    FOR    ${i}    IN RANGE    ${lenght}
        ${billableUnits_value}    Evaluate    int(${bill_response_json["hcpcSs"][${i}]["billableUnits"]})
        ${hcpc_txt}    Util.Replace Xpath    ${APT_row}//following::strong[contains(text(),'${bill_response_json["hcpcSs"][${i}]["code"]}')]//following::input[@value="${billableUnits_value}"]
        Wait Until Element Is Visible    ${hcpc_txt}
        ${ndc_hcpc_txt}    Get Text    (${hcpc_txt})[1]//preceding::tr[1]//td[2]//strong[1]
        ${ndc_hcpc_txt}    Fetch From Left    ${ndc_hcpc_txt}    \ \
        Should Be Equal    ${ndc_hcpc_txt}    ${bill_response_json["hcpcSs"][${i}]["ndc"]}    
        ${modifier_txt}    Get Selected List Label    (${hcpc_txt})[1]//preceding::select[@id="result_FirstBillingModifier"][1]
        IF    "${modifier_txt}" != "-"
            Should Be Equal    ${bill_response_json["hcpcSs"][${i}]["modifiers"][0]["modifier"]}     ${modifier_txt}
        END
        ${dxcode_txt}    Get Text    ${APT_row}//following::span[contains(text(),'DX Code:')]//following::div[1]
        ${icdCode_txt}    Get Selected List Label    (${hcpc_txt})[1]//preceding::select[@id="result_ResultICDCode"][1]
        IF    "${icdCode_txt}" == "A"
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    A\\)\\s*([A-Z0-9\\.]+)
        ELSE IF    "${icdCode_txt}" == "B"
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    B\\)\\s*([A-Z0-9\\.]+)
        ELSE
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    C\\)\\s*([A-Z0-9\\.]+)
        END
        ${matches}=    Get From List    ${matches}    0
        ${icdCode_txt}    Fetch From Right    ${matches}    \ \
        Should Be Equal    ${bill_response_json["hcpcSs"][${i}]["icdCodes"]}    ${icdCode_txt}
    END

Check cptCodes Billing
    ${lenght}    Get Length    ${bill_response_json["cptCodes"]}
    FOR    ${i}    IN RANGE    ${lenght}
        ${cpt_txt}    Util.Replace Xpath    ${APT_row}//following::option[@selected="selected" and contains(text(),'${bill_response_json["cptCodes"][${i}]["code"]}')]//parent::select[@id="result_SelectedCPTCode"]
        ${description_txt}    Get Text    ${cpt_txt}//preceding::tr[1]//td[2]//strong
        Should Be Equal    ${description_txt}    ${bill_response_json["cptCodes"][${i}]["description"]}
        ${billableUnits_txt}    Get Value    ${cpt_txt}//following::td[7]//input
        Should Be Equal As Integers    ${billableUnits_txt}    ${bill_response_json["cptCodes"][${i}]["billableUnits"]}
        ${modifier_txt}    Get Selected List Label    ${cpt_txt}//following::td[1]//select
        IF    "${modifier_txt}" != "-"
            Should Be Equal    ${bill_response_json["cptCodes"][${i}]["modifiers"][0]["modifier"]}     ${modifier_txt}
        END
        ${dxcode_txt}    Get Text    ${APT_row}//following::span[contains(text(),'DX Code:')]//following::div[1]
        ${icdCode_txt}    Get Selected List Label    ${cpt_txt}//following::td[5]//select
            IF    "${icdCode_txt}" == "A"
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    A\\)\\s*([A-Z0-9\\.]+)
        ELSE IF    "${icdCode_txt}" == "B"
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    B\\)\\s*([A-Z0-9\\.]+)
        ELSE
            ${matches}=    Get Regexp Matches    ${dxcode_txt}    C\\)\\s*([A-Z0-9\\.]+)
        END
        ${matches}=    Get From List    ${matches}    0
        ${icdCode_txt}    Fetch From Right    ${matches}    \ \
        Should Be Equal    ${bill_response_json["cptCodes"][${i}]["icdCodes"]}    ${icdCode_txt}
    END

Check Payor Value
    ${payor_type}    Util.Replace Xpath    //h4[contains(text(),'${bill_response_json["payors"][0]["payorType"]} Payor')]//following::select[@id="payer_Payer"][1]
    Wait Until Element Is Visible    ${payor_type}    30s
    Scroll Element Into View    ${payor_type}
    ${payor_name_txt}    Get Selected List Label    ${payor_type}
    Should Be Equal    ${payor_name_txt}    ${bill_response_json["payors"][0]["name"]}
    Should Be Equal    ${old_medical.CertificateNumber}    ${bill_response_json["payors"][0]["subscriber"]}
    Should Be Equal    ${old_medical.GroupNumber}    ${bill_response_json["payors"][0]["groupNumber"]}
    ${effectiveDate_response}    Convert Date    ${bill_response_json["payors"][0]["effectiveDate"]}    date_format=%Y-%m-%dT00:00:00    result_format=%m/%d/%Y
    ${expirationDate_response}    Convert Date    ${bill_response_json["payors"][0]["expirationDate"]}    date_format=%Y-%m-%dT00:00:00    result_format=%m/%d/%Y
    Should Be Equal    ${effective_date}    ${effectiveDate_response}
    Should Be Equal    ${expirationDate}    ${expirationDate_response}
    
Delete Patient From Patient List
    FOR    ${patient}    IN    @{patient_list}
        ${account_number}=    Get From Dictionary    ${patient}    accountNumber
        ${mrn_patient}=    Get From Dictionary    ${patient}    MRN
        IF    '${account_number}' == '${head_multi_acc1}'
            ${account_number}    Set Variable    ${head_multi_PO1}
        ELSE IF    '${account_number}' == '${head_multi_acc2}'
            ${account_number}    Set Variable    ${head_multi_PO2}
        ELSE IF    '${account_number}' == '${head_1_acc1}'
            ${account_number}    Set Variable    ${head_1_PO1}
        ELSE IF    '${account_number}' == '${head_0_acc1}'
            ${account_number}    Set Variable    ${head_0_PO1}
        ELSE IF    '${account_number}' == '${nohead_1_acc1}'
            ${account_number}    Set Variable    ${nohead_1_PO1}
        END
        Create Merge Patient    ${account_number}    ${merge_apt_mrn}
        Delete Created Patient    account_number=${account_number}    mrn_arg=${mrn_patient}
    END

Setup Data For Full Integration
    ${data_input}    Get Data
    Set Suite Variable    ${primaryMedication}    ${data_input}[primaryMedication]
    Set Suite Variable    ${emrMedication}    ${data_input}[emrMedication]
    Set Suite Variable    ${scope}    ${data_input}[scope]
    Set Suite Variable    ${grantType}    ${data_input}[grantType]
    Set Suite Variable    ${referringProviderNPI}    ${data_input}[referringProviderNPI]
    Set Suite Variable    ${preferredInternalProviderNPI}    ${data_input}[preferredInternalProviderNPI]
    Set Suite Variable    ${merge_apt_mrn}    ${data_input}[merge_mrn]
    Set Suite Variable    ${barcode}    ${data_input}[barcode]
    Set Suite Variable    ${lotnum}    ${data_input}[lotnum]
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

    # ave head office and list account = 0
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