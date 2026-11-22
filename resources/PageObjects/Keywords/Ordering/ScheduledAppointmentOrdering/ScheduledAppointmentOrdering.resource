*** Settings ***
Resource    ../../Layers/AppointmentOrderingLedger/AppointmentOrderingLedger.resource
Resource    ../../Layers/PriorAuthorizations/PriorAuthorizations.resource
*** Keywords ***
System Allows Searching And Selecting Or Unselecting Accounts Successfully
    [Arguments]    ${account_arg}
    Select SAO Account    ${account_arg}
    Unselect SAO Account    ${account_arg}
    Click Clear SAO Account Button

Collapse Assigned Account Table
    Wait Until Element Is Visible    ${sao_assigned_account_table}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${sao_collapse_or_expand_btn}
    Wait Until Element Is Not Visible    ${sao_assigned_account_table}    30s

Expand Assigned Account Table
    Wait Until Element Is Not Visible    ${sao_assigned_account_table}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${sao_collapse_or_expand_btn}
    Wait Until Element Is Visible    ${sao_assigned_account_table}    30s

Verify Assigned Account Table Shows All Accounts
    [Arguments]    ${expected_account_list}
    ${account_name_list}    Get Account Name List
    ${expected_account_list}    Evaluate    ${expected_account_list}
    Sort List    ${expected_account_list}
    Lists Should Be Equal    ${account_name_list}    ${expected_account_list}

Get Account Name List
    ${account_elements}    Get WebElements    //strong[@class="SAOAccountName"]
    ${account_name_list}    Create List
    FOR    ${element}    IN    @{account_elements}
        Wait Until Element Is Visible    ${element}   30s
        ${account_name}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${element}       
        Append To List    ${account_name_list}     ${account_name}
    END
    Sort List    ${account_name_list}
    RETURN    ${account_name_list}

Verify All Accounts Are Selected When Clicking Select All Button
    Click Select All Accounts
    ${account_checkbox_elements}    Get WebElements    //strong[@class="SAOAccountName"]//preceding::input[contains(@class,'SAOAccountCheckbox')]
    FOR    ${element}    IN    @{account_checkbox_elements}
        Checkbox Should Be Selected    ${element}
    END

Verify All Accounts Are Unselected When Clicking Unselect All Button
    Click Unselect All Accounts
    ${account_checkbox_elements}    Get WebElements    //strong[@class="SAOAccountName"]//preceding::input[contains(@class,'SAOAccountCheckbox')]
    FOR    ${element}    IN    @{account_checkbox_elements}
        Checkbox Should Not Be Selected    ${element}
    END

Order Product Through End Date Are Displayed Correctly When Entering End Date
    [Arguments]   ${required_product_enddate_value}
    Click Order Product Through End Date Checkbox
    Input End Date In Order Product Through    ${required_product_enddate_value}
    Wait Until Element Is Visible    //h5[contains(text(),'Fix Unfulfilled Appointments')]    60s

Order Product By Date Range Are Displayed Correctly When Entering Date Range
    [Arguments]    ${restock_product_startdate_value}    ${restock_product_enddate_value}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${restock_product_startdate_value}
    Common.Page Alert Message    You must select an End Date to begin!
    Click Element    //strong[text()='Enter your Date Range ']
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${restock_product_enddate_value}
    Wait Until Element Is Visible    //h5[contains(text(),'Fix Unfulfilled Appointments')]

Scheduled Appointment List Is Opened And Data Loads Successfully
    [Arguments]    ${apt_date}    ${patient_name}    ${apt_status}
    ${dt}    Convert Date    ${apt_date}    date_format=%m/%d/%Y    result_format=datetime
   ${date_formatted}    Format Date No Padding    ${dt}    {m}/{d}/{y}
    Click View Scheduled Appointments Button
    Common.Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']
    # ${approved_apt_row}    Set Variable    //div[@id='LoadAppointmentDiv']//h4[text()='${date_formatted}']/ancestor::div//td[span[contains(text(),'${patient_name}')]]/following-sibling::td[span='${apt_status}']
    ${approved_apt_row}    Set Variable    //td[@class='DateOfServiceRow']//h4[text()='${date_formatted}']/ancestor::div//td[span[contains(text(),'${patient_name}')]]/following-sibling::td[span='${apt_status}']
    Wait Until Element Is Visible    ${approved_apt_row}    30s

