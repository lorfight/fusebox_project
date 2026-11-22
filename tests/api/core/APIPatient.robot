*** Settings ***
Documentation      Patient Save
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Suite Setup    Suite Setup
# Test Setup    Patient.Create Fake Data List
# Suite Teardown    Suite Teardown

*** Test Cases ***
Sending Request With ID EMRPatientID MRN Match With Fusebox
    [Documentation]    P33629_TC03
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request With ID But EMRPatientID Not Match
    [Documentation]    P33629_TC04
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields       
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request With ID But EMRPatientID Exists
    [Documentation]    P33629_TC05
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...   account_number_arg=${head_multi_acc1}
    ...    expected_status=200 
    ${emr_patient_not_in_account}    Set Variable  ${response_json["emrPatientID"]}
    ${id_patient_not_in_account}    Set Variable    ${response_json["id"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200 
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    emr_patient_id_arg=${emr_patient_not_in_account}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Patient with EMRPatientID: ${emr_patient_not_in_account} already exist with ID: ${id_patient_not_in_account}.
    Should Be Equal    ${error_response}    ${error}     
Sending Request With ID But MRN Not Match
    [Documentation]    P33629_TC06
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Patient with the provided Patient ID or EMR Patient ID possesses a distinct Patient ID with the number ${Fake_dict.MRN_fake}.
    Should Be Equal    ${error_response}    ${error}
Sending Request With ID But MRN Exists
    [Documentation]    P33629_TC07
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    ${mrn_saved_patient}    Set Variable    ${response_json["mrn"]}
    ${id_save_patient}    Set Variable    ${response_json["id"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${response_json["emrPatientID"]} 
    ...    mrn_arg=${mrn_saved_patient}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Patient with MRN: ${mrn_saved_patient} already exist with ID: ${id_save_patient}.
    Should Be Equal    ${error_response}    ${error}    
Sending Request With ID But ID Not Match
    [Documentation]    P33629_TC08
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    ${id_saved_patient}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields          
    ...    id_arg=${id_saved_patient}    
    ...    expected_status=404
Sending Request No ID With EMRPatient And MRN Not Exist
    [Documentation]    P33629_TC09
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields          
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request No ID With EMRPatient And MRN Match
    [Documentation]    P33629_TC10
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json} 
Sending Request No ID With EMRPaitient Match
    [Documentation]    P33629_TC11
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${head_multi_acc1}
    ...    expected_status=200
    ${emr_saved_patient}    Set Variable    ${response_json["emrPatientID"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    ${mrn_saved_patient}    Set Variable    ${response_json["mrn"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    emr_patient_id_arg=${emr_saved_patient}    
    ...    mrn_arg=${mrn_saved_patient}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}  
    ${error}    Set Variable    Patient provide with MRN: ${mrn_saved_patient} or EMRPatientID: ${emr_saved_patient} already exist with another patient.
    Should Be Equal    ${error_response}    ${error}
Sending Request No ID With MRN Not Match
    [Documentation]    P33629_TC12
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Patient with the provided Patient ID or EMR Patient ID possesses a distinct Patient ID with the number ${Fake_dict.MRN_fake}.
    Should Be Equal    ${error_response}    ${error}   
Sending Request No ID But MRN Exists
    [Documentation]    P33629_TC13
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    ${mrn_saved_patient}    Set Variable    ${response_json["mrn"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    ${emr_saved_patient}    Set Variable    ${response_json["emrPatientID"]}
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    emr_patient_id_arg=${emr_saved_patient} 
    ...    mrn_arg=${mrn_saved_patient}    
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Patient provide with MRN: ${mrn_saved_patient} or EMRPatientID: ${emr_saved_patient} already exist with another patient.
    Should Be Equal    ${error_response}    ${error}
Sending Request With MRN Not Exist
    [Documentation]    P33629_TC14, P33629_TC15
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields        
    ...    emr_patient_id_arg=${None}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
    Sending Body Request With Required Fields  
    ...    mrn_arg=${response_json["mrn"]}      
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request With MRN Match
    [Documentation]    P33629_TC16
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields        
    ...    expected_status=200
    Sending Body Request With Required Fields  
    ...    mrn_arg=${response_json["mrn"]}      
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request With MRN Not Match
    [Documentation]    P33629_TC17
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${head_multi_acc1}        
    ...    expected_status=200
    Sending Body Request With Required Fields
    ...    emr_patient_id_arg=${None}
    ...    mrn_arg=${response_json["mrn"]}      
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To Save Patient Has No Adress 
    [Documentation]    P33629_TC21
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    primary_address_line1_arg=${None}
    ...    primary_address_line2_arg=${None}
    ...    primary_city_arg=${None}
    ...    primary_state_province_arg=${None}
    ...    primary_postal_code_arg=${None}
    ...    primary_country_region_arg=${None}
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    mrn_arg=${response_json["mrn"]}  
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json} 
Sending Request To Save Patient Has Adress 
    [Documentation]    P33629_TC22 P33629_TC23 P33629_TC24
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    mrn_arg=${response_json["mrn"]}  
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json} 
Sending Request No Account Number
    [Documentation]    P33629_TC25
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    account_number_arg=${None}   
    ...    expected_status=404 
Sending Request All Fields Blank
    [Documentation]    P33629_TC26
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    account_number_arg=${None}
    ...    first_name_arg=${None}
    ...    middle_name_arg=${None}
    ...    last_name_arg=${None}
    ...    emr_patient_id_arg=${None}
    ...    mrn_arg=${None}
    ...    ssn_arg=${None}
    ...    spouse_first_name_arg=${None}
    ...    spouse_middle_name_arg=${None}
    ...    spouse_last_name_arg=${None}
    ...    phone_arg=${None}
    ...    email_arg=${None}
    ...    notes_arg=${None}
    ...    occupation_arg=${None}
    ...    employer_name_arg=${None}
    ...    work_phone_arg=${None}
    ...    emergency_contact_name_arg=${None}
    ...    emergency_contact_phone_arg=${None}
    ...    emergency_contact_relationship_arg=${None}
    ...    primary_address_line1_arg=${None}
    ...    primary_address_line2_arg=${None}
    ...    primary_city_arg=${None}
    ...    primary_state_province_arg=${None}
    ...    primary_postal_code_arg=${None}
    ...    primary_country_region_arg=${None}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    Lists Should Be Equal    ${actual_errors}    ${list_errors_empty_field}
Sending Request To List Account Equal 1 To Save Patient With ID EMRPatientID MRN Match With Fusebox
    [Documentation]    P33629_TC208
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To List Account Equal 1 To Save Patient With ID Not Match
    [Documentation]    P33629_TC209
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields        
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    ${id_saved_patient}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${id_saved_patient}    
    ...    expected_status=404
Sending Request To List Account Equal 1 To Save Patient No ID
    [Documentation]    P33629_TC210
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200   
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To List Account Equal 1 To Save Patient No ID But EMRPatientID MRN Match With Fusebox
    [Documentation]    P33629_TC211
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]} 
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To List Account Equal 1 To Save Patient No ID But MRN Not Match
    [Documentation]    P33629_TC212
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}    
    ...    emr_patient_id_arg=${None}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To List Account Equal 1 To Save Patient No ID But MRN Match
    [Documentation]    P33629_TC213
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}   
    ...    emr_patient_id_arg=${None}
    ...    mrn_arg=${response_json["mrn"]}
    ...     expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient With ReferringProviderNPI And PreferredInternalProviderNPI
    [Documentation]    P33629_TC214 P33629_TC215
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200   
    Compare Request And Response With Required Fields    ${response_json}       
Sending Request To List Account Equal 1 To Save Patient With ReferringProviderNPI And PreferredInternalProviderNPI Not Match
    [Documentation]    P33629_TC216
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    ${referringProviderNPI_random}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(8))    random
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}  
    ...    referringProviderNPI_arg=${referringProviderNPI_random}
    ...    preferredInternalProviderNPI_arg=${referringProviderNPI_random}
    ...    expected_status=400
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Physician information not found with the NPI: ${referringProviderNPI_random}
    Should Be Equal    ${error_response}    ${error}
