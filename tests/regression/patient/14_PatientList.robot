*** Settings ***
Documentation      Patient Management
Library    DependencyLibrary
Library    Dialogs
Library    ../../../libraries/CustomLibrary.py
Variables    ../../../resources/PageObjects/Locators/Patient.py
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
Suite Setup    RePatient.Suite Setup With Required Patient Information
Test Setup    RePatient.Test Setup Keyword
Test Teardown    RePatient.Test Teardown Keyword
Suite Teardown    RePatient.Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_014    patient    Admin

*** Test Cases ***
Verify Patient List In Patients Page
    [Documentation]    PaMan_TC01    PaMan_TC02    PaMan_TC03    PaMan_TC07    PaMan_TC08    PaMan_TC09    PaMan_TC12    PaMan_TC14    PaMan_TC16    PaMan_TC18
                ...    PaMan_TC20    PaMan_TC22    PaMan_TC24    PaMan_TC27    PaMan_TC28    PaMan_TC29    PaMan_TC30    PaMan_TC31    PaMan_TC32    PaMan_TC35
                ...    PaMan_TC36    PaMan_TC37    PaMan_TC38    PaMan_TC40    PaMan_TC41    PaMan_TC42    PaMan_TC43    PaMan_TC44    PaMan_TC45    PaMan_TC46
                ...    PaMan_TC47    PaMan_TC48    PaMan_TC49    PaMan_TC50    PaMan_TC51    PaMan_TC52
    [Tags]    Regression     Patient List
    ...  allure.label.owner: Vu Nguyen
    Patient.Go To Patients Page
    Patient.Verify Location Dropdown
    Patient.Verify Patient Information Table
    Patient.Verify Patient Information Badges
    Patient.Verify Search Patient By MRN
    Patient.Verify Pagination To Navigate To Page List
    Patient.Verify Advanced Search To Search Patient
    Patient.Verify Advanced Search To Sort Patient
    Patient.Verify Clear Button In Advanced Search
    Patient.Verify Number Of Patient Filtered

Verify Inactive Patient With Advanced Search
    [Documentation]    PaMan_TC53    PaMan_TC54    PaMan_TC55    PaMan_TC26
    [Tags]    Regression     Patient List    Inactive Patient
    ...  allure.label.owner: Vu Nguyen
    Patient.Inactivate Patient And Search Patient
    Patient.Search Inactive Patient With Advanced Search
    Patient.Verify Inactive Patient

*** Keywords ***
Setup Data        #variables in data sheet to be updated
    ${data_input}    Get Data
    # Common data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${PIN}    ${data_input}[PIN_physician]
    # Patient data
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${location_PO_2}    ${data_input}[location_2]    #location on system with 2 labels (names)
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
    # Different data for each flow (full or partial)
    Set Suite Variable    ${MRN_1}    ${data_input}[MRN_1]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]    #patient to be merged only
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}
    ...    Weight_LB=${weight}    
    ...    Weight_KG=${weight}    
    ...    Refering_Provider=${referring_NPI_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}