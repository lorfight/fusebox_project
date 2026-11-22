*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Copay Assisstance
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_006    patient    Admin

*** Test Cases ***
Verify All Fields After Click On Add Co-Pay Assistance Button
    [Documentation]    CAP-1    CAP-2
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Verify All Fields After Click On Add Co-Pay Assistance Button

Create Co-Pay Assistance SuccessFully
    [Documentation]    CAP-4    CAP-8
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Create Co-Pay Assistance UnsuccessFully With Empty Medication
    [Documentation]    CAP-6
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=missing    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Procedure or function 'usp_CoPayAssistance_DuplicateExists' expects parameter '@ProprietaryName', which was not supplied.

Create Co-Pay Assisstance Unsuccessfully With Existing Medication Previously Created
    [Documentation]    CAP-5    CAP-7
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab    
    FOR    ${i}    IN RANGE    1    3
        Open Co-pay Assisstance Modal
        Set To Dictionary    ${TempData}    med_${i}=${med}
        Wait Until Element Is Visible    ${copay_med_label}    30s
        Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
        Input All Fields In Co-Pay Assistance Modal    medication=${TempData.med_1}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
        IF    ${i} == 1
            Page Alert Message    Co-Pay Assistance Added
        ELSE
            Page Alert Message    A Co-Pay Assistance for this Patient and this Medication already exists. Duplicates are not allowed.
        END
    END

Create Co-Pay Assistance UnsuccessFully With Empty Program
    [Documentation]    CAP-9
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create Fake Data List
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Program is required.

Verify Fields Are Retrieved Data From Selected Program
    [Documentation]    CAP-10    CAP-11    CAP-12    CAP-13    CAP-14
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Verify All Fields Are Empty
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${None}
    Verify Fields Of Program Are Retrieved

Verify CAP Status Have Available Value And User Can Click On It
    [Documentation]    CAP-17
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Verify CAP Status Select Have Available Value

Perform Actions With CAP Identification Number Field
    [Documentation]    CAP-19    CAP-20    CAP-21
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Input Long Characters Into Input SuccessFully    input_arg=${copay_CAP_ID_input}    length=255
    Input Long Characters Into Input UnsuccessFully    input_arg=${copay_CAP_ID_input}    length=256
    Scroll And Click Element    ${add_copay_assistance_btn}
    Page Alert Message    CAP Identification Number cannot be empty.

Perform Actions With CAP Group Number Field
    [Documentation]    CAP-22    CAP-23    CAP-24
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Input Long Characters Into Input SuccessFully    input_arg=${copay_CAP_group_input}    length=255
    Input Long Characters Into Input UnsuccessFully    input_arg=${copay_CAP_group_input}    length=256
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${EMPTY}    cap_amount=${EMPTY}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    CAP Group Number cannot be empty.

Perform Actions With CAP Approved $ Amount Field
    [Documentation]    CAP-25    CAP-26    CAP-27    CAP-28
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Verify Field Is Remain Blank When Previous Data Is Blank
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${EMPTY}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    CAP Approved Amount cannot be empty.
    Verify Input Maximum 2 Decimal And Numeric Into Field    input_arg=${copay_CAP_amount_input}    length=3
    Verify Field Is NOT Remain Blank When Previous Data Is NOT Blank

Perform Actions With Patient Copay $ Responsibility Field
    [Documentation]    CAP-29    CAP-30
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Verify Input Maximum 2 Decimal And Numeric Into Field    input_arg=${copay_CAP_responsibility_input}    length=3
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Perform Actions With Start Date Field
    [Documentation]    CAP-31    CAP-32
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${None}
    Scroll And Click Element    ${copay_CAP_startdate_input}
    Clear Element Text    ${copay_CAP_startdate_input}
    Scroll And Click Element   ${copay_done_btn}
    Scroll And Click Element   ${add_copay_assistance_btn}
    Page Alert Message    Approval Start Date cannot be empty.

Perform Actions With End Date Field
    [Documentation]    CAP-33    CAP-34
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${None}
    Scroll And Click Element    ${copay_CAP_enddate_input}
    Clear Element Text    ${copay_CAP_enddate_input}
    Scroll And Click Element   ${copay_done_btn}
    Scroll And Click Element   ${add_copay_assistance_btn}
    Page Alert Message    Approval End Date cannot be empty.

