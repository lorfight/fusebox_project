*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Dispensing/ProviderOrders/ProviderOrders.resource
Suite Setup    Suite Setup Provider Orders Suite
Test Setup    Test Setup Provider Orders Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_008    patient    Admin

*** Test Cases ***
Verify Required Fields Have Default Value In Initial Provider Orders Phase
    [Documentation]    PO_1    PO_2    PO_4    PO_9    PO_10
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Go To Patients Page
    ${location_user_list}    PatientList.Get Location List
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Handle Diagnosis For Provider Orders    status=assign
    Open Provider Orders Tab
    Click Create Provider Order
    Ordering Location Field Has Default Value    default_location=${data_input}[location]    expected_location_list=${location_user_list}
    Select A Patient Field Has Default Value    default_patient_info=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} (${PatientCreate.dob}) MRN: ${data_input}[patient_mrn]
    Verify Diagnosis Dropdown Shows Two ICD Sections After Drug Selected    drug_arg=${data_input}[drug_po_first]
    Click Close Provider Order Popup
    Handle Diagnosis For Provider Orders    status=unassign

Verify Missing Required Fields In Initial Provider Orders Phase
    [Documentation]    PO_3    PO_5    PO_8    PO_11
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create Provider Order Dictionary
    ${error_list}    Create List
        ...    AccountId is Required.
        # ...    The Patient field is required.
        ...    Please select a medication!
        ...    Please select a ICD Code!

    FOR    ${error}    IN    @{error_list}
        Open Provider Orders Tab
        Click Create Provider Order
        Run Keyword If    "${error}" != "AccountId is Required."    Enter Provider Initial Informations    
            ...    location_arg=${data_input}[location]    
            ...    mrn_arg=${data_input}[patient_mrn]    
            ...    drug_arg=${data_input}[drug_po_first]     
            ...    provider_dict=${provider_dict}
        Run Keyword If    "${error}" == "AccountId is Required."    Select Ordering Location Popup    location_arg=-- Select A Location --
        Run Keyword If    "${error}" == "AccountId is Required."    Select Treatment Drug    drug_arg=${data_input}[drug_po_first]   
        Run Keyword If    "${error}" == "AccountId is Required."    Select Diagnosis    dict_arg=${provider_dict}
        Run Keyword If    "${error}" == "Please select a medication!"    Select Treatment Drug    drug_arg=-- All Medications --
        Run Keyword If    "${error}" == "Please select a ICD Code!"    Select Diagnosis    dict_arg=${provider_dict}    value=-- Select an ICD Code --
        Common.Scroll And Click Element   ${create_po_btn}
        Run Keyword If    "${error}" == "AccountId is Required."    Alert Should Be Present    AccountId is Required.    ACCEPT
        Run Keyword If    "${error}" != "AccountId is Required."    Common.Page Alert Message    ${error}
        # Click Close Provider Order Popup
        Reload Page
    END

Verify Missing Required Fields In Detail Provider Orders Phase
    [Documentation]    PO_14    PO_15    PO_17    PO_18    PO_19    PO_22    PO_23    PO_24    PO_25    PO_26    
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create Provider Order Dictionary
    ${error_list}    Create List
        ...    Please select a referring physician!
        ...    Please select a refer to physician!
        ...    Please enter a weight!
        ...    Please select an unit for Patient weight!
        ...    Please enter a dosage!
        ...    Please enter a dose frequency!

    FOR    ${error}    IN    @{error_list}
        Click Create Provider Order
        Enter Provider Initial Informations    
            ...    location_arg=${data_input}[location]    
            ...    mrn_arg=${data_input}[patient_mrn]    
            ...    drug_arg=${data_input}[drug_po_first]     
            ...    provider_dict=${provider_dict}
        Click Create Button
        Run Keyword If    "${error}" != "Please select a referring physician!"    Input Referring    ${data_input}[refering_provider]
        Run Keyword If    "${error}" != "Please select a refer to physician!"    Select Refer To Provider    ${data_input}[referring_npi_po] 
        Run Keyword If    "${error}" == "Please select a refer to physician!"    Select Refer To Provider    ${EMPTY}
        Run Keyword If    "${error}" != "Please enter a weight!"    Input Weight    70
        Run Keyword If    "${error}" != "Please select an unit for Patient weight!"    Click Radio Button
        Run Keyword If    "${error}" != "Please enter a dosage!"    Input Dose    10
        Run Keyword If    "${error}" != "Please enter a dose frequency!"    Select Frequency Value    dict_arg=${provider_dict}
        Run Keyword If    "${error}" != "Please enter a dose frequency!"    Select Frequency Time    dict_arg=${provider_dict}
        Click Save Provider Order
        Common.Page Alert Message    ${error}
        Click Close Provider Order Popup
        Alert Should Be Present    It looks like you have been editing something. Press okay to save your changes before moving on!    DISMISS
    END

