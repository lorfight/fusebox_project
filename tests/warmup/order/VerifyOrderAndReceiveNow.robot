*** Settings ***
Documentation    Verify the "Order and Receive Now" functionality with and without applying the contract price discount.
Library    String

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/Order.resource
Resource    ../../../resources/PageObjects/Keywords/OpenOrder.resource
Resource    ../../../resources/PageObjects/Keywords/ContractsAndPricingSetKewords.resource
Resource    ../../../resources/PageObjects/Keywords/EditContract.resource
Resource    ../../../resources/PageObjects/Keywords/OrderAndReceiveNow.resource

Test Setup    Setup Test Case
Test Teardown    Close Browser
Suite Setup    Set Up Suite
Test Tags    Smoke    test:retry(4)    Admin    order    OD_101

*** Variables ***

*** Test Cases ***
Verify Order And Receive Now
	[Documentation]   Smoke test order and receive after contract price discount
    [Tags]    OD_101.1    report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Order
    ...  report.label.story:Order
    Get Price In Contract
    Create Order And Receive Now    contract_id=${contract_id}
    Verify Receive Now In Transaction

Verify Order And Receive Now Not Select Contract
	[Documentation]   Smoke test order and receive now no release contract
    [Tags]    report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Order
    ...  report.label.story:Order
    Create Order And Receive Now
    Verify Receive Now In Transaction

*** Keywords ***
Get Price In Contract
    Wait Until Keyword Succeeds    5times    2s    ContractsAndPricingSetKewords.Go To Contract & Pricing Sets 
    ContractsAndPricingSetKewords.Filter By Member    member_value=${checked_location}
    Wait Until Keyword Succeeds    5times    2s    ContractsAndPricingSetKewords.Search By Contract Information    contract_search_values=${contract_id}
    Wait Until Keyword Succeeds    5 times    2s    ContractsAndPricingSetKewords.Edit Contract    contract_search_values=${contract_id}
    Get Allocation Group Contracted Item    ndc=${ndc}
    Calc Price Discount    allocation_group=${allocation_group}
    
