*** Settings ***
Resource    ./OrderFilter/OrderFilter.resource
Resource    ../ReceiveNow/ReceiveNow.resource
Resource    ../../Layers/ViewConfirmation/ViewConfirmation.resource

*** Keywords ***
View Order
    [Arguments]    ${po_number}
    Click Element    //*[text()="${po_number}"]//preceding::td[2]//a
    Waiting For Loading
    # Title Should Be    Order Details

View Confirmation
    [Arguments]    ${po_number}

    Wait Until Keyword Succeeds    3times    3s    Click Element    //*[text()="${po_number}"]//following::tr[2]//a[@data-original-title="View Confirmation"]
    Switch Window    Order Confirmation Form
    Title Should Be    Order Confirmation Form
    Waiting For Loading

View Invoice
    [Arguments]    ${po_number}
    Wait Until Keyword Succeeds    3times    3s    Click Element    //*[text()="${po_number}"]//following::tr[2]//a[@data-original-title="View Invoice"]
    Switch Window    Invoice Reconcile Form
    Title Should Be    Invoice Reconcile Form
    Waiting For Loading

Receive Now
    Click Element    link: Receive Now 
    Waiting For Loading