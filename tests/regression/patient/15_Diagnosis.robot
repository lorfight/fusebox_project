*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_015    patient    Admin

*** Test Cases ***
ICD-10 Code Search Field Behavior And Validation
    [Documentation]    PP-214    PP-215    PP-216    PP-218
    [Tags]    Regression     Diagnosis
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Diagnosis tab
    Verify System Returns The Corresponding Result With Valid Input    icdcode_arg=${icd10_code}
    Verify System Displays Message With Invalid Input    icdcode_arg=${icd10_code_invalid}
    Unassigned Diagnosis    icdcode_arg=${icd10_code}
    
Assigning And Marking ICD-10 Codes As Primary For The Patient 
    [Documentation]    PP-217    
    [Tags]    Regression     Diagnosis
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Diagnosis tab
    Find Diagnosis    icdcode_arg=${icd10_code}
    Click Assigned Checkbox    icdcode_arg=${icd10_code}
    Schedule Appointment Without PO And Office Visit    ${PatientData.drug_PO}
    Set Test Variable    ${apt_date}    ${PatientData.APT_Date}
    Open Appointments Tab
    Check Diagnosis Is Assigned To Patient In Appointment Tab    icdcode_arg=${icd10_code}
    Open Diagnosis tab
    Unassigned Diagnosis    icdcode_arg=${icd10_code}

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
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    Set Suite Variable    ${icd10_code}    ${data_input}[icd10_code]
    Set Suite Variable    ${icd10_code_invalid}    ${data_input}[icd10_code_invalid]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    drug_PO=${drug_PO}
    ...    icd10_code=${icd10_code}
    ...    icd10_code_invalid=${icd10_code_invalid}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}