*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource

Suite Setup    Setup Suit
Test Setup    Test Setup
Suite Teardown    Close All Browsers

Test Tags    Prime    Fee_100    report.label.owner:Cuong Pham    test:retry(2)
*** Test Cases ***
Verify Fee Payment Detail
    [Documentation]    FEE_1
    Click Element    class=paymentRow
    Waiting For Loading
    [Teardown]    Close Popup


Verify Fee Detail
    [Documentation]    FEE_2
    Click Element    class=paymentRow
    Waiting For Loading
    [Teardown]    Close Popup

    
Verify Assign Fee Actual Amount
    [Documentation]    FEE_3
    Click Element    class=paymentRow
    Waiting For Loading
    [Teardown]    Close Popup


*** Keywords ***
Setup Suit
    Login To Fusebox    ${Username}    ${Password}

Test Setup
    Click Element    link: Home
    FeeTracker.Go To Fee Tracker
    Wait Until Keyword Succeeds    3times    3s    Search Location

Search Location
    Wait Until Keyword Succeeds    3times    3s    FeeTracker.View Account    Fusebox (100006) 
    FeeTracker.Search
    Waiting For Loading

Close Popup
    Wait Until Element Is Enabled    (//*[@aria-hidden="false"]//*[contains(text(),"Close")])[2]    15s
    Click Element    (//*[@aria-hidden="false"]//*[contains(text(),"Close")])[2]
    Waiting For Loading