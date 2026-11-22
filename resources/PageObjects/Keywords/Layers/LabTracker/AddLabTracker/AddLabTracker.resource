*** Settings ***
Resource    ../../Common/Common.resource
Library    ../../Fakedata/FakeData.py

*** Variables ***
${tracker_add_lab_btn}    //span[@id='AddLabTrackerButton']
${tracker_add_lab_title}    //h4[contains(text(),'Add Lab Tracker')]
${tracker_location}    //select[@id='LabTrackerAccountId']
${tracker_patient_name}    //input[@id='LabTrackerPatientName']
${tracker_description}    //input[@id='AutocompleteLabDescription']
${tracker_payer}    //input[@id='LabTrackerPayerDescription']
${tracker_lab_attribute_title}    //h2[contains(text(),'Lab Tracker Attributes')]
${tracker_ordering_provider}    //select[@id='OrderingPhysician']
${tracker_startdate_input}    //input[@id='OrderStartDate']
${tracker_enddate_input}    //input[@id='OrderEndDate']
${tracker_datepicker_done_btn}    //button[contains(text(),'Done')]
${tracker_file_num}    //input[@id='FileNumber']
${tracker_frequency_value}    //select[@id='SelectedFrequencyValue']
${tracker_frequency_select}    //select[@id='SelectedFrequency']
${tracker_resultdate_input}    //input[@id='LabStartDate']
${tracker_expdate_input}    //input[@id='LabEndDate']
${tracker_expdate_tooltip}    //div[@class='tooltip-inner' and contains(text(),'Enter Result Date and Frequency to populate the Expiration Date.')]
${tracker_status_select}    //select[@id='SelectedStatus']
${tracker_yes_checkbox}    //input[@id='IsStatOrder']
${tracker_no_checkbox}    //input[@id='IsNotStatOrder']
${tracker_fasting_checkbox}    //input[@id='IsFasting']
${tracker_company_select}    //select[@id='LabCompany']
${tracker_icd10_codes_input}    //input[@id='ICD10CodeAutoComplete']
${tracker_ICD10_checkbox}    //input[@id='PrimaryICDCheckbox']
${tracker_primary_icd10_default}    //div[@id='EmptyPrimaryCode']//strong
${tracker_add_btn}    //button[@id='AddICD10Codes']
${tracker_primary_ICD10_list}    //div[@id='PrimaryCodeOuterDiv']
${tracker_remove_primary}    //a[@class='RemovePrimaryCode']
${tracker_additional_ICD10_list}    //div[@id='AdditionalCodeOuterDiv']
${tracker_additional_ICD10_default}    //div[@id='EmptyAdditionalCodes']//strong
${tracker_remove_additional}    //a[@class='RemoveAdditionalCode']
${tracker_require_checkbox}    //input[@id='RequiredBeforeTreatment']
${update_lab_tracker_title}    //h4[text()='Update Lab Tracker']
# ${tracker_save_btn}    //div[@id='UltraSubModalPopup' or @id='ModalPopup']//following::button[@id='SaveBtn' and contains(text(),'Save')]
${tracker_no_available_title}    //h4[contains(text(),'No Lab Trackers Available')]
${tracker_primary_del}    //a[@class='RemovePrimaryCode']
${tracker_patient_value_title}    //h4[contains(text(),'Lab Trackers Available With No Patient Value')]
${tracker_show_empty_checkbox}    //input[@id='ViewEmptyPatientValues']
#attribute
${attribute_add_btn}    //span[@id='AddLabTrackerAttributeButton']
${attribute_title}    //h4[contains(text(),'Attributes')]
${attribute_description}    //input[@id='LabTrackerAttributeDescription']
${attribute_response_type}    //Select[@id='LabTrackerAttributeResponseType']
${attribute_unit}    //input[@id='LabTrackerAttributeUnitDescription']
${attribute_range_start}    //input[@id='LabTrackerAttributeRangeStart']
${attribute_range_end}    //input[@id='LabTrackerAttributeRangeEnd']
${attribute_select_list}    //textarea[@id='LabTrackerAttributeSelectListItems']
${attribute_save_btn}    (//div[@id='SubModalPopup']//following::button[@id='SaveBtn'])[1]
${attribute_close_btn}    (//div[@id='SubModalPopup']//following::button[@id='CloseBtn'])[1]
${attribute_del_btn}    (//div[@id='SubModalPopup']//following::button[@id='DeleteBtn'])[1]

*** Keywords ***
Create Lab Tracker Dictionary
    &{labtracker_dict}    Create Dictionary
    RETURN    ${labtracker_dict}

Open Add Lab Tracker Modal
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s

Select Account In Lab Tracker Modal
    [Arguments]    ${account_arg}
    Select From List By Label    ${tracker_location}    ${account_arg}

Input Patient Name In Lab Tracker Modal
    [Arguments]    ${mrn_arg}
    Clear Input Field Until Empty    ${tracker_patient_name}
    Common.Input Text Into Field    ${tracker_patient_name}    ${mrn_arg}
    ${tracker_patient_name_strong}    Set Variable    (//div[@id='LabTrackerAddOrUpdateForm']//following::div[.//strong[contains(normalize-space(.),'${mrn_arg}')] or contains(normalize-space(.),'MRN: ${mrn_arg}')])[last()]
    Wait Until Element Is Visible    ${tracker_patient_name_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_patient_name_strong}

Input Lab Descirption In Lab Tracker Modal
    [Arguments]    ${lab_des_arg}    ${drug_lab_arg}
    Common.Clear Input Field Until Empty    ${tracker_description}
    Common.Input Text Into Field    ${tracker_description}    ${lab_des_arg}
    IF    "${drug_lab_arg}" == "${EMPTY}"
        ${tracker_description_strong}    Set Variable    //div[@id="LabTrackerAddOrUpdateForm"]//following::div[normalize-space(.)='${lab_des_arg}'][1]
    ELSE
        ${tracker_description_strong}    Set Variable    //div[@id="LabTrackerAddOrUpdateForm"]//following::div[normalize-space(.)='${lab_des_arg} (${drug_lab_arg})'][1]
    END
    Wait Until Element Is Visible    ${tracker_description_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_description_strong}
    Wait Until Element Is Visible    ${tracker_lab_attribute_title}    30s
    Sleep    1s

Input Payer In Lab Tracker Modal
    [Arguments]    ${payer_arg}
    Common.Clear Input Field Until Empty    ${tracker_payer}
    Common.Input Text Into Field    ${tracker_payer}    ${payer_arg}
    ${tracker_payer_strong}    Set Variable    //div[normalize-space(.)='${payer_arg}']
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tracker_payer_strong}    2s
    IF    "${check_visible}" == "${True}"
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_payer_strong}
    END

Select Ordering Provider In Lab Tracker Modal
    [Arguments]    ${physician_arg}
    Select From List By Value   ${tracker_ordering_provider}    ${physician_arg}

Input Order Start Date In Lab Tracker Modal
    [Arguments]    ${start_date_arg}
    Common.Input Text Into Field    ${tracker_startdate_input}    ${start_date_arg}
    Common.Close Calendar Table

Input Order End Date In Lab Tracker Modal
    [Arguments]    ${end_date_arg}
    Common.Input Text Into Field    ${tracker_enddate_input}    ${end_date_arg}
    Common.Close Calendar Table

Input Result Date In Lab Tracker Modal
    [Arguments]    ${result_date_arg}
    Common.Input Text Into Field    ${tracker_resultdate_input}    ${result_date_arg}
    Common.Close Calendar Table

Get DateTime In Lab Tracker
    ${result}    Get Incremental Dates
    ${start_date}    Get From Dictionary    ${result}    current_date
    ${end_date}    Get From Dictionary    ${result}    end_date
    ${result_date}    Get From Dictionary    ${result}    result_date
    RETURN    ${start_date}    ${end_date}    ${result_date}

Input Date Time In Lab Tracker Modal
    [Arguments]    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}
    Input Order Start Date In Lab Tracker Modal    ${start_date_arg}
    Input Order End Date In Lab Tracker Modal    ${end_date_arg}
    Input Result Date In Lab Tracker Modal    ${result_date_arg}

Input File Number In Lab Tracker Modal
    [Arguments]    ${file_arg}
    Common.Clear Input Field Until Empty    ${tracker_file_num} 
    Common.Input Text Into Field    ${tracker_file_num}    ${file_arg}

Select Frequency In Lab Tracker Modal
    [Arguments]    ${dict_arg}
    Select Frequency Value In Lab Tracker Modal    ${dict_arg}
    Select Frequency Select In Lab Tracker Modal    ${dict_arg}

Select Frequency Value In Lab Tracker Modal
    [Arguments]    ${dict_arg}
    Wait Until Element Is Enabled    ${tracker_frequency_value}
    ${old_tracker_frequency_value}    Get Selected List Label    ${tracker_frequency_value}
    Common.Choose Random Value From Select List    xpath_arg=${tracker_frequency_value}    var_name=tracker_frequency_value    dic=${dict_arg}
    IF    "${dict_arg.tracker_frequency_value}" == "${old_tracker_frequency_value}"
        Select Frequency Value In Lab Tracker Modal    ${dict_arg}
    END

Select Frequency Select In Lab Tracker Modal
    [Arguments]    ${dict_arg}
    Wait Until Element Is Enabled    ${tracker_frequency_select}
    ${old_tracker_frequency_select}    Get Selected List Label    ${tracker_frequency_select}
    Common.Choose Random Value From Select List    xpath_arg=${tracker_frequency_select}    var_name=tracker_frequency_select    dic=${dict_arg}
    IF    "${dict_arg.tracker_frequency_select}" == "${old_tracker_frequency_select}"
        Select Frequency Select In Lab Tracker Modal    ${dict_arg}
    END

Select Status In Lab Tracker Modal
    [Arguments]    ${dict_arg}
    Wait Until Element Is Enabled    ${tracker_status_select}
    Common.Choose Random Value From Select List    xpath_arg=${tracker_status_select}    var_name=tracker_status_select    dic=${dict_arg}

Random Stat Order Checkbox In Lab Tracker Modal
    ${stat}    Create List    ${tracker_yes_checkbox}    ${tracker_no_checkbox}
    ${random_checkbox}    Evaluate    random.choice(${stat})
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${random_checkbox}

Choose Fasting In Lab Tracker Modal
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_fasting_checkbox}

