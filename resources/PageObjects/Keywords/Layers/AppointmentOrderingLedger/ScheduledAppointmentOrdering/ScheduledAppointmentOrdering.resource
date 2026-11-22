*** Settings ***
Resource    ../../Common/Common.resource

*** Variables ***
${sao_account_search_input}    //input[@id="SAOAccountSearchText"]
${sao_account_find_btn}    //button[@id="SAOAccountFindBtn"]
${sao_account_clear_btn}    //button[@id="SAOAccountClearBtn"]
${sao_association_select}    //select[@id="SAOAssociation"]
${sao_unselect_all_account_btn}    //a[@id="SAOUnselectAllAccountsBtn"]
${sao_select_all_account_btn}    //a[@id="SAOSelectAllAccountsBtn"]
${sao_assigned_account_table}    //div[@id="AssignedAccountTable"]
${sao_collapse_or_expand_btn}    //a[contains(text(),'Collapse/Expand Available Accounts')]
${sao_required_product_helper_checkbox}    //input[@id="RequiredProductHelper"]
${sao_restock_product_helper_checkbox}    //input[@id="RestockProductHelper"]
${sao_required_product_startdate_input}    //div[contains(@class,'RequiredProduct')]//child::label[contains(text(),'Start Date')]//following-sibling::input
${sao_required_product_enddate_input}    //input[@id="OrderAppointmentTimeRange"]
${sao_restock_product_startdate_input}    //input[@id="OrderAppointmentStartDate"]
${sao_restock_product_enddate_input}    //input[@id="OrderAppointmentEndDate"]
${sao_create_order_for_scheduled_apt_btn}    //a[text()="Create an Order for 'All Scheduled' Appointments"]
${sao_create_order_for_approved_apt_btn}    //a[text()="Create an Order for 'Approved' Appointments"]
${sao_fulfill_par_levels_checkbox}    //input[@id="FulfillPars"]
${sao_view_scheduled_appointments_btn}    //a[contains(text(),'View Scheduled Appointments')]
${add_missing_appointmnets_title}    //div[@id="LoadAppointmentDiv"]//following::h5[contains(text(),'Add Missing Appointments')]
${sao_build_order_btn}    //a[contains(@class,'SubmitOrderButton')]
${sao_back_btn}    //*[contains(@onclick,"GoBackToReviewAppointmentPage()")]
${sao_refresh_unflfilled_apt_btn}    //a[@id="RefreshUnfulfilledAppt"]
${sao_assign_code_btn}    //a[contains(@onclick,'AssignICD10ToAppointmentModal')]
${sao_assign_physician_btn}    //a[contains(@onclick,'SAOPhysicianSelectModal')]
${sao_search_icd_input}    //input[@id="ICDSearchValues"]
${sao_search_physician_input}    //input[@id="PhysicianSearchText"]



*** Keywords ***
Filter SAO Account
    [Arguments]    ${account_arg}
    Click Clear SAO Account Button
    Input Search SAO Account    ${account_arg}
    Click Find SAO Account Button
    ${sao_account_row}    Set Variable    //strong[@class="SAOAccountName" and text()='${account_arg}']
    Wait Until Element Is Visible    ${sao_account_row}    30s