Perform Actions With CAP Credit / Debit Card Number Field
    [Documentation]    CAP-35    CAP-36    CAP-37
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Verify Field Only Contains Numbers    input_arg=${copay_CAP_credit_input}    length=16
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Perform Actions With CVV Field
    [Documentation]    CAP-38    CAP-39    CAP-40    CAP-41
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Scroll And Click Element    ${copay_security_icon}
    Verify Field Only Contains Numbers    input_arg=${copay_CVV_input}    length=4
    Scroll And Click Element    ${copay_security_icon}
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Perform Actions With Billing ZIP
    [Documentation]    CAP-42    CAP-43
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Input Long Characters Into Input SuccessFully    input_arg=${copay_billing_zip_input}    length=15
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Perform Actions With Card Exp Date Field
    [Documentation]    CAP-33    CAP-34    CAP-46
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.non_exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Card Expiration Date cannot already be expired.
    Scroll And Click Element    ${copay_expdate_input}
    Clear Element Text    ${copay_expdate_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_expdate_input}    ${Fake_dict.exp_date}
    Scroll And Click Element   ${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added

Verify Open Patient Document Center Popup When Clicking on [Documents] Button
    [Documentation]    CAP-48
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Scroll And Click Element    ${copay_document_btn}
    Wait Until Element Is Visible    ${copay_document_title}    30s
    Check Document Information
    Scroll And Click Element    ${copay_document_close_btn}

Perform Actions With Upload Co-Pay Document Popup
    [Documentation]    CAP-49    CAP-51    CAP-55
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Scroll And Click Element    ${copay_upload_document_btn}
    Page Alert Message    Please select a Medication.
    Select From List By Label    ${copay_med_select}    ${med_txt}
    Scroll And Click Element    ${copay_upload_document_btn}
    Wait Until Element Is Visible    ${copay_upload_document_title}    30s
    Input Long Characters Into Input SuccessFully    input_arg=${document_description_input}    length=150
    Input Long Characters Into Input UnsuccessFully    input_arg=${document_description_input}    length=151
    Scroll And Click Element    ${copay_upload_btn}
    Page Alert Message    Please select a Document.

Update Co-Pay Assisstance Unsuccessfully When Empty Program
    [Documentation]    CAP-58    CAP-59
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added
    ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
    Scroll And Click Element    ${copay_edit_btn}
    Wait Until Element Is Visible    ${copay_med_label}    30s
    Select From List By Label    ${copay_program_select}    -- Select A Program --
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${copay_update_btn}
    Page Alert Message    Co-Pay Program is required.

Update Co-Pay Assisstance Successfully When Re-select CAP Special List
    [Documentation]    CAP-60    CAP-61    CAP-64    CAP-67    CAP-68    CAP-69    CAP-70    CAP-71    CAP-72    CAP-117
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    RePatient.Get User Name
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added
    ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
    Scroll And Click Element    ${copay_edit_btn}
    Wait Until Element Is Visible    ${copay_med_label}    30s
    Create Fake Data List
    Input All Fields In Co-Pay Assistance Modal    medication=missing    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.decimal_3d_2f}    cap_respon=${Fake_dict.decimal_3d_2f}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${None}
    Update Related Note In Copay Modal
    Scroll And Click Element   ${copay_update_btn}
    Page Alert Message    Co-Pay Assistance Updated
    Verify Co-Pay Assistance Row With Valid Info

# Update Co-pay Assisstance UnsuccessFully With Empty Required Fields
#     [Documentation]    CAP-62    CAP-63    CAP-65    CAP-66
#     [Tags]    Regression     Co-pay Assistance
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Open Co-Pay Assistance Tab
#     Open Co-pay Assisstance Modal
#     Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
#     Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
#     Page Alert Message    Co-Pay Assistance Added
#     Update UnsuccessFully With Empty Required Fields

# Verify Payment History Table Without Appointment
#     [Documentation]    CAP-73
#     [Tags]    Regression     Co-pay Assistance
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Open Co-Pay Assistance Tab
#     Open Co-pay Assisstance Modal
#     Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
#     Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
#     Page Alert Message    Co-Pay Assistance Added
    
#     Check Info In Paymetn History Table Form    med_arg=${med_txt}

