*** Settings ***
Library    ../../../../../libraries/CustomLibrary.py
Resource        ../../../../../libraries/Util.resource
Resource    ../Common/Common.resource

*** Variables ***
# Prior Authorization Ledger
${pa_print_billing_invoice_btn}    //a[@id="invoiceButton"]
${pa_location_select}    //select[contains(@id,'MemberId')]
${pa_filter_patient_input}    //*[@id='PatientId']
${pa_patient_suggestion}    //*[@id='footer']//following-sibling::*[contains(@class,'autocomplete')]//*[contains(text(),'\${patient}')]
${pa_clear_patient_btn}    //*[@type='button' and contains(@class,'patientClearButton')]
${pa_filter_status_select}    //*[@id='AuthorizationStatus']
${pa_range_start_date_input}    //*[@id='StartDate']
${pa_range_end_date_input}    //*[@id='EndDate']
${pa_filter_medication_input}    //*[@id='ItemSearchValues']
${pa_find_medication_btn}    //*[@id='ItemFindButton']
${pa_clear_medication_btn}    //*[@id='ItemClearButton']
${pa_filter_payer_confirmation_num_input}    //*[@id='PayerSearchValues']
${pa_find_payer_confirmation_num_btn}    //*[@id='PayerFindButton']
${pa_clear_payer_confirmation_num_btn}    //*[@id='PayerClearButton']
${pa_filter_medication_type_select}    //*[@id='LedgerMedicationType']
${pa_search_btn}    //*[contains(@class,'SearchBtn') and text()='Search']
${pa_list_loading}    //*[@id='PriorAuthorizationList']//*[contains(@class,'fa-spinner')]
# Provider Order (MDF)
${pa_medication_select}    //*[@id='Medication']
${pa_visit_dose_input}    //*[@id='ModalDoseFrequencyQty']
${pa_route_input}    //input[@id="ModalRouteOfAdmin"]
${pa_frequency_value_select}    //select[@id="FrequencyValue"]
${pa_frequency_unit_select}    //select[@id="DoseFrequencyUnit"]
${pa_infused_over_select}    //select[@id="InfusedOver"]
${pa_container_type_input}    //label[contains(text(),'Container Type:')]//following-sibling::input
${pa_total_dosage_input}    //input[@id="TotalDose"]
${pa_dosage_used_input}    //input[@id="TotalDoseUsed"]
${pa_total_approved_visits_input}    //input[@id="TotalVisits"]
${pa_visits_used_input}    //input[@id="TotalVisitsUsed"]
# PA Status and Confirmation
${pa_prior_auth_status_select}    //*[@id='ModalStatus']
${pa_confirm_num_input}    //*[@id='ModalConfirmationNumber']
${pa_start_date_input}    //*[@id='ModalStartDate']
${pa_end_date_input}    //*[@id='ModalEndDate']
${pa_auth_date_input}    //*[@id='ModalEntryDate']
${pa_rx_number_input}    //*[@id='RxNumber']
${pa_medication_type_select}    //*[@id='MedicationType']
${pa_other_label_input}    //*[@id='PatientInsuranceOtherLabel']
# Payer Information and Margin Calculator
${pa_payer_medicatiton_select}    //select[@id="PriorAuthSearchMedication"]
${pa_add_payer_button}    //*[contains(@onclick,'Payer') and normalize-space(text())='Add']
${pa_edit_payer_button}    //a[@id="PayerEditBtn"]
${pa_payer_name_input}    //*[@id='PriorAuthPayerName']
${pa_payer_email_input}    //*[@id='PriorAuthPayerEmail']
${pa_payer_phone_number_input}    //*[@id='PriorAuthPayerPhoneNumber']
${pa_payer_address_line_input}    //*[@id='PriorAuthPayerAddress']
${pa_payer_city_input}    //*[@id='PriorAuthPayerCity']
${pa_payer_state_select}    //*[@id='PriorAuthPayerState']
${pa_payer_postal_code_input}    //*[@id='PriorAuthPayerZipCode']
${pa_payer_country_region_select}    //*[@id='PriorAuthPayerCountry']
${pa_new_payer_add_button}    //*[@id='SaveBtn' and text()='Add']
${pa_clear_payer_button}    //*[@id='ClearPayerContentsBtn']
${pa_payer_input}    //*[@id='ModalPayer']
${pa_payer_margin_search_button}    //*[normalize-space(text())='Search' and @onclick]
${pa_label_select}    //*[@id='BillingLabelDescription']
${pa_add_label_button}    //*[contains(@onclick,'BillingLabel') and  normalize-space(text())='Add']
${pa_new_billing_label_input}    //*[@id='LabelDescription']
${pa_create_billing_label_button}    //*[@id='SaveBtn' and text()='Create']
${pa_edit_billing_label_button}    //*[@id='EditBillingLabelBtn']
# Notes
${pa_related_notes_input}    //*[@id='NewNote']
${pa_add_note_button}    //*[text()='Add Note' and @onclick]
${pa_additional_notes_input}    //*[@id='ModalPreRequisites']
# Additional Tools
${pa_progress_note_input}    //input[@id="PAModalProgressNote"]
${pa_set_reminder_button}    //*[@type='button' and contains(@onclick,'Reminder')]
${pa_reminder_value_input}    //input[contains(@class,'ReminderValue')]
# PA Footer
${discontinue_service_checkbox}    //input[@id="DiscontinuedService"]
${do_not_bill_checkbox}    //input[@id="DoNotBill"]
${pa_view_changes_button}    //div[@id="ModalPopup"]//*[normalize-space(text())='View Changes']
${pa_close_changelog_button}    //*[contains(@id,'ViewOnlyModalPopup')]//*[@id='CloseModalBtn' and text()='Close']
${pa_update_btn}    //*[@id='ModalPopup']//*[@id='SaveBtn' and text()='Update']

