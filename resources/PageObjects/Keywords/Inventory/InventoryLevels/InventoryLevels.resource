*** Settings ***
Resource    ../Common/InventoryFilter.resource
Resource    ../Common/InventoryFacility.resource

*** Variables ***
${inventory_adjustment_close_btn}    (//*[@id="CloseBtn"])[2]
${inventory_level_search_input_xpath}    //input[@id="SearchValues"]
${inventory_level_find_button_xpath}    //button[@id="FindButton"]
${inventory_adjustment_title_xpath}     //*[@class="modal-content"]//*[contains(text(),"Inventory Adjustment")]
${inventory_adjustment_price_select_xpath}    //select[@id="Price"]
${inventory_level_clear_search}    //button[@id="ClearButton"]
${input_new_lot_xpath}    //input[@id="newLotNumber"]
${input_new_expired_date_xpath}    //input[@id="newExpirationDate"]
${add_lot_button_xpath}    //a[@id="addLot"]
${close_modal}    //*[@id="ModalPopup"]//*[@id="CloseBtn"]

*** Keywords ***
Go To Inventory Levels
    Click Element    link:Inventory
    Click Element    link:Inventory Levels
    Title Should Be    Inventory Levels & Transactions

Select Show Empty Inventory
    Util.Scroll Into View    "//*[contains(@class,'tab-pane') and contains(@class,'active')]//text()[contains(.,'Show Empty Inventory') and not(contains(.,'Buckets'))]/preceding-sibling::input[contains(@class,'showEmpty')]"    block=start
    Wait Until Keyword Succeeds    10s    1s    Select Checkbox    //*[contains(@class,"tab-pane") and contains(@class,"active")]//text()[contains(.,"Show Empty Inventory") and not(contains(.,"Buckets"))]/preceding-sibling::input[contains(@class,"showEmpty")]
    Wait Until Element Is Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//tr[@class="BlackBorder success" or @class= "BlackBorder default" or @class="BlackBorder danger"][1]    30s
    Util.Waiting For Loading

Show Transaction UoM "${uom_type}"
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom_type}')]]//*[contains(@class,'TransactionsLink')]
    Click Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom_type}')]]//*[contains(@class,'TransactionsLink')]
    Wait Until Page Contains    Transaction History     timeout=20s

Show Adjustment Inventory On Hand "${uom_type}"
    Wait Until Element Is Enabled    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom_type}")]//following-sibling::div/a[@class="QtyOnHandLink"]
    Click Element    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom_type}")]//following-sibling::div/a[@class="QtyOnHandLink"]
    Wait Until Page Contains    Inventory Adjustment    timeout=20s

Get Best Price Contract
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Show Adjustment Inventory On Hand "${uom}"
    ${best_price}    Find Lowest Price
    Click Button    ${inventory_adjustment_close_btn}
    Click Clear Search
    RETURN    ${best_price}

Click Clear Search
    Wait Until Element Is Enabled    ${inventory_level_clear_search}    30s
    Click Button    ${inventory_level_clear_search}
    Util.Waiting For Loading

Find Inventory With NDC Item
    [Arguments]    ${ndc}
    Wait Until Element Is Enabled    ${inventory_level_search_input_xpath}    30s
    Input Text    ${inventory_level_search_input_xpath}    ${ndc}
    Wait Until Element Is Enabled    ${inventory_level_find_button_xpath}    30s
    Click Button    ${inventory_level_find_button_xpath}
    Util.Waiting For Loading

Find Lowest Price
    Wait Until Element Is Visible    ${inventory_adjustment_title_xpath}    30s
    Wait Until Element Is Enabled    ${inventory_adjustment_price_select_xpath}    30s
    ${selected_price_list}    Get List Items    ${inventory_adjustment_price_select_xpath}
    ${filtered_price_list}    Evaluate    [item for item in ${selected_price_list} if item != '-- Select Contract Price --']
    @{prices}    Create List
    FOR    ${item}    IN    @{filtered_price_list}
        ${price}    Evaluate    float(${item.split(' ')}[0])
        Append To List    ${prices}    ${price}
    END
    ${lowest_price}    Evaluate    min(${prices})
    RETURN    ${lowest_price}

Try Click Active Lots To Open Lot Breakouts
    [Arguments]    ${uom}    ${ndc}
    Wait Until Element Is Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom}")]/following-sibling::div/a[@href="#" and contains(text(),"Active Lots")]
    Wait Until Keyword Succeeds    3 times    strict: 10s    Click Active Lots To Open Lot Breakouts    ${uom}    ${ndc}
    Wait Until Page Contains    Lot Breakouts    timeout=5s

