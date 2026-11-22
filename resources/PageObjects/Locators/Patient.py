# Patients page
Patients_Location_Select="id=CustomerAccountId"
Find_Patient_Input="//*[@id='SearchValues']"
Find_Patient_Btn="//*[@id='FindButton' and starts-with(text(),'Find')]"
patient_preimport_status_text="//*[@id='PreProcess']//*[@style='color:${color}' and normalize-space(text())='${text}']"    #green-success
cancel_btn="//a[contains(text(),'Cancel')]"
patient_upload_file_input="//*[@id='UploadFile']"
patient_process_file_button="//*[@id='SaveBtn' and normalize-space(text())='Process File']"
patient_template_download_button="//*[@onclick and normalize-space(text())='Download Template']"
Insurance_Name_Select="//*[@id='PrimaryPayer']"
# Update A Patient page
Patient_MRN_Text="//*[@id='PatientList']//*[@class='CenterAll' and text()='${MRN}']"
patient_img=Patient_MRN_Text+"//preceding-sibling::*[3]/*[@class='patientListImage']"
patient_name_text=Patient_MRN_Text+"//preceding-sibling::*[2]/*[@href]" #*[text()='${name}']
patient_DOB_text=Patient_MRN_Text+"//preceding-sibling::*[1]"
patient_contact_text=Patient_MRN_Text+"//following-sibling::*[1]/*"
patient_gender_text=Patient_MRN_Text+"//following-sibling::*[2]"
patient_badge_link="//*[contains(@class,'badge') and contains(text(),'${text}')]/parent::*[@href]/*"
patient_inactive_icn=Patient_MRN_Text+"//following-sibling::*[3]/*[contains(@class,'fa-check')]"
Patient_MRN_Input="//*[text()='Medical Record #']/following::*[@id='MRN' and @value='${MRN}']"
Delete_Patient_Link="//*[@id='DeletePatientButton']"
New_Patient_Link="//*[starts-with(@onclick,'CreateNewPatient')]"
First_Name_Input="//*[@id='FirstName']"
Last_Name_Input="//*[@id='LastName']"
Middle_Name_Input="//*[@id='MiddleName']"
MRN_Input="//*[@id='MRN']"
DOB_Input="//*[@id='DOB']"
Close_Calendar_Btn="//*[@type='button' and contains(@class,'datepicker') and text()='Done']"
Gender_Select="//*[@id='Gender']"
Phone_input="//*[@id='Phone']"
Email_input="//*[@id='Email']"
Weight_Input="//*[@id='Weight']"
Height_Input="//*[@id='Height']"
Weight_LB_Input="//*[@id='WeightLB']"
Patients_Save_Btn="//*[@id='ContinueButton']"
Patients_Update_Btn="//*[@id='SaveButton']"
# Patients_Save_Btn="//*[@id='SaveButton']"
# Patients_Update_Btn="//*[@id='ContinueButton']"
Advanced_Search_Btn="//*[starts-with(@onclick,'DisplayAdvancedSearch') and text()='Advanced Search']"
advanced_search_text="//*[@id='AdvancedSearchDiv']//*[text()='Advanced Search']"
Inactive_Patient_Checkbox="//*[@id='Inactive']"
Search_Patient_Loading="//*[@id='loading-indicator']"
Inactive_Patient_MRN_Text="//*[@id='PatientList']//*[@class='CenterAll' and *[contains(@class,'fa-check')]]//preceding::*[@class='CenterAll' and text()='${MRN}']"
Show_Inactive_Patient_Checkbox="//*[@id='showInactive']"
advanced_clear_btn="//a[contains(text(),'Clear')]"
Patients_Clear_Btn="//*[@id='ClearButton']"
Patients_Page_Link="//*[text()='Patients' and @href]"
MB_Logo="//*[@id='MainBrandingImage']"
Delete_Patient_Msg="//*[@data-notify='message' and contains(text(),'Can not delete patient because they have been assigned to an appointment') and contains(text(),'Please make the patient inactive')]"
Cancel_Update_Patient_Btn="//*[@href and text()='Cancel']"
Patient_Tools_Btn="//*[@type='button'and contains(text(),'Patient Tools')]"
Merge_Patient_Link="//*[@id='MergePatients' and contains(@onclick,'PatientMergeModal')]"
Merge_Patient_Popup="//*[@class='modal-title' and text()='Patient Merge Helper']"
Removing_Input="//*[@id='RemovingPatient']"
Merge_Patient_Text="//*[contains(@class,'selectable') and contains(text(),'MRN:') and *[text()='${Merge_MRN}']]"
Keeping_Input="//*[@id='KeepingPatient']"
Merge_Btn="//*[@id='SaveBtn' and text()='Merge']"
save_changes_btn="//*[contains(text(),'Save Changes!') and @onclick]"
# Appointments tab
patient_APT_tab="//*[@id='Appointment']"
patient_APT_tab_header="//*[@id='AppointmentTabList']//*[normalize-space(text())='Scheduled Appointments']"
patient_APT_tab_time_text="//*[@class='DateOfServiceLabel' and text()='${date}']//following::*[text()='${time}']"
patient_APT_tab_open_button=patient_APT_tab_time_text+"//following::*[text()='Open Appointment'][1]"
# Create A Patient page
Social_Security_input="xpath://*[@id='SSN']"
Race_select="xpath://*[@id='Race']"
Ethnicity_select="xpath://*[@id='Ethnicity']"
Marital_Status_select="xpath://*[@id='MaritalStatus']"
PreferredInternalProvider_select="xpath://*[@id='ReferringDoctor']"
Home_Phone_input="xpath://*[@id='Phone']"
Work_Phone_input="xpath://*[@id='WorkPhone']"
Cell_Phone_input="xpath://*[@id='Cellphone']"
Email_input="xpath://*[@id='Email']"
Address_Line1_input="xpath://*[@id='DefaultAddressLine1']"
Address_Line2_input="xpath://*[@id='DefaultAddressLine2']"
City_input="xpath://*[@id='DefaultCity']"
State_select="xpath://*[@id='DefaultStateProvince']"
Postal_Code_input="xpath://*[@id='DefaultPostalCode']"
Country_input="xpath://*[@id='DefaultCountryRegion']"
PrimaryPayer_select="xpath://*[@id='PrimaryPayer']"
SecondaryPayer_select="xpath://*[@id='SecondaryPayer']"
TertiaryPayer_select="xpath://*[@id='TertiaryPayer']"
PrimaryPayerPlan_select="xpath://*[@id='SelectedPrimaryPayerPlan']"
Subscriber_input="xpath://*[@id='PrimaryPayerCertificateNumber']"
Group_input="xpath://*[@id='PrimaryPayerGroupNumber']"
EffectiveDate_input="xpath://*[@id='PrimaryPayerEffectiveDate']"
ExpirationDate_input="xpath://*[@id='PrimaryPayerExpirationDate']"
# Update A Patient - Appointments tab
Appointment_ID="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[1]/div[1]/strong"
Patient_ID="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[1]/div[1]/strong"
Service_Type="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[1]/div[2]"
Patient_MRN="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[2]/div[1]/div[2]"
Payer_Name="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[1]/div[3]"
Weigth="xpath://*[@id='WeightButton_MTAzODk1MQ__']"
ICD_Code="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[2]/div[3]/text()"
Start_Time="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[3]/div[1]/div/input"
Stop_Time="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[2]/div[2]/div[3]/div[2]/div/input"
Referring_Provider="xpath://*[@id='ApptNoteDiv_MTAzOTYzMw__']/div[1]/div[2]/span/input[2]"
Refer_To_Provider="xpath://*[@id='ApptNoteDiv_MTAzOTYzMw__']/div[2]/div[2]/span/input[2]"
Supervising_Provider="xpath://*[@id='ApptNoteDiv_MTAzODk1MQ__']/div[3]/div[2]/span/input[2]"
Rendering_Provider="xpath://*[@id='ApptNoteDiv_MTAzODk1MQ__']/div[4]/div[2]/span/input[2]"
Treatment_Clinician="xpath://*[@id='item_NurseId']"
Preparing_Clinician="xpath://*[@id='item_PreparedBy']/optgroup/option"
Appointment_Note="xpath://*[@id='ApptNoteTextArea_MTAzOTYzMw__']"
EMR_Appointment_Event_Description="xpath://*[@id='ApptMedColumn_MTAzODk1MQ__']/strong"
DateOfService="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[1]/div[2]/strong"
Appt_Time="xpath://*[@id='AppointmentTabList']/table/tbody/tr[3]/td[1]/div[3]/strong"
close_modal_btn="//button[@id='CloseModalBtn']"
#Patient Identifiers
# First_Name_Input="//*[@id='FirstName']"
Middle_Name_Input="//*[@id='MiddleName']"
# Last_Name_Input="//*[@id='LastName']"
# MRN_Input="//*[@id='MRN']"
# DOB_Input="//*[@id='DOB']"
existing_modal_form="//form//strong[contains(text(),'A patient within this account already contains the MRN: ${PatientCreate.MRN}')]"
SSN_Input="//*[@id='SSN']"
# Close_Calendar_Btn="//*[@type='button' and contains(@class,'datepicker') and text()='Done']"
Race_Select="//*[@id='Race']"
other_detail_input="//*[@id='RaceOtherDescription']"
Ethnicity_Select="//*[@id='Ethnicity']"
# Gender_Select="//*[@id='Gender']"
MaritalStatus_Select="//*[@id='MaritalStatus']"
Spouse_First_Name_Input="//*[@id='SpouseFirstName']"
Spouse_Middle_Name_Input="//*[@id='SpouseMiddleName']"
Spouse_Last_Name_Input="//*[@id='SpouseLastName']"
physician_select="//*[@id='ReferringDoctor']"
reffering_provider_input="//*[@id='PatientReferringProvider']"
refering_provide_strong="//div//strong[contains(text(),'${PatientData.Refering_Provider}')]"
PCP_select="//*[@id='PCPProvider']"
#Health Information
alert_note_textarea_input="//textarea[@id='AlertNote']"
weight_LP_input="//*[@id='WeightLB']"
weight_LP_title="//label[contains(text(),'Weight (Pounds)')]"
weight_KG_input="//*[@id='Weight']"
weight_KG_title="//label[contains(text(),'Weight (Kilograms)')]"
# Height_Input="//*[@id='Height']"
BMI_text="//div//span[@id='BMICalculation']"
#Personal Information
default_contact_select="//*[@id='DefaultContact']"
home_phone_input="//*[@id='Phone']"
cell_phone_input="//*[@id='Cellphone']"
email_input="//*[@id='Email']"
additional_notes_input="//*[@id='Notes']"
#Employer Information
occupation_input="//*[@id='Occupation']"
employer_name_input="//*[@id='EmployerName']"
work_phone_input="//*[@id='WorkPhone']"
employer_first_name_input="//*[@id='EmployerFirstName']"
employer_last_name_input="//*[@id='EmployerLastName']"
employer_phone_input="//*[@id='EmployerPhone']"
employer_address1_input="//*[@id='EmployerAddress1']"
employer_address2_input="//*[@id='EmployerAddress2']"
employer_city_input="//*[@id='EmployerCity']"
employer_state_select="//*[@id='EmployerState']"
employer_zip_input="//*[@id='EmployerZip']"
employer_country_select="//*[@id='EmployerCountry']"
#Responsible Information
responsible_firstName_input="//*[@id='ResponsibleFirstName']"
responsible_middleName_input="//*[@id='ResponsibleMiddleName']"
responsible_lastName_input="//*[@id='ResponsibleLastName']"
responsible_phone_input="//*[@id='ResponsiblePhone']"
responsible_DOB_input="//*[@id='ResponsibleDOB']"
responsible_SSN_input="//*[@id='ResponsibleSSN']"
responsible_address1_input="//*[@id='ResponsibleAddress1']"
responsible_address2_input="//*[@id='ResponsibleAddress2']"
responsible_city_input="//*[@id='ResponsibleCity']"
responsible_state_select="//*[@id='ResponsibleState']"
responsible_zip_input="//*[@id='ResponsibleZip']"
responsible_country_select="//*[@id='ResponsibleCountry']"
#Emergency Contact Information
emergency_name_input="//*[@id='EmergencyContactName']"
emergency_phone_input="//*[@id='EmergencyContactPhone']"
emergency_relationship_input="//*[@id='EmergencyContactRelationship']"
#Medical Payer / Insurance Information - Primary Payer / Insurance
primary_assign_select="//*[@id='PrimaryPayer']"
primary_payer_select="//*[@id='SelectedPrimaryPayerPlan']"
primary_subscriber_input="//*[@id='PrimaryPayerCertificateNumber']"
primary_group_input="//*[@id='PrimaryPayerGroupNumber']"
primary_effective_input="//*[@id='PrimaryPayerEffectiveDate']"
primary_expiration_input="//*[@id='PrimaryPayerExpirationDate']"
#Medical Payer / Insurance Information - Secondary Payer / Insurance
secondary_assign_select="//*[@id='SecondaryPayer']"
secondary_payer_select="//*[@id='SelectedSecondaryPayerPlan']"
secondary_subscriber_input="//*[@id='SecondaryPayerCertificateNumber']"
secondary_group_input="//*[@id='SecondaryPayerGroupNumber']"
secondary_effective_input="//*[@id='SecondaryPayerEffectiveDate']"
secondary_expiration_input="//*[@id='SecondaryPayerExpirationDate']"
#Medical Payer / Insurance Information - Tertiary Payer / Insurance
tertiary_assign_select="//*[@id='TertiaryPayer']"
tertiary_payer_select="//*[@id='SelectedTertiaryPayerPlan']"
tertiary_subscriber_input="//*[@id='TertiaryPayerCertificateNumber']"
tertiary_group_input="//*[@id='TertiaryPayerGroupNumber']"
tertiary_effective_input="//*[@id='TertiaryPayerEffectiveDate']"
tertiary_expiration_input="//*[@id='TertiaryPayerExpirationDate']"
#Pharmacy Payer / Insurance Information - Primary Pharmacy Payer / Insurance
pharmacy_primary_assign_select="//*[@id='PrimaryPharmacyPayer']"
pharmacy_primary_payer_select="//*[@id='SelectedPrimaryPharmacyPayerPlan']"
pharmacy_primary_subscriber_input="//*[@id='PrimaryPharmacyPayerCertificateNumber']"
pharmacy_primary_group_input="//*[@id='PrimaryPharmacyPayerGroupNumber']"
pharmacy_primary_BIN_input="//*[@id='PrimaryPharmacyPayerBIN']"
pharmacy_primary_PCN_input="//*[@id='PrimaryPharmacyPayerPCN']"
pharmacy_primary_RXgroup_input="//*[@id='PrimaryPharmacyPayerRxGroup']"
pharmacy_primary_effective_input="//*[@id='PrimaryPharmacyPayerEffectiveDate']"
pharmacy_primary_expiration_input="//*[@id='PrimaryPharmacyPayerExpirationDate']"
#Pharmacy Payer / Insurance Information - Secondary Pharmacy Payer / Insurance
pharmacy_secondary_assign_select="//*[@id='SecondaryPharmacyPayer']"
pharmacy_secondary_payer_select="//*[@id='SelectedSecondaryPharmacyPayerPlan']"
pharmacy_secondary_subscriber_input="//*[@id='SecondaryPharmacyPayerCertificateNumber']"
pharmacy_secondary_group_input="//*[@id='SecondaryPharmacyPayerGroupNumber']"
pharmacy_secondary_BIN_input="//*[@id='SecondaryPharmacyPayerBIN']"
pharmacy_secondary_PCN_input="//*[@id='SecondaryPharmacyPayerPCN']"
pharmacy_secondary_RXgroup_input="//*[@id='SecondaryPharmacyPayerRxGroup']"
pharmacy_secondary_effective_input="//*[@id='SecondaryPharmacyPayerEffectiveDate']"
pharmacy_secondary_expiration_input="//*[@id='SecondaryPharmacyPayerExpirationDate']"
#Pharmacy Payer / Insurance Information - Tertiary Pharmacy Payer / Insurance
pharmacy_tertiary_assign_select="//*[@id='TertiaryPharmacyPayer']"
pharmacy_tertiary_payer_select="//*[@id='SelectedTertiaryPharmacyPayerPlan']"
pharmacy_tertiary_subscriber_input="//*[@id='TertiaryPharmacyPayerCertificateNumber']"
pharmacy_tertiary_group_input="//*[@id='TertiaryPharmacyPayerGroupNumber']"
pharmacy_tertiary_BIN_input="//*[@id='TertiaryPharmacyPayerBIN']"
pharmacy_tertiary_PCN_input="//*[@id='TertiaryPharmacyPayerPCN']"
pharmacy_tertiary_RXgroup_input="//*[@id='TertiaryPharmacyPayerRxGroup']"
pharmacy_tertiary_effective_input="//*[@id='TertiaryPharmacyPayerEffectiveDate']"
pharmacy_tertiary_expiration_input="//*[@id='TertiaryPharmacyPayerExpirationDate']"
#Error Message
error_first_name="(//li[contains(text(),'First Name')])[1]"
error_last_name="(//li[contains(text(),'Last Name')])[1]"
error_MRN_name="(//li[contains(text(),'Medical Record #')])[1]"
error_DOB_name="(//li[contains(text(),'Date Of Birth')])[1]"
error_gender_name="(//li[contains(text(),'Gender')])[1]"
# Protocol Management
protocol_search_input="//input[@id='ProtocolSearchTerms']"
protocol_clear_btn="//button[@id='ProtocolClearButton']"
protocol_find_btn="//button[@id='ProtocolFindButton']"
protocol_location_select="//select[@id='LocationID']"
protocol_assign_lab_btn="//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Assign Labs to this Medication')][1]"
protocol_show_view_btn="//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Show Quick View')][1]"
protocol_assign_lab_checkbox="(//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Hide Quick View')][1]//following::tbody//tr[${lab_tr}]//td//input)[${lab_index}]"
protocol_assign_lab_strong="(//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Hide Quick View')][1]//following::tbody//tr[${lab_tr}]//td//strong)[${lab_index}]"
protocol_lab_search="//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Hide Quick View')][1]//following::input[contains(@class,'QuickSelectLabsSearchText')]"
protocol_lab_find_btn="//strong[contains(text(),'${drug_PO1}')]//following::a[contains(text(),'Hide Quick View')][1]//following::button[contains(text(),'Find')]"
manage_btn="//button[contains(text(),'Manage')]"
manage_protocol_link="//a[@onclick='ProtocolManagementModal()']"
protocol_loading_icon_i="//i[@class='fa fa-spinner fa-4x fa-spin']"
protocol_loading_icon="//div[@class='fas fa-spin fa-spinner fa-4x']"
protocol_title_modal="//h4[contains(text(),'Protocol Management Modal')]"
protocol_close_btn="//div[@id='ModalPopup']//button[@id='TopCloseBtn']"
protocol_frequency_value="//div[@class='RequiredLabsTable']//tbody//tr[not(contains(@class,'hidden'))]//td[1]//following::select[contains(@id, 'FrequencyValueDropdown')]"
protocol_frequency_select="//div[@class='RequiredLabsTable']//tbody//tr[not(contains(@class,'hidden'))]//td[1]//following::select[contains(@id, 'FrequencyUnitDropdown')]"
protocol_lab_assigned_checkbox="//div[@class='RequiredLabsTable']//tbody//tr[not(contains(@class,'hidden'))]//td[1]//input"
protocol_select_tool_title="//h3[contains(text(),'Quick Select Tool')]"
protocol_required_lab_title="//h3[contains(text(),'Required Labs')]"
protocol_edit_treament_btn="//a[contains(text(),'Edit Treatment Protocol')]"

