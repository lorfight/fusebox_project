*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Lab Tracker Suite
Test Setup    Test Setup Lab Tracker Suite
Test Teardown    Test Teardown Lab Tracker Suite
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_007    patient    Admin

*** Test Cases ***
Add And Update Lab Tracker SuccessFully With Valid All Fields
    [Documentation]    PaMan_TC121    PaMan_TC122    PaMan_TC123_1    PaMan_TC139    PaMan_TC149
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect
    Open Lab Tracker Tab
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

Add Lab SuccessFully With Valid Required Fields
    [Documentation]    PaMan_TC123
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    AddLabTracker.Upsert Lab Tracker With Required Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    msg=Lab Tracker Created

Add Lab UnsuccessFully With Empty All Fields
    [Documentation]    PaMan_TC124
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Select Account In Lab Tracker Modal    account_arg=- Select -
    Sleep    2s
    ${errors}    Catenate    SEPARATOR= 
        ...    The Account field is required.
        ...    The Patient field is required.
        ...    The Lab Description field is required.
        ...    The Frequency Value field is required.
        ...    The Frequency field is required.
        ...    The Status field is required.
        ...    The Order Start Date field is required.
        ...    The Order End Date field is required.
    Click Save Lab Tracker Button    ${errors}
    Click Close Lab Tracker Button

Add Lab UnsuccessFully With Empty Required Fields
    [Documentation]    PaMan_TC125    PaMan_TC126    PaMan_TC128    PaMan_TC129    PaMan_TC131    PaMan_TC132    PaMan_TC133
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect
    ${error_list}    Create List
        ...    The Account field is required.
        ...    The Patient field is required.
        ...    The Lab Description field is required.
        ...    The Order Start Date field is required.
        ...    The Order End Date field is required.
        ...    The Frequency Value field is required.
        ...    The Frequency field is required.
        ...    The Status field is required.

    ${labtracker_dict}    Create Lab Tracker Dictionary
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    FOR    ${error}    IN    @{error_list}
        Open Lab Tracker Tab
        AddLabTracker.Open Add Lab Tracker Modal
        Run Keyword If    "${error}" == "The Account field is required."    Select Account In Lab Tracker Modal    - Select -
        Run Keyword If    "${error}" != "The Account field is required."    Select Account In Lab Tracker Modal    ${data_input}[location]
        Run Keyword If    "${error}" == "The Patient field is required."    Input Patient Name In Lab Tracker Modal    ${EMPTY}
        Run Keyword If    "${error}" != "The Patient field is required."    Input Patient Name In Lab Tracker Modal    ${data_input}[patient_mrn] 
        Run Keyword If    "${error}" != "The Lab Description field is required."    Input Lab Descirption In Lab Tracker Modal    ${protocol_dict.assign_lab_txt}    ${EMPTY}
        Run Keyword If    "${error}" != "The Order Start Date field is required."    Input Order Start Date In Lab Tracker Modal    ${start_date}
        Run Keyword If    "${error}" != "The Order End Date field is required."    Input Order End Date In Lab Tracker Modal    ${end_date}
        Run Keyword If    "${error}" != "The Frequency Value field is required."    Select Frequency Value In Lab Tracker Modal    ${labtracker_dict}
        Run Keyword If    "${error}" != "The Frequency field is required."    Select Frequency Select In Lab Tracker Modal    ${labtracker_dict}
        Run Keyword If    "${error}" != "The Status field is required."    Select Status In Lab Tracker Modal    ${labtracker_dict}
        Click Save Lab Tracker Button    ${error}
        Click Close Lab Tracker Button
        Reload Page
    END

