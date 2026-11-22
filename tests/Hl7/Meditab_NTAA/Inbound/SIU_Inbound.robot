*** Settings ***
Documentation    Happycase-SIU
Library    SeleniumLibrary
Library    SSHLibrary
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary
Library    JSONLibrary

Variables    ../../../../resources/PageObjects/Locators/Patient.py

Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../../resources/Hl7Objects/Keywords/VerifyFileOnSFTP.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromJSON.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Patient.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Appointment.resource
Resource    ../../../../resources/Hl7Objects/Keywords/CallAPIJenkins.resource
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromConfigs.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Accounts.resource
Resource    ../../../../resources/Hl7Objects/Keywords/CallAPIMirthConnectClient.resource

Suite Setup    Setup Test Suite    ${LOCATION}    ${MRN}
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_SIU_Inbound

*** Variables ***
${MIRTH_CLIENT_URL}    https://localhost:8443/api
${CHANNEL_1_ID}    a30b3753-4b5c-4526-998f-9a1347502dfe    
${CHANNEL_2_ID}    bcdddf77-daa2-490f-ba93-c403a9cc5326

${remote_path}    /mirth_dev/Meditab_NTAA/AT_Test_Inbound/SIU_Inbound/ 
${local_path}    D:\\WorkSpace\\HL7\\Meditab_NTAA\\Inbound\\

${LOCATION}    12103
${MRN}    1234
${File_Type}    New Appointment (S12)

${output_file}    D:\\Fusebox Automation Testing\\resources\\PageObjects\\TestData\\SIU_Inbound.json

*** Test Cases ***
Verify Inbound SIU Message On SFTP Server 
    [Documentation]    Create message SIU from file GAP, write it to a file and send it to the sFTP Server 
    ${siu_message}=    Create HL7 Message From GAP File    SIU_Inbound    inbound     
    ${file_name}=    Save Message To File    ${siu_message}    SIU_inbound    ${local_path}
    Upload File To sFTP Server    ${local_path}    ${file_name}    ${remote_path}
    Verify File Exists On sFTP Server    ${file_name}    ${remote_path}

Verify Channel Status Process SIU Message On Mirth Connect
    [Documentation]    Call API to check if Mirth Connect channel has processed messages successfully
    ${status_channel_1}=    Verify Status In Channel Message    ${MIRTH_CLIENT_URL}    ${CHANNEL_1_ID}     
    ${status_channel_2}=    Verify Status In Channel Message    ${MIRTH_CLIENT_URL}    ${CHANNEL_2_ID}
    Log    Channel 1 Status: ${status_channel_1}
    Log    Channel 2 Status: ${status_channel_2}

Verify Jenkins Build Success    
    [Documentation]    Trigger Jenkins build for MIRTH Processor ADT project and check build status
    Create Jenkins Session    ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}
    ${initID}=    Get Current Build Number    ${PROJECT_NAME_SIU}
    Trigger Jenkins Build    ${PROJECT_NAME_SIU}     
    Verify Jenkins Build Success    ${PROJECT_NAME_SIU}    ${initID}    timeout=120    interval=10

Verify Value Patient LastName From Json File With Last Name On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value last name on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient
    ${last_name}=    Get From Dictionary    ${patient_object}    LastName
    ${last_name_ui}=    Get From Dictionary    ${patient_data}    LastName
    Should Be Equal As Strings    ${last_name}    ${last_name_ui}

Verify Value Patient FirstName From Json File With First Name On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value first name on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient    
    ${first_name}=    Get From Dictionary    ${patient_object}    FirstName
    ${first_name_ui}=    Get From Dictionary    ${patient_data}    FirstName
    Should Be Equal As Strings    ${first_name}    ${first_name_ui}

Verify Value Patient MiddleName From Json File With Middle Name On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value middle name on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient    
    ${middle_name}=    Get From Dictionary    ${patient_object}    MiddleName
    ${middle_name_ui}=    Get From Dictionary    ${patient_data}    MiddleName
    Should Be Equal As Strings    ${middle_name}    ${middle_name_ui}

Verify Value Patient EMRPatientID From Json File With MRN On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value MRN on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient
    ${mrn}=    Get From Dictionary    ${patient_object}    EmrPatientID
    ${mrn_ui}=    Get From Dictionary    ${patient_data}    MRN
    Should Be Equal As Strings    ${mrn}    ${mrn_ui}

