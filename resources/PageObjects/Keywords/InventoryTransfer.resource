*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot    
Library    Collections
Library    String   
Library    ../../../libraries/CustomLibrary.py
Library    XML
Library    pandas

Variables    ../Locators/CommonLocator.py
Variables    ../Locators/DispenseLocator.py
Variables    ../Locators/InventoryTransferList.py
Variables    ../TestData/Testdata.py

Resource    ../../../libraries/Util.resource
# Resource    ReconcileDetail.resource
# Resource    ./InventoryLevel.resource

*** Keywords ***
# Behaviour
Create Transfer
    [Arguments]    ${from_account}    ${from_facility}    ${to_account}    ${to_facility}    ${transfer_type}
    # ToLocationInventory set for Transfer with NO Receiving, ToLocationInventory_Receive set for Transfer with Receiving
    # IF    "${receive_required}" == "yes"
    #     ${ToLocationInventory}    Set Variable    ${ToLocationInventory_Receive}
    # END
    # IF    "${transfer_type}" == "external"
    #     ${to_facility}    Set Variable    ${from_facility}
    # END
    Go Inventory Transfers
    Go Create New Transfer
    Select The Account To Transfer From    ${from_account}
    Select From Inventory    ${from_facility}
    Select The Account To Transfer To     ${to_account}
    Select To Inventory    ${to_facility}
    ${other_changes_qty}    Config Item Transfer    ${transfer_type}
    Set Test Variable    ${other_changes_qty}
    # RETURN    ${other_changes_qty}

Go Inventory Transfers
    Click Element    ${InventoryLink}
    Click Element    ${InventoryTransfersLink}
    Wait Until Keyword Succeeds    30s    3s    Title Should Be    Inventory Transfers
 
Go Create New Transfer
    Wait Until Element Is Enabled    ${NewInventoryTransfer_button}
    click element    ${NewInventoryTransfer_button}
Scan Transfer ${other_changes_qty} ${ndc}
    ${list_barcode}=     Evaluate   random.sample(${ListBarcode_Transfer},${other_changes_qty})
    Scan List Barcode    $list_barcode=${list_barcode}
    
Scan List Barcode
    [Arguments]    ${list_barcode}
    ${orig_timeout}=    Set Selenium Timeout    20 seconds
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${list_barcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 10000);
    Set Selenium Timeout    ${orig_timeout}

Get LotAndExpAndQty
    [Arguments]    ${ExpDate}    ${QtyOnHand}
    ${Exp_Month}    ${Exp_Day}    ${Exp_Year}    Split String    ${ExpDate}    /
    ${Exp_Month}    Convert To Integer    ${Exp_Month}
    ${Exp_Day}    Convert To Integer    ${Exp_Day}
    ${Exp_Year}    Convert To Integer    ${Exp_Year}
    ${ExpDate}    Set Variable    ${Exp_Month}/${Exp_Day}/${Exp_Year}
    ${LotAndExpAndQty}    Set Variable    ${Lot} -- [Exp: ${ExpDate}] (${QtyOnHand})
    # Log To Console    >>>\n${LotAndExpAndQty}
    RETURN    ${LotAndExpAndQty}

Find Inventory With ${NDCItem}
    Input Text    //*[@id="SearchValues"]    ${NDCItem}
    Click Button    //*[@id="FindButton"]
    Wait Until Element Is Not Visible    //*[@id="loading-indicator" and not(contains(@class, "hidden"))]    10s
    Wait Until Element Is Visible    //*[@id="inventoryTab"]//tr[@id="itemSelectorTableRow"][1]//a[@href="#" and contains(text(),"${NDCItem}")]    timeout=30s
    
Select Lot ${LotAndExpAndQty}
    Wait Until Element Is Visible    //*[@id="inventoryTab"]//select[@id="item_LotNumber"]    20s
    Util.Verify Loading And Select By Label    locator=xpath://*[@id="inventoryTab"]//select[@id="item_LotNumber"]    selected_label=${LotAndExpAndQty}    #10 times


Add Qty ${QtyAssign}
    Wait Until Keyword Succeeds    10times    1s    Input Text    //*[@id="inventoryTab"]//input[@id="DispenseQty"]    ${QtyAssign} 
    Press Keys    id=DispenseQty    ENTER

    ${Check_Input_Qty}    Run Keyword And Return Status    Alert Should Not Be Present
    FOR    ${count}    IN RANGE    5
        IF    ${Check_Input_Qty} == ${False}
            Handle Alert    ACCEPT
            Wait Until Keyword Succeeds    10s    1s    Input Text    //*[@id="inventoryTab"]//input[@id="DispenseQty"]    ${QtyAssign}
            Wait Until Keyword Succeeds    10s    1s    Click Element    //*[@id='inventoryTab']//a[@id="AddQty"]
            Sleep    1s
        ELSE
            BREAK
        END
        ${Check_Input_Qty}    Run Keyword And Return Status    Alert Should Not Be Present
    END
