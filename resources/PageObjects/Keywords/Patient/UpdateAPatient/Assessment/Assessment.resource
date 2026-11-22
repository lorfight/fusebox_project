*** Settings ***
Resource    ../../../Layers/Assessment/Assessment.resource

*** Keywords ***
Open Assessment Tab
    Navigate To The Tab    
    ...    tab_name=//*[@id='Assessment']
    ...    title_name=//*[@id='AssessmentTab']//following::h3[contains(text(),'Patient Assessments')]

Generate Meaningful Alpha Template Name
    ${random}    Generate Random String    6    [LETTERS]
    ${template_name}    Catenate    SEPARATOR=    Template_    ${random}
    RETURN    ${template_name}

Create Assessment List
    [Arguments]    ${loops}
    ${assessment_dict}    Create Assessment Dictionary
    FOR    ${loop}    IN RANGE    ${loops}
        Click Add Template Button
        ${template_name}    Generate Meaningful Alpha Template Name
        Input Assessment Name Textbox    ${template_name}
        Assessment.Click Save Template Button
        Common.Page Alert Message    New Assessment Template Created
        Set To Dictionary    ${assessment_dict}
        ...    template_name_${loop+1}=${template_name}
    END
    RETURN    ${assessment_dict}

Verify Created Assessment List
    [Arguments]    ${expected_assessment_list}
    ${template_list}    Get Assessment Template List Items
    Sort List    ${template_list}
    Lists Should Be Equal    ${template_list[1:]}    ${expected_assessment_list}

Check Default Value Of Patient Assessments Dropdown
    ${default}    Get Selected List Label    ${assessment_template_select}
    Should Be Equal    ${default}    - Select a Template -

Verify That New Template Is Created Unsuccessfuly
    Click Add Template Button
    ${template_name}    Generate Meaningful Alpha Template Name
    Input Assessment Name Textbox    ${template_name}
    Click Cancel Template Button
    ${template_list}    Get Assessment Template List Items
    List Should Not Contain Value    ${template_list}    ${template_name}

Get Assessment Template List Items
    Wait Until Element Is Visible    ${assessment_template_select}    30s
    ${template_list}    Get List Items    ${assessment_template_select}
    RETURN    ${template_list}

Verify That New Template Is Created Successfuly
    [Arguments]    ${template_name}
    Click Add Template Button
    Input Assessment Name Textbox    ${template_name}
    Assessment.Click Save Template Button
    Common.Page Alert Message    New Assessment Template Created
    ${template_list}    Get Assessment Template List Items
    List Should Contain Value    ${template_list}    ${template_name}

Check System Shows "New Assessment" Or "Edit Selected Template
    [Arguments]    ${template_name}
    Select Assessment Template    ${template_name}
    Check Elements Visible    ${new_assessment_btn}    ${edit_selected_template_btn}

Verify Edit Selected Template Button
    [Arguments]    ${template_name}
    Update Assessment    ${template_name}    # PaMan_TC229
    Add Question    # PaMan_TC230
    Update Question    # PaMan_TC231
    Add Question Element    # PaMan_TC233
    Update Question Element    # PaMan_TC234
    RETURN    ${template_name}

Update Assessment
    [Arguments]    ${template_name}
    Click Selected Template Button
    Click Update Assessment Button
    Input Assessment Name Textbox    ${template_name}
    Click Save Update Assessment Button
    Common.Page Alert Message    Assessment Template Updated
    RETURN    ${template_name}

Add Question
    Click Add Question Button
    Input Description    Test
    Click Save Question Button
    Common.Page Alert Message    New Question Created

Update Question    
    Click Update Question Button        
    Select Number of Columns    number_arg=1
    Click Save Update Question Button
    Common.Page Alert Message    Question Updated

Add Question Element
    Click Add Question Element Button        
    Input Description    Test
    Select Data Type    data_type_arg=1
    Click Save Question Element Button
    Common.Page Alert Message    New Question Element Created

Update Question Element    
    Click Update Question Element Button    
    Click Optional Checkbox
    Click Save Update Question Element Button
    Common.Page Alert Message    Question Element Updated

Verify The System Navigates The User Into The "New Assessment"
    [Arguments]    ${template_name}
    Select Assessment Template    ${template_name}
    Click New Assessment Button
    Input Question Element    Test Assessment tab
    Click Save Asssessment Response Button
    Common.Page Alert Message    New Assessment Created

Verify That View Information Assessment Detail Successful
    [Arguments]    ${template_name}
    Click Information Asssessment Detail Button
    Wait Until Element Is Visible    ${assessment_name}
    ${title}    Get Text    ${assessment_name} 
    Should Be Equal    ${title}    ${template_name} 
    Click Close Asssessment Button

Verify Deleted SuccessFully
    Click Selected Template Button
    Click Update Question Element Button
    Delete Question Element
    Delete Question
    Delete Assessment

Delete Question Element    #PaMan_TC235
    Click Delete Question Element Button

Delete Question    #PaMan_TC232
    Click Update Question Button
    Click Delete Question Button

Delete Assessment    #PaMan_TC229
    Click Update Assessment Button
    Click Delete Assessment Button

Delete Assessment Templates
    [Arguments]    ${expected_assessment}
    FOR    ${template}    IN    @{expected_assessment}
        Select Assessment Template    ${template}
        ${item}    Get Selected List Label    ${assessment_template_select}
        Click Selected Template Button
        Wait Until Element Is Visible    //*[@id="AssessmentTemplateWrapper"]//following::div[contains(text(),'Assessment Template ')]//following::strong[text()="${item}"]
        Click Update Assessment Button
        Click Delete Assessment Button
    END

Delete All Assessment Template From Dropdown
    ${template_list}    Get Assessment Template List Items
    ${count}    Get Length    ${template_list}
    Run Keyword If    ${count} > 1    Delete Assessment Templates    ${template_list[1:]}
