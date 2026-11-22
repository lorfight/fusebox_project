*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    String
Library    Dialogs
Library    ../../../libraries/CustomLibrary.py
Variables    ../Locators/InventoryLocator.py
Variables    ../Locators/CommonLocator.py
Resource    ../../../libraries/Util.resource

*** Variables ***
${inventory_adjustment_close_btn}    (//*[@id="CloseBtn"])[2]

*** Keywords ***
# Behavior
Go Inventory Level
    Wait Until Keyword Succeeds    15s    1s    Click Element    ${InventoryLink}    #10s
    Click Element    ${InventoryLevelsLink}
    Title Should Be    Inventory Levels & Transactions
    

Select location
    [Arguments]    ${checked_location}
    # Wait Until Keyword Succeeds    10times    1s    Util.Verify Loading And Select By Label    AccountId    ${checked_location}
    Wait Until Element Is Enabled    id=AccountId
    Select From List By Label    id=AccountId    ${checked_location}
    Wait Until Element Is Not Visible    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i
Get Facility Name 
    [Arguments]    ${Facility}   
    ${Facility}    Fetch From Left    ${Facility}    \ (
    RETURN    ${Facility}

Select Inventory
    [Arguments]    ${inventory_name}
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=30s
    ${SelectInventory}=    Replace Variables    ${SelectInventory}
    # Sleep    5s
    Wait Until Element Is Enabled    ${SelectInventory}
    Scroll Element Into View    ${SelectInventory}
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${SelectInventory}
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=30s

Find Inventory With NDCItem
    [Arguments]    ${NDCItem}
    Input Text    //*[@id="SearchValues"]    ${NDCItem}
    Wait Until Keyword Succeeds    10s    1s    Click Button    //*[@id="FindButton"]


Select Inventory Tab With NDCItem
    [Arguments]    ${Facility}    ${NDCItem}
    Select Inventory    ${Facility}
    Find Inventory With NDCItem    ${NDCItem}

Select Show Empty Inventory
    Util.Scroll Into View    "//*[contains(@class,'tab-pane') and contains(@class,'active')]//text()[contains(.,'Show Empty Inventory') and not(contains(.,'Buckets'))]/preceding-sibling::input[contains(@class,'showEmpty')]"    block=start
    Wait Until Keyword Succeeds    10s    1s    Select Checkbox    //*[contains(@class,"tab-pane") and contains(@class,"active")]//text()[contains(.,"Show Empty Inventory") and not(contains(.,"Buckets"))]/preceding-sibling::input[contains(@class,"showEmpty")]
    Wait Until Element Is Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//tr[@class="BlackBorder success" or @class= "BlackBorder default" or @class="BlackBorder danger"][1]    10s    

Try Click Active Lots
    Wait Until Element Is Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom}")]/following-sibling::div/a[@href="#" and contains(text(),"Active Lots")]
    Wait Until Keyword Succeeds    3 times    strict: 10s    Click Active Lots
    Waiting For Loading
    Wait Until Page Contains    Lot Breakouts    timeout=5s

Click Active Lots
    Sleep    1s
    Click Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom}')]]//*[contains(@class,'LotsLink')]
    Wait Until Page Contains    Lot Breakouts - ${ndc} (${uom})    timeout=5s

Adjust Inventory On Hand
    Waiting For Loading
    Wait Until Page Contains Element    //*[contains(@class,'tab-pane') and contains(@class,'active')]//*[contains(@class,'QtyOnHandLink')]
    Click Element    //*[contains(@class,'tab-pane') and contains(@class,'active')]//*[contains(@class,'QtyOnHandLink')]
    Wait Until Page Contains    text=Inventory Adjustment

Get Qty On Hand
    [Arguments]     ${Lot}    ${exp_date}
    ${QtyOnHand}    Set Variable    0
    Wait Until Page Contains   Lot Breakouts
    Sleep    3s
    ${elems}    Get WebElements    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${Lot}")]/parent::div/div[4]
    FOR    ${element}    IN    @{elems}
        ${elem_qty}    Get Text    locator=${element}
        ${QtyOnHand} =    Evaluate    "${QtyOnHand}".replace(",", "")
        ${elem_qty} =     Evaluate    "${elem_qty}".replace(",", "") 
        ${QtyOnHand} =    Evaluate    int(${QtyOnHand}) + int(${elem_qty})
    END
    ${QtyOnHand}    Convert To Number    ${QtyOnHand}
    ${QtyOnHand}    Convert To Integer    ${QtyOnHand}
    RETURN    ${QtyOnHand}    


