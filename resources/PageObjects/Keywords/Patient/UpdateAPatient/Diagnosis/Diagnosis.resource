*** Settings ***
Resource    ../../../Layers/Common/Common.resource

*** Variables ***
${diagnosis_loading_icon}    //i[@id='loading-indicator']

*** Keywords ***
Open Diagnosis Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    //a[@id='ICD']
    Common.Scroll And Click Element    //a[@id='ICD']
    Wait Until Element Is Visible    //*[@id='ICDTab']//h3[contains(text(), 'Diagnosis / ICD 10 Codes')]    30s

Click Find Diagnosis Button
    Scroll And Click Element    //*[@id='FindButton']
    Common.Element Is Not Visible    ${diagnosis_loading_icon}    30s

Input Diagnosis Value
    [Arguments]    ${icdcode_arg}
    Wait Until Element Is Visible    //*[@id='SearchValues']
    Wait Until Keyword Succeeds    30s    1s    Input Text    //*[@id='SearchValues']    ${icdcode_arg}

Click Clear Diagnosis Button
    Scroll And Click Element    //*[@id='ClearButton']
    Common.Element Is Not Visible    ${diagnosis_loading_icon}    30s

Click Assigned Checkbox
    [Arguments]    ${icdcode_arg}
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    (//div[@id="ICDList"]//td[contains(text(),"${icdcode_arg}")])[last()]    ${icdcode_arg}
    ${diagnosis_assigned_checkbox}    Set Variable    //td[normalize-space(text())='${icdcode_arg}']//preceding::input[@class='AssignICD largeCheckbox']
    ${check_visible}    Run Keyword And Return Status    Checkbox Should Not Be Selected    ${diagnosis_assigned_checkbox}
    IF    "${check_visible}" == "${True}"
        Common.Scroll And Click Element    ${diagnosis_assigned_checkbox}
        Common.Page Alert Message    ICD Code Added to Patient.
        Wait Until Element Is Visible    //strong[contains(text(),'Assigned')]    30s
    END

Click Primary Checkbox
    [Arguments]    ${icdcode_arg}
    ${diagnosis_primary_checkbox}    Set Variable    //td[normalize-space(text())='${icdcode_arg}']//preceding::input[@class='PrimaryICD largeCheckbox']
    Scroll And Click Element    ${diagnosis_primary_checkbox}
    Page Alert Message    ICD Code Set as a Primary.
    Wait Until Element Is Visible    //strong[contains(text(),'Primary')]    30s

Find Diagnosis
    [Arguments]    ${icdcode_arg}
    Click Clear Diagnosis Button
    Input Diagnosis Value    ${icdcode_arg}
    Click Find Diagnosis Button

Verify System Returns The Corresponding Result With Valid Input
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    Click Assigned Checkbox    ${icdcode_arg}
    Click Primary Checkbox    ${icdcode_arg}

Verify System Displays Message With Invalid Input
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    Wait Until Element Is Visible    //strong[contains(text(),"No ICD 10 Codes Available")]    30s

Unassigned Diagnosis
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    ${diagnosis_assigned_checkbox}    Set Variable    //td[normalize-space(text())='${icdcode_arg}']//preceding::input[@class='AssignICD largeCheckbox']
    ${check_visible}    Run Keyword And Return Status    Checkbox Should Be Selected    ${diagnosis_assigned_checkbox}
    IF    "${check_visible}" == "${True}"
        Common.Scroll And Click Element    ${diagnosis_assigned_checkbox}
        Common.Page Alert Message    ICD Code Removed from Patient.
    END    
