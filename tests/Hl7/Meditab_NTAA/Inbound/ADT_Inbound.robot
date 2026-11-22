*** Settings ***
Documentation    Happycase-ADT

Library    SeleniumLibrary
Library    SSHLibrary
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary
Library    JSONLibrary
Library    ../../../../resources/Hl7Objects/TestData/DataHL7.py   

Variables    ../../../../resources/PageObjects/Locators/Patient.py
    
Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../../resources/Hl7Objects/Keywords/VerifyFileOnSFTP.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromJSON.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Patient.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Accounts.resource
Resource    ../../../../resources/Hl7Objects/Keywords/CallAPIJenkins.resource
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromConfigs.resource
Resource    ../../../../resources/Hl7Objects/Keywords/CallAPIMirthConnectClient.resource

Suite Setup    SetUp Test Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_ADT_Inbound
        
*** Variables ***
${config_file}    configs\\dev.json
${worksheet_name}    ADT_Inbound
${message_type}    inbound
${channel_group}    adt_msg_inbound
${hl7_output_dir}    ${EXECDIR}\\resources\\Hl7Objects\\TestData\\
${remote_path}    /mirth_dev/Meditab_NTAA/AT_Test_Inbound/ADT_Inbound/   

*** Test Cases ***
Verify Message File Exists On SFTP Server
    [Documentation]    Generate ADT message, upload to sFTP server, and verify the file exists
    ${adt_msg}=    DataHL7.Generate Hl7 Msg    ${sheet_adt_inbound_key}    ${worksheet_name}    ${message_type}
    Set Suite Variable    ${adt_msg}
    ${adt_msg_file}=    Save Message To File    ${adt_msg}    ADT_inbound    ${hl7_output_dir}
    Upload File To sFTP Server    ${hl7_output_dir}    ${adt_msg_file}    ${remote_path}
    Verify File Exists On sFTP Server   ${adt_msg_file}    ${remote_path}

Verify Channels Status Process ADT Message On Mirth Connect
    [Documentation]    Verify the status of ADT message processing channels on Mirth Connect
    Deploy Channel On Mirth Connect    ${MIRTH_CLIENT_URL}    ${CHANNEL_1_ID}
    Deploy Channel On Mirth Connect    ${MIRTH_CLIENT_URL}    ${CHANNEL_2_ID}
    Sleep    10s
    ${status_channel_1}=    Verify Status In Channel Messages    ${MIRTH_CLIENT_URL}    ${CHANNEL_1_ID}
    ${status_channel_2}=    Verify Status In Channel Messages    ${MIRTH_CLIENT_URL}    ${CHANNEL_2_ID}
    Log    Channel 1 Status: ${status_channel_1}
    Should Contain Any    ${status_channel_1}    TRANSFORMED    SENT
    Log    Channel 2 Status: ${status_channel_2}
    Should Contain Any    ${status_channel_2}    TRANSFORMED    SENT

Verify Jenkins Successfully Triggered Build Now    
    [Documentation]    Trigger Jenkins build now for MIRTH Processor ADT project and check build status
    Create Or Use Jenkins Session    ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}
    ${init_id}=    Get Current Build Number    ${PROJECT_NAME_ADT}
    Trigger Jenkins Build    ${PROJECT_NAME_ADT}     
    Verify Jenkins Build Success    ${PROJECT_NAME_ADT}    ${init_id}    timeout=120    interval=10

Verify Value Patient Account Number Field From Message With MRN On Patient Information Tab
    [Documentation]    ADT_15    Get value from msg file created compare with value MRN on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    Set Suite Variable    ${parsed_message}
    ${patient_account_number}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    ${17}
    Set Suite Variable    ${MRN}    ${patient_account_number}
    HL7Patient.Check MRN Exists In Patients Page    ${LOCATION}    ${MRN}
    ${patient_data}=    HL7Patient.Get Value From Patient Information Tab    ${LOCATION}    ${MRN}
    Set Suite Variable    ${patient_data}
    ${mrn_ui}=    Get From Dictionary    ${patient_data}    MRN
    Should Be Equal    ${mrn_ui}    ${MRN}
    
Verify Value Patient LastName Field From Message With Last Name On Patient Information Tab
    [Documentation]    ADT_17    Get value from msg file created compare with value last name on patient information tab   
    ${patient_name}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    4
    ${patient_last_name}=    DataHL7.Get Hl7 Component Value    ${patient_name}    0
    ${last_name_ui}=    Get From Dictionary    ${patient_data}    LastName
    Should Be Equal    ${patient_last_name}    ${last_name_ui}

Verify Value Patient FirstName Field From Message With First Name On Patient Information Tab
    [Documentation]    ADT_18    Get value from msg file created compare with value first name on patient information tab 
    ${patient_name}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    4
    ${patient_first_name}=    DataHL7.Get Hl7 Component Value    ${patient_name}    1
    ${first_name_ui}=    Get From Dictionary    ${patient_data}    FirstName
    Should Be Equal    ${patient_first_name}    ${first_name_ui}

Verify Value Patient MiddleName From Json File With Middle Name On Patient Information Tab
    [Documentation]    ADT_19    Get value from msg file created compare with value middle name on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}    
    ${pid_5}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    4
    ${pid_5_3}=    DataHL7.Get Hl7 Component Value    ${pid_5}    2
    ${middle_name_ui}=    Get From Dictionary    ${patient_data}    MiddleName
    Should Be Equal As Strings    ${pid_5_3}    ${middle_name_ui}

