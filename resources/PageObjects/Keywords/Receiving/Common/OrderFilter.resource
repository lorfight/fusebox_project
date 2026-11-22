*** Settings ***
Resource    OrderUtils.resource

*** Keywords ***
Search For An Order ${po_number}
    Waiting For Loading
    Input Text    id=SearchValues    ${po_number}
    Execute Javascript    document.activeElement.blur();
    Click Button    id=FindButton
    Waiting For Loading
    Wait Until Element Is Visible   //*[@id="OrderList"]//span[contains(text(),"${po_number}")]    timeout=20s    error=Can't find Order
