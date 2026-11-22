*** Settings ***
Resource    ../Common/Common.resource
Library    ../../../../../libraries/CustomLibrary.py

*** Variables ***
${document_type_select}    //select[@id='DocumentType']
${document_criteria_search}    //input[@id='DocumentSearch']
${document_startdate_input}    //input[@id='StartDateDocument']
${document_enddate_input}    //input[@id='EndDateDocument']
${document_find_btn}    //button[@id='DocumentFindButton']
${document_clear_btn}    //button[@id='DocumentClearButton']
${document_loading_icon_i}    //i[@class='fa fa-spinner fa-4x fa-spin']
${document_add_btn}    //button[@id='DocumentAddButton']
${new_document_title}    //h4[contains(text(),'New Document')]
${new_document_type_select}    //select[@id='NewDocumentType']
${new_document_medication_select}    //select[@id='MedicationName']
${new_document_description_textarea}    //textarea[@id='Description']
${new_document_date_input}    //input[@id='DocumentDate']
${document_datepicker_table}    //div[@id='ui-datepicker-div']
${new_document_file_input}    //input[@id='DocumentFile']
${new_document_add_btn}    //button[@id='AddDocumentSubmitButton']
${new_document_cancel_btn}    //button[@id='CancelAddDocumentButton']
${document_save_doc_btn}    //button[@id='EditDocumentSubmitButton']
${document_delete_btn}    //button[@id='DeleteDocumentButton']
${document_viewer_message_table}    //span[@id="DocumentViewerMessage"]//parent::div

*** Keywords ***
Create Document Dictionary
    &{document_dict}    Create Dictionary
    RETURN    ${document_dict}

#Documents
Select Document Type
    [Arguments]    ${type_value}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    ${type_value}

Enter Search Criteria
    [Arguments]    ${description_arg}
    Common.Input Text Into Field    ${document_criteria_search}    ${description_arg}

Input Start Date Document
    [Arguments]    ${start_date_arg}
    Common.Input Text Into Field    ${document_startdate_input}    ${start_date_arg}
    Common.Choose Date In Onset Date Input    ${start_date_arg}

Input End Date Document
    [Arguments]    ${end_date_arg}
    Common.Input Text Into Field    ${document_enddate_input}    ${end_date_arg}
    Common.Choose Date In Onset Date Input    ${end_date_arg}

Click Find Document Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_find_btn}
    Common.Element Is Not Visible    ${document_loading_icon_i}

Click Clear Document Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_clear_btn}

# New Document
Open New Document
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s

Select New Document Type
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${new_document_type_select}    var_name=new_document_type_select    dic=${dict_arg}
    ${check_medication_select}    Run Keyword And Return Status    Wait Until Element Is Visible    ${new_document_medication_select}    2s
    IF    "${check_medication_select}" == "${True}"
        Select New Document Type    ${dict_arg}
    END

Input Description In Documents
    [Arguments]    ${description_arg}
    Clear Input Field Until Empty    ${new_document_description_textarea}
    Input Text Into Field    ${new_document_description_textarea}    ${description_arg}

Input Document Date In Documents
    [Arguments]    ${date_arg}
    Clear Element Text    ${new_document_date_input}
    Input Text Into Field    ${new_document_date_input}    ${date_arg}
    Common.Choose Date In Onset Date Input    ${date_arg}

Choose Document File
    ${base}    Normalize Path    ${CURDIR}/../../../../..
    ${file_path}    Join Path    ${base}    results    export    dummy.pdf
    Choose File    ${new_document_file_input}    ${file_path}

Create Fake Folder
    [Arguments]    ${folder_path}
    Create Directory    ${folder_path}
    ${content_file}    Evaluate    'Testing ' * int(100)
    ${file_path}    Set Variable    ${folder_path}/dummy.pdf
    Create Pdf    ${file_path}    ${content_file}
    RETURN    ${file_path}    ${content_file}

Delete Fake Folder
    [Arguments]    ${folder_path}
    ${check_folder_isvisible}    Run Keyword And Return Status    Directory Should Exist    ${folder_path}
    IF    "${check_folder_isvisible}" == "${True}"
        Remove Directory    ${folder_path}    recursive=True
    END

Click Add New Document Button
    Common.Scroll And Click Element    ${new_document_add_btn}

Click Cancel New Document Button
    Common.Scroll And Click Element    ${new_document_cancel_btn}
    Common.Element Is Not Visible    //div[@id="DocumentList"]//i[@class='fa fa-spinner fa-4x fa-spin']

Click Save New Document Button
    Common.Scroll And Click Element    ${document_save_doc_btn}

Click Delete New Document Button
    Common.Scroll And Click Element    ${document_delete_btn}
    Handle Alert    ACCEPT
    Common.Page Alert Message    Document Deleted Successfully!
    Common.Element Is Not Visible    //div[@id="DocumentList"]//i[@class='fa fa-spinner fa-4x fa-spin']

Click Document Viewer Message Table
    Wait Until Element Is Visible    ${document_viewer_message_table}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_viewer_message_table}