#Lab Tracker
lab_tracker_tab="//a[@id='LabTracker']"
tracker_add_lab_btn="//span[@id='AddLabTrackerButton']"
tracker_add_lab_title="//h4[contains(text(),'Add Lab Tracker')]"
tracker_lab_attribute_title="//h2[contains(text(),'Lab Tracker Attributes')]"
tracker_location="//select[@id='LabTrackerAccountId']"
tracker_patient_name="//input[@id='LabTrackerPatientName']"
tracker_patient_name_strong="//div[@id='LabTrackerAddOrUpdateForm']//strong[contains(text(),'${PatientData.MRN}')]"
tracker_description="//input[@id='AutocompleteLabDescription']"
tracker_description_strong="//div[contains(@class,'tt-suggestion') and contains(.,'${lab_des}') and contains(.,'${drug_lab}')][1]"
tracker_payer="//input[@id='LabTrackerPayerDescription']"
tracker_payer_strong="//div[@id='LabTrackerAddOrUpdateForm']//strong[contains(text(),'${lab_payer}')]"
tracker_ordering_provider="//select[@id='OrderingPhysician']"
tracker_startdate_input="//input[@id='OrderStartDate']"
tracker_enddate_input="//input[@id='OrderEndDate']"
tracker_datepicker_done_btn="//button[contains(text(),'Done')]"
tracker_file_num="//input[@id='FileNumber']"
tracker_frequency_value="//select[@id='SelectedFrequencyValue']"
tracker_frequency_select="//select[@id='SelectedFrequency']"
tracker_resultdate_input="//input[@id='LabStartDate']"
tracker_expdate_input="//input[@id='LabEndDate']"
tracker_expdate_tooltip="//div[@class='tooltip-inner' and contains(text(),'Enter Result Date and Frequency to populate the Expiration Date.')]"
tracker_status_select="//select[@id='SelectedStatus']"
tracker_yes_checkbox="//input[@id='IsStatOrder']"
tracker_no_checkbox="//input[@id='IsNotStatOrder']"
tracker_fasting_checkbox="//input[@id='IsFasting']"
tracker_company_select="//select[@id='LabCompany']"
tracker_ICD10_input="//input[@id='ICD10CodeAutoComplete']"
tracker_ICD10_checkbox="//input[@id='PrimaryICDCheckbox']"
tracker_add_btn="//button[@id='AddICD10Codes']"
tracker_primary_ICD10_default="//div[@id='EmptyPrimaryCode']//strong"
tracker_primary_ICD10_list="//div[@id='PrimaryCodeOuterDiv']"
tracker_remove_primary="//a[@class='RemovePrimaryCode']"
tracker_additional_ICD10_list="//div[@id='AdditionalCodeOuterDiv']"
tracker_additional_ICD10_default="//div[@id='EmptyAdditionalCodes']//strong"
tracker_remove_additional="//a[@class='RemoveAdditionalCode']"
tracker_require_checkbox="//input[@id='RequiredBeforeTreatment']"
tracker_save_btn="//div[@id='UltraSubModalPopup']//following::button[@id='SaveBtn' and contains(text(),'Save')]"
tracker_close_btn="//div[@id='UltraSubModalPopup']//button[@id='SaveBtn' and contains(text(),'Save')]/following::button[1]"
tracker_primary_del="//a[@class='RemovePrimaryCode']"
tracker_PO_row="//div[contains(text(),'${PO_number}')]//following::strong[contains(text(),'${assign_lab_txt}')][1]"
tracker_lab_row="//strong[contains(text(),'${file_num}')]"
tracker_no_available_title="//h4[contains(text(),'No Lab Trackers Available')]"
tracker_patient_value_title="//h4[contains(text(),'Lab Trackers Available With No Patient Value')]"
tracker_show_empty_checkbox="//input[@id='ViewEmptyPatientValues']"
tracker_critical_table="//td[contains(text(),'${attribute_description_txt}')]//following::a[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'${out_range_value}')][1]"
tracker_ledger_link="//a[contains(text(),'Lab Tracker')]"
tracker_ledger_location="//select[@id='LabMemberId']"
tracker_ledger_patient="//input[@id='PatientId']"
tracker_ledger_row="//div[contains(text(),'${file_num}')]"
tracker_ledger_status="//div[contains(text(),'${file_num}')]//preceding::td[1]//div[1]"
tracker_ledger_result="//td[contains(text(),'${attribute_description_txt}')]//following::td[@data-column='3'][1]"
tracker_ledger_close_btn="//div[@id='ModalPopup']//button[@id='CloseBtn' and contains(text(),'Close')]"
tracker_empty_attribute_row="//div[@class='pager-total text-nowrap']//following::tr//input[not(@value)]"
attribute_add_btn="//span[@id='AddLabTrackerAttributeButton']"
attribute_title="//h4[contains(text(),'Attributes')]"
attribute_description="//input[@id='LabTrackerAttributeDescription']"
attribute_response_type="//Select[@id='LabTrackerAttributeResponseType']"
attribute_unit="//input[@id='LabTrackerAttributeUnitDescription']"
attribute_range_start="//input[@id='LabTrackerAttributeRangeStart']"
attribute_range_end="//input[@id='LabTrackerAttributeRangeEnd']"
attribute_select_list="//textarea[@id='LabTrackerAttributeSelectListItems']"
attribute_save_btn="(//div[@id='SubModalPopup']//following::button[@id='SaveBtn'])[1]"
attribute_close_btn="(//div[@id='SubModalPopup']//following::button[@id='CloseBtn'])[1]"
attribute_del_btn="(//div[@id='SubModalPopup']//following::button[@id='DeleteBtn'])[1]"
attribute_edit_btn="//td[contains(text(),'${attribute_description_txt}')]//following::span[contains(text(),'Edit')][1]"
attribute_patient_value_input="//td[contains(text(),'${attribute_description_txt}')]//following::input[@name='LabTrackerAttributeResponse'][1]"
tracker_PO_description="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')])[1]"
tracker_PO_reorder_btn="//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Reorder')]"
tracker_unrelated_description="//div[contains(text(),'Unrelated Labs')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]"
reorder_startdate="(//h4[contains(text(),'${assign_lab_txt}')]//following::div[contains(text(),'Order Start Date')]//following::input[1])[1]"
reorder_yes_checkbox="(//h4[contains(text(),'${assign_lab_txt}')]//following::span[contains(text(),'Y')]//preceding::input[contains(@class,'StatOrderCheckbox')])[1]"
reorder_no_checkbox="//h4[contains(text(),'${assign_lab_txt}')]//following::input[contains(@class,'NotStatOrderCheckbox')]"
reorder_fasting_checkbox="(//h4[contains(text(),'${assign_lab_txt}')]//following::span[contains(text(),'Fasting')]//following::input[contains(@class,'FastingCheckbox')])[1]"
reorder_lab_company_select="(//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='LabCompany'])[1]"
reorder_frequency_value="(//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='FrequencyDays'])[1]"
reorder_frequency_select="(//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='Frequency'])[1]"
reorder_resultdate="(//h4[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'Result Date')]//following::input)[1]"
reorder_expdate="(//h4[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'Expiration Date')]//following::input)[1]"
reorder_diagnosis_input="(//h4[contains(text(),'${assign_lab_txt}')]//following::div[contains(text(),'Diagnoses To Add To Order')]//following::input)[2]"
reorder_add_btn="(//h4[contains(text(),'${assign_lab_txt}')]//following::button[contains(text(),'Add')])[1]"
reorder_save_btn="(//h4[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Save and Submit Order')])[1]"
reorder_cancel_btn="(//h4[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Cancel')])[1]"
reorder_close_btn="(//h4[contains(text(),'${assign_lab_txt}')]//following::a[contains(@class,'CloseReorder')])[1]"
tracker_row_day_ramain="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='0']//strong)[1]"
tracker_row_resultdate="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='1']//strong)[1]"
tracker_row_expdate="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='2']//strong)[1]"
tracker_row_orderdate="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='3']//strong)[1]"
tracker_row_nextapt="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='4']//strong)[1]"
tracker_row_description="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='5']//strong)[1]"
tracker_row_labcode="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='6']//strong)[1]"
tracker_row_status="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='7']//strong)[1]"
tracker_row_orderenddate="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='8']//strong)[1]"
tracker_row_filenum="(//div[contains(text(),'${PO_number}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='9']//strong)[1]"

