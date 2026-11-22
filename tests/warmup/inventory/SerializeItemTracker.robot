*** Settings ***
Documentation      Verify the functionality of the Serialize Item Tracker, including pagination, search, and pricing.
# Library    SeleniumLibrary    plugins=${EXECDIR}/libraries/AllureSeleniumPlugin.py    run_on_failure=Capture Page Screenshot
Variables  ../../../resources/PageObjects/TestData/Testdata.py
Resource   ../../../resources/PageObjects/Keywords/SerializeItemTrackerKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource


Suite Setup    Set Up Suite
Test Setup    Test Set Up Serialize
Test Teardown    Sleep    3s
Suite Teardown    Suite Teardown




*** Test Cases ***
Verify Pagination Serialize Item tracker
    [Documentation]    FB_01    Verify Pagination Serialize Item tracker
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Pagination
    Verify Pagination Serialize Item tracker

Verify Serialize Item tracker Search For A Medication
    [Documentation]    FB_02    Verify Serialize Item tracker Search For A Medication Tab LastActivityAccountList 
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Search For
    TRY
        ${list_medication}=    Get Medication From Table Serialize
        Verify Search By Medication    ${list_medication}
    FINALLY
        Close Serialize Item Tracker
        Verify Close Serialize Item Tracker Successfully
    END
    
Verify Serialize Item tracker Search For A Barcode
    [Documentation]    FB_03    Verify Serialize Item tracker Search For A Barcode Tab LastActivityAccountList 
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Search For
    ${screen}    Set Variable    LastActivityAccountList
    TRY
        ${list_barcode}=    Get Barcode From Table Serialize
        Verify Search By Barcode    ${list_barcode}
    FINALLY
        Close Serialize Item Tracker
        Verify Close Serialize Item Tracker Successfully
    END
    
Verify Pricing Serialize Item Tracker
    [Documentation]    FB_04    Verify Pricing Serialize Tracker Item Sort By
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Sort By
        ${sort_by}=    Sort Serialize Item By    Pricing
    TRY
        Wait Until Keyword Succeeds    3times    1    Go Tab Pricing Item
        Verify Sort Pricing Serialize Item by     ${sort_by}
    FINALLY
        Close Serialize Item Tracker
        Verify Close Serialize Item Tracker Successfully
    END

Verify Lost Item Serialize Item Tracker
    [Documentation]    FB_07    Verify Lost Item Serialize Item Tracker
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Lost Item
    Wait Until Keyword Succeeds    3times    1    Go Tab Lost Item
    Verify Tab Lost Item Tracker Successfully
    Close Serialize Item Tracker
    Verify Close Serialize Item Tracker Successfully

Verify Close Modal Serialize Item Tracker
    [Documentation]    FB_08    Verify Close Modal Serialize Item Tracker
    [Tags]    Admin        Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Serialize Item tracker
    ...  report.label.story:Close Modal
    Sleep    2
    Close Serialize Item Tracker
    Verify Close Serialize Item Tracker Successfully

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    ${list_barcode}    Evaluate    random.sample(${ListBarcode},40)
    Set Suite Variable    ${checked_location}    ${data_input}[checked_location]
    Set Suite Variable    $list_barcode
    Set Suite Variable    $checked_facility    ${data_input}[checked_facility]
    Login To Fusebox    ${Username}    ${Password}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    Reconcile Item full And scan Barcode Then do Complete

Suite Teardown
    CommonKeywords.Close Browser Session

Reset And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    Select Type Reconcile    full
    Reset And Fill Empty

Test Set Up Serialize
    InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    inventory_name=${checked_facility}
    Wait Until Keyword Succeeds    3times    1    SerializeItemTrackerKeywords.Open Serialize Item Tracker

Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    Open Active Reconcile