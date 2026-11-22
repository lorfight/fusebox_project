*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_008    patient    Admin

*** Test Cases ***
Verify That The Ordering Location Dropdown
    [Documentation]    PO_1
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Element Is Visible    ${PO_loading_location}
    ${locations_default}=    Get List Items  ${PO_location_select}
    Click element    ${PO_btnClose}
    Click Element    link:Patients
    ${expected_location}=    Get List Items    ${PO_location}
    Lists Should Be Equal    ${locations_default[1:]}    ${expected_location[1:]}    

Verify That The Ordering Location
    [Documentation]    PO_2
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Element Is Visible    ${PO_btnLocation}
    ${locations_default}=    Get Text    ${PO_btnLocation}
    Should Be Equal    ${locations_default}    ${PatientData.Location}

Verify Error When Ordering Location Set Back To Blank
    [Documentation]    PO_3
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_location_select}    -- Select A Location --
    Sleep    1s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Click Element    ${PO_modal_create_btn}
    Alert Should Be Present    AccountId is Required.

Verify That The Default Selected Patient Is The Current Patient
    [Documentation]    PO_4
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Element Is Visible    ${SelectedPatient}    15s
    ${patient_value}    SeleniumLibrary.Get Element Attribute    ${SelectedPatient}    value
    ${expected_value}    Set Variable    ${PatientData.First_Name} ${PatientData.Middle_Name} ${PatientData.Last_Name} \(${PatientData.DOB}\) MRN: ${PatientData.MRN}
    Should Be Equal As Strings    ${patient_value}    ${expected_value}

Verify Patient Autocomplete Suggestions
    [Documentation]    PO_5
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Element Is Visible    ${PO_SelectedPatient}    10s
    FOR    ${i}    IN RANGE    5
        ${value}=    Run Keyword And Ignore Error    SeleniumLibrary.Get Element Attribute    ${PO_SelectedPatient}    value
        ${status}=    Set Variable    ${value[0]}
        ${value}=     Set Variable    ${value[1]}
        Exit For Loop If    '${value}' == ''
        Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${PO_SelectedPatient}
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_SelectedPatient}    ${PatientData.MRN}
    Wait Until Element Is Visible    ${PO_autocompleteItem}    10s

Create Provider Order With The Treatment Is Empty
    [Documentation]    PO_8
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please select a medication!

Verify Diagnosis Dropdown Enabled Only After Drug Selected
    [Documentation]    PO_9
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label  ${PO_diagnosis_select}    -- Select A Primary Medication --
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label  ${PO_diagnosis_select}    -- Select an ICD Code --

Verify Diagnosis Dropdown Shows Two ICD Sections
    [Documentation]    PO_10
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Diagnosis tab
    ICD Add To Patient    icd10_list=${{['${icd10_code}[icd10_code1]']}}
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_dropdown}
    Page Should Contain Element    ${PO_medication_icd}    ${PO_assign_icd}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    4
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_modal_close_btn}
    Open Diagnosis tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${ICD_checkbox}
    Wait For Page Loading    ICD Code Removed from Patient.    Element Should Be Visible    Wait Until Element Is Not Visible    timeout_arg=180s

Create Provider Order With The Diagnosis Is Empty
    [Documentation]    PO_11
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please select a ICD Code!

Verify Missing Referring Provider Error
    [Documentation]    PO_14    PO_15    PO_17
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Verify PO Default Dates
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please select a referring physician!

Verify Primary Diagnosis Auto Filled
    [Documentation]    PO_16
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}    
    ${diagosis_auto}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${PO_diagosis_auto}
    Should Be Equal    ${diagosis_auto}    ${icdCode_selected_text}

Verify Referring Autocomplete Suggestions
    [Documentation]    PO_18
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    ${refer_arg}    Set Variable    ${PatientData.Refering_Provider}
    ${PO_highlight_referring}    Replace Variables     ${PO_highlight_referring}
    Wait Until Element Is Visible    ${PO_highlight_referring}    10s