Verify Fields Have Default Value In Detail Provider Orders Phase
    [Documentation]    PO_16    PO_20    PO_21    PO_30
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    drug_arg=${data_input}[drug_po_first]     
        ...    provider_dict=${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Verify PO Default Dates
    Verify Primary Diagnosis Auto Filled    ${provider_dict.primary_icdcode}
    Verify Referral Source Dropdown Options
    Verify Office Visit Frequency Dropdowns
    Verify Place Of Service Dropdown Options

Verify View And Edit Provider Order Popup Show Field Groups Exactly
    [Documentation]    PO_32    PO_33    PO_34    PO_36    PO_37    PO_40    PO_41    
                ...    PO_42    PO_43    PO_44    PO_45    PO_46    PO_47    PO_48    
                ...    PO_53    PO_54    PO_57    PO_58    PO_59   
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[drug_po_second]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Click View PO    ${provider_dict.po_num}
    Check Detail Fields Are Disable    status_arg=view po
    Check Supporting Documentation section Has Fields Group    status_arg=view po
    Check Medication Regimen Section Has Fields Group    status_arg=view po
    Check Secondary Medication Section Has Fields Group    status_arg=view po
    Check The Preferred CPT Codes Section Has Fields Group    status_arg=view po
    Check Tools for Status and History Section Has Fields Group    status_arg=view po
    Click Close Provider Order Popup
    Click Edit PO    ${provider_dict.po_num}
    Check Detail Fields Are Disable    status_arg=edit po
    Check Supporting Documentation section Has Fields Group    status_arg=edit po
    Check Medication Regimen Section Has Fields Group    status_arg=edit po
    Check Secondary Medication Section Has Fields Group    status_arg=edit po
    Check The Preferred CPT Codes Section Has Fields Group    status_arg=edit po
    Check Tools for Status and History Section Has Fields Group    status_arg=edit po

Verify Created Provider Order Is Visible And Loaded Data Correctly In Both Of Provider Orders Page And Patient Page
    [Documentation]    PO_12    PO_49    PO_50    PO_51    PO_55    PO_56    PO_60
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[drug_po_second]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Click View PO    ${provider_dict.po_num}
    Verify Data Loaded Exactly In Provider Order Popup    
        ...    location_arg=${data_input}[location]  
        ...    po_num_arg=${provider_dict.po_num}
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} (${PatientCreate.dob}) MRN: ${data_input}[patient_mrn]
        ...    start_date_arg=${provider_dict.start_date} 
        ...    exp_date_arg=${provider_dict.exp_date} 
        ...    entry_date_arg=${provider_dict.entry_date} 
        ...    diagnosis_arg=${provider_dict.primary_icdcode} 
        ...    referral_physician_arg=${data_input}[refering_provider]
        ...    refer_to_provider_arg=${provider_dict.refer_to_provider} 
        ...    visit_frequency_value_arg=${provider_dict.frequency_value}
        ...    visit_frequency_unit_arg=${provider_dict.frequency_time}
        ...    weight_arg=70
        ...    height_arg=${EMPTY}
        ...    split_dose_arg=10
    Click Close Provider Order Popup
    Go To Provider Orders Page
    Filter PO Navigate Mrn    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
    Click Search PO
    Click View PO    ${provider_dict.po_num}
    Verify Data Loaded Exactly In Provider Order Popup    
        ...    location_arg=${data_input}[location]  
        ...    po_num_arg=${provider_dict.po_num}
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} (${PatientCreate.dob}) MRN: ${data_input}[patient_mrn]
        ...    start_date_arg=${provider_dict.start_date} 
        ...    exp_date_arg=${provider_dict.exp_date} 
        ...    entry_date_arg=${provider_dict.entry_date} 
        ...    diagnosis_arg=${provider_dict.primary_icdcode} 
        ...    referral_physician_arg=${data_input}[refering_provider]
        ...    refer_to_provider_arg=${provider_dict.refer_to_provider} 
        ...    visit_frequency_value_arg=${provider_dict.frequency_value}
        ...    visit_frequency_unit_arg=${provider_dict.frequency_time}
        ...    weight_arg=70
        ...    height_arg=${EMPTY}
        ...    split_dose_arg=10