Select Lab Company In Lab Tracker Modal
    Select From List By Index    ${tracker_company_select}    1

Choose Primary ICD10 Code In Lab Tracker Modal
    [Arguments]    ${icd10_code_arg}    ${type_arg}
    IF    "${type_arg}" == "Primary"
        Input Primary ICD10 Code In Lab Tracker Modal    ${icd10_code_arg}[icd10_code_1]
    ELSE IF    "${type_arg}" == "Additional"
        FOR    ${i}    IN RANGE    2    4
            Input Additional ICD10 Code In Lab Tracker Modal    ${icd10_code_arg}[icd10_code_${i}]
        END
    END

Input Primary ICD10 Code In Lab Tracker Modal
    [Arguments]    ${icd_code}
    Common.Input Text Into Field    ${tracker_icd10_codes_input}    ${icd_code}
    Click Make Primary ICD10 Code Checkbox
    Click Add ICD10 Code Button

Input Additional ICD10 Code In Lab Tracker Modal
    [Arguments]    ${icd_code}
    Common.Input Text Into Field    ${tracker_icd10_codes_input}    ${icd_code}
    Click Add ICD10 Code Button

Click Make Primary ICD10 Code Checkbox
    Common.Scroll And Click Element    ${tracker_ICD10_checkbox}

