*** Settings ***
Resource    InventoryReconcile.resource
Resource    CommonKeywords.resource
Resource    Dispense.resource
Resource    LoginKeywords.resource
Resource    ReconcileDetail.resource
Resource    InventoryLevel.resource
Resource    SerializeItemTrackerKeywords.resource
Resource    Appointment.resource
Resource    ../Keywords/Administration/Administration.resource
Resource    UserDetail.resource

*** Keywords ***
Go To Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location     ${checked_location}
    InventoryLevel.Select Inventory    ${checked_facility}
Go To Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    ${type}=full
	InventoryReconcile.Go Inventory Reconcile
    Select From List By Label    //select[contains(@id,"AccountID") or contains(@id,"AccountId")]    ${checked_location}
    InventoryReconcile.Select Inventory    ${checked_facility}
    InventoryReconcile.Open Active Reconcile
    ReconcileDetail.Select Type Reconcile    type=${type}
    ReconcileDetail.Get Reconcile History id
Go To Inventory Reconcile And Fill Empty Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    # Click Button    Clear
    ${reset_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    ${ReconcileTableXpath}    timeout=10s
    Run Keyword If    $reset_conditional == ${True}
    ...    Check Reconcile Table Contains Scanned Items
Check Reconcile Table Contains Scanned Items
    Wait Until Keyword Succeeds    3times    1    ReconcileDetail.Reset Assigned Products
    ${contains_item_conditional}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="ReconciledItemsTable"]/div/strong    timeout=10s
    IF    $contains_item_conditional
        ReconcileDetail.Complete Reconcile
    ELSE
        ReconcileDetail.Reset And Fill Empty
    END

Go To Inventory Reconcile To Add Item By Scanning With Timeout
    [Arguments]    ${checked_location}    ${checked_facility}    ${barcodes}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    Add Item By Scanning With Timeout    barcodes=${barcodes}
Go To Inventory Reconcile To Add Item By Scanning No Timeout
    [Arguments]    ${checked_location}    ${checked_facility}    ${barcodes}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}
    Add Item By Scanning No Timeout    barcodes=${barcodes}
Go To Inventory Reconcile Type Add To Add Item By Scanning With Timeout
    [Arguments]    ${checked_location}    ${checked_facility}    ${barcodes}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}    add
    Add Item By Scanning With Timeout    barcodes=${barcodes}
Go To Inventory Reconcile Type Add To Add Item By Scanning No Timeout
    [Arguments]    ${checked_location}    ${checked_facility}    ${barcodes}
    Go To Inventory Reconcile    ${checked_location}    ${checked_facility}    add
    Add Item By Scanning No Timeout    barcodes=${barcodes}
Complete Reconcile Then Go To Open Reconcile History And Add Item By Scanning No Timeout
    [Arguments]    ${barcodes}
    ReconcileDetail.Complete Reconcile
    ReconcileDetail.Open Reconcile History By Id    ${reconcile_history_id}
    Add Item By Scanning No Timeout    ${barcodes}
Cancel Reconcile Then Go To Open Reconcile History And Add Item By Scanning No Timeout
    [Arguments]    ${barcodes}
    ReconcileDetail.Cancel Reconcile
    ReconcileDetail.Open Reconcile History By Id For Cancel    ${reconcile_history_id}
    Add Item By Scanning No Timeout    ${barcodes}
Add Item By Scanning With Timeout
    [Arguments]    ${barcodes}
    FOR    ${barcode}    IN    @{barcodes}
        Execute Async Javascript    var callback = arguments[arguments.length - 1];handleScan("${barcode}");setTimeout(()=>{callback()},6000);
    END
Add Item By Scanning No Timeout
    [Arguments]    ${barcodes}
    FOR    ${barcode}    IN    @{barcodes}
        Execute Javascript    handleScan("${barcode}")
    END
Adjust Actual Qty On Hand For Adding Items By Scanning
    ${items}    Get WebElements    //*[contains(@id,"ReconcileLine_")]
    FOR    ${index}    ${item}    IN ENUMERATE   @{items}
        Input Text    ${item}    ${index+1}
    END
Verify Toast Message
    [Arguments]    ${message}
    Wait Until Page Contains    ${message}    30s
    Wait Until Page Does Not Contain    ${message}    30s
