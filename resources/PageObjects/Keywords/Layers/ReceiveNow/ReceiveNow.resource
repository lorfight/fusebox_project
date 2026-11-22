*** Settings ***
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${po_number_input}    //*[@id='PoNumber']

*** Keywords ***
Create And Receive New Order
    Wait Until Element Is Enabled    ${ReceivingLink}
    Click Element    ${ReceivingLink}
    Click Element    link:Create & Receive New Order
    Wait Until Page Contains Element    //*[@id="UniversalModalPopup" and @aria-hidden='false']//*[text()='Create & Receive New Purchase Order']    timeout=20s

Complete Receive Now
    Wait Until Element Is Enabled    link: Complete Receive
    Set Focus To Element    link: Complete Receive
    Sleep    1s
    Click Element    link: Complete Receive
    Handle Alert
    Wait Until Page Does Not Contain Element    //*[contains(@class,"modal fade in")]//*[contains(text(),"Create & Receive New Purchase Order")]    timeout=60s

Select Receiving Account
    [Arguments]    ${receiving_account}
    Wait Until Page Contains Element    id=SelectedReceivingModalAccountID    timeout=30s
    Select From List By Label    id=SelectedReceivingModalAccountID    ${receiving_account}
    Waiting For Loading
    # Wait Until Page Contains Element    //*[@id="frm_CreateAndReceiveNewPOModal"]//button[@title="QCA1"]    timeout=20s

Select Receiving Inventory
    [Arguments]    ${receiving_facility}
    Wait Until Page Contains Element    //option[text()='${receiving_facility}']
    Wait Until Page Contains Element    id=SelectedReceivingModalFacilityID    timeout=10s
    Select From List By Label    id=SelectedReceivingModalFacilityID    ${receiving_facility}

Select Order Vendor
    [Arguments]    ${order_vendor}
    Wait Until Page Contains Element    id=SelectedReceivingModalVendorID    timeout=10s
    Select From List By Label    id=SelectedReceivingModalVendorID    ${order_vendor}
    # Wait Until Keyword Succeeds    30s    5    Util.Verify Loading And Select By Label    locator=SelectedReceivingModalVendorID    selected_label=Nan Tech

Input PO Number
    [Arguments]    ${po_number}=Auto-Test
    Wait Until Page Contains Element    ${po_number_input}
    Sleep    2s
    Input Text    ${po_number_input}    ${po_number}
    Execute Javascript    document.activeElement.blur()
    Waiting For Loading

Config Order By Scan
    [Arguments]    ${barcode_item}
    ${is_reset_assigned}    Run Keyword And Return Status    Wait Until Element Is Not Visible    //*[contains(text(), 'Begin scanning')]    timeout=15s
    Run Keyword If    ${is_reset_assigned}    Click Element    //*[contains(text(), 'Reset Assigned Products')]
    Wait Until Element Is Visible    //*[contains(text(), 'Begin scanning')]    timeout=15s
    Util.Handle Scan Barcode Reconcile   barcode=${barcode_item}
    Wait Until Element Is Not Visible    //*[contains(text(), 'Begin scanning')]    timeout=15s

Input Quantity
    [Arguments]    ${order_qty}=1
    Wait Until Element Is Enabled    //*[contains(@class, 'AssignedProductQty')]
    Input Text    //*[contains(@class, 'AssignedProductQty')]    ${order_qty}
    
Click Manual Add Products
    Wait Until Page Contains Element    //*[contains(@onclick,"QuickOrderReceiveManuallyAddProduct();")]    timeout=10s
    ${quick_order_receive}    SeleniumLibrary.Get Element Attribute    //*[contains(@onclick,"QuickOrderReceiveManuallyAddProduct();")]    onclick
    Execute Javascript    ${quick_order_receive}
    Waiting For Loading

Click Complete Receive Now
    Wait Until Page Contains Element    //*[contains(@onclick,"SubmitQuickOrderReceiving();")]    timeout=10s
    ${complete_receive}    SeleniumLibrary.Get Element Attribute    //*[contains(@onclick,"SubmitQuickOrderReceiving();")]    onclick
    Execute Javascript    ${complete_receive}
    Wait Until Keyword Succeeds    5 times    1    Handle Alert And Return Its Text
    Wait Until Page Does Not Contain Element    //*[contains(@class,"modal fade in")]//*[contains(text(),"Create & Receive New Purchase Order")]    timeout=60s

Click Reset Assigned Products
    Wait Until Page Contains Element    //*[contains(@onclick,"ResetQuickOrderReceiveItems();")]    timeout=10s
    ${reset_assigned}    SeleniumLibrary.Get Element Attribute    //*[contains(@onclick,"ResetQuickOrderReceiveItems();")]    onclick
    Execute Javascript    ${reset_assigned}
    Waiting For Loading
    # Wait Until Page Contains Element    //*[contains(text(),"Begin scanning your products to populate them below.")]    timeout=10s

Search for your Item
    [Arguments]    ${search_item}
    Wait Until Page Contains    Search for your Item    timeout=10s
    Input Text    //input[@id="QuickOrderReceiveAssignSearchValues"]    ${search_item}
    Click Button    id=QuickOrderReceiveAssignFindButton
    Waiting For Loading


Verify Scan Order Success
    Wait Until Page Does Not Contain   Begin scanning    10s

Selec Lot Number
    [Arguments]    ${lot_number}
    Wait Until Page Contains Element    //*[contains(@id, 'item_LotNumber')]    timeout=10s
    Select From List By Label    //select[@id="item_LotNumber"]    ${lot_number}

Input Qty By Item
    [Arguments]    ${qty}=1
    Wait Until Page Contains Element    //input[@id="AddingQty"]    timeout=10s
    Input Text    //input[@id="AddingQty"]    ${qty}
    Execute Javascript    document.activeElement.blur()
    
Click Assign Item
    ${assign_item}    SeleniumLibrary.Get Element Attribute    //*[contains(@onclick,"ManuallyAssignToQuickOrder")]    onclick
    Execute Javascript    ${assign_item}
    Wait Until Page Contains    Successfully Added to Quick Order Receiving!    timeout=10s
    Wait Until Page Does Not Contain    Successfully Added to Quick Order Receiving!    timeout=10s
