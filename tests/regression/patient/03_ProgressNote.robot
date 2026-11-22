*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_003    patient    Admin

*** Test Cases ***
Verify Elements Are Visible In Progress Note Tab
    [Documentation]    PN-1    PN-2    PN-3    PN-4
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Progress Note Tab
    The Subject Filter dropdown is visible
    Choose Date In Date Picker Table    date_arg=${note_start_date}
    Choose Date In Date Picker Table    date_arg=${note_end_date}
    Verify A Form Is Visible When Click Add Note

Verify Add New Subject Is Visible
    [Documentation]    PN-5    PN-6
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Progress Note Tab
    Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s
    Add New Subject

Verify the Follow-Up Date Picker Is Visible
    [Documentation]    PN-7
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Progress Note Tab
    Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s
    Choose Date In Date Picker Table    date_arg=${follow_up_date}

Add Note Successfully With Valid Data
    [Documentation]    PN-8    PN-9    PN-10
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Progress Note Tab
    Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s
    Add New Subject
    Choose Date In Date Picker Table    date_arg=${follow_up_date}
    Scroll And Click Element    ${progress_save_btn}
    Page Alert Message    The Note field is required.
    Create Fake Data List
    ${long_text}    Get Random Data    fake_data=long_text
    Input Text    ${progress_note_textbox}    ${long_text}
    Scroll And Click Element    ${progress_save_btn}
    Page Alert Message    Progress Note Successfully Saved

Verify Add Note Form Close When Click Cancel
    [Documentation]    PN-11
	[Tags]    Regression    Payer Infromation  
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Progress Note Tab
    Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s
    Scroll And Click Element    ${progress_cancel_btn}
    Wait Until Page Does Not Contain    Add Progress Note    30s

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
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}