Verify Checkbox Is Checked and Disable By Default
    [Arguments]    ${location_default}
    Checkbox Should Be Selected    //strong[normalize-space()='${location_default}']//preceding::input[@type='checkbox'][1]
    ${disabled}=    SeleniumLibrary.Get Element Attribute    //strong[normalize-space()='${location_default}']//preceding::input[@type='checkbox'][1]    disabled
    Should Not Be Empty    ${disabled}
    
Verify Account Display Matching By Keyword Search
    [Arguments]    ${account_arg}    ${expected_account_list}
    Click Clear SAO Account Button
    Input Search SAO Account    ${account_arg}
    Click Find SAO Account Button
    Verify Assigned Account Table Shows All Accounts    ${expected_account_list}

Verify Linked Account Are Display When Selected An Association
    [Arguments]   ${association_arg}    ${expected_account_list}
    Click Clear SAO Account Button
    Select Association    ${association_arg}
    Verify Assigned Account Table Shows All Accounts    ${expected_account_list}
    
Count Selected Options
    [Arguments]    ${locator}
    ${elements}    SeleniumLibrary.Get WebElements    ${locator}
    ${count}=    Set Variable    0
    FOR    ${el}    IN    @{elements}
        ${checked}=    SeleniumLibrary.Get Element Attribute    ${el}    checked
        IF    '${checked}' =='true'
            ${count}=    Evaluate    ${count} + 1
        END
    END
    RETURN    ${count}
    
Verify Default Order Type Selection
    ${count}=    Count Selected Options    //input[@type='radio' and @name='helperType']
    Should Be Equal As Integers    ${count}    1

Compare Start Date Default With Current Date
    ${today}    Util.Covert Time Now    %#m/%#d/%Y
    ${required_product_startdate_value}    Get Start Date In Order Product Through
    Should Be Equal    ${today}    ${required_product_startdate_value}

Input And Compare End Date With Start Date Default 
    ${today}    Check Time Zone
    ${end_date}    Add Time To Date    ${today}    3 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Input End Date In Order Product Through    ${end_date}
    Wait Until Element Is Visible    //h5[contains(text(),'Fix Unfulfilled Appointments')]    30s
    ${required_product_startdate_value}    Get Start Date In Order Product Through
    Should Be True    '${end_date}' <= '${required_product_startdate_value}'

Verify Select Order Product Through End Date
    Click Order Product Through End Date Checkbox
    Element Should Be Disabled    ${sao_required_product_startdate_input}
    Compare Start Date Default With Current Date
    Element Should Be Enabled    ${sao_required_product_enddate_input}
    Input And Compare End Date With Start Date Default

Input Date Range When Select Order Product By Date Range
    ${today}    Check Time Zone
    ${end_date}    Add Time To Date    ${today}    3 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Input Start Date In Order Product By Date Range    ${today}
    Common.Page Alert Message    You must select an End Date to begin!
    Common.Close Calendar Table
    Click Element    //strong[text()='Enter your Date Range ']
    Input End Date In Order Product By Date Range    ${end_date}
    Wait Until Element Is Visible    //h5[contains(text(),'Fix Unfulfilled Appointments')]    60s
    RETURN    ${today}    ${end_date}

Error Message Display When Date Empty
    Common.Scroll And Click Element     ${sao_create_order_for_scheduled_apt_btn}
    Common.Page Alert Message    You must select an Start Date to begin!
    Common.Close Calendar Table
    Wait Until Element Is Not Visible  //h5[contains(text(),'Fix Unfulfilled Appointments')]    60s

