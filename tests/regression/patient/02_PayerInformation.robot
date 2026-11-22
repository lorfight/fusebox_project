*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_002    patient    Admin

*** Test Cases ***
Create Payer Info Without Select A Plan
    [Documentation]    PI-1    PI-2    PI-3
	[Tags]    Regression    Payer Infromation
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Scroll And Click Element    ${payer_create_btn}
    Page Alert Message    A selected plan is required!
    Scroll And Click Element    ${payer_close_btn}

Subscriber Num Is Empty In Medical Payer
    [Documentation]    PI-4
	[Tags]    Regression    Subscriber Num Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_medical}    Create Dictionary
    Set Suite Variable    ${new_medical}
    Fill Medical Info    subscriber=${EMPTY}    group=${num_rand}    dict=${new_medical}    btn_arg=${payer_create_btn}
    Page Alert Message    A Certificate # is required!
    Scroll And Click Element    ${payer_close_btn}

Group Num Is Empty In Medical Payer
    [Documentation]    PI-5
	[Tags]    Regression    Group Num Is Empty
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_medical}    Create Dictionary
    Set Suite Variable    ${new_medical}
    Fill Medical Info    subscriber=${num_rand}    group=${EMPTY}    dict=${new_medical}    btn_arg=${payer_create_btn}
    Page Alert Message    Insurance Plan successfully Assigned to the Patient.
    Remove Payer Plan    status=ACCEPT

Subscriber Num Is Empty In Pharmacy Payer
    [Documentation]    PI-6
	[Tags]    Regression    Subscriber Num Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Pharmacy Info    subscriber=${EMPTY}    group=${num_rand}    bin=${num_rand}    pcn=${num_rand}    rxgroup=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Page Alert Message    A Certificate # is required!
    Scroll And Click Element    ${payer_close_btn}

Group Num Is Empty In Pharmacy Payer
    [Documentation]    PI-7
	[Tags]    Regression    Group Num Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Pharmacy Info    subscriber=${num_rand}    group=${EMPTY}    bin=${num_rand}    pcn=${num_rand}    rxgroup=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Page Alert Message    A Group # is required!
    Scroll And Click Element    ${payer_close_btn}

BIN Num Is Empty In Pharmacy Payer
    [Documentation]    PI-8
	[Tags]    Regression    BIN Num Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Pharmacy Info    subscriber=${num_rand}    group=${num_rand}    bin=${EMPTY}    pcn=${num_rand}    rxgroup=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Page Alert Message    A BIN # is required!
    Scroll And Click Element    ${payer_close_btn}

Rx PCN Num And Rx Group Num Are Empty In Medical Payer
    [Documentation]    PI-9
	[Tags]    Regression    Rx PCN Num And Rx Group Num Are Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Pharmacy Info    subscriber=${num_rand}    group=${num_rand}    bin=${num_rand}    pcn=${EMPTY}    rxgroup=${EMPTY}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Page Alert Message    Insurance Plan successfully Assigned to the Patient.
    Remove Payer Plan    status=ACCEPT

Effective Date Is Empty In Payer Plan
    [Documentation]    PI-10
	[Tags]    Regression    Effective Date Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Medical Info    subscriber=${num_rand}    group=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Scroll And Click Element    ${payer_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${pharmacy_effective_date}    ${EMPTY}
    Scroll And Click Element    ${payer_update_btn}
    Page Alert Message    An effective date is required!
    Scroll And Click Element    ${payer_close_btn}
    Remove Payer Plan    status=ACCEPT

Expiration Date Is Empty In Payer Plan
    [Documentation]    PI-11
	[Tags]    Regression    Expiration Date Is Empty    
    ...  allure.label.owner: Hai Nguyen
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Add Payer
    Select Plan
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Medical Info    subscriber=${num_rand}    group=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_create_btn}
    Scroll And Click Element    ${payer_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${pharmacy_expiration_date}    ${EMPTY}
    Scroll And Click Element    ${payer_update_btn}
    Page Alert Message    Insurance Plan successfully Assigned to the Patient.
    Remove Payer Plan    status=ACCEPT
    
Edit And Remove Payer Plan
    [Documentation]    PI-12    PI-13    PI-14    30381-6
	[Tags]    Regression    Payer Infromation
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Edit Medical Payer Plan
    Verify Expand Or Collapse Changelog Table
    Remove Payer Plan    status=DISMISS
    Remove Payer Plan    status=ACCEPT

Verify Patient Information In Changelog
    [Documentation]    30381-3
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Verify Patient Information In Changelog
    Remove Payer Plan    status=ACCEPT

Verify Expand Or Collapse Functionality of Changelog Table
    [Documentation]    30381-4
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Edit Medical Payer Plan
    Verify Expand Or Collapse Changelog Table
    Remove Payer Plan    status=ACCEPT

Verify Changes Are Listed In Chronological Order
    [Documentation]    30381-5
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    RePatient.Get User Name
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    FOR    ${i}    IN RANGE    1    4
        Edit Medical Payer Plan
        Check Medical Plan In Changelog
        Set Suite Variable    ${old_medical}    ${new_medical}
    END

Verify Changelog Table Sorting and Display
    [Documentation]    30381-6
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Check Message For Changelog Display
    Edit Medical Payer Plan
    Check Message For Changelog Display
    Remove Payer Plan    status=ACCEPT
    Check Message For Changelog Display

Verify Changelog Table When Edit Medical Payer Plan
    [Documentation]    30381-7
	[Tags]    Regression    Payer Infromation
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    RePatient.Get User Name
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Edit Medical Payer Plan
    Check Medical Plan In Changelog
    Remove Payer Plan    status=ACCEPT
    
Verify Changelog Table When Edit Pharmacy Payer Plan
    [Documentation]    30381-8    30381-10
	[Tags]    Regression    Payer Infromation
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    RePatient.Get User Name
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Pharmacy Plan
    Edit Pharmacy Payer Plan
    Check Pharmacy Plan In Changelog
    Remove Payer Plan    status=ACCEPT

Verify Changelog Table When Inactive Payer Plan
    [Documentation]    30381-9    30381-10
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    RePatient.Get User Name
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Inactive Payer Plan
    Check Inactive In Changelog
    Remove Payer Plan    status=ACCEPT

Verify Changelog Table When Update Without Data
    [Documentation]    30381-11
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Scroll And Click Element    ${payer_edit_btn}
    Scroll And Click Element    ${payer_update_btn}
    Check Message For Changelog Display
    Remove Payer Plan    status=ACCEPT

Verify Expandable OR Collapsible Changelog Table When Create New Payer
    [Documentation]    30381-12
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Verify Expand Or Collapse Changelog Table
    
Verify Changelog Table When Remove Payer
    [Documentation]    30381-13
	[Tags]    Regression    Payer Infromation    
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    Remove Payer Plan    status=ACCEPT
    Check Message For Changelog Display

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