Verify Account Field Shows Correct Fomat And Data
    [Documentation]    PaMan_TC137
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    PatientList.Go To Patients Page
    ${location_user_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${patients_location_select}
    PatientList.Filter Patient In Patient Page    mrn_arg=${data_input}[patient_mrn]     location_arg=${data_input}[location]
    PatientList.Select Patient From List    mrn_arg=${data_input}[patient_mrn] 
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${location_tracker_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_location}
    Should Be Equal    ${location_user_list[1:]}    ${location_tracker_list[1:]}
    Click Close Lab Tracker Button
    
Verify Patient Field Shows Correct Fomat And Data
    [Documentation]    PaMan_TC138
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Input Patient Name In Lab Tracker Modal    ${data_input}[patient_mrn]
    ${tracker_patient_name_txt}    Get Value    ${tracker_patient_name}
    Should Be Equal    ${tracker_patient_name_txt}    ${PatientCreate.last_name}, ${PatientCreate.first_name} (${PatientCreate.dob}) MRN: ${PatientCreate.mrn} - (${data_input}[location])
    Click Close Lab Tracker Button

Verify Descirption Field Shows Correct Data When The Lab Is Assigned For One Medication
    [Documentation]    PaMan_TC140
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${True}
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Input Lab Descirption In Lab Tracker Modal    ${protocol_dict.assign_lab_txt}    ${data_input}[drug_po_first]
    ${description_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Should Be Equal    ${description_txt}    ${protocol_dict.assign_lab_txt} (${data_input}[drug_po_first])
    
Verify Descirption Field Shows Correct Data When The Lab Is Assigned For Multiple Medication
    [Documentation]    PaMan_TC141
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${True}
    ${lab_index}    Evaluate    int(${lab_index}) - 1
    Set Suite Variable    ${lab_index}
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_second]    assigned_lab_status=${True}
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Verify Descirption Field Shows Multiple Medication Data    
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    drug_first=${data_input}[drug_po_first] 
        ...    drug_second=${data_input}[drug_po_second]

Verify Frequency Fields Show Correct Fomat And Data
    [Documentation]    PaMan_TC143
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Verify Options Of Frequency Value
    Verify Options Of Frequency Select

Perform Actions With Expiration Field
    [Documentation]    PaMan_TC150    PaMan_TC151    PaMan_TC152    PaMan_TC153
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Verify Expiration Date Value Is Changed Following Result Date Value
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    Input Result Date In Lab Tracker Modal    ${result_date}
    Verify Expiration Date Value Is Changed Following Result Date Value
    ${labtracker_dict}    Create Lab Tracker Dictionary
    Select Frequency In Lab Tracker Modal    ${labtracker_dict}
    Check Value Expiration Date Should Be Equal Total Frequency And Result Date Value    
        ...    ${labtracker_dict.tracker_frequency_value}    
        ...    ${labtracker_dict.tracker_frequency_select}    
        ...    ${result_date}    
        ...    ${tracker_expdate_input}
    Common.Mouse Hover Element    ${tracker_expdate_input}    ${tracker_resultdate_input}    ${tracker_expdate_tooltip}
    Click Close Lab Tracker Button

Verify That Status Select Show Correct Fomat And Data
    [Documentation]    PaMan_TC154
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${tracker_status_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_status_select}
    ${expected_list}    Create List    - Select -    Submitted    Approved    Archived    Ordered
    Lists Should Be Equal    ${tracker_status_list}    ${expected_list}

Verify Primary ICD10 Code List Contains Only One Value
    [Documentation]    PaMan_TC155    PaMan_TC157    PaMan_TC158
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${tracker_primary_ICD10_default}    Get Text    ${tracker_primary_ICD10_default}
    Should Be Equal    ${tracker_primary_ICD10_default}    No Primary ICD10 Code Added
    Input Primary ICD10 Code In Lab Tracker Modal    ${data_input}[icd10_codes][icd10_code_1]
    ${primary_ICD10_value1}    Get Text    ${tracker_primary_ICD10_list}
    Input Primary ICD10 Code In Lab Tracker Modal   ${data_input}[icd10_codes][icd10_code_2]
    ${primary_ICD10_value2}    Get Text    ${tracker_primary_ICD10_list}
    Should Not Be Equal    ${primary_ICD10_value1}    ${primary_ICD10_value2}
    Click Remove ICD10 Code Button
    Click Close Lab Tracker Button

Verify Additional ICD10 Code List Contains Multiple Value
    [Documentation]    PaMan_TC156    PaMan_TC159    PaMan_TC160
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${tracker_additional_ICD10_default}    Get Text    ${tracker_additional_ICD10_default}
    Should Be Equal    ${tracker_additional_ICD10_default}    No Additional ICD10 Codes Added
    Choose Primary ICD10 Code In Lab Tracker Modal    ${data_input}[icd10_codes]     Additional
    ${additional_ICD10_value}    SeleniumLibrary.Get Element Count    ${tracker_additional_ICD10_list}//div[contains(@class,'AdditionalICDCodesDiv ')]
    Should Be True    ${additional_ICD10_value} > 1
    ${remove_elements}    Get WebElements    ${tracker_remove_additional}
    FOR    ${remove}    IN    @{remove_elements}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove}
        Page Alert Message    Additional Diagnosis Removed.
    END
    Click Close Lab Tracker Button

Add And Update Attribute SuccessFully With All Valid Fields In Tracker Attributes List
    [Documentation]    PaMan_TC161    PaMan_TC162    PaMan_TC163    PaMan_TC164
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect   
    ${labtracker_dict}    Create Lab Tracker Dictionary
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Input Lab Descirption In Lab Tracker Modal    ${protocol_dict.assign_lab_txt}    ${EMPTY}
    ${attribute_description_txt}    Create Attribute With All Fields    
        ...    value=random    
        ...    dict_arg=${labtracker_dict}  
    Lab Tracker Attributes List Shows Attribute Rows
    AddLabTracker.Update Attribute With All Fields    
        ...    attribute_description_arg=${attribute_description_txt}
        ...    value=random
        ...    dict_arg=${labtracker_dict} 
    AddLabTracker.Delete Created Attributes
    Click Close Lab Tracker Button

