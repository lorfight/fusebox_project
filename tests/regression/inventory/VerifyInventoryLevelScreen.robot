*** Settings ***
Documentation      Verify the functionality of inventory reconciliation details, including adding, emptying, change changes, and full item reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource



Suite Setup     Set Up Suite
Test Setup    Setup Test Case
Suite Teardown    Close Browser
Test Tags    test:retry(2)    inventory    Regression    IV_008

*** Variables ***
${data_input}

*** Test Cases ***
Verify Inventory Level Screen 
    [Tags]    [reconcile]_11    Accounting
    ...  report.label.owner:Cuong Pham
    Get Overall Inventory Value
    Go Through All Facility Inventory
    Summerize Inventory Level Value
    Verify Overall Inventory Value
    
Verify Inventory Level Screen Serialized Tooltip
    [Tags]    [reconcile]_12    Accounting
    ...  report.label.owner:Cuong Pham
    Verify Show ToolTip Serialized Item Tracker

Verify Show ToolTip Perform an Inventory Adjustment using your barcode scanner
    [Tags]    [reconcile]_14    Accounting
    ...  report.label.owner:Cuong Pham
    Verify Show ToolTip Perform an Inventory Adjustment using your barcode scanner.

Verify Show ToolTip Adjust Inventory Using Your Barcode Scanner
    [Tags]    [reconcile]_16    Accounting
    ...  report.label.owner:Cuong Pham
    Verify Show ToolTip Adjust Inventory Using Your Barcode Scanner

Verify Navigated To Inventory Levels & Transactions
    [Tags]    [reconcile]_15    [reconcile]_17    [reconcile]_21    Accounting
    ...  report.label.owner:Cuong Pham
    Select Checkbox    //*[@id="InventorySettingsButton"]
    Unselect Checkbox    //*[@id="InventorySettingsButton"]
    

Verify Find Item In Inventory Level Screen
    [Tags]    [reconcile]_20    Accounting
    ...  report.label.owner:Cuong Pham
    InventoryLevels.Select Show Empty Inventory
    Find Inventory With NDCItem

Verify Inventory Level Screen Serialized Popup
    [Tags]    [reconcile]_13    Accounting
    ...  report.label.owner:Cuong Pham
    Verify Serialized Popup
    [Teardown]    Close Modal Serialized Item Tracker

Verify Popup Inventory Create
    [Tags]    [reconcile]_24    Accounting
    ...  report.label.owner:Cuong Pham
    InventoryFacility.Click Create Inventory
    Verify Create Inventory Department Popup
    [Teardown]    InventoryFacility.Close Modal Create Inventory

# Verify System Will Switch To Inventory Levels & Transactions
#     [Tags]    [reconcile]_25    Accounting
#     ...  report.label.owner:Cuong Pham
#     Click On Reconcile Inventory
#     Wait Until Page Contains Element   //*[contains(@class,"active")]//*[contains(text(),"Open Active Reconcile")]    timeout=20s
#     Click On Available Backstock
#     Wait Until Page Contains Element   //div[contains(@class,'active')]//*[@id="LevelList"]    timeout=20s

Verify Inventory Level Screen Update Inventory
    [Tags]    [reconcile]_26    Accounting
    [Documentation]    [reconcile]_26
    ...  report.label.owner:Cuong Pham
    InventoryFacility.Click Edit Inventory
    Verify Update Inventory Department Popup
    [Teardown]    InventoryFacility.Close Modal Create Inventory

# Verify Inventory Open Active Reconcile
#     [Tags]    [reconcile]_27    [reconcile]_28    [reconcile]_56        Accounting
#     ...  report.label.owner:Cuong Pham
#     Click On Reconcile Inventory
#     Wait Until Page Contains Element   //*[contains(@class,"active")]//*[contains(text(),"Open Active Reconcile")]    timeout=20s
#     Open Active Reconcile
#     Wait Until Page Contains Element   //*[contains(@class,"active")]//*[contains(text(),"Inventory Reconciliation")]    timeout=20s
#     Get Reconcile History id
#     Verify Back To List Reconcile
#     Open Active Reconcile
#     ${reconcile_current_id}    Return Reconcile History id
#     Should Be Equal    ${reconcile_current_id}    ${reconcile_history_id}

Verify Inventory Reconcile Screen
    [Tags]    [reconcile]_29    [reconcile]_30    Accounting
    ...  report.label.owner:Cuong Pham
    Scroll Element Into View    //a[text()='Specialty Pharmacy' and @data-toggle='tab']
    Wait Until Keyword Succeeds    10s    1s    Click Element    //a[text()='Specialty Pharmacy' and @data-toggle='tab']
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=30s
    Click On Reconcile Inventory
    Wait Until Page Contains Element   //*[contains(@class,"active")]//*[contains(text(),"Open Active Reconcile")]    timeout=20s
    InventoryReconcile.Go Inventory Reconcile
    InventoryFilter.Select Location    ${data_input}[checked_location]
    InventoryFilter.Select Facility In Inventory    Specialty Pharmacy
    Waiting For Loading
    Open Active Reconcile
    Get Reconcile History id
    Verify Back To List Reconcile
    Open Active Reconcile
    ${reconcile_current_id}   Return Reconcile History id
    Should Be Equal    ${reconcile_current_id}    ${reconcile_history_id}

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Selenium Speed    0.1s
    Login To Fusebox    user_name=${Username}    password=${Password}    #robotcode:ignore
    

