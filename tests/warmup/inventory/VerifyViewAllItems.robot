*** Settings ***
Documentation      Inventory Reconcile Screen
Library    String
Library    DependencyLibrary

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/Order.resource
Resource   ../../../resources/PageObjects/Keywords/OpenOrder.resource
Resource   ../../../resources/PageObjects/Keywords/ContractsAndPricingSetKewords.resource
Resource   ../../../resources/PageObjects/Keywords/EditContract.resource
Resource   ../../../resources/PageObjects/Keywords/OrderAndReceiveNow.resource


Suite Setup    SetUp Suite
# Test Setup    SetUp Test Case
Suite Teardown    Close Browser
Test Tags    Admin    Warmup    test:retry(2)    inventory    IV_104

*** Variables ***
${data_input}

*** Test Cases ***
Verify View All Items
    [Documentation]   Adjustment item at view all item inventory reconcile
    [Tags]    [Reconcile_]_23    [Reconcile_]_24    [Reconcile_]_25    [Reconcile_]_26    [Reconcile_]_27    [Reconcile_]_28
    Login To Fusebox    user_name=${Username}    password=${Password}
    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Create Order And Receive Now    price=0
    Get Best Price Contract    ndc=${data_input}[ndc]    uom=${data_input}[uom]
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify View All Item
    [Teardown]    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]



*** Keywords ***
Verify View All Item
    Run Keyword And Continue On Failure    Verify Expected Quantity
    Run Keyword And Continue On Failure    Verify price in contract
    Run Keyword And Warn On Failure    Verify Lot Number
    Run Keyword And Continue On Failure    Verify User Action
    Run Keyword And Continue On Failure    Verify List Value Of Price
    Run Keyword And Continue On Failure    Verify Item Link To Contract Price

Verify Expected Quantity
    [Tags]    [Reconcile_]_28
    Waiting For Loading
    ${expected_qty_inventory_reconcile_ui}    Get Text    //*[@id="ReconciledItemsTable"]/div/table/tbody/tr[2]/td[9]
    Should Be Equal As Numbers    ${expected_qty_inventory_reconcile_ui}    ${qty_on_hand_inventory_level_ui}

Verify Lot Number
    [Tags]    [Reconcile_]_23
    ${lot_actual}    Get Text    //*[@id="SubModalPopup"]/div[2]/div/div[2]/div[2]/div[2]/h4
    ${barcode}    parse_barcode    ${data_input}[barcode_item]
    ${lot_expected}    Set Variable    ${barcode}[lot]
    Should Contain    ${lot_actual}     ${lot_expected}

Verify User Action
    [Tags]    [Reconcile_]_24
    Page Should Contain Element    //select[@id="ContractPriceList"]
    Log To Console    Lot Number
    
Verify List Value Of Price
    [Tags]    [Reconcile_]_25
    ${item_contract_prices_droplist}    Get List Items    //select[@id="ContractPriceList"]
    ${contract_prices}=    Create List
    FOR    ${element}    IN    @{item_contract_prices_droplist}[1:]
        ${contract_price}    Convert Amount/Unit To Number    ${element}
        Append To List    ${contract_prices}      ${contract_price}
    END
    Lists Should Be Equal     ${contract_prices}    ${prices}
    
Verify price in contract
    [Tags]    [Reconcile_]_26
    Input Text    ReconcileLine_1    0
    Execute Javascript    document.activeElement.blur()
    Wait Until Page Contains    Reconcile item updated!    timeout=10s
    Open View All Item
    ${quantity}    get value     //*[@class='ReconcileItemPricesAndQuantities']//input[contains(@class,'ReconcileItemQuantityTextBox')]
    Should Be Equal As Strings    ${quantity}    0

Verify Item Link To Contract Price
    [Tags]    [Reconcile_]_27
    Select From List By Value    ContractPriceList    ${best_price}0
    Input Text    //*[contains(@class,"AdditionalReconcileTableRow")]//input    2
    execute javascript    AddNewPriceQuantityReconcileItem()
    Click Button    //*[contains(text(),"Inventory Reconcile Items")]//ancestor::div[@class="modal-content"]//button[@id="SaveBtn"]
    Wait Until Page Contains Element     //*[contains(text(),"Inventory Reconcile Items")]//ancestor::div[@class="modal-content"]//button[@id="SaveBtn"]    timeout=10s
    Wait Until Page Contains Element    //*[@id="ReconcileLine_1"]    30s
    Waiting For Loading
    ${actual_qty_on_hand}    get value    id=ReconcileLine_1
    Should Be Equal As Strings    ${actual_qty_on_hand}    2