Sending Request To List Account Equal 1 To Save Patient Has No Adress 
    [Documentation]    P33629_TC217
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}     
    ...    primary_address_line1_arg=${None}
    ...    primary_address_line2_arg=${None}
    ...    primary_city_arg=${None}
    ...    primary_state_province_arg=${None}
    ...    primary_postal_code_arg=${None}
    ...    primary_country_region_arg=${None}
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    mrn_arg=${response_json["mrn"]}
    ...    id_arg=${response_json["id"]}
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient Has Adress 
    [Documentation]    P33629_TC218
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}  
    ...    expected_status=200   
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}      
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    mrn_arg=${response_json["mrn"]}
    ...    id_arg=${response_json["id"]}
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient No Account Number But ID EMRPatientID MRN Match
    [Documentation]    P33629_TC219
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${None}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}   
Sending Request To List Account Equal 1 To Save Patient No Account Number But ID EMRPatientID MRN Not Exist
    [Documentation]    P33629_TC220
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${None}   
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient No Account Number No ID But EMRPatientID MRN Match 
    [Documentation]    P33629_TC221
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${None}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient No Account Number No ID No EMRPatientID But MRN Not Exist
    [Documentation]    P33629_TC222
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${None}
    ...    emr_patient_id_arg=${None}   
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 1 To Save Patient No Account Number No ID No EMRPatientID And MRN Match 
    [Documentation]    P33629_TC223
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200
    Patient.Create Fake Data List
    Sending Body Request With All Fields 
    ...    head_acc_arg=${head_1_data}   
    ...    account_number_arg=${None}   
    ...    emr_patient_id_arg=${None}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    expected_status=200
    Compare Request And Response With All Fields    ${response_json}
