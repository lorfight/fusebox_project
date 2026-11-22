*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case 
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Accounting    inventory    Regression    IV_012

*** Test Cases ***
Go To Reconcile Inventory And Scan Barcode And Verify Function Unscanned Items As Lost 
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_88    [reconcile]_111    [Reconcile_partial]_36    [Reconcile_partial]_36.1   [Reconcile_partial]_37
    ...  report.label.owner:Quoc Nguyen
    OpenActiveReconcile.Reconcile Item full And Scan ${{['${data_input}[tracked_barcode]','${data_input}[losted_barcode]']}} Then Complete   
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full     ${{['${data_input}[tracked_barcode]']}} 
    OpenActiveReconcile.Select Checkbox Unscanned Items as Lost
    OpenActiveReconcile.Complete Reconcile
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    SerializedItemTracker.Open Serialized Item Tracker
    ${table_losted_item_value_dict}    SerializedItemTracker.Search Barcode Item In Tab Losted Item    ${data_input}[losted_barcode]
    Verify Value In Serialized Item Trackter    ${{[{'barcode': '${data_input}[losted_barcode]'}]}}        ${table_losted_item_value_dict}
    SerializedItemTracker.Open Tab Last Activity Item
    ${table_last_activity_value_dict}    SerializedItemTracker.Get Item Barcode Value By Table Tab Tracker         
    Verify Value In Serialized Item Trackter    ${{[{'barcode': '${data_input}[tracked_barcode]'}]}}    ${table_last_activity_value_dict}

Go To Reconcile Inventory And Scan Barcode And Verify Function Add Manual Product 
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_89    [reconcile]_90    [reconcile]_91    [reconcile]_92    [reconcile]_93
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full     ${{['${data_input}[tracked_barcode]']}} 
    ${expected_table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    ${random_qty}    Evaluate    random.randint(1,10)
    OpenActiveReconcile.Manually Add Products With Random Lot    ndc=${data_input}[ndc_manual]    qty=${random_qty}    recently_ordered=${False}    view_favorites=${False}
    OpenActiveReconcile.Reset to Only Scanned Products
    ${actual_table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    Normalize Table Value Dict To Compare After Reset    ${expected_table_value_dict}
    Normalize Table Value Dict To Compare After Reset    ${actual_table_value_dict}
    Should Be Equal    ${expected_table_value_dict}    ${actual_table_value_dict}
    OpenActiveReconcile.Cancel Reconcile

Go To Reconcile Inventory And Scan Barcode And Verify Function Preview Reconcile Changes
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_94    [reconcile]_97
    ...  report.label.owner:Quoc Nguyen
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full     ${{['${data_input}[tracked_barcode]']}} 
    OpenActiveReconcile.Click Preview Reconcile Changes
    Tab To Another Window    Report Viewer
    Close Window
    Tab To Another Window    Inventory Reconcile Ledger
    OpenActiveReconcile.Complete Reconcile

Go To Reconcile Inventory And Scan Barcode And Verify Function Request Approval
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_95
    ...  report.label.owner:Quoc Nguyen
    [Setup]   Setup Test Case And Disable Permission Reconcile
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ...    full     ${{['${data_input}[tracked_barcode]']}}
    OpenActiveReconcile.Request Approval Reconcile
    InventoryReconcile.Open Reconcile History By Id  ${reconcile_history_id}
    OpenActiveReconcile.Cancel Reconcile
    [Teardown]    Teardown Test Case And Enable Permission Reconcile

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}
Setup Test Case
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]

Setup Test Case And Disable Permission Reconcile
    Setup Test Case
    UserDetail.Go To User UserDetail
    UserDetail.Switch Tab    Permission
    Wait Until Keyword Succeeds    30s    1s    UserDetail.Unassigned Permission    Can complete a inventory reconcile.
    UserDetail.Save Button

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Test Case And Enable Permission Reconcile
    Teardown Test Case
    UserDetail.Go To User UserDetail
    UserDetail.Switch Tab    Permission
    Wait Until Keyword Succeeds    30s    1s    UserDetail.Assigned Permission    Can complete a inventory reconcile.
    UserDetail.Save Button

Teardown Suite
    Close Browser

Tab To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}

Verify Value In Serialized Item Trackter
    [Arguments]    ${expected_serialize_item_tracker_dict}    ${actual_serialize_item_tracker_dict}
    Verify Amount Item In Serialized Item Tracker    ${expected_serialize_item_tracker_dict}    ${actual_serialize_item_tracker_dict}
    Verify Data Item In Serialized Item Tracker    ${expected_serialize_item_tracker_dict}    ${actual_serialize_item_tracker_dict}

Verify Data Item In Serialized Item Tracker
    [Arguments]    ${expected_serialize_item_tracker_dict}    ${actual_serialize_item_tracker_dict}
    FOR    ${index}    ${item}    IN ENUMERATE    @{actual_serialize_item_tracker_dict}
        Should Be Equal    ${expected_serialize_item_tracker_dict}[${index}][barcode]    ${actual_serialize_item_tracker_dict}[${index}][barcode]
    END

Verify Amount Item In Serialized Item Tracker
    [Arguments]   ${expected_serialize_item_tracker_dict}    ${actual_serialize_item_tracker_dict}
    ${expected_length}    Get Length    ${expected_serialize_item_tracker_dict}
    ${actual_length}    Get Length    ${actual_serialize_item_tracker_dict}
    Should Be Equal    ${expected_length}    ${actual_length}

Normalize Table Value Dict To Compare After Reset
    [Arguments]    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        Remove From Dictionary    ${ndc_dict}    hard_count
    END