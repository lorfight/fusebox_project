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
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Variables   ../../../resources/PageObjects/Locators/ProviderOrdersLocator.py
Variables    ../../PageObjects/TestData/Testdata.py
** Variables **
${create_PO_btn}    //a[contains(text(),'Create Provider Order ')]
${location}    //select[@id="CustomerAccountId"]
${mrn_search_value}    //input[@id="SearchValues"]
${PO_tab}    //a[@id='PhysicianOrder']
${med_select}    //select[@id="PrimaryMedication"]
${icd_code_select}    //select[@id="PrimaryICDCode"]
${PO_modal_create_btn}    //button[contains(text(),'Create ')]
${PO_modal_close_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
${physician_input}    //input[@id="ReferralPhysician"]
${ordering_physician}    //select[@id="OrderingPhysician"]
${weight_PO_input}    //input[@id="WeightPO"]
${height_PO_ft}    //input[@id="PatientHeightft"]
${height_PO_inch}    //input[@id="PatientHeightin"]
${weight_PO_checkbox}    //input[@data-unit="kg"]
${PO_dosage_assign}    //input[@id="DosageAssigned"]
${PO_frequency_value}    //select[@id="FrequencyValue"]
${PO_dose_frequency}    //select[@id="DoseFrequency"]
${PO_dose_convert}    //input[@id="DosageAssignedConvert"]
${PO_place_service}    //select[@id="PlaceOfService"]
${PO_num_dose}    //input[@id="NumberOfDoses"]
${PO_uom_select}    //select[@id="PreferredUoM"]
${Po_container_type}    //select[@id="ContainerType"]
${PO_split_dose}    //input[@id="SplitDose"]
${PO_split_treatment}    //select[@id="NumberOfSplitDoseTreatments"]
${find_btn}    //button[@id="FindButton"]
${APT_tab}    //a[@id="Appointment"]
${APT_note_label}    //label[contains(text(),'Appointment Note')]
${APT_diagnosis_span}    //span[contains(text(),'Diagnosis:')]//parent::div

${APT_SCHEMA_STRING}   
    ...    {
    ...        "type": "object",
    ...        "properties": {
    ...            "id": { "type": "number" },
    ...            "accountNumber": { "type": ["string", "null"], "pattern": "^[0-9]+$"},
    ...            "emrPatientID": { "type": ["string", "null"], "minLength": 0, "maxLength": 50 },
    ...            "patientMRN": { "type": ["string", "null"], "minLength": 0, "maxLength": 50 },
    ...            "type": { "type": ["string", "null"] },
    ...            "startTime": { "type": "string", "format": "date-time" },
    ...            "endTime": { "type": ["string", "null"], "format": "date-time" },
    ...            "primaryMedication": { "type": "string" },
    ...            "doseQuantity": { "type": "number", "minLength": 0, "maxLength": 1000000 },
    ...            "emrAppointmentID": { "type": ["string", "null"] },
    ...            "note": { "type": ["string", "null"], "minLength": 0, "maxLength": 255 },
    ...            "locationNumber": { "type": ["string", "null"], "minLength": 0, "maxLength": 2147483647, "pattern": "^[0-9]+$" },
    ...            "icdCodes": { "type": ["array", "null"], "items": {"type": "string"}},
    ...            "referringProviderNPI": { "type": ["string", "null"], "minLength": 0, "maxLength": 2147483647, "pattern": "^[0-9]+$" },
    ...            "referToProviderNPI": { "type": ["string", "null"], "minLength": 0, "maxLength": 2147483647, "pattern": "^[0-9]+$" },
    ...            "scheduleConflictReason": { "type": ["string", "null"] }
    ...        }
    ...    }
** Keywords **
Get StartDate And EndDate
    ${result}    Get Next Date Timezone
    ${start_date}=    Get From Dictionary    ${result}    start_date
    ${end_date}=    Get From Dictionary    ${result}    end_date
    ${pre_date}=    Get From Dictionary    ${result}    pre_date
    Set Test Variable    ${start_date}
    Set Test Variable    ${end_date}
    Set Test Variable    ${pre_date}

Validate JSON Fields For Appointment Save
    [Arguments]    ${APT_response_arg}
    ${APT_parsed_schema}    Convert String To JSON    ${APT_SCHEMA_STRING}
    ${APT_parsed_json}    Convert String To JSON    ${APT_response_arg}
    Validate Json By Schema    ${APT_parsed_json}    ${APT_parsed_schema}

Check Status Response
    [Arguments]    ${APT_response_json}
    ${status_list}    Create List    
    ...    Approved
    ...    AwaitingOrder
    ...    Ordered
    ...    AwaitingDispense
    ...    Administering
    ...    Administered
    ...    Open
    ...    Closed
    ${status_found}    Run Keyword And Return Status    Should Contain    ${status_list}    ${APT_response_json["status"]}
    Run Keyword If    ${status_found}    Log    Status "${APT_response_json["status"]}" is in the list.
    ...    ELSE    Log    Status "${APT_response_json["status"]}" is NOT in the list.
    Set Test Variable    ${status_found}
    Should Match Regexp    ${APT_response_json["id"]}${EMPTY}    \\d+

Compare Request And Response With All Fields
    [Arguments]    ${APT_response_json}
    IF    "${body_request_APT["accountNumber"]}" == "missing"
        Should Be Equal As Integers    ${APT_response_json["accountNumber"]}    ${response_json["accountNumber"]}
    ELSE IF    "${body_request_APT["accountNumber"]}" == "${None}"
        Should Be Equal As Integers    ${APT_response_json["accountNumber"]}    ${response_json["accountNumber"]}    
    ELSE
        Should Be Equal As Integers    ${APT_response_json["accountNumber"]}    ${body_request_APT["accountNumber"]}
    END

    Should Be Equal    ${APT_response_json["startTime"]}    ${body_request_APT["startTime"]}

    IF    "${body_request_APT["endTime"]}" == "missing"
        Should Be Equal    ${APT_response_json["endTime"]}    ${None}
    ELSE IF    "${body_request_APT["endTime"]}" == "${EMPTY}"
        Should Be Equal    ${APT_response_json["endTime"]}    ${None}
    ELSE
        Should Be Equal    ${APT_response_json["endTime"]}    ${body_request_APT["endTime"]}
    END

    IF    "${body_request_APT["patientMRN"]}" == "missing"
        Should Be Equal    ${APT_response_json["patientMRN"]}    ${response_json["mrn"]}
    ELSE IF    "${body_request_APT["patientMRN"]}" == "${EMPTY}"
        Should Be Equal    ${APT_response_json["patientMRN"]}    ${response_json["mrn"]}
    ELSE
        Should Be Equal    ${APT_response_json["patientMRN"]}    ${body_request_APT["patientMRN"]}
    END

    IF    "${body_request_APT["emrPatientID"]}" == "missing"
        Should Be Equal    ${APT_response_json["emrPatientID"]}    ${response_json["emrPatientID"]}
    ELSE IF    "${body_request_APT["emrPatientID"]}" == "${EMPTY}"
        Should Be Equal    ${APT_response_json["emrPatientID"]}    ${response_json["emrPatientID"]}
    ELSE
        Should Be Equal    ${APT_response_json["emrPatientID"]}    ${body_request_APT["emrPatientID"]}
    END

    IF    "${body_request_APT["emrAppointmentID"]}" == "missing"
        Should Be Equal    ${APT_response_json["emrAppointmentID"]}    ${None}
    ELSE IF    "${body_request_APT["emrAppointmentID"]}" == "${EMPTY}"
        Should Be Equal    ${APT_response_json["emrAppointmentID"]}    ${EMPTY}
    ELSE
        Should Be Equal    ${APT_response_json["emrAppointmentID"]}    ${body_request_APT["emrAppointmentID"]}
    END
    Should Be Equal As Integers    ${APT_response_json["patientID"]}    ${response_json["id"]}

    Should Be Equal    ${APT_response_json["primaryMedication"]}    ${primaryMedication}

    IF    "${body_request_APT["doseQuantity"]}" == "missing"
        Should Be Equal As Integers    ${APT_response_json["dosage"]}    464
    ELSE
        Should Be Equal As Numbers    ${APT_response_json["dosage"]}    ${body_request_APT["doseQuantity"]}.0
    END

    IF    "${body_request_APT["locationNumber"]}" == "missing"
        Should Be Equal As Integers    ${APT_response_json["locationNumber"]}    ${0}
    ELSE IF    "${body_request_APT["locationNumber"]}" == "${None}"
        Should Be Equal As Integers    ${APT_response_json["locationNumber"]}    ${0}
    ELSE
        Should Be Equal    ${APT_response_json["locationNumber"]}    ${body_request_APT["locationNumber"]}
    END

    IF    "${body_request_APT["ReferringProviderNPI"]}" == "missing"
        Should Be Equal As Integers    ${APT_response_json["referringProviderNPI"]}    ${0}
    ELSE IF    "${body_request_APT["ReferringProviderNPI"]}" == "${None}"
        Should Be Equal As Integers    ${APT_response_json["referringProviderNPI"]}    ${0}
    ELSE
        Should Be Equal    ${APT_response_json["referringProviderNPI"]}    ${body_request_APT["ReferringProviderNPI"]}
    END

    IF    "${body_request_APT["ReferToProviderNPI"]}" == "missing"
        Should Be Equal As Integers    ${APT_response_json["referToProviderNPI"]}    ${0}
    ELSE IF    "${body_request_APT["ReferToProviderNPI"]}" == "${None}"
        Should Be Equal As Integers    ${APT_response_json["referToProviderNPI"]}    ${0}
    ELSE
        Should Be Equal    ${APT_response_json["referToProviderNPI"]}    ${body_request_APT["ReferToProviderNPI"]}
    END

    Should Be Equal    ${APT_response_json["status"]}    RequiresApproval
    Should Match Regexp    ${APT_response_json["id"]}${EMPTY}    \\d+

Get URL API Appointment
    ${config_path}    Testdata.Get Api Configs     ${env}
    Log    ${config_path}
    ${json_data}    Set Variable    ${config_path}
    ${base_url}    Get From Dictionary    ${json_data}    baseUrl
    ${appointment_path}    Get From Dictionary    ${json_data}    appointment
    ${token_url}    Get From Dictionary    ${json_data}    tokenUrl
    Set Suite Variable    ${base_url}
    Set Suite Variable    ${appointment_path}
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

Get Random Data
    [Arguments]    ${fake_data}
    # ${data}    Generate Data
    ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
    RETURN    ${fake_data}
    
Create Fake Appointment Data With Required Fields
    ${data}    Generate Data
    Set Test Variable    ${data}
    ${emrPatientID_fake}    Get Random Data    fake_data=emrPatientID
    ${emrAppointmentID_fake}    Get Random Data    fake_data=emrAppointmentID
    ${locationNumber_value}    Get Random Data    fake_data=locationNumber
    ${icd_code_value}    Get Random Data    fake_data=icdCodes
    ${types_value}    Get Random Data    fake_data=types
    ${num_rand}    Get Random Data    fake_data=num_rand
    ${sentence_str}    Get Random Data    fake_data=sentence
    &{APT_dict}    Create Dictionary    
    ...    emrPatientID_fake=${emrPatientID_fake}    emrAppointmentID_fake=${emrAppointmentID_fake}   
    ...    locationNumber_value=${locationNumber_value}    icd_code_value=${icd_code_value}    
    ...    types_value=${types_value}    num_rand=${num_rand}    sentence_str=${sentence_str}
    Set Suite Variable    ${APT_dict}
    RETURN    ${APT_dict}

Create New PO
    [Arguments]    ${locationPO_arg}    ${mrn_arg}    ${reffering_arg}    ${med_arg}    ${PO_dosage_arg}    ${status}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window
    Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    RePatient.Select Patient From List    MRN_arg=${mrn_arg}
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30    1    Click Element    ${create_PO_btn}
    Create PO    med_arg=${med_arg}    reffering_arg=${reffering_arg}    PO_dosage_arg=${PO_dosage_arg}    status=${status}
    Close Browser

Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PatientsLink}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients

