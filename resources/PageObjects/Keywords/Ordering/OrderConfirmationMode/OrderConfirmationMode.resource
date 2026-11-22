*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Order Confirmation Mode
    Click Element    link: Ordering
    Click Element    link: Order Confirmation Mode
    Title Should Be    Order Confirmation Mode
