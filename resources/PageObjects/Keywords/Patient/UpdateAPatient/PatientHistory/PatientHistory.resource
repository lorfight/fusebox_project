*** Settings ***
Resource    ../../../Layers/Common/Common.resource

*** Keywords ***
Open Patient History Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    //a[@id="PatientHistoryTreatment"]
    Scroll And Click Element    //a[@id="PatientHistoryTreatment"]
    Wait Until Element Is Visible    //h2[contains(text(),"Summary of All Treatments")]    30s

Get Data From Summary Of All Treatments Table
    [Arguments]    ${med_arg}
    ${history_primary_med_column}    Set Variable    //span[text()="${med_arg}"]
    ${treatment_list}    Create List  
    ${treatment_column_list}    Create List    
        ...    ${history_primary_med_column}//preceding::td[1]
        ...    ${history_primary_med_column}//following::td[1]
        ...    ${history_primary_med_column}//following::td[2]
        ...    ${history_primary_med_column}//following::td[3]
        ...    ${history_primary_med_column}//following::td[4]
        ...    ${history_primary_med_column}//following::td[5]
        ...    ${history_primary_med_column}//following::td[6]
        ...    ${history_primary_med_column}//following::td[7]
        ...    ${history_primary_med_column}//following::td[8]
        ...    ${history_primary_med_column}//following::td[9]
        ...    ${history_primary_med_column}//following::td[10]
        ...    ${history_primary_med_column}//following::td[11]
    
    FOR    ${treatment_column}    IN    @{treatment_column_list}
        ${treatment_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${treatment_column}
        Append To List    ${treatment_list}    ${treatment_column_txt}
    END
    RETURN    ${treatment_list}

Expand Encounter Summary Table
    [Arguments]    ${med_arg}
    ${show_encounter_btn}    Set Variable    //span[text()="${med_arg}"]//preceding::a[contains(@id,"ShowEncounterSummaryBtn")][1]
    SeleniumLibrary.Element Text Should Be    ${show_encounter_btn}    Expand
    Common.Scroll And Click Element    ${show_encounter_btn}
    Wait Until Element Is Visible    //h2[contains(text(),"Encounter Summary")]    30s
    SeleniumLibrary.Element Text Should Be    ${show_encounter_btn}    Hide

Calculate Treatment Row Total In Encounter Table
    ${row_total}    SeleniumLibrary.Get Element Count    //div[contains(@id,"EncounterSummaryList")]//child::tbody//tr
    ${row_total}    Convert To String   ${row_total}
    RETURN    ${row_total}

Get Data From Treatment Row In Encounter Table
    [Arguments]    ${row_arg}    ${list_arg}
    ${date_os_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[3]
    ${mg_per_kg_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[5]
    ${calc_dose_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[6]
    ${pain_level_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[10]
    Set To Dictionary    ${list_arg}    
        ...    date_os_value=${date_os_value}
        ...    mg_per_kg_value=${mg_per_kg_value}
        ...    calc_dose_value=${calc_dose_value}
        ...    pain_level_value=${pain_level_value}
    RETURN    ${list_arg}

Verify All Column In Summary Of All Treatments Table
    [Arguments]    ${treatment_list}    ${first_row_list}    ${last_row_list}    ${row_total}
    ${compare_list}    Create List    
    ...    Active
    ...    ${row_total}
    ...    ${first_row_list.date_os_value}
    ...    ${first_row_list.calc_dose_value}
    ...    ${first_row_list.mg_per_kg_value}mg/kg
    ...    ${first_row_list.pain_level_value}
    ...    ${last_row_list.date_os_value}
    ...    ${last_row_list.calc_dose_value}
    ...    ${last_row_list.mg_per_kg_value}mg/kg
    ...    ${last_row_list.pain_level_value}
    ...    N/A
    ...    N/A
    FOR    ${treatment_column}    ${compare_value}    IN ZIP    ${treatment_list}    ${compare_list}
        Should Be Equal    ${treatment_column}    ${compare_value}
    END

Click View Appointment Button In Patient History
    [Arguments]    ${date_arg}
    ${encounter_view_apt_btn}    Set Variable    (//div[contains(@id,"EncounterSummaryList")]//following::span[contains(text(),"${date_arg}")])//following::td[11]
    Common.Scroll And Click Element    ${encounter_view_apt_btn}
    Wait Until Element Is Visible    //h4[contains(text(),"Dispense Medication To Patient")]    30s

Get Encounter Summary Treatment Data
    [Arguments]    ${apt_date_arg}    ${med_arg}
    Open Patient History Tab
    Expand Encounter Summary Table    med_arg=${med_arg}
    ${date_os_column}    Set Variable    //div[contains(@id,"EncounterSummaryList")]//following::span[contains(text(),"${apt_date_arg}")]
    ${encounter_list}    Create Dictionary
    ${encounter_name_list}    Create List    
        ...    encounter_dxcode_column
        ...    encounter_weight_column
        ...    encounter_mg_per_kg_column
        ...    encounter_calc_dose_column
        ...    encounter_actual_dose_column
        ...    encounter_dose_frequency_column
        ...    encounter_access_site_column
        ...    encounter_pain_level_column
        ...    encounter_reaction_column
        ...    encounter_lenght_column
        ...    encounter_caregiver_column
    ${encounter_xpath_list}    Create List
        ...    (${date_os_column})//preceding::td[1]
        ...    (${date_os_column})//following::td[1]
        ...    (${date_os_column})//following::td[2]
        ...    (${date_os_column})//following::td[3]
        ...    (${date_os_column})//following::td[4]
        ...    (${date_os_column})//following::td[5]
        ...    (${date_os_column})//following::td[6]
        ...    (${date_os_column})//following::td[7]
        ...    (${date_os_column})//following::td[8]
        ...    (${date_os_column})//following::td[9]
        ...    (${date_os_column})//following::td[10]

    FOR    ${encounter_name}    ${encounter_xpath}    IN ZIP    ${encounter_name_list}    ${encounter_xpath_list}
        ${encounter_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${encounter_xpath}
        Set To Dictionary    ${encounter_list}    ${encounter_name}=${encounter_value}
    END
    RETURN    ${encounter_list}

Compare Encounter Summary Data With Treatment Note Data
    [Arguments]    ${encounter_list}    ${appointment_dict}    ${provider_dict}
    # DX Code
    Should Be Equal    ${appointment_dict.assigned_dxcode_txt}    ${encounter_list.encounter_dxcode_column}
    # Weight (kg)
    Should Be Equal    ${appointment_dict.patient_weight_txt}    ${encounter_list.encounter_weight_column}
    # mg/kg
    ${mg_per_kg_calculated}    Evaluate    round((${appointment_dict.quantity_therapy_value} / ${appointment_dict.patient_weight_txt}),2)
    Should Be Equal As Strings   ${mg_per_kg_calculated}    ${encounter_list.encounter_mg_per_kg_column}
    # Calc Dose
    Should Be Equal    ${appointment_dict.quantity_therapy_value}mg    ${encounter_list.encounter_calc_dose_column}
    # Actual Dose
    Should Be Equal    ${appointment_dict.base_qty_txt}mg    ${encounter_list.encounter_actual_dose_column}
    # Dose Frequency
    Should Be Equal    ${appointment_dict.unit_therapy_value} Every ${provider_dict.frequency_value} ${provider_dict.frequency_time}    ${encounter_list.encounter_dose_frequency_column}
    # Access Site
    Should Be Equal    N/A    ${encounter_list.encounter_access_site_column}
    # Reported Pain Level
    ${pain_scale_column}    Get Regexp Matches    ${appointment_dict.apt_pain_scale_select}    \\d+
    Should Be Equal    ${pain_scale_column}[0] of 10    ${encounter_list.encounter_pain_level_column}
    # Reaction (Y/N)
    Should Be Equal    N    ${encounter_list.encounter_reaction_column}
    # Encounter Length
    Should Contain    ${encounter_list.encounter_lenght_column}    ${appointment_dict.treatment_duration_value}    
    # Caregiver
    Should Contain    ${encounter_list.encounter_caregiver_column}    ${appointment_dict.treatment_clinician_value}
