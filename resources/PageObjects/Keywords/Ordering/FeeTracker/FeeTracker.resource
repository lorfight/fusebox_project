*** Settings ***
Resource    ../Common/OrderUtils.resource

*** Keywords ***
Go To Fee Tracker
    Click Element    link: Ordering
    Click Element    link: Fee Tracker
    Title Should Be    Fee Tracker
    Waiting For Loading

View Account
    [Arguments]    ${account}
    Wait Until Element Is Enabled    //select[@id="AccountId" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@id="AccountId" and not(contains(@class,"hidden"))]    ${account}
    Waiting For Loading

Filter By Recipient
    [Arguments]    ${recipient}
    Wait Until Element Is Enabled    //select[@id="RecipientId" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@name="RecipientId" and not(contains(@class,"hidden"))]    ${recipient}
    Waiting For Loading

Filter By Payer
    [Arguments]    ${payer}
    Wait Until Element Is Enabled    //select[@id="PayerId" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@name="PayerId" and not(contains(@class,"hidden"))]    ${payer}
    Waiting For Loading

Filter By Fee Type
    [Arguments]    ${feetype}
    Wait Until Element Is Enabled    //select[@id="FeeType" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@name="FeeType" and not(contains(@class,"hidden"))]    ${feetype}
    Waiting For Loading

Filter By Payment Status
    [Arguments]    ${paymentstatus}
    Wait Until Element Is Enabled    //select[@id="Paymentstatus" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@name="Paymentstatus" and not(contains(@class,"hidden"))]    ${paymentstatus}
    Waiting For Loading

Filter By Payment Type
    [Arguments]    ${paymenttype}
    Wait Until Element Is Enabled    //select[@id="PaymentType" and not(contains(@class,"hidden"))]    15s
    Select From List By Label    //select[@name="PaymentType" and not(contains(@class,"hidden"))]    ${paymenttype}
    Waiting For Loading

Search
    Click Element    link: Search