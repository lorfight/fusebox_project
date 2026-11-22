*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Variables    ../Locators/InventoryLocator.py
Variables    ../Locators/CommonLocator.py
Variables    ../TestData/Testdata.py
Resource    ../../../libraries/Util.resource

*** Keywords ***
# Behaviour
    ## Inventory Reconcile
Go Inventory Reconcile And Open Reconcile
    [Arguments]    ${location}
    Go Inventory Reconcile
    Util.Verify Loading And Select By Label    AccountId    ${location}
    Open Active Reconcile

Go Inventory Reconcile
    Wait Until Element Is Enabled    ${InventoryLink}    timeout=10s
    Wait Until Keyword Succeeds    3times    3s    Click Element   ${InventoryLink}
    Click Element    ${InventoryReconcileLink}
    Title Should Be    Inventory Reconcile Ledger

Click On Available Backstock
    Wait Until Page Contains Element    //*[@id="viewInventoryBackstock"]    timeout=20s
    ${available_backstock_inventory_onclick}    Get Element Attribute    //*[@id="viewInventoryBackstock"]    onclick
    Execute JavaScript    ${available_backstock_inventory_onclick}
    
Open Active Reconcile
    Wait Until Element Is Enabled    ${OpenActiveReconcile}    timeout=10s
    Click Element    ${OpenActiveReconcile}
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[contains(text(),"Inventory Reconciliation")]    timeout=15s


Select Inventory Properties
    [Arguments]    ${InventoryProperties}
    FOR    ${element}    IN    @{InventoryProperties}
        IF    '${element}' == 'DefaultFacilityType'
            Click Element    ${DefaultFacilityType}
        END
        IF    '${element}' == 'IsPatientBasedInventory'
            Click Element    ${IsPatientBasedInventory}
        END
        IF    '${element}' == 'FacilityType'
            Select From List By Label    id=FacilityType    ${InventoryType}
        END
        IF    '${element}' == 'FacilityGroupNumber'
            Select From List By Label    id=FacilityGroupNumber    ${GroupInventory}
        END
    END
    
Select Inventory
    [Arguments]    ${inventory_name}
    Run Keyword And Ignore Error    Wait Until Page Contains Element   //*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]/div[1]/i
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]/div[1]/i    timeout=60s
    ${SelectInventory}=    Replace Variables    ${SelectInventory}
    Wait Until Page Contains Element    ${SelectInventory}    timeout=10s
    Scroll Element Into View    ${SelectInventory}
    Click Element    ${SelectInventory}
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]/div[1]/i    timeout=60s

Create Inventory
    Click Create Inventory
    Verify Location    AccountId    ${location}
    Save Inventory

Click Create Inventory
    Scroll Element Into View    ${CreateInventoryXpath}
    Wait Until Element Is Visible    ${CreateInventoryXpath}
    ${create_new_inventory}    Get Element Attribute    ${CreateInventoryXpath}    onclick
    Execute JavaScript    ${create_new_inventory}

Input Description Inventory Name
    [Arguments]    ${inventory_name}
    Wait Until Element Is Visible    ${DescriptionInventoryInput}
    Input Text    ${DescriptionInventoryInput}    ${inventory_name}

Select Group Inventory
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
Click Remove Inventory
    Wait Until Element Is Visible    ${RemoveInventoryBtn}    timeout=10s
    Click Element    ${RemoveInventoryBtn}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text


Get Maximized Page Size
    [Arguments]    ${screen}
    Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//div[@class='pager-navigation']
    ${html_content}=    SeleniumLibrary.Get Element Attribute    xpath=//div[@id='${screen}']//div[@class='pager-navigation']    outerHTML
    ${maximize_page_size}=    Get Max Page Size    ${html_content}
    RETURN    ${MAXIMIZE_PAGE_SIZE}

Get All Inventory Name
    ${list_inventory_name}    Create List
    ${elements}    Get WebElements    //*[contains(@class,'InventoryFacilitySelect')]
    FOR    ${element}    IN    @{elements}
        ${target}    Execute JavaScript    return arguments[0].childNodes[1].textContent.trim();
        ...    ARGUMENTS
        ...     ${element}
        # ${target}    SeleniumLibrary.Get Element Attribute    ${element}    text
        Append To List    ${list_inventory_name}    ${target}
    END
    RETURN    ${list_inventory_name}

Get All Facility Name From Inventory Level
    ${list_inventory_name}    Create List
    ${elements}    Get WebElements    //*[contains(@class,'InventoryFacilitySelect')]
    FOR    ${element}    IN    @{elements}

        ${target}    SeleniumLibrary.Get Element Attribute    ${element}    text
        Append To List    ${list_inventory_name}    ${target}
    END
    RETURN    ${list_inventory_name}
# ------------------- VERIFY ---------------------------
# ------------------------------------------------------


Verify Display Inventory Reconcile Screen
    Wait Until Page Contains Element    ${OpenActiveReconcile}    timeout=10s    error=Inventory Reconcile table is not displayed

Verify Create Inventory Empty Name
    ${alert_text}=    Handle Alert And Return Its Text
    # Should Be Equal    ${alert_text}    ${AlertDescriptionInventory}

Verify Update Inventory Success
    Sleep    2
    ${inventory_name_updated}=    SeleniumLibrary.Get Element Attribute    ${DescriptionInventoryInput}    value
    ${inventory_type_updated}=    Get Selected List Label    id=FacilityType
    ${sort_by_group_updated}=    Get Selected List Label    id=FacilityGroupNumber
    ${check_type_status_updated}=    SeleniumLibrary.Get Element Attribute    ${IsPatientBasedInventory}    checked

    Should Be Equal     ${inventory_name_updated}     ${InventoryNameUpdated}
    Should Be Equal     ${inventory_type_updated}    ${InventoryTypeUpdated}
    Should Be Equal     ${sort_by_group_updated}    ${GroupInventoryUpdated}
    Should Be Equal     ${check_type_status_updated}    true