*** Settings ***
Resource    ../../Layers/PatientAlerts/PatientAlerts.resource

*** Variables ***
${patientalerts_filter_by_location_select}    //select[@id="PatientAlertLocationID"]
${patientalerts_filter_by_patient_input}    //input[@id="PatientAlertPatientId"]
${patientalerts_show_completed_checkbox}    //input[@id='ShowCompletedPatientAlerts']
${patientalerts_start_date_input}    //input[@id="PatientAlertStartDate"]
${patientalerts_end_date_input}    //input[@id="PatientAlertEndDate"]
${create_patient_alert_btn}    //a[@id="CreatePatientAlertBtn"]

*** Keywords ***
Go To Patient Alerts Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Patient Alerts
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Patient Alerts

Filter By Location In Patient Alerts Page
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${patientalerts_filter_by_location_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${patientalerts_filter_by_location_select}    ${location_arg}

Filter By Patient In Patient Alerts Page
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    //strong[@class="tt-highlight" and text()='${mrn_arg}']//parent::div
        Common.Clear Input Field Until Empty    ${patientalerts_filter_by_patient_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${patientalerts_filter_by_patient_input}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    2s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            Exit For Loop
        END
    END

Click Show Completed Checkbox In Patient Alerts Page
    [Arguments]    ${expected_status}    #true or None
    Wait Until Element Is Visible    ${patientalerts_show_completed_checkbox}    30s
    ${is_checked}    SeleniumLibrary.Get Element Attribute    ${patientalerts_show_completed_checkbox}    checked
    IF    "${is_checked}" != "${expected_status}"
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${patientalerts_show_completed_checkbox}
    END

Input Start Date In Filter By Event Timesptamp
    [Arguments]    ${startdate_arg}
    Wait Until Element Is Visible    ${patientalerts_start_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${patientalerts_start_date_input}    ${startdate_arg}
    Common.Close Calendar Table

Input End Date In Filter By Event Timesptamp
    [Arguments]    ${enddate_arg}
    Wait Until Element Is Visible    ${patientalerts_end_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${patientalerts_end_date_input}    ${enddate_arg}
    Common.Close Calendar Table

Filter By Event Timesptamp In Patient Alerts Page
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Input Start Date In Filter By Event Timesptamp    ${startdate_arg}
    Input End Date In Filter By Event Timesptamp    ${enddate_arg}

Click Create Patient Alert Button
    Common.Scroll And Click Element    ${create_patient_alert_btn}
    Wait Until Element Is Visible    ${create_patient_alert_title}    30s

Create New Patient Alert
    [Arguments]    ${mrn_arg}    ${date_arg}    ${action_reason_txt}    ${utc}
    Click Create Patient Alert Button
    Input Patient In Create Patient Alert Modal    ${mrn_arg}    
    ${event_description_txt}    Select Event Description    selected_index=1
    Input Event Date    ${date_arg}
    ${priority_txt}    Select Priority    selected_index=1
    ${duration_value}    Random Action Duration Value
    Click Action Duration Checkbox    ${duration_value}
    Input Action Reason Input    ${action_reason_txt}
    ${expected_datetime}    ${expected_plus_1}    Get Current Date Time When Create Patient Alert    ${utc}
    Click Save Patient Alert Button
    Common.Page Alert Message    Patient Alert Created.
    RETURN    ${expected_datetime}    ${expected_plus_1}    ${event_description_txt}    ${priority_txt}    ${duration_value}

Check Event Timesptamp Is Visible
    [Arguments]    ${completed_timestamp_column}    ${expected_event_timestamp} 
    ${event_timestamp_column}    Set Variable    ${completed_timestamp_column}//preceding::td[2]
    ${event_timestamp_txt}    Wait Until Keyword Succeeds    30s    1s   Get Text    ${event_timestamp_column} 
    ${check_equal}    Run Keyword And Return Status    Should Be Equal    ${event_timestamp_txt}    ${expected_event_timestamp}
    IF    "${check_equal}" == "${False}" 
        ${expected_event_timestamp}    Handle Datetime Format    fmt={mm}/{dd}/{y} at {h}:{mi} {ampm}    dt=${expected_event_timestamp}    add_days=1
        Should Be Equal    ${event_timestamp_txt}    ${expected_event_timestamp}
    END

Check Patient Column In Patient Alerts List
    [Arguments]    ${completed_timestamp_column}    ${expected_patient_value}
    ${patient_column}    Set Variable    ${completed_timestamp_column}//preceding::td[4]//div
    ${patient_column_txt}    Wait Until Keyword Succeeds    30s    1s   Get Text    ${patient_column} 
    Should Be Equal    ${patient_column_txt}    ${expected_patient_value}

Check Event Column In Patient Alerts List
    [Arguments]    ${completed_timestamp_column}    ${expected_event_value}
    ${event_column}    Set Variable    ${completed_timestamp_column}//preceding::td[3]
    ${event_column_txt}    Wait Until Keyword Succeeds    30s    1s   Get Text    ${event_column} 
    Should Be Equal    ${event_column_txt}    ${expected_event_value}

Check Action Duration Column In Patient Alerts List
    [Arguments]    ${completed_timestamp_column}    ${expected_action_duration_value}
    ${action_duration}    Set Variable    ${completed_timestamp_column}//preceding::td[1]//label[input[@class="ActionDurationRadio" and @checked="checked"]]
    ${action_duration_txt}    Wait Until Keyword Succeeds    30s    1s   Get Text    ${action_duration} 
    Should Be Equal    ${action_duration_txt}    ${expected_action_duration_value} Min.

Check Reason Column In Patient Alerts List
    [Arguments]    ${completed_timestamp_column}    ${expected_reason_column_value}
    ${reason_column}    Set Variable    ${completed_timestamp_column}//preceding::td[1]//textarea
    ${reason_column_txt}    Wait Until Keyword Succeeds    30s    1s   Get Text    ${reason_column} 
    Should Be Equal    ${reason_column_txt}    ${expected_reason_column_value}

Check Completed Timesptamp Column In Patient Alerts List
    [Arguments]    ${expected_datetime}    ${expected_plus_1}    ${user_name_txt}
    ${completed_timestamp_value}    Set Variable    ${expected_datetime}
    ${completed_timestamp_column}    Set Variable     //td[normalize-space(.)='By: ${user_name_txt} ${completed_timestamp_value}']
    ${check_completed_timestamp_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${completed_timestamp_column}    5s
    IF    "${check_completed_timestamp_visible}" == "${False}"
        ${completed_timestamp_value}    Set Variable    ${expected_plus_1}
        ${completed_timestamp_column}    Set Variable     //td[normalize-space(.)='By: ${user_name_txt} ${completed_timestamp_value}']
        Wait Until Element Is Visible    ${completed_timestamp_column}    5s
    END
    RETURN    ${completed_timestamp_column}    ${completed_timestamp_value}
