*** Settings ***
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${create_new_category_button_xpath}    //a[@onclick="newCategory()"]
${new_category_input_xpath}    //input[contains(@class,"newCategory")]
${search_category_input_xpath}    //input[@id="CategorySearchValues"]
${search_category_button_xpath}    //button[@id="CategoryFindButton"]
${search_item_input_xpath}    //input[@id="SearchValues"]
${search_item_button_xpath}    //button[@id="FindButton"]
${clear_category_button_xpath}    //a[@onclick="clearCategory('')"]
${clear_search_item_button_xpath}    //button[@id="ClearButton"]
${clear_search_category_button_xpath}    //button[@id="CategoryClearButton"]
${clear_category_element_xpath}    //a[@onclick="clearCategory('')"]

*** Keywords ***
Go To Categorize Items
    Click Element    link:Administration
    Click Element    link:Categorize Items
    Title Should Be    Inventory Items
    Util.Waiting For Loading

Click Create New Category Button
    Wait Until Element Is Enabled    ${create_new_category_button_xpath}    30s
    Click Element    ${create_new_category_button_xpath}

Fill New Category Input
    [Arguments]    ${new_category}
    Wait Until Element Is Enabled    ${new_category_input_xpath}    30s
    Input Text    ${new_category_input_xpath}    ${new_category} 

Click Save On Popup Modal
    Wait Until Element Is Enabled    id=SaveBtn    30s
    Click Element    //div[@id="ModalPopup"]//button[@id="SaveBtn"]

Fill Search Category Input
    [Arguments]    ${category}
    Wait Until Element Is Enabled    ${search_category_input_xpath}    30s
    Input Text    ${search_category_input_xpath}    ${category}

Click Search Category Button
    Wait Until Element Is Enabled    ${search_category_button_xpath}    30s
    Click Button    ${search_category_button_xpath}

Click Add Category To Session
    [Arguments]    ${category}
    ${add_category_to_session_button_xpath}    Set Variable    //a[@data-category="${category}"]
    Wait Until Element Is Enabled    ${add_category_to_session_button_xpath}    30s
    Click Element    ${add_category_to_session_button_xpath}

Fill Search Item Input
    [Arguments]    ${item}
    Wait Until Element Is Enabled    ${search_item_input_xpath}    30s
    Input Text    ${search_item_input_xpath}    ${item}

Click Search Item Button
    Wait Until Element Is Enabled    ${search_item_button_xpath}    30s
    Click Button    ${search_item_button_xpath}

Get Inventory Item Id
    [Arguments]    ${inventory_item}
    ${inventory_item_id_element}    Set Variable    //tr[@class="Categories"]//a[text()="${inventory_item}"]
    Wait Until Element Is Enabled    ${inventory_item_id_element}    30s
    ${inventory_item_id}    Get Element Attribute    ${inventory_item_id_element}    data-itemid
    RETURN    ${inventory_item_id}

Click Add Inventory To Category Button
    [Arguments]    ${inventory_item_id}
    ${add_inventory_item_id_button_xpath}    Set Variable    //a[@onclick="AddItemToCategory('${inventory_item_id}')"]
    Wait Until Element Is Enabled    ${add_inventory_item_id_button_xpath}    30s
    Click Element    ${add_inventory_item_id_button_xpath}

Click Remove Inventory To Category Button
    [Arguments]    ${inventory_item_id}
    ${add_inventory_item_id_button_xpath}    Set Variable    //a[@onclick="RemoveItemFromCategory('${inventory_item_id}')"]
    Wait Until Element Is Enabled    ${add_inventory_item_id_button_xpath}    30s
    Click Element    ${add_inventory_item_id_button_xpath}

Click Clear Category Session Button
    Wait Until Element Is Enabled    ${clear_category_button_xpath}    30s
    Click Element    ${clear_category_button_xpath}

Click Clear Search Item Button
    Wait Until Element Is Enabled    ${clear_search_item_button_xpath}    30s
    Click Button    ${clear_search_item_button_xpath}

Click Clear Search Category Button
    Wait Until Element Is Enabled    ${clear_search_category_button_xpath}    30s
    Click Button    ${clear_search_category_button_xpath}

Click Clear Category
    Wait Until Element Is Enabled    ${clear_category_element_xpath}    30s
    Click Element    ${clear_category_button_xpath}

Complete Create New Category
    [Arguments]    ${new_category}
    Click Create New Category Button
    Wait Until Element Contains    id=ModalPopup    Enter your new Category.    30s
    Util.Waiting For Loading
    Fill New Category Input    ${new_category}
    Click Save On Popup Modal
    Util.Wait Alert Message Show And Disappear    Category created successfully!
    Util.Waiting For Loading
    Press Keys    None    ESC
    Wait Until Element Is Not Visible    id=ModalPopup    30s

Complete Add Item To Category
    [Arguments]    ${item}    ${category}
    Fill Search Category Input    ${category}
    Click Search Category Button
    Util.Waiting For Loading
    Click Add Category To Session    ${category}
    Util.Waiting For Loading
    Fill Search Item Input    ${item}
    Click Search Item Button
    Util.Waiting For Loading
    ${item_id}    Get Inventory Item Id    ${item}
    Click Add Inventory To Category Button    ${item_id}
    Util.Wait Alert Message Show And Disappear    Category Added To Item
    Util.Waiting For Loading
    Click Clear Category Session Button
    Util.Waiting For Loading
    Click Clear Search Item Button 
    Util.Waiting For Loading
    Click Clear Search Category Button
    Util.Waiting For Loading
    Click Clear Category
    Util.Waiting For Loading

Complete Remove Item From Category
    [Arguments]    ${item}    ${category}
    Fill Search Category Input    ${category}
    Click Search Category Button
    Util.Waiting For Loading
    Click Add Category To Session    ${category}
    Util.Waiting For Loading
    Fill Search Item Input    ${item}
    Click Search Item Button
    Util.Waiting For Loading
    ${item_id}    Get Inventory Item Id    ${item}
    Click Remove Inventory To Category Button    ${item_id}
    Util.Wait Alert Message Show And Disappear    Category Removed From Item
    Util.Waiting For Loading
    Click Clear Category Session Button
    Util.Waiting For Loading
    Click Clear Search Item Button 
    Util.Waiting For Loading
    Click Clear Search Category Button
    Util.Waiting For Loading
    Click Clear Category
    Util.Waiting For Loading















    