Click Find SAO Account Button
    Common.Scroll And Click Element     ${sao_account_find_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-3x fa-spin"]

Input Search SAO Account
    [Arguments]    ${account_arg}
    Wait Until Element Is Visible    ${sao_account_search_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_account_search_input}    ${account_arg}

Click Clear SAO Account Button
    Common.Scroll And Click Element     ${sao_account_clear_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-3x fa-spin"]

Choose SAO Account
    [Arguments]    ${account_arg}
    ${account_checkbox}    Set Variable    //strong[@class="SAOAccountName" and text()='${account_arg}']//preceding::input[contains(@class,'SAOAccountCheckbox')][1]
    Wait Until Element Is Visible    ${account_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${account_checkbox}

Select Association
    [Arguments]    ${association_arg}
    Wait Until Element Is Enabled    ${sao_association_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${sao_association_select}    ${association_arg}

Click Unselect All Accounts
    Common.Scroll And Click Element     ${sao_unselect_all_account_btn}

Click Select All Accounts
    Common.Scroll And Click Element     ${sao_select_all_account_btn}

Select SAO Account
    [Arguments]    ${account_arg}
    ${account_checkbox}    Set Variable    (//strong[@class="SAOAccountName" and text()='${account_arg}']//preceding::input[contains(@class,'SAOAccountCheckbox')])[1]
    ${check}    Run Keyword And Return Status    Checkbox Should Not Be Selected    ${account_checkbox}
    IF    '${check}' == ${True}
        Common.Scroll And Click Element    ${account_checkbox}
    END
    
Unselect SAO Account
    [Arguments]    ${account_arg}
    ${account_checkbox}    Set Variable    (//strong[@class="SAOAccountName" and text()='${account_arg}']//preceding::input[contains(@class,'SAOAccountCheckbox')])[1]
    ${check}    Run Keyword And Return Status    Checkbox Should Be Selected    ${account_checkbox}
    IF    '${check}' == ${True}
        Common.Scroll And Click Element    ${account_checkbox}
    END
    
Click Order Product Through End Date Checkbox
    Common.Scroll And Click Element     ${sao_required_product_helper_checkbox}
    Wait Until Element Is Visible    //strong[text()='Enter your End Date']    30s

Get Start Date In Order Product Through
    Wait Until Element Is Visible    ${sao_required_product_startdate_input}    30s
    ${required_product_startdate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${sao_required_product_startdate_input}
    RETURN    ${required_product_startdate_value}

Input End Date In Order Product Through
    [Arguments]    ${required_product_enddate_arg}
    Wait Until Element Is Visible    ${sao_required_product_enddate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_required_product_enddate_input}    ${required_product_enddate_arg}
    Common.Close Calendar Table

Click Order Product By Date Range Checkbox
    Common.Scroll And Click Element     ${sao_restock_product_helper_checkbox}
    Wait Until Element Is Visible    //strong[text()='Enter your Date Range ']    30s

Input Start Date In Order Product By Date Range
    [Arguments]    ${order_product_enddate_arg}
    Wait Until Element Is Visible    ${sao_restock_product_startdate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_restock_product_startdate_input}    ${order_product_enddate_arg}
    Common.Close Calendar Table

Input End Date In Order Product By Date Range
    [Arguments]    ${order_product_enddate_arg}
    Wait Until Element Is Visible    ${sao_restock_product_enddate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_restock_product_enddate_input}    ${order_product_enddate_arg}
    Common.Close Calendar Table

Click Refresh Unfulfilled Button
    Common.Scroll And Click Element    //*[contains(@id,'RefreshUnfulfilled') and contains(text(),'Refresh Unfulfill')]

Select Or Unselect Fulfill ParLevels Checkbox
    [Arguments]    ${is_select}
    Run Keyword If    ${is_select} == ${True}    Select Checkbox    id\=FulfillPars
    ...  ELSE
    ...    Unselect Checkbox    id\=FulfillPars

Click Create an Order for All Scheduled Appointments Button
    Common.Scroll And Click Element     ${sao_create_order_for_scheduled_apt_btn}
    Wait Until Element Is Visible    //div[@id="ModalPopup"]    30s

Click Create an Order for Approved Appointments Button
    Common.Scroll And Click Element     ${sao_create_order_for_approved_apt_btn}
    Wait Until Element Is Visible    //div[@id="ModalPopup"]    30s

Click Back Button
    Common.Scroll And Click Element    link: Back

Input Qty To Order
    [Arguments]    ${ndc}    ${qty}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'OrderTableRow')]//text()[contains(.,'${ndc}')][1]//following::*[@id='QtyToOrder'][1]
    Input Text    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'OrderTableRow')]//text()[contains(.,'${ndc}')][1]//following::*[@id='QtyToOrder'][1]    ${qty}    clear=True
    Execute JavaScript    document.activeElement.blur()

Input Qty To Order Other Contracted
    [Arguments]    ${ndc}    ${qty}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'otherTherapyRow')]//text()[contains(.,'${ndc}')][1]//following::*[contains(@class,'DrugQty')][1]
    Input Text    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'otherTherapyRow')]//text()[contains(.,'${ndc}')][1]//following::*[contains(@class,'DrugQty')][1]    ${qty}
    Execute JavaScript    document.activeElement.blur()

