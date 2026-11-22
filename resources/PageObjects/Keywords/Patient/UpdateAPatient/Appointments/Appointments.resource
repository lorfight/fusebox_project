*** Settings ***
Resource    ../../../Layers/AppointmentOrderingLedger/AppointmentOrderingLedger.resource

*** Variables ***
${appointments_tab}    //a[@id='Appointment']

*** Keywords ***
Open Appointments Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${appointments_tab}
    Scroll And Click Element    ${appointments_tab}
    Wait Until Page Contains    Scheduled Appointments    30s

Get Frequency Of Lab Descirption In Patient Protocol Modal
    [Arguments]    ${apt_datetime}    ${lab_des_arg}
    Open Appointments Tab
    Open Patient Protocol Popup    ${apt_datetime}
    ${patient_protocol_frequency_value}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]
    ${patient_protocol_frequency_unit}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]
    ${patient_protocol_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${patient_protocol_frequency_value}
    ${patient_protocol_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${patient_protocol_frequency_unit}
    Click Close Patient Protocol Button
    RETURN    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}

Change Frequency Of Lab Descirption In Patient Protocol Modal
    [Arguments]    ${apt_datetime}    ${lab_des_arg}    ${dict_arg}
    Open Appointments Tab
    Open Patient Protocol Popup    ${apt_datetime}
    Click Edit Patient Protocol Button
    Select Frequency Value Of Lab Descirption In Patient Protocol Popup    ${lab_des_arg}    ${dict_arg}
    Select Frequency Unit Of Lab Descirption In Patient Protocol Popup    ${lab_des_arg}    ${dict_arg}
    Click Close Patient Protocol Button

Check Diagnosis Is Assigned To Patient In Appointment Tab
    [Arguments]    ${icdcode_arg}    ${apt_date_arg}
    Reload Page
    Open Appointments Tab
    ${apt_diagnosis}    Set Variable    (//strong[contains(text(),'${apt_date_arg}')]//following::a[contains(@onclick,'AssignICD10ToAppointmentModal')])[1]
    Common.Scroll And Click Element    ${apt_diagnosis}
    Wait Until Element Is Visible    //h4[contains(text(),'Assign Appointment DX Code')]
    ${apt_assign_dxcode_to_patient}    Set Variable    //div[@id='ICDModalList']//child::div[contains(text(),'Assigned To Patient')]//following::span[normalize-space(text())='${icdcode_arg}']
    Wait Until Element Is Visible    ${apt_assign_dxcode_to_patient}
    Common.Scroll And Click Element    //div[@id='SubModalPopup']//button[@id='CloseBtn' and contains(text(),'Close')]

