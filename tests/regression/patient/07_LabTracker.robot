*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_007    patient    Admin

*** Test Cases ***
Add Lab SuccessFully With Valid All Fields
    [Documentation]    PaMan_TC121    PaMan_TC122    PaMan_TC123_1    PaMan_TC139    PaMan_TC149
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
    Open Lab Tracker Row
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_file_num}    ${Fake_dict.num_rand} 
    Sleep    2s
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_value}    var_name=tracker_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_select}    var_name=tracker_frequency_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_status_select}    var_name=tracker_status_select    dic=${TempData}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    Lab Tracker Updated

Add Lab SuccessFully With Valid Required Fields
    [Documentation]    PaMan_TC123
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input Required Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}  
    ...    payer_arg=${lab_payer}    start_date_arg=${start_date}    end_date_arg=${end_date}
    ...    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    ICD10_arg=${icd10_code}    
    ...    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created

Add Lab UnsuccessFully With Empty Fields
    [Documentation]    PaMan_TC124
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    Select From List By Index    ${tracker_location}    0
    Clear Element Text    ${tracker_patient_name}
    ${errors}    Catenate    SEPARATOR= 
    # ...    The Account field is required.
    # ...    The Patient field is required.
    # ...    The Payer field is required.
    # ...    The Lab Description field is required.
    # ...    The Frequency Value field is required.
    # ...    The Frequency field is required.
    # ...    The Status field is required.
    # ...    The Result Date field is required.
    # ...    The Expiration Date field is required.
    # ...    The File Number field is required.
    # ...    The Order Start Date field is required.
    # ...    The Order End Date field is required.
    # ...    The ICD10 Code field is required.
    ...    The Account field is required.
    ...    The Patient field is required.
    ...    The Lab Description field is required.
    ...    The Frequency Value field is required.
    ...    The Frequency field is required.
    ...    The Status field is required.
    ...    The Order Start Date field is required.
    ...    The Order End Date field is required.
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    ${errors}
    Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Location Field
    [Documentation]    PaMan_TC125
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=- Select -    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=The Account field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Patient Name Field
    [Documentation]    PaMan_TC126
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30    1   Clear Input Field Until Empty    ${tracker_patient_name}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    The Patient field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

# Add Lab UnsuccessFully With Empty Payer Field
#     [Documentation]    PaMan_TC127
# 	[Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal    
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Wait Until Keyword Succeeds    30    1   Clear Input Field Until Empty    ${tracker_payer}
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message    The Payer field is required.
#     Scroll And Click Element Modal    ${tracker_close_btn}
    
Add Lab UnsuccessFully With Empty Description Field
    [Documentation]    PaMan_TC128
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_description}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    The Lab Description field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Frequency Field
    [Documentation]    PaMan_TC129
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${tracker_frequency_value}    0
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${tracker_frequency_select}    0
    ${errors}    Catenate    SEPARATOR= 
    ...    The Frequency Value field is required.
    ...    The Frequency field is required.
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    ${errors}
    Scroll And Click Element Modal    ${tracker_close_btn}

# Add Lab UnsuccessFully With Empty File Number Field
#     [Documentation]    PaMan_TC130
# 	[Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal    
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_file_num}
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message    The File Number field is required.
#     Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Status Field
    [Documentation]    PaMan_TC131
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${tracker_status_select}    0
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    The Status field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Order Start Date Field
    [Documentation]    PaMan_TC132
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_startdate_input}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    The Order Start Date field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

Add Lab UnsuccessFully With Empty Order End Date Field
    [Documentation]    PaMan_TC133
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal    
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_enddate_input}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    The Order End Date field is required.
    Scroll And Click Element Modal    ${tracker_close_btn}

# Add Lab UnsuccessFully With Empty Order Result Date Field
#     [Documentation]    PaMan_TC134
# 	[Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal    
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_resultdate_input}
#     ${errors}    Catenate    SEPARATOR= 
#     ...    The Result Date field is required.
#     ...    The Expiration Date field is required.
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message     ${errors}
#     Scroll And Click Element Modal    ${tracker_close_btn}

# Add Lab UnsuccessFully With Empty ICD10 Code Field
#     [Documentation]    PaMan_TC136
# 	[Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal    
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Scroll And Click Element    ${tracker_primary_del}
#     Page Alert Message    Primary Diagnosis Removed.
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message    The ICD10 Code field is required.
#     Scroll And Click Element Modal    ${tracker_close_btn}

