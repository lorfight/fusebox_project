*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Assessment Suite
Test Setup    Test Setup Assessment Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_018    patient    Admin

*** Test Cases ***
Verify All Template Assessments When Created
    [Documentation]    PaMan_TC220
    [Tags]    Regression    Assessment    report.label.owner: Nga Phan Hai Nguyen
    ${assessment_dict}    Create Assessment List    loops=2
    ${template_list}    Create List    ${assessment_dict.template_name_1}    ${assessment_dict.template_name_2}
    Sort List    ${template_list}
    Verify Created Assessment List    ${template_list}

Verify Template Is Created Unsuccessfuly
    [Documentation]    PaMan_TC219    PaMan_TC225    
	[Tags]    Regression    Assessments    report.label.owner: Nga Phan Hai Nguyen
    Check Default Value Of Patient Assessments Dropdown
    Verify That New Template Is Created Unsuccessfuly

Verify Create And Edit Template Asessment Successfuly
    [Documentation]    PaMan_TC221    PaMan_TC222    PaMan_TC223    PaMan_TC224    PaMan_TC226    PaMan_TC227    PaMan_TC228
    ...    PaMan_TC229    PaMan_TC230    PaMan_TC231    PaMan_TC232    PaMan_TC233    PaMan_TC234    PaMan_TC235
	[Tags]    Regression    Assessment    report.label.owner: Nga Phan Hai Nguyen
    ${template_name}    Generate Meaningful Alpha Template Name
    Verify That New Template Is Created Successfuly    ${template_name}
    Check System Shows "New Assessment" Or "Edit Selected Template    ${template_name}
    ${template_name}    Generate Meaningful Alpha Template Name
    Verify Edit Selected Template Button    ${template_name}
    Verify The System Navigates The User Into The "New Assessment"    ${template_name}
    Verify That View Information Assessment Detail Successful    ${template_name}
    Verify Deleted SuccessFully 

*** Keywords ***
Suite Setup Assessment Suite
    ${data_input}    Get Data
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

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Assessment Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Assessment Tab
    Delete All Assessment Template From Dropdown