Verify Select Order Product By Date Range
    Click Order Product By Date Range Checkbox
    Element Should Be Enabled    ${sao_restock_product_startdate_input}
    Element Should Be Enabled    ${sao_restock_product_enddate_input}
    Error Message Display When Date Empty
    Input Date Range When Select Order Product By Date Range

Verify No Stale Data After Switching
    Click Order Product By Date Range Checkbox
    ${startdate}    SeleniumLibrary.Get Element Attribute    ${sao_restock_product_startdate_input}    value
    ${enddate}    SeleniumLibrary.Get Element Attribute    ${sao_restock_product_enddate_input}    value
    Should Be Empty    ${startdate}    ${enddate}

Verify Data Persistence Behavior
    Click Order Product By Date Range Checkbox
    ${today}    ${end_date}    Input Date Range When Select Order Product By Date Range
    Switching To Another Mode
    ${startdate}    SeleniumLibrary.Get Element Attribute    ${sao_restock_product_startdate_input}    value
    ${enddate}    SeleniumLibrary.Get Element Attribute    ${sao_restock_product_enddate_input}    value
    Should Be Equal    ${today}    ${startdate}
    Should Be Equal    ${end_date}    ${enddate}

Switching To Another Mode
    Click Create an Order for All Scheduled Appointments Button
    Waiting For Loading
    Click Back Button
    Handle Alert    ACCEPT
    Wait Until Element Is Visible    ${sao_title}    30s

Fix Unfulfilled Appointment Table Not Display If Miss Date
    Common.Scroll And Click Element     ${sao_create_order_for_scheduled_apt_btn}
    Common.Page Alert Message    You must select an End Date to begin!
    Common.Close Calendar Table
    Wait Until Element Is Not Visible  //h5[contains(text(),'Fix Unfulfilled Appointments')]

Fix Unfulfilled Appointment Table If No Data
    [Arguments]    ${account_arg}
    Choose SAO Account    ${account_arg}
    Click Order Product By Date Range Checkbox
    Input Date Range When Select Order Product By Date Range
    Scroll And Click Element    //*[@class="SelectedAccountTabs_1" and contains(text(),'${account_arg}')]
    Wait Until Element Is Visible    //h4[contains(text(),'No Appointments Available.')]    30s

Verify Fix Unfulfilled Appointment Table When Its No Data
    [Arguments]    ${account_arg}
    Fix Unfulfilled Appointment Table Not Display If Miss Date
    Fix Unfulfilled Appointment Table If No Data    ${account_arg}
    
Verify Fix UnFulfilled Appointment Table When Data Is Present
    [Arguments]    ${account_arg}    ${medication_arg}
    Scroll And Click Element    //*[@class="SelectedAccountTabs_1" and contains(text(),'${account_arg}')]
    Wait Until Element Is Visible    //*[contains(text(),'${medication_arg} - No Primary Dosage Assigned')]

Can Not Created Order Without Required Data
    [Arguments]    ${account_arg}    ${enddate_arg}
    Missing Date    ${account_arg}
    Missing Account    ${account_arg}    ${enddate_arg}

Missing Date
    [Arguments]    ${account_arg}
    Choose SAO Account    ${account_arg}
    Common.Scroll And Click Element     ${sao_create_order_for_scheduled_apt_btn}
    Common.Page Alert Message    You must select an End Date to begin!
    Common.Close Calendar Table

Missing Account
    [Arguments]    ${account_arg}    ${enddate_arg}
    Choose SAO Account    ${account_arg}
    Input End Date In Order Product Through    ${enddate_arg}
    Common.Scroll And Click Element     ${sao_create_order_for_scheduled_apt_btn}
    Common.Page Alert Message    You must select at least one account before continuing!

Can Not Create Order Without Appointment
    [Arguments]    ${account_arg}    ${date_arg}
    Choose SAO Account    ${account_arg}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${date_arg}
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${date_arg}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Element Is Visible    //h4[contains(text(),'No Items Required To Purchase')]

