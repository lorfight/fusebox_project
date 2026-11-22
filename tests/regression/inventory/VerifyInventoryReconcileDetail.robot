*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource   ../../../resources/PageObjects/Keywords/Receiving/Receiving.resource

Resource   ../../../resources/PageObjects/Keywords/Dispense.resource


Suite Setup     Set Up Suite
Suite Teardown    Close Browser
Test Setup    Setup Test Case
Test Tags    test:retry(2)    inventory    Regression    IV_009    Accounting

*** Variables ***
${data_input}
${barcode}    01003031017303032108400466291401|1728063010TB0015

*** Test Cases ***
# Verify Reconcile Reservoir Inventory Reconciliation Screen
#     [Tags]    [reconcile]_50
#     ...  report.label.owner:Cuong Pham
#     [Documentation]    report.label.owner:Cuong Pham
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
#     Wait Until Page Contains    Patient Search:

# Verify Functionality Of The Add product To Inventory Option
#     [Tags]    [reconcile]_60
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=add
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."
       
# Verify Functionality Of The Empty/Scan product To Inventory Option
#     [Tags]    [reconcile]_61
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=empty
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify Functionality Of The Recent Change product To Inventory Option
#     [Tags]    [reconcile]_62
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=change
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify Functionality Of The product To Inventory Option
#     [Tags]    [reconcile]_63
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=product
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify Functionality Of The Full product To Inventory Option
#     [Tags]    [reconcile]_64
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify The Inventory Reconciliation Table Dísplay Correctly
#     [Tags]    [reconcile]_65
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify The Detailed Information General Row
#     [Tags]    [reconcile]_66
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."

# Verify The Detailed Information Detail Row
#     [Tags]    [reconcile]_67
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."


# Verify Reconcile Display The Creation Timestamp Based Default TimeZone
#     [Tags]    [reconcile]_35
#     ...  report.label.owner:Cuong Pham
#     [Documentation]    report.label.owner:Cuong Pham
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]

# Verify Reconcile Line Item Count Column Displays The number Of Rows Have A Value in "Actual Qty On Hand"
#     [Tags]    [reconcile]_36
#     ...  report.label.owner:Cuong Pham
#     [Documentation]    report.label.owner:Cuong Pham
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     ${list_barcode}     Evaluate   random.sample(${ListBarcode},20)
#     ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
#     IF    ${is_clear_button_visible}==${True}
#         Clear Search
#     END
#     Select Type Reconcile    full
#     Get Reconcile History id
#     OpenActiveReconcile.Scan Barcode Reconcile    ${list_barcode}
#     ${count}=    Get WebElements    xpath=//*[starts-with(@id, 'ReconcileLine_')]
#     ${item_count}    Get Length    ${count}
#     Complete Reconcile
#     # Verify Item Counts Row    ${item_count}


# Verify The Value Last Qty On Hand
#     [Tags]    [reconcile]_68
#     Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     Execute JavaScript    handleScan("${barcode}")
#     ${last_qty_on_hand_expect}    evaluate    random.choice(range(1, 10))
#     Wait Until Keyword Succeeds    3times    3s    Input Reconcile Line    ${last_qty_on_hand_expect}
#     Complete Reconcile
#     Open Active Reconcile
#     Select Type Reconcile    type=full
#     Verify Last Qty On Hand Column    ${last_qty_on_hand_expect}

# Verify The Value At Received Column
#     [Tags]    [reconcile]_69    [reconcile]_126
#     Create Order And Receive Now
#     Open Inventory Transaction
#     Verify Receive In Inventory Transaction
    

# Verify The Value At Dispensed Column
#     [Tags]    [reconcile]_70
#     Dispense Now
#     Open Inventory Transaction
#     Verify Dispense In Inventory Transaction

# Verify The Value At Other Changes Column
#     [Tags]    [reconcile]_71
#     Create Transfer
#     Open Inventory Transaction
#     Verify Other Changes In Inventory Transaction

