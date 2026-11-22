*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Payer Information Suite
Test Setup    Test Setup Payer Information Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_002    patient    Admin

*** Test Cases ***
Create Payer Info Without Select A Plan
    [Documentation]    PI-1    PI-2    PI-3
	[Tags]    Regression    Payer Infromation    report.label.owner: Hai Nguyen
    Add Payer
    Click Create Payer Button
    Common.Page Alert Message    A selected plan is required!
    Click Close Payer Button

Create Payer In Medical Payer Plan With Empty Field
    [Documentation]    PI-4    PI-5
	[Tags]    Regression    Payer Infromation     report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    num_rand
    ${error_list}    Create List
        ...    A Certificate # is required!
        ...    Insurance Plan successfully Assigned to the Patient.
    FOR    ${error}    IN    @{error_list}
        Add Payer
        Select Plan
        Click Medical Payer Plan Type
        Run Keyword If    "${error}" != "A Certificate # is required!"    PayerInformation.Input Subscriber Number In Medical Payer Plan    ${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    PayerInformation.Input Group Number In Medical Payer Plan    ${Fake_dict['num_rand']}
        Select Plan Date In Payer Plan
        Click Create Payer Button
        Common.Page Alert Message    ${error}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    Click Close Payer Button
    END

Create Payer In Pharmacy Payer Plan With Empty Field
    [Documentation]    PI-6    PI-7    PI-8    PI-9
	[Tags]    Regression    Payer Infromation      report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    num_rand
    ${error_list}    Create List
        ...    A Certificate # is required!
        ...    A Group # is required!
        ...    A BIN # is required!
        ...    Insurance Plan successfully Assigned to the Patient.

    FOR    ${error}    IN    @{error_list}
        Add Payer
        Select Plan
        Click Pharmacy Payer Plan Type
        Run Keyword If    "${error}" != "A Certificate # is required!"    Input Subscriber Number In Pharmacy Payer Plan    ${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "A Group # is required!"    Input Group Number In Pharmacy Payer Plan    ${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "A BIN # is required!"    Input Rx BIN Number In Pharmacy Payer Plan    ${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    Input Rx PCN Number In Pharmacy Payer Plan    ${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    Input Rx Group In Pharmacy Payer Plan    ${Fake_dict['num_rand']}
        Select Plan Date In Payer Plan
        Click Create Payer Button
        Common.Page Alert Message    ${error}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    Click Close Payer Button
    END

Plan Effective Date Plan Expiration Date Are Empty In Payer Plan
    [Documentation]    PI-10    PI-11
	[Tags]    Regression    Payer Infromation         report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    num_rand 
    ${effective_date}    Get Current Date    result_format=%m/%d/%Y
    ${expiration_date}    Add Time To Date    ${effective_date}    30 days    result_format=%m/%d/%Y     date_format=%m/%d/%Y
    ${error_list}    Create List
        ...    An effective date is required!
        ...    Insurance Plan successfully Assigned to the Patient.
    FOR    ${error}    IN    @{error_list}
        Add Payer
        Select Plan
        Fill In Medical Information    
            ...    subscriber_number_arg=${Fake_dict['num_rand']}    
            ...    group_number_arg=${Fake_dict['num_rand']}
        Run Keyword If    "${error}" != "An effective date is required!"    PayerInformation.Input Plan Effective Date    ${effective_date}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    PayerInformation.Input Plan Expiration Date    ${expiration_date}
        Click Create Payer Button
        Common.Page Alert Message    ${error}
        Run Keyword If    "${error}" != "Insurance Plan successfully Assigned to the Patient."    Click Close Payer Button
    END

Edit And Remove Medical Payer Plan
    [Documentation]    PI-12    PI-14
	[Tags]    Regression    Payer Infromation    report.label.owner: Hai Nguyen
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    ${UpdateMedical_dict}    Edit Medical Payer Plan    ${data_input}[utc]
    Remove Payer Plan    status=DISMISS

Edit And Remove Pharmacy Payer Plan
    [Documentation]    PI-12    PI-14
	[Tags]    Regression    Payer Infromation    report.label.owner: Hai Nguyen
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    ${UpdatePharmacy_dict}    Edit Pharmacy Payer Plan    ${data_input}[utc]
    Remove Payer Plan    status=DISMISS

Verify Patient Information In Changelog With A New Medical Payer Plan
    [Documentation]    30381-3
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    Verify Patient Information In Changelog    
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name}    
        ...    mrn_arg=${PatientCreate.mrn}    
        ...    dob_arg=${PatientCreate.dob}

Verify Patient Information In Changelog With A New Pharmacy Payer Plan
    [Documentation]    30381-3
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen    
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    Verify Patient Information In Changelog    
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name}    
        ...    mrn_arg=${PatientCreate.mrn}    
        ...    dob_arg=${PatientCreate.dob}

Verify Expand Or Collapse Functionality of Changelog Table With A New Medical Payer Plan
    [Documentation]    30381-4    30381-12
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    Verify Expand Or Collapse Changelog Table    status_arg=create
    ${UpdateMedical_dict}    Edit Medical Payer Plan    ${data_input}[utc]
    Verify Expand Or Collapse Changelog Table    status_arg=edit

Verify Expand Or Collapse Functionality of Changelog Table With A New Pharmacy Payer Plan
    [Documentation]    30381-4    30381-12
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    Verify Expand Or Collapse Changelog Table    status_arg=create
    ${UpdatePharmacy_dict}    Edit Pharmacy Payer Plan    ${data_input}[utc]
    Verify Expand Or Collapse Changelog Table    status_arg=edit

Verify Changes Are Listed In Chronological Order
    [Documentation]    30381-5
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${user_name_txt}    Common.Get User Name
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    FOR    ${i}    IN RANGE    1    4
        ${UpdateMedical_dict}    Edit Medical Payer Plan    ${data_input}[utc]
        Check Medical Plan In Changelog    ${CreateMedical_dict}    ${UpdateMedical_dict}    ${user_name_txt}
        Set Test Variable    ${CreateMedical_dict}    ${UpdateMedical_dict}
    END

Verify Changelog Table Sorting and Display With A New Medical Payer Plan
    [Documentation]    30381-6    30381-13
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    Check Message For Changelog Display    status_arg=create
    ${UpdateMedical_dict}    Edit Medical Payer Plan    ${data_input}[utc]
    Check Message For Changelog Display    status_arg=edit
    Remove Payer Plan    status=ACCEPT
    Check Message For Changelog Display    status_arg=remove

Verify Changelog Table Sorting and Display With A New Pharmacy Payer Plan
    [Documentation]    30381-6    30381-13
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen    
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    Check Message For Changelog Display    status_arg=create
    ${UpdatePharmacy_dict}    Edit Pharmacy Payer Plan    ${data_input}[utc]
    Check Message For Changelog Display    status_arg=edit
    Remove Payer Plan    status=ACCEPT
    Check Message For Changelog Display    status_arg=remove

Verify Changelog Table When Edit Medical Payer Plan
    [Documentation]    30381-7
	[Tags]    Regression    Payer Infromation    report.label.owner: Hai Nguyen
    ${user_name_txt}    Common.Get User Name
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    ${UpdateMedical_dict}    Edit Medical Payer Plan    ${data_input}[utc]
    Check Medical Plan In Changelog    ${CreateMedical_dict}    ${UpdateMedical_dict}    ${user_name_txt}
    
Verify Changelog Table When Edit Pharmacy Payer Plan
    [Documentation]    30381-8    30381-10
	[Tags]    Regression    Payer Infromation    report.label.owner: Hai Nguyen
    ${user_name_txt}    Common.Get User Name
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    ${UpdatePharmacy_dict}    Edit Pharmacy Payer Plan    ${data_input}[utc]
    Check Pharmacy Plan In Changelog    ${CreatePharmacy_dict}    ${UpdatePharmacy_dict}    ${user_name_txt}

Verify Changelog Table When Inactive Payer Plan
    [Documentation]    30381-9    30381-10
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${user_name_txt}    Common.Get User Name
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    ${date_zone}    ${date_zone_plus_1_minute}    Inactive Payer Plan    ${data_input}[utc]
    Set To Dictionary    ${CreateMedical_dict}    date_zone=${date_zone}    date_zone_plus_1_minute=${date_zone_plus_1_minute}
    Check Inactive In Changelog    ${CreateMedical_dict}    ${user_name_txt}

Verify Changelog Table When Update Without Data With A New Medical Payer Plan
    [Documentation]    30381-11
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreateMedical_dict}    Create A New Medical Payer Plan    ${data_input}[utc]
    Click Edit Payer Button
    Click Update Payer Button
    Check Message For Changelog Display    status_arg=create

Verify Changelog Table When Update Without Data With A New Pharmacy Payer Plan
    [Documentation]    30381-11
	[Tags]    Regression    Payer Infromation        report.label.owner: Hai Nguyen
    ${CreatePharmacy_dict}    Create A New Pharmacy Payer Plan    ${data_input}[utc]
    Click Edit Payer Button
    Click Update Payer Button
    Check Message For Changelog Display    status_arg=create

*** Keywords ***
Suite Setup Payer Information Suite
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

Test Setup Payer Information Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Payer Information Tab
    Check Payer Plan Is Visible    #PI-13
