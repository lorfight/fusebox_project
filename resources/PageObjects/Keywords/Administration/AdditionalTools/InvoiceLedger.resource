*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Click Filter Search Button
    Click Element    //*[@id='InvoiceLedgerList']/preceding::*[contains(@class,'SearchBtn')]

Click List Search Button
    Click Element    //*[@id='InvoiceLedgerList']/*[contains(@class,'SearchBtn')]

Input Item Filter
    [Arguments]    ${item}
    Input Text    id=ItemSearchValues    ${item}
    Execute JavaScript    document.activeElement.blur()

Click Find Item
    Click Button    id=ItemFindButton

Click Clear Item
    Click Button    id=ItemClearButton

Filter Status
    [Arguments]    ${status}
    Select From List By Label    id=StatusID    ${status}

Filter Distributor
    [Arguments]    ${distri}
    Select From List By Label    id=SelectedDistributorID    ${distri}

Filter Member
    [Arguments]    ${mem}
    Select From List By Label    id=SelectedAccountID    ${mem}

Input Start Date
    [Arguments]    ${date}
    Input Text    id=StartDate    ${date}
    Execute JavaScript    document.activeElement.blur()

Input End Date
    [Arguments]    ${date}
    Input Text    id=EndDate    ${date}
    Execute JavaScript    document.activeElement.blur()