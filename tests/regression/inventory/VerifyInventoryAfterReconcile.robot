*** Settings ***
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(2)    Accounting    inventory    Regression    IV_013

*** Test Cases ***
Go To Reconcile Inventory To Complete Reconcile With Strict Note Turn On
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_98    [reconcile]_106
    ...  report.label.owner:Quoc Nguyen
    [Setup]   Setup Test Case With Strict Note Turn On
    ${barcode}    InventoryUtils.Get Barcode With Random Serial Number    ${data_input}[ndc_part]    ${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode}']}}

    OpenActiveReconcile.Complete Reconcile With Strict Note Turn On
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    add    ${{['${barcode}']}}
    OpenActiveReconcile.Complete Reconcile With Strict Note Turn On
    [Teardown]    Teardown Test Case And Turn Off Stict Note

Go To Reconcile Inventory To Complete Inventory Reconcile And Verify Inventory
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_99    [reconcile]_100    [reconcile]_105    [reconcile]_107    [reconcile]_108
    ...  report.label.owner:Quoc Nguyen
    ${barcode}    InventoryUtils.Get Barcode With Random Serial Number    ${data_input}[ndc_part]    ${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode}']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${table_value_dict}
    OpenActiveReconcile.Complete Reconcile
    Verify All Value Item In Inventory Reconcile To Inventory Level Lot Breakout    full    ${table_value_dict}

    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    add    ${{['${barcode}']}}
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${table_value_dict}
    OpenActiveReconcile.Complete Reconcile
    Verify All Value Item In Inventory Reconcile To Inventory Level Lot Breakout    add    ${table_value_dict}    

Go To Reconcile Inventory To Complete Inventory Reconcile And Verify Transactions
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_101    [reconcile]_109
    ...  report.label.owner:Quoc Nguyen
    ${barcode}    InventoryUtils.Get Barcode With Random Serial Number    ${data_input}[ndc_part]    ${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode}']}}
    ${name_user_create}    OpenActiveReconcile.Get Name User Create Reconcile
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${table_value_dict}
    OpenActiveReconcile.Complete Reconcile
    Verify Item Value Contain In Inventory Level Transition    Inventory Reconcile    ${name_user_create}    ${table_value_dict}

    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    add    ${{['${barcode}']}}
    ${name_user_create}    OpenActiveReconcile.Get Name User Create Reconcile
    ${table_value_dict}    OpenActiveReconcile.Get Value Item In Table Reconcile
    OpenActiveReconcile.Add All Price Item In View All Items With Index To Value Dict    ${table_value_dict}
    OpenActiveReconcile.Complete Reconcile
    Verify Item Value Contain In Inventory Level Transition    Inventory Reconcile - Product Add    ${name_user_create}    ${table_value_dict}

Go To Reconcile Inventory To Complete Add Product To Inventory Reconcile And Verify Item Tracker
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_102    [reconcile]_104    [reconcile]_110    [reconcile]_112    [reconcile]_114
    ...  report.label.owner:Quoc Nguyen
    ${barcode}    Get Barcode With Random Serial Number    ${data_input}[ndc_part]    ${data_input}[lot_part]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode}']}}
    OpenActiveReconcile.Complete Reconcile
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    SerializedItemTracker.Open Serialized Item Tracker
    SerializedItemTracker.Search Barcode Item In Tab Last Activity    ${barcode}
    SerializedItemTracker.Close Serialize Item Tracker
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    add    ${{['${barcode}']}}
    OpenActiveReconcile.Complete Reconcile
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${data_input}[checked_location]    ${data_input}[checked_facility]
    SerializedItemTracker.Open Serialized Item Tracker
    SerializedItemTracker.Search Barcode Item In Tab Last Activity    ${barcode}
    SerializedItemTracker.Close Serialize Item Tracker