Calc Price Discount
    [Arguments]    ${allocation_group}
    Edit Contract.Get Info Contract Checked Row
    ${base_price}    Convert Amount/Unit To Number    ${base_price}    $
    ${base_qty}    Convert Amount/Unit To Number    ${base_qty}
    ${condtion}    Run Keyword And Return Status    Should Contain    ${allocation_group}    Group
    IF    $condtion == ${True}
        ${allocation_group}    Get Substring    ${allocation_group}    6
        Edit Contract.Select Tab Allocation Rules
        ${total_base_price}    Set Variable    0
        ${total_base_uom}    Set Variable    0
        Wait Until Element Is Visible    //*[@id="ContractAllocations"]//label[text()='${allocation_group}']//ancestor::div[contains(@class,"panel-info")]//tbody//td[contains(text(),"Immediate") or contains(text(),"Prompt Pay Discount")]//parent::tr
        ${elems_count}    Get Element Count    //*[@id="ContractAllocations"]//label[text()='${allocation_group}']//ancestor::div[contains(@class,"panel-info")]//tbody//td[contains(text(),"Immediate") or contains(text(),"Prompt Pay Discount")]//parent::tr
        FOR    ${i}    IN RANGE    1    ${elems_count}+1
            ${contributor}    Get Text    (//*[@id="ContractAllocations"]//label[text()='${allocation_group}']//ancestor::div[contains(@class,"panel-info")]//tbody//td[contains(text(),"Immediate") or contains(text(),"Prompt Pay Discount")]//parent::tr)[${i}]/td[2]
            ${recipient}    Get Text    (//*[@id="ContractAllocations"]//label[text()='${allocation_group}']//ancestor::div[contains(@class,"panel-info")]//tbody//td[contains(text(),"Immediate") or contains(text(),"Prompt Pay Discount")]//parent::tr)[${i}]/td[3]
            ${amount}    Get Text    (//*[@id="ContractAllocations"]//label[text()='${allocation_group}']//ancestor::div[contains(@class,"panel-info")]//tbody//td[contains(text(),"Immediate") or contains(text(),"Prompt Pay Discount")]//parent::tr)[${i}]/td[5]
            ${unit}=  Evaluate   "%" in """${amount}"""
            # if contributor = distributor and recipient = Member price decrease
            IF    """${contributor}""" == """Distributor""" and """${recipient}""" == """Member"""
                IF    $unit == $True
                    ${amount}    Convert Amount/Unit To Number    ${amount}    %
                    ${total_base_price}    Evaluate    ${${amount}}+${${total_base_price}}
                ELSE
                    ${amount}    Convert Amount/Unit To Number    ${amount}    $
                    ${total_base_uom}    Evaluate    ${${amount}}+${${total_base_uom}}
                END
            # if contributor = distributor and recipient = Member price increase
            
            ELSE IF     """${contributor}""" == """Member""" and """${recipient}""" == """Distributor"""
                IF    $unit == $True
                    ${amount}    Convert Amount/Unit To Number    ${amount}    %
                    ${total_base_price}    Evaluate    ${-${amount}}+${${total_base_price}}
                ELSE
                    ${amount}    Convert Amount/Unit To Number    ${amount}    $
                    ${total_base_uom}    Evaluate    ${-${amount}}+${${total_base_uom}}
                END
            END
        END
        ${price_after_discount}    Evaluate    ${base_price}*(1-${total_base_price}/100)-${base_qty}*${total_base_uom}
        Set Test Variable    ${price_after_discount}
    ELSE
        Set Test Variable    ${price_after_discount}    ${base_price}
    END

Get Allocation Group Contracted Item
    [Arguments]    ${ndc}
    Waiting For Loading
    # Wait Until Element Is Not Visible    //*[@id="ContractedItems"]/div/i
    Edit Contract.Search By Item    ${ndc}
    Wait Until Element Is Visible    name=item.AllocationGroupId
    # Scroll Element Into View   name=item.AllocationGroupId
    ${allocation_group}    Get Selected List Label    name=item.AllocationGroupId
    Set Test Variable    ${allocation_group}


Create Order And Receive Now
    [Arguments]    ${contract_id}=No related contract
    Wait Until Keyword Succeeds    3times    5s    OpenOrder.Open Orders
    OrderAndReceiveNow.Receive Now
    Input Order Info
    IF    '${contract_id}' == 'No related contract'
        Wait Until Page Contains    Receiving Products & Pricing
        Select From List By Label    billingItem_ContractSelected    No related contract
        Execute Javascript    document.activeElement.blur();
        Waiting For Loading
        sleep    2s
        Execute Javascript    document.evaluate("//*[contains(@class,'AssignedProductPrice')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value="$100"
        sleep    2s
        Execute Javascript    document.querySelector('input.AssignedProductPrice').dispatchEvent(new Event('change', { bubbles: true}));
        Waiting For Loading
        sleep    2s
        ${price_after_discount}    Get Value     //*[contains(@class,'AssignedProductPrice')]
        ${price_after_discount}    Convert Amount/Unit To Number    ${price_after_discount}    $
        Set Test Variable    ${price_after_discount}
    END
    Wait Until Keyword Succeeds    3 times    1    OrderAndReceiveNow.Complete Receive Now

Input Order Info
    Wait Until Keyword Succeeds    3times    5s    OrderAndReceiveNow.Select Receiving Account    receiving_account=${checked_location}
    Wait Until Keyword Succeeds    3times    5s    OrderAndReceiveNow.Select Receiving Inventory    receiving_facility=${receiving_facility}
    Wait Until Keyword Succeeds    3times    5s    OrderAndReceiveNow.Select Order Vendor    order_vendor=${order_vendor}
    Wait Until Keyword Succeeds    3times    5s    OrderAndReceiveNow.Click Reset Assigned Products
    Wait Until Keyword Succeeds    5 times    5s    Input PO Number And Scan

Input PO Number And Scan
    OrderAndReceiveNow.Input PO Number
    OrderAndReceiveNow.Config Order By Scan    ${barcode_item}
    Wait Until Page Does Not Contain    You must assign an PO Number to continue.    timeout=10s
    Verify Scan Order Success
    OrderAndReceiveNow.Input Quantity    ${order_qty} 
    
Verify Receive Now In Reconcile
	Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
	ReconcileDetail.Verify Dispensed and Received and Other Change In Reconcile Table
	...    ndc=${ndc}
	...    received_qty=${order_qty}

Verify Receive Now In Transaction
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location    ${checked_location}
    InventoryLevel.Select Facility In Inventory Level    ${checked_facility}
    InventoryLevel.Find Inventory With NDCItem    ${ndc}
    InventoryLevel.Select Show Empty Inventory
    Wait Until Keyword Succeeds    5 times    3s    InventoryLevel.Show Transaction UoM "${uom}"
    ${order_receive_info}    Get WebElement    //*[contains(@class,'active') and contains(@class,'tab-pane')]//*[(@id='LevelList')]//*[contains(@class,'active') and contains(@class,'tab-pane') and contains(@id,'InventoryTransactionTab')]//*[contains(@class,'row')][2]
    ${order_receive_info}    Get Element Attribute    ${order_receive_info}    outerHTML
    ${order_receive_info}    CustomLibrary.Get Transaction Inventory Level    ${order_receive_info}    ${{['Type','Description','Adjustment','Price']}}
    ${order_receive_info}    Convert To Dictionary    ${order_receive_info}
    # ${Type}    Get From Dictionary    ${order_receive_info}    Type
    # ${Description}    Get From Dictionary    ${order_receive_info}    Description
    ${Adjustment}    Get From Dictionary    ${order_receive_info}    Adjustment
    ${Price}    Get From Dictionary    ${order_receive_info}    Price
    ${Price}    Convert Amount/Unit To Number    ${Price}    $
    Should Be Equal    ${Price}    ${price_after_discount}
    Should Be Equal    ${${Adjustment}}    ${${order_qty}}


Reset And Fill Empty Reconcile
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=20s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    Open Active Reconcile
    Select Type Reconcile    full

Set Up Suite
    ${data_input}    Get Data
    ${order_qty}    Evaluate    random.choice(range(1, 4))    random
	Set Suite Variable    ${order_qty}
    Set Suite Variable    ${checked_facility}    ${data_input}[checked_facility]
    Set Suite Variable    ${contract_id}    ${data_input}[contract_id]
    Set Suite Variable    ${checked_location}    ${data_input}[checked_location]
    Set Suite Variable    ${ndc}    ${data_input}[ndc]
    Set Suite Variable    ${barcode_item}    ${data_input}[barcode_item]
    Set Suite Variable    ${order_vendor}    ${data_input}[order_vendor]
    Set Suite Variable    ${receiving_facility}    ${data_input}[receiving_facility]
    Set Suite Variable    ${uom}    ${data_input}[uom]

Setup Test Case
    Login To Fusebox    ${Username}    ${Password}
    Reset And Fill Empty Reconcile

Convert Amount/Unit To Number
    [Arguments]    ${unit}    ${string_remove}=" "
    ${unit}    Remove String    ${unit}    ${string_remove}
    ${unit}    Convert To Number    ${unit}
    RETURN    ${unit}
