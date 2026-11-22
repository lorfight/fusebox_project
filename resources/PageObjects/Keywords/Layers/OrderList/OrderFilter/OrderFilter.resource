*** Settings ***
Resource    ../../../../../../libraries/Util.resource

*** Keywords ***
Search For An Order ${po_number}
    Waiting For Loading
    Input Text    id=SearchValues    ${po_number}
    Execute Javascript    document.activeElement.blur();
    Click Button    id=FindButton
    Waiting For Loading
    Wait Until Element Is Visible   //*[contains(text(),"${po_number}")]    timeout=20s    error=Can't find Order

Filter By Location
    [Arguments]    ${location}
    Waiting For Loading
    Select From List By Label    id=MemberId    ${location}
    Waiting For Loading

Click Search
    Click Button    id=FindButton
    Waiting For Loading