Verify That Response Type Select Show Correct Fomat And Data
    [Documentation]    PaMan_TC165
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect 
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Input Lab Descirption In Lab Tracker Modal    ${protocol_dict.assign_lab_txt}    ${EMPTY}
    Open Attributes Modal
    ${attribute_select_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${attribute_response_type}
    ${expected_list}    Create List    - Select -    Range    String    Selection
    Lists Should Be Equal    ${attribute_select_list}    ${expected_list}
    Click Close Attribute Popup Button

Verify Status Is ABNORMAL When Result Is Out Of Normal Range
    [Documentation]    PaMan_TC166
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect
    Open Lab Tracker Tab
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
    LabTrackerLedger.Open Lab Tracker Row    ${protocol_dict.assign_lab_txt}
    ${attribute_description_txt}    Create Attribute With All Fields    
        ...    value=Range    
        ...    dict_arg=${labtracker_dict}  
    AddLabtracker.Show Empty Value In Lab Tracker Row
    Input Out Of Normal Range Value    
        ...    attribute_description=${attribute_description_txt}   
        ...    min_range=${labtracker_dict.min_range}      
        ...    max_range=${labtracker_dict.max_range}  
        ...    dict_arg=${labtracker_dict} 
    Click Save Lab Tracker Button    Lab Tracker Updated
    Labtracker.Open Lab Tracker Ledger
    LabTracker.Filter Lab Tracker Following Mrn
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
    LabTrackerLedger.Open Lab Tracker Row    ${protocol_dict.assign_lab_txt}
    Check Value Of Stautus Lab Tracker Modal    
        ...    file_num=${file_num_create}    
        ...    attribute_description_txt=${attribute_description_txt}    
        ...    tracker_result=${labtracker_dict.tracker_result}  

# Verify That Critical Lab Component Results Table Show Correct Fomat And Data
#     [Documentation]    PaMan_TC168
# 	[Tags]    regression     Lab Tracker
#       report.label.owner: Hai Nguyen
#     Select Lab Descirption In Lab View    drug_arg=${PatientData.drug_PO1}    assigned_lab_status=${False}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
#     Input Out Of Normal Range Value
#     ${tracker_critical_table}    Replace Variables    ${tracker_critical_table}
#     Wait Until Element Is Visible    ${tracker_critical_table}    30s

Labs Related To Provider Orders Table Displays All The Labs Of The PO
    [Documentation]    PaMan_TC169    PaMan_TC170    PaMan_TC171    PaMan_TC172    PaMan_TC173    PaMan_TC177    PaMan_TC178    PaMan_TC179    PaMan_TC190
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${treatment_txt}    Get Treatment Drug For PO
    Common.Open New Window    Update Patient
    ${original_window}    Get Window Handles
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Go To Protocol Management Modal
    Select Location In Protocol Management Modal    ${data_input}[location]
    Search for Medication In Protocol Management Modal    ${treatment_txt}
    Show Medication's Required Labs    ${treatment_txt}
    Show Quick View    ${treatment_txt}
    Remove Lab Descirption Medication Required Labs    ${treatment_txt}
    ${protocol_dict}    Create Protocol Dictionary
    ${assign_lab_txt_first}    ${assign_emr_lab_first}    Get Lab Descirption Text    ${treatment_txt}
    Assign Lab Descirption In Quick Select Tool    ${treatment_txt}    ${lab_tr}    ${lab_index}    
    ${assign_lab_txt_second}    ${assign_emr_lab_second}    Get Lab Descirption Text    ${treatment_txt}
    Assign Lab Descirption In Quick Select Tool    ${treatment_txt}    ${lab_tr}    ${lab_index}    
    Common.Return Previous Window    window_arg=${original_window}[1]
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_txt} 
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    
    ${assign_lab_list}    Create List    ${assign_lab_txt_first}    ${assign_lab_txt_second}

    Check Labs Related To Provider Orders Table Displays All The Labs Of The PO
        ...    assign_lab_list=${assign_lab_list}
        ...    po_num=${provider_dict.po_num}  
