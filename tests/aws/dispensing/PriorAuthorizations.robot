*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Prior Authorizations
Test Setup    Test Setup View Patient History
Test Teardown    Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Clinic    DIS_PAS    report.label.owner: Hai Nguyen

*** Test Cases ***
Handle Prior Authorization After Creating Provider Order
	[Documentation]    DIS-16    DIS-17    DIS-18
	...    smoke    Prior Authorizations    
    ${pa_dict}    Create Prior Authorizations Dictionary
    Filter PA Navigate Mrn    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[mrn] 
    Edit Prior Authorizations Successfully    
        ...    po_num=${po_num}    
        ...    status=Approved
        ...    dict_arg=${pa_dict}    
        ...    type=Buy and Bill
    Open Document Popup In PA Page    ${po_num}  
    Verify Insurance Verification Details Displays Correctly    ${po_num}
    View PO Popup In PA Page    ${po_num}
    View Billing Invoice Report Successfully    
    Close Patient Billing Invoice Report In Report Reviewer Window    window_arg=${original_window}[1]

*** Keywords ***
Suite Setup Prior Authorizations
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Create Patient
    ${provider_dict}    Create Provider Order
    Set Suite Variable    ${po_num}    ${provider_dict.po_num}
    Go to Prior Authorization Page

Test Setup View Patient History
    Open New Window    title_arg=Prior Authorization Ledger
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[referring_provider]

Create Provider Order
    Go To Provider Orders Page
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[mrn] 
        ...    drug_arg=${data_input}[medication]  
        ...    refer_arg=${data_input}[referring_provider]
        ...    refer_to_arg=${data_input}[npi_number]
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    RETURN    ${provider_dict}
    
Open Document Popup In PA Page
    [Arguments]    ${po_num}
    Click Document Button In PA Page    ${po_num}
    Verify Document Popup Shows Remain Fields
    Common.Close Modal Popup