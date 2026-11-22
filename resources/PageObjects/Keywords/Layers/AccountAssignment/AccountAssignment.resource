*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${assigned_note_column_title}    //th[contains(text(),'Note')]
${adjust_default_location_btn}    //a[contains(text(),'Adjust Default Location')]
${default_account_select}    //select[@id='DefaultAssignedAccountDropdown']
${assignments_cancel_btn}    //a[contains(text(),'Cancel')]
${assigned_default_accounts_checkbox}    //input[contains(@class,'AssignmentCheckbox') and @disabled='disabled']//following::td[1]
${assigned_account_name_row_total}    //input[contains(@class,'AssignmentCheckbox')]//following::td[1]
${assigned_checked_checkbox}    //input[contains(@class,'AssignmentCheckbox') and not(@disabled='disabled')]

*** Keywords ***
Click Adjust Default Location Button
    Wait Until Element Is Visible    ${adjust_default_location_btn}    30s
    Common.Scroll And Click Element    ${adjust_default_location_btn}

Select Default Account
    [Arguments]    ${location_arg}
    Wait Until Element Is Visible    ${default_account_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${default_account_select}    ${location_arg}

Click Assigned Account Button
    [Arguments]    ${location_arg}
    ${assigned_accounts_checkbox}    Set Variable    //td[contains(text(),'${location_arg}')]//preceding::input[contains(@class,'AssignmentCheckbox')][1]
    Common.Scroll And Click Element    ${assigned_accounts_checkbox}

Input Account Note Field
    [Arguments]    ${location_name}    ${note_arg}
    ${note_accounts_checkbox}    Set Variable    //td[contains(text(),'${location_name}')]//following::input[contains(@class,'accountAssignmentNote')][1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${note_accounts_checkbox}    ${note_arg}

Clear Account Note Field
    [Arguments]    ${location_name}
    ${note_accounts_checkbox}    Set Variable    //td[contains(text(),'${location_name}')]//following::input[contains(@class,'accountAssignmentNote')][1]
    Common.Clear Input Field Until Empty    ${note_accounts_checkbox}