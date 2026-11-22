*** Settings ***
Documentation    Verify the functionality of the inventory reconciliation process, including order, transfer, and dispense operations.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource

Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Resource	../../../resources/PageObjects/Keywords/Receiving.resource

Suite Setup   Set Up Suite
Test Teardown    Close Browser
Test Tags    test:retry(2)    Admin    Accounting    Regression    inventory    IV_002

*** Test Cases ***
Verify Reconcile Process After Order, Transfer, and Dispense (TDD)
	[Documentation]   Verify the reconciliation process after performing order, transfer, and dispense operations.
    [Tags]    [Reconcile_partial]_30    [Reconcile_partial]_31    [Reconcile_partial]_32    [Reconcile_partial]_33
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Full Inventory
    [Setup]    Setup Test Case
    [Template]    Verify Reconcile After Order: ${order_qty},Transfer: ${other_changes_qty} and Dispense: ${dispensed_qty}
    # 4    1    1
	2    2    1
	# 3    2    1

Verify Reconcile Item Untouch
    [Documentation]   Verify the reconciliation process within inventory transactions.
    [Tags]    test:retry(2)    [Reconcile_partial]_40    [reconcile]_132
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Full Inventory
    ...  report.label.TC_ID:[Reconcile_]_40
    [Setup]    Setup Test Case
    InventoryReconcile.Reset And Fill Empty Reconcile    ${checked_location}    ${checked_facility}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    checked_location=${checked_location}    checked_facility=${checked_facility}
    InventoryLevels.Select Show Empty Inventory
    InventoryLevels.Find Inventory With NDCItem    ${ndc}
    Adjust Inventory On Hand ${ndc}
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    Select Type Reconcile    full
    Adjust Actual Qty On Hand
    Complete Reconcile
    Open Active Reconcile
    Select Type Reconcile    full
    Wait Until Page Contains Element    //*[@id="ReconciledItemsTable"]    timeout=30s    error=Reconciled Table Not Appear

*** Keywords ***
Adjust Inventory On Hand ${ndc}
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[@id="LevelList"]//*[text()="${ndc}"]//ancestor::tbody//*[@class="QtyOnHandLink"]    timeout=10s
    InventoryLevels.Adjust Inventory On Hand
    ${list_item}    Create List
    FOR    ${index}    IN RANGE    1    3
        Wait Until Keyword Succeeds    3times    1s    Select Lot Number By ${index}
        Wait Until Keyword Succeeds    3times    1s    Select Contract Price By ${index}
        Wait Until Keyword Succeeds    3times    1s    Input Qty On Hand ${index}
        ${lot_number}    Get Selected List label    id=LotDetailId
        ${qty}    Set Variable    ${index}
        Wait Until Keyword Succeeds    3times    1s    Click Add New Qty On Hand
        Add Item To List    ${list_item}    ${lot_number}    ${qty}
    END
    Set Test Variable     ${list_item}
    Save Inventory Adjustment Modal

Adjust Actual Qty On Hand
    ${count_item}    Get Length    ${list_item}
    FOR    ${index}    IN RANGE   ${count_item}
        Wait Until Page Contains Element    id=ReconcileLine_${index+1}    timeout=60s
        Input Text    id=ReconcileLine_${index+1}    ${index}
    END

Input Qty On Hand ${qty}
    Input Text    //*[@id="newQty"]    ${qty}

Click Add New Qty On Hand
    Click Element    css:[id="newQtyOnHand"]
    Wait Until Page Contains    Inventory Updated!

Select Lot Number By ${index}
    Wait Until Page Contains Element    id=LotDetailId
    ${options}=    Get List Items    id=LotDetailId
    ${count}=    Get Length    ${options}
    ${index}=    Evaluate    random.choice(range(2,${count}-2))
    Select From List By Index    id=LotDetailId    ${index}

Select Contract Price By ${index}
    Wait Until Page Contains Element    id=Price
    ${options}=    Get List Items    id=Price
    ${count}=    Get Length    ${options}
    ${index}=    Evaluate    random.choice(range(1,${count}))
    Select From List By Index    id=Price    ${index}

Verify Reconcile In Inventory Transaction Set Up
    Setup Test Case
    InventoryReconcile.Reset And Fill Empty Reconcile    ${checked_location}    ${checked_facility}
    ${log_action_before_reconcile}    Create List
    Set Test Variable    ${log_action_before_reconcile}
    Order "2", Transfer "1" And Dispense "1"
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    ${reconcile_status}    Run Keyword And Return Status    Scan And Complete Reconcile
    Write Action To Log    reconcile_status=${reconcile_status}

Scan And Complete Reconcile 
    Get Reconcile History id
    InventoryUtils.Scan List Barcode   barcode=${BarcodeItem}
    OpenActiveReconcile.Complete Reconcile

