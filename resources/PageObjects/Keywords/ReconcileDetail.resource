*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library         Collections
Library    ../../../libraries/CustomLibrary.py
Library    OperatingSystem
Library    String

Variables    ../Locators/ReconcileLocator.py
Variables    ../Locators/CommonLocator.py
Variables    ../TestData/Testdata.py

Resource    ../../../libraries/Util.resource
*** Variables ***
${select_location}    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]

*** Keywords ***
Verify Go Inventory Reconcile
    Title Should Be    Inventory Reconcile Ledger
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[contains(text(),"Inventory Reconciliation")]    timeout=20s

Select Type Reconcile
    [Arguments]    ${type}
    Wait Until Page Does Not Contain Element    //*[@id="ReconciledItemsTable"]/i     timeout=30s
    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[contains(text(),"Inventory Reconciliation")]    timeout=20s
    ${ReconcileType}=    Replace Variables    ${ReconcileType}
    Wait Until Element Is Enabled    ${ReconcileType}
    Wait Until Element Is Not Visible    //*[@id="ReconciledItemsTable"]/i    timeout=20s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${ReconcileType}

Select Inventory
    [Arguments]    ${inventory_name}
    Wait Until Element Is Enabled    //a[contains(text(),"${inventory_name}")]
    Wait Until Keyword Succeeds    2times    1    Scroll Element Into View    //a[contains(text(),"${inventory_name}")]
    Wait Until Keyword Succeeds    5s    1s     Click Element    //a[contains(text(),"${inventory_name}")]

# Scan Barcode Reconcile
#     [Arguments]    ${ListBarcode}
#     ${barcode_count}    Get Length    ${ListBarcode}
#     ${orig_timeout}    Set Selenium Timeout    180 seconds
#     Execute Async Javascript
#     ...    var callback = arguments[arguments.length - 1]; var a = ${ListBarcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 120000);
#     Set Selenium Timeout    ${orig_timeout}
#     Run Keyword And Ignore Error    Wait Until Page Contains Element    //*[@id="ScanNotification" and text()="${barcode_count}"]    timeout=120s

Scan Barcode Reconcile
    [Arguments]    ${ListBarcode}
    ${barcode_count}    Get Length    ${ListBarcode}
    Execute Javascript
    ...    var raw = arguments[0];
    ...    var items = typeof raw === 'string' ? JSON.parse(raw.replace(/'/g,'"')) : raw;
    ...    scanProcessing = true;
    ...    items.forEach(function(x) { queue.push(x); });
    ...    scanProcessing = false;
    ...    ProcessQueue();
    ...    ARGUMENTS    ${ListBarcode}
    Wait Until Page Contains Element    //*[@id="ScanNotification" and text()="${barcode_count}"]    timeout=120s 


Complete Reconcile
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Click Complete Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    ${explain_modal}    Run Keyword And Return Status     Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s
    Run Keyword If    '${explain_modal}' == 'True'    Save Complete Reconcile
    ...    ELSE IF    '${explain_modal}' == 'False'
    ...    Log    Modal did not appear. Continuing without saving.
    ...    ELSE
    ...    Fail    Unexpected value '${explain_modal}' returned.
    Wait Until Page Contains Element     ${open_active_reconcile}    timeout=60s    error=Loading Available Reconciles Failed

Request Approval Reconcile
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Click Request Approval Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    ${explain_modal}    Run Keyword And Return Status     Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s
    Run Keyword If    '${explain_modal}' == 'True'    Save Complete Reconcile
    ...    ELSE IF    '${explain_modal}' == 'False'
    ...    Log    Modal did not appear. Continuing without saving.
    ...    ELSE
    ...    Fail    Unexpected value '${explain_modal}' returned.
    Wait Until Page Contains Element     ${open_active_reconcile}    timeout=60s    error=Loading Available Reconciles Failed

Click Complete Reconcile
    Util.Scroll To Bottom
    Click Element    //*[contains(@class,"active")]//*[@id='CompleteReconcile']

Click Request Approval Reconcile
    Util.Scroll To Bottom
    ${request_approval_onclick}    SeleniumLibrary.Get Element Attribute    //*[contains(@class,"active")]//*[text()='Request Approval ']    onclick
    execute javascript    ${request_approval_onclick}

Save Complete Reconcile
    Wait Until Element Is Enabled    ${SaveCompleteReconcileBtn}    timeout=10s
    Wait Until Keyword Succeeds    5s    1     Click Element    ${SaveCompleteReconcileBtn}
    Wait Until Page Does Not Contain    Reconcile Processing    timeout=120s
    Wait Until Page Contains Element     ${open_active_reconcile}    timeout=30s    error=Loading Complete Reconcile Failed

Get Reconcile History id
    ${reconcile_history_id}=    SeleniumLibrary.Get Element Attribute    ${ReconcileInventoryIdXpath}    value
    Run Keyword And Ignore Error     Set Test Variable    ${reconcile_history_id}

Open Reconcile History By Id
    [Arguments]    ${reconcile_history_id}
    Wait Until Page Contains Element    ${open_active_reconcile}    timeout=15s
    ${account_id}    Get Selected List Value    locator=${select_location}
    ${faclility_id}    Get Value    id=SearchCriteria_FacilityID
    Execute Javascript    LoadInventoryReconcileEnhance('${reconcile_history_id}','${account_id}','${faclility_id}')
    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=30s

Open Reconcile History By Id For Cancel
    [Arguments]    ${reconcile_history_id}
    Wait Until Page Contains Element    ${open_active_reconcile}    timeout=30s
    ${account_id}    Get Selected List Value    locator=${select_location}
    ${faclility_id}    Get Value    id=SearchCriteria_FacilityID
    Execute Javascript    LoadInventoryReconcileEnhance('${reconcile_history_id}','${account_id}','${faclility_id}')
    Wait Until Page Contains   text=This Inventory Reconcile has been Canceled.    timeout=20s

Manually Add Products
    [Arguments]    ${ndc}    ${qty}    ${lot}    ${recently_ordered}    ${view_favorites}
    Wait Until Keyword Succeeds    3 times    1    Open Manually Add Products
    Wait Until Element Is Visible    ${SearchAssignProductInput}
    Run Keyword If    ${view_favorites} == ${True}    Select Checkbox    viewFavorites
    Run Keyword If    ${recently_ordered} == ${True}    Select Checkbox    viewHistory
    Input Text    ${SearchAssignProductInput}    ${ndc}
    SeleniumLibrary.Click Button    ${SearchAssignProductBtn}
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]
    Select From List By Value    //*[@id="item_LotNumber"]    ${lot}
    Input Text    ${AddingQtyInput}    ${qty}
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}

