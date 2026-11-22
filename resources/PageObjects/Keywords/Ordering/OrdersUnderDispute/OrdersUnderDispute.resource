*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource


*** Keywords ***
Go To Orders Under Dispute
    Click Element    link: Ordering
    Click Element    link: Orders Under Dispute
    Title Should Be    Orders Under Dispute