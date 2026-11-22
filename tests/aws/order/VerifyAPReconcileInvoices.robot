*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Test Setup    Setup Test Case
Suite Teardown    Close All Browsers
Test Tags    Prime    OD_101    test:retry(2)    report.label.owner:Cuong Pham

*** Variables ***
${data_input}

*** Test Cases ***
Order Invoice Reconcile
    Log    By Passed This Case


*** Keywords ***
Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}

Setup Test Case
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    AP-ReconcileInvoices.Go To Invoice Ledger
    AP-ReconcileInvoices.Filter By Member    ${data_input}[checked_location]
    AP-ReconcileInvoices.Status Filter
    AP-ReconcileInvoices.Click Search Button

    