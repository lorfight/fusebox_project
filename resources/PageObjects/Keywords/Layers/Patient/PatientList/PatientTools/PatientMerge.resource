*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${removing_patient_input}    //*[@id='RemovingPatient']
${keeping_patient_input}    //*[@id='KeepingPatient']
${merge_btn}    //*[@id='SaveBtn' and text()='Merge']
${merge_modal_close_btn}    //div[@id="ModalPopup"]//following::button[contains(text(),'Close')]    
${patient_tools_btn}    //*[@type='button'and contains(text(),'Patient Tools')]

*** Keywords ***
Megre Patient In Patient Merge Helper
    [Arguments]    ${removing_mrn_arg}    ${keeping_mrn_arg}
    Input Removing Patient    ${removing_mrn_arg}
    Select Patient To Merge    mrn_arg=${removing_mrn_arg}
    Input Keeping Patient    ${keeping_mrn_arg}
    Select Patient To Merge    mrn_arg=${keeping_mrn_arg}
    Click Merge Button
    Handle Alert    ACCEPT
    ${check_merged}    Run Keyword And Return Status    Common.Page Alert Message    Appointments Successfully Merged & Patient Deleted    300s
    Run Keyword If    "${check_merged}"=="${False}"    Common.Close Modal Popup
    Reload Page
    RETURN    ${check_merged}
    
Input Removing Patient
    [Arguments]    ${removing_mrn_arg}
    Wait Until Element Is Visible    ${removing_patient_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${removing_patient_input}    ${removing_mrn_arg}

Input Keeping Patient
    [Arguments]    ${keeping_mrn_arg}
    Wait Until Element Is Visible    ${keeping_patient_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${keeping_patient_input}    ${keeping_mrn_arg}

Select Patient To Merge
    [Arguments]    ${mrn_arg}
    ${patient_mrn_row}    Set Variable    xpath=//*[contains(@class,'selectable') and contains(text(),'MRN:') and *[text()='${mrn_arg}']]
    Wait Until Element Is Visible    ${patient_mrn_row}    30s
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_mrn_row}    30s
    Run Keyword If    "${check}" == "${False}"   Click Element    ${removing_patient_input}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${patient_mrn_row}

Click Merge Button
    Wait Until Element Is Enabled    ${merge_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${merge_btn}
