*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Admin    inventory    smoke    aws    INV_01    report.label.owner:Quoc Nguyen

*** Variables ***
${data_input}

*** Test Cases ***
Edit Inventory In Inventory Levels
    [Documentation]    Verify Edit Inventory Levels Sucessfully
    ...       INV_07 
    InventoryLevels.Go To Inventory Level To Change Group Inventory     ${data_input}[checked_location]    ${data_input}[checked_facility]    Group 2
    InventoryLevels.Go To Inventory Level To Change Group Inventory     ${data_input}[checked_location]    ${data_input}[checked_facility]    Group 1

Add New Lot And Edit Lot In Inventory Levels
    [Documentation]    Verify Add And Edit Lot Sucessfully
    ...    INV_08
    ${new_lot}    Random New Lot
    ${new_expired_date}    Random Expired Date Lot
    ${change_lot}    Random New Lot
    ${changed_expired_date}    Random Expired Date Lot
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryLevels.Add New Lot To Inventory Level    ${data_input}[adjust_lot_ndc]    ${new_lot}    ${new_expired_date}
    InventoryLevels.Edit Exist Lot In Inventory Level    ${data_input}[adjust_lot_ndc]    ${new_lot}    ${new_expired_date}    ${change_lot}    ${changed_expired_date}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryLevels.Verify Exist Lot In Inventory Level    ${data_input}[adjust_lot_ndc]    ${change_lot}    ${changed_expired_date}

Adjust Qty Item In Inventory Level And Check Transaction
    [Documentation]    Verify Adjust Qty Item In Inventory Level Sucessfully And Correct Transaction
    ...    INV_09    INV_10
    [Setup]    Setup Test Case Reset Qty
    ${add_qty}    Evaluate    random.randint(1, 10)    random
    Add Qty Items In Inventory Levels    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]    ${add_qty}
    ${adjust_qty}    Evaluate    random.randint(1, 10)    random
    Adjust Qty Items In Inventory Levels    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]    ${adjust_qty}
    Verify Transaction In Inventory Levels    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items] 

Open Inventory Levels Create New Backstock And Verify Feature In New Backstock
    [Documentation]    Verify Feature In Backstock
    ...    INV_06
    [Setup]    Setup Test Case Reset Qty And Delete Backstock
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${inventory_backstock_id}    AvaiableBackstock.Create New Available Backstock    ${data_input}[backstock_name]    ${data_input}[location]
    Build Transfer Item To Backstock    
    ...    ${inventory_backstock_id}    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    ${data_input}[location]    ${data_input}[backstock_name]    ${data_input}[items]    
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    AvaiableBackstock.Open Available Backstock
    AvaiableBackstock.Open View Item In Inventory Backstock    ${inventory_backstock_id}
    ${table_value_dict}    AvaiableBackstock.Get Value Item In View Table Backstock
    AvaiableBackstock.Click Back to Inventory Backstock
    AvaiableBackstock.Delete Inventory Backstock    ${inventory_backstock_id}
    ${expect_value_dict}    Normalize Data Expect To Compare Transfer    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]
    Adjust Qty Items In Inventory Levels   ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]    0
    Should Be Equal    ${table_value_dict}    ${expect_value_dict}               

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}    
    Login To Fusebox    user_name=${Username}    password=${Password}
    Set Price To Each Item Data Test    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Setup Test Case Reset Qty
    Reset Qty Items In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]

Setup Test Case Reset Qty And Delete Backstock
    Reset Qty Items In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${data_input}[items]
    Delete All Backstocks In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]

Teardown Suite
    Close Browser

Set Price To Each Item Data Test
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}
    FOR    ${item}    IN    @{items}
        ${price}    InventoryLevels.Get Best Price Contract    ${checked_location}    ${checked_facility}    ${item}[ndc]    ${item}[uom]
        Set To Dictionary    ${item}    price    ${price}    
    END

Random New Lot
    ${random_lot}    Evaluate    ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789', k=8))    random
    RETURN    ${random_lot}

Random Expired Date Lot
    ${current_time}    Get Time Now
    ${random_year}    Evaluate    random.randint(1, 10)    random
    ${add_day}    Evaluate    ${random_year} * 365   
    ${expired_lot}    Add Time To Date    date=${current_time}    time=${add_day} days    result_format=%m/%d/%Y    date_format=%Y-%m-%d %H:%M:%S.%f
    RETURN    ${expired_lot}
    
Tab To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}

Reset Qty Items In Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}
    FOR    ${item}    IN    @{items}
        InventoryLevels.Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
        InventoryLevels.Search NDC To Open Inventory Adjustment Then Reset Qty    ${item}[ndc]    ${item}[uom]
    END

Delete All Backstocks In Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
    AvaiableBackstock.Open Available Backstock
    ${backstock_id_list}    AvaiableBackstock.Get List Id Inventory Backstock
    FOR    ${backstock_id}    IN    @{backstock_id_list}
        AvaiableBackstock.Delete Inventory Backstock    ${backstock_id}
    END
    
