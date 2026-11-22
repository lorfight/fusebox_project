*** Settings ***
Resource    ../../../Layers/PatientInformation/PatientInformation.resource

*** Keywords ***
Create Locator Map
    &{locator_map}    Create Dictionary
        ...    first_name=${first_name_input}
        ...    middle_name=${middle_name_input}
        ...    last_name=${last_name_input}
        ...    mrn=${mrn_input}
        ...    dob=${dob_input}
        ...    ssn=${ssn_input}
        ...    race=${race_select}
        ...    race_additional_detail=${race_additional_detail_input}
        ...    ethnicity=${ethnicity_select}
        ...    gender=${gender_select}
        ...    marital_status=${marital_status_select}
        ...    spouse_first_name=${spouse_first_name_input}
        ...    spouse_middle_name=${spouse_middle_name_input}
        ...    spouse_last_name=${spouse_last_name_input}
        ...    preferred_internal_provider=${preferred_internal_provider_select}
        ...    refering_provider=${reffering_provider_input}
        ...    pcp=${pcp_select}
        ...    dispense_alert_note=${dispensing_alert_note_input}
        ...    height=${height_input}
        ...    weight_lp_value=${weight_lp_input}
        ...    weight_kg_value=${weight_kg_input}
        ...    default_contact=${default_contact_select}
        ...    homephone=${home_phone_input}
        ...    cellphone=${cell_phone_input}
        ...    email=${email_input}
        ...    additional_notes=${additional_notes_input}
        ...    occupation=${occupation_input}
        ...    employer_name=${employer_name_input}
        ...    workphone=${work_phone_input}
        ...    employer_contact_first_name=${employer_first_name_input}
        ...    employer_contact_last_name=${employer_last_name_input}
        ...    employer_contact_phone=${employer_phone_input}
        ...    employer_address_line_1=${employer_address_line_1_input}
        ...    employer_address_line_2=${employer_address_line_2_input}
        ...    employer_city=${employer_city_input}
        ...    employer_state=${employer_state_select}
        ...    employer_postal_code=${employer_postal_code_input}
        ...    employer_country=${employer_country_select}
        ...    responsible_first_name=${responsible_firstName_input}
        ...    responsible_middle_name=${responsible_middleName_input}
        ...    responsible_last_name=${responsible_lastName_input}
        ...    responsible_phone=${responsible_phone_input}
        ...    responsible_dob=${responsible_dob_input}
        ...    responsible_ssn=${responsible_ssn_input}
        ...    responsible_address_line_1=${responsible_address_line_1_input}
        ...    responsible_address_line_2=${responsible_address_line_2_input}
        ...    responsible_city=${responsible_city_input}
        ...    responsible_state=${responsible_state_select}
        ...    responsible_postal_code=${responsible_postal_code_input}
        ...    responsible_country=${responsible_country_select}
        ...    emergency_name=${emergency_name_input}
        ...    emergency_phone=${emergency_phone_input}
        ...    emergency_relationship=${emergency_relationship_input}
    RETURN    &{locator_map}

