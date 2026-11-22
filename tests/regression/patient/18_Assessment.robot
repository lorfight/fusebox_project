*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword Assessment
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_018    patient    Admin

*** Test Cases ***
Verify All Template Assessments When Created
    [Documentation]    PaMan_TC220
    [Tags]    Regression    Assessments
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
    Open Assessment Tab
    Generate Meaningful Alpha Template Name
    Create List Assessment
    ${assessment}     Get List Items    ${template_dropdown}
    Sort List    ${assessment}
    Lists Should Be Equal    ${assessment[1:]}    ${template_list}
    Delete Assessment Templates    ${template_list}

Verify Patient Information Exists
    [Documentation]    PaMan_TC219    PaMan_TC221    PaMan_TC222    PaMan_TC223    PaMan_TC224    PaMan_TC225    PaMan_TC226    
    ...    PaMan_TC227   PaMan_TC228    PaMan_TC229    PaMan_TC230    PaMan_TC231    PaMan_TC232    PaMan_TC233    PaMan_TC234
	[Tags]    Regression    Assessments
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
    Open Assessment Tab
    Check Default Value Of Patient Assessments Dropdown
    Verify That New Template Is Created Unsuccessfuly
    Verify That New Template Is Created Successfuly
    Check System Shows "New Assessment" Or "Edit Selected Template
    Verify Edit Selected Template Button
    Verify The System Navigates The User Into The "New Assessment"
    Verify That View Information Assessment Detail Successful
    Verify Deleted SuccessFully

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]

    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}

Test Setup Keyword Assessment
    Test Setup Keyword
    Navigate to Patient by Generated MRN
    Open Assessment Tab
    Delete All Assessment Template From Dropdown
