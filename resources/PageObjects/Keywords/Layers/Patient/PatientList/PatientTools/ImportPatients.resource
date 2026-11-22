*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${new_import_btn}    //*[@id='RestartBtn']
${patient_upload_file_input}    //*[@id='UploadFile']
${patient_template_download_button}    //*[@onclick and normalize-space(text())='Download Template']
${close_import_patients_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
${patient_process_file_button}    //*[@id='SaveBtn' and normalize-space(text())='Process File']
${remove_error_lines_btn}    //*[@id='SaveBtn' and normalize-space(text())='Remove Error Lines']
${remove_row_btn}    //a[contains(text(),'Remove')]
${confirm_inport_btn}    //button[contains(text(),'Confirm Import')]

*** Keywords ***
Check Upload File Field Is Visible
    ${is_new_import}    Run Keyword And Return Status    Element Should Not Be Visible    ${new_import_btn}
    IF    ${is_new_import} == ${False}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${new_import_btn}
    END
    Wait Until Element Is Visible    ${patient_upload_file_input}    30s

Click Download Template Button
    Common.Scroll And Click Element    ${patient_template_download_button}

Click Remove Row Button
    Common.Scroll And Click Element    ${remove_row_btn}

Click Close Import Patient Modal Button
    Common.Scroll And Click Element    ${close_import_patients_btn}

Click Remove Error Lines Button
    Common.Scroll And Click Element    ${remove_error_lines_btn}

Click Confirm Import Button
    Common.Scroll And Click Element    ${confirm_inport_btn}