*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${queue_filter_by_location}    //select[@id="SelectedLocationID"]
${queue_filter_by_patient}    //input[@id="AppointmentQueuePatientId"]
${queue_filter_by_ordering_provider}    //input[@id="SelectedOrderingProvider"]
${queue_filter_by_medication}    //select[@id="SelectedAlertQueueMedication"]
${queue_filter_by_alert_type}    //select[@id="SelectedAlertType"]
${queue_show_cleared_alerts_checkbox}    //input[@id="ClearAlerts"]
${queue_seach_btn}    //a[contains(@class,'SearchSchedulingQueueBtn')]
${queue_clear_patient_filter}    //button[contains(@class,'SchedulingQueuePatientClearButton')]
${queue_clear_ordering_provider_filter}    //button[contains(@class,'OrderingProviderClearButton')]
${queue_clear_medication_filter}    //button[contains(@class,'SchedulingQueueMedClearButton')]
${queue_clear_alert_type_filter}    //button[contains(@class,'SchedulingQueueAlertClearButton')]

*** Keywords ***
Go To Appointment Scheduling Queue
    Common.Scroll And Click Element    link: Administration
    Common.Scroll And Click Element    link: Appointment Scheduling Queue
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Appointment Scheduling Queue

Filter By Location In Appointment Scheduling Queue Page
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${queue_filter_by_location}    ${location_arg}

Filter By Patient In Appointment Scheduling Queue Page
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    //strong[@class="tt-highlight" and text()='${mrn_arg}']//parent::div
        Click Clear Patient Button
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${queue_filter_by_patient}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    2s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            Exit For Loop
        END
    END

Click Clear Patient Button
    Common.Scroll And Click Element    ${queue_clear_patient_filter}

Filter By Ordering Provider In Appointment Scheduling Queue Page
    [Arguments]    ${ordering_provider_arg}
    Click Clear Ordering Provider Button
    ${ordering_provider_selected}    Set Variable    //strong[@class="tt-highlight" and text()='${ordering_provider_arg}']//parent::div
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${queue_filter_by_ordering_provider}    ${ordering_provider_arg}
    Wait Until Element Is Visible    ${ordering_provider_selected}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${ordering_provider_selected}

Click Clear Ordering Provider Button
    Common.Scroll And Click Element    ${queue_clear_ordering_provider_filter}

Filter By Medication In Appointment Scheduling Queue Page
    [Arguments]    ${medication_arg}
    Click Clear Medication Button
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${queue_filter_by_medication}    ${medication_arg}

Click Clear Medication Button
    Common.Scroll And Click Element    ${queue_clear_medication_filter}

Filter By Alert Type In Appointment Scheduling Queue Page
    [Arguments]    ${alert_type_arg}
    Click Clear Alert Type Button
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${queue_filter_by_alert_type}    ${alert_type_arg}

Click Clear Alert Type Button
    Common.Scroll And Click Element    ${queue_clear_alert_type_filter}

Click Show Cleared Alerts Checkbox
    Common.Scroll And Click Element    ${queue_show_cleared_alerts_checkbox}
    
Click Search Button
    Common.Scroll And Click Element    ${queue_seach_btn}

Open Schedule Appointment Button In Appointment Scheduling Queue Page
    [Arguments]    ${mrn_arg}
    ${schedule_appointment_btn}    Set Variable    //div[normalize-space(.)='MRN: ${mrn_arg}']//following::a[@title="Schedule Appointment"]
    Common.Scroll And Click Element    ${schedule_appointment_btn}

