*** Settings ***
Documentation      Verify the functionality of inventory reconciliation details, including adding, emptying, recent changes, and full item reconciliation.

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup     Set Up Suite
Suite Teardown    Close All Browsers
Test Teardown    Test Case Teardown
Test Tags    test:retry(1)    Admin    Accounting    Regression    inventory    IV_001

*** Variables ***
${data_input}

*** Test Cases ***
Verify Inventory Reconcile To Inventory Scan
    [Documentation]    Verify Inventory Reconcile To Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Reconcile
    [Tags]    [Reconcile_partial]_01    [Reconcile_partial]_02    [Reconcile_partial]_03
    ...    [Reconcile_partial]_04    [Reconcile_partial]_05    [Reconcile_partial]_06
    ...    report.label.owner:Cuong Pham
    [Setup]    Setup Test Case Scanning
    [Template]    Verify Inventory Reconcile To Inventory
    ${{['01003031017303032108400466291402|1725063010TB0015','01003031017303032108400466291402|1725063010TB0016']}}    2    The system not displays two lines for different lot number but the same expiry dates.
    ${{['01003031017303032103955221124050|1725063010TB0015','01003031017303032107882108800171|1725063010TB0015']}}    1    The system not counts and groups items by the same lot number and the same expiry dates..
    ${{['01003031017303032102289848041540|1725063010TB0015','01003031017303032102288848041539|1726063010TB0015']}}    2    The system not displays two lines for the same lot number and but the different expiry dates.
    ${{['01003502420512172110103982496801|17250831103DFTE130','01003502420512172110103982496802|17250831103DFTE131']}}    2    The system not displays two lines for the different lot number but the same RT expiry dates.
    ${{['01003502420512172110103982496803|17250831103DFTE132','01003502420512172110103982496810|17250831103DFTE132']}}    1    The system not counts and groups items by the same lot number and the same RT expiry dates..
    ${{['01003031017303032108400466291403|1725063010TB0017','01003031017303032108400466291403|1725063010TB0018']}}    2    The system not displays two lines for the same lot number and but the different RT expiry dates.

# Verify Inventory Reconcile To Inventory Non-Scan
#     [Documentation]    Verify Inventory Reconcile To Inventory
#     [Tags]    [Reconcile_partial]_07    [Reconcile_partial]_08    [Reconcile_partial]_09
#     ...    [Reconcile_partial]_10    [Reconcile_partial]_11    [Reconcile_partial]_12
#     ...    report.label.owner:Cuong Pham
#     [Setup]    Setup Test Case Scanning
#     [Template]    Verify Inventory Reconcile To Inventory Non Scan
#     ${{["NDUxMDA_","NDUwODM_"]}}    00310-1730-30    2    The system not displays two lines for different lot number but the same expiry dates.
#     ${{["NTkxODU_","NTkxODY_"]}}    00310-1730-30    1    The system not counts and groups items by the same lot number and the same expiry dates..
#     ${{["MzEwOTQ_","NTk0MjI_"]}}    00310-1730-30    2    The system not displays two lines for the same lot number and but the different expiry dates.

    
# Verify Inventory Reconcile To Inventory Non-Scan RT Items
#     [Documentation]    Verify Inventory Reconcile To Inventory
#     ...  report.label.owner:Cuong Pham
#     ...  report.label.severity:normal
#     ...  report.label.epic:Inventory Management
#     ...  report.label.feature:Inventory Reconcile
#     [Tags]    [Reconcile_]_10    [Reconcile_]_11    [Reconcile_]_12
#     [Setup]    Setup Test Case Scanning
#     [Template]    Verify Inventory Reconcile To Inventory Non Scan
#     ${{["NTk0MTY_","NTk0MTc_"]}}    50242-0051-21    2    The system not displays two lines for the different lot number but the same RT expiry dates.
#     ${{["NTk0MTg_","NTk0MjY_"]}}    50242-0051-21    1    The system not counts and groups items by the same lot number and the same RT expiry dates..
#     ${{["NTk0MTk_","NTk0MjY_"]}}    50242-0051-21    2    The system not displays two lines for the same lot number and but the different RT expiry dates.

*** Keywords ***
Verify Inventory Reconcile To Inventory Non Scan
    [Arguments]    ${list_lots}    ${ndc}    ${line_items_expected}    ${msg}
    Run Keyword And Ignore Error    Reset Assigned Products
    InventoryFilter.Search For Item #,NDC    ${ndc}
    FOR    ${lot}    IN    @{list_lots} 
        OpenActiveReconcile.Manually Add Products   ndc=${ndc}    qty=1    lot=${lot}    recently_ordered=${False}    view_favorites=${False}
    END
    Wait Until Page Does Not Contain Element    xpath=//*[@id="SubModalPopup" and @style="display: block;"]    timeout=10s
    Check UI The System Displays Lines    line_items_expected=${line_items_expected}    msg=${msg}

Verify Inventory Reconcile To Inventory
    [Arguments]    ${list_barcode}    ${line_items_expected}    ${msg}
    Run Keyword And Ignore Error    Reset Assigned Products
    Add Item By Scanning    list_barcode=${list_barcode}
    Check UI The System Displays Lines    line_items_expected=${line_items_expected}    msg=${msg}

Check UI The System Displays Lines
    [Arguments]    ${line_items_expected}    ${msg}
    ${line_items_actual}=    Get WebElements    xpath=//*[starts-with(@id, 'ReconcileLine_')]
    ${count_item_actual}=    Get Length    ${line_items_actual}
    Should Be Equal    ${count_item_actual}    ${${line_items_expected}}    ${msg}


Add Item By Scanning
    [Arguments]    ${list_barcode}
    FOR    ${barcode}    IN    @{list_barcode}
        Execute Async Javascript    var callback = arguments[arguments.length - 1];handleScan("${barcode}");setTimeout(()=>{callback()},6000);
    END

Test Case Teardown
    Open Active Reconcile.Cancel Reconcile

Set Up Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}
    Reset And Fill Empty Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]

Setup Test Case Scanning
    InventoryLevels.Go To Inventory Levels
    InventoryFilter.Select Location    ${data_input}[checked_location]
    InventoryFilter.Select Facility In Inventory    inventory_name=${data_input}[checked_facility]
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]    # robotcode: ignore
    OpenActiveReconcile.Select Type Reconcile    type=full

Suite Teardown
    SeleniumLibrary.Close Browser