Go To Reconcile Inventory To Open List of Reconcile Location Appointments & Statuses
    [Documentation]    Verify Inventory Reconcile To Inventory
    [Tags]    [reconcile]_115    [reconcile]_116    [reconcile]_117    [reconcile]_118
    ...  report.label.owner:Quoc Nguyen
    ${barcode}    Get Barcode With Random Serial Number    ${data_input}[ndc_part]    ${data_input}[lot_part]
    ${expected_dos_appointments}    Open Appointment To Get DOS Appointment    ${data_input}[checked_location]
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility Then Add Item By Scanning    
    ...    ${data_input}[checked_location]    ${data_input}[checked_facility]    
    ...    full    ${{['${barcode}']}}
    OpenActiveReconcile.Open List of Reconcile Location Appointments & Statuses
    ${actual_dos_appointments}    OpenActiveReconcile.Get Appointment DOS In Inventory Reconcile
    OpenActiveReconcile.Close List of Reconcile Location Appointments & Statuses
    OpenActiveReconcile.Complete Reconcile
    ${actual_dos_appointments_json}    Evaluate    sorted([json.dumps(d, sort_keys=True) for d in ${actual_dos_appointments}])    json
    ${expected_dos_appointments_json}    Evaluate    sorted([json.dumps(d, sort_keys=True) for d in ${expected_dos_appointments}])    json
    Lists Should Be Equal     ${actual_dos_appointments_json}    ${expected_dos_appointments_json}

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    user_name=${Username}    password=${Password}
Setup Test Case
    InventoryReconcile.Go To Inventory Reconcile And Reset Reconcile    ${data_input}[checked_location]    ${data_input}[checked_facility]
Setup Test Case With Strict Note Turn On
    Setup Test Case
    MyAccount.Go To My Account
    MyAccount.Select Inventory Reconcile Complexity    Add & Full Reconcile Only Visible - STRICT NOTES
    MyAccount.Save Change

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Test Case And Turn Off Stict Note
    Teardown Test Case
    MyAccount.Go To My Account
    MyAccount.Select Inventory Reconcile Complexity    Every Reconcile Type is Visible
    MyAccount.Save Change
Teardown Suite
    Close Browser

Verify All Value Item In Inventory Reconcile To Inventory Level Lot Breakout
    [Arguments]    ${type}    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        ${data_item_inventory_level}    InventoryLevels.Get Item List In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${ndc_dict}[ndc]    ${ndc_dict}[uom]            
        Verify Item Value Reconcile To Inventory Level Lot Breakout    ${type}    ${data_item_inventory_level}    ${ndc_dict}[list_item]    
    END

Verify Item Value Reconcile To Inventory Level Lot Breakout
    [Arguments]    ${type}    ${lot_breakout_data_dict}    ${item_reconcile_data_dict}
    ${normalized_uom_reconcile_data_dict}    Normalize Value From Reconcile Table In Inventory Reconcile    ${type}    ${item_reconcile_data_dict}
    ${normalized_lot_breakout_data_dict}    Normalize Value From Lot Breakout In Inventory Level    ${lot_breakout_data_dict}
    Should Be Equal    ${normalized_lot_breakout_data_dict}    ${normalized_uom_reconcile_data_dict}

Verify Item Value Contain In Inventory Level Transition
    [Arguments]    ${type_transition}    ${name_user_create}    ${table_value_dict}
    FOR    ${ndc_dict}    IN    @{table_value_dict}
        ${actual_transactions_list}    InventoryLevels.Get Transaction List In Inventory Level    ${data_input}[checked_location]    ${data_input}[checked_facility]    ${ndc_dict}[ndc]    ${ndc_dict}[uom]    
        FOR    ${item_dict}    IN    @{ndc_dict}[list_item]
            ${transactions_item}    Normalize Value Expected Transition In Inventory Reconcile   ${data_input}[checked_location]    ${data_input}[checked_facility]    ${ndc_dict}[ndc]    ${ndc_dict}[uom]         
            ...    ${type_transition}    ${name_user_create}    ${item_dict}[actual_qty]    ${item_dict}[lot]    ${item_dict}[expired_date]     ${item_dict}[price]           
        END
        Should Be Equal    ${actual_transactions_list}[0]    ${transactions_item}
    END

