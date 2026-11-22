*** Settings ***
Resource    InventoryUtils.resource

*** Variables ***
${show_item_tracker_xpath}    //*[@id='ShowSerializedItemTrackerButton']
${lost_item_tab_xpath}    //a[@id="LostItem"]
${last_activity_tab_xpath}    //a[@id="LastActivity"]
${table_item_tracker_xpath}    //div[@class="tab-content"]//div[@class="tab-pane active"]//table
${title_item_tracker_xpath}    //*[contains(text(),"Serialized Item Tracker") and not(contains(@class,"hidden"))]
${close_item_tracker_xpath}    //button[@id='TopCloseBtn']
${search_barcode_input_xpath}    //input[@id="barcodeSearch"]
${search_barcode_button_xpath}    //span[following-sibling::input[@id="barcodeSearch"]]/button
${clear_barcode_button_xpath}    //button[@id="ClearBarcodeSearchButton"]
${loader_lost_item_tab_xpath}    //div[@id="LostItemTab"]//i[@class="fa fa-spinner fa-4x fa-spin"]
${loader_last_activity_tab_xpath}    //div[@id="LastActivityTab"]//i[@class="fa fa-spinner fa-4x fa-spin"]

*** Keywords ***
Open Serialized Item Tracker
    Wait Until Element Is Enabled    ${show_item_tracker_xpath}    30s
    Click Element    ${show_item_tracker_xpath}
    Wait Until Element Is Visible    ${title_item_tracker_xpath}    timeout=30s

Open Tab Lost Item
    Wait Until Element Is Enabled    ${lost_item_tab_xpath}    30s
    Click Element    ${lost_item_tab_xpath}
    Wait Until Element Is Not Visible    ${loader_lost_item_tab_xpath}    30s
    Util.Waiting For Loading

Open Tab Last Activity Item
    Wait Until Element Is Enabled    ${last_activity_tab_xpath}    30s
    Click Element    ${last_activity_tab_xpath}
    Wait Until Element Is Not Visible    ${loader_last_activity_tab_xpath}    30s
    Util.Waiting For Loading

Input Search Barcode
    [Arguments]    ${barcode}
    Wait Until Element Is Enabled    ${search_barcode_input_xpath}    30s
    Input Text    ${search_barcode_input_xpath}    ${barcode}

Click Search Barcode Button
    Wait Until Element Is Enabled    ${search_barcode_button_xpath}    30s
    Click Button    ${search_barcode_button_xpath}
    Util.Waiting For Loading

Click Clear Barcode Button
    Wait Until Element Is Enabled    ${clear_barcode_button_xpath}    30s
    Click Button    ${clear_barcode_button_xpath}
    Util.Waiting For Loading

Close Serialize Item Tracker
    Wait Until Element Is Enabled    ${close_item_tracker_xpath}    30s
    Click Button    ${close_item_tracker_xpath}
    Wait Until Element Is Not Visible    ${title_item_tracker_xpath}    30s

Get Item Barcode Value By Table Tab Tracker
    ${table_html}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${table_item_tracker_xpath}    outerHTML
    ${value_item_barcode_table_dict}    Utils.Get Item Barcode Data From Html Table In Serialized Item Tracker   ${table_html}
    RETURN    ${value_item_barcode_table_dict}

Search Barcode Item
    [Arguments]    ${barcode}
    Input Search Barcode    ${barcode}
    Click Search Barcode Button
    ${table_item_value_dict}    Get Item Barcode Value By Table Tab Tracker
    Click Clear Barcode Button
    RETURN    ${table_item_value_dict}

Search Barcode Item In Tab Last Activity
    [Arguments]    ${barcode}
    Open Tab Last Activity Item
    ${table_item_value_dict}    Search Barcode Item    ${barcode}
    RETURN    ${table_item_value_dict}

Search Barcode Item In Tab Losted Item
    [Arguments]    ${barcode}
    Open Tab Lost Item
    ${table_item_value_dict}    Search Barcode Item    ${barcode}
    RETURN    ${table_item_value_dict}

    