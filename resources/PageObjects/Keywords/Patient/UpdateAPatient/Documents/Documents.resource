*** Settings ***
Resource    ../../../Layers/Documents/Documents.resource

*** Variables ***
${document_tab}    //a[@id='Document']
${document_title}    //h2[contains(text(),'Documents')]
${document_custom_title}    //h3[contains(text(),'Save Custom Document Type')]
${document_option_default}    //select[@id='DocumentType']//optgroup[@label='Default']//option
${document_option_custom}    //select[@id='DocumentType']//optgroup[@label='Custom']//option
${document_custom_type}    //input[@id='CustomDocumentTypeDescription']
${document_show_archived_checkbox}    //input[@id='isArchive']
${document_yes_btn}    //button[@id='AcceptButton']
${document_no_btn}    //button[@id='CloseAcceptButton']
${document_edit_title}    //h4[contains(text(),'Edit Document')]
${document_frame}    //span[@id='DocumentViewerMessage']//parent::div
${document_patient_label}    //strong[contains(text(),'Patient:')]//parent::div
${document_dob_label}    //strong[contains(text(),'DOB:')]//parent::div
${document_mrn_label}    //strong[contains(text(),'MRN:')]//parent::div
${document_type_label}    //select[@id='DocumentType']//preceding::label[contains(text(),'Document Type')]
${document_description_title}    //span[@id='DocumentDescription']
${new_document_cancel_btn}    //button[@id='CancelAddDocumentButton']
${new_document_confirm_title}    //h4[contains(text(),'CONFIRMATION')]
${new_document_frame}    //iframe[@id='DocumentViewer']

*** Keywords ***   
Open Documents Tab
    Navigate To The Tab    
    ...    tab_name=${document_tab}    
    ...    title_name=${document_title}
    Common.Element Is Not Visible    //div[@id="DocumentList"]//i[@class='fa fa-spinner fa-4x fa-spin']

Get Document Date
    ${start_date}    Get Current Date    result_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${start_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    RETURN    ${start_date}    ${end_date}

Verify Documents Tab Is Displayed Successfully With All Visible Elements
    Wait Until Element Is Visible    ${document_patient_label}    30s
    Wait Until Element Is Visible    ${document_dob_label}    30s
    Wait Until Element Is Visible    ${document_mrn_label}    30s
    Wait Until Element Is Visible    ${document_type_label}    30s
    Wait Until Element Is Visible    ${document_type_select}    30s
    Wait Until Element Is Visible    ${document_criteria_search}    30s
    Wait Until Element Is Visible    ${document_startdate_input}    30s
    Wait Until Element Is Visible    ${document_enddate_input}    30s
    Wait Until Element Is Visible    ${document_find_btn}    30s
    Wait Until Element Is Visible    ${document_clear_btn}    30s
    Wait Until Element Is Visible    ${document_show_archived_checkbox}    30s
    Wait Until Element Is Visible    ${document_add_btn}    30s
    Wait Until Element Is Visible    ${document_frame}    30s

Create New Document
    [Arguments]    ${file_path}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    sentence
    ${start_date}    ${end_date}    Get Document Date
    Open New Document
    Verify Add Document Form Is Visible
    Select New Document Type    ${dict_arg}
    Input Description In Documents    ${Fake_dict['sentence']} 
    Input Document Date In Documents    ${start_date}
    Choose Document File
    Click Add New Document Button
    Handle Alert    ACCEPT
    Wait Until Element Is Not Visible    //div[@id="DocumentVirusScanModal"]//div[@class="upload-process"]    60s
    Wait Until Element Is Visible    //div[@id="DocumentVirusScanModal"]//div[@class="upload-success"]    60s
    Click Element    //div[@id="DocumentVirusScanModal"]//button
    Set To Dictionary    ${dict_arg}
        ...    description=${Fake_dict['sentence']}
        ...    start_date=${start_date}
        ...    end_date=${end_date}
    Common.Element Is Not Visible    //div[@id="DocumentList"]//i[@class='fa fa-spinner fa-4x fa-spin']
    
Verify Patient ID Is Displayed Correctly In Document Tab
    [Arguments]    ${dict_arg}
    Wait Until Element Is Visible    ${document_patient_label}    30s
    ${patient_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_patient_label}
    Should Contain    ${patient_label_txt}    ${dict_arg.last_name}, ${dict_arg.first_name} ${dict_arg.middle_name}
    
Verify DOB Is Displayed Correctly In Document Tab
    [Arguments]    ${dict_arg}
    Wait Until Element Is Visible    ${document_dob_label}    30s
    ${dob_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_dob_label}
    Should Contain    ${dob_label_txt}    ${dict_arg.dob}
    
Verify MRN Is Displayed Correctly In Document Tab
    [Arguments]    ${dict_arg}
    Wait Until Element Is Visible    ${document_mrn_label}    30s
    ${mrn_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_mrn_label}
    Should Contain    ${mrn_label_txt}    ${dict_arg.mrn}
    
Verify Search Successfully With Document Type In Document Tab
    [Arguments]    ${document_type_arg}
    ${new_document_row}    Set Variable    //h3[text()='${document_type_arg}']//ancestor::button
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    ${document_type_arg}
    Wait Until Element Is Visible    ${new_document_row}    30s

Verify Search Successfully When Entering Search Critiria In Document Tab
    [Arguments]    ${description_arg}
    ${new_document_description_row}    Set Variable    //a[contains(text(),'${description_arg}')]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    -- All Types --
    Common.Input Text Into Field    ${document_criteria_search}    ${description_arg}
    Click Find Document Button  
    Wait Until Element Is Visible    ${new_document_description_row}    30s

Enter Date Range In Document Tab
    [Arguments]    ${start_date_arg}    ${end_date_arg}
    Input Start Date Document    ${start_date_arg}
    Input End Date Document    ${end_date_arg}

Search New Document
    [Arguments]    ${document_type_arg}    ${description_arg}    ${start_date_arg}    ${end_date_arg}
    Select Document Type    ${document_type_arg}
    Enter Search Criteria    ${description_arg}
    Enter Date Range In Document Tab    ${start_date_arg}    ${end_date_arg}
    Click Find Document Button

Verify Created Document Is Visible
    [Arguments]    ${document_type_arg}
    ${new_document_row}    Set Variable    //h3[text()='${document_type_arg}']//ancestor::button
    Wait Until Element Is Visible    ${new_document_row}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${new_document_row}
    RETURN    ${new_document_row}

Clear All Fields Successfully In Document Tab
    Click Clear Document Button
    ${document_criteria_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_criteria_search}
    ${document_startdate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_startdate_input}
    ${document_enddate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_enddate_input}
    Should Be Empty    ${document_criteria_value}
    Should Be Empty    ${document_startdate_value}
    Should Be Empty    ${document_enddate_value}

Archive Or Un-Archive New Document
    [Arguments]    ${msg}   ${description_arg}
    ${archive_icon}    Set Variable    //a[contains(text(),'${description_arg}')]//following::a[@class='archive-button'][1]
    Common.Scroll And Click Element    ${archive_icon}
    Wait Until Element Is Visible    ${new_document_confirm_title}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_yes_btn}
    Common.Page Alert Message    ${msg}

