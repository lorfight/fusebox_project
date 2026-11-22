*** Settings ***
Documentation      Verify the functionality of inventory reconciliation details, including adding, emptying, change changes, and full item reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource   ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource

Suite Setup     Set Up Suite
Test Setup    Setup Test Case Complete Reconcile
Suite Teardown    Close Browser
Test Tags    test:retry(2)    inventory    Regression    IV_007    Manager

*** Variables ***
${data_input}

*** Test Cases ***
Verify Reconcile Scanned Product Display With Permission View And Delete Products Within Patient Reservoirs And Inventory Reconciles Checked
    [Tags]    [reconcile]_05    [reconcile]_57    [reconcile]_120    Accounting
    ...  report.label.owner:Cuong Pham
    [Documentation]    report.label.owner:Cuong Pham
    Assign Permissions    permission=Can view and delete scanned products within patient reservoirs and inventory reconciles.
    Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Reconcile Scanned Product Display
    Close Modal Scanned Product
        
Verify Reconcile Scanned Product Not Display With Permission View And Delete Products Within Patient Reservoirs And Inventory Reconciles Unchecked
    [Tags]    [reconcile]_06    Accounting
    ...  report.label.owner:Cuong Pham
    [Documentation]    [reconcile]_06
    ...  report.label.owner:Cuong Pham
    Unassign Permissions    permission=Can view and delete scanned products within patient reservoirs and inventory reconciles.
    Save Change
    Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Verify Reconcile Scanned Product Not Display

# Verify Reconcile Can complete A Inventory Reconcile Has Authority To Mark A Reconcile As Completed And Adjust Inventory Unchecked
#     [Tags]    [reconcile]_08    [reconcile]_32    [reconcile]_37    [reconcile]_39
#     ...    [reconcile]_40    [reconcile]_44    [reconcile]_45    [reconcile]_48
#     ...    [reconcile]_49    [reconcile]_51    Accounting
#     ...    report.label.owner:Cuong Pham
#     [Documentation]    report.label.owner:Cuong Pham
#     [Setup]    Setup Test Case Complete Reconcile
#     Unassign Permissions    permission=Can complete a inventory reconcile. (Has authority to mark a reconcile as completed and adjust inventory.)
#     Save Change
#     Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
#     Verify Request Approval Reconcile Functionality
#     Verify Request Approval Reconcile Row Highlighted By Red
#     Verify Completed/Canceled By Empty
#     Verify Completed/Canceled Date Is Empty
#     Open Reconcile History By Id    reconcile_history_id=${reconcile_history_id}
#     Verity Edit Field Actual Qty On Hand Column
#     Cancel Reconcile
#     Verify Completed/Canceled Date Is Empty
#     Verify Completed/Canceled By Empty
#     Verify Status Reconcile Is Canceled
#     Verify Reconcile Cancelled
    
# Verify Reconcile Can complete A Inventory Reconcile Has Authority To Mark A Reconcile As Completed And Adjust Inventory Checked
#     [Tags]    [reconcile]_07    [reconcile]_38    [reconcile]_53    [reconcile]_58    Accounting
#     ...  report.label.owner:Cuong Pham
#     [Documentation]    report.label.owner:Cuong Pham
#     [Setup]    Setup Test Case Complete Reconcile
#     Assign Permissions    permission=Can complete a inventory reconcile. (Has authority to mark a reconcile as completed and adjust inventory.)
#     Save Change
#     Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
#     Verify Complete Reconcile Functionality
#     Verify Completion Log Display
#     Verify Status Reconcile Is Completed In Detail

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Set Selenium Speed    0.1s
    Login To Fusebox    user_name=${Username}    password=${Password}

Setup Test Case
    InventoryReconcile.Reset And Fill Empty Reconcile    checked_location=${data_input}[checked_location]    checked_facility=${data_input}[checked_facility]
    Go To User List
    Find User    role_filter=-- All Roles --
    Edit User    user_name=${Username}
    Switch Tab Permission In Edit User

Setup Test Case Complete Reconcile
    Go To User List
    Find User    role_filter=-- All Roles --
    Edit User    user_name=${Username}
    Switch Tab Permission In Edit User

Suite Teardown
    Close Browser Session

Go To User List
    Users.Go To User List
    

Find User
    [Arguments]    ${user_name}=${Username}    ${view_inactive}=${False}    ${role_filter}=Administrator
    Users.Find User    ${user_name}    ${view_inactive}    ${role_filter}

Edit User
    [Arguments]    ${user_name}=${data_input}[user_name]
    Users.Edit User    ${user_name}

Switch Tab Permission In Edit User
    [Arguments]    ${tab_name}=Permission
    UserDetail.Switch Tab    ${tab_name}

Assign Permissions
    [Arguments]    ${permission}=${data_input}[permission]
    UserDetail.Assigned Permission    ${permission}

Unassign Permissions
    [Arguments]    ${permission}=${data_input}[permission]
    UserDetail.Unassigned Permission    ${permission}

