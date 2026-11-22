*** Settings ***
Documentation    Verify the functionality of scanning 88 barcodes during inventory reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Setup Suite
Test Setup    Setup Test Case
Test Teardown    Test Teardown

*** Variables ***
${data_input}

*** Test Cases ***
Verify Performance Scan 88 Barcode Reconcile
    [Documentation]    Verify the performance of scanning 88 barcodes during inventory reconciliation.
    [Tags]    Admin    Smoke    Regression    inventory    test:retry(3)
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Scan Barcode
    # Create Inventory Reconcile full And handle
    
    Create Inventory Reconcile add And scan
    Scan Barcode Reconcile Type    full
    Verify Barcode Scan Successfully    ${list_barcode}


*** Keywords ***
Create Inventory Reconcile ${type} And ${scan_type}
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Reconcile Item ${type} And ${scan_type} Barcode Then do Complete

Reset And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    Select Type Reconcile    full
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    Open Active Reconcile
    Get Reconcile History id
    

Scan Barcode Reconcile Type
    [Arguments]    ${type}
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Select Type Reconcile    ${type}
    Scan Barcode Reconcile    ListBarcode=${list_barcode}


Setup Suite
    Set Selenium Speed    0.1s
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

Setup Test Case
    Login To Fusebox    user_name=${Username}    password=${Password}
    # ${barcode}     Evaluate   random.choice(${list_barcode})
    Set Suite Variable    ${barcode}    01003031017303032103955221124050|1725063010TB0015
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location    checked_location=${data_input}[checked_location]
    Click Button    Clear
    Reset And Fill Empty Reconcile    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]

Cancel Reconcile If Test Failed
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Select Type Reconcile    add
    CommonKeywords.Handle Scan Barcode Reconcile    ${barcode}
    Cancel Reconcile
    Verify Reconcile Cancel    ${reconcile_history_id}    # robotcode: ignore




Test Teardown
    Run Keyword If Test Failed    Cancel Reconcile If Test Failed
    Close Browser Session
    