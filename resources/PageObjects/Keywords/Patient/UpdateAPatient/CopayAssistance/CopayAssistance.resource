*** Settings ***
Resource    ../../../Layers/Common/Common.resource
Library    ../../../Layers/Fakedata/FakeData.py

*** Variables ***
${copay_assistance_tab}    //a[@id='CoPayAssistance']
${add_copay_assisstance_btn}    (//span[contains(text(),'Add Co-Pay Assistance')])[1]
${copay_select_medication}    //select[@id='SelectedMedication']
# Create Co-Pay Assistance Program Modal
${copay_program_select}    //select[@id='SelectedCoPayAssistanceProgramId']
${program_modal_tilte}    //h4[contains(text(),'Create Co-Pay Assistance Program')]
${program_name}    //input[@id='CoPayAssistanceProgramName']
${program_phone}    //input[@id='CoPayAssistanceProgramPhone']
${program_fax_enrollment}    //input[@id='CoPayAssistanceProgramFax']
${program_CAP}    //input[@id='ProgramWebsiteLink']
${program_phone_claims}    //input[@id='ProgramClaimsPhone']
${program_fax_claims}    //input[@id='ProgramClaimsFax']
${add_program_btn}    //button[contains(text(),'Add Program')]
${edit_program_btn}    //span[@id='UpdateCoPayAssistanceProgram']
${update_program_btn}    //button[contains(text(),'Update Program')]
${delete_program_btn}    //button[contains(text(),'Delete Program')]
${close_program_btn}    //form[@id='frm_CreateCoPayAssistanceProgram']//following::button[@id='CloseBtn'][1]
# Co-Pay Assisstance Modal
${copay_phone_enrollment_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='Phone']
${copay_fax_enrollment_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='Fax']
${copay_cap_website_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='WebsiteLink']
${copay_phone_claim_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsPhone']
${copay_fax_claim_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsFax']
${copay_cap_specialist_select}    //form[@id='frm_CreateCoPayAssistance']//following::select[@id='CoPaySpecialist']
${copay_cap_status_select}    //form[@id='frm_CreateCoPayAssistance']//following::select[@id='SelectedCoPayStatus']
${copay_cap_identification_number_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsPatientID']
${copay_cap_group_number_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='PatientGroupNumber']
${copay_cap_approved_amount_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceTotal']
${copay_patient_responsibility_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='PatientResponsibility']
${copay_approval_startdate_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceStartDate']
${copay_approval_enddate_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceEndDate']
${copay_cap_credit_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceCardNumber']
${copay_cvv_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='SecurityCode']
${copay_security_icon}    //form[@id='frm_CreateCoPayAssistance']//following::button[@id='DisplaySecurityCode']
${copay_billing_zip_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='BillingZip']
${copay_expdate_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='ExpirationDate']
${copay_cap_balance_input}    //form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceBalance']
${copay_related_note_input}    //form[@id='frm_CreateCoPayAssistance']//following::textarea[@id='NewCoPayNote']
${copay_add_note_btn}    //form[@id='frm_CreateCoPayAssistance']//following::a[contains(text(),'Add Note')]
${copay_related_note_line}    //form[@id='frm_CreateCoPayAssistance']//following::textarea[@id='NewCoPayNote']//following::td[1]
# Document
${copay_document_btn}    //a[contains(@onclick, 'LoadPatientDocumentModal')]
${copay_document_title}    //h4[contains(text(),'Patient Document Center')]
${copay_document_patient}    //strong[contains(text(),'Patient:')]//parent::div
${copay_document_dob}    //strong[contains(text(),'DOB:')]//parent::div
${copay_document_mrn}    //strong[contains(text(),'MRN:')]//parent::div
${copay_document_close_btn}    (//div[@id='SubModalPopup']//following::button[@id='CloseBtn' and contains(text(),'Close')])[1]
# Upload document
${copay_upload_document_btn}    //a[contains(@onclick, 'UploadCoPayDocumentModal')]
${copay_upload_document_title}    //h4[contains(text(),'Upload Co-Pay Document')]
${copay_upload_btn}    //*[@id='SaveBtn' and text()='Upload']
${document_description_input}    //textarea[@id='CopayDocumentDescription']
${add_copay_assistance_btn}    //form[@id='frm_CreateCoPayAssistance']//following::button[contains(text(),'Add Co-Pay Assistance')]
${update_copay_assistance_btn}    //*[@id='SaveBtn' and text()='Update Co-Pay Assistance']
${close_copay_assistance_btn}    //form[@id='frm_CreateCoPayAssistance']//following::button[contains(text(),'Close')][1]
# Payment History
${copay_payment_history_btn}    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']

*** Keywords ***
Create Copay Assisstance Dictionary
    &{CopayAssisstance_dict}    Create Dictionary
    RETURN    ${CopayAssisstance_dict}

Create Program Dictionary
    &{Program_dict}    Create Dictionary
    RETURN    ${Program_dict}

Open Co-Pay Assistance Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${copay_assistance_tab}
    Scroll And Click Element    ${copay_assistance_tab}
    Wait Until Element Is Visible    ${add_copay_assisstance_btn}    30s

Open Co-Pay Assistance Modal
    Common.Scroll And Click Element    ${add_copay_assisstance_btn}
    Wait Until Element Is Visible    //h4[text()='Co-Pay Assistance (CAP)']    30s

Select Medication
    [Arguments]    ${medication_arg}
    Wait Until Element Is Enabled    ${copay_select_medication}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${copay_select_medication}    ${medication_arg}

Open Create Copay Assisstance Program
    FOR    ${i}    IN RANGE    10
        Sleep    1s
        Select Program    -- Create New Co-Pay Assistance Program --
        ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${program_modal_tilte}    30s
        IF    "${check}" == "${True}"
            Exit For Loop
        ELSE
            Select Program    -- Select A Program --
        END
    END

Input Program Name
    [Arguments]    ${program_name_arg}
    Wait Until Element Is Visible    ${program_name}    30s
    Common.Clear Input Field Until Empty    ${program_name}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_name}    ${program_name_arg}

Input Program Phone (Enrollment) 
    [Arguments]    ${phone_arg}
    Wait Until Element Is Visible    ${program_phone}    30s
    Common.Clear Input Field Until Empty    ${program_phone}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_phone}    ${phone_arg}

Input Program Fax (Enrollment)
    [Arguments]    ${fax_arg}
    Wait Until Element Is Visible    ${program_fax_enrollment}    30s
    Common.Clear Input Field Until Empty    ${program_fax_enrollment}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_enrollment}    ${fax_arg}

Input Program CAP Website / Online Form Link
    [Arguments]    ${cap_arg}
    Wait Until Element Is Visible    ${program_CAP}    30s
    Common.Clear Input Field Until Empty    ${program_CAP}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_CAP}    ${cap_arg}

Input Program Phone (Claims)
    [Arguments]    ${phone_claim_arg}
    Wait Until Element Is Visible    ${program_phone_claims}    30s
    Common.Clear Input Field Until Empty    ${program_phone_claims}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_phone_claims}    ${phone_claim_arg}

Input Program Fax (Claims)
    [Arguments]    ${fax_claim_arg}
    Wait Until Element Is Visible    ${program_fax_claims}    30s
    Common.Clear Input Field Until Empty    ${program_fax_claims}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_claims}    ${fax_claim_arg}

Click Add Program Button
    [Arguments]    ${msg_arg}
    Common.Scroll And Click Element    ${add_program_btn}
    Common.Page Alert Message    ${msg_arg}

Click Update Program Button
    [Arguments]    ${msg_arg}
    Common.Scroll And Click Element    ${update_program_btn}
    Common.Page Alert Message    ${msg_arg}

Click Edit Program Button
    Common.Scroll And Click Element    ${edit_program_btn}

Click Delete Program Button
    Common.Scroll And Click Element    ${delete_program_btn}
    Alert Should Be Present    Are you sure you would like to remove this Co-Pay Assistance Program? This action cannot be undone!    ACCEPT    5s
    Page Alert Message    Co-Pay Assistance Program removed

Click Close Program Button
    Common.Scroll And Click Element    ${close_program_btn}

Select Program
    [Arguments]    ${program_arg}
    Wait Until Element Is Enabled    ${copay_program_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${copay_program_select}    ${program_arg}
    IF    '${program_arg}' not in ['-- Select A Program --', '-- Create New Co-Pay Assistance Program --']
        Page Alert Message    Selected Program's Information Updated. Please save your changes.
    END

Select CAP Specialist
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${copay_cap_specialist_select}    var_name=copay_cap_specialist    dic=${dict_arg}

Select CAP Status
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${copay_cap_status_select}    var_name=copay_cap_status    dic=${dict_arg}

Input CAP Identification Number
    [Arguments]    ${identification_number_arg}
    Wait Until Element Is Visible    ${copay_cap_identification_number_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_cap_identification_number_input}    ${identification_number_arg}

Input CAP Group Number
    [Arguments]    ${group_number_arg}
    Wait Until Element Is Visible    ${copay_cap_group_number_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_cap_group_number_input}    ${group_number_arg}

Input CAP Approved $ Amount
    [Arguments]    ${amount_arg}
    Wait Until Element Is Visible    ${copay_cap_approved_amount_input}    30s
    Common.Clear Input Field Until Empty    ${copay_cap_approved_amount_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_cap_approved_amount_input}    ${amount_arg}

Input Patient Copay $ Responsibility
    [Arguments]    ${responsibility_arg}
    Wait Until Element Is Visible    ${copay_patient_responsibility_input}    30s
    Common.Clear Input Field Until Empty    ${copay_patient_responsibility_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_patient_responsibility_input}    ${responsibility_arg}

Input Approval Start Date
    [Arguments]    ${startdate_arg}
    Wait Until Element Is Visible    ${copay_approval_startdate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_approval_startdate_input}    ${startdate_arg}
    Common.Close Calendar Table

Input Approval End Date
    [Arguments]    ${enddate_arg}
    Wait Until Element Is Visible    ${copay_approval_enddate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_approval_enddate_input}    ${enddate_arg}
    Common.Close Calendar Table

Input CAP Credit / Debit Card Number
    [Arguments]    ${card_number_arg}
    Wait Until Element Is Visible    ${copay_cap_credit_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_cap_credit_input}    ${card_number_arg}

Input CVV
    [Arguments]    ${cvv_arg}
    Wait Until Element Is Visible    ${copay_cvv_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_cvv_input}    ${cvv_arg}

Click Security Icon
    Common.Scroll And Click Element    ${copay_security_icon}

Input Billing ZIP
    [Arguments]    ${billing_zip_arg}
    Wait Until Element Is Visible    ${copay_billing_zip_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_billing_zip_input}    ${billing_zip_arg}

Input Card Exp Date
    [Arguments]    ${exp_date_arg}
    Wait Until Element Is Visible    ${copay_expdate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_expdate_input}    ${exp_date_arg}

Input Related Notes
    [Arguments]    ${related_note_arg}
    Wait Until Element Is Visible    ${copay_related_note_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_related_note_input}    ${related_note_arg}

Click Add Related Note Button
    Common.Scroll And Click Element    ${copay_add_note_btn}
    Alert Should Be Present    Are you sure you are all ready to submit this note?    ACCEPT    5s
    Page Alert Message    Co-Pay Assistance Note Successfully Added!

Related Notes Line Should Be Text
    [Arguments]    ${text_expect}
    ${copay_related_note_text}    Get Text    ${copay_related_note_line}
    Should Be Equal    ${copay_related_note_text}    ${text_expect}

Click Document Co-Pay Assisstance Button
    Common.Scroll And Click Element    ${copay_document_btn}
    Wait Until Element Is Visible    ${copay_document_title}    30s

Click Close Document Co-Pay Assisstance Button
    Common.Scroll And Click Element    ${copay_document_close_btn}

Click Upload Document Co-Pay Assisstance Button
    Common.Scroll And Click Element    ${copay_upload_document_btn}
    Wait Until Element Is Visible    ${copay_upload_document_title}    30s

Click Upload Co-Pay Document Button
    [Arguments]    ${alert_msg}
    Common.Scroll And Click Element    ${copay_upload_btn}
    Common.Page Alert Message    ${alert_msg}

Click Add Co-Pay Assisstance Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    ${add_copay_assistance_btn}
    Common.Page Alert Message    ${msg}

Click Update Co-Pay Assisstance Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    ${update_copay_assistance_btn}
    Common.Page Alert Message    ${msg}

Click Close Co-Pay Assisstance Button
    Common.Scroll And Click Element    ${close_copay_assistance_btn}

Click Edit Co-Pay Assisstance Button
    [Arguments]    ${medication_arg}
    ${copay_edit_btn}    Set Variable    //h3[contains(text(),'${medication_arg}')]//following::span[contains(text(),'Edit Co-Pay Assistance')][1]
    Common.Scroll And Click Element    ${copay_edit_btn}
    Wait Until Element Is Visible    //h4[text()='Co-Pay Assistance (CAP)']    30s

Click Payment History Button
    Common.Scroll And Click Element    ${copay_payment_history_btn}

Get Option In Medication Select
    [Arguments]    ${medication_list}
    ${index}    Get Variable Value    ${index}    1
    ${medication_option}    Set Variable    (//select[@id='SelectedMedication']//following::option)[${index}]
    ${medication_txt}    Wait Until Keyword Succeeds    10s    1s    Get Text    ${medication_option}
    ${index}    Evaluate    int(${index}) + 1
    Set Suite Variable    ${index}
    IF    '${medication_txt}' in ${medication_list}
        ${medication_txt}    Get Option In Medication Select    ${medication_list}
    END
    RETURN    ${medication_txt}

Create Program
    ${Program_dict}    Create Program Dictionary
    ${Fake_dict}    Generate Fake Data    full_name    phone    sentence    
    Open Create Copay Assisstance Program
    Input Program Name    program_name_arg=${Fake_dict['full_name']}
    Input Program Phone (Enrollment)    phone_arg=${Fake_dict['phone']}
    Input Program Fax (Enrollment)    fax_arg=${Fake_dict['phone']}
    Input Program CAP Website / Online Form Link    cap_arg=${Fake_dict['sentence']}
    Input Program Phone (Claims)    phone_claim_arg=${Fake_dict['phone']}
    Input Program Fax (Claims)    fax_claim_arg=${Fake_dict['phone']}
    Click Add Program Button    Co-Pay Assistance Program added

    Set To Dictionary    ${Program_dict}    
        ...    program_name=${Fake_dict['full_name']}
        ...    phone_enrollment=${Fake_dict['phone']}
        ...    fax_enrollment=${Fake_dict['phone']}
        ...    cap_website=${Fake_dict['sentence']}
        ...    phone_claim=${Fake_dict['phone']}
        ...    fax_claim=${Fake_dict['phone']}

    RETURN    ${Program_dict}    

Delete Co-Pay Assistance Program
    Reload Page
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${program_list}    Get List Items    ${copay_program_select}
    FOR    ${program_option}    IN    @{program_list} 
        IF    '${program_option}' not in ['-- Select A Program --', '-- Create New Co-Pay Assistance Program --']
            Select Program    ${program_option}
            Click Edit Program Button
            Click Delete Program Button
        END
    END

Prepare Data For Co-Pay Assistance
    ${Fake_dict}    Generate Fake Data    num_rand    demical_3d    credit_num    exp_date
    ${startdate}    Get Current Date    result_format=%m/%d/%Y
    ${enddate}    Add Time To Date    ${startdate}    365 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    RETURN    ${Fake_dict}    ${startdate}    ${enddate}

Upsert Co-Pay Assistance    
    [Arguments]    
        ...    ${medication_arg}    
        ...    ${program_arg}    
        ...    ${identification_number_arg}    
        ...    ${group_number_arg}    
        ...    ${amount_arg}    
        ...    ${responsibility_arg}    
        ...    ${startdate_arg}    
        ...    ${enddate_arg}    
        ...    ${card_number_arg}    
        ...    ${cvv_arg}    
        ...    ${billing_zip_arg}    
        ...    ${exp_date_arg}
        ...    ${utc}
        ...    ${btn_arg}
        ...    ${msg}

    ${CopayAssisstance_dict}    Create Copay Assisstance Dictionary
    IF    "${medication_arg}" != "missing"
        Select Medication    ${medication_arg}
    END
    IF    "${program_arg}" != "missing"
        Select Program    ${program_arg}
    END
    Select CAP Specialist    ${CopayAssisstance_dict}
    Select CAP Status    ${CopayAssisstance_dict}
    Input CAP Identification Number    ${identification_number_arg}
    Input CAP Group Number    ${group_number_arg}
    Input CAP Approved $ Amount    ${amount_arg}
    Input Patient Copay $ Responsibility    ${responsibility_arg}
    Input Approval Start Date    ${startdate_arg}
    Input Approval End Date    ${enddate_arg}
    Input CAP Credit / Debit Card Number    ${card_number_arg}
    Input CVV    ${cvv_arg}
    Input Billing ZIP    ${billing_zip_arg}
    Input Card Exp Date    ${exp_date_arg}
    
    IF    "${btn_arg}" == "${add_copay_assistance_btn}"
        Click Add Co-Pay Assisstance Button    ${msg}
    ELSE IF    "${btn_arg}" == "${update_copay_assistance_btn}"
        Update Related Note In Copay Modal     ${utc}
        Click Update Co-Pay Assisstance Button    ${msg}
    END
    Set To Dictionary    ${CopayAssisstance_dict}
        ...    identification_number=${identification_number_arg}
        ...    group_number=${group_number_arg}
        ...    amount=${amount_arg}
        ...    responsibility=${responsibility_arg}
        ...    startdate=${startdate_arg}
        ...    enddate=${enddate_arg}
        ...    card_number=${card_number_arg}
        ...    cvv=${cvv_arg}
        ...    billing_zip=${billing_zip_arg}
        ...    exp_date=${exp_date_arg}
    RETURN    ${CopayAssisstance_dict}

Verify Co-Pay Assistance Row With Valid Info
    [Arguments]    ${medication_arg}    ${compare_value_list}
    ${copay_medication_row}    Set Variable    //h3[contains(text(),'${medication_arg}')]
    ${program}    Set Variable    ${copay_medication_row}//following::strong[contains(text(),'Program')][1]//parent::h4
    SeleniumLibrary.Element Text Should Be    ${program}    Program: ${compare_value_list.program_name}
    ${element_list}    Create List    
        ...    Phone (Enrollment)
        ...    Fax (Enrollment)
        ...    CAP Website
        ...    Phone (Claims)
        ...    Fax (Claims)
        ...    CAP Specialist
        ...    CAP Status
        ...    CAP Identification Number
        ...    CAP Group Number
        ...    Approval Start Date
        ...    Approval End Date
        ...    CAP Approved $ Amount
        ...    Patient Copay $ Responsibility
        ...    CAP Card Current $ Balance

    ${expected_value_list}    Create List
        ...    ${compare_value_list.phone_enrollment}
        ...    ${compare_value_list.fax_enrollment}
        ...    ${compare_value_list.cap_website}
        ...    ${compare_value_list.phone_claim}
        ...    ${compare_value_list.fax_claim}
        ...    ${compare_value_list.copay_cap_specialist}
        ...    ${compare_value_list.copay_cap_status}
        ...    ${compare_value_list.identification_number}
        ...    ${compare_value_list.group_number}
        ...    ${compare_value_list.startdate}
        ...    ${compare_value_list.enddate}
        ...    ${compare_value_list.amount}
        ...    ${compare_value_list.responsibility}
        ...    ${compare_value_list.amount}
    
    FOR    ${element_name}    ${expected_value}    IN ZIP    ${element_list}    ${expected_value_list}
        ${element_txt}    Get Text    ${copay_medication_row}//following::span[contains(text(),'${element_name}')][1]//parent::td
        Should Contain    ${element_txt}    ${expected_value}
    END

Compare Program Name
    [Arguments]    ${copay_medication_row}    ${expected_value}
    ${copay_med_program}    Set Variable    ${copay_medication_row}//following::strong[contains(text(),'Program')][1]//parent::h4
    ${copay_med_program_txt}    Get Text    ${copay_med_program}
    Should Contain    ${copay_med_program_txt}    ${expected_value}

Verify All Input Fields Are Empty
    ${input_list}    Create List
        ...    ${copay_phone_enrollment_input}    
        ...    ${copay_fax_enrollment_input}    
        ...    ${copay_cap_website_input}    
        ...    ${copay_phone_claim_input}
        ...    ${copay_fax_claim_input}    
        ...    ${copay_cap_identification_number_input}    
        ...    ${copay_cap_group_number_input}    
        ...    ${copay_cap_approved_amount_input}
        ...    ${copay_patient_responsibility_input}    
        ...    ${copay_approval_startdate_input}    
        ...    ${copay_approval_enddate_input}    
        ...    ${copay_cap_credit_input}
        ...    ${copay_cvv_input}    
        ...    ${copay_billing_zip_input}    
        ...    ${copay_expdate_input}    
        ...    ${copay_cap_balance_input}

    FOR    ${input}    IN    @{input_list}
        ${value}    SeleniumLibrary.Get Element Attribute    ${input}    value
        Should Be Equal    ${value}    ${EMPTY}
    END

Verify All Select Fields Have Default Value
    ${select_list}    Create List
        ...    ${copay_select_medication}    
        ...    ${copay_program_select}    
        ...    ${copay_CAP_specialist_select}    
        ...    ${copay_CAP_status_select}    

    ${default_value_list}    Create List
        ...    -- Select A Medication --
        ...    -- Select A Program --
        ...    -- Select A Specialist --
        ...    Unknown

    FOR    ${select}    ${default_value}    IN ZIP    ${select_list}    ${default_value_list}
        ${first_option}    Get Selected List Label    ${select}
        Should Be Equal    ${first_option}    ${default_value}
    END

Verify Fields Of Program Are Retrieved
    [Arguments]    ${compare_value_list}
    ${input_list}    Create List
        ...    ${copay_phone_enrollment_input}    
        ...    ${copay_fax_enrollment_input}    
        ...    ${copay_cap_website_input}    
        ...    ${copay_phone_claim_input}    
        ...    ${copay_fax_claim_input}
    FOR    ${input}    ${compare_value}    IN ZIP    ${input_list}    ${compare_value_list}
        ${input_txt}=    SeleniumLibrary.Get Element Attribute    ${input}    value
        Should Be Equal    ${input_txt}    ${compare_value}
    END

Verify CAP Status Select Have Available Value
    ${expect_options}    Create List
        ...    Unknown
        ...    Pending
        ...    Approved
        ...    Expired
        ...    Denied
    Scroll And Click Element    ${copay_CAP_status_select}
    ${options}    Get List Items    ${copay_CAP_status_select}
    Lists Should Be Equal    ${options}    ${expect_options}

Verify Input Long Characters Into Field
    [Arguments]    ${input_field}    ${character_lenght}    ${equal_status}
    ${long_characters}    Generate Random String    ${character_lenght}    [LETTERS] [NUMBERS]
    Common.Clear Input Field Until Empty    ${input_field}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${input_field}    ${long_characters}
    ${value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${input_field}
    IF    "${equal_status}" == "equal"
        Should Be Equal    ${value}    ${long_characters}
    ELSE IF    "${equal_status}" == "not equal"
        Should Not Be Equal    ${value}    ${long_characters}
    END

Perform Actions With CAP Identification Number Field
    Common.Clear Input Field Until Empty    ${copay_cap_identification_number_input}
    Click Add Co-Pay Assisstance Button    CAP Identification Number cannot be empty.
    Verify Input Long Characters Into Field    
        ...    input_field=${copay_cap_identification_number_input}    
        ...    character_lenght=256    
        ...    equal_status=not equal
    Verify Input Long Characters Into Field    
        ...    input_field=${copay_cap_identification_number_input}    
        ...    character_lenght=255    
        ...    equal_status=equal

Perform Actions With CAP Group Number Field
    Common.Clear Input Field Until Empty    ${copay_cap_group_number_input}
    Click Add Co-Pay Assisstance Button    CAP Group Number cannot be empty.
    Verify Input Long Characters Into Field    
        ...    input_field=${copay_cap_group_number_input}    
        ...    character_lenght=256    
        ...    equal_status=not equal
    Verify Input Long Characters Into Field    
        ...    input_field=${copay_cap_group_number_input}    
        ...    character_lenght=255    
        ...    equal_status=equal

Perform Actions With CAP Approved $ Amount Field
    Verify CAP Approved $ Amount Field Is Remain Blank When Previous Data Is Blank
    Click Add Co-Pay Assisstance Button    CAP Approved Amount cannot be empty.
    Verify Input Maximum 2 Decimal And Numeric Into Field    ${copay_cap_approved_amount_input}
    Verify CAP Approved $ Amount Field Is NOT Remain Blank When Previous Data Is NOT Blank

Verify CAP Approved $ Amount Field Is Remain Blank When Previous Data Is Blank
    Common.Scroll And Click Element    ${copay_cap_approved_amount_input}
    Press Keys    None    TAB
    ${copay_cap_approved_amount_text}    Get Text    ${copay_cap_approved_amount_input}
    Should Be Empty    ${copay_cap_approved_amount_text}

Verify CAP Approved $ Amount Field Is NOT Remain Blank When Previous Data Is NOT Blank
    Common.Clear Input Field Until Empty    ${copay_cap_approved_amount_input}
    Press Keys    None    TAB
    ${value}    Get Value    ${copay_cap_approved_amount_input}
    Should Be Equal    ${value}    $0.00

Verify Input Maximum 2 Decimal And Numeric Into Field
    [Arguments]    ${input_field}
    ${int_part}    Generate Random String    3    123456789
    ${decimal_part}    Generate Random String    2    123456789
    ${number}    Set Variable    ${int_part}.${decimal_part}
    Common.Clear Input Field Until Empty    ${input_field}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${input_field}    ${number}
    Press Keys    None    TAB
    ${value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${input_field}
    Should Be Equal    ${value}    $${number}

Perform Actions With Patient Copay $ Responsibility Field
    Verify Input Maximum 2 Decimal And Numeric Into Field    ${copay_patient_responsibility_input}

Perform Actions With Approval Start Date Field
    [Arguments]    ${startdate_arg}
    Input Approval Start Date    ${EMPTY}
    Click Add Co-Pay Assisstance Button    Approval Start Date cannot be empty.
    Input Approval Start Date    ${startdate_arg}

Perform Actions With Approval End Date Field
    [Arguments]    ${enddate_arg}
    Input Approval End Date    ${EMPTY}
    Click Add Co-Pay Assisstance Button    Approval End Date cannot be empty.
    Input Approval End Date    ${enddate_arg}

Perform Actions With CAP Credit / Debit Card Number Field
    Verify Input Number Characters Into Field      
        ...    input_field=${copay_cap_credit_input}    
        ...    character_lenght=16 
        ...    equal_status=equal

Perform Actions With CVV Field
    Verify Input Number Characters Into Field      
        ...    input_field=${copay_cvv_input}    
        ...    character_lenght=4
        ...    equal_status=equal
    Verify CVV Field Has Input Type    expected_type=password
    Click Security Icon
    Verify CVV Field Has Input Type    expected_type=text

Verify CVV Field Has Input Type
    [Arguments]    ${expected_type}
    ${password_type}    SeleniumLibrary.Get Element Attribute    ${copay_cvv_input}    type
    Should Be Equal    ${password_type}    ${expected_type}

Perform Actions With Billing ZIP
    Verify Input Long Characters Into Field    
    ...    input_field=${copay_billing_zip_input}    
    ...    character_lenght=15    
    ...    equal_status=equal

Verify Input Number Characters Into Field
    [Arguments]    ${input_field}    ${character_lenght}    ${equal_status}
    ${long_characters}   Generate Random String   ${character_lenght}    [NUMBERS]
    Common.Clear Input Field Until Empty    ${input_field}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${input_field}    ${long_characters}
    ${value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${input_field}
    ${value}    Replace String    ${value}    ${SPACE}    ${EMPTY}
    IF    "${equal_status}" == "equal"
        Should Be Equal    ${value}    ${long_characters}
    ELSE IF    "${equal_status}" == "not equal"
        Should Not Be Equal    ${value}    ${long_characters}
    END

Perform Actions With Card Exp Date Field
    [Arguments]    ${exp_date_arg}
    ${current_date}    Get Current Date
    ${exp_date}    Subtract Time From Date    ${current_date}    30 days    result_format=%m/%y
    Input Card Exp Date    ${exp_date}
    Click Add Co-Pay Assisstance Button    Card Expiration Date cannot already be expired.
    Input Card Exp Date    31/13
    Click Add Co-Pay Assisstance Button    Card Expiration Date must be a valid date and in MM/YY format.
    Input Card Exp Date    ${exp_date_arg}

Check No Payment History Title In Paymetn History Table Form
    Click Payment History Button
    ${no_payment_history_title}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::tbody//tr//h3
    Wait Until Element Is Visible    ${no_payment_history_title}    30s
    ${no_payment_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${no_payment_history_title}
    Should Be Equal    ${no_payment_txt}    No Payment History found
    Click Close Co-Pay Assisstance Button

Verify Historical Data Against Created Appointments In Paymetn History Table Form
    [Arguments]    ${apt_datetime}    ${apt_starttime}    ${apt_status}    ${apt_med}
    Click Payment History Button
    Compare Appt Time Column    ${apt_datetime}    ${apt_starttime}
    Compare Appt Status Column    ${apt_datetime}    ${apt_status}
    Compare Appt Appt Treatment / Dose Column    ${apt_datetime}    ${apt_med}
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f
    Input CAP $ Charge Applied    ${apt_datetime}    ${Fake_dict['decimal_2d_2f']}
    Click Save Charge History    ${apt_datetime}
    Click Update Co-Pay Assisstance Button    msg=Co-Pay Assistance Updated

Compare Appt Time Column
    [Arguments]    ${apt_datetime}    ${apt_starttime}
    ${copay_history_appttime}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::td[contains(text(),'${apt_datetime}')]//following::td[1]
    ${copay_history_appttime}    Get Text    ${copay_history_appttime}
    Should Be Equal    ${copay_history_appttime.lower()}    ${apt_starttime.lower()}

Compare Appt Status Column
    [Arguments]    ${apt_datetime}    ${apt_status}
    ${copay_history_apptstatus}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::td[contains(text(),'${apt_datetime}')]//following::td[2]
    ${copay_history_apptstatus}    Get Text    ${copay_history_apptstatus}
    Should Be Equal    ${copay_history_apptstatus}    ${apt_status}

Compare Appt Appt Treatment / Dose Column
    [Arguments]    ${apt_datetime}    ${apt_med}
    ${copay_history_appttreatment}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::td[contains(text(),'${apt_datetime}')]//following::td[3]
    ${copay_history_appttreatment}    Get Text    ${copay_history_appttreatment}
    Should Be Equal    ${copay_history_appttreatment}    ${apt_med}

Input CAP $ Charge Applied
    [Arguments]    ${apt_datetime}    ${charge_value}
    ${copay_history_apptcharge}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::td[contains(text(),'${apt_datetime}')]//following::td[4]//input
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_history_apptcharge}    ${charge_value}    

Click Save Charge History
    [Arguments]    ${apt_datetime}
    ${copay_history_save_charge_btn}    Set Variable    //form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::td[contains(text(),'${apt_datetime}')]//following::td[4]//span//button
    Common.Scroll And Click Element    ${copay_history_save_charge_btn}
    Common.Page Alert Message    Co-Pay Amount Added!

Perform Actions With Program Name Field
    [Arguments]    ${status_arg}
    Input Program Name    ${EMPTY}
    IF    "${status_arg}" == "create"
        Click Add Program Button    Name cannot be empty.
    ELSE IF    "${status_arg}" == "update"
        Click Update Program Button    Name cannot be empty.
    END
    ${Fake_dict}    Generate Fake Data    full_name
    Input Program Name    ${Fake_dict['full_name']}

Perform Actions With Program Phone (Enrollment) Field
    [Arguments]    ${status_arg}
    Verify Input Long Characters Into Field    
        ...    input_field=${program_phone}
        ...    character_lenght=20    
        ...    equal_status=not equal
    Input Program Phone (Enrollment)    ${EMPTY}
    IF    "${status_arg}" == "create"
        Click Add Program Button    Phone (Enrollment) cannot be empty.
    ELSE IF    "${status_arg}" == "update"
        Click Update Program Button    Phone (Enrollment) cannot be empty.
    END
    ${Fake_dict}    Generate Fake Data    phone
    Input Program Phone (Enrollment)    ${Fake_dict['phone']}

Perform Actions With Program Fax (Enrollment) Field
    Verify Input Long Characters Into Field    
        ...    input_field=${program_fax_enrollment}    
        ...    character_lenght=20    
        ...    equal_status=not equal
    ${Fake_dict}    Generate Fake Data    phone
    Input Program Fax (Enrollment)    ${Fake_dict['phone']}

Perform Actions With Program CAP Website / Online Form Link Field
    [Arguments]    ${status_arg}
    Verify Input Long Characters Into Field    
        ...    input_field=${program_CAP}
        ...    character_lenght=255    
        ...    equal_status=equal
    Input Program CAP Website / Online Form Link    ${EMPTY}
    IF    "${status_arg}" == "create"
        Click Add Program Button    CAP Website / Form cannot be empty.
    ELSE IF    "${status_arg}" == "update"
        Click Update Program Button    CAP Website / Form cannot be empty.
    END
    ${Fake_dict}    Generate Fake Data    sentence
    Input Program CAP Website / Online Form Link    ${Fake_dict['sentence']}

Perform Actions With Program Phone (Claims) Field
    [Arguments]    ${status_arg}
    Verify Input Long Characters Into Field    
        ...    input_field=${program_phone_claims}    
        ...    character_lenght=20    
        ...    equal_status=not equal
    Input Program Phone (Claims)    ${EMPTY}
    IF    "${status_arg}" == "create"
        Click Add Program Button    Phone (Claims) cannot be empty.
    ELSE IF    "${status_arg}" == "update"
        Click Update Program Button    Phone (Claims) cannot be empty.
    END
    ${Fake_dict}    Generate Fake Data    phone
    Input Program Phone (Claims)    ${Fake_dict['phone']}

Perform Actions With Program Fax (Claims) Field
    Verify Input Long Characters Into Field    
        ...    input_field=${program_fax_claims}    
        ...    character_lenght=20    
        ...    equal_status=not equal
    ${Fake_dict}    Generate Fake Data    phone
    Input Program Fax (Claims)    ${Fake_dict['phone']}

Click Add Co-pay Assistance Button With PA's Medication
    [Arguments]    ${medication_arg}
    ${add_pa_copay_btn}    Set Variable    //h3[contains(text(),'${medication_arg}')]//following::span[contains(text(),'Add Co-Pay Assistance')]
    Scroll And Click Element    ${add_pa_copay_btn}
    Wait Until Element Is Visible    //h4[text()='Co-Pay Assistance (CAP)']    30s

Update Related Note In Copay Modal
    [Arguments]     ${utc}
    Related Notes Line Should Be Text    No Co-Pay Assistance Notes Available
    ${Fake_dict}    Generate Fake Data    sentence   
    Input Related Notes    ${Fake_dict['sentence']}
    ${expected_datetime}    ${expected_plus_1_minute}    Get Current Date Time When Add Related Note     ${utc}
    Click Add Related Note Button
    ${user_name_txt}    Common.Get User Name
    ${compare_value}    Set Variable    ${expected_datetime} - ${user_name_txt} : ${Fake_dict['sentence']}
    ${check_equal}    Run Keyword And Return Status    Related Notes Line Should Be Text    ${compare_value}
    IF    "${check_equal}" == "${False}"
        ${compare_value}    Set Variable    ${expected_plus_1_minute} - ${user_name_txt} : ${Fake_dict['sentence']}
        Related Notes Line Should Be Text    ${compare_value}
    END

Get Current Date Time When Add Related Note
    [Arguments]    ${utc}
    ${expected_datetime}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    utc=${utc}
    ${expected_plus_1_minute}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    utc=${utc}    add_minutes=1
    RETURN    ${expected_datetime}    ${expected_plus_1_minute}