Click Build Order Button
    Common.Scroll And Click Element     ${sao_build_order_btn}

Click Build All Orders Button
    Common.Scroll And Click Element     link: Build All Orders

Click View Scheduled Appointments Button
    Common.Scroll And Click Element     ${sao_view_scheduled_appointments_btn}
    Wait Until Element Is Visible    ${add_missing_appointmnets_title}    30s

Close Scheduled Appointments Popup
    Common.Scroll And Click Element     //*[@id='ModalPopup']//*[@id='TopCloseBtn']

Click Unfulfilled Appointments Row
    [Arguments]    ${patient_name}
    Scroll And Click Element    //span[contains(text(),'${patient_name}')]//ancestor::tr

Click Assign Code
    Common.Scroll And Click Element     ${sao_assign_code_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Assign Appointment DX Code')]    30s

Search ICD Code
    [Arguments]    ${icd_arg}
    Clear Input Field Until Empty    ${sao_search_icd_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_search_icd_input}    ${icd_arg}
    Click Element    //*[@id="ICDFindButton"]

Select ICD Code
    [Arguments]    ${icd_arg}
    Scroll And Click Element    //span[contains(text(),'${icd_arg}')]//ancestor::tr//input[@type='radio']

Submit Assign DX Code
    Scroll And Click Element    //*[@id='SaveBtn' and contains(text(),'Assign DX Code')]

Click Assign Physician
    Common.Scroll And Click Element     ${sao_assign_physician_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Assign Provider to Appointment')]    30s

Search Physician
    [Arguments]    ${physician_arg}
    Clear Input Field Until Empty    ${sao_search_physician_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${sao_search_physician_input}    ${physician_arg}
    Click Element    //*[@id="PhysicianFindButton"]

Select Physician
    [Arguments]    ${physician_npi_arg}
    Scroll And Click Element    //input[contains(@data-npi,'${physician_npi_arg}')]

Submit Assign Physician
    Scroll And Click Element    //*[@id='SaveBtn' and contains(text(),'Assign')]
    Common.Page Alert Message    Physician Added to Appointment.

Click To Export SAO Data To Excel
    Common.Scroll And Click Element    link: Export To Excel

Click Add Other Contracted
    [Arguments]    ${num_tab}=1
    Common.Scroll And Click Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'ExpandButton')]//*[contains(text(),'Other Contracted')][1]

Input To Search Other Contracted
    [Arguments]    ${ndc}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@placeholder,'Search for item')]
    Input Text    //*[contains(@placeholder,'Search for item')]    ${ndc}
    Execute JavaScript    document.activeElement.blur()

Click Find Other Contracted Button
    [Arguments]    ${num_tab}=1
    Click Button    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'OtherTherapyFindBtn')]

Click To Add Item To Order
    [Arguments]    ${ndc}    ${num_tab}=1
    Common.Scroll And Click Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'otherTherapyRow')]//text()[contains(.,'${ndc}')][1]//following::*[contains(@class,'addItemToOrder')][1]

Click Unlock Account
    [Arguments]    ${acc}
    Common.Scroll And Click Element    //*[contains(@class,'Account') and contains(text(),'${acc}')]//following::*[@onclick and contains(text(),'Unlock')][1]