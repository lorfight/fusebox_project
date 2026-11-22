*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${patient_history_log_page}    //div[text()='Patient History Log']//ancestor::div[@class='layer']
${patient_history_log_find_patient_input}    //div[text()='Find Patient']//following::input[@data-role="datepicker"][1]
${patient_history_log_find_medication_input}    //div[text()='Find Medication']//following::input[@data-role="datepicker"][1]
${patient_history_log_find_lot_number_input}    //div[text()='Find Lot Number']//following::input[@data-role="datepicker"][1]
${patient_history_log_start_date_input}    //div[text()='Start Date']//following::input[@data-role="datepicker"][1]
${patient_history_log_end_date_input}    //div[text()='End Date']//following::input[@data-role="datepicker"][1]
${patient_history_log_account_filter_input}    //div[text()='AccountFilter']//following::input[1]
${patient_history_log_select_account_table}    //div[text()='Select Account']//following::div[2]

*** Keywords ***
Go To View Patient History
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: View Patient History

Go To Patient History Log Page
    Switch Window    title=Report Viewer
    Wait Until Keyword Succeeds    60s    1s    Title Should Be    Report Viewer
    Set Window Size    1920    1080

Verify Patient History Log Sheet Page Is Visible
    ${element_list}    Create List    
    ...    ${patient_history_log_page}
    ...    ${patient_history_log_find_patient_input}
    ...    ${patient_history_log_find_medication_input}
    ...    ${patient_history_log_find_lot_number_input}
    ...    ${patient_history_log_start_date_input}
    ...    ${patient_history_log_end_date_input}
    ...    ${patient_history_log_account_filter_input}
    ...    ${patient_history_log_select_account_table}
    
    FOR    ${element}    IN    @{element_list}
        Wait Until Element Is Visible    ${element}    30s
    END 

Close Patient History Log In Report Reviewer Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}