Click Active Lots To Open Lot Breakouts
    [Arguments]    ${uom}    ${ndc}
    Sleep    1s
    Click Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom}')]]//*[contains(@class,'LotsLink')]
    Wait Until Page Contains    Lot Breakouts - ${ndc} (${uom})    timeout=5s

Get Item List In Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Try Click Active Lots To Open Lot Breakouts    ${uom}    ${ndc}
    ${inventory_item_cols}    Create List
    ${rows}    Get WebElements    //div[@class="panel-body"]/div[not(contains(.,"Total"))]
    FOR    ${item}    IN    @{rows}[1:]
        ${inventory_item_html}    SeleniumLibrary.Get Element Attribute    ${item}    outerHTML
        ${inventory_item_col}    Utils.Get Data Lot Breakout Inventory Level    ${inventory_item_html}    ${{["lot","expired_date","price","qty_on_hand","cost"]}}
        Append To List    ${inventory_item_cols}    ${inventory_item_col}
    END
    Click Clear Search
    RETURN   ${inventory_item_cols}

Get Transaction List In Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    Click Transaction To Open Transaction List    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    ${inventory_transaction_cols}    Create List
    ${rows}    Get WebElements    //*[contains(@class,'active') and contains(@class,'tab-pane')]//*[(@id='LevelList')]//*[contains(@class,'active') and contains(@class,'tab-pane') and contains(@id,'InventoryTransactionTab')]//*[contains(@class,'row')]
    FOR    ${item}    IN    @{rows}[1:]
        ${inventory_transaction_html}    SeleniumLibrary.Get Element Attribute    ${item}    outerHTML
        ${inventory_transaction_col}    Utils.Get Transaction Inventory Level    ${inventory_transaction_html}    ${{["type","created_by","adjustment","price","lot_no","expiration"]}}
        Append To List    ${inventory_transaction_cols}    ${inventory_transaction_col}
    END
    Click Clear Search
    RETURN   ${inventory_transaction_cols}

Click Inventory Adjustment
    [Arguments]    ${ndc}    ${uom}
    ${button_adjust_inventory_on_hand}    Set Variable    //*[contains(@class,"active")]//*[@id="LevelList"]//*[text()="${ndc}"]//ancestor::tbody//td[contains(.,"${uom}")]//*[@class="QtyOnHandLink"]
    Wait Until Element Is Enabled    ${button_adjust_inventory_on_hand}        30s
    Click Element    ${button_adjust_inventory_on_hand}
    Wait Until Element Contains    //div[@id="ModalPopup"]    Inventory Adjustment    30s

Open Manage Lot Adjustment
    [Arguments]    ${ndc}
    ${button_open_manage_lot_xpath}    Set Variable    //*[contains(@class,"active")]//*[@id="LevelList"]//*[text()="${ndc}"]//ancestor::tbody//a[text()="Manage Lots"]
    Wait Until Element Is Enabled    ${button_open_manage_lot_xpath}        30s
    Click Element    ${button_open_manage_lot_xpath}
    Wait Until Element Contains    //div[@id="ModalPopup"]    Lot Management    30s

Close Manage Lot Adjustment
    Click Element    ${close_modal}
    Wait Until Element Is Not Visible    //*[@id="ModalPopup"]    30s

Input New Lot
    [Arguments]    ${lot}
    Wait Until Element Is Enabled   ${input_new_lot_xpath}    30s
    Input Text    ${input_new_lot_xpath}    ${lot}
    Util.Waiting For Loading

Input Expired Date New Lot
    [Arguments]    ${expired_date}
    Wait Until Element Is Enabled    ${input_new_expired_date_xpath}    30s
    Input Text    ${input_new_expired_date_xpath}    ${expired_date}
    Util.Waiting For Loading

Click Add New Lot
    Wait Until Element Is Enabled    ${add_lot_button_xpath}    30s
    Click Element    ${add_lot_button_xpath}
    Util.Waiting For Loading

Verify Lot Already Exist
    [Arguments]    ${lot}    ${expired_date}
    ${new_lot_row}    Set Variable    //tr[.//input[@value="${lot}"] and .//input[@value="${expired_date}"]]
    Wait Until Element Is Visible    ${new_lot_row}        30s

Edit Lot And Expired Date
    [Arguments]    ${old_lot}    ${old_expired_date}    ${new_lot}    ${new_expired_date}
    ${old_lot_input_xpath}    Set Variable    //tr[.//input[@value="${old_lot}"] and .//input[@value="${old_expired_date}"]]//input[contains(@class, "LotNumber")]
    ${old_expired_date_input_xpath}   Set Variable    //tr[.//input[@value="${old_lot}"] and .//input[@value="${old_expired_date}"]]//input[contains(@class, "ExpirationDate")]
    Input Text    ${old_lot_input_xpath}    ${new_lot}
    Util.Waiting For Loading
    Input Text    ${old_expired_date_input_xpath}    ${new_expired_date}
    Util.Waiting For Loading
    Click Confirm Save Change Lot    ${old_lot}    ${old_expired_date}

