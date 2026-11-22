** Settings **
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    FakerLibrary
Library    ../../PageObjects/TestData/Fakedata/FakeData.py
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/RePatient.resource
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Resource   ../../../resources/ApiObjects/Keywords/Appointment.resource
Resource   ../../../resources/ApiObjects/Keywords/Dispense.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Variables   ../../../resources/PageObjects/Locators/ProviderOrdersLocator.py
Variables    ../../PageObjects/TestData/Testdata.py
** Variables **
${BILL_SCHEMA_STRING} 
    ...    {
    ...        "type": "object",
    ...        "properties": {
    ...            "emrPatientID": { "type": ["string", "null"], "minLength": 0, "maxLength": 50 },
    ...            "mrn": { "type": ["string", "null"], "minLength": 0, "maxLength": 50 },
    ...            "appointmentID": { "type": ["string", "null"], "minLength": 0, "maxLength": 50 },
    ...            "startTime": { "type": "string", "format": "date-time" },
    ...            "treatmentStartTime": { "type": "string", "format": "date-time" },
    ...            "treatmentEndTime": { "type": "string", "format": "date-time" },
    ...            "referringProviderNPI": { "type": ["string", "null"]},
    # ...            "renderingProviderNPI": { "type": ["string", "null"]},
    ...            "icdCodes": { 
    ...                "type": ["array", "null"], 
    ...                "items": { "type": "string" } 
    ...            },
    ...            "cptCodes": {
    ...                "type": ["array", "null"],
    ...                "items": {
    ...                    "type": "object",
    ...                    "properties": {
    ...                        "code": { "type": "string" },
    ...                        "description": { "type": "string" },
    ...                        "billableUnits": { "type": "number" },
    ...                        "icdCodes": { "type": "string" },
    ...                        "modifiers": {
    ...                            "type": ["array", "null"],
    ...                            "items": { "type": "string" }
    ...                        }
    ...                    }
    ...                }
    ...            },
    ...            "hcpcSs": {
    ...                "type": ["array", "null"],
    ...                "items": {
    ...                    "type": "object",
    ...                    "properties": {
    ...                        "code": { "type": "string" },
    ...                        "medicationProprietaryName": { "type": "string" },
    ...                        "ndc": { "type": "string" },
    ...                        "billableUnits": { "type": "number" },
    ...                        "icdCodes": { "type": "string" },
    ...                        "modifiers": {
    ...                            "type": ["array", "null"],
    ...                            "items": {
    ...                                "type": "object",
    ...                                "properties": {
    ...                                    "modifier": { "type": "string" },
    ...                                    "definition": { "type": "string" }
    ...                                }
    ...                            }
    ...                        }
    ...                    }
    ...                }
    ...            },
    ...            "payors": {
    ...                "type": ["array", "null"],
    ...                "items": {
    ...                    "type": "object",
    ...                    "properties": {
    ...                        "payorType": { "type": "string" },
    ...                        "name": { "type": "string" },
    ...                        "subscriber": { "type": "string" },
    ...                        "planID": { "type": "string" },
    ...                        "groupNumber": { "type": "string" },
    ...                        "effectiveDate": { "type": "string", "format": "date-time" },
    ...                        "expirationDate": { "type": "string", "format": "date-time" }
    ...                    }
    ...                }
    ...            }
    ...        }
    ...    }

** Keywords **

Create New Payer Plan
    [Arguments]    ${locationPO_arg}    ${mrn_arg}    ${loop_arg}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window
    Repatient.Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    Repatient.Select Patient From List    MRN_arg=${mrn_arg}
    Open Payer Information Tab
    FOR    ${i}    IN RANGE    1    ${loop_arg}
        Add Payer
        Select Plan    index=${i}
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
    Close Browser
Select Plan
    [Arguments]    ${index}
    Wait Until Keyword Succeeds    30s    1s    Click Element    (${select_plan_radio})[${index}]

