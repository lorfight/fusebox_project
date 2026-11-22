*** Settings ***
Documentation      Patient Management
Library    DependencyLibrary
Library    Dialogs
Library    ../../../libraries/CustomLibrary.py
Variables    ../../../resources/PageObjects/Locators/Appointment.py
Variables    ../../../resources/PageObjects/Locators/Billable.py
Resource   ../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/PriorAuthorization.resource
Resource    ../../../resources/PageObjects/Keywords/Appointment.resource
Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Resource    ../../../resources/PageObjects/Keywords/Billable.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryTransfer.resource
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Create PO
Suite Teardown    Log Data And Close Browser
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
    PriorAuthorization.Create Dictionary Of PA Data
    PriorAuthorization.Go to Prior Authorization Page
    Priorauthorization.Find PA Created For Regression
    PriorAuthorization.Click Edit PA Button
    Priorauthorization.Input MDF in PA For Regression
    PriorAuthorization.Input Status And Confirmation In PA For Regression
    PriorAuthorization.Input Payor And Margin In PA For Regression
    PriorAuthorization.Input Notes In PA For Regression
    PriorAuthorization.Input Coding Details In PA For Regression
    PriorAuthorization.Input Addtional Tools In PA For Regression
    PriorAuthorization.Update PA With Invalid Then Valid Date Range For Regression
    PriorAuthorization.Click Update Button
    PriorAuthorization.Close Modal
    PriorAuthorization.Verify PA General Section Visible
    PriorAuthorization.Verify PA Provider Order MDF Section Visible
    PriorAuthorization.Verify PA Status And Confirmation Section Visible
    PriorAuthorization.Verify Payor Information And Margin Calculator Section Visible

*** Keywords ***
Create PO    #Verify successful creation of a "New PO" on the "Provider Order" page with valid data
    ProviderOrders.Go to Provider Orders
    ProviderOrders.Select Location Provider Orders
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Calculate PO End Date
    ProviderOrders.Filter Date Range    date_arg=${end_date}
    ProviderOrders.Click Search PO
    ProviderOrders.Select Ordering Location    location_arg=${PatientData.Location}
    ProviderOrders.Input A Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Select Treatment Drug    drug_arg=${drug_PO}
    ProviderOrders.Click Diagnosis    DX_arg=M05.669
    ProviderOrders.Click Create Button
    ProviderOrders.Get PO Number
    ProviderOrders.Get PO Dates
    ProviderOrders.Input Referring/Ordering Provider    refer_arg=${referring_NPI_PO}
    ProviderOrders.Select Refer To Provider    refer_to_arg=${referto_provider_NPI_PO}
    ProviderOrders.Select Visit Frequency    frequency_arg=Day
    ProviderOrders.Input Weight And Height    patient_weight_arg=${patient_weight_PO}    patient_height_arg=${patient_height_PO}
    ProviderOrders.Input Dose And Frequency    dosageAssignedValue_arg=${dosage_assigned_value_PO}    calculated_dosage_arg=${calculated_dosage_PO}    dose_frequency_arg=${dosage_assigned_value_PO}    time_frequency_arg=${time_frequency_PO}
    ProviderOrders.Select Place Of Service And Preferred UoM And Container Type    placeOfserviceValue_arg=${placeof_service_value_PO}    requested_dose_arg=10    containerTypeValue_arg=${container_type_value_PO}    splitDoseValue_arg=${split_dose_value_PO}    numberOfsplitDosetreatmentsValue_arg=${numberof_split_dose_treatments_value_PO}
    Scroll Element Into View    ${referrals_select}/preceding::*[text()='Referrals'][1]
    Wait Until Element Is Visible    ${referrals_select}/preceding::*[text()='Referrals'][1]    30s
    Set Test Variable    ${line}    \*
    ${CPT_line}    Util.Replace Xpath    xpath=${PO_CPT_line}
    ${CPT_line}    Get WebElements    ${CPT_line}
    ${count}    Get Length    ${CPT_line}
    Set Test Variable    ${line}    1
    ${CPT_ckbx}    Util.Replace Xpath    xpath=${PO_CPT_checkbox}
    Click Element    ${CPT_ckbx}
    Util.Wait For Page Loading    element_arg=Successfully Assigned CPT Code    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=15s
    ${code}    Util.Replace Xpath    xpath=${PO_CPT_text}
    ${CPT}    Get Text    ${code}
    ${CPT}    Strip String    ${CPT}
    @{list}    Create List
    Append To List    ${list}    96365
    Set To Dictionary    ${PO_data}    CPT_Assigned=${list}    Num_CPTs=${count}
    Set Suite Variable    ${PO_data}
    ProviderOrders.Close Modal

