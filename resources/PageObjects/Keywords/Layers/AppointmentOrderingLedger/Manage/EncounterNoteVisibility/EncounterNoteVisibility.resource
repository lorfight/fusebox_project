*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${encounter_create_template_btn}    //a[@id="CreateTemplateBtn"]
${encounter_template_name_input}    //input[@id="TemplateDescription"]
${encounter_proprietary_name_select}    //select[@id="ProprietaryNameList"]
${encounter_route_of_administration_select}    //div[contains(@class,'TemplateRouteOfAdmin')]//select[@id="Route"]
${encounter_dx_code_input}    //input[contains(@class,'TemplateICDCode tt-input')]
${encounter_save_template_btn}    //a[@id="SaveTemplateBtn"]
${encounter_edit_btn}    //a[contains(text(),'Edit')]
${encounter_delete_btn}    //a[contains(text(),'Delete')]

*** Keywords ***
Click Create Template Button
    Common.Scroll And Click Element    ${encounter_create_template_btn}
    Wait Until Element Is Visible    //h3[text()='Create Template']    30s

Input Template Name
    [Arguments]    ${template_name_arg}
    Wait Until Element Is Visible    ${encounter_template_name_input}    30s
    Common.Clear Input Field Until Empty    ${encounter_template_name_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${encounter_template_name_input}    ${template_name_arg}

Select Proprietary Name
    [Arguments]    ${proprietary_name_arg}
    Wait Until Element Is Enabled    ${encounter_proprietary_name_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${encounter_proprietary_name_select}    ${proprietary_name_arg}

Select Route of Administration
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${encounter_route_of_administration_select}    var_name=route_of_administration    dic=${dict_arg}

Input Dx Code
    [Arguments]    ${dxcode_arg}
    Wait Until Element Is Visible    ${encounter_dx_code_input}    30s
    Common.Clear Input Field Until Empty    ${encounter_dx_code_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${encounter_dx_code_input}    ${dxcode_arg}

Click Save Template Button
    Common.Scroll And Click Element    ${encounter_save_template_btn}

Click Tools Button
    [Arguments]    ${template_name_arg}
    ${tools_btn}    Set Variable    //h4[text()='${template_name_arg}']//following::button[contains(text(),'Tools')]
    Common.Scroll And Click Element    ${tools_btn}

Click Edit Template Button
    [Arguments]    ${template_name_arg}    
    Click Tools Button    ${template_name_arg}
    Common.Scroll And Click Element    ${encounter_edit_btn}
    Wait Until Element Is Visible    //h3[text()='Edit Template']    30s

Click Delete Template Button
    [Arguments]    ${template_name_arg}    
    Click Tools Button    ${template_name_arg}
    Common.Scroll And Click Element    ${encounter_delete_btn}
    Alert Should Be Present    Are you sure you want to delete this template?    ACCEPT    5s
    Common.Page Alert Message    Template Successfully Deleted.

Create Template In Encounter Note Visibility Settings Modal
    [Arguments]    ${template_name_arg}    ${proprietary_name_arg}    ${dict_arg}    ${dxcode_arg}
    Click Create Template Button
    Input Template Name    ${template_name_arg}
    Select Proprietary Name    ${proprietary_name_arg}
    Select Route of Administration    ${dict_arg}
    Input Dx Code    ${dxcode_arg}
    Click Save Template Button
    Common.Page Alert Message    Template Created!

Update Template In Encounter Note Visibility Settings Modal
    [Arguments]    ${template_name_create_arg}    ${template_name_update_arg}
    Click Edit Template Button    ${template_name_create_arg}
    Input Template Name    ${template_name_update_arg}
    Click Save Template Button
    Common.Page Alert Message    Template Updated!