Verify Missing Refer To Provider Error
    [Documentation]    PO_19
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    ProviderOrders.Input Referring/Ordering Provider    refer_arg=${referring_NPI_PO}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label  ${PO_refer_to_provider}    -- Select Refer To Physician --
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please select a refer to physician!

Verify Referral Source Dropdown Options
    [Documentation]    PO_20
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    ${expected_options}=    Create List    In Office    Outside Physician    Affiliate / Partner Company
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_referral_source}
    ${actual_options}=     Get List Items   ${PO_referral_source}
    Lists Should Be Equal    ${actual_options}    ${expected_options}

Verify Office Visit Frequency Dropdowns
    [Documentation]    PO_21
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_visit_frequency_value_select}
    ${expected_units}=    Create List    Week(s)    Month(s)    Year(s)    Day(s)
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_visit_frequency_select}
    ${unit_options}=      Get List Items    ${PO_visit_frequency_select}
    Lists Should Be Equal    ${unit_options[1:]}    ${expected_units}
    ${PO_visit_frequency_value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${PO_visit_frequency_value_select}
    ${actual_list}    Evaluate    [int(i) for i in ${PO_visit_frequency_value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 100))
    Should Be Equal    ${PO_visit_frequency_value_list[0]}    -
    Lists Should Be Equal    ${actual_list}    ${expected_list}

Verify Error If Patient Weight Is Not Entered
    [Documentation]    PO_22
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}    
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician}    
    Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains   Please enter a weight!

Verify Error If An Unit Patient Weight Is Not Entered
    [Documentation]    PO_23    PO_24
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}    
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician} 
    Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}    
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains   Please select an unit for Patient weight!

Verify Error If Maint Dose Is Not Entered
    [Documentation]    PO_25
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}    
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician} 
    Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
    Scroll And Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains   Please enter a dosage!

Verify Error If Dose Frequency Is Not Entered
    [Documentation]    PO_26
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}    
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician} 
    Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
    Scroll And Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${Fake_dict.demical_2d}
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please enter a dose frequency!

# Verify Error If Calculated Dose Is Not Entered
#     [Documentation]    PO_27
#     [Tags]    Regression    Provider Order
#     ...  allure.label.owner: Nga Phan
#     Create PO Phase1 Succeeds
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
#     ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
#     Scroll And Click Element    ${reffering_strong}    
#     Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
#     ${physician_selected_text}    Get Selected List Label    ${ordering_physician} 
#     Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
#     Scroll And Click Element    ${weight_PO_checkbox}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${Fake_dict.demical_2d}
#     Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
#     Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
#     Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please enter a dosege!
    # Wait For Page Loading    element_arg=Please enter a dosege!    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=15s       

# Verify Indexed Dose Is Auto Calculated
#     [Documentation]    PO_28    PO_29
#     [Tags]    Regression    Provider Order
#     ...  allure.label.owner: Nga Phan
#     Create PO Phase1 Succeeds
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
#     ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
#     Scroll And Click Element    ${reffering_strong}    
#     Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
#     ${physician_selected_text}    Get Selected List Label    ${ordering_physician} 
#     Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
#     Scroll And Click Element    ${weight_PO_checkbox}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${Fake_dict.demical_2d}
#     Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
#     Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_calculated_dose}    ${Fake_dict.decimal_3d_2f}
#     ${indexed_dose}=    Get Value    ${PO_indexed_dose_input}
#     Should Not Be Empty    ${indexed_dose}
#     Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
#     Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please select a place of service!

Verify Place Of Service Dropdown Options
    [Documentation]    PO_30
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Create PO Modal Succeeds
    ${expected_options}=    Create List    In Office    Patient Address (Patient Home)    Alternate Office
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_place_service}
    ${actual_options}=    Get List Items    ${PO_place_service}
    Lists Should Be Equal    ${actual_options[1:]}    ${expected_options}