#Patient Information tab
patient_info_tab="//a[@id='PatientInfo']"

#Payer Information tab
payer_info_tab="//a[@id='PayerInfo']"
add_payer_btn="//a[contains(text(),' Add Payer / Plan ')]"
select_plan_radio="//input[@name='plan']"
medical_type="//input[@value='Medical']"
pharmacy_type="//input[@value='Pharmacy']"
medical_subscriber_num="//h3[contains(text(),'Medical Payer Plan')]/following::input[@id='CertificateNumber'][1]"
medical_group_num="//h3[contains(text(),'Medical Payer Plan')]/following::input[@id='GroupNumber'][1]"
pharmacy_subscriber_num="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='CertificateNumber']"
pharmacy_group_num="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='GroupNumber']"
pharmacy_Bin_num="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='BIN']"
pharmacy_PCN_num="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='PCN']"
pharmacy_RxGroup_num="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='RxGroup']"
pharmacy_effective_date="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='EffectiveDate']"
pharmacy_expiration_date="//h3[contains(text(),'Pharmacy Payer Plan')]/following::input[@id='ExpirationDate']"
payer_inactive_checkbox="//input[@id='InactivePayer']"
payer_create_btn="//button[@id='SaveBtn' and contains(text(),'Create')]"
payer_close_btn="(//button[@id='SaveBtn']/following::button)[1]"
payer_update_btn="//button[@id='SaveBtn' and contains(text(),'Update')]"
payer_edit_btn="//a[contains(text(),' Edit Payer  ')]"
payer_remove_btn="//a[contains(text(),' Remove Payer  ')]"
payer_view_change="//a[@id='PatientPayerChangesBtn']"
changelog_patient_name="(//h4[contains(text(),'Patient: ')]//strong)[4]"
changelog_MRN="(//h4[contains(text(),'Patient: ')]//strong)[5]"
changelog_DOB="(//h4[contains(text(),'Patient: ')]//strong)[6]"
changelog_collapsed="//a[@data-toggle='collapse']"
changelog_table="//th[contains(text(),'Property')]/parent::tr"
changelog_close_btn="(//button[@id='SaveBtn']/following::button)[1]"
user_name_element="//h4[@class='HelloUserMessage']"
changelog_inactive_row="(//tbody//tr[td[1][text()='Inactive']])[last()]"

#Progress Note Tab
progress_note_tab="//a[@id='ProgressNote']"
subject_filter_span="//span[contains(text(),'Subject Filter')]"
date_range_span="//span[contains(text(),'Filter By Date Range')]"
follow_date_span="//span[contains(text(),'Follow Up Date')]"
subject_filter_select="//select[@id='SelectedSubjectElement']"
note_start_date="//input[@id='ProgressNoteStartDate']"
note_end_date="//input[@id='ProgressNoteEndDate']"
date_picker_table="//div[@id='ui-datepicker-div']"
list_date_picker_table="//td[@data-handler='selectDay']/a[text()='${today}']"
add_note_btn="//span[@id='AddPatientProgressNoteButton']"
subject_field_select="//select[@id='SelectedSubject']"
note_new_subject="//input[@id='NewSubject']"
follow_up_date="//input[@id='FollowUpDate']"
progress_note_textbox="//textarea[@id='Note']"
progress_save_btn="//span[@id='SavePatientProgressNoteButton']"
progress_cancel_btn="//span[@id='CancelPatientProgressNoteButton']"
progress_export_btn="//span[@id='ExportProgressNoteToExcelButton']"

#Address Tab
address_tab="//a[@id='Address']"
address_description="//input[@id='Description']"
address_address1="//input[@id='Address1']"
address_address2="//input[@id='Address2']"
address_city="//input[@id='City']"
address_state="//select[@id='State']"
address_zipcode="//input[@id='ZipCode']"
address_Country="//select[@id='CountryRegion']"
adress_inactive="//input[@id='InactiveAddress']"
address_create="//button[@id='SaveBtn' and contains(text(),'Create')]"
address_close="(//button[@id='SaveBtn']/following::button)[1]"
address_update="//button[@id='SaveBtn' and contains(text(),'Update')]"
address_created_value="( ${PatientData.address_description}) ${PatientData.address_address1} ${PatientData.address_address2} ${PatientData.address_city}, ${PatientData.address_state} ${PatientData.address_zipcode} ${PatientData.address_Country}"
address_row="//tr[@class='addressRow'][last()]"
address_inactive_input="//input[@id='InactiveAddress']"
address_inactive_icon="(//tr[@class='addressRow']//td//span)[last()]"
address_id_column="(//th[contains(text(),'#')])[1]"
address_address_column="(//th[contains(text(),'Address Line')])[1]"
address_city_column="(//th[contains(text(),'City')])[1]"
address_state_column="(//th[contains(text(),'State')])[1]"
address_zipcode_column="(//th[contains(text(),'Zip Code')])[1]"
address_inactive_column="(//th[contains(text(),'Inactive')])[1]"
address_message="//span[@data-notify='message']"
address_address1_update="//form[@id='frm_PatientAddress']//following::input[@id='Address1']"
address_address2_update="//form[@id='frm_PatientAddress']//following::input[@id='Address2']"
address_city_update="//form[@id='frm_PatientAddress']//following::input[@id='City']"
address_zipcode_update="//form[@id='frm_PatientAddress']//following::input[@id='ZipCode']"
address_row_total="//tbody/tr[@class='addressRow']"
address_line_total="//div[@id='PayerList']//div[@class='panel panel-warning']"
#Patient Addresses - Default Address
default_address_select="//*[@id='PrimaryAddress']"
default_address1_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultAddressLine1']"
default_address2_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultAddressLine2']"
default_city_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultCity']"
default_state_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultStateProvince']"
default_state_select="(//*[@id='DefaultStateProvince'])[1]"
default_zipcode_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultPostalCode']"
default_country_input="//div[@id='DefaultAddressReadOnly']//*[@id='DefaultCountryRegion']"
default_address_last_option="(//select[@id='PrimaryAddress']/option)[last()-1]"
#Patient Addresses - Secondary Address
work_address_select="//*[@id='WorkAddress']"
work_address1_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkAddressLine1']"
work_address2_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkAddressLine2']"
work_city_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkCity']"
work_state_select="//select[@id='State']"
work_state_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkStateProvince']"
work_zipcode_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkPostalCode']"
work_country_input="//div[@id='WorkAddressReadOnly']//*[@id='WorkCountryRegion']"
work_address_last_option="(//select[@id='WorkAddress']/option)[last()-1]"
#Compare
addreses_btn="//span[contains(text(),'Addresses')]"
ICD_codes_btn="//span[contains(text(),'ICD Codes')]"
payers_btn="//span[contains(text(),'Payers')]"
provider_orders_btn="//span[contains(text(),'Provider Orders')]"
sche_apt_btn="//span[contains(text(),'Scheduled Appointments')]"
medications_btn="//span[contains(text(),'Medications')]"
active_lab_btn="//span[contains(text(),'Active Labs')]"

