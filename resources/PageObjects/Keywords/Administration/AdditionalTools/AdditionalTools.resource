*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource
Resource    InvoiceLedger.resource
Resource    FeeTracker.resource
Resource    OrderHistory.resource

*** Keywords ***
Go To Additional Tools
    Click Element    link: Administration
    Click Element    link: Additional Tools

Go To Invoice Ledger
    Click Element    link: AP - Order Invoice Ledger

View Reconciled Invoices
    Click Element    link: AP - Reconciled Invoices

Go To Fee Tracker
    Click Element    link: Fee Tracker

Go To Order History
    Click Element    link: Order History

Click Send Test Order
    Click Element    link: Send Test Order

Go To Report Viewer
    Click Element    link: Barcode Configuration