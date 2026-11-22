*** Settings ***
Resource    ./OpenActiveReconcile/OpenActiveReconcile.resource

*** Keywords ***
Go Inventory Reconcile
    Click Element    link:Inventory
    Click Element    link:Inventory Reconcile
    Title Should Be    Inventory Reconcile Ledger

Click On Available Backstock
    Wait Until Page Contains Element    //*[@id="viewInventoryBackstock"]    timeout=20s
    ${available_backstock_inventory_onclick}    SeleniumLibrary.Get Element Attribute    //*[@id="viewInventoryBackstock"]    onclick
    Execute JavaScript    ${available_backstock_inventory_onclick}
    Waiting For Loading

Open Reconcile History By Id
    [Arguments]    ${reconcile_history_id}
    Wait Until Page Contains Element    ${open_active_reconcile}    timeout=15s
    ${account_id}    Get Selected List Value    locator=${select_location}
    ${faclility_id}    Get Value    id=SearchCriteria_FacilityID
    Execute Javascript    LoadInventoryReconcileEnhance('${reconcile_history_id}','${account_id}','${faclility_id}')
    Waiting For Loading

# Inventory Reconcile Flows
Go To Inventory Reconcile And Select Location And Facility
    [Documentation]    Go to Inventory Reconcile page and select location and facility
    [Arguments]    ${checked_location}    ${checked_facility}
	Go Inventory Reconcile
    InventoryFilter.Select Location    ${checked_location}
    InventoryFilter.Select Facility In Inventory    ${checked_facility}
    Open Active Reconcile
    Waiting For Loading

Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning
    [Arguments]    ${checked_location}    ${checked_facility}    ${type}    ${barcodes}
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    OpenActiveReconcile.Select Type Reconcile    ${type}
    OpenActiveReconcile.Get Reconcile History id
    InventoryUtils.Scan List Barcode    ${barcodes}

Go To Inventory Reconcile And Select Location And Facility Then Reset Reconcile and Add Item By Scanning
    [Arguments]    ${checked_location}    ${checked_facility}    ${type}    ${barcodes}
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    OpenActiveReconcile.Select Type Reconcile    type=${type}
    OpenActiveReconcile.Get Reconcile History id
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(@class,'active')]//*[@id='ReconciledItemsTable']/div/table    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    OpenActiveReconcile.Reset And Fill Empty But Not Complete
    InventoryUtils.Scan List Barcode    ${barcodes}

Go To Inventory Reconcile And Reset Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    ${is_contain_type_full}    Run Keyword and Return Status    Wait Until Page Contains Element    //*[@data-type='full']    timeout=10s
    IF    ${is_contain_type_full}==${True}
        OpenActiveReconcile.Select Type Reconcile    type=full
    END
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(@class,'active')]//*[@id='ReconciledItemsTable']/div/table    timeout=5s
    Run Keyword If    $reset_conditional == ${True}
    ...    Check Reconcile Table Contains Scanned Items

Go To Inventory Reconcile And Adjust All Item In Current Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    ${type}    
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    OpenActiveReconcile.Select Type Reconcile    ${type}
    OpenActiveReconcile.Get Reconcile History id
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Adjust Actual Qty On Hand All Items In Table Reconcile Not Equal Expect Qty    ${table_value_dict}

Check Reconcile Table Contains Scanned Items
    Wait Until Keyword Succeeds    3times    1    OpenActiveReconcile.Reset Assigned Products
    ${contains_item_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="ReconciledItemsTable"]/div/strong    timeout=10s
    IF    $contains_item_conditional
        OpenActiveReconcile.Cancel Reconcile
    ELSE
        OpenActiveReconcile.Reset And Fill Empty
    END

Reset And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile And Select Location And Facility    ${checked_location}    ${checked_facility}
    OpenActiveReconcile.Select Type Reconcile    type=full
    ${is_clear_button_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    ${clear_inventory}    timeout=10s
    IF    ${is_clear_button_visible}==${True}
        Clear Search
    END
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(@class,'active')]//*[@id='ReconciledItemsTable']/div/table    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Reset And Fill Empty