*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_005    patient    Admin

*** Test Cases ***
Verify The Vital Sign Table Displays All Columns
    [Documentation]    VS-1
	[Tags]    Regression     Vital Signs
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Vital Signs Tab
    Verify The Vital Sign Table Displays All Columns

Verify The Vital Signs Lines Are Ordered By Decreasing DOS
    [Documentation]    VS-4
	[Tags]    Regression     Vital Signs
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Multiple Appointments With 1 Office Visit    dict=${PatientData}
    Input Data In Procedural Details For All Created Normal Appointments
    Verify The Vital Signs Lines Are Ordered By Decreasing DOS

The Value Comlumns In Vital Signs Are Retreived From Values In Procedural Details
    [Documentation]    VS-2    VS-7    VS-9    VS-12    VS-15    VS-18    VS-21    VS-24    VS-27    VS-29    VS-31    VS-33
	[Tags]    Regression     Verify The Value Comlumns In Vital Signs Are Retreived
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Input Data In Treatment Note With Created APT
    Compare Values Of Vital Signs Tab With Procedural Details

Verify The Value Comlumns In Vital Signs Are Changed According To Changed Values In Procedural Details
    [Documentation]    VS-3    VS-8    VS-10    VS-13    VS-16    VS-19    VS-22    VS-25    VS-28    VS-30    VS-32    VS-34
	[Tags]    Regression     Verify The Value Comlumns In Vital Signs Are Changed
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Input Data In Treatment Note With Created APT
    Compare Values Of Vital Signs Tab With Procedural Details
    Input Data In Treatment Note With Created APT
    Compare Values Of Vital Signs Tab With Procedural Details

Verify Corresponding Vital Signs Line Removed When The Procedural Details Deleted
    [Documentation]    VS-6
	[Tags]    Regression     Verify Vital Signs Line Removed
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Input Data In Treatment Note With Created APT
    Compare Values Of Vital Signs Tab With Procedural Details
    Delete Procedural Details Line
    Verify Vital Signs Line Removed

Verify Blood Pressure Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-11
	[Tags]    Regression     Verify Blood Pressure Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Create Fake Data List
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${EMPTY}    heart_rate=${Fake_dict.demical_3d}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${Fake_dict.decimal_2d_2f}
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_blood_pressure_numerator}    compare_value=Not Entered

Verify Heart Rate Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-14
	[Tags]    Regression     Verify Heart Rate Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Create Fake Data List
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${EMPTY}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${Fake_dict.decimal_2d_2f}
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_heart_rate}    compare_value=Not Entered

Verify Resp Rate Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-17
	[Tags]    Regression     Verify Resp Rate Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Create Fake Data List
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${Fake_dict.demical_3d}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${EMPTY}     SPO2=${Fake_dict.decimal_2d_2f}
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_resp_rate}    compare_value=Not Entered

Verify Temperature Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-20
	[Tags]    Regression     Verify Temperature Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Create Fake Data List
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${Fake_dict.demical_3d}    temperature=${EMPTY}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${Fake_dict.decimal_2d_2f}
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_temperature_empty}    compare_value=Not Entered

Verify SpO2 Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-23
	[Tags]    Regression     Verify SpO2 Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Create Fake Data List
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${Fake_dict.demical_3d}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${EMPTY}
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_spo2}    compare_value=Not Entered

Verify O2 Flow Rate Is Not Entered When The Corresponding Column Has No Value In the Treatment Note
    [Documentation]    VS-26
	[Tags]    Regression     Verify O2 Flow Rate Is Not Entered
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Schedule Appointment Without PO And Office Visit    therapy=${PatientData.therapy1}
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    The O2 Flow Rate Column Has 0 Value In Vital Signs

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
    Set Suite Variable    ${therapy1}    ${data_input}[therapy1]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}    
    ...    therapy1=${therapy1}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}