# Verify The Value At Expected Column
#     [Tags]    [reconcile]_72
#     Open Inventory Transaction
#     # Dispense Now
#     # Open Inventory Transaction
#     # Verify Dispense In Inventory Transaction

# Verify The User Can Not Edit This Field
#     [Tags]    [reconcile]_73    [reconcile]_74
#     [Setup]    Go Inventory And Cancel Reconcile
#     Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
#     Select Type Reconcile    type=full
#     execute JavaScript    handleScan("${barcode}")
#     Wait Until Keyword Succeeds    3times    3s    Input Reconcile Line    5
#     Get Reconcile History id
#     Complete Reconcile
#     Open Reconcile History By Id    ${reconcile_history_id}
#     Verify User Can't Edit This Field

Verify Can only Input Positive Intergers And Zero
    [Tags]    [reconcile]_75
    [Setup]    Go Inventory And Cancel Reconcile
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Select Type Reconcile    type=full
    execute JavaScript    handleScan("${barcode}")
    Verify Actual Qty On Hand Can only Input Positive Intergers And Zero
    [Teardown]    Cancel Reconcile

Verify The Inventory Reconcile Adjustment Screen
    [Tags]    [reconcile]_121    [reconcile]_122
    [Setup]    Go Inventory And Cancel Reconcile
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Select Type Reconcile    type=full
    execute JavaScript    handleScan("${barcode}")
    Wait Until Page Contains Element    id=ReconcileLine_1    30s
    Click Element    link:Add Item
    Verify Inventory Reconcile Adjustment Popup Display
    [Teardown]    Cancel Reconcile

Verify Open View All Item
    [Tags]    [reconcile]_124
    [Setup]    Go Inventory And Cancel Reconcile
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Select Type Reconcile    type=full
    execute JavaScript    handleScan("${barcode}")
    Wait Until Keyword Succeeds    3times    3s    View All Item
    Click Element    //*[@id="SaveBtn" and @type="submit"]
    [Teardown]    Cancel Reconcile

Verify The Inventory Reconcile Review
    [Tags]    [reconcile]_128
    [Setup]    Go Inventory And Cancel Reconcile
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Select Type Reconcile    type=full
    execute JavaScript    handleScan("${barcode}")
    ${actual_qty_on_hand_expect}    evaluate    random.choice(range(1, 10))
    Wait Until Keyword Succeeds    3times    3s    Input Reconcile Line    ${actual_qty_on_hand_expect}
    ${preview_reconcile_onclick}    SeleniumLibrary.Get Element Attribute    //*[@onclick="InventoryReconcilePreview()"]    onclick
    Execute Javascript    ${preview_reconcile_onclick}
    Switch Window    title=Report Viewer
    Wait Until Page Contains    Inventory Reconcile Preview
    Switch Window    title=Inventory Reconcile Ledger
    [Teardown]    Cancel Reconcile

Verify The Inventory Reconcile Adjustment Qty On Hand
    [Tags]    [reconcile]_123
    [Setup]    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Select Type Reconcile    type=full
    execute JavaScript    handleScan("${barcode}")
    ${actual_qty_on_hand_expect}    evaluate    random.choice(range(1, 10))
    Wait Until Keyword Succeeds    3times    3s    Input Reconcile Line    ${actual_qty_on_hand_expect}
    Add Item
    Verify Inventory Reconcile Adjustment Qty On Hand    ${actual_qty_on_hand_expect}
    [Teardown]    Cancel Reconcile

Verify Open And Add Product And Search Item in Manually Add Product Inventory Reconcile Items Popup
    [Tags]    [reconcile]_125    [reconcile]_126
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Wait Until Keyword Succeeds    3 times    1    Open Manually Add Products
    Wait Until Page Contains Element    ${SearchAssignProductInput}
    Input Text    ${SearchAssignProductInput}    00310-1730-30
    SeleniumLibrary.Click Button    ${SearchAssignProductBtn}
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]
    ${lot}    SeleniumLibrary.Get Element Attribute    //*[@id="item_LotNumber"]/option[2]    value
    Select From List By Value    //*[@id="item_LotNumber"]    ${lot}
    Input Text    ${AddingQtyInput}    1
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}

