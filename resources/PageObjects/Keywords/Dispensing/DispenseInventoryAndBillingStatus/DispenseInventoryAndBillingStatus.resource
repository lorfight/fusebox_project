*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${filter_by_item_input}    //div[text()='Filter By Item']//following::input[@data-role="datepicker"][1]
${report_date_input}    //div[text()='Report Date']//following::input[@data-role="datepicker"][1]
${select_a_location_table}    //div[text()='Select A Location']//following::div[2]

*** Keywords ***
Go To Dispense, Inventory, and Billing Status
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Dispense, Inventory, and Billing Status

Go To Daily Dispense, Inventory, and Billing Status Page
    Switch Window    title=Report Viewer
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Report Viewer
    Set Window Size    1920    1080

Verify Dispense, Inventory, and Billing Status Is Displayed All Fields Correctly
    ${column_name_list}    Create List    
        ...    Patient
        ...    DOB
        ...    Dispensed Total
        ...    Submitted / Billed Out
        ...    Starting Inventory
        ...    Received
        ...    Other Adjustments
        ...    Dispensed Quantity
        ...    Expected Quantity
        ...    Counted Quantity
        ...    Count Discrepancy
        ...    Billing Discrepancy

    FOR    ${column_name}    IN    @{column_name_list}
        ${column}    Set Variable    (//div[normalize-space(.)='${column_name}'])[1]
        Wait Until Element Is Visible    ${column}    120s
    END

Verify Dispense, Inventory, and Billing Status Document Map Area Is Displayed All Fields Correctly
    ${element_list}    Create List    
    ...    ${filter_by_item_input}
    ...    ${report_date_input}
    ...    ${select_a_location_table}

    FOR    ${element}    IN    @{element_list}
        Wait Until Element Is Visible    ${element}    30s
    END 

Close Daily Dispense, Inventory, and Billing Status Page Page In Report Reviewer Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}
