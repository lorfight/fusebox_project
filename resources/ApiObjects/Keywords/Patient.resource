*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    FakerLibrary
Library    ../../PageObjects/TestData/Fakedata/FakeData.py
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource   ../../../resources/PageObjects/Keywords/RePatient.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Variables    ../../PageObjects/TestData/Testdata.py
*** Variables ***
${location}    //select[@id="CustomerAccountId"]
${mrn_search_value}    //input[@id="SearchValues"]
${find_btn}    //button[@id="FindButton"]
${merge_remove_patient}    //*[@id='RemovingPatient']//following::strong
${merge_keep_patient}    //*[@id='KeepingPatient']//following::strong

${SCHEMA_STRING}    
    ...    {
    ...        "type": "object",
    ...        "properties": {
    ...            "id": { "type": "number" },
    ...            "accountNumber": { "type": "number" },
    ...            "firstName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "middleName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "lastName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "dob": { "type": "string", "format": "date-time" },
    ...            "emrPatientID": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "mrn": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "gender": { "type": "string" },
    ...            "ssn": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "race": { "type": "string" },
    ...            "ethnicity": { "type": "string" },
    ...            "maritalStatus": { "type": "string" },
    ...            "spouseFirstName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "spouseMiddleName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "spouseLastName": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "referringProviderID": { "type": ["number", "string"] },
    ...            "preferredInternalProviderID": { "type": ["number", "string"] },
    ...            "height": { "type": "number" },
    ...            "weight": { "type": "number" },
    ...            "weightUnit": { "type": "string" },
    ...            "phone": { "type": "string", "maxLength": 15 },
    ...            "email": { "type": "string", "maxLength": 255 },
    ...            "notes": { "type": "string", "maxLength": 255 },
    ...            "occupation": { "type": "string", "maxLength": 255 },
    ...            "employerName": { "type": "string", "maxLength": 255 },
    ...            "workPhone": { "type": ["string", "null"], "minLength": 50, "maxLength": 50 },
    ...            "emergencyContactName": { "type": "string", "maxLength": 255 },
    ...            "emergencyContactPhone": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...            "emergencyContactRelationship": { "type": "string", "maxLength": 255 },
    ...            "active": { "type": "boolean" },
    ...            "primaryAddress": {
    ...                "type": ["object", "null"],
    ...                "properties": {
    ...                    "addressLine1": { "type": "string", "maxLength": 100 },
    ...                    "addressLine2": { "type": "string", "maxLength": 100 },
    ...                    "city": { "type": "string", "minLength": 50, "maxLength": 50 },
    ...                    "stateProvince": { "type": "string", "maxLength": 2 },
    ...                    "postalCode": { "type": "string", "maxLength": 15 },
    ...                    "countryRegion": { "type": "string", "minLength": 50, "maxLength": 50 }
    ...                }
    ...            }
    # ...            "workAddress": {
    # ...                "type": ["object", "null"],
    # ...                "properties": {
    # ...                    "addressLine1": { "type": "string", "maxLength": 100 },
    # ...                    "addressLine2": { "type": "string", "maxLength": 100 },
    # ...                    "city": { "type": "string", "minLength": 50, "maxLength": 50 },
    # ...                    "stateProvince": { "type": "string", "maxLength": 2 },
    # ...                    "postalCode": { "type": "string", "maxLength": 15 },
    # ...                    "countryRegion": { "type": "string", "minLength": 50, "maxLength": 50 }
    # ...                }
    # ...            }
    ...        }
    ...    }