Normalize Value From Reconcile Table In Inventory Reconcile
    [Arguments]    ${type}    ${item_reconcile_data_dict}
    ${normalized_item_reconcile_data_dict_list}    Create List
    FOR    ${item_reconcile_data}    IN    @{item_reconcile_data_dict}
        IF    "${type}" == "full"
            ${actual_qty}    Evaluate    round(float(${item_reconcile_data}[actual_qty]), 1)
        END
        IF    "${type}" == "add"
            ${actual_qty}    Evaluate    round(float(${item_reconcile_data}[discrepancy]), 1)
        END
        ${coverted_expired_date}    Convert Date    ${item_reconcile_data}[expired_date]    result_format=%Y-%m-%d    date_format=%m/%d/%Y
        ${coverted_price}    Evaluate    round(float(${item_reconcile_data}[price]), 2)
        ${coverted_cost}    Evaluate    ${actual_qty} * ${coverted_price}
        ${normalized_uom_reconcile_data_dict}    Create Dictionary
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    lot=${item_reconcile_data}[lot]
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    expired_date=${coverted_expired_date}
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    price=${coverted_price}
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    qty_on_hand=${actual_qty}
        Set To Dictionary    ${normalized_uom_reconcile_data_dict}    cost=${coverted_cost}
        Append To List    ${normalized_item_reconcile_data_dict_list}    ${normalized_uom_reconcile_data_dict}
    END 
    RETURN    ${normalized_item_reconcile_data_dict_list}

Normalize Value From Lot Breakout In Inventory Level
    [Arguments]    ${lot_breakout_data_dict}
    ${normalized_lot_breakout_data_dict_list}    Create List
    FOR    ${lot_breakout_data}    IN    @{lot_breakout_data_dict}
        ${coverted_expired_date}    Convert Date    ${lot_breakout_data}[expired_date]    result_format=%Y-%m-%d    date_format=%m/%d/%Y
        ${coverted_price}    Evaluate    round(float(${lot_breakout_data}[price]), 2)
        ${normalized_lot_breakout_data_dict}    Create Dictionary
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    lot=${lot_breakout_data}[lot]
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    expired_date=${coverted_expired_date}
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    price=${lot_breakout_data}[price]
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    qty_on_hand=${lot_breakout_data}[qty_on_hand]
        Set To Dictionary    ${normalized_lot_breakout_data_dict}    cost=${lot_breakout_data}[cost]
        Append To List    ${normalized_lot_breakout_data_dict_list}    ${normalized_lot_breakout_data_dict}
    END 
    RETURN    ${normalized_lot_breakout_data_dict_list}

Normalize Value Expected Transition In Inventory Reconcile
    [Arguments]    ${checked_location}    ${checked_facility}    ${ndc}    ${uom}    ${type}    ${create_by}    ${adjustment}    ${lot_no}    ${expired_date}    ${price}       
    ${round_best_price}    Evaluate    round(float(${price}), 2)
    ${covert_expired_date}    Convert Date    ${expired_date}    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${coverted_adjustment}    Evaluate    int(${adjustment})

    ${expected_transaction}    Create Dictionary
    Set To Dictionary    ${expected_transaction}    type=${type}
    Set To Dictionary    ${expected_transaction}    created_by=${create_by}
    Set To Dictionary    ${expected_transaction}    adjustment=${coverted_adjustment}
    Set To Dictionary    ${expected_transaction}    price=${round_best_price}
    Set To Dictionary    ${expected_transaction}    lot_no=${lot_no}
    Set To Dictionary    ${expected_transaction}    expiration=${covert_expired_date}
    RETURN    ${expected_transaction}


