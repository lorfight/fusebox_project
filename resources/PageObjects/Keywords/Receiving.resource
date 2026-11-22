*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library         Collections
Library    ../../../libraries/CustomLibrary.py

Variables    ../Locators/CommonLocator.py
Variables    ../Locators/CreateOrderLocator.py
Variables    ../TestData/Testdata.py

Resource    ../../../libraries/Util.resource


*** Keywords ***
# Behaviour
## Inventory Reconcile
Go Create & Receive New Purchase Order
    Click Element    ${ReceivingLink}
    Click Element    ${CreateOrderingLink}
    
Apply Item
    [Arguments]    ${barcode}    ${checked_facility}    ${order_qty}
    Waiting For Loading
    Util.Verify Loading And Select By Label    Facility    ${checked_facility}
    Util.Handle Scan List Barcode    barcode=${barcode}
    # ${order_qty_actual}=    Get Text    //div[contains(@class,"QtyOrdered")]
    # Should Be Equal    ${${order_qty_actual}}    ${${order_qty}}
    # Input Text    id=LineNumber1Qty    ${order_qty}
    # Execute Javascript    document.activeElement.blur()
    # Click Element    link:Save
    Waiting For Loading