Sending Request To List Account Equal 0 To Save Patient With ID EMRPatientID MRN Match With Fusebox
    [Documentation]    P33629_TC224
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields 
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}   
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]}    
    ...    id_arg=${response_json["id"]}    
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}   
Sending Request To List Account Equal 0 To Save Patient With ID Not Match
    [Documentation]    P33629_TC225
	[Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    ${id_saved_patient}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    id_arg=${id_saved_patient}    
    ...    expected_status=404    

Sending Request To List Account Equal 0 To Save Patient No ID
    [Documentation]    P33629_TC226
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1} 
    ...    expected_status=200 
    Compare Request And Response With Required Fields    ${response_json}   

Sending Request To List Account Equal 0 To Save Patient No ID But EMRPatientID MRN Match With Fusebox
    [Documentation]    P33629_TC227
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    mrn_arg=${response_json["mrn"]}
    ...    expected_status=200   
    Compare Request And Response With Required Fields    ${response_json}    
Sending Request To List Account Equal 0 To Save Patient No ID But MRN Not Match
    [Documentation]    P33629_TC228
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}  
    ...    emr_patient_id_arg=${None}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}     
Sending Request To List Account Equal 0 To Save Patient No ID But MRN Match
    [Documentation]    P33629_TC229
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200   
    ...    emr_patient_id_arg=${None}
    ...    mrn_arg=${response_json["mrn"]}
    Compare Request And Response With Required Fields    ${response_json}

Sending Request To List Account Equal 0 To Save Patient With ReferringProviderNPI And PreferredInternalProviderNPI
    [Documentation]    P33629_TC230 P33629_TC231
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200  
    Compare Request And Response With Required Fields    ${response_json}       
Sending Request To List Account Equal 0 To Save Patient With ReferringProviderNPI And PreferredInternalProviderNPI Not Match
    [Documentation]    P33629_TC232
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    ${referringProviderNPI_random}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(8))    random
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    referringProviderNPI_arg=${referringProviderNPI_random}
    ...    preferredInternalProviderNPI_arg=${referringProviderNPI_random}
    ...    expected_status=400   
    ${error_response}    Set Variable    ${response_json["detail"]}
    ${error}    Set Variable    Physician information not found with the NPI: ${referringProviderNPI_random}
    Should Be Equal    ${error_response}    ${error}
Sending Request To List Account Equal 0 To Save Patient Has No Adress 
    [Documentation]    P33629_TC233
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    primary_address_line1_arg=${None}
    ...    primary_address_line2_arg=${None}
    ...    primary_city_arg=${None}
    ...    primary_state_province_arg=${None}
    ...    primary_postal_code_arg=${None}
    ...    primary_country_region_arg=${None}
    ...    expected_status=200     
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]} 
    ...    id_arg=${response_json["id"]}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request To List Account Equal 0 To Save Patient Has Adress 
    [Documentation]    P33629_TC234
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200  
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data}   
    ...    account_number_arg=${head_0_acc1}
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}    
    ...    mrn_arg=${response_json["mrn"]} 
    ...    id_arg=${response_json["id"]}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