Verify Value Patient DOB From Json File With DOB On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value DOB on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient    
    ${dob}=    Get From Dictionary    ${patient_object}    DOB
    ${dob_ui}=    Get From Dictionary    ${patient_data}    DOB
    Should Be Equal As Strings    ${dob}    ${dob_ui}

Verify Value Patient Gender From Json File With Gender On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value Gender on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient    
    ${gender}=    Get From Dictionary    ${patient_object}    Gender   
    ${gender_ui}=    Get From Dictionary    ${patient_data}    Gender
    Should Be Equal As Strings    ${gender}    ${gender_ui}

Verify Value Patient Address Line1 From Json File With Address Line 1 On Patient Information Tab
    [Documentation]    Get value from json file created from GAP file to compare with value Address Line1 on patient information tab
    ${patient_object}=    Get From Dictionary    ${json_data}    Patient
    ${patient_address}=    Get From Dictionary    ${patient_object}    PatientAddress
    ${address_line1}=    Get From Dictionary    ${patient_address}    AddressLine1
    ${address_line1_ui}=    Get From Dictionary    ${patient_data}    PatientAddressLine1
    Should Be Equal As Strings    ${address_line1}    ${address_line1_ui}

Verify Value Account PracticeAnalyzerIdentifier From Json File With Practice Analyzer ID On Edit Account Page
    [Documentation]    Get value from json file created from GAP file to compare with value Practice Analyzer ID on Edit Account page
    ${account_object}=    Get From Dictionary    ${json_data}    Account
    ${practice_analyzer_id}=    Get From Dictionary    ${account_object}    PracticeAnalyzerIdentifier
    ${practice_analyzer_id_ui}=    Get From Dictionary    ${account_data}    PracticeAnalyzerID
    Should Be Equal As Strings    ${practice_analyzer_id}    ${practice_analyzer_id_ui}

# Verify Value Appointment StartTime From Json File With Appointment Start Time On Appointments Tab
#     [Documentation]    Get value from json file to compare value with value Appointment Start Time  on appointments tab
#     ${appointment_object}=    Get From Dictionary    ${json_data}    Appointment
#     ${start_time}=    Get From Dictionary    ${appointment_object}    StartTime
#     ${appointment_start_time_ui}=    Get From Dictionary    ${appointment_data}    AppointmentStartTime
#     Should Be Equal As Strings    ${start_time}    ${appointment_start_time_ui}

Verify Physicians NPI First Index From Json File With Refer To Provider NPI On Appointments Tab
    [Documentation]    Get value from json file to compare value with value Refer To Provider NPI on appointments tab
    ${physicians_npi}=    Get Value From Json Array    ${json_data}    Physicians    0    NPI
    ${npi_refer_to_provider_ui}=    Get From Dictionary    ${appointment_data}    NPIReferToProvider
    Should Be Equal As Strings    ${physicians_npi}    ${npi_refer_to_provider_ui}

Verify Appointment EmrProprietaryName From Json File With System Proprietary Name On Edit Account Page
    [Documentation]    Get value from json file to compare value with value EmrProprietaryName on Edit Account Page
    ${appointment_object}=    Get From Dictionary    ${json_data}    Appointment
    ${emr_proprietary_name}=    Get From Dictionary    ${appointment_object}    EmrProprietaryName
    ${system_prop_name_ui}=    Get Value System ProprietaryName From Edit Account Page    ${emr_proprietary_name}
    ${appt_system_prop_name_ui}=    Get From Dictionary    ${appointment_data}    SystemPropName
    Should Be Equal As Strings    ${system_prop_name_ui}    ${appt_system_prop_name_ui}

*** Keywords ***
Setup Test Suite
    [Documentation]    Login to Fusebox, load config, create JSON Data and gather all required data
    [Arguments]    ${LOCATION}    ${MRN}
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    Load Config
    ${json_data}=    Create Json Data From File GAP    ${output_file}    SIU_Inbound
    ${appointment_object}=    Get From Dictionary    ${json_data}    Appointment
    ${start_time}=    Get From Dictionary    ${appointment_object}    StartTime
    ${date_of_service}=    Convert Date    ${start_time}    result_format=%m/%d/%Y
    ${appt_time}=    Convert Date    ${start_time}    result_format=%I:%M %p
    ${patient_data}=    Get Value From Patient Information Tab
    ${appointment_data}=    Get Value From Appointments Tab
    ${account_data}=    Get Value From Edit Account Page 
    Set Suite Variable    ${json_data}
    Set Suite Variable    ${patient_data}
    Set Suite Variable    ${appointment_data}
    Set Suite Variable    ${account_data}
    
    

    
    
    


    



    
