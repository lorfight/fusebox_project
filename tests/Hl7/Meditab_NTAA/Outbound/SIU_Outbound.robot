*** Settings ***
Library    SeleniumLibrary
Library    DatabaseLibrary
Library    JSONLibrary
Library    Collections
Library    OperatingSystem
Library    RequestsLibrary
Library    SSHLibrary

Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/PageObjects/Keywords/GetValueFromJSON.resource
Resource    ../../../../resources/PageObjects/Keywords/Dispense.resource
Resource    ../../../../resources/PageObjects/Keywords/GetValueFromConfigs.resource
Resource    ../../../../resources/PageObjects/Keywords/CallAPIMirthConnectClient.resource
Resource    ../../../../resources/PageObjects/Keywords/SendMessageToSFTPServer.resource
Resource    ../../../../resources/PageObjects/Keywords/HL7_Patient.resource
Resource    ../../../../resources/PageObjects/Keywords/HL7_Accounts.resource
Resource    ../../../../resources/PageObjects/Keywords/HL7_Appointment.resource

Suite Setup    SetUp Test Suite    ${LOCATION}    ${MRN}
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_SIU_Outbound

*** Variables ***
${QUERY}    SELECT TOP 1 HL7_Outbound_Staging.HL7_Outbound_StagingID AS HL7OutboundStagingID, HL7_Outbound_Staging.JsonData AS JSONData FROM HL7_Outbound_Staging WITH (NOLOCK) JOIN Account WITH (NOLOCK) ON HL7_Outbound_Staging.AccountID = Account.AccountID WHERE FileType >= 110 AND FileType <= 140 AND HL7_Outbound_Staging.Status = 10 AND Account.EMRMapping = 170 AND HL7_Outbound_Staging.LastAction <> 'D' AND Account.LastAction <> 'D' ORDER BY HL7_Outbound_Staging.HL7_Outbound_StagingID DESC OPTION (RECOMPILE);    

${DAY}    Evaluate    random.randint(1, 15)    modules=random
${xpath}    //*[@id="ui-datepicker-div"]/div[1]/table/tbody/tr[3]/td[${DAY}]/a

${OUTPUT_FILE}    D:\\Fusebox Automation Testing\\resources\\PageObjects\\TestData\\SIU_Outbound.json
${CONFIG_FILE}    configs/dev.json

${MIRTH_CLIENT_API}    https://localhost:8443/api
${CHANNEL_ID_1}    b6fb657e-cadf-4239-bc00-d887ab0f9c7a   
${CHANNEL_ID_2}    f61a8df2-9e54-4dfb-8004-ee63c6d93d1e 
${CHANNEL_ID_3}    3ad48751-9001-44c5-a2cc-0da7aca2fdbf

# ${REMOTE_PATH}    /mirth_dev/Meditab_NTAA/SIU_Outbound 
${REMOTE_PATH}    /mirth_dev/Meditab_NTAA/ADT_OutboundFromFusebox/
${LOCAL_PATH}     D:\\WorkSpace\\HL7\\

${TIME_OFFSET}    120

*** Test Cases ***
Verify That The System Will Record The Json File To DB 
    [Documentation]    Verify that the system will record the JSON file to DB when the user creates an appointment successfully
    # Create A New Appointment
    DatabaseLibrary.Connect To Database    pymssql    ${DB_NAME}    ${DB_USER_NAME}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
    ${result}=    DatabaseLibrary.Query    ${QUERY}
    Should Not Be Empty    ${result}    JSON File is not recorded to DB
    ${HL7OutboundStagingID}=    Set Variable    ${result}[0][0]
    Set Suite Variable    ${HL7OutboundStagingID}    ${HL7OutboundStagingID}
    ${json_data}=    Set Variable    ${result}[0][1]
    Save JSON Data To File    ${json_data}    ${OUTPUT_FILE}
    DatabaseLibrary.Disconnect From Database

