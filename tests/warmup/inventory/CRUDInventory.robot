*** Settings ***
Documentation     Verify CRUD operations for inventory management.
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Set Up Suite
Test Setup    Test Set Up
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session



*** Test Cases ***
Verify Validate Create Inventory Empty Name
    [Documentation]    FB_01    Verify Validate Create Inventory Empty Name
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    Save Inventory
    Verify Create Inventory Empty Name
    Close Modal Create Inventory

Verify Create Inventory Track / Display Inventory Value
    [Documentation]    FB_03    Verify Create Inventory Track / Display Inventory Value
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    # ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    Input Description Inventory Name    ${InventoryName}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    [Teardown]    Remove Inventory Succeed    ${InventoryName}


Verify Create Inventory Default Inventory for Type
    [Documentation]    FB_04    Verify Create Inventory Default Inventory for Type
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:critical
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    ${InventoryProperties}=    Create List    DefaultFacilityType
    # ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    Input Description Inventory Name    ${InventoryName}
    Select Inventory Properties      ${InventoryProperties}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    [Teardown]    Remove Inventory Succeed    ${InventoryName}

Verify Create Inventory Is Pation Based Inventory
    [Documentation]    FB__05    Verify Create Inventory Track / Display Inventory Value
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    ${InventoryProperties}=    Create List    IsPatientBasedInventory
    # ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    Input Description Inventory Name    ${InventoryName}
    Select Inventory Properties    ${InventoryProperties}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    [Teardown]    Remove Inventory Succeed    ${InventoryName}

Verify Create Inventory Sort By Group
    [Documentation]    FB__06    Verify Create Inventory Track / Display Inventory Value
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    ${InventoryProperties}=    Create List    FacilityGroupNumber
    
    Input Description Inventory Name    ${InventoryName}
    Select Inventory Properties    ${InventoryProperties}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    [Teardown]    Remove Inventory Succeed    ${InventoryName}

Verify Create Inventory Inventory Type
    [Documentation]    FB__07    Verify Create Inventory Inventory Type
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Create Inventory
    ${InventoryProperties}=    Create List    FacilityType
    # ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    Input Description Inventory Name    ${InventoryName}
    Select Inventory Properties    ${InventoryProperties}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    [Teardown]    Remove Inventory Succeed    ${InventoryName}

Verify Update Inventory Success
    [Documentation]    FB__08    Verify Create Inventory Inventory Type
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Update Inventory
    # ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    ${InventoryProperties}=    Create List    IsPatientBasedInventory    FacilityGroupNumber    FacilityType    FacilityDescription    
    Input Description Inventory Name    ${InventoryName}
    CommonKeywords.Verify Location    AccountId    ${location}
    Created Inventory Succeed
    Select Inventory    ${InventoryName}
    Click Edit Inventory
    Input Description Inventory Name    ${InventoryNameUpdated}
    Select Inventory Properties    ${InventoryProperties}
    CommonKeywords.Verify Location    AccountId    ${location}
    Updated Inventory Succeed
    Select Inventory    ${InventoryNameUpdated}
    Click Edit Inventory
    Verify Update Inventory Success
    CommonKeywords.Verify Location    AccountId    ${location}
    [Teardown]    Click Remove Inventory

Verify Delete Inventory Success
    [Documentation]    FB__09    Verify Delete Inventory
    [Tags]        Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Tracking
    ...  report.label.story:Delete Inventory
    ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${InventoryName}=    Catenate    ${InventoryName}    ${current_date}
    Input Description Inventory Name    ${InventoryName}
    CommonKeywords.Verify Location    AccountId    ${location}
    Save Inventory
    Remove Inventory Succeed    ${InventoryName}

*** Keywords ***
Set Up Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${InventoryType}    ${data_input}[inventory_type]
    Set Suite Variable    ${GroupInventory}    ${data_input}[group_inventory]
    Set Suite Variable    $location    ${data_input}[checked_location]
    Set Suite Variable    ${inventoryNameUpdated}    ${data_input}[inventory_name_updated]
    Set Suite Variable    ${GroupInventoryUpdated}    ${data_input}[group_inventory_updated]
    ${current_date}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${InventoryName}=    Catenate    ${data_input}[inventory_name]    ${current_date}
    Set Suite Variable    ${InventoryName}

Created Inventory Succeed
    Save Inventory
    Wait Until Element Is Visible    //*[contains(text(),"Inventory Department Successfully Created")]    timeout=10s

Updated Inventory Succeed
    Save Inventory
    Wait Until Element Is Visible    //*[contains(text(),"Inventory Department Successfully Updated")]    timeout=10s

Remove Inventory Succeed
    [Arguments]    ${InventoryName}
    Wait Until Keyword Succeeds    5times    1    Select Inventory    ${InventoryName}
    Click Edit Inventory
    CommonKeywords.Verify Location    AccountId    ${location}
    Wait Until Keyword Succeeds    5times    1    Click Remove Inventory

Test Set Up
    Wait Until Keyword Succeeds    5times    1    InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${location}
    CommonKeywords.Verify Location    AccountId    ${location}
    Wait Until Keyword Succeeds    5times    1    Click Create Inventory