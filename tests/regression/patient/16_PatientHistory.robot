*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup Patient History Tab
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_016    patient    Admin

*** Test Cases ***
Verify Summary Table Displays Correctly
    [Documentation]    PH-1    PH-2    PH-3    PH-4    PH-5    PH-6    PH-7    PH-8    PH-9    
                ...    PH-10    PH-11    PH-12    PH-13    PH-14    PH-16    PH-17
    [Tags]    Regression     Patient History
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Dispense Appointment For Patient History    med_arg=${drug_PO}    loops=3
    Open Patient History Tab
    Get Data From Summary Of All Treatments Table    med_arg=${drug_PO}
    Expand Encounter Summary Table    med_arg=${drug_PO}
    Calculate Treatment Row Total In Encounter Table
    ${previous_last_treatment_row_list}    Create Dictionary
    ${last_treatment_row_list}    Create Dictionary
    Get Data From Treatment Row In Encounter Table    row_arg=${previous_last_treatment_row}    list_arg=${previous_last_treatment_row_list}
    Get Data From Treatment Row In Encounter Table    row_arg=${last_treatment_row}    list_arg=${last_treatment_row_list}
    Verify All Column In Summary Of All Treatments Table    first_row_list=${previous_last_treatment_row_list}    last_row_list=${last_treatment_row_list}

Verify Treatment Data Is Validated Based On Treatment Notes
    [Documentation]    PH-18    PH-19    PH-20    PH-21    PH-22    PH-23    PH-24    
                ...    PH-25    PH-26    PH-27    PH-28    PH-29    PH-30
    [Tags]    Regression     Patient History
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Dispense Appointment For Patient History    med_arg=${drug_PO}    loops=1
    Handle Data Treatment Note    date_arg=${APT_data['apt_date[1]']}    med_arg=${drug_PO}
    Get Encounter Summary Treatment Data    date_arg=${APT_data['apt_date[1]']}    med_arg=${drug_PO}
    Compare Encounter Summary Data With Treatment Note Data 
    
*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    referto_provider_NPI_PO=${referto_provider_NPI_PO}
    ...    drug_PO=${drug_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}

Suite Setup Patient History Tab
    Suite Setup With Required Patient Information
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create PO For Patient History    med_arg=${drug_PO}
    Patient.Go To Patients Page