Open Manually Add Products
    Util.Scroll To Bottom
    Wait Until Element Is Enabled     ${ManualAddProductsBtn}   timeout=10s
    Execute Javascript    InventoryReconcileManuallyAddProduct();
Cancel Reconcile
    Wait Until Element Is Visible     ${CancelReconcileBtn}    timeout=30s
    Util.Scroll To Bottom
    ${cancel_reconcile_onclick}    SeleniumLibrary.Get Element Attribute    ${CancelReconcileBtn}    onclick
    Execute Javascript    ${cancel_reconcile_onclick}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text

Back To List
    Wait Until Element Is Enabled    ${BackToListBtn}
    Click Element    ${BackToListBtn}
    Wait Until Element Is Not Visible    ${BackToListBtn}    timeout=10s


Reset Assigned Products
    Util.Scroll Into View    locator="//*[contains(@class,'active')]//*[contains(text(),'Reset Assigned Products')]"
    Click Element    //*[contains(@class,"active")]//*[contains(text(),"Reset Assigned Products")]
    Wait Until Keyword Succeeds    5 times    1    Handle Alert And Return Its Text
    # Wait Until Element Is Visible    //*[contains(@placeholder,"?")]        timeout=10s

Fill Empty Reconcile
    Util.Scroll Into View    locator="//*[contains(@class,'active')]//*[contains(text(),'Fill Empty Cells with Zero')]"
    Click Element   ${FillEmptyCellBtn}
    Wait Until Page Contains    Reconcile item updated!    timeout=5s

Get NDC From Reconcile Table
    Wait Until Element Is Enabled    ${ReconcileTableXpath}
    ${html_table}=    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${ndcs}=   Get Ndc From Html Table    ${html_table}    screen=reconciled_table
    ${ndcs}=    Convert To List    ${ndcs}
    RETURN    ${ndcs}

Search NDC In Reconcile Table
    [Arguments]    ${ndc}
    Input Text    ${SearchInput}    ${ndc}
    Click Button    Find
    Wait Until Element Is Not Visible    //*[@id="inv-loading-indicator"]    timeout=15s

Go Into Complete Log
    [Arguments]    ${reconcile_history_id}
    ${CompleteLogBtn}=    Replace Variables    ${CompleteLogBtn}
    Click Element    ${CompleteLogBtn}

Reset And Fill Empty
    Wait Until Keyword Succeeds    3times    1    Reset Assigned Products
    Wait Until Keyword Succeeds    3times    1    Fill Empty Reconcile
    Get Reconcile History id
    Wait Until Page Does Not Contain    Reconcile item updated!    timeout=10s
    Complete Reconcile

Reconcile Item ${type} And ${scan_type} Barcode Then ${complete} Complete
    Verify Go Inventory Reconcile
    Sleep    2s
    # Click Button    Clear
    Select Type Reconcile    ${type}
    Get Reconcile History id
    Run Keyword If    '${scan_type}' == 'handle'
    ...    Util.Handle Scan Barcode Reconcile    barcode=${barcode}
    ...  ELSE
    ...    Scan Barcode Reconcile    ${list_barcode}
    Run Keyword If    '${complete}' == 'do'
    ...    Wait Until Keyword Succeeds    2 times    1    Complete Reconcile

View All Item
    Wait Until Element Is Enabled    link:View All Items
    CLick Element    link:View All Items
    Wait Until Element Is Visible    //table[contains(@id,"DuplicateReconcileItemTable")]