Open Provider Orders tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${PO_tab}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_tab}
    Wait Until Element Is Visible    ${create_PO_btn}    30s

Create PO
    [Arguments]    ${med_arg}    ${reffering_arg}    ${PO_dosage_arg}    ${status}
    Wait Until Page Contains    Ordering Location    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${med_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}=    Get Selected List Label    ${icd_code_select}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${reffering_arg}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${reffering_arg}')]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${reffering_strong}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${reffering_arg}
    ${physician_selected_text}=    Get Selected List Label    ${ordering_physician}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    80
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_ft}    22
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_inch}    22
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${PO_dosage_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_frequency_value}    3
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_dose_frequency}    Week(s)
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dose_convert}    22
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_place_service}    In Office
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_num_dose}    22
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_uom_select}    Vial
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Po_container_type}    Pooled Bag
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_split_dose}    22
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_split_treatment}    3
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    Wait Until Page Contains    Provider Order Successfully Created!    30s
    Wait Until Page Does Not Contain    Provider Order Successfully Created!    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_close_btn}
    IF    ${status} == ${False}
        Wait Until Keyword Succeeds    30    1    Click Element    //a[contains(text(),'Edit Order ')][1]
        RePatient.Scroll To Bottom And Click Element    //input[@id="IsDiscontinuedService"]
        Wait Until Keyword Succeeds    30    1    Click Button    //button[@id="SaveBtn" and text()="Save "]
        Wait Until Page Contains    Provider Order Successfully Updated!    30s
        Wait Until Page Does Not Contain    Provider Order Successfully Updated!    30s
    END
    ${PO_data}    Create Dictionary    PO_dosage=${PO_dosage_arg}    PO_icdCode=${icdCode_selected_text}    PO_refering=${reffering_arg}    PO_referto=${physician_selected_text}
    Set Test Variable    ${PO_data}