Setup Data        #variables in data sheet to be updated
    ${data_input}    Get Data
    # Setup Testing Flow
    Set Suite Variable    ${testing_flow}    ${data_input}[testing_flow]
    # Common data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${testing_type}    ${data_input}[testing_type]
    Set Suite Variable    ${PIN}    ${data_input}[PIN_physician]
    # Patient data
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]
    Set Suite Variable    ${location_PO}    ${data_input}[location_PO]
    Set Suite Variable    ${location_PO_2}    ${data_input}[location_PO_2]    #location on system with 2 labels (names)
    Set Suite Variable    ${first_name}    ${data_input}[first_name]
    Set Suite Variable    ${last_name}    ${data_input}[last_name]
    Set Suite Variable    ${DOB}    ${data_input}[DOB]
    Set Suite Variable    ${weight}    ${data_input}[weight]
    Set Suite Variable    ${height}    ${data_input}[height]
    # PO-PA data
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]    #Fasenra
    Set Suite Variable    ${referring_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referto_provider_NPI_PO]
    Set Suite Variable    ${patient_weight_PO}    ${data_input}[patient_weight_PO]
    Set Suite Variable    ${patient_height_PO}    ${data_input}[patient_height_PO]
    Set Suite Variable    ${dosage_assigned_value_PO}    ${data_input}[dosage_assigned_value_PO]
    Set Suite Variable    ${calculated_dosage_PO}    ${data_input}[calculated_dosage_PO]
    Set Suite Variable    ${time_frequency_PO}    ${data_input}[time_frequency_PO]
    Set Suite Variable    ${placeof_service_value_PO}    ${data_input}[placeof_service_value_PO]
    Set Suite Variable    ${container_type_value_PO}    ${data_input}[container_type_value_PO]
    Set Suite Variable    ${split_dose_value_PO}    ${data_input}[split_dose_value_PO]
    Set Suite Variable    ${numberof_split_dose_treatments_value_PO}    ${data_input}[numberof_split_dose_treatments_value_PO]
    Set Suite Variable    ${time_zone}    ${data_input}[time_zone]
    Set Suite Variable    ${new_height}    ${data_input}[new_height]
    Set Suite Variable    ${PA_green_status}    ['Approved','No Auth Req','SP Controls Auth']
    # APT data
    Set Suite Variable    ${qty_dispense}    ${data_input}[qty_dispense]
    Set Suite Variable    ${NDC}    ${data_input}[NDC]    #00310-1730-30
    Set Suite Variable    ${lot}    ${data_input}[lot]    #TB0015 -- \[Exp: 6/30/2025]
    # TNote data
    Set Suite Variable    ${tnote_start_time}    ${data_input}[tnote_start_time]
    Set Suite Variable    ${tnote_end_time}    ${data_input}[tnote_end_time]
    Set Suite Variable    ${bld_pressure}    ${data_input}[bld_pressure]
    Set Suite Variable    ${hrt_rate}    ${data_input}[hrt_rate]
    Set Suite Variable    ${temp_F}    ${data_input}[temp_F]
    Set Suite Variable    ${resp_rate}    ${data_input}[resp_rate]
    Set Suite Variable    ${SPO2}    ${data_input}[SPO2]
    Set Suite Variable    ${medication_size}    ${data_input}[medication_size]
    Set Suite Variable    ${volumn_wdrawn}    ${data_input}[volumn_wdrawn]
    Set Suite Variable    ${second_med}    ${data_input}[second_med]
    Set Suite Variable    ${second_med_qty}    ${data_input}[second_med_qty]
    Set Suite Variable    ${second_med_time}    ${data_input}[second_med_time]
    Set Suite Variable    ${lot_second}    ${data_input}[lot_second]
    Set Suite Variable    ${max_drip_rate}    ${data_input}[max_drip_rate]
    Set Suite Variable    ${drip_rate}    ${data_input}[drip_rate]
    Set Suite Variable    ${bld_pressure_proc}    ${data_input}[bld_pressure_proc]
    Set Suite Variable    ${hrt_rate_proc}    ${data_input}[hrt_rate_proc]
    Set Suite Variable    ${temp_F_proc}    ${data_input}[temp_F_proc]
    Set Suite Variable    ${resp_rate_proc}    ${data_input}[resp_rate_proc]
    Set Suite Variable    ${SPO2_proc}    ${data_input}[SPO2_proc]
    Set Suite Variable    ${MRN_1}    ${data_input}[MRN_1]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]    #patient to be merged only
    Set Suite Variable    ${gender}    ${data_input}[gender]

    Set To Dictionary    ${PatientData}    
    ...    Location=${location_PO}    
    ...    Weight_LB=${weight}    
    ...    Weight_KG=${weight}    
    ...    Refering_Provider=${referring_NPI_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}

