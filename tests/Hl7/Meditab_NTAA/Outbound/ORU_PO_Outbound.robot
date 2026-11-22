*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    JSONLibrary
Library    ../../../../libraries/DataHL7.py

Resource    ../../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../../resources/Hl7Objects/Keywords/VerifyFileOnSFTP.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromConfigs.resource  
Resource    ../../../../resources/Hl7Objects/Keywords/HL7ProviderOrders.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Patient.resource 

Suite Setup    SetUp Test Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_ORU_PO_Outbound

*** Variables ***
${QUERY}=    SELECT TOP 2 HL7_Outbound_Staging.HL7_Outbound_StagingID AS HL7OutboundStagingID,
...    HL7_Outbound_Staging.JsonData AS JSONData
...    FROM HL7_Outbound_Staging Join Account On HL7_Outbound_Staging.AccountID = Account.AccountID
...    WHERE Filetype = 410 AND HL7_Outbound_Staging.Status = 10 AND Account.EMRMapping = 170 AND HL7_Outbound_Staging.LastAction <> 'D' AND Account.LastAction <> 'D'

${config_file}    configs\\dev.json
# ${MRN}    1234

*** Test Cases ***
Verify That The System Will Insert JSON Data Into The HL7_outbound_Staging Table After Publishing The PO Success
    [Documentation]    This test case will verify that the system will insert JSON data into the HL7_outbound_Staging table after publishing the PO success
    HL7_ProviderOrders.Go To Provider Orders Page
    HL7_ProviderOrders.Create Provider Order    ${LOCATION}    ${MRN}    ${Drug_arg}    ${DX_arg}    ${referring}    ${Patient_Weight}    ${DosageAssigned}    ${DosageUnit}

*** Keywords ***
SetUp Test Suite
    [Documentation]    Login to Fusebox, load config, create JSON Data and gather all required data 
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    GetValueFromConfigs.Initialize Global Config    ${config_file}
    DataHL7.Generate Hl7 Data    Outbound   ORU_PO_Outbound
    ${MRN}=    HL7_Patient.Check MRN Exists In Patients Page    ${LOCATION}    1234
    IF    ${MRN} == None
        ${patient_data}=    DataHL7.Generate Hl7 Data    Outbound    ADT_Outbound
        ${MRN}=    HL7_Patient.Create A Patient    ${LOCATION}    ${MRN}    ${patient_data["first_name"]}    ${patient_data["last_name"]}    
        ...    ${patient_data["dob"]}    ${patient_data["home_phone"]}    ${patient_data["cell_phone"]}    ${patient_data["email"]}    ${patient_data["address_line1"]}    
        ...    ${patient_data["city"]}    ${patient_data["postal_code"]}
    END
    Set Suite Variable    ${MRN}
    
    

    