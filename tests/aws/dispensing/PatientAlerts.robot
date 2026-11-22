*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Alerts
Test Setup    Open New Window    title_arg=Patient Alerts
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_PAL    report.label.owner: Hai Nguyen

*** Test Cases ***
Create Patient Alerts Successfully
	[Documentation]    DIS-25    DIS-26
	...    smoke    Patient Alerts    
    Filter By Location In Patient Alerts Page    location_arg=${data_input}[location]
    ${current_date}    Get Current Date    result_format=%m/%d/%Y
    ${Fake_dict}    Generate Fake Data    sentence
    ${expected_datetime}    ${expected_plus_1}    ${event_description_txt}    ${priority_txt}    ${duration_value}    Create New Patient Alert    
        ...    mrn_arg=${data_input}[mrn]
        ...    date_arg=${current_date}    
        ...    action_reason_txt=${Fake_dict['sentence']}
        ...    utc=${data_input}[utc]
    Filter By Patient In Patient Alerts Page    mrn_arg=${data_input}[mrn]
    ${start_date}    ${end_date}    Handle Data Timestamp
    Filter By Event Timesptamp In Patient Alerts Page    ${start_date}    ${end_date}
    Click Show Completed Checkbox In Patient Alerts Page    expected_status=true
    ${user_name_txt}    Common.Get User Name
    ${completed_timestamp_column}    ${completed_timestamp_value}    Check Completed Timesptamp Column In Patient Alerts List    ${expected_datetime}    ${expected_plus_1}    ${user_name_txt}
    ${event_timestamp_value}    Set Variable    ${completed_timestamp_value}
    Check Event Timesptamp Is Visible    ${completed_timestamp_column}    ${event_timestamp_value}    
    Check Patient Column In Patient Alerts List    ${completed_timestamp_column}    MRN: ${data_input}[mrn]
    Check Event Column In Patient Alerts List    ${completed_timestamp_column}    ${event_description_txt}\nPriority: ${priority_txt}
    Check Action Duration Column In Patient Alerts List    ${completed_timestamp_column}    ${duration_value}
    Check Reason Column In Patient Alerts List    ${completed_timestamp_column}    ${Fake_dict['sentence']}

*** Keywords ***
Suite Setup Patient Alerts
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Go To Patient Alerts Page
