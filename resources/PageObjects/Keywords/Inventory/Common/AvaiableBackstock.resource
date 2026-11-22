*** Settings ***
Resource    InventoryUtils.resource

*** Variables ***
${view_backstock_xpath}    //*[@id="viewInventoryBackstock"]
${create_new_backstock_element_xpath}    //*[@id="CreateBackstockButton"]
${backstock_modal_xpath}    //div[@id="ModalPopup"]
${description_input_xpath}    //*[@id="Description"]
${location_input_xpath}    //*[@id="Location"]
${item_backstock_table_xpath}    //*[@id="InventoryBackstockList"]//table
${back_to_inventory_backstock}    //a[@onclick="LoadInventoryBackstockList(undefined, 1);"]
${create_button_xpath}    //*[@id="ModalPopup"]//*[@id="AcceptBtn"]
${delete_button_xpath}    //*[@id="ModalPopup"]//*[@id="DeleteBtn"]
${close_button_xpath}    //*[@id="ModalPopup"]//*[@id="CloseBtn"]

*** Keywords ***
Open Available Backstock
    Wait Until Page Contains Element    ${view_backstock_xpath}    timeout=20s
    ${available_backstock_inventory_onclick}    SeleniumLibrary.Get Element Attribute    ${view_backstock_xpath}    onclick
    Execute JavaScript    ${available_backstock_inventory_onclick}
    Util.Waiting For Loading

Click Create Backstock Button
    Wait Until Element Is Enabled    ${create_new_backstock_element_xpath}    30s    
    Click Element    ${create_new_backstock_element_xpath}
    Wait Until Element Contains   ${backstock_modal_xpath}    Create a new Inventory Backstock        30s
    Util.Waiting For Loading

Input Description
    [Arguments]    ${description}
    Wait Until Element Is Enabled    ${description_input_xpath}    30s
    Input Text    ${description_input_xpath}    ${description}

Input Location
    [Arguments]    ${location}
    Wait Until Element Is Enabled    ${location_input_xpath}    30s
    Input Text    ${location_input_xpath}    ${location}

Click Save Inventory Backstock
    Wait Until Element Is Enabled    ${create_button_xpath}    30s
    Click Button    ${create_button_xpath}
    Util.Wait Alert Message Show And Disappear   Backstock Successfully Inserted!
    Util.Waiting For Loading

Click Delete Inventory Backstock
    Wait Until Element Is Enabled    ${delete_button_xpath}    30s
    Click Button    ${delete_button_xpath}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    Util.Wait Alert Message Show And Disappear   Backstock Successfully Deleted!
    Util.Waiting For Loading

Click Close Inventory Backstock
    Wait Until Element Is Enabled    ${close_button_xpath}    30s
    Click Button    ${close_button_xpath}
    Wait Until Element Is Not Visible    ${backstock_modal_xpath}

Get Value Item In View Table Backstock
    ${table_html}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${item_backstock_table_xpath}    outerHTML
    ${table_value_dict}    Utils.Get Data In Html Table In View Backstock   ${table_html}
    RETURN    ${table_value_dict}

Get Id Inventory Backstock
    [Arguments]    ${backstock_name}    ${location}
    ${row_inventory_backstock_xpath}    Set Variable   //div[contains(@class,"active")]//*[@id="InventoryBackstockList"]//tr[./td[1][ contains(.,"${backstock_name}")] and ./td [2][contains(.,"${location}")]]//td[4]
    Wait Until Element Is Visible    ${row_inventory_backstock_xpath}    30s    
    ${iventory_backstock_id}    SeleniumLibrary.Get Element Attribute    ${row_inventory_backstock_xpath}    data-backstock
    RETURN    ${iventory_backstock_id}
Get List Id Inventory Backstock
    ${row_inventory_backstock_xpath}    Set Variable   //div[contains(@class,"active")]//*[@id="InventoryBackstockList"]//tr//td[4]
    Wait Until Element Is Visible    //table[@class="table table-bordered"]    30s    
    ${row_inventory_backstock_list}    Get WebElements    ${row_inventory_backstock_xpath}
    ${inventory_backstock_id_list}    Create List
    FOR    ${row_inventory_backstock}    IN    @{row_inventory_backstock_list}
        ${iventory_backstock_id}    SeleniumLibrary.Get Element Attribute    ${row_inventory_backstock}    data-backstock
        Append To List    ${inventory_backstock_id_list}    ${iventory_backstock_id}
    END
    RETURN    ${inventory_backstock_id_list}

Open Edit Inventory Backstock
    [Arguments]    ${id_backstock}
    ${row_backstock_edit_xpath}    Set Variable    //a[@onclick="BackstockMaitenanceModal('${id_backstock}')"]
    Wait Until Element Is Enabled    ${row_backstock_edit_xpath}    30s
    Click Element    ${row_backstock_edit_xpath}
    Wait Until Element Contains   ${backstock_modal_xpath}    Update an Inventory Backstock        30s
    Util.Waiting For Loading

Open View Item In Inventory Backstock
    [Arguments]    ${id_backstock}
    ${row_backstock_view_xpath}    Set Variable    //a[@onclick="LoadInventoryBackstockTable('${id_backstock}', 1)"]
    Wait Until Element Is Enabled    ${row_backstock_view_xpath}    30s
    Click Element    ${row_backstock_view_xpath}
    Wait Until Element Is Visible   ${item_backstock_table_xpath}        30s
    Util.Waiting For Loading

Click Back to Inventory Backstock
    Wait Until Element Is Visible    ${back_to_inventory_backstock}    30s
    Click Element    ${back_to_inventory_backstock}
    Util.Waiting For Loading

Open Transfer Inventory Backstock
    [Arguments]    ${id_backstock}
    ${row_backstock_transfer_xpath}    Set Variable    //tr[./td[@data-backstock="${id_backstock}"]]/td[5]/a[1]
    Wait Until Element Is Enabled    ${row_backstock_transfer_xpath}    30s
    Click Element    ${row_backstock_transfer_xpath}
    Wait Until Element Is Visible    ${item_backstock_table_xpath}    30s
    Util.Waiting For Loading
    
Create New Available Backstock
    [Arguments]    ${backstock_name}    ${location}
    Open Available Backstock
    Click Create Backstock Button
    Input Description    ${backstock_name}
    Input Location    ${location}
    Click Save Inventory Backstock
    Click Close Inventory Backstock
    ${inventory_backstock_id}    Get Id Inventory Backstock    ${backstock_name}    ${location}
    RETURN    ${inventory_backstock_id}        

Delete Inventory Backstock
    [Arguments]    ${id_backstock}
    Open Edit Inventory Backstock    ${id_backstock}
    Click Delete Inventory Backstock
    Click Close Inventory Backstock
    






    


