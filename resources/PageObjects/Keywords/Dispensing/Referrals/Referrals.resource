*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py

*** Variables ***
${referral_filter_by_location}    //select[@id="AccountID"]
${referral_filter_by_patient}    //input[@id="PatientID"]
${referral_filter_by_status}    //select[@id="Status"]
${referral_filter_by_startdate}    //input[@id="StartDate"]
${referral_filter_by_enddate}    //input[@id="EndDate"]
${referral_clear_btn}    //button[contains(@class,'patientClearButton')]
${referral_search_btn}    //a[contains(@class,'ReferralLedgerSearchBtn')]
${create_referral_btn}    //a[contains(text(),'Create Referral')]
${create_a_referral_title}    //h4[text()='Create A Referral']
${referral_loading_icon_i}    //i[@class='fa fa-spinner fa-4x fa-spin']
${edit_referral_title}    //h4[text()='Edit Referral']
#Create A Referral Popup
${referral_select_a_account_id}    //select[@id="SelectedAccountID"]
${referral_select_patient}    //input[@id="SelectedPatient"]
${referral_select_physician_id}    //select[@id="ReferralPhysicianID"]
${referral_assign_code_btn}    //div[@id="ModalPopup"]//a[@id="ICDCode1"]
${referral_icdcode_input}    //input[@name="ICDSearchValues"]
${referral_clear_icdcode_btn}    //button[@id="ICDClearButton"]
${referral_find_icdcode_btn}    //button[@id="ICDFindButton"]
${save_assign_code_btn}    //button[@id="SaveBtn" and contains(text(),'Assign DX Code')]
${assign_dx_codes_title}    //h4[text()='Assign DX Codes']
${referral_select_refer_to_physician_id}    //select[@id="ReferToPhysicianID"]
${referral_number_input}    //input[@id="ReferralNumber"]
${referral_number_of_visits_input}    //input[@id="NumberOfVisits"]
${referral_selected_startdate_input}    //input[@id="SelectedStartDate"]
${referral_selected_enddate_input}    //input[@id="SelectedEndDate"]
${referral_select_proprietary_name}    //select[@id="ProprietaryName"]
${referral_dosage_input}    //input[@id="ReferralDosage"]
${referral_b$b_checkbox}    //input[@id="BBRadioBtn"]
${referral_select_payer}    //select[@id="PayerID"]
${referral_spp_checkbox}    //input[@id="SPPRadioBtn"]
${referral_select_pharmacy}    //select[@id="RecipientPharmacyID"]
${referral_other_provider_checkbox}    //input[@id="ProviderRadioBtn"]
${referral_recipient_npi_input}    //input[@id="RecipientNPI"]
${referral_select_status}    //select[@id="SelectedStatus"]
${referral_discontinue_service_checkbox}    //input[@id="DiscontinueService"]
${referral_create_btn}    //div[@id="ModalPopup"]//button[@id="SaveBtn"]
${referral_edit_btn}    //div[@id="ModalPopup"]//button[@id="SaveBtn" and text()='Edit']
${referral_close_btn}    //div[@id="ModalPopup"]//button[@id="CloseBtn"]

*** Keywords ***
Create Referrals Dictionary
    &{referrals_dict}    Create Dictionary
    RETURN    ${referrals_dict}

Go To Referrals Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Referrals
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Referrals

Filter By Location In Referrals Page
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${referral_filter_by_location}    ${location_arg}

Filter By Patient In Referrals Page
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    (//div[contains(text(),'${mrn_arg}')])[${i}]
        Click Clear Patient Button
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_filter_by_patient}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    5s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            Exit For Loop
        END
    END

Click Clear Patient Button
    Common.Scroll And Click Element    ${referral_clear_btn}

