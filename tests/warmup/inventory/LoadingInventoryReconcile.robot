*** Settings ***
Documentation     Verify the Inventory Reconcile screen functionality from both inventory reconcile and inventory level.
# Library    SeleniumLibrary    plugins=${EXECDIR}/libraries/AllureSeleniumPlugin.py    run_on_failure=Capture Page Screenshot
Variables  ../../../resources/PageObjects/TestData/Testdata.py

Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Set Up Suite
Suite Teardown    Close Browser

Test Tags    IV_103
*** Variables *** 
${data_input}

*** Test Cases ***
Verify Loading List Inventory Reconcile
    [Documentation]    FB__10    Verify Loading List Inventory Reconcile
    [Tags]    Smoke    Admin    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Loading List
    InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${data_input}[checked_location]
    Waiting For Loading
    ${list_inventory_name}    InventoryReconcile.Get All Inventory Name
    FOR    ${inventory_name}    IN    @{list_inventory_name}
        InventoryReconcile.Select Inventory    ${inventory_name}
        InventoryReconcile.Verify Display Inventory Reconcile Screen
    END

# Verify Loading List Inventory Reconcile From Inventory List
#     [Documentation]    FB__11    Verify Loading List Inventory Reconcile From Inventory List
#     [Tags]    Smoke    Admin    inventory
#     ...  report.label.owner:Cuong Pham
#     ...  report.label.severity:normal
#     ...  report.label.epic:Inventory Management
#     ...  report.label.feature:Inventory Reconcile
#     ...  report.label.story:Loading List
#     InventoryLevel.Go Inventory Level
#     Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${data_input}[checked_location]
#     Waiting For Loading
#     ${list_inventory_name}    InventoryReconcile.Get All Facility Name From Inventory Level
#     FOR    ${inventory_name}    IN    @{list_inventory_name}
#         InventoryLevel.Select Facility In Inventory Level    ${inventory_name}
#         InventoryLevel.Go Into Inventory Reconcile
#         InventoryReconcile.Verify Display Inventory Reconcile Screen
#     END

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    Set Suite Variable    ${data_input}