*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${alert_startdate_input}    //input[@id='AlertEventStartDate']
${alert_enddate_input}    //input[@id='AlertEventEndDate']
${alert_close_btn_calendar_btn}    //*[@type='button' and contains(@class,'datepicker') and text()='Done']
${alert_show_completed_checkbox}    //input[@id='ShowCompletedAlerts']
${create_patient_alert_btn}    //*[@id='PatientAlertsTab']//following::a[contains(text(),'Create Patient Alert')]
${create_patient_alert_title}    //h4[text()='Create Patient Alert']
${alert_patient_input}    //input[@id='ModalAlertPatientId']
${alert_clear_patient_btn}    //button[@id="ModalPatientAlertClearBtn"]
${alert_event_description_select}    //select[@id='AlertEventDescription']
${alert_event_description_select_option}    //select[@id='AlertEventDescription']//option
${alert_event_date_input}    //input[@id='ModalEventDate']
${alert_priority_select}    //select[@id='AlertPriority']
${alert_priority_select_option}    //select[@id='AlertPriority']//option
${other_modal_duration_input}    //input[@id='OtherModalDurationText']
${alert_action_reason_input}    //textarea[@id='ModalActionReason']
${alert_close_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
${alert_save_btn}    //*[@id='ModalPopup']//*[@id='SaveBtn' and text()='Save']
${alert_confirm_btn}    (//*[@id='PatientAlertsList']//following::a[contains(text(),'Confirm')])[1]
${alert_datepicker}    //*[@id='ui-datepicker-div']
${hide_alert}    (//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td//strong[contains(text(),'No Alerts Available')]
${alert_action_reason_column}    ((//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td[4]//following::textarea)[1]
${completed_timestamp_column}    ((//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td)[5]//span
${completed_timestamp_column_text}    ((//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[3]//td)[5]
${patient_column}    (((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[1]
${event_column}    (((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[2]
${event_timestamp_column}    (((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[3]
${other_input}    //input[@name='ActionDuration_0' and @data-val='other']
${other_textbox}    //input[@class='form-control ActionDurationValue']

*** Keywords ***
Created Patient Alerts Dictionary
    &{patientalerts_dict}    Create Dictionary
    RETURN    ${patientalerts_dict}

Filter By Event Timestamp And Check Datepicker In Patient Alerts
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Input Start Date In Timestamp    ${startdate_arg} 
    Input End Date In Timestamp    ${enddate_arg}

Input Start Date In Timestamp
    [Arguments]    ${startdate_arg}
    Wait Until Element Is visible    ${alert_startdate_input}    30s
    Common.Clear Input Field Until Empty    ${alert_startdate_input}
    Common.Input Text Into Field    ${alert_startdate_input}    ${startdate_arg}
    Common.Close Calendar Table
 
Input End Date In Timestamp
    [Arguments]    ${enddate_arg}
    Wait Until Element Is visible    ${alert_enddate_input}    30s
    Common.Clear Input Field Until Empty    ${alert_enddate_input}
    Common.Input Text Into Field    ${alert_enddate_input}    ${enddate_arg}
    Common.Close Calendar Table

Click Show Completed Checkbox
    Wait Until Element Is Visible    ${alert_show_completed_checkbox}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_show_completed_checkbox}

Open Create Patient Alert Popup
    Wait Until Element Is Visible    ${create_patient_alert_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_patient_alert_btn}
    Wait Until Element Is Visible    ${create_patient_alert_title}    30s

Input Patient In Create Patient Alert Modal
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    //div[@id="ModalPopup"]//strong[@class="tt-highlight" and text()='${mrn_arg}']//parent::div
        Click Clear Patient Alert Button
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${alert_patient_input}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    2s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            Exit For Loop
        END
    END
    
Click Clear Patient Alert Button
    Wait Until Element Is Visible    ${alert_clear_patient_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_clear_patient_btn}

Select Event Description
    [Arguments]    ${selected_index}
    Wait Until Element Is Visible    ${alert_event_description_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${alert_event_description_select}    ${selected_index}
    ${event_description_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${alert_event_description_select}
    RETURN    ${event_description_txt}

Input Event Date
    [Arguments]    ${date_arg}
    Common.Clear Input Field Until Empty    ${alert_event_date_input}
    Common.Input Text Into Field    ${alert_event_date_input}    ${date_arg}
    Common.Close Calendar Table

Select Priority
    [Arguments]    ${selected_index}
    Wait Until Element Is Visible    ${alert_priority_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${alert_priority_select}    ${selected_index}
    ${priority_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${alert_priority_select}
    RETURN    ${priority_txt}

Random Action Duration Value
    ${duration_list}    Create List    15    30    45    60
    ${duration_value}    Evaluate    random.choice(${duration_list})
    RETURN    ${duration_value}

Click Action Duration Checkbox
    [Arguments]    ${duration_value_arg}
    ${action_duration_checkbox}    Set Variable    //input[@name='ModalDuration' and @data-val='${duration_value_arg}']    # 15    30    45    60    other
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${action_duration_checkbox}

Input Modal Duration Text Input
    [Arguments]    ${other_duration_txt}
    Wait Until Element Is Enabled    ${other_modal_duration_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${other_modal_duration_input}    ${other_duration_txt}

Input Action Reason Input
    [Arguments]    ${action_reason_txt}
    Wait Until Element Is Enabled    ${alert_action_reason_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${alert_action_reason_input}    ${action_reason_txt}

Click Action Duration Checkbox And Input Action Reason
    [Arguments]    ${duration_value_arg}
    Click Action Duration Checkbox    ${duration_value_arg}
    IF    '${duration_value_arg}' == 'other'
        ${Fake_dict}    Generate Fake Data    decimal_2d_2f
        ${other_duration_txt}    Set Variable    ${Fake_dict['decimal_2d_2f']}
        Input Modal Duration Text Input    ${other_duration_txt}
    ELSE
        ${action_reason_txt}    Generate Random String    255    [LETTERS]
	    Input Action Reason Input    ${action_reason_txt}
    END

Click Save Patient Alert Button
    Wait Until Element Is Visible    ${alert_save_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_save_btn}

Click Close Patient Alert Button
    Wait Until Element Is Visible    ${alert_close_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_close_btn}

Click Confirm Patient Alert Button
    Wait Until Element Is Visible    ${alert_confirm_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_confirm_btn}

Handle Data Timestamp
    ${current_date}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}    Subtract Time From Date    ${current_date}    2 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${current_date}    2 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    RETURN    ${start_date}    ${end_date}

Get Current Date Time When Create Patient Alert
    [Arguments]    ${utc}
    ${expected_datetime}    Handle Datetime Format    fmt={mm}/{dd}/{y} at {h}:{mi} {ampm}    utc=${utc}
    ${expected_plus_1}    Handle Datetime Format    fmt={mm}/{dd}/{y} at {h}:{mi} {ampm}    dt=${expected_datetime}    add_minutes=1
    RETURN    ${expected_datetime}    ${expected_plus_1}