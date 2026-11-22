*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup EMR Account
Test Setup    Test Setup EMR Account
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Prime_physician    ADM_EAS

*** Test Cases ***
Verify EMR Tools / Settings Page Opens Successfully And Displays All Configuration Sections
    [Documentation]    ADM-30    Smoke     EMR Tools / Settings
    [Tags]    report.label.owner: Hai Nguyen
    Verify EMR Tools / Settings Displays All Configuration Sections

Add / Remove EMR Medication Mapping
    [Documentation]    ADM-31    Smoke     Medication Type
    [Tags]    report.label.owner: Hai Nguyen
    Open Medication Type Tab
    ${Fake_dict}    Generate Fake Data    sentence
    Create Emr Medication Mapper
        ...    proprietary_name_arg=${Fake_dict['sentence']}
        ...    medication_arg=${data}[medication]
        ...    calendar_color_arg=#8fce00
        ...    text_color_arg=#f44336
    Remove Emr Medication Mapper    proprietary_name_arg=${Fake_dict['sentence']}

Add / Remove EMR Event Type Mapper
    [Documentation]    ADM-32    Smoke     Event Type
    [Tags]    report.label.owner: Hai Nguyen
    Open Event Type Tab
    ${Fake_dict}    Generate Fake Data    sentence    num_rand
    Create Emr Event Type    
        ...    code_arg=${Fake_dict['num_rand']}
        ...    description_arg=${Fake_dict['sentence']}
        ...    medication_arg=${data}[medication]    
        ...    category_arg=${data}[category]
    Remove Emr Event Type    code_arg=${Fake_dict['num_rand']}

Adjust Location Description
    [Documentation]    ADM-33    Smoke     Location Type
    [Tags]    report.label.owner: Hai Nguyen
    Open Location Type Tab
    Filter Adjust Location Descriptions Options    location_name_arg=Chair    count_arg=10
    ${Fake_dict}    Generate Fake Data    sentence    num_rand
    Update Location Description    
        ...    location_name_arg=Chair    
        ...    category_arg=${Fake_dict['num_rand']}   
        ...    description_arg=${Fake_dict['sentence']}
    Clear Location Description    
        ...    location_name_arg=Chair    
        ...    category_arg=${EMPTY}  
        ...    description_arg=${EMPTY}

Update EMR Nurse Schedule
    [Documentation]    ADM-34    Smoke     Employee Scheduling
    [Tags]    report.label.owner: Hai Nguyen
    Open Employee Scheduling Tab
    Filter Employee Scheduling Options    number_arg=10
    Update Nurse Scheduling    number_arg=1    max_range=10

Add / Update / Remove EMR Cancelation Code
    [Documentation]    ADM-35    Smoke     EMR Cancelation Codes
    [Tags]    report.label.owner: Hai Nguyen
    Open EMR Cancelation Codes Tab
    ${Fake_dict}    Generate Fake Data    num_rand
    ${create_code_value}    Set Variable    ${Fake_dict['num_rand']}
    Create EMR Cancelation Code    code_arg=${create_code_value}
    ${Fake_dict}    Generate Fake Data    num_rand
    ${update_code_value}    Set Variable    ${Fake_dict['num_rand']}
    Update EMR Cancelation Code    code_arg=${create_code_value}    new_code_value_arg=${update_code_value}
    Reload Page
    Open EMR Cancelation Codes Tab
    Delete EMR Cancelation Code    code_arg=${update_code_value}

*** Keywords ***
Suite Setup EMR Account
    ${data}    Get Data
    Set Suite Variable    ${data}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Go To EMR Account Setup
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Set Configs For Emr Tools    
        ...    location_arg=${data}[account]    
        ...    emr_mapping_arg=${data}[emr_mapping]    
        ...    account_id_arg=0

Test Setup EMR Account
    Open New Window    title_arg=EMR Account Setup
    Common.Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']
