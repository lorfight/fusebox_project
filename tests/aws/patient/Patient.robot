*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Patient Suite
Test Setup    Test Setup Patient Suite
Test Teardown    Return Previous Window    window_arg=${home_window}
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    PAT_PA    report.label.owner: Hai Nguyen

*** Test Cases ***
CRUD And Inactive Patient
    [Documentation]    PAT-1    PAT-2
    ...    smoke     patient 
    ${PatientCreate}    Patient.Create Patient With All Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider]
    PatientList.Navigate to Patient by Generated MRN    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]
    PatientInformation.Inactived Patient
    PatientList.Select Location In Patient List    location_arg=${data_input}[location]
    PatientList.Input MRN In Patient List    ${data_input}[mrn]
    PatientList.Search Inactive Patient With Advanced Search
    PatientList.Select Patient From List    mrn_arg=${data_input}[mrn]
    PatientInformation.Actived Patient
    PatientList.Filter Patient In Patient Page    mrn_arg=${data_input}[mrn]    location_arg=${data_input}[location]
    PatientInformation.Delete Patient In Patient Information    ${data_input}[mrn]
    
Import Patient File And Merge Patient
    [Documentation]    PAT-3    PAT-4
    ...    smoke     patient    report.label.owner: Hai Nguyen
    PatientList.Go To Patients Page
    PatientList.Select Location In Patient List    ${data_input}[location]
    PatientList.Open Import Patients Popup
    ImportPatients.Check Upload File Field Is Visible
    ${df}   ${path}    Get Patient Import Excel File
    ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${Fake_dict['last_name']}  
        ...    mrn=${data_input}[mrn]
        ...    dob=${Fake_dict['dob']} 
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=File Successfully Imported!
        ...    color_arg=green
        ...    text_arg=Success
    Confirm Import Patient File
    PatientList.Navigate to Patient by Generated MRN    mrn_arg=${data_input}[mrn]    location_arg=${data_input}[location]
    ${expected_value_list}    Create List    ${Fake_dict['first_name']}    ${Fake_dict['last_name']}    ${data_input}[mrn]    ${Fake_dict['dob']}    ${gender_text}
    PatientInformation.Verify Created Patient With Required fields    ${expected_value_list}
    Remove File    ${path}
    PatientList.Go To Patients Page
    PatientList.Filter Patient In Patient Page    mrn_arg=${data_input}[mrn_merge]    location_arg=${data_input}[location]
    Patient.Create Merged Patient If Not Available    mrn_merge_arg=${data_input}[mrn_merge]
    PatientList.Open Patient Merge Helper Popup
    ${check_merged}    PatientMerge.Megre Patient In Patient Merge Helper    removing_mrn_arg=${data_input}[mrn]    keeping_mrn_arg=${data_input}[mrn_merge]
    IF    "${check_merged}" == "${False}"    
        PatientList.Filter Patient In Patient Page    mrn_arg=${data_input}[mrn]    location_arg=${data_input}[location]
        ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${data_input}[mrn]']/preceding::td[2]//a
        Wait Until Element Is Not Visible    ${patient_mrn_row}    3s
    END

*** Keywords ***
Suite Setup Patient Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${home_window}    ${original_window}[0]

Test Setup Patient Suite
    Open New Window    title_arg=Home
    Check Newsletter