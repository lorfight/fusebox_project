*** Settings ***
Resource    ../../Common/InventoryFilter.resource

*** Variables ***
${open_active_reconcile}    //*[contains(@class,"active")]//*[contains(text(),"Open Active Reconcile")]
${cancel_reconcile_btn}    //*[contains(@class,'active')]//*[contains(text(),'Cancel Reconcile')]
${back_to_list_btn}    //*[contains(@class,'active')]//*[contains(text(),' Back to List')]
${save_complete_reconcile_btn}    //*[@id='SaveBtn' and text()='Continue & Complete']
${adding_qty_input}    //*[@id='AddingQty']
${assign_btn}    //*[text()='Assign ']
${select_iItem_lot}    //*[@id='item_LotNumber'']
${search_assign_product_input}    //*[@id='InventoryReconcileItemAssignSearchValues']
${search_assign_product_btn}    //*[@id='InventoryReconcileItemAssignFindButton']
${fill_empty_cell_btn}    //*[contains(@class,'active')]//*[contains(text(),'Fill Empty Cells with Zero')]
${complete_reconcile_noticed_modal}    //*[contains(text(),'Check for')]
${unscanned_items_as_lost_check}    //*[@id='UnscannedItemsCheckbox']
${reconcile_inventory_id_xpath}    //*[@id='InventoryReconcileId']
${status_reconcile}    //*[contains(@class,'active')]//span[preceding-sibling::strong[text()='Status: ']]
${reset_to_only_scanned_products_xpath}    //*[contains(@class,'active')]//*[contains(text(),'Reset to Only Scanned Products')]
${preview_reconcile_changes_xpath}    //*[contains(@class,"active")]//*[contains(text(),"Preview Reconcile Changes")]
${created_reconcile_user_xpath}    //strong[contains(text(),"Created By")]/following-sibling::span
${dos_appointment_table_inventory_reconcile_xpath}    //*[@id="SubModalPopup"]//table[@class="table table-bordered"]

${reconcile_table_xpath}    //*[contains(@class,'active')]//*[@id='ReconciledItemsTable']/div/table
${view_all_item_table_xpath}    //table[contains(@id,"DuplicateReconcileItemTable")]

*** Keywords ***

Open Active Reconcile
    Wait Until Page Contains Element    ${open_active_reconcile}
    ${open_active_reconcile_onclick}    SeleniumLibrary.Get Element Attribute    ${open_active_reconcile}    onclick
    Execute Javascript    ${open_active_reconcile_onclick}
    Waiting For Loading

Select Type Reconcile
    [Arguments]    ${type}
    Wait Until Page Does Not Contain Element    //*[@id="ReconciledItemsTable"]/i     timeout=30s
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[contains(text(),"Inventory Reconciliation")]    timeout=20s
    Click Element    //*[contains(@class,"active")]//*[@data-type='${type}']
    Waiting For Loading

Cancel Reconcile
    Wait Until Element Is Visible     ${cancel_reconcile_btn}    timeout=30s
    Util.Scroll To Bottom
    ${cancel_reconcile_onclick}    SeleniumLibrary.Get Element Attribute    ${cancel_reconcile_btn}    onclick
    Execute Javascript    ${cancel_reconcile_onclick}
    Wait Until Keyword Succeeds    5 times    1 second    Handle Alert

Back To List
    Wait Until Element Is Enabled    ${back_to_list_btn}
    Click Element    ${back_to_list_btn}
    Wait Until Element Is Not Visible    ${back_to_list_btn}    timeout=10s

Reset Assigned Products
    Util.Scroll Into View    locator="//*[contains(@class,'active')]//*[contains(text(),'Reset Assigned Products')]"
    Click Element    //*[contains(@class,"active")]//*[contains(text(),"Reset Assigned Products")]
    Wait Until Keyword Succeeds    5 times    1    Handle Alert

Reset to Only Scanned Products
    Wait Until Element Is Visible     ${reset_to_only_scanned_products_xpath}    30s
    Util.Scroll Into View    "${reset_to_only_scanned_products_xpath}"
    Click Element    ${reset_to_only_scanned_products_xpath}
    Wait Until Keyword Succeeds    5 times    1    Handle Alert And Return Its Text
    Waiting For Loading
    Sleep    1s    # Don't have any other options        

