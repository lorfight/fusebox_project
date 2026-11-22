*** Settings ***
Resource    ../../../Layers/Allergies/Allergies.resource

*** Variables ***
${allergies_tab}    //a[@id='Allergy']

*** Keywords ***
Open Allergies Tab
    Navigate To The Tab    
    ...    tab_name=${allergies_tab}    
    ...    title_name=${allergies_new_btn}
    Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']

Add New Allergy
    [Arguments]    ${onset_date_arg}    ${allergies_detail_arg}    ${msg}
    ${allergy_dict}    Create Allergies Dictionary
    Open New Allergy Table
    Select Allergy Type Without Unknown Allergy    ${allergy_dict}
    Select An Allergy Description    ${allergy_dict}
    Input Onset Date    ${onset_date_arg}
    Select Allergy Severity    ${allergy_dict}
    Input Intolerance Reaction Details    ${allergies_detail_arg}
    Click Add Allergy Button
    Common.Page Alert Message    ${msg}
    Set To Dictionary    ${allergy_dict}
        ...    onset_date=${onset_date_arg}
        ...    allergies_detail=${allergies_detail_arg}
    RETURN    ${allergy_dict}

Verify All Fields Are Visible
    Wait Until Page Contains Element    ${allergies_type_select}    30s
    Wait Until Page Contains Element    ${allergies_description_select}    30s
    Wait Until Page Contains Element    ${allergies_onset_date_input}    30s
    Wait Until Page Contains Element    ${allergies_severity_select}    30s
    Wait Until Page Contains Element    ${allergies_detail_textarea}    30s

Verify All Fields Have Default Value
    [Arguments]    ${dict_arg}
    Verify Allergy Active Status Filrer Has Default Value
    Verify Allergy Type Select Has Default Value
    Verify Allergy Description Default Value    ${dict_arg}
    Verify Onset Date Input Has Default Value
    Verify Allergy Severity Select Has Default Value
    Verify Intolerance Reaction Details Input Has Default Value

Verify Allergy Active Status Filrer Has Default Value
    ${allergies_status_default}    Get Selected List Label    ${allergies_status_select}
    Should Be Equal    ${allergies_status_default}    Viewing Active - Allergies Only

Verify Allergy Type Select Has Default Value
    ${allergies_type_default}    Get Selected List Label    ${allergies_type_select}
    Should Be Equal    ${allergies_type_default}    -- Select an Allergy Type --

Verify Allergy Description Default Value
    [Arguments]    ${dict_arg}
    ${allergies_description_default}    Get Selected List Label    ${allergies_description_select}
    Should Be Equal    ${allergies_description_default}    -- Select an Allergy Type --
    Common.Choose Random Value From Select List    xpath_arg=${allergies_type_select}    var_name=allergies_type    dic=${dict_arg}
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    ${allergies_description_default}    Get Selected List Label    ${allergies_description_select}
    Should Be Equal    ${allergies_description_default}    -- Select an Allergy --

Verify Onset Date Input Has Default Value
    ${allergies_onset_date_default}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_onset_date_input}
    Should Be Equal    ${allergies_onset_date_default}    ${EMPTY}

Verify Allergy Severity Select Has Default Value
    ${allergies_severity_default}    Get Selected List Label    ${allergies_severity_select}
    Should Be Equal    ${allergies_severity_default}    -- Select the Severity of the Allergy --

Verify Intolerance Reaction Details Input Has Default Value
    ${allergies_detail_default}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_detail_textarea}
    Should Be Equal    ${allergies_detail_default}    ${EMPTY}
    
Verify "Select an Allergy Type" Dropdown Has Correct Values
    ${dropdown_options}    Create List    -- Select an Allergy Type --    Medication Allergy    Food Allergy    Environmental Allergy    Unknown Allergy
    ${allergy_type_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergy_type_options}

Verify "Select an Allergy Description" Dropdown Has Correct Values
    [Arguments]    ${dict_arg}
    Select Allergy Type Without Unknown Allergy    ${dict_arg}
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    ${allergies_description_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_description_select}
    ${lenght_total}    Get Length    ${allergies_type_select}
    Should Be True    ${lenght_total} > 2
    Should Contain    ${allergies_description_options}    [Add New Allergy]

Verify "Allergy Severity" Dropdown Has Correct Values
    ${dropdown_options}    Create List    -- Select the Severity of the Allergy --    Intolerant    Mild    Severe    Discomfort    Patient Preference
    ${allergy_type_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_severity_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergy_type_options}

