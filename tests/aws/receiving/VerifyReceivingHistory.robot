*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Receiving/Receiving.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Test Setup    Setup Test case
Test Teardown    Test Teardown
Suite Teardown    Close All Browsers
Test Tags    RE_101    test:retry(2)    Prime    report.label.owner:Cuong Pham

*** Variables ***
${data_input}
${lot_number}    TB0015 -- [Expires: 06/30/2027]
${ndc}    00310-1730-30
${vendor}    Nan Tech

${receiving_inventory}    Inventory Reconcile Partial ( Buy & Bill )
${po_number}
*** Test Cases ***
Verify View Order
    [Documentation]    ORD_17
    OrderFilter.Filter By Location    ${data_input}[checked_location]
    OrderFilter.Search For An Order ${po_number}
    OrderList.View Order    ${po_number}
    

Verify View Confirmation
    [Documentation]    ORD_18
    OrderFilter.Search For An Order ${po_number}
    OrderList.View Confirmation    ${po_number}
    ViewConfirmation.Vendor Contact
    ViewConfirmation.Generate Confirmation Email
    ViewConfirmation.Send Confirmation Email
    ViewConfirmation.View Confirmation PDF
    Log    Viewed Confirmation for PO Number: ${po_number}

Verify View Invoice
    [Documentation]    ORD_19
    OrderFilter.Search For An Order ${po_number}
    OrderList.View Invoice    ${po_number}

    

*** Keywords ***
Receive Now Order
    [Documentation]    ORD_16
    ReceivingHistory.Go To Order History
    OrderList.Receive Now
    ReceiveNow.Select Receiving Account    ${data_input}[checked_location]
    ReceiveNow.Select Receiving Inventory    ${receiving_inventory}
    ReceiveNow.Select Order Vendor    ${vendor}
    ReceiveNow.Input PO Number    ${po_number}
    ReceiveNow.Click Reset Assigned Products
    ReceiveNow.Click Manual Add Products
    ReceiveNow.Search for your Item    ${ndc}
    ReceiveNow.Selec Lot Number    ${lot_number}
    ReceiveNow.Input Qty By Item    5
    ReceiveNow.Click Assign Item
    ReceiveNow.Complete Receive Now

Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    ${time_stamp}    Get Current Date    result_format=%d%H%M%S
    Set Suite Variable    ${po_number}    ORD-16-${time_stamp}

    Receive Now Order
    
Setup Test case
    ReceivingHistory.Go To Order History
    
Test Teardown
    Click Element    link: Home
    