#Vital Signs tab
vital_signs_tab="//a[@id='PastVitals']"
vital_sign_title="//h3[contains(text(),'Vital Signs')]"
vital_date="//th[contains(text(),'Date Taken')]//following::div[contains(text(),'${date_taken}')]"
vital_clinician="${vital_date}//following::div[1]"
vital_blood_pressure_numerator="${vital_date}/following::td[1]//span[1]"
vital_blood_pressure_denominator="${vital_date}/following::td[1]//span[3]"
vital_heart_rate="${vital_date}//following::td[2]"
vital_resp_rate="${vital_date}//following::td[3]"
vital_temp_F="${vital_date}//following::td[4]//div[1]"
vital_temp_C="${vital_date}//following::td[4]//div[2]"
vital_height_ft="${vital_date}//following::td[5]//div[1]"
vital_height_cm="${vital_date}//following::td[5]//div[2]"
vital_weight_lbs="${vital_date}//following::td[6]//div[1]"
vital_weight_kg="${vital_date}//following::td[6]//div[2]"
vital_BMI="${vital_date}//following::td[7]//div"
vital_BSA="${vital_date}//following::td[8]//div"
vital_spo2="${vital_date}//following::td[9]"
vital_flow_rate="${vital_date}//following::td[10]"
vital_temperature_empty="${vital_date}//following::td[4]//span"
vital_del_btn="//span[contains(text(),'Delete')]//parent::button"
#Provider Order tab
PO_location_select="//select[@id='ModalAccountID']"
PO_location = "//select[@id='CustomerAccountId']"
PO_btnLocation="//button[@data-id='ModalAccountID']/span[@class='filter-option pull-left']"
PO_loading_location="//*[@id='frm_CreateEditPatientOrderModal']"
PO_SelectedPatient="//input[contains(@id,'SelectedPatient')]"
PO_auto_input="//input[contains(@id,'SelectedPatient')]/preceding::*[1]"
PO_autocompleteItem="//*[@id='Phase1']//following-sibling::span[1]//div[contains(@class,'tt-dataset')]"
PO_newPatient="//a[contains(@class, 'add_patient') and contains(text(), 'New Patient')]"
PO_medication_icd="//*[@id='InitialIcd10CodeSelectSection']//following::span[contains(text(),'Medication ICD Codes')]"
PO_assign_icd="//*[@id='InitialIcd10CodeSelectSection']//following::span[contains(text(),'Assigned to Patient')]"
PO_btnClose="(//*[@id='CloseBtn'])[2]"
icd_code="//span[@class='filter-option pull-left']"
PO_Loading="//*[@id='PatientInnerView']//*[contains(@class,'fa-spinner')]"
PO_diagnosis_select="//select[@id='PrimaryICDCode']"
PO_diagnosis_txt="(//button[@data-id='PrimaryICDCode']//span)[1]"
PO_dropdown="(//*[@id='InitialIcd10CodeSelectSection']//following::button)[1]"
PO_loading="//*[@id='loading-indicator']"
PO_start_date_input="//*[@id='OrderDate']"
PO_exp_date_input="//*[@id='ExpirationDate']"
PO_diagosis_auto="//*[@id='DiagnosisDispaly']"
PO_referring_order="//input[contains(@id,'ReferralPhysician')]"
PO_refer_to_provider="//select[contains(@id,'OrderingPhysician')]"
PO_highlight_referring="(//*[@id='PatientInnerView']//*[contains(text(),'${refer_arg}')])[2]"
PO_referral_source="//*[@id='ReferralSource']"
PO_visit_frequency_value_select="//*[@id='OfficeVisitRequirementValue']"
PO_visit_frequency_select="//*[@id='OfficeVisitRequirementFrequency']"
PO_route_select="//*[@id='RouteOfAdministration']"
PO_maint_dose='//*[@id="DosageAssigned"]'
PO_calculated_dose="//input[contains(@id,'CalculatedDosage')]"
PO_frequency_value="xpath://select[contains(@id,'FrequencyValue')]"
PO_frequency_time="xpath://select[contains(@id,'DoseFrequency')]"
PO_place_service="xpath://select[contains(@id,'PlaceOfService')]"
PO_requested_dose="//*[@id='NumberOfDoses']"
PO_preferred_UoM="//*[@id='PreferredUoM']"
PO_prefered_method="xpath://select[contains(@id,'ContainerType')]"
PO_indexed_dose_input="//*[@id='DosageAssignedConvert']"
PO_split_dose="xpath://input[contains(@id,'SplitDose')]"
PO_split_over_treatment="xpath://select[contains(@id,'NumberOfSplitDoseTreatments')]"
PO_save_btn="//*[contains(@onclick,'patientOrderSave') and contains(text(),'Save')]"
PO_patientlist="//*[@id='PhysicianOrderTabList']"
create_PO_btn = "//a[contains(text(),'Create Provider Order ')]"
location = "//select[@id='CustomerAccountId']"
mrn_search_value = "//input[@id='SearchValues']"
PO_tab = "//a[@id='PhysicianOrder']"
PO_number_txt="//span[@id='PONumberDispaly']"
med_select = "//select[@id='PrimaryMedication']"
icd_code_select = "//select[@id='PrimaryICDCode']"
PO_modal_create_btn = "//button[contains(text(),'Create ')]"
PO_modal_close_btn = "//*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']"
physician_input = "//input[@id='ReferralPhysician']"
ordering_physician = "//select[@id='OrderingPhysician']"
weight_PO_input = "//input[@id='WeightPO']"
height_PO_ft = "//input[@id='PatientHeightft']"
height_PO_inch = "//input[@id='PatientHeightin']"
weight_PO_checkbox = "//input[@data-unit='kg']"
PO_dosage_assign = "//input[@id='DosageAssigned']"
PO_frequency_value = "//select[@id='FrequencyValue']"
PO_dose_frequency = "//select[@id='DoseFrequency']"
PO_dose_convert = "//input[@id='DosageAssignedConvert']"
PO_place_service = "//select[@id='PlaceOfService']"
PO_num_dose = "//input[@id='NumberOfDoses']"
PO_uom_select = "//select[@id='PreferredUoM']"
Po_container_type = "//select[@id='ContainerType']"
PO_split_dose = "//input[@id='SplitDose']"
PO_split_treatment = "//select[@id='NumberOfSplitDoseTreatments']"
find_btn = "//button[@id='FindButton']"
APT_tab = "//a[@id='Appointment']"
APT_note_label = "//label[contains(text(),'Appointment Note')]"
APT_diagnosis_span = "//span[contains(text(),'Diagnosis:')]//parent::div"
PO_row_edit_btn="//span[contains(text(),'${PO_number}')]//following::a[contains(text(),'Edit Order')][1]"
PO_lab_frequency_value="//strong[contains(text(),'${assign_lab_txt}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]"
PO_lab_frequency_select="//strong[contains(text(),'${assign_lab_txt}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]"
PO_accept_btn="//button[contains(text(),'Accept & Continue')]"
PO_show_quick_view_btn="//a[contains(text(),'Show Quick View')]"
PO_lab_checkbox="(//a[contains(text(),'Hide Quick View')][1]//following::tbody//tr[${lab_tr}]//td//input)[${lab_index}]"
PO_assign_lab_strong="(//a[contains(text(),'Hide Quick View')][1]//following::tbody//tr[${lab_tr}]//td//strong)[${lab_index}]"
PO_assign_lab_input="//strong[contains(text(),'${assign_lab_txt}')]//preceding::input[contains(@class,'AssignAccountLab')][1]"
PO_advise_title="//h4[contains(text(),'PLEASE BE ADVISED')]"
PO_exist_alert="//h4[contains(text(),'EXISTING PROVIDER ORDER ALERT')]"