Verify Account Field Shows Correct Fomat And Data
    [Documentation]    PaMan_TC137
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Repatient.Go To Patients Page
    ${location_user_list}    Get List Items    ${Patients_Location_Select}
    Filter Patient In Patient Page    MRN_arg=${PatientData.MRN}    location_arg=${PatientData.Location}
    Select Patient From List    MRN_arg=${PatientData.MRN}
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    ${location_tracker_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_location}
    Should Be Equal    ${location_user_list[1:]}    ${location_tracker_list[1:]}
    Scroll And Click Element Modal    ${tracker_close_btn}
    
Verify Patient Field Shows Correct Fomat And Data
    [Documentation]    PaMan_TC138
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    ${first_name}    Get Value    ${First_Name_Input}
    ${last_name}    Get Value    ${Last_Name_Input}
    ${dob}    Get Value    ${DOB_Input}
    ${mrn}    Get Value    ${MRN_Input}
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Input Patient Name Lab Tracker Modal    ${PatientData.MRN}
    ${tracker_patient_name_txt}    Get Value    ${tracker_patient_name}
    Should Be Equal    ${tracker_patient_name_txt}    ${last_name}, ${first_name} (${dob}) MRN: ${mrn} - (${PatientData.Location})
    Scroll And Click Element Modal    ${tracker_close_btn}

Verify Descirption Field Shows Correct Data When The Lab Is Assigned For One Medication
    [Documentation]    PaMan_TC140
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${True}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${PatientData.drug_PO1}
    ${description_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Should Be Equal    ${description_txt}    ${assign_lab_txt} (${PatientData.drug_PO1})
    
Verify Descirption Field Shows Correct Data When The Lab Is Assigned For Multiple Medication
    [Documentation]    PaMan_TC141
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Open Protocol Management Modal
    Show Medication's Required Labs    drug_arg=${PatientData.drug_PO1}
    Remove Lab Descirption Abiraterone Assigned Labs
    Select Lab Descirption In Quick Select Tool Table    ${True}
    Show Medication's Required Labs    drug_arg=${PatientData.drug_PO2}
    Remove Lab Descirption Abiraterone Assigned Labs
    Verify Descirption Field Shows Multiple Medication Data

Verify Frequency Fields Show Correct Fomat And Data
    [Documentation]    PaMan_TC143
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Open Protocol Management Modal
    Show Medication's Required Labs    ${PatientData.drug_PO1}
    Remove Lab Descirption Abiraterone Assigned Labs
    Select Lab Descirption In Quick Select Tool Table    ${True}
    ${protocol_value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${protocol_frequency_value}
    ${actual_list}    Evaluate    [int(i) for i in ${protocol_value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 91))
    Should Be Equal    ${protocol_value_list[0]}    - Select -
    Lists Should Be Equal    ${actual_list}    ${expected_list}
    ${protocol_select_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${protocol_frequency_select}
    ${expected_list}    Create List    Min(s)    Hour(s)    Day(s)    Week(s)    Month(s)    Year(s)
    Should Be Equal    ${protocol_select_list[0]}    - Frequency -
    Lists Should Be Equal    ${protocol_select_list[1:]}    ${expected_list}

Perform Actions With Expiration Field
    [Documentation]    PaMan_TC150    PaMan_TC151    PaMan_TC152    PaMan_TC153
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    ${startdate_value}     Get Value     ${tracker_resultdate_input}
    Compare Value Inputs    ${tracker_resultdate_input}    ${tracker_expdate_input}    Value
    Compare Value Inputs    ${tracker_expdate_input}    ${EMPTY}    Empty
    Get DateTime In Lab Tracker
    Input Date Time Lab Tracker Modal    ${start_date}    ${end_date}    ${result_date}
    Compare Value Inputs    ${tracker_resultdate_input}    ${tracker_expdate_input}    Value
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
    Check Value Expiration Date    ${tracker_frequency_value}    ${tracker_frequency_select}    ${tracker_resultdate_input}    ${tracker_expdate_input}
    Mouse Hover Element    ${tracker_expdate_input}    ${tracker_resultdate_input}    ${tracker_expdate_tooltip}
    Scroll And Click Element Modal    ${tracker_close_btn}

Verify That Status Select Show Correct Fomat And Data
    [Documentation]    PaMan_TC154
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    ${tracker_status_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_status_select}
    ${expected_list}    Create List    - Select -    Submitted    Approved    Archived    Ordered
    Lists Should Be Equal    ${tracker_status_list}    ${expected_list}

Verify Primary ICD10 Code List Contains Only One Value
    [Documentation]    PaMan_TC155    PaMan_TC157    PaMan_TC158
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    ${tracker_primary_ICD10_default}    Get Text    ${tracker_primary_ICD10_default}
    Should Be Equal    ${tracker_primary_ICD10_default}    No Primary ICD10 Code Added
    Choose Primary ICD10 Code    ${icd10_code}    Primary
    ${primary_ICD10_value1}    Get Text    ${tracker_primary_ICD10_list}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_ICD10_input}    ${icd10_code}[icd10_code2]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_ICD10_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_add_btn}
    ${primary_ICD10_value2}    Get Text    ${tracker_primary_ICD10_list}
    Should Not Be Equal    ${primary_ICD10_value1}    ${primary_ICD10_value2}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_remove_primary}
    Page Alert Message    Primary Diagnosis Removed.
    Scroll And Click Element Modal    ${tracker_close_btn}