# Payer Plan Information
${pa_medical_payer_plan_checkbox}    //input[@id="MedicalPlanRadio"]
${pa_medical_certificate_number_input}    //input[@id="MedicalCertificateNumber"]
${pa_medical_group_number_input}    //input[@id="MedicalGroupNumber"]
${pa_pharmacy_payer_plan_checkbox}    //input[@id="PharmacyPlanRadio"]
${pa_pharmacy_certificate_number_input}    //input[@id="PharmacyCertificateNumber"]
${pa_pharmacy_group_number_input}    //input[@id="PharmacyGroupNumber"]
${pa_pharmacy_rx_bin_num_input}    //input[@id="RxBinNum"]
${pa_pharmacy_rx_pcn_num_input}    //input[@id="RxPCNNum"]
${pa_pharmacy_rx_group_num_input}    //input[@id="RxGroupNum"]
${pa_pharmacy_plan_effective_date_input}    //input[@id="PlanEffectiveDate"]
${pa_pharmacy_plan_expire_date_input}    //input[@id="PlanExpireDate"]
${pa_payer_plan_add_button}    //*[@id='SaveBtn' and text()='Add']


# ${pa_accept_button}    //*[@id='SaveBtn' and text()='Accept']
# ${close_pa_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
# ${pa_payer_plan_sub_num_input}    //*[@id='MedicalCertificateNumber']
# ${pa_payer_plan_group_num_input}    //*[@id='MedicalGroupNumber']
# ${pa_payer_plan_effect_date_input}    //*[@id='PlanEffectiveDate']
# ${pa_payer_plan_expire_date_input}    //*[@id='PlanExpireDate']

*** Keywords ***
Create Prior Authorizations Dictionary
    &{pa_dict}    Create Dictionary
    RETURN    ${pa_dict}

Go to Prior Authorization Page
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${DispensingLink}
    Click Element    ${DispensingLink}
    Click Element    ${pa_link}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Prior Authorization Ledger

Click Print Billing Invoice Button
    Common.Scroll And Click Element    ${pa_print_billing_invoice_btn}

Filter Location
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${pa_location_select}
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${pa_location_select}    ${location_arg}

Filter Patient
    [Arguments]    ${mrn}
    Click Clear Patient Button
    Wait Until Keyword Succeeds    60s    1s    Input Text    ${pa_filter_patient_input}    ${mrn}
    ${patient_pa_suggestion}    Set Variable    //li[div[contains(text(),'${mrn}')]]
    Wait Until Element Is Visible    ${patient_pa_suggestion}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_pa_suggestion}

Click Clear Patient Button
    Common.Scroll And Click Element    ${pa_clear_patient_btn}
    Common.Element Is Not Visible    ${pa_list_loading}
    Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    ${pa_filter_patient_input}    placeholder    -- All Patients --

Filter Status
    [Arguments]    ${status}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${pa_filter_status_select}    ${status}