# Verify Error If Preferred Dispensing UoM Is Not Entered
#     [Documentation]    PO_31
#     [Tags]    Regression    Provider Order
#     ...  allure.label.owner: Nga Phan
#     Create PO Phase1 Succeeds
#     ProviderOrders.Input Referring/Ordering Provider    refer_arg=${referring_NPI_PO}
#     ProviderOrders.Select Refer To Provider    refer_to_arg=${referto_provider_NPI_PO}
#     Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
#     Scroll And Click Element    ${weight_PO_checkbox}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${Fake_dict.demical_2d}
#     Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
#     Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_calculated_dose}    ${Fake_dict.decimal_3d_2f}
#     Util.Select Random From List Regression    xpath_arg=${PO_place_service}    var_name=PO_place_service    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_num_dose}    ${Fake_dict.demical_2d}
#     Util.Select Random From List Regression    xpath_arg=${Po_container_type}    var_name=Po_container_type    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_split_dose}    ${Fake_dict.demical_2d}
#     Util.Select Random From List Regression    xpath_arg=${PO_split_treatment}    var_name=PO_split_treatment    dic=${TempData}
#     Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
#     Wait Until Keyword Succeeds    30s    1s    Wait Until Page Contains    Please enter a preferred unit of measure!
Verify View Provider Order New UI Has Field Group
    [Documentation]    PO_32    PO_33    PO_34    PO_36    PO_37    PO_40
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug1_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Open PO At Provider Order Page
    Check Navigate To Viewwing Provider Order Successfully
    Check Supporting Documentation section Has Fields Group
    Check Medication Regimen Section Has Fields Group
    Check Secondary Medication Section Has Fields Group
    Check The Preferred CPT Codes Section Has Fields Group
    Check Tools for Status and History Section Has Fields Group

Verify Update Provider Order New UI Has Field Group
    [Documentation]    PO_41    PO_42    PO_43    PO_44    PO_45    PO_46    PO_47    PO_48
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug1_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Open PO At Provider Order Page
    Select PO Row    PO_arg=${PO_number}
    Check Supporting Documentation section Has Fields Group For Update PO
    Check Medication Regimen Section Has Fields Group For Update PO
    Check Secondary Medication Section Has Fields Group For Update PO
    Check The Preferred CPT Codes Section Has Fields Group For Update PO
    Check Tools for Status and History Section Has Fields Group For Update PO

Verify Existing Provider Order Data Loaded Correctly
    [Documentation]    PO_49
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    ${height_ft}=    Set Variable    ${Fake_dict.height_fake}
    ${height_in}=    Set Variable    ${Fake_dict.height_fake}
    ${PO_dosage_arg}=    Set Variable    ${Fake_dict.demical_2d}
    Set To Dictionary    ${TempData}    height_ft=${height_ft}
    Set To Dictionary    ${TempData}    height_in=${height_in}
    Set To Dictionary    ${TempData}    PO_dosage_arg=${PO_dosage_arg}
    Create New PO    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Wait Until Element Is Visible    ${PO_patientlist}
    Select PO Row    PO_arg=${PO_number}
    Compare Data Before And After Saved

Verify Create Provider Order Updates In Both Screen
    [Documentation]    PO_12
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Compare Provider Order In Both Screen
    
Verify Provider Order Edits Reflect In All Screens
    [Documentation]    PO_13
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Wait Until Element Is Not Visible    //*[@id='frm_CreateEditPatientOrderModal']    30s
    Wait Until Element Is Visible    ${PO_patientlist}    timeout=10s
    Select PO Row    PO_arg=${PO_number}
    Edit Text area
    Open PO At Provider Order Page
    Get Value At Provider Order Page
    Should Be Equal     ${Edit_order}    ${Current_text}