# Perform Actions With Payment History Table
#     [Documentation]    CAP-74    CAP-75    CAP-76
#     [Tags]    Regression     Co-pay Assistance
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Schedule Appointment With Past Date
#     Get Data With Created Appointment    APT_datetime=${PatientData.APT_Date}    apt_status=nor_status    apt_med=nor_med
#     Open Co-Pay Assistance Tab
#     Check Co-pay Assisstance Is Visible
#     Check Info In Paymetn History Table Form    med_arg=${PatientData.drug_PO}

# Verify Open Patient Document Center Popup With Created Co-pay Assisstance
#     [Documentation]    CAP-77
# 	[Tags]    Regression     Co-pay Assistance
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Open Co-Pay Assistance Tab
#     Open Co-pay Assisstance Modal
#     Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
#     Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
#     Page Alert Message    Co-Pay Assistance Added
#     ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
#     Scroll And Click Element    ${copay_edit_btn}
#     Scroll And Click Element    ${copay_document_btn}
#     Wait Until Element Is Visible    ${copay_document_title}    30s
#     Check Document Information
#     Scroll And Click Element     ${copay_document_close_btn}

# Verify Upload Co-Pay Document Popup With Created Co-pay Assisstance
#     [Documentation]    CAP-78    CAP-80    CAP-84
# 	[Tags]    Regression     Co-pay Assistance
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Open Co-Pay Assistance Tab
#     Open Co-pay Assisstance Modal
#     Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
#     Input All Fields In Co-Pay Assistance Modal    medication=${med}    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
#     Page Alert Message    Co-Pay Assistance Added
#     ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
#     Scroll And Click Element    ${copay_edit_btn}
#     Scroll And Click Element    ${copay_upload_document_btn}
#     Wait Until Page Contains Element   ${copay_upload_document_title}    30s
#     Input Long Characters Into Input SuccessFully    input_arg=${document_description_input}    length=150
#     Input Long Characters Into Input UnsuccessFully    input_arg=${document_description_input}    length=151
#     Scroll And Click Element    ${copay_upload_btn}
#     Page Alert Message    Please select a Document.

Create Co-Pay Assistance Program Successfully With Maximum Characters
    [Documentation]    CAP-87    CAP-88    CAP-89    CAP-93    CAP-96    CAP-97    CAP-99    CAP-102    CAP-105    CAP-106
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Select From List By Label    ${copay_program_select}    -- Create New Co-Pay Assistance Program --
    Wait Until Element Is Visible    ${program_modal_tilte}    30s
    Input Long Characters    input_arg=${program_name}    length=255
    ${program_option}    Set Variable    ${lenght_txt}
    Input Long Numbers    input_arg=${program_phone}    length=25
    Input Long Numbers    input_arg=${program_fax_enrollment}    length=25
    Input Long Characters    input_arg=${program_CAP}    length=255
    Input Long Numbers    input_arg=${program_phone_claims}    length=25
    Input Long Numbers    input_arg=${program_fax_claims}    length=25
    Scroll And Click Element    ${add_program_btn}
    Page Alert Message    Co-Pay Assistance Program added
    Select From List By Label    ${copay_program_select}    ${program_option}
    Wait Until Element Is Visible    ${copay_program_edit_btn}    30s
    Scroll And Click Element    ${close_copay_assistance_btn}
    
Verify Create Co-Pay Assistance Program Unsuccessfully If Empty Required Fields
    [Documentation]    CAP-90    CAP-94    CAP-100    CAP-103
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Leave Required Fields In Co-pay Assistance Program
    Scroll And Click Element    ${close_copay_assistance_btn}

Verify Create Co-Pay Assistance Program Unsuccessfully If Existing Name Previously Created
    [Documentation]    CAP-91
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    ${program_name_pre}    Set Variable    ${Fake_dict.full_name_fake}
    Create New Co-Pay Assistance Program    name_arg=${program_name_pre}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Program Name already exists. Duplicates are not allowed.

Verify Error When Non-Numeric Value Is Entered Into Phone [(Enrollment)], [Fax (Enrollment)], [Phone (Claims)], [Fax (Claims)]
    [Documentation]    CAP-92    CAP-96    CAP-101    CAP-104
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create Fake Data List
    Select From List By Label    ${copay_program_select}    -- Create New Co-Pay Assistance Program --
    Input Long Characters Into Input UnsuccessFully    input_arg=${program_phone}    length=20
    Input Long Characters Into Input UnsuccessFully    input_arg=${program_fax_enrollment}    length=20
    Input Long Characters Into Input UnsuccessFully    input_arg=${program_phone_claims}    length=20
    Input Long Characters Into Input UnsuccessFully    input_arg=${program_fax_claims}    length=20
    Scroll And Click Element    ${close_program_btn}