Config Item Transfer
    [Arguments]    ${transfer_type}
    ${transfer_type}    Set Variable    internal or external
    Wait Until Element Is Visible    //*[@id="ProductSelectorInventory"]//div[contains(text(),'Items')]    timeout=30s
    IF    "${transfer_method}" == "scan"
        Scan Barcode Transfer    
        Wait Until Element Is Visible    //*[@id="bottom-lines"]    timeout=30s
        Scroll Element Into View    //*[@id="bottom-lines"]
    ELSE
        Find Inventory With ${ndc}
        ${LotAndExpAndQty}    Get LotAndExpAndQty    ${ExpDate}    ${QtyOnHand}
        Select Lot ${LotAndExpAndQty}
        Add Qty ${QtyAssign}
    END
    Wait Until Element Is Enabled    link: Transfer Memo / Note
    Wait Until Keyword Succeeds    3times    1    Verify Qty Scan
    Scroll Element Into View    //a[contains(text(),'Submit Transfer')]    
    Submit Transfer
    RETURN    ${other_changes_qty}
Verify Qty Scan
    Wait Until Element Is Visible    //*[@name="item.Qty"]    15s
    ${other_changes_qty}    Wait Until Keyword Succeeds    5s    1s    Get Value    //*[@name="item.Qty"]
    ${other_changes_qty}    Evaluate    ${other_changes_qty}
    # ${ListBarcode_Transfer}    Evaluate    ${ListBarcode_Transfer}
    ${QtyScanned}    Get Length    ${ListBarcode_Transfer} 
    Should Be Equal    ${QtyScanned}    ${other_changes_qty}
    Set Test Variable    ${other_changes_qty}

Select The Account To Transfer From
    [Arguments]    ${from_account}
    Wait Until Element Is Enabled    id=FromAccount
    Sleep    1s
    Wait Until Keyword Succeeds    3times    1    Util.Verify Loading And Select By Label    FromAccount    ${from_account}
    
Select From Inventory
    [Arguments]    ${from_facility}
    Wait Until Element Is Enabled    id=FromFacility
    Wait Until Keyword Succeeds    3times    1    Util.Verify Loading And Select By Label    FromFacility    ${from_facility}

Select The Account To Transfer To
    [Arguments]    ${to_account}
    Wait Until Element Is Enabled    id=ToAccount
    Wait Until Keyword Succeeds    3times    1    Util.Verify Loading And Select By Label    ToAccount    ${to_account}

Select To Inventory
    [Arguments]    ${to_facility}
    Wait Until Element Is Enabled    id=ToFacility
    Wait Until Keyword Succeeds    3times    1    Util.Verify Loading And Select By Label    ToFacility    ${to_facility}

Submit Transfer
    Wait Until Element Is Enabled    //a[contains(text(),'Submit Transfer')]
    Click Element    //a[contains(text(),'Submit Transfer')]
    ${alert}    Wait Until Keyword Succeeds    5s    1s    Handle Alert And Return Its Text
    Should Be Equal    Are you sure you want to submit this draft?    ${alert}
    Wait Until Keyword Succeeds    3times    5s    Title Should Be    Inventory Transfers

Scan Barcode Transfer
    Set Selenium Timeout    30s
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${ListBarcode_Transfer}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 15000);    #6 barcodes

