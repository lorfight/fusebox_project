*** Settings ***
Documentation      Verify the functionality of inventory reconciliation details, including adding, emptying, recent changes, and full item reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup     Set Up Suite
Test Setup    Setup Test Case
Test Teardown    Close Browser
Test Tags    test:retry(2)    Manager    IV_102

*** Variables ***
${data_input}

*** Test Cases ***
Verify Add Item Reconcile To Inventory As ${Userrole}
    [Documentation]    FB_01    Verify adding an item during inventory reconciliation.
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Add Item
    ${barcode}     Evaluate   random.choice(${ListBarcode})
    Reconcile Item add And handle Barcode Then do Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is   add

Verify Empty Item Reconcile To Inventory As ${Userrole}
    [Documentation]    FB_02    Verify reconciling an empty item during inventory reconciliation.
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Empty Item
    ${barcode}     Evaluate   random.choice(${ListBarcode})
    Set Test Variable    ${barcode}
    Reconcile Item empty And handle Barcode Then do Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    full

Verify Recent Change Item Reconcile To Inventory As ${Userrole}
    [Documentation]    FB_03    Verify reconciling a recently changed item during inventory reconciliation.
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Recent Change
    ${barcode}     Evaluate   random.choice(${ListBarcode})
    Set Test Variable    ${barcode}
    Reconcile Item change And handle Barcode Then do Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    change

Verify Full Item Reconcile To Inventory As ${Userrole}
    [Documentation]    FB_04    Verify reconciling a full item during inventory reconciliation.
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Full Item
    ${barcode}     Evaluate   random.choice(${ListBarcode})
    Set Test Variable    ${barcode}
    Reconcile Item full And handle Barcode Then do Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    full


Verify Manual Add Products Feature As ${Userrole}
    [Documentation]    FB_06    Verify Manual Add Products Feature
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Manual Add Products
    ...  report.label.story:Add
    Reconcile Item full And handle Barcode Then not Complete
    Verify Manually Add Products    ndc=${data_input}[ndc]    qty=2    lot=${lot}


Verify Reset Assigned and Fill Empty Products As ${Userrole}
    [Documentation]    FB_07    Verify Reset Assigned Products
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Reset Assigned and Fill Empty Products
    ...  report.label.story:Reset and Fill
    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore

Verify Scan Barcode Reconcile As ${Userrole}
    [Documentation]    FB_08    Verify Scan Barcode Reconcile
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Scan Barcode
    ${list_barcode}     Evaluate   random.sample(${ListBarcode},20)
    Set Test Variable    ${list_barcode}
    Log    ${list_barcode}
    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Scan Barcode Reconcile Type   full    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Barcode Scan Successfully    ${list_barcode}
    Cancel Reconcile

Verify Cancel Reconcile As ${Userrole}
    [Documentation]    FB_10    Verify Cancel Reconcile
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Cancel Reconcile
    Reconcile Item full And handle Barcode Then not Complete
    Wait Until Keyword Succeeds    3times    1    Cancel Reconcile
    # Verify Reconcile Cancel    ${reconcile_history_id}    # robotcode: ignore

Verify Back to List Reconcile As ${Userrole}
    [Documentation]    FB_11    Verify Back to List Reconcile
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Back to list
    Wait Until keyword Succeeds    5times    1    Back To List
    Verify Back To List Succeeds

Verify Complete Log As ${Userrole}
    [Documentation]    [IN-I001]_TC17    Verify Complete Log
    [Tags]    Admin    Smoke    inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Complete Log
    ${ListBarcode}     Evaluate   random.sample(${ListBarcode},20)
    Set Test Variable    ${list_barcode}
    Reconcile Item full And scan Barcode Then do Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Complete Log Successfully    ${reconcile_history_id}    # robotcode: ignore

*** Keywords ***
Scan Barcode Reconcile Type
    [Arguments]    ${type}    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}    # robotcode: ignore
    Select Type Reconcile    ${type}
    Util.Handle Scan List Barcode    list_barcode=${list_barcode}

Reset And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}    # robotcode: ignore
    Select Type Reconcile    type=full
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty

Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${lot}    ${data_input}[lot_id]
    ${barcode}     Evaluate   random.choice(${ListBarcode})
    Set Suite Variable    ${barcode}
    Set Selenium Speed    0.1s

Setup Test Case
    Login To Fusebox    user_name=${Username}    password=${Password}
    # Set Suite Variable    $location    ${LocationInventory}
	# Set Suite Variable    $checked_facility    Test TDD
    # Set Suite Variable    $list_barcode    ${ListBarcode}
    InventoryLevel.Go Inventory Level
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${data_input}[checked_location]
    Select Facility In Inventory Level    inventory_name=${data_input}[checked_facility]
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]    # robotcode: ignore
    
Suite Teardown
    Close Browser Session

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    Open Active Reconcile