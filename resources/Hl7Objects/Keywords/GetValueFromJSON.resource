*** Settings ***
Library    JSONLibrary
Library    SeleniumLibrary
Library    Collections
Library    OperatingSystem
Library    String
Library    ../../Hl7Objects/TestData/DataHL7.py

Variables    ../../../resources/PageObjects/Locators/Patient.py        

*** Keywords ***
# Create Json Data From File GAP
#     [Arguments]    ${file_name}    ${worksheet_name}
#     ${key_value}=    DataHL7.Get Key Object Values    ${Inbound_GAP_Key}    ${worksheet_name}
#     ${json_data}=    DataHL7.Generate Json Data    ${key_value}
#     DataHL7.Save Json To File    ${json_data}    ${file_name}
#     RETURN    ${json_data}

Get Value From Json Object
    [Arguments]    ${json_file}    ${parent_key}    ${child_key}
    ${json_data}=    Load JSON From File    ${json_file}
    ${parent_object}=    Get From Dictionary    ${json_data}    ${parent_key}
    ${value}=    Get From Dictionary    ${parent_object}    ${child_key}
    RETURN    ${value}

Get Value From Json Array
    [Arguments]    ${json_data}    ${parent_key}    ${index}    ${child_key}   
    ${array}=        Get From Dictionary    ${json_data}    ${parent_key}
    ${object}=       Get From List         ${array}    ${index}
    ${value}=        Get From Dictionary    ${object}    ${child_key}
    RETURN    ${value}

Update JSON With Patient Info
    [Arguments]    ${json_file}    ${patient_info_dic}    ${appointment_info_dic}        
    ${json_data}=    Load JSON From File    ${json_file}    encoding=UTF-8

    Set To Dictionary    ${json_data['Patient']}    PatientID    ${appointment_info_dic['patientid']}
    Set To Dictionary    ${json_data["Patient"]}    FirstName    ${patient_info_dic["FirstName"]}
    Set To Dictionary    ${json_data["Patient"]}    LastName     ${patient_info_dic["LastName"]}
    Set To Dictionary    ${json_data["Patient"]}    MRN          ${patient_info_dic["MRN"]}
    Set To Dictionary    ${json_data["Patient"]}    DateOfBirth  ${patient_info_dic["DateOfBirth"]}
    Set To Dictionary    ${json_data["Patient"]}    Gender       ${patient_info_dic["Gender"]}
    Set To Dictionary    ${json_data["Patient"]}    HomePhone    ${patient_info_dic["HomePhone"]}
    Set To Dictionary    ${json_data["Patient"]}    CellPhone    ${patient_info_dic["CellPhone"]}
    Set To Dictionary    ${json_data["Patient"]}    Email        ${patient_info_dic["Email"]}

    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    AddressLine1    ${patient_info_dic["AddressLine1"]}
    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    AddressLine2    ${patient_info_dic["AddressLine2"]}
    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    City            ${patient_info_dic["City"]}
    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    State           ${patient_info_dic["State"]}
    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    ZipCode         ${patient_info_dic["ZipCode"]}
    Set To Dictionary    ${json_data["Patient"]["PatientAddress"]}    CountryCode     ${patient_info_dic["CountryCode"]}
    
    Set To Dictionary    ${json_data['Appointment']}    AppointmentID          ${appointment_info_dic['appointmentid']}  
    Set To Dictionary    ${json_data['Appointment']}    AppointmentMedication  ${appointment_info_dic['appointmentmedication']}
    Set To Dictionary    ${json_data['Appointment']}    AppointmentNote        ${appointment_info_dic['appointmentnote']}
    Set To Dictionary    ${json_data['Appointment']}    ReferringProvider      ${appointment_info_dic['referringprovider']}
    Set To Dictionary    ${json_data['Appointment']}    StartTime              ${appointment_info_dic['starttime']}       

    ${payer}=         Create Dictionary
    Set To Dictionary    ${payer}    SubscriberNumber=${patient_info_dic["SubscriberNumber"]}
    Set To Dictionary    ${payer}    EffectiveDate=${patient_info_dic["EffectiveDate"]}
    Set To Dictionary    ${payer}    ExpirationDate=${patient_info_dic["ExpirationDate"]}

    Set To Dictionary    ${json_data["Payers"][0]}    SubscriberNumber=${payer["SubscriberNumber"]}
    Set To Dictionary    ${json_data["Payers"][0]}    EffectiveDate=${payer["EffectiveDate"]}
    Set To Dictionary    ${json_data["Payers"][0]}    ExpirationDate=${payer["ExpirationDate"]}

    Save Json Data To File    ${json_data}    ${json_file}
    Log    Updated JSON saved to ${json_file}

Save Json Data To File    
    [Arguments]    ${json_object}    ${output_file}
    ${json_object}=    Replace String Using Regexp    ${json_object}    true    True
    ${json_object}=    Replace String Using Regexp    ${json_object}    false    False
    ${json_object}=    Replace String Using Regexp    ${json_object}    null    None
    ${json_string}=    Evaluate    json.dumps(${json_object}, indent=4)    modules=json
    Create File    ${output_file}    ${json_string}    encoding=UTF-8
    RETURN    ${json_string}

Get Account Object From JSON
    [Arguments]    ${json_file}
    ${account_data}=    Get Value From Json Object    ${json_file}    Account    AccountID
    ${account_name}=    Get Value From Json Object    ${json_file}    Account    Name
    ${account_number}=    Get Value From Json Object    ${json_file}    Account    AccountNumber
    ${practice_analyzer_identifier}=    Get Value From Json Object    ${json_file}    Account    PracticeAnalyzerIdentifier
    ${emr_mapping}=    Get Value From Json Object    ${json_file}    Account    EMRMapping

    ${account_info_dic}=    Create Dictionary
    ...                     AccountID=${account_data}
    ...                     Name=${account_name}
    ...                     AccountNumber=${account_number}
    ...                     PracticeAnalyzerIdentifier=${practice_analyzer_identifier}
    ...                     EMRMapping=${emr_mapping}
    RETURN                  ${account_info_dic}