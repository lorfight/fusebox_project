*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    ../../../libraries/CustomLibrary.py
Library    OperatingSystem
Library    Collections
Library    String
Library    DateTime
Library    requests
Library    ../TestData/Testdata.py
Variables    ../Locators/CommonLocator.py

*** Keywords ***
Go Billable Events
    Click Element    ${DispensingLink}
    Click Element    ${BillableLink}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Billable Event Ledger
    