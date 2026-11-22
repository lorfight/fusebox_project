*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/PayerContractsTracker/PayerContractsTracker.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Setup Suite
Suite Teardown    Close All Browsers
Test Tags    Prime    OD_109    report.label.owner:Cuong Pham
*** Test Cases ***
Verify Allowable Validations in Payer Contracts Tracker
    [Documentation]    PCT_01
    PayerContractsTracker.Go To Payer Contracts Tracker Page
    PayerContractsTracker.Location    ${data_input}[checked_location]
    # PayerContractsTracker.Allowable Validation
    # Click Button    //*[@id="ModalPopup" and @aria-hidden="false"]//*[@id="CloseBtn"]

*** Keywords ***
Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}