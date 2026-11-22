*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${follow_date_span}    //span[contains(text(),'Follow Up Date')]
${note_start_date}    //input[@id='ProgressNoteStartDate']
${note_end_date}    //input[@id='ProgressNoteEndDate']
${follow_up_date}    //input[@id='FollowUpDate']
${progress_export_btn}    //span[@id='ExportProgressNoteToExcelButton']
${subject_field_select}    //select[@id='SelectedSubject']
${note_new_subject}    //input[@id='NewSubject']
${add_note_btn}    //span[@id='AddPatientProgressNoteButton']
${progress_note_textbox}    //textarea[@id='Note']
${date_range_span}    //span[contains(text(),'Filter By Date Range')]
${date_picker_table}    //div[@id='ui-datepicker-div']
${progress_save_btn}    //span[@id='SavePatientProgressNoteButton']
${progress_cancel_btn}    //span[@id='CancelPatientProgressNoteButton']

*** Keywords ***
Add New Subject
    Wait Until Element Is Enabled    ${subject_field_select}    30s
    Select From List By Label    ${subject_field_select}    -- Add New Subject --
    Input New Subject Note Field    New Subject

Input New Subject Note Field
    [Arguments]    ${note_arg}
    Common.Clear Input Field Until Empty    ${note_new_subject}
    Common.Input Text Into Field    ${note_new_subject}    ${note_arg}

Click Add Note Button
    Common.Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s

Input Progress Note Textbox
    ${long_text}    Generate Random String    300    [LETTERS]
    Common.Input Text Into Field    ${progress_note_textbox}    ${long_text}

Choose Date In Date Picker Table
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    ${date_range_span}    30s
    Click Element    ${date_arg}
    Wait Until Element Is Visible    ${date_picker_table}    30s
    ${today}    Get Current Date    result_format=datetime
    ${today}    Format Date No Padding    ${today}    {d}
    ${today_choose}    Set Variable    //td[@data-handler='selectDay']/a[text()='${today}']
    Wait Until Element Is Visible    ${today_choose}    30s
    Click Element    ${today_choose}

Click Save Progress Note Button
    Common.Scroll And Click Element    ${progress_save_btn}

Click Cancel Progress Note Button
    Common.Scroll And Click Element    ${progress_cancel_btn}
