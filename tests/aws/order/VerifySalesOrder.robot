*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Test Setup    Setup Test case
Test Teardown    Test Teardown
Suite Teardown    Close All Browsers
Test Tags    Prime    OD_111    test:retry(2)    Manager    report.label.owner:Cuong Pham

*** Variables ***
${ndc}    00310-1730-30
${vendor}    Nan Tech
*** Test Cases ***
    
Verify View Order
    [Documentation]    ORD_17
    [Setup]    New Order
    Wait Until Page Contains Element    id=MemberId    60s
    OrderFilter.Filter By Location    ${data_input}[checked_location]
    OrderFilter.Search For An Order ${po_number}
    OrderList.View Order    ${po_number}

Verify View Confirmation
    [Documentation]    ORD_18
    OrderList.View Confirmation    ${po_number}
    ViewConfirmation.Vendor Contact
    ViewConfirmation.Generate Confirmation Email
    ViewConfirmation.Send Confirmation Email
    ViewConfirmation.View Confirmation PDF

Verify View Invoice
    [Documentation]    ORD_19
    OrderList.View Invoice    ${po_number}

    

*** Keywords ***
New Order
    NewOrder.Go Order
    NewOrder.Select Customer Account    ${data_input}[checked_location]
    NewOrder.Find NDC    ${ndc}
    NewOrder.Filter By Vendor    ${vendor}
    NewOrder.Filter By Manufacturer    ${data_input}[manufacturer]
    NewOrder.Ship To Alternate Address    QC auto (New York, NY)
    NewOrder.Select Contract Search Tab    contract=${data_input}[contract]
    NewOrder.Select UOM Search Tab    ${data_input}[uom]
    NewOrder.Add Quality    1
    ${po_number}    NewOrder.Config My Cart
    Set Suite Variable    ${po_number}    ${po_number}
    NewOrder.Submit Order

Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

    
Setup Test case
    SalesOrders.Go To Sales Orders
    Wait Until Page Contains Element    //li[@class="active" and text()="Sales Orders"]
    OrderFilter.Search For An Order ${po_number}

    
Test Teardown
    Click Element    link: Home
    