# Verify Blank Information Lab Is Removed When The Lab Is Unassigned From PO
    Unassign Required Lab Descirption In PO Popup    
        ...    po_num=${provider_dict.po_num}
        ...    assign_lab_txt=${assign_lab_txt_first}    
    ${tracker_description_element}    Set Variable    (//div[contains(text(),'${provider_dict.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt_first}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${tracker_description_element}    
        ...    po_num=${provider_dict.po_num}    
        ...    assign_lab_txt=${assign_lab_txt_first}    
        ...    expected_description_status=${False}    
        ...    reorder_btn_status=${False}
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    ${lab_order_dict}    Update Lab Tracker Successfully When Input Required Fields In Lab Order    
        ...    assign_lab_txt=${assign_lab_txt_second}    
        ...    po_num=${provider_dict.po_num}     
        ...    startdate_arg=${start_date}   
#Verify Updated Information Lab Is Removed When The Lab Is Unassigned From PO
    Unassign Required Lab Descirption In PO Popup    
        ...    po_num=${provider_dict.po_num}
        ...    assign_lab_txt=${assign_lab_txt_second}    
    ${tracker_unrelated_description}    Set Variable    //div[contains(text(),'Unrelated Labs')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt_second}')]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${tracker_unrelated_description}    
        ...    po_num=${provider_dict.po_num}    
        ...    assign_lab_txt=${assign_lab_txt_second}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${False}
    
Verify Lab Tracker Applies Correct Frequency Based On Frequency Sources Priority
    [Documentation]    PaMan_TC144    PaMan_TC145    PaMan_TC146    PaMan_TC147
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    ${treatment_txt}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_txt}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${treatment_txt}  
        ...    dose_arg=10
        ...    po_number_arg=${provider_dict.po_num}

    Check Lab Frequency Fields Of Protocol Management Impact Provider Order, Patient Protocol And Lab Tracker    
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

    Check Lab Frequency Fields Of Provider Order Impact Patient Protocol, Lab Tracker And Not Effect Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}
    
    Check Lab Frequency Fields Of Patient Protocol Impact Provider Order, Lab Tracker And Not Effect Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

    Check Lab Frequency Fields Of Lab Tracker Does Not Impact Provider Order, Patient Protocol And Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