Verify Additional ICD10 Code List Contains Only One Value
    [Documentation]    PaMan_TC156    PaMan_TC159    PaMan_TC160
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    ${tracker_additional_ICD10_default}    Get Text    ${tracker_additional_ICD10_default}
    Should Be Equal    ${tracker_additional_ICD10_default}    No Additional ICD10 Codes Added
    Choose Primary ICD10 Code    ${icd10_code}    Additional
    ${additional_ICD10_value}    SeleniumLibrary.Get Element Count    ${tracker_additional_ICD10_list}//div//div
    Should Be True    ${additional_ICD10_value} > 1
    ${remove_elements}=    Get WebElements    ${tracker_remove_additional}
    FOR    ${remove}    IN    @{remove_elements}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove}
        Page Alert Message    Additional Diagnosis Removed.
    END
    Scroll And Click Element Modal    ${tracker_close_btn}

Verify That Show Empty Values Checkbox Shows Correct Data
    [Documentation]    PaMan_TC161
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=Verbal Order
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
    Open Lab Tracker Row
    Input All Fields In Attribute Modal    btn=${attribute_add_btn}    alert=Lab Tracker Attribute Added
    Show Empty Value In Lab Tracker Row

Add Attribute SuccessFully With All Valid Fields
    [Documentation]    PaMan_TC162    PaMan_TC163
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${EMPTY}
    Input All Fields In Attribute Modal    btn=${attribute_add_btn}    alert=Lab Tracker Attribute Added

Update Attribute SuccessFully With All Valid Fields
    [Documentation]    PaMan_TC164
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    # Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${EMPTY}
    Input Lab Descirption Lab Tracker Modal    ACTH, Plasma    ${EMPTY}
    Input All Fields In Attribute Modal    btn=${attribute_add_btn}    alert=Lab Tracker Attribute Added
    ${attribute_edit_btn}    Replace Variables    ${attribute_edit_btn}
    Input All Fields In Attribute Modal    btn=${attribute_edit_btn}    alert=Lab Tracker Attribute Updated

