*** Settings ***
Resource    ../../../../../libraries/Util.resource


*** Keywords ***
Go To Payer Contracts Tracker Page
    Click Link    link: Ordering
    Click Link    link: Payer Contracts Tracker
    Waiting For Loading    error=Can't load Payer Contracts Tracker page

Item Filter
    [Arguments]    ${item}
    Wait Until Element Is Enabled    id=ItemSearchValues
    Input Text    id=ItemSearchValues    ${item}
    Execute Javascript    document.activeElement.blur();
    Waiting For Loading

Location
    [Arguments]    ${location}
    Wait Until Element Is Enabled    id=Location
    Select From List By Label    id=Location    ${location}
    Waiting For Loading

Payer Contract
    [Arguments]    ${insurer/payer}
    Wait Until Element Is Enabled    id=PayerContractId
    Select From List By Label    id=PayerContractId    ${insurer/payer}
    Waiting For Loading

Filter By Quarter
    [Arguments]    ${quarter}=1
    Wait Until Page Contains Element    id=CurrentQuarter
    Select From List By Label    id=CurrentQuarter    ${quarter}
    Waiting For Loading

Filter By Year
    [Arguments]    ${year}=2024
    Wait Until Page Contains Element    id=CurrentYear
    Select From List By Label    id=CurrentYear    ${year}
    Waiting For Loading

Filter By Benefits
    [Arguments]    ${benefits}=Show All
    Wait Until Page Contains Element    id=Benefit
    Select From List By Label    id=Benefit    ${benefits}
    Waiting For Loading

Allowable Validation
    Click Element    id=allowableValidation
    Waiting For Loading    error=Allowable Validation action failed

Add Payer Contract
    Click Element    link: Add Payer Contract
    Waiting For Loading    error=Add Payer Contract action failed

Search
    Click Button    link: Search
    Waiting For Loading    error=Search action failed