@{expected_errors}  
...    The field MRN must be a string or array type with a maximum length of '50'.  
...    The field SSN must be a string or array type with a maximum length of '50'.  
...    The field Notes must be a string or array type with a maximum length of '255'.  
...    The field Phone must be a string or array type with a maximum length of '15'.  
...    The field LastName must be a string or array type with a maximum length of '50'.  
...    The field FirstName must be a string or array type with a maximum length of '50'.  
...    The field WorkPhone must be a string or array type with a maximum length of '50'.  
...    The field MiddleName must be a string or array type with a maximum length of '50'.  
...    The field Occupation must be a string or array type with a maximum length of '255'.  
...    The field EmployerName must be a string or array type with a maximum length of '255'.  
...    The field EMRPatientID must be a string or array type with a maximum length of '50'.  
...    The field SpouseLastName must be a string or array type with a maximum length of '50'.  
...    The field SpouseFirstName must be a string or array type with a maximum length of '50'.  
...    The field SpouseMiddleName must be a string or array type with a maximum length of '50'.  
...    The field EmergencyContactName must be a string or array type with a maximum length of '255'.  
...    The field EmergencyContactPhone must be a string or array type with a maximum length of '50'.  
...    The field EmergencyContactRelationship must be a string or array type with a maximum length of '255'.  
...    The field City must be a string or array type with a maximum length of '50'.  
...    The field PostalCode must be a string or array type with a maximum length of '15'.  
...    The field AddressLine1 must be a string or array type with a maximum length of '100'.  
...    The field AddressLine2 must be a string or array type with a maximum length of '100'.  
...    The field CountryRegion must be a string or array type with a maximum length of '50'.  
...    The field StateProvince must be a string or array type with a maximum length of '2'.  
# ...    The field City must be a string or array type with a maximum length of '50'.  
# ...    The field PostalCode must be a string or array type with a maximum length of '15'.  
# ...    The field AddressLine1 must be a string or array type with a maximum length of '100'.  
# ...    The field AddressLine2 must be a string or array type with a maximum length of '100'.  
# ...    The field CountryRegion must be a string or array type with a maximum length of '50'.  
# ...    The field StateProvince must be a string or array type with a maximum length of '2'.  

@{list_errors_empty_field}
    ...    The MRN field is required.
    ...    The LastName field is required.
    ...    The FirstName field is required.

*** Keywords ***
# Send POST Request
#     Get Access Token    head_account=${head_1_data}
#     Create Session    mysession    ${base_url}
#     ${headers}    Create Dictionary
#     ...    Authorization=Bearer ${access_token}
#     ...    Content-Type=application/json
#     Sending Body Request With Required Fields
#     ...    account_number_arg=${accountNumber}
#     ...    first_name_arg=${Fake_dict.first_name_fake}
#     ...    last_name_arg=${Fake_dict.last_name_fake}
#     ...    dob_arg=${Fake_dict.DOB_fake}
#     ...    mrn_arg=${Fake_dict.MRN_fake}
#     ...    id_arg=${EMPTY}
#     ${response}    Post Request    mysession    ${patient_path}    json=${body_request}    headers=${headers}
#     Should Be Equal As Numbers    ${response.status_code}    200
#     Set Test Variable    ${response.json()}

# Send POST Request All Fields
#     Get Access Token    head_account=${head_1_data}
#     Create Session    mysession    ${base_url}
#     ${headers}    Create Dictionary
#     ...    Authorization=Bearer ${access_token}
#     ...    Content-Type=application/json
#     Sending Body Request With All Fields
#     ...    id_arg=${None}
#     ...    account_number_arg=${accountNumber}
#     ...    first_name_arg=${Fake_dict.first_name_fake}
#     ...    middle_name_arg=${Fake_dict.first_name_fake}
#     ...    last_name_arg=${Fake_dict.last_name_fake}
#     ...    dob_arg=${Fake_dict.DOB_fake}
#     ...    emr_patient_id_arg=${Fake_dict.MRN_fake}
#     ...    mrn_arg=${Fake_dict.MRN_fake}
#     ...    gender_arg=${Fake_dict.gender_value}
#     ...    ssn_arg=${Fake_dict.SSN_fake}
#     ...    race_arg="${Fake_dict.race_value}"
#     ...    ethnicity_arg=${Fake_dict.ethnicitie_value}
#     ...    marital_status_arg=${Fake_dict.marital_status_value}
#     ...    spouse_first_name_arg=${Fake_dict.first_name_fake}
#     ...    spouse_middle_name_arg=${Fake_dict.first_name_fake}
#     ...    spouse_last_name_arg=${Fake_dict.last_name_fake}
#     ...    referringProviderNPI_arg=${referringProviderNPI}
#     ...    preferredInternalProviderNPI_arg=${preferredInternalProviderNPI}
#     ...    height_arg=${Fake_dict.height_fake}
#     ...    weight_arg=${Fake_dict.weight_fake}
#     ...    weight_unit_arg=${Fake_dict.weight_units}
#     ...    phone_arg=${Fake_dict.phone_fake}
#     ...    email_arg=${Fake_dict.email_fake}
#     ...    notes_arg=${Fake_dict.sentence_str}
#     ...    occupation_arg=${Fake_dict.job_fake}
#     ...    employer_name_arg=${Fake_dict.full_name_fake}
#     ...    work_phone_arg=${Fake_dict.phone_fake}
#     ...    emergency_contact_name_arg=${Fake_dict.full_name_fake}
#     ...    emergency_contact_phone_arg=${Fake_dict.phone_fake}
#     ...    emergency_contact_relationship_arg=${Fake_dict.relationship_fake}
#     #primary_address
#     ...    primary_address_line1_arg=${Fake_dict.address_fake}
#     ...    primary_address_line2_arg=${Fake_dict.address_fake}
#     ...    primary_city_arg=${Fake_dict.country_fake}
#     ...    primary_state_province_arg=${Fake_dict.state_province_value}
#     ...    primary_postal_code_arg=${Fake_dict.zip_fake}
#     ...    primary_country_region_arg=${Fake_dict.country_fake}
#     #work_address
#     ...    work_address_line1_arg=${Fake_dict.address_fake}
#     ...    work_address_line2_arg=${Fake_dict.address_fake}
#     ...    work_city_arg=${Fake_dict.country_fake}
#     ...    work_state_province_arg=${Fake_dict.state_province_value}
#     ...    work_postal_code_arg=${Fake_dict.zip_fake}
#     ...    work_country_region_arg=${Fake_dict.country_fake}
#     ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}
#     Should Be Equal As Numbers    ${response.status_code}    200
#     # Set Test Variable    ${response.json()}

