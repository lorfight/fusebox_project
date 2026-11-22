*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient List Suite
Test Setup    Test Setup Patient Management
                ...    title_arg=Patients
                ...    location_arg=${data_input}[location]    
                ...    mrn_arg=${data_input}[patient_mrn]
Test Teardown    Common.Return Previous Window    window_arg=${patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_014    patient    Admin

*** Test Cases ***
Verify Patient List In Patients Page
    [Documentation]    PaMan_TC01    PaMan_TC02    PaMan_TC03    PaMan_TC07    PaMan_TC08    PaMan_TC09    PaMan_TC12    PaMan_TC14    PaMan_TC16    PaMan_TC18
                ...    PaMan_TC20    PaMan_TC22    PaMan_TC24    PaMan_TC27    PaMan_TC28    PaMan_TC29    PaMan_TC30    PaMan_TC31    PaMan_TC32    PaMan_TC35
                ...    PaMan_TC36    PaMan_TC37    PaMan_TC38    PaMan_TC40    PaMan_TC41    PaMan_TC42    PaMan_TC43    PaMan_TC44    PaMan_TC45    PaMan_TC46
                ...    PaMan_TC47    PaMan_TC48    PaMan_TC49    PaMan_TC50    PaMan_TC51    PaMan_TC52
    [Tags]    Regression     Patient List    report.label.owner: Vu Nguyen, Hai Nguyen
    PatientList.Go To Patients Page
    Verify Location Dropdown    expected_list=${data_input}[location_list]
    Verify Search Patient With Invalid MRN    mrn_arg=!@#$%    location_arg=${data_input}[location]
    Verify Patient Information Table    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]    dict_arg=${PatientCreate}
    Verify Patient Information Badges
    Verify Pagination To Navigate To Page List    mrn_arg=${EMPTY}    location_arg=${data_input}[location]
    Verify Advanced Search To Search Patient    dict_arg=${PatientCreate}    location_arg=${data_input}[location]
    Verify Advanced Search To Sort Patient

Verify Inactive Patient With Advanced Search
    [Documentation]    PaMan_TC53    PaMan_TC54    PaMan_TC55    PaMan_TC26
    [Tags]    Regression     Patient List    Inactive Patient    report.label.owner: Vu Nguyen, Hai Nguyen
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    PatientInformation.Inactived Patient
    Select Location In Patient List    ${data_input}[location]
    Input MRN In Patient List    ${data_input}[patient_mrn]
    Search Inactive Patient With Advanced Search
    Verify Inactive Patient    mrn_arg=${data_input}[patient_mrn]

*** Keywords ***
Suite Setup Patient List Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    ${original_window}    Get Window Handles

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${patient_window}    ${original_window}[0]
