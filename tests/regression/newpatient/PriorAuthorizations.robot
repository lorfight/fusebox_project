*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Provider Orders Suite
Test Setup    Test Setup Provider Orders Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_009    patient    Admin

*** Test Cases ***
Verify PA Regression    #Navigate To PA Modal
    [Documentation]    PA_1    PA_2    PA_3    PA_4    PA_5    PA_6    PA_7    PA_8    PA_9    PA_10    PA_11
                ...    PA_12    PA_13    PA_14    PA_15    PA_16    PA_17    PA_18    PA_19    PA_20    PA_21
                ...    PA_22    PA_23    PA_25    PA_30    PA_31    PA_32    PA_33    PA_34    PA_35    PA_36
                ...    PA_37    PA_38    PA_39    PA_40    PA_41    PA_42    PA_43    PA_45    PA_46    PA_47
                ...    PA_48    PA_49    PA_50    PA_51    PA_52    PA_53    PA_54    PA_55    PA_56    PA_ 57   
                ...    PA_67    PA_76    PA_77    PA_78    PA_79    PA_80    PA_81    PA_82    PA_83    PA_84
                ...    PA_85    PA_93    PA_94    PA_95    PA_96    PA_97    PA_98    PA_99    PA_100    PA_101    PA_102
    [Tags]    Regression    Vu Nguyen    normal    Patient    Prior Authorization    Nagivate To PA Modal
    Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO All Fields    
        ...    location_arg=${data_input}[location]  
        ...    mrn_arg=${data_input}[patient_mrn]  
        ...    drug_arg=${data_input}[drug_po]  
        ...    refer_arg=${data_input}[refering_provider]  
        ...    refer_to_arg=${data_input}[referring_npi_po]  
        ...    patient_weight_arg=70
        ...    patient_height_arg=30
        ...    dosageAssignedValue_arg=10
        ...    calculated_dosage_arg=10
        ...    requested_dose_arg=10
        ...    splitDoseValue_arg=10
    Set Suite Variable    ${provider_dict}
    ${cpt_line_count}    ${cpt_code_txt}    Get Provider Orders Data    ${provider_dict.po_num}
    Open Payer Information Tab
    ${primary_payer_dict}    PayerInformation.Create A New Medical Payer Plan    ${data_input}[utc]
    ${pa_dict}    Create Prior Authorizations Dictionary
    Set Suite Variable    ${pa_dict}
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    Priorauthorizations.Hanlde Provider Order MDF 
    Priorauthorizations.Handle PA Status and Confirmation    
        ...    status_list=${data_input}[pa_green_status]
        ...    startdate_arg=${provider_dict.start_date}    
        ...    enddate_arg=${provider_dict.exp_date}    
        ...    authdate_arg=${provider_dict.entry_date}   
        ...    dict_arg=${pa_dict}
    # Priorauthorizations.Handle Payor Information and Margin Calculator    payer_name_arg=${primary_payer_dict.plan_payer_name}
    Priorauthorizations.Handle Notes     utc=${data_input}[utc]
    Priorauthorizations.Handle Coding Details     ${cpt_line_count}    ${cpt_code_txt}
    Priorauthorizations.Handle Addtional Tools
    Priorauthorizations.View PA Changelog
    Priorauthorizations.Click Update Button
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Prior Authorization Successfully Updated!    5s
    IF    "${check_msg}" == "${False}"
        Add Medical Payer Plan
            ...    number_arg=123
            ...    date_arg=${provider_dict.start_date}
        Priorauthorizations.Click Update Button
        Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    END
    Common.Close Modal Popup
    Click Edit PA Button    ${provider_dict.po_num}
    Verify PA General Section Visible
    Verify PA Provider Order MDF Section Visible
    Verify PA Status and Confirmation Section Visible
    Verify Payor Information and Margin Calculator Section Visible

*** Keywords ***
Suite Setup Provider Orders Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    Set Suite Variable    ${PatientCreate}
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${original_window}    Get Window Handles
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Provider Orders Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]

Get Provider Orders Data
    [Arguments]    ${po_num}
    Click Edit PO    ${po_num}
    ${cpt_lines}    Set Variable    //*[@id='AssignableCPTCodeList']//*[contains(@class,'CleanHeader') and contains(text(),'CPT Code')]/ancestor::*[2]/*[not(@style)][*]
    ${cpt_line_count}    SeleniumLibrary.Get Element Count    ${cpt_lines}
    ${cpt_ckbx}    Set Variable    //*[@id='AssignableCPTCodeList']//*[contains(@class,'CleanHeader') and contains(text(),'CPT Code')]/ancestor::*[2]/*[not(@style)][1]//*[contains(@onclick,'Toggle')]
    Common.Scroll And Click Element    ${cpt_ckbx}
    Common.Page Alert Message    Successfully Assigned CPT Code
    ${cpt_code}    Set Variable    //*[@id='AssignableCPTCodeList']//*[contains(@class,'CleanHeader') and contains(text(),'CPT Code')]/ancestor::*[2]/*[not(@style)][1]/*[1]/*
    ${cpt_code_txt}    Get Text    ${cpt_code}
    Click Close Provider Order Popup
    RETURN    ${cpt_line_count}    ${cpt_code_txt}

Verify PA General Section Visible
    Check Location    location_arg=${data_input}[location]  
    Check Physician Order Num    po_num_arg=${provider_dict.po_num}
    Check Patient    patient_name_arg=${PatientCreate.last_name}, ${PatientCreate.first_name} ${PatientCreate.middle_name} \(${PatientCreate.dob}\) MRN: ${PatientCreate.mrn}
    Check DX Code    dx_arg=${provider_dict.primary_icdcode}
    Check Physician    physician_arg=${data_input}[referring_npi_po]  

Verify PA Provider Order MDF Section Visible
    Scroll Element Into View    //div[normalize-space()='Provider Order (MDF)']//following::h3[normalize-space()='PA Status and Confirmation']
    Check Medication    medicaiton_arg=${provider_dict.medication}
    Check Visit Dose    maint_dose_arg=${provider_dict.dosage_assigned}
    Check Route    route_arg=${provider_dict.route}
    Check Frequency    frequency_value=${provider_dict.frequency_value}    frequency_unit=${provider_dict.frequency_time}
    Check Container Type    container_type_arg=${provider_dict.preferred_uom}
    # Check Total Dosage    10
    # Check Total Approved Visits    20

Verify PA Status and Confirmation Section Visible
    List Selection Should Be    ${pa_prior_auth_status_select}    ${pa_dict.status}
    Element Attribute Value Should Be    ${pa_confirm_num_input}    value    ${pa_dict.confirmation_number}
    Element Attribute Value Should Be    ${pa_start_date_input}    value    ${pa_dict.startdate}
    Element Attribute Value Should Be    ${pa_end_date_input}    value    ${pa_dict.enddate}
    Element Attribute Value Should Be    ${PA_auth_date_input}    value    ${pa_dict.entrydate}
    Element Attribute Value Should Be    ${pa_rx_number_input}    value    ${pa_dict.rx_number}
    List Selection Should Be    ${pa_medication_type_select}    ${pa_dict.medication_type}
    Element Attribute Value Should Be    ${pa_other_label_input}    value    ${pa_dict.payer_label}

Verify Payor Information and Margin Calculator Section Visible
    List Selection Should Be    ${pa_payer_medicatiton_select}    ${provider_dict.medication}