#Provider Order edit
PO_modal_location="//select[contains(@id,'ModalAccountID')]"
secondary_diagnosis_UI="//*[@id='SecondaryIcd10CodeSelectSection']"
show_icdcode_UI="//*[@id='ShowAllSecondaryIcd10CodesSection']"
viewdoc_UI="//*[@id='ViewPODocumentationBtn']"
document_list_UI="//*[@id='PODocumentationDiv']"
question_doc_UI="(//select[@class='form-control input-sm QuestionAnswer'])[1]"
regimen_UI="//strong[contains(text(), 'Medication Regimen')]"
select_regimen_UI="//*[@id='Regimen']"
dose_UI="//*[@id='Dose_1']"
repeatRegimen_UI="//*[@id='RepeatRegimen']"
repeatRegimenFrequency_UI="//*[@id='RepeatRegimenFrequency']"
repeatMaintenance_UI="//*[@id='RepeatMaintenance']"
repeatMaintenanceFrequency_UI="//*[@id='RepeatMaintenanceFrequency']"
edit_regimen_UI="//*[@id='EditRegimen']"
create_regimen_UI="//*[@id='CreateEditRegimenBtns']/a[2]"
select_regimen_outer_UI="//div[@id='SelectedRegimenList']"
secondary_UI="//strong[contains(text(), 'Secondary Medications')]"
quick_select_UI="//a[@class='btn btn-sm btn-success' and contains(text(),'Hide / Show Quick Select')]"
add_secondarymed_UI="//*[@id='AddNewAdditionalMedBtn']"
secondary_list_UI="//*[@id='AdditionalMedicationsList']"
view_assigned_medication_UI="//*[@id='ViewAssignedAdditionalMedication']"
referrals_CPT_UI="//strong[contains(text(), 'Preferred CPT Codes')]"
referral_UI="(//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//button[contains(@class, 'dropdown-toggle')])[1]"
prefer_checkbox_UI="(//*[@id='AssignableCPTCodeList']//*[contains(@class,'largeCheckbox')])[1]"
treatment_goals_UI="(//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//button[contains(@class, 'dropdown-toggle')])[2]"
notes_UI="//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//textarea[(@id= 'AdditionalNotes')]"
Rx_number_assign_UI="//strong[contains(text(), 'Preferred CPT Codes')]/ancestor::div[1]/following-sibling::div//strong[contains(text(), 'Rx Number Assignment')]"
Rx_num_UI="//*[@id='RXNumber']"
Rx_date_UI="//*[@id='RXNumberAssignDate']"
Rx_origin_UI="//*[@id='RxOrigin']"
tools_status_history_UI="//strong[contains(text(), 'Tools for Status and History')]"
discontinue_checkbox_UI="//strong[contains(text(), 'Tools for Status and History')]/ancestor::div[1]/following-sibling::div//input[@id='IsDiscontinuedService']"
view_change_btn="//strong[contains(text(), 'Tools for Status and History')]/ancestor::div[1]/following-sibling::div//a[contains(., 'View Changes')]"
copyPO_UI="//*[@id='CopyBtn']/ancestor::div[1]//button[contains(text(), 'Copy Provider Order')]"
savePO_UI="//*[@id='CopyBtn']/ancestor::div[1]//button[contains(text(), 'Save')]"
select_location_PO="//select[contains(@id,'AccountID')]"
PO_filter_patient_input="//*[@id='PatientId']"
patient_autocomplete="//input[@id='PatientId']/following-sibling::pre[1]/following::div[1]"
PO_search_btn="//*[contains(@class,'SearchBtn') and text()='Search']"
PO_load="//*[@id='PatientOrderList']//*[contains(@class,'fa-spinner')]"
PO_list="//*[@id='PatientOrderList']"
PO_num_row="//*[@onclick and normalize-space(text())='Edit Order']//preceding::*[normalize-space(text())='${PO_num}']//ancestor::*[contains(@style,'cursor: pointer;')]"
Edit_PO=PO_num_row+"//*[contains(text(),'')]/ancestor::tr//a[normalize-space(text())='Edit Order'][1]"
physician_disabled="//input[@id='ReferralPhysician']/preceding::*[1]"
referto_disabled="//*[@id='OrderingPhysician']/ancestor::div[contains(@class,'btn-group')]/button"
dose_type_po="//*[@id='ActivateRegimen_1']"
progress_note="//*[@id='POModalProgressNote']"
datepicker_done_btn="//button[contains(text(),'Done')]"
secondary_diag_dropdown="(//*[@id='SecondaryIcd10CodeSelectSection']//following::button)[1]"
POs_medication_icd="//*[@id='SecondaryIcd10CodeSelectSection']//following::span[contains(text(),'Medication ICD Codes')]"
POs_assign_icd="//*[@id='SecondaryIcd10CodeSelectSection']//following::span[contains(text(),'Assigned to Patient')]"
POs_secondary_diagnosis_select="//select[@id='SecondaryICDCodeSelect']"
PO_title="//h4[contains(text(),'Provider Order')]"
Create_ProviderOrder="//*[contains(text(),'Create Provider Order')]"
ICD_disabled_secondary="//*[@id='SecondaryIcd10CodeSelectSection']//li[.//span[text()='Assigned to Patient']]/following-sibling::li[1]//a"
ICD_disabled_primary="//*[@id='InitialIcd10CodeSelectSection']//li[.//span[text()='Assigned to Patient']]/following-sibling::li[1]//a"
startdate_field="//*[@id='StartDate']"
enddate_field="//*[@id='EndDate']"
clearpatient_btn="//button[@class='btn btn-default patientClearButton']"

#Diagnosis tab
Diagnosis_tab="//a[@id='ICD']"
title_ICD="//*[@id='ICDTab']//h3[contains(text(), 'Diagnosis / ICD 10 Codes')]"
search_ICD="//*[@id='SearchValues']"
find_ICD="//*[@id='FindButton']"
ICD_list="//*[@id='ICDList']"
ICD_clear="//button[@id='ClearButton' and text()='Clear']"
ICD_checkbox="//*[@id='IsSelected']"
diagnosis_assigned_checkbox="//td[normalize-space(text())='${icd_code}']//preceding::input[@class='AssignICD largeCheckbox']"
diagnosis_primary_checkbox="//td[normalize-space(text())='${icd_code}']//preceding::input[@class='PrimaryICD largeCheckbox']"
diagnosis_no_icd_msg='//strong[contains(text(),"No ICD 10 Codes Available")]'
diagnosis_loading_icon="//i[@id='loading-indicator']"
diagnosis_assigned_section="//strong[contains(text(),'Assigned')]"
diagnosis_primary_section="//strong[contains(text(),'Primary')]"

#Prior Authorization
PA_tab="//a[@id='PriorAuthorization']"
PA_med_column="//a[contains(text(),'${PatientData.First_Name} ${PatientData.Last_Name}')]//following::td[contains(.,'${med_txt}')]"

#Schedule APT
schedule_btn="//a[@id='ScheduleApptBtn']"
accept_btn="//button[contains(text(),'Accept')]"
suggested_day_text="//strong[@id='SuggestedOfficeVisitDate']"
patient_input="//input[@id='SelectedPatient']"
APT_tab="//a[@id='Appointment']"
sche_new_apt_btn="//a[contains(text(),'Schedule New Appointment ')]"
APT_row="//*[@class='DateOfServiceLabel']/following::hr[1]/preceding::strong[text()='${APT_datetime}']"
APT_treatment_note_btn="//*[@class='DateOfServiceLabel']/following::hr[1]/preceding::strong[text()='${APT_datetime}']//following::*[@id='print' and *[normalize-space(text())='Treatment Note']][1]"
treat_loading="//*[@id='EncounterNoteTab']//*[contains(@class,'fa-spinner')]"
APT_status_txt="${APT_row}//following::*[contains(@class, 'appointmentStatusBadge')]"
APT_primary_med_txt="${APT_row}//following::*[contains(@id, 'ApptMedColumn')]//strong[1]"
APT_patient_protocol="//*[@class='DateOfServiceLabel']/following::hr[1]/preceding::strong[text()='${APT_datetime}']//following::a[@data-original-title='Protocol']"
APT_protol_title="//h4[contains(text(),'Adjust the protocol for this patient.')]"
APT_protocol_edit_btn="//form[@id='frm_AdjustPatientProtocolModal']//following::a[contains(text(),'Edit for Patient')]"
APT_protocol_accept_btn="//form[@id='frm_AdjustPatientProtocolModal']//following::button[contains(text(),'Accept')]"

#Treatment Note - Procedural Details
treat_procedural_details_btn="//a[contains(text(),'Procedural Details')]"
procedural_details_title="//h2[@id='ProceduralDetailsTitleHeader']"
recording_clinician_select="//h2[contains(text(),'Procedural Details')]//following::select[@id='SelectedPhysicalMeasurementUser'][2]"
drip_rate_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='DripRate'][2]"
blood_pressure_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='BloodPressure'][2]"
heart_rate_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='HeartRate'][2]"
temperature_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='Temp'][2]"
respiratory_rate_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='RespRate'][2]"
SPO2_input="//h2[contains(text(),'Procedural Details')]//following::input[@id='SPO2'][2]"
oxygen_select="//h2[contains(text(),'Procedural Details')]//following::input[@id='SelectedOxygen'][2]"
delivery_method_select="//h2[contains(text(),'Procedural Details')]//following::select[@id='SelectedDeliveryMethod'][2]"
recording_clinician_select_update="//h2[contains(text(),'Procedural Details')]//following::select[@id='SelectedPhysicalMeasurementUser'][1]"
drip_rate_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='DripRate'][1]"
blood_pressure_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='BloodPressure'][1]"
heart_rate_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='HeartRate'][1]"
temperature_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='Temp'][1]"
respiratory_rate_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='RespRate'][1]"
SPO2_input_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='SPO2'][1]"
oxygen_select_update="//h2[contains(text(),'Procedural Details')]//following::input[@id='SelectedOxygen'][1]"
delivery_method_select_update="//h2[contains(text(),'Procedural Details')]//following::select[@id='SelectedDeliveryMethod'][1]"
treat_APT_DOS="//u[contains(text(),'DATE OF SERVICE:')]//following::dd[1]"
action_del_btn="//h2[contains(text(),'Procedural Details')]//following::a[2]"
TN_close_btn="//*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']"

#Treatment Note - Assessment
treat_assessment_btn="//form[@id='frm_AssignDosageToAppointment']//a[contains(text(),'Assessment')]"
treat_assessment_title="//h2[contains(text(),'Assessment')]"
assessment_starttime_input='//input[@id="AssessmentStartTime"]'
assessment_weight="//input[@id='AssessmentWeight']"
assessment_height="//input[@id='AssessmentHeight']"
assessment_height_title="//h4[contains(text(),'Enter Height')]"
assessment_height_ft="//input[@id='PatientHeightFeet']"
assessment_height_inch="//input[@id='PatientHeightInches']"
assessment_BMI="//span[@id='assessment-bmi']"
assessment_BSA="//span[@id='assessment-bsa']"
assessment_height_accept_btn="//button[contains(text(),'Accept')]"
assessment_starttime_picker='(//div[@class="ui-timepicker-wrapper"]//li[@class="ui-timepicker-am ui-timepicker-selected"])'

#Treatment Note - Patient Charge
patient_discharge_btn="//form[@id='frm_AssignDosageToAppointment']//a[contains(text(),'Patient Discharge')]"
patient_discharge_title="//h2[contains(text(),'Patient Discharge')]"
patient_discharge_endtime='//input[@id="endTime"]'
patient_discharge_duration='//input[@id="TimeAdminCalculation"]'
patient_discharge_endtime_picker='(//div[@class="ui-timepicker-wrapper"]//li[@class="ui-timepicker-am ui-timepicker-selected"])[2]'

