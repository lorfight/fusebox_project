*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${allergies_status_select}    //select[@id="AllergyActiveStatusFilter"]
${allergies_new_btn}    //a[contains(text(),"New Allergy")]
${allergies_no_known_btn}    //a[contains(text(),"No Known Allergies")]
${no_known_allergies_row}    (//strong[contains(text(),"No Known Allergies")]//following::td[contains(text(),'No Known Allergies')]//following::td//span[contains(text(),'N/A')])//ancestor::tr
${allergies_type_select}    //select[@id="EncounterNoteAddingAllergyType"]
${allergies_type_title}    //label[contains(text(),"Select an Allergy Type")]
${allergies_description_select}    //select[@id="EncounterNoteAddingAllergyDescription"]
${allergies_create_allergy_title}    //h4[contains(text(),"Create New Allergy")]
${allergies_create_allergy_btn}    //button[contains(text(),"Create Allergy")]
${allergies_close_btn}    //button[contains(text(),"Create Allergy")]//following::button[contains(text(),"Close")][1]
${allergies_medication_input}    //input[@id="NewAllergyDescription"]
${allergies_description_option}    //select[@id="EncounterNoteAddingAllergyDescription"]//child::option[contains(text(),"[Add New Allergy]")]//following::option[1]
${allergies_description_option_default}    //button[@data-id="EncounterNoteAddingAllergyDescription"]//span[contains(text(),"-- Select an Allergy Type --")]
${allergies_onset_date_input}    //label[contains(text(),"Onset Date")]//following::input[1]
${allergies_date_picker_table}    //div[@id='ui-datepicker-div']
${allergies_close_calendar_btn}    //*[@type='button' and contains(@class,'datepicker') and text()='Done']
${allergies_severity_select}    //select[@id="Severity"]
${allergies_detail_textarea}    //label[contains(text(),"Allergy / Intolerance Reaction Details")]//following::textarea[1]
${allergies_add_btn}    //a[contains(text(),"Add Allergy ")]
${allergies_cancel_modal_btn}    //div[@id="AdditionalAllergyAddingArea"]//child::a[contains(text(),"Cancel")]
${allergies_cancel_btn}    //a[contains(text(),"Cancel") and not(ancestor::div[@id="AdditionalAllergyAddingArea"])]
${allergies_deactive_title}    //h4[contains(text(),"Update Allergy Status - To DEACTIVE")]
${allergies_deactive_reason_select}    //select[@id="DeactivationReason"]
${allergies_deactive_date_input}    //input[@id="DeactivationDate"]
${allergies_deactive_btn}    //button[contains(text(),"Deactivate Allergy")]
${allergies_additional_area}    //div[@id="AdditionalAllergyAddingArea"]
${allergies_no_known_btn}    //a[contains(text(),"No Known Allergies")]

*** Keywords ***
Create Allergies Dictionary
    &{allergy_dict}    Create Dictionary
    RETURN    ${allergy_dict}

Open New Allergy Table
    Common.Scroll And Click Element    ${allergies_new_btn}
    Wait Until Element Is Visible    ${allergies_type_title}    30s

Click No Known Allergies Button
    Common.Scroll And Click Element    ${allergies_no_known_btn}
    Common.Page Alert Message    Encounter Note Allergy Updated!

Filter Allergy Active Status
    [Arguments]    ${selected_value}
    Wait Until Element Is Enabled    ${allergies_status_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_select}    ${selected_value}

Select Allergy Type Without Unknown Allergy
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${allergies_type_select}    var_name=allergies_type    dic=${dict_arg}
    IF    "${dict_arg.allergies_type}" == "Unknown Allergy"
        Select Allergy Type Without Unknown Allergy    ${dict_arg}
    END

Select An Allergy Description
    [Arguments]    ${dict_arg}
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    Common.Choose Random Value From Select List    xpath_arg=${allergies_description_select}    var_name=allergies_description    dic=${dict_arg}
    IF    "${dict_arg.allergies_description}" == "[Add New Allergy]"
        Wait Until Element Is Visible    ${allergies_create_allergy_title}    30s
        Common.Scroll And Click Element    ${allergies_close_btn}
        Select An Allergy Description    ${dict_arg}
    END

Input Onset Date
    [Arguments]    ${onset_date_arg}
    Common.Input Text Into Field    ${allergies_onset_date_input}    ${onset_date_arg}
    Common.Choose Date In Onset Date Input    date_arg=${onset_date_arg}

Select Allergy Severity
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${allergies_severity_select}    var_name=allergies_severity    dic=${dict_arg}

Input Intolerance Reaction Details
    [Arguments]    ${allergies_detail_arg}
    Common.Input Text Into Field    ${allergies_detail_textarea}    ${allergies_detail_arg}

Click Add Allergy Button
    Common.Scroll And Click Element    ${allergies_add_btn}

Select Deactivation Reason
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${allergies_deactive_reason_select}    var_name=allergies_deactive_reason    dic=${dict_arg}

Input Deactivation Date
    [Arguments]    ${date_arg}
    Common.Input Text Into Field    ${allergies_deactive_date_input}    ${date_arg}
    Common.Scroll And Click Element    ${allergies_close_calendar_btn}

Click Deactive Allergy Button
    Common.Scroll And Click Element    ${allergies_deactive_btn}

# Create New Allergy
Open Create New Allergy Popup
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_description_select}    [Add New Allergy]
    Wait Until Element Is Visible    ${allergies_create_allergy_title}    30s

Input Medication Allergy
    [Arguments]    ${description_arg}
    Common.Input Text Into Field    ${allergies_medication_input}    ${description_arg}

Click Create Allergy Button
    Common.Scroll And Click Element    ${allergies_create_allergy_btn}

Click Close New Allergy Popup
    Common.Scroll And Click Element    ${allergies_close_btn}

Click Cancel Allergy Popup
    Common.Scroll And Click Element    ${allergies_cancel_modal_btn}

# Edit Allergy
Open Created Allergy
    [Arguments]    ${allergy_detail_txt}
    ${allergies_edit_icon}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//following::i[@class="far fa-edit"][1]
    Common.Scroll And Click Element    ${allergies_edit_icon}
    Wait Until Element Is Visible    ${allergies_additional_area}    30s
