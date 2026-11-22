*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${insurance_filter_by_location}    //select[@id="MemberId"]    
${insurance_filter_by_patient}    //select[@id="PatientId"]    
${insurance_clear_patient_btn}    //button[contains(@class,'patientClearButton')]
${insurance_filter_by_eligibility_status}    //select[@id="EligibilityStatusCode"]    
${insurance_filter_by_primary_insurance}    //select[@id="TradingPartnerId"]    
${insurance_start_date_input}    //input[@id="StartDate"]
${insurance_end_date_input}    //input[@id="EndDate"]
${insurance_update_btn}    //button[@id="InsuranceUpdateButton"]    
${insurance_verify_checkbox}    //input[@id="verify"]    
${insurance_discovery_checkbox}    //input[@id="discovery"]    
${insurance_perform_btn}    //button[contains(text(),'Perform')]

*** Keywords ***
Go To Insurance Verification Ledger Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Insurance Verifications
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Insurance Verification Ledger

Filter Insurance Verification
    [Arguments]    ${location_arg}    ${patient_arg}    ${status_arg}    ${primary_insurance_arg}    ${start_date_arg}    ${end_date_arg}
    Filter By Location In Insurance Verification Ledger Page    ${location_arg}
    Filter By Patient In Insurance Verification Ledger Page    ${patient_arg}
    Filter By Eligibility Status In Insurance Verification Ledger Page    ${status_arg}
    Filter By Primary Insurance In Insurance Verification Ledger Page    ${primary_insurance_arg}
    Input Start Date In Insurance Verification Ledger Page    ${start_date_arg}
    Input End Date In Insurance Verification Ledger Page    ${end_date_arg}

Filter By Location In Insurance Verification Ledger Page
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${insurance_filter_by_location}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${insurance_filter_by_location}    ${location_arg}

Filter By Patient In Insurance Verification Ledger Page
    [Arguments]    ${patient_arg}
    Click Clear Patient Button
    Wait Until Element Is Enabled    ${insurance_filter_by_patient}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${insurance_filter_by_patient}    ${patient_arg}

Click Clear Patient Button
    Common.Scroll And Click Element    ${insurance_clear_patient_btn}

Filter By Eligibility Status In Insurance Verification Ledger Page
    [Arguments]    ${status_arg}
    Wait Until Element Is Enabled    ${insurance_filter_by_location}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${insurance_filter_by_location}    ${status_arg}

Filter By Primary Insurance In Insurance Verification Ledger Page
    [Arguments]    ${primary_insurance_arg}
    Wait Until Element Is Enabled    ${insurance_filter_by_location}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${insurance_filter_by_location}    ${primary_insurance_arg}

Input Start Date In Insurance Verification Ledger Page
    [Arguments]    ${start_date_arg}
    Wait Until Element Is Visible    ${insurance_start_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${insurance_start_date_input}    ${start_date_arg}

Input End Date In Insurance Verification Ledger Page
    [Arguments]    ${end_date_arg}
    Wait Until Element Is Visible    ${insurance_end_date_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${insurance_end_date_input}    ${end_date_arg}

Click Insurance Verification Tools Button
    [Arguments]    ${first_name_arg}    ${last_name_arg} 
    ${tool_btn}    Set Variable    //div[normalize-space(.)='Patient: ${first_name_arg} ${last_name_arg}']//following::a[contains(@class,'InsuranceVerification btn')]
    Common.Scroll And Click Element    ${tool_btn}
    Wait Until Element Is Visible    //div[@id="ModalPopup"]    30s
    # Wait Until Page Contains    Insurance Call Method    30s

Verify Insurance Information
    [Arguments]    ${expect_patient_name}    ${expect_dob}    ${expect_mrn}
    ${patient_name_txt}    Set Variable    //div[strong[text()='Patient Name:']]//following-sibling::div[1]
    SeleniumLibrary.Element Text Should Be    ${patient_name_txt}    ${expect_patient_name}
    ${dob_txt}    Set Variable    //div[strong[text()='Date of Birth:']]//following-sibling::div[1]
    SeleniumLibrary.Element Text Should Be    ${dob_txt}    ${expect_dob}
    ${mrn_txt}    Set Variable    //div[strong[text()='MRN:']]//following-sibling::div[1]
    SeleniumLibrary.Element Text Should Be    ${mrn_txt}    ${expect_mrn}
    
Update Insurance Successfully
    [Arguments]    ${method_arg}
    Common.Scroll And Click Element    ${insurance_update_btn}
    Wait Until Element Is Visible    //h4[text()='Insurance Call Method']    30s
    IF    '${method_arg}' == 'verify'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${insurance_verify_checkbox}
    ELSE IF    '${method_arg}' == 'discovery'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${insurance_discovery_checkbox}
    END
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${insurance_perform_btn}
    Common.Element Is Not Visible    //i[contains(@class,'fa fa-spinner fa-1x fa-spin')]