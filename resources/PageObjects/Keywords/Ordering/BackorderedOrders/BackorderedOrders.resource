*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Backordered Orders
    Click Element    link: Ordering
    Click Element    //*[contains(text(),"Backordered Orders ")]
    Title Should Be    Backordered Orders
