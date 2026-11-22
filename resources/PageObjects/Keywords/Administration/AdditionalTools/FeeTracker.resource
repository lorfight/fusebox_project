*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Click Filter Search Button
    Click Element    //*[@id='FeeList']/preceding::*[contains(@class,'SearchBtn')]

Click List Search Button
    Click Element    //*[@id='FeeList']/*[contains(@class,'SearchBtn')]

Filter Account
    [Arguments]    ${acc}
    Select From List By Label    id=AccountId    ${acc}

Filter Recipient
    [Arguments]    ${rec}
    Select From List By Label    id=RecipientId    ${rec}

Filter Payer
    [Arguments]    ${payer}
    Select From List By Label    id=PayerId    ${payer}

Input Start Date
    [Arguments]    ${date}
    Input Text    id=StartDate    ${date}
    Execute JavaScript    document.activeElement.blur()

Input End Date
    [Arguments]    ${date}
    Input Text    id=EndDate    ${date}
    Execute JavaScript    document.activeElement.blur()

Filter Fee Type
    [Arguments]    ${type}
    Select From List By Label    id=FeeType    ${type}

Filter Payment Status
    [Arguments]    ${status}
    Select From List By Label    id=PaymentStatus    ${status}

Filter Payment Type
    [Arguments]    ${type}
    Select From List By Label    id=PaymentType    ${type}

Filter Row Per Page
    [Arguments]    ${row}
    Select From List By Label    id=RowsPerPage    ${row}

Filter Sort By
    [Arguments]    ${sort}
    Select From List By Label    id=SortBy    ${sort}