Validate JSON Fields Max Length
    [Arguments]    ${response_arg}
    ${parsed_schema}    Convert String To JSON    ${SCHEMA_STRING}
    ${parsed_json}    Convert String To JSON    ${response_arg}
    Validate Json By Schema    ${parsed_json}    ${parsed_schema}

Compare Request And Response With Required Fields
    [Arguments]    ${response_json}
    Should Be Equal    ${response_json["accountNumber"]}    ${body_request["accountNumber"]}
    Should Be Equal    ${response_json["firstName"]}    ${body_request["firstName"]}
    Should Be Equal    ${response_json["lastName"]}    ${body_request["lastName"]}
    Should Be Equal    ${response_json["mrn"]}    ${body_request["mrn"]}
    ${dob_formmated}    Convert Date    ${body_request["dob"]}    date_format=%m/%d/%Y    result_format=%Y-%m-%dT00:00:00
    Should Be Equal    ${response_json["dob"]}    ${dob_formmated}
    Should Be Equal    ${response_json["gender"]}    ${body_request["gender"]}
    Should Be Equal    ${response_json["emrPatientID"]}    ${body_request["emrPatientID"]}
Compare Request And Response With All Fields
    [Arguments]    ${response_json}
    IF    ${body_request["id"]} != ${None} and ${body_request["emrPatientID"] != "" and ${body_request["accountNumber"]} != ${None} } 
        Should Be Equal    ${response_json["accountNumber"]}    ${body_request["accountNumber"]}    
    END
    Should Be Equal    ${response_json["firstName"]}    ${body_request["firstName"]}
    Should Be Equal    ${response_json["middleName"]}    ${body_request["middleName"]}
    Should Be Equal    ${response_json["lastName"]}    ${body_request["lastName"]}
    Should Be Equal    ${response_json["emrPatientID"]}    ${body_request["emrPatientID"]}
    ${dob_formmated}    Convert Date    ${body_request["dob"]}    date_format=%m/%d/%Y    result_format=%Y-%m-%dT00:00:00
    Should Be Equal    ${response_json["dob"]}    ${dob_formmated}
    Should Be Equal    ${response_json["mrn"]}    ${body_request["mrn"]}
    Should Be Equal    ${response_json["gender"]}    ${body_request["gender"]}
    Should Be Equal    ${response_json["ssn"]}    ${body_request["ssn"]}
    IF    "${body_request["race"]}" == "${EMPTY}" and "${body_request["ethnicity"]}" == "${EMPTY}" and "${body_request["maritalStatus"]}" == "${EMPTY}" and ${body_request["referringProviderNPI"]} == ${None} and ${body_request["preferredInternalProviderNPI"]} == ${None} and "${body_request["email"]}" == "${None}"and "${body_request["height"]}" == "${EMPTY}"and "${body_request["weight"]}" == "${EMPTY}"and "${body_request["weightUnit"]}" == "${EMPTY}"
        Should Be Equal    ${response_json["race"]}    ${None}
        Should Be Equal    ${response_json["ethnicity"]}    ${None}
        Should Be Equal    ${response_json["maritalStatus"]}    ${None}
        Should Be Equal    ${response_json["referringProviderNPI"]}    ${None}
        Should Be Equal    ${response_json["preferredInternalProviderNPI"]}    ${0}
        Should Be Equal    ${response_json["email"]}    ${None}
        Should Be Equal    ${response_json["height"]}    ${None}
        Should Be Equal    ${response_json["weight"]}    ${None}
        Should Be Equal    ${response_json["weightUnit"]}    ${None}
    ELSE
        Should Be Equal    ${response_json["race"]}    ${body_request["race"]}
        Should Be Equal    ${response_json["ethnicity"]}    ${body_request["ethnicity"]}
        Should Be Equal    ${response_json["maritalStatus"]}    ${body_request["maritalStatus"]}
        Should Be Equal    ${response_json["email"]}    ${body_request["email"]}
        Should Be Equal As Integers    ${response_json["referringProviderNPI"]}    ${body_request["referringProviderNPI"]}
        Should Be Equal As Integers    ${response_json["preferredInternalProviderNPI"]}    ${body_request["preferredInternalProviderNPI"]}
        Should Be Equal As Numbers    ${response_json["height"]}    ${body_request["height"]}
        Should Be Equal As Numbers    ${response_json["weight"]}    ${body_request["weight"]}
        Should Be Equal    ${response_json["weightUnit"]}    ${body_request["weightUnit"]}
    END
    Should Be Equal    ${response_json["spouseFirstName"]}    ${body_request["spouseFirstName"]}
    Should Be Equal    ${response_json["spouseMiddleName"]}    ${body_request["spouseMiddleName"]}
    Should Be Equal    ${response_json["spouseLastName"]}    ${body_request["spouseLastName"]}
    Should Be Equal    ${response_json["phone"]}    ${body_request["phone"]}
    Should Be Equal    ${response_json["notes"]}    ${body_request["notes"]}
    Should Be Equal    ${response_json["occupation"]}    ${body_request["occupation"]}
    Should Be Equal    ${response_json["employerName"]}    ${body_request["employerName"]}
    Should Be Equal    ${response_json["workPhone"]}    ${body_request["workPhone"]}
    Should Be Equal    ${response_json["emergencyContactName"]}    ${body_request["emergencyContactName"]}
    Should Be Equal    ${response_json["emergencyContactPhone"]}    ${body_request["emergencyContactPhone"]}
    Should Be Equal    ${response_json["emergencyContactRelationship"]}    ${body_request["emergencyContactRelationship"]}
    Should Be Equal As Strings    ${response_json["active"]}    ${body_request["active"]}
    Should Be Equal    ${response_json["primaryAddress"]["addressLine1"]}    ${body_request["primaryAddress"]["addressLine1"]}
    Should Be Equal    ${response_json["primaryAddress"]["addressLine2"]}    ${body_request["primaryAddress"]["addressLine2"]}
    Should Be Equal    ${response_json["primaryAddress"]["city"]}    ${body_request["primaryAddress"]["city"]}
    Should Be Equal    ${response_json["primaryAddress"]["stateProvince"]}    ${body_request["primaryAddress"]["stateProvince"]}
    Should Be Equal    ${response_json["primaryAddress"]["postalCode"]}    ${body_request["primaryAddress"]["postalCode"]}
    Should Be Equal    ${response_json["primaryAddress"]["countryRegion"]}    ${body_request["primaryAddress"]["countryRegion"]}
    # Should Be Equal    ${response_json["workAddress"]["addressLine1"]}    ${body_request["workAddress"]["addressLine1"]}
    # Should Be Equal    ${response_json["workAddress"]["addressLine2"]}    ${body_request["workAddress"]["addressLine2"]}
    # Should Be Equal    ${response_json["workAddress"]["city"]}    ${body_request["workAddress"]["city"]}
    # Should Be Equal    ${response_json["workAddress"]["stateProvince"]}    ${body_request["workAddress"]["stateProvince"]}
    # Should Be Equal    ${response_json["workAddress"]["postalCode"]}    ${body_request["workAddress"]["postalCode"]}
    # Should Be Equal    ${response_json["workAddress"]["countryRegion"]}    ${body_request["workAddress"]["countryRegion"]}
    Should Match Regexp    ${response_json["id"]}${EMPTY}    \\d+