#Co-Pay Assistance tab
copay_assistance_tab="//a[@id='CoPayAssistance']"
copay_add_btn="(//span[contains(text(),'Add Co-Pay Assistance')])[1]"
copay_med_add_btn="(//span[contains(text(),'Add Co-Pay Assistance')])[2]"
copay_modal="//form[@id='frm_CreateCoPayAssistance']"
copay_med_label="//label[contains(text(),'Medication')]"
non_med="//select[@id='SelectedMedication']//option[contains(text(),'-- Select A Medication --')]"
copay_med_select="//select[@id='SelectedMedication']"
copay_med_btn="(//button[@data-id='SelectedMedication']//span)[1]"
copay_med_button="//button[@data-id='SelectedMedication']"
copay_program_select="//select[@id='SelectedCoPayAssistanceProgramId']"
# copay_program_option="(//select[@id='SelectedCoPayAssistanceProgramId']/option)[last()-1]"
copay_program_option="//select[@id='SelectedCoPayAssistanceProgramId']//following::option[contains(text(),'${program_name_arg}')]"
copay_phone_enrollment_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='Phone']"
copay_fax_enrollment_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='Fax']"
copay_CAP_website_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='WebsiteLink']"
copay_phone_claim_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsPhone']"
copay_fax_claim_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsFax']"
copay_CAP_specialist_select="//form[@id='frm_CreateCoPayAssistance']//following::select[@id='CoPaySpecialist']"
copay_CAP_status_select="//form[@id='frm_CreateCoPayAssistance']//following::select[@id='SelectedCoPayStatus']"
copay_CAP_ID_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='ClaimsPatientID']"
copay_CAP_group_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='PatientGroupNumber']"
copay_CAP_amount_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceTotal']"
copay_CAP_responsibility_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='PatientResponsibility']"
copay_CAP_startdate_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceStartDate']"
copay_CAP_enddate_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceEndDate']"
copay_CAP_credit_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceCardNumber']"
copay_CVV_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='SecurityCode']"
copay_billing_zip_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='BillingZip']"
copay_expdate_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='ExpirationDate']"
copay_related_note_input="//form[@id='frm_CreateCoPayAssistance']//following::textarea[@id='NewCoPayNote']"
copay_add_note_btn="//form[@id='frm_CreateCoPayAssistance']//following::a[contains(text(),'Add Note')]"
copay_related_note_line="//form[@id='frm_CreateCoPayAssistance']//following::textarea[@id='NewCoPayNote']//following::td[1]"
copay_CAP_balance_input="//form[@id='frm_CreateCoPayAssistance']//following::input[@id='CoPayAssistanceBalance']"
copay_security_icon="//form[@id='frm_CreateCoPayAssistance']//following::button[@id='DisplaySecurityCode']"
copay_payment_history="//form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']"
copay_payment_history_row="//form[@id='frm_CreateCoPayAssistance']//following::span[@id='ToggleCoPayPaymentHistoryButton']//following::tbody//tr"
copay_done_btn="//button[contains(text(),'Done')]"
add_copay_assistance_btn="//form[@id='frm_CreateCoPayAssistance']//following::button[contains(text(),'Add Co-Pay Assistance')]"
close_copay_assistance_btn="//form[@id='frm_CreateCoPayAssistance']//following::button[contains(text(),'Close')][1]"
create_program_modal="//form[@id='frm_CreateCoPayAssistanceProgram']"
program_modal_tilte="//h4[contains(text(),'Create Co-Pay Assistance Program')]"
program_name="//input[@id='CoPayAssistanceProgramName']"
program_phone="//input[@id='CoPayAssistanceProgramPhone']"
program_fax_enrollment="//input[@id='CoPayAssistanceProgramFax']"
program_CAP="//input[@id='ProgramWebsiteLink']"
program_phone_claims="//input[@id='ProgramClaimsPhone']"
program_fax_claims="//input[@id='ProgramClaimsFax']"
add_program_btn="//button[contains(text(),'Add Program')]"
close_program_btn="//form[@id='frm_CreateCoPayAssistanceProgram']//following::button[@id='CloseBtn'][1]"
copay_cancel_btn="//a[contains(text(),'Cancel')]"
copay_edit_btn="//h3[contains(text(),'${med_selected_value}')]//following::span[contains(text(),'Edit Co-Pay Assistance')][1]"
copay_document_btn="//a[contains(@onclick, 'LoadPatientDocumentModal')]"
copay_upload_document_btn="//a[contains(@onclick, 'UploadCoPayDocumentModal')]"
copay_upload_btn="//*[@id='SaveBtn' and text()='Upload']"
document_description_input="//textarea[@id='CopayDocumentDescription']"
copay_update_btn="//*[@id='SaveBtn' and text()='Update Co-Pay Assistance']"
last_page="(//a[contains(text(),'Next')]/preceding::a[1])[1]"
copay_document_patient="//strong[contains(text(),'Patient:')]//parent::div"
copay_document_dob="//strong[contains(text(),'DOB:')]//parent::div"
copay_document_mrn="//strong[contains(text(),'MRN:')]//parent::div"
copay_document_close_btn="(//div[@id='SubModalPopup']//following::button[@id='CloseBtn' and contains(text(),'Close')])[1]"
copay_med_row="//h3[contains(text(),'${med_selected_value}')]"
copay_med_program="${copay_med_row}//following::strong[contains(text(),'Program')][1]//parent::h4"
copay_med_phone_enrollment="${copay_med_row}//following::span[contains(text(),'Phone (Enrollment)')][1]//parent::td"
copay_med_fax_enrollment="${copay_med_row}//following::span[contains(text(),'Fax (Enrollment)')][1]//parent::td"
copay_med_cap_website="${copay_med_row}//following::span[contains(text(),'CAP Website')][1]//parent::td"
copay_med_phone_claim="${copay_med_row}//following::span[contains(text(),'Phone (Claims)')][1]//parent::td"
copay_med_fax_claim="${copay_med_row}//following::span[contains(text(),'Fax (Claims)')][1]//parent::td"
copay_med_cap_specialist="${copay_med_row}//following::span[contains(text(),'CAP Specialist')][1]//parent::td"
copay_med_cap_status="${copay_med_row}//following::span[contains(text(),'CAP Status')][1]//parent::td"
copay_med_cap_id="${copay_med_row}//following::span[contains(text(),'CAP Identification Number')][1]//parent::td"
copay_med_group_num="${copay_med_row}//following::span[contains(text(),'CAP Group Number')][1]//parent::td"
copay_med_approval_startdate="${copay_med_row}//following::span[contains(text(),'Approval Start Date')][1]//parent::td"
copay_med_approval_enddate="${copay_med_row}//following::span[contains(text(),'Approval End Date')][1]//parent::td"
copay_med_cap_amount="${copay_med_row}//following::span[contains(text(),'CAP Approved $ Amount')][1]//parent::td"
copay_med_cap_response="${copay_med_row}//following::span[contains(text(),'Patient Copay $ Responsibility')][1]//parent::td"
copay_med_cap_balance="${copay_med_row}//following::span[contains(text(),'CAP Card Current $ Balance')][1]//parent::td"
copay_history_appttime="${copay_payment_history}//following::td[contains(text(),'${apt_datetime}')]//following::td[1]"
copay_history_apptstatus="${copay_payment_history}//following::td[contains(text(),'${apt_datetime}')]//following::td[2]"
copay_history_appttreatment="${copay_payment_history}//following::td[contains(text(),'${apt_datetime}')]//following::td[3]"
copay_history_apptcharge="${copay_payment_history}//following::td[contains(text(),'${apt_datetime}')]//following::td[4]//input"
copay_history_savecharge="${copay_payment_history}//following::td[contains(text(),'${apt_datetime}')]//following::td[4]//span//button"
copay_program_edit_btn="//span[@id='UpdateCoPayAssistanceProgram']"
copay_program_update_btn="//button[contains(text(),'Update Program')]"
copay_program_delete_btn="//button[contains(text(),'Delete Program')]"
copay_PA_add_copay="//h3[contains(text(),'${med_selected_value}')]//following::span[contains(text(),'Add Co-Pay Assistance')]"
copay_upload_document_title="//h4[contains(text(),'Upload Co-Pay Document')]"
copay_document_title="//h4[contains(text(),'Patient Document Center')]"

#Documents tab
document_tab="//a[@id='Document']"
document_title="//h2[contains(text(),'Documents')]"
document_custom_title="//h3[contains(text(),'Save Custom Document Type')]"
document_type_select="//select[@id='DocumentType']"
document_option_default="//select[@id='DocumentType']//optgroup[@label='Default']//option"
document_option_custom="//select[@id='DocumentType']//optgroup[@label='Custom']//option"
document_custom_type="//input[@id='CustomDocumentTypeDescription']"
document_custom_edit_btn="//span[@id='EditCustomDocumentTypeButton']"
document_custom_del_btn="//span[@id='DeleteCustomDocumentTypeButton']"
document_custom_save_btn="//span[@id='SaveCustomDocumentTypeButton']"
document_custom_cancel_btn="//span[@id='CancelSaveCustomDocumentTypeButton']"
document_criteria_search="//input[@id='DocumentSearch']"
document_startdate_input="//input[@id='StartDateDocument']"
document_enddate_input="//input[@id='EndDateDocument']"
document_find_btn="//button[@id='DocumentFindButton']"
document_clear_btn="//button[@id='DocumentClearButton']"
document_show_archived_checkbox="//input[@id='isArchive']"
document_add_btn="//button[@id='DocumentAddButton']"
document_yes_btn="//button[@id='AcceptButton']"
document_no_btn="//button[@id='CloseAcceptButton']"
document_del_btn="//button[@id='DeleteDocumentButton']"
document_edit_title="//h4[contains(text(),'Edit Document')]"
document_save_doc_btn="//button[@id='EditDocumentSubmitButton']"
document_plus_icon="//h3[text()='${doc_type}']//preceding::h3[1]//i[@class='fa fa-plus']"
document_minus_icon="//h3[text()='${doc_type}']//preceding::h3[1]//i[@class='fa fa-minus']"
document_frame="//span[@id='DocumentViewerMessage']//parent::div"
document_patient_label="//strong[contains(text(),'Patient:')]//parent::div"
document_dob_label="//strong[contains(text(),'DOB:')]//parent::div"
document_mrn_label="//strong[contains(text(),'MRN:')]//parent::div"
document_type_label="//select[@id='DocumentType']//preceding::label[contains(text(),'Document Type')]"
document_datepicker="//select[@class='ui-datepicker-month']//option[@selected='selected']//following::a[contains(text(),'${doc_date}')][1]"
document_description_title="//span[@id='DocumentDescription']"
document_loading_icon_i="//i[@class='fa fa-spinner fa-4x fa-spin']"
document_viewer_msg="//span[@id='DocumentViewerMessage']//parent::div"
new_document_title="//h4[contains(text(),'New Document')]"
new_document_type_select="//select[@id='NewDocumentType']"
new_document_medication_select="//select[@id='MedicationName']"
new_document_description_textarea="//textarea[@id='Description']"
new_document_date_input="//input[@id='DocumentDate']"
new_document_file_input="//input[@id='DocumentFile']"
new_document_add_btn="//button[@id='AddDocumentSubmitButton']"
new_document_cancel_btn="//button[@id='CancelAddDocumentButton']"
new_document_row="//h3[text()='${doc_type}']//ancestor::button"
new_document_show_icon="//a[contains(text(),'${doc_description}')]//preceding::i[@class='far fa-file fa-2x'][1]"
new_document_edit_icon="//a[contains(text(),'${doc_description}')]//following::i[@class='fas fa-edit'][1]"
new_document_fax_icon="//a[contains(text(),'${doc_description}')]//following::i[@class='fas fa-fax'][1]"
new_document_archive_icon="//a[contains(text(),'${doc_description}')]//following::a[@class='archive-button'][1]"
new_document_date_txt="//a[contains(text(),'${doc_description}')]//following::span[contains(text(),'Document Date')][1]"
new_document_upload_txt="//a[contains(text(),'${doc_description}')]//following::span[contains(text(),'Uploaded')][1]"
new_document_description_row="//a[contains(text(),'${doc_description}')]"
new_document_confirm_title="//h4[contains(text(),'CONFIRMATION')]"
new_document_blue_bar="//div[@aria-labelledby='${doc_type}']"
new_document_frame="//iframe[@id='DocumentViewer']"

