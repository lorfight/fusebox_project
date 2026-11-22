*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Addresses Suite
Test Setup    Test Setup Patient Addresses Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_004    patient    Admin

*** Test Cases ***
Verify Create And Update Address In Corresponding Field
    [Documentation]    PAD-1    PAD-8    PAD-9
	[Tags]    Regression     Patient Addresses    report.label.owner: Hai Nguyen
    ${random_select}    PatientInformation.Select Random Patient Address    select_arg=-- Create New Address --
    ${AddressCreate_dict}    Create Patient Address
    Open Patient Addresses Tab
    Open Created Patient Address    address_arg=${AddressCreate_dict.address_first}
    ${AddressUpdate_dict}    PatientAddresses.Update Patient Address
    PatientInformation.Verify Created Address In Corresponding Field    dict_arg=${AddressUpdate_dict}    random_select=${random_select}

Create New Address Without Required Fields
    [Documentation]    PAD-2    PAD-3    PAD-4    PAD-5    PAD-6
	[Tags]    Regression     Patient Addresses    report.label.owner: Hai Nguyen
    ${random_select}    PatientInformation.Select Random Patient Address    select_arg=-- Create New Address --
    Click Create Address Button
    Common.Page Alert Message    Address Line is required!
    Click Close Address Button
    ${Fake_dict}    Generate Fake Data    sentence    address    country    postal_code
    ${AddressCreate_dict}    Create Address Create Dictionary
    ${error_list}    Create List    
        ...    Address Line is required!
        ...    City is required!
        ...    State is required!
        ...    Zip Code is required!
    FOR    ${error}    IN    @{error_list}
        ${random_select}    PatientInformation.Select Random Patient Address    select_arg=-- Create New Address --
        Input Description In Patient Address Popup    description_arg=${Fake_dict['sentence']} 
        Run Keyword If    "${error}" != "Address Line is required!"    Input Ship To Address Line 1 In Patient Address Popup    address_first_arg=${Fake_dict['address']}
        Input Ship To Address Line 2 In Patient Address Popup    address_second_arg=${Fake_dict['address']}
        Run Keyword If    "${error}" != "City is required!"    Input City In Patient Address Popup    city_arg=${Fake_dict['country']}   
        Run Keyword If    "${error}" != "State is required!"    Select State In Patient Address Popup    dict_arg=${AddressCreate_dict}
        Run Keyword If    "${error}" != "Zip Code is required!"    Input Postal Code In Patient Address Popup    postal_code_arg=${Fake_dict['postal_code']} 
        Select Country In Patient Address Popup    dict_arg=${AddressCreate_dict}
        Click Create Address Button
        Common.Page Alert Message    ${error}
        Click Close Address Button
    END

Remove Required Fields With An Existing Patient Address
    [Documentation]    PAD-11    PAD-12    PAD-13
	[Tags]    Regression     Patient Addresses    report.label.owner: Hai Nguyen
    ${random_select}    PatientInformation.Select Random Patient Address    select_arg=-- Create New Address --
    ${AddressCreate_dict}    Create Patient Address
    Open Patient Addresses Tab
    ${field_list}    Create List    
        ...    ${ship_to_address_line_1_input}
        ...    ${address_city_input}
        ...    ${address_state_select}
        ...    ${address_postal_code_input}
    
    ${error_list}    Create List    
        ...    Address Line is required!
        ...    City is required!
        ...    State is required!
        ...    Zip Code is required!

    FOR    ${field}    ${error}    IN ZIP    ${field_list}    ${error_list}
        Open Created Patient Address    address_arg=${AddressCreate_dict.address_first}
        PatientAddresses.Remove Required Field In Patient Address Popup    ${field}    ${error}
    END

Verify The Address Table Displays All Required Columns And Inactive Addresses Are Marked Correctly
    [Documentation]    PAD-16    PAD-17
	[Tags]    Regression     Patient Addresses    report.label.owner: Hai Nguyen
    ${random_select}    PatientInformation.Select Random Patient Address    select_arg=-- Create New Address --
    ${AddressCreate_dict}    Create Patient Address
    Open Patient Addresses Tab
    Check Table Displays All Required Columns
    Open Created Patient Address    address_arg=${AddressCreate_dict.address_first}
    PatientAddresses.Inactive Patient Address Row
    Verify Inactive Icon Is Visible With Corresponding Patient Address    address_arg=${AddressCreate_dict.address_first}

*** Keywords ***
Suite Setup Patient Addresses Suite
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

Test Setup Patient Addresses Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]