Verify All Field Is Saved
    [Documentation]    PO_50    PO_51    PO_55    PO_56    PO_60
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Edit PO
    Page Alert Message    Provider Order Successfully Updated!

Verify All Field Is Disabled
    [Documentation]    PO_53    PO_54    PO_57    PO_58    PO_59   
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Check Field Is Disable

Verify The Assigned To Patient Section Not Displayed
   [Documentation]    PO_63       
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Order Page
    Verify Assigned To Patient Not Displayed In Primary Diagnosis

Verify The Assigned To Patient Section Not Displayed In Secondary Diagnosis
    [Documentation]    PO_67
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Create Fake Data List
    Create New PO With ICD Assigned To Patient    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Open Provider Order Page
    Verify Assigned To Patient Not Displayed In Secondary Diagnosis
    
Verify Primary Diagnosis Dropdown Has Two Sections In Create PO
    [Documentation]    PO_62    PO_64
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Diagnosis tab
    ICD Add To Patient    icd10_list=${{['${icd10_code}[icd10_code1]','${icd10_code}[icd10_code2]']}}
    Open Provider Order Page
    Verify Primary Diagnosis Has Two Section and ICD Disable 
    Removed ICD Code

Verify Secondary Diagnosis Dropdown Has Two Sections In Edit PO
    [Documentation]    PO_66    PO_68
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Open Diagnosis tab
    ICD Add To Patient    icd10_list=${{['${icd10_code}[icd10_code1]','${icd10_code}[icd10_code2]']}}
    Open Provider Orders tab
    Create Fake Data List
    Create New PO With ICD Assigned To Patient    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Open Provider Order Page
    Verify Secondary Diagnosis Has Two Section and ICD Disable
    Removed ICD Code    

Verify UoM And Preferred Method Labels In Create View And Update PO Mode 
    [Documentation]    PO_70    PO_71    PO_72    PO_73    PO_76    PO_77
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO With ICD Assigned To Patient    med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Wait Until Element Is Visible    ${PO_patientlist}
    ${PO_num}    Set Variable    ${PO_number}
    ${PO_num_row}    Replace Variables    ${PO_num_row}   
    Click Element    ${PO_num_row}
    Wait Until Element Is Visible    ${PO_header_text}    30s
    Verify Preferred UoM Dropdown In View Mode
    Verify Preferred Method Label In View Mode
    Scroll And Click Element    ${PO_modal_close_btn}
    Select PO Row    PO_arg=${PO_number}
    Verify Preferred UoM Dropdown In Edit Order
    Verify Preferred Method Label In Edit Order

Verify Create And Updated PO Successfully If User Select The Preferred Unit Of Measure
    [Documentation]    PO_74    PO_78
    [Tags]    Regression    Provider Order
    ...  allure.label.owner: Nga Phan
    Navigate to Patient by Generated MRN
    Create Fake Data List
    Create New PO With ICD Assigned To Patient     med_arg=${PatientData.drug_PO}    PO_dosage_arg=${Fake_dict.demical_2d}
    Wait Until Element Is Visible    ${PO_patientlist}    timeout=10s
    Select PO Row    PO_arg=${PO_number}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${PO_uom_select}    1
    # Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_uom_select}    -- Select a Preferred UoM --
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    1s
    IF    ${check_advised} == ${True}
        Scroll And Click Element Modal    ${PO_accept_btn}
    END
    Page Alert Message    Provider Order Successfully Updated!
    Scroll And Click Element    ${PO_modal_close_btn}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    Set Suite Variable    ${drug1_PO}    ${data_input}[drug1_PO]
    Set Suite Variable    ${referring_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${icd10_code}    ${data_input}[icd10_code]

    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    drug_PO=${drug_PO}
    ...    drug1_PO=${drug1_PO}
    ...    referring_NPI_PO=${referring_NPI_PO}    
    ...    referto_provider_NPI_PO=${referto_provider_NPI_PO}
    ...    icd10_code=${icd10_code}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}