Verify "Allergy Status" Dropdown Has Correct Values
    ${dropdown_options}    Create List    Viewing Active - Allergies Only    Viewing Inactive - Allergies Only    Viewing All Allergies
    ${allergies_status_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_status_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergies_status_options}

Verify System Prevents Duplicate Or Allergy Descriptions
    ${allergies_description_option_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_description_option}
    Open Create New Allergy Popup
    Click Create Allergy Button
    Common.Page Alert Message    You must enter an Allergy Description.
    Input Medication Allergy    ${allergies_description_option_txt}
    Click Create Allergy Button
    Common.Page Alert Message    Allergy Already Exists.
    Click Close New Allergy Popup

Verify New Allergy Is Visible In Allergies Table
    [Arguments]    ${column_value_list_arg}    ${allergies_row_arg}
    FOR    ${i}    IN RANGE    1    6
        Wait Until Element Is Visible    ${allergies_row_arg}//td[${i}]    30s
        ${column_txt}    Get Text    ${allergies_row_arg}//td[${i}]
        ${expected_value}    Set Variable    ${column_value_list_arg}[${i - 1}]
        Should Be Equal    ${column_txt}    ${expected_value}
    END

Inactive Allergy
    [Arguments]    ${allergy_detail_txt}    ${dict_arg}
    ${allergies_status_column_select}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//following::select[1]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_column_select}    Deactivate Allergy
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${allergies_deactive_title}    5s
    IF    "${check}" == "${True}"
        Wait Until Element Is Visible    ${allergies_deactive_reason_select}    30s
        ${current_day}    Get Current Date    result_format=%m/%d/%Y
        FOR    ${i}    IN RANGE    10
            Select Deactivation Reason    ${dict_arg}
            Input Deactivation Date    ${current_day}
            ${deactive_reason_select_txt}    Get Selected List Label    ${allergies_deactive_reason_select}
            ${allergies_deactive_date_txt}    Get Value    ${allergies_deactive_date_input}
            IF    '${deactive_reason_select_txt}' != '-- Select a Reason for Deactivating --' and '${allergies_deactive_date_txt}' != '${EMPTY}'
                Exit For Loop
            END
        END
        Click Deactive Allergy Button
        Common.Page Alert Message    Encounter Allergy Note Updated!
    END

Verify System Does Not Allow Reactivation
    [Arguments]    ${allergy_detail_txt}
    Filter Allergy Active Status    Viewing Inactive - Allergies Only
    ${allergies_new_row}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//parent::tr
    Wait Until Element Is Visible    ${allergies_new_row}    30s
    ${allergies_active_status_column_select}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//following::select[1]
    Wait Until Element Is Not Visible    ${allergies_active_status_column_select}    30s
    
Table Updates Both Active And Inactive Allergies When Filtering By Viewing All Allergies
    [Arguments]    ${allergy_active_detail_arg}    ${allergy_inactive_detail_arg}
    Filter Allergy Active Status    Viewing All Allergies
    ${allergies_active_status_column_select}    Set Variable    //td[contains(text(),"${allergy_active_detail_arg}")]//following::select[1]
    Wait Until Element Is Visible    ${allergies_active_status_column_select}    30s
    ${allergies_deactive_status_column_select}    Set Variable    //td[contains(text(),"${allergy_inactive_detail_arg}")]//following::span[1]
    Wait Until Element Is Visible    ${allergies_deactive_status_column_select}    30s
    
Edit Allergy And Updated Data Is Reflected In The Table 
    [Arguments]    ${allergy_detail_txt}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    sentence
    Open Created Allergy    ${allergy_detail_txt}
    Select Allergy Type Without Unknown Allergy    ${dict_arg}
    Select An Allergy Description    ${dict_arg}
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Input Onset Date    ${current_day}
    Select Allergy Severity    ${dict_arg}
    ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
    Input Intolerance Reaction Details    ${allergy_detail_txt}
    Click Add Allergy Button
    Common.Page Alert Message    Encounter Note Allergy Updated!
    ${column_value_list}    Create List    ${dict_arg.allergies_description}    ${dict_arg.allergies_type}    ${dict_arg.allergies_severity}    ${current_day}    ${allergy_detail_txt}
    ${allergies_new_row}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//parent::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}