Sending Request To List Account Equal 0 To Save Patient No Account Number
    [Documentation]    P33629_TC235
    [Tags]    API    Patient Save
    ...  report.label.owner: Quoc Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields    
    ...    head_acc_arg=${head_0_data} 
    ...    account_number_arg=${None}  
    ...    expected_status=404
Sending Request With Required Fields And Missing Optional Fields
    [Documentation]    P33629_TC02    P33629_TC60    P33629_TC62    P33629_TC72    P33629_TC84
    ...    P33629_TC93    P33629_TC96    P33629_TC100    P33629_TC104    P33629_TC108
    ...    P33629_TC112    P33629_TC116    P33629_TC120    P33629_TC124    P33629_TC126
    ...    P33629_TC130    P33629_TC135    P33629_TC138    P33629_TC142    P33629_TC146
    ...    P33629_TC150    P33629_TC154    P33629_TC158    P33629_TC162    P33629_TC166
    ...    P33629_TC170    P33629_TC174    P33629_TC178    P33629_TC185    P33629_TC189
    ...    P33629_TC193    P33629_TC197    P33629_TC201    P33629_TC205
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}
    ${null_fields}=    Create List
    ...    middleName    ssn    race    ethnicity    maritalStatus
    ...    spouseFirstName    spouseMiddleName    spouseLastName    referringProviderNPI
    ...    height    weight    weightUnit    phone    email    notes
    ...    occupation    employerName    workPhone    emergencyContactName
    ...    emergencyContactPhone    emergencyContactRelationship    primaryAddress
    FOR    ${field}    IN    @{null_fields}
        Should Be Equal    ${response_json["${field}"]}    ${None}
    END

Sending Request With The ID Already Exists In The System
    [Documentation]    P33629_TC58    P33629_TC59
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    mrn_arg=${response_json["mrn"]}
    ...    id_arg=${response_json["id"]}
    ...    expected_status=200
    Compare Request And Response With Required Fields    ${response_json}

Sending Request With The EMR Patient ID Already Exists In The System
    [Documentation]    P33629_TC62
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    expected_status=200    
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    mrn_arg=${response_json["mrn"]}
    ...    id_arg=${response_json["id"]}
    ...    emr_patient_id_arg=${response_json["emrPatientID"]}
    ...    expected_status=200   
    Compare Request And Response With Required Fields    ${response_json}

Verify Response Format and Match with Request Body for Maximum Character Fields
    [Documentation]    P33629_TC01    P33629_TC69    P33629_TC73    P33629_TC78    P33629_TC85
    ...    P33629_TC90    P33629_TC97    P33629_TC101    P33629_TC105    P33629_TC109    
    ...    P33629_TC113    P33629_TC117    P33629_TC121    P33629_TC131    P33629_TC136
    ...    P33629_TC139    P33629_TC143    P33629_TC151    P33629_TC155    P33629_TC159   
    ...    P33629_TC163    P33629_TC167    P33629_TC171    P33629_TC175    P33629_TC186 
    ...    P33629_TC190    P33629_TC194    P33629_TC198    P33629_TC202    P33629_TC206    
    ...    P33629_TC27 --> P33629_TC57
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Data List
    ${rand_str_50}    Patient.Get Random Data    fake_data=rand_str_50
    ${rand_str_15}    Patient.Get Random Data    fake_data=rand_str_15
    ${rand_str_100}    Patient.Get Random Data    fake_data=rand_str_100
    ${rand_str_255}    Patient.Get Random Data    fake_data=rand_str_255
    Sending Body Request With All Fields
    ...    first_name_arg=${rand_str_50}
    ...    middle_name_arg=${rand_str_50}
    ...    last_name_arg=${rand_str_50}
    ...    emr_patient_id_arg=${rand_str_50}
    ...    mrn_arg=${rand_str_50}
    ...    ssn_arg=${rand_str_50}
    ...    spouse_first_name_arg=${rand_str_50}
    ...    spouse_middle_name_arg=${rand_str_50}
    ...    spouse_last_name_arg=${rand_str_50}
    ...    phone_arg=${rand_str_15}
    ...    notes_arg=${rand_str_255}
    ...    occupation_arg=${rand_str_255}
    ...    employer_name_arg=${rand_str_255}
    ...    work_phone_arg=${rand_str_50}
    ...    emergency_contact_name_arg=${rand_str_255}
    ...    emergency_contact_phone_arg=${rand_str_50}
    ...    emergency_contact_relationship_arg=${rand_str_255}
    #primary_address
    ...    primary_address_line1_arg=${rand_str_100}
    ...    primary_address_line2_arg=${rand_str_100}
    ...    primary_city_arg=${rand_str_50}
    ...    primary_postal_code_arg=${rand_str_15}
    ...    primary_country_region_arg=${rand_str_50}
    ...    expected_status=200
    ${response_string}  Evaluate    json.dumps(${response_json})    json
    Set Test Variable    ${response_string}
    Validate JSON Fields Max Length    response_arg=${response_string}
    Compare Request And Response With All Fields    ${response_json}
    