Verify Price Exist Item In Reconcile
    [Arguments]    ${ndc}    ${orders_data}    ${total_order_qty}    ${adjust_actual_qty}
    Adjust Actual Qty In View All Item    adjust_actual_qty=${adjust_actual_qty}
    Open View All Item
    ${remain_qty}    Set Variable    ${${adjust_actual_qty}}
    FOR    ${element}    IN    @{orders_data}
        ${price}    Get From Dictionary    dictionary=${element}    key=price
        ${price}    Convert Amount/Unit To Number    ${price}    $    
        ${qty}    Get From Dictionary    dictionary=${element}    key=qty
        ${actual_qty}    Get Value    locator=//table[contains(@id,"DuplicateReconcileItemTable")]/tbody//tr[contains(@data-originalprice,"${price}")]/td[3]/input
        ${remain_qty}    Evaluate    ${remain_qty}-${qty}
        IF    $remain_qty >= ${0}
            Should Be Equal    ${${qty}}    ${${actual_qty}}
        ELSE
            Should Be Equal    ${${actual_qty}}    ${${${qty}}+${${remain_qty}}}
        END
    END
    IF    ${remain_qty} > ${0}
        ${best_contract_qty}    Get Value    //*[@class="ReconcileItemPricesAndQuantities" and contains(@data-originalprice,"${best_price}")]/td[3]/input
        Should Be Equal    ${${best_contract_qty}}    ${remain_qty}
    END
    Wait Until Keyword Succeeds    3 times    2s    Close View All Items

Adjust Actual Qty In View All Item
    [Arguments]    ${adjust_actual_qty}
    Wait Until Element Is Enabled    //*[contains(text(),"View All Items")]//preceding-sibling::input
    input text    //*[contains(text(),"View All Items")]//preceding-sibling::input    ${${adjust_actual_qty}}
    Click Element    //*[contains(text(),"Inventory Reconciliation")]
    Wait Until Page Contains    Reconcile item updated!    timeout=10s
    Wait Until Page Does Not Contain    Reconcile item updated!    timeout=10s

Add Item By Scanning
    [Arguments]    ${barcode}
    Execute Async Javascript    var callback = arguments[arguments.length - 1];handleScan("${barcode}");setTimeout(()=>{callback()},6000);
#    util.Handle Scan List Barcode    ${list_barcode}
Open View All Item
    CLick Element    link:View All Items
    Wait Until Element Is Visible    //table[contains(@id,"DuplicateReconcileItemTable")]
Create Order And Receive Now
    [Arguments]    ${price}    ${contract_id}=No related contract    ${order_qty}=1
    OrderAndReceiveNow.Create And Receive New Order
    OrderAndReceiveNow.Select Receiving Account    receiving_account=${data_input}[checked_location]
    OrderAndReceiveNow.Select Receiving Inventory    receiving_facility=${data_input}[receiving_facility]
    OrderAndReceiveNow.Select Order Vendor    order_vendor=${data_input}[order_vendor]
    Click Element    link:Reset Assigned Products
    Wait Until Keyword Succeeds    10 times    1    Input PO Number And Scan
    OrderAndReceiveNow.Input Quantity    ${order_qty}
    IF    '${contract_id}' == 'No related contract'
        Order And Receive No Related Contract    ${price}
    END
    OrderAndReceiveNow.Complete Receive Now