Get Access Token
    [Arguments]    ${head_account}
    Create Session    auth_session    ${base_url}
    ${headers}    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${response}    POST On Session    auth_session    ${token_url}    data=${head_account}    headers=${headers}    expected_status=200
    ${access_token}    Set Variable    ${response.json()["access_token"]}
    Set Suite Variable    ${access_token}

Get URL API Patient
    ${config_path}    Testdata.Get Api Configs     ${env}
    ${json_data}    Set Variable    ${config_path}
    ${base_url}    Get From Dictionary    ${json_data}    baseUrl
    ${patient_path}    Get From Dictionary    ${json_data}    patient
    ${token_url}    Get From Dictionary    ${json_data}    tokenUrl
    Set Suite Variable    ${base_url}
    Set Suite Variable    ${patient_path}
    Set Suite Variable    ${token_url}

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

Sending Body Request With Required Fields
    [Arguments]    
    ...    ${head_acc_arg}=${head_multi_data}
    ...    ${account_number_arg}=${head_multi_acc1}
    ...    ${first_name_arg}=${Fake_dict.first_name_fake}
    ...    ${last_name_arg}=${Fake_dict.last_name_fake}
    ...    ${dob_arg}=${Fake_dict.DOB_fake}
    ...    ${mrn_arg}=${Fake_dict.MRN_fake}
    ...    ${gender_arg}=${Fake_dict.gender_value}
    ...    ${id_arg}=${None}
    ...    ${emr_patient_id_arg}=${Fake_dict.emrPatientID}
    ...    ${expected_status}=${expected_status}
    ...    ${active}=true
    Get Access Token    head_account=${head_acc_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request}    Create Dictionary    
    ...    accountNumber=${account_number_arg}
    ...    firstName=${first_name_arg}
    ...    lastName=${last_name_arg}
    ...    dob=${dob_arg}
    ...    mrn=${mrn_arg}
    ...    gender=${gender_arg}
    ...    id=${id_arg}
    ...    emrPatientID=${emr_patient_id_arg}
    ...    active=${active}
    ...    expected_status=${expected_status}
    Set Test Variable    ${body_request}
    ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}    expected_status=${expected_status}
    ${response_json}    Set Variable    ${response.json()}
    Set Test Variable    ${response_json}