Click Add ICD10 Code Button
    Common.Scroll And Click Element    ${tracker_add_btn}

Click Remove ICD10 Code Button
    Common.Scroll And Click Element    ${tracker_remove_primary}
    Common.Page Alert Message    Primary Diagnosis Removed.

Remove ICD10 Code
    [Arguments]    ${type_arg}    ${msg}
    ${remove_elements}    Get WebElements    ${type_arg}
    FOR    ${remove}    IN    @{remove_elements}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove}
        Common.Page Alert Message    ${msg}
    END

Click Save Lab Tracker Button
    [Arguments]    ${msg}
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //div[@id='UltraSubModalPopup']//following::button[@id='SaveBtn' and contains(text(),'Save')]    2s
    IF    "${check_visible}" == "${True}"
        Common.Scroll And Click Element    //div[@id='UltraSubModalPopup']//following::button[@id='SaveBtn' and contains(text(),'Save')]
    ELSE
        Common.Scroll And Click Element    //div[@id='ModalPopup']//following::button[@id='SaveBtn' and contains(text(),'Save')]
    END
    Common.Page Alert Message    ${msg}

Click Close Lab Tracker Button
    # Common.Scroll And Click Element    ${tracker_close_btn}
    Common.Close Ultra SubModal Popup

Upsert Lab Tracker With All Fields
    [Arguments]    
        ...    ${account_arg}
        ...    ${name_arg}
        ...    ${lab_des_arg}
        ...    ${payer_arg}
        ...    ${physician_arg}
        ...    ${start_date_arg}
        ...    ${end_date_arg}
        ...    ${file_arg}
        ...    ${result_date_arg}
        ...    ${icd10_code_arg}
        ...    ${msg}
        ...    ${drug_lab_arg}=${EMPTY}
        ...    ${select_status}=select
    ${labtracker_dict}    Create Lab Tracker Dictionary
    Select Account In Lab Tracker Modal    ${account_arg}
    Input Patient Name In Lab Tracker Modal    ${name_arg}
    IF    "${msg}" != "Lab Tracker Updated"
        Input Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    END
    Input Payer In Lab Tracker Modal    ${payer_arg}
    Select Ordering Provider In Lab Tracker Modal    ${physician_arg}
    Input Date Time In Lab Tracker Modal    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}
    Input File Number In Lab Tracker Modal    ${file_arg}
    IF    "${select_status}" == "select"
        Select Frequency In Lab Tracker Modal    ${labtracker_dict}
    END
    Select Status In Lab Tracker Modal    ${labtracker_dict}
    Random Stat Order Checkbox In Lab Tracker Modal
    Choose Fasting In Lab Tracker Modal
    Select Lab Company In Lab Tracker Modal
    Choose Primary ICD10 Code In Lab Tracker Modal    ${icd10_code_arg}    Primary
    Choose Primary ICD10 Code In Lab Tracker Modal    ${icd10_code_arg}    Additional
    Click Save Lab Tracker Button    ${msg}
    Set To Dictionary    ${labtracker_dict}    file_num=${file_arg}
    RETURN    ${labtracker_dict}

