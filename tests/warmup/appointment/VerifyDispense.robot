*** Settings ***
Documentation      Dispense From Appointment

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Dispense.resource
Resource	../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource	../../../resources/PageObjects/Keywords/Order.resource
Variables    ../../../resources/PageObjects/Keywords/Inventory/Common/Utils.py
Suite Setup    Set Up Suite
Test Teardown    Close Browser
Test Tags    test:retry(1)    Admin    AP_100

*** Test Cases ***
Verify Dispensing
    [Documentation]   AP-OI004_TC05
    [Tags]    Smoke    test:retry(2)
    [Setup]    Set Up Test Case
    Schedule And Dispense
    # Verify in inventory reconcile

*** Keywords ***
Verify in inventory reconcile
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    ReconcileDetail.Verify In View Item    ndc=${ndc}    dispense_qty=${dispensed_qty}

Set Up Suite
    ${data_input}    Get Data
	Set Suite Variable    $checked_location    ${data_input}[checked_location]
    Set Suite Variable    $patient    ${data_input}[patient]
    Set Suite Variable    $dispensed_qty    ${data_input}[dispensed_qty]
    Set Suite Variable    $ndc    ${data_input}[ndc]
    Set Suite Variable    $checked_facility    ${data_input}[checked_facility]
    
Set Up Test Case
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}

Reset And Fill Empty Reconcile
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    InventoryReconcile.Open Active Reconcile
    ReconcileDetail.Select Type Reconcile    full

Schedule And Dispense
    Dispense.Go Dispensing
    Wait Until Keyword Succeeds    3 times    2s    Dispense.Filter By Location    ${checked_location}
    Dispense.Go To Schedule New Appointment
    Select Patient    patient=${Patient}
    Selected Therapy    therapy=Fasenra Injection
    Select Medications And dosages For Therapy    dosages_qty=20
    Approve Therapy And Begin Scheduling
    Config Scheduling    start_time=10:00 am    appointment_length=40
    Dispense.Select Ledger View
    ${date_time}    Get Time Now    result_format=%m/%d/%Y
    Wait Until Keyword Succeeds    3 times    1
    ...    Dispense.Filter Appointment
    ...    date_time=${date_time}
    ...    medication=Fasenra
    ...    appointment_status=Scheduled
    Dispense.Open Appointment
    Dispense.Select Item Therapy    therapy_item=Fasenra Syringe of 30
    Wait Until Keyword Succeeds    3 times    2s    Dispense.Input Qty ${dispensed_qty}
    Wait Until Keyword Succeeds    3 times    1    Dispense.Approve And Dispense
    Dispense.Scan ${dispensed_qty} ${BARCODES_TRANSFER}
    Dispense.Select Facility And Complete Dispense    ${checked_facility}
    Wait Until Keyword Succeeds    3 times    1   Dispense.Close Appointment

Add Primary Medication
    Set Selenium Speed    0.1s
    Dispense.Add Medication
    Dispense.Select Therapy Medication    medication=Fasenra
    Dispense.Input Dose    dose=30
    Click Button    Submit
    Wait Until Page Contains    Appointment Item Successfully Created!