Setup Test Case
    InventoryLevels.Go To Inventory Levels
    InventoryFilter.Select Location    ${data_input}[checked_location]
    Waiting For Loading
    Wait Until Page Does Not Contain Element   //*[@id="overall-inventory-value"]/i    timeout=240s

Suite Teardown
    Close Browser Session

Get Overall Inventory Value
    [Arguments]    ${location}=${data_input}[checked_location]
    InventoryFilter.Select location    ${location}
    Wait Until Page Does Not Contain Element   //*[@id="overall-inventory-value"]/i    timeout=240s
    ${overall_inventory_value}    SeleniumLibrary.Get Element Attribute    //*[@id="overall-inventory-value"]    innerHTML
    ${overall_inventory_value}    convert_price_string_to_float    ${overall_inventory_value}
    Set Test Variable    ${overall_inventory_value}    ${overall_inventory_value}

Summerize Inventory Level Value
    ${total_invValue}    Set Variable    ${0}
    ${list_invValue}    Get WebElements    //*[contains(@class, 'invValue') and not(contains(@class, 'hidden'))]
    FOR    ${invValue}    IN    @{list_invValue}
        ${invValue}    SeleniumLibrary.Get Element Attribute    ${invValue}    innerHTML
        ${invValue}    convert_price_string_to_float    ${invValue}
        ${total_invValue}    Evaluate    ${total_invValue} + ${invValue}
    END
    Set Test Variable    ${total_invValue}    ${total_invValue}
Go Through All Facility Inventory
    ${list_inventory_facility_name}    InventoryFacility.Get All Inventory Facility Name
    FOR    ${inventory_facility_name}    IN    @{list_inventory_facility_name}
        InventoryFilter.Select Facility In Inventory    ${inventory_facility_name}
    END

Verify Overall Inventory Value
    Should Be Equal As Numbers    ${total_invValue}    ${overall_inventory_value}    #robotcode:ignore

Verify Show ToolTip Serialized Item Tracker
    Wait Until Page Contains Element   //*[@data-toggle='tooltip' and @data-original-title="Show Serialized Item Tracker"]    timeout=20s    error=Show Serialized Item Tracker tooltip not displayed
    
Verify Show ToolTip Perform an Inventory Adjustment using your barcode scanner.
    Wait Until Page Contains Element   //*[@data-toggle='tooltip' and @data-original-title="Perform an Inventory Adjustment using your barcode scanner."]    timeout=20s    error=Perform an Inventory Adjustment tooltip not displayed

Verify Serialized Popup
    Click Element    //a[@id='ShowSerializedItemTrackerButton']
    Wait Until Page Contains Element    //div[@class='modal-content']//*[text()='Serialized Item Tracker']    timeout=20s    error=Serialized Item Tracker popup not displayed

Verify Show ToolTip Adjust Inventory Using Your Barcode Scanner
    Wait Until Page Contains Element   //*[@data-toggle='tooltip' and @data-original-title="Adjust Inventory Visibility / Default Dispensing."]    timeout=20s    error=Perform an Inventory Adjustment tooltip not displayed

Close Modal Serialized Item Tracker
    Wait Until Element Is Visible    //button[@id='TopCloseBtn']
    Click Element    //button[@id='TopCloseBtn']
    Wait Until Page Does Not Contain Element    //div[@class='modal fade in']//*[text()='Serialized Item Tracker']    timeout=20s    error=Serialized Item Tracker popup not closed

Click On Reconcile Inventory
    Wait Until Page Contains Element    //*[@id="ToggleReconcileInventoryBtn"]    timeout=20s
    ${reconcile_inventory_onclick}    SeleniumLibrary.Get Element Attribute    //*[@id="ToggleReconcileInventoryBtn"]    onclick
    Execute JavaScript    ${reconcile_inventory_onclick}
    Wait Until Page Contains    Open Active Reconcile    timeout=20s
    Title Should Be    Inventory Reconcile Ledger

Find Inventory With NDCItem
    [Arguments]    ${ndc_item}=00310-1730-30
    InventoryFilter.Search For Item #,NDC    ${ndc_item}

Verify Create Inventory Department Popup
    Wait Until Page Contains Element    //div[@class='modal fade in']//h4[text()='Create Inventory Department']    timeout=20s    error=Create Inventory Department popup not displayed

Verify Update Inventory Department Popup
    Wait Until Page Contains Element    //div[@class='modal fade in']//h4[text()='Update Inventory Department']    timeout=20s    error=Update Inventory Department popup not displayed

Click On Available Backstock
    InventoryReconcile.Click On Available Backstock

Verify Back To List Reconcile
    OpenActiveReconcile.Back To List
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s