Verify Inventory Transaction
    [Arguments]    ${checked_location}=${checked_location}    ${checked_facility}=${checked_facility}    ${ndc}=${ndc}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    checked_location=${checked_location}    checked_facility=${checked_facility}
    InventoryLevels.Find Inventory With NDCItem    ${ndc}
    InventoryLevels.Select Show Empty Inventory
    Wait Until Keyword Succeeds    5times    1    InventoryLevels.Show Transaction UoM "Syringe"
    InventoryLevels.Get Last Action Inventory Level Before Reconcile

Write Action To Log
    [Arguments]    ${dispense_status}=False    ${transfer_status}=False    ${receive_status}=False    ${reconcile_status}=False
    IF    ${reconcile_status} == ${True}
        ${reconcile_action}    Create Dictionary    Type=Inventory Reconcile    Adjustment=${1}
        Insert Into List    ${log_action_before_reconcile}    0    ${reconcile_action}
    END
    IF    ${dispense_status} == ${True}
        ${dispense_action}    Create Dictionary    Type=Dispense    Adjustment=${-${dispensed_qty}}
        Insert Into List    ${log_action_before_reconcile}    0    ${dispense_action}
    END
    IF    ${transfer_status} == ${True}
        ${transfer_action}    Create Dictionary    Type=Inventory Transfer    Adjustment=${-${other_changes_qty}}
        Insert Into List    ${log_action_before_reconcile}    0    ${transfer_action}
    END
    IF    ${receive_status} == ${True}
         ${receive_action}    Create Dictionary    Type=PO Receipt Adjustment    Adjustment=${${order_qty}}
         Insert Into List    ${log_action_before_reconcile}    0    ${receive_action}
    END
Verify Reconcile After Order: ${order_qty},Transfer: ${other_changes_qty} and Dispense: ${dispensed_qty}
    ${log_action_before_reconcile}    Create List
    Set Test Variable    ${log_action_before_reconcile}
	Order "${order_qty}", Transfer "${other_changes_qty}" And Dispense "${dispensed_qty}"
    Verify ${order_qty} And ${dispensed_qty} And ${other_changes_qty} In Reconcile
	Add Actual Qty And Complete Reconcile
    Open Active Reconcile
    Select Type Reconcile    full
    Verify After Complete Reconcile
    
Order "${order_qty}", Transfer "${other_changes_qty}" And Dispense "${dispensed_qty}"
    Setup Variables ${order_qty} ${other_changes_qty} ${dispensed_qty}
    Create Order ${order_qty}
	Verify Create Order Succeeds ${po_number}
	${receive_status}    Run Keyword And Return Status    Receive ${order_qty} Order
    Write Action To Log    receive_status=${receive_status}
	${transfer_status}    Run Keyword And Return Status    Create Transfer ${other_changes_qty}
    Write Action To Log    transfer_status=${transfer_status}
	Schedule Appointment
    ...    therapy=Fasenra Injection
    ...    start_time=10:00 am
    ...    appointment_length=40
    ...    dosages_qty=20
    ${dispense_status}    Run Keyword And Return Status    Complete Dispense
    ...    medication=Fasenra
    ...    appointment_stat=Requires Approval
    ...    therapy_item=Fasenra Syringe of 30
    ...    dispensed_qty=${dispensed_qty}
    Write Action To Log    dispense_status=${dispense_status}
    
Create Order ${order_qty}
	Go Order
    Config Order
    ...    location=${checked_location}
    ...    ndc=${ndc}
    ...    vendor=${vendor}
    ...    order_qty=${order_qty}
    Config My Cart
    Submit Order

Verify Create Order Succeeds ${po_number}
    Wait Until Page Contains Element    //li[@class="active" and text()="Open Orders"]    timeout=30s
    OrderFilter.Search For An Order ${po_number}
	OrderLIst.View Order    ${po_number}

Receive ${order_qty} Order
	Receiving.Apply Item    barcode=${BARCODES_TRANSFER}[:${order_qty}]    checked_facility=${checked_facility}    order_qty=${order_qty}

Create Transfer ${other_changes_qty}
    Log To Console    message=from_account=${checked_location},from_facility=${checked_facility},to_account=${checked_location},to_facility=${to_facility},list_barcode=${BARCODES_TRANSFER}[:${other_changes_qty}]
    Create Transfer    from_account=${checked_location}    from_facility=${checked_facility}    to_account=${checked_location}    to_facility=${to_facility}    list_barcode=${BARCODES_TRANSFER}[:${other_changes_qty}]

Create Transfer
    [Arguments]    ${from_account}    ${from_facility}    ${to_account}    ${to_facility}    ${list_barcode}
	Go To Inventory Transfer
    New Inventory Transfer
    NewInventoryTransfer.Select The Account To Transfer From    ${from_account}
    NewInventoryTransfer.From Inventory    ${from_facility} ( Buy & Bill )
    NewInventoryTransfer.Select The Account To Transfer To    ${to_account}
    NewInventoryTransfer.To Inventory    ${to_facility}
    ${transfer_id}    NewInventoryTransfer.Get Id Transfer
    InventoryUtils.Scan List Barcode    ${list_barcode}
	NewInventoryTransfer.Submit Transfer
    RETURN    ${transfer_id}   