Verify That Response Type Select Show Correct Fomat And Data
    [Documentation]    PaMan_TC165
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${EMPTY}
    Scroll And Click Element Modal    ${attribute_add_btn}
    Wait Until Element Is Visible    ${attribute_title}    30s
    ${attribute_select_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${attribute_response_type}
    ${expected_list}    Create List    - Select -    Range    String    Selection
    Lists Should Be Equal    ${attribute_select_list}    ${expected_list}
    Scroll And Click Element Modal    ${attribute_close_btn}

Verify Status Is ABNORMAL When Result Is Out Of Normal Range
    [Documentation]    PaMan_TC166
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
    Input Out Of Normal Range Value
    Check Value Of Stautus Lab Tracker Modal

# Verify That Critical Lab Component Results Table Show Correct Fomat And Data
#     [Documentation]    PaMan_TC168
# 	[Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
#     Input Out Of Normal Range Value
#     ${tracker_critical_table}    Replace Variables    ${tracker_critical_table}
#     Wait Until Element Is Visible    ${tracker_critical_table}    30s

Labs Related To Provider Orders Table Displays All The Labs Of The PO
    [Documentation]    PaMan_TC169    PaMan_TC170    PaMan_TC171    PaMan_TC172    PaMan_TC173
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Assign Multiple Labs For Medication    lab_num=2    drug_arg=${treatment_txt}
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    Check Labs Related To Provider Orders Table Displays All The Labs Of The PO    PO_num=${PO_number}
    Verify Blank Information Lab Is Removed When The Lab Is Unassigned From PO
    Verify Updated Information Lab Is Removed When The Lab Is Unassigned From PO
    
Verify Frequency Fields Show Correct Data According To Protocol Management
    [Documentation]    PaMan_TC144
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${True}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${PatientData.drug_PO1}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${tracker_frequency_value}    ${TempData.protocol_frequency_value}    equal_status=${True}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${tracker_frequency_select}    ${TempData.protocol_frequency_select}    equal_status=${True}

Verify Frequency Fields Show Correct Data According To PO Frequency
    [Documentation]    PaMan_TC145    PaMan_TC147
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    Select Frequency Lab In PO
    Check Changed Value Frequency Lab Tracker Modal    ${treatment_txt}    ${PO_lab_frequency_value_txt}    ${PO_lab_frequency_select_txt}
    Reload Page
    Check Frequency Value With PO Protocol
    Check Frequency Value With Protocol Management    ${treatment_txt}    ${TempData.tracker_frequency_value}    ${TempData.tracker_frequency_select}    ${False}
    
Verify Frequency Fields Show Correct Data According To Patient Protocol Frequency
    [Documentation]    PaMan_TC146    PaMan_TC147
	[Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_lab1}    assigned_lab_status=${True}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy2}
    Select Frequency Lab In Patient Protocol
    Check Changed Value Frequency Lab Tracker Modal    ${PatientData.drug_lab1}    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_select_txt}
    Reload Page
    Check Frequency Value With Patient Protocol    ${TempData.tracker_frequency_value}    ${TempData.tracker_frequency_select}    ${False}
    Check Frequency Value With Protocol Management    ${PatientData.drug_lab1}    ${TempData.tracker_frequency_value}    ${TempData.tracker_frequency_select}    ${False}

Create New Lab Tracker When Input the Same Description of Previous Lab Tracker
    [Documentation]    PaMan_TC174
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
    FOR    ${loop}    IN RANGE    2
        Navigate to Patient by Generated MRN
        Open Lab Tracker Tab
        Create Fake Data List
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
        Get DateTime In Lab Tracker
        Input All Fields In Lab Tracker Modal
        ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
        ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
        ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
        ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
        Set Test Variable    ${file_num}    ${Fake_dict.num_rand}
        ${tracker_lab_txt}    Replace Variables    ${tracker_ledger_row}
        Open Lab Tracker Ledger
        Wait Until Element Is Visible    ${tracker_lab_txt}    30s
    END

Create New Lab Tracker Is Visible When Selecting The General Descirption
    [Documentation]    PaMan_TC175
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Set Test Variable    ${treatment_txt1}   ${treatment_txt}
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt1}    assigned_lab_status=${True}
    Get Treatment Drug For PO
    Set Test Variable    ${treatment_txt2}   ${treatment_txt}
    Select Lab Descirption By Searching    drug_arg=${treatment_txt2}    assign_lab_txt=${assign_lab_txt}    assigned_lab_status=${False}
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${treatment_txt1}    PO_dosage_arg=${Fake_dict.demical_2d}
    Set Test Variable    ${PO_num1}    ${PO_number}
    Create Fake Data List
    Create New PO    med_arg=${treatment_txt2}    PO_dosage_arg=${Fake_dict.demical_2d}
    Set Test Variable    ${PO_num2}    ${PO_number}
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
    Set Test Variable    ${PO_number}    ${PO_num1}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${False}
    Set Test Variable    ${PO_number}    ${PO_num2}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${False}

