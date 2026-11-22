*** Settings ***
Library    SeleniumLibrary
Library    DatabaseLibrary
Library    Collections
Library    OperatingSystem
Library    JSONLibrary
Library    SSHLibrary
Library    ../../../../libraries/DataHL7.py

Variables    ../../../../resources/PageObjects/Locators/Patient.py

Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/SendMessageToSFTPServer.resource
Resource    ../../../../resources/PageObjects/Keywords/HL7_Patient.resource
Resource    ../../../../resources/PageObjects/Keywords/GetValueFromJSON.resource
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../../resources/PageObjects/Keywords/GetValueFromConfigs.resource

Suite Setup    SetUp Test Suite    ${LOCATION}    ${MRN}
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_ADT_Outbound

*** Variables ***
${QUERY}    SELECT TOP 1 HL7_Outbound_Staging.HL7_Outbound_StagingID AS HL7OutboundStagingID, HL7_Outbound_Staging.JsonData AS JSONData FROM HL7_Outbound_Staging Join Account On HL7_Outbound_Staging.AccountID = Account.AccountID WHERE (Filetype = 320 OR Filetype = 330) AND HL7_Outbound_Staging.Status = 10 AND Account.EMRMapping = 170 AND HL7_Outbound_Staging.LastAction <> 'D' AND Account.LastAction <> 'D'

${CONFIG_FILE}    configs/dev.json
${JSON_TEMPLATE}    D:\\WorkSpace\\Fusebox%20Automation%20Testing\\resources\\PageObjects\\TestData\\JSON_Template.json

*** Test Cases ***
Verify The System Will Record The JSON File To DB
    [Documentation]    This test case will verify the system will record the JSON file to the database
    [Tags]    Integration
    New Patient Information
    Check Patient Information Created
    Connect To Database    pymssql    ${DB_NAME}    ${DB_USER_NAME}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
    ${result}=    DatabaseLibrary.Query    ${QUERY}
    ${json_data}=    Set Variable    ${result}[0][1]
    Save JSON Data To File    ${json_data}    ${JSON_TEMPLATE}
    Disconnect From Database

Verify Patient Object With Patient Information Tab
    [Documentation]    This test case will compare patient object from JSON data with value on patient information screen
    [Tags]    Integration
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient
    ${patient_id}=    Get From Dictionary    ${patient_object}    PatientID
    ${mrn}=    Get From Dictionary    ${patient_object}    MRN
    ${first_name}=    Get From Dictionary    ${patient_object}    FirstName
    ${last_name}=    Get From Dictionary    ${patient_object}    LastName
    ${middle_name}=    Get From Dictionary    ${patient_object}    MiddleName
    ${dob}=    Get From Dictionary    ${patient_object}    DOB
    ${gender}=    Get From Dictionary    ${patient_object}    Gender
    ${home_phone}=    Get From Dictionary    ${patient_object}    HomePhone
    ${work_phone}=    Get From Dictionary    ${patient_object}    WorkPhone
    ${cell_phone}=    Get From Dictionary    ${patient_object}    CellPhone
    ${email}=    Get From Dictionary    ${patient_object}    Email
    ${marital_status}=    Get From Dictionary    ${patient_object}    MaritalStatus
    ${ssn}=    Get From Dictionary    ${patient_object}    SSN
    ${patient_address}=    Get From Dictionary    ${patient_object}    PatientAddress
    ${address_line1}=    Get From Dictionary    ${patient_address}    AddressLine1
    ${address_line2}=    Get From Dictionary    ${patient_address}    AddressLine2
    ${city}=    Get From Dictionary    ${patient_address}    City
    ${state}=    Get From Dictionary    ${patient_address}    StateProvince
    ${postal_code}=    Get From Dictionary    ${patient_address}    PostalCode
    ${country}=    Get From Dictionary    ${patient_address}    CountryRegion
    
    ${patient_info_ui}=    Get Value From Patient Information Tab

*** Keywords ***
SetUp Test Suite
    [Documentation]    Login to Fusebox, load config, create JSON Data and gather all required data
    [Arguments]    ${LOCATION}    ${MRN} 
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    Load Config    ${CONFIG_FILE}

    









