*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Sales Orders
    Click Element    link: Ordering
    Click Element    link: Sales Orders
    Title Should Be    Sales Orders

View Packing Slip
    [Arguments]    ${po_number}
    Click Element    //*[text()="${po_number}"]//following::tr[2]//a[@data-original-title="View Packing Slip"]
    Waiting For Loading