Verify Input Numeric and Text Into [CAP Website / On-line Form Link]
    [Documentation]    CAP-98
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create Fake Data List
    Select From List By Label    ${copay_program_select}    -- Create New Co-Pay Assistance Program --
    Input Long Characters Into Input SuccessFully    input_arg=${program_CAP}    length=25
    Scroll And Click Element    ${close_program_btn}

Verify Update Co-Pay Assistance Program Unsuccessfully If Empty Required Fields
    [Documentation]    CAP-107    CAP-108    CAP-110    CAP-112    CAP-113
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Update Co-Pay Assistance Program Unsuccessfully If Empty Required Fields

Verify Update Co-Pay Assistance Program Unsuccessfully If Existing Name Previously Created
    [Documentation]    CAP-109
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    ${program_name_pre}    Set Variable    ${Fake_dict.full_name_fake}
    Create Fake Data List
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Scroll And Click Element    ${copay_program_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${program_name}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_name}    ${program_name_pre}
    Scroll And Click Element    ${copay_program_update_btn}
    Page Alert Message    Program Name already exists. Duplicates are not allowed.

Verify Update Co-Pay Assistance Program Successfully If Inputting [Fax (Enrollment)], [Fax (Claims)]
    [Documentation]    CAP-111    CAP-114
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Scroll And Click Element    ${copay_program_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${program_fax_enrollment}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_enrollment}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${program_fax_claims}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_claims}    ${Fake_dict.sentence_str}
    Scroll And Click Element    ${copay_program_update_btn}
    Page Alert Message    Co-Pay Assistance Program updated

Verify Delete Co-Pay Assistance Program Successfully
    [Documentation]    CAP-115    CAP-116
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Co-Pay Assistance Tab
    Open Co-pay Assisstance Modal
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    ${program_name_pre}    Set Variable    ${Fake_dict.full_name_fake}
    Create Fake Data List
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    ${program_name_del}    Set Variable    ${Fake_dict.full_name_fake}
    Set Test Variable    ${program_name_del}
    Scroll And Click Element    ${copay_program_edit_btn}
    Scroll And Click Element    ${copay_program_delete_btn}
    Handle Alert    ACCEPT
    Page Alert Message    Co-Pay Assistance Program removed
    ${program_name_arg}    Set Variable    ${TempData.program_name}
    ${copay_program_option}    Replace Variables    ${copay_program_option}
    ${copay_program_option}    Get Text    ${copay_program_option}
    Should Contain    ${copay_program_option}    [REMOVED]
    Create Fake Data List
    Select From List By Label    ${copay_program_select}    ${program_name_pre}
    Scroll And Click Element    ${copay_program_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${program_name}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_name}    ${Fake_dict.full_name_fake}
    Scroll And Click Element    ${copay_program_update_btn}
    Page Alert Message    Co-Pay Assistance Program updated
    ${element_found}    Run Keyword And Return Status    Select From List By Label    ${copay_program_select}    ${program_name_del}
    Should Be Equal    ${element_found}    ${False}

Verify PA's Medication Is Displayed In Co-pay Assisstance With No Information
    [Documentation]    CAP-3    CAP-118
	[Tags]    Regression     Co-pay Assistance
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug_PO1}    PO_dosage_arg=${Fake_dict.demical_2d}
    Reload Page
    Open Co-Pay Assistance Tab
    Add Co-pay Assistance With PA's Medication    med_arg=${PatientData.drug_PO1}
    Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
    Input All Fields In Co-Pay Assistance Modal    medication=missing    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
    Page Alert Message    Co-Pay Assistance Added
    Check Co-pay Info In PA Tab

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${therapy_PO}    ${data_input}[therapy_PO]
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    Set Suite Variable    ${drug_PO1}    ${data_input}[drug_PO1]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    drug_PO=${drug_PO}    
    ...    drug_PO1=${drug_PO1}    
    ...    therapy_PO=${therapy_PO}
    ...    referto_provider_NPI_PO=${referto_provider_NPI_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}

Test Teardown Copay Assisstance
    Delete Co-Pay Assistance Program
    Test Teardown Keyword