# All keywords below should be placed in resource file relate appointment , please remove and refactor it later
Open Appointment To Get DOS Appointment
    [Arguments]    ${checked_location}
    ${time_now}    CustomLibrary.Get Time Now
    ${time_now_filter}    Convert Date    ${time_now}    result_format=%m/%d/%Y    date_format=%Y-%m-%d %H:%M:%S.%f
    Go Appointment Ordering Ledger
    Filter By Location    ${checked_location}
    Select Ledger View
    Filter By Date Range    ${time_now_filter}
    Click Element    link:Search
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
            ${time}    Get Text    //*[@class="accountRow"][${index}]//div[@style="font-size: 18px; color: #fff;"]/strong
            ${date_of_service}    Set Variable    ${date} ${time}
            ${date_of_service}    Convert Date    ${date_of_service}    result_format=%m/%d/%Y %I:%M %p    date_format=%m/%d/%Y %I:%M %p
            ${medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]//strong
            IF    $medication == 'No Primary Medications Assigned'
                ${medication}    Set Variable    N/A
            ELSE IF    '/' in $medication
                ${name_medication}     Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]//strong/span[1]
                ${ammount_medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]//strong/span[4]
                ${uom_medication}    Get Text    //*[@class="accountRow"][${index}]//*[contains(@id,"ApptMedColumn_")]//strong/span[5]
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
                ${first_name_physican_remove_dr}    Remove String    ${first_name_physican}    ${SPACE}Dr.
                ${last_name_physican}    Strip String    ${physican_strip}[0]
                ${physician_corrected}    Set Variable    ${first_name_physican_remove_dr} ${last_name_physican}
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
Click Next In Page Appointment
    CommonKeywords.Scroll To Bottom
    Click Element    //div[@class="pager ImportListPager"]//a[contains(.,"Next")]
    Wait Until Page Contains Element   //*[@id="AppointmentList"]//*[@class="ajax-loader"]   30s
    Wait Until Page Does Not Contain Element    //*[@id="AppointmentList"]//*[@class="ajax-loader"]    30s
Go Appointment Ordering Ledger
    Wait Until Element Is Enabled   link:Ordering    timeout=10s
    Wait Until Keyword Succeeds    3times    3s    Click Element   link:Ordering
    Click Element    //*[contains(@class, 'dropdown open')]//*[text()='Scheduled Appointment Ordering']
    Title Should Be    Appointment Ordering Ledger
Filter By Location
    [Arguments]    ${location}
    Wait Until Page Contains Element    //*[contains(@class,"hidden") and @id="_MemberLoader"]    timeout=10s
    Wait Until Element Is Enabled    id=MemberId    timeout=10s
    Select From List By Label    id=MemberId    ${location}
Select Ledger View
    Wait Until Keyword Succeeds    30s    1s    Mouse Over    //*[@id='body']//*[@href='/' and contains(text(),'Home')]
    Wait Until Element Is Enabled    id=appointmentViewsDropdown    timeout=30s
    Scroll Element Into View    id=appointmentViewsDropdown
    Wait Until Element Is Visible    id=appointmentViewsDropdown    60s
    ${view}    Get Text    id=appointmentViewsDropdown
    ${check}    Run Keyword And Return Status    Should Be Equal    ${view}    Ledger View    strip_spaces=True
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    id=appointmentViewsDropdown
        Wait Until Keyword Succeeds    60s    1s    Click Element   link:Ledger View
    END
Filter By Date Range
    [Arguments]    ${date_time}
    Wait Until Element Is Enabled    //*[@id='StartDate']    60s
    Wait Until Keyword Succeeds    60s    1s    Input Text    //*[@id='StartDate']    ${date_time}
    Wait Until Keyword Succeeds    60s    1s    Input Text    //*[@id='EndDate']    ${date_time}
    Wait Until Element Is Enabled    //button[text()='Done']
    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("//button[text()='Done']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Wait Until Element Is Not Visible    //button[text()='Done']    60