Verify Open And Add Product And Search Item in Manually Add Product Inventory Reconcile Items Popup In Facility Reservoir
    [Tags]    [reconcile]_127
    [Setup]    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=Specialty Pharmacy
    Input Text    id=ReconcilePatientSearch    Automaion, QC (01/01/2000) MRN: 04040 - (QCA1)
    Execute Javascript    document.activeElement.blur()
    Wait Until Keyword Succeeds    3 times    1    Open Manually Add Products
    Wait Until Page Contains Element    ${SearchAssignProductInput}
    Input Text    ${SearchAssignProductInput}    00310-1730-30
    SeleniumLibrary.Click Button    ${SearchAssignProductBtn}
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]
    ${lot}    SeleniumLibrary.Get Element Attribute    //*[@id="item_LotNumber"]/option[2]    value
    Select From List By Value    //*[@id="item_LotNumber"]    ${lot}
    Input Text    ${AddingQtyInput}    1
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}
    [Teardown]    Cancel Reconcile

Verify Selected Option Reconcile When Completing The Reconciliation
    [Tags]    [reconcile]_131
    [Setup]    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    ${barcode}     Evaluate   random.sample(${ListBarcode},1)
    Reconcile Item add And Scan ${barcode} Then Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is   add
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Reconcile Item empty And Scan ${barcode} Then Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    full
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Reconcile Item change And Scan ${barcode} Then Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    change
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Reconcile Item full And Scan ${barcode} Then Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Type Reconcile Is    full

Verify Cancel Reconcile
    [Tags]    [reconcile]_133
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Cancel Reconcile
    [Setup]    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    ${barcode}     Evaluate    random.sample(${ListBarcode},1)
    Reconcile Item full And Scan ${barcode} Then Cancel
    Verify Reconcile Cancel    ${reconcile_history_id}    # robotcode: ignore

Verify Complete Log As ${Userrole}
    [Documentation]    [reconcile]_130    [reconcile]_134
    [Tags]    inventory    Accounting    [reconcile]_130
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Complete Log
    [Setup]    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    ${barcode}     Evaluate   random.sample(${ListBarcode},20)
    Reconcile Item full And Scan ${barcode} Then Complete
    Verify Reconcile Successfully     ${reconcile_history_id}    # robotcode: ignore
    Verify Complete Log Successfully    ${reconcile_history_id}    # robotcode: ignore

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}

Setup Test Case
    Reset And Fill Empty Reconcile    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Wait Until Keyword Succeeds    3times    3s    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    
Suite Teardown
    Close Browser Session

Verify Text "Begin Scanning your barcode stickers on serialized items to process them into inventory."
    Wait Until Page Contains    Begin Scanning your barcode stickers on serialized items to process them into inventory. 

Verify Actual Qty On Hand Can only Input Positive Intergers And Zero
    Wait Until Page Contains Element    id=ReconcileLine_1    30s
    input Text    id=ReconcileLine_1    -2
    Execute JavaScript    document.activeElement.blur()
    Wait Until Page Contains    Please input a positive number

Verify User Can't Edit This Field
    Wait Until Page Does Not Contain Element    id=ReconcileLine_1    timeout=10s

Verify Last Qty On Hand Column
    [Arguments]    ${expected_qty}
    Wait Until Page Contains Element    ${reconcile_table_xpath}    timeout=10s
    ${reconcile_table}    SeleniumLibrary.Get Element Attribute    ${reconcile_table_xpath}    outerHTML
    ${items}    Get All Data From Html Table Before Reconciled    ${reconcile_table}    [1]
    Should Be Equal As Numbers    ${items}[0][Last Qty On Hand]    ${expected_qty}

