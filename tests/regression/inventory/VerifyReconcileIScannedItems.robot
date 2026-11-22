*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite
Test Tags    test:retry(2)    Accounting    Regression    inventory    IV_004

*** Test Cases ***
Verify Inventory Reconcile Item Price Use Scanned Barcode In Serialized Item Tracker
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_13
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${data_input}[barcode_reconciled]']}}
    OpenActiveReconcile.Select Checkbox Unscanned Items as Lost
    OpenActiveReconcile.Complete Reconcile
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    SerializedItemTracker.Open Serialized Item Tracker 
    ${expect_value_dict_list}    SerializedItemTracker.Get Item Barcode Value By Table Tab Tracker
    SerializedItemTracker.Close Serialize Item Tracker
    ${list_barcode}    Create List
    FOR    ${item}    IN    @{expect_value_dict_list}
        Append To List    ${list_barcode}    ${item}[barcode]
        Remove From Dictionary    ${item}    barcode  
    END
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${list_barcode}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    ${actual_value_dict_list}    Normalize Item Value Reconcile To Serialized Tracker Format    ${table_value_dict}
    OpenActiveReconcile.Cancel Reconcile
    ${expect_value_dict_list}    Evaluate    sorted(${expect_value_dict_list}, key=lambda x: x['ndc'])
    ${actual_value_dict_list}    Evaluate    sorted(${actual_value_dict_list}, key=lambda x: x['ndc'])
    Should Be Equal    ${expect_value_dict_list}    ${actual_value_dict_list}

Verify Inventory Reconcile Item Price Use Scanned Barcode Not In Serialized Item Tracker
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_14
    ...  report.label.owner:Quoc Nguyen
    ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${random_barcode}']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Verify Price Item Value In Reconcile To Best Price    ${table_value_dict}
    OpenActiveReconcile.Cancel Reconcile

Verify Inventory Reconcile Item Price Use Scanned Barcode Not Have Lot Exist In Inventory Level
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_15
    ...  report.label.owner:Quoc Nguyen
    ${random_lot}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${barcode_with_random_lot}    Set Variable    ${data_input}[barcode_not_exist]${random_lot}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode_with_random_lot}']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Verify Price Item Value In Reconcile To Best Price    ${table_value_dict}
    OpenActiveReconcile.Cancel Reconcile               

Verify Inventory Reconcile Item Price Use Scanned Barcode Which is Utilized
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_16
    ...  report.label.owner:Quoc Nguyen
    ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${random_barcode}']}}
    OpenActiveReconcile.Complete Reconcile
    InventoryTransfer.Create Transfer
    ...    from_account=${data_input}[checked_location]    from_facility=${data_input}[checked_facility] ( Buy & Bill ) 
    ...    to_account=${data_input}[checked_location]    to_facility=${data_input}[to_facility]
    ...    list_barcode=${{['${random_barcode}']}}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${random_barcode}']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Verify Price Item Value In Reconcile To Best Price    ${table_value_dict}
    OpenActiveReconcile.Cancel Reconcile  

Verify Inventory Reconcile To Inventory Scan Before And After When Scan One Item
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_34    [Reconcile_partial]_35.1    
    ...  report.label.owner:Quoc Nguyen
    ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${random_barcode}']}}
    Verify Before After Reconcile And Inventory
    
