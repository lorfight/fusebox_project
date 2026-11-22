*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Order History
    Click Element    link: Ordering
    Click Element    link: Order History
    Title Should Be    Order History

Select Order Line
    [Arguments]    ${po_num_arg}
    Waiting For Loading
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[contains(text(),'${po_num_arg}')]//preceding::*[contains(text(),'View Order')]