Verify PracticeAnalyzerIdentifier From Account Object With Practice Analyzer ID On Edit Account Page
    [Documentation]    Compare Account.PracticeAnalyzerIdentifier from DB with Practice Analyzer ID on Edit Account Page
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${practice_analyzer_id}=    JSONLibrary.Get Value From Json    ${json_data}    Account.PracticeAnalyzerIdentifier
    ${practice_analyzer_id_ui}=    Get From Dictionary    ${account_data}    Name
    Should Be Equal    ${practice_analyzer_id}[0]    ${practice_analyzer_id_ui}

Verify EMRMapping From Account Object With EMR Mapping On Edit Account Page
    [Documentation]    Compare Account.EMRMapping from DB with EMRMapping on Edit Account Page
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${emr_mapping}=    JSONLibrary.Get Value From Json    ${json_data}    Account.EMRMapping
    ${emr_mapping_ui}=    Get From Dictionary    ${account_data}    EMRMapping
    Should Be Equal    ${emr_mapping}[0]    ${emr_mapping_ui}

Verify MRN From Patient Object With MRN On Patient Information Tab
    [Documentation]    Compare Patient.MRN from DB with MRN on Patient Information Tab
    ${json_data}=    Load Json From File    ${OUTPUT_FILE}
    ${mrn}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.MRN
    ${mrn_ui}=    Get From Dictionary    ${patient_data}    MRN
    Should Be Equal    ${mrn}[0]    ${mrn_ui}

Verify FirstName From Patient Object With First Name On Patient Information Tab
    [Documentation]    Compare Patient.FirstName from DB with First Name on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${first_name}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.FirstName
    ${first_name_ui}=    Get From Dictionary    ${patient_data}    FirstName
    Should Be Equal    ${first_name}[0]    ${first_name_ui}

Verify LastName From Patient Object With Last Name On Patient Information Tab
    [Documentation]    Compare Patient.LastName from DB with Last Name on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${last_name}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.LastName
    ${last_name_ui}=    Get From Dictionary    ${patient_data}    LastName
    Should Be Equal    ${last_name}[0]    ${last_name_ui}

Verify DOB From Patient Object With Date Of Birth On Patient Information Tab
    [Documentation]    Compare Patient.DOB from DB with Date Of Birth on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${dob}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.DOB
    ${dob_ui}=    Get From Dictionary    ${patient_data}    DateOfBirth
    Should Be Equal    ${dob}[0]    ${dob_ui}

Verify Gender From Patient Object With Gender On Patient Information Tab
    [Documentation]    Compare Patient.Gender from DB with Gender on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${gender}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.Gender
    ${gender_ui}=    Get From Dictionary    ${patient_data}    Gender
    Should Be Equal    ${gender}[0]    ${gender_ui}    

Verify AddressLine1 From Patient Object with Address Line 1 On Patient Information Tab
    [Documentation]    Compare Patient.PatientAddress.AddressLine1 from DB with Address Line 1 on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${address_line1}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.PatientAddress.AddressLine1
    ${address_line1_ui}=    Get From Dictionary    ${patient_data}    AddressLine1
    Should Be Equal    ${address_line1}[0]    ${address_line1_ui}

Verify City From Patient Object with City On Patient Information Tab
    [Documentation]    Compare Patient.PatientAddress.City from DB with City on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${city}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.PatientAddress.City
    ${city_ui}=    Get From Dictionary    ${patient_data}    City
    Should Be Equal    ${city}[0]    ${city_ui}

Verify StateProvince From Patient Object with State/Province On Patient Information Tab
    [Documentation]    Compare Patient.PatientAddress.StateProvince from DB with State on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${state}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.PatientAddress.StateProvince
    ${state_ui}=    Get From Dictionary    ${patient_data}    State
    Should Be Equal    ${state}[0]    ${state_ui}

Verify PostalCode From Patient Object With Postal Code On Patient Information Tab
    [Documentation]    Compare Patient.PatientAddress.PostalCode from DB with Postal Code on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${postal_code}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.PatientAddress.PostalCode
    ${postal_code_ui}=    Get From Dictionary    ${patient_data}    PostalCode
    Should Be Equal    ${postal_code}[0]    ${postal_code_ui}

