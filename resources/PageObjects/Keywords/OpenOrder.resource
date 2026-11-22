*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime

Variables    ../Locators/CommonLocator.py
Variables    ../Locators/OrderList.py
Variables    ../Locators/CreateOrderLocator.py
Variables    ../TestData/Testdata.py

Resource    ../../../libraries/Util.resource


*** Keywords ***
Open Orders
    Click Element    link: Ordering
    Click Element    link: Open Orders
    Title Should Be    Open Orders

Search For An Order ${po_number}
    Wait Until Page Contains Element    //h2[contains(text(),"Open Orders")]    timeout=30s
    Input Text    id=SearchValues    ${po_number}
    Click Button    id=FindButton
    Waiting For Loading
    Wait Until Element Is Visible   //*[@id="OrderList"]//span[contains(text(),"${po_number}")]    error=Can't find Order

View Order
    Wait Until Element Is Enabled    link:View Order    timeout=20s    error=Loading page takes too long
    Click Element    link:View Order
