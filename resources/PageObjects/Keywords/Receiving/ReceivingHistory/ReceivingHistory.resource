*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Order History
    Click Element    link: Receiving
    Click Element    link: Receiving History
    Title Should Be    Order History