Random RS Barcode
    ${random_rs_barcode}    Evaluate    'RS' + ''.join(str(random.randint(0,9)) for _ in range(7))    random
    RETURN    ${random_rs_barcode}
Get Value In Table Reconcile
    ${table}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${table_value_dict}    Get All Data From Html Table In Reconcile Screen    ${table}
    RETURN    ${table_value_dict}
Get Hard Count In Table Reconcile
    ${table}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${value_hard_counts_table_dict}    Get Hard Count Data From Html Table In Reconcile Screen   ${table}
    RETURN    ${value_hard_counts_table_dict}
Cal Hard Count In Table Reconcile
    ${table}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${ReconcileTableXpath}    outerHTML
    ${value_items_table_dict}    Get All Data From Html Table In Reconcile Screen    ${table}
    ${value_hard_counts_table_dict}    Cal Hard Count Data From Value Rows In Reconcile Screen    ${value_items_table_dict}
    RETURN    ${value_hard_counts_table_dict}     
Adjust Actual Qty On Hand Base On Value Expected Qty On Hand
    [Arguments]    ${index}    ${row}        ${is_equal_actual_and_expected}=${False}    
    IF    $is_equal_actual_and_expected
        ${actual_qty_on_hand}    Set Variable    ${row}[Expected Qty On Hand]
    ELSE
        ${actual_qty_on_hand}    Evaluate    ${row}[Expected Qty On Hand] + random.randint(1,10) or ${row}[Expected Qty On Hand] - random.randint(1,10)    random 
    END 
    Input Text    id=ReconcileLine_${index}    ${actual_qty_on_hand}
    Verify Toast Message    Please input a valid number.
    Press Keys    id=ReconcileLine_${index}    TAB        
    Verify Toast Message    Reconcile item updated!
    Execute Javascript    document.getElementById("ReconcileLine_${index}").setAttribute("value","${actual_qty_on_hand}")
    IF    not $is_equal_actual_and_expected
        Wait Until Element Is Visible    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]
        ${list_item}    Get List Items    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]
        ${last_item_index}    Evaluate    len(${list_item}) - 1
        Select From List By Index    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//select[@id="item_Reason"]    ${last_item_index}
        Input Text    //input[@id="ReconcileLine_${index}"]/ancestor::tr/following-sibling::tr[1]//input[@class="form-control reconcileItemNote"]    Test
    END
Verify Value In Table Reconcile
    ${table_value_dict}    Get Value In Table Reconcile
    FOR    ${index}    ${row}    IN ENUMERATE    @{table_value_dict}
        Verify Color In Table Reconcile    ${row}
        Verify Discrepancy Value In Table Reconcile    ${row}
    END
    Verify Hard Count Value In Table Reconcile
Verify Discrepancy Value In Table Reconcile
    [Arguments]    ${row}
    ${expected_discrepancy}    Evaluate    ${row}[Actual Qty On Hand] - ${row}[Expected Qty On Hand]    
    Should Be Equal As Numbers    ${row}[Discrepancy]    ${expected_discrepancy}
Verify Hard Count Value In Table Reconcile
    ${actual_hard_count_value_on_table_dict}    Get Hard Count In Table Reconcile
    ${expected_hard_count_value_on_table_dict}    Cal Hard Count In Table Reconcile
    Should Be Equal    ${actual_hard_count_value_on_table_dict}    ${expected_hard_count_value_on_table_dict}    
Verify Color In Table Reconcile
    [Arguments]    ${row}
    IF    $row["Expected Qty On Hand"] == $row["Actual Qty On Hand"]
        Wait Until Element Is Visible    //tr[contains(.,"${row}[NDC]") and contains(.,"${row}[Lot]") and contains(@class,"reconcileRecentlyEdit")]    30s
        Wait Until Element Is Visible    //tr[contains(.,"${row}[NDC]") and contains(.,"${row}[Lot]") and contains(@class,"reconcileRecentlyEdit")]/following-sibling::tr[contains(@class,"reconcileRecentlyEdit")]    30s
    ELSE
        Wait Until Element Is Visible    //tr[contains(.,"${row}[NDC]") and contains(.,"${row}[Lot]") and contains(@class,"reconcileDiscrepancy")]    30s
        Wait Until Element Is Visible    //tr[contains(.,"${row}[NDC]") and contains(.,"${row}[Lot]") and contains(@class,"reconcileDiscrepancy")]/following-sibling::tr[contains(@class,"reconcileDiscrepancy")]    30s
    END