Verify Can Not Create Order Without Required Data And Appointment
    [Arguments]    ${account_arg}    ${date_arg}
    Can Not Created Order Without Required Data    ${account_arg}    ${date_arg}
    Can Not Create Order Without Appointment    ${account_arg}    ${date_arg}

Verify Select All Behavior With More Than N Accounts
    [Arguments]    ${quality_arg}
    ${account_checkbox_elements}    Get WebElements    //strong[@class="SAOAccountName"]//preceding::input[contains(@class,'SAOAccountCheckbox')]
    ${total_account}    Get Length    ${account_checkbox_elements}
    Should Be True    ${total_account} > ${quality_arg}
    Click Select All Accounts
    ${selected_count}    Count Selected Options    //strong[@class="SAOAccountName"]//preceding::input[contains(@class,'SAOAccountCheckbox')]
    Should Be Equal As Integers    ${selected_count}    ${quality_arg}

Verify Note Format When Schedule Without Therapy
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${startdate_arg}
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${enddate_arg}
    Wait Until Element Is Visible    //*[contains(text(),'No Primary Medication Assigned')]

Verify Note Format When Appointment Unassigned
    [Arguments]    ${medication_arg}    ${date_arg}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${date_arg}
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${date_arg}
    Scroll Element Into View    //*[contains(text(),'${medication_arg}') and contains(text(),'Appointment Type Unassigned')]

Table Reflects Correct Date Range
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Click Order Product Through End Date Checkbox
    Input End Date In Order Product Through    ${enddate_arg}
    Wait Until Element Is Visible    //*[contains(text(),'No Primary Medication Assigned')]
    ${daterange}    Add Time To Date    ${startdate_arg}    3 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${daterange}
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${daterange}
    Wait Until Element Is Visible    //h4[contains(text(),'No Appointments Available.')]    30s

Verify Action With Refresh Unfulfielled Appt
    ${check}    Run Keyword And Return Status    Element Should Be Enabled    ${sao_refresh_unflfilled_apt_btn}
    IF    "${check}" == "${False}"
        Waiting For Loading
        Click Refresh Unfulfilled Button
    END
    Click Refresh Unfulfilled Button

