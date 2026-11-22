*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${reschedule_location_select}    //select[@id="RescheduleAccountID"]
${reschedule_newdate_input}    //input[@id="RequireDate"]
${reschedule_newtime_input}    //input[@id="RequireTime"]
${reschedule_appointment_lenght_select}    //select[@id="RequiredLength"]
${reschedule_reason_select}    //select[@id="Reason"]
${reschedule_appointment_location_select}    //select[@id="Location"]
${reschedule_btn}    //a[contains(text(),'Reschedule')]

*** Keywords ***
Create Reschedule Appointment Dictionary
    &{reschedule_appointment_dict}    Create Dictionary
    RETURN    ${reschedule_appointment_dict}

Select Location
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${reschedule_location_select}    30s
    Wait Until Keyword Succeeds    30s    1s   Select From List By Label    ${reschedule_location_select}    ${location_arg}

Input New Date
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    ${reschedule_newdate_input}    30s
    Wait Until Keyword Succeeds    30s    1s   Input Text    ${reschedule_newdate_input}    ${date_arg}
    Common.Close Calendar Table
    
Input New Time
    [Arguments]    ${time_arg}
    Wait Until Element Is Visible    ${reschedule_newtime_input}    30s
    Wait Until Keyword Succeeds    30s    1s   Input Text    ${reschedule_newtime_input}    ${time_arg}
    Press Keys    ${reschedule_newtime_input}    RETURN

Select Appointment Length
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${reschedule_appointment_lenght_select}    var_name=reschedule_appointment_lenght_select    dic=${dict_arg}

Select Reason
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${reschedule_reason_select}    var_name=reschedule_reason_select    dic=${dict_arg}

Select Appointment Location
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${reschedule_appointment_location_select}    var_name=reschedule_appointment_location_select    dic=${dict_arg}

Click Rechedule Button
    Common.Scroll And Click Element    ${reschedule_btn}

Rechedule Appointment
    [Arguments]    ${location_arg}    ${date_arg}    ${time_arg}
    ${reschedule_appointment_dict}    Create Reschedule Appointment Dictionary
    Select Location    ${location_arg}
    Input New Date    ${date_arg}
    Input New Time    ${time_arg}
    Select Appointment Length    ${reschedule_appointment_dict}
    Select Reason    ${reschedule_appointment_dict}
    Select Appointment Location    ${reschedule_appointment_dict}
    Click Rechedule Button
    Common.Page Alert Message    Appointment Rescheduled!
    RETURN    ${reschedule_appointment_dict}