Sending Body Request With All Fields
    [Arguments]    
    ...    ${head_acc_arg}=${head_multi_data} 
    ...    ${id_arg}=${None}
    ...    ${account_number_arg}=${head_multi_acc1}  
    ...    ${first_name_arg}=${Fake_dict.first_name_fake}
    ...    ${middle_name_arg}=${Fake_dict.first_name_fake}
    ...    ${last_name_arg}=${Fake_dict.last_name_fake}  
    ...    ${dob_arg}=${Fake_dict.DOB_fake}
    ...    ${emr_patient_id_arg}=${Fake_dict.emrPatientID}
    ...    ${mrn_arg}=${Fake_dict.MRN_fake}
    ...    ${gender_arg}=${Fake_dict.gender_value}
    ...    ${ssn_arg}=${Fake_dict.SSN_fake}
    ...    ${race_arg}=${Fake_dict.race_value}
    ...    ${ethnicity_arg}=${Fake_dict.ethnicitie_value}
    ...    ${marital_status_arg}=${Fake_dict.marital_status_value}
    ...    ${spouse_first_name_arg}=${Fake_dict.first_name_fake}
    ...    ${spouse_middle_name_arg}=${Fake_dict.first_name_fake}
    ...    ${spouse_last_name_arg}=${Fake_dict.last_name_fake}
    ...    ${referringProviderNPI_arg}=${referringProviderNPI}
    ...    ${preferredInternalProviderNPI_arg}=${preferredInternalProviderNPI}
    ...    ${height_arg}=${Fake_dict.height_fake}
    ...    ${weight_arg}=${Fake_dict.weight_fake}
    ...    ${weight_unit_arg}=${Fake_dict.weight_units}
    ...    ${phone_arg}=${Fake_dict.phone_fake}
    ...    ${email_arg}=${Fake_dict.email_fake}
    ...    ${notes_arg}=${Fake_dict.sentence_str}
    ...    ${occupation_arg}=${Fake_dict.job_fake}
    ...    ${employer_name_arg}=${Fake_dict.full_name_fake}
    ...    ${work_phone_arg}=${Fake_dict.phone_fake}
    ...    ${emergency_contact_name_arg}=${Fake_dict.full_name_fake}
    ...    ${emergency_contact_phone_arg}=${Fake_dict.phone_fake}
    ...    ${emergency_contact_relationship_arg}=${Fake_dict.relationship_fake}
    ...    ${primary_address_line1_arg}=${Fake_dict.address_fake}
    ...    ${primary_address_line2_arg}=${Fake_dict.address_fake}
    ...    ${primary_city_arg}=${Fake_dict.country_fake}
    ...    ${primary_state_province_arg}=${Fake_dict.state_province_value}
    ...    ${primary_postal_code_arg}=${Fake_dict.zip_fake}
    ...    ${primary_country_region_arg}=${Fake_dict.country_fake}
    ...    ${expected_status}=${expected_status}
    ...    ${active}=True
    Get Access Token    head_account=${head_acc_arg}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request}    Create Dictionary    
    ...    id=${id_arg}
    ...    head_acc=${head_acc_arg}
    ...    accountNumber=${account_number_arg}
    ...    firstName=${first_name_arg}
    ...    middleName=${middle_name_arg}
    ...    lastName=${last_name_arg}
    ...    dob=${dob_arg}
    ...    emrPatientID=${emr_patient_id_arg}
    ...    mrn=${mrn_arg}
    ...    gender=${gender_arg}
    ...    ssn=${ssn_arg}
    ...    race=${race_arg}
    ...    ethnicity=${ethnicity_arg}
    ...    maritalStatus=${marital_status_arg}
    ...    spouseFirstName=${spouse_first_name_arg}
    ...    spouseMiddleName=${spouse_middle_name_arg}
    ...    spouseLastName=${spouse_last_name_arg}
    ...    referringProviderNPI=${referringProviderNPI_arg}
    ...    preferredInternalProviderNPI=${preferredInternalProviderNPI_arg}
    ...    height=${height_arg}
    ...    weight=${weight_arg}
    ...    weightUnit=${weight_unit_arg}
    ...    phone=${phone_arg}
    ...    email=${email_arg}
    ...    notes=${notes_arg}
    ...    occupation=${occupation_arg}
    ...    employerName=${employer_name_arg}
    ...    workPhone=${work_phone_arg}
    ...    emergencyContactName=${emergency_contact_name_arg}
    ...    emergencyContactPhone=${emergency_contact_phone_arg}
    ...    emergencyContactRelationship=${emergency_contact_relationship_arg}
    ...    active=${active}

    ${primary_address}    Create Dictionary
    ...    addressLine1=${primary_address_line1_arg}
    ...    addressLine2=${primary_address_line2_arg}
    ...    city=${primary_city_arg}
    ...    stateProvince=${primary_state_province_arg}
    ...    postalCode=${primary_postal_code_arg}
    ...    countryRegion=${primary_country_region_arg}
    ...    expected_status=${expected_status}

    Set To Dictionary    ${body_request}
    ...    primaryAddress=${primary_address}
    # IF    '${id_arg}' != ''
    #     Set To Dictionary    ${body_request}    id=${id_arg}
    # END
    Set Test Variable    ${body_request}
    ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}    expected_status=${expected_status}
    ${response_json}    Set Variable    ${response.json()}
    Set Test Variable    ${response_json}