Go To Inventory Level And Open Data Item In Tracker To Verify Tracked Barcodes And Losted Barcodes 
    [Arguments]    ${checked_location}    ${checked_facility}    ${tracked_barcodes}    ${losted_barcodes}  
    Go To Inventory Level    ${checked_location}    ${checked_facility}
    SerializeItemTrackerKeywords.Open Serialize Item Tracker
    SerializeItemTrackerKeywords.Verify Search By Barcode    ${tracked_barcodes}
    SerializeItemTrackerKeywords.Go Tab Lost Item
    SerializeItemTrackerKeywords.Verify Tab Lost Item Tracker Successfully
    SerializeItemTrackerKeywords.Verify Search By Barcode In Tab Lost Item Tracker    ${losted_barcodes}
    SerializeItemTrackerKeywords.Close Serialize Item Tracker
Open Manually Add Products On Inventory Reconcile
    Util.Scroll To Bottom
    Wait Until Element Is Visible     ${ManualAddProductsBtn}   30s
    Click Element    ${ManualAddProductsBtn}
    Wait Until Element Is Visible    ${SearchAssignProductInput}    30s
Manually Add Products On Inventory Reconcile
    [Arguments]    ${ndc}    ${qty}    ${lot}
    Open Manually Add Products On Inventory Reconcile
    Wait Until Element Is Visible    ${SearchAssignProductInput}
    Input Text    ${SearchAssignProductInput}    ${ndc}
    Click Button    ${SearchAssignProductBtn}
    Wait Until Element Is Enabled    //*[@id="item_LotNumber"]
    Select From List By Value      //*[@id="item_LotNumber"]    ${lot}
    Input Text    ${AddingQtyInput}    ${qty}
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${AssignBtn}
Verify Manually Add Products On Inventory Reconcile
    [Arguments]    ${ndc}    ${qty}    ${lot}
    Manually Add Products On Inventory Reconcile    ndc=${ndc}    qty=${qty}    lot=${lot}
    Wait Until Page Contains    Successfully Added to Patient Reservoir!    timeout=10s    error=Manual add not success
Reset Reset to Only Scanned Products
    Wait Until Element Is Visible     //*[contains(@class,"active")]//*[contains(text(),"Reset to Only Scanned Products")]    30s
    CommonKeywords.Scroll To Bottom
    Click Element    //*[contains(@class,"active")]//*[contains(text(),"Reset to Only Scanned Products")]
    Wait Until Keyword Succeeds    5 times    1    Handle Alert And Return Its Text
Click Preview Reconcile Changes
    Wait Until Element Is Visible     //*[contains(@class,"active")]//*[contains(text(),"Preview Reconcile Changes")]    30s
    CommonKeywords.Scroll To Bottom
    Click Element    //*[contains(@class,"active")]//*[contains(text(),"Preview Reconcile Changes")]
Tab To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}
Try Click Active Lots To Open Lot Breakouts
    [Arguments]    ${uom}    ${ndc}
    Wait Until Element Is Visible    //*[contains(@class,"tab-pane") and contains(@class,"active")]//div[contains(text(),"${uom}")]/following-sibling::div/a[@href="#" and contains(text(),"Active Lots")]
    Wait Until Keyword Succeeds    3 times    strict: 10s    Click Active Lots To Open Lot Breakouts    ${uom}    ${ndc}
    Wait Until Page Contains    Lot Breakouts    timeout=5s

Click Active Lots To Open Lot Breakouts
    [Arguments]    ${uom}    ${ndc}
    Sleep    1s
    Click Element    //*[contains(@class,'active')]//*[@id='LevelList']//*[preceding-sibling::div[contains(text(),'${uom}')]]//*[contains(@class,'LotsLink')]
    Wait Until Page Contains    Lot Breakouts - ${ndc} (${uom})    timeout=5s