Check Data In Scheduled Appointments Tab
    [Arguments]    ${locationPO_arg}    ${mrn_arg}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window
    Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${locationPO_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    RePatient.Select Patient From List    MRN_arg=${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_tab}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${APT_note_label}
    ${diagnosis_txt}    Get Text    ${APT_diagnosis_span}
    ${diagnosis_txt}      Evaluate    '${diagnosis_txt}'.split('Diagnosis: ')[1]
    ${diagnosis_list}    Evaluate    [x.strip() for x in '''${diagnosis_txt}'''.split(',')]
    Set Test Variable    ${diagnosis_list}
    Close Browser

Create New Appointment
    [Arguments]    
    ...    ${head_account_arg}=${head_multi_data}
    ...    ${id_send}=${None}
    ...    ${account_number_send}=${head_multi_acc1}
    ...    ${emrPatientID_send}=${response_json["emrPatientID"]}
    ...    ${patientMRN_send}=${response_json["mrn"]}
    ...    ${type_send}=${APT_dict.types_value}
    ...    ${start_date_send}=${start_date}
    ...    ${end_date_send}=${end_date}
    ...    ${med_send}=${emrMedication}
    ...    ${dose_send}=${APT_dict.num_rand}
    ...    ${emrAptID_send}=${APT_dict.emrPatientID_fake}
    ...    ${note_send}=${APT_dict.sentence_str}
    ...    ${location_num_send}=${APT_dict.locationNumber_value}
    ...    ${icd_code_send}=${icd_code_value}
    ...    ${referringProviderNPI_send}=${referringProviderNPI}
    ...    ${preferredInternalProviderNPI_send}=${preferredInternalProviderNPI}
    ...    ${reason_send}=Testing
    ...    ${expected_status}=200
    Appointment.Get Access Token    head_account=${head_account_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request_APT}    Create Dictionary
    ...    id=${id_send}
    ...    accountNumber=${account_number_send}
    ...    emrPatientID=${emrPatientID_send}
    ...    patientMRN=${patientMRN_send}
    ...    type=${type_send}
    ...    startTime=${start_date_send}
    ...    endTime=${end_date_send}
    ...    primaryMedication=${med_send}
    ...    doseQuantity=${dose_send}
    ...    emrAppointmentID=${emrAptID_send}
    ...    note=${note_send}
    ...    locationNumber=${location_num_send}
    ...    icdCodes=${icd_code_send}
    ...    ReferringProviderNPI=${referringProviderNPI_send}
    ...    ReferToProviderNPI=${preferredInternalProviderNPI_send}
    ...    scheduleConflictReason=${reason_send}
    Set Test Variable    ${body_request_APT}
    ${body_request_APT}    Evaluate    {k: v for k, v in $body_request_APT.items() if v not in ["missing"]}
    ${APT_response}    POST On Session    mysession    ${appointment_path}    json=${body_request_APT}    headers=${headers}    expected_status=${expected_status}
    ${APT_response_json}    Set Variable    ${APT_response.json()}
    Set Test Variable    ${APT_response_json}

Sending Request To Create New Appointment
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    I10    E11.9    A01.02
    Get StartDate And EndDate
    Set Test Variable    ${icd_code_value}
    Appointment.Create New Appointment
    ...    head_account_arg=${head_account_arg}
    ...    account_number_send=${account_num_arg}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200