*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${search_icd_code_input}    //*[@id='SearchValues']
${find_icd_code_btn}    //*[@id='FindButton']
${ICD_list}    //*[@id='ICDList']
${clear_icd_code_btn}    //button[@id='ClearButton' and text()='Clear']
${ICD_checkbox}    //*[@id='IsSelected']
${diagnosis_no_icd_msg}    //strong[contains(text(),"No ICD 10 Codes Available")]
${diagnosis_loading_icon}    //i[@id='loading-indicator']
${diagnosis_assigned_section}    //strong[contains(text(),'Assigned')]
${diagnosis_primary_section}    //strong[contains(text(),'Primary')]

*** Keywords ***
Search For An ICD Code
    [Arguments]    ${icdcode_arg}
    Common.Clear Input Field Until Empty    ${search_icd_code_input}
    Common.Input Text Into Field    ${search_icd_code_input}    ${icdcode_arg}

Click Find Diagnosis Button
    Wait Until Element Is Visible    ${find_icd_code_btn}    30s
    Common.Scroll And Click Element    ${find_icd_code_btn}
    Common.Element Is Not Visible    ${diagnosis_loading_icon}

Find Diagnosis
    [Arguments]    ${icdcode_arg}
    Search For An ICD Code    ${icdcode_arg}
    Click Find Diagnosis Button

Click Clear Diagnosis Button
    Wait Until Element Is Visible    ${clear_icd_code_btn}    30s
    Common.Scroll And Click Element    ${clear_icd_code_btn}
    Common.Element Is Not Visible    ${diagnosis_loading_icon}

Click Assigned Checkbox
    [Arguments]    ${icdcode_arg}    ${msg}
    ${diagnosis_assigned_checkbox}    Set Variable    //td[normalize-space(text())='${icdcode_arg}']//preceding::input[@class='AssignICD largeCheckbox']
    Common.Scroll And Click Element    ${diagnosis_assigned_checkbox}
    Common.Page Alert Message    ${msg}
    IF    '${msg}' == 'ICD Code Added to Patient.'
        Wait Until Element Is Visible    ${diagnosis_assigned_section}    30s
    ELSE IF    '${msg}' == 'ICD Code Removed from Patient.'
        Wait Until Element Is Not Visible    ${diagnosis_assigned_section}    30s
    END

Click Primary Checkbox
    [Arguments]    ${icdcode_arg}    ${msg}
    ${diagnosis_primary_checkbox}    Set Variable    //td[normalize-space(text())='${icdcode_arg}']//preceding::input[@class='PrimaryICD largeCheckbox']
    Common.Scroll And Click Element    ${diagnosis_primary_checkbox}
    Common.Page Alert Message    ${msg}