Verify Value Reconcile In Inventory Level
    [Arguments]    ${row}
    Wait Until Element Is Visible    //div[@class="panel-body"]/div[@class="row" and contains(.,"${row}[Lot]")]    30s
    ${list_data}    Get WebElements    //div[@class="panel-body"]/div[@class="row" and contains(.,"${row}[Lot]")]/div
    ${actual_expired_date}    Get Text    ${list_data}[1]
    ${coverted_actual_expired_date}    Convert Date    ${actual_expired_date}    result_format=%Y-%m-%d    date_format=%m/%d/%Y
    ${coverted_expected_expired_date}    Convert Date    ${row}[Date Expired]    result_format=%Y-%m-%d    date_format=%m/%d/%Y
    Should Be Equal    ${coverted_expected_expired_date}    ${coverted_actual_expired_date}
    ${actual_price}    Get Text    ${list_data}[2]
    ${converted_actual_price}    Replace String    ${actual_price}    $    ${EMPTY}
    Should Be Equal As Numbers    ${row}[Price]    ${converted_actual_price}
    ${actual_qty_on_hand}    Get Text    ${list_data}[3]
    Should Be Equal As Numbers    ${row}[Actual Qty On Hand]    ${actual_qty_on_hand}
Get Best Price Contract
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location     ${checked_location}
    InventoryLevel.Select Inventory    ${checked_facility}
    InventoryLevel.Find Inventory With NDCItem    ${ndc}
    InventoryLevel.Select Show Empty Inventory
    InventoryLevel.Show Adjustment Inventory On Hand "${uom}"
    ${best_price}    Wait Until Keyword Succeeds    5s    1s    Find Lowest Price
    Click Button    ${inventory_adjustment_close_btn}
    RETURN    ${best_price}

Find Lowest Price
    Wait Until Page Contains Element    //*[@class="modal-content"]//*[contains(text(),"Inventory Adjustment")]    timeout=20s
    Wait Until Keyword Succeeds    3times    10s    Select From List By Index    //*[@id="Price"]    1
    ${price_list}    Get List Items    //*[@id="Price"]
    # Step 1: Filter out non-price items (like '-- Select Contract Price --')
    ${filtered_list}=    Evaluate    [item for item in ${price_list} if item != '-- Select Contract Price --']
    # Step 2: Extract price values as floats
    @{prices}=    Create List
    FOR    ${item}    IN    @{filtered_list}
        ${price}=    Evaluate    float(${item.split(' ')}[0])
        Append To List    ${prices}    ${price}
    END
    # Step 3: Find the lowest price
    ${best_price}=    Evaluate    min(${prices})
    RETURN    ${best_price}
Get Name User Create Reconcile
    Wait Until Element Is Visible    //*[@id="ReconcileInventoryList"]/div[2]/div[1]/span
    ${name_user_create}    Get Text    //*[@id="ReconcileInventoryList"]/div[2]/div[1]/span
    RETURN     ${name_user_create}
Get Transaction List In Inventory Level
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    Click Transaction To Open Transaction List    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    ${inventory_transaction_cols}    Create List
    ${rows}    Get WebElements    locator=//*[contains(@class,'active') and contains(@class,'tab-pane')]//*[(@id='LevelList')]//*[contains(@class,'active') and contains(@class,'tab-pane') and contains(@id,'InventoryTransactionTab')]//*[contains(@class,'row')]
    FOR    ${var}    IN    @{rows}[1:]
        ${inventory_transaction_html}=    SeleniumLibrary.Get Element Attribute    ${var}    outerHTML
        ${list_properties}    Create List    Type    Adjustment
        ${inventory_transaction_col}=    Get Transaction Inventory Level    ${inventory_transaction_html}    ${{["Type","Created_By","Adjustment","Price","Lot_No","Expiration"]}}
        Append To List    ${inventory_transaction_cols}    ${inventory_transaction_col}
    END
    RETURN   ${inventory_transaction_cols}
Click Transaction To Open Transaction List
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    InventoryLevel.Go Inventory Level
    InventoryLevel.Select location    ${checked_location}
    InventoryLevel.Select Facility In Inventory Level    ${checked_facility}
    InventoryLevel.Find Inventory With NDCItem    ${ndc}
    InventoryLevel.Select Show Empty Inventory
    Wait Until Keyword Succeeds    5times    1    InventoryLevel.Show Transaction UoM "${uom}"