Click Confirm Save Change Lot
    [Arguments]    ${lot}    ${expired_date}
    ${confirm_edit_new_lot_row_button_xpath}    Set Variable    //tr[.//input[@value="${lot}"] and .//input[@value="${expired_date}"]]//a[contains(@class,"confirmEdit ")]
    Wait Until Element Is Visible    ${confirm_edit_new_lot_row_button_xpath}    30s
    Click Element    ${confirm_edit_new_lot_row_button_xpath}
    Util.Waiting For Loading

Add New Lot To Inventory Level
    [Arguments]    ${ndc}    ${lot}    ${expired_date}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Open Manage Lot Adjustment    ${ndc}
    Input New Lot    ${lot}
    Input Expired Date New Lot    ${expired_date}
    Click Add New Lot
    Verify Lot Already Exist    ${lot}    ${expired_date}
    Close Manage Lot Adjustment
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END

Edit Exist Lot In Inventory Level
    [Arguments]    ${ndc}    ${old_lot}    ${old_expired_date}    ${new_lot}    ${new_expired_date}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Open Manage Lot Adjustment    ${ndc}
    Edit Lot And Expired Date    ${old_lot}    ${old_expired_date}    ${new_lot}    ${new_expired_date}
    Close Manage Lot Adjustment
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END

Verify Exist Lot In Inventory Level
    [Arguments]    ${ndc}    ${lot}    ${expired_date}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Open Manage Lot Adjustment    ${ndc}
    Verify Lot Already Exist    ${lot}    ${expired_date}
    Close Manage Lot Adjustment
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END

Save Inventory Adjustment
    Wait Until Element Is Enabled    //button[text()="Save"]    30s
    Click Button    //button[text()="Save"]
    Wait Until Element Is Not Visible    //*[@id="ModalPopup"]//div[contains(@class,"modal-content")]    timeout=30s
    Util.Waiting For Loading

Select Contract Price By Index
    [Arguments]    ${index}
    Wait Until Element Is Enabled    id=Price    30s
    Select From List By Index    id=Price    ${index}

Select Contract Price By Price
    [Arguments]    ${price}
    ${option_with_price}    Set Variable    //select[@id="Price"]/option[contains(.,"${price}")]
    Wait Until Element Is Enabled    ${option_with_price}    30s
    Click Element    ${option_with_price}

Select Lot Number By Index
    [Arguments]    ${index}
    Wait Until Element Is Enabled    id=LotDetailId    30s
    Select From List By Index    id=LotDetailId    ${index}

Select Lot Number By Label
    [Arguments]    ${lot}    ${expired_date}
    ${label}    Set Variable    ${lot} -- [Expires: ${expired_date} ]
    Wait Until Element Is Enabled    id=LotDetailId    30s
    Select From List By Label    id=LotDetailId    ${label}

Input Add Qty On Hand
    [Arguments]    ${qty}
    Wait Until Element Is Enabled    //*[@id="newQty"]    30s
    Input Text    //*[@id="newQty"]    ${qty}

Input Adjust Qty On Hand
    [Arguments]    ${lot}    ${expired_date}    ${qty}
    ${input_adjust_qty_xpath}    Set Variable    //tbody/tr[contains(.,"${lot}") and contains(.,"${expired_date}")]//input[contains(@class,"Quantity ")]
    Wait Until Element Is Enabled    ${input_adjust_qty_xpath}    30s
    Input Text    ${input_adjust_qty_xpath}    ${qty}

Click Add New Qty On Hand
    Wait Until Element Is Enabled    css:[id="newQtyOnHand"]    30s
    Click Element    css:[id="newQtyOnHand"]
    Wait Until Keyword Succeeds    30s    1s    List Selection Should Be    id=LotDetailId    -- Select Lot --        
    Util.Waiting For Loading

Click Transaction To Open Transaction List
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Wait Until Keyword Succeeds    5times    1    Show Transaction UoM "${uom}"

Go To Inventory Level And Select Location And Facility
    [Arguments]    ${checked_location}    ${checked_facility}
	Go To Inventory Levels
    InventoryFilter.Select Location    ${checked_location}
    InventoryFilter.Select Facility In Inventory    ${checked_facility}
    Waiting For Loading

