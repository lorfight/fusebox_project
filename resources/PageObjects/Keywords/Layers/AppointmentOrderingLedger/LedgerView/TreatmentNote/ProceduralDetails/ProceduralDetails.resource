*** Settings ***
Resource    ../../../../Common/Common.resource

*** Variables ***
${procedural_details_tab}    //a[contains(text(),'Procedural Details')]
${procedural_details_title}    //h2[@id='ProceduralDetailsTitleHeader']
${procedural_regimen_select}    //select[@id="RegimenTreatmentNote"]
${procedural_max_rate_input}     //input[@id='maxDrip']
${procedural_time_input}    (//div[@class="EncounterNoteTableDiv"]//following-sibling::input[@id='NoteTime' and @data-record!='' and @data-record!='Reaction'])[last()]
${treatmentnote_delete_btn_popup}    //span[contains(text(),'Delete')]//parent::button
${alert_msg}    //span[@data-notify="message"]

*** Keywords ***
Create Procedural Details Dictionary
    &{ProceduralDetails_dict}    Create Dictionary
    RETURN    ${ProceduralDetails_dict}

Go To Procedural Details
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${procedural_details_tab}
    Wait Until Element Is Visible    ${procedural_details_title}    30s

Select Regimen
    [Arguments]    ${regimen_arg}
    Wait Until Element Is Enabled    ${procedural_regimen_select}    30s
    Select From List By Label    ${procedural_regimen_select}    ${regimen_arg}

Input Max Rate
    [Arguments]    ${max_rate_arg}
    Wait Until Element Is Visible    ${procedural_max_rate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_max_rate_input}    ${max_rate_arg}
    Press Keys    None    TAB
    Common.Page Alert Message    Updated successfully!

Input Time
    ${note_time_value}    Evaluate    f"{random.randint(0,23):02d}{random.randint(0,59):02d}"    modules=random
    Wait Until Element Is Visible    ${procedural_time_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_time_input}    ${note_time_value}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}
    RETURN    ${note_time_value}