Verify Value Patient DOB From Json File With DOB On Patient Information Tab
    [Documentation]    ADT_22    Get value from msg file created compare with value DOB on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${pid_7_1}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    6
    ${dob_ui}=    Get From Dictionary    ${patient_data}    DOB
    Should Be Equal As Strings    ${pid_7_1}    ${dob_ui}

Verify Value Patient Gender From Json File With Gender On Patient Information Tab
    [Documentation]    ADT_23    Get value from msg file created compare with value Gender on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${pid_8_1}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    7
    ${gender_ui}=    Get From Dictionary    ${patient_data}    Gender
    Should Be Equal As Strings    ${pid_8_1}    ${gender_ui}

Verify Value Patient AddressLine1 From Json File With Address Line 1 On Patient Information Tab
    [Documentation]    ADT_25    Get value from msg file created compare with value AddressLine1 on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${pid_11}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    10
    ${pid_11_1}=    DataHL7.Get Hl7 Component Value    ${pid_11}    0
    ${address_line1_ui}=    Get From Dictionary    ${patient_data}    PatientAddressLine1
    Should Be Equal As Strings    ${pid_11_1}    ${address_line1_ui}

Verify Value Patient AddressLine2 From Json File With Address Line 1 On Patient Information Tab
    [Documentation]    ADT_25    Get value from msg file created compare with value AddressLine2 on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${pid_11}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PID    10
    ${pid_11_2}=    DataHL7.Get Hl7 Component Value    ${pid_11}    1
    ${address_line1_ui}=    Get From Dictionary    ${patient_data}    PatientAddressLine2
    Should Be Equal As Strings    ${pid_11_2}    ${address_line1_ui}

Verify Value PracticeAnalyzerIdentifier From Json File With Practice Analyzer ID On Edit Account Page
    [Documentation]    ADT_50    Get value from msg file created compare with value Practice Analyzer ID on Edit Account page
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${pv1_3}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    PV1    2
    ${practice_analyzer_id_ui}=    Get From Dictionary    ${account_data}    PracticeAnalyzerID
    Should Be Equal As Strings    ${pv1_3}    ${practice_analyzer_id_ui}

Verify Value InsuranceName First Index From Json File With Primary Insurance Name On Patient Information Tab
    [Documentation]    ADT_103    Get value from msg file created compare with value Primary Insurance Name on patient information tab
    ${parsed_message}=    DataHL7.Parse Hl7 Message    ${adt_msg}
    ${in1_3}=    DataHL7.Get Hl7 Field Value    ${parsed_message}    IN1    3
    ${pid_11_1}=    DataHL7.Get Hl7 Component Value    ${pid_11}    0
    ${primary_insurance_name_ui}=    Get From Dictionary    ${patient_data}    PrimaryInsuranceName
    Should Be Equal As Strings    ${insurance_name}    ${primary_insurance_name_ui}

Verify Value InsuranceName Second Index From Json File With Secondary Insurance Name On Patient Information Tab
    [Documentation]    Get value from msg file created to compare with value Secondary Insurance Name on patient information tab
    ${insurance_name}=    Get Value From Json Array    ${json_data}    Insurances    1    Name
    ${secondary_insurance_name_ui}=    Get From Dictionary    ${patient_data}    SecondaryInsuranceName
    Should Be Equal As Strings    ${insurance_name}    ${secondary_insurance_name_ui}

Verify Value InsuranceName Third Index From Json File With Tertiary Insurance Name On Patient Information Tab
    [Documentation]    Get value from msg file created to compare with value Tertiary Insurance Name on patient information tab
    ${insurance_name}=    Get Value From Json Array    ${json_data}    Insurances    2    Name
    ${tertiary_insurance_name_ui}=    Get From Dictionary    ${patient_data}    TertiaryInsuranceName
    Should Be Equal As Strings    ${insurance_name}    ${tertiary_insurance_name_ui}

*** Keywords ***
SetUp Test Suite
    [Documentation]    Get value from config file and login to Fusebox to get value from UI 
    GetValueFromConfigs.Initialize Global Config    ${config_file}
    ${sheet_adt_inbound_key}=    GetValueFromConfigs.Get Value By Key Path    ${config_file}    hl7.meditab_ntaa.gg_sheet.sheet_adt_inbound_key
    Set Suite Variable    ${sheet_adt_inbound_key}
    
    # Get channels id from config file
    ${channel_id_1}=    GetValueFromConfigs.Get Value By Key Path    ${config_file}    hl7.meditab_ntaa.mirth_connect.adt_msg_inbound.channel_id_1
    ${channel_id_2}=    GetValueFromConfigs.Get Value By Key Path    ${config_file}    hl7.meditab_ntaa.mirth_connect.adt_msg_inbound.channel_id_2    
    Set Suite Variable    ${CHANNEL_1_ID}    ${channel_id_1}
    Set Suite Variable    ${CHANNEL_2_ID}    ${channel_id_2}
        
    # Get value from UI
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    # ${patient_data}=    HL7Patient.Get Value From Patient Information Tab    ${LOCATION}    ${MRN}    
    # ${account_data}=    HL7Accounts.Get Value From Edit Account Page
    # Set Suite Variable    ${patient_data}
    # Set Suite Variable    ${account_data}