Sending Request Exceeding Maximum Characters With All Fields
    [Documentation]    P33629_TC70    P33629_TC74    P33629_TC79    P33629_TC86
    ...    P33629_TC91    P33629_TC98    P33629_TC114    P33629_TC118    P33629_TC122    
    ...    P33629_TC144    P33629_TC152    P33629_TC156    P33629_TC160    P33629_TC164    
    ...    P33629_TC168    P33629_TC172    P33629_TC176    P33629_TC187    P33629_TC191    
    ...    P33629_TC195    P33629_TC199    P33629_TC203    P33629_TC207
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Data List
    ${rand_str_51}    Patient.Get Random Data    fake_data=rand_str_51
    ${rand_str_16}    Patient.Get Random Data    fake_data=rand_str_16
    ${rand_str_101}    Patient.Get Random Data    fake_data=rand_str_101
    ${rand_str_256}    Patient.Get Random Data    fake_data=rand_str_256
    ${rand_str_3}    Patient.Get Random Data    fake_data=rand_str_3
    Sending Body Request With All Fields
    ...    first_name_arg=${rand_str_51}
    ...    middle_name_arg=${rand_str_51}
    ...    last_name_arg=${rand_str_51}
    ...    emr_patient_id_arg=${rand_str_51}
    ...    mrn_arg=${rand_str_51}
    ...    ssn_arg=${rand_str_51}
    ...    spouse_first_name_arg=${rand_str_51}
    ...    spouse_middle_name_arg=${rand_str_51}
    ...    spouse_last_name_arg=${rand_str_51}
    ...    phone_arg=${rand_str_16}
    ...    notes_arg=${rand_str_256}
    ...    occupation_arg=${rand_str_256}
    ...    employer_name_arg=${rand_str_256}
    ...    work_phone_arg=${rand_str_51}
    ...    emergency_contact_name_arg=${rand_str_256}
    ...    emergency_contact_phone_arg=${rand_str_51}
    ...    emergency_contact_relationship_arg=${rand_str_256}
    #primary_address
    ...    primary_address_line1_arg=${rand_str_101}
    ...    primary_address_line2_arg=${rand_str_101}
    ...    primary_city_arg=${rand_str_51}
    ...    primary_state_province_arg=ABC
    ...    primary_postal_code_arg=${rand_str_16}
    ...    primary_country_region_arg=${rand_str_51}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    Lists Should Be Equal    ${actual_errors}    ${expected_errors}

Sending Request Blank DOB And Gender
    [Documentation]    P33629_TC80
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    dob_arg=${EMPTY}
    ...    gender_arg=${EMPTY}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    Error converting value {null} to type 'System.DateTime'.
    ...    Required property 'dob' expects a value but got null.
    ...    Error converting value "" to type 'FuseboxGateway.Web.API.PublicAPI.Version1.Enum.Gender'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request Missing DOB And Gender
    [Documentation]    P33629_TC81    P33629_TC92
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request}    Create Dictionary    
    ...    accountNumber=${head_multi_acc2}
    ...    firstName=${Fake_dict.first_name_fake}
    ...    lastName=${Fake_dict.last_name_fake}
    ...    mrn=${Fake_dict.MRN_fake}
    Set Test Variable    ${body_request}
    ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}    expected_status=400
    ${response_json}    Set Variable    ${response.json()}
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    Required property 'dob' not found in JSON.
    ...    Required property 'gender' not found in JSON.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END