Verify Data In Patient Column
    [Arguments]    ${patient_id_arg}    ${mrn_arg}
    ${patient_txt}    Get Text    (//tr[@class='UnfulfilledAppt']//span[contains(text(),'${patient_id_arg}')]//ancestor::td)[1]
    Should Be Equal As Strings    ${patient_txt}    ${patient_id_arg}\nMRN: ${mrn_arg}

Get All Appointment Count From Account
    [Arguments]    ${data_acc_id_arg}
    ${apt_num}    Get Text    //a[contains(@data-accountid,'${data_acc_id_arg}')]//following-sibling::span[@class='TotalCount badge']
    RETURN    ${apt_num}

Get Badge Color By Account Appointment Count
    [Arguments]    ${data_acc_id_arg}
    ${color}    SeleniumLibrary.Get Element Attribute    
    ...    //a[contains(@data-accountid,'${data_acc_id_arg}')]//following-sibling::span[@class='TotalCount badge']
    ...    style
    RETURN    ${color}

Get All Account Tabs
    ${tabs}    SeleniumLibrary.Get WebElements    //li[contains(@class,'SAOAccEle')]//a
    RETURN    ${tabs}

Get Data Account ID From Tab
    [Arguments]    ${tab_element}
    ${data_acc_id}    SeleniumLibrary.Get Element Attribute    ${tab_element}    data-accountid
    RETURN    ${data_acc_id}

Get Row Count By Account 
    [Arguments]    ${data_acc_id_arg}
    ${row_count}    SeleniumLibrary.Get Element Count    //tr[contains(@class,'UnfulfilledAppt') and contains(@data-accountid,'${data_acc_id_arg}')]
    RETURN    ${row_count}

Verify Badge Color Is Correct
    [Arguments]    ${account_arg}    ${apt_num}
    ${color}    Get Badge Color By Account Appointment Count    ${account_arg}
    IF    ${apt_num} == 0
        Should Contain    ${color}    forestgreen
    ELSE
        Should Contain    ${color}    firebrick
    END

Verify Badge Count Matches Row Count
    [Arguments]    ${data_acc_id_arg}    ${apt_num_arg}
    ${row_count}    Get Row Count By Account    ${data_acc_id_arg}
    Should Be Equal As Integers    ${row_count}    ${apt_num_arg}

Verify All Account Appointment Accounts
    ${tabs}    Get All Account Tabs
    FOR    ${tab}    IN    @{tabs}
        ${data_acc_id}    Get Data Account ID From Tab    ${tab}
        ${apt_num}    Get All Appointment Count From Account    ${data_acc_id}
        Verify Badge Count Matches Row Count    ${data_acc_id}    ${apt_num}
    END
    
Verify Badge Color And Row Count For All Accounts
    ${tabs}    Get All Account Tabs
    FOR    ${tab}    IN    @{tabs}
        ${data_acc_id}    Get Data Account ID From Tab    ${tab}
        ${apt_num}    Get All Appointment Count From Account    ${data_acc_id}
        Verify Badge Color Is Correct    ${data_acc_id}    ${apt_num}
        Verify Badge Count Matches Row Count    ${data_acc_id}    ${apt_num}
    END

Account Action On SAO Screen
    [Arguments]    ${account_arg}    ${daterange}
    Check Account Disable    ${account_arg}
    Choose SAO Account    ${account_arg}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    ${daterange}
    Common.Close Calendar Table
    Input End Date In Order Product By Date Range    ${daterange}

Assign DX Code
    [Arguments]    ${patient_name}    ${icd_arg}
    Click Unfulfilled Appointments Row    ${patient_name}
    Click Assign Code
    Search ICD Code    ${icd_arg}
    Select ICD Code    ${icd_arg}
    Submit Assign DX Code
    Waiting For Loading
    Click Refresh Unfulfilled Button

Assign Physician
    [Arguments]    ${patient_name}    ${npi_arg} 
    Waiting For Loading
    Click Unfulfilled Appointments Row    ${patient_name}
    Click Assign Physician
    Search Physician    ${npi_arg}
    Waiting For Loading
    Select Physician    ${npi_arg}
    Submit Assign Physician
    Waiting For Loading
    Click Refresh Unfulfilled Button

Compare ICD Code Item Selected 
    [Arguments]    ${patient_name_arg}    ${icd_arg}
    ${icd_txt}    Get Text    //h4[contains(text(),'${patient_name_arg}')]//following::*[contains(@onclick,'AssignICD10ToAppointmentModal')]
    Should Be Equal    ${icd_txt}    ${icd_arg}

Compare Physician Selected
    [Arguments]    ${patient_name_arg}
    ${icd_txt}    Get Text    //h4[contains(text(),'${patient_name_arg}')]//following::*[contains(@onclick,'SAOPhysicianSelectModal')]
    Should Be Equal    ${icd_txt}    Dr. Michael Ward 

Verify DX Code And Physician Updated
    [Arguments]    ${patient_name}    ${icd_arg}    ${npi_arg}
    # Scroll Element Into View     ${patient_name}
    Assign DX Code    ${patient_name}    ${icd_arg}
    Assign Physician     ${patient_name}    ${npi_arg}
    Click Unfulfilled Appointments Row    ${patient_name}
    Compare ICD Code Item Selected     ${patient_name}    ${icd_arg}
    Compare Physician Selected    ${patient_name}

Get All Treating Therapy Note
    [Arguments]    ${data_acc_id_arg}
    ${cells}=    Get WebElements    //tr[contains(@class,'UnfulfilledAppt') and contains(@data-accountid,'${data_acc_id_arg}')]//td[3]
    RETURN    ${cells}

Get Valid Unfulfilleds Treating Therapy Note
    ${therapy_notes}=    Create List    
    ...    No Primary Dosage Assigned
    ...    No Primary Medication Assigned
    ...    Appointment Type Unassigned
    RETURN    ${therapy_notes}

Is Valid Unfulfilled Therapy Note
    [Arguments]    ${therapy_note_txt}
    ${therapy_notes}    Get Valid Unfulfilleds Treating Therapy Note
    FOR    ${therapy_note}    IN    @{therapy_notes}
        ${matched}    Run Keyword And Return Status
        ...    Should Contain    ${therapy_note_txt}    ${therapy_note}
        IF    ${matched}    RETURN    ${True}            
    END
    RETURN    ${False}

Verify All Rows Are Unfulfilled
    [Arguments]    ${data_acc_id_arg}
    ${cells}    Get All Treating Therapy Note    ${data_acc_id_arg}
    ${invalid_rows}=    Create List
    FOR    ${cell}    IN    @{cells}
        ${text}=    Get Text    ${cell}
        ${is_valid}=    Is Valid Unfulfilled Therapy Note    ${text}
        IF    not ${is_valid}
            Append To List    ${invalid_rows}    ${text}
        END
    END
    Should Be Empty    ${invalid_rows}
    
Verify Table Shows All Appointments Are Unfulfilled
    [Arguments]    ${account_arg}
    ${data_acc_id}    Get Data Account ID From Tab    //*[@class="SelectedAccountTabs_1" and contains(text(),'${account_arg}')]
    Verify All Rows Are Unfulfilled    ${data_acc_id}

Get All MRN Cells 
    [Arguments]    ${data_acc_id_arg}
    ${cells}    Get WebElements    //tr[contains(@class,'UnfulfilledAppt') and contains(@data-accountid,'${data_acc_id_arg}')]//td[2]//div
    RETURN    ${cells}

Is Valid MRN Format
    [Arguments]    ${mrn_line}
    ${has_prefix}    Run Keyword And Return Status    Should Start With    ${mrn_line}    MRN:
    IF    not ${has_prefix}    RETURN    ${False}
    ${mrn_value}    Fetch From Right    ${mrn_line}    MRN: \
    ${mrn_value}    Strip String    ${mrn_value}
    ${is_not_empty}    Run Keyword And Return Status    
    ...    Should Not Be Empty    ${mrn_value}
    RETURN    ${is_not_empty}

Verity All MRN Formats Are Valid
    [Arguments]    ${account_arg}
    ${data_acc_id}    Get Data Account ID From Tab    //*[@class="SelectedAccountTabs_1" and contains(text(),'${account_arg}')]
    ${cells}=    Get All MRN Cells    ${data_acc_id}
    ${invalid_mrns}=    Create List
    FOR    ${cell}    IN    @{cells}
        ${txt}    Get Text    ${cell}
        ${is_valid}    Is Valid MRN Format    ${txt}
        IF    not ${is_valid}
            Append To List    ${invalid_mrns}    ${txt}
        END
    END
    Should Be Empty    ${invalid_mrns}

Check Account Disable
    [Arguments]    ${account_arg}
    ${checkbox}=    Get WebElement    //strong[@class="SAOAccountName" and text()='${account_arg}']//preceding::input[contains(@class,'SAOAccountCheckbox')][1]
    ${is_disabled}=    SeleniumLibrary.Get Element Attribute    ${checkbox}    disabled
    Return From Keyword If    '${is_disabled}' == 'None'
    Wait Until Element Is Visible    //strong[@class="SAOAccountName" and text()='${account_arg}']//following::a[contains(@onclick,'UnlockSAOCheckbox')][1]
    Wait Until Keyword Succeeds    30s    1s    Click Element    //strong[@class="SAOAccountName" and text()='${account_arg}']//following::a[contains(@onclick,'UnlockSAOCheckbox')][1]
    