Add Qty Items In Inventory Levels
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}    ${add_qty}
    FOR    ${item}    IN    @{items}
        InventoryLevels.Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
        InventoryLevels.Search NDC To Open Inventory Adjustment Then Add Qty  
        ...    ${item}[ndc]   ${item}[uom]
        ...    ${item}[lot]    ${item}[expired_date]    ${add_qty}
    END

Adjust Qty Items In Inventory Levels
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}    ${adjust_qty}
    FOR    ${item}    IN    @{items}
        InventoryLevels.Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
        ${previous_qty}    InventoryLevels.Search NDC To Get Current Qty    
        ...    ${item}[ndc]   ${item}[uom]
        ...    ${item}[lot]    ${item}[expired_date]
        InventoryLevels.Search NDC To Open Inventory Adjustment Then Adjust Qty  
        ...    ${item}[ndc]   ${item}[uom]
        ...    ${item}[lot]    ${item}[expired_date]    ${adjust_qty}
        ${changed_qty}    Evaluate    ${adjust_qty} - ${previous_qty}
        Set To Dictionary    ${item}    changed_qty=${changed_qty}
    END

Verify Transaction In Inventory Levels
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}
    ${name}    Util.Get User Name    
    FOR    ${item}    IN    @{items}
        ${actual_transaction_list}    InventoryLevels.Get Transaction List In Inventory Level    ${checked_location}    ${checked_facility}    ${item}[ndc]    ${item}[uom]
        ${expect_transaction_item}    Normalize Value Expected Transition In Inventory Levels
        ...    ${checked_location}    ${checked_facility}
        ...    ${item}[ndc]    ${item}[uom]
        ...    Inventory Adjustment    ${name}
        ...    ${item}[changed_qty]    ${item}[lot]           
        ...    ${item}[expired_date]    ${item}[price]
        List Should Contain Value    ${actual_transaction_list}    ${expect_transaction_item}
    END

Build Transfer Item To Backstock
    [Arguments]    ${inventory_backstock_id}    ${checked_location}    ${checked_facility}    ${location}    ${backstock_name}    ${items}
    ${barcodes}    Create List
    FOR    ${item}    IN    @{items}
        FOR    ${barcode}    IN    @{item}[barcodes]
            Append To List    ${barcodes}    ${barcode}
        END
    END
    AvaiableBackstock.Open Transfer Inventory Backstock    ${inventory_backstock_id}
    Tab To Another Window    Build Transfer
    InventoryTransfer.Create Transfter To Backstock
    ...    from_account=${checked_location}    from_facility=${checked_facility} ( Buy & Bill ) 
    ...    from_backstock=-- ${checked_facility} (Buy & Bill ) --    to_backstock=${location} ${backstock_name}
    ...    list_barcode=${barcodes}
    Close Window
    Tab To Another Window    Inventory Levels & Transactions

Normalize Value Expected Transition In Inventory Levels
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}    ${type}    ${create_by}    ${adjustment}    ${lot_no}    ${expired_date}    ${price}       
    ${round_best_price}    Evaluate    round(float(${price}), 2)
    ${covert_expired_date}    Convert Date    ${expired_date}    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${coverted_adjustment}    Evaluate    int(${adjustment})

    ${expected_transaction}    Create Dictionary
    Set To Dictionary    ${expected_transaction}    type=${type}
    Set To Dictionary    ${expected_transaction}    created_by=${create_by}
    Set To Dictionary    ${expected_transaction}    adjustment=${coverted_adjustment}
    Set To Dictionary    ${expected_transaction}    price=${round_best_price}
    Set To Dictionary    ${expected_transaction}    lot_no=${lot_no}
    Set To Dictionary    ${expected_transaction}    expiration=${covert_expired_date}
    RETURN    ${expected_transaction}

Normalize Data Expect To Compare Transfer
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}
    ${normalized_items}    Create List
    FOR    ${index}    ${item}    IN ENUMERATE    @{items}    start=1    
        ${qty}    Evaluate    len(${item}[barcodes])
        ${normalized_item}    Create Dictionary
        Set To Dictionary    ${normalized_item}    index    ${index}
        Set To Dictionary    ${normalized_item}    ndc    ${item}[ndc]
        Set To Dictionary    ${normalized_item}    uom    ${item}[uom]
        Set To Dictionary    ${normalized_item}    lot    ${item}[lot]
        Set To Dictionary    ${normalized_item}    expired_date    ${item}[expired_date]
        Set To Dictionary    ${normalized_item}    price    ${item}[price]
        Set To Dictionary    ${normalized_item}    qty_on_hand    ${qty}
        Append To List    ${normalized_items}    ${normalized_item}
    END
    RETURN    ${normalized_items}
