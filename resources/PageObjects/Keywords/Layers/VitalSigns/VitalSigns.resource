*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***

*** Keywords ***
Create Vital Sign Dictionary
    &{VitalSign_dict}    Create Dictionary
    RETURN    ${VitalSign_dict}

Find Vital Sign Row
    [Arguments]    ${date_arg}
    ${vital_sign_row}    Set Variable    //tr[td[div[normalize-space(text())='${date_arg}']]]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${vital_sign_row}    2s
    IF    "${check}"=="${False}"
        Common.Scroll And Click Element    (//a[contains(text(),'Next')]/preceding::a[1])[1]
        Find Vital Sign Row    ${date_arg}
    END

Get Date Taken Column
    [Arguments]    ${date_arg}
    ${date_taken_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]
    ${date_taken_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${date_taken_column}
    RETURN    ${date_taken_txt}
    
Get Blood Pressure (mmHg) Column
    [Arguments]    ${date_arg}
    ${blood_pressure_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[1]
    ${blood_pressure_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${blood_pressure_column}
    RETURN    ${blood_pressure_txt}
    
Get Heart Rate (bpm) Column
    [Arguments]    ${date_arg}
    ${heart_rate_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[2]
    ${heart_rate_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${heart_rate_column}
    RETURN    ${heart_rate_txt}
    
Get Resp Rate (per minute) Column
    [Arguments]    ${date_arg}
    ${respiratory_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[3]
    ${respiratory_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${respiratory_column}
    RETURN    ${respiratory_txt}
    
Get Temperature Column
    [Arguments]    ${date_arg}
    ${temperature_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[4]
    ${temperature_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${temperature_column}
    RETURN    ${temperature_txt}
    
Get Height Column
    [Arguments]    ${date_arg}
    ${height_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[5]
    ${height_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${height_column}
    RETURN    ${height_txt}
    
Get Weight Column
    [Arguments]    ${date_arg}
    ${weight_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[6]
    ${weight_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${weight_column}
    RETURN    ${weight_txt}
    
Get BMI (kg/m²) Column
    [Arguments]    ${date_arg}
    ${bmi_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[7]
    ${bmi_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${bmi_column}
    RETURN    ${bmi_txt}
    
Get BSA (m²) Column
    [Arguments]    ${date_arg}
    ${bsa_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[8]
    ${bsa_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${bsa_column}
    RETURN    ${bsa_txt}
    
Get SpO2 Column
    [Arguments]    ${date_arg}
    ${spo2_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[9]
    ${spo2_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${spo2_column}
    RETURN    ${spo2_txt}
    
Get O2 Flow Rate (L/min) Column
    [Arguments]    ${date_arg}
    ${o2_flow_rate_column}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//following::td[10]
    ${o2_flow_rate_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${o2_flow_rate_column}
    RETURN    ${o2_flow_rate_txt}
    
