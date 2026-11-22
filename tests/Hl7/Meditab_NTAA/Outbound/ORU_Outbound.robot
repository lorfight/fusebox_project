** Settings **
Library    SeleniumLibrary
Library    DatabaseLibrary
Library    Collections
Library    JSONLibrary
Library    RequestsLibrary

Resource    ../../../../resources/PageObjects/Keywords/LoginKeywords.resource 
Resource    ../../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Patient.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromJSON.resource
Resource    ../../../../resources/Hl7Objects/Keywords/GetValueFromConfigs.resource
Resource    ../../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Accounts.resource
Resource    ../../../../resources/Hl7Objects/Keywords/HL7Appointment.resource
Resource    ../../../../resources/Hl7Objects/Keywords/VerifyFileOnSFTP.resource

Suite Setup    SetUp Test Suite    ${LOCATION}    ${MRN}
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

Test Tags    Hl7    MNTAA_ORU_Outbound

*** Variables ***
${QUERY}    SELECT TOP 1 HL7_Outbound_Staging.HL7_Outbound_StagingID AS HL7OutboundStagingID, HL7_Outbound_Staging.JsonData AS JSONData FROM HL7_Outbound_Staging Join Account On HL7_Outbound_Staging.AccountID = Account.AccountID WHERE Filetype = 60 AND HL7_Outbound_Staging.Status = 10 AND Account.EMRMapping = 170 AND HL7_Outbound_Staging.LastAction <> 'D' AND Account.LastAction <> 'D'

${OUTPUT_FILE}    D:\\Fusebox Automation Testing\\resources\\PageObjects\\TestData\\ORU_Outbound.json
${CONFIG_FILE}    configs/dev.json

${MIRTH_CLIENT_API}    https://localhost:8443/api
${CHANNEL_ID_1}    6571962d-975e-44f1-93e5-15586c664369   
${CHANNEL_ID_2}    ff0c0029-b907-4561-8731-8f8cc889b878 
${CHANNEL_ID_3}    4594a15b-1d45-43f2-9c50-f670462f2855

** Test Cases **
Verify Dispense Appointment 
    [Documentation]    Verify dispense medication to patient 
    Navigate To Patient Information Tab    ${LOCATION}    ${MRN}
    Click Element    //*[@id="Appointment"]
    Wait Until Page Contains    Scheduled Appointments    10s  
    Wait Until Element Is Visible    //*[@id="ApptBtnGroup_MTAzODk1MQ__"]/div[2]/div[2]/a    10s  
    Click Element    //*[@id="ApptBtnGroup_MTAzODk1MQ__"]/div[2]/div[2]/a
    Wait Until Element Contains    //*[@id="ModalPopup"]/div[2]/div/div[1]/div[2]/h4    Dispense Medication To Patient
    ${rows}=    Get WebElements    //*[@id="AppointmentDispenseTable"]/tbody/tr[@class="lineDetail DispenseModalRow pickedStatus"]
    ${number_element}=    Get Length    ${rows}
    
    FOR    ${index}    IN RANGE    1    ${number_element} + 1
        ${dispensed}    Set Variable    //tr[contains(@class,'lineDetail')][${index}]//*[@class='editableLine' and @name='Dispensed']
        Click Element    ${dispensed}
        ${select_lot}    Set Variable    //tr[contains(@class,'lineDetail')][${index}]//*[@type='button' and contains(@title,'Select Lot')]  
        Click Element    ${select_lot}
        Input Text    //tr[contains(@class,'lineDetail')][${index}]//*[@type='text']    3603335
        Press Keys    //tr[contains(@class,'lineDetail')][${index}]//*[@type='text']    ENTER      
    END
    
    Click Element    //*[@id="AppointmentDispenseTable"]/tbody/tr[16]/td/div[7]/a[2]
    Handle Alert    Accept
    Wait Until Element Is Visible    //*[@id="CloseBtn"]    5s
    Click Button    //*[@id="CloseBtn"]
    Click Element    //*[@id="PatientHistoryTreatment"]
    Click Element    //*[@id="Appointment"]
    Wait Until Element Contains    //*[@id="AppointmentTabList"]/table/tbody/tr[3]/td[1]/div[5]/span    Dispensed

Verify That The System Will Record The Json File To DB 
    [Documentation]    Verify that the system will record the JSON file to DB when the user creates an appointment successfully
    # Create A New Appointment
    DatabaseLibrary.Connect To Database    pymssql    ${DB_NAME}    ${DB_USER_NAME}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
    ${result}=    DatabaseLibrary.Query    ${QUERY}
    ${HL7OutboundStagingID}=    Set Variable    ${result}[0][0]
    ${json_data}=    Set Variable    ${result}[0][1]
    Save JSON Data To File    ${json_data}    ${OUTPUT_FILE}
    DatabaseLibrary.Disconnect From Database

Verify PracticeAnalyzerIdentifier From Account Object With Practice Analyzer Identifier On Edit Account Page
    [Documentation]    Compare Account.PracticeAnalyzerIdentifier from DB with PracticeAnalyzerIdentifier on Edit Account Page
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${practice_analyzer_id}=    JSONLibrary.Get Value From Json    ${json_data}    Account.PracticeAnalyzerIdentifier
    ${practice_analyzer_id_ui}=    Get From Dictionary    ${account_data}    Name
    Should Be Equal    ${practice_analyzer_id}[0]    ${practice_analyzer_id_ui}

Verify EMRMapping From Account Object With EMR Mapping On Edit Account Page
    [Documentation]    Compare Account.EMRMapping from DB with EMRMapping on Edit Account Page
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${emr_mapping}=    JSONLibrary.Get Value From Json    ${json_data}    Account.EMRMapping
    ${emr_mapping_ui}=    Get From Dictionary    ${account_data}    EMRMapping
    ${convert_emr_mapping_ui}=    Replace String    ${emr_mapping_ui}    Meditab North Texas Allergy and Asthma    Meditab_NTAA
    Should Be Equal    ${emr_mapping}[0]    ${convert_emr_mapping_ui}

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
    ${format_dob}=    Convert Date    ${dob}    result_format=%m/%d/%Y    date_format=%Y-%m-%dT%H:%M:%S
    Should Be Equal    ${dob}[0]    ${format_dob}

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
    ${convert_country_ui}=    Replace String    ${country_ui}    United States    USA
    Should Be Equal    ${country}[0]    ${convert_country_ui}

Verify AppointmentID From Appointment Object With Appointment ID On Appointments Tab
    [Documentation]    Compare Appointment.AppointmentID from DB with Appointment ID on Appointments Tab
    ${json_data}=    Load JSON From File    ${OUTPUT_FILE}
    ${appointment_id}=    JSONLibrary.Get Value From Json    ${json_data}    Appointment.AppointmentID
    ${appointment_id_ui}=    Get From Dictionary    ${appointment_data}    appointmentID 
    ${replace_appointment_id_ui}=    Replace String    ${appointment_id_ui}    APT    ${EMPTY}
    ${convert_appointment_id_ui}=    Convert To Integer    ${replace_appointment_id_ui}
    Should Be Equal    ${appointment_id}[0]    ${convert_appointment_id_ui}

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

*** Keywords ***
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