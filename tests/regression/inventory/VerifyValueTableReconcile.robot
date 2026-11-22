*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Accounting    inventory    Regression    IV_011

*** Test Cases ***
Go To Reconcile Inventory Type Full And Scan Barcode Then Adjust Qty And Verify Value In Table
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_80     [reconcile]_81    [reconcile]_82    [reconcile]_83    [reconcile]_84
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full     ${{['${data_input}[barcode]']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Adjust Actual Qty On Hand All Items In Table Reconcile Equal Expect Qty    ${table_value_dict}
    Verify Value In Table Reconcile    Full
    OpenActiveReconcile.Adjust Actual Qty On Hand All Items In Table Reconcile Not Equal Expect Qty    ${table_value_dict}
    Verify Value In Table Reconcile    Full
    OpenActiveReconcile.Cancel Reconcile

Go To Reconcile Inventory Type Add And Scan Barcode Then Adjust Qty And Verify Value In Table
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_85    [reconcile]_86    [reconcile]_87
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    add     ${{['${data_input}[barcode]']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Adjust Actual Qty On Hand All Items In Table Reconcile Not Equal Expect Qty    ${table_value_dict}
    Verify Value In Table Reconcile    Add
    OpenActiveReconcile.Cancel Reconcile

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}

Setup Test Case
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

Verify Value In Table Reconcile
    [Arguments]    ${type}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Verify All Item Value In Table Reconcile    ${type}    ${table_value_dict}
    Verify All Hard Count Value In Table Reconcile    ${type}    ${table_value_dict}

Verify All Item Value In Table Reconcile
    [Arguments]    ${type}    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            Verify Item Color In Table Reconcile    ${ndc_dict}[ndc]    ${item_dict}[lot]    ${item_dict}[actual_qty]    ${item_dict}[expected_qty] 
            Verify Item Discrepancy Value In Table Reconcile    ${type}    ${item_dict}[discrepancy]    ${item_dict}[actual_qty]    ${item_dict}[expected_qty]
        END
    END

Verify Item Color In Table Reconcile
    [Arguments]    ${ndc}    ${lot}    ${actual_qty}    ${expected_qty}
    IF    ${expected_qty} == ${actual_qty}
        Wait Until Element Is Visible    //tr[contains(.,"${ndc}") and contains(.,"${lot}") and contains(@class,"reconcileRecentlyEdit")]    30s
        Wait Until Element Is Visible    //tr[contains(.,"${ndc}") and contains(.,"${lot}") and contains(@class,"reconcileRecentlyEdit")]/following-sibling::tr[contains(@class,"reconcileRecentlyEdit")]    30s
    ELSE
        Wait Until Element Is Visible    //tr[contains(.,"${ndc}") and contains(.,"${lot}") and contains(@class,"reconcileDiscrepancy")]    30s
        Wait Until Element Is Visible    //tr[contains(.,"${ndc}") and contains(.,"${lot}") and contains(@class,"reconcileDiscrepancy")]/following-sibling::tr[contains(@class,"reconcileDiscrepancy")]    30s
    END

Verify Item Discrepancy Value In Table Reconcile
    [Arguments]    ${type}    ${discrepancy}    ${actual_qty}    ${expected_qty}    
    IF    "${type}" == "Full"
        ${expected_discrepancy}    Evaluate    ${actual_qty} - ${expected_qty}
    END
    IF    "${type}" == "Add"
        ${expected_discrepancy}    Evaluate    ${actual_qty} + ${expected_qty}
    END
    Should Be Equal As Numbers    ${discrepancy}    ${expected_discrepancy}

Verify All Hard Count Value In Table Reconcile
    [Arguments]    ${type}    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        ${calculated_actual_qty_on_hand_hard_count}    Calculate Actual Qty On Hand Hard Count    ${ndc_dict}    
        ${calculated_discrepancy_hard_count}    Calculate Discrepancy Hard Count    ${type}    ${ndc_dict}
        Should Be Equal As Numbers    ${calculated_actual_qty_on_hand_hard_count}    ${ndc_dict}[hard_count][actual_qty]
        Should Be Equal As Numbers    ${calculated_actual_qty_on_hand_hard_count}    ${ndc_dict}[hard_count][discrepancy]
    END

Calculate Actual Qty On Hand Hard Count
    [Arguments]   ${ndc_dict}
    ${calculated_actual_qty_on_hand_hard_count}    Set Variable
    FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
        ${calculated_actual_qty_on_hand_hard_count}    Evaluate    ${calculated_actual_qty_on_hand_hard_count} + ${item_dict}[actual_qty]
    END
    RETURN    ${calculated_actual_qty_on_hand_hard_count}

Calculate Discrepancy Hard Count
    [Arguments]    ${type}   ${ndc_dict}
    ${calculated_discrepancy_hard_count}    Set Variable
    IF    "${type}" == "Full"
        ${calculated_discrepancy_hard_count}    Evaluate    ${ndc_dict}[hard_count][actual_qty] - ${ndc_dict}[hard_count][expected_qty]     
    END  
    IF    "${type}" == "Add"
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${calculated_discrepancy_hard_count}    Evaluate    ${calculated_discrepancy_hard_count} + ${item_dict}[discrepancy]
        END
    END
    RETURN    ${calculated_discrepancy_hard_count}
