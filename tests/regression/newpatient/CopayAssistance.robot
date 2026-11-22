*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Copay Assisstance Suite
Test Setup    Test Setup Copay Assisstance Suite
Test Teardown    Test Teardown Copay Assisstance
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_006    patient    Admin

*** Test Cases ***
Verify All Fields After Click On Add Co-Pay Assistance Button
    [Documentation]    CAP-1    CAP-2
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    Verify All Input Fields Are Empty
    Verify All Select Fields Have Default Value
    Click Close Co-Pay Assisstance Button

Create And Update Co-Pay Assistance SuccessFully With All Fields
    [Documentation]    CAP-4    CAP-8    CAP-16    CAP-18    CAP-30    CAP-37    CAP-41    CAP-43    CAP-45    
    ...    CAP-60    CAP-61    CAP-64    CAP-67    CAP-68    CAP-69    CAP-70    CAP-71    CAP-72    CAP-117
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    Upsert Co-Pay Assistance  
        ...    medication_arg=${medication_txt}    
        ...    program_arg=${Program_dict.program_name}
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Co-Pay Assistance Added
    Click Edit Co-Pay Assisstance Button    medication_arg=${medication_txt} 
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${update_copay_assisstance_dict}    Upsert Co-Pay Assistance  
        ...    medication_arg=missing  
        ...    program_arg=missing
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${update_copay_assistance_btn}
        ...    msg=Co-Pay Assistance Updated
    &{expected_compare_data}    Evaluate    {**$Program_dict, **$update_copay_assisstance_dict}
    Verify Co-Pay Assistance Row With Valid Info    
        ...    medication_arg=${medication_txt} 
        ...    compare_value_list=${expected_compare_data} 

Create Co-Pay Assistance UnsuccessFully With Empty Medication
    [Documentation]    CAP-6
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    Upsert Co-Pay Assistance  
        ...    medication_arg=missing 
        ...    program_arg=${Program_dict.program_name}
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Procedure or function 'usp_CoPayAssistance_DuplicateExists' expects parameter '@ProprietaryName', which was not supplied.

Create Co-Pay Assisstance Unsuccessfully With Existing Medication Previously Created
    [Documentation]    CAP-5    CAP-7
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab    
    Open Co-Pay Assistance Modal
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    Click Close Co-Pay Assisstance Button
    FOR    ${i}    IN RANGE    1    3
        Open Co-Pay Assistance Modal
        IF    ${i} == 1
            ${alert_msg}    Set Variable    Co-Pay Assistance Added
        ELSE
            ${alert_msg}    Set Variable    A Co-Pay Assistance for this Patient and this Medication already exists. Duplicates are not allowed.
        END
        Upsert Co-Pay Assistance  
            ...    medication_arg=${medication_txt} 
            ...    program_arg=${Program_dict.program_name}
            ...    identification_number_arg=${Fake_dict['num_rand']}    
            ...    group_number_arg=${Fake_dict['num_rand']}    
            ...    amount_arg=${Fake_dict['demical_3d']}    
            ...    responsibility_arg=${Fake_dict['demical_3d']}    
            ...    startdate_arg=${startdate}    
            ...    enddate_arg=${enddate}    
            ...    card_number_arg=${Fake_dict['credit_num']}    
            ...    cvv_arg=${Fake_dict['demical_3d']}    
            ...    billing_zip_arg=${Fake_dict['num_rand']}    
            ...    exp_date_arg=${Fake_dict['exp_date']}
            ...    utc=${data_input}[utc]
            ...    btn_arg=${add_copay_assistance_btn}
            ...    msg=${alert_msg}
    END

Create Co-Pay Assistance UnsuccessFully With Empty Program
    [Documentation]    CAP-9
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    Upsert Co-Pay Assistance  
        ...    medication_arg=${medication_txt} 
        ...    program_arg=missing
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Co-Pay Program is required.

Verify Fields Are Retrieved Data From Selected Program
    [Documentation]    CAP-10    CAP-11    CAP-12    CAP-13    CAP-14
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${Program_dict}    Create Program
    Select Program    ${Program_dict.program_name}
    ${compare_value_list}    Create List
        ...    ${Program_dict.phone_enrollment}    
        ...    ${Program_dict.fax_enrollment}    
        ...    ${Program_dict.cap_website}    
        ...    ${Program_dict.phone_claim}    
        ...    ${Program_dict.fax_claim}   
    Verify Fields Of Program Are Retrieved    ${compare_value_list}