Verify Inventory Reconcile To Inventory Scan Before And After When Scan One Item With Large Qty By Scanning
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_35
    ...  report.label.owner:Quoc Nguyen
    ${list_barcodes_large_qty}    Create List
    FOR    ${index}    IN RANGE    0    10
        ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
        ${random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[lot_part]
        Append To List    ${list_barcodes_large_qty}    ${random_barcode}    
    END
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${list_barcodes_large_qty}
    Wait Until Element Is Not Visible    //*[@id="ScanNotification"]    60s
    Verify Before After Reconcile And Inventory

Verify Inventory Reconcile To Inventory Scan Before And After When Scan Dup Item
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_44    [Reconcile_partial]_45
    ...  report.label.owner:Quoc Nguyen
    ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[dup_lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${random_barcode}']}}
    Verify Before After Reconcile And Inventory

Verify Inventory Reconcile To Inventory Scan Before And After When Scan Multi Items
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_46    [Reconcile_partial]_49
    ...  report.label.owner:Quoc Nguyen
    ${serial_number}        Generate Random String    8    ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    ${vial_random_barcode}    Set Variable    ${data_input}[ndc_part]${serial_number}${data_input}[lot_part]
    ${syringe_random_barcode}    Set Variable    ${data_input}[syringe_ndc_part]${serial_number}${data_input}[syringe_lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${vial_random_barcode}', '${syringe_random_barcode}']}}
    Verify Before After Reconcile And Inventory

Perform Two Reconcile On One Account
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_48
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    OpenActiveReconcile.Reconcile Item full And Scan ${{['${data_input}[barcode_reconciled]']}} Then Complete
    Login To Fusebox    user_name=${Username}    password=${Password}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    OpenActiveReconcile.Reconcile Item full And Scan ${{['${data_input}[barcode_reconciled]']}} Then Complete
    Close Browser
    Switch Browser    1

Verify Inventory Not Reconcile Wrong Item Belongs Another Inventory
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [Reconcile_partial]_47
    ...  report.label.owner:Quoc Nguyen
    [Setup]    Setup Test Case For Two Inventory Account
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryLevels.Search NDC To Open Inventory Adjustment Then Add Qty    ${data_input}[item_1][ndc]    ${data_input}[item_1][uom]    ${data_input}[item_1][lot]    ${data_input}[item_1][expired_date]   3
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${table_value_dict_ndc_1}    OpenActiveReconcile.Get Value Item In Table Reconcile

    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location_2]    ${data_input}[checked_facility_2]
    InventoryLevels.Search NDC To Open Inventory Adjustment Then Add Qty    ${data_input}[item_2][ndc]    ${data_input}[item_2][uom]    ${data_input}[item_2][lot]    ${data_input}[item_2][expired_date]   2  
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location_2]    ${data_input}[checked_facility_2]
    ${table_value_dict_ndc_2}    OpenActiveReconcile.Get Value Item In Table Reconcile
    
    Should Not Be Equal    ${table_value_dict_ndc_1}    ${table_value_dict_ndc_2}

    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryLevels.Search NDC To Open Inventory Adjustment Then Adjust Qty    ${data_input}[item_1][ndc]    ${data_input}[item_1][uom]    ${data_input}[item_1][lot]    ${data_input}[item_1][expired_date]   0

    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location_2]    ${data_input}[checked_facility_2]
    InventoryLevels.Search NDC To Open Inventory Adjustment Then Adjust Qty    ${data_input}[item_2][ndc]    ${data_input}[item_2][uom]    ${data_input}[item_2][lot]    ${data_input}[item_2][expired_date]   0

*** Keywords ***
Teardown Test Case 
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Setup Suite
    ${data_input}    CommonKeywords.Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}

Setup Test Case
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]

Setup Test Case For Two Inventory Account
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location_2]    ${data_input}[checked_facility_2]

Teardown Suite
    Close Browser Session
Normalize Item Value Reconcile To Serialized Tracker Format
    [Arguments]    ${table_value_dict}
    ${actual_value_dict_list}    Create List
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${actual_value_dict}    Create Dictionary
            Set To Dictionary    ${actual_value_dict}    ndc=${ndc_dict}[ndc]
            Set To Dictionary    ${actual_value_dict}    uom=${ndc_dict}[uom]
            Set To Dictionary    ${actual_value_dict}    lot=${item_dict}[lot]
            
            ${coverted_date}    Convert Date    ${item_dict}[expired_date]     result_format=%m/%d/%Y    date_format=%m/%d/%Y

            Set To Dictionary    ${actual_value_dict}    expired_date=${coverted_date}
            Append To List    ${actual_value_dict_list}    ${actual_value_dict}
        END
    END
    RETURN    ${actual_value_dict_list}

Verify Price Item Value In Reconcile To Best Price
    [Arguments]    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${expect_price}    InventoryLevels.Get Best Price Contract    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${ndc_dict}[ndc]    ${ndc_dict}[uom]
            InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]    
            ${actual_price}    OpenActiveReconcile.Get Price Item In View All Items With Index    ${item_dict}[index]
            Should Be Equal As Numbers    ${expect_price}    ${actual_price}
        END
    END