Schedule Appointment
    [Arguments]    ${therapy}    ${start_time}    ${appointment_length}    ${dosages_qty}
    Set Selenium Speed    0.1s
    Dispense.Go Dispensing
    Dispense.Filter By Location    ${checked_location}
    Dispense.Go To Schedule New Appointment
    Select Patient    patient=${Patient}
    Selected Therapy    therapy=${therapy}
    Select Medications And dosages For Therapy    dosages_qty=${dosages_qty}
    Approve Therapy And Begin Scheduling
    Config Scheduling    start_time=${start_time}  appointment_length=${appointment_length}

Complete Dispense
    [Arguments]    ${medication}    ${appointment_stat}    ${therapy_item}    ${dispensed_qty}
    TRY    
        Wait Until Keyword Succeeds    3 times    1    Dispense.Select Ledger View
        ${date_time}    Get Time Now    result_format=%m/%d/%Y
        Wait Until Keyword Succeeds    3 times    1
        ...    Dispense.Filter Appointment
        ...    date_time=${date_time}
        ...    medication=${medication}
        ...    appointment_status=${appointment_stat}
        Dispense.Open Appointment
        Dispense.Select Item Therapy    therapy_item=${therapy_item}
        Wait Until Keyword Succeeds    3 times    1    Dispense.Input Qty ${dispensed_qty}
        Wait Until Keyword Succeeds    3 times    1    Dispense.Approve And Dispense
        Dispense.Scan ${dispensed_qty} ${BARCODES_TRANSFER}
        Dispense.Select Facility And Complete Dispense    ${checked_facility}
    FINALLY
        Wait Until Keyword Succeeds    3 times    1   Dispense.Close Appointment
    END

Verify ${order_qty} And ${dispensed_qty} And ${other_changes_qty} In Reconcile
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    OpenActiveReconcile.Select Type Reconcile    type=full
	Verify Dispensed and Received and Other Change In Reconcile Table
	...    ndc=${ndc}
	...    received_qty=${order_qty}
	...    dispense_qty=${dispensed_qty}
	...    other_change_qty=${other_changes_qty}
Verify After Complete Reconcile
    InventoryFilter.Search For Item #,NDC    ${ndc}
    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    ${table}    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${actual}    Get Data From Html Table Reconciled Test    ${table}
    Should Be Equal As Numbers   ${actual}[Expected Qty On Hand]    ${actual_qty}

Add Actual Qty And Complete Reconcile 
    Get Reconcile History id
    Set Test Variable    ${actual_qty}    1
    Input Text    ReconcileLine_1      ${actual_qty}
    OpenActiveReconcile.Complete Reconcile

Verify Dispensed and Received and Other Change In Reconcile Table
    [Arguments]    ${ndc}    ${dispense_qty}=0    ${received_qty}=0    ${other_change_qty}=0    ${last_qty_on_hand}=0
    InventoryFilter.Search For Item #,NDC    ${ndc}
    ${table}    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${actual}    Get Data From Html Table Reconciled Test    ${table}
    ${expect}    Create Dictionary
    ...    Dispensed=${-${dispense_qty}}
    ...    Received=${${received_qty}}
    ...    Other Changes=${-${other_change_qty}}
    ...    Expected Qty On Hand=${${last_qty_on_hand}-${dispense_qty}+${received_qty}-${other_change_qty}}
    ...    Last Qty On Hand=${${last_qty_on_hand}}
    Should Be Equal     ${actual}    ${expect}
    
Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${BarcodeItem}    ${data_input}[barcode]
    Set Suite Variable    ${checked_location}    ${data_input}[checked_location]
    Set Suite Variable    ${ndc}    ${data_input}[ndc]
    Set Suite Variable    ${checked_facility}    ${data_input}[checked_facility]
    Set Suite Variable    ${vendor}    ${data_input}[vendor]
    Set Suite Variable    ${to_facility}    ${data_input}[to_facility]
    Set Suite Variable    ${patient}    ${data_input}[patient]
Setup Test Case
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    checked_location=${checked_location}    checked_facility=${checked_facility}
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    # Set Selenium Speed    0.1s

Setup Variables ${order_qty} ${other_changes_qty} ${dispensed_qty}
	Set Test Variable    ${order_qty}
	Set Test Variable    ${other_changes_qty}
	Set Test Variable    ${dispensed_qty}
	Set Test Variable    ${last_qty_on_hand}    0
	InventoryReconcile.Reset And Fill Empty Reconcile    ${checked_location}    ${checked_facility}

Suite Teardown
    CommonKeywords.Close Browser Session

Add Item To List
    [Arguments]    ${list_item}    ${lot_number}    ${qty}
    ${item}    Create Dictionary    lot=${lot_number}    qty=${qty}
    Append To List    ${list_item}    ${item}