Fill Empty Reconcile
    [Documentation]    Fill empty cells with zero in reconcile table
    ${fill_empty_cell_with_zero_onclick}    Set Variable    ZeroAllEmptyReconcileSlots()
    Execute Javascript    ${fill_empty_cell_with_zero_onclick}
    Wait Until Page Contains    Reconcile item updated!    timeout=5s

Get Reconcile History id
    ${reconcile_history_id}=    SeleniumLibrary.Get Element Attribute   ${reconcile_inventory_id_xpath}    value
    Run Keyword And Ignore Error     Set Test Variable    ${reconcile_history_id}

Get Name User Create Reconcile
    Wait Until Element Is Visible    ${created_reconcile_user_xpath}
    ${name_user_create}    Get Text    ${created_reconcile_user_xpath}
    RETURN     ${name_user_create}

Return Reconcile History id
    ${reconcile_history_id}=    SeleniumLibrary.Get Element Attribute   ${reconcile_inventory_id_xpath}    value
    RETURN    ${reconcile_history_id}

Click Complete Reconcile
    Util.Scroll To Bottom
    Click Element    //*[contains(@class,"active")]//*[@id='CompleteReconcile']

Click Request Approval Reconcile
    Util.Scroll To Bottom
    ${request_approval_onclick}    SeleniumLibrary.Get Element Attribute    //*[contains(@class,"active")]//*[text()='Request Approval ']    onclick
    execute javascript    ${request_approval_onclick}

Click Preview Reconcile Changes
    Wait Until Element Is Visible     ${preview_reconcile_changes_xpath}    30s
    Util.Scroll To Bottom
    Click Element    ${preview_reconcile_changes_xpath}

Save Complete Reconcile
    Waiting For Loading
    Wait Until Element Is Not Visible    //*[@id='AppointmentReconcileLoadingSpinner']//i[@class='fa fa-spinner fa-4x fa-spin']    60s
    Wait For Condition
    ...    return document.readyState === 'complete' && jQuery.active === 0
    ...    timeout=30s
    Wait Until Element Is Enabled    ${save_complete_reconcile_btn}    timeout=10s
    Wait Until Keyword Succeeds    5times    3s     Click Element    ${save_complete_reconcile_btn}
    Wait Until Page Does Not Contain    Reconcile Processing    timeout=120s
    Waiting For Loading
    Wait Until Page Contains Element     //*[contains(@class,'active')]//*[text()="Open Active Reconcile"]    timeout=30s    error=Loading Complete Reconcile Failed

Save Incompleted Reconcile
    Wait Until Element Is Enabled    ${save_complete_reconcile_btn}    timeout=10s
    Wait Until Keyword Succeeds    5s    1     Click Element    ${save_complete_reconcile_btn}
    # Wait Until Page Does Not Contain    Reconcile Processing    timeout=120s

View All Item
    Wait Until Element Is Enabled    link:View All Items
    CLick Element    link:View All Items
    Wait Until Element Is Visible    //table[contains(@id,"DuplicateReconcileItemTable")]

Complete Log
    [Arguments]    ${reconcile_history_id}
    ${complete_log_btn}    Set Variable    //a[@href='/Report/InventoryReconcileHistory?InventoryReconcileId=${reconcile_history_id}']
    Click Element    ${complete_log_btn}
    Title Should Be    Report Viewer

Select Checkbox Unscanned Items as Lost
    Wait Until Element Is Visible    ${UnscannedItemsAsLostCheck}    timeout=10s
    Util.Scroll To Bottom
    Select Checkbox    ${UnscannedItemsAsLostCheck}

Open Manually Add Products
    Util.Scroll To Bottom
    Wait Until Element Is Enabled     //*[contains(text(), 'Manually Add Products ')]   timeout=10s
    Execute Javascript    InventoryReconcileManuallyAddProduct();
    Waiting For Loading

Scan Barcode Reconcile
    [Arguments]    ${barcode}
    ${barcode_count}    Get Length    ${barcode}
    Scan List Barcode    ${barcode}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    //*[@id="ScanNotification" and text()="${barcode_count}"]    timeout=120s
    Waiting For Loading

Add Item
    Click Element    link:Add Item
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[text()="Inventory Reconcile Adjustment"]    timeout=30s
    Waiting For Loading

Get Value Item In Table Reconcile
    ${table_html}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${reconcile_table_xpath}    outerHTML
    ${table_value_dict}    Utils.Get Data In Html Table In Reconcile Screen   ${table_html}
    RETURN    ${table_value_dict}

