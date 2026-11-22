*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Admin    inventory    smoke    aws    INV_02    report.label.owner:Quoc Nguyen

*** Test Cases ***
Open Serialized Item Tracker
    [Documentation]    Verify Serialized Item Tracker Display Sucessfully    INV_01
    InventoryLevels.Go To Inventory Level And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    SerializedItemTracker.Open Serialized Item Tracker
    SerializedItemTracker.Get Item Barcode Value By Table Tab Tracker

Open Inventory Reconcile to Complete Reconcile Then Open Complete Log
    [Documentation]    Verify Inventory Reconcile Sucessfully    INV_02    INV_03    INV_04    INV_05
    InventoryReconcile.Go To Inventory Reconcile And Adjust All Item In Current Reconcile
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]   full
    OpenActiveReconcile.Cancel Reconcile
    # Verify Cancel Reconcile Successfully     ${reconcile_history_id}    
    
    InventoryReconcile.Go To Inventory Reconcile And Adjust All Item In Current Reconcile
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]   full
    OpenActiveReconcile.Complete Reconcile
    Verify Complete Reconcile Successfully    ${reconcile_history_id}
    Verify Complete Log SuccessFully    ${reconcile_history_id}

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}    
    Login To Fusebox    user_name=${Username}    password=${Password}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Reset Reconcile and Add Item By Scanning    
    ...     ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full    ${{['${data_input}[barcode]']}}    
    OpenActiveReconcile.Complete Reconcile   
    
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

# Consider rework all keyword below because they're relate to old keyword inside Util and CustomLibrary
# Also them using the xpath element what should only use in file resource
Verify Cancel Reconcile Successfully 
    [Arguments]    ${reconcile_history_id}
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    Wait Until Page Contains   text=This Inventory Reconcile has been Canceled.    timeout=20s
    Util.Scroll To Top
    ${status_reconcile}    SeleniumLibrary.Get Text    ${StatusReconcile}
    Should Be Equal    ${status_reconcile}    Canceled

Verify Complete Reconcile Successfully
    [Arguments]    ${reconcile_history_id}
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    Util.Scroll To Top
    Wait Until Element Is Visible    ${status_reconcile}    timeout=10s
    ${status_reconcile}    SeleniumLibrary.Get Text    ${status_reconcile}
    Should Be Equal    ${status_reconcile}    Complete

Verify Complete Log SuccessFully
    [Arguments]    ${reconcile_history_id}
    Wait Until Element Is Visible    ${ReconcileTableXpath}
    ${html_table_reconcile}    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${table_reconile}   CustomLibrary.Get Data From Html Table Reconciled    ${html_table_reconcile}
    OpenActiveReconcile.Complete Log    ${reconcile_history_id}
    ${export_path}    Util.Download Report CSV SuccessFully    ManualInventoryCheck.csv
    ${completion_log}    CustomLibrary.Convert File Csv Complete Log    ${export_path}
    Should Be Equal     ${table_reconile}    ${completion_log}