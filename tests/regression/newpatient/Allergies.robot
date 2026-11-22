*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Allergies Suite
Test Setup    Test Setup Allergies Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_011    patient    Admin

*** Test Cases ***
Verify That Clicking No Known Allergies Populates Default Values
    [Documentation]    Allergies-47    Allergies-48
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Click No Known Allergies Button
    ${column_value_list}    Create List    No Known Allergies    No Known Allergies    Unknown    N/A    N/A
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${no_known_allergies_row}

Verify That the Allergy Table Updates According to the Selected Value in the Filter Dropdown
    [Documentation]    Allergies-2    Allergies-3
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    ${current_day}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=${data_input}[utc]
    # Create Active Allergy
    ${Fake_dict}    Generate Fake Data    sentence
    ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
    ${active_allergy_dict}    Add New Allergy    
        ...    onset_date_arg=${current_day}    
        ...    allergies_detail_arg=${allergy_detail_txt}    
        ...    msg=Encounter Note Allergy Updated!

    ${active_allergy}    Create List    
        ...    ${active_allergy_dict.allergies_description}    
        ...    ${active_allergy_dict.allergies_type}    
        ...    ${active_allergy_dict.allergies_severity}    
        ...    ${active_allergy_dict.onset_date}    
        ...    ${active_allergy_dict.allergies_detail} 
    # Create Inactive Allergy
    ${Fake_dict}    Generate Fake Data    sentence
    ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
    ${inactive_allergy_dict}    Add New Allergy    
        ...    onset_date_arg=${current_day}    
        ...    allergies_detail_arg=${allergy_detail_txt}    
        ...    msg=Encounter Note Allergy Updated!
  
    ${inactive_allergy}    Create List    
        ...    ${inactive_allergy_dict.allergies_description}    
        ...    ${inactive_allergy_dict.allergies_type}    
        ...    ${inactive_allergy_dict.allergies_severity}    
        ...    ${inactive_allergy_dict.onset_date}    
        ...    ${inactive_allergy_dict.allergies_detail} 
    #Inactive Allergy
    ${allergy_detail_txt}    Set Variable    ${inactive_allergy}[4]
    Inactive Allergy    ${allergy_detail_txt}    ${inactive_allergy_dict}
    #Filter Allergy
    Filter Allergy Active Status    Viewing Inactive - Allergies Only
    ${allergies_new_row}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//parent::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${inactive_allergy}    allergies_row_arg=${allergies_new_row}
    Table Updates Both Active And Inactive Allergies When Filtering By Viewing All Allergies    allergy_active_detail_arg=${active_allergy}[4]    allergy_inactive_detail_arg=${inactive_allergy}[4]

Verify All Fields Are Visible And Have Defualt Value
    [Documentation]    Allergies-1    Allergies-4    Allergies-8    Allergies-21    Allergies-25    Allergies-28
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Open New Allergy Table
    Verify All Fields Are Visible
    ${allergy_dict}    Create Allergies Dictionary
    Verify All Fields Have Default Value    dict_arg=${allergy_dict}
    
Verify Select Fields Display Dropdown Options Correctly
    [Documentation]    Allergies-5    Allergies-7    Allergies-26    Allergies-41
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Open New Allergy Table
    Verify "Allergy Status" Dropdown Has Correct Values
    Verify "Select an Allergy Type" Dropdown Has Correct Values
    ${allergy_dict}    Create Allergies Dictionary
    Verify "Select an Allergy Description" Dropdown Has Correct Values    dict_arg=${allergy_dict}
    Verify "Allergy Severity" Dropdown Has Correct Values

Add New Allergy Unsuccessfully When Missing Required Fields
    [Documentation]    Allergies-6    Allergies-27    Allergies-31    Allergies-33
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Open New Allergy Table
    Click Add Allergy Button
    Common.Page Alert Message    The Allergy Description is Required.
    ${allergy_dict}    Create Allergies Dictionary
    Select Allergy Type Without Unknown Allergy    dict_arg=${allergy_dict}
    Click Add Allergy Button
    Common.Page Alert Message    The Allergy Description is Required.
    Click Cancel Allergy Popup
    
