*** Settings ***
Documentation    Inventory Timezone 


Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Test Setup    Test Setup
Test Teardown    Close All Browsers
Test Tags    test:retry(1)    Admin    Accounting    Regression    inventory    IV_003

*** Variables ***
${first_row_create_date}    //*[contains(@class,'active')]//*[@id='ReconcileInventoryEnhanceList']//table//tbody/tr[1]/td[2]
${first_row_complete_date}    //*[contains(@class,'active')]//*[@id="ReconcileInventoryEnhanceList"]//table/tbody/tr[1]/td[9]

*** Test Cases ***
Verify Reconcile Time Zone
	[Documentation]   Inventory Reconcile Partial Time Zone 
    [Tags]    [Reconcile_partial]_42    [reconcile]_33
    ...    report.label.owner:Cuong Pham
    Change Time Zone    (UTC) Coordinated Universal Time
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${create_date_before}    Get Create Date
    Change Time Zone    (UTC+07:00) Bangkok, Hanoi, Jakarta
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${create_date_after}    Get Create Date
    Verify Create Date After Change Time Zone    create_date_after=${create_date_after}    create_date_before=${create_date_before}    diff_time_expected=7

Verify Reconcile Time Zone Not Config
	[Documentation]   Inventory Reconcile Partial Time Zone 
    [Tags]    [Reconcile_partial]_43    [reconcile]_34
    ...    report.label.owner:Cuong Pham    
    Change Time Zone    -- Select a Timezone --
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${create_date_before}    Get Create Date
    Change Time Zone    (UTC-06:00) Central Time (US & Canada)
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    ${create_date_after}    Get Create Date
    Verify Create Date After Change Time Zone    create_date_after=${create_date_after}    create_date_before=${create_date_before}    diff_time_expected=0

Verify Reconcile Line Completed / Canceled Date Column Has Timezone Set
    [Tags]    [reconcile]_42
    ...    report.label.owner:Cuong Pham    
    Change Time Zone    (UTC+07:00) Bangkok, Hanoi, Jakarta
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Open Active Reconcile
    Select Type Reconcile    type=full
    Click Button    Clear
    ${barcode}    Evaluate    random.choice(${ListBarcode})
    execute JavaScript    handleScan("${barcode}")
    ${actual_qty_on_hand_expect}    evaluate    random.choice(range(1, 10))
    Wait Until Page Contains Element    //*[@id="ReconcileLine_1"]    30s
    Input Text    id=ReconcileLine_1    ${actual_qty_on_hand_expect}
    Execute JavaScript    document.activeElement.blur()
    Wait Until Page Contains    Reconcile item updated!
    Wait Until Page Does Not Contain    Reconcile item updated!
    Complete Reconcile
    Verify Timezone Set

Verify Reconcile Line Completed / Canceled Date Column Has Timezone Doesn't Set
    [Tags]    [reconcile]_43
    ...    report.label.owner:Cuong Pham    
    Change Time Zone    -- Select a Timezone --
    Go To Inventory Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
    Open Active Reconcile
    Select Type Reconcile    type=full
    Click Button    Clear
    ${barcode}    Evaluate    random.choice(${ListBarcode})
    execute JavaScript    handleScan("${barcode}")
    ${actual_qty_on_hand_expect}    evaluate    random.choice(range(1, 10))
    Wait Until Page Contains Element    //*[@id="ReconcileLine_1"]    30s
    Input Text    id=ReconcileLine_1    ${actual_qty_on_hand_expect}
    Execute JavaScript    document.activeElement.blur()
    Wait Until Page Contains    Reconcile item updated!
    Wait Until Page Does Not Contain    Reconcile item updated!
    Complete Reconcile
    Verify Timezone Doesn't Set   

*** Keywords ***
Test Setup
    [Documentation]   Open the browser and navigate to the application
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    
Change Time Zone
    [Arguments]    ${TimeZone}
    MyAccount.Go To My Account
    MyAccount.Config Location Time Zone    ${TimeZone}
    MyAccount.Save Change
    
Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	Wait Until Keyword Succeeds    3times    1    InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryFilter.Select Facility In Inventory    ${checked_facility}

Get Create Date
    # ${create_date}    Get Text    //*[contains(@class,'active')]//*[@id='ReconcileInventoryList']/div[4]/table/tbody/tr[1]/td[1]/strong
    ${create_date}    Get Text    ${first_row_create_date}
    RETURN    ${create_date}

Verify Create Date After Change Time Zone
    [Arguments]    ${create_date_after}    ${create_date_before}    ${diff_time_expected}
    ${after}=    Convert Date    ${create_date_after}    date_format=%m/%d/%Y at %I:%M %p
    ${before}=   Convert Date    ${create_date_before}   date_format=%m/%d/%Y at %I:%M %p
    ${time_between}    Subtract Date From Date    ${after}    ${before}
    ${time_between}   Evaluate    ${time_between}/3600
    Should Be Equal As Numbers    ${time_between}     ${diff_time_expected}

Verify Timezone Set
    Log To Console    message=Verify Timezone Set
    ${ui_time}    Get Text    ${first_row_complete_date}
    ${parsed}=    Convert Date    ${ui_time}    date_format=%m/%d/%Y at %I:%M %p
    ${expected}=  Get Current Date    result_format=%Y-%m-%d %H:%M    time_zone=UTC    increment=+7 hours
    Should Be Equal As Strings    ${parsed[:16]}    ${expected}

Verify Timezone Doesn't Set
    Log To Console    message=Verify Timezone Doesn't Set
    ${ui_time}    Get Text    ${first_row_complete_date}
    ${parsed}=    Convert Date    ${ui_time}    date_format=%m/%d/%Y at %I:%M %p
    ${expected}=  Get Current Date    result_format=%Y-%m-%d %H:%M    time_zone=UTC    increment=-5 hours
    Should Be Equal As Strings    ${parsed[:16]}    ${expected}