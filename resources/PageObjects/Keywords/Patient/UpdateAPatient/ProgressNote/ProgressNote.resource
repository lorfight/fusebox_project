*** Settings ***
Resource    ../../../Layers/ProgressNote/ProgressNote.resource

*** Variables ***
${progress_note_tab}    //a[@id='ProgressNote']
${subject_filter_span}    //span[contains(text(),'Subject Filter')]
${subject_filter_select}    //select[@id='SelectedSubjectElement']

*** Keywords ***
Open Progress Note Tab
    [Arguments]    ${patient_info_txt}
    Navigate To The Tab
    ...    tab_name=${progress_note_tab}    
    ...    title_name=${patient_info_txt}

The Subject Filter Dropdown Is Visible
    Wait Until Element Is Visible    ${subject_filter_span}    30s
    Wait Until Element Is Visible    ${subject_filter_select}    30s

Verify A Form Is Visible When Click Add Note
    Click Add Note Button
    Wait Until Page Contains Element    ${subject_field_select}    30s
    Wait Until Page Contains Element    ${follow_date_span}    30s
    Wait Until Page Contains Element    ${progress_note_textbox}    30s
    Wait Until Page Contains Element    ${progress_save_btn}    30s
    Wait Until Page Contains Element    ${progress_cancel_btn}    30s