Get Appointment DOS In Inventory Reconcile
    ${table}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${dos_appointment_table_inventory_reconcile_xpath}    outerHTML
    ${list_appointment}    Utils.Get All Appointment Dos In Inventory Reconcile    ${table}
    RETURN    ${list_appointment}

Adjust Actual Qty On Hand Item In Table Reconcile With Index
    [Arguments]    ${index}    ${actual_qty_on_hand}    ${discrepancy}
    Wait Until Element Is Enabled    id=ReconcileLine_${index}
    Input Text    id=ReconcileLine_${index}    ${actual_qty_on_hand}
    Run Keyword If   "${discrepancy}" != "-"
    ...     Util.Wait Alert Message Show And Disappear    Please input a valid number.
    Press Keys    id=ReconcileLine_${index}    TAB        
    Util.Wait Alert Message Show And Disappear    Reconcile item updated!
    Execute Javascript    document.getElementById("ReconcileLine_${index}").setAttribute("value","${actual_qty_on_hand}")

Adjust Actual Qty On Hand All Items In Table Reconcile Equal Expect Qty
    [Arguments]    ${table_value_dict}   
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${actual_qty_on_hand}    Set Variable    ${item_dict}[expected_qty]
            Adjust Actual Qty On Hand Item In Table Reconcile With Index    ${item_dict}[index]    ${actual_qty_on_hand}    ${item_dict}[discrepancy]
        END
    END

Adjust Actual Qty On Hand All Items In Table Reconcile Not Equal Expect Qty
    [Arguments]    ${table_value_dict}   
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${actual_qty_on_hand}    Evaluate    random.choice([n for n in range(1,10) if n != ${item_dict}[expected_qty]])    random
            Adjust Actual Qty On Hand Item In Table Reconcile With Index    ${item_dict}[index]    ${actual_qty_on_hand}    ${item_dict}[discrepancy]
        END
    END

Add Discrepancy Reason All Item In Table Reconcile
    [Arguments]    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            Add Discrepancy Reason Item With Index   ${item_dict}[index]
        END
    END

Add Discrepancy Reason Item With Index
    [Arguments]    ${index}    ${reason}=Test
    Wait Until Element Is Visible    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]
    ${list_item}    Get List Items    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]
    ${last_item_index}    Evaluate    len(${list_item}) - 1
    Select From List By Index    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]    ${last_item_index}
    Input Text    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//input[@class="form-control reconcileItemNote"]    ${reason}

Add All Price Item In View All Items With Index To Value Dict
    [Arguments]    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${price}    Get Price Item In View All Items With Index    ${item_dict}[index]
            ${coverted_price}    Evaluate    round(float(${price}), 2)
            Set To Dictionary    ${item_dict}    price=${coverted_price}
        END
    END

View All Item With Index
    [Arguments]    ${index}
    Wait Until Element Is Enabled    //tr[.//a[text()="View All Items"]][${index}]//a[text()="View All Items"]
    CLick Element    //tr[.//a[text()="View All Items"]][${index}]//a[text()="View All Items"]
    Wait Until Element Is Visible    ${view_all_item_table_xpath}    30s

Close View All Items
    Wait Until Element Is Enabled    //div[@id="SubModalPopup"]//button[@id="CloseBtn"]    30s
    Click Element    //div[@id="SubModalPopup"]//button[@id="CloseBtn"]
    Wait Until Element Is Not Visible    ${view_all_item_table_xpath}    30s

Get Price In View All Items
    ${price}    Get Value    //input[contains(@class,"ReconcileItemPriceTextBox")]
    RETURN    ${price}

Get Price Item In View All Items With Index 
    [Arguments]    ${index}
    View All Item With Index    ${index}
    ${price}    Get Price In View All Items
    Close View All Items
    RETURN    ${price}  

# work flow
Reconcile Item ${type} And Scan ${barcode} Then Complete
    Select Type Reconcile    ${type}
    Get Reconcile History id
    Scan Barcode Reconcile    ${barcode}
    Complete Reconcile

Reconcile Item ${type} And Scan ${barcode} Then Cancel
    Select Type Reconcile    ${type}
    Get Reconcile History id
    Scan Barcode Reconcile    ${barcode}
    Cancel Reconcile

Reset And Fill Empty
    Wait Until Keyword Succeeds    3times    1    Reset Assigned Products
    Wait Until Keyword Succeeds    3times    1    Fill Empty Reconcile
    Get Reconcile History id
    Wait Until Page Does Not Contain    Reconcile item updated!    timeout=10s
    Complete Reconcile