#Allergies tab
allergies_tab='//a[@id="Allergy"]'
allergies_status_select='//select[@id="AllergyActiveStatusFilter"]'
allergies_new_btn='//a[contains(text(),"New Allergy")]'
allergies_no_known_btn='//a[contains(text(),"No Known Allergies")]'
allergies_type_select='//select[@id="EncounterNoteAddingAllergyType"]'
allergies_type_title='//label[contains(text(),"Select an Allergy Type")]'
allergies_description_select='//select[@id="EncounterNoteAddingAllergyDescription"]'
allergies_create_allergy_title='//h4[contains(text(),"Create New Allergy")]'
allergies_create_allergy_btn='//button[contains(text(),"Create Allergy")]'
allergies_close_btn='//button[contains(text(),"Create Allergy")]//following::button[contains(text(),"Close")][1]'
allergies_medication_input='//input[@id="NewAllergyDescription"]'
allergies_description_option='//select[@id="EncounterNoteAddingAllergyDescription"]//child::option[contains(text(),"[Add New Allergy]")]//following::option[1]'
allergies_description_option_default='//button[@data-id="EncounterNoteAddingAllergyDescription"]//span[contains(text(),"-- Select an Allergy Type --")]'
allergies_onset_date_input='//label[contains(text(),"Onset Date")]//following::input[1]'
allergies_severity_select='//select[@id="Severity"]'
allergies_detail_textarea='//label[contains(text(),"Allergy / Intolerance Reaction Details")]//following::textarea[1]'
allergies_add_btn='//a[contains(text(),"Add Allergy ")]'
allergies_cancel_modal_btn='//div[@id="AdditionalAllergyAddingArea"]//child::a[contains(text(),"Cancel")]'
allergies_cancel_btn='//a[contains(text(),"Cancel") and not(ancestor::div[@id="AdditionalAllergyAddingArea"])]'
allergies_new_row='//td[contains(text(),"${allergy_detail_txt}")]//parent::tr'
allergies_status_column_select='//td[contains(text(),"${allergy_detail_txt}")]//following::select[1]'
allergies_edit_icon='//td[contains(text(),"${allergy_detail_txt}")]//following::i[@class="far fa-edit"][1]'
allergies_deactive_title='//h4[contains(text(),"Update Allergy Status - To DEACTIVE")]'
allergies_deactive_reason_select='//select[@id="DeactivationReason"]'
allergies_deactive_date_input='//input[@id="DeactivationDate"]'
allergies_deactive_btn='//button[contains(text(),"Deactivate Allergy")]'
allergies_active_status_column_select='//td[contains(text(),"${allergy_detail_txt}")]//following::select[1]'
allergies_deactive_status_column_select='//td[contains(text(),"${allergy_detail_txt}")]//following::span[1]'
allergies_additional_area='//div[@id="AdditionalAllergyAddingArea"]'
allergies_no_known_btn='//a[contains(text(),"No Known Allergies")]'

# Patient Payment tab
patient_payment_tab="//a[@id='PatientPayments']"
payment_current_balance_title='//strong[contains(text(),"Current Balance")]//parent::div'
payment_current_balance_amount='//strong[@id="PatientPaymentCurrentBalance"]'
payment_transaction_method_select='//select[@id="TransactionMethodFilter"]'
payment_transaction_type_select='//select[@id="TransactionTypeFilter"]'
payment_transaction_date_select='//input[@id="TransactionDateFilter"]'
# Patient Payment tab - Charge
payment_add_charge_btn='//a[contains(text(),"Add Charge")]'
add_charge_title='//h4[contains(text(),"Add Charge")]'
add_charge_amount_input='(//input[contains(@class,"ChargeAmount")])[${line}]'
add_charge_type_select='//select[@id="Type"]'
edit_charge_type_select='//select[@id="item_Type"]'
add_charge_reference_number_input='(//input[contains(@class,"ChargeReferenceNumber")])[${line}]'
add_charge_transaction_date_input='(//input[contains(@class,"TransactionDatepicker")])[${line}]'
add_charge_btn='//a[contains(@class,"AddNewChargeBtn")]'
add_charge_first_row_btn='//a[contains(@class,"AddNewChargeBtn") and @data-index="1"]'
remove_charge_btn='(//a[contains(@class,"RemoveExisitingChargeBtn")])[${line}]'
remove_charge_first_row_btn='//a[contains(@class,"RemoveExisitingChargeBtn") and @data-index="1"]'
add_charge_save_btn='//button[@id="SaveBtn" and contains(text(),"Save")]'
add_charge_close_btn='//button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button'
add_charge_current_balance='//strong[@id="ChargeModalCurrentBalance"]'
add_charge_new_balance='//strong[@id="NewChargesBalance"]'
charge_row='//input[@value="${charge_line}"]//ancestor::tr'
# Patient Payment tab - Payment
payment_add_payment_btn='//a[contains(text(),"Add Payment")]'
add_payment_title='//h4[contains(text(),"Add Payment")]'
add_payment_amount_input='(//input[contains(@class,"PaymentAmount")])[${line}]'
add_payment_method_select='//select[@id="PaymentMethod"]'
edit_payment_method_select='//select[@id="item_PaymentMethod"]'
add_payment_type_select='//select[@id="Type"]'
edit_payment_type_select='//select[@id="item_Type"]'
add_payment_reference_number_input='(//input[contains(@class,"PaymentReferenceNumber")])[${line}]'
add_payment_transaction_date_input='(//input[contains(@class,"TransactionDatepicker")])[${line}]'
add_payment_btn='//a[contains(@class,"AddNewPaymentBtn")]'
add_payment_firts_row_btn='//a[contains(@class,"AddNewPaymentBtn") and @data-index="1"]'
remove_payment_btn='(//a[contains(@class,"RemoveExisitingPaymentBtn")])[${line}]'
remove_payment_first_row_btn='//a[contains(@class,"RemoveExisitingPaymentBtn") and @data-index="1"]'
add_payment_save_btn='//button[@id="SaveBtn" and contains(text(),"Save")]'
add_payment_close_btn='//button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button'
add_payment_current_balance='//strong[@id="PaymentModalCurrentBalance"]'
add_payment_new_balance='//strong[@id="NewPaymentsBalance"]'
payment_row='//input[@value="${payment_line}"]//ancestor::tr'
# Patient Payment tab - Adjustment
payment_add_adjustment_btn='//a[contains(text(),"Add Adjustment")]'
add_adjustment_title='//h4[contains(text(),"Add Adjustment")]'
add_adjustment_amount_input='(//input[contains(@class,"AdjustmentAmount")])[${line}]'
add_adjustment_type_select='//select[@id="Type"]'
edit_adjustment_type_select='//select[@id="item_Type"]'
add_adjustment_reason_input='(//textarea[contains(@class,"PatientAdjustmentReason")])[${line}]'
add_adjustment_transaction_date_input='(//input[contains(@class,"TransactionDatepicker")])[${line}]'
add_adjustment_add_btn='//a[contains(text(),"Add to Balance")]'
add_adjustment_add_first_row_btn='//a[contains(@class,"AddAdjustmentToBalanceBtn") and @data-index="1"]'
add_adjustment_subtract_btn='//a[contains(text(),"Subtract from Balance")]'
add_adjustment_subtract_first_row_btn='//a[contains(@class,"RemoveAdjustmentFromBalanceBtn") and @data-index="1"]'
remove_adjustment_btn='(//a[contains(@class,"RemoveExisitingAdjustmentBtn")])[${line}]'
remove_adjustment_first_row_btn='//a[contains(@class,"RemoveExisitingAdjustmentBtn") and @data-index="1"]'
add_adjustment_save_btn='//button[@id="SaveBtn" and contains(text(),"Save")]'
add_adjustment_close_btn='//button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button'
add_adjustment_current_balance='//strong[@id="AdjustmentModalCurrentBalance"]'
add_adjustment_new_balance='//strong[@id="NewAdjustmentsBalance"]'
adjustment_row='//textarea[contains(text(),"${adjustment_line}")]//ancestor::tr'
# Patient Payment tab - Tansactions Table
transaction_date_column_value='//td[contains(text(),"${reference_number_value}")]//preceding::td[2]//div[1]'
transaction_edit_btn='//td[contains(text(),"${reference_number_value}")]//preceding::td[2]//a[contains(text(),"Edit Transaction")]'
type_column_value='//td[contains(text(),"${reference_number_value}")]//preceding::td[1]'
reference_number_column_value='//td[contains(text(),"${reference_number_value}")]'
amount_column_value='//td[contains(text(),"${reference_number_value}")]//following::td[1]//strong'
running_total_column_value='//td[contains(text(),"${reference_number_value}")]//following::td[2]//strong'
adjustment_transaction_date_column_value='//strong[contains(text(),"${adjustment_reason_value}")]//preceding::td[1]//div[1]'
adjustment_transaction_edit_btn='//strong[contains(text(),"${adjustment_reason_value}")]//preceding::td[1]//a[contains(text(),"Edit Transaction")]'
adjustment_type_column_value='//strong[contains(text(),"${adjustment_reason_value}")]//ancestor::td'
adjustment_reference_number_column_value='//strong[contains(text(),"${adjustment_reason_value}")]//following::td[1]'
adjustment_amount_column_value='//strong[contains(text(),"${adjustment_reason_value}")]//following::td[2]'
adjustment_running_total_column_value='//strong[contains(text(),"${adjustment_reason_value}")]//following::td[3]'
patient_payment_next_btn='//a[contains(text(),"Next")]'
filter_transaction_method_select='//select[@id="TransactionMethodFilter"]'
filter_transaction_type_select='//select[@id="TransactionTypeFilter"]'
filter_transaction_date_input='//input[@id="TransactionDateFilter"]'
method_line='//strong[contains(text(),"${method_index}")]//ancestor::td'
type_line='//strong[contains(text(),"${type_index}")]//ancestor::td'
date_line='//div[contains(text(),"${date_index}")]//ancestor::td'
total_line='//div[@id="PatientPaymentTransactions"]//child::tbody//tr'
page_num='//div[@class="pager-navigation"]//a[contains(text(),"${page_index}")]'
edit_transaction_title='//h4[contains(text(),"Edit Transaction")]'
# Patient Payment tab - Appointments Table
payment_apt_no_filter_input='//input[@id="AppointmentNoFilter"]'
payment_startdate_filter_input='//input[@id="AppointmentStartDateFilter"]'
payment_enddate_filter_input='//input[@id="AppointmentEndDateFilter"]'
apt_transaction_row='//td[contains(text(),"${apt_id}")]//ancestor::tr'
payment_loading_icon_i='//i[@class="fa fa-spinner fa-4x fa-spin"]'
no_apt_available='//strong[contains(text(),"No Appointments Available")]'
apt_date_of_service='//td[contains(text(),"${apt_date}")]'
apt_transaction_date_column='(//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[1]'
apt_transaction_id_column='(//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[2]'
apt_transaction_med_column='(//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[4]'
apt_transaction_allowed_column='(//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[5]//strong'
apt_transaction_due_column='(//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[6]//strong'
open_billable_event_btn='//a[contains(text(),"Open Billable Event")]'
open_billable_event_table='//table[contains(@class,"BillableEventsTable")]'

