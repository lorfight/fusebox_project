*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    XML
Library    String
Library    DateTime

Variables    ../../../resources/PageObjects/Locators/Appointment.py

*** Keywords ***
Go To Appointment Ordering Ledger
    Click Element    //*[contains(@class, 'dropdown open')]/a[text()=' Ordering ']
    Click Element    //*[contains(@class, 'dropdown open')]//*[text()='Scheduled Appointment Ordering']

Get Value From Appointments Tab
    Go To Appointment Ordering Ledger
    Click Element    //*[@id="Appointment"]    
    Wait Until Element Is Visible    //*[@id="AppointmentTabList"]    30s
    
    Wait Until Element Is Visible    ${Appointment_ID}    30s
    ${appt_id}=                    Get Text    ${Appointment_ID}
    ${replace_appointment_id}=    Replace String    ${appt_ID}    APT    ${EMPTY}
    ${convert_appointment_id}=    Convert To Integer    ${replace_appointment_id}
    ${patient_identifier}=         Get Text    ${Patient_ID}
    ${appt_date_of_service}=       Get Text    ${Date_Of_Service}
    ${appt_time}=           Get Text    ${Appt_Time}
    ${appointment_start_time}=    Convert Date    ${appt_date_of_service} ${appt_time}    result_format=%Y%m%d%H%M%S    date_format=%m/%d/%Y %I:%M %p 
    ${appt_medication}=             Get Text    //*[@id="ApptMedColumn_MTAzOTYzMw__"]/strong[1]/span[1]    
    ${appt_note}=                  Get Value    ${Appointment_Note}
    ${appt_referring_provider}=    Get Value    ${Referring_Provider}
    ${appt_refer_to_provider}=     Get Value    ${Refer_To_Provider}  
    ${appt_refer_to_provider}=     Get Value    ${Refer_To_Provider}
    ${npi_match}=    Get Regexp Matches    ${appt_refer_to_provider}    (?<=NPI# : )\\d+
    ${npi_refer_to_provider}=    Get From List    ${npi_match}    0
    ${last_name_refer_to_provider}=    Get Regexp Matches    ${appt_refer_to_provider}    ^\\w+
    ${last_name_refer_to_provider}=    Get From List    ${last_name_refer_to_provider}    0
    ${first_name_refer_to_provider}=    Get Regexp Matches    ${appt_refer_to_provider}    (?<=, )\\w+
    ${first_name_refer_to_provider}=    Get From List    ${first_name_refer_to_provider}    0 

    ${appointment_data}=    Create Dictionary
    ...                     AppointmentId=${convert_appointment_id}
    ...                     AppointmentStartTime=${appointment_start_time}      
    ...                     AppointmentNote=${appt_note} 
    ...                     ReferringProvider=${appt_referring_provider}
    ...                     NPIReferToProvider=${npi_refer_to_provider}  
    ...                     LastNameReferToProvider=${last_name_refer_to_provider}
    ...                     FirstNameReferToProvider=${first_name_refer_to_provider}
    ...                     ApptMedication=${appt_medication}        
    
    RETURN    ${appointment_data}