*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${add_template_btn}    //span[@id='AddPatientAssessmentTemplateButton']
${assessment_name_texbox}    //*[@id='Name']
${save_assessment_btn}    //*[@id='SaveAddPatientAssessmentTemplateButton']
${assessment_template_select}    //select[@id='SelectedAssessmentTemplateId']
${cancel_assessment_btn}    //*[@id='CancelAddPatientAssessmentTemplateButton']
${new_assessment_btn}    //span[@id='AddPatientAssessmentButton']
${edit_selected_template_btn}    //span[@id='EditPatientAssessmentTemplateButton']
${update_assessment_btn}    //span[@id='UpdateAssessmentTemplateButton']
${save_update_assessment}    //*[@id='SaveUpdatePatientAssessmentTemplateButton']
${add_question_btn}    //span[@id='AddAssessmentTemplateQuestionItemButton']
${description_question_input}    //*[@id='Description']
${save_question_btn}    //*[@id='SaveAddPatientAssessmentTemplateQuestionItemButton']
${update_question_btn}    (//div[@class='questions-sortable']//following::span)[1]
${number_of_columns_select}    //*[@id='NumberOfColumns']
${save_update_question_btn}    //*[@id='SaveUpdatePatientAssessmentTemplateQuestionItemButton']
${add_question_element_btn}    //div[@class='questions-sortable']//following::span[contains(text(),'Add Question Element')]
${add_question_element_title}    //div[@class='questions-sortable']//following::h3[contains(text(),'Add Question Element')]
${data_type_select}    //*[@id='DataType']
${save_question_element_btn}    //*[@id='SaveAddPatientAssessmentTemplateItemButton']
${update_question_element_btn}    //*[@id='AssessmentTemplateWrapper']//following::a[@class='updateAssessmentTemplateItemButton']
${optional_checkbox}    //*[@id='Optional']
${save_update_question_element_btn}    //*[@id='SaveUpdatePatientAssessmentTemplateItemButton']
${question_element_input}    //*[@id='PatientAssessmentQuestionList_0__PatientAssessmentItemList_0__Value']
${save_assessment_response_btn}    (//div[@class='assessmentCreateForm']//following::span)[1]
${info_assessment_detail}    //*[@id='AssessmentListSection']//following::td[1]/a
${assessment_name}    (//*[@id='ModalPopup']//following::h3)[1]
${close_assessment_btn}    (//div[@id='ModalPopup']//following::button[@id='CloseBtn'])[1]
${delete_quesion_element_btn}    //*[@id='DeletePatientAssessmentTemplateItemButton']
${delete_quesion_btn}    //*[@id='DeletePatientAssessmentTemplateQuestionItemButton']
${delete_assessment_btn}    //*[@id='DeletePatientAssessmentTemplateButton']

*** Keywords ***
Create Assessment Dictionary
    &{assessment_dict}    Create Dictionary
    RETURN    ${assessment_dict}

Click Add Template Button
    Wait Until Element Is Visible    ${add_template_btn}    30s
    Common.Scroll And Click Element    ${add_template_btn}

Input Assessment Name Textbox
    [Arguments]    ${name_arg}
    Common.Clear Input Field Until Empty    ${assessment_name_texbox}
    Common.Input Text Into Field    ${assessment_name_texbox}    ${name_arg}

Click Save Template Button
    Wait Until Element Is Visible    ${save_assessment_btn}    30s
    Common.Scroll And Click Element    ${save_assessment_btn}

Click Cancel Template Button
    Wait Until Element Is Visible    ${cancel_assessment_btn}    30s
    Common.Scroll And Click Element    ${cancel_assessment_btn}

Select Assessment Template
    [Arguments]    ${template_name_arg}
    Wait Until Element Is Visible    ${assessment_template_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label	${assessment_template_select}    ${template_name_arg}

Click New Assessment Button
    Wait Until Element Is Visible    ${new_assessment_btn}    30s
    Common.Scroll And Click Element    ${new_assessment_btn}

Click Selected Template Button
    Wait Until Element Is Visible    ${edit_selected_template_btn}    30s
    Common.Scroll And Click Element    ${edit_selected_template_btn}

Click Update Assessment Button
    Wait Until Element Is Visible    ${update_assessment_btn}    30s
    Common.Scroll And Click Element    ${update_assessment_btn}

Click Save Update Assessment Button
    Wait Until Element Is Visible    ${save_update_assessment}    30s
    Common.Scroll And Click Element    ${save_update_assessment}

Click Add Question Button
    Wait Until Element Is Visible    ${add_question_btn}    30s
    Common.Scroll And Click Element    ${add_question_btn}

Input Description
    [Arguments]    ${description_arg}
    Common.Clear Input Field Until Empty    ${description_question_input}
    Common.Input Text Into Field    ${description_question_input}    ${description_arg}

Click Save Question Button
    Wait Until Element Is Visible    ${save_question_btn}    30s
    Common.Scroll And Click Element    ${save_question_btn}

Click Update Question Button
    Wait Until Element Is Visible    ${update_question_btn}    30s
    Common.Scroll And Click Element    ${update_question_btn}

Select Number of Columns
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${number_of_columns_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label	${number_of_columns_select}    ${number_arg}

Click Save Update Question Button
    Wait Until Element Is Visible    ${save_update_question_btn}    30s
    Common.Scroll And Click Element    ${save_update_question_btn}

Click Add Question Element Button
    Wait Until Element Is Visible    ${add_question_element_btn}    30s
    Common.Scroll And Click Element    ${add_question_element_btn}
    Wait Until Element Is Visible    ${add_question_element_title}

Select Data Type
    [Arguments]    ${data_type_arg}
    Wait Until Element Is Visible    ${data_type_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${data_type_select}    ${data_type_arg}

Click Save Question Element Button
    Wait Until Element Is Visible    ${save_question_element_btn}    30s
    Common.Scroll And Click Element    ${save_question_element_btn}

Click Update Question Element Button
    Wait Until Element Is Visible    ${update_question_element_btn}    30s
    Common.Scroll And Click Element    ${update_question_element_btn}

Click Optional Checkbox
    Wait Until Element Is Visible    ${optional_checkbox}    30s
    Common.Scroll And Click Element    ${optional_checkbox}

Click Save Update Question Element Button
    Wait Until Element Is Visible    ${save_update_question_element_btn}    30s
    Common.Scroll And Click Element    ${save_update_question_element_btn}

Input Question Element
    [Arguments]    ${question_arg}
    Common.Clear Input Field Until Empty    ${question_element_input}
    Common.Input Text Into Field    ${question_element_input}    ${question_arg}

Click Save Asssessment Response Button
    Wait Until Element Is Visible    ${save_assessment_response_btn}    30s
    Common.Scroll And Click Element    ${save_assessment_response_btn}

Click Information Asssessment Detail Button
    Wait Until Element Is Visible    ${info_assessment_detail}    30s
    Common.Scroll And Click Element    ${info_assessment_detail}

Click Close Asssessment Button
    Wait Until Element Is Visible    ${close_assessment_btn}    30s
    Common.Scroll And Click Element    ${close_assessment_btn}

Click Delete Question Element Button
    Wait Until Element Is Visible    ${delete_quesion_element_btn}    30s
    Common.Scroll And Click Element    ${delete_quesion_element_btn}
    Handle Alert    ACCEPT    30s
    Common.Page Alert Message    Question Element Removed
    
Click Delete Question Button
    Wait Until Element Is Visible    ${delete_quesion_btn}    30s
    Common.Scroll And Click Element    ${delete_quesion_btn}
    Handle Alert    ACCEPT    30s
    Common.Page Alert Message    Question Removed

Click Delete Assessment Button
    Wait Until Element Is Visible    ${delete_assessment_btn}    30s
    Common.Scroll And Click Element    ${delete_assessment_btn}
    Handle Alert    ACCEPT    30s
    Common.Page Alert Message    Assessment Template Removed