# Generate Fake Data
#     ${data}    Generate Data
#     RETURN    ${data}
# Get Random Data
#     [Arguments]    ${fake_data}
#     ${data}    Generate Fake Data
#     ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
#     RETURN    ${fake_data}

Get Random Data
    [Arguments]    ${fake_data}
    # ${data}    Generate Data
    ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
    RETURN    ${fake_data}

Create Fake Data List
    ${data}    Generate Data
    Set Test Variable    ${data}
    ${full_name_fake}    Get Random Data    fake_data=full_name
    ${first_name_fake}    Get Random Data    fake_data=first_name
    ${middle_name_fake}    Get Random Data    fake_data=first_name
    ${last_name_fake}    Get Random Data    fake_data=last_name
    ${email_fake}    Get Random Data    fake_data=email
    ${phone_fake}    Get Random Data    fake_data=phone
    ${address_fake}    Get Random Data    fake_data=address
    ${sentence_str}    Get Random Data    fake_data=sentence
    ${MRN_fake}    Get Random Data    fake_data=MRN
    ${emrPatientID}    Get Random Data    fake_data=emrPatientID
    ${SSN_fake}    Get Random Data    fake_data=SSN
    ${DOB_fake}    Get Random Data    fake_data=DOB
    ${height_fake}    Get Random Data    fake_data=Height
    ${weight_fake}    Get Random Data    fake_data=Weight
    ${zip_fake}    Get Random Data    fake_data=zip_code
    ${country_fake}    Get Random Data    fake_data=country
    ${job_fake}    Get Random Data    fake_data=job
    ${relationship_fake}    Get Random Data    fake_data=relationship
    ${gender_value}    Get Random Data    fake_data=gender
    ${race_value}    Get Random Data    fake_data=race
    ${ethnicitie_value}    Get Random Data    fake_data=ethnicitie
    ${marital_status_value}    Get Random Data    fake_data=marital_status
    ${state_province_value}    Get Random Data    fake_data=state_province
    ${weight_units}    Get Random Data    fake_data=weight_units
    ${num_rand}    Get Random Data    fake_data=num_rand
    ${emrPatientID}    Get Random Data    fake_data=emrPatientID

    &{Fake_dict}    Create Dictionary    
    ...    full_name_fake=${full_name_fake}    first_name_fake=${first_name_fake}    middle_name_fake=${middle_name_fake}    
    ...    last_name_fake=${last_name_fake}    MRN_fake=${MRN_fake}    SSN_fake=${SSN_fake}    DOB_fake=${DOB_fake}    
    ...    height_fake=${height_fake}    zip_fake=${zip_fake}    phone_fake=${phone_fake}    sentence_str=${sentence_str}
    ...    country_fake=${country_fake}    email_fake=${email_fake}    address_fake=${address_fake}    job_fake=${job_fake}    
    ...    relationship_fake=${relationship_fake}    race_value=${race_value}    ethnicitie_value=${ethnicitie_value}    
    ...    marital_status_value=${marital_status_value}    state_province_value=${state_province_value}
    ...    weight_fake=${weight_fake}    gender_value=${gender_value}    weight_units=${weight_units}
    ...    emrPatientID=${emrPatientID}    num_rand=${num_rand}    emrPatientID=${emrPatientID}
    Set Suite Variable    ${Fake_dict}
    RETURN    ${Fake_dict}

