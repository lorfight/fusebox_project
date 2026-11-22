*** Settings ***
Documentation    Verify the functionality of the inventory reconciliation process, including order, transfer, and dispense operations.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource


Library    DependencyLibrary

Suite Setup   Set Up Suite
Suite Teardown    Close Browser
Test Tags    test:retry(2)    Accounting    Regression    inventory    IV_014    report.label.owner:Cuong Pham

*** Test Cases ***
Verify switching between inventories while an active reconcile exists (Buy & Bill → Patient Reservoir → Buy & Bill)
    [Documentation]    [888]_1    (Buy & Bill → Patient Reservoir → Buy & Bill)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${buyandbill_reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Specialty Pharmacy
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${buyandbill_reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory
    # Complete Reconcile




Verify switching between inventories while an active reconcile exists (Patient Reservoir → Buy & Bill → Patient Reservoir)
    [Documentation]    [888]_2    (Patient Reservoir → Buy & Bill → Patient Reservoir)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Specialty Pharmacy
    Open Reconcile History By Id    ${reconcile_id}
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Patient Reservoir → Sample → Patient Reservoir)
    [Documentation]    [888]_3    (Patient Reservoir → Sample → Patient Reservoir)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Specialty Pharmacy
    Open Reconcile History By Id    ${reconcile_id}
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Sample → Patient Reservoir → Sample)
    [Documentation]    [888]_4    (Sample → Patient Reservoir → Sample)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Specialty Pharmacy
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Buy & Bill → Sample → Buy & Bill)
    [Documentation]    [888]_5    (Buy & Bill → Sample → Buy & Bill)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${buyandbill_reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${buyandbill_reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Sample → Buy & Bill → Sample)
    [Documentation]    [888]_6    (Sample → Buy & Bill → Sample)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Buy & Bill → Supplies → Buy & Bill)
    [Documentation]    [888]_7    (Buy & Bill → Supplies → Buy & Bill)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Supplies
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Supplies → Buy & Bill → Supplies)
    [Documentation]    [888]_8    (Supplies → Buy & Bill → Supplies)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Supplies
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Supplies
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Sample → Supplies → Sample)
    [Documentation]    [888]_9    (Sample → Supplies → Sample)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Supplies
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify switching between inventories while an active reconcile exists (Supplies → Sample → Supplies)
    [Documentation]    [888]_10    (Supplies → Sample → Supplies)
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Supplies
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Select Facility In Inventory    Supplies
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

# complete reconcile

Verify completing a reconcile after entering data in another internal inventory (Buy & Bill → Patient Reservoir)
    [Documentation]    [888]_11
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Specialty Pharmacy
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${reconcile_id}
    OpenActiveReconcile.Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Patient Reservoir → Buy & Bill)
    [Documentation]    [888]_12
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Specialty Pharmacy
    Open Reconcile History By Id    ${reconcile_id}
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Patient Reservoir → Sample)
    [Documentation]    [888]_13
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Specialty Pharmacy
    Open Reconcile History By Id    ${reconcile_id}
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Sample → Patient Reservoir)
    [Documentation]    [888]_14
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Specialty Pharmacy
    OpenActiveReconcile.Open Active Reconcile
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Buy & Bill → Sample)
    [Documentation]    [888]_15
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Sample → Buy & Bill)
    [Documentation]    [888]_16
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Buy & Bill → Supplies)
    [Documentation]    [888]_17
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Default Inventory
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Default Inventory
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Supplies → Buy & Bill)
    [Documentation]    [888]_18
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Supplies
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Default Inventory
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Supplies
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Sample → Supplies)
    [Documentation]    [888]_19
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Sample
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Supplies
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Sample
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory

Verify completing a reconcile after entering data in another internal inventory (Supplies → Sample)
    [Documentation]    [888]_20
    [Setup]    Setup Test Case    checked_location=${data_input}[checked_location]    checked_facility=Supplies
    Run Keyword And Ignore Error    OpenActiveReconcile.Open Active Reconcile
    ${reconcile_id}    Get Reconcile History id
    Select Facility In Inventory    Sample
    OpenActiveReconcile.Open Active Reconcile
    Select Type Reconcile    full
    CommonKeywords.Handle Scan Barcode Reconcile    ${BARCODES_TRANSFER}[0]
    Complete Reconcile
    Select Facility In Inventory    Supplies
    Open Reconcile History By Id    ${reconcile_id}
    Select Type Reconcile    full
    Verify Not Display Reconcile Inventory
*** Keywords ***
Set Up Suite
    Set Selenium Speed    0.1s
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}

Setup Test Case
    [Arguments]    ${checked_location}    ${checked_facility}
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    checked_location=${checked_location}    checked_facility=${checked_facility}


Suite Teardown
    CommonKeywords.Close Browser Session

Verify Not Display Reconcile Inventory
    Page Should Not Contain Element    //*[contains(@class,"active")]//*[@id="ReconciledItemsTable"]//table