Verify Provider Order Edits Reflect In All Screens
    [Documentation]    PO_13
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location] 
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[drug_po_first]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Edit PO    
        ...    po_num=${provider_dict.po_num}
        ...    patient_height_arg=3
        ...    dict_arg=${provider_dict}
    Click View PO    ${provider_dict.po_num}
    Verify Data Loaded Exactly In Provider Order Popup    
        ...    location_arg=${data_input}[location]  
        ...    po_num_arg=${provider_dict.po_num}
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} (${PatientCreate.dob}) MRN: ${data_input}[patient_mrn]
        ...    start_date_arg=${provider_dict.start_date} 
        ...    exp_date_arg=${provider_dict.exp_date} 
        ...    entry_date_arg=${provider_dict.entry_date} 
        ...    diagnosis_arg=${provider_dict.primary_icdcode} 
        ...    referral_physician_arg=${data_input}[refering_provider]
        ...    refer_to_provider_arg=${provider_dict.refer_to_provider} 
        ...    visit_frequency_value_arg=${provider_dict.frequency_value}
        ...    visit_frequency_unit_arg=${provider_dict.frequency_time}
        ...    weight_arg=70
        ...    height_arg=3
        ...    split_dose_arg=10
    Click Close Provider Order Popup
    Go To Provider Orders Page
    Filter PO Navigate Mrn    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
    Click Search PO
    Click View PO    ${provider_dict.po_num}
    Verify Data Loaded Exactly In Provider Order Popup    
        ...    location_arg=${data_input}[location]  
        ...    po_num_arg=${provider_dict.po_num}
        ...    patient_name_arg=${PatientCreate.first_name} ${PatientCreate.middle_name} ${PatientCreate.last_name} (${PatientCreate.dob}) MRN: ${data_input}[patient_mrn]
        ...    start_date_arg=${provider_dict.start_date} 
        ...    exp_date_arg=${provider_dict.exp_date} 
        ...    entry_date_arg=${provider_dict.entry_date} 
        ...    diagnosis_arg=${provider_dict.primary_icdcode} 
        ...    referral_physician_arg=${data_input}[refering_provider]
        ...    refer_to_provider_arg=${provider_dict.refer_to_provider} 
        ...    visit_frequency_value_arg=${provider_dict.frequency_value}
        ...    visit_frequency_unit_arg=${provider_dict.frequency_time}
        ...    weight_arg=70
        ...    height_arg=3
        ...    split_dose_arg=10

Verify The Sections Displayed In Primary Diagnosis Depending On Assigned Diagnosis 
   [Documentation]    PO_62    PO_63    PO_64
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    Click Create Provider Order
    Select Treatment Drug    ${data_input}[drug_po_first]
    Page Should Not Contain    Assigned to Patient
    Page Should Contain    Medication ICD Codes
    Click Close Provider Order Popup
    Handle Diagnosis For Provider Orders    assign
    Open Provider Orders Tab
    Click Create Provider Order
    Select Treatment Drug    ${data_input}[drug_po_first]
    Page Should Contain    Assigned to Patient
    Page Should Contain    Medication ICD Codes
    Click Close Provider Order Popup
    Handle Diagnosis For Provider Orders    unassign

Verify The Sections Displayed In Secondary Diagnosis Depending On Assigned Diagnosis 
    [Documentation]    PO_66    PO_67    PO_68
    [Tags]    Regression    Provider Order    report.label.owner: Nga Phan, Hai Nguyen
    Open Provider Orders Tab
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    drug_arg=${data_input}[drug_po_first]     
        ...    provider_dict=${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Wait Until Page Does Not Contain    Assigned to Patient    5s
    Wait Until Page Contains    Medication ICD Codes    5s
    Click Close Provider Order Popup
    Handle Diagnosis For Provider Orders    assign
    Open Provider Orders Tab
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    drug_arg=${data_input}[drug_po_first]     
        ...    provider_dict=${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Wait Until Page Contains    Assigned to Patient    5s
    Wait Until Page Contains    Medication ICD Codes    5s
    Click Close Provider Order Popup
    Handle Diagnosis For Provider Orders    unassign

# Verify UoM And Preferred Method Labels In Create View And Update PO Mode 
#     [Documentation]    PO_70    PO_71    PO_72    PO_73    PO_76    PO_77

# Verify Create And Updated PO Successfully If User Select The Preferred Unit Of Measure
#     [Documentation]    PO_74    PO_78

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

Handle Diagnosis For Provider Orders
    [Arguments]    ${status}
    Open Diagnosis Tab
    FOR    ${key}    ${value}    IN    &{data_input}[icd10_codes]  
        IF    "${status}" == "assign"
            Find Diagnosis    ${value}
            Click Assigned Checkbox    ${value}
        ELSE IF    "${status}" == "unassign"
            Unassigned Diagnosis    ${value}
        END
    END