Validate Response Status
    [Arguments]    ${response_status}    ${expected_status}
    Should Be Equal As Numbers    ${response_status}    ${expected_status}
Validate Error Message Contains
    [Arguments]    ${actual_message}    ${expected_error}
    ${actual_message_string}    Convert To String    ${actual_message}
    Should Contain    ${actual_message_string}    ${expected_error}    msg=Expected '${expected_error}' to be in '${actual_message}'

Verify Response Send Request To Save Patient
    [Arguments]    ${request_body}    ${response}    ${expected_code}    ${error}       
    # Validate Response Status    ${response.status_code}    ${expected_code}
    IF    ${expected_code} == 200
        Compare Request And Response With All Fields    ${response}
    ELSE
        Validate Error Message Contains    ${response}    ${error}
    END

Create New Patient
    [Arguments]    ${head_account_arg}    ${account_num_arg}
    Create Fake Patient Data With Required Fields
    Patient.Get URL API Patient
    Patient.Sending Body Request With Required Fields
    ...    head_acc_arg=${head_account_arg}
    ...    account_number_arg=${account_num_arg}
    ...    expected_status=200
    Add Patient To List    ${response_json["accountNumber"]}    ${response_json["mrn"]}

Create Fake Patient Data With Required Fields
    ${data}    Generate Data
    Set Test Variable    ${data}
    ${first_name_fake}    Get Random Data    fake_data=first_name
    ${last_name_fake}    Get Random Data    fake_data=last_name
    ${MRN_fake}    Get Random Data    fake_data=MRN
    ${emrPatientID}    Get Random Data    fake_data=emrPatientID
    ${DOB_fake}    Get Random Data    fake_data=DOB
    ${gender_value}    Get Random Data    fake_data=gender
    ${num_rand}    Get Random Data    fake_data=num_rand

    &{Fake_dict}    Create Dictionary    
    ...    first_name_fake=${first_name_fake} 
    ...    last_name_fake=${last_name_fake}    MRN_fake=${MRN_fake} 
    ...    gender_value=${gender_value}    DOB_fake=${DOB_fake}
    ...    emrPatientID=${emrPatientID}    num_rand=${num_rand}
    Set Suite Variable    ${Fake_dict}
    RETURN    ${Fake_dict}

