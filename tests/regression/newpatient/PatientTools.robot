*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Tools Suite
Test Setup    Test Setup Patient Tools Suite
Test Teardown    Test Teardown Patient Tools Suite
Suite Teardown    Suite Teardown Patient Tools Suite
Test Tags    test:retry(1)    PaMan_019    patient    Admin

*** Test Cases ***
Import Patient With Empty Account Number In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
    ${invalid_id}    Evaluate    random.choice(["testid","test12","test!#","test12!#","123#$%","!#$%&*"])
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${invalid_id}
        ...    first_name=${Fake_dict['first_name']} 
        ...    last_name=${Fake_dict['last_name']} 
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${Fake_dict['dob']}
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=Could not find an account with identifiers provided
        ...    color_arg=red
        ...    text_arg=Error
    Remove All Erorr Lines
    Click Close Import Patient Modal Button
    
Import Patient With Empty First Name In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    last_name    dob
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${EMPTY} 
        ...    last_name=${Fake_dict['last_name']} 
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${Fake_dict['dob']}
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=First Name Missing
        ...    color_arg=red
        ...    text_arg=Error
    Remove All Erorr Lines
    Click Close Import Patient Modal Button

Import Patient With Empty Last Name In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    dob
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${EMPTY}
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${Fake_dict['dob']}
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=Last Name Missing
        ...    color_arg=red
        ...    text_arg=Error
    Remove All Erorr Lines
    Click Close Import Patient Modal Button

Import Patient With Empty DOB In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${Fake_dict['last_name']}  
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${EMPTY}
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=Invalid DOB Supplied
        ...    color_arg=red
        ...    text_arg=Error
    Remove All Erorr Lines
    Click Close Import Patient Modal Button

Import Patient With Empty Gender In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${Fake_dict['last_name']}  
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${Fake_dict['dob']} 
        ...    gender=${EMPTY}
    Import Patient File    
        ...    path=${path}    
        ...    msg=File Successfully Imported!
        ...    color_arg=green
        ...    text_arg=Success
    Click Remove Row Button
    Click Close Import Patient Modal Button

Import Patient With Required Fields In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools    report.label.owner: Vu Nguyen Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
    ${gender_text}    ${gender_code}    Set Gender Value
    Prepare Invalid Patient Data
        ...    df=${df}
        ...    path=${path}
        ...    invalid_id=${data_input}[location_id]
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${Fake_dict['last_name']}  
        ...    mrn=${data_input}[patient_mrn]
        ...    dob=${Fake_dict['dob']} 
        ...    gender=${gender_code}
    Import Patient File    
        ...    path=${path}    
        ...    msg=File Successfully Imported!
        ...    color_arg=green
        ...    text_arg=Success
    Confirm Import Patient File
    Navigate to Patient by Generated MRN    mrn_arg=${data_input}[patient_mrn]    location_arg=${data_input}[location]
    ${expected_value_list}    Create List    ${Fake_dict['first_name']}    ${Fake_dict['last_name']}    ${data_input}[patient_mrn]    ${Fake_dict['dob']}    ${gender_text}
    PatientInformation.Verify Created Patient With Required fields    ${expected_value_list}
    Click Delete Patient Button
    Alert Should Be Present    Are you sure you want to Delete this patient?    ACCEPT    5s
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Patients

*** Keywords ***
Suite Setup Patient Tools Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    Login To Fusebox    ${Username}    ${Password}
    PatientList.Go To Patients Page
    PatientList.Select Location In Patient List    ${data_input}[location]
    PatientList.Open Import Patients Popup
    ImportPatients.Check Upload File Field Is Visible
    ${df}   ${path}    Get Patient Import Excel File
    Click Close Import Patient Modal Button
    ${keys}    Create List     
        ...    Account # (Must get location account# from Mainbridge staff)    
        ...    First Name    
        ...    Last Name  
        ...    MRN    
        ...    Gender (M / F / O)    
        ...    DOB (MM/DD/YYYY)
    Set Suite Variable    ${df}
    Set Suite Variable    ${keys}
    Set Suite Variable    ${path}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}

Test Setup Patient Tools Suite
    Test Setup Patient Management
        ...    title_arg=Patients
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    PatientList.Select Location In Patient List    ${data_input}[location]
    PatientList.Open Import Patients Popup
    ImportPatients.Check Upload File Field Is Visible

Test Teardown Patient Tools Suite
    Clear Patient Import Template
        ...    df=${df}
        ...    path=${path}
        ...    keys=${keys}
    Common.Return Previous Window    ${original_window}[0]

Suite Teardown Patient Tools Suite
    Remove File    ${path}
    Close Browser
