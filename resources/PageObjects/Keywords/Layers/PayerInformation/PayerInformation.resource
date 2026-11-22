*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${add_payer_btn}    //a[contains(text(),' Add Payer / Plan ')]
${select_plan_radio}    (//input[@name='plan'])[1]
${payer_edit_btn}    //a[contains(text(),' Edit Payer  ')]
${payer_inactive_checkbox}    //input[@id='InactivePayer']
${payer_update_btn}    //button[@id='SaveBtn' and contains(text(),'Update')]
${medical_subscriber_number_input}    //h3[contains(text(),'Medical Payer Plan')]/following::input[@id='CertificateNumber'][1]
${medical_group_number_input}    //h3[contains(text(),'Medical Payer Plan')]/following::input[@id='GroupNumber'][1]
${medical_payer_plan_type}    //input[@value='Medical']
${pharmacy_subscriber_number_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='CertificateNumber']
${pharmacy_group_number_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='GroupNumber']
${pharmacy_rx_bin_number_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='BIN']
${pharmacy_rx_pcn_number_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='PCN']
${pharmacy_rx_group_number_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='RxGroup']
${plan_effective_date_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='EffectiveDate']
${plan_expiration_date_input}    //h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='ExpirationDate']
${pharmacy_payer_plan_type}    //input[@value='Pharmacy']
${payer_view_change}    //a[@id='PatientPayerChangesBtn']
${changelog_collapsed}    //a[@data-toggle='collapse']
${changelog_close_btn}    (//button[@id='SaveBtn']/following::button)[1]
${payer_remove_btn}    //a[contains(text(),' Remove Payer  ')]
${payer_create_btn}    //button[@id='SaveBtn' and contains(text(),'Create')]
${payer_close_btn}    (//button[@id='SaveBtn']/following::button)[1]

*** Keywords ***
Add Payer
    Common.Scroll And Click Element    ${add_payer_btn}
    Wait Until Page Contains    Assign Insurance / Payer Information    30s

Select Plan
    ${plan_index}    Get Variable Value    ${plan_index}    1
    Common.Scroll And Click Element    (//input[@name='plan'])[${plan_index}]
    ${plan_payer_name}    Get Text    (//input[@name='plan'])[${plan_index}]//ancestor::tr//td//div[1]
    ${plan_index}   Evaluate    int(${plan_index}) + 1
    Set Suite Variable    ${plan_index}
    RETURN    ${plan_payer_name}

Inactive Payer Plan
    [Arguments]    ${utc}
    Click Edit Payer Button
    Click Inactive Payer Button
    ${date_zone}    ${date_zone_plus_1_minute}    Get Datezone And Timezone When Creating Payer Plan    ${utc}
    Click Update Payer Button
    Common.Page Alert Message    Insurance Plan successfully Updated.
    RETURN    ${date_zone}    ${date_zone_plus_1_minute}

# Medical Payer Plan
Click Medical Payer Plan Type
    Common.Scroll And Click Element    ${medical_payer_plan_type}

Input Subscriber Number In Medical Payer Plan
    [Arguments]    ${subscriber_number_arg}
    Clear Input Field Until Empty    ${medical_subscriber_number_input}
    Input Text Into Field    ${medical_subscriber_number_input}    ${subscriber_number_arg}

Input Group Number In Medical Payer Plan
    [Arguments]    ${group_number_arg}
    Clear Input Field Until Empty    ${medical_group_number_input}
    Input Text Into Field    ${medical_group_number_input}    ${group_number_arg}

Fill In Medical Information
    [Arguments]    ${subscriber_number_arg}    ${group_number_arg}
    Click Medical Payer Plan Type
    Input Subscriber Number In Medical Payer Plan    ${subscriber_number_arg}
    Input Group Number In Medical Payer Plan    ${group_number_arg}

# Pharmacy Payer Plan
Click Pharmacy Payer Plan Type
    Common.Scroll And Click Element    ${pharmacy_payer_plan_type}

Input Subscriber Number In Pharmacy Payer Plan
    [Arguments]    ${subscriber_number_arg}
    Clear Input Field Until Empty    ${pharmacy_subscriber_number_input}
    Input Text Into Field    ${pharmacy_subscriber_number_input}    ${subscriber_number_arg}

Input Group Number In Pharmacy Payer Plan
    [Arguments]    ${group_number_arg}
    Clear Input Field Until Empty    ${pharmacy_group_number_input}
    Input Text Into Field    ${pharmacy_group_number_input}    ${group_number_arg}

Input Rx BIN Number In Pharmacy Payer Plan
    [Arguments]    ${rx_bin_number_arg}
    Clear Input Field Until Empty    ${pharmacy_rx_bin_number_input}
    Input Text Into Field    ${pharmacy_rx_bin_number_input}    ${rx_bin_number_arg}

Input Rx PCN Number In Pharmacy Payer Plan
    [Arguments]    ${rx_pcn_number_arg}
    Clear Input Field Until Empty    ${pharmacy_rx_pcn_number_input}
    Input Text Into Field    ${pharmacy_rx_pcn_number_input}    ${rx_pcn_number_arg}

Input Rx Group In Pharmacy Payer Plan
    [Arguments]    ${rx_group_arg}
    Clear Input Field Until Empty    ${pharmacy_rx_group_number_input}
    Input Text Into Field    ${pharmacy_rx_group_number_input}    ${rx_group_arg}

Fill In Pharmacy Information
    [Arguments]    ${subscriber_number_arg}    ${group_number_arg}    ${rx_bin_number_arg}    ${rx_pcn_number_arg}    ${rx_group_arg}
    Click Pharmacy Payer Plan Type
    Input Subscriber Number In Pharmacy Payer Plan    ${subscriber_number_arg}
    Input Group Number In Pharmacy Payer Plan    ${group_number_arg}
    Input Rx BIN Number In Pharmacy Payer Plan    ${rx_bin_number_arg}
    Input Rx PCN Number In Pharmacy Payer Plan    ${rx_pcn_number_arg}
    Input Rx Group In Pharmacy Payer Plan    ${rx_group_arg}

# Plan Date
Input Plan Effective Date
    [Arguments]    ${effective_date_arg}
    Clear Input Field Until Empty    ${plan_effective_date_input}
    Input Text Into Field    ${plan_effective_date_input}    ${effective_date_arg}
    Common.Choose Date In Onset Date Input    ${effective_date_arg}

Input Plan Expiration Date
    [Arguments]    ${expiration_date_arg}
    Clear Input Field Until Empty    ${plan_expiration_date_input}
    Input Text Into Field    ${plan_expiration_date_input}    ${expiration_date_arg}
    Common.Choose Date In Onset Date Input     ${expiration_date_arg}

Get Datezone And Timezone When Creating Payer Plan
    [Arguments]    ${utc}
    ${date_zone}    Handle Datetime Format    fmt={mm}/{dd}/{y} on {h}:{mi} {ampm}    utc=${utc}
    ${date_zone_plus_1_minute}    Handle Datetime Format    fmt={mm}/{dd}/{y} on {h}:{mi} {ampm}    dt=${date_zone}    add_minutes=1
    RETURN    ${date_zone}    ${date_zone_plus_1_minute}

Remove Payer Plan
    [Arguments]    ${status}
    Click Remove Payer Plan Button
    ${alert_txt}    Handle Alert    ${status}
    Should Be Equal    ${alert_txt}    Are you sure you would like to remove this insurance / payer from the patient?
    IF    "${status}" == "ACCEPT"
        Common.Page Alert Message    Insurance Plan successfully Removed from the Patient.
    END

Click Create Payer Button
    Common.Scroll And Click Element    ${payer_create_btn}

Click Close Payer Button
    Common.Scroll And Click Element    ${payer_close_btn}

Click Edit Payer Button
    Common.Scroll And Click Element    ${payer_edit_btn}

Click Update Payer Button
    Common.Scroll And Click Element    ${payer_update_btn}

Click View Change Button
    Common.Scroll And Click Element    ${payer_view_change}

Click Changelog Collapse Button
    Common.Scroll And Click Element    ${changelog_collapsed}

Click Close Changelog Button
    Common.Scroll And Click Element    ${changelog_close_btn}

Click Inactive Payer Button
    Common.Scroll And Click Element    ${payer_inactive_checkbox}

Click Remove Payer Plan Button
    Common.Scroll And Click Element    ${payer_remove_btn}