Filter By End Date Range
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Input Start Date    ${startdate_arg}
    Input End Date    ${enddate_arg}
    
Input Start Date
    [Arguments]    ${startdate_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${pa_range_start_date_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_range_start_date_input}    ${startdate_arg}
    Common.Choose Date In Onset Date Input    ${startdate_arg}

Input End Date
    [Arguments]    ${enddate_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${pa_range_end_date_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_range_end_date_input}    ${enddate_arg}
    Common.Choose Date In Onset Date Input    ${enddate_arg}

Search Medication
    [Arguments]    ${medication_arg}
    Click Clear Medication Button
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_filter_medication_input}    ${medication_arg}
    Click Find Medication Button

Click Clear Medication Button
    Common.Scroll And Click Element    ${pa_clear_medication_btn}
    Common.Element Is Not Visible    ${pa_list_loading}
    Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    ${pa_filter_patient_input}    placeholder    Search for Item #, NDC, Manufacturer, Description...

Click Find Medication Button
    Common.Scroll And Click Element    ${pa_find_medication_btn} 
    Common.Element Is Not Visible    ${pa_list_loading}

Search Payer And Confirmation Num
    [Arguments]    ${payer_arg}
    Click Clear Payer And Confirmation Num Search Button
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_filter_payer_confirmation_num_input}    ${payer_arg}
    Click Find Payer And Confirmation Num Search Button

Click Find Payer And Confirmation Num Search Button
    Common.Scroll And Click Element    ${pa_find_payer_confirmation_num_btn} 
    Common.Element Is Not Visible    ${pa_list_loading}

Click Clear Payer And Confirmation Num Search Button
    Common.Scroll And Click Element    ${pa_clear_payer_confirmation_num_btn}
    Common.Element Is Not Visible    ${pa_list_loading}
    Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    ${pa_filter_patient_input}    placeholder    Search for Payer Description or Confirmation #