Filter By Status In Referrals Page
    [Arguments]    ${status_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${referral_filter_by_status}    ${status_arg}

Filter By Date Range In Referrals Page
    [Arguments]    ${start_date_arg}    ${end_date_arg}
    Input Start Date    ${start_date_arg}
    Input End Date    ${end_date_arg}

Input Start Date
    [Arguments]    ${start_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_filter_by_startdate}    ${start_date_arg}
    Common.Close Calendar Table

Input End Date
    [Arguments]    ${end_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_filter_by_enddate}    ${end_date_arg}
    Common.Close Calendar Table

Click Search Button
    Common.Scroll And Click Element    ${referral_search_btn}
    Common.Element Is Not Visible    //a[text()='Loading...']

Open Create A Referral ModalPopup
    Common.Scroll And Click Element    ${create_referral_btn}
    Wait Until Element Is Visible    ${create_a_referral_title}    30s
    Common.Element Is Not Visible    ${referral_loading_icon_i}

Filter Location In Referral ModalPopup
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${referral_select_a_account_id}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${referral_select_a_account_id}    ${location_arg}

Filter By Patient In Referral ModalPopup
    [Arguments]    ${mrn_arg}
    FOR    ${i}    IN RANGE    1    3
        ${patient_selected}    Set Variable    (//div[contains(text(),'${mrn_arg}')])[${i}]
        Wait Until Element Is Visible    ${referral_select_patient}    30s
        Common.Clear Input Field Until Empty    ${referral_select_patient}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_select_patient}    ${mrn_arg}
        ${check_automated_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_selected}    5s
        IF    '${check_automated_patient_visible}' == '${True}'
            Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_selected}
            ${patient_name}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${referral_select_patient}
            Exit For Loop
        END
    END
    RETURN    ${patient_name}

