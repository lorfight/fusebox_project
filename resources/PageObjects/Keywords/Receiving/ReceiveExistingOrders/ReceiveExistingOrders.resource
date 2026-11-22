*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource

*** Keywords ***
Go To Open Orders
    Click Element    link: Receiving
    Click Element    link: Receive Existing Orders
    Title Should Be    Open Orders
