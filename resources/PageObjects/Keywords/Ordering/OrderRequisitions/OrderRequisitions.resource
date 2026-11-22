*** Settings ***
Resource    ../Common/OrderUtils.resource



*** Keywords ***
Go To Order Requisitions
    Click Element    link: Ordering
    Click Element    link: Order Requisitions
    Title Should Be    Order Requisitions

Viewing Account
    [Arguments]    ${account}
    Wait Until Page Contains Element    id=MemberId    error=Viewing Account element isn't available
    Select From List By Label    id=MemberId    ${account}
    Waiting For Loading

New Order
    Click Element    link: New Order
    Title Should Be    Build Order