Verify CountryRegion From Patient Object With Country/Region On Patient Information Tab
    [Documentation]    Compare Patient.PatientAddress.CountryRegion from DB with Country on Patient Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${country}=    JSONLibrary.Get Value From Json    ${json_data}    Patient.PatientAddress.CountryRegion
    ${country_ui}=    Get From Dictionary    ${patient_data}    CountryCode
    Should Be Equal    ${country}[0]    ${country_ui}

Verify AppointmentID From Appointment Object With Appointment ID On Appointments Tab
    [Documentation]    Compare Appointment.AppointmentID from DB with Appointment ID on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_id}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.AppointmentID
    ${appointment_id_ui}=    Get From Dictionary    ${appointment_data}    appointmentID 
    Should Be Equal    ${appointment_id}[0]    ${appointment_id_ui}

Verify DateOfService From Appointment Object With Date Of Service On Appointments Tab
    [Documentation]    Compare Appointment.DateOfService from DB with Date Of Service on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${date_of_service}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.DateOfService
    ${date_of_service_ui}=    Get From Dictionary    ${appointment_data}    appointmentDOS
    ${appointment_time_ui}=    Get From Dictionary    ${appointment_data}    appointmentTime
    ${formatted_date}=    Convert Date    ${date_of_service_ui}    result_format=%Y-%m-%d    date_format=%m/%d/%Y
    ${formatted_time}=    Format Time String    ${appointment_time_ui}
    ${combined_datetime}=    Set Variable    ${formatted_date}T${formatted_time}
    Should Be Equal    ${date_of_service}[0]    ${combined_datetime}

Verify AppointmentNote From Appointment Object With Appointment Note On Appointments Tab
    [Documentation]    Compare Appointment.AppointmentNote from DB with Appointment Note on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_note}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.AppointmentNote
    ${appointment_note_ui}=    Get From Dictionary    ${appointment_data}    appointmentNote
    Should Be Equal    ${appointment_note}[0]    ${appointment_note_ui}

Verify EMRProprietaryName From Medications Object With EMR Medication Name Conversions On Edit Account Page
    [Documentation]    Compare Medications.EMRProprietaryName Object from DB with Medications Information Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_object}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.Medications[0].EMRProprietaryName
    ${emr_prroprietary_name_ui}=    Get EMR Medication Mappings Information From Edit Account Page
    Should Be Equal    ${appointment_object}[0]    ${emr_prroprietary_name_ui}

Verify NPI Of Referring From Physicians Object With Referring Provider On Appointments Tab
    [Documentation]    Compare Physician.NPI Object from DB with Referring Provider on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_object}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.Physicians[0].NPI
    ${referring_provider_ui}=    Get From Dictionary    ${appointment_data}    referringProvider
    Should Be Equal    ${appointment_object}[0]    ${referring_provider_ui}

Verify First Name Of Referring From Physicians Object With Referring Provider On Appointments Tab
    [Documentation]    Compare Physician.Provider_First_Name Object from DB with Referring Provider on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_object}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.Physicians[0].Provider_First_Name
    ${referring_provider_ui}=    Get From Dictionary    ${appointment_data}    referringProvider
    ${referring_first_name_ui}=    Get Substring    ${referring_provider_ui}    12    21
    Should Be Equal As Strings    ${appointment_object}[0]    ${referring_first_name_ui}    ignore_case=True

Verify Last Name Of Referring From Physicians Object With Referring Provider On Appointments Tab
    [Documentation]    Compare Physician.Provider_Last_Name Object from DB with Referring Provider on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_object}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.Physicians[0].Provider_Last_Name
    ${referring_provider_ui}=    Get From Dictionary    ${appointment_data}    referringProvider
    ${split_referring_provider_ui}=    Split String    ${referring_provider_ui}    ,
    ${referring_last_name_ui}=    Strip String    ${split_referring_provider_ui}[0]
    Should Be Equal As Strings   ${appointment_object}[0]    ${referring_last_name_ui}    ignore_case=True

Verify Status On Mirth Connect After Processed Message Successfully 
    [Documentation]    Call API to check if Mirth Connect channel has processed messages successfully
    Verify Status In Channel Message    ${MIRTH_CLIENT_API}    ${CHANNEL_ID_1}    
    Verify Status In Channel Message    ${MIRTH_CLIENT_API}    ${CHANNEL_ID_2}    
    Verify Status In Channel Message    ${MIRTH_CLIENT_API}    ${CHANNEL_ID_3}    

