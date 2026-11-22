*** Settings ***
Library    XML
Resource    ../Common/Common.resource
Resource    ../../../../../libraries/Util.resource

*** Variables ***
# "Provider Order" page
${publish_po_checkbox}    //input[@id="CanPublishProviderOrder"]
${sign_po_checkbox}    //input[@id="SignatureRequired"]
${import_provider_order}    xpath://*[contains(text(),"Import Provider Order")]
${import_provider_order_title}    //h4[text()='Import Provider Orders']
${choose_po_file_input}    //input[@id="UploadFile"]
${po_process_file_btn}    //button[contains(text(),'Process File')]
${po_confirm_import_btn}    //button[contains(text(),'Confirm Import')]
${download_po_template}    //a[contains(@onclick,'DownloadPatientOrderTemplate')]
${create_provider_order}    xpath://*[contains(text(),"Create Provider Order")]
${location_po_page}    xpath://select[contains(@id,'AccountID')]
${clear_patient_btn}    //*[@type='button' and contains(@class,'patientClearButton')]
${filter_patient_input}    //*[@id='PatientId']
${patient_autocomplete}    //input[@id='PatientId']/following-sibling::pre[1]/following::div[1]
${range_start_date_input}    //*[@id='StartDate']
${range_end_date_input}    //*[@id='EndDate']
${select_date_done_btn}    //*[@type='button' and text()='Done']
${search_po_btn}    //*[contains(@class,'SearchBtn') and text()='Search']
${next_page_link}    //*[@id='PatientOrderList']//*[normalize-space(text())='Provider Orders']//following::*[text()='Next'][1]
${po_list_loading}    //*[@id='PatientOrderList']//*[contains(@class,'fa-spinner')]
${view_expired_checkbox}    //input[@id="viewExpired"]
${view_signed_checkbox}    //input[@id="ViewSigned"]
${view_unsigned_checkbox}    //input[@id="ViewUnSigned"]
${view_published_checkbox}    //input[@id="ViewPublished"]
${view_unpublished_checkbox}    //input[@id="ViewUnPublished"]
${view_progress_note_checkbox}    //input[@id="ViewProgressNotes"]
${view_discontinued_service_checkbox}    //input[@id="ViewDiscontinued"]

