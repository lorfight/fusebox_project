*** Settings ***
Resource    ../Common/OrderUtils.resource



*** Keywords ***
Go To Invoice Ledger
    Click Element    link: Ordering
    Click Element    link: AP - Order Invoice Ledger
    Title Should Be    Invoice Ledger

Item Filter
    [Arguments]    ${item}
    Wait Until Page Contains Element    id=ItemSearchValues    timeout=20s    error=Item Search Values field is not visible
    Input Text    id=ItemSearchValues    ${item}
    Execute Javascript    document.activeElement.blur();
    Press Keys    None    ENTER
    Waiting For Loading

Status Filter
    [Arguments]    ${status}=-- All Unreconciled Invoices --
    Click Element    id=StatusID
    Select From List By Label    id=StatusID    ${status}
    Waiting For Loading

Filter By Distributor
    [Arguments]    ${distributor}
    Wait Until Page Contains Element    id=SelectedDistributorID    timeout=20s    error=Distributor Search Values field is not visible
    Select From List By Label    id=SelectedDistributorID    ${distributor}
    Waiting For Loading

Filter By Member
    [Arguments]    ${member}
    Wait Until Page Contains Element    id=SelectedAccountID    timeout=20s    error=Member Search Values field is not visible
    Select From List By Label    id=SelectedAccountID    ${member}
    Waiting For Loading

Filter By Date Range
    [Arguments]    ${start_date}    ${end_date}
    Wait Until Page Contains Element    id=StartDate    timeout=20s    error=From Date field is not visible
    Input Text    id=StartDate    ${start_date}
    Input Text    id=EndDate    ${end_date}
    Execute Javascript    document.activeElement.blur();
    Waiting For Loading

Click Search Button
    Click Element    link: Search
    Waiting For Loading