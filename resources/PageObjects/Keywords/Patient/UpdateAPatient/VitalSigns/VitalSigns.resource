*** Settings ***
Resource    ../../../Layers/VitalSigns/VitalSigns.resource

*** Variables ***
${vital_signs_tab}    //a[@id='PastVitals']
${vital_sign_title}    //h3[contains(text(),'Vital Signs')]

*** Keywords ***
Open Vital Signs Tab
    Navigate To The Tab    
    ...    tab_name=${vital_signs_tab}    
    ...    title_name=${vital_sign_title}

Verify The Vital Sign Table Displays All Columns
    @{title_arg}    Create List    Date Taken    Blood Pressure    (mmHg)    Heart Rate    
    ...    (bpm)    Resp Rate    (per minute)    Temperature    Height    Weight    BMI
    ...    (kg/m²)    BSA    (m²)    SpO2    O2 Flow Rate    (L/min)
    FOR    ${header}    IN    @{title_arg}
        Element Should Be Visible    //th[contains(., '${header}')]    30s
        ${title_txt}    Get Text    //th[contains(., '${header}')]
        Should Contain    ${title_txt}    ${header}
    END

Verify The Vital Signs Lines Are Ordered By Decreasing DOS
    [Arguments]    ${loops}
    ${date_list}    Create List
    FOR    ${i}    IN RANGE    ${loops}
        ${i}    Evaluate    ${i}+1
        ${date}    Get Text    //th[contains(text(),'Date Taken')]//following::tr[${i}]//td[1]//div[1]
        ${date}    Convert Date    ${date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        Append To List    ${date_list}    ${date}
    END
    ${sorted_list}    Copy List    ${date_list}
    Sort List    ${sorted_list}
    Reverse List    ${sorted_list}
    Should Be Equal    ${date_list}    ${sorted_list}

Get Data In Vital Signs Tab
    [Arguments]    ${date_arg}
    Find Vital Sign Row    ${date_arg}
    ${date_taken_txt}    Get Date Taken Column    ${date_arg}    
    ${blood_pressure_txt}    Get Blood Pressure (mmHg) Column    ${date_arg}
    ${heart_rate_txt}    Get Heart Rate (bpm) Column    ${date_arg}
    ${respiratory_txt}    Get Resp Rate (per minute) Column    ${date_arg}
    ${temperature_txt}    Get Temperature Column    ${date_arg}
    ${height_txt}    Get Height Column    ${date_arg}
    ${weight_txt}    Get Weight Column    ${date_arg}
    ${bmi_txt}    Get BMI (kg/m²) Column    ${date_arg}
    ${bsa_txt}    Get BSA (m²) Column    ${date_arg}
    ${spo2_txt}    Get SpO2 Column    ${date_arg}
    ${o2_flow_rate_txt}    Get O2 Flow Rate (L/min) Column    ${date_arg}
    ${VitalSign_dict}    Create Vital Sign Dictionary
    Set To Dictionary    ${VitalSign_dict}
        ...    date_taken_txt=${date_taken_txt}
        ...    blood_pressure_txt=${blood_pressure_txt}
        ...    heart_rate_txt=${heart_rate_txt}
        ...    respiratory_txt=${respiratory_txt}
        ...    temperature_txt=${temperature_txt}
        ...    height_txt=${height_txt}
        ...    weight_txt=${weight_txt}
        ...    bmi_txt=${bmi_txt}
        ...    bsa_txt=${bsa_txt}
        ...    spo2_txt=${spo2_txt}
        ...    o2_flow_rate_txt=${o2_flow_rate_txt}
    RETURN    ${VitalSign_dict}

Compare Values Of Vital Signs Tab With Treatment Note Information
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    Compare Date Taken Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Blood Pressure Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Heart Rate Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Resp Rate Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Temperature Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Height Column    ${vital_sign_data}    ${expected_compare_data}
    Compare Weight Column    ${vital_sign_data}    ${expected_compare_data}
    # Compare BMI Column    ${vital_sign_data}    ${expected_compare_data}
    Compare BSA Column    ${vital_sign_data}    ${expected_compare_data}
    Compare SpO2 Column    ${vital_sign_data}    ${expected_compare_data}
    Compare O2 Flow Rate Column    ${vital_sign_data}    ${expected_compare_data}

Compare Date Taken Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${treatment_date_of_service_txt}    Convert Date    ${expected_compare_data.treatment_date_of_service_txt}    date_format=%m/%d/%y    result_format=%m/%d/%Y
    Should Be Equal    ${vital_sign_data.date_taken_txt}    ${treatment_date_of_service_txt}\nBy: ${expected_compare_data.recording_clinician_txt}

Compare Blood Pressure Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${blood_pressure}    Replace String    ${expected_compare_data.blood_pressure}    /    \n
    Should Be Equal    ${vital_sign_data.blood_pressure_txt}    ${blood_pressure}

Compare Heart Rate Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    Should Be Equal    ${vital_sign_data.heart_rate_txt}    ${expected_compare_data.heart_rate}

Compare Resp Rate Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    Should Be Equal    ${vital_sign_data.respiratory_txt}    ${expected_compare_data.respiratory} per minute

Compare Temperature Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${temperature_F}    Evaluate    str(${expected_compare_data.temperature}).rstrip('0').rstrip('.')
    ${temperature_C}    Evaluate    str(round((${expected_compare_data.temperature} - 32) * (5/9), 2)).rstrip('0').rstrip('.')
    Should Be Equal    ${vital_sign_data.temperature_txt}    ${temperature_F}°F\n${temperature_C}°C

Compare Height Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${height_cm}    Evaluate    f"{round(${expected_compare_data.assessment_height_value} * 2.54, 2):.2f}".rstrip('0').rstrip('.')    # 1 inch = 2.54 cm
    ${height_ft}    Replace String    ${expected_compare_data.assessment_height_ft_value}    ${SPACE}    ${EMPTY}
    ${height_inch}    Replace String    ${expected_compare_data.assessment_height_inch_value}    ${SPACE}    ${EMPTY}
    Should Be Equal    ${vital_sign_data.height_txt}    ${height_ft} ${height_inch}\n${height_cm}cm
    
Compare Weight Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${weight_lbs}    Evaluate    str(round(${expected_compare_data.assessment_weight_value} * 2.20462))    # 1 kg=2.20462 lbs
    Should Be Equal    ${vital_sign_data.weight_txt}    ${weight_lbs}lbs\n${expected_compare_data.assessment_weight_value}kg

Compare BMI Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${vital_sign_data.bmi_txt}    ${expected_compare_data.assessment_bmi_value}
    IF    '${check}' == '${False}'
        ${vital_bmi_txt}    Evaluate    str(round((${vital_sign_data.bmi_txt} - 0.01), 2))
        Should Be Equal    ${vital_bmi_txt}    ${expected_compare_data.assessment_bmi_value}
    END

Compare BSA Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    Should Be Equal    ${vital_sign_data.bsa_txt}    ${expected_compare_data.assessment_bsa_value}

Compare SpO2 Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    ${expected_spo2}    Evaluate    f"{float('${expected_compare_data.spo2}'):g}"
    Should Be Equal    ${vital_sign_data.spo2_txt}    ${expected_spo2}%

Compare O2 Flow Rate Column
    [Arguments]    ${vital_sign_data}    ${expected_compare_data}
    Should Be Equal    ${vital_sign_data.o2_flow_rate_txt}    ${expected_compare_data.oxygen}

Verify Vital Sign Is Created
    [Arguments]    ${date_arg}
    ${date_arg}    Convert Date    ${date_arg}    date_format=%m/%d/%y    result_format=%m/%d/%Y
    ${vital_sign_row}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//ancestor::tr
    Wait Until Element Is Visible    ${vital_sign_row}    30s

Verify Vital Signs Line Removed
    [Arguments]    ${date_arg}
    ${date_arg}    Convert Date    ${date_arg}    date_format=%m/%d/%y    result_format=%m/%d/%Y
    ${vital_sign_row}    Set Variable    //td[div[normalize-space(text())='${date_arg}']]//ancestor::tr
    Wait Until Element Is Not Visible    ${vital_sign_row}    30s