Open Edit Document Table
    [Arguments]    ${document_type_arg}    ${description_arg}
    ${document_plus_icon}    Set Variable    //h3[text()='${document_type_arg}']//preceding::h3[1]//i[@class='fa fa-plus']
    ${check_icon_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${document_plus_icon}    2s
    IF    '${check_icon_visible}' == '${True}'
        Common.Scroll And Click Element    ${document_plus_icon}
    END
    ${edit_icon}    Set Variable    //a[contains(text(),'${description_arg}')]//following::i[@class='fas fa-edit'][1]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_icon}
    Wait Until Element Is Visible    ${document_edit_title}    30s

Edit New Document
    [Arguments]    ${dict_arg}    ${document_type_arg}    ${description_arg}
    Open Edit Document Table    ${document_type_arg}    ${description_arg}
    ${Fake_dict}    Generate Fake Data    sentence
    ${start_date}    ${end_date}    Get Document Date
    Select New Document Type    ${dict_arg}
    Input Description In Documents    ${Fake_dict['sentence']} 
    Input Document Date In Documents    ${start_date}
    FOR    ${loop}    IN RANGE    10
        Click Save New Document Button
        ${alert_txt}    Handle Alert    ACCEPT
        IF    '${alert_txt}' =='Please select a Medication.'
            Select New Document Type    ${dict_arg}
        ELSE IF    '${alert_txt}' =='Save changes?'
            Common.Page Alert Message    Document Successfully Saved!
            Set To Dictionary    ${dict_arg}
            ...    description=${Fake_dict['sentence']}
            ...    start_date=${start_date}
            ...    end_date=${end_date}
            Exit For Loop
        END
    END

Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar
    [Arguments]    ${attribute_status}    ${document_type_arg}
    ${doc_type}    Fetch From Left   ${document_type_arg}    \ \
    ${new_document_blue_bar_attribute}    SeleniumLibrary.Get Element Attribute    //div[@aria-labelledby='${doc_type}']    aria-expanded
    Should Be Equal    ${new_document_blue_bar_attribute}    ${attribute_status}

Verify New Document From List Displays With All Element When Expand
    [Arguments]    ${document_type_arg}    ${description_arg}    ${start_date_arg}    ${utc}
    ${document_plus_icon}    Set Variable    //h3[text()='${document_type_arg}']//preceding::h3[1]//i[@class='fa fa-plus']
    Common.Scroll And Click Element    ${document_plus_icon}
    ${element_list}    Create Dictionary
    ...    new_document_show_icon=//a[contains(text(),'${description_arg}')]//preceding::i[@class='far fa-file-pdf fa-2x'][1]
    ...    new_document_description_row=//a[contains(text(),'${description_arg}')]
    ...    new_document_date_txt=//a[contains(text(),'${description_arg}')]//following::span[contains(text(),'Document Date')][1]
    ...    new_document_upload_txt=//a[contains(text(),'${description_arg}')]//following::span[contains(text(),'Uploaded')][1]
    ...    new_document_archive_icon=//a[contains(text(),'${description_arg}')]//following::a[@class='archive-button'][1]
    ...    new_document_edit_icon=//a[contains(text(),'${description_arg}')]//following::i[@class='fas fa-edit'][1]
    ...    new_document_fax_icon=//a[contains(text(),'${description_arg}')]//following::i[@class='fas fa-fax'][1]
    FOR    ${element}    IN    @{element_list.values()}
        Wait Until Element Is Visible    ${element}    30s
    END
    Show Document Date    ${element_list.new_document_date_txt}    ${start_date_arg}
    Show Date Time Uploaded    ${element_list.new_document_upload_txt}    ${utc}
    Show Document Successfully In Frame Document    
    ...    ${element_list.new_document_show_icon}    ${description_arg}

Show Document Date
    [Arguments]    ${document_date_arg}    ${start_date_arg}
    ${new_document_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_date_arg}
    Should Contain    ${new_document_date_txt}    ${start_date_arg}

Show Date Time Uploaded
    [Arguments]    ${document_upload_arg}    ${utc}
    ${user_name_txt}    Common.Get User Name
    ${upload_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}
    ${new_document_upload_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_upload_arg}
    Should Contain    ${new_document_upload_txt}    ${upload_date}
    Should Contain    ${new_document_upload_txt}    ${user_name_txt}
    
Show Document Successfully In Frame Document
    [Arguments]    ${document_description_arg}    ${description_arg}
    Common.Scroll And Click Element    ${document_description_arg}
    ${document_description_title}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_description_title}
    Should Be Equal    ${document_description_title}    ${description_arg}