Check Inventory Level
    [Arguments]    ${checked_location}    ${from_facility}    ${to_facility}    ${ndc}
    Select location    ${checked_location}
    ${from_facility}    Get Facility Name     ${from_facility}
    Select Inventory Tab With NDCItem   ${from_facility}    ${ndc}
    Select Show Empty Inventory
    Wait Until Keyword Succeeds    10 times    5s    Try Click Active Lots
    ${QtyOnHand}    Get Qty On Hand     ${Lot}    ${exp_date}
    ${randomQty}    Evaluate    random.randint(1,10)    #add random Qty in case Qty On Hand
    ${QtyAdjust}    Evaluate    ${QtyAssign} + ${randomQty} 
    IF    ${QtyOnHand} < ${QtyAssign}
        Set Test Variable    ${QtyAdjust}    ${QtyAdjust}
        Adjust Medication Qty    ${QtyAdjust}    ${uom}
        ${QtyOnHand}    Get Qty On Hand    ${Lot}    ${exp_date}
    END
    Set Test Variable    ${QtyOnHand}
    ###check to-inventory  
    ${to_facility}    Get Facility Name     ${to_facility}
    Select Inventory Tab With NDCItem   ${to_facility}    ${ndc}
    Select Show Empty Inventory
    Wait Until Keyword Succeeds    3 times    strict:30s    Try Click Active Lots
    Waiting For Loading
    ${QtyOnHand_ToInventory}    Get Qty On Hand    ${Lot}    ${exp_date}
    Set Test Variable    ${QtyOnHand_ToInventory}



Check Inventory Level After Transfer
    [Arguments]    ${checked_location}    ${from_facility}    ${to_facility}    ${ndc}
    Go Inventory Level
    Select location    ${checked_location}
    ${from_facility}    Get Facility Name     ${from_facility}
    Select Inventory Tab With NDCItem   ${from_facility}    ${ndc}
    Select Show Empty Inventory
    Wait Until Keyword Succeeds    10 times    5s    Try Click Active Lots
    IF    "${transfer_method}" == "scan"
        ${QtyAssign}    Set Variable    ${other_changes_qty}
    END
    IF    ${QtyOnHand} != ${QtyAssign}
        ${QtyOnHand_AfterTransfer_Ui}    Evaluate    ${QtyOnHand}-${QtyAssign}
        ${QtyOnHand_AfterTransfer}    Get Qty On Hand    ${Lot}    ${exp_date}
        Should Be Equal    $${QtyOnHand_AfterTransfer_Ui}    $${QtyOnHand_AfterTransfer}
    ELSE
        Element Should Not Be Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${Lot}")]/following-sibling::div[contains(text(),"${exp_date}")]/following-sibling::div[2]
    END
    ${to_facility}    Get Facility Name     ${to_facility}
    Select Inventory Tab With NDCItem   ${to_facility}    ${ndc}
    Select Show Empty Inventory
    Wait Until Keyword Succeeds    10 times    5s    Try Click Active Lots
    Waiting For Loading
    ${QtyOnHand_AfterTransfer_ToInventory}    Get Qty On Hand    ${Lot}    ${ExpDate}
    ${QtyTransferred}    Evaluate    ${QtyOnHand_AfterTransfer_ToInventory}-${QtyOnHand_ToInventory}
    Should Be Equal    $${QtyTransferred}    $${QtyAssign}
    
Adjust Medication Qty
    [Arguments]    ${QtyAdjust}    ${uom}
    Click Element    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom}")]//following-sibling::div/a[@class="QtyOnHandLink"]
    ${LotAndExp_AdjustQty}    Set Variable    ${Lot} -- [Expires: ${exp_date} ]
    Wait Until Keyword Succeeds    3times    1    util.verify loading and select by label    LotDetailId    ${LotAndExp_AdjustQty}
    ${PriceAndContract}    Set Variable    (${ContractNo})
    Util.Verify Loading And Select By Label    Price    ${PriceAndContract}
    Input Text    //*[@id="newQty"]    ${QtyAdjust}    
    Click Element    //*[@id="newQtyOnHand"]
    Wait Until Element Is Visible    //span[text()="Inventory Updated!"]    10s
    Wait Until Element Is Not Visible    //span[text()="Inventory Updated!"]    
    Wait Until Keyword Succeeds    3times    1    Close Inventory Adjustment Modal

