*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${billable_filter_by_location_select}    //select[@id="MemberId"]
${billable_filter_by_medication_select}    //select[@id="Medication"]
${billable_filter_by_patient_input}    //input[@id="BillingLedgerPatientId"]
${billable_start_date_input}    //input[@id="StartDate"]
${billable_end_date_input}    //input[@id="EndDate"]
${billable_search_btn}    //a[contains(@class,'BillingLedgerSearchBtn')]
${billable_cpt_code_input}    //input[contains(@class,'CPTCodeBillingResult tt-input')]
${billable_days_units_input}    //input[contains(@class,'DaysUnits')]
${billable_save_btn}    //a[contains(@class,'SaveBillingResultLineBtn')]
${billing_change_btn}    //a[@id="BillingChanges"]

*** Keywords ***
Go To Billable Event Ledger Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Billable Events
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Billable Event Ledger

Filter Billable Event
    [Arguments]    ${location_arg}    ${medication_arg}    ${mrn_arg}    ${start_date_arg}    ${end_date_arg}
    Filter By Location In Billable Event Ledger Page    ${location_arg}
    Filter By Medication In Billable Event Ledger Page    ${medication_arg}
    Filter By Patient In Billable Event Ledger Page    ${mrn_arg}
    Filter By Date Range In Billable Event Ledger Page    ${start_date_arg}    ${end_date_arg}
    Click Search Button In Billable Event Ledger Page

Filter By Location In Billable Event Ledger Page
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${billable_filter_by_location_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${billable_filter_by_location_select}    ${location_arg}

Filter By Medication In Billable Event Ledger Page
    [Arguments]    ${medication_arg}
    Wait Until Element Is Enabled    ${billable_filter_by_medication_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${billable_filter_by_medication_select}    ${medication_arg}

Filter By Patient In Billable Event Ledger Page
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    //div[contains(text(),'MRN: ${mrn_arg}')]
        Common.Clear Input Field Until Empty    ${billable_filter_by_patient_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${billable_filter_by_patient_input}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    2s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            Exit For Loop
        END
    END

Filter By Date Range In Billable Event Ledger Page
    [Arguments]    ${start_date_arg}    ${end_date_arg}
    Input Start Date In Billable Event Ledger Page    ${start_date_arg}
    Input End Date In Billable Event Ledger Page    ${end_date_arg}

Input Start Date In Billable Event Ledger Page
    [Arguments]    ${start_date_arg}
    Wait Until Element Is Visible    ${billable_start_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${billable_start_date_input}    ${start_date_arg}

Input End Date In Billable Event Ledger Page
    [Arguments]    ${end_date_arg}
    Wait Until Element Is Visible    ${billable_end_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${billable_end_date_input}    ${end_date_arg}

Click Search Button In Billable Event Ledger Page
    Common.Scroll And Click Element    ${billable_search_btn}

Click Open Appointment Button In Billable Event Ledger Page
    [Arguments]    ${apt_date_arg}
    ${open_appointment_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//following::a[text()='Open Appointment'][1]
    Common.Scroll And Click Element    ${open_appointment_btn}

Click Document Button In Billable Event Ledger Page
    [Arguments]    ${apt_date_arg}
    ${documents_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//preceding::a[contains(@class,'documentBtn')][1]
    Common.Scroll And Click Element    ${documents_btn}
    Wait Until Element Is Visible    //div[@id="ModalPopup"]    30s

Click View Changes Button In Billable Event Ledger Page
    [Arguments]    ${apt_date_arg}
    ${view_changes_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//preceding::a[contains(text(),'View Changes')][1]
    Common.Scroll And Click Element    ${view_changes_btn}
    Wait Until Element Is Visible    //div[@id="SubModalPopup"]    30s

Click Billing Change Button
    Common.Scroll And Click Element    ${billing_change_btn}

Click Unlock Button
    [Arguments]    ${apt_date_arg}
    ${unlock_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//following::a[contains(@class,'UnlockLockBillingFieldsBtn')]
    Wait Until Element Is Visible    ${unlock_btn}    30s
    ${status_btn}    Run Keyword And Return Status    SeleniumLibrary.Element Text Should Be    ${unlock_btn}    Unlock
    IF    '${status_btn}' == '${True}'
        Common.Scroll And Click Element    ${unlock_btn}
    END

Click Lock Button
    [Arguments]    ${apt_date_arg}
    ${lock_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//following::a[contains(@class,'UnlockLockBillingFieldsBtn')]
    Wait Until Element Is Visible    ${lock_btn}    30s
    ${status_btn}    Run Keyword And Return Status    SeleniumLibrary.Element Text Should Be    ${lock_btn}    Lock
    IF    '${status_btn}' == '${True}'
        Common.Scroll And Click Element    ${lock_btn}
    END

Click Add Line Button
    [Arguments]    ${apt_date_arg}
    ${add_line_btn}    Set Variable    //strong[@class="DateOfServiceLabel" and text()='${apt_date_arg}']//following::a[contains(@class,'DisplayNewBillingLineBtn')]
    Wait Until Element Is Enabled    ${add_line_btn}
    Common.Scroll And Click Element    ${add_line_btn}
    Wait Until Element Is Visible    //tr[@class="AdditionalBillingResultLineRow"]    30s

Input Cpt Code
    [Arguments]    ${cpt_code_arg}
    ${cpt_code_selected}    Set Variable    (//strong[@class="tt-highlight" and text()='${cpt_code_arg}']//parent::div)[1]
    Wait Until Element Is Visible    ${billable_cpt_code_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${billable_cpt_code_input}    ${cpt_code_arg}
    Wait Until Element Is Visible    ${cpt_code_selected}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${cpt_code_selected}

Input Days Units
    [Arguments]    ${day_unit_arg}
    Wait Until Element Is Visible    ${billable_days_units_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${billable_days_units_input}    ${day_unit_arg}

Click Save Button
    Common.Scroll And Click Element    ${billable_save_btn}

Add Cpt Code Successfully
    [Arguments]    ${cpt_code_arg}    ${day_unit_arg}
    Input Cpt Code    ${cpt_code_arg}
    Input Days Units    ${day_unit_arg}
    Click Save Button
    Common.Page Alert Message    CPT Assigned.

Verify Change History Loads Correctly
    [Arguments]    ${apt_date_arg}    ${cpt_code_arg}    ${day_unit_arg}
    Click View Changes Button In Billable Event Ledger Page    ${apt_date_arg}
    Click Billing Change Button
    ${new_value_cpt_column}    Set Variable    //td[text()='CPT/HCPCS - Added']//following-sibling::td[text()='${cpt_code_arg}']
    Wait Until Element Is Visible    ${new_value_cpt_column}    30s
    ${new_value_day_units_column}    Set Variable    //td[text()='${cpt_code_arg} - Days Units']//following-sibling::td[text()='${day_unit_arg}']
    Wait Until Element Is Visible    ${new_value_day_units_column}    30s
    Common.Close SubModal Popup