Receive Transfer
    IF    "${receive_required}" == "yes"
        ${ToLocationInventory}    Set Variable    ${ToLocationInventory_Receive}
    END
    Wait Until Element Is Enabled    id=FromAccount    5s
    Select From List By Label    id=FromAccount    ${LocationInventory}
    Select From List By Label    id=ToAccount    ${ToLocationInventory}
    Sleep    3s
    ${Check_Transfer_Line}    Run Keyword And Return Status    Scroll Element Into View    //tr[@class="awaiting-receive"][1]//a[contains(@href,"AwaitingReceiving")]/ancestor::tr[contains(@class,"awaiting-receive")]/following-sibling::tr[1]/td[@colspan]  
    IF    ${Check_Transfer_Line} == ${True}
        Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    //tr[@class="awaiting-receive"][1]//a[contains(@href,"AwaitingReceiving")]/ancestor::tr[contains(@class,"awaiting-receive")]/following-sibling::tr[1]/td[@colspan]
    END  
    Wait Until Element Is Visible    //tr[contains(@class,"awaiting-receive")][1]//a[contains(@href,"AwaitingReceiving")]    10s
    Wait Until Keyword Succeeds    5s    1s    Click Element    //tr[contains(@class,"awaiting-receive")][1]//a[contains(@href,"AwaitingReceiving")]
    Wait Until Element Is Visible    //label[contains(@for,"FromFacilityName")]/parent::h4
    IF    "${transfer_type}" == "external"
        ${to_facility}    Set Variable    ${from_facility}
    END
    # Receive Inventory Transfer page
    ${Check_From_Facility}    Get Text    //label[contains(@for,"FromFacilityName")]/parent::h4
	${Check_From_Facility}    Fetch From Right    ${Check_From_Facility}    From Facility
	${Check_From_Facility}    Strip String    ${Check_From_Facility}
	${Check_To_Facility}    Get Text    //label[contains(@for,"ToFacilityName")]/parent::h4
	${Check_To_Facility}    Fetch From Right    ${Check_To_Facility}    To Facility
	${Check_To_Facility}    Strip String    ${Check_To_Facility}
	# check facilites
    ${FromFacility}    Fetch From Left    ${FromFacility}    \ (
    ${ToFacility}    Fetch From Left    ${ToFacility}    \ (
    ${Check_From_Facility}    Evaluate    "${Check_From_Facility}" in "${FromFacility}"
    ${Check_To_Facility}    Evaluate    "${Check_To_Facility}" in "${ToFacility}"
    Sleep    1s
    Util.Scroll To Bottom    
    ${LotAndExp_Receive}    Set Variable    ${Lot} -- [Expires: ${ExpDate}]
    # Receive Partial
    ${QtyReceive}    Evaluate    ${QtyReceive}
    ${ListBarcode_Transfer}    Evaluate    ${ListBarcode_Transfer}
    IF    "${receive_type}" == "partial"
        ${Check_Received}    Evaluate    0
        FOR    ${EachQty}    IN    @{QtyReceive}
            ${Check_Received}    Evaluate    ${Check_Received} + ${EachQty}
            # Check if Scan-Receive or NOT
            IF    "${receive_method}" == "scan"
                @{ScanList}    Get Slice From List    ${ListBarcode_Transfer}    0    ${EachQty}
                Sleep    1s    
                Util.Scroll To Bottom
                # Sleep    2s
                FOR    ${BarcodeScanned}    IN    @{ScanList}
                    Execute Javascript    handleScan("${BarcodeScanned}")
                    Sleep    ${WaitingTime_Scan}    #2.5s
                END
                Wait Until Element Is Visible    //*[@id="ScanNotification"]    10s
                Wait Until Keyword Succeeds    15s    1s    SeleniumLibrary.Element Text Should Be    //*[@id="ScanNotification"]    ${Check_Received}/${TotalReceive}    #10s
                Wait Until Element Is Not Visible    //*[@id="updateButton" and text()="Save"]    15s
            ELSE
                FOR    ${count}    IN RANGE    2
                    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    //select[@name="receipt.LotNo" and not(contains(@disabled,"True"))]        ${LotAndExp_Receive}
                    IF    ${count} == 1
                        BREAK
                    END
                    Sleep    1s
                END
                Wait Until Keyword Succeeds    10s    1s    Input Text    //input[@name="receipt.Qty" and not(contains(@disabled,"True"))]    ${EachQty}
                Sleep    1s
                Util.Scroll To Bottom
                Wait Until Keyword Succeeds    15s    1s    Click Element    //*[contains(@id,"LineNumber")]//a[contains(text(),"Apply")]
                Wait Until Element Is Not Visible    //*[contains(@data-notify,"message") and contains(text(),"Receipt applied successfully")]
            END
            IF    ${Check_Received} == ${TotalReceive}
                IF    "${transfer_method}" == "scan"
                    Wait Until Keyword Succeeds    10s    1s    Element Should Not Be Visible    //*[@id="ScanNotification"]
                END
                Wait Until Keyword Succeeds    15s    1s    Element Should Not Be Visible    //*[contains(@id,"LineNumber")]//a[contains(text(),"Apply")]    #15s
                ${Check_Qty_Transferred}    Wait Until Keyword Succeeds    5s    1s    Get Value    //label[text()="Qty Transferred"]//ancestor::div[@class="row"]/following-sibling::div//input[contains(@disabled,"disabled")]
                Should Be Equal As Numbers    ${Check_Qty_Transferred}    ${Check_Received}
            END
            #Back to Transfer Ledger btn not working → To be implemented later!
            Click Element    //*[@id="body"]//a[contains(text(),"Inventory Transfers")]
            Wait Until Element Is Visible    //button[contains(@data-id,"FromAccount") and contains(@title,"Select an Account")]
            Select From List By Label    id=FromAccount    ${LocationInventory}
            Select From List By Label    id=ToAccount    ${ToLocationInventory}
            Sleep    3s
            IF    ${Check_Received} == ${TotalReceive}
		        Wait Until Keyword Succeeds    5s    1s    SeleniumLibrary.Element Text Should Be    //tr[contains(@class,"")][1]/td[contains(text(),"${SubmitTransfer_User}")]/following-sibling::td/span    Complete
			    BREAK
		    END
	        Wait Until Element Is Visible    //tr[contains(@class,"awaiting-receive")][1]//a[contains(@href,"AwaitingReceiving")]    15s    #10
            Wait Until Keyword Succeeds    5s    1s    Click Element    //tr[contains(@class,"awaiting-receive")][1]//a[contains(@href,"AwaitingReceiving")]
            Wait Until Element Is Visible    //select[@name="receipt.LotNo" and not(contains(@disabled,"True"))]    10s
            # Sleep    3s
            @{ListBarcode_Transfer}    Get Slice From List    ${ListBarcode_Transfer}     ${EachQty}      
        END
    ELSE
        # Receive Full
        # Check if Scan-Receive or NOT
        IF    "${receive_method}" == "scan"
            FOR    ${BarcodeScanned}    IN    @{ListBarcode_Transfer}
                    Execute Javascript    handleScan("${BarcodeScanned}")
                    Sleep    ${WaitingTime_Scan}    #2.5s    
            END
            Wait Until Keyword Succeeds    15s    1s    SeleniumLibrary.Element Text Should Be    //*[@id="ScanNotification"]    ${TotalReceive}/${TotalReceive}
            Wait Until Keyword Succeeds    15s    1s    Element Should Not Be Visible    //*[@id="ScanNotification"]
            Run Keyword And Ignore Error    Wait Until Keyword Succeeds   15s    1s    Element Should Not Be Visible    //*[contains(@id,"LineNumber")]//a[contains(text(),"Apply")]
            Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    //label[text()="Qty Transferred"]//ancestor::div[@class="row"]/following-sibling::div//a[text()="Receive"]
            Wait Until Keyword Succeeds    10s    1s    Click Element    //label[text()="Qty Transferred"]//ancestor::div[@class="row"]/following-sibling::div//a[text()="Receive"]
            # Sleep    3s
            ${Check_QtyTransferred}    Wait Until Keyword Succeeds    10s    1s    Get Value    //label[text()="Qty Transferred"]/ancestor::div[@class="row"]/following-sibling::div[contains(@class,"LineItemTable")]//input[@disabled="disabled"]
            ${Check_QtyTransferred}    Evaluate    ${Check_QtyTransferred}
            Should Be Equal As Numbers    ${Check_QtyTransferred}    ${Total_Receive}
        ELSE
            Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    //label[text()="Qty Transferred"]//ancestor::div[@class="row"]/following-sibling::div//a[text()="Receive"]
            Wait Until Keyword Succeeds    10s    1s    Click Element    //label[text()="Qty Transferred"]//ancestor::div[@class="row"]/following-sibling::div//a[text()="Receive"]
            # message prompted but sometimes cannot locate element!
            ${Check_Message}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(text(),"Receiving successful")]
        END
        Wait Until Keyword Succeeds    15s    1s    Element Should Not Be Visible    //*[contains(@id,"LineNumber")]//a[contains(text(),"Apply")]    #10s
        ${alert_transfer}    Run Keyword And Ignore Error    Handle Alert    ACCEPT
        Util.Scroll To Top
        Click Element    //*[@id="body"]//a[contains(text(),"Inventory Transfers")]
        Select From List By Label    id=FromAccount    ${LocationInventory}
        Select From List By Label    id=ToAccount    ${ToLocationInventory}
        Sleep    3s
        Wait Until Keyword Succeeds    5s    1s    SeleniumLibrary.Element Text Should Be    //tr[contains(@class,"")][1]/td[contains(text(),"${SubmitTransfer_User}")]/following-sibling::td/span    Complete
    END