Close Inventory Adjustment Modal
    Click Button    //button[text()="Save"]
    Wait Until Element Is Not Visible    //*[@id="ModalPopup"]//div[contains(@class,"modal-content")]    timeout=30s

Add New Inventory
    [Arguments]    ${New_Inventory}    ${Type}
    Wait Until Keyword Succeeds    5s    1s    Click Element    id=newInventory    
    Wait Until Keyword Succeeds    5s    1s    Input Text    id=FacilityDescription    ${New_Inventory}
    Select From List By Label    id=FacilityType    ${Type}
    Click Button    //*[@id="SaveBtn" and contains(text(),"Create Inventory Department")]

Get Last Action Inventory Level Before Reconcile
    ${inventory_transaction_cols}    Create List
    ${rows}    Get WebElements    locator=//*[contains(@class,'active') and contains(@class,'tab-pane')]//*[(@id='LevelList')]//*[contains(@class,'active') and contains(@class,'tab-pane') and contains(@id,'InventoryTransactionTab')]//*[contains(@class,'row')]
    FOR    ${var}    IN    @{rows}[1:]
        ${inventory_transaction_html}=    SeleniumLibrary.Get Element Attribute    ${var}    outerHTML
        ${list_properties}    Create List    Type    Adjustment
        ${inventory_transaction_col}=    Get Transaction Inventory Level    ${inventory_transaction_html}    ${{["Type","Adjustment"]}}
        Append To List    ${inventory_transaction_cols}    ${inventory_transaction_col}
    END
    ${inventory_transaction_cols}    Get Last Reconcile Inventory    ${inventory_transaction_cols}
    Should Be Equal     ${inventory_transaction_cols}    ${log_action_before_reconcile}

Click Inventory Reports
    SeleniumLibrary.Click Button    Inventory Reports
Switch Tab
    Switch Window    NEW
Select Inventory Report
    [Arguments]    ${type_report}
    ${InventoryReportBtn}=    Replace Variables    ${InventoryReportBtn}
    wait until element is enabled    ${InventoryReportBtn}
    Click Element       ${InventoryReportBtn}
Select Facility In Inventory Level
    [Arguments]    ${inventory_name}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=10s
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=20s
    ${SelectInventory}=    Replace Variables    ${SelectInventory}
    Wait Until Element Is Enabled    ${SelectInventory}
    Scroll Element Into View    ${SelectInventory}
    Click Element    ${SelectInventory}
    Wait Until Page Does Not Contain Element    //*[contains(@class,"active")]//*[@id="LevelList"]/div[1]/i    timeout=30s
    
Read Inventory Report PDF
    [Arguments]    ${type_report}
    ${file_name}    Get File Report Name     ${type_report}
    # Set up case
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    ${export_path}=    Join Path    ${export_path}    ${file_name}

    ${exists}=    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
    Sleep    4
    execute javascript    window.print();
    Sleep    4
    Wait Until Created    ${export_path}
    Attach File    ${export_path}    name=${file_name}    attachment_type=PDF
    read_file_pdf   ${export_path}
    Sleep    2

Read Inventory Report CSV
    [Arguments]    ${type_report}
    ${file_name}    Get File Report Name     ${type_report}
    # Set up case
    ${export_path}=    Download Report CSV SuccessFully    ${file_name}
    ${report}=    convert_file_csv_inventory_report   ${export_path}
    Attach File    ${export_path}    name=${file_name}    attachment_type=CSV

Go Into Inventory Reconcile
    Wait Until Element Is Enabled   //a[@id="ToggleReconcileInventoryBtn"]
    Execute Javascript    document.getElementById('ToggleReconcileInventoryBtn').click()

Show Transaction UoM "${uom_type}"
    Wait Until Element Is Enabled    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom_type}')]]//*[contains(@class,'TransactionsLink')]    5s
    Click Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom_type}')]]//*[contains(@class,'TransactionsLink')]
    Waiting For Loading
    Wait Until Page Contains    Transaction History     timeout=20s

Show Adjustment Inventory On Hand "${uom_type}"
    Wait Until Element Is Enabled    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom_type}")]//following-sibling::div/a[@class="QtyOnHandLink"]
    Wait Until Keyword Succeeds    3times    5s    Click Element    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom_type}")]//following-sibling::div/a[@class="QtyOnHandLink"]
    Wait Until Page Contains    Inventory Adjustment