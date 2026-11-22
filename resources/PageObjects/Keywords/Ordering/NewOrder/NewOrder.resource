*** Settings ***
Resource    ../Common/OrderUtils.resource

*** Variables ***
${ReceivingAccount_select}    //*[@id='SelectedReceivingModalAccountID']
${ReceivingInventory_select}    //*[@id='SelectedReceivingModalFacilityID']
${OrderVendor_select}    //*[@id='SelectedReceivingModalVendorID']
${CompleteReceive_button}    //*[contains(text(),'Complete Receive')]
${PoNumber_input}    //*[@id='PoNumber']
${AddQty_button}    //div[contains(@id,'allTab')]//*[contains(@class,'AddQty')]
${SearchOrder_input}    //div[contains(@id,'ProductSelectorAll')]//*[@id='OrderQty']
${PoNumber_modal}    //*[@id='modalDialogLabel']
${PoNumberModal_input}    //*[@id='modalDialogText']
*** Keywords ***
Go Order
    Click Element    link:Ordering
    Click Element   link:New Order
    Title Should Be    Build Order
    Waiting For Loading
Config Order
    [Arguments]    ${location}    ${ndc}    ${vendor}    ${order_qty}
    Select Customer Account    ${location}
    Find NDC    ${ndc}
    Filter By Vendor    ${Vendor}
    Wait Until Keyword Succeeds    2 times    1    Add Quality     ${order_qty}

Select Customer Account
    [Arguments]    ${customer_account}
    Wait Until Element Is Enabled    id=CustomerId
    # Util.Verify Loading And Select By Label    CustomerId    ${customer_account}
    Select From List By Label    //select[@id="CustomerId"]    ${customer_account}
    Waiting For Loading

Filter By Manufacturer
    [Arguments]    ${manufacturer}
    Wait Until Element Is Enabled    id=ManufacturerAccountId    timeout=10s    error=Select Manufacturer Is Not Enabled
    Select From List By Label    id=ManufacturerAccountId    ${manufacturer}
    Waiting For Loading    error=Loading manufacturer takes too long

Filter By Vendor
    [Arguments]    ${vendor}
    Set Test Variable    ${vendor}
    Wait Until Element Is Enabled    id=VendorAccountId    timeout=10s    error=Select Vendor Is Not Enabled
    Util.Verify Loading And Select By Label    VendorAccountId    ${vendor}

Find NDC
    [Arguments]    ${ndc}
    Wait Until Element Is Enabled    id=SearchValues
    Input Text    id=SearchValues    ${ndc}
    Click Button    Find
    Waiting For Loading    error=Finding NDC takes too long

Select Contract Search Tab
    [Arguments]    ${contract}=Nan Tech - Contract:[230920-045100] - Contract:$10.00 - Net:$2.80
    Wait Until Page Contains Element    id=item_DefaultContractAndVendor
    Select From List By Label    id=item_DefaultContractAndVendor    ${contract}
    Waiting For Loading

Select UOM Search Tab
    [Arguments]    ${uom}=Vial - Contract:$300.00 - Net:$285.00 - (30 Milligram)
    Waiting For Loading
    Wait Until Page Contains Element    id=item_DefaultUomId
    Wait until keyword succeeds    3times    3s    Select From List By Label    id=item_DefaultUomId    ${uom}
    Waiting For Loading

Add Quality
    [Arguments]    ${order_qty}=1
    Util.Scroll To Bottom
    Input Text    ${SearchOrder_input}    ${order_qty}
    ${add_qty_js}    SeleniumLibrary.Get Element Attribute    ${AddQty_button}    onclick
    execute Javascript    ${add_qty_js}
    Waiting For Loading    error=Adding quantity takes too long

Add Quality Search Tab
    [Arguments]    ${order_qty}=1
    Util.Scroll To Bottom
    Input Text    ${SearchOrder_input}    ${order_qty}
    ${add_qty_js}    SeleniumLibrary.Get Element Attribute    ${AddQty_button}    onclick
    execute Javascript    ${add_qty_js}
    Waiting For Loading    error=Adding quantity takes too long

Ship To Alternate Address
    [Arguments]    ${alternate_address}
    Wait Until Element Is Enabled    id=AltShipToAddressId
    Select From List By Label    id=AltShipToAddressId    ${alternate_address}
    Waiting For Loading

Config My Cart
    Wait Until Element Is Enabled    link:Order Note    timeout=15s    error=Loading page takes too long
    ${date_time}=    Get Current Date Time
    ${po_number}=    Set Variable    AT-${date_time}
    Set Test Variable    ${po_number}
    Config PO Number ${po_number}
    RETURN    ${po_number}

Config PO Number ${po_number}
    Wait Until Element Is Enabled    id=SetDistibutorPONumberButton
    ${set_distributor_po_number_js}    SeleniumLibrary.Get Element Attribute    id=SetDistibutorPONumberButton    onclick
    execute Javascript    ${set_distributor_po_number_js}
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[@id="modalDialogText"]    timeout=15s    error=Loading page takes too long
    Util.Input Text When Enabled    locator=//*[@aria-hidden="false"]//*[@id="modalDialogText"]    text=${po_number}
    Wait Until Keyword Succeeds    3times    3s    Save Po Number
    Waiting For Loading

Save Po Number
    Click Button    Save
    Wait Until Page Does Not Contain Element    //*[@aria-hidden="false"]//*[@id="modalDialogText"]    15s
Get Current Date Time
    ${date}=    Get Time Now   result_format=%m%d%H%M
    RETURN    ${date}

Cancel Build Order
    Wait Until Element Is Enabled    link: Cancel Build
    Wait Until Keyword Succeeds    15s    3s    Click Element    link: Cancel Build

Submit Requisition
    Click Element    link: Submit Requisition
    Handle Alert
    Wait Until Page Does Not Contain    Submitting Order    120s
    Waiting For Loading
    Wait Until Keyword Succeeds    2times    30s    Title Should Be    Order Requisitions

Submit Order
    Click Element    link: Submit Order
    Handle Alert
    Wait Until Page Does Not Contain    Submitting Order    120s
    Waiting For Loading
    # Wait Until Page Contains Element    //*[@id="processing-indicator"]    timeout=60s
    # Wait Until Page Does Not Contain Element    //*[@id="processing-indicator"]    timeout=60s

Complete Later
    Click Element    link: Complete Later
    Waiting For Loading

Delete Draft
    Click Element    link: Delete Draft
    Handle Alert
    Waiting For Loading
    Title Should Be    Pending Orders

Get PO Number In Order
    Wait Until Element Is Visible    id=SetDistibutorPONumberButton    30s
    ${po_num_order}    Get Text    id=SetDistibutorPONumberButton
    RETURN    ${po_num_order} 