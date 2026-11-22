*** Settings ***
Documentation      Verify the functionality of inventory reconciliation details, including adding, emptying, change changes, and full item reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
# Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
# Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
# Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource   ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Set Up Suite
Test Setup    Setup Test Case
Test Teardown    Close Browser
Test Tags    test:retry(2)    Accounting    inventory    Regression    IV_006

*** Variables ***
${data_input}

*** Test Cases ***
Verify Reconcile To Inventory Every Reconcile Type is Visible - STRICT NOTES
    [Documentation]    [reconcile]_04
    [Tags]    [reconcile]_04
    ...    report.label.owner:Cuong Pham
    MyAccount.Select Inventory Reconcile Complexity    Every Reconcile Type is Visible - STRICT NOTES
    MyAccount.Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Option Reconcile Display    add=${True}    full=${True}    change=${True}    empty=${True}

Verify Reconcile To Inventory Add & Full Reconcile Only Visible
    [Documentation]    [reconcile]_01
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    ...  report.label.story:Add Item
    [Tags]    [reconcile]_01
    ...    report.label.owner:Cuong Pham
    MyAccount.Select Inventory Reconcile Complexity    Add & Full Reconcile Only Visible
    MyAccount.Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Option Reconcile Display    add=${True}    full=${True}

Verify Reconcile To Inventory Add & Full Reconcile Only Visible - STRICT NOTES
    [Documentation]    [reconcile]_03
    [Tags]    [reconcile]_03
    ...  report.label.owner:Cuong Pham
    MyAccount.Select Inventory Reconcile Complexity    Add & Full Reconcile Only Visible - STRICT NOTES
    MyAccount.Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Option Reconcile Display    add=${True}    full=${True}

Verify Reconcile To Inventory Every Reconcile Type is Visible
    [Tags]    [reconcile]_02    [reconcile]_59
    ...  report.label.owner:Cuong Pham
    MyAccount.Select Inventory Reconcile Complexity    Every Reconcile Type is Visible
    MyAccount.Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Option Reconcile Display    add=${True}    full=${True}    change=${True}    empty=${True}

*** Keywords ***
Verify Option Reconcile Display
    [Arguments]    ${add}=${False}    ${full}=${False}    ${change}=${False}    ${empty}=${False}
    IF    ${add}== ${True}
        Element Should Be Visible    //input[@data-type="add"]   
    ELSE
        Element Should Not Be Visible    //input[@data-type="add"]
    END
    IF    ${full}== ${True}
        Element Should Be Visible    //input[@data-type="full"]   
    ELSE
        Element Should Not Be Visible    //input[@data-type="full"]
    END
    IF    ${change}== ${True}
        Element Should Be Visible    //input[@data-type="change"]   
    ELSE
        Element Should Not Be Visible    //input[@data-type="change"]
    END
    IF    ${empty}== ${True}
        Element Should Be Visible    //input[@data-type="empty"]   
    ELSE
        Element Should Not Be Visible    //input[@data-type="empty"]
    END

Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Selenium Speed    0.1s

Setup Test Case
    Login To Fusebox    user_name=${Username}    password=${Password}
    Go To My Account
    
Suite Teardown
    Close Browser Session

Go To My Account
    MyAccount.Go To My Account
    MyAccount.Viewing Account    ${data_input}[checked_location]