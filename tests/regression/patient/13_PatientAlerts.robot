*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_013    patient    Admin

*** Test Cases ***
Verify date Field Format And Picker
	[Documentation]    PAlert-1    PAlert-2    PAlert-3    PAlert-4
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    ${current_date}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}    Subtract Time From Date    ${current_date}    2 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${current_date}    2 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Input Event Timestamp And Check Datepicker In PAlerts    ${start_date}    ${end_date}
    Verify The Date Fomat Is MM/DD/YYYY In PAlerts

Verify Patient Information Exists
    [Documentation]    PAlert-20
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Check Patient Field Correct Information
    ${PatientInfor_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${patientfield_popup}
    Should Be True    ${PatientInfor_disabled}

Verify Dropdown Contains Only
    [Documentation]    PAlert-21    PAlerts-23    PAlert-24
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Click Element    ${create_PAlerts}
    Verify Dropdown Has Only Option    
    ...    ${event_desc}    
    ...    ${event_desc_option}    
    ...    This is a Test Event Description
    Verify Dropdown Has Only Option    
    ...    ${priority}    
    ...    ${priority_option}    
    ...    Test High Priority
    Click Element    ${event_date}
	Check Field Event Date

Verify Error If Event Description Is Not Selected
    [Documentation]    PAlert-22    PAlert-25    PAlert-27    PAlert-28    PAlert-30
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Click Element    ${create_PAlerts}
    Check Error If Not Selected

Verify That Select Any Action Duration
    [Documentation]    PAlert-9    PAlert-10    PAlert-11    PAlert-13    PAlert-14    PAlert-26    PAlert-29    PAlert-31    PAlert-32
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Click Element    ${create_PAlerts}
    Wait Until Element Is Visible    ${patientfield_popup}
    Input Required Field In PAlert Popup
    Check Action Duration Options
	Verify Textarea Allows Max 255 Characters	${actionreason}    ${result_reason}
    Verify Completed Alerts Hide
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${showcomplete_checkbox}
    Verify Completed Alerts Visible
    Check The Patient Column
    Check The Event Column

Verify Alert No Action Duration
    [Documentation]   PAlert-12    PAlert-15    PAlert-16    PAlert-17    PAlert-18    PAlert-19    
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Create Patient Alerts No Action Reason And Get Datetime
    Check If Checkbox Is Not Checked
    Verify Completed Alerts Visible
    ${result}=    Get Text    ${completed_timestamp_column}
    Should Be Equal As Strings    ${result}    N/A
    Check Confirm Button Disable
    Check Completed Timestamp Column Updated    ${result_reason}

Verify System Displays Alerts Within The Selected Date Range
    [Documentation]    PAlert-5    PAlerts-6    PAlert-7
	[Tags]    Regression    Patient Alerts
    ...  allure.label.owner: Nga Phan
	Navigate to Patient by Generated MRN
	Open Patient Alerts Tab
    Create Patient Alerts Successfully
    Check Filter Alerts Using Both Start Date And End Date
    
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

