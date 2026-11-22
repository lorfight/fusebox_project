*** Settings ***
Resource    ./InventoryUtils.resource
*** Variables ***
${CreateInventoryXpath}    //*[@id='newInventory']
${SaveBtn}    //*[@id='SaveBtn']
${CloseModalBtn}    //div[@class='modal-footer']//button[@id='CloseBtn']
${DescriptionInventoryInput}    //input[@id='FacilityDescription']
${TrackInventoryValue}    //input[@id='TrackInventoryValue']
${DefaultFacilityType}    //input[@id='DefaultFacilityType']
${IsPatientBasedInventory}    //input[@id='IsPatientBasedInventory']
${RemoveInventoryBtn}    //a[contains(text(),'Remove Inventory Department ')]
${EditInventoryBtn}    //*[@id='editInventoryButton']

*** Keywords ***
Click Create Inventory
    Scroll Element Into View    ${CreateInventoryXpath}
    Wait Until Element Is Visible    ${CreateInventoryXpath}
    ${create_new_inventory}    SeleniumLibrary.Get Element Attribute    ${CreateInventoryXpath}    onclick
    Execute JavaScript    ${create_new_inventory}

Input Description Inventory Name
    [Arguments]    ${inventory_name}
    Wait Until Element Is Visible    ${DescriptionInventoryInput}
    Input Text    ${DescriptionInventoryInput}    ${inventory_name}

Select Group Inventory
    [Arguments]    ${GroupInventory}
    Wait Until Element Is Enabled    id=FacilityGroupNumber    30s
    Wait Until Element Contains    id=FacilityGroupNumber    ${GroupInventory}    30s
    Select From List By Label    id=FacilityGroupNumber    ${GroupInventory}

Close Modal Create Inventory 
    Wait Until Element Is Visible    ${CloseModalBtn}
    Click Element    ${CloseModalBtn}

Save Inventory
    Wait Until Element Is Enabled    ${SaveBtn}
    SeleniumLibrary.Click Button    ${SaveBtn}

Click Edit Inventory
    Wait Until Element Is Visible    //*[@id="editInventoryButton"]
    Click Element    //*[@id="editInventoryButton"]
    Util.Waiting For Loading

Click Remove Inventory
    Wait Until Element Is Visible    ${RemoveInventoryBtn}    timeout=10s
    Click Element    ${RemoveInventoryBtn}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text

Get All Inventory Facility Name
    ${list_inventory_name}    Create List
    ${elements}    Get WebElements    //*[contains(@class,'InventoryFacilitySelect')]
    FOR    ${element}    IN    @{elements}
        ${target}    SeleniumLibrary.Get Element Attribute    ${element}    text
        Append To List    ${list_inventory_name}    ${target}
    END
    RETURN    ${list_inventory_name}