Sending Request Blank FirstName, LastName And MRN
    [Documentation]    P33629_TC66    P33629_TC75    P33629_TC87
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    Sending Body Request With Required Fields
    ...    first_name_arg=${EMPTY}
    ...    last_name_arg=${EMPTY}
    ...    mrn_arg=${EMPTY}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The MRN field is required.
    ...    The LastName field is required.
    ...    The FirstName field is required.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request Missing FirstName, LastName And MRN
    [Documentation]    P33629_TC67    P33629_TC76    P33629_TC88
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body_request}    Create Dictionary    
    ...    account_number_arg=${head_multi_acc2}
    ...    dob=${Fake_dict.DOB_fake}
    ...    gender=${Fake_dict.gender_value}
    Set Test Variable    ${body_request}
    ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}    expected_status=400
    ${response_json}    Set Variable    ${response.json()}
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The MRN field is required.
    ...    The LastName field is required.
    ...    The FirstName field is required.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request With Blank Optional Fields
    [Documentation]    P33629_TC71    P33629_TC83    P33629_TC95    P33629_TC99
    ...    P33629_TC103    P33629_TC107    P33629_TC111    P33629_TC115    P33629_TC119
    ...    P33629_TC129    P33629_TC134    P33629_TC137    P33629_TC141    P33629_TC149
    ...    P33629_TC153    P33629_TC157    P33629_TC161    P33629_TC165    P33629_TC169 
    ...    P33629_TC173    P33629_TC177    P33629_TC184    P33629_TC188    P33629_TC192    
    ...    P33629_TC196    P33629_TC200    P33629_TC204
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    middle_name_arg=${EMPTY}
    ...    emr_patient_id_arg=${EMPTY}
    ...    ssn_arg=${EMPTY}
    ...    race_arg=${EMPTY}
    ...    ethnicity_arg=${EMPTY}
    ...    marital_status_arg=${EMPTY}
    ...    spouse_first_name_arg=${EMPTY}
    ...    spouse_middle_name_arg=${EMPTY}
    ...    spouse_last_name_arg=${EMPTY}
    ...    referringProviderNPI_arg=${None}
    ...    preferredInternalProviderNPI_arg=${None}
    ...    height_arg=${EMPTY}
    ...    weight_arg=${EMPTY}
    ...    weight_unit_arg=${EMPTY}
    ...    phone_arg=${EMPTY}
    ...    email_arg=${None}
    ...    notes_arg=${EMPTY}
    ...    occupation_arg=${EMPTY}
    ...    employer_name_arg=${EMPTY}
    ...    work_phone_arg=${EMPTY}
    ...    emergency_contact_name_arg=${EMPTY}
    ...    emergency_contact_phone_arg=${EMPTY}
    ...    emergency_contact_relationship_arg=${EMPTY}
    ...    expected_status=200
    #primary_address
    ...    primary_address_line1_arg=${EMPTY}
    ...    primary_address_line2_arg=${EMPTY}
    ...    primary_city_arg=${EMPTY}
    ...    primary_state_province_arg=${EMPTY}
    ...    primary_postal_code_arg=${EMPTY}
    ...    primary_country_region_arg=${EMPTY}
    Compare Request And Response With All Fields    ${response_json}

