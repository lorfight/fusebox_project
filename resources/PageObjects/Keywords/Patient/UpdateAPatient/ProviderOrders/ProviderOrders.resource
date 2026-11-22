*** Settings ***
Resource    ../../../Layers/ProviderOrders/ProviderOrders.resource

*** Variables ***

*** Keywords ***
Open Provider Orders Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    //a[@id='PhysicianOrder']
    Common.Scroll And Click Element    //a[@id='PhysicianOrder']
    Wait Until Element Is Visible    //h2[contains(text(),'Provider Orders')]    30s
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-4x fa-spin"]

Unassign Required Lab Descirption In PO Popup
    [Arguments]    ${po_num}    ${assign_lab_txt}
    Open Provider Orders Tab
    Click Edit PO    ${po_num}
    ${po_assign_lab_input}    Set Variable    //strong[contains(text(),'${assign_lab_txt}')]//preceding::input[contains(@class,'AssignAccountLab')][1]
    Common.Scroll And Click Element    ${po_assign_lab_input}
    Page Alert Message    Lab has been updated.
    Click Close Provider Order Popup

Assign Required Lab Descirption In PO Popup
    [Arguments]    ${po_num}    ${assign_lab_txt}
    Open Provider Orders Tab
    Click Edit PO    ${po_num}
    Click Show Quick View Button In PO Popup
    ${po_assign_lab_input}    Set Variable    //strong[contains(text(),'${assign_lab_txt}')]//preceding::input[contains(@class,'ProtocolAssignLabCheckbox')][1]
    Common.Scroll And Click Element    ${po_assign_lab_input}
    Page Alert Message    Lab has been assigned.
    Click Close Provider Order Popup

