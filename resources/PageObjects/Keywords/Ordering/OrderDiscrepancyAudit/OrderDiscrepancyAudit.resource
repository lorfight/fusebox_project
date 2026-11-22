*** Settings ***
Resource    ../../Layers/OrderList/OrderList.resource



*** Keywords ***
Go To Order Discrepancy Audit
    Click Element    link: Ordering
    Click Element    link: Order Discrepancy Audit
    Title Should Be    Order Discrepancy Audit

Edit extExt Actual/Paid Value
    [Arguments]    ${value}
    Input Text    //*[contains(@class,"actualValue")]    ${value}
    Execute Javascript    document.activeElement.blur();
    Waiting For Loading

Apply
    Click Element    //*[text()="Apply"]
    Wait Until Page Contains    Audit Applied!
    Waiting For Loading