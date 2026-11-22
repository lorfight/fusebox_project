*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Lab Tracker
Test Setup    Open New Window    title_arg=Appointment Ordering Ledger
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(1)    Clinic    DIS_LAB    allure.label.owner:Hai Nguyen

*** Test Cases ***
Lab Tracker Creation Process
	[Documentation]    DIS-19    DIS-20    DIS-21
	...    smoke    Lab Tracker
    AppointmentOrderingLedger.Go To Protocol Management Modal
    ${protocol_dict}    Create Protocol Dictionary
    ${protocol_dict}    Protocols.Select Lab Descirption In Protocol Management Modal
        ...    location_arg=${data_input}[location]
        ...    drug_arg=${data_input}[medication]   
        ...    assigned_lab_status=${False}
        ...    frequency_status=unselect
    Labtracker.Open Lab Tracker Ledger
    AddLabTracker.Open Add Lab Tracker Modal
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    ${Fake_dict}    Generate Fake Data    num_rand
    ${file_num_create}    Set Variable    ${Fake_dict['num_rand']}
    ${labtracker_dict}    AddLabTracker.Upsert Lab Tracker With All Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}
        ...    payer_arg=${data_input}[lab_payer] 
        ...    physician_arg=${data_input}[referring_npi_po]  
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    file_arg=${file_num_create}
        ...    result_date_arg=${result_date}
        ...    icd10_code_arg=${data_input}[icd10_codes] 
        ...    msg=Lab Tracker Created
    LabTracker.Filter Lab Tracker Following Mrn
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
    LabTrackerLedger.Open Lab Tracker Row    ${protocol_dict.assign_lab_txt}
    ${Fake_dict}    Generate Fake Data    num_rand
    ${file_num_update}    Set Variable    ${Fake_dict['num_rand']}
    ${labtracker_dict}    AddLabTracker.Upsert Lab Tracker With All Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}
        ...    payer_arg=${data_input}[lab_payer] 
        ...    physician_arg=${data_input}[referring_npi_po]  
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    file_arg=${file_num_update}
        ...    result_date_arg=${result_date}
        ...    icd10_code_arg=${data_input}[icd10_codes] 
        ...    msg=Lab Tracker Updated
    LabTrackerLedger.Open Lab Tracker Row    ${protocol_dict.assign_lab_txt}
    ${attribute_description_txt}    Create Attribute With All Fields    
        ...    value=random    
        ...    dict_arg=${labtracker_dict}    
    AddLabTracker.Show Empty Value In Lab Tracker Row
    AddLabTracker.Update Attribute With All Fields    
        ...    attribute_description_arg=${attribute_description_txt}
        ...    value=random
        ...    dict_arg=${labtracker_dict}    
    AddLabTracker.Delete Created Attributes
    Common.Close Modal Popup
    Open Documents Modal In Lab Tracker Ledger    ${protocol_dict.assign_lab_txt}    ${file_num_update}

*** Keywords ***
Suite Setup Lab Tracker
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Create Patient
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]

Open Documents Modal In Lab Tracker Ledger
    [Arguments]    ${assign_lab_txt}    ${file_num_arg}
    ${documents_btn}    Set Variable    (//div[@id="LabTrackerList"]//following-sibling::div[contains(text(),'${assign_lab_txt}')]//following::td/div[contains(text(),'${file_num_arg}')]//following::a[contains(text(),'Documents')])[1]
    Common.Scroll And Click Element    ${documents_btn}
    Documents.Verify Document Popup Shows Remain Fields
    Common.Close Modal Popup