Create SIU Outbound Message From Gap File
    ${siu_outbound}=    Create HL7 Message From GAP File    SIU_Outbound    outbound
    Save Message To File    ${siu_outbound}    SIU_Outbound.hl7    ${LOCAL_PATH}
    Log    ${siu_outbound}

*** Keywords ***
SetUp Test Suite
    [Documentation]    Login to Fusebox, load config, create JSON Data and gather all required data
    [Arguments]    ${LOCATION}    ${MRN} 
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    Load Config
    ${json_data}=    Create Json Data From File GAP    ${output_file}    ADT_Inbound
    ${patient_data}=    Get Value From Patient Information Tab
    ${account_data}=    Get Value From Edit Account Page
    ${appointment_data}=    Get Value From Appointments Tab    ${date_of_service}    ${appt_time}
    Set Suite Variable    ${appointment_data}
    Set Suite Variable    ${json_data}
    Set Suite Variable    ${patient_data}
    Set Suite Variable    ${account_data}

Create A New Appointment
    Navigate To Patient Information Tab    ${LOCATION}    ${MRN}
    Click Element    //*[@id="Appointment"]
    Wait Until Element Is Visible    //*[@id="AppointmentTabList"]/div[1]/h2    5s
    Click Element    //*[@id="CreatePatientApptBtn"]/a
    Wait Until Element Is Visible    //*[@id="SchduleDosageContainer"]/div[2]/div[1]/div/button    10s
    Click Element    //*[@id="SchduleDosageContainer"]/div[2]/div[1]/div/button
    Input Text    //*[@id="SchduleDosageContainer"]/div[2]/div[1]/div/div/div/input    Xolair 
    Click Element    //*[@id="SchduleDosageContainer"]/div[2]/div[1]/div/div/ul/li[26]/a/span[1]
    Wait Until Element Is Visible   xpath=//*[@id="Value_1"]   5s
    Input Text    //*[@id="Value_1"]    1
    Click Element    //*[@id="DosageAddonSelectionDiv"]/div[4]/div/a
    Wait Until Element Is Visible    //*[@id="AppointmentDate"]
    Click Element    //*[@id="AppointmentDate"]
    # Click Element    //*[@id="ui-datepicker-div"]/div[1]/table/tbody/tr[3]/td[4]/a
    ${DAY}    Evaluate    random.randint(1, 7)    modules=random
    ${evaluated_xpath}=    Evaluate    "//*[@id='ui-datepicker-div']/div[1]/table/tbody/tr[2]/td[${DAY}]/a"
    Click Element    ${evaluated_xpath}
    Input Text    //*[@id="RequireTime"]    7:00 am
    Press Key    //*[@id="RequireTime"]    \\13    # \\13: ENTER
    Click Button    //*[@id="SaveBtn"]
    Wait Until Element Is Visible    //*[@id="AppointmentTabList"]/div[1]/h2    10s
    Click Element    //*[@id="PatientHistoryTreatment"]
    Click Element    //*[@id="Appointment"]

Format Time String
    [Arguments]    ${time_string}
    ${time_string}=    Strip String    ${time_string}
    ${time_parts}=    Split String    ${time_string}    ${SPACE}
    ${time_value}=    Set Variable    ${time_parts[0]}
    ${ampm}=          Set Variable    ${time_parts[1]}
    ${hour}=    Evaluate    int('${time_value}'.split(':')[0])
    ${minute}=  Evaluate    '${time_value}'.split(':')[1]
    ${hour}=    Evaluate    ${hour} + 12 if '${ampm}' == 'PM' and ${hour} != 12 else ${hour}
    ${hour}=    Evaluate    ${hour} - 12 if '${ampm}' == 'AM' and ${hour} == 12 else ${hour}
    ${hour}=    Evaluate    str(${hour}).zfill(2)
    ${formatted_time}=    Set Variable    ${hour}:${minute}:00
    RETURN    ${formatted_time}