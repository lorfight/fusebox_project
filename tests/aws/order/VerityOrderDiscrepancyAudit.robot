*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Suite Teardown    Close All Browsers
Test Tags    test:retry(2)    Prime    OD_112    report.label.owner:Cuong Pham

*** Variables ***
${ndc}    00310-1730-30
${vendor}    Nan Tech


*** Test Cases ***
Verify Order Discrepancy Audit
    [Documentation]    Verify that an order discrepancy audit is created when there is a change in contract, UOM, or quantity.
    [Setup]    New Order
    OrderDiscrepancyAudit.Go To Order Discrepancy Audit
    OrderFilter.Search For An Order ${po_number}
    OrderDiscrepancyAudit.Edit extExt Actual/Paid Value    300.00
    OrderDiscrepancyAudit.Apply
*** Keywords ***
Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

New Order
    NewOrder.Go Order
    NewOrder.Select Customer Account    ${data_input}[checked_location]
    NewOrder.Find NDC    ${ndc}
    NewOrder.Filter By Vendor    ${vendor}
    NewOrder.Filter By Manufacturer    ${data_input}[manufacturer]
    NewOrder.Ship To Alternate Address    QC auto (New York, NY)
    NewOrder.Select Contract Search Tab    contract=${data_input}[contract]
    NewOrder.Select UOM Search Tab    ${data_input}[uom]
    NewOrder.Add Quality    1
    ${po_number}    NewOrder.Config My Cart
    Set Suite Variable    ${po_number}
    NewOrder.Submit Order