Order And Receive No Related Contract
    [Arguments]    ${price}
    Wait Until Page Contains    Receiving Products & Pricing
    Select From List By Label    billingItem_ContractSelected    No related contract
    Click element    //*[@id="ScanReceivingModalArea"]/table[1]/tbody/tr[2]/td[4]/div[1]/a
    Execute JavaScript  document.activeElement.blur()
    Waiting For Loading
    Sleep    1s
    Click Element    //*[contains(text(),'Order Total Cost')]
    Execute Javascript    document.evaluate("//*[contains(@class,'AssignedProductPrice')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value="${price}"
    Click Element    //*[@id="ScanReceivingModalArea"]/table[1]/tbody/tr[2]/td[4]/div[3]/a
    Execute JavaScript  document.activeElement.blur()
    Waiting For Loading
    Sleep    1s


    
    
Input PO Number And Scan
    OrderAndReceiveNow.Input PO Number
    OrderAndReceiveNow.Config Order By Scan    ${data_input}[barcode_item]
    Wait Until Page Does Not Contain    You must assign an PO Number to continue.    timeout=10s
    Verify Scan Order Success

Reset And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    Open Active Reconcile
    Select Type Reconcile    full

SetUp Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Selenium Speed    0.2s

Setup Test Case
    Login To Fusebox    user_name=${Username}    password=${Password}
    Get Best Price Contract    ndc=${data_input}[ndc]    uom=${data_input}[uom]
    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${total_order_qty}    Set Variable    0
    FOR    ${element}    IN    @{orders_data}
        ${price}    Get From Dictionary    dictionary=${element}    key=price
        ${qty}    Get From Dictionary    dictionary=${element}    key=qty
        ${total_order_qty}    Evaluate    ${total_order_qty}+${qty}
	    Set Test Variable    ${order_qty}    ${qty}
        Create Order And Receive Now    price=${price}    order_qty=${order_qty}
    END
    Set Test Variable    ${total_order_qty}
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ReconcileDetail.Search NDC In Reconcile Table    ${data_input}[ndc]
    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s

Get Best Price Contract
    [Arguments]    ${ndc}=${/}    ${uom}=Syringe
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location     ${data_input}[checked_location]
    InventoryLevel.Select Inventory    ${data_input}[checked_facility]
    InventoryLevel.Find Inventory With NDCItem    ${ndc}
    InventoryLevel.Select Show Empty Inventory
    ${qty_on_hand_inventory_level_ui}    Wait Until Keyword Succeeds    3times    3s    Get Qty On Hand Inventory Level    uom=${uom}
    Set Test Variable    ${qty_on_hand_inventory_level_ui}
    InventoryLevel.Show Adjustment Inventory On Hand "${data_input}[uom]"
    Wait Until Keyword Succeeds    5s    1s    Find Lowest Price
    Click Button    ${inventory_adjustment_close_btn}

Get Qty On Hand Inventory Level
    [Arguments]    ${uom}
    Wait Until Page Contains Element    (//*[contains(@class,"tab-pane") and contains(@class,"active")]//*[text()="${uom}"]//following::div)[2]//a    timeout=15s
    ${qty_on_hand_inventory_level_ui}    Get Text    (//*[contains(@class,"tab-pane") and contains(@class,"active")]//*[text()="${uom}"]//following::div)[2]//a
    RETURN    ${qty_on_hand_inventory_level_ui}

Find Lowest Price
    Wait Until Page Contains Element    //*[@class="modal-content"]//*[contains(text(),"Inventory Adjustment")]    timeout=20s
    ${price_list}    Get List Items    //*[@id="Price"]
    # Step 1: Filter out non-price items (like '-- Select Contract Price --')
    ${filtered_list}=    Evaluate    [item for item in ${price_list} if item != '-- Select Contract Price --']
    # Step 2: Extract price values as floats
    @{prices}=    Create List
    FOR    ${item}    IN    @{filtered_list}
        ${price}=    Evaluate    float(${item.split(' ')}[0])
        Append To List    ${prices}    ${price}
    END
    # Step 3: Find the lowest price
    Set Suite Variable    ${prices}
    ${best_price}=    Evaluate    min(${prices})
    Set Suite Variable    ${best_price}

Convert Amount/Unit To Number
    [Arguments]    ${unit}    ${string_remove}=" "
    ${has_comma}    Run Keyword And Return Status    Should Contain    ${unit}    ,
    IF    ${has_comma}==${True}
        ${unit}    Replace String    ${unit}    ,    ${EMPTY}
    END
    ${unit}    Convert To Number    ${unit}
    RETURN    ${unit}

Close View All Items
    Click Element    (//*[@id="CloseBtn"])[3]
    Wait Until Page Contains    Inventory Reconcile Items    timeout=10s

    