#Appointment tab
apt_id='//*[@class="DateOfServiceLabel"]/following::hr[1]/preceding::strong[text()="${apt_date}"]//preceding::strong[1]'
apt_primary_medication='//*[@class="DateOfServiceLabel"]/following::hr[1]/preceding::strong[text()="${apt_date}"]//following::div[contains(@id,"ApptMedColumn")][1]//following-sibling::strong'
apt_open_apt_btn='//*[@class="DateOfServiceLabel"]/following::hr[1]/preceding::strong[text()="${apt_date}"]//following::a[contains(text(),"Open Appointment")][1]'
apt_approve_dispensed_btn='//span[contains(text(),"Approve & Dispense")]'
apt_lot_number_select='//select[@id="Lot_0"]'
apt_complete_dispense_btn='//strong[contains(text(),"Complete Dispense")]'
apt_discrepancy_reason_select='//select[@id="DiscrepancyDropdownReason"]'
apt_reason_continue_btn='//button[@id="SaveBtn" and contains(text(),"Continue")]'
apt_warn_yes_btn='//button[@id="SaveBtn" and contains(text(),"Yes / Continue")]'
apt_accept_dispense_btn='//button[@id="SaveBtn" and contains(text(),"Accept & Dispense")]'
apt_assign_dossage_title='//h4[contains(text(),"Assign Dosage To Appointment")]'
warn_future_apt_title='//h4[contains(text(),"Warning - Opening Future Appointment")]'
apt_dispense_reason='//textarea[@id="DispenseAmountReason"]'
apt_advised_title='//h4[contains(text(),"PLEASE BE ADVISED")]'
apt_close_btn='//div[@id="ModalPopup"]//button[@id="CloseBtn" and contains(text(),"Close")]'
therapy_have_po='//optgroup[@label="Patient Therapies"]//following-sibling::option[contains(text(),"${drug_po}")]'
apt_therapy_select='//select[@id="Therapy"]'
apt_quantity_therapy_input='//input[contains(@class,"AddonDosageQty")]'
apt_dispense_medication_title='//h4[contains(text(),"Dispense Medication To Patient")]'
apt_assigned_dxcode='//strong[contains(text(),"Assigned DX Code")]//following::a[1]'
apt_patient_weight='//label[@for="PatientWeight"]//following::input[@name="PatientWeight"][1]'
apt_base_qty='//strong[@name="BaseQty"]'
apt_unit_therapy="//strong[contains(text(),'Dosage')]//parent::div"
apt_pain_scale_select='//label[contains(text(),"Pain Scale")]//following::select[@id="symptomRating"]'
apt_diagnosis="//strong[contains(text(),'${apt_date}')]//following::a[contains(@onclick,'AssignICD10ToAppointmentModal')]"
apt_assign_dxcode_title="//h4[contains(text(),'Assign Appointment DX Code')]"
apt_assign_dxcode_to_patient="//div[@id='ICDModalList']//child::div[contains(text(),'Assigned To Patient')]//following::span[normalize-space(text())='${icd_code}']"
assign_dxcode_close_btn="//div[@id='SubModalPopup']//button[@id='CloseBtn' and contains(text(),'Close')]"
apt_clinician_select='//select[@id="NurseId"]'
apt_loading_icon='//div[@id="SchedulingCalendarLoadingDiv"]'
apt_scheduling_alert='//form[@id="frm_SchedulingAlertMessage"]'
apt_update_therapy_btn='//a[@id="UpdateApptTherapyBtn"]'

#Patient History tab - Summary of All Treaments
patient_history_tab='//a[@id="PatientHistoryTreatment"]'
summary_treatment_title='//h2[contains(text(),"Summary of All Treatments")]'
history_primary_med_column='//span[text()="${drug_po}"]'
show_encounter_btn='${history_primary_med_column}//preceding::a[contains(@id,"ShowEncounterSummaryBtn")][1]'
patient_history_status_column='${history_primary_med_column}//preceding::td[1]'
total_treatment_column='${history_primary_med_column}//following::td[1]'
startdate_column='${history_primary_med_column}//following::td[2]'
startdose_column='${history_primary_med_column}//following::td[3]'
startdose_per_kg_column='${history_primary_med_column}//following::td[4]'
starting_pain_level_column='${history_primary_med_column}//following::td[5]'
last_treatment_date_column='${history_primary_med_column}//following::td[6]'
lastdose_column='${history_primary_med_column}//following::td[7]'
lastdose_per_kg_column='${history_primary_med_column}//following::td[8]'
last_pain_level_column='${history_primary_med_column}//following::td[9]'
dcd_date_column='${history_primary_med_column}//following::td[10]'
reason_for_dc_column='${history_primary_med_column}//following::td[11]'
#Patient History tab - Encounter Summary
encounter_summary_title='//h2[contains(text(),"Encounter Summary")]'
date_os_column='//div[contains(@id,"EncounterSummaryList")]//following::span[contains(text(),"${past_date}")]'
treatment_num_column='(${date_os_column})//preceding::td[2]'
encounter_dxcode_column='(${date_os_column})//preceding::td[1]'
encounter_weight_column='(${date_os_column})//following::td[1]'
encounter_mg_per_kg_column='(${date_os_column})//following::td[2]'
encounter_calc_dose_column='(${date_os_column})//following::td[3]'
encounter_actual_dose_column='(${date_os_column})//following::td[4]'
encounter_dose_frequency_column='(${date_os_column})//following::td[5]'
encounter_access_site_column='(${date_os_column})//following::td[6]'
encounter_pain_level_column='(${date_os_column})//following::td[7]'
encounter_reaction_column='(${date_os_column})//following::td[8]'
encounter_lenght_column='(${date_os_column})//following::td[9]'
encounter_caregiver_column='(${date_os_column})//following::td[10]'
encounter_view_apt_btn='(${date_os_column})//following::td[11]'
encounter_row_total='//div[contains(@id,"EncounterSummaryList")]//child::tbody//tr'
previous_last_treatment_row='(//div[contains(@id,"EncounterSummaryList")]//child::tbody//tr)[last()]'
last_treatment_row='(//div[contains(@id,"EncounterSummaryList")]//child::tbody//tr)[1]'
startdate_last_row='(${encounter_last_row})//child::td[3]'

#Account Assignments tab
account_assignments_tab="//a[@id='AccountAssignment']"
assigned_accounts_title='//h3[contains(text(),"Assigned Accounts")]'
assigned_note_column_title='//th[contains(text(),"Note")]'
adjust_default_location_btn='//a[contains(text(),"Adjust Default Location")]'
default_account_select='//select[@id="DefaultAssignedAccountDropdown"]'
assigned_accounts_checkbox='//td[contains(text(),"${location_name}")]//preceding::input[contains(@class,"AssignmentCheckbox")][1]'
note_accounts_checkbox='//td[contains(text(),"${location_name}")]//following::input[contains(@class,"accountAssignmentNote")][1]'
assignments_cancel_btn='//a[contains(text(),"Cancel")]'
assigned_default_accounts_checkbox='//input[contains(@class,"AssignmentCheckbox") and @disabled="disabled"]//following::td[1]'
assigned_account_name='//td[contains(text(),"${location_name}")]'
assigned_account_name_row_total='//input[contains(@class,"AssignmentCheckbox")]//following::td[1]'
assigned_checked_checkbox='//input[contains(@class,"AssignmentCheckbox") and not(@disabled="disabled")]'
#Patient Alerts
alerts_tab="//*[@id='PatientAlerts']"
alerts_title="//*[@id='PatientAlertsTab']//following::h3[contains(text(),'Patient Alerts')]"
alerts_startdate="//input[@id='AlertEventStartDate']"
alerts_enddate="//input[@id='AlertEventEndDate']"
showcomplete_checkbox="//input[@id='ShowCompletedAlerts']"
create_PAlerts="//*[@id='PatientAlertsTab']//following::a[contains(text(),'Create Patient Alert')]"
patientfield_popup="//input[@id='ModalAlertPatientId']"
event_desc="//select[@id='AlertEventDescription']"
event_desc_option="//select[@id='AlertEventDescription']//option"
event_date="//input[@id='ModalEventDate']"
priority="//select[@id='AlertPriority']"
priority_option="//select[@id='AlertPriority']//option"
other_radio_btn="//input[@name='ModalDuration' and @data-val='other']"
duration_text="//input[@id='OtherModalDurationText']"
actionreason="//textarea[@id='ModalActionReason']"
alerts_close="//*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']"
alerts_save="//*[@id='ModalPopup']//*[@id='SaveBtn' and text()='Save']"
alerts_confirm="(//*[@id='PatientAlertsList']//following::a[contains(text(),'Confirm')])[1]"
datepick="//*[@id='ui-datepicker-div']"
hide_alert="(//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td//strong[contains(text(),'No Alerts Available')]"
result_reason="((//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td[4]//following::textarea)[1]"
completed_timestamp_column="((//*[@id='PatientAlertsList']//tbody//following-sibling::tr)[1]//td)[5]//span"
completed_timestamp_column_text="//textarea[contains(text(),'${long_text}')]//ancestor::tr/td[5]"
patient_column="(((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[1]"
event_column="(((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[2]"
event_timestamp_column="(((//div[@id='PatientAlertsList'])//tbody//following-sibling::tr)[1]//td)[3]"
other_input="//input[@name='ActionDuration_0' and @data-val='other']"
other_textbox="//input[@class='form-control ActionDurationValue']"

#Assessment
assessment_tab="//*[@id='Assessment']"
assessment_title="//*[@id='AssessmentTab']//following::h3[contains(text(),'Patient Assessments')]"
template_dropdown="//select[@id='SelectedAssessmentTemplateId']"
add_template_btn="//span[@id='AddPatientAssessmentTemplateButton']"
assessment_name_texbox="//*[@id='Name']"
save_assessment_btn="//*[@id='SaveAddPatientAssessmentTemplateButton']"
cancel_assessment_btn="//*[@id='CancelAddPatientAssessmentTemplateButton']"
delete_assessment_btn="//*[@id='DeletePatientAssessmentTemplateButton']"
new_assessment_btn="//span[@id='AddPatientAssessmentButton']"
edit_selectedtemp_btn="//span[@id='EditPatientAssessmentTemplateButton']"
update_assessment_btn="//span[@id='UpdateAssessmentTemplateButton']"
save_update_assessment="//*[@id='SaveUpdatePatientAssessmentTemplateButton']"
add_question_btn="//span[@id='AddAssessmentTemplateQuestionItemButton']"
copy_template_btn="//span[@id='CopyAssessmentTemplateButton']"
update_question="(//div[@class='questions-sortable']//following::span)[1]"
desc_assessment="//*[@id='Description']"
numberofcolumn="//*[@id='NumberOfColumns']"
save_question="//*[@id='SaveAddPatientAssessmentTemplateQuestionItemButton']"
save_update_question="//*[@id='SaveUpdatePatientAssessmentTemplateQuestionItemButton']"
delete_quesion="//*[@id='DeletePatientAssessmentTemplateQuestionItemButton']"
add_question_element="//div[@class='questions-sortable']//following::span[contains(text(),'Add Question Element')]"
add_question_element_title="//div[@class='questions-sortable']//following::h3[contains(text(),'Add Question Element')]"
datatype="//*[@id='DataType']"
save_question_element="//*[@id='SaveAddPatientAssessmentTemplateItemButton']"
update_question_element="//*[@id='AssessmentTemplateWrapper']//following::a[@class='updateAssessmentTemplateItemButton']"
optional_checkbox="//*[@id='Optional']"
save_update_question_element="//*[@id='SaveUpdatePatientAssessmentTemplateItemButton']"
question_element_input="//*[@id='PatientAssessmentQuestionList_0__PatientAssessmentItemList_0__Value']"
save_question_element_input="(//div[@class='assessmentCreateForm']//following::span)[1]"
delete_quesion_element_btn="//*[@id='DeletePatientAssessmentTemplateItemButton']"
info_assessment_detail="//*[@id='AssessmentListSection']//following::td[1]/a"
assessment_name="(//*[@id='ModalPopup']//following::h3)[1]"
close_assessment_btn="(//div[@id='ModalPopup']//following::button[@id='CloseBtn'])[1]"