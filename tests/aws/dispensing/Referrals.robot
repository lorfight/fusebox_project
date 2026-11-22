*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Referrals
Test Setup    Open New Window    title_arg=Referrals
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_REF    report.label.owner: Hai Nguyen

*** Test Cases ***
CRUD And Confirm Referral Is Visible In Referrals List
	[Documentation]    DIS-9    DIS-10
	...    smoke    Referrals    
    Filter By Location In Referrals Page    ${data_input}[location]
    Referrals.Click Clear Patient Button
    ${referral_number}    ${number_of_visits}    ${dosage}    Prepare Data For Referral
    Set Test Variable    ${referral_number}
    ${start_date}    ${end_date}    Set Start Date And End Date Data
    ${referrals_dict}    Create A Referral    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[mrn]   
        ...    referring_provider_arg=${data_input}[refering_provider]    
        ...    dx_code_arg=${data_input}[dx_code]      
        ...    refer_to_provider_arg=${data_input}[refer_to_provider]      
        ...    referral_number_arg=${referral_number}    
        ...    number_of_visits_arg=${number_of_visits}    
        ...    start_date_arg=${start_date}    
        ...    end_date_arg=${end_date}    
        ...    medication_arg=${data_input}[medication]         
        ...    dosage_arg=${dosage}   
        ...    npi_arg=${data_input}[npi] 
    Set Test Variable    ${referrals_dict}
    Filter Options To Find Referral Row    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[mrn] 
        ...    status_arg=${referrals_dict.referral_status}
        ...    start_date_arg=${start_date} 
        ...    end_date_arg=${end_date}
    Referrals.Click Search Button
    Verify Referral Is Visible In Referrals List
    ${updated_referral_number}    ${updated_number_of_visits}    ${updated_dosage}    Prepare Data For Referral
    Open Created Referral Row    ${referral_number}
    Edit A Referral    
        ...    dict_arg=${referrals_dict}   
        ...    dx_code_arg=${data_input}[dx_code_second]       
        ...    referral_number_arg=${updated_referral_number}    
        ...    medication_arg=${data_input}[medication_second]      
        ...    dosage_arg=${updated_dosage}    
        ...    npi_arg=${data_input}[npi]   
    Filter Options To Find Referral Row    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[mrn] 
        ...    status_arg=${referrals_dict.referral_status}
        ...    start_date_arg=${start_date} 
        ...    end_date_arg=${end_date}   
    Referrals.Click Search Button 
    Verify Updated Referral Is Visible    ${updated_referral_number}
    Open Documents Popup Navigate Referral And Review Content    ${updated_referral_number}

*** Keywords ***
Suite Setup Referrals
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]
    Set Suite Variable    ${PatientCreate}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Go To Referrals Page

Open Documents Popup Navigate Referral And Review Content
    [Arguments]    ${referral_number}
    ${documents_btn}    Set Variable    (//td[span[text()='${referral_number}']]//following::a[contains(text(),'Documents')])[1]
    Common.Scroll And Click Element    ${documents_btn}
    Verify Document Popup Shows Remain Fields

Verify Referral Is Visible In Referrals List
    ${referral_number_column}    Check Referral Number Column    ${referral_number}
    Check Expires In Column    
        ...    referral_number_column=${referral_number_column}    
        ...    start_date_arg=${referrals_dict.start_date}
        ...    end_date_arg=${referrals_dict.end_date}
    Check Patient Column    
        ...    referral_number_column=${referral_number_column}    
        ...    expected_patient_name_value=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name}
    Check Number Of Visits Column    
        ...    referral_number_column=${referral_number_column}
        ...    expect_number_of_visits=${referrals_dict.number_of_visits}
    Check Provider Column
        ...    referral_number_column=${referral_number_column}
        ...    expected_provider=${referrals_dict.provider}
    Check Status Column
        ...    referral_number_column=${referral_number_column}
        ...    expected_referral_status=${referrals_dict.referral_status}
    Check DX Code Column
        ...    referral_number_column=${referral_number_column}
        ...    expected_dx_code=${referrals_dict.dx_code}