Verify All Info Of Patient
    [Arguments]    ${dict_arg}
    Check BMI    ${dict_arg.weight_kg_value}    ${dict_arg.weight_lp_value}    ${dict_arg.height}    ${dict_arg.random_weights}
    &{locator_map}    Create Locator Map
    FOR    ${key}    ${locator}    IN    &{locator_map}
        ${check_locator_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    2s
        IF    '${check_locator_visible}' == '${True}'
            ${tag_name}    SeleniumLibrary.Get Element Attribute    ${locator}    tagName
            IF    '${tag_name}' == 'INPUT' or '${tag_name}' == 'TEXTAREA'
                ${ui_value}    SeleniumLibrary.Get Element Attribute    ${locator}    value
            ELSE IF    '${tag_name}' == 'SELECT'
                ${ui_value}    Get Selected List Label    ${locator}
            END
            ${expected_value}    Set Variable    ${dict_arg.${key}}
            Should Be Equal    ${ui_value}    ${expected_value}
        END
    END
    Click Update Patient Button

Remove All Value Field In Update Patient
    &{locator_map}    Create Locator Map
    FOR    ${locator}    IN    @{locator_map.values()}
        ${check_locator_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${locator}    2s
        IF    '${check_locator_visible}' == '${True}'
            ${tag_name}    SeleniumLibrary.Get Element Attribute    ${locator}    tagName
            IF    '${tag_name}' == 'INPUT' or '${tag_name}' == 'TEXTAREA'
                Common.Clear Input Field Until Empty    ${locator}
            ELSE IF    '${tag_name}' == 'SELECT'
                Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${locator}    0
            END
        END
    END
    Click Update Patient Button

Verify Error Message Visible
    ${error_list}    Create List    ${error_first_name}    ${error_last_name}    ${error_mrn_name}    ${error_dob_name}    ${error_gender_name}
    ${expect_error}    Create List    
    ...    The First Name field is required.    
    ...    The Last Name field is required.
    ...    The Medical Record # field is required.
    ...    The Date Of Birth field is required.
    ...    The Gender field is required.    
    FOR    ${error_arg}    IN    @{error_list}
        ${error_txt}    Get Text    ${error_arg}
        Should Contain    ${expect_error}    ${error_txt}
    END

Inactived Patient
    Click Inactive Patient Button
    Click Update Patient Button

Actived Patient
    Click Inactive Patient Button
    Click Update Patient Button

Clear Remain Fields
    Common.Clear Input Field Until Empty   ${first_name_input}
    Common.Clear Input Field Until Empty   ${last_name_input}
    Common.Clear Input Field Until Empty   ${mrn_input}
    Common.Clear Input Field Until Empty    ${dob_input}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${gender_select}    0

Input MRN Already Exists And Input DOB Field
    [Arguments]    ${mrn_arg}    ${dob_arg}    ${account_name_arg}
    Common.Input Text Into Field    ${mrn_Input}    ${mrn_arg}
    Common.Input Text Into Field    ${dob_Input}    ${dob_arg}
    Common.Close Calendar Table
    Wait Until Page Contains    A patient within your network already contains the MRN: ${mrn_arg}    30s
    Wait Until Page Contains    Account: ${account_name_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${close_modal_btn}

Input MRN Already Exists And Input Required Field
    [Arguments]    ${dict_arg}    ${first_name_arg}    ${last_name_arg}    ${mrn_arg}    ${dob_arg}    ${gender_arg}    ${account_name_arg}
    Input Required Fields In Patient Information    
    ...    dict_arg=${dict_arg}
    ...    first_name_arg=${first_name_arg}
    ...    last_name_arg=${last_name_arg}
    ...    mrn_arg=${mrn_arg}
    ...    dob_arg=${dob_arg}
    ...    gender_arg=${gender_arg}
    Click Save Patient Button
    ${check_error}    Run Keyword And Return Status    Wait Until Page Contains    The MRN you are trying to use already exists within another patient.
    IF    '${check_error}' == '${False}'
        Wait Until Page Contains    A patient within your network already contains the MRN: ${mrn_arg} Account: ${account_name_arg}
    END

Select Home Phone And Personal/Home Phone Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Home Phone

Select Cellphone And CellPhone Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Cellphone

Select Email And Email Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Email

Verify Created Address In Corresponding Field
    [Arguments]    ${dict_arg}    ${random_select}
    IF    "${random_select}" == "${default_address_select}"
        ${prefix}    Set Variable    default
        ${option_label}    Set Variable    //select[@id='PrimaryAddress']/option[contains(text(),'${dict_arg.description}')]
        ${option_value}    Get Value    ${option_label}
        Select From List By Value    ${random_select}    ${option_value}
    ELSE IF    "${random_select}" == "${work_address_select}"
        ${prefix}    Set Variable    work
        ${option_label}    Set Variable    //select[@id='WorkAddress']/option[contains(text(),'${dict_arg.description}')]
        ${option_value}    Get Value    ${option_label}
        Select From List By Value    ${random_select}    ${option_value}
    END
    ${fields}    Create List    address_first    address_second    city    state    postal_code    country_region
    FOR    ${field}    IN    @{fields}
        ${xpath_arg}    Set Variable    ${${prefix}_${field}_input}
        ${input_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${xpath_arg}
        Should Be Equal    ${input_value}    ${dict_arg.${field}}
    END

Select Random Patient Address
    [Arguments]    ${select_arg}
    ${select_list}    Create List    ${default_address_select}    ${work_address_select}
    ${random_select}    Evaluate    random.choice(${select_list})
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${random_select}
    Select From List By Label    ${random_select}    ${select_arg}
    RETURN    ${random_select}

Verify Created Patient With Required fields
    [Arguments]    ${expected_value_list}
    ${required_field_list}    Create List    ${first_name_input}    ${last_name_input}    ${mrn_input}    ${dob_input}    ${gender_select}
    FOR    ${expected_value}    ${required_field_value}    IN ZIP    ${expected_value_list}    ${required_field_list}
        Scroll Element Into View    ${required_field_value}
        IF    "${required_field_value}" == "${gender_select}"
            ${input_value}    Get Selected List Label    ${gender_select}
        ELSE
            ${input_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${required_field_value}
        END
        Should Be Equal    ${input_value}    ${expected_value}
    END