*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${protocol_search_input}    //input[@id='ProtocolSearchTerms']
${protocol_clear_btn}    //button[@id='ProtocolClearButton']
${protocol_find_btn}    //button[@id='ProtocolFindButton']
${protocol_location_select}    //select[@id='LocationID']
${protocol_loading_icon_i}    //i[@class='fa fa-spinner fa-4x fa-spin']
${protocol_loading_icon}    //div[@class='fas fa-spin fa-spinner fa-4x']
${protocol_title_modal}    //h4[contains(text(),'Protocol Management Modal')]
${protocol_close_btn}    //div[@id='ModalPopup']//button[@id='TopCloseBtn']
${protocol_lab_assigned_checkbox}    //div[@class='RequiredLabsTable']//tbody//tr[not(contains(@class,'hidden'))]//td[1]//input
${protocol_select_tool_title}    //h3[contains(text(),'Quick Select Tool')]
${protocol_edit_treament_btn}    //a[contains(text(),'Edit Treatment Protocol')]

*** Keywords ***
Create Protocol Dictionary
    &{protocol_dict}    Create Dictionary
    RETURN    ${protocol_dict}

Select Location In Protocol Management Modal
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${protocol_location_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${protocol_location_select}    ${location_arg}
    Common.Element Is Not Visible    ${protocol_loading_icon}
    
Click Clear Medication Button
    Common.Scroll And Click Element    ${protocol_clear_btn}
    Common.Element Is Not Visible    ${protocol_loading_icon}

Input Medication In Protocol Management Modal
    [Arguments]    ${drug_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${protocol_search_input}    ${drug_arg}

Click Find Medication Button
    Common.Scroll And Click Element    ${protocol_find_btn}
    Common.Element Is Not Visible    ${protocol_loading_icon}

Search for Medication In Protocol Management Modal
    [Arguments]    ${drug_arg}
    Click Clear Medication Button
    Input Medication In Protocol Management Modal    ${drug_arg}
    Click Find Medication Button

Select Lab Descirption In Protocol Management Modal
    [Arguments]    ${location_arg}    ${drug_arg}    ${assigned_lab_status}    ${frequency_status}=select
    ${protocol_dict}    Create Protocol Dictionary
    Select Location In Protocol Management Modal    ${location_arg}
    Search for Medication In Protocol Management Modal    ${drug_arg}
    Show Medication's Required Labs    ${drug_arg}
    Show Quick View    ${drug_arg}
    Remove Lab Descirption Medication Required Labs    ${drug_arg}
    ${assign_lab_txt}    ${assign_emr_lab}    Get Lab Descirption Text    ${drug_arg}
    IF    ${assigned_lab_status} == ${True}
        Assign Lab Descirption In Quick Select Tool    ${drug_arg}    ${lab_tr}    ${lab_index}
    END
    IF    "${frequency_status}" == "select"
        Select Frequency For Assigned Lab Descirption In Quick Select Tool    ${protocol_dict}    ${assign_lab_txt}    ${drug_arg}
    END
    Common.Close Modal Popup
    Set To Dictionary    ${protocol_dict}
        ...    assign_lab_txt=${assign_lab_txt}
        ...    assign_emr_lab=${assign_emr_lab}
    RETURN    ${protocol_dict}

Show Medication's Required Labs
    [Arguments]    ${drug_arg}
    ${protocol_assign_lab_btn}    Set Variable    //strong[text()='${drug_arg}']//following::a[contains(text(),'Assign Labs to this Medication')][1]
    Common.Scroll And Click Element    ${protocol_assign_lab_btn}
    ${protocol_required_lab_title}    Set Variable    //h3[text()="${drug_arg}'s Required Labs"]
    Wait Until Element Is Visible    ${protocol_required_lab_title}    30s

Show Quick View
    [Arguments]    ${drug_arg}
    ${protocol_show_quick_view_btn}    Set Variable    //strong[text()='${drug_arg}']//following::a[text()='Show Quick View'][1]
    Common.Scroll And Click Element    ${protocol_show_quick_view_btn}
    Common.Element Is Not Visible    ${protocol_loading_icon}

Remove Lab Descirption Medication Required Labs
    [Arguments]    ${drug_arg}
    ${protocol_lab_assigned_checkbox}    Set Variable    //div[@class='RequiredLabsTable' and @data-medication="${drug_arg}"]//tbody//tr[not(contains(@class,'hidden'))]//td[1]//input
    ${total_rows}    SeleniumLibrary.Get Element Count    ${protocol_lab_assigned_checkbox}
    IF    ${total_rows} > 0
        FOR    ${i}    IN RANGE    1    ${total_rows + 1}
            Common.Scroll And Click Element    ${protocol_lab_assigned_checkbox}
            Common.Page Alert Message    Lab has been removed.
        END
    END

Get Lab Description Index In Quick Select Tool
    ${lab_index}    Get Variable Value    ${lab_index}    0
    ${lab_tr}   Get Variable Value    ${lab_tr}       1
    ${lab_index}    Evaluate    int(${lab_index}) + 1
    IF    "${lab_index}" == "4"
        ${lab_index}    Set Variable    1
        ${lab_tr}   Evaluate    int(${lab_tr}) + 1
    END
    Set Suite Variable    ${lab_index}
    Set Suite Variable    ${lab_tr}

Get Lab Descirption Text
    [Arguments]    ${drug_arg}
    Get Lab Description Index In Quick Select Tool
    ${assign_lab_description_txt}    Set Variable    (//h3[contains(text(),'${drug_arg}') and contains(text(),'Required Labs')]//following::a[text()="Hide Quick View"][1]//following::tbody//tr[${lab_tr}]//td//strong)[${lab_index}]
    Wait Until Element Is Visible    ${assign_lab_description_txt}    30s
    Scroll Element Into View    ${assign_lab_description_txt}
    ${assign_lab_txt}    Get Text    ${assign_lab_description_txt}
    ${assign_emr_lab}    Evaluate    """${assign_lab_txt}""".rpartition('(')[2].rstrip(')') if '(' in """${assign_lab_txt}""" else ""
    ${assign_lab_txt}    Evaluate    """${assign_lab_txt}""".rpartition('(')[0].rstrip() if '(' in """${assign_lab_txt}""" else """${assign_lab_txt}"""
    IF    '${assign_lab_txt}' == '${EMPTY}' or '${assign_emr_lab}' == '${EMPTY}'
        ${assign_lab_txt}    ${assign_emr_lab}    Get Lab Descirption Text    ${drug_arg}
    END
    RETURN    ${assign_lab_txt}    ${assign_emr_lab}

Assign Lab Descirption In Quick Select Tool
    [Arguments]    ${drug_arg}    ${lab_tr}    ${lab_index}
    ${assign_lab_checkbox}    Set Variable    (//strong[text()='${drug_arg}']//following::a[text()='Hide Quick View'][1]//following::tbody//tr[${lab_tr}]//td//input)[${lab_index}]
    Common.Scroll And Click Element    ${assign_lab_checkbox}
    Common.Page Alert Message    Lab has been assigned.

Select Frequency For Assigned Lab Descirption In Quick Select Tool
    [Arguments]    ${dict_arg}    ${assign_lab_txt}    ${drug_arg}
    ${protocol_frequency_value_select}    Set Variable    //strong[contains(text(),'${assign_lab_txt}')]//following::select[contains(@id, 'FrequencyValueDropdown') and @data-medication="${drug_arg}"][1]
    ${protocol_frequency_unit_select}    Set Variable    //strong[contains(text(),'${assign_lab_txt}')]//following::select[contains(@id, 'FrequencyUnitDropdown') and @data-medication="${drug_arg}"][1]
    Common.Choose Random Value From Select List    xpath_arg=${protocol_frequency_value_select}    var_name=protocol_frequency_value    dic=${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${protocol_frequency_unit_select}    var_name=protocol_frequency_unit    dic=${dict_arg}
    Common.Page Alert Message    Lab has been updated.
