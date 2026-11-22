*** Settings ***
Documentation      Verify the functionality of inventory transferring, including internal transfers with and without scanning.

Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource   
Resource   ../../../resources/PageObjects/Keywords/InventoryTransfer.resource
Resource   ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource   ../../../resources/PageObjects/Keywords/Receiving.resource
Resource   ../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Suite Setup
Test Setup    Setup Test Case
Test Teardown    Close Browser

Test Tags	TR_100
*** Test Cases **
# Verify Transfer (Non-scan) - Internal Transfer  
# 	[Documentation]   Verify Create Transfer - Check Inventory
# 	...    TC: [IN-I001]_TC08, [IN-I001]_TC09
# 	[Tags]    Admin    Smoke    transfer    test:retry(2)
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:Transfer Receive
#     ...  report.label.story:Transfer (Non-scan)
# 	Set Test Variable    ${transfer_method}    ${EMPTY}
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level
# 	...    checked_location=${data_input}[checked_location]
# 	...    from_facility=${data_input}[from_facility]
# 	...    to_facility=${data_input}[to_facility]
# 	...    ndc=${data_input}[ndc]
#     InventoryTransfer.Create Transfer
# 	...    from_account=${data_input}[checked_location]
#     ...    to_account=${data_input}[checked_location]
# 	...    from_facility=${data_input}[from_facility]
# 	...    to_facility=${data_input}[to_facility]
# 	...    transfer_type=internal
#     InventoryLevel.Check Inventory Level After Transfer
# 	...    checked_location=${data_input}[checked_location]
# 	...    from_facility=${data_input}[from_facility]
# 	...    to_facility=${data_input}[to_facility]
# 	...    ndc=${data_input}[ndc]

Verify Transfer (Scan) - Internal Transfer
    [Documentation]   Verify Create Transfer - Check Inventory
	...    TC: [IN-I002]_TC05, [IN-I002]_TC06
	[Tags]    Admin    Smoke    transfer    test:retry(2)
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Transfer
    ...  report.label.feature:Transfer Receive
    ...  report.label.story:Transfer (Scan)  
	Set Test Variable    ${transfer_method}    scan
	InventoryLevel.Go Inventory Level    
	InventoryLevel.Check Inventory Level
	...    checked_location=${data_input}[checked_location]
	...    from_facility=${data_input}[from_facility]
	...    to_facility=${data_input}[to_facility]
	...    ndc=${data_input}[ndc]
    InventoryTransfer.Create Transfer
	...    from_account=${data_input}[checked_location]
    ...    to_account=${data_input}[checked_location]
	...    from_facility=${data_input}[from_facility]
	...    to_facility=${data_input}[to_facility]
	...    transfer_type=internal
    InventoryLevel.Check Inventory Level After Transfer
	...    checked_location=${data_input}[checked_location]
	...    from_facility=${data_input}[from_facility]
	...    to_facility=${data_input}[to_facility]
	...    ndc=${data_input}[ndc]
	
# Verify Transfer (Non-scan) - External Transfer  
# 	[Documentation]   Verify Create Transfer - Check Inventory
# 	...    TC: [IN-I001]_TC08, [IN-I001]_TC09
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Transfer (Non-scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_type}    external
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
#     InventoryLevel.Check Inventory Level After Transfer

# Verify Transfer (Scan) - External Transfer  
# 	[Documentation]   Verify Create Transfer - Check Inventory
# 	...    TC: [IN-I001]_TC08, [IN-I001]_TC09
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Transfer (Scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_method}    scan    
# 	Set Test Variable    ${transfer_type}    external
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
#     InventoryLevel.Check Inventory Level After Transfer
# Verify Transfer (Non-scan) - Receive Full (Non-scan) - External Transfer 
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Full (Non-scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_type}    external
# 	Set Test Variable    ${receive_required}    yes
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer

# Verify Transfer (Non-scan) - Receive Partial (Non-scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Partial (Non-scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_type}    external
# 	Set Test Variable    ${receive_type}    partial
# 	Set Test Variable    ${receive_required}    yes
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer
	
# Verify Transfer (Scan) - Receive Full (Scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Full (Scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_method}    scan    
# 	Set Test Variable    ${transfer_type}    external
# 	Set Test Variable    ${receive_required}    yes
# 	Set Test Variable    ${receive_method}    scan
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer

# Verify Transfer (Scan) - Receive Partial (Scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Partial (Scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Test Variable    ${transfer_method}    scan    
# 	Set Test Variable    ${transfer_type}    external
# 	Set Test Variable    ${receive_type}    partial
# 	Set Test Variable    ${receive_required}    yes
# 	Set Test Variable    ${receive_method}    scan
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer	

# Verify Transfer (Scan) - Receive Full (Non-scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Full (Non-scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Suite Variable    ${transfer_method}    scan    
# 	Set Suite Variable    ${transfer_type}    external
# 	Set Suite Variable    ${receive_required}    yes
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer

# Verify Transfer (Scan) - Receive Partial (Non-scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Partial (Non-scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Suite Variable    ${transfer_method}    scan    
# 	Set Suite Variable    ${transfer_type}    external
# 	Set Suite Variable    ${receive_type}    partial
# 	Set Suite Variable    ${receive_required}    yes
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer

# Verify Transfer (Non-scan) - Receive Full (Scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Full (Scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Suite Variable    ${transfer_type}    external
# 	Set Suite Variable    ${receive_required}    yes
# 	Set Suite Variable    ${receive_method}    scan
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer	
# Verify Transfer (Non-scan) - Receive Partial (Scan) - External Transfer
#     [Documentation]   Verify Create Transfer - Receive - Check Inventory
# 	...    TC: 
# 	[Tags]    Smoke    Regression    Transfer
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Transfer
#     ...  report.label.feature:External Transfer
#     ...  report.label.story:Receive Partial (Scan)
#     ${NDC}    Set Variable		${NDCItem}
# 	Set Suite Variable    ${transfer_type}    external
# 	Set Suite Variable    ${receive_type}    partial
# 	Set Suite Variable    ${receive_required}    yes
# 	Set Suite Variable    ${receive_method}    scan
# 	Maximize Browser Window
# 	Sleep    3s
# 	InventoryLevel.Go Inventory Level    
# 	InventoryLevel.Check Inventory Level    
#     InventoryTransfer.Create Transfer
# 	...    from_account=${LocationInventory}    
#     ...    to_account=${ToLocationInventory_Receive}    
# 	...    from_facility=${FromFacility}
# 	...    to_facility=${ToFacility}
# 	...    transfer_type=external
# 	InventoryTransfer.Receive Transfer
#     InventoryLevel.Check Inventory Level After Transfer



*** Keywords ***
Suite Setup
    ${data_input}    Get Data
	Set Suite Variable    ${data_input}
	Set Suite Variable    ${uom}    ${data_input}[uom]
	Set Suite Variable    ${ndc}    ${data_input}[ndc]
	Set Suite Variable    ${Lot}    ${data_input}[lot]
	Set Suite Variable    ${exp_date}    ${data_input}[exp_date]
	Set Suite Variable    ${contract_no}    ${data_input}[contract_no]
	Set Suite Variable    ${QtyAssign}    6
	# Set Suite Variable    $checked_location    ${data_input}[checked_location]
	# Set Suite Variable    $to_facility    ${data_input}[to_facility]
	# Set Suite Variable    $from_facility    ${data_input}[from_facility]
	Set Selenium Speed    0.1s

Setup Test Case
    Login To Fusebox    ${Username}    ${Password}