Verify System Prevents Duplicate Or Empty Allergy Descriptions Within A Type
    [Documentation]    Allergies-16    Allergies-18
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Open New Allergy Table
    ${allergy_dict}    Create Allergies Dictionary
    Select Allergy Type Without Unknown Allergy    dict_arg=${allergy_dict}
    Verify System Prevents Duplicate Or Allergy Descriptions

Create New Allergy Successfully With Required Fields
    [Documentation]    Allergies-32    Allergies-38    Allergies-39    Allergies-40
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    Open New Allergy Table
    ${allergy_dict}    Create Allergies Dictionary
    Select Allergy Type Without Unknown Allergy    dict_arg=${allergy_dict}
    Select An Allergy Description    dict_arg=${allergy_dict}
    Click Add Allergy Button
    Common.Page Alert Message    Encounter Note Allergy Updated!
    ${column_value_list}    Create List    
        ...    ${allergy_dict.allergies_description}    
        ...    ${allergy_dict.allergies_type}    
        ...    Unknown    
        ...    N/A    
        ...    N/A
    ${allergies_new_row}    Set Variable    (//strong[contains(text(),"${allergy_dict.allergies_description}")]//following::td[contains(text(),'${allergy_dict.allergies_type}')]//following::td//span[contains(text(),'N/A')])//ancestor::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}

# Add New Allergy Unsuccessfully With Invalid Onset Date Field
#     [Documentation]    Allergies-23    Allergies-29    Allergies-24
#     [Tags]    Regression     Allergies
#    report.label.owner: Hai Nguyen
    # ${Fake_dict}    Generate Fake Data    sentence
    # ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
#     Add New Allergy    onset_date_arg=13/32/2000    allergies_detail_arg=${allergy_detail_txt}    msg=

Add New And Edit Allergy Successfully
    [Documentation]    Allergies-35    Allergies-36    Allergies-37    Allergies-42    Allergies-45    Allergies-46
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    sentence
    ${current_day}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=${data_input}[utc]
    ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
    ${allergy_dict}    Add New Allergy    
        ...    onset_date_arg=${current_day}    
        ...    allergies_detail_arg=${allergy_detail_txt}    
        ...    msg=Encounter Note Allergy Updated!
    Filter Allergy Active Status    Viewing Active - Allergies Only
    ${column_value_list}    Create List    
        ...    ${allergy_dict.allergies_description}    
        ...    ${allergy_dict.allergies_type}    
        ...    ${allergy_dict.allergies_severity}    
        ...    ${allergy_dict.onset_date}    
        ...    ${allergy_dict.allergies_detail} 
    ${allergies_new_row}    Set Variable    //td[contains(text(),"${allergy_detail_txt}")]//parent::tr
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}
    Edit Allergy And Updated Data Is Reflected In The Table    ${allergy_detail_txt}    ${allergy_dict}

Perform Actions With Inactive Allergy
    [Documentation]    Allergies-43    Allergies-44
    [Tags]    Regression     Allergies    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    sentence
    ${current_day}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=${data_input}[utc]
    ${allergy_detail_txt}    Set Variable    ${Fake_dict['sentence']} 
    ${allergy_dict}    Add New Allergy    
        ...    onset_date_arg=${current_day}    
        ...    allergies_detail_arg=${allergy_detail_txt}    
        ...    msg=Encounter Note Allergy Updated!
    Inactive Allergy    ${allergy_detail_txt}    ${allergy_dict}
    Verify System Does Not Allow Reactivation    ${allergy_detail_txt}
    
*** Keywords ***
Suite Setup Allergies Suite
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

Test Setup Allergies Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Allergies Tab