Edit Document Unsuccessfully
    [Arguments]    ${document_type_arg}    ${description_arg}    ${element_arg}    ${msg}
    Open Edit Document Table    ${document_type_arg}    ${description_arg}
    Clear Input Field Until Empty    ${element_arg}
    Click Document Viewer Message Table
    Click Save New Document Button
    Alert Should Be Present    ${msg}    ACCEPT

Check Document Type Select Has Default Value
    ${option_count}    SeleniumLibrary.Get Element Count    ${document_option_default}
    IF    ${option_count} == 0
        Select Document Type    -- Add New Document Type --
        Wait Until Element Is Visible    ${document_custom_title}    30s
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${document_custom_type}    Testing
        Common.Page Alert Message    Custom Document Type successfully added!
    END

Verify Add Document Form Is Visible
    Wait Until Element Is Visible    ${new_document_type_select}    30s
    Wait Until Element Is Visible    ${new_document_description_textarea}    30s
    Wait Until Element Is Visible    ${new_document_date_input}    30s
    Wait Until Element Is Visible    ${new_document_file_input}    30s
    Wait Until Element Is Visible    ${new_document_add_btn}    30s
    Wait Until Element Is Visible    ${new_document_cancel_btn}    30s
    
Delete New Document
    [Arguments]    ${document_type_arg}    ${description_arg}
    Common.Scroll And Click Element    ${document_clear_btn}
    ${new_document_row}    Set Variable    //h3[text()='${document_type_arg}']//ancestor::button
    ${check_document_row_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${new_document_row}    5s
    IF    "${check_document_row_visible}" == "${True}"
        Open Edit Document Table    ${document_type_arg}    ${description_arg}
        Click Delete New Document Button
    END

Verify Document Popup Shows Remain Fields
    Wait Until Element Is Visible    ${document_type_select}    30s
    Wait Until Element Is Visible    ${document_criteria_search}    30s
    Wait Until Element Is Visible    ${document_startdate_input}    30s
    Wait Until Element Is Visible    ${document_enddate_input}    30s
    Wait Until Element Is Visible    ${document_find_btn}    30s
    Wait Until Element Is Visible    ${document_clear_btn}    30s
    Open New Document
    Wait Until Element Is Visible    ${new_document_type_select}    30s
    Wait Until Element Is Visible    ${new_document_description_textarea}    30s
    Wait Until Element Is Visible    ${new_document_date_input}    30s
    Wait Until Element Is Visible    ${new_document_file_input}    30s
    Wait Until Element Is Visible    ${new_document_add_btn}    30s
    Wait Until Element Is Visible    ${document_viewer_message_table}    30s