Create New Lab Tracker Is Visible When Selecting The Medication Specific Descirption
    [Documentation]    PaMan_TC176
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Set Test Variable    ${treatment_txt1}   ${treatment_txt}
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt1}    assigned_lab_status=${True}
    Get Treatment Drug For PO
    Set Test Variable    ${treatment_txt2}   ${treatment_txt}
    Select Lab Descirption By Searching    drug_arg=${treatment_txt2}    assign_lab_txt=${assign_lab_txt}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt1}    PO_dosage_arg=${Fake_dict.demical_2d}
    Set Test Variable    ${PO_num1}    ${PO_number}
    Create Fake Data List
    Create New PO    med_arg=${treatment_txt2}    PO_dosage_arg=${Fake_dict.demical_2d}
    Set Test Variable    ${PO_num2}    ${PO_number}
    ${drug_list}    Create List    ${treatment_txt1}    ${treatment_txt2}
    FOR    ${drug_element}    IN    @{drug_list}
        Create Fake Data List
        Navigate to Patient by Generated MRN
        Open Lab Tracker Tab
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
        Get DateTime In Lab Tracker
        Input All Fields In Lab Tracker Modal
        ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
        ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
        ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
        ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
        Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_description}
        Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${drug_element}
        Scroll And Click Element Modal    ${tracker_save_btn}
        Page Alert Message    Lab Tracker Created
    END
    Set Test Variable    ${PO_number}    ${PO_num1}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${False}
    Set Test Variable    ${PO_number}    ${PO_num2}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${False}

Update Lab Tracker Successfully When Input All Valid Fields In Lab Order
    [Documentation]    PaMan_TC177
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    Select Lab In PO
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Update All Fields In Lab Order    btn_arg=${reorder_save_btn}    msg=Lab has been Reordered.
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${False}

Update Lab Tracker Successfully When Input Valid Required Fields In Lab Order
    [Documentation]    PaMan_TC178    PaMan_TC179    PaMan_TC190
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Set Test Variable    ${assign_lab_txt1}    ${assign_lab_txt}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    Select Lab In PO
    Set Test Variable    ${assign_lab_txt2}    ${assign_lab_txt}
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt1}    ${True}    ${True}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt2}    ${True}    ${True}
    ${tracker_PO_reorder_btn}    Replace Variables    ${tracker_PO_reorder_btn}
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    Input Date Time Lab Order
    ${reorder_frequency_value}    Replace Variables    ${reorder_frequency_value}
    Util.Select Random From List Regression    xpath_arg=${reorder_frequency_value}    var_name=reorder_frequency_value    dic=${PatientData}
    Sleep    1s
    ${reorder_frequency_select}    Replace Variables    ${reorder_frequency_select}
    Util.Select Random From List Regression    xpath_arg=${reorder_frequency_select}    var_name=reorder_frequency_select    dic=${PatientData}
    ${reorder_save_btn}    Replace Variables    ${reorder_save_btn}
    Scroll And Click Element Modal    ${reorder_save_btn}
    Page Alert Message    Lab has been Reordered.

# All Columns In Lab Tracker Related To Provider Order Table Show Data Correctly
#     [Documentation]    PaMan_TC180    PaMan_TC181    PaMan_TC182    PaMan_TC183    PaMan_TC184    PaMan_TC185    PaMan_TC186    PaMan_TC187    PaMan_TC188    PaMan_TC189    
#     [Tags]    Regression     Lab Tracker
#     ...  allure.label.owner: Hai Nguyen
#     Get Treatment Drug For PO
#     Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Check Value Expiration Date    ${tracker_frequency_value}    ${tracker_frequency_select}    ${tracker_resultdate_input}    ${tracker_expdate_input}
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message    Lab Tracker Created
#     Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
#     All Columns In Lab Tracker Related Show Correct Data

Verify All Fields Show Data And Type Correctly In Lab Order
    [Documentation]    PaMan_TC191    PaMan_TC192    PaMan_TC193    PaMan_TC194    PaMan_TC196    PaMan_TC203    PaMan_TC204    PaMan_TC205    PaMan_TC206    PaMan_TC207    PaMan_TC208    PaMan_TC209    PaMan_TC210    PaMan_TC211    PaMan_TC212
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    Select Lab In PO
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Verify The Reorder Lab Will Close When Clicking Cancel Button
    Verify Date Input In Lab Order
    Verify Checkbox In Lab Order
    Verify Select In Lab Order
    Verify Dianoses Input In Lab Order
    ${reorder_save_btn}    Replace Variables    ${reorder_save_btn}
    Scroll And Click Element Modal    ${reorder_save_btn}
    Page Alert Message    Lab has been Reordered.
    Verify Result Date And Expiration Date Display In Corresponding Column And Update Lab Tracker Popup
    Verify The Primary ICD 10 Code list And Additional ICD10 Codes Shows Correct Data
    ${tracker_close_btn}    Replace Variables    ${tracker_close_btn}
    Scroll And Click Element Modal    ${tracker_close_btn}