Sending Request With Blank preferredInternalProviderNPI, referringProviderNPI, Email
    [Documentation]    P33629_TC123    P33629_TC125    P33629_TC145
    [Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    referringProviderNPI_arg=${EMPTY}
    ...    preferredInternalProviderNPI_arg=${EMPTY}
    ...    email_arg=${EMPTY}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The Email field is not a valid e-mail address.
    ...    The field ReferringProviderNPI must match the regular expression '^[0-9]+$'.
    ...    The field PreferredInternalProviderNPI must match the regular expression '^[0-9]+$'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request With Not Boolean On Active
    [Documentation]    P33629_TC181
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    active=boolean
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    Could not convert string to boolean: boolean.

Sending Request With Symbol Character, Letter, The Special Character On Id, AccountNumber
    [Documentation]    P33629_TC61    P33629_TC65
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=id#A9!@
    ...    id_arg=id#A9!@
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The field ID must match the regular expression '^[0-9]+$'.
    ...    The field AccountNumber must match the regular expression '^[0-9]+$'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request With Not Date Time On DOB And Outside The List On Gender
    [Documentation]    P33629_TC82    P33629_TC94
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${head_multi_acc2}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.num_rand}
    ...    mrn_arg=${Fake_dict.MRN_fake}
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${EMPTY}
    ...    gender_arg=Man
    ...    expected_status=400

    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    Could not convert string to DateTime: ${body_request["dob"]}.
    ...    Required property 'dob' not found in JSON.
    ...    Error converting value \"${body_request["gender"]}\" to type 'FuseboxGateway.Web.API.PublicAPI.Version1.Enum.Gender'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request With Value Outside The List On Race, Ethnicity, MaritalStatus, WeightUnit
    [Documentation]    P33629_TC102    P33629_TC106    P33629_TC110    P33629_TC140

	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Data List
    Sending Body Request With All Fields
    ...    id_arg=${None}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    middle_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    emr_patient_id_arg=${Fake_dict.MRN_fake}
    ...    mrn_arg=${Fake_dict.MRN_fake}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    ssn_arg=${Fake_dict.SSN_fake}
    ...    race_arg=Europe
    ...    ethnicity_arg=Europe
    ...    marital_status_arg=Couple
    ...    spouse_first_name_arg=${Fake_dict.first_name_fake}
    ...    spouse_middle_name_arg=${Fake_dict.first_name_fake}
    ...    spouse_last_name_arg=${Fake_dict.last_name_fake}
    ...    referringProviderNPI_arg=${referringProviderNPI}
    ...    preferredInternalProviderNPI_arg=${preferredInternalProviderNPI}
    ...    height_arg=${Fake_dict.height_fake}
    ...    weight_arg=${Fake_dict.weight_fake}
    ...    weight_unit_arg=tons
    ...    phone_arg=${Fake_dict.phone_fake}
    ...    email_arg=${Fake_dict.email_fake}
    ...    notes_arg=${Fake_dict.sentence_str}
    ...    occupation_arg=${Fake_dict.job_fake}
    ...    employer_name_arg=${Fake_dict.full_name_fake}
    ...    work_phone_arg=${Fake_dict.phone_fake}
    ...    emergency_contact_name_arg=${Fake_dict.full_name_fake}
    ...    emergency_contact_phone_arg=${Fake_dict.phone_fake}
    ...    emergency_contact_relationship_arg=${Fake_dict.relationship_fake}
    #primary_address
    ...    primary_address_line1_arg=${Fake_dict.address_fake}
    ...    primary_address_line2_arg=${Fake_dict.address_fake}
    ...    primary_city_arg=${Fake_dict.country_fake}
    ...    primary_state_province_arg=${Fake_dict.state_province_value}
    ...    primary_postal_code_arg=${Fake_dict.zip_fake}
    ...    primary_country_region_arg=${Fake_dict.country_fake}
    ...    expected_status=400

    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    Error converting value \"${body_request["race"]}\"
    ...    Error converting value \"${body_request["ethnicity"]}\"
    ...    Error converting value \"${body_request["weightUnit"]}\"
    ...    Error converting value \"${body_request["maritalStatus"]}\"
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending 1 Character With FirstName, LastName And MRN
    [Documentation]    P33629_TC68    P33629_TC77    P33629_TC89
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${head_multi_acc1}
    ...    first_name_arg=A
    ...    last_name_arg=A
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    mrn_arg=1
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${None}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    expected_status=200

    Should Be Equal    ${response_json["accountNumber"]}    ${body_request["accountNumber"]}
    Should Be Equal    ${response_json["firstName"]}    ${body_request["firstName"]}
    Should Be Equal    ${response_json["lastName"]}    ${body_request["lastName"]}
    Should Be Equal    ${response_json["mrn"]}    ${body_request["mrn"]}

Sending Request Blank AccountNumber
    [Documentation]    P33629_TC63
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${EMPTY}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    mrn_arg=${Fake_dict.MRN_fake}
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${EMPTY}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    expected_status=400

    ${actual_errors}    Evaluate    [err for errors in ${response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The field AccountNumber must match the regular expression '^[0-9]+$'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request Missing AccountNumber
    [Documentation]    P33629_TC64
	[Tags]    API    Patient Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    Sending Body Request With Required Fields
    ...    account_number_arg=${None}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    mrn_arg=${Fake_dict.MRN_fake}
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${EMPTY}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    expected_status=404

*** Keywords ***
Suite Setup
    Setup Data
    Get URL API Patient
   
Suite Teardown
    Delete Patient From Patient List
    Close Browser