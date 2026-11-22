*** Settings ***
Resource    ./InventoryUtils.resource

*** Variables ***
${find_inventory}    id=SearchValues
${select_location}    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]
${find_button}    //*[@id="FindButton" or @id="reconcielFindItemBtn"]
${clear_inventory}    //*[@id="reconcielClearItemBtn" and not(contains(@class,"hidden"))]
${CreateInventoryXpath}    //*[@id='newInventory']

*** Keywords ***
Select Location
    [Arguments]    ${location}
    Wait Until Element Is Enabled    ${select_location}    timeout=10s
    Select From List By Label    ${select_location}    ${location}
    Waiting For Loading

Search For Item #,NDC
    [Arguments]    ${item_number}
    Wait Until Element Is Enabled    ${find_inventory}    timeout=10s
    Input Text    ${find_inventory}    ${item_number}
    Click Button    ${find_button}
    Waiting For Loading
    
Clear Search
    Click Element    ${clear_inventory}
    Execute JavaScript    document.activeElement.blur()
    Waiting For Loading
    


Click Create Inventory
    Scroll Element Into View    ${CreateInventoryXpath}
    Wait Until Element Is Visible    ${CreateInventoryXpath}
    ${create_new_inventory}    SeleniumLibrary.Get Element Attribute    ${CreateInventoryXpath}    onclick
    Execute JavaScript    ${create_new_inventory}

Select Facility In Inventory
    [Arguments]    ${inventory_name}
    ${SelectInventory}    Set Variable    xpath=//a[text()='${inventory_name}' and @data-toggle='tab']
    ${loading_facility_tab}    Set Variable    //*[contains(@class,"active")]//*[@id="LevelList" and not(contains(@class,"hidden"))]/div[1]/i
    ${loading_inventory_value}    Set Variable    //div[@class="tab-pane active"]//span[@id="total-inventory-value"]/i[@class="valueLoader fa fa-spinner fa-spin"]
    ${loading_overal_inventory_value}    Set Variable    //span[@id="overall-inventory-value"]/i[@class="valueLoader fa fa-spinner fa-spin"]
    Waiting For Loading
    Wait Until Page Contains Element    ${SelectInventory}    5s
    Wait Until Page Does Not Contain Element    ${loading_inventory_value}    15s    
    Wait Until Page Does Not Contain Element    ${loading_overal_inventory_value}    15s 
    Wait Until Page Does Not Contain Element       ${loading_facility_tab}    15s
    Scroll Element Into View    ${SelectInventory}
    Click Element    ${SelectInventory}
    Waiting For Loading
    Wait Until Page Does Not Contain Element    ${loading_inventory_value}    15s
    Wait Until Page Does Not Contain Element    ${loading_overal_inventory_value}    15s    
    Wait Until Page Does Not Contain Element       ${loading_facility_tab}    15s