Add Patient To List
    [Arguments]    ${account_num_arg}    ${mrn}
    &{patient}    Create Dictionary    accountNumber=${account_num_arg}    MRN=${MRN}
    Append To List    ${patient_list}    ${patient}

Delete Patient From Patient List
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window
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

Create Merge Patient
    [Arguments]    ${account_number_arg}    ${Merge_MRN_arg}
    Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${account_number_arg}
    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${Merge_MRN_arg}
    Click Button    ${Find_Patient_Btn}
    Set Suite Variable    ${MRN}    ${Merge_MRN_arg}
    ${Patient_MRN_Text}    Util.Replace Xpath    ${Patient_MRN_Text}
    ${Check_Merge_Patient}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Patient_MRN_Text}    10s
    Set Suite Variable    ${Check_Merge_Patient}
    IF    ${Check_Merge_Patient} == ${False}
        Create New Merge Patient    First_Name_arg=Merge    Last_Name_arg=Patient    DOB_arg=01/01/2000    MRN=${Merge_MRN_arg}
    END

Select Patient From List
    [Arguments]    ${MRN_arg}
    Set Suite Variable    ${Merge_MRN}    ${MRN_arg}
    ${Merge_Patient_Text}    Util.Replace Xpath    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[contains(text(),'${Merge_MRN}')]/preceding::td[2]//a
    Wait Until Element Is Visible    ${Merge_Patient_Text}    30s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${Merge_Patient_Text}

Delete Created Patient
    [Arguments]    ${account_number}    ${mrn_arg}
    Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${account_number}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${mrn_search_value}    ${mrn_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${find_btn}
    Select Patient From List    MRN_arg=${mrn_arg}
    Util.Scroll To Bottom
    Wait Until Element Is Visible    ${Delete_Patient_Link}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Delete_Patient_Link}
    ${Check_Can_Delete_Patient}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2s    1s    Page Should Contain    Can not delete patient because they have been assigned to an appointment
    IF    ${Check_Can_Delete_Patient} == ${True}
        Go To Patients Page
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${location}    ${account_number}
        Merge Patient    Keeping_MRN_arg=${merge_mrn}    Remove_MRN=${mrn_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Delete_Patient_Link}
        Handle Alert    ACCEPT
    END

Merge Patient
    [Arguments]    ${Keeping_MRN_arg}    ${Remove_MRN}
    Wait Until Element Is Visible    ${Patient_Tools_Btn}    60s
    Click Button    ${Patient_Tools_Btn}
    Wait Until Element Is Visible    ${Merge_Patient_Link}    60s
    Click Element    ${Merge_Patient_Link}
    Wait Until Element Is Visible    ${Merge_Patient_Popup}    60s
    Input Text    ${Removing_Input}    ${Remove_MRN}
    Wait Until Keyword Succeeds    30s    1s        Click Element    ${merge_remove_patient}
    Input Text    ${Keeping_Input}    ${Keeping_MRN_arg}
    Wait Until Keyword Succeeds    30s    1s        Click Element    ${merge_keep_patient}
    Click Button    ${Merge_Btn}
    Handle Alert    ACCEPT
    Wait Until Page Contains    Appointments Successfully Merged & Patient Deleted    60s
    # Wait Until Page Does Not Contain    Appointments Successfully Merged & Patient Deleted

Create New Merge Patient
    [Arguments]    ${First_Name_arg}    ${Last_Name_arg}    ${DOB_arg}    ${MRN}
    Click Element    ${New_Patient_Link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient
    Input Text    ${First_Name_Input}    ${First_Name_arg}
    Input Text    ${Last_Name_Input}    ${Last_Name_arg}
    Input Text    ${MRN_Input}    ${MRN}
    Input Text    ${DOB_Input}    ${DOB_arg}
    Select From List By Label    ${Gender_Select}    Male
    Util.Scroll To Bottom
    Wait Until Element Is Visible    ${Patients_Save_Btn}    30s
    Click Element   ${Patients_Save_Btn}

Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PatientsLink}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients