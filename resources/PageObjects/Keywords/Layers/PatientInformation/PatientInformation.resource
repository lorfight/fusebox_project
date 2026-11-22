*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${patient_info_tab}    //a[@id='PatientInfo']
# Patient Identifiers
${first_name_input}    //*[@id='FirstName']
${middle_name_input}    //*[@id='MiddleName']
${last_name_input}    //*[@id='LastName']
${mrn_input}    //*[@id='MRN']
${dob_input}    //*[@id='DOB']
${ssn_input}    //*[@id='SSN']
${race_select}    //*[@id='Race']
${race_additional_detail_input}    //*[@id='RaceOtherDescription']
${ethnicity_select}    //*[@id='Ethnicity']
${gender_select}    //*[@id='Gender']
${marital_status_select}    //*[@id='MaritalStatus']
${spouse_first_name_input}    //*[@id='SpouseFirstName']
${spouse_middle_name_input}    //*[@id='SpouseMiddleName']
${spouse_last_name_input}    //*[@id='SpouseLastName']
${preferred_internal_provider_select}    //*[@id='ReferringDoctor']
${reffering_provider_input}    //*[@id='PatientReferringProvider']
${pcp_select}    //*[@id='PCPProvider']
#Health Information
${dispensing_alert_note_input}    //textarea[@id='AlertNote']
${height_input}    //*[@id='Height']
${weight_lp_input}    //*[@id='WeightLB']
${weight_lp_title}    //label[contains(text(),'Weight (Pounds)')]
${weight_kg_input}    //*[@id='Weight']
${weight_kg_title}    //label[contains(text(),'Weight (Kilograms)')]
${bmi_text}    //div//span[@id='BMICalculation']
#Personal Information
${default_contact_select}    //*[@id='DefaultContact']
${home_phone_input}    //*[@id='Phone']
${cell_phone_input}    //*[@id='Cellphone']
${email_input}    //*[@id='Email']
${additional_notes_input}    //*[@id='Notes']
#Employer Information
${occupation_input}    //*[@id='Occupation']
${employer_name_input}    //*[@id='EmployerName']
${work_phone_input}    //*[@id='WorkPhone']
${employer_first_name_input}    //*[@id='EmployerFirstName']
${employer_last_name_input}    //*[@id='EmployerLastName']
${employer_phone_input}    //*[@id='EmployerPhone']
${employer_address_line_1_input}    //*[@id='EmployerAddress1']
${employer_address_line_2_input}    //*[@id='EmployerAddress2']
${employer_city_input}    //*[@id='EmployerCity']
${employer_state_select}    //*[@id='EmployerState']
${employer_postal_code_input}    //*[@id='EmployerZip']
${employer_country_select}    //*[@id='EmployerCountry']
#Responsible Information
${responsible_firstName_input}    //*[@id='ResponsibleFirstName']
${responsible_middleName_input}    //*[@id='ResponsibleMiddleName']
${responsible_lastName_input}    //*[@id='ResponsibleLastName']
${responsible_phone_input}    //*[@id='ResponsiblePhone']
${responsible_dob_input}    //*[@id='ResponsibleDOB']
${responsible_ssn_input}    //*[@id='ResponsibleSSN']
${responsible_address_line_1_input}    //*[@id='ResponsibleAddress1']
${responsible_address_line_2_input}    //*[@id='ResponsibleAddress2']
${responsible_city_input}    //*[@id='ResponsibleCity']
${responsible_state_select}    //*[@id='ResponsibleState']
${responsible_postal_code_input}    //*[@id='ResponsibleZip']
${responsible_country_select}    //*[@id='ResponsibleCountry']
#Emergency Contact Information
${emergency_name_input}    //*[@id='EmergencyContactName']
${emergency_phone_input}    //*[@id='EmergencyContactPhone']
${emergency_relationship_input}    //*[@id='EmergencyContactRelationship']
#Patient Addresses - Default Address
${default_address_select}    //*[@id='PrimaryAddress']
${default_address_first_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultAddressLine1']
${default_address_second_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultAddressLine2']
${default_city_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultCity']
${default_state_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultStateProvince']
${default_state_select}    (//*[@id='DefaultStateProvince'])[1]
${default_postal_code_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultPostalCode']
${default_country_region_input}    //div[@id='DefaultAddressReadOnly']//*[@id='DefaultCountryRegion']
${default_address_last_option}    (//select[@id='PrimaryAddress']/option)[last()-1]
#Patient Addresses - Secondary Address
${work_address_select}    //*[@id='WorkAddress']
${work_address_first_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkAddressLine1']
${work_address_second_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkAddressLine2']
${work_city_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkCity']
${work_state_select}    //select[@id='State']
${work_state_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkStateProvince']
${work_postal_code_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkPostalCode']
${work_country_region_input}    //div[@id='WorkAddressReadOnly']//*[@id='WorkCountryRegion']
${work_address_last_option}    (//select[@id='WorkAddress']/option)[last()-1]
#Medical Payer / Insurance Information - Primary Payer / Insurance
${primary_assign_select}    //*[@id='PrimaryPayer']
${primary_payer_select}    //*[@id='SelectedPrimaryPayerPlan']
${primary_subscriber_input}    //*[@id='PrimaryPayerCertificateNumber']
${primary_group_input}    //*[@id='PrimaryPayerGroupNumber']
${primary_effective_input}    //*[@id='PrimaryPayerEffectiveDate']
${primary_expiration_input}    //*[@id='PrimaryPayerExpirationDate']
#Medical Payer / Insurance Information - Secondary Payer / Insurance
${secondary_assign_select}    //*[@id='SecondaryPayer']
${secondary_payer_select}    //*[@id='SelectedSecondaryPayerPlan']
${secondary_subscriber_input}    //*[@id='SecondaryPayerCertificateNumber']
${secondary_group_input}    //*[@id='SecondaryPayerGroupNumber']
${secondary_effective_input}    //*[@id='SecondaryPayerEffectiveDate']
${secondary_expiration_input}    //*[@id='SecondaryPayerExpirationDate']
#Medical Payer / Insurance Information - Tertiary Payer / Insurance
${tertiary_assign_select}    //*[@id='TertiaryPayer']
${tertiary_payer_select}    //*[@id='SelectedTertiaryPayerPlan']
${tertiary_subscriber_input}    //*[@id='TertiaryPayerCertificateNumber']
${tertiary_group_input}    //*[@id='TertiaryPayerGroupNumber']
${tertiary_effective_input}    //*[@id='TertiaryPayerEffectiveDate']
${tertiary_expiration_input}    //*[@id='TertiaryPayerExpirationDate']
#Pharmacy Payer / Insurance Information - Primary Pharmacy Payer / Insurance
${pharmacy_primary_assign_select}    //*[@id='PrimaryPharmacyPayer']
${pharmacy_primary_payer_select}    //*[@id='SelectedPrimaryPharmacyPayerPlan']
${pharmacy_primary_subscriber_input}    //*[@id='PrimaryPharmacyPayerCertificateNumber']
${pharmacy_primary_group_input}    //*[@id='PrimaryPharmacyPayerGroupNumber']
${pharmacy_primary_BIN_input}    //*[@id='PrimaryPharmacyPayerBIN']
${pharmacy_primary_PCN_input}    //*[@id='PrimaryPharmacyPayerPCN']
${pharmacy_primary_RXgroup_input}    //*[@id='PrimaryPharmacyPayerRxGroup']
${pharmacy_primary_effective_input}    //*[@id='PrimaryPharmacyPayerEffectiveDate']
${pharmacy_primary_expiration_input}    //*[@id='PrimaryPharmacyPayerExpirationDate']
#Pharmacy Payer / Insurance Information - Secondary Pharmacy Payer / Insurance
${pharmacy_secondary_assign_select}    //*[@id='SecondaryPharmacyPayer']
${pharmacy_secondary_payer_select}    //*[@id='SelectedSecondaryPharmacyPayerPlan']
${pharmacy_secondary_subscriber_input}    //*[@id='SecondaryPharmacyPayerCertificateNumber']
${pharmacy_secondary_group_input}    //*[@id='SecondaryPharmacyPayerGroupNumber']
${pharmacy_secondary_BIN_input}    //*[@id='SecondaryPharmacyPayerBIN']
${pharmacy_secondary_PCN_input}    //*[@id='SecondaryPharmacyPayerPCN']
${pharmacy_secondary_RXgroup_input}    //*[@id='SecondaryPharmacyPayerRxGroup']
${pharmacy_secondary_effective_input}    //*[@id='SecondaryPharmacyPayerEffectiveDate']
${pharmacy_secondary_expiration_input}    //*[@id='SecondaryPharmacyPayerExpirationDate']
#Pharmacy Payer / Insurance Information - Tertiary Pharmacy Payer / Insurance
${pharmacy_tertiary_assign_select}    //*[@id='TertiaryPharmacyPayer']
${pharmacy_tertiary_payer_select}    //*[@id='SelectedTertiaryPharmacyPayerPlan']
${pharmacy_tertiary_subscriber_input}    //*[@id='TertiaryPharmacyPayerCertificateNumber']
${pharmacy_tertiary_group_input}    //*[@id='TertiaryPharmacyPayerGroupNumber']
${pharmacy_tertiary_BIN_input}    //*[@id='TertiaryPharmacyPayerBIN']
${pharmacy_tertiary_PCN_input}    //*[@id='TertiaryPharmacyPayerPCN']
${pharmacy_tertiary_RXgroup_input}    //*[@id='TertiaryPharmacyPayerRxGroup']
${pharmacy_tertiary_effective_input}    //*[@id='TertiaryPharmacyPayerEffectiveDate']
${pharmacy_tertiary_expiration_input}    //*[@id='TertiaryPharmacyPayerExpirationDate']
#Error Message
${error_first_name}    (//li[contains(text(),'First Name')])[1]
${error_last_name}    (//li[contains(text(),'Last Name')])[1]
${error_MRN_name}    (//li[contains(text(),'Medical Record #')])[1]
${error_DOB_name}    (//li[contains(text(),'Date Of Birth')])[1]
${error_gender_name}    (//li[contains(text(),'Gender')])[1]
# Patient Locator
${patients_save_btn}    //*[@id='ContinueButton']
${cancel_update_patient_btn}    //*[@href and text()='Cancel']
${patients_update_btn}    //*[@id='SaveButton']
${inactive_patient_checkbox}    //*[@id='Inactive']
${save_changes_btn}    //*[contains(text(),'Save Changes!') and @onclick]
${close_modal_btn}    //button[@id='CloseModalBtn']
${delete_patient_btn}    //*[@id='DeletePatientButton']

*** Keywords ***
Fill In And Select All Fields
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}     ${dict_arg}
    Fill In And Select In Patient Identifiers    ${mrn_arg}    ${refering_provider_arg}     ${dict_arg}
    Fill In And Select In Health Information    ${dict_arg}
    Fill In And Select In Personal Information    ${dict_arg}
    Fill In And Select In Employer Information    ${dict_arg}
    Fill In And Select In Responsible Information    ${dict_arg}
    Fill In And Select In Emergency Contact Information    ${dict_arg}

Fill In And Select In Patient Identifiers
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    first_name    middle_name    last_name    dob    ssn    sentence
    Input First Name In Patient Information    ${Fake_dict['first_name']}
    Input Middle Name In Patient Information    ${Fake_dict['middle_name']}
    Input Last Name In Patient Information    ${Fake_dict['last_name']}
    Input MRN In Patient Information    ${mrn_arg}
    Input DOB In Patient Information    ${Fake_dict['dob']}
    Input SSN In Patient Information    ${Fake_dict['ssn']}
    Select Race In Patient Information    ${dict_arg}
    Input Race Additional Detail In Patient Information    ${Fake_dict['sentence']}
    Select Ethnicity In Patient Information    ${dict_arg}
    Select Gender In Patient Information    ${dict_arg}
    Select Marital Status In Patient Information    ${dict_arg}
    Input Spouse First Name In Patient Information    ${Fake_dict['first_name']}
    Input Spouse Middle Name In Patient Information    ${Fake_dict['middle_name']}
    Input Spouse Last Name In Patient Information    ${Fake_dict['last_name']}
    Select Preferred Internal Provider In Patient Information    ${dict_arg}
    Input Refering Provider In Patient Information    ${refering_provider_arg}  
    Select PCP In Patient Information    ${dict_arg}

    Set To Dictionary    ${dict_arg}    
        ...    first_name=${Fake_dict['first_name']}   
        ...    middle_name=${Fake_dict['middle_name']}   
        ...    last_name=${Fake_dict['last_name']}  
        ...    mrn=${mrn_arg} 
        ...    refering_provider=${refering_provider_arg} 
        ...    dob=${Fake_dict['dob']}   
        ...    ssn=${Fake_dict['ssn']}   
        ...    race_additional_detail=${Fake_dict['sentence']}   
        ...    spouse_first_name=${Fake_dict['first_name']}   
        ...    spouse_middle_name=${Fake_dict['middle_name']}   
        ...    spouse_last_name=${Fake_dict['last_name']}   

Fill In And Select In Health Information
    [Arguments]    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    sentence    height    weight
    Input Dispensing Alert Note In Patient Information    ${Fake_dict['sentence']}
    Input Height In Patient Information    ${Fake_dict['height']}
    Handle Weight Input In Patient Information    ${Fake_dict['weight']}    ${dict_arg}
    
    Set To Dictionary    ${dict_arg}    
        ...    dispense_alert_note=${Fake_dict['sentence']}   
        ...    height=${Fake_dict['height']}   
        ...    weight=${Fake_dict['weight']}   

Fill In And Select In Personal Information
    [Arguments]    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    phone    email    sentence
    Select Default Contact In Patient Information    random    ${dict_arg}
    Input HomePhone In Patient Information    ${Fake_dict['phone']}
    Input Cellphone In Patient Information    ${Fake_dict['phone']}
    Input Email In Patient Information    ${Fake_dict['email']}
    Input Additional Notes In Patient Information    ${Fake_dict['sentence']}

    Set To Dictionary    ${dict_arg}    
        ...    homephone=${Fake_dict['phone']}   
        ...    cellphone=${Fake_dict['phone']}   
        ...    email=${Fake_dict['email']}   
        ...    additional_notes=${Fake_dict['sentence']}   
    
Fill In And Select In Employer Information
    [Arguments]    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    job    full_name    phone    first_name    last_name    address    country    postal_code
    Input Occupation In Patient Information    ${Fake_dict['job']}
    Input Employer Name In Patient Information    ${Fake_dict['full_name']}
    Input Work Phone In Patient Information    ${Fake_dict['phone']}
    Input Employer Contact First Name In Patient Information    ${Fake_dict['first_name']}
    Input Employer Contact Last Name In Patient Information    ${Fake_dict['last_name']}
    Input Employer Contact Phone In Patient Information    ${Fake_dict['phone']}
    Input Employer Address Line 1 In Patient Information    ${Fake_dict['address']}
    Input Employer Address Line 2 In Patient Information    ${Fake_dict['address']}
    Input Employer City In Patient Information    ${Fake_dict['country']}
    Select Employer State In Patient Information    ${dict_arg}
    Input Employer Postal Code In Patient Information    ${Fake_dict['postal_code']}
    Select Employer Country In Patient Information    ${dict_arg}

    Set To Dictionary    ${dict_arg}    
        ...    occupation=${Fake_dict['job']}   
        ...    employer_name=${Fake_dict['full_name']}   
        ...    workphone=${Fake_dict['phone']}   
        ...    employer_contact_first_name=${Fake_dict['first_name']}   
        ...    employer_contact_last_name=${Fake_dict['last_name']}   
        ...    employer_contact_phone=${Fake_dict['phone']}   
        ...    employer_address_line_1=${Fake_dict['address']}   
        ...    employer_address_line_2=${Fake_dict['address']}   
        ...    employer_city=${Fake_dict['country']}   
        ...    employer_postal_code=${Fake_dict['postal_code']}   

Fill In And Select In Responsible Information
    [Arguments]    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    first_name    middle_name    last_name    phone    dob    ssn    address    country    postal_code
    Input Responsible First Name In Patient Information    ${Fake_dict['first_name']}
    Input Responsible Middle Name In Patient Information    ${Fake_dict['middle_name']}
    Input Responsible Last Name In Patient Information    ${Fake_dict['last_name']}
    Input Responsible Phone In Patient Information    ${Fake_dict['phone']}
    Input Responsible DOB In Patient Information    ${Fake_dict['dob']}
    Input Responsible SSN In Patient Information    ${Fake_dict['ssn']}
    Input Responsible Address Line 1 In Patient Information    ${Fake_dict['address']}
    Input Responsible Address Line 2 In Patient Information    ${Fake_dict['address']}
    Input Responsible City In Patient Information    ${Fake_dict['country']}
    Select Responsible State In Patient Information    ${dict_arg}
    Input Responsible Postal Code In Patient Information    ${Fake_dict['postal_code']}
    Select Responsible Country In Patient Information    ${dict_arg}

    Set To Dictionary    ${dict_arg}    
        ...    responsible_first_name=${Fake_dict['first_name']}   
        ...    responsible_middle_name=${Fake_dict['middle_name']}   
        ...    responsible_last_name=${Fake_dict['last_name']}   
        ...    responsible_phone=${Fake_dict['phone']}   
        ...    responsible_dob=${Fake_dict['dob']}   
        ...    responsible_ssn=${Fake_dict['ssn']}   
        ...    responsible_address_line_1=${Fake_dict['address']}   
        ...    responsible_address_line_2=${Fake_dict['address']}   
        ...    responsible_city=${Fake_dict['country']}   
        ...    responsible_postal_code=${Fake_dict['postal_code']}   

Fill In And Select In Emergency Contact Information
    [Arguments]    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    full_name    phone    relationship
    Input Emergency Name In Patient Information    ${Fake_dict['full_name']}
    Input Emergency Phone In Patient Information    ${Fake_dict['phone']}
    Input Emergency Relationship In Patient Information    ${Fake_dict['relationship']}

    Set To Dictionary    ${dict_arg}    
        ...    emergency_name=${Fake_dict['full_name']}   
        ...    emergency_phone=${Fake_dict['phone']}   
        ...    emergency_relationship=${Fake_dict['relationship']}  

Input Valid Data In Necessary Fields
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    first_name    middle_name    last_name    dob    height    weight
    Input First Name In Patient Information    ${Fake_dict['first_name']}
    Input Middle Name In Patient Information    ${Fake_dict['middle_name']}
    Input Last Name In Patient Information    ${Fake_dict['last_name']}
    Input MRN In Patient Information    ${mrn_arg}  
    Input DOB In Patient Information    ${Fake_dict['dob']}
    Select Gender In Patient Information    ${dict_arg}
    Select Preferred Internal Provider In Patient Information    ${dict_arg}
    Input Refering Provider In Patient Information    ${refering_provider_arg}
    Input Height In Patient Information    ${Fake_dict['height']}
    Handle Weight Input In Patient Information    ${Fake_dict['weight']}    ${dict_arg}

    Set To Dictionary    ${dict_arg}    
        ...    first_name=${Fake_dict['first_name']}    
        ...    middle_name=${Fake_dict['middle_name']}    
        ...    last_name=${Fake_dict['last_name']}    
        ...    mrn=${mrn_arg}  
        ...    dob=${Fake_dict['dob']}    
        ...    refering_provider=${refering_provider_arg}
        ...    height=${Fake_dict['height']}
        ...    weight=${Fake_dict['weight']}

Handle Weight Input In Patient Information
    [Arguments]    ${weight_value_arg}    ${dict_arg}    #1kg ~ 2.2046lb
    ${weights_list}    Create List    ${weight_lp_input}    ${weight_kg_input}
    ${random_weights}    Evaluate    random.choice(${weights_list})
    IF    "${random_weights}" == "${weight_lp_input}"
        Input Weight Pounds In Patient Information    ${weight_value_arg}
        Click Element    ${weight_kg_title}
        ${weight_lp_value}    Set Variable    ${weight_value_arg}
        ${weight_kg_value}    Evaluate    round(${weight_value_arg} / 2.2046, 2)    #1kg ~ 2.2046lb
        ${weight_kg_value}    Convert To String    ${weight_kg_value}
    ELSE
        Input Weight Kilograms In Patient Information    ${weight_value_arg}
        Click Element    ${weight_lp_title}
        ${weight_kg_value}    Set Variable    ${weight_value_arg}
        ${weight_lp_value}    Evaluate    round(${weight_value_arg} * 2.2046)    #1kg ~ 2.2046lb
        ${weight_lp_value}    Convert To String    ${weight_lp_value}
    END
    Set To Dictionary    ${dict_arg}    weight_kg_value=${weight_kg_value}    weight_lp_value=${weight_lp_value}    random_weights=${random_weights}

Input Required Fields In Patient Information
    [Arguments]    ${first_name_arg}    ${last_name_arg}    ${mrn_arg}    ${dob_arg}    ${gender_arg}    ${dict_arg}
    Input First Name In Patient Information    ${first_name_arg}
    Input Last Name In Patient Information    ${last_name_arg}
    Input MRN In Patient Information    ${mrn_arg}
    Input DOB In Patient Information    ${dob_arg}
    IF    '${gender_arg}' == '${None}'
        Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${gender_select}    0
    ELSE IF    '${gender_arg}' == 'random'
        Select Gender In Patient Information    ${dict_arg}
    END

Delete Patient In Patient Information
    [Arguments]    ${mrn_arg}
    ${check_alert_visible}    Set Variable    ${True}
    ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${mrn_arg}']/preceding::td[2]//a
    ${check_mrn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_mrn_row}    3s
    IF    '${check_mrn_visible}' == '${True}'
        Common.Scroll And Click Element    ${patient_mrn_row}
        Click Delete Patient Button
        ${check_alert_visible}    Run Keyword And Return Status    Alert Should Be Present    Are you sure you want to Delete this patient?    ACCEPT    5s
        IF    '${check_alert_visible}' == '${False}'
            Page Should Contain    Can not delete patient because they have been assigned to an appointment! Please make the patient inactive.
            Wait Until Keyword Succeeds    30s    1s    Click Element    locator=//*[@id="CloseAlertModal"]
        ELSE
            Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients
        END
    END
    RETURN    ${check_alert_visible}

Verify Save Change Button Visible
    Scroll Element Into View    ${save_changes_btn}
    Wait Until Element Is Visible    ${save_changes_btn}    30s

Click Cancel Update Patient Button
    Common.Scroll And Click Element    ${cancel_update_patient_btn}

Click Save Patient Button
    Common.Scroll And Click Element    ${patients_save_btn}

Click Update Patient Button
    Common.Scroll And Click Element    ${Patients_Update_Btn}

Click Inactive Patient Button
    Common.Scroll And Click Element    ${inactive_patient_checkbox}

Click Delete Patient Button
    Common.Scroll And Click Element    ${delete_patient_btn}

# Patient Identifiers
Input First Name In Patient Information
    [Arguments]    ${first_name_arg}
    Clear Input Field Until Empty    ${first_name_input}
    Input Text Into Field    ${first_name_input}    ${first_name_arg}

Input Middle Name In Patient Information
    [Arguments]    ${middle_name_arg}
    Clear Input Field Until Empty    ${middle_name_input}
    Input Text Into Field    ${middle_name_input}    ${middle_name_arg}

Input Last Name In Patient Information
    [Arguments]    ${last_name_arg}
    Clear Input Field Until Empty    ${last_name_input}
    Input Text Into Field    ${last_name_input}    ${last_name_arg}

Input MRN In Patient Information
    [Arguments]    ${mrn_arg}
    Clear Input Field Until Empty    ${mrn_input}
    Input Text Into Field    ${mrn_input}    ${mrn_arg}

Input DOB In Patient Information
    [Arguments]    ${dob_arg}
    Clear Input Field Until Empty    ${dob_input}
    Input Text Into Field    ${dob_input}    ${dob_arg}
    Common.Close Calendar Table

Input SSN In Patient Information
    [Arguments]    ${ssn_arg}
    Clear Input Field Until Empty    ${ssn_input}
    Input Text Into Field    ${ssn_input}    ${ssn_arg}

Select Race In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${race_select}    var_name=race    dic=${dict_arg}

Input Race Additional Detail In Patient Information
    [Arguments]    ${race_additional_detail_arg}
    ${check_race_additional_detail_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${race_additional_detail_input}    2s
    IF    '${check_race_additional_detail_visible}' == '${True}'
        Clear Input Field Until Empty    ${race_additional_detail_input}
        Input Text Into Field    ${race_additional_detail_input}    ${race_additional_detail_arg}
    END

Select Ethnicity In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${ethnicity_select}    var_name=ethnicity    dic=${dict_arg}

Select Gender In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${gender_select}    var_name=gender    dic=${dict_arg}

Select Marital Status In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${marital_status_select}    var_name=marital_status    dic=${dict_arg}

Input Spouse First Name In Patient Information
    [Arguments]    ${spouse_first_name_arg}
    Clear Input Field Until Empty    ${spouse_first_name_input}
    Input Text Into Field    ${spouse_first_name_input}    ${spouse_first_name_arg}

Input Spouse Middle Name In Patient Information
    [Arguments]    ${spouse_middle_name_arg}
    Clear Input Field Until Empty    ${spouse_middle_name_input}
    Input Text Into Field    ${spouse_middle_name_input}    ${spouse_middle_name_arg}

Input Spouse Last Name In Patient Information
    [Arguments]    ${spouse_last_name_arg}
    Clear Input Field Until Empty    ${spouse_last_name_input}
    Input Text Into Field    ${spouse_last_name_input}    ${spouse_last_name_arg}

Select Preferred Internal Provider In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${preferred_internal_provider_select}    var_name=preferred_internal_provider    dic=${dict_arg}

Input Refering Provider In Patient Information
    [Arguments]    ${refering_provider_arg}
    ${refering_provide_strong}    Set Variable   xpath=//div//strong[contains(text(),'${refering_provider_arg}')]
    FOR    ${loop}    IN    30
        Press Keys    ${reffering_provider_input}    CTRL+A+BACKSPACE
        Input Text    ${reffering_provider_input}    ${refering_provider_arg}
        ${check_refering_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${refering_provide_strong}    5s
        IF    '${check_refering_visible}' == '${True}'
            Scroll And Click Element    ${refering_provide_strong}
            Exit For Loop
        END
    END

Select PCP In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${pcp_select}    var_name=pcp    dic=${dict_arg}

# Health Information
Input Dispensing Alert Note In Patient Information
    [Arguments]    ${dispensing_alert_note_arg}
    Clear Input Field Until Empty    ${dispensing_alert_note_input}
    Input Text Into Field    ${dispensing_alert_note_input}    ${dispensing_alert_note_arg}

Input Height In Patient Information
    [Arguments]    ${height_arg}
    Clear Input Field Until Empty    ${height_input}
    Input Text Into Field    ${height_input}    ${height_arg}

Input Weight Pounds In Patient Information
    [Arguments]    ${weight_lp_arg}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${weight_lp_input}
    Input Text Into Field    ${weight_lp_input}    ${weight_lp_arg}

Input Weight Kilograms In Patient Information
    [Arguments]    ${weight_kg_arg}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${weight_kg_input}
    Input Text Into Field    ${weight_kg_input}    ${weight_kg_arg}

Check BMI
    [Arguments]    ${weight_kg_value}    ${weight_lp_value}    ${height_value}    ${random_weights}
    Scroll Element Into View    ${bmi_text}
    ${bmi_text}    Get Text    ${bmi_text}
    IF    "${random_weights}" == "${weight_lp_input}"
        ${bmi_value}    Evaluate    round((${weight_lp_value} * 703) / ((${height_value}) ** 2), 1)    # (lb * 703) / (inch)^2
    ELSE
        ${bmi_value}    Evaluate    round((${weight_kg_value}) / ((${height_value} * 0.0254) ** 2), 1)    # (kg) / (inch * 0.0254)^2
    END
    ${bmi_value}    Convert To String    ${bmi_value}
    Should Be Equal    ${bmi_value}    ${bmi_text}

#Personal Information
Select Default Contact In Patient Information
    [Arguments]    ${default_contact_arg}    ${dict_arg}
    IF    '${default_contact_arg}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${default_contact_select}    var_name=default_contact    dic=${dict_arg}
    ELSE
        Scroll Element Into View    ${default_contact_select}
        Select From List By Label    ${default_contact_select}    ${default_contact_arg}
        Set To Dictionary    ${dict_arg}    default_contact=${default_contact_arg}
    END

Input HomePhone In Patient Information
    [Arguments]    ${homephone_arg}
    Clear Input Field Until Empty    ${homephone_input}
    Input Text Into Field    ${homephone_input}    ${homephone_arg}

Input Cellphone In Patient Information
    [Arguments]    ${cellphone_arg}
    Clear Input Field Until Empty    ${cellphone_input}
    Input Text Into Field    ${cellphone_input}    ${cellphone_arg}

Input Email In Patient Information
    [Arguments]    ${email_arg}
    Clear Input Field Until Empty    ${email_input}
    Input Text Into Field    ${email_input}    ${email_arg}

Input Additional Notes In Patient Information
    [Arguments]    ${additional_notes_arg}
    Clear Input Field Until Empty    ${additional_notes_input}
    Input Text Into Field    ${additional_notes_input}    ${additional_notes_arg}

#Employer Information
Input Occupation In Patient Information
    [Arguments]    ${occupation_arg}
    Clear Input Field Until Empty    ${occupation_input}
    Input Text Into Field    ${occupation_input}    ${occupation_arg}

Input Employer Name In Patient Information
    [Arguments]    ${employer_name_arg}
    Clear Input Field Until Empty    ${employer_name_input}
    Input Text Into Field    ${employer_name_input}    ${employer_name_arg}

Input Work Phone In Patient Information
    [Arguments]    ${work_phone_arg}
    Clear Input Field Until Empty    ${work_phone_input}
    Input Text Into Field    ${work_phone_input}    ${work_phone_arg}

Input Employer Contact First Name In Patient Information
    [Arguments]    ${employer_first_name_arg}
    Clear Input Field Until Empty    ${employer_first_name_input}
    Input Text Into Field    ${employer_first_name_input}    ${employer_first_name_arg}

Input Employer Contact Last Name In Patient Information
    [Arguments]    ${employer_last_name_arg}
    Clear Input Field Until Empty    ${employer_last_name_input}
    Input Text Into Field    ${employer_last_name_input}    ${employer_last_name_arg}

Input Employer Contact Phone In Patient Information
    [Arguments]    ${employer_phone_arg}
    Clear Input Field Until Empty    ${employer_phone_input}
    Input Text Into Field    ${employer_phone_input}    ${employer_phone_arg}

Input Employer Address Line 1 In Patient Information
    [Arguments]    ${employer_address_first_arg}
    Clear Input Field Until Empty    ${employer_address_line_1_input}
    Input Text Into Field    ${employer_address_line_1_input}    ${employer_address_first_arg}

Input Employer Address Line 2 In Patient Information
    [Arguments]    ${employer_address_second_arg}
    Clear Input Field Until Empty    ${employer_address_line_2_input}
    Input Text Into Field    ${employer_address_line_2_input}    ${employer_address_second_arg}

Input Employer City In Patient Information
    [Arguments]    ${employer_city_arg}
    Clear Input Field Until Empty    ${employer_city_input}
    Input Text Into Field    ${employer_city_input}    ${employer_city_arg}

Select Employer State In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${employer_state_select}    var_name=employer_state    dic=${dict_arg}

Input Employer Postal Code In Patient Information
    [Arguments]    ${employer_postal_code_arg}
    Clear Input Field Until Empty    ${employer_postal_code_input}
    Input Text Into Field    ${employer_postal_code_input}    ${employer_postal_code_arg}

Select Employer Country In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${employer_country_select}    var_name=employer_country    dic=${dict_arg}

#Responsible Information
Input Responsible First Name In Patient Information
    [Arguments]    ${responsible_first_name_arg}
    Clear Input Field Until Empty    ${responsible_first_name_input}
    Input Text Into Field    ${responsible_first_name_input}    ${responsible_first_name_arg}

Input Responsible Middle Name In Patient Information
    [Arguments]    ${responsible_middle_name_arg}
    Clear Input Field Until Empty    ${responsible_middle_name_input}
    Input Text Into Field    ${responsible_middle_name_input}    ${responsible_middle_name_arg}

Input Responsible Last Name In Patient Information
    [Arguments]    ${responsible_last_name_arg}
    Clear Input Field Until Empty    ${responsible_last_name_input}
    Input Text Into Field    ${responsible_last_name_input}    ${responsible_last_name_arg}

Input Responsible Phone In Patient Information
    [Arguments]    ${responsible_phone_arg}
    Clear Input Field Until Empty    ${responsible_phone_input}
    Input Text Into Field    ${responsible_phone_input}    ${responsible_phone_arg}

Input Responsible DOB In Patient Information
    [Arguments]    ${responsible_dob_arg}
    Clear Input Field Until Empty    ${responsible_dob_input}
    Input Text Into Field    ${responsible_dob_input}    ${responsible_dob_arg}
    Common.Close Calendar Table

Input Responsible SSN In Patient Information
    [Arguments]    ${responsible_ssn_arg}
    Clear Input Field Until Empty    ${responsible_ssn_input}
    Input Text Into Field    ${responsible_ssn_input}    ${responsible_ssn_arg}

Input Responsible Address Line 1 In Patient Information
    [Arguments]    ${responsible_address_line_1_arg}
    Clear Input Field Until Empty    ${responsible_address_line_1_input}
    Input Text Into Field    ${responsible_address_line_1_input}    ${responsible_address_line_1_arg}

Input Responsible Address Line 2 In Patient Information
    [Arguments]    ${responsible_address_line_2_arg}
    Clear Input Field Until Empty    ${responsible_address_line_2_input}
    Input Text Into Field    ${responsible_address_line_2_input}    ${responsible_address_line_2_arg}

Input Responsible City In Patient Information
    [Arguments]    ${responsible_city_arg}
    Clear Input Field Until Empty    ${responsible_city_input}
    Input Text Into Field    ${responsible_city_input}    ${responsible_city_arg}

Select Responsible State In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${responsible_state_select}    var_name=responsible_state    dic=${dict_arg}

Input Responsible Postal Code In Patient Information
    [Arguments]    ${responsible_postal_code_arg}
    Clear Input Field Until Empty    ${responsible_postal_code_input}
    Input Text Into Field    ${responsible_postal_code_input}    ${responsible_postal_code_arg}

Select Responsible Country In Patient Information
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${responsible_country_select}    var_name=responsible_country    dic=${dict_arg}

#Emergency Contact Information
Input Emergency Name In Patient Information
    [Arguments]    ${emergency_name_arg}
    Clear Input Field Until Empty    ${emergency_name_input}
    Input Text Into Field    ${emergency_name_input}    ${emergency_name_arg}

Input Emergency Phone In Patient Information
    [Arguments]    ${emergency_phone_arg}
    Clear Input Field Until Empty    ${emergency_phone_input}
    Input Text Into Field    ${emergency_phone_input}    ${emergency_phone_arg}

Input Emergency Relationship In Patient Information
    [Arguments]    ${emergency_relationship_arg}
    Clear Input Field Until Empty    ${emergency_relationship_input}
    Input Text Into Field    ${emergency_relationship_input}    ${emergency_relationship_arg}
    