Get Expected Transition After Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}    ${type}    ${create_by}    ${adjustment}    ${lot_no}    ${covert_expired_date}        
    ${best_price}    Get Best Price Contract    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}
    ${round_best_price}    Evaluate    f"{${best_price}:.2f}"
    ${expected_transaction}    Create Dictionary
    Set To Dictionary    ${expected_transaction}    Type=${type}
    Set To Dictionary    ${expected_transaction}    Created_By=${create_by}
    Set To Dictionary    ${expected_transaction}    Adjustment=${adjustment}
    Set To Dictionary    ${expected_transaction}    Price=$${round_best_price}
    Set To Dictionary    ${expected_transaction}    Lot_No=${lot_no}
    Set To Dictionary    ${expected_transaction}    Expiration=${covert_expired_date}
    RETURN    ${expected_transaction}
Change Permission Reconcile For Account
    [Arguments]    ${is_enable}
    Click Element    link: Administration
    Click Element    link: My Login
    UserDetail.Switch Tab    Permission
    IF    ${is_enable}
        Wait Until Keyword Succeeds    30s    1    UserDetail.Assigned Permission    Can complete a inventory reconcile. (Has authority to mark a reconcile as completed and adjust inventory.)
    ELSE
        Wait Until Keyword Succeeds    30s    1    UserDetail.Unassigned Permission    Can complete a inventory reconcile. (Has authority to mark a reconcile as completed and adjust inventory.)
    END
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Permissions    30s
Change Account Inventory Reconcile Complexity
    [Arguments]    ${index}
    MyAccount.Go To My Account
    Wait Until Element Is Visible    //*[@id="InventoryReconcileComplexity"]
    Select From List By Index    //*[@id="InventoryReconcileComplexity"]    ${index}        
    MyAccount.Save Change
Open List of Reconcile Location Appointments & Statuses
    Wait Until Element Is Not Visible    //*[@data-notify="container"]    timeout=20s
    Click Complete Reconcile
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    Wait Until Page Contains     (Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)    timeout=30s
Save Complete Reconcile From List of Reconcile Location Appointments & Statuses
    Wait Until Element Is Enabled    ${SaveCompleteReconcileBtn}    timeout=10s
    Wait Until Keyword Succeeds    5s    1     Click Element    ${SaveCompleteReconcileBtn}
    Wait Until Page Does Not Contain    Reconcile Processing    timeout=120s
Close List of Reconcile Location Appointments & Statuses
    Wait Until Element Is Visible    //*[@id="SubModalPopup"]//*[@id="CloseBtn"]    30s
    Click Element    //*[@id="SubModalPopup"]//*[@id="CloseBtn"]
    Wait Until Element Is Not Visible     //span[text()="(Check for 'Awaiting Dispense' statuses which may explain reconcile discrepancies)"]    timeout=30s