Create Order And Receive Now
    Config Receive Now
    Manually Add Products Receive Now
    Complete Order And Receive Now

Config Receive Now
    ReceiveNow.Create And Receive New Order
    ReceiveNow.Select Receiving Account    receiving_account=${data_input}[checked_location]
    ReceiveNow.Select Receiving Inventory    receiving_facility=${data_input}[receiving_facility]
    ReceiveNow.Select Order Vendor    order_vendor=${data_input}[order_vendor]
    ReceiveNow.Input PO Number

Manually Add Products Receive Now
    [Arguments]    ${ndc}=${data_input}[ndc]    ${lot}=${data_input}[lot]    ${order_qty}=1
    ReceiveNow.Click Reset Assigned Products
    ReceiveNow.Click Manual Add Products
    ReceiveNow.Search for your Item    ${ndc}
    ReceiveNow.Selec Lot Number    ${lot}
    ReceiveNow.Input Qty By Item    ${order_qty}
    ReceiveNow.Click Assign Item

Complete Order And Receive Now
    ReceiveNow.Click Complete Receive Now

Verify ${action} In Inventory Transaction
    ${type_transaction}    Get Text    //*[contains(@class,"active") and contains(@id,"InventoryTransactionTab")]/div[2]//div[1]
    IF    '${action}' == 'Receive'
        Should Be Equal As Strings    ${type_transaction}    PO Receipt
    ELSE IF    '${action}' == 'Dispense'
        Should Be Equal As Strings    ${type_transaction}    Dispense
    ELSE IF    '${action}' == 'Other Changes'
        Should Be Equal As Strings    ${type_transaction}    Inventory Transfer
    END

Dispense Now
    Dispense.Go Dispensing
    Dispense.Filter By Location    ${data_input}[checked_location]
    Dispense.Go Dispense Now Screen
    Add Primary Medication
    Approve Container Sizes
    Dispense.Scan 1 ${BARCODES_TRANSFER}
    Complete Dispense Now
    
Complete Dispense Now
    Select From List By Label    id=Facility    ${data_input}[full_name_facility]
    Dispense.Click Complete Dispense Button
    Wait Until Keyword Succeeds    3times    3s    Handle Alert
    Dispense.Click Close Dispense Now Modal
    
Add Primary Medication
    Set Selenium Speed    0.1s
    Dispense.Add Medication
    Dispense.Select Therapy Medication    medication=Fasenra
    Dispense.Input Dose    dose=30
    Click Button    Submit
    Wait Until Page Contains    Appointment Item Successfully Created!

Open Inventory Transaction
    InventoryLevels.Go To Inventory Levels
    InventoryFilter.Select Location    ${data_input}[checked_location]
    InventoryFilter.Select Facility In Inventory    ${data_input}[checked_facility]
    InventoryFilter.Search For Item #,NDC    ${data_input}[ndc]
    InventoryLevels.Select Show Empty Inventory
    Wait Until Keyword Succeeds    3times    3s    InventoryLevels.Show Transaction UoM "Syringe"


Close Modal Popup
    Wait Until Page Contains Element    //*[@id="ModalPopup" and contains(@class,'in')]//button[@id='CloseBtn']
    Click Element    //*[@id="ModalPopup" and contains(@class,'in')]//button[@id='CloseBtn']
    Wait Until Page Does Not Contain Element    //*[@id="ModalPopup" and contains(@class,'in')]//button[@id='CloseBtn']