Upsert Lab Tracker With Required Fields
    [Arguments]    
        ...    ${account_arg}
        ...    ${name_arg}
        ...    ${lab_des_arg}
        ...    ${start_date_arg}
        ...    ${end_date_arg}
        ...    ${msg}
        ...    ${drug_lab_arg}=${EMPTY}
    ${labtracker_dict}    Create Lab Tracker Dictionary
    Select Account In Lab Tracker Modal    ${account_arg}
    Input Patient Name In Lab Tracker Modal    ${name_arg}
    Input Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    Input Order Start Date In Lab Tracker Modal    ${start_date_arg}
    Input Order End Date In Lab Tracker Modal    ${end_date_arg}
    Select Frequency In Lab Tracker Modal    ${labtracker_dict}
    Select Status In Lab Tracker Modal    ${labtracker_dict}
    Click Save Lab Tracker Button    ${msg}

#Attribute
Open Attributes Modal
    Common.Scroll And Click Element    ${attribute_add_btn}
    Wait Until Element Is Visible    ${attribute_title}    30s

Input Descirption In Attributes Modal
    [Arguments]    ${description_arg}
    Common.Input Text Into Field    ${attribute_description}    ${description_arg} 

Select Response Type In Attributes Modal
    [Arguments]    ${dict_arg}    ${value}
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${attribute_response_type}    var_name=attribute_response_type    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${attribute_response_type}    ${value}
        Set To Dictionary    ${dict_arg}    attribute_response_type=${value}
    END

Input Unit In Attributes Modal
    [Arguments]    ${unit_arg}
    Common.Input Text Into Field    ${attribute_unit}    ${unit_arg}  

Input Range Start In Attributes Modal
    [Arguments]    ${range_start_arg}
    Common.Input Text Into Field    ${attribute_range_start}    ${range_start_arg}  

Input Range End In Attributes Modal
    [Arguments]    ${range_end_arg}
    Common.Input Text Into Field    ${attribute_range_end}    ${range_end_arg}  

Input Select List Items In Attributes Modal
    [Arguments]    ${items_arg}
    Common.Input Text Into Field    ${attribute_select_list}    ${items_arg}  