Create New Lab Tracker When Input the Same Description of Previous Lab Tracker
    [Documentation]    PaMan_TC174
    [Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    drug_arg=${data_input}[drug_po_first]    assigned_lab_status=${False}    frequency_status=unselect
    Open Lab Tracker Tab
    FOR    ${loop}    IN RANGE    2
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
        Common.Open New Window    Update Patient
        ${current_window}    Get Window Handles
        Labtracker.Open Lab Tracker Ledger
        LabTracker.Filter Lab Tracker Following Mrn
            ...    location_arg=${data_input}[location]
            ...    mrn_arg=${data_input}[patient_mrn] 
        LabTrackerLedger.Open Lab Tracker Row    ${protocol_dict.assign_lab_txt}
        Common.Close Modal Popup
        Common.Return Previous Window    window_arg=${current_window}[1]
    END

Create New Lab Tracker Is Visible When Selecting The General Descirption
    [Documentation]    PaMan_TC175
    [Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict_first}    ${treatment_first}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    ${lab_index}    Evaluate    int(${lab_index}) - 1
    Set Suite Variable    ${lab_index}
    ${protocol_dict_second}    ${treatment_second}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    Should Be Equal    ${protocol_dict_first.assign_lab_txt}    ${protocol_dict_second.assign_lab_txt}
    Open Provider Orders Tab
    ${provider_dict_first}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_first}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    ${provider_dict_second}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_second}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    ${Fake_dict}    Generate Fake Data    num_rand
    ${file_num_create}    Set Variable    ${Fake_dict['num_rand']}
    ${labtracker_dict}    AddLabTracker.Upsert Lab Tracker With All Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${protocol_dict_first.assign_lab_txt}
        ...    payer_arg=${data_input}[lab_payer] 
        ...    physician_arg=${data_input}[referring_npi_po]  
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    file_arg=${file_num_create}
        ...    result_date_arg=${result_date}
        ...    icd10_code_arg=${data_input}[icd10_codes] 
        ...    msg=Lab Tracker Created
    ${lab_tracker_row_first}    Set Variable    (//div[contains(text(),'${provider_dict_first.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict_first.assign_lab_txt}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${lab_tracker_row_first}    
        ...    po_num=${provider_dict_first.po_num}    
        ...    assign_lab_txt=${protocol_dict_first.assign_lab_txt}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${False}
    ${lab_tracker_row_second}    Set Variable    (//div[contains(text(),'${provider_dict_second.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict_second.assign_lab_txt}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${lab_tracker_row_second}    
        ...    po_num=${provider_dict_second.po_num}    
        ...    assign_lab_txt=${protocol_dict_second.assign_lab_txt}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${False}

Create New Lab Tracker Is Visible When Selecting The Medication Specific Descirption
    [Documentation]    PaMan_TC176
    [Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict_first}    ${treatment_first}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    ${lab_index}    Evaluate    int(${lab_index}) - 1
    Set Suite Variable    ${lab_index}
    ${protocol_dict_second}    ${treatment_second}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    Should Be Equal    ${protocol_dict_first.assign_lab_txt}    ${protocol_dict_second.assign_lab_txt}
    Open Provider Orders Tab
    ${provider_dict_first}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_first}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    ${provider_dict_second}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_second}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    Open Lab Tracker Tab
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    AddLabTracker.Open Add Lab Tracker Modal
    ${Fake_dict}    Generate Fake Data    num_rand
    ${file_num_create}    Set Variable    ${Fake_dict['num_rand']}
    ${labtracker_dict}    AddLabTracker.Upsert Lab Tracker With All Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${protocol_dict_first.assign_lab_txt}
        ...    payer_arg=${data_input}[lab_payer] 
        ...    physician_arg=${data_input}[referring_npi_po]  
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    file_arg=${file_num_create}
        ...    result_date_arg=${result_date}
        ...    icd10_code_arg=${data_input}[icd10_codes] 
        ...    drug_lab_arg=${treatment_first}
        ...    msg=Lab Tracker Created
    ${lab_tracker_row_first}    Set Variable    (//div[contains(text(),'${provider_dict_first.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict_first.assign_lab_txt}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${lab_tracker_row_first}    
        ...    po_num=${provider_dict_first.po_num}    
        ...    assign_lab_txt=${protocol_dict_first.assign_lab_txt}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${False}
    ${lab_tracker_row_second}    Set Variable    (//div[contains(text(),'${provider_dict_second.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict_second.assign_lab_txt}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${lab_tracker_row_second}    
        ...    po_num=${provider_dict_second.po_num}    
        ...    assign_lab_txt=${protocol_dict_second.assign_lab_txt}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${False}

# All Columns In Lab Tracker Related To Provider Order Table Show Data Correctly
#     [Documentation]    PaMan_TC180    PaMan_TC181    PaMan_TC182    PaMan_TC183    PaMan_TC184    PaMan_TC185    PaMan_TC186    PaMan_TC187    PaMan_TC188    PaMan_TC189    
#     [Tags]    regression     Lab Tracker
#       report.label.owner: Hai Nguyen
#     Get Treatment Drug For PO
#     Select Lab Descirption In Lab View    drug_arg=${treatment_txt}    assigned_lab_status=${True}
#     Navigate to Patient by Generated MRN
#     Open Lab Tracker Tab
#     Create Fake Data List
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
#     Get DateTime In Lab Tracker
#     Input All Fields In Lab Tracker Modal
#     ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
#     ...    payer_arg=${lab_payer}    physician_arg=${referring_NPI_PO}    start_date_arg=${start_date}    
#     ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
#     ...    ICD10_arg=${icd10_code}    btn_arg=${None}    msg=${None}
#     Check Value Expiration Date    ${tracker_frequency_value}    ${tracker_frequency_select}    ${tracker_resultdate_input}    ${tracker_expdate_input}
#     Scroll And Click Element Modal    ${tracker_save_btn}
#     Page Alert Message    Lab Tracker Created
#     Create New PO    med_arg=${treatment_txt}    PO_dosage_arg=${Fake_dict.demical_2d}
#     All Columns In Lab Tracker Related Show Correct Data

Verify All Fields Show Data And Type Correctly In Lab Order
    [Documentation]    PaMan_TC191    PaMan_TC192    PaMan_TC193    PaMan_TC194    PaMan_TC196    PaMan_TC203    PaMan_TC204    PaMan_TC205    PaMan_TC206    PaMan_TC207    PaMan_TC208    PaMan_TC209    PaMan_TC210    PaMan_TC211    PaMan_TC212
    [Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    ${treatment_txt}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}    frequency_status=unselect
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_txt}  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    ${tracker_description_element}    Set Variable    (//div[contains(text(),'${provider_dict.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict.assign_lab_txt}')])[1]
    Check Lab Row Is Visible In Lab Tracker Modal   
        ...    tracker_description_element=${tracker_description_element}    
        ...    po_num=${provider_dict.po_num}    
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}    
        ...    expected_description_status=${True}    
        ...    reorder_btn_status=${True}
    Verify The Reorder Lab Will Close When Clicking Cancel Button
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}   
        ...    po_num=${provider_dict.po_num}    
    Add Lab Order UnsuccessFully With Empty Required Fields
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}   
        ...    po_num=${provider_dict.po_num}    
    Click Reorder Button
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}   
        ...    po_num=${provider_dict.po_num}    
    Verify Date Input In Lab Order
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}   
        ...    po_num=${provider_dict.po_num}    
    Verify Checkbox In Lab Order    ${protocol_dict.assign_lab_txt}
    Verify Select In Lab Order    ${protocol_dict.assign_lab_txt}
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    Click Cancel Button    ${protocol_dict.assign_lab_txt}
    ${lab_order_dict}    Update Lab Tracker Successfully When Input All Fields In Lab Order    
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}   
        ...    po_num=${provider_dict.po_num}  
        ...    startdate_arg=${start_date}    
        ...    resultdate_arg=${result_date}    
        ...    icd10_code_arg=${data_input}[icd10_codes]
    Verify Result Date Column In Lab Table    
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=${result_date}
    ${tracker_row_expdate}    Set Variable    (//div[contains(text(),'${provider_dict.po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${protocol_dict.assign_lab_txt}')]//ancestor::tr//td[@data-column='2']//strong)[1]
    ${formatted_result_date}    Convert Date    ${result_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    Check Value Expiration Date Should Be Equal Total Frequency And Result Date Value In Lab Order   
        ...    ${lab_order_dict.reorder_frequency_value}    
        ...    ${lab_order_dict.reorder_frequency_unit}    
        ...    ${formatted_result_date}    
        ...    ${tracker_row_expdate}
    ${formatted_start_date}    Convert Date    ${start_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    Verify Order Date Column In Lab Table    
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=${formatted_start_date}
    Verify Lab Code Column In Lab Table    
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=${protocol_dict.assign_emr_lab}
    Verify Status Column In Lab Table    
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=Ordered
    Verify Order End Date In Lab Table
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=-
    Verify File Number Column In Lab Table
        ...    po_num=${provider_dict.po_num} 
        ...    assign_lab_txt=${protocol_dict.assign_lab_txt}
        ...    expect_value=-
    LabTrackerLedger.Open Lab Tracker Row    assign_lab_txt=${protocol_dict.assign_lab_txt}    
    Verify The Primary And Additional ICD10 Codes Shows Correct Data    icd10_code_arg=${data_input}[icd10_codes]
    Click Close Lab Tracker Button

Verify Reorder Lab Applies Correct Frequency Based On Frequency Sources Priority
    [Documentation]    PaMan_TC197    PaMan_TC198    PaMan_TC199    PaMan_TC200    PaMan_TC201
	[Tags]    regression     Lab Tracker    report.label.owner: Hai Nguyen
    ${protocol_dict}    ${treatment_txt}    Get Lab Descirption Following Drug PO In Protocol Management Modal    assigned_lab_status=${True}
    Open Provider Orders Tab
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${treatment_txt}   
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${treatment_txt}  
        ...    dose_arg=10
        ...    po_number_arg=${provider_dict.po_num}
    
    Check Lab Frequency Fields Of Protocol Management Impact Provider Order, Patient Protocol And Lab Order
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

    Check Lab Frequency Fields Of Provider Order Impact Patient Protocol, Lab Order And Not Effect Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}
    
    Check Lab Frequency Fields Of Patient Protocol Impact Provider Order, Lab Order And Not Effect Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

    Check Lab Frequency Fields Of Lab Order Does Not Impact Provider Order, Patient Protocol And Protocol Management
        ...    po_num=${provider_dict.po_num}    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    lab_des_arg=${protocol_dict.assign_lab_txt}   
        ...    drug_lab_arg=${treatment_txt}

*** Keywords ***
Suite Setup Lab Tracker Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
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
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Lab Tracker Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]

Test Teardown Lab Tracker Suite
    Common.Return Previous Window    window_arg=${update_patient_window}

Get Treatment Drug For PO
    ${existed_treatments}    Create List
        ...    ${data_input}[drug_po_first]
        ...    ${data_input}[drug_po_second]
    Open Provider Orders Tab
    Click Create Provider Order
    Common.Element Is Not Visible    ${protocol_loading_icon_i}
    ${treatment_txt}    Get Treatment Drug    ${existed_treatments}
    Click Close Provider Order Popup
    RETURN    ${treatment_txt}

Get Lab Descirption In Protocol Management Modal
    [Arguments]    ${drug_arg}    ${assigned_lab_status}    ${frequency_status}=select
    Common.Open New Window    Update Patient
    ${current_window}    Get Window Handles
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Go To Protocol Management Modal
    ${protocol_dict}    Protocols.Select Lab Descirption In Protocol Management Modal
        ...    location_arg=${data_input}[location]
        ...    drug_arg=${drug_arg} 
        ...    assigned_lab_status=${assigned_lab_status}
        ...    frequency_status=${frequency_status}
    Common.Return Previous Window    window_arg=${current_window}[1]
    RETURN    ${protocol_dict}

Get Lab Descirption Following Drug PO In Protocol Management Modal
    [Arguments]    ${assigned_lab_status}    ${frequency_status}=select
    ${treatment_txt}    Get Treatment Drug For PO
    ${protocol_dict}    Get Lab Descirption In Protocol Management Modal    
        ...    drug_arg=${treatment_txt}
        ...    assigned_lab_status=${assigned_lab_status}
        ...    frequency_status=${frequency_status}
    RETURN    ${protocol_dict}    ${treatment_txt}

Get Frequency Of Lab Descirption In Protocol Management Modal
    [Arguments]    ${lab_des_arg}    ${drug_lab_arg}
    Common.Open New Window    Update Patient
    ${current_window}    Get Window Handles
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Go To Protocol Management Modal
    Select Location In Protocol Management Modal    ${data_input}[location]
    Search for Medication In Protocol Management Modal    ${drug_lab_arg}
    Show Medication's Required Labs    ${drug_lab_arg}
    ${protocol_management_frequency_value}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]
    ${protocol_management_frequency_unit}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${protocol_management_frequency_value}
    ${protocol_management_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${protocol_management_frequency_value}
    ${protocol_management_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${protocol_management_frequency_unit}
    Common.Close Modal Popup
    Common.Return Previous Window    window_arg=${current_window}[1]
    RETURN    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}

Check Lab Frequency Fields Of Protocol Management Impact Provider Order, Patient Protocol And Lab Tracker
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    ${tracker_frequency_value_txt}    ${tracker_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    Should Be True  "${protocol_management_frequency_value_txt}" == "${tracker_frequency_value_txt}" and "${protocol_management_frequency_value_txt}" == "${po_lab_frequency_value_txt}" and "${protocol_management_frequency_value_txt}" == "${patient_protocol_frequency_value_txt}"
    Should Be True     "${protocol_management_frequency_unit_txt}" == "${tracker_frequency_unit_txt}" and "${protocol_management_frequency_unit_txt}" == "${po_lab_frequency_unit_txt}" and "${protocol_management_frequency_unit_txt}" == "${patient_protocol_frequency_unit_txt}"

Check Lab Frequency Fields Of Provider Order Impact Patient Protocol, Lab Tracker And Not Effect Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${po_frequency_dict}    Create Dictionary
    Change Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}    ${po_frequency_dict}
    ${tracker_frequency_value_txt}    ${tracker_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${po_frequency_dict.po_lab_frequency_value}" == "${tracker_frequency_value_txt}" and "${po_frequency_dict.po_lab_frequency_value}" == "${patient_protocol_frequency_value_txt}" 
    Should Be True     "${po_frequency_dict.po_lab_frequency_unit}" == "${tracker_frequency_unit_txt}" and "${po_frequency_dict.po_lab_frequency_unit}" == "${patient_protocol_frequency_unit_txt}" 
    Should Be True    "${po_frequency_dict.po_lab_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${po_frequency_dict.po_lab_frequency_unit}" != "${protocol_management_frequency_unit_txt}"
    
Check Lab Frequency Fields Of Patient Protocol Impact Provider Order, Lab Tracker And Not Effect Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${patient_protocol_frequency_dict}    Create Dictionary
    Change Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}    ${patient_protocol_frequency_dict}
    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    ${tracker_frequency_value_txt}    ${tracker_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" == "${po_lab_frequency_value_txt}" and "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" == "${tracker_frequency_value_txt}" 
    Should Be True     "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" == "${po_lab_frequency_unit_txt}" and "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" == "${tracker_frequency_unit_txt}" 
    Should Be True    "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" != "${protocol_management_frequency_unit_txt}"

Check Lab Frequency Fields Of Lab Tracker Does Not Impact Provider Order, Patient Protocol And Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    ${Fake_dict}    Generate Fake Data    num_rand
    ${file_num_create}    Set Variable    ${Fake_dict['num_rand']}
    ${labtracker_dict}    AddLabTracker.Upsert Lab Tracker With All Fields
        ...    account_arg=${data_input}[location]
        ...    name_arg=${data_input}[patient_mrn] 
        ...    lab_des_arg=${lab_des_arg}
        ...    payer_arg=${data_input}[lab_payer] 
        ...    physician_arg=${data_input}[referring_npi_po]  
        ...    start_date_arg=${start_date}
        ...    end_date_arg=${end_date}
        ...    file_arg=${file_num_create}
        ...    result_date_arg=${result_date}
        ...    icd10_code_arg=${data_input}[icd10_codes] 
        ...    drug_lab_arg=${drug_lab_arg}
        ...    msg=Lab Tracker Created

    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${labtracker_dict.tracker_frequency_value}" != "${po_lab_frequency_value_txt}" and "${labtracker_dict.tracker_frequency_value}" != "${patient_protocol_frequency_value_txt}" 
    Should Be True     "${labtracker_dict.tracker_frequency_select}" != "${po_lab_frequency_unit_txt}" and "${labtracker_dict.tracker_frequency_select}" != "${patient_protocol_frequency_unit_txt}" 
    Should Be True    "${labtracker_dict.tracker_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${labtracker_dict.tracker_frequency_select}" != "${protocol_management_frequency_value_txt}"

Check Lab Frequency Fields Of Protocol Management Impact Provider Order, Patient Protocol And Lab Order
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Open Lab Tracker Tab
    ${reorder_frequency_value_txt}    ${reorder_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Order    ${lab_des_arg}    ${po_num}
    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    Should Be True  "${protocol_management_frequency_value_txt}" == "${reorder_frequency_value_txt}" and "${protocol_management_frequency_value_txt}" == "${po_lab_frequency_value_txt}" and "${protocol_management_frequency_value_txt}" == "${patient_protocol_frequency_value_txt}"
    Should Be True     "${protocol_management_frequency_unit_txt}" == "${reorder_frequency_unit_txt}" and "${protocol_management_frequency_unit_txt}" == "${po_lab_frequency_unit_txt}" and "${protocol_management_frequency_unit_txt}" == "${patient_protocol_frequency_unit_txt}"

Check Lab Frequency Fields Of Provider Order Impact Patient Protocol, Lab Order And Not Effect Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${po_frequency_dict}    Create Dictionary
    Change Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}    ${po_frequency_dict}
    Open Lab Tracker Tab
    ${reorder_frequency_value_txt}    ${reorder_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Order    ${lab_des_arg}    ${po_num}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${po_frequency_dict.po_lab_frequency_value}" == "${reorder_frequency_value_txt}" and "${po_frequency_dict.po_lab_frequency_value}" == "${patient_protocol_frequency_value_txt}" 
    Should Be True     "${po_frequency_dict.po_lab_frequency_unit}" == "${reorder_frequency_unit_txt}" and "${po_frequency_dict.po_lab_frequency_unit}" == "${patient_protocol_frequency_unit_txt}" 
    Should Be True    "${po_frequency_dict.po_lab_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${po_frequency_dict.po_lab_frequency_unit}" != "${protocol_management_frequency_unit_txt}"

Check Lab Frequency Fields Of Patient Protocol Impact Provider Order, Lab Order And Not Effect Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    ${patient_protocol_frequency_dict}    Create Dictionary
    Change Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}    ${patient_protocol_frequency_dict}
    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    Open Lab Tracker Tab
    ${reorder_frequency_value_txt}    ${reorder_frequency_unit_txt}    Get Frequency Of Lab Descirption In Lab Order    ${lab_des_arg}    ${po_num}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" == "${po_lab_frequency_value_txt}" and "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" == "${reorder_frequency_value_txt}"
    Should Be True     "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" == "${po_lab_frequency_unit_txt}" and "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" == "${reorder_frequency_unit_txt}"
    Should Be True    "${patient_protocol_frequency_dict.patient_protocol_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${patient_protocol_frequency_dict.patient_protocol_frequency_unit}" != "${protocol_management_frequency_unit_txt}"

Check Lab Frequency Fields Of Lab Order Does Not Impact Provider Order, Patient Protocol And Protocol Management
    [Arguments]    ${po_num}    ${apt_datetime}    ${lab_des_arg}    ${drug_lab_arg}
    Open Lab Tracker Tab
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    ${lab_order_dict}    Update Lab Tracker Successfully When Input Required Fields In Lab Order    
        ...    assign_lab_txt=${lab_des_arg}    
        ...    po_num=${po_num}     
        ...    startdate_arg=${start_date}   

    ${po_lab_frequency_value_txt}    ${po_lab_frequency_unit_txt}    Get Frequency Of Lab Descirption In Provider Order Modal    ${po_num}    ${lab_des_arg}
    ${patient_protocol_frequency_value_txt}    ${patient_protocol_frequency_unit_txt}    Get Frequency Of Lab Descirption In Patient Protocol Modal    ${apt_datetime}    ${lab_des_arg}
    ${protocol_management_frequency_value_txt}    ${protocol_management_frequency_unit_txt}    Get Frequency Of Lab Descirption In Protocol Management Modal    ${lab_des_arg}    ${drug_lab_arg}
    Should Be True     "${lab_order_dict.reorder_frequency_value}" != "${po_lab_frequency_value_txt}" and "${lab_order_dict.reorder_frequency_value}" != "${patient_protocol_frequency_value_txt}" 
    Should Be True     "${lab_order_dict.reorder_frequency_unit}" != "${po_lab_frequency_unit_txt}" and "${lab_order_dict.reorder_frequency_unit}" != "${patient_protocol_frequency_unit_txt}" 
    Should Be True    "${lab_order_dict.reorder_frequency_value}" != "${protocol_management_frequency_value_txt}" or "${lab_order_dict.reorder_frequency_unit}" != "${protocol_management_frequency_value_txt}"