Filter Medication Type
    [Arguments]    ${type_arg}
    Wait Until Element Is Enabled    ${pa_filter_medication_type_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${pa_filter_medication_type_select}    ${type_arg}

Click Search PA
    Common.Scroll And Click Element    ${pa_search_btn}
    Common.Element Is Not Visible    ${pa_list_loading}

Select Assigned Specialist
    [Arguments]    ${dict_arg}    ${po_num}
    Common.Choose Random Value From Select List    xpath_arg=(//*[contains(@onclick,'CreateEditPatientOrderModal') and contains(text(),'${po_num}')])//preceding::select[@id="item_AssignedToUserID"][1]    var_name=assigned_specialist    dic=${dict_arg}
    Common.Page Alert Message    User Successfully Assigned!

View PA
    [Arguments]    ${po_num}
    ${pa_row}    Set Variable    (//*[contains(@onclick,'CreateEditPatientOrderModal') and contains(text(),'${po_num}')])//preceding::td[@data-column="6"][1]
    Common.Scroll And Click Element    ${pa_row}
    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[contains(@class,'modal-title') and text()='Prior Authorization']    60s

Click Document Button In PA Page
    [Arguments]    ${po_num}
    ${document_btn}    Set Variable    (//*[contains(@onclick,'CreateEditPatientOrderModal') and contains(text(),'${po_num}')])//preceding::a[contains(text(),'Documents')][1]
    Common.Scroll And Click Element    ${document_btn}
    Wait Until Page Contains    Patient Document Center     30s

Click Edit PA Button
    [Arguments]    ${po_num}
    ${edit_pa_btn}    Set Variable    (//*[contains(@onclick,'CreateEditPatientOrderModal') and contains(text(),'${po_num}')])//preceding::a[contains(text(),'Edit Prior Auth ')][1]
    Common.Scroll And Click Element    ${edit_pa_btn}
    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[contains(@class,'modal-title') and text()='Prior Authorization']    30s

Click Insurance Verification Button In PA Page
    [Arguments]    ${po_num}
    ${insurance_verification_btn}    Set Variable    //*[normalize-space(text())='${po_num}']//preceding::a[contains(@class,'InsuranceVerification')][1]
    Common.Scroll And Click Element    ${insurance_verification_btn}

Click PO Button In PA Page
    [Arguments]    ${po_num}
    ${po_btn}    Set Variable    //*[normalize-space(text())='${po_num}']
    Common.Scroll And Click Element    ${po_btn}
    Wait Until Element Is Visible    //h4[text()='Provider Order']    30s

# Provider Order (MDF)
Input Total Dosage In MDF
    [Arguments]    ${dosage_value}
    Scroll Element Into View    ${PA_total_dosage_input}
    Wait Until Element Is Visible    ${PA_total_dosage_input}    30s
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${PA_total_dosage_input}    ${dosage_value}

Input Total Approved Visits In MDF
    [Arguments]    ${visit_value}
    Wait Until Element Is Visible    ${PA_total_approved_visits_input}    30s
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${PA_total_approved_visits_input}    ${visit_value}

Click Edit Visits Used
    Common.Scroll And Click Element    //button[@id="editVisitsUsed"]

Input Visits Used In MDF
    [Arguments]    ${visits_used_value}
    Wait Until Element Is Visible    //input[@id="TotalVisitsUsed"]    30s
    Wait Until Keyword Succeeds    5s    1s    Input Text    //input[@id="TotalVisitsUsed"]    ${visits_used_value}

# PA Status and Confirmation
Select Prior Auth Status In PA Status and Confirmation
    [Arguments]    ${status_arg}
    Wait Until Element Is Enabled    ${pa_prior_auth_status_select}    30s
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${pa_prior_auth_status_select}    ${status_arg}

Input Confirmation Number In PA Status and Confirmation
    [Arguments]    ${number_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${pa_confirm_num_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_confirm_num_input}    ${number_arg}

Input Start Date In PA Status and Confirmation
    [Arguments]    ${startdate_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${pa_start_date_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_start_date_input}    ${startdate_arg}
    Common.Choose Date In Onset Date Input    ${startdate_arg}

Input End Date In PA Status and Confirmation
    [Arguments]    ${enddate_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${pa_end_date_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${pa_end_date_input}    ${enddate_arg}
    Common.Choose Date In Onset Date Input    ${enddate_arg}

Input Auth Entry Date In PA Status and Confirmation
    [Arguments]    ${authdate_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${PA_auth_date_input}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${PA_auth_date_input}    ${authdate_arg}
    Common.Choose Date In Onset Date Input    ${authdate_arg}

Input RX Number
    [Arguments]    ${rx_arg}
    Scroll Element Into View    ${pa_rx_number_input}
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${pa_rx_number_input}    ${rx_arg}

Select PA Medication Type
    [Arguments]    ${dict_arg}    ${value}=random
    IF    "${value}" == "random"
        Common.Choose Random Value From Select List    xpath_arg=${pa_medication_type_select}    var_name=medication_type    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    10 times    3s    Select From List By Label    ${pa_medication_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    medication_type=${value}
    END

Select Pharmacy
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=//*[@id="Pharmacy"]    var_name=pharmacy    dic=${dict_arg}

Input Other Payer Label
    [Arguments]    ${label}
    Scroll Element Into View    ${pa_other_label_input}
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${pa_other_label_input}    ${label}

# Payer Information and Margin Calculator
Select Medication In Payer Information and Margin Calculator
    [Arguments]    ${medicaion_arg}
    Wait Until Element Is Enabled    ${pa_payer_medicatiton_select}    30s
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${pa_payer_medicatiton_select}    ${medicaion_arg}

Open Add Payer Popup
    Common.Scroll And Click Element    ${pa_add_payer_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    30s

Open Update Payer Popup
    Common.Scroll And Click Element    ${pa_add_payer_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    30s

Input Payer Name In Payer Popup
    [Arguments]    ${payer_name_arg}
    Wait Until Element Is Visible    ${pa_payer_name_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_name_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_name_input}    ${payer_name_arg}

Input Payer Email In Payer Popup
    [Arguments]    ${email_arg}
    Wait Until Element Is Visible    ${pa_payer_email_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_email_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_email_input}    ${email_arg}

Input Payer Phone Number In Payer Popup
    [Arguments]    ${phone_arg}
    Wait Until Element Is Visible    ${pa_payer_phone_number_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_phone_number_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_phone_number_input}    ${phone_arg}

Input Address Line In Payer Popup
    [Arguments]    ${address_arg}
    Wait Until Element Is Visible    ${pa_payer_address_line_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_address_line_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_address_line_input}    ${address_arg}

Input City In Payer Popup
    [Arguments]    ${city_arg}
    Wait Until Element Is Visible    ${pa_payer_city_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_city_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_city_input}    ${city_arg}

Select State In Payer Popup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${pa_payer_state_select}    var_name=payer_state    dic=${dict_arg}

Input Postal Code In Payer Popup
    [Arguments]    ${code_arg}
    Wait Until Element Is Visible    ${pa_payer_postal_code_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_payer_postal_code_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_postal_code_input}    ${code_arg}

Select Country Region In Payer Popup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${pa_payer_country_region_select}    var_name=payer_country_region    dic=${dict_arg}

Click Add New Payer
    Common.Scroll And Click Element    ${pa_new_payer_add_button}
    Common.Page Alert Message    Payer Information Added

Click Close Payer Popup
    Common.Close SubModal Popup

Add New Payer With Required Fields
    [Arguments]    ${payer_name_arg}    ${address_arg}
    Open Add Payer Popup
    Input Payer Name In Payer Popup    ${payer_name_arg}
    Input Address Line In Payer Popup    ${address_arg}
    Click Add New Payer

Choose Payer In Payer Information and Margin Calculator
    [Arguments]    ${payer_name_arg}
    Click Clear Payer Button
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_payer_input}    ${payer_name_arg}
    ${pa_payer_suggesstion}    Set Variable    //*[contains(@class,'tt-highlight') and text()='${payer_name_arg}']
    Wait Until Element Is Visible    ${pa_payer_suggesstion}    15s
    Click Element    ${pa_payer_suggesstion}
    Press Keys    ${pa_payer_input}    TAB  

Click Clear Payer Button
    Common.Scroll And Click Element    ${pa_clear_payer_button}

Click Search Payer Button
    Scroll Element Into View    ${pa_payer_margin_search_button}
    Wait Until Keyword Succeeds    10 times    3s   Click Element    ${pa_payer_margin_search_button}

Select Billing Label
    [Arguments]    ${label_arg}
    Wait Until Element Is Enabled    ${pa_label_select}    30s
    Wait Until Keyword Succeeds    10 times    3s    Select From List By Label    ${pa_label_select}    ${label_arg}

Click Add Billing Label
    Common.Scroll And Click Element    ${pa_add_label_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    30s

Input New Billing Label
    [Arguments]    ${label_arg}
    Wait Until Element Is Visible    ${pa_new_billing_label_input}    30s
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${pa_new_billing_label_input}    ${label_arg}

Click Create New Billing Label
    Common.Scroll And Click Element    ${pa_create_billing_label_button}

Click Edit Billing Label
    Common.Scroll And Click Element    ${pa_edit_billing_label_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    30s

Click Delete Billing Label
    Common.Scroll And Click Element    //*[@id='SubModalPopup']//button[@id="DeleteBtn"]
    Handle Alert    ACCEPT
    Common.Page Alert Message    Billing Label has been deleted.

Add Billing Label
    [Arguments]    ${label_arg}
    ${label_list}    Get List Items    ${pa_label_select}
    ${check}    Run Keyword And Return Status    Should Contain    ${label_list}    ${label_arg}
    IF    "${check}" == "${True}"    
        Delete Billing Label    ${label_arg}
    END
    Click Add Billing Label
    Input New Billing Label    ${label_arg}
    Click Create New Billing Label
    Common.Page Alert Message    Billing Label has been Created.
  
Delete Billing Label
    [Arguments]    ${label_arg}
    Select Billing Label    ${label_arg}
    Click Edit Billing Label
    Click Delete Billing Label

# Benefits Investigation
Select Secondary Payer
    [Arguments]    ${second_payer_arg}
    Wait Until Element Is Enabled    //select[@id="PASecondaryPayer"]    30s
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    //select[@id="PASecondaryPayer"]    ${second_payer_arg}

# Notes
Input Notes
    [Arguments]    ${text}
    Wait Until Element Is Visible    ${pa_related_notes_input}    30s
    Scroll Element Into View    ${pa_related_notes_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_related_notes_input}    ${text}

Click Add Note
    Common.Scroll And Click Element    ${pa_add_note_button}
    Alert Should Be Present    Are you sure you are all ready to submit this note?    ACCEPT
    Common.Page Alert Message    Prior Authorization Note Successfully Added

# Coding Details
Get Cpt Code Description Text
    [Arguments]    ${cpt_code_arg}
    ${cptcode_description}    Set Variable    //tr[.//strong[normalize-space(text())="${cpt_code_arg}"]]//span
    ${cptcode_description_txt}    Wait Until Keyword Succeeds    10 times    3s   Get Text    ${cptcode_description}
    RETURN    ${cptcode_description_txt}

Click Toggle Cpt Code Checkbox
    [Arguments]    ${cpt_code_arg}
    ${toggle_cptcode_checkbox}    Set Variable    //tr[.//strong[normalize-space(text())="${cpt_code_arg}"]]//input[@class="largeCheckbox"]
    Common.Scroll And Click Element    ${toggle_cptcode_checkbox}
    Common.Page Alert Message    Successfully Assigned CPT Code

# Addtional Tools
Input Progress Note
    [Arguments]    ${note_arg}
    Wait Until Element Is Visible    ${pa_progress_note_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_progress_note_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_progress_note_input}    ${note_arg}

Input Reminder Value
    [Arguments]    ${reminder_value_arg}
    Wait Until Element Is Visible    ${pa_reminder_value_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Clear Element Text    ${pa_reminder_value_input}
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_reminder_value_input}    ${reminder_value_arg}

Click Set Reminder Button
    Wait Until Element Is Enabled    ${pa_set_reminder_button}
    Common.Scroll And Click Element    ${pa_set_reminder_button}
    Common.Page Alert Message    Prior Authorization Notifications Updated!

# PA Footer
Click Discontinue Service Checkbox
    Common.Scroll And Click Element    ${discontinue_service_checkbox}

Click Do Not Bill Checkbox
    Common.Scroll And Click Element    ${do_not_bill_checkbox}

Click View Change Button
    Common.Scroll And Click Element    ${pa_view_changes_button}
    Wait Until Element Is Visible    //*[contains(@class,'title') and text()='Prior Authorization Changelog']    30s

Click Close PA Changelog
    Common.Scroll And Click Element    ${pa_close_changelog_button}
    Wait Until Element Is Not Visible    //*[contains(@class,'title') and text()='Prior Authorization Changelog']    30s

Click Update Button
    Common.Scroll And Click Element    ${pa_update_btn}

# Payer Plan Information
Add Medical Payer Plan
    [Arguments]    ${number_arg}    ${date_arg}
    Click Medical Payer Plan Checkbox
    Input Medical Certificate Number    ${number_arg}
    Input Medical Group Number    ${number_arg}
    Input Plan Effective Date    ${date_arg}
    Click Payer Plan Button    Payer added to Patient.

Click Medical Payer Plan Checkbox
    Common.Scroll And Click Element    ${pa_medical_payer_plan_checkbox}

Input Medical Certificate Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_medical_certificate_number_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_medical_certificate_number_input}    ${number_arg}

Input Medical Group Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_medical_group_number_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_medical_group_number_input}    ${number_arg}

Add Pharmacy Payer Plan
    [Arguments]    ${number_arg}    ${date_arg}
    Click Pharmacy Payer Plan Checkbox
    Input Pharmacy Certificate Number    ${number_arg}
    Input Pharmacy Group Number    ${number_arg}
    Input Pharmacy Rx BIN Number    ${number_arg}
    Input Pharmacy Rx PCN Number    ${number_arg}
    Input Pharmacy Rx Group    ${number_arg}
    Input Plan Effective Date    ${date_arg}
    Click Payer Plan Button    Payer added to Patient.

Click Pharmacy Payer Plan Checkbox
    Common.Scroll And Click Element    ${pa_pharmacy_payer_plan_checkbox}

Input Pharmacy Certificate Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_certificate_number_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_certificate_number_input}    ${number_arg}

Input Pharmacy Group Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_group_number_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_group_number_input}    ${number_arg}

Input Pharmacy Rx BIN Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_rx_bin_num_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_rx_bin_num_input}    ${number_arg}

Input Pharmacy Rx PCN Number
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_rx_pcn_num_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_rx_pcn_num_input}    ${number_arg}

Input Pharmacy Rx Group
    [Arguments]    ${number_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_rx_group_num_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_rx_group_num_input}    ${number_arg}

Input Plan Effective Date
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_plan_effective_date_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_plan_effective_date_input}    ${date_arg}
    Common.Choose Date In Onset Date Input    ${date_arg}

Input Plan Expiration Date
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    ${pa_pharmacy_plan_expire_date_input}    30s
    Wait Until Keyword Succeeds    10 times    3s   Input Text    ${pa_pharmacy_plan_expire_date_input}    ${date_arg}
    Common.Choose Date In Onset Date Input    ${date_arg}

Click Payer Plan Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    ${pa_payer_plan_add_button}
    Common.Page Alert Message    ${msg}