Create Transfer
    [Arguments]    ${checked_location}=${data_input}[checked_location]    ${from_facility}=${data_input}[receiving_facility]    ${to_facility}=${data_input}[to_facility]    ${other_changes_qty}=1    ${ndc}=${data_input}[ndc]
    InventoryTransfer.Go To Inventory Transfer
    InventoryTransfer.New Inventory Transfer
    NewInventoryTransfer.Select The Account To Transfer From    ${checked_location}
    NewInventoryTransfer.From Inventory    ${from_facility}
    NewInventoryTransfer.Select The Account To Transfer To     ${checked_location}
    NewInventoryTransfer.To Inventory    ${to_facility}
	NewInventoryTransfer.Scan Transfer ${other_changes_qty} ${ndc}
	NewInventoryTransfer.Submit Transfer

Go Inventory And Cancel Reconcile
    ${barcode}     Evaluate   random.sample(${ListBarcode},1)
    Go To Inventory Reconcile And Select Location And Facility    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    OpenActiveReconcile.Reconcile Item full And Scan ${barcode} Then Cancel
    
Input Reconcile Line
    [Arguments]    ${actual_qty_on_hand_expect}
    Wait Until Page Contains Element    //*[@id="ReconcileLine_1"]    30s
    Input Text    id=ReconcileLine_1    ${actual_qty_on_hand_expect}
    Execute JavaScript    document.activeElement.blur()
    Wait Until Page Contains    Reconcile item updated!
    Wait Until Page Does Not Contain    Reconcile item updated!

Verify Inventory Reconcile Adjustment Popup Display
    Wait Until Page Contains Element    //*[@id="ModalPopup" and contains(@class,'in')]//*[text()='Inventory Reconcile Adjustment']    timeout=10s
    Wait Until Keyword Succeeds    3times    3s    Close Modal Popup

Verify Inventory Reconcile Adjustment Qty On Hand
    [Arguments]    ${actual_qty_on_hand_expect}
    ${qty_on_hand_reconcile_adjustment}    SeleniumLibrary.Get Element Attribute    id=Lots_0__Quantity    value
    Wait Until Keyword Succeeds    3times    3s    Close Modal Popup
    Should Be Equal As Numbers    ${qty_on_hand_reconcile_adjustment}    ${actual_qty_on_hand_expect}

Verify Item Counts Row
    [Arguments]    ${item_count}
    ${item_count_ui}    Get Text    //*[contains(@class,'active')]//*[@id="ReconcileInventoryList"]/div[4]/table/tbody/tr[1]/td[3]
    Should Be Equal As Numbers    ${item_count_ui}    ${item_count}

Verify Type Reconcile Is
    [Arguments]    ${type}
    Util.Scroll To Top
    ${reconcile_type}    Set Variable    //*[@data-type='${type}']
    ${actual}=    SeleniumLibrary.Get Element Attribute    ${ReconcileType}    checked
    Should Be Equal    ${actual}    true

Verify Reconcile Successfully
    [Arguments]    ${reconcile_history_id}
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    Util.Scroll To Top
    Wait Until Element Is Visible    ${status_reconcile}    timeout=10s
    ${status_reconcile}=    SeleniumLibrary.Get Text    ${status_reconcile}
    Should Be Equal    ${status_reconcile}    Complete

Verify Reconcile Cancel
    [Arguments]    ${reconcile_history_id}
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    Wait Until Page Contains   text=This Inventory Reconcile has been Canceled.    timeout=20s
    Util.Scroll To Top
    ${status_reconcile}=    SeleniumLibrary.Get Text    ${StatusReconcile}
    Should Be Equal    ${status_reconcile}    Canceled

Verify Complete Log SuccessFully
    [Arguments]    ${reconcile_history_id}
    Wait Until Element Is Visible    ${ReconcileTableXpath}
    ${html_table_reconcile}=    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${table_reconile}=   get_data_from_html_table_reconciled    ${html_table_reconcile}
    OpenActiveReconcile.Complete Log    ${reconcile_history_id}
    ${export_path}=    Download Report CSV SuccessFully    ManualInventoryCheck.csv
    ${completion_log}=    Convert File Csv Complete Log    ${export_path}
    Should Be Equal     ${table_reconile}    ${completion_log}