*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_011    patient    Admin

*** Test Cases ***
Verify That Clicking No Known Allergies Populates Default Values
    [Documentation]    Allergies-47    Allergies-48
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_no_known_btn}
    Page Alert Message    Encounter Note Allergy Updated!
    ${column_value_list}    Create List    No Known Allergies    No Known Allergies    Unknown    N/A    N/A
    ${allergies_new_row}    Set Variable    (//strong[contains(text(),"No Known Allergies")]//following::td[contains(text(),'No Known Allergies')]//following::td//span[contains(text(),'N/A')])//ancestor::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}

Verify That the Allergy Table Updates According to the Selected Value in the Filter Dropdown
    [Documentation]    Allergies-2    Allergies-3
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Create Fake Data List
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    Add New Allergy    onset_date_arg=${current_day}    allergies_detail_arg=${allergy_detail_txt}    msg=Encounter Note Allergy Updated!
    ${active_allergy}    Create List    ${PatientData.allergies_description_select}    ${PatientData.allergies_type_select}    ${PatientData.allergies_severity_select}    ${current_day}    ${Fake_dict.sentence_str}
    Set Test Variable    ${active_allergy}
    Create Fake Data List
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    Add New Allergy    onset_date_arg=${current_day}    allergies_detail_arg=${allergy_detail_txt}    msg=Encounter Note Allergy Updated!
    ${inactive_allergy}    Create List    ${PatientData.allergies_description_select}    ${PatientData.allergies_type_select}    ${PatientData.allergies_severity_select}    ${current_day}    ${Fake_dict.sentence_str}
    Set Test Variable    ${inactive_allergy}
    Set Test Variable    ${allergy_detail_txt}    ${inactive_allergy}[4]
    Inactive Allergy
    Wait Until Element Is Visible    ${allergies_status_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_select}    Viewing Inactive - Allergies Only
    ${allergies_new_row}    Replace Variables    ${allergies_new_row}
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${inactive_allergy}    allergies_row_arg=${allergies_new_row}
    Table Updates Both Active And Inactive Allergies When Filtering By Viewing All Allergies    allergy_active_detail_arg=${active_allergy}[4]    allergy_inactive_detail_arg=${inactive_allergy}[4]

Verify All Fields Are Visible And Have Defualt Value
    [Documentation]    Allergies-1    Allergies-4    Allergies-8    Allergies-21    Allergies-25    Allergies-28
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_new_btn}
    Verify All Fields Are Visible
    Verify All Fields Have Default Value
    
Verify Select Fields Display Dropdown Options Correctly
    [Documentation]    Allergies-5    Allergies-7    Allergies-26    Allergies-41
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_new_btn}
    Verify "Allergy Status" Dropdown Has Correct Values
    Verify "Select an Allergy Type" Dropdown Has Correct Values
    Verify "Select an Allergy Description" Dropdown Has Correct Values
    Verify "Allergy Severity" Dropdown Has Correct Values

Add New Allergy Unsuccessfully When Missing Required Fields
    [Documentation]    Allergies-6    Allergies-27    Allergies-31    Allergies-33
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_new_btn}
    Scroll And Click Element    ${allergies_add_btn}
    Page Alert Message    The Allergy Description is Required.
    Util.Select Random From List Regression    xpath_arg=${allergies_type_select}    var_name=allergies_type_select    dic=${PatientData}
    Scroll And Click Element    ${allergies_add_btn}
    Page Alert Message    The Allergy Description is Required.
    Scroll And Click Element    ${allergies_cancel_modal_btn}
    
    
Verify System Prevents Duplicate Or Empty Allergy Descriptions Within A Type
    [Documentation]    Allergies-16    Allergies-18
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_new_btn}
    Select Allergy Type Without Unknown Allergy
    Verify System Prevents Duplicate Or Allergy Descriptions

Create New Allergy Successfully With Required Fields
    [Documentation]    Allergies-32    Allergies-38    Allergies-39    Allergies-40
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Scroll And Click Element    ${allergies_new_btn}
    Select Allergy Type Without Unknown Allergy
    Select An Allergy Description
    Scroll And Click Element    ${allergies_add_btn}
    Page Alert Message    Encounter Note Allergy Updated!
    ${column_value_list}    Create List    ${PatientData.allergies_description_select}    ${PatientData.allergies_type_select}    Unknown    N/A    N/A
    ${allergies_new_row}    Set Variable    (//strong[contains(text(),"${PatientData.allergies_description_select}")]//following::td[contains(text(),'${PatientData.allergies_type_select}')]//following::td//span[contains(text(),'N/A')])//ancestor::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}

# Add New Allergy Unsuccessfully With Invalid Onset Date Field
#     [Documentation]    Allergies-23    Allergies-29    Allergies-24
#     [Tags]    Regression     Allergies
#     ...  allure.label.owner: Hai Nguyen
#     Navigate to Patient by Generated MRN
#     Open Allergies Tab
    # Create Fake Data List
    # Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
#     Add New Allergy    onset_date_arg=13/32/2000    allergies_detail_arg=${allergy_detail_txt}    msg=

Add New Allergy Successfully With All Fields
    [Documentation]    Allergies-35    Allergies-36    Allergies-37    Allergies-42
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Create Fake Data List
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    Add New Allergy    onset_date_arg=${current_day}    allergies_detail_arg=${allergy_detail_txt}    msg=Encounter Note Allergy Updated!
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_select}    Viewing Active - Allergies Only
    ${column_value_list}    Create List    ${PatientData.allergies_description_select}    ${PatientData.allergies_type_select}    ${PatientData.allergies_severity_select}    ${current_day}    ${Fake_dict.sentence_str}
    ${allergies_new_row}    Replace Variables    ${allergies_new_row}
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}

Perform Actions With Inactive Allergy
    [Documentation]    Allergies-43    Allergies-44
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Create Fake Data List
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    Add New Allergy    onset_date_arg=${current_day}    allergies_detail_arg=${allergy_detail_txt}    msg=Encounter Note Allergy Updated!
    Inactive Allergy
    Verify System Does Not Allow Reactivation
    
Edit Allergy Successfully With Valid Fields
    [Documentation]    Allergies-45    Allergies-46
    [Tags]    Regression     Allergies
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Allergies Tab
    Create Fake Data List
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    Add New Allergy    onset_date_arg=${current_day}    allergies_detail_arg=${allergy_detail_txt}    msg=Encounter Note Allergy Updated!
    Edit Allergy And Updated Data Is Reflected In The Table

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