Open Appointment To Get DOS Appointment
    [Arguments]    ${checked_location}
    ${time_now}    CustomLibrary.Get Time Now
    ${time_now_filter}    Convert Date    ${time_now}    result_format=%m/%d/%Y    date_format=%Y-%m-%d %H:%M:%S.%f
    Go Appointment Ordering Ledger
    Dispense.Filter By Location    ${checked_location}
    Appointment.Select Ledger View
    Appointment.Filter By Date Range    ${time_now_filter}
    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    //*[@id="AppointmentList"]/table    30s
    ${text_contains_amount_appointment}    Get Text    //div[@class="pager"]/div[@class="pager-total text-nowrap"]
    @{splited_amount_appointment}    Split String    ${text_contains_amount_appointment}
    ${amount_appointment}    Set Variable    ${splited_amount_appointment}[-1]
    ${appointment_dos_cols}    Create List
    WHILE    len(${appointment_dos_cols}) < int(${amount_appointment})
        IF    len(${appointment_dos_cols}) > 0
            Click Next In Page Appointment
        END
        ${row_xpath}    Set Variable    //*[@class="accountRow"]
        ${rows}    Get WebElements    ${row_xpath}    
        ${length_rows}    Get Length    ${rows}
        ${date_of_service_and_account}    Get Text    //td[@class="DateOfServiceRow"]//h4
        @{split_strip_date_of_service_and_account}    Split String    ${date_of_service_and_account}    ${SPACE}--${SPACE}
        ${account_corrected}    Set Variable    ${split_strip_date_of_service_and_account}[2]
        FOR    ${index}    IN RANGE    1    ${length_rows}+1
            ${information_appointment}    Create Dictionary
            ${date}    Get Text    //*[@class="accountRow"][${index}]//strong[@class="DateOfServiceLabel"]
            ${time}    Get Text    //*[@class="accountRow"][${index}]//strong[@class="DateOfServiceLabel"]/ancestor::div/following-sibling::div/strong
            ${date_of_service}    Set Variable    ${date} ${time}
            ${date_of_service}    Convert Date    ${date_of_service}    result_format=%m/%d/%Y %I:%M %p    date_format=%m/%d/%Y %I:%M %p
            ${medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]/strong
            IF    $medication == 'No Primary Medications Assigned'
                ${medication}    Set Variable    N/A
            ELSE IF    '/' in $medication
                ${name_medication}     Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]/strong/span[1]
                ${ammount_medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]/strong/span[4]
                ${uom_medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]/strong/span[5]
                ${medication}    Set Variable    ${name_medication}${SPACE}${ammount_medication}${SPACE}${uom_medication}  
            END
            ${icd_code_10}    Get Text    //*[@class="accountRow"][${index}]//div[span[text()="Diagnosis: "]]
            ${icd_code_remove_title}    Remove String    ${icd_code_10}    Diagnosis:
            ${strip_icd_code}    Strip String    ${icd_code_remove_title}
            @{splited_icd}    Split String    ${strip_icd_code}    ,
            ${icd_corrected}    Set Variable    ${splited_icd}[0]
            ${status}    Get Text    //*[@class="accountRow"][${index}]//span[@class="badge appointmentStatusBadge"]
            ${type}    Get Text    //*[@class="accountRow"][${index}]//div[span[text()="Service Type: "]]/strong
            ${type_lower}    Convert To Lower Case    ${type}
            ${type_title}    Convert To Title Case    ${type_lower}
            ${status_type}    Set Variable    ${status}${SPACE}${SPACE}${type_title}
            ${physician}    Get Value    //*[@class="accountRow"][${index}]//div[label[text()="Refer to Provider: "]]/following-sibling::div//input[2]
            IF    $physician != ''
                @{physican_strip}    Split String    ${physician}    (
                @{physican_strip}    Split String    ${physican_strip}[0]    ,
                ${first_name_physican}    Strip String    ${physican_strip}[1]
                ${last_name_physican}    Strip String    ${physican_strip}[0]
                ${physician_corrected}    Set Variable    ${first_name_physican} ${last_name_physican}
            ELSE
                ${physician_corrected}    Set Variable    N/A    
            END
            Set To Dictionary    ${information_appointment}    Account=${account_corrected}
            Set To Dictionary    ${information_appointment}    Date Of Service=${date_of_service}
            Set To Dictionary    ${information_appointment}    Medication=${medication}
            Set To Dictionary    ${information_appointment}    ICD 10 Code=${icd_corrected}
            Set To Dictionary    ${information_appointment}    Status / Type=${status_type}
            Set To Dictionary    ${information_appointment}    Physician=${physician_corrected}
            Append To List    ${appointment_dos_cols}    ${information_appointment}
        END
    END
    RETURN    ${appointment_dos_cols}
Go Appointment Ordering Ledger
    Wait Until Element Is Enabled   link:Ordering    timeout=10s
    Wait Until Keyword Succeeds    3times    3s    Click Element   link:Ordering
    Click Element    //*[contains(@class, 'dropdown open')]//*[text()='Scheduled Appointment Ordering']
    Title Should Be    Appointment Ordering Ledger
Get Appointment DOS In Inventory Reconcile
    ${table}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    //*[@id="SubModalPopup"]//table[@class="table table-bordered"]    outerHTML
    ${list_appointment}    Get All Appointment Dos In Inventory Reconcile    ${table}
    RETURN    ${list_appointment}
Click Next In Page Appointment
    CommonKeywords.Scroll To Bottom
    Click Element    //div[@class="pager ImportListPager"]//a[contains(.,"Next")]
    Wait Until Page Contains Element   //*[@id="AppointmentList"]//*[@class="ajax-loader"]   30s
    Wait Until Page Does Not Contain Element    //*[@id="AppointmentList"]//*[@class="ajax-loader"]    30s
Get Barcode With Random Serial Number
    [Arguments]    ${ndc_part}    ${lot_part}
    ${serial_number}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(8))    random
    RETURN    ${ndc_part}${serial_number}${lot_part}
Go To Homepage
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