# PO Modal
${po_header_text}    //*[@id='ModalPopup']//*[contains(@class,'modal-title') and text()='Provider Order']
${ordering_location_select}    xpath://select[contains(@id,'ModalAccountID')]
${select_patient_text}    //*[contains(text(),'Please Select a Patient')]
${select_patient}    xpath://input[contains(@id,'SelectedPatient')]
${patient_auto_select}    //*[@id='Phase1']//following-sibling::span[1]//div[contains(@class,'tt-dataset')]
${filter_meds_by_primary_icds_checkbox}    //input[@id="FilterMedsByPrimaryICDs"]
${treatment_drug_select}    xpath://select[contains(@id,'PrimaryMedication')]
${primary_icdcode_select}    //select[@id='PrimaryICDCode']
${primary_icdcode_txt}    (//button[@data-id='PrimaryICDCode']//span)[1]
${po_loading}    //*[@id='PatientInnerView']//*[contains(@class,'fa-spinner')]
${create_po_btn}    xpath://button[contains(text(),'Create')]
${po_num_text}    //*[@id='PONumberDispaly']
${entry_date_input}    //*[starts-with(text(),'Order Entry Date:')]/following-sibling::*
${start_date_input}    //*[@id='OrderDate']
${exp_date_input}    //*[@id='ExpirationDate']
${diagnosis_txt}    //strong[@id="DiagnosisDispaly"]
${referring_provider_text}    //*[contains(text(),'Referring/Ordering Provider: ')]
${referral_physician}    //input[contains(@id,'ReferralPhysician')]
${refer_to_provider_select}    xpath://select[contains(@id,'OrderingPhysician')]
${referral_source_select}    //*[@id='ReferralSource']
${visit_frequency_value_select}    //*[@id='OfficeVisitRequirementValue']
${visit_frequency_select}    //*[@id='OfficeVisitRequirementFrequency']
${weight_po_input}    xpath://input[contains(@id,'WeightPO')]
${height_po_input}    xpath://input[contains(@id,'PatientHeightft')]
${kg_radio_btn}    xpath://*[@id="PatientInnerView"]//input[@data-type="MA__"]
${po_bmi_text}    //*[@id='PatientBMI']
${route_po_select}    //*[@id='RouteOfAdministration']
${dosage_caculated}    xpath://input[contains(@id,'CalculatedDosage')]
${dosage_assigned}    //*[@id="DosageAssigned"]
${frequency_value}    xpath://select[contains(@id,'FrequencyValue')]
${frequency_time}    xpath://select[contains(@id,'DoseFrequency')]
${indexed_dose_input}    //*[@id='DosageAssignedConvert']
${place_of_service}    xpath://select[contains(@id,'PlaceOfService')]
${requested_dose_input}    //*[@id='NumberOfDoses']
${preferred_UoM_select}    //*[@id='PreferredUoM']
${container_type}    xpath://select[contains(@id,'ContainerType')]
${split_dose}    xpath://input[contains(@id,'SplitDose')]
${number_of_split_dose_treatments}    xpath://select[contains(@id,'NumberOfSplitDoseTreatments')]
${save_po_btn}    //*[contains(@onclick,'patientOrderSave') and contains(text(),'Save')]
${referrals_select}    //*[@id='Referral']
# ${close_po_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
${dose_type_po}    //*[@id='ActivateRegimen_1']
${progress_note}    //*[@id='POModalProgressNote']
${discontinue_service_checkbox}    //*[@id='IsDiscontinuedService']
${view_changes_btn}    //*[@onclick and contains(text(),'View Changes ')]
${publish_physician_order_document}    //*[@id='PublishPDFButton']
# "PO tab"
${po_tab}    //a[@id='PhysicianOrder']
${create_new_po_patient_page}    Xpath://*[contains(text(),'Create Provider Order ')]
${view_discontinued_checkbox}    //*[@id='ViewDiscontinuedCheckboxPO']
${po_advise_title}    //h4[contains(text(),'PLEASE BE ADVISED')]
${po_accept_btn}    //button[contains(text(),'Accept & Continue')]
${po_exist_alert}    //h4[contains(text(),'EXISTING PROVIDER ORDER ALERT')]

#Supporting Documentation
${view_document_btn}    //*[@id='ViewPODocumentationBtn']
${document_list}    //*[@id='PODocumentationDiv']
${question_doc_select}    (//select[@class='form-control input-sm QuestionAnswer'])[1]

# Medication Regimen
${medication_regimen_title}    //strong[text()='Medication Regimen']
${medication_regimen_select}    //*[@id='Regimen']
${medication_dose_table}    //*[@id='Dose_1']
${medication_repeat_regimen_select}    //*[@id='RepeatRegimen']
${medication_repeat_regimen_frequency_select}    //*[@id='RepeatRegimenFrequency']
${medication_repeat_maintenance_select}    //*[@id='RepeatMaintenance']
${medication_repeat_maintenance_frequency_select}    //*[@id='RepeatMaintenanceFrequency']

# Secondary Medications
${secondary_regimen_title}    //strong[text()='Secondary Medications']
${secondary_quick_select}    //a[@class='btn btn-sm btn-success' and contains(text(),'Hide / Show Quick Select')]
${secondary_add_secondary_meds_btn}    //*[@id='AddNewAdditionalMedBtn']
${secondary_secondary_list}    //*[@id='AdditionalMedicationsList']
${secondary_view_assigned_medication}    //*[@id='ViewAssignedAdditionalMedication']

# Preferred CPT Codes
${preferred_cpt_codes_title}    //strong[contains(text(), 'Preferred CPT Codes')]
${preferred_referral_select}    (//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//button[contains(@class, 'dropdown-toggle')])[1]
${preferred_assigned_as_preference_checkbox}    (//*[@id='AssignableCPTCodeList']//*[contains(@class,'largeCheckbox')])[1]
${preferred_treatment_goals_select}    (//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//button[contains(@class, 'dropdown-toggle')])[2]
${preferred_notes_textarea}    //strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//textarea[(@id= 'AdditionalNotes')]
${rx_number_assignment_title}    //strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//strong[contains(text(), 'Rx Number Assignment')]
${rx_number_input}    //*[@id='RXNumber']
${rx_assignment_date_input}    //*[@id='RXNumberAssignDate']
${rx_origin_select}    //*[@id='RxOrigin']

#Tools for Status and History
${tools_for_status_and_history_title}    //strong[contains(text(), 'Tools for Status and History')]
${tools_progress_note_textarea}    //*[@id="POModalProgressNote"]


*** Keywords ***
Create Provider Order Dictionary
    &{provider_dict}    Create Dictionary
    RETURN    ${provider_dict}

Create PO Required Fields
    [Arguments]    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${refer_arg}    ${refer_to_arg}    ${patient_weight_arg}    ${dosageAssignedValue_arg}    #${dose_arg}    ${activate_arg}
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Get PO Number    ${provider_dict}
    Get PO Dates    ${provider_dict}
    Input Referring    ${refer_arg}  
    # Select Referral Source    ${provider_dict}
    ${refer_to_provider}    Select Refer To Provider    ${refer_to_arg}  
    Input Weight    ${patient_weight_arg}
    Click Radio Button    
    Select Route    ${provider_dict}
    Input Dose    ${dosageAssignedValue_arg}
    Select Frequency Value    ${provider_dict}
    Select Frequency Time    ${provider_dict}
    # Input Dose (Vials) In Medication Regimen    ${dose_arg}
    # Select Loading Or Maintenance     ${activate_arg}
    # Select Repeat Full Regimen    ${provider_dict}
    Click Save Provider Order
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Provider Order Successfully Created!    5s
    IF    "${check_msg}" == "${False}"
        Check Advised
        Common.Page Alert Message    Provider Order Successfully Created!    30s
    END
    Click Close Provider Order Popup
    Set To Dictionary    ${provider_dict}    refer_to_provider=${refer_to_provider}    
    RETURN    ${provider_dict}

Create PO All Fields
    [Arguments]    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${refer_arg}    ${refer_to_arg}    ${patient_weight_arg}    ${patient_height_arg}    ${dosageAssignedValue_arg}    ${calculated_dosage_arg}    ${requested_dose_arg}    ${splitDoseValue_arg}
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Get PO Number    ${provider_dict}
    Get PO Dates    ${provider_dict}
    Input Referring    ${refer_arg}  
    Select Referral Source    ${provider_dict}
    ${refer_to_provider}    Select Refer To Provider    ${refer_to_arg}  
    Select Office Visit Frequency    ${provider_dict}
    Select Office Visit Frequency Value    ${provider_dict}
    Input Weight    ${patient_weight_arg}
    Click Radio Button
    Input Height    ${patient_height_arg}
    Select Route    ${provider_dict}
    Input Dose    ${dosageAssignedValue_arg}
    Select Frequency Value    ${provider_dict}
    Select Frequency Time    ${provider_dict}
    Input Calculate Dose    ${calculated_dosage_arg}
    Select Place Of Service    ${provider_dict}
    Input Number Of Requested Dose    ${requested_dose_arg}
    Select Preferred Dispensing UoM    ${provider_dict}
    Select Preferred Method    ${provider_dict}
    Input Split Dose    ${splitDoseValue_arg}
    Select Number Of Split Dose Treatments    ${provider_dict}
    Click Save Provider Order
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Provider Order Successfully Created!    5s
    IF    "${check_msg}" == "${False}"
        Check Advised
        Common.Page Alert Message    Provider Order Successfully Created!    30s
    END
    Click Close Provider Order Popup
    Set To Dictionary    ${provider_dict}    
        ...    medication=${drug_arg}
        ...    dosage_assigned=${dosageAssignedValue_arg}
    RETURN    ${provider_dict}

Edit PO 
    [Arguments]    ${patient_height_arg}    ${dict_arg}    ${po_num}
    Click Edit PO    ${po_num}
    Select Office Visit Frequency Value    ${dict_arg}
    Select Office Visit Frequency    ${dict_arg}
    Input Height    ${patient_height_arg}
    Select Place Of Service    ${dict_arg}
    Select Preferred Dispensing UoM    ${dict_arg}
    Select Preferred Method    ${dict_arg}
    Select Number Of Split Dose Treatments    ${dict_arg}
    Click Save Provider Order
    Check Advised
    Common.Page Alert Message    Provider Order Successfully Updated!
    Click Close Provider Order Popup
    
#PO Page
Go to Provider Orders
    Click Element    ${DispensingLink}
    Click Element    ${PO_link}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Provider Orders

Enter Provider Initial Informations
    [Arguments]    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${provider_dict}
    Select Ordering Location Popup    ${location_arg}
    Input Patient    ${mrn_arg}
    Click Filter By Patient's Primary DX Codes Checkbox
    Select Treatment Drug    ${drug_arg}
    Select Diagnosis    ${provider_dict}

Select Location Provider Orders
    [Arguments]    ${location_arg}
    Filter Location - PO Page    ${location_arg}
    Wait Until Element Is Enabled    ${create_provider_order}

Filter Location - PO Page
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${location_po_page}
    Select From List By Label    ${location_po_page}    ${location_arg}

Filter Patient - PO Page
    [Arguments]    ${patient_arg}
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${clear_patient_btn}
    Input Patient And Select Autocomplete    ${filter_patient_input}    ${patient_arg}    ${patient_autocomplete}

Filter Start Date Range - PO Page
    [Arguments]    ${date_arg}
    Clear Element Text    ${range_start_date_input}
    Input Text    ${range_start_date_input}    ${date_arg}
    Wait Until Element Is Visible    ${select_date_done_btn}    30s
    Click Element    ${select_date_done_btn}

Filter End Date Range - PO Page
    [Arguments]    ${date_arg}
    Clear Element Text    ${range_end_date_input}
    Input Text    ${range_end_date_input}    ${date_arg}
    Wait Until Element Is Visible    ${select_date_done_btn}    30s
    Click Element    ${select_date_done_btn}

Clear Date Range Filter - PO Page
    Clear Element Text    ${range_start_date_input}
    Clear Element Text    ${range_end_date_input}

Calculate PO End Date
    ${today}    Check Time Zone
    ${end_date}    Add Time To Date    ${today}    364 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    RETURN    ${end_date}

Click Search PO
    Click Element    ${search_po_btn}
    Util.Wait For Page Loading    element_arg=${po_list_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

# Find PO
#     [Arguments]    ${po_arg}
#     ${po_row}    Find PO Row    ${po_arg}
#     Check PO Not Duplicated    ${po_row}    # only 1 PO row with exact PO number on PO page
#     # Check PO Row
#     Util.Scroll To Bottom
#     Wait Until Keyword Succeeds    30s    1s    Click Element    ${po_row}
#     Wait Until Element Is Visible    ${po_header_text}    30
#     Util.Wait For Page Loading    element_arg=${po_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
#     RETURN  ${po_row}

# Find PO Row
#     [Arguments]    ${po_arg}
#     ${po_row}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[normalize-space(.)='Edit Order'][1]
#     ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${po_row}
#     WHILE    ${check} == ${False}
#         Wait Until Keyword Succeeds    30s    1s    Click Element    ${next_page_link}
#         ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${po_row}
#     END
#     RETURN  ${po_row}

Input Patient And Select Autocomplete
    [Arguments]    ${patient_locator}    ${mrn}    ${autocomplete_locator}
    Input Text    ${patient_locator}    ${mrn}
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${autocomplete_locator}    10s
    IF    ${status}
        Click Element    ${autocomplete_locator}
    ELSE
        Clear Input Field Until Empty    ${patient_locator}
        Input Text    ${patient_locator}    ${mrn}
        Wait Until Element Is Visible    ${autocomplete_locator}    10s
        Click Element    ${autocomplete_locator}
    END

Click Create Provider Order
    Sleep    4s
    Wait Until Element Is Visible    ${create_provider_order}    30s
    Click Element    ${create_provider_order}
    Common.Element Is Not Visible    //div[@id="PatientPhysicianOrderList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Click Import Provider Orders
    Wait Until Element Is Visible    ${import_provider_order}    30s
    Click Element    ${import_provider_order}
    Wait Until Element Is Visible    ${import_provider_order_title}    10s

Click Download Provider Order Import Template
    Wait Until Element Is Visible    ${download_po_template}    30s
    Click Element    ${download_po_template}

Click Confirm Import Provider Order Button
    Wait Until Element Is Visible    ${po_confirm_import_btn}    30s
    Click Element    ${po_confirm_import_btn}

Click Process Provider Order File Button
    Wait Until Element Is Visible    ${po_process_file_btn}    30s
    Click Element    ${po_process_file_btn}

Click Publish Provider Orders Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${publish_po_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${publish_po_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${publish_po_checkbox}
    END

Click Sign Provider Orders Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${sign_po_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${sign_po_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${sign_po_checkbox}
    END

Click View Expired Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_expired_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_expired_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_expired_checkbox}
    END

Click View Signed Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_signed_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_signed_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_signed_checkbox}
    END

Click View Unsigned Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_unsigned_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_unsigned_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_unsigned_checkbox}
    END

Click View Published Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_published_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_published_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_published_checkbox}
    END

Click View Unpublished Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_unpublished_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_unpublished_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_unpublished_checkbox}
    END

Click View Progress Note Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_progress_note_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_progress_note_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_progress_note_checkbox}
    END

Click View Discontinued Service Checkbox
    [Arguments]    ${expect_status}
    Wait Until Element Is Visible    ${view_discontinued_service_checkbox}    30s
    ${check_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${view_discontinued_service_checkbox}
    IF    '${check_status}' != '${expect_status}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_discontinued_service_checkbox}
    END

Click Publish Button
    [Arguments]    ${po_arg}
    ${publish_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::div[@class="publishButtonSection"]
    Common.Scroll And Click Element    ${publish_btn}

Click Sign Button
    [Arguments]    ${po_arg}
    ${sign_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[contains(@class,'signButton')]
    Common.Scroll And Click Element    ${sign_btn}

Click Confirm Publish Button
    [Arguments]    ${po_arg}
    ${confirm_publish_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[contains(@class,'confirmPublishButton')]
    Common.Scroll And Click Element    ${confirm_publish_btn}
    Common.Page Alert Message    Provider Order is published successfully.

Click Cancel Publish Button
    [Arguments]    ${po_arg}
    ${cancel_publish_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[contains(@class,'cancelPublishButton')]
    Common.Scroll And Click Element    ${cancel_publish_btn}

#PO popup
Select Ordering Location Popup 
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${ordering_location_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${ordering_location_select}    ${location_arg}
    Common.Element Is Not Visible    //div[@id="PatientPhysicianOrderList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Input Patient 
    [Arguments]    ${mrn}
    Common.Clear Input Field Until Empty    ${select_patient}
    Sleep    2s
    Input Text Into Field    ${select_patient}    ${mrn}
    Wait Until Element Is Visible    ${patient_auto_select}    30s
    Click Element    ${patient_auto_select}
    Press Keys    None    TAB
    Common.Element Is Not Visible    //div[@id="PatientPhysicianOrderList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Click Filter By Patient's Primary DX Codes Checkbox
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${filter_meds_by_primary_icds_checkbox}    2s
    IF    '${check_visible}' == '${True}'
        ${checkbox}    Run Keyword And Return Status    Checkbox Should Be Selected    ${filter_meds_by_primary_icds_checkbox}
        Run Keyword If    '${checkbox}' == '${True}'    Wait Until Keyword Succeeds    30s    1s    Click Element    ${filter_meds_by_primary_icds_checkbox}
    END

Select Treatment Drug
    [Arguments]    ${drug_arg}
    Wait Until Element Is Enabled    ${treatment_drug_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${treatment_drug_select}    ${drug_arg}
    IF    "${drug_arg}" != "-- All Medications --"
        Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    //button[@data-id="PrimaryICDCode"]    title     -- Select an ICD Code --
    END
    
Select Diagnosis
    [Arguments]    ${dict_arg}    ${value}=random
    Wait Until Element Is Enabled    ${primary_icdcode_select}    30s
    IF    "${value}" == "random"
        Common.Choose Random Value From Select List    xpath_arg=${primary_icdcode_select}    var_name=primary_icdcode    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${primary_icdcode_select}    ${value}
        Set To Dictionary    ${dict_arg}    primary_icdcode=${value}
    END

Click Create Button
    Common.Scroll And Click Element   ${create_po_btn}
    Check Exist Alert
    Common.Element Is Not Visible    ${po_loading}

# Check PO Loading
#     ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${po_loading}
#     IF    ${check} == ${True}
#         Wait Until Element Is Not Visible    ${po_loading}    30s
#     END
Get PO Number
    [Arguments]    ${dict_arg}
    ${po_num}    Get Text    ${po_num_text}
    ${po_num}    Fetch From Right    ${po_num}    \ \
    Util.Add To Dictionary    dic_arg=${dict_arg}    key_arg=po_num    val_arg=${po_num}

Get PO Dates    #Expiration Date
    [Arguments]    ${dict_arg}
    ${entry_date}    Get Value    ${entry_date_input}
    ${start_date}    Get Value    ${start_date_input}
    ${exp_date}    Get Value    ${exp_date_input}
    ${today}    Util.Check Time Zone
    Set To Dictionary    ${dict_arg}    entry_date=${entry_date}    start_date=${start_date}    exp_date=${exp_date}    today=${today}

Input Referring
    [Arguments]    ${refer_arg}
    Input Text Into Field   ${referral_physician}    ${refer_arg}
    ${referring_strong}    Set Variable    xpath=//div//strong[contains(text(),'${refer_arg}')]
    Scroll And Click Element    ${referring_strong}

Select Referral Source
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${referral_source_select}    var_name=referral_source_select    dic=${dict_arg}

Select Refer To Provider
    [Arguments]    ${refer_to_arg}
    Wait Until Element Is Enabled    ${refer_to_provider_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${refer_to_provider_select}    ${refer_to_arg}
    ${refer_to_provider}    Get Selected List Label    ${refer_to_provider_select}
    RETURN    ${refer_to_provider}

Select Office Visit Frequency Value
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${visit_frequency_value_select}    var_name=visit_frequency_value    dic=${dict_arg}

Select Office Visit Frequency
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${visit_frequency_select}    var_name=visit_frequency_unit    dic=${dict_arg}

Input Weight
    [Arguments]    ${patient_weight_arg}
    Input Text Into Field    ${weight_po_input}    ${patient_weight_arg}

Click Radio Button
    Click Element    ${kg_radio_btn}

Input Height
    [Arguments]    ${patient_height_arg}
    Input Text Into Field    ${height_po_input}    ${patient_height_arg}

Get Route Select
    ${route}    Get Selected List Label    ${route_po_select}
    RETURN    ${route}
    
Select Route
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${route_po_select}    var_name=route    dic=${dict_arg}

Input Dose
    [Arguments]    ${dosageAssignedValue_arg}
    Input Text Into Field    ${dosage_assigned}    ${dosageAssignedValue_arg}

Input Calculate Dose
    [Arguments]    ${calculated_dosage_arg}
    Input Text Into Field    ${dosage_caculated}    ${calculated_dosage_arg}

Select Frequency Value
    [Arguments]    ${dict_arg}    ${value}=random
    IF    "${value}" == "random"
        Common.Choose Random Value From Select List    xpath_arg=${frequency_value}    var_name=frequency_value    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${frequency_value}    ${value}
    END    

Select Frequency Time
    [Arguments]    ${dict_arg}    ${value}=random
    IF    "${value}" == "random"
        Common.Choose Random Value From Select List    xpath_arg=${frequency_time}    var_name=frequency_time    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${frequency_time}    ${value}
    END  

Select Place Of Service
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${place_of_service}    var_name=place_of_service    dic=${dict_arg}

Input Number Of Requested Dose
    [Arguments]    ${requested_dose_arg}
    Input Text Into Field    ${requested_dose_input}    ${requested_dose_arg}

Input Split Dose
    [Arguments]    ${splitDoseValue_arg}
    Input Text Into Field    ${split_dose}    ${splitDoseValue_arg}

Select Number Of Split Dose Treatments
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${number_of_split_dose_treatments}    var_name=number_of_split_dose_treatments    dic=${dict_arg}

Select Preferred Dispensing UoM
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${preferred_UoM_select}    var_name=preferred_uom    dic=${dict_arg}
    ${UoM}    Get Selected List Label    ${preferred_UoM_select}
    Set To Dictionary    ${dict_arg}    UoM=${UoM}

Select Preferred Method
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${container_type}    var_name=container_type    dic=${dict_arg}

Click Save Provider Order
    Wait Until Page Does Not Contain Element    //*[@class="ajax-loader"]    30s
    Wait Until Element Is Enabled    ${save_po_btn}
    Common.Scroll And Click Element    ${save_po_btn}

Click Close Provider Order Popup
    Common.Close Modal Popup

Click Discontinue Service
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${discontinue_service_checkbox}

Click View Changes
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_changes_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Provider Order Changelog')]    30s

Click Publish Physician Order Document
    Common.Scroll And Click Element    ${publish_physician_order_document}
    Handle Alert    ACCEPT
    Common.Page Alert Message    Provider Order is published successfully.

Input Progress Note
    Wait Until Element Is Visible    ${dose_type_po}
    Wait Until Element Is Enabled    ${progress_note}    15s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${progress_note}    Test PO_13

Get Progress Note
    Wait Until Element Is Visible    ${progress_note}
    ${progress_note_txt}    Get Text    ${progress_note}
    RETURN    ${progress_note_txt}

Check Advised
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${po_advise_title}    2s
    IF    ${check_advised} == ${True}
        Scroll And Click Element    ${po_accept_btn}
    END

Check Exist Alert
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${po_exist_alert}    3s
    IF    ${check_exist} == ${True}
        Scroll And Click Element   ${po_accept_btn}
    END

Check Popup Confirm PA
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    frm_ConfirmUpdateValidatePriorAuthorizationModal    2s
    IF    ${check_exist} == ${True}
        Scroll And Click Element   //button[contains(text(),'Accept')]
    END

# Close Modal
#     Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${close_po_btn}
#     Wait Until Element Is Visible    ${close_po_btn}    30s
#     ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Click Button    ${close_po_btn}
#     IF    ${check} == ${False}    #button covered    #PROD
#         Wait Until Keyword Succeeds    30s    1s    Execute JavaScript    return document.evaluate("${close_po_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
#     END
#     Wait Until Element Is Not Visible    css:#ModalPopup > div.modal-dialog > div > div.modal-body.clearfix    timeout=30s

Check PO Not Duplicated
    [Arguments]    ${xpath_arg}
    ${check_list}    Wait Until Keyword Succeeds    30s    1s    Get WebElements    ${xpath_arg}
    ${check_count}    Get Length    ${check_list}
    Should Be Equal As Integers    ${check_count}    1
    
#PO List
Click View PO
    [Arguments]    ${po_arg}
    ${view_po_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']
    Common.Scroll And Click Element    ${view_po_btn}
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Common.Element Is Not Visible    ${po_loading}

Click Edit PO
    [Arguments]    ${po_arg}
    ${edit_po_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[normalize-space(.)='Edit Order'][1]
    Common.Scroll And Click Element    ${edit_po_btn}
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Common.Element Is Not Visible    ${po_loading}

Click Print Order
    [Arguments]    ${po_arg}
    ${print_order}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[normalize-space(.)='Print Order'][1]
    Common.Scroll And Click Element    ${print_order}

Click Document Button
    [Arguments]    ${po_arg}
    ${document_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[normalize-space(.)='Documents'][1]
    Common.Scroll And Click Element    ${document_btn}

Click Prior Auth Button
    [Arguments]    ${po_arg}
    ${pa_btn}    Set Variable    //span[normalize-space(.)='${po_arg}']//following::a[normalize-space(.)='Prior Auth'][1]
    Common.Scroll And Click Element    ${pa_btn}

Click View Discontinued Service
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_discontinued_checkbox}

Input Dose (Vials) In Medication Regimen
    [Arguments]    ${dose_arg}
    ${dose_input}    Set Variable    //input[@id="VisitDose_1"]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${dose_input}    ${dose_arg}

Select Loading Or Maintenance
    [Arguments]    ${activate_arg}
    ${activate_regiment_select}    Set Variable    //select[@id="ActivateRegimen_1"]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${activate_regiment_select}    ${activate_arg}

Select Repeat Full Regimen    
    [Arguments]    ${dict_arg}
    ${activate_regiment_select}    Set Variable    //select[@id="RepeatRegimen"]
    ${activate_regiment_frequency_select}    Set Variable    //select[@id="RepeatRegimenFrequency"]
    Common.Choose Random Value From Select List    xpath_arg=${activate_regiment_select}    var_name=activate_regiment    dic=${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${activate_regiment_frequency_select}    var_name=activate_regiment_frequency    dic=${dict_arg}
    
Get Treatment Drug
    [Arguments]    ${existed_treatments}
    ${index}    Get Variable Value    ${index}    1
    ${treatment_xpath}    Set Variable    (//select[@id="PrimaryMedication"]//following::option)[${index}]
    ${treatment_txt}    Wait Until Keyword Succeeds    10s    1s    Get Text    ${treatment_xpath}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index   ${treatment_drug_select}    ${index}
    Sleep    2s
    ${check_diagnosis_visible}    Run Keyword And Return Status    Wait Until Element Does Not Contain    ${primary_icdcode_txt}    No ICD Codes Available    2s
    ${index}    Evaluate    int(${index}) + 1
    Set Suite Variable    ${index}
    IF    '${treatment_txt}' in ${existed_treatments} or '${check_diagnosis_visible}' == '${False}'
        ${treatment_txt}    Get Treatment Drug    ${existed_treatments}
    END
    RETURN    ${treatment_txt}

Click Show Quick View Button In PO Popup
    Wait Until Element Is Visible    //a[contains(text(),'Show Quick View')]    30s
    Common.Scroll And Click Element     //a[contains(text(),'Show Quick View')]
    Wait Until Element Is Visible    //h3[contains(text(),'Quick Select Tool')]    30s

Select Frequency Value Of Lab Descirption In PO Popup
    [Arguments]    ${lab_des_arg}    ${dict_arg}
    ${po_lab_frequency_value}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]
    ${po_lab_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${po_lab_frequency_value}
    Common.Choose Random Value From Select List    xpath_arg=${po_lab_frequency_value}    var_name=po_lab_frequency_value    dic=${dict_arg}
    IF    "${dict_arg.po_lab_frequency_value}" == "${po_lab_frequency_value_txt}"
        Select Frequency Value Of Lab Descirption In PO Popup    ${lab_des_arg}    ${dict_arg}
    END

Select Frequency Unit Of Lab Descirption In PO Popup
    [Arguments]    ${lab_des_arg}    ${dict_arg}
    ${po_lab_frequency_unit}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]
    ${po_lab_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${po_lab_frequency_unit}
    Common.Choose Random Value From Select List    xpath_arg=${po_lab_frequency_unit}    var_name=po_lab_frequency_unit    dic=${dict_arg}
    IF    "${dict_arg.po_lab_frequency_unit}" == "${po_lab_frequency_unit_txt}"
        Select Frequency Unit Of Lab Descirption In PO Popup    ${lab_des_arg}    ${dict_arg}
    END

Verify Data Loaded Exactly In Provider Order Popup
    [Arguments]    ${location_arg} 
            ...    ${po_num_arg} 
            ...    ${patient_name_arg} 
            ...    ${start_date_arg} 
            ...    ${exp_date_arg} 
            ...    ${entry_date_arg} 
            ...    ${diagnosis_arg} 
            ...    ${referral_physician_arg} 
            ...    ${refer_to_provider_arg} 
            ...    ${visit_frequency_value_arg}
            ...    ${visit_frequency_unit_arg}
            ...    ${weight_arg}
            ...    ${height_arg}
            ...    ${split_dose_arg}

    List Selection Should Be    ${ordering_location_select}    ${location_arg}
    SeleniumLibrary.Element Text Should Be    ${po_num_text}    Viewing PO: ${po_num_arg} 
    SeleniumLibrary.Element Text Should Be    //span[@id="PatientNameDispaly"]    ${patient_name_arg}    
    Element Attribute Value Should Be    ${start_date_input}    value    ${start_date_arg}    
    Element Attribute Value Should Be    ${exp_date_input}    value    ${exp_date_arg}    
    Element Attribute Value Should Be    ${entry_date_input}    value    ${entry_date_arg}    
    SeleniumLibrary.Element Text Should Be    ${diagnosis_txt}    ${diagnosis_arg}    
    Element Attribute Value Should Be    ${referral_physician}    value    ${referral_physician_arg}    
    List Selection Should Be    ${refer_to_provider_select}    ${refer_to_provider_arg}    
    List Selection Should Be    ${frequency_value}    ${visit_frequency_value_arg}    
    List Selection Should Be    ${frequency_time}    ${visit_frequency_unit_arg}    
    Element Attribute Value Should Be    ${weight_po_input}    value    ${weight_arg}    
    ${height_value}    SeleniumLibrary.Get Element Attribute    ${height_po_input}    value
    Should Contain    ${height_value}    ${height_arg}
    Element Attribute Value Should Be    ${split_dose}    value    ${split_dose_arg}    

Check Detail Fields Are Disable
    [Arguments]    ${status_arg}
    IF    "${status_arg}" == "view po"
        Element Should Be Disabled    ${ordering_location_select}
        Element Should Be Disabled    ${start_date_input}
        Element Should Be Disabled    ${exp_date_input}
        Element Should Be Disabled    ${refer_to_provider_select}
        Element Should Be Disabled    ${visit_frequency_value_select}
        Element Should Be Disabled    ${visit_frequency_select}
        Element Should Be Disabled    ${weight_po_input}
        Element Should Be Disabled    ${height_po_input}
        Element Should Be Disabled    ${place_of_service}
        Element Should Be Disabled    ${preferred_UoM_select}
        Element Should Be Disabled    ${container_type}
        Element Should Be Disabled    ${number_of_split_dose_treatments}
    END
    Element Should Be Disabled    ${entry_date_input}
    Element Should Be Disabled    ${referral_physician}
    Element Should Be Disabled    ${referral_source_select}
    Element Should Be Disabled    ${route_po_select}
    Element Should Be Disabled    ${dosage_assigned}
    Element Should Be Disabled    ${frequency_value}
    Element Should Be Disabled    ${frequency_time}
    Element Should Be Disabled    ${indexed_dose_input}
    Element Should Be Disabled    ${dosage_caculated}
    Element Should Be Disabled    ${requested_dose_input}
    Element Should Be Disabled    ${split_dose}
