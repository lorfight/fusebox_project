*** Settings ***
Resource    ../../../Layers/PayerInformation/PayerInformation.resource

*** Variables ***
${payer_infomation_tab}    //a[@id='PayerInfo']
${payer_information_title}    //h3[contains(text(),'Patient Insurance / Plans')]
${changelog_patient_name}    (//h4[contains(text(),'Patient: ')]//strong)[4]
${changelog_mrn}    (//h4[contains(text(),'Patient: ')]//strong)[5]
${changelog_dob}    (//h4[contains(text(),'Patient: ')]//strong)[6]
${changelog_no_change_title}    //h4[text()='No Changes Available.']
${changelog_table}    //th[contains(text(),'Property')]/parent::tr
${changelog_inactive_row}    (//tbody//tr[td[1][text()='Inactive']])[last()]

*** Keywords ***
Open Payer Information Tab
    Navigate To The Tab    
    ...    tab_name=${payer_infomation_tab}    
    ...    title_name=${payer_information_title}

# Medical Payer Plan
Set Data For Medical Payer Plan
    [Arguments]    ${dict_arg}
    ${medical_field_list}    Create List    CertificateNumber    GroupNumber
    FOR    ${medical_field}    IN    @{medical_field_list}
        ${Fake_dict}    Generate Fake Data    num_rand 
        Set To Dictionary    ${dict_arg}    ${medical_field}=${Fake_dict['num_rand']}
    END

Create A New Medical Payer Plan
    [Arguments]    ${utc}
    &{CreateMedical_dict}    Create Dictionary
    Set Data For Medical Payer Plan    ${CreateMedical_dict}
    Add Payer
    ${plan_payer_name}    Select Plan
    Fill In Medical Information    subscriber_number_arg=${CreateMedical_dict.CertificateNumber}    group_number_arg=${CreateMedical_dict.GroupNumber}
    ${effective_date}    ${expiration_date}    Select Plan Date In Payer Plan
    ${date_zone}    ${date_zone_plus_1_minute}    Get Datezone And Timezone When Creating Payer Plan    ${utc}
    Click Create Payer Button
    Common.Page Alert Message    Insurance Plan successfully Assigned to the Patient.
    Set To Dictionary    ${CreateMedical_dict}    
        ...    plan_payer_name=${plan_payer_name}
        ...    effective_date=${effective_date}
        ...    expiration_date=${expiration_date}
        ...    date_zone=${date_zone}
        ...    date_zone_plus_1_minute=${date_zone_plus_1_minute}
    RETURN    ${CreateMedical_dict}

Edit Medical Payer Plan
    [Arguments]    ${utc}
    &{UpdateMedical_dict}    Create Dictionary
    Set Data For Medical Payer Plan    ${UpdateMedical_dict}
    Click Edit Payer Button
    Fill In Medical Information    subscriber_number_arg=${UpdateMedical_dict.CertificateNumber}    group_number_arg=${UpdateMedical_dict.GroupNumber}
    ${effective_date}    ${expiration_date}    Select Plan Date In Payer Plan
    ${date_zone}    ${date_zone_plus_1_minute}    Get Datezone And Timezone When Creating Payer Plan    ${utc}
    Click Update Payer Button
    Common.Page Alert Message    Insurance Plan successfully Updated.
    Set To Dictionary    ${UpdateMedical_dict}    
    ...    EffectiveDate=${effective_date}
    ...    PlanExpireDate=${expiration_date}
    ...    date_zone=${date_zone}
    ...    date_zone_plus_1_minute=${date_zone_plus_1_minute}
    RETURN    ${UpdateMedical_dict}

# Pharmacy Payer Plan
Set Data For Pharmacy Payer Plan
    [Arguments]    ${dict_arg}   
    ${pharmacy_field_list}    Create List    CertificateNumber    GroupNumber    BIN    PCN    RxGroup
    FOR    ${pharmacy_field}    IN    @{pharmacy_field_list}
        ${Fake_dict}    Generate Fake Data    demical_3d
        Set To Dictionary    ${dict_arg}    ${pharmacy_field}=${Fake_dict['demical_3d']}
    END

Create A New Pharmacy Payer Plan
    [Arguments]    ${utc}
    &{CreatePharmacy_dict}    Create Dictionary
    Set Data For Pharmacy Payer Plan    ${CreatePharmacy_dict}
    Add Payer
    ${plan_payer_name}    Select Plan
    Fill In Pharmacy Information    subscriber_number_arg=${CreatePharmacy_dict.CertificateNumber}    group_number_arg=${CreatePharmacy_dict.GroupNumber}    rx_bin_number_arg=${CreatePharmacy_dict.BIN}    rx_pcn_number_arg=${CreatePharmacy_dict.PCN}    rx_group_arg=${CreatePharmacy_dict.RxGroup}
    ${effective_date}    ${expiration_date}    Select Plan Date In Payer Plan
    ${date_zone}    ${date_zone_plus_1_minute}    Get Datezone And Timezone When Creating Payer Plan    ${utc}
    Click Create Payer Button
    Common.Page Alert Message    Insurance Plan successfully Assigned to the Patient.
    Set To Dictionary    ${CreatePharmacy_dict}    
    ...    plan_payer_name=${plan_payer_name}
    ...    EffectiveDate=${effective_date}
    ...    PlanExpireDate=${expiration_date}
    ...    date_zone=${date_zone}
    ...    date_zone_plus_1_minute=${date_zone_plus_1_minute}
    RETURN    ${CreatePharmacy_dict}
    
Edit Pharmacy Payer Plan
    [Arguments]    ${utc}
    &{UpdatePharmacy_dict}    Create Dictionary
    Set Data For Pharmacy Payer Plan    ${UpdatePharmacy_dict}
    Click Edit Payer Button
    Fill In Pharmacy Information    subscriber_number_arg=${UpdatePharmacy_dict.CertificateNumber}    group_number_arg=${UpdatePharmacy_dict.GroupNumber}    rx_bin_number_arg=${UpdatePharmacy_dict.BIN}    rx_pcn_number_arg=${UpdatePharmacy_dict.PCN}    rx_group_arg=${UpdatePharmacy_dict.RxGroup}
    ${effective_date}    ${expiration_date}    Select Plan Date In Payer Plan
    ${date_zone}    ${date_zone_plus_1_minute}    Get Datezone And Timezone When Creating Payer Plan    ${utc}
    Click Update Payer Button
    Common.Page Alert Message    Insurance Plan successfully Updated.
    Set To Dictionary    ${UpdatePharmacy_dict}    
    ...    EffectiveDate=${effective_date}
    ...    PlanExpireDate=${expiration_date}
    ...    date_zone=${date_zone}
    ...    date_zone_plus_1_minute=${date_zone_plus_1_minute}
    RETURN    ${UpdatePharmacy_dict}

# Plan Date
Select Plan Date In Payer Plan
    ${effective_date}    Get Current Date    result_format=%m/%d/%Y
    ${expiration_date}    Add Time To Date    ${effective_date}    30 days    result_format=%m/%d/%Y     date_format=%m/%d/%Y
    PayerInformation.Input Plan Effective Date    ${effective_date}
    PayerInformation.Input Plan Expiration Date    ${expiration_date}
    RETURN    ${effective_date}    ${expiration_date}

# Patient Payer Changelog
Verify Expand Or Collapse Changelog Table
    [Arguments]    ${status_arg}
    PayerInformation.Click View Change Button
    PayerInformation.Click Changelog Collapse Button
    IF    '${status_arg}' == 'create'
        Wait Until Element Is Not Visible    ${changelog_no_change_title}
        PayerInformation.Click Changelog Collapse Button
        Wait Until Element Is Visible    ${changelog_no_change_title}
    ELSE IF    '${status_arg}' == 'edit'
        Wait Until Element Is Not Visible    ${changelog_table}
        PayerInformation.Click Changelog Collapse Button
        Wait Until Element Is Visible    ${changelog_table}
    END
    PayerInformation.Click Close Changelog Button

Verify Patient Information In Changelog
    [Arguments]    ${patient_name_arg}    ${mrn_arg}    ${dob_arg}
    PayerInformation.Click View Change Button
    Wait Until Element Is Visible    ${changelog_patient_name}    30s
    ${changelog_patient_name}    Get Text    ${changelog_patient_name}
    ${changelog_mrn}    Get Text    ${changelog_mrn}
    ${changelog_dob}    Get Text    ${changelog_dob}
    Should Be Equal    ${changelog_patient_name}    ${patient_name_arg}
    Should Be Equal    ${changelog_mrn}    ${mrn_arg}
    Should Be Equal    ${changelog_dob}    ${dob_arg}
    PayerInformation.Click Close Changelog Button

Check Medical Plan In Changelog
    [Arguments]    ${CreateMedical_dict}    ${UpdateMedical_dict}    ${user_name_txt}
    PayerInformation.Click View Change Button
    ${properties}    Create List    CertificateNumber    GroupNumber
    FOR    ${i}    IN RANGE    1    3
        ${prop}    Set Variable    ${properties}[${i - 1}]
        ${row_xpath}    Set Variable    xpath=(//tbody//tr[td[1][text()='${prop}']])[last()]
        Wait Until Element Is Visible    ${row_xpath}    30s
        ${property}    Get Text    ${row_xpath}/td[1]
        ${old_value}    Get Text    ${row_xpath}/td[2]
        ${new_value}    Get Text    ${row_xpath}/td[3]
        ${changed_by}    Get Text    ${row_xpath}/td[4]
        ${change_date}    Get Text    ${row_xpath}/td[5]
        ${expected_old_value}    Set Variable    ${CreateMedical_dict.${prop}}
        ${expected_new_value}    Set Variable    ${UpdateMedical_dict.${prop}}
        Should Be Equal    ${property}    ${prop}
        Should Be Equal    ${old_value}    ${expected_old_value}
        Should Be Equal    ${new_value}    ${expected_new_value}
        Should Be Equal    ${changed_by}    ${user_name_txt}
        ${check_equal_status}    Run Keyword And Return Status    Should Be Equal    ${change_date}    ${UpdateMedical_dict.date_zone}
        IF    '${check_equal_status}' == '${False}'
            Should Be Equal    ${change_date}    ${UpdateMedical_dict.date_zone_plus_1_minute}
        END
    END
    PayerInformation.Click Close Changelog Button

Check Pharmacy Plan In Changelog
    [Arguments]    ${CreatePharmacy_dict}    ${UpdatePharmacy_dict}    ${user_name_txt}
    PayerInformation.Click View Change Button
    ${properties}    Create List    CertificateNumber    GroupNumber    BIN    PCN    RxGroup
    FOR    ${i}    IN RANGE    1    6
        ${prop}    Set Variable    ${properties}[${i - 1}]
        ${row_xpath}    Set Variable    xpath=(//tbody//tr[td[1][text()='${prop}']])[last()]
        Wait Until Element Is Visible    ${row_xpath}    30s
        ${property}    Get Text    ${row_xpath}/td[1]
        ${old_value}    Get Text    ${row_xpath}/td[2]
        ${new_value}    Get Text    ${row_xpath}/td[3]
        ${changed_by}    Get Text    ${row_xpath}/td[4]
        ${change_date}    Get Text    ${row_xpath}/td[5]
        ${expected_old_value}    Set Variable    ${CreatePharmacy_dict.${prop}}
        ${expected_new_value}    Set Variable    ${UpdatePharmacy_dict.${prop}}
        Should Be Equal    ${property}    ${prop}
        Should Be Equal    ${old_value}    ${expected_old_value}
        Should Be Equal    ${new_value}    ${expected_new_value}
        Should Be Equal    ${changed_by}    ${user_name_txt}
        ${check_equal_status}    Run Keyword And Return Status    Should Be Equal    ${change_date}    ${UpdatePharmacy_dict.date_zone}
        IF    '${check_equal_status}' == '${False}'
            Should Be Equal    ${change_date}    ${UpdatePharmacy_dict.date_zone_plus_1_minute}
        END
    END
    PayerInformation.Click Close Changelog Button

Check Message For Changelog Display
    [Arguments]    ${status_arg}
    PayerInformation.Click View Change Button
    IF    '${status_arg}' == 'create'
        Wait Until Element Is Visible    ${changelog_no_change_title}
    ELSE IF    '${status_arg}' == 'edit'
        Wait Until Element Is Visible    ${changelog_table}
    ELSE IF    '${status_arg}' == 'remove'
        Wait Until Page Contains    No Insurance Plans Assigned.
    END
    PayerInformation.Click Close Changelog Button

Check Inactive In Changelog
    [Arguments]    ${create_dict_arg}    ${user_name_txt}
    PayerInformation.Click View Change Button
    ${row_xpath}    Set Variable    ${changelog_inactive_row}
    Wait Until Element Is Visible    ${row_xpath}    30s
    ${property}    Get Text    ${row_xpath}/td[1]
    ${old_value}    Get Text    ${row_xpath}/td[2]
    ${new_value}    Get Text    ${row_xpath}/td[3]
    ${changed_by}    Get Text    ${row_xpath}/td[4]
    ${change_date}    Get Text    ${row_xpath}/td[5]
    Should Be Equal    ${property}    Inactive
    Should Be Equal    ${old_value}    False
    Should Be Equal    ${new_value}    True
    Should Be Equal    ${changed_by}    ${user_name_txt}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${change_date}    ${create_dict_arg.date_zone}
    IF    '${check}' == '${False}'
        Should Be Equal    ${change_date}    ${create_dict_arg.date_zone_plus_1_minute}
    END
    PayerInformation.Click Close Changelog Button

# Remove Payer Plan
Check Payer Plan Is Visible
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${payer_remove_btn}    3s
    IF    "${status}" == "True"
        Remove Payer Plan    status=ACCEPT
    END