Reset And Fill Empty But Not Complete
    Wait Until Keyword Succeeds    3times    1    Reset Assigned Products
    Wait Until Keyword Succeeds    3times    1    Fill Empty Reconcile
    Get Reconcile History id
    Wait Until Page Does Not Contain    Reconcile item updated!    timeout=10s

Complete Reconcile
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Wait Until Keyword Succeeds    5 times    1 second    Click Complete Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    ${explain_modal}    Run Keyword And Return Status     Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s
    Run Keyword If    '${explain_modal}' == 'True'    Save Complete Reconcile
    ...    ELSE IF    '${explain_modal}' == 'False'
    ...    Log    Modal did not appear. Continuing without saving.
    ...    ELSE
    ...    Fail    Unexpected value '${explain_modal}' returned.
    Wait Until Page Contains Element     ${open_active_reconcile}    timeout=60s    error=Loading Available Reconciles Failed

Open List of Reconcile Location Appointments & Statuses
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Wait Until Keyword Succeeds    5 times    1 second    Click Complete Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    ${explain_modal}    Run Keyword And Return Status     Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s

Close List of Reconcile Location Appointments & Statuses
    Wait Until Element Is Visible    //*[@id="SubModalPopup"]//*[@id="CloseBtn"]    30s
    Click Element    //*[@id="SubModalPopup"]//*[@id="CloseBtn"]
    Wait Until Element Is Not Visible     //span[text()="(Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)"]    timeout=30s

Incomplete Reconcile
    Open List of Reconcile Location Appointments & Statuses
    Save Incompleted Reconcile

Request Approval Reconcile
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Click Request Approval Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    ${explain_modal}    Run Keyword And Return Status     Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s
    Run Keyword If    '${explain_modal}' == 'True'    Save Complete Reconcile
    ...    ELSE IF    '${explain_modal}' == 'False'
    ...    Log    Modal did not appear. Continuing without saving.
    ...    ELSE
    ...    Fail    Unexpected value '${explain_modal}' returned.
    Wait Until Page Contains Element     ${open_active_reconcile}    timeout=60s    error=Loading Available Reconciles Failed

Manually Add Products
    [Arguments]    ${ndc}    ${qty}    ${lot}    ${recently_ordered}    ${view_favorites}
    Open Manually Add Products
    Run Keyword If    ${view_favorites} == ${True}    Select Checkbox    viewFavorites
    Run Keyword If    ${recently_ordered} == ${True}    Select Checkbox    viewHistory
    Input Text    ${SearchAssignProductInput}    ${ndc}
    SeleniumLibrary.Click Button    ${SearchAssignProductBtn}
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]
    Select From List By Value    //*[@id="item_LotNumber"]    ${lot}
    Input Text    ${AddingQtyInput}    ${qty}
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}
    Waiting For Loading

Manually Add Products With Random Lot
    [Arguments]    ${ndc}    ${qty}    ${recently_ordered}    ${view_favorites}
    Open Manually Add Products
    Run Keyword If    ${view_favorites} == ${True}    Select Checkbox    viewFavorites
    Run Keyword If    ${recently_ordered} == ${True}    Select Checkbox    viewHistory
    Wait Until Element Is Enabled    ${SearchAssignProductInput}    30s
    Input Text    ${SearchAssignProductInput}    ${ndc}
    SeleniumLibrary.Click Button    ${SearchAssignProductBtn}
    Util.Waiting For Loading
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]    30s
    ${lot_current}    Get WebElements    //*[@id="item_LotNumber"]/option
    ${lot_ammount}    Get Length    ${lot_current}
    ${random_lot_index}    Evaluate    random.randint(1, ${lot_ammount} - 2)
    Select From List By Index    //*[@id="item_LotNumber"]    ${random_lot_index}    
    Input Text    ${AddingQtyInput}    ${qty}
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}
    Wait Until Element Is Not Visible    //*[@id="SubModalPopup"]    30s
    Waiting For Loading

Complete Reconcile With Strict Note Turn On
    ${table_value_dict}    Get Value Item In Table Reconcile
    Adjust Actual Qty On Hand All Items In Table Reconcile Not Equal Expect Qty    ${table_value_dict}
    Incomplete Reconcile
    Util.Wait Alert Message Show And Disappear    All items with discrepancies must have a reason assigned.
    ${table_value_dict}    Get Value Item In Table Reconcile
    Add Discrepancy Reason All Item In Table Reconcile    ${table_value_dict}
    Complete Reconcile