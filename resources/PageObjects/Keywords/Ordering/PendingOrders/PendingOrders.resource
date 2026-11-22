*** Settings ***
Resource    ../Common/OrderUtils.resource

*** Keywords ***
Go To Pending Orders
    Click Element    link: Ordering
    Click Element    link: Pending Orders
    Title Should Be    Pending Orders

Viewing Account
    [Arguments]    ${account}
    Wait Until Page Contains Element    id=MemberId    error=Viewing Account element isn't available
    Select From List By Label    id=MemberId    ${account}
    Waiting For Loading

New Order
    Click Element    link: New Order
    Title Should Be    Build Order

Build Name
    [Arguments]    ${build_name}
    Click Element    link: ${build_name}
    Waiting For Loading
    Title Should Be    Build Order