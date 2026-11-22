*** Settings ***
Resource    ../../../Layers/PatientAlerts/PatientAlerts.resource

*** Variables ***
${alert_tab}    //*[@id='PatientAlerts']
${alert_title}    //*[@id='PatientAlertsTab']//following::h3[contains(text(),'Patient Alerts')]

*** Keywords ***
Open Patient Alerts Tab
    Navigate To The Tab    
    ...    tab_name=${alert_tab}    
    ...    title_name=${alert_title}

Verify The Date Fomat Is MM/DD/YYYY In Patient Alerts
    ${start_date_txt}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${alert_startdate_input}    value
    ${is_valid_start}    Is Date In Format    ${start_date_txt}    %m/%d/%Y
    Should Be True    ${is_valid_start}
    ${end_date_txt}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${alert_enddate_input}    value
    ${is_valid_end}    Is Date In Format    ${end_date_txt}    %m/%d/%Y
    Should Be True    ${is_valid_end}

Is Date In Format
    [Arguments]    ${date_string}    ${format}
    ${status}    Run Keyword And Return Status
    ...    Convert Date    ${date_string}    result_format=datetime    date_format=${format}
    RETURN    ${status}

Check Patient Field Correct Information
    [Arguments]    ${expected_value}
    Wait Until Element Is Visible    ${alert_patient_input}    30s
    ${patient_value}    SeleniumLibrary.Get Element Attribute    ${alert_patient_input}    value
    Should Be Equal As Strings    ${patient_value}    ${expected_value}

Verify Dropdown Has Only Option
    [Arguments]    ${dropdown_locator}    ${option_locator}    ${expected_value}
    Click Element    ${dropdown_locator}
    ${options}    Get WebElements    ${option_locator}
    ${filtered}    Create List
    FOR    ${el}    IN    @{options}
        ${text}    Get Text    ${el}
        Run Keyword If    "${text}" != "" and not "select" in "${text.lower()}"    Append To List    ${filtered}    ${text}
    END 
    Length Should Be    ${filtered}    1
    Should Be Equal    ${filtered[0]}    ${expected_value}

Check Event Date Field Fomat
	${date_value}    SeleniumLibrary.Get Element Attribute   ${alert_event_date_input}   value
	${is_valid}    Is Date In Format    ${date_value}    %m/%d/%Y
    Should Be True    ${is_valid}

Check Error If Missing Field
    Click Save Patient Alert Button
    Common.Page Alert Message    You must select an Event Description.
    Select Event Description    selected_index=1
    Click Save Patient Alert Button
    Common.Page Alert Message    You must select a Priority.
    Select Priority    selected_index=1
    Click Action Duration Checkbox And Input Action Reason    duration_value_arg=other
    Element Should Be Disabled    ${alert_action_reason_input}
    Click Save Patient Alert Button
    Common.Page Alert Message    The Duration value must be a valid and positive number.

Input Required Field In PAlert Popup
    [Arguments]    ${dict_arg}
    Select Event Description    selected_index=1
	Select Priority    selected_index=1
    ${event_description_txt}    Get Selected List Label    ${alert_event_description_select}
    ${priority_txt}    Get Selected List Label    ${alert_priority_select}
    ${duration_value}    Random Action Duration Value
    Click Action Duration Checkbox    ${duration_value}
	Wait Until Element Is Enabled    ${alert_action_reason_input}    30s
    Set To Dictionary    ${dict_arg}    
    ...    event_description_txt=${event_description_txt}
    ...    priority_txt=${priority_txt}