Verify CAP Status Have Available Value And User Can Click On It
    [Documentation]    CAP-17
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    Verify CAP Status Select Have Available Value

Perform Actions With Required Fields In Co-Pay Assistance Modal
    [Documentation]    CAP-19    CAP-20    CAP-21    CAP-22    CAP-23    CAP-24    CAP-25    CAP-26    CAP-27    CAP-28    CAP-29    
                ...    CAP-31    CAP-32    CAP-33    CAP-34    CAP-35    CAP-36    CAP-38    CAP-39    CAP-40    CAP-42    CAP-46
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    ${CopayAssisstance_dict}    Create Copay Assisstance Dictionary
    Select Medication    ${medication_txt}
    Select Program    ${Program_dict.program_name}
    Select CAP Specialist    ${CopayAssisstance_dict}
    Select CAP Status    ${CopayAssisstance_dict}
    Perform Actions With CAP Identification Number Field
    Perform Actions With CAP Group Number Field
    Perform Actions With CAP Approved $ Amount Field
    Perform Actions With Patient Copay $ Responsibility Field
    Perform Actions With Approval Start Date Field    ${startdate}
    Perform Actions With Approval End Date Field    ${enddate}
    Perform Actions With CAP Credit / Debit Card Number Field
    Perform Actions With CVV Field
    Perform Actions With Billing ZIP
    Perform Actions With Card Exp Date Field    ${Fake_dict['exp_date']}
    Click Add Co-Pay Assisstance Button    Co-Pay Assistance Added

Update Co-Pay Assisstance Unsuccessfully When Empty Program
    [Documentation]    CAP-58    CAP-59    CAP-62    CAP-63    CAP-65    CAP-66
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    Upsert Co-Pay Assistance  
        ...    medication_arg=${medication_txt}    
        ...    program_arg=${Program_dict.program_name}
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Co-Pay Assistance Added
    
    ${method_list}    Create List
        ...    Select Program
        ...    Input CAP Identification Number    
        ...    Input CAP Group Number
        ...    Input Approval Start Date
        ...    Input Approval End Date
    
    ${error_list}    Create List
        ...    Co-Pay Program is required.
        ...    CAP Identification Number cannot be empty.
        ...    CAP Group Number cannot be empty.
        ...    Approval Start Date cannot be empty.
        ...    Approval End Date cannot be empty.

    FOR    ${method}    ${error}    IN ZIP    ${method_list}    ${error_list}
        Click Edit Co-Pay Assisstance Button    medication_arg=${medication_txt}
        IF    "${method}" == "Select Program"
            Run Keyword    ${method}    -- Select A Program --
        ELSE    
            Run Keyword    ${method}    ${EMPTY}
        END
        Click Update Co-Pay Assisstance Button    ${error}
        Click Close Co-Pay Assisstance Button
    END