Validate JSON Fields Max Length
    [Arguments]    ${response_arg}
    ${parsed_schema}    Convert String To JSON    ${BILL_SCHEMA_STRING}
    ${parsed_json}    Convert String To JSON    ${response_arg}
    Validate Json By Schema    ${parsed_json}    ${parsed_schema}

Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval"
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Patient.Create New Patient    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    expected_status=400
    Should Contain    ${bill_response_json['detail']}    This appointment has not been dispensed yet, so there is no billing information available at the moment. Please check again or contact us for further details.

Sending Request With Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    ${emrAppointmentID}    Patient.Get Random Data    fake_data=emrAppointmentID
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    emr_apt_id_arg=${emrAppointmentID}
    ...    expected_status=400
    Should Contain    ${bill_response_json['detail']}    Can not find the appointment.

Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Patient.Create New Patient    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Dispense.Create Fake Data List
    Dispense.Get Access Token    head_account=${head_account_arg}
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
    ...    treatment_end_time_arg= ${treatment_start_date}
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    expected_status=200
    Length Should Be    ${bill_response_json["cptCodes"]}    0

Sending Request With EMR Appointment ID Not Matches AccountNumber In Fusebox
    [Arguments]    ${head_account_arg}    ${account_num_arg}    ${head_account_no_match}    ${account_num__no_match}
    Patient.Create New Patient    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Dispense.Sending Request To Dispense Appointment     head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_no_match}
    ...    account_number_arg=${account_num__no_match}
    ...    emr_apt_id_arg=${APT_response_json["emrAppointmentID"]}
    ...    expected_status=400
    Should Contain    ${bill_response_json['detail']}    Can not find the appointment.

Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Patient.Create New Patient    head_account_arg=${head_account_arg}    account_num_arg=${account_num_arg}
    Appointment.Create Fake Appointment Data With Required Fields
    Get StartDate And EndDate
    ${icd_code_value}    Create List
    Set Test Variable    ${icd_code_value}
    Appointment.Create New Appointment
    ...    head_account_arg=${head_account_arg}
    ...    account_number_send=${account_num_arg}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Dispense.Create Fake Data List
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
    ...    treatment_end_time_arg= ${treatment_start_date}
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    expected_status=200
    Should Be Equal    ${bill_response_json["renderingProviderNPI"]}    ${None}
    Length Should Be    ${bill_response_json["icdCodes"]}    0
    Length Should Be    ${bill_response_json["cptCodes"]}    0
    Length Should Be    ${bill_response_json["payors"]}    0

Sending Request With Fields Has Type=Array Containing Multiple Data
    [Arguments]    ${head_account_arg}    ${account_num_arg}    ${locationPO_arg}
    Create New Payer Plan    locationPO_arg=${locationPO_arg}    mrn_arg=${response_json["mrn"]}    loop_arg=4
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    expected_status=200
    ${length_icdCode}=    Get Length    ${bill_response_json["icdCodes"]}
    Should Be True    ${length_icdCode} >= 2
    ${length_cptCodes}=    Get Length    ${bill_response_json["cptCodes"]}
    Should Be True    ${length_cptCodes} >= 2
    ${length_hcpcSs}=    Get Length    ${bill_response_json["hcpcSs"]}
    Should Be True    ${length_hcpcSs} >= 2
    ${length_payors}=    Get Length    ${bill_response_json["payors"]}
    Should Be True    ${length_payors} >= 2