Get Time Value
    Wait Until Element Is Visible    ${procedural_time_input}    30s
    ${note_time_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${procedural_time_input}
    RETURN    ${note_time_value}

Select Recording Clinician
    [Arguments]    ${note_time_arg}    ${recording_clinician_arg}
    ${procedural_recording_clinician_select}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/select[@id='SelectedPhysicalMeasurementUser' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Enabled    ${procedural_recording_clinician_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${procedural_recording_clinician_select}    ${recording_clinician_arg}
    Common.Element Is Not Visible    ${alert_msg}

Get Recording Clinician Value
    [Arguments]    ${note_time_arg}
    ${procedural_recording_clinician_select}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/select[@id='SelectedPhysicalMeasurementUser' and @data-record!='' and @data-record!='Reaction']
    ${recording_clinician_txt}    Get Selected List Label    ${procedural_recording_clinician_select}
    RETURN    ${recording_clinician_txt}

Choose IV Site OK
    [Arguments]    ${note_time_arg}    ${status_arg}
    IF    "${status_arg}" == 'yes'
        ${yes_checkbox}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[contains(@class,'IvSiteOkRecommended')]
        Common.Scroll And Click Element    ${yes_checkbox}
    ELSE IF    "${status_arg}" == 'no'
        ${no_checkbox}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[contains(@class,'IvSiteOkNotRecommended')]
        Common.Scroll And Click Element    ${no_checkbox}
    END
    Common.Element Is Not Visible    ${alert_msg}

Choose Infusing On Pump
    [Arguments]    ${note_time_arg}    ${status_arg}
    IF    "${status_arg}" == 'yes'
        ${yes_checkbox}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[contains(@class,'IsInfusingOnPumpRecommended')]
        Common.Scroll And Click Element    ${yes_checkbox}        
    ELSE IF    "${status_arg}" == 'no'
        ${no_checkbox}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[contains(@class,'InfusingOnPumpNotRecommended')]
        Common.Scroll And Click Element    ${no_checkbox}        
    END
    Common.Element Is Not Visible    ${alert_msg}

Input Drip Rate    # format = xxx.xxx
    [Arguments]    ${note_time_arg}    ${drip_rate_arg}
    ${procedural_drip_rate_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='DripRate' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_drip_rate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_drip_rate_input}    ${drip_rate_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input Blood Pressure (mmHg)    # format = xxx/xxx
    [Arguments]    ${note_time_arg}    ${blood_pressure_arg}
    ${procedural_blood_pressure_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='BloodPressure' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_blood_pressure_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_blood_pressure_input}    ${blood_pressure_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input Heart Rate (bpm)    # format = xxx
    [Arguments]    ${note_time_arg}    ${heart_rate_arg}
    ${procedural_heart_rate_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='HeartRate' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_heart_rate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_heart_rate_input}    ${heart_rate_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input Temp (F)    # format = xxx.xx
    [Arguments]    ${note_time_arg}    ${temperature_arg}
    ${procedural_temperature_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='Temp' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_temperature_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_temperature_input}    ${temperature_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input Respiratory Rate    # format = xxx
    [Arguments]    ${note_time_arg}    ${respiratory_rate_arg}
    ${procedural_respiratory_rate_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='RespRate' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_respiratory_rate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_respiratory_rate_input}    ${respiratory_rate_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input SPO2 %    # format = xxx.xx
    [Arguments]    ${note_time_arg}    ${spo2_arg}
    ${procedural_spo2_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='SPO2' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_spo2_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_spo2_input}    ${spo2_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Input Oxygen (L/min)    # format = xx
    [Arguments]    ${note_time_arg}    ${oxygen_arg}
    ${procedural_oxygen_input}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/input[@id='SelectedOxygen' and @data-record!='' and @data-record!='Reaction']
    Wait Until Element Is Visible    ${procedural_oxygen_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${procedural_oxygen_input}    ${oxygen_arg}
    Press Keys    None    TAB
    Common.Element Is Not Visible    ${alert_msg}

Select 02 Delivery Method
    [Arguments]    ${note_time_arg}    ${dict_arg}    ${delivery_method_arg}=random
    ${procedural_delivery_method_select}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/select[@id='SelectedDeliveryMethod' and @data-record!='' and @data-record!='Reaction']
    IF    "${delivery_method_arg}" != "random"
        Wait Until Element Is Enabled    ${procedural_delivery_method_select}    30s
        Select From List By Label    ${procedural_delivery_method_select}    ${delivery_method_arg}
    ELSE
        Common.Choose Random Value From Select List    xpath_arg=${procedural_delivery_method_select}    var_name=delivery_method    dic=${dict_arg}
    END
    Common.Element Is Not Visible    ${alert_msg}

Click Delete Action
    [Arguments]    ${note_time_arg}
    ${procedural_delete_btn}    Set Variable    //td[input[@id="NoteTime" and @value="${note_time_arg}"]]//following-sibling::td/a[contains(@onclick,'RemoveMeasurementAndReactionRow') and not(contains(@onclick,"this,'',''"))]
    Common.Scroll And Click Element    ${procedural_delete_btn}
    Wait Until Page Contains    Do you want to delete this vital line?    30s
    Common.Scroll And Click Element    ${treatmentnote_delete_btn_popup}
    Common.Page Alert Message    The line has been deleted successfully.

Input Data In Procedural Details
    [Arguments]    ${drip_rate_arg}   ${blood_pressure_arg}    ${heart_rate_arg}    ${temperature_arg}    ${respiratory_rate_arg}    ${spo2_arg}    ${oxygen_arg}    ${delivery_method_arg}
    Go To Procedural Details
    ${ProceduralDetails_dict}    Create Procedural Details Dictionary
        ${note_time_value}    Get Time Value
        ${recording_clinician_txt}    Get Recording Clinician Value    ${note_time_value}
        Choose IV Site OK    ${note_time_value}    yes
        Choose Infusing On Pump    ${note_time_value}    yes
        Input Drip Rate    ${note_time_value}    ${drip_rate_arg}
        Input Blood Pressure (mmHg)    ${note_time_value}    ${blood_pressure_arg}
        Input Heart Rate (bpm)    ${note_time_value}    ${heart_rate_arg}
        Input Temp (F)    ${note_time_value}    ${temperature_arg}
        Input Respiratory Rate    ${note_time_value}    ${respiratory_rate_arg}
        Input SPO2 %    ${note_time_value}    ${spo2_arg}
        Input Oxygen (L/min)    ${note_time_value}    ${oxygen_arg}
        Select 02 Delivery Method    ${note_time_value}    ${ProceduralDetails_dict}    ${delivery_method_arg}
    Set To Dictionary    ${ProceduralDetails_dict}    
        ...    note_time_value=${note_time_value}    
        ...    recording_clinician_txt=${recording_clinician_txt}    
        ...    drip_rate=${drip_rate_arg}    
        ...    blood_pressure=${blood_pressure_arg}    
        ...    heart_rate=${heart_rate_arg}    
        ...    temperature=${temperature_arg}    
        ...    respiratory=${respiratory_rate_arg}    
        ...    spo2=${spo2_arg}
        ...    oxygen=${oxygen_arg}
    RETURN    ${ProceduralDetails_dict}