Verify Payment History Table Is Impacted Appointment
    [Documentation]    CAP-73    CAP-74    CAP-75    CAP-76
    [Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    Upsert Co-Pay Assistance  
        ...    medication_arg=${data_input}[medication_first] 
        ...    program_arg=${Program_dict.program_name}
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Co-Pay Assistance Added
    Click Edit Co-Pay Assisstance Button    medication_arg=${data_input}[medication_first] 
    Check No Payment History Title In Paymetn History Table Form
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    Schedule Appointment Has No Office Visit With Past Date    
        ...    location_arg=${data_input}[location]    
        ...    patient_arg=${data_input}[patient_mrn]      
        ...    therapy_arg=${data_input}[therapy]      
        ...    dose_arg=10
    Reload Page
    Open Appointments Tab
    ${status_apt_txt}    Get Status APT    ${appointment_dict.apt_date}
    ${starttime_txt}    Get Start Time APT    ${appointment_dict.apt_date}
    ${dosage_medication_txt}    Get Dosage Medication    ${appointment_dict.apt_date}
    Open Co-Pay Assistance Tab
    Click Edit Co-Pay Assisstance Button    medication_arg=${data_input}[medication_first] 
    Verify Historical Data Against Created Appointments In Paymetn History Table Form    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    apt_starttime=${starttime_txt}    
        ...    apt_status=${status_apt_txt}    
        ...    apt_med=${dosage_medication_txt}

Verify Open Patient Document Center Popup And Upload Co-Pay Document Popup With Created Co-pay Assisstance
    [Documentation]    CAP-48    CAP-49    CAP-51    CAP-55    CAP-77    CAP-78    CAP-80    CAP-84
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    Click Document Co-Pay Assisstance Button
    Documents.Verify Document Popup Shows Remain Fields
    SeleniumLibrary.Element Text Should Be    ${copay_document_patient}    Patient: ${PatientCreate.last_name}, ${PatientCreate.first_name} ${PatientCreate.middle_name}
    SeleniumLibrary.Element Text Should Be    ${copay_document_dob}    DOB: ${PatientCreate.dob}
    SeleniumLibrary.Element Text Should Be    ${copay_document_mrn}    MRN: ${PatientCreate.mrn}
    Click Close Document Co-Pay Assisstance Button
    Common.Scroll And Click Element    ${copay_upload_document_btn}
    Page Alert Message    Please select a Medication.
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    Select Medication    ${medication_txt}
    Click Upload Document Co-Pay Assisstance Button
    Verify Input Long Characters Into Field    
        ...    input_field=${document_description_input}    
        ...    character_lenght=150    
        ...    equal_status=equal
    Verify Input Long Characters Into Field    
        ...    input_field=${document_description_input}    
        ...    character_lenght=151    
        ...    equal_status=not equal
    Click Upload Co-Pay Document Button    alert_msg=Please select a Document.
    Common.Close Ultra SubModal Popup
    
Create Co-Pay Assistance Program Successfully With Maximum Characters
    [Documentation]    CAP-87    CAP-88    CAP-89    CAP-93    CAP-96    CAP-97    CAP-99    CAP-102    CAP-105    CAP-106
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    Open Create Copay Assisstance Program
    ${255_characters}   Generate Random String   255    [LETTERS] [NUMBERS]
    ${20_number_characters}   Generate Random String   20    [NUMBERS]
    Input Program Name    program_name_arg=${255_characters}
    Input Program Phone (Enrollment)    phone_arg=${20_number_characters}
    Input Program Fax (Enrollment)    fax_arg=${20_number_characters}
    Input Program CAP Website / Online Form Link    cap_arg=${255_characters}
    Input Program Phone (Claims)    phone_claim_arg=${20_number_characters}
    Input Program Fax (Claims)    fax_claim_arg=${20_number_characters}
    Click Add Program Button    Co-Pay Assistance Program added
    Select Program    ${255_characters}
    ${option_selected}    Get Selected List Label    ${copay_program_select}
    Should Be Equal    ${option_selected}    ${255_characters}
    Click Close Co-Pay Assisstance Button

Perform Actions With All Fields In Create Co-Pay Assistance Program Modal
    [Documentation]    CAP-90    CAP-92    CAP-94    CAP-96    CAP-98    CAP-100    CAP-101    CAP-103    CAP-104
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    Open Create Copay Assisstance Program
    Perform Actions With Program Name Field    status=create
    Perform Actions With Program Phone (Enrollment) Field    status=create
    Perform Actions With Program Fax (Enrollment) Field
    Perform Actions With Program CAP Website / Online Form Link Field    status=create
    Perform Actions With Program Phone (Claims) Field    status=create
    Perform Actions With Program Fax (Claims) Field

Perform Actions With All Fields In Update Co-Pay Assistance Program Modal
    [Documentation]    CAP-107    CAP-108    CAP-110    CAP-111    CAP-112    CAP-113    CAP-114
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${Program_dict}    Create Program
    Select Program    ${Program_dict.program_name}
    Click Edit Program Button
    Perform Actions With Program Name Field    status=update
    Perform Actions With Program Phone (Enrollment) Field    status=update
    Perform Actions With Program Fax (Enrollment) Field
    Perform Actions With Program CAP Website / Online Form Link Field    status=update
    Perform Actions With Program Phone (Claims) Field    status=update
    Perform Actions With Program Fax (Claims) Field
    Click Update Program Button    Co-Pay Assistance Program updated

Verify Create And Update Co-Pay Assistance Program Unsuccessfully If Existing Name Previously Created
    [Documentation]    CAP-91    CAP-109
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${first_program_dict}    Create Program
    ${second_program_dict}    Create Program
    ${Fake_dict}    Generate Fake Data    phone    sentence    
    ${program_name_dict}    Create List    ${first_program_dict.program_name}    ${second_program_dict.program_name}
    FOR    ${program_name}    IN    @{program_name_dict}
        IF    "${program_name}" == "${first_program_dict.program_name}"
            Open Create Copay Assisstance Program
        ELSE IF    "${program_name}" == "${first_program_dict.program_name}"
            Select Program    ${second_program_dict.program_name}
            Click Edit Program Button
        END
        Input Program Name    program_name_arg=${program_name}
        Input Program Phone (Enrollment)    phone_arg=${Fake_dict['phone']}
        Input Program CAP Website / Online Form Link    cap_arg=${Fake_dict['sentence']}
        Input Program Phone (Claims)    phone_claim_arg=${Fake_dict['phone']}
        Click Add Program Button    Program Name already exists. Duplicates are not allowed.
    END

Verify Delete Co-Pay Assistance Program Successfully
    [Documentation]    CAP-115    CAP-116
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    Open Co-Pay Assistance Tab
    Open Co-Pay Assistance Modal
    ${first_program_dict}    Create Program
    ${second_program_dict}    Create Program
    Select Program    ${first_program_dict.program_name}
    Click Edit Program Button
    Click Delete Program Button
    ${copay_program_option}    Set Variable    //select[@id='SelectedCoPayAssistanceProgramId']//following::option[contains(text(),'${first_program_dict.program_name}')]
    ${copay_program_option_txt}    Get Text    ${copay_program_option}
    Should Contain    ${copay_program_option_txt}    [REMOVED]
    ${Fake_dict}    Generate Fake Data    full_name
    Select Program    ${second_program_dict.program_name}
    Click Edit Program Button
    Input Program Name    program_name_arg=${Fake_dict['full_name']}
    Click Update Program Button    Co-Pay Assistance Program updated
    ${program_name_list}    Get Selected List Labels    ${copay_program_select}
    Should Not Contain    ${program_name_list}    ${first_program_dict}

Verify PA's Medication Is Displayed In Co-pay Assisstance With No Information
    [Documentation]    CAP-3    CAP-118
	[Tags]    Regression     Co-pay Assistance    report.label.owner: Hai Nguyen
    ProviderOrders.Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[medication_second]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[npi] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    Open Co-Pay Assistance Tab
    Click Add Co-pay Assistance Button With PA's Medication    medication_arg=${data_input}[medication_second] 
    ${medication_txt}    Get Option In Medication Select    ${medication_list}
    ${Fake_dict}    ${startdate}    ${enddate}    Prepare Data For Co-Pay Assistance
    ${Program_dict}    Create Program
    ${CopayAssisstance_dict}    Upsert Co-Pay Assistance  
        ...    medication_arg=missing  
        ...    program_arg=${Program_dict.program_name}
        ...    identification_number_arg=${Fake_dict['num_rand']}    
        ...    group_number_arg=${Fake_dict['num_rand']}    
        ...    amount_arg=${Fake_dict['demical_3d']}    
        ...    responsibility_arg=${Fake_dict['demical_3d']}    
        ...    startdate_arg=${startdate}    
        ...    enddate_arg=${enddate}    
        ...    card_number_arg=${Fake_dict['credit_num']}    
        ...    cvv_arg=${Fake_dict['demical_3d']}    
        ...    billing_zip_arg=${Fake_dict['num_rand']}    
        ...    exp_date_arg=${Fake_dict['exp_date']}
        ...    utc=${data_input}[utc]
        ...    btn_arg=${add_copay_assistance_btn}
        ...    msg=Co-Pay Assistance Added
    Open Prior Authorizations Tab
    ${pa_medication_column}    Set Variable    //a[contains(text(),'${PatientCreate.first_name} ${PatientCreate.last_name}')]//following::td[contains(.,'${data_input}[medication_second]')][1]
    Wait Until Element Is Visible    ${pa_medication_column}    30s
    ${pa_medication_txt}    Get Text    ${pa_medication_column}
    Should Contain    ${pa_medication_txt}    Co-Pay: ${Program_dict.program_name} (${CopayAssisstance_dict.copay_cap_status})
 
*** Keywords ***
Suite Setup Copay Assisstance Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${original_window}    Get Window Handles
    ${medication_list}    Create List    ${data_input}[medication_first]    ${data_input}[medication_second]
    Set Suite Variable    ${medication_list}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Copay Assisstance Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]

Test Teardown Copay Assisstance
    Delete Co-Pay Assistance Program
    Common.Return Previous Window    window_arg=${update_patient_window}