*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With All Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_001    patient    Admin
*** Test Cases ***
Verify Patient
	[Documentation]    PaMan_TC106
	[Tags]    Regression    Verify Patient
    ...  allure.label.owner: Hai Nguyen
    Verify All Info Of Patient
Remove All Data Patient
    [Documentation]    PaMan_TC113    PaMan_TC115    PaMan_TC117
	[Tags]    Regression    Remove Value
    ...  allure.label.owner: Hai Nguyen
    Remove All Value Field In Update Patient
Verify Popup Is Visible When Deleting Patient
    [Documentation]    PaMan_TC119
	[Tags]    Regression    Delete Popup
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Scroll And Click Element    ${Delete_Patient_Link}
    Handle Alert    DISMISS
    Scroll And Click Element    ${cancel_btn}
Inactive Patient
	[Documentation]    PaMan_TC118
	[Tags]    Regression    Inactive Patient
    ...  allure.label.owner: Hai Nguyen
    Inactived Patient
    Actived Patient

# Update Patient
# 	[Documentation]    PaMan_TC114    PaMan_TC116
#     Skip
# 	[Tags]    Regression    Update Patient
#     ...  allure.label.owner: Hai Nguyen
#     Update All Info Patient

Create Patient Unsuccessfully When Not Input All Value
    [Documentation]    PaMan_TC97
	[Tags]    Regression    Invalid Input
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Clear Remain Fields
    Scroll And Click Element    ${Patients_Save_Btn}
    Verify Error Message Visible
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully When First Name Is Empty
    [Documentation]    PaMan_TC98
	[Tags]    Regression    First Name Is Empty
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Remain Fields
    Input Text    ${First_Name_Input}    ${EMPTY}
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The First Name field is required.
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully When Last Name Is Empty
    [Documentation]    PaMan_TC99
	[Tags]    Regression    Last Name Is Empty
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Remain Fields
    Input Text    ${Last_Name_Input}    ${EMPTY}
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Last Name field is required.
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully When MRN Is Empty
    [Documentation]    PaMan_TC100
	[Tags]    Regression    MRN Is Empty
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Remain Fields
    Input Text    ${MRN_Input}    ${EMPTY}
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Medical Record # field is required.
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully When DOB Is Empty
    [Documentation]    PaMan_TC107
	[Tags]    Regression    DOB Is Empty
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Remain Fields
    Input Text    ${DOB_Input}    ${EMPTY}
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Date Of Birth field is required.
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully When Gender Is Empty
    [Documentation]    PaMan_TC109
	[Tags]    Regression    Gender Is Empty
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Remain Fields
    Select From List By Label    ${Gender_Select}    -- Select a Gender --
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Gender field is required.
    Scroll And Click Element    ${cancel_btn}

Verify Gender Field Show Value Correctly
    [Documentation]    PaMan_TC108
	[Tags]    Regression    Gender Field Value
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    ${gender_list}    Get List Items    ${Gender_Select}
    Should Contain    ${gender_list}    Male
    Should Contain    ${gender_list}    Female
    Should Contain    ${gender_list}    Other
    Scroll And Click Element    ${cancel_btn}

Create Patient With Already MRN
    [Documentation]    PaMan_TC101    PaMan_TC102
	[Tags]    Regression    Already MRN
    ...  allure.label.owner: Hai Nguyen
    Go To Create New Patient Page
    Input Text    ${MRN_Input}    ${PatientData.MRN}
    Input Text    ${DOB_Input}    ${Fake_dict.DOB_fake}
    Click Button    ${Close_Calendar_Btn}
    Wait Until Page Contains    A patient within your network already contains the MRN: ${PatientData.MRN}
    Wait Until Page Contains    Account: ${PatientData.account_name1}
    Wait Until Keyword Succeeds    30s    1    Click Element    ${close_modal_btn}
    Input Remain Fields
    Input Text    ${MRN_Input}    ${PatientData.MRN}
    Wait Until Keyword Succeeds    30s    1    Scroll And Click Element    ${Patients_Save_Btn}
    ${check_error}    Run Keyword And Return Status    Wait Until Page Contains    The MRN you are trying to use already exists within another patient.
    IF    '${check_error}' == '${False}'
        Wait Until Page Contains    A patient within your network already contains the MRN: ${PatientData.MRN} Account: ${PatientData.account_name1}
    END
    Wait Until Keyword Succeeds    30s    1    Scroll And Click Element    ${cancel_btn}

Select Home Phone And Personal/Home Phone Field Is Blank
    [Documentation]    PaMan_TC110
	[Tags]    Regression    Personal/Home Phone Field Is Blank
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    Go To Create New Patient Page
    Input Remain Fields
    Select Home Phone And Personal/Home Phone Field Is Blank
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Phone field is required
    Scroll And Click Element    ${cancel_btn}

Select Cellphone And Cellphone Field Is Blank
    [Documentation]    PaMan_TC111
	[Tags]    Regression    Cellphone Field Is Blank
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    Go To Create New Patient Page
    Input Remain Fields
    Select Cellphone And CellPhone Field Is Blank
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Cellphone field is required
    Scroll And Click Element    ${cancel_btn}

Select Email And Email Field Is Blank
    [Documentation]    PaMan_TC112
	[Tags]    Regression    Email Field Is Blank
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    Go To Create New Patient Page
    Input Remain Fields
    Select Email And Email Field Is Blank
    Scroll And Click Element    ${Patients_Save_Btn}
    Wait Until Page Contains    The Email field is required
    Scroll And Click Element    ${cancel_btn}

# Compare Qty Of Patient Addresses Tab
#     [Documentation]
# 	[Tags]    Regression    Compare data badges and buttons in patient page
#     ...  allure.label.owner: Hai Nguyen
#     Get Qty Address Line In Patient Addresses Tab
#     Get Qty Of Tabs In Patient Page    tab_arg=${addreses_btn}
#     Should Be Equal As Numbers    ${numbers}    ${row_count}

# Compare Qty Of Payer Information Tab
#     [Documentation]
# 	[Tags]    Regression    Compare data badges and buttons in patient page
#     ...  allure.label.owner: Hai Nguyen
#     Get Qty Address Line In Payer Information Tab
#     Get Qty Of Tabs In Patient Page    tab_arg=${payers_btn}
#     Should Be Equal As Numbers    ${numbers}    ${row_count}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${account_name1}    ${data_input}[account_name1]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    account_name1=${account_name1}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}