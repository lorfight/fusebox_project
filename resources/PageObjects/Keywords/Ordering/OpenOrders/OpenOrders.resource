*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource

*** Keywords ***
Go To Open Orders
    Click Element    link: Ordering
    Click Element    link: Open Orders
    Title Should Be    Open Orders