Get Frequency Of Lab Descirption In Provider Order Modal
    [Arguments]    ${po_num}    ${lab_des_arg}
    Open Provider Orders Tab
    Click Edit PO    ${po_num}
    ${po_lab_frequency_value}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]
    ${po_lab_frequency_unit}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${po_lab_frequency_value}
    ${po_lab_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${po_lab_frequency_value}
    ${po_lab_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${po_lab_frequency_unit}
    Click Close Provider Order Popup
    RETURN    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}

Change Frequency Of Lab Descirption In Provider Order Modal
    [Arguments]    ${po_num}    ${lab_des_arg}    ${dict_arg}
    Open Provider Orders Tab
    Click Edit PO    ${po_num}
    Select Frequency Value Of Lab Descirption In PO Popup    ${lab_des_arg}    ${dict_arg}
    Select Frequency Unit Of Lab Descirption In PO Popup    ${lab_des_arg}    ${dict_arg}
    Click Close Provider Order Popup

Ordering Location Field Has Default Value
    [Arguments]    ${default_location}    ${expected_location_list}
    ${ordering_location_button}    Set Variable    //button[@data-id='ModalAccountID']/span[@class='filter-option pull-left']
    SeleniumLibrary.Element Text Should Be    ${ordering_location_button}    ${default_location}
    ${locations_default}    Get List Items  ${ordering_location_select}
    Lists Should Be Equal    ${locations_default[1:]}    ${expected_location_list[1:]}

Select A Patient Field Has Default Value
    [Arguments]    ${default_patient_info}
    ${patient_value}    SeleniumLibrary.Get Element Attribute    ${select_patient}    value
    Should Be Equal    ${patient_value}    ${default_patient_info}

Verify Diagnosis Dropdown Shows Two ICD Sections After Drug Selected
    [Arguments]    ${drug_arg}
    ${primary_icdcode_txt}    Set Variable    //button[@data-id='PrimaryICDCode']/span[@class='filter-option pull-left']
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${primary_icdcode_txt}    -- Select A Primary Medication --
    Select Treatment Drug    ${drug_arg}
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${primary_icdcode_txt}    -- Select an ICD Code --
    ${medication_icdcode_txt}    Set Variable    //*[@id='InitialIcd10CodeSelectSection']//following::span[contains(text(),'Medication ICD Codes')]
    ${assigned_to_patient_txt}    Set Variable    //*[@id='InitialIcd10CodeSelectSection']//following::span[contains(text(),'Assigned to Patient')]
    Click Button    //button[@data-id='PrimaryICDCode']
    Wait Until Element Is Visible    ${medication_icdcode_txt}    30s
    Wait Until Element Is Visible    ${assigned_to_patient_txt}    30s
    Click Button    //button[@data-id='PrimaryICDCode']
    
Verify PO Default Dates
    ${start_date}    Get Value    //*[@id='OrderDate']
    ${exp_date}    Get Value    //*[@id='ExpirationDate']
    ${today}    CustomLibrary.Get Time Now
    ${today}    Convert Date    ${today}    result_format=%m/%d/%Y
    ${today}    Handle Datetime Format    fmt={m}/{d}/{y}    dt=${today}
    ${one_year_later}    Handle Datetime Format    fmt={m}/{d}/{y}    dt=${today}    add_days=364
    Should Be Equal As Strings    ${start_date}    ${today}    Start date should default to today
    Should Be Equal As Strings    ${exp_date}    ${one_year_later}    Expiration date should be 1 year from today

Verify Primary Diagnosis Auto Filled
    [Arguments]    ${diagnosis_arg}
    Wait Until Element Is Visible    //strong[@id='DiagnosisDispaly']    30s
    SeleniumLibrary.Element Text Should Be    //strong[@id='DiagnosisDispaly']    ${diagnosis_arg}

Verify Referral Source Dropdown Options
    ${expected_options}    Create List    In Office    Outside Physician    Affiliate / Partner Company
    # Wait Until Keyword Succeeds    30s    1s    Click Element    ${referral_source_select}
    ${actual_options}    Get List Items   ${referral_source_select}
    Lists Should Be Equal    ${actual_options}    ${expected_options}

Verify Office Visit Frequency Dropdowns
    ${expected_units}    Create List    -    Week(s)    Month(s)    Year(s)    Day(s)
    ${unit_options}    Get List Items    ${visit_frequency_select}
    Lists Should Be Equal    ${unit_options}    ${expected_units}
    ${visit_frequency_value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${visit_frequency_value_select}
    ${actual_list}    Evaluate    [int(i) for i in ${visit_frequency_value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 100))
    Should Be Equal    ${visit_frequency_value_list[0]}    -
    Lists Should Be Equal    ${actual_list}    ${expected_list}

Verify Place Of Service Dropdown Options
    ${expected_options}    Create List    -- Select a Place of Service --    In Office    Patient Address (Patient Home)    Alternate Office
    ${actual_options}    Get List Items    ${place_of_service}
    Lists Should Be Equal    ${actual_options}    ${expected_options}

Check Supporting Documentation section Has Fields Group
    [Arguments]    ${status_arg}
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Contains    ${view_document_btn}    View Documentation    5s
    IF    '${check_visible}' == '${True}'
        Common.Scroll And Click Element    ${view_document_btn}
        Wait Until Element Contains    ${view_document_btn}    Hide Documentation    5s
    END
    Check Elements Visible    ${document_list}    ${question_doc_select}
    IF    "${status_arg}" == "view po"
        Element Should Be Disabled    ${question_doc_select}
    END

Check Medication Regimen Section Has Fields Group
    [Arguments]    ${status_arg}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${medication_regimen_title}
    Check Elements Visible    
        ...    ${medication_regimen_select}    
        ...    ${medication_dose_table}    
        ...    ${medication_repeat_regimen_select}    
        ...    ${medication_repeat_regimen_frequency_select}    
        ...    ${medication_repeat_maintenance_select}    
        ...    ${medication_repeat_maintenance_frequency_select}  
    IF    "${status_arg}" == "view po"
        ${class}    SeleniumLibrary.Get Element Attribute    ${medication_regimen_select}    class
        Should Contain    ${class}    disabled
        ${class}    SeleniumLibrary.Get Element Attribute    ${medication_dose_table}    class
        Should Contain    ${class}    input-regimen-disabled
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${medication_repeat_regimen_select}
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${medication_repeat_regimen_frequency_select}
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${medication_repeat_maintenance_select}
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${medication_repeat_maintenance_frequency_select}
    END

Check Secondary Medication Section Has Fields Group
    [Arguments]    ${status_arg}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${secondary_regimen_title}
    Check Elements Visible    
        ...    ${secondary_quick_select}    
        ...    ${secondary_add_secondary_meds_btn}     
        ...    ${secondary_secondary_list}   
        ...    ${secondary_view_assigned_medication}
    ${is_hidden}    Run Keyword And Return Status    Should Contain    ${secondary_secondary_list}    class    hidden
    IF    ${is_hidden}
        Common.Scroll And Click Element    ${secondary_quick_select}
        Wait Until Element Is Visible    ${secondary_secondary_list}    30s
    ELSE
        Element Should Be Visible    ${secondary_secondary_list}
    END
    IF    "${status_arg}" == "view po"
        ${class}    SeleniumLibrary.Get Element Attribute    ${secondary_add_secondary_meds_btn}    class
        Should Contain    ${class}    disabled
    END

Check The Preferred CPT Codes Section Has Fields Group
    [Arguments]    ${status_arg}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${preferred_cpt_codes_title}
    Check Elements Visible
        ...    ${preferred_assigned_as_preference_checkbox}
        ...    ${preferred_referral_select}
        ...    ${preferred_treatment_goals_select}
        ...    ${preferred_notes_textarea}
        ...    ${rx_number_assignment_title}
        ...    ${rx_number_input}
        ...    ${rx_assignment_date_input}
        ...    ${rx_origin_select}
    IF    "${status_arg}" == "view po"
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${preferred_assigned_as_preference_checkbox}
        ${aria_disabled_value}    SeleniumLibrary.Get Element Attribute    ${preferred_referral_select}    aria-disabled
        Should Be Equal    ${aria_disabled_value}    true
        ${aria_disabled_value}    SeleniumLibrary.Get Element Attribute    ${preferred_treatment_goals_select}    aria-disabled
        Should Be Equal    ${aria_disabled_value}    true
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${rx_number_input}
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${rx_assignment_date_input}
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${rx_origin_select}
    END

Check Tools for Status and History Section Has Fields Group
    [Arguments]    ${status_arg}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tools_for_status_and_history_title}
    Check Elements Visible    
        ...    ${tools_progress_note_textarea}     
    IF    "${status_arg}" == "view po"
        Wait Until Keyword Succeeds    30s    1s    Element Should Be Disabled    ${rx_number_input}
    END
    