*** Settings ***
Resource    ../Common/InventoryUtils.resource

*** Variables ***
${generate_on_modal_button_xpath}    //button[@id="SaveReportBtn"]
${close_on_modal_button_xpath}    //button[@id="CloseReportBtn"]
${unselect_all_button_xpath}    //a[@id="ReportUnselectAllAccounts"]
${report_start_day_input_xpath}    //input[@id="ReportingStartDate"]
${search_account_input_xpath}    //input[@id="AccountSearchText"]
${find_account_button_xpath}    //button[@id="ReportAccountSearchFindBtn"]
${report_select_xpath}    //select[@id="ReportTypeSelector"]
${medication_select_xpath}    //select[@id="ProprietaryNames"]
${association_select_xpath}    //select[@id="SelectedAssociation"]

*** Keywords ***
Go To On Hand Inventory
    Click Element    link:Inventory
    Click Element    link:On Hand Inventory
    Wait Until Element Contains    id=ReportUniversalModalPopup    Comprehensive On Hand Inventory Report Filter Selector    30s
    Util.Waiting For Loading

Click Generate Button On Modal
    Wait Until Element Is Enabled    ${generate_on_modal_button_xpath}    30s
    Click Element    ${generate_on_modal_button_xpath}

Click Close Button On Modal
    Wait Until Element Is Enabled    ${close_on_modal_button_xpath}    30s
    Click Element    ${close_on_modal_button_xpath}

Fill Report Start Day Input
    [Arguments]    ${start_day}
    Wait Until Element Is Visible    ${report_start_day_input_xpath}    30s
    Input Text    ${report_start_day_input_xpath}    ${start_day}
    Press Keys    None    TAB

Click Unselect All Button
    Wait Until Element Is Enabled    ${unselect_all_button_xpath}    30s
    Click Element    ${unselect_all_button_xpath}

Fill Search Account Input
    [Arguments]    ${account}
    Wait Until Element Is Enabled    ${search_account_input_xpath}    30s
    Input Text    ${search_account_input_xpath}    ${account}

Click Find Account Button
    Wait Until Element Is Enabled    ${find_account_button_xpath}    30s
    Click Button    ${search_account_input_xpath}

Check Account Checkbox
    [Arguments]    ${account}
    ${account_checkbox_xpath}    Set Variable    //div[contains(text(),"${account}")]/following-sibling::div/input
    Wait Until Element Is Enabled    ${account_checkbox_xpath}    30s
    Select Checkbox    ${account_checkbox_xpath}

Search Account 
    [Arguments]    ${account}
    Fill Search Account Input    ${account}
    Click Find Account Button
    Util.Waiting For Loading

Get Report Type Labels
    Wait Until Element Is Visible    ${report_select_xpath}    30s
    ${labels}    Get List Items    ${report_select_xpath}
    RETURN       ${labels}

Get Medication Labels
    Wait Until Element Is Enabled    ${medication_select_xpath}    30s
    ${labels}    Get List Items    ${medication_select_xpath}
    RETURN       ${labels}

Get Assocciation Labels
    Wait Until Element Is Visible        ${association_select_xpath}    30s
    ${labels}    Get List Items    ${association_select_xpath}
    RETURN    ${labels}

Select Report Type Option
    [Arguments]    ${report_type}
    Wait Until Element Is Enabled    ${report_select_xpath}    30s
    Select From List By Label    ${report_select_xpath}    ${report_type}

Select Medication Option
    [Arguments]    ${medication_name}
    Wait Until Element Is Enabled    ${medication_select_xpath}    30s
    Select From List By Label    ${medication_select_xpath}    ${medication_name}

Select Association Option
    [Arguments]    ${association}
    Wait Until Element Is Enabled    ${association_select_xpath}    30s
    Select From List By Label    ${association_select_xpath}    ${association}

Fill All Data To On Hand Inventory Modal
    [Arguments]    ${account}    ${start_day}    ${report_type}    ${medication_name}    ${association}
    Fill Report Start Day Input    ${start_day}
    Select Report Type Option    ${report_type}
    Select Medication Option    ${medication_name}
    Select Association Option    ${association}
    Click Unselect All Button
    Search Account    ${account}
    Check Account Checkbox    ${account}

Complete Generate On Hand Inventory Report
    [Arguments]    ${account}    ${start_day}    ${report_type}    ${medication_name}    ${association}
    Fill All Data To On Hand Inventory Modal    ${account}    ${start_day}    ${report_type}    ${medication_name}    ${association}
    Click Generate Button On Modal
    Click Close Button On Modal


     
    