Verify That Frequency In Reorder Lab Will Be Populated According To PO When PO Update
    [Documentation]    PaMan_TC197    PaMan_TC199
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    Get Lab Frequency In PO
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Check Frequency Value In Reorder Lab    ${PO_lab_frequency_value_txt}    ${PO_lab_frequency_select_txt}    ${True}
    Change Frequency Lab Value In Provider Order
    Reload Page
    Open Lab Tracker Tab
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Check Frequency Value In Reorder Lab    ${TempData.PO_lab_frequency_value}    ${TempData.PO_lab_frequency_select}    ${True}

Verify That Frequency In Reorder Lab Will Be Populated According To Protocol Management
    [Documentation]    PaMan_TC198
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
    Get Lab Frequency In PO
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Check Frequency Value In Reorder Lab    ${PO_lab_frequency_value_txt}    ${PO_lab_frequency_select_txt}    ${True}
    Change Frequency Lab Value In Protocol Management
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Check Frequency Value In Reorder Lab    ${TempData.protocol_frequency_value}    ${TempData.protocol_frequency_select}    ${True}

Verify That Reorder Lab Frequency Will Be Populated According To Patient Protocol And Patient Protocol Or Protocol Management Will Not Be Affected When It Updates
    [Documentation]    PaMan_TC200    PaMan_TC201
    [Tags]    Regression     Lab Tracker
    ...  allure.label.owner: Hai Nguyen
    Get Treatment Drug For PO
    Select Lab Descirption In Lab View    drug_arg=${drug_lab2}    assigned_lab_status=${True}
    Create Fake Data List
    Navigate to Patient by Generated MRN
    Create New PO    med_arg=${drug_lab2}    PO_dosage_arg=${Fake_dict.demical_2d}
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Select Frequency Lab In Patient Protocol
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Check Frequency Value In Reorder Lab    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_select_txt}    ${True}
    ${reorder_cancel_btn}    Replace Variables    ${reorder_cancel_btn}
    Scroll And Click Element    ${reorder_cancel_btn}
    Update All Fields In Lab Order    btn_arg=${reorder_save_btn}    msg=Lab has been Reordered.
    Check Frequency Value With Patient Protocol    ${TempData.reorder_frequency_value}    ${TempData.reorder_frequency_select}    ${False}
    Check Frequency Value With Protocol Management    ${PatientData.drug_lab2}    ${TempData.reorder_frequency_value}    ${TempData.reorder_frequency_select}    ${False}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${referring_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${therapy1}    ${data_input}[therapy1]
    Set Suite Variable    ${therapy2}    ${data_input}[therapy2]
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    Set Suite Variable    ${drug_PO1}    ${data_input}[drug_PO1]
    Set Suite Variable    ${drug_PO2}    ${data_input}[drug_PO2]
    Set Suite Variable    ${drug_lab1}    ${data_input}[drug_lab1]
    Set Suite Variable    ${drug_lab2}    ${data_input}[drug_lab2]
    Set Suite Variable    ${lab_payer}    ${data_input}[lab_payer]
    Set Suite Variable    ${icd10_code}    ${data_input}[icd10_code]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    drug_PO=${drug_PO}    
    ...    drug_PO1=${drug_PO1}
    ...    referring_NPI_PO=${referring_NPI_PO}    
    ...    referto_provider_NPI_PO=${referto_provider_NPI_PO}
    ...    drug_PO2=${drug_PO2}    
    ...    drug_lab1=${drug_lab1}
    ...    drug_lab2=${drug_lab2}
    ...    therapy1=${therapy1}
    ...    therapy2=${therapy2}
    ...    lab_payer=${lab_payer}    
    ...    icd10_code=${icd10_code}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}