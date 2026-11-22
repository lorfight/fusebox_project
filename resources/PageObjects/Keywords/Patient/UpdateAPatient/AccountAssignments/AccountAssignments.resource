*** Settings ***
Resource    ../../../Layers/AccountAssignment/AccountAssignment.resource

*** Variables ***
${account_assignments_tab}    //a[@id='AccountAssignment']
${assigned_accounts_title}    //h3[contains(text(),'Assigned Accounts')]

*** Keywords ***
Open Account Assignments Tab
    Navigate To The Tab    
    ...    tab_name=${account_assignments_tab}    
    ...    title_name=${assigned_accounts_title}

Verify Default Account Select Shows All Locations Have Same HeadOffice
    [Arguments]    ${accounts_have_same_headoffice}
    Click Adjust Default Location Button
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${default_account_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${default_account_select}
    Lists Should Be Equal    ${default_account_list}    ${accounts_have_same_headoffice}

Selecting Default Account Triggers A Confirmation Popup
    [Arguments]    ${location_arg}    ${status}
    Click Adjust Default Location Button
    Select Default Account    ${location_arg}
    IF    '${status}' == 'ACCEPT'
        Alert Should Be Present    Are you sure you would like to change the default location for this patient?    ACCEPT
        Common.Page Alert Message    Patient Default Account Successfully Assigned
    ELSE IF    '${status}' == 'DISMISS'
        Handle Alert    action=DISMISS
        Reload Page
        Open Account Assignments Tab
    END

Check The Default Account Remains Changed
    [Arguments]    ${location_arg}
    Click Adjust Default Location Button
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${account_selected}   Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${default_account_select}
    Should Be Equal     ${account_selected}    ${location_arg}
    ${account_name}   Wait Until Keyword Succeeds    30s    1s    Get Text    ${assigned_default_accounts_checkbox}
    Should Contain    ${account_name}    ${location_arg}

Compare Account Name List With Default Location Select
    Click Adjust Default Location Button
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${default_account_select_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${default_account_select}
    ${account_name_list}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get WebElements    ${assigned_account_name_row_total}
    ${default_account_name_list}    Create List
    FOR    ${account_name}    IN    @{account_name_list}
        ${account_name_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${account_name}
        ${account_name_txt}    Fetch From Left    ${account_name_txt}    \ (\
        Append To List    ${default_account_name_list}    ${account_name_txt}
    END
    Lists Should Be Equal    ${default_account_select_list}    ${default_account_name_list}

Select Multiple Checkboxes In "Assigned" Column
    [Arguments]    ${location_list}
    FOR    ${location_index}    IN    @{location_list}
        Checking An "Assigned" checkbox    status=select    msg=Patient Account Successfully Assigned    location_arg=${location_index}
    END
    ${checked_checkbox_list}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get WebElements    ${assigned_checked_checkbox}
    FOR    ${checkbox_index}    IN    @{checked_checkbox_list}
        ${checked}    Wait Until Keyword Succeeds    30s     1s    SeleniumLibrary.Get Element Attribute    ${checkbox_index}    checked
        Should Be Equal    ${checked}    true
    END
    FOR    ${location_index}    IN    @{location_list}
        Checking An "Assigned" checkbox    status=unselect    msg=Patient Account Removed    location_arg=${location_index}
    END

Checking An "Assigned" checkbox
    [Arguments]    ${status}    ${msg}    ${location_arg}
    Click Assigned Account Button    ${location_arg}
    IF    '${status}' == 'select'
        Common.Page Alert Message    Patient Account Successfully Assigned
    ELSE IF    '${status}' == 'unselect'
        Common.Page Alert Message    Patient Account Removed
    END

Account Name Has Disabled Checkbox
    [Arguments]    ${location_name}
    ${assigned_accounts_checkbox}    Set Variable    //td[contains(text(),'${location_name}')]//preceding::input[contains(@class,'AssignmentCheckbox')][1]
    ${checkbox_disabled}    SeleniumLibrary.Get Element Attribute    ${assigned_accounts_checkbox}    disabled
    Should Be Equal    ${checkbox_disabled}    true

Verify "Account Name" Shows Fomat Exactly
    [Arguments]    ${location_name}
    ${assigned_account_name}    Set Variable    //td[contains(text(),'${location_name}')]
    ${account_name_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${assigned_account_name}
    Should Match Regexp    ${account_name_txt}    ^${location_name}\\s\\(\\d+\\)$

Save "Note" Textbox By Clicking Outside
    [Arguments]    ${location_name}
    Input Unlimited Characters Into Note Textbox    ${location_name}
    Common.Scroll And Click Element    ${assigned_note_column_title}
    Run Keyword And Ignore Error    Common.Page Alert Message    Patient Account Successfully Updated    timeout=3s
    Clear Account Note Field    ${location_name}
    Common.Scroll And Click Element    ${assigned_note_column_title}
    Run Keyword And Ignore Error    Common.Page Alert Message    Patient Account Successfully Updated    timeout=3s

Save "Note" Textbox By Pressing Tab Key
    [Arguments]    ${location_name}
    Input Unlimited Characters Into Note Textbox    ${location_name}
    Press Keys    None    TAB
    Run Keyword And Ignore Error    Common.Page Alert Message    Patient Account Successfully Updated    timeout=3s
    Clear Account Note Field    ${location_name}
    Press Keys    None    TAB
    Run Keyword And Ignore Error    Common.Page Alert Message    Patient Account Successfully Updated    timeout=3s

Input Unlimited Characters Into Note Textbox
    [Arguments]    ${location_name}
    ${action_reason_txt}    Generate Random String    500    [LETTERS]
    Input Account Note Field    ${location_name}    ${action_reason_txt}

Return Default Location
    [Arguments]    ${location_arg}
    Click Adjust Default Location Button
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${selected_value}    Get Selected List Label    ${default_account_select}
    IF    '${selected_value}' != '${location_arg}'
        Selecting Default Account Triggers A Confirmation Popup    location_arg=${location_arg}    status=ACCEPT
    END
    ${checkbox_visible}    SeleniumLibrary.Get Element Attribute    ${assigned_checked_checkbox}    checked
    IF    '${checkbox_visible}' == 'true'
        Common.Scroll And Click Element    ${assigned_checked_checkbox}
        Common.Page Alert Message    Patient Account Removed
    END