Add Qty On Hand Inventory
    [Arguments]    ${lot}    ${expired_date}   ${qty}
    Select Lot Number By Label    ${lot}    ${expired_date}
    Select Contract Price By Index    1
    ${price}    Find Lowest Price
    Select Contract Price By Price    ${price}
    Input Add Qty On Hand   ${qty}
    Click Add New Qty On Hand
    Save Inventory Adjustment

Adjust Qty On Hand In Inventory
    [Arguments]    ${lot}    ${expired_date}    ${qty}
    Input Adjust Qty On Hand    ${lot}    ${expired_date}    ${qty}    
    Save Inventory Adjustment

Adjust Inventory On Hand
    Click Element    //*[contains(@class,'tab-pane') and contains(@class,'active')]//*[contains(@class,'QtyOnHandLink')]
    Waiting For Loading
    Wait Until Page Contains    text=Inventory Adjustment

Search NDC To Get Current Qty
    [Arguments]    ${ndc}    ${uom}    ${lot}    ${expired_date}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Click Inventory Adjustment    ${ndc}    ${uom}
    ${qty}    Get Current Qty On Hand    ${lot}    ${expired_date}
    Click Element    ${close_modal}
    Wait Until Element Is Not Visible    //*[@id="ModalPopup"]    30s
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    RETURN    ${qty}

Get Current Qty On Hand
    [Arguments]    ${lot}    ${expired_date}
    ${input_adjust_qty_xpath}    Set Variable    //tbody/tr[contains(.,"${lot}") and contains(.,"${expired_date}")]//input[contains(@class,"Quantity ")]
    Wait Until Element Is Visible    ${input_adjust_qty_xpath}    30s
    ${qty}    Get Value    ${input_adjust_qty_xpath}     
    RETURN    ${qty}

Search NDC To Open Inventory Adjustment Then Adjust Qty
    [Arguments]    ${ndc}    ${uom}    ${lot}    ${expired_date}   ${qty}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Click Inventory Adjustment    ${ndc}    ${uom}
    Adjust Qty On Hand In Inventory    ${lot}    ${expired_date}   ${qty}   
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END

Search NDC To Open Inventory Adjustment Then Add Qty
    [Arguments]    ${ndc}    ${uom}    ${lot}    ${expired_date}   ${qty}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Click Inventory Adjustment    ${ndc}    ${uom}
    Add Qty On Hand Inventory    ${lot}    ${expired_date}    ${qty}
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END

Search NDC To Open Inventory Adjustment Then Reset Qty
    [Arguments]    ${ndc}    ${uom}
    Find Inventory With NDC Item    ${ndc}
    Select Show Empty Inventory
    Click Inventory Adjustment    ${ndc}    ${uom}
    ${list_qty_input}    Get WebElements    //input[contains(@class,"Quantity ")]
    FOR    ${qty_input}    IN    @{list_qty_input}
        Wait Until Element Is Enabled    ${qty_input}    30s
        Input Text    ${qty_input}    0
    END
    Save Inventory Adjustment
    
Get Last Action Inventory Level Before Reconcile
    ${inventory_transaction_cols}    Create List
    ${rows}    Get WebElements    locator=//*[contains(@class,'active') and contains(@class,'tab-pane')]//*[(@id='LevelList')]//*[contains(@class,'active') and contains(@class,'tab-pane') and contains(@id,'InventoryTransactionTab')]//*[contains(@class,'row')]
    FOR    ${var}    IN    @{rows}[1:]
        ${inventory_transaction_html}=    SeleniumLibrary.Get Element Attribute    ${var}    outerHTML
        ${list_properties}    Create List    Type    Adjustment
        ${inventory_transaction_col}=    Utils.Get Transaction Inventory Level    ${inventory_transaction_html}    ${{["Type","Adjustment"]}}
        Append To List    ${inventory_transaction_cols}    ${inventory_transaction_col}
    END
    ${inventory_transaction_cols}    Get Last Reconcile Inventory    ${inventory_transaction_cols}
    Should Be Equal     ${inventory_transaction_cols}    ${log_action_before_reconcile}

Go To Inventory Level To Change Group Inventory
    [Arguments]    ${checked_location}    ${checked_facility}    ${group}    
    Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}
    InventoryFacility.Click Edit Inventory
    InventoryFacility.Select Group Inventory    ${group}
    InventoryFacility.Save Inventory  

Save Inventory Adjustment Modal
    Waiting For Loading
    Wait Until Page Contains Element    //button[text()="Save"]
    Click Button    //button[text()="Save"]
    Waiting For Loading
    Wait Until Element Is Not Visible    //*[@id="ModalPopup"]//div[contains(@class,"modal-content")]    timeout=30s