Select Checkbox Unscanned Items as Lost
    Wait Until Element Is Visible    ${UnscannedItemsAsLostCheck}    timeout=10s
    Util.Scroll To Bottom
    Select Checkbox    ${UnscannedItemsAsLostCheck}

# ------------------- VERIFY ---------------------------
# ------------------------------------------------------

Verify Reconcile Successfully
    [Arguments]    ${reconcile_history_id}
    Open Reconcile History By Id    ${reconcile_history_id}
    Util.Scroll To Top
    Wait Until Element Is Visible    ${StatusReconcile}    timeout=10s
    ${status_reconcile}=    SeleniumLibrary.Get Text    ${StatusReconcile}
    Should Be Equal    ${status_reconcile}    Complete

Verify Reconcile Cancel
    [Arguments]    ${reconcile_history_id}
    Open Reconcile History By Id For Cancel    ${reconcile_history_id}
    Util.Scroll To Top
    ${status_reconcile}=    SeleniumLibrary.Get Text    ${StatusReconcile}
    Should Be Equal    ${status_reconcile}    Canceled

Verify Type Reconcile Is
    [Arguments]    ${type}
    Util.Scroll To Top
    ${ReconcileType}=    Replace Variables    ${ReconcileType}
    ${actual}=    SeleniumLibrary.Get Element Attribute    ${ReconcileType}    checked
    Should Be Equal    ${actual}    true

Verify Barcode Scan Successfully
    [Arguments]    ${list_barcode}
    ${html_table}=    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${count}=    Get WebElements    xpath=//*[starts-with(@id, 'ReconcileLine_')]
    ${empty_dictionary}=    Create Dictionary
    FOR    ${var}    IN    @{count}
        ${reconcileIdTable}=    SeleniumLibrary.Get Element Attribute    ${var}    id
        ${reconcile_value_table}=    SeleniumLibrary.Get Element Attribute    ${var}    value
        Set To Dictionary    ${empty_dictionary}    ${reconcile_id_table}=${reconcile_value_table}
    END
    ${actual}=    Get Data From Html Table    ${html_table}    ${empty_dictionary}
    ${expect}=    Parse Barcode Scanned    ${list_barcode}
    Should Be Equal    ${actual}    ${expect}

Verify Search NDC
    [Arguments]    ${ndcs}
    ${random_ndc}=    Evaluate    random.sample(${ndcs},3)
    FOR    ${ndc}    IN    @{random_ndc}
        Search NDC In Reconcile Table    ${ndc}
        Sleep    2
        ${ndcs_searched}    Get NDC From Reconcile Table
        FOR    ${ndc_searched}    IN    @{ndcs_searched}
            Should Be Equal    ${ndc_searched}    ${ndc}
        END
        Sleep    1
    END

Verify Complete Log SuccessFully
    [Arguments]    ${reconcile_history_id}
    Wait Until Element Is Visible    ${ReconcileTableXpath}
    ${html_table_reconcile}=    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${table_reconile}=   get_data_from_html_table_reconciled    ${html_table_reconcile}
    Go Into Complete Log    ${reconcile_history_id}
    ${export_path}=    Download Report CSV SuccessFully    ManualInventoryCheck.csv
    ${completion_log}=    Convert File Csv Complete Log    ${export_path}
    Should Be Equal     ${table_reconile}    ${completion_log}

Verify Manually Add Products
    [Arguments]    ${ndc}    ${qty}    ${lot}
    Manually Add Products    ndc=${ndc}    qty=${qty}    lot=${lot}    recently_ordered=False    view_favorites=False
    Wait Until Page Contains    Successfully Added to Patient Reservoir!    timeout=10s    error=Manual add not success

Verify Dispensed and Received and Other Change In Reconcile Table
    [Arguments]    ${ndc}    ${dispense_qty}=0    ${received_qty}=0    ${other_change_qty}=0    ${last_qty_on_hand}=0
    Search NDC In Reconcile Table    ${ndc}
    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    ${table}    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${actual}    Get Data From Html Table Reconciled Test    ${table}
    ${expect}    Create Dictionary
    ...    Dispensed=${-${dispense_qty}}
    ...    Received=${${received_qty}}
    ...    Other Changes=${-${other_change_qty}}
    ...    Expected Qty On Hand=${${last_qty_on_hand}-${dispense_qty}+${received_qty}-${other_change_qty}}
    ...    Last Qty On Hand=${${last_qty_on_hand}}
    Should Be Equal     ${actual}    ${expect}

Verify In View Item
    [Arguments]    ${ndc}    ${dispense_qty}=0    ${received_qty}=0    ${other_change_qty}=0
    Search NDC In Reconcile Table    ${ndc}
    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Wait Until Keyword Succeeds    3times    1    Click Element    link:View All Items
    ${expected_quantity_on_hand}    Evaluate    ${received_qty}-${dispense_qty}-${other_change_qty}

Verify Back To List Succeeds
    Element Should Not Be Visible    ${BackToListBtn}