Save Change
    UserDetail.Save Button

Close Modal Scanned Product
    Click Element    id=CloseModalBtn
    Wait Until Page Contains Element     //*[@id='MiniModalPopup' and contains(@aria-hidden,"true")]

Verify Reconcile Scanned Product Display
    execute JavaScript    handleScan("01003031017303032108400466291401|1725063010TB0015")
    Wait Until Element Contains     //*[@id='ScannedItemCount']    1    timeout=10s
    Wait Until Page Contains Element    //*[@onclick='ScannedItemsModal()']
    ${scanned_products}    Get Element Attribute    //*[@onclick='ScannedItemsModal()']    onclick
    execute JavaScript    ${scanned_products}
    Wait Until Page Contains Element    //*[@id='ScannedItemModalList']
    Wait Until Page Contains Element    //*[contains(@class,'RemoveScannedItemBtn')]    timeout=30s
    Click Element    //*[contains(@class,'RemoveScannedItemBtn')]
    Wait Until Page Contains    Scanned Item has been removed.
    Wait Until Page Does Not Contain    Scanned Item has been removed.
  
Verify Reconcile Scanned Product Not Display
    Wait Until Page Does Not Contain Element    //*[@onclick='ScannedItemsModal()']    120s

Verify Complete Reconcile Functionality
    execute JavaScript    handleScan("01003031017303032108400466291401|1725063010TB0015")
    Get Reconcile History id
    OpenActiveReconcile.Complete Reconcile
    Verify Status Reconcile Is Completed
    ${user_name}    Util.Get User Name
    Verify Completed/Canceled By User    user=${user_name}
    
Verify Request Approval Reconcile Functionality
    execute JavaScript    handleScan("01003031017303032108400466291401|1725063010TB0015")
    Get Reconcile History id
    Verity Edit Field Actual Qty On Hand Column
    Request Approval Reconcile
    Verify Status Reconcile Is Requires Approval

Verify Status Reconcile Is Requires Approval
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${reconcile_status}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[4]/strong    innerHTML
    Should Be Equal As Strings    ${reconcile_status}    Requires Approval

Verify Status Reconcile Is Canceled
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${reconcile_status}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[4]/strong    innerHTML
    Should Be Equal As Strings    ${reconcile_status}    Canceled

Verify Status Reconcile Is Completed
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${reconcile_status}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[4]/strong    innerHTML
    Should Be Equal As Strings    ${reconcile_status}    Complete

Verify Completed/Canceled By Empty
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${completed/canceled_by}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[5]/span    innerHTML
    Should Be Equal As Strings    ${completed/canceled_by}    -

Verify Completed/Canceled Date Is Empty
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${completed/canceled_by}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[6]/span    innerHTML
    Should Be Equal As Strings    ${completed/canceled_by}    -
    
Verify Completed/Canceled By User
    [Arguments]    ${user}
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${completed/canceled_by}    Get Text    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr/td)[5]
    Should Be Equal As Strings    ${completed/canceled_by}    ${user}

Verify Request Approval Reconcile Row Highlighted By Red
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    ${background_color}    Get Element Attribute    (//*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]/parent::td/parent::tr)[1]    style
    Should Be Equal As Strings    ${background_color}    background-color: rgba(250, 60, 60, 0.18) !important;

Verify Completion Log Display
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(text(),'Open Active Reconcile')]    timeout=20s
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@onclick,${reconcile_history_id})]
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[@id="ReconcileInventoryList"]//*[contains(@href,${reconcile_history_id})]
            
Verify General Information Reconcile
    [Arguments]    ${created_by}    ${created_date}    ${status}
    Wait Until Page Contains Element    //*[@id="ReconcileInventoryList"]//*[contains(text(),${status})]

Verity Edit Field Actual Qty On Hand Column
    Wait Until Page Contains Element    //input[@id="ReconcileLine_1"]    timeout=20s
    
Verity Can't Edit Field Actual Qty On Hand Column
    Wait Until Page Does Not Contain Element   //input[@id="ReconcileLine_1"]    timeout=20s

Verify Reconcile Cancel
    [Arguments]    ${reconcile_history_id}
    InventoryReconcile.Open Reconcile History By Id    ${reconcile_history_id}
    Wait Until Page Contains   text=This Inventory Reconcile has been Canceled.    timeout=20s
    Util.Scroll To Top
    ${status_reconcile}=    SeleniumLibrary.Get Text    ${StatusReconcile}
    Should Be Equal    ${status_reconcile}    Canceled

Verify Reconcile Cancelled
    [Arguments]    ${reconcile_history_id}=${reconcile_history_id}
    Verify Reconcile Cancel    ${reconcile_history_id}
    Verity Can't Edit Field Actual Qty On Hand Column

Verify Status Reconcile Is Completed In Detail
    [Arguments]    ${reconcile_history_id}=${reconcile_history_id}
    Open Reconcile History By Id    ${reconcile_history_id}    
    Verity Can't Edit Field Actual Qty On Hand Column