Verify All Item Value In Inventory Reconcile To Breakout Inventory Level
    [Arguments]    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${data_item_inventory_level}    InventoryLevels.Get Item List In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${ndc_dict}[ndc]    ${ndc_dict}[uom]
            Verify Item Value In Inventory Reconcile To Breakout Inventory Level    ${data_item_inventory_level}    ${ndc_dict}[list_item]    
        END
    END

Verify Item Value In Inventory Reconcile To Breakout Inventory Level
    [Arguments]    ${lot_breakout_data_dict}    ${item_reconcile_data_dict}
    ${normalized_lot_breakout_data_dict}    Normalize Value From Lot Breakout In Inventory Level    ${lot_breakout_data_dict}
    ${normalized_item_reconcile_data_dict}    Normalize Value From Reconcile Table In Inventory Reconcile   ${item_reconcile_data_dict}
    Should Be Equal    ${normalized_lot_breakout_data_dict}    ${normalized_item_reconcile_data_dict}

Verify Before After Reconcile And Inventory
    ${before_table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${before_table_value_dict}
    OpenActiveReconcile.Complete Reconcile
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    ${after_table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${after_table_value_dict}
    Should Be Equal    ${before_table_value_dict}    ${after_table_value_dict}
    Verify All Item Value In Inventory Reconcile To Breakout Inventory Level    ${after_table_value_dict}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${new_table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Verify Qty Reconcile In Old Reconcile And New Reconcile    ${after_table_value_dict}    ${new_table_value_dict}

Verify Qty Reconcile In Old Reconcile And New Reconcile
    [Arguments]    ${old_table_value_dict}    ${new_table_value_dict}
    FOR    ${ndc_index}    ${ndc_dict}    IN ENUMERATE    @{new_table_value_dict}
        FOR    ${item_index}    ${item_dict}    IN ENUMERATE    @{ndc_dict}[list_item]
            Should Be Equal As Numbers    ${item_dict}[last_qty]    ${old_table_value_dict}[${ndc_index}][list_item][${item_index}][actual_qty]
        END
    END

Normalize Value From Lot Breakout In Inventory Level
    [Arguments]    ${lot_breakout_data_dict}
    ${normalized_lot_breakout_data_dict_list}    Create List
    FOR    ${lot_breakout_data}    IN    @{lot_breakout_data_dict}
        ${coverted_expired_date}    Convert Date    ${lot_breakout_data}[expired_date]    result_format=%Y-%m-%d    date_format=%m/%d/%Y
        ${covert_price}    Evaluate    round(float(${lot_breakout_data}[price]), 2)
        ${covert_cost}    Evaluate    round(float(${lot_breakout_data}[cost]), 2)
        ${normalized_lot_breakout_data_dict}    Create Dictionary
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    lot=${lot_breakout_data}[lot]
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    expired_date=${coverted_expired_date}
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    price=${covert_price}
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    qty_on_hand=${lot_breakout_data}[qty_on_hand]
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    cost=${covert_cost}
        Append To List    ${normalized_lot_breakout_data_dict_list}    ${normalized_lot_breakout_data_dict}
    END 
    RETURN    ${normalized_lot_breakout_data_dict_list}

Normalize Value From Reconcile Table In Inventory Reconcile
    [Arguments]    ${uom_reconcile_data_dict}
    ${normalized_uom_reconcile_data_dict_list}    Create List
    FOR    ${uom_reconcile_data}    IN    @{uom_reconcile_data_dict}
        ${coverted_expired_date}    Convert Date    ${uom_reconcile_data}[expired_date]    result_format=%Y-%m-%d    date_format=%m/%d/%Y
        ${covert_price}    Evaluate    round(float(${uom_reconcile_data}[price]), 2)
        ${coverted_cost}    Evaluate    ${uom_reconcile_data}[actual_qty] * ${covert_price}
        ${normalized_uom_reconcile_data_dict}    Create Dictionary
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    lot=${uom_reconcile_data}[lot]
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    expired_date=${coverted_expired_date}
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    price=${covert_price}
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    qty_on_hand=${uom_reconcile_data}[actual_qty]
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    cost=${coverted_cost}
        Append To List    ${normalized_uom_reconcile_data_dict_list}    ${normalized_uom_reconcile_data_dict}
    END 
    RETURN    ${normalized_uom_reconcile_data_dict_list}