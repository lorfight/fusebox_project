*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_004    patient    Admin

*** Test Cases ***
Create New Address In Update Patient Page
    [Documentation]    PAD-1
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    
Create New Address With Blank Fields
    [Documentation]    PAD-3    PAD-4    PAD-5    PAD-6
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${EMPTY}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Line is required!
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${EMPTY}    zipcode=${Fake_dict.zip_fake}     error_message=City is required!
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${EMPTY}     error_message=Zip Code is required!
    Select Random Patient Address    select_arg=-- Create New Address --
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address1}    ${Fake_dict.address_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address2}    ${Fake_dict.address_fake}
    Wait Until Keywo rd Succeeds    30s    1s    Input Text    ${address_city}    ${Fake_dict.country_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_zipcode}    ${Fake_dict.zip_fake}
    Util.Select Random From List Regression    xpath_arg=${address_Country}    var_name=address_Country    dic=${PatientData}
    Click Element    ${address_create}
    Page Alert Message    State is required!
    Scroll And Click Element    ${address_close}

Verify Created Address In Corresponding Field
    [Documentation]    PAD-8
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    Verify Created Address In Corresponding Field

Edit An Existing Patient Address
    [Documentation]    PAD-9
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    Open Address Tab
    Edit Patient Address Row

Remove Required Fields With An Existing Patient Address
    [Documentation]    PAD-11    PAD-12    PAD-13    PAD-14
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    Open Address Tab
    Remove Required Fields In Patient Address Row

Inactive Addresses Are Marked Correctly
    [Documentation]    PAD-16
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    Open Address Tab
    Inactive Patient Address Row

Verify The Address Table Displays All Required Columns
    [Documentation]    PAD-17
	[Tags]    Regression     Address Tab
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Address Tab
    Check Table Displays All Required Columns

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