Select Referring Provider In Referral ModalPopup
    [Arguments]    ${referring_provider_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${referral_select_physician_id}    ${referring_provider_arg}
    ${referring_provider_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${referral_select_physician_id}
    RETURN    ${referring_provider_txt}

Click Assign Code Button
    Common.Scroll And Click Element    ${referral_assign_code_btn}
    Wait Until Element Is Visible    ${assign_dx_codes_title}    30s
    Common.Element Is Not Visible    //div[@id="ICDModalList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Filter Icdcode
    [Arguments]    ${dx_code_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${referral_clear_icdcode_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_icdcode_input}    ${dx_code_arg}
    Sleep    1s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${referral_find_icdcode_btn}

Assign Dx Codes In Referral ModalPopup
    [Arguments]    ${dx_code_arg}
    Click Assign Code Button
    Filter Icdcode    ${dx_code_arg}
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    (//div[@id="ICDModalList"]//span[@class="icdCodeName"])[last()]    ${dx_code_arg}
    ${assign_dxcode_checkbox}    Set Variable    //td[span[normalize-space(text())='${dx_code_arg}']]//preceding::td[1]//input[@name="icd10Codes"]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${assign_dxcode_checkbox}
    Common.Scroll And Click Element    ${save_assign_code_btn}
    Common.Page Alert Message    DX Code Added.

Select Refer To Provider In Referral ModalPopup
    [Arguments]    ${refer_to_provider_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${referral_select_refer_to_physician_id}    ${refer_to_provider_arg}

Input Referral Number In Referral ModalPopup
    [Arguments]    ${referral_number_arg}
    Common.Clear Input Field Until Empty    ${referral_number_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_number_input}    ${referral_number_arg}

Input Number Of Visits In Referral ModalPopup
    [Arguments]    ${number_of_visits_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_number_of_visits_input}    ${number_of_visits_arg}

Input Start Date In Referral ModalPopup
    [Arguments]    ${start_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_selected_startdate_input}    ${start_date_arg}
    Common.Close Calendar Table

Input End Date In Referral ModalPopup
    [Arguments]    ${end_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_selected_enddate_input}    ${end_date_arg}
    Common.Close Calendar Table

Select Proprietary Name In Referral ModalPopup
    [Arguments]    ${medication_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${referral_select_proprietary_name}    ${medication_arg}

Input Dosage In Referral ModalPopup
    [Arguments]    ${dosage_arg}
    Common.Clear Input Field Until Empty    ${referral_dosage_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_dosage_input}    ${dosage_arg}

Click B$B Checkbox In Referral ModalPopup
    Common.Scroll And Click Element    ${referral_b$b_checkbox}

Click SPP Checkbox In Referral ModalPopup
    Common.Scroll And Click Element    ${referral_spp_checkbox}

Click Other Provider Checkbox In Referral ModalPopup
    Common.Scroll And Click Element    ${referral_other_provider_checkbox}

Select A Payer In Referral ModalPopup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${referral_select_payer}    var_name=referral_payer    dic=${dict_arg}

Select Recipient Pharmacy In Referral ModalPopup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${referral_select_pharmacy}    var_name=referral_pharmacy    dic=${dict_arg}

Input Recipient NPI In Referral ModalPopup
    [Arguments]    ${npi_arg}
    Common.Clear Input Field Until Empty    ${referral_recipient_npi_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referral_recipient_npi_input}    ${npi_arg}

Select Status In Referral ModalPopup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${referral_select_status}    var_name=referral_status    dic=${dict_arg}

Click Discontinue Service Checkbox
    Common.Scroll And Click Element    ${referral_discontinue_service_checkbox}

Click Create Referral ModalPopup Button
    Common.Scroll And Click Element    ${referral_create_btn}

Click Close Referral ModalPopup Button
    Common.Scroll And Click Element    ${referral_close_btn}

Click Edit Referral ModalPopup Button
    Common.Scroll And Click Element    ${referral_edit_btn}

Filter Options To Find Referral Row
    [Arguments]    ${location_arg}    ${mrn_arg}    ${status_arg}    ${start_date_arg}    ${end_date_arg}
    Filter By Location In Referrals Page    ${location_arg} 
    Filter By Patient In Referrals Page    ${mrn_arg}
    Filter By Status In Referrals Page    ${status_arg}
    Filter By Date Range In Referrals Page    ${start_date_arg}    ${end_date_arg}

Create A Referral
    [Arguments]    ${location_arg}    ${mrn_arg}    ${referring_provider_arg}    ${dx_code_arg}    ${refer_to_provider_arg}    ${referral_number_arg}    ${number_of_visits_arg}    ${start_date_arg}    ${end_date_arg}    ${medication_arg}    ${dosage_arg}    ${npi_arg}
    ${referrals_dict}    Create Referrals Dictionary
    Open Create A Referral ModalPopup
    Filter Location In Referral ModalPopup    ${location_arg}
    ${patient_name}    Filter By Patient In Referral ModalPopup    ${mrn_arg}
    ${referring_provider_txt}    Select Referring Provider In Referral ModalPopup    ${referring_provider_arg}
    Assign Dx Codes In Referral ModalPopup    ${dx_code_arg}
    Select Refer To Provider In Referral ModalPopup    ${refer_to_provider_arg}
    Input Referral Number In Referral ModalPopup    ${referral_number_arg}
    Input Number Of Visits In Referral ModalPopup    ${number_of_visits_arg}
    Input Start Date In Referral ModalPopup    ${start_date_arg}
    Input End Date In Referral ModalPopup    ${end_date_arg}
    Select Proprietary Name In Referral ModalPopup    ${medication_arg}
    Input Dosage In Referral ModalPopup    ${dosage_arg}
    Click Random Checkbox    ${referrals_dict}    ${npi_arg}
    Select Status In Referral ModalPopup    ${referrals_dict}
    Click Create Referral ModalPopup Button
    Common.Page Alert Message    Referral Created Successfully.
    Set To Dictionary    ${referrals_dict}    
    ...    patient=${patient_name}
    ...    dx_code=${dx_code_arg}
    ...    number_of_visits=${number_of_visits_arg}
    ...    provider=${referring_provider_txt}
    ...    referral_number=${referral_number_arg}
    ...    start_date=${start_date_arg}
    ...    end_date=${end_date_arg}
    RETURN    ${referrals_dict}

Edit A Referral
    [Arguments]    ${dict_arg}    ${dx_code_arg}    ${referral_number_arg}    ${medication_arg}    ${dosage_arg}    ${npi_arg}
    Assign Dx Codes In Referral ModalPopup    ${dx_code_arg}
    Input Referral Number In Referral ModalPopup    ${referral_number_arg}
    Select Proprietary Name In Referral ModalPopup    ${medication_arg}
    Input Dosage In Referral ModalPopup    ${dosage_arg}
    Click Random Checkbox    ${dict_arg}    ${npi_arg}
    Select Status In Referral ModalPopup    ${dict_arg}
    Click Edit Referral ModalPopup Button
    Common.Page Alert Message    Referral Updated Successfully.

Verify Updated Referral Is Visible
    [Arguments]    ${referral_number_arg}
    ${updated_referral_row}    Set Variable    //td[span[text()='${referral_number_arg}']]
    Wait Until Element Is Visible    ${updated_referral_row}    30s

Open Created Referral Row
    [Arguments]    ${referral_number}
    ${edit_referral_btn}    Set Variable    (//td[span[text()='${referral_number}']]//following::a[contains(text(),'Edit Referral')])[1]
    Common.Scroll And Click Element    ${edit_referral_btn}
    Wait Until Element Is Visible    ${edit_referral_title}    30s
    Common.Element Is Not Visible    //div[@id="ManualReferralItems"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Click Random Checkbox
    [Arguments]    ${dict_arg}    ${npi_arg}
    ${checkbox_list}    Create List    ${referral_b$b_checkbox}    ${referral_spp_checkbox}    ${referral_other_provider_checkbox}
    ${random_checkbox}    Evaluate    random.choice(${checkbox_list})
    Common.Scroll And Click Element    ${random_checkbox}
    IF    '${random_checkbox}' == '${referral_b$b_checkbox}'
        Select A Payer In Referral ModalPopup    ${dict_arg}
    ELSE IF    '${random_checkbox}' == '${referral_spp_checkbox}'
        Select Recipient Pharmacy In Referral ModalPopup    ${dict_arg}
    ELSE IF    '${random_checkbox}' == '${referral_other_provider_checkbox}'
        Input Recipient NPI In Referral ModalPopup    ${npi_arg}
    END

Prepare Data For Referral
    ${referral_number}    Generate Random String    6    [NUMBERS]
    ${number_of_visits}    Generate Random String    1    123456789
    ${dosage}    Generate Random String    2    [NUMBERS]
    RETURN    ${referral_number}    ${number_of_visits}    ${dosage}

Set Start Date And End Date Data
    ${current_date}    Get Current Date
    ${start_date}      Convert Date     ${current_date}    result_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${current_date}    10 days    result_format=%m/%d/%Y
    RETURN    ${start_date}    ${end_date}

Check Referral Number Column
    [Arguments]    ${referral_number}
    ${referral_number_column}    Set Variable    //td[span[text()='${referral_number}']]
    Wait Until Element Is Visible    ${referral_number_column}    30s
    RETURN    ${referral_number_column}

Check Expires In Column
    [Arguments]    ${referral_number_column}    ${start_date_arg}    ${end_date_arg}
    ${expires_in_column}    Set Variable    ${referral_number_column}//preceding::td[4]/strong
    Wait Until Element Is Visible    ${expires_in_column}    30s
    ${expires_in_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${expires_in_column}
    ${expected_expire_value}    Subtract Date From Date
        ...    ${end_date_arg}
        ...    ${start_date_arg}
        ...    date1_format=%m/%d/%Y
        ...    date2_format=%m/%d/%Y
        ...    result_format=verbose
    
    ${adjusted_start}    Add Time To Date    ${start_date_arg}    1 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${expected_expire_value_decrease_1_day}    Subtract Date From Date
        ...    ${end_date_arg}
        ...    ${adjusted_start}
        ...    date1_format=%m/%d/%Y
        ...    date2_format=%m/%d/%Y
        ...    result_format=verbose
    
    ${check_equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${expires_in_txt.lower()}    ${expected_expire_value.lower()}
    IF    '${check_equal}' == '${False}'
        Should Be Equal As Strings    ${expires_in_txt.lower()}    ${expected_expire_value_decrease_1_day.lower()}
    END

Check Patient Column
    [Arguments]    ${referral_number_column}    ${expected_patient_name_value}
    ${patient_id}    Set Variable    ${referral_number_column}//preceding::td[3]/div[1]/strong
    Wait Until Element Is Visible    ${patient_id}    30s
    ${patient_id_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${patient_id}    
    Should Contain    ${expected_patient_name_value}    ${patient_id_txt}
    
Check Number Of Visits Column
    [Arguments]    ${referral_number_column}    ${expect_number_of_visits}
    ${number_of_visits_column}    Set Variable    ${referral_number_column}//preceding::td[2]/strong
    Wait Until Element Is Visible    ${number_of_visits_column}    30s
    ${number_of_visits_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${number_of_visits_column}    
    Should Contain    ${number_of_visits_txt}    ${expect_number_of_visits}
    
Check Provider Column
    [Arguments]    ${referral_number_column}    ${expected_provider}
    ${provider_column}    Set Variable    ${referral_number_column}//preceding::td[1]/span
    Wait Until Element Is Visible    ${provider_column}    30s
    ${provider_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${provider_column} 
    ${first}    ${last}    Split String     ${provider_txt}     ${SPACE}
    ${provider_fommated}=     Set Variable     ${last}, ${first}
    Should Contain    ${expected_provider}    ${provider_fommated}

Check Status Column
    [Arguments]    ${referral_number_column}    ${expected_referral_status}
    ${status_column}    Set Variable    ${referral_number_column}//following::td[1]/strong
    Wait Until Element Is Visible    ${status_column}    30s
    ${status_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${status_column}    
    Should Be Equal    ${expected_referral_status}    ${status_txt}

Check DX Code Column
    [Arguments]    ${referral_number_column}    ${expected_dx_code}
    ${dx_code_column}    Set Variable    ${referral_number_column}//following::td[2]/div[1]/span
    Wait Until Element Is Visible    ${dx_code_column}    30s
    ${dx_code_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${dx_code_column}    
    Should Be Equal    ${expected_dx_code}    ${dx_code_txt}