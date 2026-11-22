*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Accounting    inventory    Regression    IV_010

*** Test Cases ***
Go To Reconcile Inventory And Scan One Barcode Two Times
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_76
    ...  report.label.owner:Quoc Nguyen
    InventoryUtils.Scan List Barcode    ${{['${data_input}[barcode]']}}
    InventoryUtils.Scan List Barcode   ${{['${data_input}[barcode]']}}    0
    Util.Wait Alert Message Show And Disappear    The barcode you scanned has already been scanned for this reconcile.
    OpenActiveReconcile.Cancel Reconcile
Go To Reconcile Inventory And Scan Wrong RS Barcodes
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_77
    ...  report.label.owner:Quoc Nguyen
    ${wrong_rs_barcode}    InventoryUtils.Random RS Barcode
    InventoryUtils.Scan List Barcode    ${{['${wrong_rs_barcode}']}}    0
    Util.Wait Alert Message Show And Disappear     The barcode you scanned could not be found in the system. Please serialize your barcode and then try again.
Go To Reconcile Inventory And Scan Barcode Inside Completed Reconcile
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_78
    ...  report.label.owner:Quoc Nguyen
    OpenActiveReconcile.Reconcile Item full And Scan ${{['${data_input}[barcode]']}} Then Complete    
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    InventoryUtils.Scan List Barcode    ${{['${data_input}[barcode]']}}    0
    Util.Wait Alert Message Show And Disappear     Cannot update a Complete reconcile.
    [Teardown]    Teardown Test Case And Empty Reconcile   
Go To Reconcile Inventory And Scan Barcode Inside Canceled Reconcile
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_79
    ...  report.label.owner:Quoc Nguyen
    OpenActiveReconcile.Reconcile Item full And Scan ${{['${data_input}[barcode]']}} Then Cancel    
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    InventoryUtils.Scan List Barcode    ${{['${data_input}[barcode]']}}    0
    Util.Wait Alert Message Show And Disappear     Cannot update a Canceled reconcile.

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
Setup Test Case
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter
Teardown Test Case And Empty Reconcile
    Teardown Test Case
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
Teardown Suite
    Close Browser