Create Attribute With All Fields
    [Arguments]    ${value}    ${dict_arg}
    Open Attributes Modal
    ${attribute_description_txt}    Input All Fields In Attribute Modal    ${value}    ${dict_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${attribute_save_btn}
    Common.Page Alert Message    Lab Tracker Attribute Added
    RETURN    ${attribute_description_txt}

Verify Attribute Row Is Visible In Lab Tracker Attributes List
    [Arguments]    ${attribute_description_arg}
    ${attribute_edit_btn}    Set Variable    //td[contains(text(),'${attribute_description_arg}')]//following::span[contains(text(),'Edit')][1]
    FOR    ${i}    IN RANGE    10
        ${check_btn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${attribute_edit_btn}    5s
        IF    '${check_btn_visible}' == '${True}'
            Common.Scroll And Click Element    ${attribute_edit_btn}
            Exit For Loop
        ELSE
            Common.Scroll And Click Element    (//a[contains(text(),"Next")])[1]
        END
    END

Update Attribute With All Fields
    [Arguments]    ${attribute_description_arg}    ${value}    ${dict_arg}
    Verify Attribute Row Is Visible In Lab Tracker Attributes List    ${attribute_description_arg}
    Input All Fields In Attribute Modal    ${value}    ${dict_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${attribute_save_btn}
    Common.Page Alert Message    Lab Tracker Attribute Updated

Delete Created Attributes
    ${edit_attribute_list}    SeleniumLibrary.Get Element Count   //div[@id="LabTrackerAttributeList"]//tbody//following-sibling::tr[1]//following::span[contains(@class,'updateLabTrackerAttributeButton')]
    FOR    ${edit_attribute_btn}    IN RANGE    ${edit_attribute_list}
        Common.Scroll And Click Element    (//div[@id="LabTrackerAttributeList"]//tbody//following-sibling::tr[1]//following::span[contains(@class,'updateLabTrackerAttributeButton')])[1]
        Common.Scroll And Click Element    ${attribute_del_btn}
        Handle Alert    ACCEPT
        Common.Page Alert Message    Attribute Removed
    END

Input All Fields In Attribute Modal
    [Arguments]    ${value}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    sentence    demical_2d
    ${attribute_description_txt}    Set Variable    ${Fake_dict['sentence']} 
    Input Descirption In Attributes Modal    ${Fake_dict['sentence']} 
    Select Response Type In Attributes Modal    ${dict_arg}    ${value}
    IF    "${dict_arg.attribute_response_type}" == "Range"
        ${min_range}    Set Variable    ${Fake_dict['demical_2d']}
        ${max_range}    Evaluate    ${Fake_dict['demical_2d']} + ${Fake_dict['demical_2d']}
        Input Range Start In Attributes Modal    ${min_range}   
        Input Range End In Attributes Modal    ${max_range}  
        Input Unit In Attributes Modal    ml
        Set To Dictionary    ${dict_arg}    min_range=${min_range}    max_range=${max_range} 
    ELSE IF    "${dict_arg.attribute_response_type}" == "Selection"
        Input Select List Items In Attributes Modal    Attribute Selection
        Input Unit In Attributes Modal    ml
    ELSE IF    "${dict_arg.attribute_response_type}" == "String"
        Input Unit In Attributes Modal    ml
    END
    RETURN    ${attribute_description_txt}

Delete Attribute
    [Arguments]    ${edit_btn_arg}
    Common.Scroll And Click Element    ${edit_btn_arg}
    Wait Until Keyword Succeeds    30s     1s    Click Element    ${attribute_del_btn}
    Handle Alert    ACCEPT
    Page Alert Message    Attribute Removed

Show Empty Value In Lab Tracker Row
    # ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tracker_patient_value_title}    5s
    # IF    '${check_visible}' == '${False}'
    #     Wait Until Element Is Visible    ${tracker_no_available_title}    5s
    # END
    ${checkbox_visible}    Run Keyword And Return Status    Checkbox Should Not Be Selected    ${tracker_show_empty_checkbox}
    IF    '${checkbox_visible}' == '${True}'
        Common.Scroll And Click Element    ${tracker_show_empty_checkbox}
    END

Get Attribute Result Value In Lab Tracker Row
    [Arguments]    ${attribute_description_txt}
    ${tracker_ledger_result}    Set Variable    //td[contains(text(),'${attribute_description_txt}')]//following::td[@data-column='3'][1]
    ${tracker_ledger_result_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_result}
    RETURN    ${tracker_ledger_result_txt}

Get Lab Tracker Status In Lab Tracker Row
    [Arguments]    ${file_num}
    ${tracker_ledger_status}    Set Variable    //div[contains(text(),'${file_num}')]//preceding::td[1]//div[1]
    ${tracker_ledger_status_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_status}
    RETURN    ${tracker_ledger_status_txt}

Click Close Attribute Popup Button
    Common.Scroll And Click Element    ${attribute_close_btn}