Check Action Duration Options
    ${expected_list}    Create List    15 Min.    30 Min.    45 Min.    60 Min.    Other
    ${duration_list}    Get WebElements    //div[@id="ModalPopup"]//label[@class="radio-inline"]
    FOR    ${expected_value}    ${duration_value}    IN ZIP    ${expected_list}    ${duration_list}
        ${duration_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${duration_value}    
        Should Be Equal    ${expected_value}    ${duration_txt}    
    END

Input Over 255 Characters In Action Reason Input
    ${action_reason_txt}    Generate Random String    300    [LETTERS]
    Input Action Reason Input    ${action_reason_txt}
    Click Save Patient Alert Button
	Common.Page Alert Message    Patient Alert Created


Verify Textarea Allows Max 255 Characters In Reason Action Column
    Click Show Completed Checkbox
    ${action_reason_value}    Get Value    ${alert_action_reason_column}
	${action_reason_length}    Get Length    ${action_reason_value}
	Should Be Equal As Integers    ${action_reason_length}    255

Verify Completed Alerts Visible
    ${is_checked}    Check Show Completed Status
    IF    '${is_checked}' == '${False}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_show_completed_checkbox}
    END

Verify Completed Alerts Hide
    ${is_checked}    Check Show Completed Status
    IF    '${is_checked}' == '${True}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${alert_show_completed_checkbox}
    END

Check The Patient Column
    [Arguments]    ${expected_patient_information}
    Wait Until Element Is Visible    ${patient_column}    30s
    ${patient_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${patient_column}
    Should Be Equal As Strings    ${patient_column_txt}    ${expected_patient_information}

Check The Event Column
    [Arguments]    ${dict_arg}
    Wait Until Element Is Visible    ${event_column}    30s
    ${event_column_txt}    Get Text    ${event_column}
    Should Be Equal As Strings    ${event_column_txt}    ${dict_arg.event_description_txt}\nPriority: ${dict_arg.priority_txt}

Create Patient Alerts No Action Reason And Check Event Timstamp Value
    [Arguments]    ${utc}
    Select Event Description    selected_index=1
	Select Priority    selected_index=1
    ${expected_datetime}    ${expected_plus_1}    Get Current Date Time When Create Patient Alert    ${utc}
	Click Save Patient Alert Button
	Common.Page Alert Message    Patient Alert Created
    ${event_timestamp_txt}    Get Text    ${event_timestamp_column}
    ${is_equal}    Run Keyword And Return Status    Should Be Equal    ${event_timestamp_txt}    ${expected_datetime}
    IF    '${is_equal}' == '${False}'
        Should Be Equal    ${event_timestamp_txt}    ${expected_plus_1}
    END

Check Show Completed Status
    ${is_checked}    SeleniumLibrary.Get Element Attribute    ${alert_show_completed_checkbox}    checked
    RETURN    ${is_checked}

Check Confirm Button Disable
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${other_input}
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${other_textbox}    ${Fake_dict['decimal_2d_2f']}
    ${class}    SeleniumLibrary.Get Element Attribute    ${alert_confirm_btn}    class
    Should Contain    ${class}    disabled

Check Completed Timestamp Column Updated
    [Arguments]    ${utc}
    Click Element    (//*[@id="PatientAlertsList"]//following::input)[1]
	${long_text}    Generate Random String    100    [LETTERS]
	Input Text    ${alert_action_reason_column}    ${long_text}
    ${expected_datetime}    ${expected_plus_1}    Get Current Date Time When Create Patient Alert    ${utc}
    Click Confirm Patient Alert Button
    Common.Page Alert Message    Patient Alert Updated.
    Click Element    ${alert_show_completed_checkbox}
    Sleep    2s
    ${user_name_txt}    Common.Get User Name
    ${infor}    Get Text    //textarea[contains(text(),'${long_text}')]//ancestor::tr/td[5]
    ${is_equal}    Run Keyword And Return Status    Should Be Equal    ${infor}    By: ${user_name_txt}\n${expected_datetime}
    IF    '${is_equal}' == '${False}'
        Should Be Equal    ${infor}    By: ${user_name_txt}\n${expected_plus_1}
    END

Create Patient Alerts Successfully
    [Arguments]    ${utc}
    ${expected_datetime}    ${expected_plus_1}    Get Current Date Time When Create Patient Alert    ${utc}
    Select Event Description    selected_index=1
	Select Priority    selected_index=1
    ${duration_value}    Random Action Duration Value
    Click Action Duration Checkbox And Input Action Reason    ${duration_value}
    Click Save Patient Alert Button
	Common.Page Alert Message    Patient Alert Created

Check Filter Alerts Using Both Start Date And End Date
    ${start_date}    ${end_date}    Handle Data Timestamp
    Filter By Event Timestamp And Check Datepicker In Patient Alerts    ${start_date}    ${end_date}
    Click Element    ${alert_show_completed_checkbox}
    ${result_datetime}    Get Text    ${event_timestamp_column}
    ${date_event}    Fetch From Left    ${result_datetime}    \ at
    ${event_date_obj}     Convert Date    ${date_event}     result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${start_date_obj}     Convert Date    ${start_date}     result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${end_date_obj}       Convert Date    ${end_date}       result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${check_date}    Subtract Date From Date    ${event_date_obj}    ${start_date_obj}     result_format=number    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    Should Be True    ${check_date} > 0 
    ${check_date}    Subtract Date From Date    ${event_date_obj}    ${end_date_obj}     result_format=number    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    Should Be True    ${check_date} < 0