Check The API Response Error When No Authentication Token Is Present
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Billing.Get Access Token    head_account=${head_account_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer eyJhbGciOiJSUzM4NCIsImtpZCI6IjEzRUFDQTY1RDJBMjE3NDdGMkNFQjA4NjM5MkM1MDVGNUIxRDExNkUiLCJ4NXQiOiJFLXJLWmRLaUYwZnl6ckNHT1N4UVgxc2RFVzQiLCJ0eXAiOiJhdCtqd3QifQ.eyJzdWIiOiJmNjlhZWQ3NS00MzMzLTRmNmMtOWIxMy1hYjU4NGU3ODE5OTkiLCJob2EiOiIxMDExOCIsImFjY291bnQiOiIxMjczOSAxMjc0MSIsIm9pX3Byc3QiOiJmNjlhZWQ3NS00MzMzLTRmNmMtOWIxMy1hYjU4NGU3ODE5OTkiLCJjbGllbnRfaWQiOiJmNjlhZWQ3NS00MzMzLTRmNmMtOWIxMy1hYjU4NGU3ODE5OTkiLCJvaV90a25faWQiOiJjNmY4MzUyNC0zOThiLTQzNmYtYTU0MS1lNjc0MGE1Y2ZhNzIiLCJzY29wZSI6ImZ1c2Vib3hfYXBpIiwianRpIjoiMWRkMzUwYjEtOTUwOC00ZWVhLTliZjYtN2U5N2QwZmZiOThlIiwiZXhwIjoxNzQ0MTA2MjgwLCJpc3MiOiJodHRwczovL21haW5icmlkZ2VocC1hcGktZGV2LmF6dXJld2Vic2l0ZXMubmV0LyIsImlhdCI6MTc0NDEwNTk4MH0.d2B5CxGYhOpv0pihZBMVFibqklBh3JBAKpVEMc_qzrgDbAdvSlGZs_rIP8Xnbi-HKZQVV5vmsjDAzIHAt4SphqX5yVJ2rYGchKl3FYUOBuM_P3PWe5Nz03peVUAF2aeYHyWuZMTIbJPAU_i5zycD0Lq48fY02BcJxpJIUtZ3EFyKHfeys9wVs3qF_v8PLaKPYayOeyyV6Wt8SRIjq01NqzSIV68qmKg5f6iVR5lJELyQ4gDKjYgJRw-uJNWjA4f6Wmu-wLH1Qq5oFglJP4kBJ70mtJtCZmq_G_q2jFPVQ8aqk7Znlnr3RRc0R48rUSJ3pGIfntOWMyfFjfFjJE0l6g
    ...    Content-Type=application/json
    ${body_request_Bill}    Create Dictionary   
    ...    head_account_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    emrAppointmentID=${APT_response_json["emrAppointmentID"]}
    Set Test Variable    ${body_request_Bill}
    ${bill_response}    GET On Session    mysession    ${bill_path}    params=${body_request_Bill}    headers=${headers}    expected_status=401

Sending Body Request With All Billing Fields
    [Arguments]
    ...    ${head_account_arg}=${head_multi_data}
    ...    ${account_number_arg}=${head_multi_acc1}
    ...    ${emr_apt_id_arg}=${APT_response_json["emrAppointmentID"]}
    ...    ${expected_status}=${expected_status}
    Billing.Get Access Token    head_account=${head_account_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request_Bill}    Create Dictionary   
    ...    accountNumber=${account_number_arg}
    ...    emrAppointmentID=${emr_apt_id_arg}
    Set Test Variable    ${body_request_Bill}
    ${body_request_Bill}    Evaluate    {k: v for k, v in $body_request_Bill.items() if v not in ["missing"]}
    ${bill_response}    GET On Session    mysession    ${bill_path}    params=${body_request_Bill}    headers=${headers}    expected_status=${expected_status}
    ${bill_response_json}    Set Variable    ${bill_response.json()}
    Set Test Variable    ${bill_response_json}

Test Setup With List Account = 1
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Dispense.Sending Request To Dispense Appointment     head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Test Setup With List Account = 0
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Dispense.Sending Request To Dispense Appointment     head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

Get URL API Billing
    ${config_path}    Testdata.Get Api Configs     ${env}
    Log    ${config_path}
    ${json_data}    Set Variable    ${config_path}
    ${base_url}    Get From Dictionary    ${json_data}    baseUrl
    ${bill_path}    Get From Dictionary    ${json_data}    bill
    ${token_url}    Get From Dictionary    ${json_data}    tokenUrl
    Set Suite Variable    ${base_url}
    Set Suite Variable    ${bill_path}
    Set Suite Variable    ${token_url}
Get Access Token
    [Arguments]    ${head_account}
    Create Session    auth_session    ${base_url}
    ${headers}    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${response}    POST On Session    auth_session    ${token_url}    data=${head_account}    headers=${headers}    expected_status=200
    ${access_token}    Set Variable    ${response.json()["access_token"]}
    Set Suite Variable    ${access_token}

# Get Random Data
#     [Arguments]    ${fake_data}
#     # ${data}    Generate Data
#     ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
#     RETURN    ${fake_data}

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
