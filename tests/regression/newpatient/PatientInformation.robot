*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Information Suite
Test Setup    Patient.Test Setup Patient Management    
                ...    title_arg=Patients
                ...    location_arg=${data_input}[location]    
                ...    mrn_arg=${data_input}[patient_mrn]
Test Teardown    Common.Return Previous Window    window_arg=${patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_001    patient    Admin

*** Test Cases ***
Verify Patient
	[Documentation]    PaMan_TC106
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    Filter Patient In Patient Page    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]
    Select Patient From List    mrn_arg=${data_input}[patient_mrn]
    Verify All Info Of Patient    ${PatientUpdate}

Remove All Data Patient
    [Documentation]    PaMan_TC113    PaMan_TC115    PaMan_TC117
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    Filter Patient In Patient Page    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]
    Select Patient From List    mrn_arg=${data_input}[patient_mrn]
    Remove All Value Field In Update Patient
    Verify Error Message Visible
    Click Cancel Update Patient Button

Verify Popup Is Visible When Deleting Patient
    [Documentation]    PaMan_TC119
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    Filter Patient In Patient Page    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]
    Select Patient From List    mrn_arg=${data_input}[patient_mrn]
    Click Delete Patient Button
    Handle Alert    DISMISS
    Click Cancel Update Patient Button

Inactive Patient
	[Documentation]    PaMan_TC118
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    Filter Patient In Patient Page    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]
    Select Patient From List    mrn_arg=${data_input}[patient_mrn]
    PatientInformation.Inactived Patient
    PatientList.Select Location In Patient List    location_arg=${data_input}[location]
    PatientList.Input MRN In Patient List    ${data_input}[patient_mrn]
    PatientList.Search Inactive Patient With Advanced Search
    PatientList.Select Patient From List    mrn_arg=${data_input}[patient_mrn]
    PatientInformation.Actived Patient

Create Patient Unsuccessfully When Not Input All Value
    [Documentation]    PaMan_TC97
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    PatientList.Select Location In Patient List    location_arg=${data_input}[location]
    PatientList.Go To Create New Patient Page
    Clear Remain Fields
    Click Save Patient Button
    Verify Error Message Visible
    Click Cancel Update Patient Button

Create Patient Unsuccessfully With Empty Required Field
    [Documentation]    PaMan_TC98    PaMan_TC99    PaMan_TC100    PaMan_TC107    PaMan_TC109
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    mrn    dob
    ${error_list}    Create List    
        ...    The First Name field is required.
        ...    The Last Name field is required.
        ...    The Medical Record # field is required.
        ...    The Date Of Birth field is required.
        ...    The Gender field is required.

    FOR    ${error}    IN ZIP    ${error_list}
        PatientList.Select Location In Patient List    location_arg=${data_input}[location]
        PatientList.Go To Create New Patient Page
        Clear Remain Fields
        Run Keyword If    "${error}" != "The First Name field is required."    Input First Name In Patient Information    first_name_arg=${Fake_dict['first_name']} 
        Run Keyword If    "${error}" != "The Last Name field is required."    Input Last Name In Patient Information    last_name_arg=${Fake_dict['last_name']} 
        Run Keyword If    "${error}" != "The Medical Record # field is required."    Input MRN In Patient Information    mrn_arg=${Fake_dict['mrn']} 
        Run Keyword If    "${error}" != "The Date Of Birth field is required."    Input DOB In Patient Information    dob_arg=${Fake_dict['dob']} 
        Run Keyword If    "${error}" != "The Gender field is required."    Select Gender In Patient Information    dict_arg=${PatientCreate}
        Click Save Patient Button
        Wait Until Page Contains    ${error}
        Click Cancel Update Patient Button
    END

Verify Gender Field Show Value Correctly
    [Documentation]    PaMan_TC108
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    PatientList.Select Location In Patient List    location_arg=${data_input}[location]
    PatientList.Go To Create New Patient Page
    ${gender_list}    Get List Items    ${gender_select}
    Should Contain    ${gender_list}    Male
    Should Contain    ${gender_list}    Female
    Should Contain    ${gender_list}    Other
    Click Cancel Update Patient Button

Create Patient With Already MRN
    [Documentation]    PaMan_TC101    PaMan_TC102
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    PatientList.Select Location In Patient List    location_arg=${data_input}[location]
    PatientList.Go To Create New Patient Page
    ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
    Input MRN Already Exists And Input DOB Field    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    dob_arg=${Fake_dict['dob']}    
        ...    account_name_arg=${data_input}[account_name_first]
    Input MRN Already Exists And Input Required Field
        ...    first_name_arg=${Fake_dict['first_name']}   
        ...    last_name_arg=${Fake_dict['last_name']} 
        ...    mrn_arg=${data_input}[patient_mrn]
        ...    dob_arg=${Fake_dict['dob']} 
        ...    gender_arg=random
        ...    dict_arg=${PatientCreate}
        ...    account_name_arg=${data_input}[account_name_first]
    Click Cancel Update Patient Button

Select Default Contact Field With Blank Corresponding Field
    [Documentation]    PaMan_TC110    PaMan_TC111    PaMan_TC112
	[Tags]    Regression    Patient Infromation    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    mrn    dob   
    ${method_list}    Create List    
        ...    Select Home Phone And Personal/Home Phone Field Is Blank
        ...    Select Cellphone And CellPhone Field Is Blank
        ...    Select Email And Email Field Is Blank
    ${error_list}    Create List    
        ...    The Phone field is required
        ...    The Cellphone field is required
        ...    The Email field is required
    FOR    ${method}    ${error}    IN ZIP    ${method_list}    ${error_list}
        PatientList.Select Location In Patient List    location_arg=${data_input}[location]
        PatientList.Go To Create New Patient Page
        PatientInformation.Input Required Fields In Patient Information    
            ...    first_name_arg=${Fake_dict['first_name']}   
            ...    last_name_arg=${Fake_dict['last_name']} 
            ...    mrn_arg=${Fake_dict['mrn']} 
            ...    dob_arg=${Fake_dict['dob']} 
            ...    gender_arg=random
            ...    dict_arg=${PatientCreate}
        Run Keyword If    "${error}" == "The Phone field is required"    Run Keyword    ${method}
        Run Keyword If    "${error}" == "The Cellphone field is required"    Run Keyword    ${method}
        Run Keyword If    "${error}" == "The Email field is required"    Run Keyword    ${method}
        Click Save Patient Button
        Wait Until Page Contains    ${error}
        Click Cancel Update Patient Button
    END

*** Keywords ***
Suite Setup Patient Information Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With All Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN      
        ...    mrn_arg=${PatientCreate.mrn}
        ...    location_arg=${data_input}[location]
    ${PatientUpdate}    UpdateAPatient.Update All Info Patient    # PaMan_TC114    PaMan_TC116    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    refering_provider_arg=${data_input}[refering_provider]
    ${original_window}    Get Window Handles

    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${PatientUpdate}
    Set Suite Variable    ${patient_window}    ${original_window}[0]