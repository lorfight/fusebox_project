*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime
Library    String
Library    pandas
Library    FakerLibrary
Library    ../TestData/Fakedata/FakeData.py
Variables    ../Locators/CommonLocator.py
Variables    ../TestData/Testdata.py
Variables    ../Locators/Patient.py
Resource    ../../../libraries/Util.resource
Resource    Appointment.resource
Resource    Patient.resource
Resource    ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

*** Variables ***
@{input_xpath_list}    
        ...    ${First_Name_Input}    ${Middle_Name_Input}    ${Last_Name_Input}    ${MRN_Input}    ${DOB_Input}    ${SSN_Input}    
        ...    ${other_detail_input}    ${alert_note_textarea_input}    ${Height_Input}    ${home_phone_input}    ${cell_phone_input}    ${email_input}    
        ...    ${additional_notes_input}    ${occupation_input}    ${employer_name_input}    ${work_phone_input}    ${employer_first_name_input}    
        ...    ${employer_last_name_input}    ${employer_phone_input}    ${employer_address1_input}    ${employer_address2_input}    ${employer_city_input}    
        ...    ${employer_zip_input}    ${responsible_firstName_input}    ${responsible_middleName_input}    ${responsible_lastName_input}    
        ...    ${responsible_phone_input}    ${responsible_DOB_input}    ${responsible_SSN_input}    ${responsible_address1_input}    ${responsible_address2_input}    
        ...    ${responsible_city_input}    ${responsible_zip_input}    ${emergency_name_input}    ${emergency_phone_input}    ${emergency_relationship_input}
@{input_var_list}    
        ...    First_Name    Middle_Name    Last_Name    MRN    DOB    SSN    Race_Additional_Detail    Dispensing_Alert_Note    Height    HomePhone    Cellphone    
        ...    Email    Additional_Notes    Occupation    Employer_Name    Work_Phone    Employer_Contact_First_Name    Employer_Contact_Last_Name    Employer_Contact_Phone    
        ...    Employer_Address1    Employer_Address2    Employer_City    Employer_Zip    Responsible_First_Name    Responsible_Middle_Name    Responsible_Last_Name    Responsible_Phone    
        ...    Responsible_DOB    Responsible_SSN    Responsible_Address1    Responsible_Address2    Responsible_City    Responsible_Zip    Emergency_Name    Emergency_Phone    
        ...    Emergency_Relationship
@{select_xpath_list}    
        ...    ${Race_Select}    ${Ethnicity_Select}    ${Gender_Select}    ${MaritalStatus_Select}    ${physician_select}    ${PCP_select}    ${default_contact_select}    
        ...    ${employer_state_select}    ${employer_country_select}    ${responsible_state_select}    ${responsible_country_select}
@{select_var_list}    
...    Race    Ethnicity    Gender    Marital_Status    Physician    PCP    Default_Contact    Employer_State    Employer_Country    Responsible_State    Responsible_Country

*** Keywords ***
Suite Setup With All Patient Information
    Create Dictionary Of PatientCreate Data
    Create Dictionary Of PatientData Data
    Create Dictionary Of Treatment Note Data
    Create Dictionary Of Temp Data
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Set Window Size    1920    1080
    Create Patient With Full Info
    Update All Info Patient    # PaMan_TC114    PaMan_TC116

Suite Setup With Required Patient Information
    Create Dictionary Of PatientCreate Data
    Create Dictionary Of PatientData Data
    Create Dictionary Of Treatment Note Data
    Create Dictionary Of Temp Data
    Create Dictionary Of Provider Order
    Create Dictionary Of Appointment
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Set Window Size    1920    1080
    Create Patient With Required Fields

Log Data And Close Browser
    # Log    Patient Create Data: ${PatientCreate}
    # Log    Patient Update Data: ${PatientData}
    # Delete Created Patient If TestCase Is Failed
    Close Browser

Test Setup Keyword
    ${check_logout}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    Log In
    ${check_disconnect}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    fusebox-portal-staging.azurewebsites.net
    IF    "${check_logout}" == "${True}"
        Login account    ${Username}    ${Password}
        Go To Patients Page
    ELSE IF    "${check_disconnect}" == "${True}"
        Wait Until Keyword Succeeds    15 min    10s    Wait Until Page Is Connected
        Go To Patients Page
    END
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter

Test Teardown Keyword
    Close Window
    Switch To Another Window    title_arg=Patients
    Reload Page

Wait Until Page Is Connected
    Reload Page
    Title Should Be    Home

Delete Created Patient If TestCase Is Failed
    Go To Patients Page
    Select From List By Label    ${Patients_Location_Select}    ${PatientData.Location}
    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientCreate.MRN}
    Click Button    ${Find_Patient_Btn}
    ${patient_row}    Util.Replace Xpath    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[contains(text(),'${PatientCreate.MRN}')]/preceding::td[2]//a
    ${check}    Run Keyword And Return Status    Element Should Be Visible    ${patient_row}    30
    IF    "${check}" == "True"
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${patient_row}
        Wait Until Element Is Visible    ${Delete_Patient_Link}
        Scroll And Click Element    ${Delete_Patient_Link}
        Handle Alert    ACCEPT
        Wait Until Page Contains    No Patients Available.    30S
    END

Create Dictionary Of PatientCreate Data
    &{PatientCreate}    Create Dictionary
    Set Suite Variable    ${PatientCreate}
Create Dictionary Of PatientData Data
    &{PatientData}    Create Dictionary
    Set Suite Variable    ${PatientData}
Create Dictionary Of Treatment Note Data
    &{TNoteData}    Create Dictionary
    Set Suite Variable    ${TNoteData}
Create Dictionary Of Temp Data
    &{TempData}    Create Dictionary
    Set Suite Variable    ${TempData}

Create Dictionary Of Provider Order
    &{PO_data}    Create Dictionary
    Set Suite Variable    ${PO_data}

Create Dictionary Of Appointment
    &{APT_data}    Create Dictionary
    Set Suite Variable    ${APT_data}

Open New Window
    [Arguments]    ${url_arg}
    Execute Javascript    window.open('${url_arg}','_blank')
    Set Window Size    1920    1080

Switch To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}
    Set Window Size    1920    1080
    # Check Newsletter

Get Random Data
    [Arguments]    ${fake_data}
    # ${data}    Generate Data
    ${fake_data}    Get From Dictionary    ${data}    ${fake_data}
    RETURN    ${fake_data}

Create Fake Data List
    ${data}    Generate Data
    Set Suite Variable    ${data}
    ${full_name_fake}    Get Random Data    fake_data=full_name
    ${first_name_fake}    Get Random Data    fake_data=first_name
    ${middle_name_fake}    Get Random Data    fake_data=first_name
    ${last_name_fake}    Get Random Data    fake_data=last_name
    ${email_fake}    Get Random Data    fake_data=email
    ${phone_fake}    Get Random Data    fake_data=phone
    ${address_fake}    Get Random Data    fake_data=address
    ${sentence_str}    Get Random Data    fake_data=sentence
    ${MRN_fake}    Get Random Data    fake_data=MRN
    ${SSN_fake}    Get Random Data    fake_data=SSN
    ${DOB_fake}    Get Random Data    fake_data=DOB
    ${height_fake}    Get Random Data    fake_data=Height
    ${zip_fake}    Get Random Data    fake_data=zip_code
    ${country_fake}    Get Random Data    fake_data=country
    ${job_fake}    Get Random Data    fake_data=job
    ${relationship_fake}    Get Random Data    fake_data=relationship
    ${decimal_2d_2f}    Get Random Data    fake_data=decimal_2d_2f
    ${decimal_3d_2f}    Get Random Data    fake_data=decimal_3d_2f
    ${demical_2d}    Get Random Data    fake_data=demical_2d
    ${demical_3d}    Get Random Data    fake_data=demical_3d
    ${integer_decimal_ratio}    Get Random Data    fake_data=integer_decimal_ratio
    ${exp_date}    Get Random Data    fake_data=exp_date
    ${non_exp_date}    Get Random Data    fake_data=non_exp_date
    ${credit_num}    Get Random Data    fake_data=credit_num
    ${num_rand}    Get Random Data    fake_data=num_rand

    &{Fake_dict}    Create Dictionary    
    ...    full_name_fake=${full_name_fake}    
    ...    first_name_fake=${first_name_fake}    
    ...    middle_name_fake=${middle_name_fake}    
    ...    last_name_fake=${last_name_fake}    
    ...    MRN_fake=${MRN_fake}    
    ...    SSN_fake=${SSN_fake}    
    ...    DOB_fake=${DOB_fake}    
    ...    height_fake=${height_fake}    
    ...    zip_fake=${zip_fake}    
    ...    phone_fake=${phone_fake}    
    ...    sentence_str=${sentence_str}
    ...    country_fake=${country_fake}    
    ...    email_fake=${email_fake}    
    ...    address_fake=${address_fake}    
    ...    job_fake=${job_fake}    
    ...    relationship_fake=${relationship_fake}    
    ...    decimal_2d_2f=${decimal_2d_2f}    
    ...    demical_2d=${demical_2d}    
    ...    decimal_3d_2f=${decimal_3d_2f}    
    ...    integer_decimal_ratio=${integer_decimal_ratio}    
    ...    demical_3d=${demical_3d}    
    ...    exp_date=${exp_date}    
    ...    credit_num=${credit_num}    
    ...    num_rand=${num_rand}    
    ...    non_exp_date=${non_exp_date}
    Set Suite Variable    ${Fake_dict}
    RETURN    ${Fake_dict}

Page Alert Message
    [Arguments]    ${alert}
    Wait Until Page Contains    ${alert}    30s
    Wait Until Page Does Not Contain    ${alert}    30s

Element Is Not Visible
    [Arguments]    ${element}
    ${check_visible}    Run Keyword And Return Status        Wait Until Element Is Visible    ${element}    3s
    Run Keyword If    '${check_visible}' == '${True}'    Wait Until Element Is Not Visible    ${element}    30s

Create Patient With Full Info
    Go To Patients Page
    Check And Delete Patient In Patient Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${PatientData.Location}
    Click Element    ${New_Patient_Link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient
    Create Fake Data List
    Create Value Input
    Scroll And Click Element    ${Patients_Save_Btn}
    Scroll And Click Element    ${Patients_Update_Btn}

Create Patient With Required Fields
    Go To Patients Page
    Check And Delete Patient In Patient Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${PatientData.Location}
    Element Is Not Visible    ${Search_Patient_Loading}
    Click Element    ${New_Patient_Link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient
    Create Fake Data List
    Input Valid Data In Required Fields
    Scroll And Click Element    ${Patients_Save_Btn}
    Scroll And Click Element    ${Patients_Update_Btn}

Check And Delete Patient In Patient Page
    Filter Patient In Patient Page    MRN_arg=${PatientData.MRN}    location_arg=${PatientData.Location}
    ${Merge_Patient_Text}    Util.Replace Xpath    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[contains(text(),'${PatientData.MRN}')]/preceding::td[2]//a
    ${check_mrn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Merge_Patient_Text}    3s
    IF    '${check_mrn_visible}' == '${True}'
        Scroll And Click Element    ${Merge_Patient_Text}
        Scroll And Click Element    ${Delete_Patient_Link}
        ${check_msg}    Run Keyword And Return Status    Wait Until Page Contains    Can not delete patient because they have been assigned to an appointment! Please make the patient inactive.    5s
        IF    '${check_msg}' == '${True}'
            Go To Patients Page
            Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${PatientData.Location}
            Element Is Not Visible    ${Search_Patient_Loading}
            Merge Patient    Keeping_MRN_arg=${PatientData.MRN_merge}
        ELSE    
            Scroll And Click Element    ${Delete_Patient_Link}
            Handle Alert    ACCEPT
        END
    END

Input Valid Data In Required Fields
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${First_Name_Input}    ${Fake_dict.first_name_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Middle_Name_Input}    ${Fake_dict.middle_name_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Last_Name_Input}    ${Fake_dict.last_name_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${MRN_Input}    ${PatientData.MRN}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${DOB_Input}    ${Fake_dict.DOB_fake}
    Scroll And Click Element    ${Close_Calendar_Btn}
    Util.Select Random From List Regression    xpath_arg=${Gender_Select}    var_name=Gender    dic=${PatientData}
    Util.Select Random From List Regression    xpath_arg=${physician_select}    var_name=Physician    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Refering Provider
    Util.Select Random From List Regression    xpath_arg=${PCP_select}    var_name=PCP    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Height_Input}    ${Fake_dict.height_fake}
    Input Weight    ${PatientData.Weight_LB}    ${PatientData.Weight_KG}    ${PatientData}
    Set To Dictionary    ${PatientData}    
    ...    First_Name=${Fake_dict.first_name_fake}    Middle_Name=${Fake_dict.middle_name_fake}    
    ...    Last_Name=${Fake_dict.last_name_fake}    DOB=${Fake_dict.DOB_fake}    Height=${Fake_dict.height_fake}

Verify All Info Of Patient
    Navigate to Patient by Generated MRN
    Check BMI
    Verify Or Remove Weight    status_arg=verify
    Loop Select    status_arg=verify
    Loop Input    status_arg=verify
    Verify Spouse Name    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    Marital_Status=${PatientCreate.Marital_Status}
    ${reffering_provider_value}    SeleniumLibrary.Get Element Attribute    ${reffering_provider_input}    value
    Should Be Equal    ${reffering_provider_value}    ${PatientData.Refering_Provider}
    Scroll And Click Element    ${Patients_Update_Btn}
Update All Info Patient
    Go To Patients Page
    Filter Patient In Patient Page    MRN_arg=${PatientCreate.MRN}    location_arg=${PatientData.Location}
    Select Patient From List    MRN_arg=${PatientCreate.MRN}
    Create Fake Data List
    Update Weight Value
    Loop Select    status_arg=update
    Loop Input    status_arg=update
    Input Spouse Name    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    Marital_Status=${PatientData.Marital_Status}    dict=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Refering Provider
    Verify Save Change Button Visible
    Scroll And Click Element    ${Patients_Update_Btn}
Remove All Value Field In Update Patient
    Navigate to Patient by Generated MRN
    Loop Select    status_arg=remove
    Loop Input    status_arg=remove
    Verify Or Remove Weight    status_arg=remove
    Remove Spouse Name
    Remove Refering Provider
    Scroll And Click Element    ${Patients_Update_Btn}
    Verify Error Message Visible
    Scroll And Click Element    ${cancel_btn}

Create Patient Unsuccessfully
    Go To Create New Patient Page
    Scroll And Click Element    ${Patients_Save_Btn}
    Verify Error Message Visible
    Scroll And Click Element    ${cancel_btn}
Inactived Patient
    Navigate to Patient by Generated MRN
    Scroll And Click Element    ${Inactive_Patient_Checkbox}
    Scroll And Click Element    ${Patients_Update_Btn}

Actived Patient
    Navigate to Patient by Generated MRN
    Scroll And Click Element    ${Inactive_Patient_Checkbox}
    Scroll And Click Element    ${Patients_Update_Btn}

Go To Patients Page
    Scroll And Click Element    ${PatientsLink}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients
Navigate to Patient by Generated MRN
    Go To Patients Page
    Filter Patient In Patient Page    MRN_arg=${PatientData.MRN}    location_arg=${PatientData.Location}
    Select Patient From List    MRN_arg=${PatientData.MRN}
Go To Create New Patient Page
    Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${PatientData.Location}
    Click Element    ${New_Patient_Link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient
Create Value Input
    ${Fake_data_list}    Create List    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    ${Fake_dict.MRN_fake}    ${Fake_dict.DOB_fake}    ${Fake_dict.SSN_fake}    ${Fake_dict.sentence_str}    ${Fake_dict.sentence_str}    ${Fake_dict.height_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.email_fake}    ${Fake_dict.sentence_str}    ${Fake_dict.job_fake}    ${Fake_dict.full_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.first_name_fake}    ${Fake_dict.last_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.address_fake}    ${Fake_dict.address_fake}    ${Fake_dict.country_fake}    ${Fake_dict.zip_fake}    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.DOB_fake}    ${Fake_dict.SSN_fake}    ${Fake_dict.address_fake}    ${Fake_dict.address_fake}    ${Fake_dict.country_fake}    ${Fake_dict.zip_fake}    ${Fake_dict.full_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.relationship_fake}
    FOR    ${xpath_element}    ${var_element}    IN ZIP    ${select_xpath_list}    ${select_var_list}
        Scroll Element Into View    ${xpath_element}
        Util.Select Random From List Regression    xpath_arg=${xpath_element}    var_name=${var_element}    dic=${PatientCreate}
    END
    FOR    ${xpath_element}    ${fake_element}    ${input_var_element}    IN ZIP    ${input_xpath_list}    ${Fake_data_list}    ${input_var_list}
        ${status}    ${result}    Run Keyword And Ignore Error    Scroll Element Into View    ${xpath_element}
        IF    "${status}" == "PASS"
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${xpath_element}    ${fake_element}
            Set To Dictionary    ${PatientCreate}    ${input_var_element}=${fake_element}
            Set Suite Variable    ${PatientCreate}
        END
    END
    Input Spouse Name    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    Marital_Status=${PatientCreate.Marital_Status}    dict=${PatientCreate}
    Wait Until Keyword Succeeds    30s    1s    Input Refering Provider
    Input Weight    ${PatientData.Weight_LB}    ${PatientData.Weight_KG}    ${PatientCreate}

Input Spouse Name
    [Arguments]    ${Spouse_First_Name_arg}    ${Spouse_Middle_Name_arg}    ${Spouse_Last_Name_arg}    ${Marital_Status}    ${dict}
    IF    "${Marital_Status}" != "Single"
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_First_Name_Input}    ${Spouse_First_Name_arg}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_Middle_Name_Input}    ${Spouse_Middle_Name_arg}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_Last_Name_Input}    ${Spouse_Last_Name_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_First_Name_Input}    ${EMPTY}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_Middle_Name_Input}    ${EMPTY}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${Spouse_Last_Name_Input}    ${EMPTY}
    END
    Set To Dictionary    ${dict}    Spouse_First_Name=${Spouse_First_Name_arg}    Spouse_Middle_Name=${Spouse_Middle_Name_arg}    Spouse_Last_Name=${Spouse_Last_Name_arg}
    Set Suite Variable    ${dict}

Remove Refering Provider
    Clear Element Text    ${reffering_provider_input}
    
Clear Remain Fields
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text   ${First_Name_Input}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text   ${Last_Name_Input}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text   ${MRN_Input}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${DOB_Input}

Verify Error Message Visible
    ${error_list}    Create List    ${error_first_name}    ${error_last_name}    ${error_MRN_name}    ${error_DOB_name}    ${error_gender_name}
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

Input Refering Provider
    Press Keys    ${reffering_provider_input}    CTRL+A+BACKSPACE
    Input Text    ${reffering_provider_input}    ${PatientData.Refering_Provider}
    ${refering_provide_strong}    Replace Xpath    xpath=${refering_provide_strong}
    Wait Until Element Is Visible    ${refering_provide_strong}    5s
    Scroll And Click Element    ${refering_provide_strong}

Verify Spouse Name
    [Arguments]    ${Spouse_First_Name_arg}    ${Spouse_Middle_Name_arg}    ${Spouse_Last_Name_arg}    ${Marital_Status}
    IF    "${PatientData.Marital_Status}" != "Single"
        ${Spouse_First_Name_arg}    SeleniumLibrary.Get Element Attribute    ${Spouse_First_Name_Input}    value
        ${Spouse_Middle_Name_arg}    SeleniumLibrary.Get Element Attribute    ${Spouse_Middle_Name_Input}    value
        ${Spouse_Last_Name_arg}    SeleniumLibrary.Get Element Attribute    ${Spouse_Last_Name_Input}    value
        Should Be Equal    ${Spouse_First_Name_arg}    ${PatientData.Spouse_First_Name}
        Should Be Equal    ${Spouse_Middle_Name_arg}    ${PatientData.Spouse_Middle_Name}
        Should Be Equal    ${Spouse_Last_Name_arg}    ${PatientData.Spouse_Last_Name}
    END
Remove Spouse Name
    Clear Element Text    ${Spouse_First_Name_Input}
    Clear Element Text    ${Spouse_Middle_Name_Input}
    Clear Element Text    ${Spouse_Last_Name_Input}
Input Weight
    [Arguments]    ${weight_LB_arg}    ${weight_KG_arg}    ${dict}    #1kg ~ 2.2046lb
    ${weights_list}    Create List    ${weight_LP_input}    ${weight_KG_input}
    ${random_weights}    Evaluate    random.choice(${weights_list})
    IF    "${random_weights}" == "${weight_LP_input}"
        Clear Element Text    ${weight_LP_input}
        Input Text    ${weight_LP_input}    ${weight_LB_arg}
        Click Element    ${weight_KG_title}
        ${weight_LB_value}    Set Variable    ${weight_LB_arg}
        ${weight_KG_value}    Evaluate    round(${weight_LB_arg} / 2.2046, 2)    #1kg ~ 2.2046lb
        ${weight_KG_value}    Convert To String    ${weight_KG_Value}
    ELSE
        Clear Element Text    ${weight_KG_input}
        Input Text    ${weight_KG_input}    ${weight_KG_arg}
        Click Element    ${weight_LP_title}
        ${weight_KG_value}    Set Variable    ${weight_KG_arg}
        ${weight_LB_Value}    Evaluate    round(${weight_KG_arg} * 2.2046)    #1kg ~ 2.2046lb
        ${weight_LB_Value}    Convert To String    ${weight_LB_Value}
    END
    Set Suite Variable    ${random_weights}
    Set Suite Variable    ${weight_KG_value}
    Set Suite Variable    ${weight_LB_value}
    Set To Dictionary    ${dict}    Weight_KG=${weight_KG_value}    Weight_LB=${weight_LB_value}
Verify Or Remove Weight
    [Arguments]    ${status_arg}
    Scroll Element Into View    ${weight_LP_input}
    IF    '${status_arg}' == 'verify'
        ${weight_LB_text}    SeleniumLibrary.Get Element Attribute    ${weight_LP_input}    value
        ${weight_LB_text}    Convert To String    ${weight_LB_text}
        Should Be Equal    ${weight_LB_text}    ${PatientData.Weight_LB}
        ${weight_KG_text}    SeleniumLibrary.Get Element Attribute    ${weight_KG_input}    value
        ${weight_KG_text}    Convert To String    ${weight_KG_text}
        Should Be Equal    ${weight_KG_text}    ${PatientData.Weight_KG}
    ELSE IF    '${status_arg}' == 'remove'
        Clear Element Text    ${weight_LP_input}
        Clear Element Text    ${weight_KG_input}
    END

Update Weight Value
    Input Weight    ${PatientData.Weight_LB}    ${PatientData.Weight_KG}    ${PatientData}

Check BMI
    Scroll Element Into View    ${BMI_text}
    ${BMI_text}    Get Text    ${BMI_text}
    IF    "${random_weights}" == "${weight_LP_input}"
        ${BMI_value}    Evaluate    round((${PatientData.Weight_LB} * 703) / ((${PatientData.Height}) ** 2), 1)    # (lb * 703) / (inch)^2
    ELSE
        ${BMI_value}    Evaluate    round((${PatientData.Weight_KG}) / ((${PatientData.Height} * 0.0254) ** 2), 1)    # (kg) / (inch * 0.0254)^2
    END
    ${BMI_value}    Convert To String    ${BMI_value}
    Should Be Equal    ${BMI_value}    ${BMI_text}

Select Patient From List
    [Arguments]    ${MRN_arg}
    Set Suite Variable    ${Merge_MRN}    ${MRN_arg}
    ${Merge_Patient_Text}    Util.Replace Xpath    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[contains(text(),'${Merge_MRN}')]/preceding::td[2]//a
    Wait Until Element Is Visible    ${Merge_Patient_Text}    30s
    Scroll And Click Element    ${Merge_Patient_Text}

Filter Patient In Patient Page
    [Arguments]    ${MRN_arg}    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Patients_Location_Select}    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Find_Patient_Input}    ${MRN_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Advanced_Search_Btn}
    Wait Until Element Is Visible    ${advanced_search_text}    30s
    Scroll And Click Element    ${advanced_clear_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${Find_Patient_Btn}
    Element Is Not Visible    ${Search_Patient_Loading}

Loop Select
    [Arguments]    ${status_arg}
    FOR    ${xpath_element}    ${var_element}    IN ZIP    ${select_xpath_list}    ${select_var_list}
        Scroll Element Into View    ${xpath_element}
        IF    '${status_arg}' == 'verify'
            ${selected_value}    Get Selected List Label    ${xpath_element}
            Should Be Equal    ${selected_value}    ${PatientData.${var_element}}
        ELSE IF    '${status_arg}'=='remove'
            ${list_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${xpath_element}
            ${list_length}    Get Length    ${list_options}
            ${selected}    Get From List    ${list_options}    0
            Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${xpath_element}    ${selected}
        ELSE IF    '${status_arg}'=='update'
            Util.Select Random From List Regression    xpath_arg=${xpath_element}    var_name=${var_element}    dic=${PatientData}
        END
    END

Loop Input
    [Arguments]    ${status_arg}
    ${Fake_data_list}    Create List    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    ${PatientData.MRN}    ${Fake_dict.DOB_fake}    ${Fake_dict.SSN_fake}    ${Fake_dict.sentence_str}    ${Fake_dict.sentence_str}    ${Fake_dict.height_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.email_fake}    ${Fake_dict.sentence_str}    ${Fake_dict.job_fake}    ${Fake_dict.full_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.first_name_fake}    ${Fake_dict.last_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.address_fake}    ${Fake_dict.address_fake}    ${Fake_dict.country_fake}    ${Fake_dict.zip_fake}    ${Fake_dict.first_name_fake}    ${Fake_dict.middle_name_fake}    ${Fake_dict.last_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.DOB_fake}    ${Fake_dict.SSN_fake}    ${Fake_dict.address_fake}    ${Fake_dict.address_fake}    ${Fake_dict.country_fake}    ${Fake_dict.zip_fake}    ${Fake_dict.full_name_fake}    ${Fake_dict.phone_fake}    ${Fake_dict.relationship_fake}
    FOR    ${xpath_element}    ${var_element}    ${update_element}    IN ZIP    ${input_xpath_list}    ${input_var_list}    ${Fake_data_list}
        ${check}    ${result}    Run Keyword And Ignore Error    Scroll Element Into View    ${xpath_element}
        IF    "${check}" == "PASS"
            Scroll Element Into View    ${xpath_element}
            IF    '${status_arg}' == 'verify'
                ${input_value}    Get Value    ${xpath_element}
                Should Be Equal    ${input_value}    ${PatientData.${var_element}}
            ELSE IF    '${status_arg}' == 'remove'
                Clear Element Text    ${xpath_element}
            ELSE IF    '${status_arg}' == 'update'
                Update Value Input    xpath_arg=${xpath_element}    field_arg=${var_element}    keyword_arg=${update_element}
            END
        END
    END
    
Update Value Input
    [Arguments]    ${xpath_arg}    ${field_arg}    ${keyword_arg}
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${xpath_arg}
    Clear Element Text    ${xpath_arg}
    ${status}    ${result}    Run Keyword And Ignore Error    Scroll Element Into View    ${xpath_arg}
    IF    "${status}" == "PASS"
        Input Text    ${xpath_arg}    ${keyword_arg}
        Set To Dictionary    ${PatientData}    ${field_arg}=${keyword_arg}
        Set Suite Variable    ${PatientData}
    END

Verify Save Change Button Visible
    Scroll Element Into View    ${save_changes_btn}
    Wait Until Element Is Visible    ${save_changes_btn}    30s

Input Remain Fields
    Input Text    ${First_Name_Input}    ${Fake_dict.first_name_fake}
    Input Text    ${Last_Name_Input}    ${Fake_dict.last_name_fake}
    Input Text    ${MRN_Input}    ${Fake_dict.MRN_fake}
    Input Text     ${DOB_Input}    ${Fake_dict.DOB_fake}
    Click Button    ${Close_Calendar_Btn}
    Select From List By Label    ${Gender_Select}    Male

Select Home Phone And Personal/Home Phone Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Home Phone

Select Cellphone And CellPhone Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Cellphone

Select Email And Email Field Is Blank
    Scroll Element Into View    ${default_contact_select}
    Select From List By Label    ${default_contact_select}    Email

Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${lab_tracker_tab}
    Scroll And Click Element    ${lab_tracker_tab}
    Wait Until Page Contains    CRITICAL LAB COMPONENT RESULTS    30s

Open Payer Information Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${payer_info_tab}
    Scroll And Click Element    ${payer_info_tab}
    Wait Until Page Contains    Patient Insurance / Plans    30s

Open Co-Pay Assistance Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${copay_assistance_tab}
    Scroll And Click Element    ${copay_assistance_tab}
    Wait Until Element Is Visible    ${copay_add_btn}    30s

Open Documents Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${document_tab}
    Scroll And Click Element    ${document_tab}
    Wait Until Element Is Visible    ${document_title}    30s

Open Prior Authorizations Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${PA_tab}
    Scroll And Click Element    ${PA_tab}
    Wait Until Element Is Visible    //th[contains(text(),'Expires In')]    30s

Open Assessment Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${assessment_tab}
    Scroll And Click Element    ${assessment_tab}
    Wait Until Element Is Visible    ${assessment_title}    30s

Open Patient Alerts Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${alerts_tab}
    Scroll And Click Element    ${alerts_tab}
    Wait Until Element Is Visible    ${alerts_title}    30s

Add Payer
    Scroll And Click Element    ${add_payer_btn}
    Wait Until Page Contains    Assign Insurance / Payer Information    30s
Select Plan
    Scroll And Click Element    ${select_plan_radio}

Fill Medical Info
    [Arguments]    ${subscriber}    ${group}    ${dict}    ${btn_arg}
    Scroll And Click Element    ${medical_type}
    Input Text    ${medical_subscriber_num}    ${subscriber}
    Input Text    ${medical_group_num}    ${group}
    Select Date In Payer
    ${date_zone}    Get Time Now    result_format=%m/%d/%Y
    ${time_zone}    Get Time Zone   result_format=%#I:%M %p
    Set Suite Variable    ${date_zone}
    Set Suite Variable    ${time_zone}
    Set To Dictionary    ${dict}    CertificateNumber=${subscriber}    GroupNumber=${group}
    Set Suite Variable    ${dict}
    Scroll And Click Element    ${btn_arg}

Fill Pharmacy Info
    [Arguments]    ${subscriber}    ${group}    ${bin}    ${pcn}    ${rxgroup}    ${dict}    ${btn_arg}
    Scroll And Click Element    ${pharmacy_type}
    Input Text    ${pharmacy_subscriber_num}    ${subscriber}
    Input Text    ${pharmacy_group_num}    ${group}
    Input Text    ${pharmacy_Bin_num}    ${bin}
    Input Text    ${pharmacy_PCN_num}    ${pcn}
    Input Text    ${pharmacy_RxGroup_num}    ${rxgroup}
    Select Date In Payer
    ${date_zone}    Get Time Now    result_format=%m/%d/%Y
    ${time_zone}    Get Time Zone   result_format=%#I:%M %p
    Set Suite Variable    ${date_zone}
    Set Suite Variable    ${time_zone}
    Set To Dictionary    ${dict}    CertificateNumber=${subscriber}    GroupNumber=${group}    BIN=${bin}    PCN=${pcn}    RxGroup=${rxgroup}
    Set Suite Variable    ${dict}
    Scroll And Click Element    ${btn_arg}

Select Date In Payer
    ${effective_date}    Get Current Date    result_format=%m/%d/%Y
    ${expiration_date}    Add Time To Date    ${effective_date}    30 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Scroll Element Into View    ${pharmacy_effective_date}
    Input Text    ${pharmacy_effective_date}    ${effective_date}
    Scroll And Click Element    ${Close_Calendar_Btn}
    Input Text    ${pharmacy_expiration_date}    ${expiration_date}
    Scroll And Click Element    ${Close_Calendar_Btn}
    Set Suite Variable    ${effective_date}
    Set Suite Variable    ${expiration_date}

Create A New Medical Plan
    Add Payer
    Select Plan
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Select Date In Payer
    &{old_medical}    Create Dictionary
    Set Suite Variable    ${old_medical}
    Fill Medical Info    subscriber=${num_rand}    group=${num_rand}    dict=${old_medical}    btn_arg=${payer_create_btn}
    Page Alert Message    Insurance Plan successfully Assigned to the Patient.

Create A New Pharmacy Plan
    Add Payer
    Select Plan
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    Select Date In Payer
    &{old_pharmacy}    Create Dictionary
    Set Suite Variable    ${old_pharmacy}
    Fill Pharmacy Info    subscriber=${num_rand}    group=${num_rand}    bin=${num_rand}    pcn=${num_rand}    rxgroup=${num_rand}    dict=${old_pharmacy}    btn_arg=${payer_create_btn}
    Page Alert Message    Insurance Plan successfully Assigned to the Patient.

Edit Medical Payer Plan
    ${payer_edit_btn}    Util.Replace Xpath    ${payer_edit_btn}
    Scroll And Click Element    ${payer_edit_btn}
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    &{new_medical}    Create Dictionary
    Set Suite Variable    ${new_medical}
    Fill Medical Info    subscriber=${num_rand}    group=${num_rand}    dict=${new_medical}    btn_arg=${payer_update_btn}
    Page Alert Message    Insurance Plan successfully Updated.

Check Payer Plan Is Visible
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${payer_remove_btn}
    IF    "${status}" == "True"
        Remove Payer Plan    status=ACCEPT
    END

Edit Pharmacy Payer Plan
    ${payer_edit_btn}    Util.Replace Xpath    ${payer_edit_btn}
    Scroll And Click Element    ${payer_edit_btn}
    Create Fake Data List
    ${num_rand}    Get Random Data    fake_data=num_rand
    &{new_pharmacy}    Create Dictionary
    Set Suite Variable    ${new_pharmacy}
    Fill Pharmacy Info    subscriber=${num_rand}    group=${num_rand}    bin=${num_rand}    pcn=${num_rand}    rxgroup=${num_rand}    dict=${new_pharmacy}    btn_arg=${payer_update_btn}
    Page Alert Message    Insurance Plan successfully Updated.

Remove Payer Plan
    [Arguments]    ${status}
    ${payer_remove_btn}    Util.Replace Xpath    ${payer_remove_btn}
    Scroll And Click Element    ${payer_remove_btn}
    Handle Alert    ${status}
    IF    "${status}" == "ACCEPT"
        Page Alert Message    Insurance Plan successfully Removed from the Patient.
    END

Verify Patient Information In Changelog
    Scroll And Click Element    ${payer_view_change}
    Wait Until Element Is Visible    ${changelog_patient_name}    30s
    ${changelog_patient_name}    Get Text    ${changelog_patient_name}
    ${changelog_MRN}    Get Text    ${changelog_MRN}
    ${changelog_DOB}    Get Text    ${changelog_DOB}
    Should Be Equal    ${changelog_patient_name}    ${PatientData.First_Name} ${PatientData.Middle_Name} ${PatientData.Last_Name}
    Should Be Equal    ${changelog_MRN}    ${PatientData.MRN}
    Should Be Equal    ${changelog_DOB}    ${PatientData.DOB}
    Scroll And Click Element    ${changelog_close_btn}

Verify Expand Or Collapse Changelog Table
    Scroll And Click Element    ${payer_view_change}
    Scroll And Click Element    ${changelog_collapsed}
    ${status1}    Run Keyword And Return Status    Wait Until Page Does Not Contain    No Changes Available.
    ${status2}    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${changelog_table}
    IF    "${status1}" == "FAIL" and "${status2}" == "FAIL"
        Fail    "Both conditions failed"
    END
    Scroll And Click Element    ${changelog_collapsed}
    ${status1}    Run Keyword And Return Status    Wait Until Page Contains    No Changes Available.
    ${status2}    Run Keyword And Return Status    Wait Until Element Is Visible    ${changelog_table}
    IF    "${status1}" == "FAIL" and "${status2}" == "FAIL"
        Fail    "Both conditions failed"
    END
    Click Button    ${changelog_close_btn}

Check Message For Changelog Display
    Scroll And Click Element    ${payer_view_change}
    ${status1}    Run Keyword And Return Status    Wait Until Page Contains    No Changes Available.
    ${status2}    Run Keyword And Return Status    Wait Until Page Contains    No Insurance Plans Assigned.
    ${status3}    Run Keyword And Return Status    Wait Until Element Is Visible    ${changelog_table}
    IF    "${status1}" == "FAIL" and "${status2}" == "FAIL" and "${status3}" == "FAIL"
        Fail    "Both conditions failed"
    END
    Click Button    ${changelog_close_btn}

Get User Name
    Wait Until Element Is Visible    ${user_name_element}    30s
    ${user_name_txt}    Get Text    ${user_name_element}
    ${user_name_txt}    Get Regexp Matches    ${user_name_txt}    (?<=,\ ).*(?=\ of)
    ${user_name_txt}    Set Variable    ${user_name_txt}[0]
    Set Test Variable    ${user_name_txt}

Open Progress Note Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${progress_note_tab}
    Scroll And Click Element    ${progress_note_tab}
    Wait Until Page Contains    ${PatientData.First_Name} ${PatientData.Last_Name} - DOB: ${PatientData.DOB} - MRN: ${PatientData.MRN}    30s

The Subject Filter dropdown is visible
    Wait Until Element Is Visible    ${subject_filter_span}    30s
    Wait Until Element Is Visible    ${subject_filter_select}    30s
    
Choose Date In Date Picker Table
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    ${date_range_span}    30s
    Click Element    ${date_arg}
    Wait Until Element Is Visible    ${date_picker_table}    30s
    ${today}=    Get Current Date    result_format=%#d
    Set Test Variable    ${today}
    ${today_choose}    Util.Replace Xpath    ${list_date_picker_table}
    Wait Until Element Is Visible    ${today_choose}    5s
    Click Element    ${today_choose}
    Click Element    ${Close_Calendar_Btn}

Verify A Form Is Visible When Click Add Note
    Scroll And Click Element    ${add_note_btn}
    Wait Until Page Contains    Add Progress Note    30s
    Wait Until Page Contains Element    ${subject_field_select}    30s
    Wait Until Page Contains Element    ${follow_date_span}    30s
    Wait Until Page Contains Element    ${progress_note_textbox}    30s
    Wait Until Page Contains Element    ${progress_save_btn}    30s
    Wait Until Page Contains Element    ${progress_cancel_btn}    30s

Add New Subject
    Select From List By Label    ${subject_field_select}    -- Add New Subject --
    Wait Until Page Contains Element    ${note_new_subject}    30s
    Input Text    ${note_new_subject}    New Subject

Check Medical Plan In Changelog
    Scroll And Click Element    ${payer_view_change}
    ${properties}    Create List    CertificateNumber    GroupNumber
    FOR    ${i}    IN RANGE    1    3
        ${prop}    Set Variable    ${properties}[${i - 1}]
        ${row_xpath}    Set Variable    xpath=(//tbody//tr[td[1][text()='${prop}']])[last()]
        Wait Until Element Is Visible    ${row_xpath}    30s
        ${property}    Get Text    ${row_xpath}/td[1]
        ${old_value}    Get Text    ${row_xpath}/td[2]
        ${new_value}    Get Text    ${row_xpath}/td[3]
        ${changed_by}    Get Text    ${row_xpath}/td[4]
        ${change_date}    Get Text    ${row_xpath}/td[5]
        ${expected_old_value}    Set Variable    ${old_medical.${prop}}
        ${expected_new_value}    Set Variable    ${new_medical.${prop}}
        Should Be Equal    ${property}    ${prop}
        Should Be Equal    ${old_value}    ${expected_old_value}
        Should Be Equal    ${new_value}    ${expected_new_value}
        Should Be Equal    ${changed_by}    ${user_name_txt}
        # Should Be Equal    ${change_date}    ${date_zone} on ${time_zone}
        Should Contain    ${change_date}    ${date_zone}
    END
    Scroll And Click Element    ${changelog_close_btn}

Check Pharmacy Plan In Changelog
    Scroll And Click Element    ${payer_view_change}
    ${properties}    Create List    CertificateNumber    GroupNumber    RxGroup    PCN    BIN
    FOR    ${i}    IN RANGE    1    6
        ${prop}    Set Variable    ${properties}[${i - 1}]
        ${row_xpath}    Set Variable    xpath=(//tbody//tr[td[1][text()='${prop}']])[last()]
        Wait Until Element Is Visible    ${row_xpath}    30s
        ${property}    Get Text    ${row_xpath}/td[1]
        ${old_value}    Get Text    ${row_xpath}/td[2]
        ${new_value}    Get Text    ${row_xpath}/td[3]
        ${changed_by}    Get Text    ${row_xpath}/td[4]
        ${change_date}    Get Text    ${row_xpath}/td[5]
        ${expected_old_value}    Set Variable    ${old_pharmacy.${prop}}
        ${expected_new_value}    Set Variable    ${new_pharmacy.${prop}}
        Should Be Equal    ${property}    ${prop}
        Should Be Equal    ${old_value}    ${expected_old_value}
        Should Be Equal    ${new_value}    ${expected_new_value}
        Should Be Equal    ${changed_by}    ${user_name_txt}
        # Should Be Equal    ${change_date}    ${date_zone} on ${time_zone}
        Should Contain    ${change_date}    ${date_zone}
    END
    Scroll And Click Element    ${changelog_close_btn}

Check Inactive In Changelog
    Scroll And Click Element    ${payer_view_change}
    ${row_xpath}    Set Variable    ${changelog_inactive_row}
    Wait Until Element Is Visible    ${row_xpath}    30s
    ${property}    Get Text    ${row_xpath}/td[1]
    ${old_value}    Get Text    ${row_xpath}/td[2]
    ${new_value}    Get Text    ${row_xpath}/td[3]
    ${changed_by}    Get Text    ${row_xpath}/td[4]
    ${change_date}    Get Text    ${row_xpath}/td[5]
    Should Be Equal    ${property}    Inactive
    Should Be Equal    ${old_value}    False
    Should Be Equal    ${new_value}    True
    Should Be Equal    ${changed_by}    ${user_name_txt}
    # Should Be Equal    ${change_date}    ${date_zone} on ${time_zone}
    Should Contain    ${change_date}    ${date_zone}
    Scroll And Click Element    ${changelog_close_btn}

Inactive Payer Plan
    Scroll And Click Element    ${payer_edit_btn}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${payer_inactive_checkbox}
    Scroll And Click Element    ${payer_inactive_checkbox}
    Click Button    ${payer_update_btn}
    Page Alert Message    Insurance Plan successfully Updated.

Open Address Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${address_tab}
    Scroll And Click Element    ${address_tab}
    Wait Until Page Contains    Addresses    30s

Create New Address
    Select Random Patient Address    select_arg=-- Create New Address --
    Create Fake Data List
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_description}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address1}    ${Fake_dict.address_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address2}    ${Fake_dict.address_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_city}    ${Fake_dict.country_fake}
    Util.Select Random From List Regression    xpath_arg=${address_state}    var_name=address_state    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_zipcode}    ${Fake_dict.zip_fake}
    Util.Select Random From List Regression    xpath_arg=${address_Country}    var_name=address_Country    dic=${PatientData}
    Scroll And Click Element    ${address_create}
    Scroll And Click Element    ${address_close}
    Set To Dictionary    ${PatientData}    address_description=${Fake_dict.sentence_str}    address_address1=${Fake_dict.address_fake}    address_address2=${Fake_dict.address_fake}    address_city=${Fake_dict.sentence_str}    address_zipcode=${Fake_dict.zip_fake}
    Set Test Variable    ${PatientData}

Input With Valid Fields
    [Arguments]    ${descirption}   ${address1}    ${address2}    ${city}    ${zipcode}    ${error_message}
    ${status}    ${msg}    Run Keyword And Ignore Error    Wait Until Element Is Visible    //h4[contains(text(),'Update Patient Address')]    5s
    IF    '${status}' == 'FAIL'
        Select Random Patient Address    select_arg=-- Create New Address --
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_description}    ${descirption}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address1}    ${address1}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address2}    ${address2}
        Wait Until Keywo rd Succeeds    30s    1s    Input Text    ${address_city}    ${city}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_zipcode}    ${zipcode}
        Util.Select Random From List Regression    xpath_arg=${address_state}    var_name=address_state    dic=${PatientData}
        Util.Select Random From List Regression    xpath_arg=${address_Country}    var_name=address_Country    dic=${PatientData}
        Click Element    ${address_create}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_description}    ${descirption}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address1_update}    ${address1}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address2_update}    ${address2}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_city_update}    ${city}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_zipcode_update}    ${zipcode}
        Util.Select Random From List Regression    xpath_arg=${address_state}    var_name=address_state    dic=${PatientData}
        Util.Select Random From List Regression    xpath_arg=${address_Country}    var_name=address_Country    dic=${PatientData}
        Click Element    ${address_update}
    END
    Wait Until Element Is Visible    ${address_message}
    ${error_text}    Get Text    ${address_message}
    Should Be Equal As Strings    ${error_text}    ${error_message}
    Wait Until Element Is Not Visible    ${address_message}
    Scroll And Click Element    ${address_close}
    Set To Dictionary    ${PatientData}    address_description=${descirption}    address_address1=${address1}    address_address2=${address2}    address_city=${city}    address_zipcode=${zipcode}
    Set Test Variable    ${PatientData}

Select Random Patient Address
    [Arguments]    ${select_arg}
    ${select_list}    Create List    ${default_address_select}    ${work_address_select}
    ${random_select}    Evaluate    random.choice(${select_list})
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${random_select}
    Select From List By Label    ${random_select}    ${select_arg}
    Set Test Variable    ${random_select}

Verify Created Address In Corresponding Field
    IF    "${random_select}" == "${default_address_select}"
        ${prefix}    Set Variable    default
        ${option_label}    Replace Variables    //select[@id='PrimaryAddress']/option[contains(text(),'${PatientData.address_description}')]
        ${option_value}    Get Value    ${option_label}
        Select From List By Value    ${random_select}    ${option_value}
    ELSE IF    "${random_select}" == "${work_address_select}"
        ${prefix}    Set Variable    work
        ${option_label}    Replace Variables    //select[@id='WorkAddress']/option[contains(text(),'${PatientData.address_description}')]
        ${option_value}    Get Value    ${option_label}
        Select From List By Value    ${random_select}    ${option_value}
    END
    ${fields}    Create List    address1    address2    city    state    zipcode    Country
    FOR    ${field}    IN    @{fields}
        ${xpath_arg}    Util.Replace Xpath    ${${prefix}_${field}_input}
        ${input_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${xpath_arg}
        Should Be Equal    ${input_value}    ${PatientData["address_${field}"]}
    END

Edit Patient Address Row
    Scroll And Click Element    ${address_row}
    Create Fake Data List
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Updated.

Remove Required Fields In Patient Address Row
    Create Fake Data List
    Scroll And Click Element    ${address_row}
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${EMPTY}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Line is required!
    Scroll And Click Element    ${address_row}
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${EMPTY}    zipcode=${Fake_dict.zip_fake}     error_message=City is required!
    Scroll And Click Element    ${address_row}
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${EMPTY}     error_message=Zip Code is required!
    Scroll And Click Element    ${address_row}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address1}    ${Fake_dict.address_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_address2}    ${Fake_dict.address_fake}
    Wait Until Keywo rd Succeeds    30s    1s    Input Text    ${address_city}    ${Fake_dict.country_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${address_zipcode}    ${Fake_dict.zip_fake}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${address_state}    0
    Util.Select Random From List Regression    xpath_arg=${address_Country}    var_name=address_Country    dic=${PatientData}
    Click Element    ${address_update}
    Page Alert Message    State is required!
    Scroll And Click Element    ${address_close}

Inactive Patient Address Row
    Scroll And Click Element    ${address_row}
    Scroll And Click Element    ${address_inactive_input}
    Scroll And Click Element    ${address_update}
    Page Alert Message    Address Successfully Updated.
    Scroll And Click Element    ${address_close}
    Wait Until Element Is Visible    ${address_inactive_icon}    30s

Check Table Displays All Required Columns
    Wait Until Element Is Visible    ${address_id_column}    30s
    ${address_id_column}    Get Text   ${address_id_column}
    Should Be Equal    '${address_id_column}'    '#'
    ${address_address_column}    Get Text   ${address_address_column}
    Should Be Equal    ${address_address_column}    Address Line
    ${address_city_column}    Get Text   ${address_city_column}
    Should Be Equal    ${address_city_column}    City
    ${address_state_column}    Get Text   ${address_state_column}
    Should Be Equal    ${address_state_column}    State
    ${address_zipcode_column}    Get Text   ${address_zipcode_column}
    Should Be Equal    ${address_zipcode_column}    Zip Code
    ${address_inactive_column}    Get Text   ${address_inactive_column}
    Should Be Equal    ${address_inactive_column}    Inactive

Get Qty Of Tabs In Patient Page
    [Arguments]    ${tab_arg}
    Go To Patients Page
    Filter Patient In Patient Page    MRN_arg=${PatientData.MRN}    location_arg=${PatientData.Location}
    ${tab_arg}    Get Text    ${tab_arg}
    ${numbers}    Get Regexp Matches    ${tab_arg}    \\d+
    ${numbers}    Set Variable    ${numbers}[0]
    Set Test Variable    ${numbers}

Get Qty Address Line In Patient Addresses Tab
    Navigate to Patient by Generated MRN
    Input With Valid Fields    descirption=${Fake_dict.sentence_str}    address1=${Fake_dict.address_fake}    address2=${Fake_dict.address_fake}    city=${Fake_dict.country_fake}    zipcode=${Fake_dict.zip_fake}     error_message=Address Successfully Created.
    Open Address Tab
    ${row_count}    SeleniumLibrary.Get Element Count    ${address_row_total}
    Set Test Variable    ${row_count}

Get Qty Address Line In Payer Information Tab
    Navigate to Patient by Generated MRN
    Open Payer Information Tab
    Check Payer Plan Is Visible
    Create A New Medical Plan
    ${row_count}    SeleniumLibrary.Get Element Count    ${address_line_total}
    Set Test Variable    ${row_count}

Open Vital Signs Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${vital_signs_tab}
    Scroll And Click Element    ${vital_signs_tab}
    Wait Until Element Is Visible    ${vital_sign_title}    30s

Open Provider Orders tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${PO_tab}
    Scroll And Click Element    ${PO_tab}
    Wait Until Element Is Visible    ${create_PO_btn}    30s

Open Diagnosis tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${Diagnosis_tab}
    Scroll And Click Element    ${Diagnosis_tab}
    Wait Until Element Is Visible    ${title_ICD}    30s

Open Appointments Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${APT_tab}
    Scroll And Click Element    ${APT_tab}
    Wait Until Page Contains    Scheduled Appointments    30s

Verify The Vital Sign Table Displays All Columns
    @{title_arg}    Create List    Date Taken    Blood Pressure    (mmHg)    Heart Rate    
    ...    (bpm)    Resp Rate    (per minute)    Temperature    Height    Weight    BMI
    ...    (kg/m²)    BSA    (m²)    SpO2    O2 Flow Rate    (L/min)
    FOR    ${header}    IN    @{title_arg}
        Element Should Be Visible    //th[contains(., '${header}')]    30s
        ${title_txt}    Get Text    //th[contains(., '${header}')]
        Should Contain    ${title_txt}    ${header}
    END

Create New PO
    [Arguments]    ${med_arg}    ${PO_dosage_arg}
    Open Provider Orders tab
    Scroll And Click Element    ${create_PO_btn}
    Wait Until Page Contains    Ordering Location    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${med_arg}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Scroll And Click Element    ${PO_modal_create_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_exist_alert}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician}
    Get PO Number
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_ft}    ${Fake_dict.height_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_inch}    ${Fake_dict.height_fake}
    Scroll And Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dose_convert}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_place_service}    var_name=PO_place_service    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_num_dose}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_uom_select}    var_name=PO_uom_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${Po_container_type}    var_name=Po_container_type    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_split_dose}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_split_treatment}    var_name=PO_split_treatment    dic=${TempData}

    # ${dose_input}    Set Variable    //input[@id="VisitDose_1"]
    # Wait Until Keyword Succeeds    30s    1s    Input Text    ${dose_input}    10
    # ${activate_regiment_select}    Set Variable    //select[@id="ActivateRegimen_1"]
    # Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${activate_regiment_select}    Maintenance Dose
    # ${activate_regiment_select}    Set Variable    //select[@id="RepeatRegimen"]
    # ${activate_regiment_frequency_select}    Set Variable    //select[@id="RepeatRegimenFrequency"]
    # Util.Select Random From List Regression    xpath_arg=${activate_regiment_select}    var_name=activate_regiment    dic=${TempData}
    # Util.Select Random From List Regression    xpath_arg=${activate_regiment_frequency_select}    var_name=activate_regiment_frequency    dic=${TempData}
    Scroll And Click Element Modal    ${PO_modal_create_btn}
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    2s
    IF    ${check_advised} == ${True}
        Scroll And Click Element Modal    ${PO_accept_btn}
    END
    Page Alert Message    Provider Order Successfully Created!
    Scroll And Click Element    ${PO_modal_close_btn}

Get PO Number
    ${PO_number}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${PO_number_txt}
    ${PO_number}    Fetch From Right    ${PO_number}    \: \
    Set Test Variable    ${PO_number}
    Set To Dictionary    ${PO_data}    PO_num=${PO_number}    
Input Referring/Ordering Provider
    [Arguments]    ${refer_arg}
    Input Text    ${PO_referring_order}    ${refer_arg}
    Set Test Variable    ${refer_arg}
    ${PO_highlight_referring}    Util.Replace Xpath    xpath=${PO_highlight_referring}
    Wait Until Element Is Visible    ${PO_highlight_referring}     60
    Sleep    1s
    ${referring}    Wait Until Keyword Succeeds    5s    1s    Get Text    ${PO_highlight_referring}/parent::*
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${PO_highlight_referring}
    Util.Select Random From List Regression    xpath_arg=${PO_referral_source}    var_name=PO_referral_source    dic=${PatientData}
    Set To Dictionary    ${PatientData}    Referring_Provider=${referring}

Select Refer To Provider
    [Arguments]    ${refer_to_arg}
    Select From List By Value   ${PO_refer_to_provider}    ${refer_to_arg}
    ${refer_to}    Get Selected List Label    ${PO_refer_to_provider}
    Set To Dictionary    ${PatientData}    Refer_To_Provider=${refer_to}    Refer_To_NPI=${refer_to_arg}
    Set Suite Variable    ${PatientData}

Select Visit Frequency
    [Arguments]    ${frequency_arg}
    ${value}    Evaluate    random.randint(1,7)
    Select From List By Value    ${visit_frequency_value_select}    ${value}
    Select From List By Label    ${visit_frequency_select}    ${frequency_arg}\(s)
    Set To Dictionary    ${PatientData}    Visit_Frequency=${value} ${frequency_arg}\(s)
    Set Suite Variable    ${PatientData}

Input Weight And Height
    [Arguments]    ${patient_weight_arg}    ${patient_height_arg}
    Input Text    ${WeightPO_input}    ${patient_weight_arg}
    Click Element    ${Radiobuton_KG}
    Input Text    ${HeightPO_input}    ${patient_height_arg}

Input Dose And Frequency
    [Arguments]    ${dosageAssignedValue_arg}    ${calculated_dosage_arg}     ${dose_frequency_arg}    ${time_frequency_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_route_select}    var_name=PO_route_select    dic=${PatientData}
    Wait Until Keyword Succeeds    5    1    Input Text    ${PO_maint_dose}    ${dosageAssignedValue_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_calculated_dose}    ${calculated_dosage_arg}
    Select From List By Label    ${PO_frequency_value}    ${dose_frequency_arg}
    Select From List By Label    ${PO_frequency_time}    ${time_frequency_arg}
    Set To Dictionary    ${PatientData}    Maint_Dose=${dosageAssignedValue_arg}    Dose_Frequency=${dose_frequency_arg} ${time_frequency_arg}    Calculated_Dose=${calculated_dosage_arg}
    Set Suite Variable    ${PatientData}

Select Place Of Service And Preferred UoM And Container Type
    [Arguments]   ${requested_dose_arg}    ${splitDoseValue_arg}    ${numberOfsplitDosetreatmentsValue_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_place_service}    var_name=PO_place_service    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_requested_dose}    ${requested_dose_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_preferred_UoM}    var_name=PO_preferred_UoM    dic=${PatientData}
    Util.Select Random From List Regression    xpath_arg=${PO_prefered_method}    var_name=PO_prefered_method    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_split_dose}    ${splitDoseValue_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_split_over_treatment}    var_name=PO_split_over_treatment    dic=${PatientData}

Schedule Appointment Without PO
    [Arguments]    ${therapy}
    Open Appointments Tab
    Scroll And Click Element    ${sche_new_apt_btn}
    Selected Therapy In Patient Page    therapy=${therapy}    dict=${PatientData}
    Select Medications And dosages For Therapy With Regression    Dose=20    Office_Visit_Scheduled=${True}    dict=${PatientData}
    Schedule Appointment With 1 Office Visit
    Reload Page

Schedule Appointment Without PO And Office Visit
    [Arguments]    ${therapy}
    Open Appointments Tab
    Scroll And Click Element    ${sche_new_apt_btn}
    Selected Therapy In Patient Page    therapy=${therapy}    dict=${PatientData}
    Select Medications And dosages For Therapy With Regression    Dose=20    Office_Visit_Scheduled=${False}    dict=${PatientData}
    Schedule Appointment Without Office Visit
    Reload Page

Get Data With Created Appointment
    [Arguments]    ${APT_datetime}    ${apt_status}    ${apt_med}
    Open Appointments Tab
    Set Test Variable    ${APT_datetime}
    ${APT_row}    Util.Replace Xpath    ${APT_row}
    Set Test Variable    ${APT_row}
    Scroll Element Into View    ${APT_row}//following::tr[1]
    ${APT_status_txt}    Util.Replace Xpath    ${APT_status_txt}
    ${status_value}    Get Text    ${APT_status_txt}
    ${APT_primary_med_txt}    Util.Replace Xpath    ${APT_primary_med_txt}
    ${med_value}    Get Text    ${APT_primary_med_txt}
    Set To Dictionary    ${PatientData}    ${apt_status}=${status_value}    ${apt_med}=${med_value}
    Set Test Variable    ${PatientData}

Schedule Multiple Appointments With 1 Office Visit
    [Arguments]    ${dict}
    Open Appointments Tab
    Scroll And Click Element    ${sche_new_apt_btn}
    Selected Therapy In Patient Page    therapy=${PatientData.therapy1}    dict=${PatientData}
    Select Medications And dosages For Therapy With Regression    Dose=20    Office_Visit_Scheduled=${True}    dict=${PatientData}
    FOR    ${i}    IN RANGE    1    4
        ${result}    Get Next Date
        ${apt_date}    Get From Dictionary    ${result}    _current_date
        Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    Lenght=10    dict=${PatientData}
        ${visit_date}    Subtract Time From Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
        Schedule OV Appointment    day_arg=${visit_date}        visit_starttime=11:20 am    visit_length=15    dict=${PatientData}
        Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
        Scroll And Click Element    ${add_APT_to_queue_btn}
        Handle DOS Before Suggested Alert
        Set To Dictionary    ${dict}    APT_Date_${i}=${apt_date}    Visit_Date_${i}=${visit_date}
    END
    Click Random Button
    Set Suite Variable    ${dict}
    Sleep    10

Select A Patient
    ${Patient}    Set Variable    ${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${patient_input}    ${Patient}
    ${PatientSelected_click}     Replace Variables    ${PatientSelected_click}
    Wait Until Keyword Succeeds    10s    1s    CLick ELement    ${PatientSelected_click}
Selected Therapy In Patient Page
    [Arguments]    ${therapy}    ${dict}
    Wait Until Element Is Visible    ${Therapy_Selected_Text}    60s
    Wait Until Element Is Enabled    ${Therapy_Select}    timeout=30s
    ${therapy_selected}    Util.Verify Loading And Select By Label    Therapy    ${therapy}
    Set To Dictionary    ${dict}    Therapy_And_Route=${therapy_selected}
    Set Suite Variable    ${dict}
Select Medications And dosages For Therapy With Regression
    [Arguments]    ${Dose}    ${Office_Visit_Scheduled}    ${dict}
    Wait Until Element Is Enabled    ${AddQtyDosage_input}    timeout=120s    error=Can't not find Add Quality Dosage input
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${AddQtyDosage_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text     ${AddQtyDosage_input}    ${Dose}
    Util.Select Random From List Regression    xpath_arg=${Nurse_Select}    var_name=Nurse    dic=${PatientData}
    IF    ${Office_Visit_Scheduled} == ${True}
        Scroll And Click Element    ${Visit_Checkbox}
        Util.Select Random From List Regression    xpath_arg=${Complexity_Select}    var_name=Visit_complexity    dic=${PatientData}
        Util.Select Random From List Regression    xpath_arg=${Provider_Select}    var_name=Visit_Provider    dic=${PatientData}
    END
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${Begin_And_Schedule}

Schedule Appointment With 1 Office Visit
    ${result}    Get Next Date
    ${apt_date}    Get From Dictionary    ${result}    _current_date
    Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    Lenght=10    dict=${PatientData}
    ${visit_date}    Subtract Time From Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Schedule OV Appointment    day_arg=${visit_date}    visit_starttime=11:20 am    visit_length=15    dict=${PatientData}
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${add_APT_to_queue_btn}
    Handle DOS Before Suggested Alert
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${schedule_btn}
    Scheduling Alert

Schedule Appointment Without Office Visit
    ${result}    Get Next Date
    ${apt_date}    Get From Dictionary    ${result}    _current_date
    Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    Lenght=10    dict=${PatientData}
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${add_APT_to_queue_btn}
    Handle DOS Before Suggested Alert
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${schedule_btn}
    Scheduling Alert


Schedule Appointment With Past Date
    Open Appointments Tab
    Scroll And Click Element    ${sche_new_apt_btn}
    Selected Therapy In Patient Page    therapy=${PatientData.therapy_PO}    dict=${PatientData}
    Select Medications And dosages For Therapy With Regression    Dose=20    Office_Visit_Scheduled=${True}    dict=${PatientData}
    ${apt_date}    Get Current Date
    ${apt_date}    Convert Date    ${apt_date}    date_format=%Y-%m-%d %H:%M:%S.%f    result_format=%m/%d/%Y
    ${nor_date}    Subtract Time From Date    ${apt_date}    5 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Schedule Normal Appointment    day_arg=${nor_date}    start_time=10:20 am    Lenght=10    dict=${PatientData}
    ${visit_date}    Subtract Time From Date    ${nor_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Schedule OV Appointment    day_arg=${visit_date}    visit_starttime=11:20 am    visit_length=15    dict=${PatientData}
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${add_APT_to_queue_btn}
    Handle DOS Before Suggested Alert
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Scroll And Click Element    ${schedule_btn}
    Scheduling Alert
    Reload Page

Schedule Normal Appointment
    [Arguments]    ${day_arg}    ${start_time}    ${Lenght}    ${dict}
    Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${APT_Date_Box}    ${day_arg}
    Scroll And Click Element    ${Done_Filter_Date_Btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Start_Time_Input}    ${start_time}
    Press Keys    ${Start_Time_Input}    RETURN
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${APT_Length_Select}    ${Lenght}
    Util.Select Random From List Regression    xpath_arg=${APT_Location_Sched_Select}    var_name=APT_Location_Sched    dic=${dict}
    Set To Dictionary    ${dict}    APT_Date=${day_arg}    nor_starttime=${start_time}
    Set Test Variable    ${dict}

Schedule OV Appointment
    [Arguments]    ${day_arg}    ${visit_starttime}    ${visit_length}    ${dict}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Visit_Date_Box}    ${day_arg}
    Scroll And Click Element    ${Done_Filter_Date_Btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${Visit_Start_Time_Input}    ${visit_starttime}
    Press Keys    ${Visit_Start_Time_Input}    RETURN
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${Visit_Length_Select}    ${visit_length}
    Util.Select Random From List Regression    xpath_arg=${Visit_Location_Sched_Select}    var_name=Visit_Location_Sched    dic=${dict}
    Set To Dictionary    ${dict}    Visit_Date=${day_arg}    visit_starttime=${visit_starttime}
    Set Test Variable    ${dict}
Click Random Button
    Wait Until Element Is Not Visible    ${apt_loading_icon}    30
    ${buttons}    Create List    ${schedule_btn}    ${accept_btn}
    ${random_button}    Evaluate    random.choice(${buttons})
    IF    "${random_button}" == "${schedule_btn}"
        Scroll And Click Element    ${schedule_btn}
    ELSE
        Scroll And Click Element    ${accept_btn}
    END

Input Data In Treatment Note With Created APT
    Create Fake Data List
    ${decimal_2d_2f}    Get Random Data    fake_data=decimal_2d_2f
    ${decimal_3d_2f}    Get Random Data    fake_data=decimal_3d_2f
    ${demical_3d}    Get Random Data    fake_data=demical_3d
    ${integer_decimal_ratio}    Get Random Data    fake_data=integer_decimal_ratio
    Set Test Variable    ${APT_datetime}    ${PatientData.APT_Date}
    Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${Fake_dict.demical_3d}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${Fake_dict.decimal_2d_2f}

Compare Values Of Vital Signs Tab With Procedural Details
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter
    Get Data In Vital Signs tab
    Compare Date Taken
    Should Be Equal    ${TempData.vital_clinician_txt}    By: ${TNoteData.recording_clinician}
    Should Be Equal    ${TempData.vital_blood_pressure_numerator_txt}/${TempData.vital_blood_pressure_denominator_txt}    ${TNoteData.Blood_Pressure_mmHg_Proc_Measure}
    Should Be Equal    ${TempData.vital_heart_rate_txt}    ${TNoteData.Heart_Rate_bpm_Proc_Measure}
    Should Be Equal    ${TempData.vital_resp_rate_txt}    ${TNoteData.Respiratory_Rate_Proc_Measure} per minute
    Compare Temperature
    Compare Height
    Compare Weight
    Compare BMI
    Should Be Equal    ${TempData.vital_BSA_txt}    ${TNoteData.assessment_BSA_value}
    ${spo2_value}    Get From Dictionary    ${TNoteData}    SPO2_%_Proc_Measure
    Should Be Equal    ${TempData.vital_spo2_txt}    ${spo2_value}%
    ${o2_flow_rate}    Get From Dictionary    ${TNoteData}    Oxygen_L/min_Proc_Measure
    Should Be Equal    ${TempData.vital_flow_rate_txt}    ${o2_flow_rate}
    Close Window
    Switch To Another Window    title_arg=Update Patient

Compare Date Taken
    ${date_taken_txt}    Get Regexp Matches    ${TNoteData.date_taken}    \\d{2}/\\d{2}/\\d{2}
    ${date_taken_txt}    Set Variable    ${date_taken_txt}[0]
    ${vital_date_txt}    Convert Date    ${TempData.vital_date_txt}    date_format=%m/%d/%Y    result_format=%m/%d/%y
    Should Be Equal    ${vital_date_txt}    ${date_taken_txt}

Compare BMI
    ${vital_BMI_txt}    Evaluate    str(round(${TempData.vital_BMI_txt}, 1))
    ${assessment_BMI_value}    Evaluate    str(round(${TNoteData.assessment_BMI_value}, 1))
    ${check}    Run Keyword And Return Status    Should Be Equal    ${vital_BMI_txt}    ${assessment_BMI_value}
    IF    '${check}' == '${False}'
        ${vital_BMI_txt}    Evaluate    str(round((${vital_BMI_txt} - 0.1), 1))
        Should Be Equal    ${vital_BMI_txt}    ${assessment_BMI_value}
    END

Compare Temperature
    ${temperature_C}    Evaluate    str(round((${TNoteData.Temp_F_Proc_Measure} - 32) * (5/9), 2))
    ${TNoteData.Temp_F_Proc_Measure}    Evaluate    str(${TNoteData.Temp_F_Proc_Measure}).rstrip('0').rstrip('.')
    ${temperature_C}    Evaluate    str(round((${TNoteData.Temp_F_Proc_Measure} - 32) * (5/9), 2)).rstrip('0').rstrip('.')
    Should Be Equal    ${TempData.vital_temp_C_txt}    ${temperature_C}°C
    Should Be Equal    ${TempData.vital_temp_F_txt}    ${TNoteData.Temp_F_Proc_Measure}°F

Compare Height
    ${height_cm}    Evaluate    str(round(${TNoteData.assessment_height_value} * 2.54, 2))    # 1 inch = 2.54 cm
    ${height_ft}    Replace String    ${TNoteData.assessment_height_ft_value}    ${SPACE}    ${EMPTY}
    ${height_inch}    Replace String    ${TNoteData.assessment_height_inch_value}    ${SPACE}    ${EMPTY}
    Should Be Equal    ${height_ft} ${height_inch}    ${TempData.vital_height_ft_txt}
    Should Be Equal    ${TempData.vital_height_cm_txt}    ${height_cm}cm
    
Compare Weight
    ${weight_lbs}    Evaluate    str(round(${TNoteData.assessment_weight_value} * 2.20462))    # 1 kg=2.20462 lbs
    Should Be Equal    ${TempData.vital_weight_lbs_txt}    ${weight_lbs}lbs
    Should Be Equal    ${TempData.vital_weight_kg_txt}    ${TNoteData.assessment_weight_value}kg

Get Data In Vital Signs tab
    Navigate to Patient by Generated MRN
    Open Vital Signs Tab
    @{vital_sign_xpath}    Create List    
    ...    ${vital_clinician}    ${vital_blood_pressure_numerator}    ${vital_blood_pressure_denominator}    
    ...    ${vital_heart_rate}    ${vital_resp_rate}    ${vital_temp_F}    ${vital_temp_C}    ${vital_height_ft}    ${vital_height_cm}    
    ...    ${vital_weight_lbs}    ${vital_weight_kg}    ${vital_BMI}    ${vital_BSA}    ${vital_spo2}    ${vital_flow_rate}  
    @{vital_keys}    Create List      
    ...    vital_clinician_txt    vital_blood_pressure_numerator_txt    vital_blood_pressure_denominator_txt    vital_heart_rate_txt
    ...    vital_resp_rate_txt    vital_temp_F_txt    vital_temp_C_txt    vital_height_ft_txt    vital_height_cm_txt    vital_weight_lbs_txt
    ...    vital_weight_kg_txt    vital_BMI_txt    vital_BSA_txt    vital_spo2_txt    vital_flow_rate_txt
    ${date_taken}    Get Regexp Matches    ${TNoteData.date_taken}    \\d{2}/\\d{2}
    ${date_taken}    Set Variable    ${date_taken}[0]
    Set Test Variable    ${date_taken}
    ${vital_date}    Util.Replace Xpath    ${vital_date}
    Set Test Variable    ${vital_date}
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${vital_date}    5s
    IF    "${check}"=="${False}"
        Scroll And Click Element    ${last_page}
    END
    ${vital_date_txt}    Get Text    ${vital_date}
    Set To Dictionary    ${TempData}    vital_date_txt=${vital_date_txt}
    Set Test Variable    ${TempData}
    FOR    ${vital_value}    ${vital_key}    IN ZIP    ${vital_sign_xpath}    ${vital_keys}
        ${vital_value}    Util.Replace Xpath    ${vital_value}
        Set Test Variable    ${vital_value}
        ${text_value}    Get Text    ${vital_value}
        Set To Dictionary    ${TempData}    ${vital_key}=${text_value}
        Set Test Variable    ${TempData}
    END

Open Treatment Note With Created APT
    ${APT_treatment_note_btn}    Util.Replace Xpath    ${APT_treatment_note_btn}
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${APT_treatment_note_btn}    5s
    IF    ${check} == ${False}
        Scroll And Click Element    ${last_page}
    END
    Scroll And Click Element    ${APT_treatment_note_btn}
    Check Warning Future Appointment
    Wait Until Page Does Not Contain Element    ${treat_loading}    30s

Get Data In Assessment
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${treat_assessment_btn}
    Wait Until Element Is Visible    ${treat_assessment_title}    30s
    ${assessment_weight_value}    Get Value    ${assessment_weight}
    ${assessment_height_value}    Get Value    ${assessment_height}
    ${assessment_BMI_value}    Get Text    ${assessment_BMI}
    ${assessment_BSA_value}    Get Text    ${assessment_BSA}
    FOR    ${i}    IN RANGE    10
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${assessment_height}
        ${visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${assessment_height_title}    5s
        Exit For Loop If    ${visible} == True
    END
    ${assessment_height_ft_value}    Get Value    ${assessment_height_ft}
    ${assessment_height_inch_value}    Get Value    ${assessment_height_inch}
    Scroll And Click Element    ${assessment_height_accept_btn}
    Wait Until Page Does Not Contain    Patient Height Adjusted!    30s
    Set To Dictionary    ${TNoteData}    
    ...    assessment_weight_value=${assessment_weight_value}    assessment_height_value=${assessment_height_value}    
    ...    assessment_BMI_value=${assessment_BMI_value}    assessment_BSA_value=${assessment_BSA_value}
    ...    assessment_height_ft_value=${assessment_height_ft_value}    assessment_height_inch_value=${assessment_height_inch_value}
    Set Test Variable    ${TNoteData}
    Wait Until Element Is Visible    ${tnote_nav_bar}    30s
    Wait Until Element Is Not Visible    ${tnote_tab_loading}    30s

Get Data In Procedural Details
    ${treat_APT_DOS}    Get Text    ${treat_APT_DOS}
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${recording_clinician_select}    5s
    IF    ${check} == ${True}
        ${recording_clinician}    Get Selected List Label    ${recording_clinician_select}
    ELSE
        ${recording_clinician}    Get Selected List Label    ${recording_clinician_select_update}
    END
    Set To Dictionary    ${TNoteData}    date_taken=${treat_APT_DOS}    recording_clinician=${recording_clinician}
    Set Test Variable    ${TNoteData}
    
Input Data In Procedural Details
    [Arguments]    ${drip_rate}   ${blood_pressure}    ${heart_rate}    ${temperature}    ${respiratory_rate}    ${SPO2}
    Open Appointments Tab
    Open Treatment Note With Created APT
    Wait Until Page Does Not Contain Element    ${treat_loading}    30s
    Get Data In Assessment
    Scroll And Click Element    ${treat_procedural_details_btn}
    Wait Until Element Is Visible    ${procedural_details_title}    30s
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${drip_rate_input}    5s
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${drip_rate_input}    ${drip_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${blood_pressure_input}    ${blood_pressure}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${heart_rate_input}    ${heart_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${temperature_input}    ${temperature}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${respiratory_rate_input}    ${respiratory_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${SPO2_input}    ${SPO2}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${oxygen_select}    2
        # Util.Select Random From List Regression    xpath_arg=${oxygen_select}    var_name=Oxygen_L/min_Proc_Measure    dic=${TNoteData}
        Util.Select Random From List Regression    xpath_arg=${delivery_method_select}    var_name=delivery_method    dic=${TNoteData}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${drip_rate_input_update}    ${drip_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${blood_pressure_input_update}    ${blood_pressure}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${heart_rate_input_update}    ${heart_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${temperature_input_update}    ${temperature}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${respiratory_rate_input_update}    ${respiratory_rate}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${SPO2_input_update}    ${SPO2}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${oxygen_select_update}    2
        # Util.Select Random From List Regression    xpath_arg=${oxygen_select_update}    var_name=Oxygen_L/min_Proc_Measure    dic=${TNoteData}
        Util.Select Random From List Regression    xpath_arg=${delivery_method_select_update}    var_name=delivery_method    dic=${TNoteData}
    END
    Get Data In Procedural Details
    Set To Dictionary    ${TNoteData}    
    ...    Blood_Pressure_mmHg_Proc_Measure=${blood_pressure}    Heart_Rate_bpm_Proc_Measure=${heart_rate}    Temp_F_Proc_Measure=${temperature}    
    ...    Respiratory_Rate_Proc_Measure=${respiratory_rate}    SPO2_%_Proc_Measure=${SPO2}    Oxygen_L/min_Proc_Measure=2
    Set Test Variable    ${TNoteData}
    Appointment.Close Modal
    Reload Page

Check Warning Future Appointment
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //h4[contains(text(),'Warning - Opening Future Appointment')]    2s
    IF    ${check} == ${True}
        Scroll And Click Element    //button[contains(text(),'Yes / Continue')]
    END
    ${check_early}    Run Keyword And Return Status    Wait Until Element Is Visible    //p[contains(text(),'- Early Scheduled Appointment')]    2s
    IF    ${check_early} == ${True}
        Wait Until Keyword Succeeds    5s    1s    Input Text    //textarea[@id="EarlyConfirm"]    Testing
        Scroll And Click Element    //button[@id="AcceptBtnModal"]
    END

Delete Procedural Details Line
    Open Appointments Tab
    Open Treatment Note With Created APT
    Wait Until Page Does Not Contain Element    ${treat_loading}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${treat_procedural_details_btn}
    Wait Until Element Is Visible    ${procedural_details_title}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${action_del_btn}
    Wait Until Page Contains    Do you want to delete this vital line?    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${vital_del_btn}
    Page Alert Message    The line has been deleted successfully.
    Appointment.Close Modal
    Reload Page

Verify Vital Signs Line Removed
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter
    Navigate to Patient by Generated MRN
    Open Vital Signs Tab
    Wait Until Element Is Not Visible    ${vital_date}
    Close Window
    Switch To Another Window    title_arg=Update Patient

The Corresponding Column Is Not Entered In Vital Signs
    [Arguments]    ${vital_value_column}    ${compare_value}
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter
    Navigate to Patient by Generated MRN
    Open Vital Signs Tab
    ${date_taken}    Get Regexp Matches    ${TNoteData.date_taken}    \\d{2}/\\d{2}
    ${date_taken}    Set Variable    ${date_taken}[0]
    Set Test Variable    ${date_taken}
    ${vital_date}    Util.Replace Xpath    ${vital_date}
    Set Test Variable    ${vital_date}
    ${vital_value_column}    Util.Replace Xpath    ${vital_value_column}
    ${vital_value_column_txt}    Get Text    ${vital_value_column}
    Should Be Equal    ${vital_value_column_txt}    ${compare_value}
    Close Window
    Switch To Another Window    title_arg=Update Patient

The O2 Flow Rate Column Has 0 Value In Vital Signs
    Open Appointments Tab
    Open Treatment Note With Created APT
    Scroll And Click Element    ${treat_procedural_details_btn}
    Wait Until Element Is Visible    ${procedural_details_title}    30s
    Create Fake Data List
    ${decimal_3d_2f}    Get Random Data    fake_data=decimal_3d_2f
    Get Data In Procedural Details
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${drip_rate_input}    ${Fake_dict.decimal_3d_2f}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${oxygen_select}    2
    # Select From List By Index    ${oxygen_select}    0
    Appointment.Close Modal
    Reload Page
    The Corresponding Column Is Not Entered In Vital Signs    vital_value_column=${vital_flow_rate}    compare_value=2

Input Data In Procedural Details For All Created Normal Appointments
    Reload Page
    FOR    ${i}    IN RANGE    1    4
        ${apt_date}    Convert Date    ${PatientData.APT_Date_${i}}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        Set Test Variable    ${APT_datetime}    ${apt_date}
        Create Fake Data List
        ${decimal_3d_2f}    Get Random Data    fake_data=decimal_3d_2f
        ${demical_3d}    Get Random Data    fake_data=demical_3d
        ${integer_decimal_ratio}    Get Random Data    fake_data=integer_decimal_ratio
        Input Data In Procedural Details    drip_rate=${Fake_dict.decimal_3d_2f}    blood_pressure=${Fake_dict.integer_decimal_ratio}    heart_rate=${Fake_dict.demical_3d}    temperature=${Fake_dict.decimal_3d_2f}    respiratory_rate=${Fake_dict.demical_3d}     SPO2=${Fake_dict.decimal_2d_2f}
    END

Verify The Vital Signs Lines Are Ordered By Decreasing DOS
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter
    Navigate to Patient by Generated MRN
    Open Vital Signs Tab
    ${date_list}    Create List
    FOR    ${i}    IN RANGE    1    4
        ${date}    Get Text    //th[contains(text(),'Date Taken')]//following::tr[${i}]//td[1]//div[1]
        ${date}    Convert Date    ${date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        Append To List    ${date_list}    ${date}
    END
    ${sorted_list}    Copy List    ${date_list}
    Sort List    ${sorted_list}
    Reverse List    ${sorted_list}
    Should Be Equal    ${date_list}    ${sorted_list}
    Close Window
    Switch To Another Window    title_arg=Update Patient

Open Co-pay Assisstance Modal
    Scroll And Click Element    ${copay_add_btn}
    Wait Until Element Is Visible    ${copay_med_label}    30s
    Create Fake Data List
    ${med}    Get Option In Medication Select
    Set Test Variable    ${med}

Verify All Fields Are Empty
    ${inputs}=    Create List
    ...    ${copay_phone_enrollment_input}    ${copay_fax_enrollment_input}    ${copay_CAP_website_input}    ${copay_phone_claim_input}
    ...    ${copay_fax_claim_input}    ${copay_CAP_ID_input}    ${copay_CAP_group_input}    ${copay_CAP_amount_input}
    ...    ${copay_CAP_responsibility_input}    ${copay_CAP_startdate_input}    ${copay_CAP_enddate_input}    ${copay_CAP_credit_input}
    ...    ${copay_CVV_input}    ${copay_billing_zip_input}    ${copay_expdate_input}    ${copay_CAP_balance_input}
    ${selects}=    Create List
    ...    ${copay_program_select}    ${copay_CAP_specialist_select}    ${copay_CAP_status_select}
    FOR    ${input}    IN    @{inputs}
        ${value}    SeleniumLibrary.Get Element Attribute    ${input}    value
        Should Be Equal    ${value}    ${EMPTY}
    END
    FOR    ${select}    IN    @{selects}
        ${first_option}    Get Selected List Label    ${select}
        ${all_options}    Get List Items    ${select}
        Should Be Equal    ${first_option}    ${all_options}[0]
    END
    
Verify All Fields After Click On Add Co-Pay Assistance Button
    Scroll And Click Element    ${copay_add_btn}
    Wait Until Element Is Visible    ${copay_med_btn}    30s
    ${copay_medication_txt}    Get Text    ${copay_med_btn}
    Should Be Equal    ${copay_medication_txt}    -- Select A Medication --
    Verify All Fields Are Empty

Input All Fields In Co-Pay Assistance Modal
    [Arguments]    ${medication}    ${cap_id}   ${cap_group}    ${cap_amount}    ${cap_respon}    ${cap_credit}    ${cvv}    ${billing}    ${expdate}    ${btn_arg}
    IF    "${medication}" != "missing"
        ${med_selected_value}    SeleniumLibrary.Get Element Attribute    ${medication}    value
        Select From List By Value    ${copay_med_select}    ${med_selected_value}
        Set Test Variable    ${med_selected_value}
    END
    Util.Select Random From List Regression    xpath_arg=${copay_CAP_specialist_select}    var_name=copay_CAP_specialist_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${copay_CAP_status_select}    var_name=copay_CAP_status_select    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_ID_input}    ${cap_id}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_group_input}    ${cap_group}
    Press Keys       ${copay_CAP_amount_input}     CTRL+A+BACKSPACE
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_amount_input}    ${cap_amount}
    Press Keys       ${copay_CAP_responsibility_input}     CTRL+A+BACKSPACE
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_responsibility_input}    ${cap_respon}
    Input Start Date And End Date
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_credit_input}    ${cap_credit}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CVV_input}    ${cvv}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_billing_zip_input}    ${billing}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_expdate_input}    ${expdate}
    IF    "${btn_arg}" == "${add_copay_assistance_btn}"
        Scroll And Click Element    ${add_copay_assistance_btn}
    ELSE IF    "${btn_arg}" == "${copay_update_btn}"
        Scroll And Click Element    ${copay_update_btn}
    END
    Set To Dictionary    ${TempData}
    ...    copay_CAP_ID=${cap_id}
    ...    copay_CAP_group=${cap_group}
    ...    copay_CAP_amount=${cap_amount}
    ...    copay_CAP_responsibility=${cap_respon}
    ...    copay_CAP_credit=${cap_credit}
    ...    copay_CVV=${cvv}
    ...    copay_billing_zip=${billing}
    ...    copay_expdate=${expdate}

Input Start Date And End Date
    ${startdate}    Get Current Date    result_format=%m/%d/%Y
    ${enddate}    Add Time To Date    ${startdate}    365 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_startdate_input}    ${startdate}
    Scroll And Click Element    ${copay_done_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${copay_CAP_enddate_input}    ${enddate}
    Scroll And Click Element    ${copay_done_btn}
    Set To Dictionary    ${TempData}    copay_CAP_startdate=${startdate}    copay_CAP_enddate=${enddate}
    Set Test Variable    ${TempData}

Get Option In Medication Select
    ${index}=    Get Variable Value    ${index}    1
    ${med_xpath}=    Set Variable    (//select[@id='SelectedMedication']//following::option)[${index}]
    ${med_txt}    Wait Until Keyword Succeeds    10s    1s    Get Text    ${med_xpath}
    ${new_index}=    Evaluate    int(${index}) + 1
    Set Test Variable    ${med_txt}
    Set Suite Variable    ${index}    ${new_index}
    IF    '${med_txt}' == '${PatientData.drug_PO}' or '${med_txt}' == '${PatientData.drug_PO1}'
        ${med_xpath}    Get Option In Medication Select
    END
    RETURN    ${med_xpath}

Create New Co-Pay Assistance Program
    [Arguments]    ${name_arg}    ${phone_arg}    ${fax_arg}    ${cap_arg}    ${phone_claim_arg}    ${fax_claim_arg}    ${btn_arg}    ${alert_arg}
    FOR    ${i}    IN RANGE    10
        Sleep    1s
        Select From List By Label    ${copay_program_select}    -- Create New Co-Pay Assistance Program --
        ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${program_modal_tilte}    30s
        IF    "${check}" == "${True}"
            Exit For Loop
        ELSE
            Select From List By Label    ${copay_program_select}    -- Select A Program --
        END
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_name}    ${name_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_phone}    ${phone_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_enrollment}    ${fax_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_CAP}    ${cap_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_phone_claims}    ${phone_claim_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${program_fax_claims}    ${fax_claim_arg}
    IF    "${btn_arg}" == "${add_program_btn}"
        Sleep    1s
        Scroll And Click Element    ${add_program_btn}
        IF    "${alert_arg}" != ${None}
            Page Alert Message    ${alert_arg}
        END
        ${program_name_arg}    Set Variable    ${name_arg}
        ${copay_program_option}    Replace Variables    ${copay_program_option}
        ${option_value}    SeleniumLibrary.Get Element Attribute    ${copay_program_option}    value
        Select From List By Value    ${copay_program_select}    ${option_value}
    ELSE IF    "${btn_arg}" == "${close_program_btn}"
        Scroll And Click Element    ${close_program_btn}
    END
    Set To Dictionary    ${TempData}    program_name=${name_arg}    program_phone=${phone_arg}    program_fax_enrollment=${fax_arg}    program_CAP=${cap_arg}    program_phone_claims=${phone_claim_arg}    program_fax_claims=${fax_claim_arg}
    Set Test Variable    ${TempData}

Delete Co-Pay Assistance Program
    Reload Page
    Open Co-Pay Assistance Tab
    Scroll And Click Element    ${copay_add_btn}
    Wait Until Element Is Visible    ${copay_med_label}    30s
    ${list}    Get List Items    ${copay_program_select}
    FOR    ${i}    IN    @{list} 
        IF    '${i}' not in ['-- Select A Program --', '-- Create New Co-Pay Assistance Program --']
            Select From List By Label    ${copay_program_select}    ${i}
            Scroll And Click Element    ${copay_program_edit_btn}
            Scroll And Click Element    ${copay_program_delete_btn}
            Handle Alert    ACCEPT
            Page Alert Message    Co-Pay Assistance Program removed
        END
    END

Verify Fields Of Program Are Retrieved
    ${inputs}=    Create List
    ...    ${copay_phone_enrollment_input}    ${copay_fax_enrollment_input}    ${copay_CAP_website_input}    ${copay_phone_claim_input}    ${copay_fax_claim_input}
    ${values}=    Create List
    ...    ${TempData.program_phone}    ${TempData.program_fax_enrollment}    ${TempData.program_CAP}    ${TempData.program_phone_claims}    ${TempData.program_fax_claims}

    FOR    ${input}    ${value}    IN ZIP    ${inputs}    ${values}
        ${input_txt}=    SeleniumLibrary.Get Element Attribute    ${input}    value
        Should Be Equal    ${input_txt}    ${value}
    END

Verify CAP Status Select Have Available Value
    ${expect_options}    Create List    Unknown    Pending    Approved    Expired    Denied
    Scroll And Click Element    ${copay_CAP_status_select}
    ${options}=    Get List Items    ${copay_CAP_status_select}
    Lists Should Be Equal    ${options}    ${expect_options}

Input Long Characters Into Input SuccessFully
    [Arguments]    ${input_arg}    ${length}
    ${part1}=    Evaluate    random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")    modules=random
    ${part2}=    Evaluate    random.choice("0123456789")    modules=random
    ${remaining}=    Evaluate    ''.join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=${length}-2))    modules=random
    ${lenght_txt}=    Set Variable    ${part1}${part2}${remaining}
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    ${value}=    Get Value    ${input_arg}
    Should Be Equal    ${value}    ${lenght_txt}
    Clear Element Text    ${input_arg}

Input Long Characters
    [Arguments]    ${input_arg}    ${length}
    ${part1}=    Evaluate    random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ")    modules=random
    ${part2}=    Evaluate    random.choice("0123456789")    modules=random
    ${remaining}=    Evaluate    ''.join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=${length}-2))    modules=random
    ${lenght_txt}=    Set Variable    ${part1}${part2}${remaining}
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    Set Test Variable    ${lenght_txt}

Input Long Characters Into Input UnsuccessFully
    [Arguments]    ${input_arg}    ${length}
    ${part1}=    Evaluate    random.choice("ABCDEFGHIJKLMNOPQRSTUVWXY")    modules=random
    ${part2}=    Evaluate    random.choice("0123456789")    modules=random
    ${remaining}=    Evaluate    ''.join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=${length}-2))    modules=random
    ${lenght_txt}=    Set Variable    ${part1}${part2}${remaining}
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    ${value}=    Get Value    ${input_arg}
    Should Not Be Equal    ${value}    ${lenght_txt}
    Clear Element Text    ${input_arg}

Verify Input Maximum 2 Decimal And Numeric Into Field
    [Arguments]    ${input_arg}    ${length}
    ${lenght_txt}=    Evaluate    '{:.4f}'.format(random.uniform(10**(${length}-1), 10**${length}-1))    modules=random
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    Scroll And Click Element    //label[contains(text(),'Patient Copay $ Responsibility')]
    ${value}=    Get Value    ${input_arg}
    ${rounded_lenght_txt}=    Evaluate    round(float(${lenght_txt}), 2)
    ${formatted_number}=    Evaluate    '{:,.2f}'.format(${rounded_lenght_txt})
    Should Be Equal    ${value}    $${formatted_number}
    Clear Element Text    ${input_arg}

Verify Field Is Remain Blank When Previous Data Is Blank
    Scroll And Click Element    ${copay_CAP_amount_input}
    Scroll And Click Element    //label[contains(text(),'Patient Copay $ Responsibility')]
    ${value}=    Get Value    ${copay_CAP_amount_input}
    Should Be Equal    "${value}"    "${EMPTY}"

Verify Field Is NOT Remain Blank When Previous Data Is NOT Blank
    Clear Element Text    ${copay_CAP_amount_input}
    Scroll And Click Element    ${copay_CAP_amount_input}
    Scroll And Click Element    //label[contains(text(),'CAP Approved $ Amount ')]
    ${value}=    Get Value    ${copay_CAP_amount_input}
    Should Be Equal    ${value}    $0.00

Verify Field Only Contains Numbers
    [Arguments]    ${input_arg}    ${length}
    ${lenght_txt}=    Evaluate    ''.join(random.choices("0123456789", k=${length}))    modules=random
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    ${value}=    Get Value    ${input_arg}
    ${value}=    Strip String    ${value} 
    Should Match Regexp    ${value}    (?=.*\\d).*
    Clear Element Text    ${input_arg}

Input Long Numbers
    [Arguments]    ${input_arg}    ${length}
    ${lenght_txt}=    Evaluate    ''.join(random.choices("0123456789", k=${length}))    modules=random
    Wait Until Keyword Succeeds    30    1    Input Text    ${input_arg}    ${lenght_txt}
    Set Test Variable    ${lenght_txt}

Check Document Information
    ${copay_document_patient}    Get Text    ${copay_document_patient}
    ${copay_document_dob}    Get Text    ${copay_document_dob}
    ${copay_document_mrn}    Get Text    ${copay_document_mrn}
    Should Be Equal    ${copay_document_patient}    Patient: ${PatientData.Last_Name}, ${PatientData.First_Name} ${PatientData.Middle_Name}
    Should Be Equal    ${copay_document_dob}    DOB: ${PatientData.DOB}
    Should Be Equal    ${copay_document_mrn}    MRN: ${PatientData.MRN}

Update Related Note In Copay Modal
    ${med_selected_value}    Get Selected List Value    //select[@id="_CoPayMedicationLoader"]
    Set Test Variable    ${med_selected_value}
    ${copay_related_note_text}    Get Text    ${copay_related_note_line}
    Should Be Equal    ${copay_related_note_text}    No Co-Pay Assistance Notes Available
    Wait Until Keyword Succeeds    30    1    Input Text    ${copay_related_note_input}    ${Fake_dict.sentence_str}
    Scroll And Click Element    ${copay_add_note_btn}
    Handle Alert    ACCEPT
    Page Alert Message    Co-Pay Assistance Note Successfully Added!
    ${copay_related_note_line}    Get Text    ${copay_related_note_line}
    ${date_zone}    Get Time Now    result_format=%#m/%#d/%Y
    Should Contain    ${copay_related_note_line}    ${date_zone}
    Should Contain    ${copay_related_note_line}    ${user_name_txt}
    Should Contain    ${copay_related_note_line}    ${Fake_dict.sentence_str}
Verify Co-Pay Assistance Row With Valid Info
    ${copay_med_row}    Util.Replace Xpath    ${copay_med_row}
    Set Test Variable    ${copay_med_row}
    ${element_list}    Create List    
    ...    ${copay_med_program}
    ...    ${copay_med_phone_enrollment}
    ...    ${copay_med_fax_enrollment}
    ...    ${copay_med_cap_website}
    ...    ${copay_med_phone_claim}
    ...    ${copay_med_fax_claim}
    ...    ${copay_med_cap_specialist}
    ...    ${copay_med_cap_status}
    ...    ${copay_med_cap_id}
    ...    ${copay_med_group_num}
    ...    ${copay_med_approval_startdate}
    ...    ${copay_med_approval_enddate}
    ...    ${copay_med_cap_amount}
    ...    ${copay_med_cap_response}
    ...    ${copay_med_cap_balance}
    ${var_list}    Create List
    ...    ${TempData.program_name}
    ...    ${TempData.program_phone}
    ...    ${TempData.program_fax_enrollment}
    ...    ${TempData.program_CAP}
    ...    ${TempData.program_phone_claims}
    ...    ${TempData.program_fax_claims}
    ...    ${TempData.copay_CAP_specialist_select}
    ...    ${TempData.copay_CAP_status_select}
    ...    ${TempData.copay_CAP_ID}
    ...    ${TempData.copay_CAP_group}
    ...    ${TempData.copay_CAP_startdate}
    ...    ${TempData.copay_CAP_enddate}
    ...    ${TempData.copay_CAP_amount}
    ...    ${TempData.copay_CAP_responsibility}
    ...    ${TempData.copay_CAP_amount}
    
    FOR    ${element}    ${var}    IN ZIP    ${element_list}    ${var_list}
        ${element}    Util.Replace Xpath    ${element}
        ${element}    Get Text    ${element}
        Should Contain    ${element}    ${var}
    END

Update UnsuccessFully With Empty Required Fields
    ${element_list}    Create List    
    ...    ${copay_CAP_ID_input}
    ...    ${copay_CAP_group_input}
    ...    ${copay_CAP_startdate_input}
    ...    ${copay_CAP_enddate_input}
    ${error_list}    Create List
    ...    CAP Identification Number cannot be empty.
    ...    CAP Group Number cannot be empty.
    ...    Approval Start Date cannot be empty.
    ...    Approval End Date cannot be empty.
    FOR    ${element}    ${error}    IN ZIP    ${element_list}    ${error_list}
        ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
        Scroll And Click Element    ${copay_edit_btn}
        Wait Until Element Is Visible    ${copay_med_label}    30s
        Press Keys    ${element}    CTRL+A+BACKSPACE
        IF    "${element}" == "${copay_CAP_startdate_input}" and "${element}" == "${copay_CAP_enddate_input}"
            Scroll And Click Element    ${copay_done_btn}
        END
        Scroll And Click Element   ${copay_update_btn}
        Page Alert Message    ${error}
        Scroll And Click Element   ${close_copay_assistance_btn}
    END

Check Co-pay Assisstance Is Visible
    ${med_selected_value}    Set Variable    ${PatientData.drug_PO}
    Set Test Variable    ${med_selected_value}
    ${copay_med_row}    Util.Replace Xpath    ${copay_med_row}
    ${copay_check}    Run Keyword And Return Status    Scroll Element Into View    ${copay_med_row}
    IF    ${copay_check} == ${False}
        Scroll And Click Element    ${copay_add_btn}
        Wait Until Element Is Visible    ${copay_med_label}    30s
        Create Fake Data List
        ${med_select}    Select From List By Value    ${copay_med_select}    ${PatientData.drug_PO}
        Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${add_program_btn}    alert_arg=Co-Pay Assistance Program added
        Input All Fields In Co-Pay Assistance Modal    medication=missing    cap_id=${Fake_dict.num_rand}   cap_group=${Fake_dict.num_rand}    cap_amount=${Fake_dict.demical_3d}    cap_respon=${Fake_dict.demical_3d}    cap_credit=${Fake_dict.credit_num}    cvv=${Fake_dict.demical_3d}    billing=${Fake_dict.num_rand}    expdate=${Fake_dict.exp_date}    btn_arg=${add_copay_assistance_btn}
        Page Alert Message    Co-Pay Assistance Added
    END

Check Info In Paymetn History Table Form
    [Arguments]    ${med_arg}
    ${med_selected_value}    Set Variable    ${med_arg}
    Set Test Variable    ${med_selected_value}
    ${copay_edit_btn}    Util.Replace Xpath    ${copay_edit_btn}
    Scroll And Click Element    ${copay_edit_btn}
    Scroll And Click Element    ${copay_payment_history}
    ${payment_table_check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${copay_payment_history}//following::tbody//tr//h3
    IF    ${payment_table_check} == ${True}
        ${no_payment}    Get Text    ${copay_payment_history}//following::tbody//tr//h3
        Should Be Equal    ${no_payment}    No Payment History found
        Scroll Element Into View    ${close_copay_assistance_btn}
        Scroll And Click Element   ${close_copay_assistance_btn}
    ELSE
        Verify Historical Data Against Created Appointments    apt_datetime=${PatientData.APT_Date}    apt_starttime=${PatientData.nor_starttime}    apt_status=${PatientData.nor_status}      apt_med=${PatientData.nor_med}  
    END

Verify Historical Data Against Created Appointments
    [Arguments]    ${apt_datetime}    ${apt_starttime}    ${apt_status}    ${apt_med}
    ${copay_history_appttime}    Util.Replace Xpath    ${copay_history_appttime}
    ${copay_history_apptstatus}    Util.Replace Xpath    ${copay_history_apptstatus}
    ${copay_history_appttreatment}    Util.Replace Xpath    ${copay_history_appttreatment}
    ${copay_history_apptcharge}    Util.Replace Xpath    ${copay_history_apptcharge}
    ${copay_history_savecharge}    Util.Replace Xpath    ${copay_history_savecharge}
    ${copay_history_appttime}    Get Text    ${copay_history_appttime}
    Should Be Equal    ${copay_history_appttime.lower()}    ${apt_starttime.lower()}
    ${copay_history_apptstatus}    Get Text    ${copay_history_apptstatus}
    Should Be Equal    ${copay_history_apptstatus}    ${apt_status}
    ${copay_history_appttreatment}    Get Text    ${copay_history_appttreatment}
    Should Be Equal    ${copay_history_appttreatment}    ${apt_med}
    Create Fake Data List
    ${decimal_2d_2f}    Get Random Data    fake_data=decimal_2d_2f
    Wait Until Keyword Succeeds    30    1    Input Text    ${copay_history_apptcharge}    ${decimal_2d_2f}
    Scroll And Click Element    ${copay_history_savecharge}
    Page Alert Message    Co-Pay Amount Added!
    Scroll And Click Element   ${copay_update_btn}
    Page Alert Message    Co-Pay Assistance Updated

Leave Required Fields In Co-pay Assistance Program
    ${error_list}    Create List
    ...    Name cannot be empty.
    ...    Phone (Enrollment) cannot be empty.
    ...    CAP Website / Form cannot be empty.
    ...    Phone (Claims) cannot be empty.
    ${xpath_list}    Create List
    ...    ${program_name}
    ...    ${program_phone}
    ...    ${program_CAP}
    ...    ${program_phone_claims}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        Create New Co-Pay Assistance Program    name_arg=${Fake_dict.full_name_fake}    phone_arg=${Fake_dict.phone_fake}    fax_arg=${Fake_dict.phone_fake}    cap_arg=${Fake_dict.sentence_str}    phone_claim_arg=${Fake_dict.phone_fake}    fax_claim_arg=${Fake_dict.phone_fake}    btn_arg=${None}    alert_arg=${None}
        Wait Until Keyword Succeeds    30    1    Clear Element Text    ${xpath}
        Scroll And Click Element    ${add_program_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${close_program_btn}
    END

Update Co-Pay Assistance Program Unsuccessfully If Empty Required Fields
    ${xpath_list}    Create List    ${program_name}    ${program_phone}    ${program_CAP}    ${program_phone_claims}
    ${error_list}    Create List    
    ...    Name cannot be empty.
    ...    Phone (Enrollment) cannot be empty.
    ...    CAP Website / Form cannot be empty.
    ...    Phone (Claims) cannot be empty.
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        Scroll And Click Element    ${copay_program_edit_btn}
        Wait Until Keyword Succeeds    30    1    Clear Element Text    ${xpath}
        Scroll And Click Element    ${copay_program_update_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${close_program_btn}
    END

Add Co-pay Assistance With PA's Medication
    [Arguments]    ${med_arg}
    ${med_selected_value}    Set Variable    ${med_arg}
    Set Test Variable    ${med_selected_value}
    ${copay_PA_add_copay}    Util.Replace Xpath    ${copay_PA_add_copay}
    Scroll And Click Element    ${copay_PA_add_copay}
    Wait Until Element Is Visible    ${copay_med_label}    30s
    
Check Co-pay Info In PA Tab
    Open Prior Authorizations Tab
    ${med_txt}    Set Variable    ${PatientData.drug_PO1}
    Set Test Variable    ${med_txt}
    ${PA_med_column}    Util.Replace Xpath    ${PA_med_column}
    Wait Until Element Is Visible    ${PA_med_column}    30s
    ${PA_med_column}    Get Text    ${PA_med_column}
    ${copay_value}    Fetch From Right    ${PA_med_column}    \Co-Pay: \
    Should Be Equal    ${copay_value}    ${TempData.program_name} (${TempData.copay_CAP_status_select})

Create PO Modal Succeeds
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_exist_alert}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END

Create PO Modal Succeeds With Xolair drug
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${create_PO_btn}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${PatientData.drug1_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_modal_create_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_exist_alert}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END

Create New PO With ICD Assigned To Patient
    [Arguments]    ${med_arg}    ${PO_dosage_arg}
    Open Provider Orders tab
    Scroll And Click Element    ${create_PO_btn}
    Wait Until Page Contains    Ordering Location    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${med_arg}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    4
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Scroll And Click Element    ${PO_modal_create_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_exist_alert}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician}
    Get PO Number
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
    Scroll And Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dose_convert}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_place_service}    var_name=PO_place_service    dic=${TempData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_num_dose}    ${PO_dosage_arg}
    Verify Preferred UoM Dropdown In Create Mode
    Verify Preferred Method Label In Create Mode
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_split_dose}    ${PO_dosage_arg}
    Util.Select Random From List Regression    xpath_arg=${PO_split_treatment}    var_name=PO_split_treatment    dic=${TempData}
    Scroll And Click Element    ${PO_modal_create_btn}
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    2s
    IF    ${check_advised} == ${True}
        Scroll And Click Element Modal    ${PO_accept_btn}
    END
    Page Alert Message    Provider Order Successfully Created!
    Scroll And Click Element    ${PO_modal_close_btn}
    Wait Until Element Is Not Visible    //*[@id='frm_CreateEditPatientOrderModal']    30s

ICD Add To Patient
    [Arguments]    ${icd10_list}
    FOR    ${icd10_arg}    IN    @{icd10_list}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${search_ICD}    ${icd10_arg}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${find_ICD}
        Wait Until Element Is Visible    ${ICD_list}
        Sleep    2s
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${ICD_checkbox}
        Page Alert Message    ICD Code Added to Patient.
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${ICD_clear}
    END
Removed ICD Code
    Go To Patients Page
    Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Click Button    //*[@id="ClearButton"]
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientData.MRN}
    Sleep    3s
    Click Button    ${Find_Patient_Btn}
    Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[contains(text(),'${PatientData.MRN}')]/preceding::td[2]//a
    Open Diagnosis tab
    Wait Until Element Is Visible    ${ICD_list}
    FOR    ${i}    IN RANGE    2
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${ICD_checkbox}
        Page Alert Message    ICD Code Removed from Patient.
    END

Verify PO Default Dates
    ${start_date}=    Get Value    ${PO_start_date_input}
    ${exp_date}=      Get Value    ${PO_exp_date_input}
    ${today}=         Check Time Zone PO Tab
    ${one_year_later}    Add Time To Date    ${today}    364 days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    Set To Dictionary    ${PO_data}    Start_Date=${start_date}    Exp_Date=${exp_date}    Today=${today}    One_Year_Later=${one_year_later}
    Set Suite Variable    ${PO_data}
    
    Should Be Equal As Strings    ${start_date}    ${today}    Start date should default to today
    Should Be Equal As Strings    ${exp_date}    ${one_year_later}    Expiration date should be 1 year from today

Check Time Zone PO Tab
    ${today_location}    CustomLibrary.Get Time Now
    ${today_location}    Convert Date    ${today_location}    result_format=%#m/%#d/%Y
    RETURN    ${today_location}

Edit PO
    Wait Until Element Is Not Visible    //*[@id='frm_CreateEditPatientOrderModal']    30s
    Wait Until Element Is Visible    ${PO_patientlist}    timeout=10s
    Select PO Row    PO_arg=${PO_number}
    Get DateTime In Provider Order
    Input Date Time Provider Order Modal    ${start_date}    ${exp_date}
    Util.Select Random From List Regression    xpath_arg=${PO_visit_frequency_select}    var_name=PO_visit_frequency_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${PO_uom_select}    var_name=PO_uom_select    dic=${TempData}
    Click Element    ${PO_save_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END
    ${reason_required}    Run Keyword And Return Status    Wait Until Page Contains Element    xpath=//*[@id="RequiredChangeReason"]     timeout=2s
    Run Keyword If    '${reason_required}'=='True'    Wait Until Keyword Succeeds    30s    1s    Input Text   xpath=//*[@id="RequiredChangeReason"]    Testing
    Run Keyword If    '${reason_required}'=='True'    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id="UltraSubModalPopup"]//button[normalize-space(text())="Enter"]
    ${accept_visible}    Run Keyword And Return Status    Wait Until Page Contains Element    xpath=//*[@id="SaveBtn" and normalize-space(text())="Accept"]    timeout=1s

Check Field Is Disable
    Wait Until Element Is Not Visible    //*[@id='frm_CreateEditPatientOrderModal']    30s
    Wait Until Element Is Visible    ${PO_patientlist}    timeout=10s
    Select PO Row    PO_arg=${PO_number}
    Wait Until Element Is Visible    ${physician_input}    timeout=10s
    ${ReferralPhysician_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${physician_disabled}
    Should Be True    ${ReferralPhysician_disabled}
    ${Referto_aria_disabled}=    SeleniumLibrary.Get Element Attribute    ${referto_disabled}    aria-disabled
    ${is_disabled}=      Evaluate    "${Referto_aria_disabled}" == "true"
    Should Be True    ${is_disabled}
    ${ReferralSource_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${PO_referral_source}
    Should Be True    ${ReferralSource_disabled}
    ${WeightPO_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${weight_PO_input}
    Should Be True    ${WeightPO_disabled}
    ${DosageAssigned_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${PO_dosage_assign}
    Should Be True    ${DosageAssigned_disabled}
    ${PlaceOfService_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${PO_place_service}
    Should Be True    ${PlaceOfService_disabled}
Edit Text area
    Wait Until Element Is Visible    ${dose_type_po}
    Wait Until Element Is Enabled    ${progress_note}    15s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${progress_note}    Test PO_13
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_save_btn}
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    1s
    IF    ${check_advised} == ${True}
        Scroll And Click Element Modal    ${PO_accept_btn}
    END
    Page Alert Message    Provider Order Successfully Updated!
    Scroll And Click Element    ${PO_modal_close_btn}
    Select PO Row    PO_arg=${PO_number}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${progress_note}
    ${Edit_order}=    Get Value    ${progress_note}
    Set Test Variable    ${Edit_order}
    Click Element    ${PO_modal_close_btn}
Input Date Time Provider Order Modal
    [Arguments]    ${start_date_arg}    ${exp_date_arg}
    Input Date Field    ${PO_start_date_input}    ${start_date_arg}
    Input Date Field    ${PO_exp_date_input}    ${exp_date_arg}

Input Date Field
    [Arguments]    ${locator}    ${value}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${locator}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${locator}    ${value}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${datepicker_done_btn}

Get DateTime In Provider Order
    ${result}    Get Current Date    result_format=%#m/%#d/%Y
    ${start_date}=     Add Time To Date    ${result}    2 days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${exp_date}=    Add Time To Date    ${start_date}    364 days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    Set Test Variable    ${start_date}
    Set Test Variable    ${exp_date}

Open Provider Order Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${DispensingLink}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_link}
    Title Should Be    Provider Orders

Open PO At Provider Order Page
    Open Provider Order Page
    Wait Until Element Is Enabled    ${select_location_PO}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${select_location_PO}    ${PatientData.Location}
    Click Button    ${clearpatient_btn}
    Input Patient And Select Autocomplete    ${PO_filter_patient_input}    ${PatientData.MRN}    ${patient_autocomplete}
    Clear StartDate And EndDate Field    ${startdate_field}    ${enddate_field}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${datepicker_done_btn}
    Run Keyword If    ${is_visible}    Click Element    ${datepicker_done_btn}
    Check Loading Data
    Wait Until Keyword Succeeds    30s    1s   Click Element    ${PO_search_btn}

Get Value At Provider Order Page
    Select PO Row    PO_arg=${PO_number}
    Wait Until Element Is Enabled    ${progress_note} 
    ${Current_text}=    Get Value    ${progress_note}
    Set Test Variable    ${Current_text}
    Click Element    ${PO_modal_close_btn}

Select PO Row
    [Arguments]    ${PO_arg}
    ${PO_num}    Set Variable    ${PO_number}
    ${PO_num_row}    Replace Variables    ${PO_num_row}
    ${Edit_PO}    Replace Variables    ${Edit_PO}
    Check Loading Data
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${Edit_PO}
    ${check}    Run Keyword And Return Status    Click Element    ${Edit_PO}
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Util.Scroll To Bottom
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${Edit_PO}
    END
    Util.Wait For Page Loading    element_arg=${PO_Loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Verify Selected Dropdown Value Matches TempData
    [Arguments]    ${element}    ${tempdata_key}
    ${expected}=    Set Variable    ${TempData['${tempdata_key}']}
    ${actual}=    Get Selected List Label    ${element}
    Should Be Equal As Strings    ${actual}    ${expected}

Verify Field Value Matches TempData
    [Arguments]    ${element}    ${tempdata_key}
    ${expected}=    Set Variable    ${TempData['${tempdata_key}']}
    ${actual}=    Get Value    ${element}
    ${actual_number}=  Evaluate  math.floor(float('${actual}'.split(' ')[0]))    modules=math
    ${expected_number}=  Evaluate  math.floor(float('${expected}'))    modules=math
    Should Be Equal As Numbers    ${actual_number}    ${expected_number}

# Verify Height Fields Matches TempData Converted Ft And In
#     [Arguments]    ${ft_element}    ${in_element}    ${ft_key}    ${inch_key}
#     ${ft}=    Get From Dictionary    ${TempData}    ${ft_key}
#     ${inch}=    Get From Dictionary    ${TempData}    ${inch_key}
#     ${total_inch}=    Evaluate    int(${ft}) * 12 + int(${inch})
#     ${expected_ft}=    Evaluate    ${total_inch} // 12
#     ${expected_in}=    Evaluate    ${total_inch} % 12
#     ${actual_ft_raw}=    Get Value    ${ft_element}
#     ${actual_ft}=    Evaluate    str('${actual_ft_raw}').replace('ft','').replace(' ','').strip()

#     ${actual_in_raw}=    Get Value    ${in_element}
#     ${actual_in}=    Evaluate    str('${actual_in_raw}').replace('in','').replace(' ','').strip()

#     Should Be Equal As Strings    ${expected_ft}    ${actual_ft}
#     Should Be Equal As Strings    ${expected_in}    ${actual_in}

Check Loading Data
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    30s

Check Elements Visible
    [Arguments]    @{elements}
    FOR    ${el}    IN    @{elements}
            Element Should Be Visible    ${el}
    END

Check Navigate To Viewwing Provider Order Successfully
    Wait Until Element Is Visible   ${PO_list}
    ${PO_num}    Set Variable    ${PO_number}
    ${PO_num_row}    Replace Variables    ${PO_num_row}
    Click Element    ${PO_num_row}
    Wait Until Element Is Visible    ${PO_loading}
    Wait Until Element Is Not Visible    ${PO_loading}

Check Supporting Documentation section Has Fields Group
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${regimen_UI}
    ${button_text}=    Get Text    ${viewdoc_UI}
    IF    '${button_text}' == 'View Documentation'
        Click Element    ${viewdoc_UI}
        Wait Until Element Contains    ${viewdoc_UI}    Hide Documentation    5s
    END
    Check Elements Visible    ${document_list_UI}    ${question_doc_UI}
    ${question_doc_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${question_doc_UI}
    Should Be True    ${question_doc_disabled}

Check Supporting Documentation Section Has Fields Group For Update PO
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${regimen_UI}
    ${button_text}=    Get Text    ${viewdoc_UI}
    IF    '${button_text}' == 'View Documentation'
        Click Element    ${viewdoc_UI}
        Wait Until Element Contains    ${viewdoc_UI}    Hide Documentation    5s
    END
    Check Elements Visible    ${document_list_UI}    ${question_doc_UI}    ${PO_save_btn}

Check Medication Regimen Section Has Fields Group For Update PO
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${secondary_UI}
    Check Elements Visible    
    ...    ${select_regimen_UI}    
    # ...    ${create_regimen_UI}    
    ...    ${dose_UI}    
    ...    ${repeatRegimen_UI}    
    ...    ${repeatRegimenFrequency_UI}    
    ...    ${repeatMaintenance_UI}    
    ...    ${repeatMaintenanceFrequency_UI}

Check Medication Regimen Section Has Fields Group
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${secondary_UI}
    Check Elements Visible    ${select_regimen_UI}    ${dose_UI}    ${repeatRegimen_UI}    ${repeatRegimenFrequency_UI}    ${repeatMaintenance_UI}    ${repeatMaintenanceFrequency_UI}  
    ${class}=    SeleniumLibrary.Get Element Attribute    ${select_regimen_UI}    class
    Should Contain    ${class}    disabled
    ${class}=    SeleniumLibrary.Get Element Attribute    ${dose_UI}    class
    Should Contain    ${class}    input-regimen-disabled
    ${RepeatRegimen_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${repeatRegimen_UI}
    Should Be True    ${RepeatRegimen_disabled}
    ${RepeatRegimenFrequency_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${repeatRegimenFrequency_UI}
    Should Be True    ${RepeatRegimenFrequency_disabled}
    ${RepeatMaintenance_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${repeatMaintenance_UI}
    Should Be True    ${RepeatMaintenance_disabled}
    ${RepeatMaintenanceFrequency_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${repeatMaintenanceFrequency_UI}
    Should Be True    ${RepeatMaintenanceFrequency_disabled}

Check Secondary Medication Section Has Fields Group For Update PO
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${referrals_CPT_UI}
    Check Elements Visible    
    ...    ${quick_select_UI}    
    ...    ${add_secondarymed_UI}     
    ...    ${secondary_list_UI}   
    ...    ${view_assigned_medication_UI}
    ${is_hidden}=    Run Keyword And Return Status    Should Contain    ${secondary_list_UI}    class    hidden
     IF    ${is_hidden}
        Click Element    ${quick_select_UI}
        Wait Until Element Is Visible    ${secondary_list_UI}    10s
    ELSE
        Element Should Be Visible    ${secondary_list_UI}
    END

Check Secondary Medication Section Has Fields Group
    Check Secondary Medication Section Has Fields Group For Update PO
    ${class}=    SeleniumLibrary.Get Element Attribute    ${add_secondarymed_UI}    class
    Should Contain    ${class}    disabled

Check The Preferred CPT Codes Section Has Fields Group For Update PO
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tools_status_history_UI}
    Check Elements Visible    
    ...    ${referrals_CPT_UI}     
    ...    ${referral_UI}    
    ...    ${treatment_goals_UI}    
    ...    ${notes_UI}    
    ...    ${Rx_number_assign_UI}

Check The Preferred CPT Codes Section Has Fields Group
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tools_status_history_UI}
    Check Elements Visible    ${referrals_CPT_UI}     ${referral_UI}    ${treatment_goals_UI}    ${notes_UI}    ${Rx_number_assign_UI}    ${Rx_num_UI}    ${Rx_date_UI}    ${Rx_origin_UI}
    ${prefer_checkbox_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${prefer_checkbox_UI}
    Should Be True    ${prefer_checkbox_disabled}
    ${Refer_aria_disabled}=    SeleniumLibrary.Get Element Attribute    ${referral_UI}    aria-disabled
    ${is_disabled}=      Evaluate    "${Refer_aria_disabled}" == "true"
    Should Be True    ${is_disabled}
    ${treatment_goals_disabled}=    SeleniumLibrary.Get Element Attribute    ${treatment_goals_UI}    aria-disabled
    ${is_disabled}=      Evaluate    "${treatment_goals_disabled}" == "true"
    Should Be True    ${is_disabled}
    ${Rx_num_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${Rx_num_UI}
    Should Be True    ${Rx_num_disabled}
    ${Rx_date_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${Rx_date_UI}
    Should Be True    ${Rx_date_disabled}
    ${Rx_origin_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${Rx_origin_UI}
    Should Be True    ${Rx_origin_disabled}
Check Tools for Status and History Section Has Fields Group
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tools_status_history_UI}
    Check Elements Visible    
    ...    ${tools_status_history_UI}     
    ...    ${discontinue_checkbox_UI}    
    ...    ${view_change_btn}    
    ...    ${copyPO_UI}    
    ...    ${PO_modal_close_btn}

Check Tools for Status and History Section Has Fields Group For Update PO
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tools_status_history_UI}
    Check Elements Visible    
    ...    ${tools_status_history_UI}     
    ...    ${discontinue_checkbox_UI}    
    ...    ${view_change_btn}    
    ...    ${copyPO_UI}    
    ...    ${savePO_UI}    
    ...    ${PO_modal_close_btn}

Clear StartDate And EndDate Field
    [Arguments]    @{locators}
    FOR    ${field}    IN    @{locators}
        FOR    ${i}    IN RANGE    5
            ${value}=    Run Keyword And Ignore Error    SeleniumLibrary.Get Element Attribute    ${field}    value
            ${status}=    Set Variable    ${value[0]}
            ${value}=     Set Variable    ${value[1]}
            Exit For Loop If    '${value}' == ''
            Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${field}    
        END
    END

Compare Data Before And After Saved
    ${physician}=    Get Value    ${physician_input}
    ${ordering}=    Get Value    ${ordering_physician}
    ${weight}=    Get Value    ${weight_PO_input}
    Should Be Equal As Strings    ${PatientData.Refering_Provider}    ${physician}
    Should Be Equal As Strings    ${PatientData.referto_provider_NPI_PO}    ${ordering}
    Should Be Equal As Numbers    ${PatientData.Weight_KG}    ${weight}    precision=0.01
    Verify Field Value Matches TempData  ${PO_dosage_assign}  PO_dosage_arg
    Verify Field Value Matches TempData  ${PO_dose_convert}  PO_dosage_arg
    Verify Field Value Matches TempData  ${PO_num_dose}    PO_dosage_arg
    Verify Field Value Matches TempData  ${PO_split_dose}   PO_dosage_arg
    Verify Selected Dropdown Value Matches TempData    ${PO_frequency_value}    PO_frequency_value
    Verify Selected Dropdown Value Matches TempData    ${PO_dose_frequency}    PO_dose_frequency
    Verify Selected Dropdown Value Matches TempData    ${PO_split_treatment}    PO_split_treatment
    
Compare Provider Order In Both Screen
    Wait Until Element Is Not Visible    //*[@id='frm_CreateEditPatientOrderModal']    30s
    Wait Until Element Is Visible    ${PO_patientlist}
    ${PO_num}    Set Variable    ${PO_number}
    ${PO_num_row}    Replace Variables    ${PO_num_row}   
    Click Element    ${PO_num_row}
    Should Be Equal    ${PO_num}    ${PO_number}
    Scroll And Click Element    ${PO_modal_close_btn}
    Open PO At Provider Order Page
    Wait Until Element Is Visible    ${PO_list}
    ${PO_numm}    Set Variable    ${PO_number}
    ${PO_num_row}    Replace Variables    ${PO_num_row}
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${PO_num_row}
    Should Be Equal    ${PO_numm}    ${PO_number}

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

Verify Primary Diagnosis Has Two Section and ICD Disable 
    Wait Until Element Is Enabled    ${select_location_PO}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${select_location_PO}    ${PatientData.Location}
    Click Element    ${Create_ProviderOrder}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_location_select}    ${PatientData.Location}
    Input Patient And Select Autocomplete    ${PO_SelectedPatient}    ${PatientData.MRN}    ${PO_autocompleteItem}
    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_dropdown}
    Check Loading Data
    Page Should Contain Element    ${PO_medication_icd}    ${PO_assign_icd}
    ${ICD_disabled}=    SeleniumLibrary.Get Element Attribute    ${ICD_disabled_primary}    aria-disabled
    ${is_disabled}=      Evaluate    "${ICD_disabled}" == "true"
    Should Be True    ${is_disabled}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    4
    Scroll And Click Element    ${PO_modal_close_btn}

Verify Secondary Diagnosis Has Two Section and ICD Disable
    Wait Until Element Is Enabled    ${select_location_PO}
    Select From List By Label    ${select_location_PO}    ${PatientData.Location}
    Click Button    ${clearpatient_btn}
    Input Patient And Select Autocomplete    ${PO_filter_patient_input}    ${PatientData.MRN}    ${patient_autocomplete}
    Clear StartDate And EndDate Field    ${startdate_field}    ${enddate_field}
    Click Element    ${PO_search_btn}
    Check Loading Data
    Select PO Row    PO_arg=${PO_number}
    Check Loading Data
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${secondary_diag_dropdown}
    Check Loading Data
    Wait Until Keyword Succeeds    30s    1s    Page Should Contain Element    ${POs_medication_icd}    ${POs_assign_icd}
    ${ICD_disabled}=    SeleniumLibrary.Get Element Attribute    ${ICD_disabled_secondary}    aria-disabled
    ${is_disabled}=      Evaluate    "${ICD_disabled}" == "true"
    Should Be True    ${is_disabled}
    Select From List By Index    ${POs_secondary_diagnosis_select}    5
    Scroll And Click Element    ${PO_modal_close_btn}

Verify Assigned To Patient Not Displayed In Primary Diagnosis
    Wait Until Element Is Enabled    ${select_location_PO}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${select_location_PO}    ${PatientData.Location}
    Click Element    ${Create_ProviderOrder}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${PO_location_select}    ${PatientData.Location}
    Input Patient And Select Autocomplete    ${PO_SelectedPatient}    ${PatientData.MRN}    ${PO_autocompleteItem}
    Check Loading Data
    Select From List By Label    ${med_select}    ${PatientData.drug_PO}
    Wait Until Element Is Visible    ${PO_diagnosis_txt}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${PO_dropdown}
    Page Should Not Contain Element    ${PO_assign_icd}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    4
    Scroll And Click Element    ${PO_modal_close_btn}

Verify Assigned To Patient Not Displayed In Secondary Diagnosis
    Wait Until Element Is Enabled    ${select_location_PO}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${select_location_PO}    ${PatientData.Location}
    Click Button    ${clearpatient_btn}
    Input Patient And Select Autocomplete    ${PO_filter_patient_input}    ${PatientData.MRN}    ${patient_autocomplete}
    Clear StartDate And EndDate Field    ${startdate_field}    ${enddate_field}
    Click Element    ${PO_search_btn}
    Check Loading Data
    Select PO Row    PO_arg=${PO_number}
    Check Loading Data
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${secondary_diag_dropdown}
    Page Should Not Contain Element    ${POs_assign_icd}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${POs_secondary_diagnosis_select}    4
    Scroll And Click Element    ${PO_modal_close_btn}

Verify Preferred UoM Dropdown In Create Mode
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Dispensing UoM')]
    ${default}=    Get Selected List Label    ${PO_uom_select}
    Should Be Equal As Strings    ${default}    -- Select a Preferred UoM --

Verify Preferred Method Label In Create Mode
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Method')]
    ${old_label}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Container Type')]
    Should Be Equal As Strings    ${old_label}    False

Verify Preferred UoM Dropdown In View Mode
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Dispensing UoM')]
    Element Should Be Disabled    ${PO_uom_select}
    ${default}=    Get Selected List Label    ${PO_uom_select}
    Should Be Equal As Strings    ${default}    -- Select a Preferred UoM --

Verify Preferred Method Label In View Mode
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Method')]
    ${old_label}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Container Type')]
    Should Be Equal As Strings    ${old_label}    False

Verify Preferred UoM Dropdown In Edit Order
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Dispensing UoM')]
    ${default}=    Get Selected List Label    ${PO_uom_select}
    Should Be Equal As Strings    ${default}    -- Select a Preferred UoM --

Verify Preferred Method Label In Edit Order
    Check Loading Data
    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Preferred Method')]
    ${old_label}=    Run Keyword And Return Status    
    ...    Page Should Contain Element    //*[@id='PatientInnerView']//following::div//strong[contains(text(),'Container Type')]
    Should Be Equal As Strings    ${old_label}    False

Scroll And Click Element
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${element}
    Execute Javascript    window.scrollBy(0, 200)
    ${type_name}    Wait Until Keyword Succeeds    30    1    SeleniumLibrary.Get Element Attribute    ${element}    tagName
    IF    "${type_name}" == "BUTTON"
        Wait Until Keyword Succeeds    30s    1    Click Button    ${element}
    ELSE
        Wait Until Keyword Succeeds    30s    1    Click Element    ${element}
    END

Scroll And Click Element Modal
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    30s
    Sleep    1s
    Execute Javascript    var el = document.evaluate("${element}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; el.scrollIntoView({behavior: "smooth", block: "center"}); setTimeout(() => { window.scrollBy(0, 400); });
    Wait Until Element Is Enabled    ${element}    10s
    ${type_name}    Wait Until Keyword Succeeds    30    1    SeleniumLibrary.Get Element Attribute    ${element}    tagName
    Sleep    1s
    IF    "${type_name}" == "BUTTON"
        Wait Until Keyword Succeeds    30s    1    Click Button    ${element}
    ELSE
        Wait Until Keyword Succeeds    30s    1    Click Element    ${element}
    END

Input Required Fields In Lab Tracker Modal
    [Arguments]    ${account_arg}    ${name_arg}    ${lab_des_arg}    ${payer_arg}    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}    ${file_arg}    ${ICD10_arg}    ${btn_arg}    ${msg}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    Select From List By Label    ${tracker_location}    ${account_arg}
    Input Patient Name Lab Tracker Modal    ${name_arg}
    Input Lab Descirption Lab Tracker Modal    ${lab_des_arg}    ${EMPTY}
    Input Payer Lab Tracker Modal    ${payer_arg}
    Input Date Time Lab Tracker Modal    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_file_num}    ${file_arg}
    Sleep    1s
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_value}    var_name=tracker_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_select}    var_name=tracker_frequency_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_status_select}    var_name=tracker_status_select    dic=${TempData}
    Choose Primary ICD10 Code    ${ICD10_arg}    Primary
    IF    "${btn_arg}" == "${tracker_save_btn}"
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Get DateTime In Lab Tracker
    ${result}    Get Next Date
    ${start_date}=    Get From Dictionary    ${result}    _current_date
    ${end_date}=    Get From Dictionary    ${result}    end_date
    ${result_date}=    Get From Dictionary    ${result}    result_date
    Set Test Variable    ${start_date}
    Set Test Variable    ${end_date}
    Set Test Variable    ${result_date}

Input All Fields In Lab Tracker Modal
    [Arguments]    ${account_arg}    ${name_arg}    ${lab_des_arg}    ${payer_arg}    ${physician_arg}    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}    ${file_arg}    ${ICD10_arg}    ${btn_arg}    ${msg}
    Wait Until Element Is Visible    ${tracker_add_lab_title}    30s
    Select From List By Label    ${tracker_location}    ${account_arg}
    Input Patient Name Lab Tracker Modal    ${name_arg}
    Input Lab Descirption Lab Tracker Modal    ${lab_des_arg}    ${EMPTY}
    Input Payer Lab Tracker Modal    ${payer_arg}
    Select From List By Value   ${tracker_ordering_provider}    ${physician_arg}
    Input Date Time Lab Tracker Modal    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_file_num}    ${file_arg}
    Sleep    2s
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_value}    var_name=tracker_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_frequency_select}    var_name=tracker_frequency_select    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${tracker_status_select}    var_name=tracker_status_select    dic=${TempData}
    Random Stat Order Checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_fasting_checkbox}
    Select From List By Index    ${tracker_company_select}    1
    Choose Primary ICD10 Code    ${ICD10_arg}    Primary
    Choose Primary ICD10 Code    ${ICD10_arg}    Additional
    IF    "${btn_arg}" == "${tracker_save_btn}"
        Scroll And Click Element Modal    ${btn_arg}
        Page Alert Message    ${msg}
    END
    Set To Dictionary    ${TempData}    file_num=${file_arg}

Input Patient Name Lab Tracker Modal
    [Arguments]    ${name_arg}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_patient_name}
    ${lab_des}    Set Variable    ${name_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_patient_name}    ${name_arg}
    ${tracker_patient_name_strong}    Replace Variables    ${tracker_patient_name_strong}
    Wait Until Element Is Visible    ${tracker_patient_name_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_patient_name_strong}

Input Lab Descirption Lab Tracker Modal
    [Arguments]    ${lab_des_arg}    ${drug_lab_arg}
    ${lab_des}    Set Variable    ${lab_des_arg}
    ${drug_lab}    Set Variable    ${drug_lab_arg}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_description}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_description}    ${lab_des}
    ${tracker_description_strong}    Replace Variables    ${tracker_description_strong}
    Wait Until Element Is Visible    ${tracker_description_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_description_strong}
    Wait Until Element Is Visible    ${tracker_lab_attribute_title}
    Sleep    2s

Input Payer Lab Tracker Modal
    [Arguments]    ${payer_arg}
    # Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_payer}    Test Payer New
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_payer}    ${payer_arg}
    # ${tracker_payer_strong}    Util.Replace Xpath    ${tracker_payer_strong}
    # Wait Until Element Is Visible    ${tracker_payer_strong}    30s
    # Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_payer_strong}

Input Date Time Lab Tracker Modal
    [Arguments]    ${start_date_arg}    ${end_date_arg}    ${result_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_startdate_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_startdate_input}    ${start_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_enddate_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_enddate_input}    ${end_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_resultdate_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_resultdate_input}    ${result_date_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    
Choose Primary ICD10 Code
    [Arguments]    ${ICD10_arg}    ${type_arg}
    IF    "${type_arg}" == "Primary"
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_ICD10_input}    ${ICD10_arg}[icd10_code1]
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_ICD10_checkbox}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_add_btn}
    ELSE IF    "${type_arg}" == "Additional"
        FOR    ${i}    IN RANGE    2    4
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_ICD10_input}    ${ICD10_arg}[icd10_code${i}]
            Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_add_btn}
        END
    END

Random Stat Order Checkbox
    ${stat}    Create List    ${tracker_yes_checkbox}    ${tracker_no_checkbox}
    ${random_checkbox}    Evaluate    random.choice(${stat})
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${random_checkbox}

Select Lab Descirption In Lab View
    [Arguments]    ${drug_arg}    ${assigned_lab_status}
    Open Protocol Management Modal
    Show Medication's Required Labs    ${drug_arg}
    Remove Lab Descirption Abiraterone Assigned Labs
    Select Lab Descirption In Quick Select Tool Table    ${assigned_lab_status}
    Scroll And Click Element    ${protocol_close_btn}

Open Protocol Management Modal
    Appointment.Go Dispensing
    Scroll And Click Element    ${manage_btn}
    Scroll And Click Element    ${manage_protocol_link}
    Wait Until Element Is Visible    ${protocol_edit_treament_btn}    30s

Show Medication's Required Labs
    [Arguments]    ${drug_arg}
    ${drug_PO1}    Set Variable    ${drug_arg}
    Set Test Variable    ${drug_PO1}
    Select From List By Label    ${protocol_location_select}    ${PatientData.Location}
    Scroll And Click Element Modal    ${protocol_clear_btn}
    # Element Is Not Visible    ${protocol_loading_icon}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon}    5s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${protocol_search_input}    ${drug_arg}
    Scroll And Click Element Modal    ${protocol_find_btn}
    # Element Is Not Visible    ${protocol_loading_icon}
    # Sleep    1s
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon}    5s
    ${protocol_assign_lab_btn}    Util.Replace Xpath    ${protocol_assign_lab_btn}
    Scroll And Click Element Modal    ${protocol_assign_lab_btn}
    Wait Until Element Is Visible    ${protocol_required_lab_title}    30s

Select Lab Descirption In Quick Select Tool Table
    [Arguments]    ${assigned_lab_status}
    ${protocol_show_view_btn}    Util.Replace Xpath    ${protocol_show_view_btn}
    Scroll And Click Element Modal    ${protocol_show_view_btn}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon_i}    5s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon_i}    5s
    ${lab_index}    Get Variable Value    ${lab_index}    3
    ${lab_tr}    Get Variable Value    ${lab_tr}    1
    IF    "${lab_index}" == "4"
        ${lab_index}    Set Variable    1
        ${new_lab_tr}    Evaluate    int(${lab_tr}) + 1
        Set Suite Variable    ${lab_tr}    ${new_lab_tr}
    END
    IF    ${assigned_lab_status} == ${True}
        ${assign_lab_checkbox}    Replace Variables    ${protocol_assign_lab_checkbox}
        Sleep    2s
        Scroll And Click Element Modal    ${assign_lab_checkbox}
        Page Alert Message    Lab has been assigned.
        Util.Select Random From List Regression    xpath_arg=${protocol_frequency_value}    var_name=protocol_frequency_value    dic=${TempData}
        Util.Select Random From List Regression    xpath_arg=${protocol_frequency_select}    var_name=protocol_frequency_select    dic=${TempData}
        Page Alert Message    Lab has been updated.
    END
    ${assign_lab_strong}    Replace Variables    ${protocol_assign_lab_strong}
    Wait Until Element Is Visible    ${assign_lab_strong}    30s
    Scroll Element Into View    ${assign_lab_strong}
    ${assign_lab_txt}    Get Text    ${assign_lab_strong}
    ${assign_emr_lab}    Evaluate    """${assign_lab_txt}""".rpartition('(')[2].rstrip(')') if '(' in """${assign_lab_txt}""" else ""
    ${assign_lab_txt}    Evaluate    """${assign_lab_txt}""".rpartition('(')[0].rstrip() if '(' in """${assign_lab_txt}""" else """${assign_lab_txt}"""
    ${new_lab_index}    Evaluate    int(${lab_index}) + 1
    Set Test Variable    ${assign_lab_txt}
    Set Test Variable    ${assign_emr_lab}
    Set Suite Variable    ${lab_tr}
    Set Suite Variable    ${lab_index}    ${new_lab_index}

Select Lab Descirption By Searching
    [Arguments]    ${drug_arg}    ${assign_lab_txt}    ${assigned_lab_status}
    Open Protocol Management Modal
    Show Medication's Required Labs    ${drug_arg}
    Remove Lab Descirption Abiraterone Assigned Labs
    ${drug_PO1}    Set Variable    ${drug_arg}
    ${protocol_show_view_btn}    Util.Replace Xpath    ${protocol_show_view_btn}
    Scroll And Click Element Modal    ${protocol_show_view_btn}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon_i}    5s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon_i}    5s
    ${protocol_lab_search}    Replace Variables    ${protocol_lab_search}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${protocol_lab_search}    ${assign_lab_txt}
    ${protocol_lab_find_btn}    Replace Variables    ${protocol_lab_find_btn}
    Wait Until Keyword Succeeds    30s     1s    Click Button    ${protocol_lab_find_btn}
    ${lab_checkbox}    Replace Variables    //strong[contains(text(),'${assign_lab_txt}')]//preceding::input[1]
    Wait Until Keyword Succeeds    30s     1s    Click Element    ${lab_checkbox}
    Page Alert Message    Lab has been assigned.
    IF    ${assigned_lab_status} == ${True}
        Util.Select Random From List Regression    xpath_arg=${protocol_frequency_value}    var_name=protocol_frequency_value    dic=${TempData}
        Util.Select Random From List Regression    xpath_arg=${protocol_frequency_select}    var_name=protocol_frequency_select    dic=${TempData}
        Page Alert Message    Lab has been updated.
    END
    Scroll And Click Element    ${protocol_close_btn}

Remove Lab Descirption Abiraterone Assigned Labs
    ${total_rows}    SeleniumLibrary.Get Element Count    ${protocol_lab_assigned_checkbox}
    IF    ${total_rows} > 0
        FOR    ${i}    IN RANGE    1    ${total_rows + 1}
            ${td_checkbox}    Set Variable    ${protocol_lab_assigned_checkbox}
            Scroll And Click Element Modal    ${td_checkbox}
            Page Alert Message    Lab has been removed.
        END
    END

Clear Input Field Until Empty
    [Arguments]    ${locator}
    Press Keys    ${locator}    CTRL+A+BACKSPACE
    # Clear Element Text    ${locator}
    ${value}     Get Value     ${locator}
    Should Be Empty    ${value}

Compare Value Inputs
    [Arguments]    ${xpath_input1}    ${xpath_input2}    ${equal_status}
    IF    "${equal_status}" == "Value"
        ${value1}    Get Value    ${xpath_input1}
        ${value2}    Get Value    ${xpath_input2}
        Should Be Equal    ${value1}    ${value2}
    ELSE IF    "${equal_status}" == "Text"
        ${value1}    Get Text    ${xpath_input1}
        ${value2}    Get Text    ${xpath_input2}
        Should Be Equal    ${value1}    ${value2}
    ELSE IF    "${equal_status}" == "Empty"
        ${value1}    Get Value    ${xpath_input1}
        Should Be Equal    ${value1}    ${xpath_input2}
    END

Check Selected Label
    [Arguments]    ${xpath_select}    ${expected}    ${equal_status}
    ${value}    Get Selected List Label    ${xpath_select}
    IF    "${equal_status}" == "${True}"
        Should Be Equal    ${value}    ${expected}
    ELSE
        Should Not Be Equal    ${value}    ${expected}
    END

Select Frequency Lab In PO
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_lab_frequency_value}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_value}    ${TempData.protocol_frequency_value}    equal_status=${True}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_select}    ${TempData.protocol_frequency_select}    equal_status=${True}
    ${PO_lab_frequency_value_txt}    Get Selected List Label    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select_txt}    Get Selected List Label    ${PO_lab_frequency_select}
    Set Test Variable    ${PO_lab_frequency_value_txt}
    Set Test Variable    ${PO_lab_frequency_select_txt}
    Scroll And Click Element Modal    ${PO_modal_close_btn}

Check Changed Value Frequency Lab Tracker Modal
    [Arguments]    ${drug_arg}    ${frequency_value}    ${frequency_select}
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Get DateTime In Lab Tracker
    Input All Fields In Lab Tracker Modal
    ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
    ...    payer_arg=${PatientData.lab_payer}    physician_arg=${PatientData.referring_NPI_PO}    start_date_arg=${start_date}    
    ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
    ...    ICD10_arg=${PatientData.icd10_code}    btn_arg=${None}    msg=${None}
    Wait Until Keyword Succeeds    30    1   Clear Input Field Until Empty    ${tracker_description}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${drug_arg}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${tracker_frequency_value}    ${frequency_value}    equal_status=${True}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${tracker_frequency_select}    ${frequency_select}    equal_status=${True}
    Sleep    2s
    Change Value Select Until Not Be Equal Old Value    ${tracker_frequency_value}    ${tracker_frequency_select}    tracker_frequency_value     tracker_frequency_select
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    Lab Tracker Created

Check Frequency Value With PO Protocol
    Open Provider Orders tab
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_lab_frequency_value}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_value}    ${TempData.tracker_frequency_value}    equal_status=${False}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_select}    ${TempData.tracker_frequency_select}    equal_status=${False}
    Scroll And Click Element Modal    ${PO_modal_close_btn}

Select Frequency Lab In Patient Protocol
    Open Appointments Tab
    ${APT_datetime}    Set Variable    ${PatientData.APT_Date}
    Set Test Variable    ${APT_datetime}
    ${APT_patient_protocol}    Util.Replace Xpath    ${APT_patient_protocol}
    Scroll And Click Element    ${APT_patient_protocol}
    Wait Until Element Is Visible    ${APT_protol_title}    30s
    Scroll And Click Element Modal    ${APT_protocol_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_lab_frequency_value}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_value}    ${TempData.protocol_frequency_value}    equal_status=${True}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_select}    ${TempData.protocol_frequency_select}    equal_status=${True}
    ${patient_protocol_frequency_value_txt}    Get Selected List Label    ${PO_lab_frequency_value}
    ${patient_protocol_frequency_select_txt}    Get Selected List Label    ${PO_lab_frequency_select}
    Set Test Variable    ${patient_protocol_frequency_value_txt}
    Set Test Variable    ${patient_protocol_frequency_select_txt}
    Scroll And Click Element Modal    ${APT_protocol_accept_btn}
    Page Alert Message    Protocol Updated!

Check Frequency Value With Patient Protocol
    [Arguments]    ${frequency_value_compare}    ${frequency_select_compare}    ${status_compare}
    Open Appointments Tab
    ${APT_datetime}    Set Variable    ${PatientData.APT_Date}
    Set Test Variable    ${APT_datetime}
    ${APT_patient_protocol}    Util.Replace Xpath    ${APT_patient_protocol}
    Scroll And Click Element    ${APT_patient_protocol}
    Wait Until Element Is Visible    ${APT_protol_title}    30s
    Scroll And Click Element Modal    ${APT_protocol_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_lab_frequency_value}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_value}    ${frequency_value_compare}    equal_status=${status_compare}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_select}    ${frequency_select_compare}    equal_status=${status_compare}
    Scroll And Click Element Modal    ${APT_protocol_accept_btn}
    Page Alert Message    Protocol Updated!

Check Frequency Value With Protocol Management
    [Arguments]    ${drug_arg}    ${frequency_value_compare}    ${frequency_select_compare}    ${status_compare}
    Open Protocol Management Modal
    Show Medication's Required Labs    ${drug_arg}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_lab_frequency_value}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_value}    ${frequency_value_compare}    equal_status=${status_compare}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${PO_lab_frequency_select}    ${frequency_select_compare}    equal_status=${status_compare}
    Scroll And Click Element    ${protocol_close_btn}

Check Frequency Value In Protocol Management
    [Arguments]    ${drug_arg}  ${status_arg}
    Open Protocol Management Modal
    Show Medication's Required Labs    ${drug_arg}
    IF    "${status_arg}" == "Patient Protocol"
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_value}    ${TempData.patient_protocol_frequency_value}    equal_status=${False}
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_select}    ${TempData.patient_protocol_frequency_select}    equal_status=${False}
    ELSE IF    "${status_arg}" == "PO Protocol"
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_value}    ${TempData.PO_lab_frequency_value}    equal_status=${False}
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_select}    ${TempData.PO_lab_frequency_select}    equal_status=${False}
    ELSE
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_value}    ${TempData.tracker_frequency_value}    equal_status=${False}
        Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${protocol_frequency_select}    ${TempData.tracker_frequency_select}    equal_status=${False}
    END
    Scroll And Click Element    ${protocol_close_btn}

Check Value Expiration Date
    [Arguments]    ${frequency_value_arg}    ${frequency_select_arg}    ${resultdate_input_arg}    ${expdate_input_arg}
    ${frequency_value}    Get Selected List Label    ${frequency_value_arg}
    ${frequency_select}    Get Selected List Label    ${frequency_select_arg}
    ${tracker_resultdate_value}    Get Value    ${resultdate_input_arg}
    ${tracker_expdate_value}    Get Value    ${expdate_input_arg}
    IF    "${frequency_select}" == "Day(s)"
        ${tracker_resultdate_value}    Add Time To Date    ${tracker_resultdate_value}    ${frequency_value} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ELSE IF    "${frequency_select}" == "Week(s)"
        ${frequency_value}    Evaluate    int(${frequency_value}*7)
        ${tracker_resultdate_value}    Add Time To Date    ${tracker_resultdate_value}    ${frequency_value} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ELSE IF    "${frequency_select}" == "Month(s)"
        ${tracker_resultdate_value}    Evaluate    str((datetime.datetime.strptime('${tracker_resultdate_value}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(months=${frequency_value})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
    ELSE IF    "${frequency_select}" == "Year(s)"
        ${tracker_resultdate_value}    Evaluate    str((datetime.datetime.strptime('${tracker_resultdate_value}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(years=${frequency_value})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
    END
    Should Be Equal    ${tracker_resultdate_value}    ${tracker_expdate_value}
    Set Test Variable    ${tracker_expdate_value}

Open Lab Tracker Row
    Set Test Variable    ${file_num}    ${Fake_dict.num_rand}
    ${tracker_lab_row}    Replace Variables    ${tracker_lab_row}
    Scroll And Click Element    ${tracker_lab_row}

Show Empty Value In Lab Tracker Row
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tracker_patient_value_title}    5s
    IF    '${check_visible}' == '${False}'
        Wait Until Element Is Visible    ${tracker_no_available_title}    5s
    END
    Scroll And Click Element Modal    ${tracker_show_empty_checkbox}
    ${checked}    Wait Until Keyword Succeeds    30s     1s    SeleniumLibrary.Get Element Attribute    ${tracker_show_empty_checkbox}    checked
    Should Be Equal    ${checked}    true
    Wait Until Element Is Visible    ${tracker_empty_attribute_row}    30s
    ${total_attribute_rows}    SeleniumLibrary.Get Element Count    ${tracker_empty_attribute_row}
    Should Be True    ${total_attribute_rows} > 0
    Scroll And Click Element Modal    ${tracker_close_btn}
    
Input All Fields In Attribute Modal
    [Arguments]    ${btn}    ${alert}
    FOR    ${i}    IN RANGE    10
        ${check_btn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${btn}    5s
        IF    '${check_btn_visible}' == '${True}'
            Scroll And Click Element Modal    ${btn}
            Exit For Loop
        ELSE
            Scroll And Click Element    (//a[contains(text(),"Next")])[1]
        END
    END    
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_description}    ${Fake_dict.sentence_str}
    Set Test Variable    ${attribute_description_txt}    ${Fake_dict.sentence_str}
    Util.Select Random From List Regression    xpath_arg=${attribute_response_type}    var_name=attribute_response_type    dic=${TempData}
    IF    "${TempData.attribute_response_type}" == "Range"
        ${min_range}    Set Variable    ${Fake_dict.demical_2d}
        ${max_range}    Evaluate    ${Fake_dict.demical_2d} + ${Fake_dict.demical_2d}
        Set Test Variable    ${min_range}
        Set Test Variable    ${max_range}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_range_start}    ${min_range}   
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_range_end}    ${max_range}  
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_unit}    ml
    ELSE IF    "${TempData.attribute_response_type}" == "Selection"
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_select_list}    Attribute Selection
    END
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${attribute_save_btn}
    Run Keyword And Ignore Error    Handle Alert    ACCEPT    1s
    Page Alert Message    ${alert}

Open Lab Tracker Ledger
    Scroll And Click Element    ${DispensingLink}
    Scroll And Click Element    ${tracker_ledger_link}
    Title Should Be    Lab Tracker Ledger
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${tracker_ledger_location}    ${PatientData.Location}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon_i}    5s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon_i}    5s
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${tracker_ledger_patient}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${tracker_ledger_patient}    ${PatientData.MRN}
    ${tracker_ledger_patient_strong}    Replace Variables    //div[contains(text(),'${PatientData.MRN}')]
    Wait Until Element Is Visible    ${tracker_ledger_patient_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_ledger_patient_strong}
    Wait Until Keyword Succeeds    30s    1s    Click Element    (//a[contains(@class,'LabTrackerLedgerSearchBtn')])[1]
    

Input Out Of Normal Range Value
    Open Lab Tracker Row
    Scroll And Click Element Modal    ${attribute_add_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_description}    ${Fake_dict.sentence_str}
    Select From List By Label    ${attribute_response_type}    Range
    ${min_range}    Set Variable    ${Fake_dict.demical_2d}
    ${max_range}    Evaluate    ${Fake_dict.demical_2d} + ${Fake_dict.demical_2d}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_range_start}    ${min_range}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_range_end}    ${max_range}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_unit}    ml
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${attribute_save_btn}
    Page Alert Message    Lab Tracker Attribute Added
    Scroll And Click Element Modal    ${tracker_show_empty_checkbox}
    Set Test Variable    ${attribute_description_txt}    ${Fake_dict.sentence_str}
    ${out_range_value}    Evaluate    random.choice([random.randint(0, ${min_range} - 1), random.randint(${max_range} + 1, ${max_range} + 20)])    modules=random
    Set Test Variable    ${out_range_value}
    IF    ${out_range_value} < ${min_range}
        Set Test Variable    ${tracker_result}    Lower
    ELSE
        Set Test Variable    ${tracker_result}    Higher
    END
    ${attribute_patient_value_input}    Replace Variables    ${attribute_patient_value_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_patient_value_input}    ${out_range_value}
    Scroll And Click Element Modal    ${tracker_save_btn}
    Page Alert Message    Lab Tracker Updated

Check Value Of Stautus Lab Tracker Modal
    Open Lab Tracker Ledger
    ${tracker_ledger_row}    Replace Variables    ${tracker_ledger_row}
    Scroll And Click Element    ${tracker_ledger_row}
    ${tracker_ledger_result}    Replace Variables    ${tracker_ledger_result}
    Wait Until Element Is Visible     ${tracker_ledger_result}
    ${tracker_ledger_result_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_result}
    Should Be Equal    ${tracker_ledger_result_txt}    ${tracker_result}
    Scroll And Click Element Modal    ${tracker_ledger_close_btn}
    ${tracker_ledger_status}    Replace Variables    ${tracker_ledger_status}
    Wait Until Element Is Visible     ${tracker_ledger_status}
    ${tracker_ledger_status_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_status}
    Should Contain    ${tracker_ledger_status_txt}    ABNORMAL

Verify Descirption Field Shows Multiple Medication Data
    ${lab_index}    Evaluate    int(${lab_index}) - 1
    ${drug_PO1}    Set Variable    ${PatientData.drug_PO2}
    Set Test Variable    ${lab_index}
    Set Test Variable    ${drug_PO1}
    ${protocol_show_view_btn}    Util.Replace Xpath    ${protocol_show_view_btn}
    Scroll And Click Element Modal    ${protocol_show_view_btn}
    Wait Until Element Is Visible    ${protocol_select_tool_title}    30s
    ${assign_lab_checkbox}    Replace Variables    ${protocol_assign_lab_checkbox}
    Scroll And Click Element Modal    ${assign_lab_checkbox}
    Page Alert Message    Lab has been assigned.
    Scroll And Click Element    ${protocol_close_btn}
    Navigate to Patient by Generated MRN
    Open Lab Tracker Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${PatientData.drug_PO1}
    ${description_txt1}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Wait Until Keyword Succeeds    30    1   Clear Input Field Until Empty    ${tracker_description}
    Input Lab Descirption Lab Tracker Modal    ${assign_lab_txt}    ${PatientData.drug_PO2}
    ${description_txt2}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Should Be Equal    ${description_txt1}    ${assign_lab_txt} (${PatientData.drug_PO1})
    Should Be Equal    ${description_txt2}    ${assign_lab_txt} (${PatientData.drug_PO2})

Select Lab In PO
    Scroll And Click Element Modal    ${PO_show_quick_view_btn}
    Wait Until Element Is Visible    ${protocol_select_tool_title}    30s
    ${lab_index}    Get Variable Value    ${lab_index}    1
    ${lab_tr}    Get Variable Value    ${lab_tr}    1
    IF    "${lab_index}" == "4"
        ${lab_index}    Set Variable    1
        ${new_lab_tr}    Evaluate    int(${lab_tr}) + 1
        Set Suite Variable    ${lab_tr}    ${new_lab_tr}
    END
    ${PO_assign_lab_checkbox}    Replace Variables    ${PO_lab_checkbox}
    Sleep    2s
    Scroll And Click Element Modal    ${PO_assign_lab_checkbox}
    Page Alert Message    Lab has been assigned.
    ${assign_lab_strong}    Replace Variables    ${PO_assign_lab_strong}
    Wait Until Element Is Visible    ${assign_lab_strong}    30s
    Scroll Element Into View    ${assign_lab_strong}
    ${assign_lab_txt}    Get Text    ${assign_lab_strong}
    ${assign_lab_txt}    Evaluate    """${assign_lab_txt}""".rpartition('(')[0].rstrip() if '(' in """${assign_lab_txt}""" else """${assign_lab_txt}"""
    ${new_lab_index}    Evaluate    int(${lab_index}) + 1
    Set Test Variable    ${assign_lab_txt}
    Set Suite Variable    ${lab_tr}
    Set Suite Variable    ${lab_index}    ${new_lab_index}

Check Labs Related To Provider Orders Table Displays All The Labs Of The PO
    [Arguments]    ${PO_num}
    Open Lab Tracker Tab
    ${tracker_PO_description}    Replace Variables    ${tracker_PO_description}
    Wait Until Element Is Visible    ${tracker_PO_description}    30s
    @{tracker_PO_description}    Get WebElements    ${tracker_PO_description}
    FOR    ${lab}    IN    @{tracker_PO_description}
        ${lab_txt}    Get Text    ${lab}
        Should Contain    ${assign_lab_list}    ${lab_txt}
    END

Assign Multiple Labs For Medication
    [Arguments]    ${lab_num}    ${drug_arg}
    Open Protocol Management Modal
    Show Medication's Required Labs    ${drug_arg}
    Remove Lab Descirption Abiraterone Assigned Labs
    Scroll And Click Element    ${protocol_close_btn}
    @{assign_lab_list}   Create List
    FOR    ${loops}    IN RANGE    ${lab_num}
        Open Protocol Management Modal
        Show Medication's Required Labs    ${drug_arg}
        Select Lab Descirption In Quick Select Tool Table    ${True}
        Scroll And Click Element    ${protocol_close_btn}
        Navigate to Patient by Generated MRN
        Open Lab Tracker Tab
        Create Fake Data List
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_add_lab_btn}
        Get DateTime In Lab Tracker
        Input All Fields In Lab Tracker Modal
        ...    account_arg=${PatientData.Location}    name_arg=${PatientData.MRN}    lab_des_arg=${assign_lab_txt}
        ...    payer_arg=${PatientData.lab_payer}    physician_arg=${PatientData.referring_NPI_PO}    start_date_arg=${start_date}    
        ...    end_date_arg=${end_date}    result_date_arg=${result_date}    file_arg=${Fake_dict.num_rand}    
        ...    ICD10_arg=${PatientData.icd10_code}    btn_arg=${tracker_save_btn}    msg=Lab Tracker Created
        Append To List    ${assign_lab_list}    ${assign_lab_txt}
        Set Test Variable    ${assign_lab_list}
    END

Verify Blank Information Lab Is Removed When The Lab Is Unassigned From PO
    Open Provider Orders tab
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    Select Lab In PO
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${True}    ${True}
    Open Provider Orders tab
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    ${PO_assign_lab_input}    Replace Variables    ${PO_assign_lab_input}
    Scroll And Click Element Modal    ${PO_assign_lab_input}
    Page Alert Message    Lab has been updated.
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_PO_description}    ${assign_lab_txt}    ${False}    ${False}

Verify Updated Information Lab Is Removed When The Lab Is Unassigned From PO
    Open Provider Orders tab
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    Set Test Variable    ${assign_lab_txt}    ${assign_lab_list[0]}
    ${PO_assign_lab_input}    Replace Variables    ${PO_assign_lab_input}
    Scroll And Click Element Modal    ${PO_assign_lab_input}
    Page Alert Message    Lab has been updated.
    Scroll And Click Element    ${PO_modal_close_btn}
    Check Lab Row Is Visible In Lab Tracker Modal    ${tracker_unrelated_description}    ${assign_lab_txt}    ${True}    ${False}

Check Lab Row Is Visible In Lab Tracker Modal
    [Arguments]    ${tracker_description_arg}    ${lab_expect}    ${equal_status}    ${reorder_btn}
    Reload Page
    Open Lab Tracker Tab
    ${tracker_description_arg}    Replace Variables    ${tracker_description_arg}
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tracker_description_arg}    5s
    Should Be Equal    ${check}    ${equal_status}
    IF    "${check}" == "${True}" and "${reorder_btn}" == "${True}"
        ${tracker_PO_reorder_btn}    Replace Variables    ${tracker_PO_reorder_btn}
        Wait Until Element Is Visible    ${tracker_PO_reorder_btn}    30s
    END

Mouse Hover Element
    [Arguments]    ${locator}    ${other_locator}    ${tooltip}
    FOR    ${i}    IN RANGE    10
        Scroll Element Into View    ${locator}
        Mouse Over    ${locator}
        ${check_toolip}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tooltip}    2s
        IF    "${check_toolip}" == "${False}"
            Mouse Over    ${other_locator}
            Mouse Hover Element    ${locator}    ${other_locator}    ${tooltip}
        ELSE IF    "${check_toolip}" == "${True}"
            Exit For Loop
        END
    END

Get Treatment Drug For PO
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Scroll And Click Element    ${create_PO_btn}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon_i}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon_i}    5s
    Get Treatment Drug
    Scroll And Click Element    ${PO_modal_close_btn}

Get Treatment Drug
    ${index}    Get Variable Value    ${index}    1
    ${treatment_xpath}    Set Variable    (//select[@id="PrimaryMedication"]//following::option)[${index}]
    ${treatment_txt}    Wait Until Keyword Succeeds    10s    1s    Get Text    ${treatment_xpath}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index   ${med_select}    ${index}
    Sleep    2s
    ${diagnosis_txt}    Get Text    ${PO_diagnosis_txt}
    ${new_index}    Evaluate    int(${index}) + 1
    Set Suite Variable    ${index}    ${new_index}
    IF    '${diagnosis_txt}' == 'No ICD Codes Available' or '${treatment_txt}' == '${PatientData.drug_PO}' or '${treatment_txt}' == '${PatientData.drug_PO1}' or '${treatment_txt}' == '${PatientData.drug_PO2}'
        ${med_xpath}    Get Treatment Drug
    END
    Set Test Variable    ${treatment_txt}

Update All Fields In Lab Order
    [Arguments]    ${btn_arg}    ${msg}
    ${reorder_yes_checkbox}    Replace Variables    ${reorder_yes_checkbox}
    Set Test Variable    ${reorder_yes_checkbox}    ${reorder_yes_checkbox}
    ${reorder_no_checkbox}    Replace Variables    ${reorder_no_checkbox}
    Set Test Variable    ${reorder_no_checkbox}    ${reorder_no_checkbox}
    ${reorder_fasting_checkbox}    Replace Variables    ${reorder_fasting_checkbox}
    Set Test Variable    ${reorder_fasting_checkbox}    ${reorder_fasting_checkbox}
    ${reorder_lab_company_select}    Replace Variables    ${reorder_lab_company_select}
    Set Test Variable    ${reorder_lab_company_select}    ${reorder_lab_company_select}
    ${reorder_frequency_value}    Replace Variables    ${reorder_frequency_value}
    Set Test Variable    ${reorder_frequency_value}    ${reorder_frequency_value}
    ${reorder_frequency_select}    Replace Variables    ${reorder_frequency_select}
    Set Test Variable    ${reorder_frequency_select}    ${reorder_frequency_select}
    ${reorder_diagnosis_input}    Replace Variables    ${reorder_diagnosis_input}
    Set Test Variable    ${reorder_diagnosis_input}    ${reorder_diagnosis_input}
    ${reorder_add_btn}    Replace Variables    ${reorder_add_btn}
    Set Test Variable    ${reorder_add_btn}    ${reorder_add_btn}
    ${reorder_save_btn}     Replace Variables    ${reorder_save_btn}
    Set Test Variable    ${reorder_save_btn}    ${reorder_save_btn}
    ${tracker_PO_reorder_btn}    Replace Variables    ${tracker_PO_reorder_btn}
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    Input Date Time Lab Order
    ${stat}    Create List    ${reorder_yes_checkbox}    ${reorder_no_checkbox}
    ${random_checkbox}    Evaluate    random.choice(${stat})
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${random_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${reorder_fasting_checkbox}
    Select From List By Index    ${reorder_lab_company_select}    1
    Change Value Select Until Not Be Equal Old Value    ${reorder_frequency_value}    ${reorder_frequency_select}    reorder_frequency_value     reorder_frequency_select
    Scroll Element Into View    ${reorder_diagnosis_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${reorder_diagnosis_input}    ${PatientData.icd10_code}[icd10_code1]
    Scroll And Click Element    ${reorder_add_btn}
    IF    "${btn_arg}" == "${reorder_save_btn}"
        Scroll And Click Element Modal    ${reorder_save_btn}
        Page Alert Message    ${msg}
    END

Change Value Select Until Not Be Equal Old Value
    [Arguments]    ${frequency_value_xpath}    ${frequency_select_xpath}    ${frequency_value_name}    ${frequency_select_name}
    ${frequency_value_compare}    Get Selected List Label    ${frequency_value_xpath}
    ${frequency_select_compare}    Get Selected List Label    ${frequency_select_xpath}
    Util.Select Random From List Regression    xpath_arg=${frequency_value_xpath}    var_name=${frequency_value_name}    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${frequency_select_xpath}    var_name=${frequency_select_name}    dic=${TempData}
    ${check_frequency_value}    Run Keyword And Return Status    Should Not Be Equal    ${frequency_value_compare}    ${TempData.${frequency_value_name}}
    ${check_frequency_select}    Run Keyword And Return Status    Should Not Be Equal    ${frequency_select_compare}    ${TempData.${frequency_select_name}}
    IF    "${check_frequency_value}" == "${False}" or "${check_frequency_select}" == "${False}"
        Change Value Select Until Not Be Equal Old Value    ${frequency_value_xpath}    ${frequency_select_xpath}    ${frequency_value_name}    ${frequency_select_name}
    END

Input Date Time Lab Order
    ${reorder_startdate}    Replace Variables    ${reorder_startdate}
    Set Test Variable    ${reorder_startdate}    ${reorder_startdate}
    ${reorder_resultdate}    Replace Variables    ${reorder_resultdate}
    Set Test Variable    ${reorder_resultdate}    ${reorder_resultdate}
    Get DateTime In Lab Tracker
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${reorder_startdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${reorder_startdate}    ${start_date}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${reorder_resultdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${reorder_resultdate}    ${result_date}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}

All Columns In Lab Tracker Related Show Correct Data
    Open Lab Tracker Tab
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    ${current_day}    Add Time To Date    ${current_day}    1 day    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${remain_date}    Subtract Date From Date    ${tracker_expdate_value}    ${current_day}    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    IF    "${remain_date}" == "1 day"
        Set Test Variable    ${remain_date}    ${remain_date}s
    END
    ${result_date}    Convert Date    ${result_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${tracker_expdate_value}    Convert Date    ${tracker_expdate_value}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${start_date}    Convert Date    ${start_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${end_date}    Convert Date    ${end_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y

    ${column_list}    Create List    ${tracker_row_day_ramain}    ${tracker_row_resultdate}    ${tracker_row_expdate}    ${tracker_row_orderdate}    ${tracker_row_nextapt}    ${tracker_row_description}    ${tracker_row_labcode}    ${tracker_row_status}    ${tracker_row_orderenddate}    ${tracker_row_filenum}
    ${lab_value_list}    Create List    ${remain_date}    ${result_date}    ${tracker_expdate_value}    ${start_date}    Not Scheduled    ${assign_lab_txt}    ${assign_emr_lab}    ${TempData.tracker_status_select}    ${end_date}    ${TempData.file_num}
    FOR    ${column}    ${lab_value}    IN ZIP    ${column_list}    ${lab_value_list}
        ${column}    Replace Variables    ${column}
        Wait Until Element Is Visible    ${column}    30s
        ${column_txt}    Get Text    ${column}
        Should Be Equal    ${column_txt.lower()}    ${lab_value.lower()}
    END

Verify The Reorder Lab Will Close When Clicking Cancel Button
    ${tracker_PO_reorder_btn}    Replace Variables    ${tracker_PO_reorder_btn}
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    ${lab_order_title}    Replace Variables    //h4[contains(text(),'Create Lab Order For: ${assign_lab_txt}')]
    Wait Until Element Is Visible    ${lab_order_title}    30s
    ${reorder_cancel_btn}    Replace Variables    ${reorder_cancel_btn}
    Scroll And Click Element Modal    ${reorder_cancel_btn}
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    ${reorder_save_btn}    Replace Variables    ${reorder_save_btn}
    Scroll And Click Element Modal    ${reorder_save_btn}
    Page Alert Message    The Order Start Date field is required.

Verify Date Input In Lab Order
    ${reorder_startdate}    Replace Variables    ${reorder_startdate}
    ${reorder_resultdate}    Replace Variables    ${reorder_resultdate}
    ${reorder_expdate}    Replace Variables    ${reorder_expdate}
    Get DateTime In Lab Tracker
    ${input_list}    Create List    ${reorder_startdate}    ${reorder_resultdate}
    ${date_value_list}    Create List    ${start_date}    ${result_date}
    ${reorder_expdate_disable}    SeleniumLibrary.Get Element Attribute    ${reorder_expdate}    disable
    ${reorder_expdate_txt}    Get Value    ${reorder_expdate}
    Should Be Equal    ${reorder_expdate_txt}    ${EMPTY}
    FOR    ${input_element}    ${date_value}    IN ZIP    ${input_list}    ${date_value_list}    
        ${input_element}    Replace Variables    ${input_element}
        ${input_element_txt}    Get Value    ${input_element}
        Should Be Equal    ${input_element_txt}    ${EMPTY}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${input_element}    ${date_value}
        Wait Until Element Is Visible    //div[contains(@id,'datepicker')]    30s
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${tracker_datepicker_done_btn}
        IF    "${input_element}" == "${reorder_resultdate}"
            ${reorder_expdate_txt}    Get Value    ${reorder_expdate}
            Should Be Equal    ${reorder_expdate_txt}    ${date_value}
        END
    END
    ${reorder_frequency_value}    Replace Variables    ${reorder_frequency_value}
    ${reorder_frequency_select}    Replace Variables    ${reorder_frequency_select}
    Util.Select Random From List Regression    xpath_arg=${reorder_frequency_value}    var_name=reorder_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${reorder_frequency_select}    var_name=reorder_frequency_select    dic=${TempData}
    Check Value Expiration Date    ${reorder_frequency_value}    ${reorder_frequency_select}    ${reorder_resultdate}    ${reorder_expdate}
    Mouse Hover Element    ${reorder_expdate}    ${reorder_resultdate}    ${tracker_expdate_tooltip}
    ${reorder_expdate_txt}    Get Value    ${reorder_expdate}
    Set Test Variable    ${reorder_expdate_txt}

Verify Checkbox In Lab Order
    ${reorder_yes_checkbox}    Replace Variables    ${reorder_yes_checkbox}
    ${reorder_no_checkbox}    Replace Variables    ${reorder_no_checkbox}
    ${reorder_fasting_checkbox}    Replace Variables    ${reorder_fasting_checkbox}
    ${checkbox_list}    Create List    ${reorder_yes_checkbox}    ${reorder_no_checkbox}    ${reorder_fasting_checkbox}
    FOR    ${checkbox_element}    IN    @{checkbox_list}
        Checkbox Should Not Be Selected    ${checkbox_element}
        ${checkbox_atrribute}    SeleniumLibrary.Get Element Attribute    ${checkbox_element}    type
        Should Be Equal    ${checkbox_atrribute}    checkbox
        Wait Until Keyword Succeeds    30s    1s    Click Element     ${checkbox_element}
        Checkbox Should Be Selected    ${checkbox_element}
    END

Verify Select In Lab Order
    ${reorder_lab_company_select}    Replace Variables    ${reorder_lab_company_select}
    ${reorder_frequency_value}    Replace Variables    ${reorder_frequency_value}
    ${reorder_frequency_select}    Replace Variables    ${reorder_frequency_select}
    ${lab_company_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_lab_company_select}
    ${lab_company_expect}    Create List    -- Select a Lab Company --    Lab Corp    Other    Quest
    Lists Should Be Equal    ${lab_company_list}    ${lab_company_expect}
    ${reorder_frequency_value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_frequency_value}
    ${actual_list}    Evaluate    [int(i) for i in ${reorder_frequency_value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 91))
    Should Be Equal    ${reorder_frequency_value_list[0]}    -
    Lists Should Be Equal    ${actual_list}    ${expected_list}
    ${reorder_frequency_selectlist}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_frequency_select}
    ${expected_list}    Create List    -    Min(s)    Hour(s)    Day(s)    Week(s)    Month(s)    Year(s)
    Lists Should Be Equal    ${reorder_frequency_selectlist}    ${expected_list}

Verify Dianoses Input In Lab Order
    ${reorder_diagnosis_input}    Replace Variables    ${reorder_diagnosis_input}
    ${reorder_add_btn}    Replace Variables    ${reorder_add_btn}
    ${icd_dict}    Get From Dictionary    ${PatientData}    icd10_code
    FOR    ${diagnose_value}    IN    @{icd_dict.values()}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${reorder_diagnosis_input}    ${diagnose_value}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${reorder_add_btn}
    END
    Set Test Variable    ${order_primary_dianose}    ${PatientData.icd10_code}[icd10_code1]
    ${order_additional_dianose}    Create List    ${PatientData.icd10_code}[icd10_code2]    ${PatientData.icd10_code}[icd10_code3]
    Set Test Variable    ${order_additional_dianose}

Verify Result Date And Expiration Date Display In Corresponding Column And Update Lab Tracker Popup
    Reload Page
    Open Lab Tracker Tab
    ${result_date}    Convert Date    ${result_date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${reorder_expdate_txt}    Convert Date    ${reorder_expdate_txt}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${tracker_row_resultdate}    Replace Variables    ${tracker_row_resultdate}
    ${tracker_row_expdate}    Replace Variables    ${tracker_row_expdate}
    ${lab_value_list}    Create List    ${result_date}    ${reorder_expdate_txt}
    ${column_list}    Create List    ${tracker_row_resultdate}    ${tracker_row_expdate}
    ${tracker_input_list}    Create List    ${tracker_resultdate_input}    ${tracker_expdate_input}
    FOR    ${column}    ${lab_value}    IN ZIP    ${column_list}    ${lab_value_list}
        ${column}    Replace Variables    ${column}
        Wait Until Element Is Visible    ${column}    30s
        ${column_txt}    Get Text    ${column}
        Should Be Equal    ${column_txt}    ${lab_value}
    END
    ${tracker_PO_description}    Replace Variables    ${tracker_PO_description}
    Scroll And Click Element    ${tracker_PO_description}
    Wait Until Element Is Visible    ${tracker_lab_attribute_title}    30s
        FOR    ${tracker_input}    ${lab_value}    IN ZIP    ${tracker_input_list}    ${lab_value_list}
        ${tracker_input}    Replace Variables    ${tracker_input}
        Wait Until Element Is Visible    ${tracker_input}    30s
        ${tracker_input_txt}    Get Value    ${tracker_input}
        Should Be Equal    ${tracker_input_txt}    ${lab_value}
    END

Verify The Primary ICD 10 Code list And Additional ICD10 Codes Shows Correct Data
    ${primary_ICD10_txt}    Get Text    ${tracker_primary_ICD10_list}
    ${additional_ICD10_txt}    Get Text    ${tracker_additional_ICD10_list}
    Should Be Equal    ${primary_ICD10_txt}    ${order_primary_dianose}
    Lists Should Be Equal    ${order_additional_dianose}    ${additional_ICD10_txt.split()}

Get Lab Frequency In PO
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Element Is Visible    ${PO_lab_frequency_value}    30s
    Scroll Element Into View    ${PO_lab_frequency_value}
    ${PO_lab_frequency_value_txt}    Get Selected List Label    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select_txt}    Get Selected List Label    ${PO_lab_frequency_select}
    Set Test Variable    ${PO_lab_frequency_value_txt}
    Set Test Variable    ${PO_lab_frequency_select_txt}
    Scroll And Click Element    ${PO_modal_close_btn}

Change Frequency Lab Value In Provider Order
    Open Provider Orders tab
    ${PO_row_edit_btn}    Util.Replace Xpath    ${PO_row_edit_btn}
    Scroll And Click Element    ${PO_row_edit_btn}
    ${PO_lab_frequency_value}    Replace Variables    ${PO_lab_frequency_value}
    ${PO_lab_frequency_select}    Replace Variables    ${PO_lab_frequency_select}
    Wait Until Element Is Visible    ${PO_lab_frequency_value}    30s
    Scroll Element Into View    ${PO_lab_frequency_value}
    Util.Select Random From List Regression    xpath_arg=${PO_lab_frequency_value}    var_name=PO_lab_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${PO_lab_frequency_select}    var_name=PO_lab_frequency_select    dic=${TempData}
    Page Alert Message    Lab has been updated.
    Scroll And Click Element    ${PO_modal_close_btn}

Change Frequency Lab Value In Protocol Management
    Open Protocol Management Modal
    Show Medication's Required Labs    ${treatment_txt}
    Util.Select Random From List Regression    xpath_arg=${protocol_frequency_value}    var_name=protocol_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${protocol_frequency_select}    var_name=protocol_frequency_select    dic=${TempData}
    Page Alert Message    Lab has been updated.
    Scroll And Click Element    ${protocol_close_btn}

Check Frequency Value In Reorder Lab
    [Arguments]    ${frequency_value_compare}    ${frequency_select_compare}    ${status_compare}
    ${tracker_PO_reorder_btn}    Replace Variables    ${tracker_PO_reorder_btn}
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    ${reorder_frequency_value}    Replace Variables    ${reorder_frequency_value}
    ${reorder_frequency_select}    Replace Variables    ${reorder_frequency_select}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${reorder_frequency_value}    ${frequency_value_compare}    equal_status=${status_compare}
    Wait Until Keyword Succeeds    10s    1s    Check Selected Label    ${reorder_frequency_select}    ${frequency_select_compare}    equal_status=${status_compare}

Check Document Type Select Has Default Value
    ${option_count}    SeleniumLibrary.Get Element Count    ${document_option_default}
    IF    ${option_count} == 0
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    -- Add New Document Type --
        Wait Until Element Is Visible    ${document_custom_title}    30s
        Wait Until Keyword Succeeds    30s    1s    ${document_custom_type}    Testing
        Page Alert Message    Custom Document Type successfully added!
    END

Verify Add Document Form Is Visible
    Wait Until Element Is Visible    ${new_document_type_select}    30s
    Wait Until Element Is Visible    ${new_document_description_textarea}    30s
    Wait Until Element Is Visible    ${new_document_date_input}    30s
    Wait Until Element Is Visible    ${new_document_file_input}    30s
    Wait Until Element Is Visible    ${new_document_add_btn}    30s
    Wait Until Element Is Visible    ${new_document_cancel_btn}    30s

Verify Documents Tab Is Displayed Successfully With All Visible Elements
    Wait Until Element Is Visible    ${document_patient_label}    30s
    Wait Until Element Is Visible    ${document_dob_label}    30s
    Wait Until Element Is Visible    ${document_mrn_label}    30s
    Wait Until Element Is Visible    ${document_type_label}    30s
    Wait Until Element Is Visible    ${document_type_select}    30s
    Wait Until Element Is Visible    ${document_criteria_search}    30s
    Wait Until Element Is Visible    ${document_startdate_input}    30s
    Wait Until Element Is Visible    ${document_enddate_input}    30s
    Wait Until Element Is Visible    ${document_find_btn}    30s
    Wait Until Element Is Visible    ${document_clear_btn}    30s
    Wait Until Element Is Visible    ${document_show_archived_checkbox}    30s
    Wait Until Element Is Visible    ${document_add_btn}    30s
    Wait Until Element Is Visible    ${document_frame}    30s

Create New Document
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s
    Scroll Element Into View    ${new_document_add_btn}
    Verify Add Document Form Is Visible
    Select Document Type
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_description_textarea}    ${Fake_dict.sentence_str}
    Get Document Date
    Choose Document File
    Scroll And Click Element    ${new_document_add_btn}
    Handle Alert    ACCEPT
    Page Alert Message    File Successfully Uploaded!

Select Document Type
    Util.Select Random From List Regression    xpath_arg=${new_document_type_select}    var_name=new_document_type_select    dic=${TempData}
    ${check_medication_select}    Run Keyword And Return Status    Wait Until Element Is Visible    ${new_document_medication_select}    2s
    IF    "${check_medication_select}" == "${True}"
        Select Document Type
    END

Search New Document
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${new_document_row}    Replace Variables    ${new_document_row}
    Wait Until Element Is Visible    ${new_document_row}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    ${TempData.new_document_type_select}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${document_criteria_search}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${document_startdate_input}    ${start_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //span[@id="DocumentViewerMessage"]//parent::div
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${document_enddate_input}    ${end_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //span[@id="DocumentViewerMessage"]//parent::div
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_find_btn}

Clear All Fields Successfully In Document Tab
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_clear_btn}
    ${document_criteria_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_criteria_search}
    ${document_startdate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_startdate_input}
    ${document_enddate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_enddate_input}
    Should Be Equal    ${document_criteria_value}    ${EMPTY}
    Should Be Equal    ${document_startdate_value}    ${EMPTY}
    Should Be Equal    ${document_enddate_value}    ${EMPTY}

Edit New Document
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${document_plus_icon}    Replace Variables    ${document_plus_icon}
    ${edit_icon}    Replace Variables    ${new_document_edit_icon}
    Scroll And Click Element    ${document_plus_icon}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_icon}
    Wait Until Element Is Visible    ${document_edit_title}    30s
    Create Fake Data List
    Select Document Type
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_description_textarea}    ${Fake_dict.sentence_str}
    Get Document Date
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_save_doc_btn}
    Handle Alert    ACCEPT
    Page Alert Message    Document Successfully Saved!
    
Delete New Document
    Scroll And Click Element    ${document_clear_btn}
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${new_document_row}    Replace Variables    ${new_document_row}
    ${edit_icon}    Replace Variables    ${new_document_edit_icon}
    ${check_document_row_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${new_document_row}    5s
    IF    "${check_document_row_visible}" == "${True}"
        Scroll And Click Element    ${new_document_row}
        Wait Until Element Is Visible    ${edit_icon}    30s
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_icon}
        Wait Until Element Is Visible    ${document_edit_title}    30s
        Scroll And Click Element    ${document_del_btn}
        Handle Alert    ACCEPT
        Page Alert Message    Document Deleted Successfully!
    END

Get Document Date
    ${start_date}    Get Current Date    result_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${start_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_date_input}    ${start_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //span[@id="DocumentViewerMessage"]//parent::div
    Set Test Variable    ${start_date}
    Set Test Variable    ${end_date}

Choose Document File
    Create Fake Folder    folder_path=${CURDIR}/../../../results/export/fake_folder
    ${base}         Normalize Path    ${CURDIR}/../../..
    ${target}       Join Path         ${base}    results    export    fake_folder    dummy.txt
    Choose Fake Folder    folder_path=${target}
    
Create Fake Folder
    [Arguments]    ${folder_path}
    Create Directory    ${folder_path}
    ${content_file}=    Evaluate    'Testing ' * int(100)
    Create File    ${folder_path}/dummy.txt    ${content_file}
    Set Test Variable    ${content_file}

Choose Fake Folder
    [Arguments]    ${folder_path}
    Choose File    ${new_document_file_input}    ${folder_path}

Delete Fake Folder
    [Arguments]    ${folder_path}
    ${check_folder_isvisible}    Run Keyword And Return Status    Directory Should Exist    ${folder_path}
    IF    "${check_folder_isvisible}" == "${True}"
        Remove Directory    ${folder_path}    recursive=True
    END

Verify Patient ID Is Displayed Correctly In Document Tab
    Wait Until Element Is Visible    ${document_patient_label}    30s
    ${patient_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_patient_label}
    Should Contain    ${patient_label_txt}    ${PatientData.Last_Name}, ${PatientData.First_Name} ${PatientData.Middle_Name}
    
Verify DOB Is Displayed Correctly In Document Tab
    Wait Until Element Is Visible    ${document_dob_label}    30s
    ${dob_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_dob_label}
    Should Contain    ${dob_label_txt}    ${PatientData.DOB}
    
Verify MRN Is Displayed Correctly In Document Tab
    Wait Until Element Is Visible    ${document_mrn_label}    30s
    ${mrn_label_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_mrn_label}
    Should Contain    ${mrn_label_txt}    ${PatientData.MRN}
    
Verify Search Successfully With Document Type In Document Tab
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${new_document_row}    Replace Variables    ${new_document_row}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    ${TempData.new_document_type_select}
    Wait Until Element Is Visible    ${new_document_row}    30s

Verify Search Successfully When Entering Search Critiria In Document Tab
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${new_document_description_row}    Replace Variables    ${new_document_description_row}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${document_type_select}    -- All Types --
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${document_criteria_search}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_find_btn}    
    Wait Until Element Is Visible    ${new_document_description_row}    30s

Enter Date Range In Document Tab
    ${from_date}    Convert Date    ${start_date}    date_format=%m/%d/%Y    result_format=%#d
    ${to_date}    Convert Date    ${end_date}    date_format=%m/%d/%Y    result_format=%#d
    ${doc_date}    Set Variable    ${from_date}
    ${from_datepicker}    Replace Variables    ${document_datepicker}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_startdate_input}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${from_datepicker}
    ${doc_date}    Set Variable    ${to_date}
    ${to_datepicker}    Replace Variables    ${document_datepicker}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_enddate_input}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${to_datepicker}
    ${from_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_startdate_input}
    Should Be Equal    ${from_date_txt}    ${start_date}
    ${to_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${document_enddate_input}
    Should Be Equal    ${to_date_txt}    ${end_date}

Archive Or Un-Archive New Document
    [Arguments]    ${msg}
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${new_document_row}    Replace Variables    ${new_document_row}
    Set Test Variable    ${new_document_row}
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${archive_icon}    Replace Variables    ${new_document_archive_icon}
    Wait Until Element Is Visible    ${new_document_row}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${new_document_row}
    Scroll And Click Element    ${archive_icon}
    Wait Until Element Is Visible    ${new_document_confirm_title}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_yes_btn}
    Page Alert Message    ${msg}

Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar
    [Arguments]    ${attribute_status}
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${doc_type}    Fetch From Left   ${doc_type}    \ \
    ${new_document_blue_bar}    Replace Variables    ${new_document_blue_bar}
    ${new_document_blue_bar_attribute}    SeleniumLibrary.Get Element Attribute    ${new_document_blue_bar}    aria-expanded
    Should Be Equal    ${new_document_blue_bar_attribute}    ${attribute_status}

Verify New Document From List Displays With All Element When Expand
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${document_plus_icon}    Replace Variables    ${document_plus_icon}
    Scroll And Click Element    ${document_plus_icon}
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${element_list}    Create List    ${new_document_show_icon}    ${new_document_description_row}    ${new_document_date_txt}    ${new_document_upload_txt}    ${new_document_archive_icon}    ${new_document_edit_icon}    ${new_document_fax_icon}
    FOR    ${element}    IN    @{element_list}
        ${element}    Replace Variables    ${element}
        Wait Until Element Is Visible    ${element}    30s
    END
    ${new_document_date_txt}    Replace Variables    ${new_document_date_txt}
    ${new_document_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${new_document_date_txt}
    Should Contain    ${new_document_date_txt}    ${start_date}
    Get User Name
    ${new_document_upload_txt}    Replace Variables    ${new_document_upload_txt}
    ${current_day}    Get Current Date    result_format=%m/%d/%Y
    ${new_document_upload_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${new_document_upload_txt}
    Should Contain    ${new_document_upload_txt}    ${current_day}
    Should Contain    ${new_document_upload_txt}    ${user_name_txt}
    
Show Document Successfully In Frame Document
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${new_document_show_icon}    Replace Variables    ${new_document_show_icon}
    Scroll And Click Element    ${new_document_show_icon}
    ${document_description_title}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${document_description_title}
    Should Be Equal    ${document_description_title}    ${doc_description}
    Get Content From Frame Document

Get Content From Frame Document
    ${iframe_src}    SeleniumLibrary.Get Element Attribute    ${new_document_frame}    src
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    Check Newsletter
    Go To    ${iframe_src}
    ${iframe_txt}    Get Text    //pre
    Should Be Equal    ${iframe_txt}    ${content_file}
    Close Window
    Switch To Another Window    title_arg=Update Patient

Edit Document Unsuccessfully
    [Arguments]    ${element_arg}    ${msg}
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${doc_description}    Set Variable    ${Fake_dict.sentence_str}
    ${document_plus_icon}    Replace Variables    ${document_plus_icon}
    ${edit_icon}    Replace Variables    ${new_document_edit_icon}
    Scroll And Click Element    ${document_plus_icon}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_icon}
    Wait Until Element Is Visible    ${document_edit_title}    30s
    Clear Input Field Until Empty    ${element_arg}
    IF    "${msg}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${element_arg}    ${Fake_dict.num_rand}
        Wait Until Keyword Succeeds    30s    1s    Click Element    //span[@id="DocumentViewerMessage"]//parent::div
        Scroll And Click Element    ${document_save_doc_btn}
        Handle Alert    ACCEPT
    ELSE    
        Wait Until Keyword Succeeds    30s    1s    Click Element    //span[@id="DocumentViewerMessage"]//parent::div
        Scroll And Click Element    ${document_save_doc_btn}
    END
    ${alert_text}    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_text}    ${msg}

Open Allergies Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${allergies_tab}
    Scroll And Click Element    ${allergies_tab}
    Wait Until Element Is Visible    ${allergies_new_btn}    30s
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    5s

Add New Allergy
    [Arguments]    ${onset_date_arg}    ${allergies_detail_arg}    ${msg}
    Scroll And Click Element    ${allergies_new_btn}
    Wait Until Element Is Visible    ${allergies_type_title}    30s
    Select Allergy Type Without Unknown Allergy
    Select An Allergy Description
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_onset_date_input}    ${onset_date_arg}
    Wait Until Element Is Visible    ${date_picker_table}    30s
    Scroll And Click Element    ${Close_Calendar_Btn}
    Util.Select Random From List Regression    xpath_arg=${allergies_severity_select}    var_name=allergies_severity_select    dic=${PatientData}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_detail_textarea}    ${allergies_detail_arg}
    Scroll And Click Element    ${allergies_add_btn}
    Page Alert Message    ${msg}

Select An Allergy Description
    Sleep    2s
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    Util.Select Random From List Regression    xpath_arg=${allergies_description_select}    var_name=allergies_description_select    dic=${PatientData}
    IF    "${PatientData.allergies_description_select}" == "[Add New Allergy]"
        Wait Until Element Is Visible    ${allergies_create_allergy_title}    30s
        Scroll And Click Element    ${allergies_close_btn}
        Select An Allergy Description
    END
    
Verify All Fields Are Visible
    Wait Until Page Contains Element    ${allergies_type_select}    30s
    Wait Until Page Contains Element    ${allergies_description_select}    30s
    Wait Until Page Contains Element    ${allergies_onset_date_input}    30s
    Wait Until Page Contains Element    ${allergies_severity_select}    30s
    Wait Until Page Contains Element    ${allergies_detail_textarea}    30s

Verify All Fields Have Default Value
    ${allergies_status_default}    Get Selected List Label    ${allergies_status_select}
    Should Be Equal    ${allergies_status_default}    Viewing Active - Allergies Only
    ${allergies_type_default}    Get Selected List Label    ${allergies_type_select}
    Should Be Equal    ${allergies_type_default}    -- Select an Allergy Type --
    Verify Allergy Description Default Value
    ${allergies_onset_date_default}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_onset_date_input}
    Should Be Equal    ${allergies_onset_date_default}    ${EMPTY}
    ${allergies_severity_default}    Get Selected List Label    ${allergies_severity_select}
    Should Be Equal    ${allergies_severity_default}    -- Select the Severity of the Allergy --
    ${allergies_detail_default}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_detail_textarea}
    Should Be Equal    ${allergies_detail_default}    ${EMPTY}

Verify Allergy Description Default Value
    ${allergies_description_default}    Get Selected List Label    ${allergies_description_select}
    Should Be Equal    ${allergies_description_default}    -- Select an Allergy Type --
    Util.Select Random From List Regression    xpath_arg=${allergies_type_select}    var_name=allergies_type_select    dic=${PatientData}
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    ${allergies_description_default}    Get Selected List Label    ${allergies_description_select}
    Should Be Equal    ${allergies_description_default}    -- Select an Allergy --
    
Verify "Select an Allergy Type" Dropdown Has Correct Values
    ${dropdown_options}    Create List    -- Select an Allergy Type --    Medication Allergy    Food Allergy    Environmental Allergy    Unknown Allergy
    ${allergy_type_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergy_type_options}

Verify "Select an Allergy Description" Dropdown Has Correct Values
    Select Allergy Type Without Unknown Allergy
    Wait Until Element Is Not Visible    ${allergies_description_option_default}    30s
    ${allergies_description_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_description_select}
    ${lenght_total}    Get Length    ${allergies_type_select}
    Should Be True    ${lenght_total} > 2
    Should Contain    ${allergies_description_options}    [Add New Allergy]

Verify "Allergy Severity" Dropdown Has Correct Values
    ${dropdown_options}    Create List    -- Select the Severity of the Allergy --    Intolerant    Mild    Severe    Discomfort    Patient Preference
    ${allergy_type_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_severity_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergy_type_options}

Verify "Allergy Status" Dropdown Has Correct Values
    ${dropdown_options}    Create List    Viewing Active - Allergies Only    Viewing Inactive - Allergies Only    Viewing All Allergies
    ${allergies_status_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${allergies_status_select}
    Lists Should Be Equal    ${dropdown_options}    ${allergies_status_options}

Select Allergy Type Without Unknown Allergy
    Util.Select Random From List Regression    xpath_arg=${allergies_type_select}    var_name=allergies_type_select    dic=${PatientData}
    IF    "${PatientData.allergies_type_select}" == "Unknown Allergy"
        Select Allergy Type Without Unknown Allergy
    END

Verify System Prevents Duplicate Or Allergy Descriptions
    ${allergies_description_option_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${allergies_description_option}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_description_select}    [Add New Allergy]
    Wait Until Element Is Visible    ${allergies_create_allergy_title}    30s
    Scroll And Click Element    ${allergies_create_allergy_btn}
    Page Alert Message    You must enter an Allergy Description.
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_medication_input}    ${allergies_description_option_txt}
    Scroll And Click Element    ${allergies_create_allergy_btn}
    Page Alert Message    Allergy Already Exists.
    Scroll And Click Element    ${allergies_close_btn}

Verify New Allergy Is Visible In Allergies Table
    [Arguments]    ${column_value_list_arg}    ${allergies_row_arg}
    FOR    ${i}    IN RANGE    1    6
        Wait Until Element Is Visible    ${allergies_row_arg}//td[${i}]    30s
        ${column_txt}    Get Text    ${allergies_row_arg}//td[${i}]
        ${expected_value}    Set Variable    ${column_value_list_arg}[${i - 1}]
        Should Be Equal    ${column_txt}    ${expected_value}
    END

Inactive Allergy
    ${allergies_status_column_select}    Replace Variables    ${allergies_status_column_select}
    Wait Until Element Is Visible    ${allergies_status_column_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_column_select}    Deactivate Allergy
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${allergies_deactive_title}    5s
    IF    "${check}" == "${True}"
        Wait Until Element Is Visible    ${allergies_deactive_reason_select}    30s
        ${current_day}    Get Current Date    result_format=%m/%d/%Y
        FOR    ${i}    IN RANGE    10
            Util.Select Random From List Regression    xpath_arg=${allergies_deactive_reason_select}    var_name=allergies_deactive_reason_select    dic=${PatientData}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_deactive_date_input}    ${current_day}
            Scroll And Click Element    ${Close_Calendar_Btn}
            ${deactive_reason_select_txt}    Get Selected List Label    ${allergies_deactive_reason_select}
            ${allergies_deactive_date_txt}    Get Value    ${allergies_deactive_date_input}
            IF    '${deactive_reason_select_txt}' != '-- Select a Reason for Deactivating --' and '${allergies_deactive_date_txt}' != '${EMPTY}'
                Exit For Loop
            END
        END
        Scroll And Click Element    ${allergies_deactive_btn}
        Page Alert Message    Encounter Allergy Note Updated!
    END

Verify System Does Not Allow Reactivation
    Wait Until Element Is Visible    ${allergies_status_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_select}    Viewing Inactive - Allergies Only
    ${allergies_new_row}    Replace Variables    ${allergies_new_row}
    Wait Until Element Is Visible    ${allergies_new_row}    30s
    ${allergies_active_status_column_select}    Replace Variables    ${allergies_active_status_column_select}
    Wait Until Element Is Not Visible    ${allergies_active_status_column_select}    30s
    
Table Updates Both Active And Inactive Allergies When Filtering By Viewing All Allergies
    [Arguments]    ${allergy_active_detail_arg}    ${allergy_inactive_detail_arg}
    Wait Until Element Is Visible    ${allergies_status_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${allergies_status_select}    Viewing All Allergies
    ${allergy_detail_txt}    Set Variable    ${allergy_active_detail_arg}
    ${allergies_active_status_column_select}    Replace Variables    ${allergies_active_status_column_select}
    Wait Until Element Is Visible    ${allergies_active_status_column_select}    30s
    ${allergy_detail_txt}    Set Variable    ${allergy_inactive_detail_arg}
    ${allergies_deactive_status_column_select}    Replace Variables    ${allergies_deactive_status_column_select}
    Wait Until Element Is Visible    ${allergies_deactive_status_column_select}    30s
    
Edit Allergy And Updated Data Is Reflected In The Table 
    Create Fake Data List
    ${allergies_edit_icon}    Replace Variables    ${allergies_edit_icon}
    Wait Until Element Is Visible    ${allergies_edit_icon}    30s
    Scroll And Click Element    ${allergies_edit_icon}
    Wait Until Element Is Visible    ${allergies_additional_area}    30s
    Select Allergy Type Without Unknown Allergy
    Select An Allergy Description
    ${current_day}    Get Current Date    result_format=%#m/%#d/%Y
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_onset_date_input}    ${current_day}
    Wait Until Element Is Visible    ${date_picker_table}    30s
    Scroll And Click Element    ${Close_Calendar_Btn}
    Util.Select Random From List Regression    xpath_arg=${allergies_severity_select}    var_name=allergies_severity_select    dic=${PatientData}
    ${allergy_detail_txt}    Set Variable    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${allergies_detail_textarea}    ${allergy_detail_txt}
    Scroll And Click Element    ${allergies_add_btn}
    Page Alert Message    Encounter Note Allergy Updated!
    ${column_value_list}    Create List    ${PatientData.allergies_description_select}    ${PatientData.allergies_type_select}    ${PatientData.allergies_severity_select}    ${current_day}    ${Fake_dict.sentence_str}
    Set Test Variable    ${allergy_detail_txt}    ${Fake_dict.sentence_str}
    ${allergies_new_row}    Replace Variables    ${allergies_new_row}
    Verify New Allergy Is Visible In Allergies Table    column_value_list_arg=${column_value_list}    allergies_row_arg=${allergies_new_row}

Open Patient Payments Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${patient_payment_tab}
    Scroll And Click Element    ${patient_payment_tab}
    Wait Until Element Is Visible    ${payment_current_balance_title}    30s
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']    30s

Get Current Balance Amount
    Wait Until Element Is Visible    ${payment_current_balance_amount}    30s
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_current_balance_amount}
    ${current_balance_amount}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount}    Set Variable    ${current_balance_amount}[0]
    ${current_balance_amount}    Replace String    ${current_balance_amount}    ,    ${EMPTY}
    IF    '${current_balance_amount}' != '0.00'
        ${balance_color_style}    SeleniumLibrary.Get Element Attribute    ${payment_current_balance_amount}    style
        ${balance_color}    Get Regexp Matches    ${balance_color_style}    \\d+,\\s\\d+,\\s\\d+
        ${balance_color}    Set Variable    ${balance_color}[0]
        Set Test Variable    ${balance_color}
    ELSE
        Set Test Variable    ${balance_color}    none
    END
    Set Test Variable    ${current_balance_amount}

Calculate Current Balance Amount
    [Arguments]    ${status_arg}    ${amount_arg}    ${current_balance_amount_arg}
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${current_balance_amount_arg}
    ${current_balance_amount_txt}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount_txt}    Set Variable    ${current_balance_amount_txt}[0]
    ${current_balance_amount_txt}    Replace String    ${current_balance_amount_txt}    ,    ${EMPTY}
    Set Test Variable    ${current_balance_amount_txt}    
    ${amount_arg}    Evaluate    abs(${amount_arg})
    IF    '${balance_color}' == '71, 159, 118' or '${balance_color}' == 'none'    #green
        IF    "${status_arg}" == "increase"
            ${current_balance_increase}    Evaluate    round((${current_balance_amount} + ${amount_arg}),2)
            ${current_balance_increase}    Evaluate    abs(${current_balance_increase})
            ${current_balance_increase}    Evaluate    f"{${current_balance_increase}:.2f}"
            Set Test Variable    ${current_balance_increase}
            Should Be Equal As Strings    ${current_balance_increase}    ${current_balance_amount_txt}
        ELSE IF    "${status_arg}" == "decrease"
            ${current_balance_decrease}    Evaluate    round((${current_balance_amount} - ${amount_arg}),2)
            ${current_balance_decrease}    Evaluate    abs(${current_balance_decrease})
            ${current_balance_decrease}    Evaluate    f"{${current_balance_decrease}:.2f}"
            Set Test Variable    ${current_balance_decrease}
            Should Be Equal As Strings    ${current_balance_decrease}    ${current_balance_amount_txt}
        END
    ELSE IF    '${balance_color}' == '220, 53, 69'    #red
        IF    "${status_arg}" == "increase"
            ${current_balance_increase}    Evaluate    round((${current_balance_amount} - ${amount_arg}),2)
            ${current_balance_increase}    Evaluate    abs(${current_balance_increase})
            ${current_balance_increase}    Evaluate    f"{${current_balance_increase}:.2f}"
            Set Test Variable    ${current_balance_increase}
            Should Be Equal As Strings    ${current_balance_increase}    ${current_balance_amount_txt}
        ELSE IF    "${status_arg}" == "decrease"
            ${current_balance_decrease}    Evaluate    round((${current_balance_amount} + ${amount_arg}),2)
            ${current_balance_decrease}    Evaluate    abs(${current_balance_decrease})
            ${current_balance_decrease}    Evaluate    f"{${current_balance_decrease}:.2f}"
            Set Test Variable    ${current_balance_decrease}
            Should Be Equal As Strings    ${current_balance_decrease}    ${current_balance_amount_txt}
        END
    END

Add Charge
    [Arguments]    ${btn_arg}    ${msg}    ${charge_amount_value}    ${loop}    ${add_charge_btn_status}
    Scroll And Click Element    ${payment_add_charge_btn}
    Wait Until Element Is Visible    ${add_charge_title}    30s
    Check Current Balance Value In Modal    current_balance_arg=${add_charge_current_balance}
    Input Charge Modal    ${charge_amount_value}    ${loop}    ${add_charge_btn_status}    Add Charge
    IF    '${add_charge_btn_status}' == '${True}'
        Calculate Current Balance Amount    status_arg=decrease    amount_arg=${charge_amount_total}    current_balance_amount_arg=${add_charge_new_balance}
    END
    IF    '${btn_arg}' == '${add_charge_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Input Charge Modal
    [Arguments]    ${charge_amount_value}    ${loop}    ${add_charge_btn_status}    ${charge_status}
    ${charge_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        Import Variables    ${CURDIR}/../../PageObjects/Locators/Patient.py
        Create Fake Data List
        ${add_charge_amount_input}    Replace Variables    ${add_charge_amount_input}
        IF    '${charge_amount_value}' == '${None}'
            ${charge_amount_value}    Set Variable    ${Fake_dict.decimal_2d_2f}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_amount_input}    ${charge_amount_value}
        ELSE
            Clear Input Field Until Empty    ${add_charge_amount_input}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_amount_input}    ${charge_amount_value}
        END
        IF    '${charge_status}' == 'Add Charge'
            Util.Select Random From List Regression    xpath_arg=${add_charge_type_select}    var_name=add_charge_type_select    dic=${TempData}
        ELSE IF    '${charge_status}' == 'Edit Charge'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${edit_charge_type_select}    0
            Sleep    1s
            Util.Select Random From List Regression    xpath_arg=${edit_charge_type_select}    var_name=add_charge_type_select    dic=${TempData}
        END
        ${charge_reference_number_value}    Set Variable    ${Fake_dict.full_name_fake} ${Fake_dict.num_rand}
        ${add_charge_reference_number_input}    Replace Variables    ${add_charge_reference_number_input}
        Clear Input Field Until Empty    ${add_charge_reference_number_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_reference_number_input}    ${charge_reference_number_value}
        ${charge_transaction_date}    Get Current Date    result_format=%m/%d/%Y
        ${add_charge_transaction_date_input}    Replace Variables    ${add_charge_transaction_date_input}
        Clear Input Field Until Empty    ${add_charge_transaction_date_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_transaction_date_input}    ${charge_transaction_date}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
        IF    '${add_charge_btn_status}' == '${True}'
            IF    '${charge_status}' == 'Add Charge'
                Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_charge_btn}
                ${remove_charge_btn}    Replace Variables    ${remove_charge_btn}
                Wait Until Element Is Visible    ${remove_charge_btn}    30s
            END
        END
        Set To Dictionary    ${TempData}    charge_amount_value[${line}]=${charge_amount_value}
        Set To Dictionary    ${TempData}    add_charge_type_select[${line}]=${TempData.add_charge_type_select}
        Set To Dictionary    ${TempData}    charge_reference_number_value[${line}]=${charge_reference_number_value}
        Set To Dictionary    ${TempData}    charge_transaction_date[${line}]=${charge_transaction_date}
        ${charge_amount_total}    Evaluate    f"{(${charge_amount_total} + ${charge_amount_value}):.2f}"
        Set Test Variable    ${charge_amount_total}
    END

Edit Charge
    [Arguments]    ${btn_arg}    ${msg}    ${charge_amount_value}    ${loop}    ${add_charge_btn_status}
    Open Edit Transaction Modal    payment_type=Charge    row_value=${TempData['charge_reference_number_value[${loop}]']}
    Check Current Balance Value In Modal    current_balance_arg=${add_charge_current_balance}
    Input Charge Modal    ${charge_amount_value}    ${loop}    ${add_charge_btn_status}    Edit Charge
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${add_charge_new_balance}
    ${current_balance_amount_txt}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount_txt}    Set Variable    ${current_balance_amount_txt}[0]
    ${current_balance_amount_txt}    Replace String    ${current_balance_amount_txt}    ,    ${EMPTY}
    Set Test Variable    ${current_balance_amount_txt}  
    IF    '${btn_arg}' == '${add_charge_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Add Payment
    [Arguments]    ${btn_arg}    ${msg}    ${payment_amount_value}    ${loop}    ${add_payment_btn_status}
    Scroll And Click Element    ${payment_add_payment_btn}
    Wait Until Element Is Visible    ${add_payment_title}    30s
    Check Current Balance Value In Modal    current_balance_arg=${add_payment_current_balance}
    Input Payment Modal    ${payment_amount_value}    ${loop}    ${add_payment_btn_status}    Add Payment
    IF    '${add_payment_btn_status}' == '${True}'
        Calculate Current Balance Amount    status_arg=increase    amount_arg=${payment_amount_total}    current_balance_amount_arg=${add_payment_new_balance}
    END   
    IF    '${btn_arg}' == '${add_payment_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Input Payment Modal
    [Arguments]    ${payment_amount_value}    ${loop}    ${add_payment_btn_status}    ${payment_status}
    ${payment_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        Import Variables    ${CURDIR}/../../PageObjects/Locators/Patient.py
        Create Fake Data List
        ${add_payment_amount_input}    Replace Variables    ${add_payment_amount_input}
        IF    '${payment_amount_value}' == '${None}'
            ${payment_amount_value}    Set Variable    ${Fake_dict.decimal_2d_2f}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_payment_amount_input}    ${payment_amount_value}
        ELSE
            Clear Input Field Until Empty    ${add_payment_amount_input}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_payment_amount_input}    ${payment_amount_value}
        END
            IF    '${payment_status}' == 'Add Payment'
            Util.Select Random From List Regression    xpath_arg=${add_payment_method_select}    var_name=add_payment_method_select    dic=${TempData}
            Util.Select Random From List Regression    xpath_arg=${add_payment_type_select}    var_name=add_payment_type_select    dic=${TempData}
        ELSE IF    '${payment_status}' == 'Edit Payment'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${edit_payment_method_select}    0
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${edit_payment_type_select}    0
            Sleep    1s
            Util.Select Random From List Regression    xpath_arg=${edit_payment_method_select}    var_name=add_payment_method_select    dic=${TempData}
            Util.Select Random From List Regression    xpath_arg=${edit_payment_type_select}    var_name=add_payment_type_select    dic=${TempData}
        END
        ${payment_reference_number_value}    Set Variable    ${Fake_dict.full_name_fake} ${Fake_dict.num_rand}
        ${add_payment_reference_number_input}    Replace Variables    ${add_payment_reference_number_input}
        Clear Input Field Until Empty    ${add_payment_reference_number_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_payment_reference_number_input}    ${payment_reference_number_value}
        ${payment_transaction_date}    Get Current Date    result_format=%m/%d/%Y
        ${add_payment_transaction_date_input}    Replace Variables    ${add_payment_transaction_date_input}
        Clear Input Field Until Empty    ${add_payment_transaction_date_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_payment_transaction_date_input}    ${payment_transaction_date}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
        IF    '${add_payment_btn_status}' == '${True}'
            IF    '${payment_status}' == 'Add Payment'
                Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_payment_btn}
                ${remove_payment_btn}    Replace Variables    ${remove_payment_btn}
                Wait Until Element Is Visible    ${remove_payment_btn}    30s
            END
        END
        Set To Dictionary    ${TempData}    payment_amount_value[${line}]=${payment_amount_value}
        Set To Dictionary    ${TempData}    add_payment_method_select[${line}]=${TempData.add_payment_method_select}
        Set To Dictionary    ${TempData}    add_payment_type_select[${line}]=${TempData.add_payment_type_select}
        Set To Dictionary    ${TempData}    payment_reference_number_value[${line}]=${payment_reference_number_value}
        Set To Dictionary    ${TempData}    payment_transaction_date[${line}]=${payment_transaction_date}
        ${payment_amount_total}    Evaluate    f"{(${payment_amount_total} + ${payment_amount_value}):.2f}"
        Set Test Variable    ${payment_amount_total}
    END

Edit Payment
    [Arguments]    ${btn_arg}    ${msg}    ${payment_amount_value}    ${loop}    ${add_payment_btn_status}
    Open Edit Transaction Modal    payment_type=Payment    row_value=${TempData['payment_reference_number_value[${loop}]']}
    Check Current Balance Value In Modal    current_balance_arg=${add_payment_current_balance}
    Input Payment Modal    ${payment_amount_value}    ${loop}    ${add_payment_btn_status}    Edit Payment
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${add_payment_new_balance}
    ${current_balance_amount_txt}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount_txt}    Set Variable    ${current_balance_amount_txt}[0]
    ${current_balance_amount_txt}    Replace String    ${current_balance_amount_txt}    ,    ${EMPTY}
    Set Test Variable    ${current_balance_amount_txt}  
    IF    '${btn_arg}' == '${add_payment_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Add Adjustment
    [Arguments]    ${tool_btn}    ${btn_arg}    ${msg}    ${adjustment_amount_value}    ${loop}
    Scroll And Click Element    ${payment_add_adjustment_btn}
    Wait Until Element Is Visible    ${add_adjustment_title}    30s
    Check Current Balance Value In Modal    current_balance_arg=${add_adjustment_current_balance}
    Input Adjustment Modal    ${tool_btn}    ${adjustment_amount_value}    ${loop}    Add Adjustment
    IF    ${adjustment_amount_total} >= 0
        Calculate Current Balance Amount    status_arg=increase    amount_arg=${adjustment_amount_total}    current_balance_amount_arg=${add_adjustment_new_balance}
    ELSE IF    ${adjustment_amount_total} < 0
        Calculate Current Balance Amount    status_arg=decrease    amount_arg=${adjustment_amount_total}    current_balance_amount_arg=${add_adjustment_new_balance}
    END
    IF    '${btn_arg}' == '${add_adjustment_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Input Adjustment Modal
    [Arguments]    ${tool_btn}    ${adjustment_amount_value}    ${loop}    ${adjustment_status}
    ${adjustment_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        Import Variables    ${CURDIR}/../../PageObjects/Locators/Patient.py
        Create Fake Data List
        ${add_adjustment_amount_input}    Replace Variables    ${add_adjustment_amount_input}
        IF    '${adjustment_amount_value}' == '${None}'
            ${adjustment_amount_value}    Set Variable    ${Fake_dict.decimal_2d_2f}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_adjustment_amount_input}    ${adjustment_amount_value}
        ELSE
            Clear Input Field Until Empty    ${add_adjustment_amount_input}
            Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_adjustment_amount_input}    ${adjustment_amount_value}
        END
        IF    '${adjustment_status}' == 'Add Adjustment'
            Util.Select Random From List Regression    xpath_arg=${add_adjustment_type_select}    var_name=add_adjustment_type_select    dic=${TempData}
        ELSE IF    '${adjustment_status}' == 'Edit Adjustment'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${edit_adjustment_type_select}    0
            Sleep    1s
            Util.Select Random From List Regression    xpath_arg=${edit_adjustment_type_select}    var_name=add_adjustment_type_select    dic=${TempData}
        END
        ${adjustment_reason_value}    Set Variable    ${Fake_dict.sentence_str}
        ${add_adjustment_reason_input}    Replace Variables    ${add_adjustment_reason_input}
        Clear Input Field Until Empty    ${add_adjustment_reason_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_adjustment_reason_input}    ${adjustment_reason_value}
        ${adjustment_transaction_date}    Get Current Date    result_format=%m/%d/%Y
        ${add_adjustment_transaction_date_input}    Replace Variables    ${add_adjustment_transaction_date_input}
        Clear Input Field Until Empty    ${add_adjustment_transaction_date_input}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_adjustment_transaction_date_input}    ${adjustment_transaction_date}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
        IF    '${adjustment_status}' == 'Add Adjustment'
            IF    '${tool_btn}' == 'random'
                Random Adjustment Button
                IF    '${tool_btn_random}' == '${add_adjustment_add_btn}'
                    ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} + ${adjustment_amount_value}):.2f}"
                ELSE IF    '${tool_btn_random}' == '${add_adjustment_subtract_btn}'
                    ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} - ${adjustment_amount_value}):.2f}"
                END
                ${remove_adjustment_btn}    Replace Variables    ${remove_adjustment_btn}
                Wait Until Element Is Visible    ${remove_adjustment_btn}    30s
            ELSE IF    '${tool_btn}' == '${add_adjustment_add_btn}'
                Wait Until Keyword Succeeds    30s    1s    Click Element    ${tool_btn}
                ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} + ${adjustment_amount_value}):.2f}"
                ${remove_adjustment_btn}    Replace Variables    ${remove_adjustment_btn}
                Wait Until Element Is Visible    ${remove_adjustment_btn}    30s        
            ELSE IF    '${tool_btn}' == '${add_adjustment_subtract_btn}'
                Wait Until Keyword Succeeds    30s    1s    Click Element    ${tool_btn}
                ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} - ${adjustment_amount_value}):.2f}"
                ${remove_adjustment_btn}    Replace Variables    ${remove_adjustment_btn}
                Wait Until Element Is Visible    ${remove_adjustment_btn}    30s        
            END
        END
        Set To Dictionary    ${TempData}    adjustment_amount_value[${line}]=${adjustment_amount_value}
        Set To Dictionary    ${TempData}    add_adjustment_type_select[${line}]=${TempData.add_adjustment_type_select}
        Set To Dictionary    ${TempData}    adjustment_reason_value[${line}]=${adjustment_reason_value}
        Set To Dictionary    ${TempData}    adjustment_transaction_date[${line}]=${adjustment_transaction_date}
        Set Test Variable    ${adjustment_amount_total}
    END

Edit Adjustment
    [Arguments]    ${tool_btn}    ${btn_arg}    ${msg}    ${adjustment_amount_value}    ${loop}
    Open Edit Transaction Modal    payment_type=Adjustment    row_value=${TempData['adjustment_reason_value[${loop}]']}
    Check Current Balance Value In Modal    current_balance_arg=${add_adjustment_current_balance}
    Input Adjustment Modal    ${tool_btn}    ${adjustment_amount_value}    ${loop}    Edit Adjustment
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${add_adjustment_new_balance}
    ${current_balance_amount_txt}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount_txt}    Set Variable    ${current_balance_amount_txt}[0]
    ${current_balance_amount_txt}    Replace String    ${current_balance_amount_txt}    ,    ${EMPTY}
    Set Test Variable    ${current_balance_amount_txt}  
    IF    '${btn_arg}' == '${add_adjustment_save_btn}'
        Scroll And Click Element    ${btn_arg}
        Page Alert Message    ${msg}
    END

Open Edit Transaction Modal
    [Arguments]    ${payment_type}    ${row_value}
    IF    '${payment_type}' == 'Charge' or '${payment_type}' == 'Payment'
        Set Test Variable    ${reference_number_value}    ${row_value}
        ${transaction_edit_btn}    Replace Variables    ${transaction_edit_btn}
        ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${transaction_edit_btn}    30s
        Scroll And Click Element    ${transaction_edit_btn}
    ELSE IF    '${payment_type}' == 'Adjustment'
        Set Test Variable    ${adjustment_reason_value}    ${row_value}
        ${adjustment_transaction_edit_btn}    Replace Variables    ${adjustment_transaction_edit_btn}
        Scroll And Click Element    ${adjustment_transaction_edit_btn}
    END
    Wait Until Element Is Visible    ${edit_transaction_title}    30s

Random Adjustment Button
    ${tool_btn_list}    Create List    ${add_adjustment_add_btn}    ${add_adjustment_subtract_btn}
    ${tool_btn_random}    Evaluate    random.choice(${tool_btn_list})
    Set Test Variable    ${tool_btn_random}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tool_btn_random}

The Balance's Color Should Be
    [Arguments]    ${xpath}    ${color}    
    ${balance_color_style}    SeleniumLibrary.Get Element Attribute    ${xpath}    style
    ${balance_color}    Get Regexp Matches    ${balance_color_style}    \\d+,\\s\\d+,\\s\\d+
    Should Be Equal    ${balance_color}[0]    ${color}

Check Current Balance Value In Modal
    [Arguments]    ${current_balance_arg}
    ${current_balance_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${current_balance_arg}
    ${current_balance_txt}    Get Regexp Matches    ${current_balance_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_txt}    Set Variable    ${current_balance_txt}[0]
    ${current_balance_txt}    Replace String    ${current_balance_txt}    ,    ${EMPTY}
    Should Be Equal    ${current_balance_txt}    ${current_balance_amount}
    
Verify All Lines Are Visible On Transactions Table
    [Arguments]    ${loop}    ${payment_type}
    ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    # ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    # ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    FOR    ${i}    IN RANGE    ${loop}
        ${i}    Set Variable    ${i+1}
        Import Variables    ${CURDIR}/../../PageObjects/Locators/Patient.py
        Get User Name
        IF    '${payment_type}' == 'Charge' or '${payment_type}' == 'Payment'
            IF    '${payment_type}' == 'Charge'
                ${reference_number_value}    Set Variable    ${TempData['charge_reference_number_value[${i}]']}
            ELSE IF    '${payment_type}' == 'Payment'
                ${reference_number_value}    Set Variable    ${TempData['payment_reference_number_value[${i}]']}
            END
            ${transaction_date_column_value}    Replace Variables    ${transaction_date_column_value}
            ${type_column_value}    Replace Variables    ${type_column_value}
            ${reference_number_column_value}    Replace Variables    ${reference_number_column_value}
            ${amount_column_value}    Replace Variables    ${amount_column_value}
            ${running_total_column_value}    Replace Variables    ${running_total_column_value}
        ELSE IF    '${payment_type}' == 'Adjustment'
            ${adjustment_reason_value}    Set Variable    ${TempData['adjustment_reason_value[${i}]']}

            ${transaction_date_column_value}    Replace Variables    ${adjustment_transaction_date_column_value}
            ${type_column_value}    Replace Variables    ${adjustment_type_column_value}
            ${reference_number_column_value}    Replace Variables    ${adjustment_reference_number_column_value}
            ${amount_column_value}    Replace Variables    ${adjustment_amount_column_value}
            ${running_total_column_value}    Replace Variables    ${adjustment_running_total_column_value}
        END
        FOR    ${check_loop}    IN RANGE    10
            ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${transaction_date_column_value}    5s
            IF    '${check_visible}' == '${True}'
                ${transaction_date_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${transaction_date_column_value}
                ${type_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${type_column_value}
                ${reference_number_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${reference_number_column_value}
                ${amount_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${amount_column_value}
                ${running_total_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${running_total_column_value}
                ${running_total_column_txt}    Replace String    ${running_total_column_txt}    ,    ${EMPTY}
                Exit For Loop
            ELSE
                Scroll And Click Element    ${patient_payment_next_btn}
            END
        END
        IF    '${payment_type}' == 'Charge'
            Should Contain    ${transaction_date_column_txt}    ${TempData['charge_transaction_date[${i}]']}
            Should Contain    ${type_column_txt}    ${payment_type} - ${TempData['add_charge_type_select[${i}]']}
            Should Contain    ${reference_number_column_txt}    ${TempData['charge_reference_number_value[${i}]']}
            Should Contain    ${reference_number_column_txt}    Created Date: ${current_day} by ${user_name_txt}
            Should Contain    ${amount_column_txt}    ${TempData['charge_amount_value[${i}]']}
            Should Contain    ${running_total_column_txt}    ${current_balance_amount_txt}
            The Balance's Color Should Be    xpath=${amount_column_value}    color=220, 53, 69    #red
        ELSE IF    '${payment_type}' == 'Payment'
            Should Contain    ${transaction_date_column_txt}    ${TempData['payment_transaction_date[${i}]']}
            Should Contain    ${type_column_txt}    ${payment_type} - ${TempData['add_payment_type_select[${i}]']}
            Should Contain    ${type_column_txt}    Payment Method: ${TempData['add_payment_method_select[${i}]']}
            Should Contain    ${reference_number_column_txt}    ${TempData['payment_reference_number_value[${i}]']}
            Should Contain    ${reference_number_column_txt}    Created Date: ${current_day} by ${user_name_txt}
            Should Contain    ${amount_column_txt}    ${TempData['payment_amount_value[${i}]']}
            Should Contain    ${running_total_column_txt}    ${current_balance_amount_txt}
            The Balance's Color Should Be    xpath=${amount_column_value}    color=71, 159, 118    #green
        ELSE IF    '${payment_type}' == 'Adjustment'
            Should Contain    ${transaction_date_column_txt}    ${TempData['adjustment_transaction_date[${i}]']}
            Should Contain    ${type_column_txt}    ${payment_type} - ${TempData['add_adjustment_type_select[${i}]']}
            Should Contain    ${type_column_txt}    Adjustment Reason: ${TempData['adjustment_reason_value[${i}]']}
            Should Contain    ${reference_number_column_txt}    N/A
            Should Contain    ${reference_number_column_txt}    Created Date: ${current_day} by ${user_name_txt}
            Should Contain    ${amount_column_txt}    ${TempData['adjustment_amount_value[${i}]']}
            Should Contain    ${running_total_column_txt}    ${current_balance_amount_txt}
        END
    END

Verify Filtered Transaction Results On UI
    [Arguments]    ${expect_line}    
    FOR    ${page_index}    IN RANGE    1    11
        Sleep    2s
        ${expect_line}    Replace Variables    ${expect_line}
        ${expect_transaction_filter_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${expect_line}
        ${transaction_total_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${total_line}
        Should Be Equal    ${expect_transaction_filter_lines}    ${transaction_total_lines}
        ${page_index}    Set Variable    ${page_index + 1}
        ${page_num_visible}    Replace Variables    ${page_num}
        ${page_isvisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${page_num_visible}    2s
        IF    '${page_isvisible}' == '${True}'
            Scroll And Click Element    ${page_num_visible}
        ELSE
            Exit For Loop
        END
    END

Verify Remove Transaction Line When Clicking Delete Button
    [Arguments]    ${remove_first_row_btn}    ${transaction_row}    ${new_balance}
    Wait Until Element Is Visible    ${remove_first_row_btn}    30s
    ${transaction_row}    Replace Variables    ${transaction_row}
    Wait Until Element Is Visible    ${transaction_row}    30s
    Scroll And Click Element    ${remove_first_row_btn}
    Wait Until Element Is Not Visible    ${transaction_row}    30s
    ${new_balance_after_action}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${new_balance}
    ${new_balance_after_action}    Get Regexp Matches    ${new_balance_after_action}    (?<=\\$)\\d+.*\\d+
    Should Be Equal    ${current_balance_amount}    ${new_balance_after_action}[0]

Filter All Transaction Methods On Transactions Table
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_method_select}    All Transaction Methods
    @{method_list}    Create List    Charge    Payment    Adjustment
    FOR    ${method_index}    IN    @{method_list}
        Set Test Variable    ${method_index}
        ${expect_line}    Replace Variables    ${method_line}
        ${expect_transaction_filter_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${expect_line}
        ${transaction_total_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${total_line}
        Should Be True    ${expect_transaction_filter_lines} >= 1
        Should Be True    ${expect_transaction_filter_lines} <= ${transaction_total_lines}
    END

Filter All Transaction Types On Transactions Table
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_type_select}    All Transaction Types
    @{type_list}    Create List    Office Copay Debit    Coinsurance Debit    Deductible Debit
    FOR    ${type_index}    IN    @{type_list}
        Set Test Variable    ${type_index}
        ${expect_line}    Replace Variables    ${type_line}
        ${expect_transaction_filter_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${expect_line}
        ${transaction_total_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${total_line}
        Should Be True    ${expect_transaction_filter_lines} >= 1
        Should Be True    ${expect_transaction_filter_lines} <= ${transaction_total_lines}
    END

Leave Required Fields In Add Charge Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Charge Type.
    ...    Reference Number can't be empty.
    ${xpath_list}    Create List
    ...    ${add_charge_amount_input}
    ...    ${add_charge_type_select}
    ...    ${add_charge_reference_number_input}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        Get Current Balance Amount
        Add Charge    
        ...    btn_arg=${None}    
        ...    msg=${None} 
        ...    charge_amount_value=${None}
        ...    loop=1
        ...    add_charge_btn_status=${False}
        IF    '${xpath}' == '${add_charge_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${line}    Set Variable    1
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Scroll And Click Element    ${add_charge_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_charge_close_btn}
    END

Leave Required Fields In Add Payment Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Payment Method.
    ...    Please select a Payment Type.
    ...    Reference Number can't be empty.
    ${xpath_list}    Create List
    ...    ${add_payment_amount_input}
    ...    ${add_payment_method_select}
    ...    ${add_payment_type_select}
    ...    ${add_payment_reference_number_input}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        Get Current Balance Amount
        Add Payment    
        ...    btn_arg=${None}    
        ...    msg=${None} 
        ...    payment_amount_value=${None}
        ...    loop=1
        ...    add_payment_btn_status=${False}
        IF    '${xpath}' == '${add_payment_method_select}' or '${xpath}' == '${add_payment_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${line}    Set Variable    1
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Scroll And Click Element    ${add_payment_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_payment_close_btn}
    END

Leave Required Fields In Add Adjustment Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Adjustment Type.
    ${xpath_list}    Create List
    ...    ${add_adjustment_amount_input}
    ...    ${add_adjustment_type_select}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        Get Current Balance Amount
        Add Adjustment    
        ...    tool_btn=${None}    
        ...    btn_arg=${None}    
        ...    msg=${None} 
        ...    adjustment_amount_value=${None}    
        ...    loop=1
        IF    '${xpath}' == '${add_adjustment_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${line}    Set Variable    1
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Random Adjustment Button
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_charge_close_btn}
    END

Leave Required Fields In Edit Charge Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Charge Type.
    ...    Must enter a Reference Number.
    ${xpath_list}    Create List
    ...    ${add_charge_amount_input}
    ...    ${edit_charge_type_select}
    ...    ${add_charge_reference_number_input}
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated. 
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        ${line}    Set Variable    1
        Open Edit Transaction Modal    payment_type=Charge    row_value=${TempData['charge_reference_number_value[${line}]']}
        IF    '${xpath}' == '${edit_charge_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Scroll And Click Element    ${add_charge_save_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_charge_close_btn}
    END

Leave Required Fields In Edit Payment Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Payment Method.
    ...    Please select a Payment Type.
    ...    Must enter a Reference Number.
    ${xpath_list}    Create List
    ...    ${add_payment_amount_input}
    ...    ${edit_payment_method_select}
    ...    ${edit_payment_type_select}
    ...    ${add_payment_reference_number_input}
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        ${line}    Set Variable    1
        Open Edit Transaction Modal    payment_type=Payment    row_value=${TempData['payment_reference_number_value[${line}]']}
        IF    '${xpath}' == '${edit_payment_method_select}' or '${xpath}' == '${edit_payment_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Scroll And Click Element    ${add_payment_save_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_payment_close_btn}
    END

Leave Required Fields In Edit Adjustment Modal
    ${error_list}    Create List
    ...    Amount can't be empty.
    ...    Please select a Adjustment Type.
    ${xpath_list}    Create List
    ...    ${add_adjustment_amount_input}
    ...    ${edit_adjustment_type_select}
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    FOR    ${xpath}    ${error}    IN ZIP    ${xpath_list}    ${error_list}
        ${line}    Set Variable    1
        Open Edit Transaction Modal    payment_type=Adjustment    row_value=${TempData['adjustment_reason_value[${line}]']}
        IF    '${xpath}' == '${edit_adjustment_type_select}'
            Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${xpath}    0
        ELSE
            ${xpath}    Replace Variables    ${xpath}
            Clear Input Field Until Empty    ${xpath}
        END
        Scroll And Click Element    ${add_adjustment_save_btn}
        Page Alert Message    ${error}
        Scroll And Click Element    ${add_adjustment_close_btn}
    END

Filter All Three Filters With Default Value And Return Result
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_method_select}    All Transaction Methods
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_type_select}    All Transaction Types
    ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_transaction_date_input}    ${current_day}
    Filter All Transaction Methods On Transactions Table
    Filter All Transaction Types On Transactions Table

Dispense Created Appoinment
    ${apt_open_apt_btn}    Replace Variables    ${apt_open_apt_btn}
    Scroll And Click Element    ${apt_open_apt_btn}
    Check Warning Future Appointment
    ${check_schedule_alert}    Run Keyword And Return Status    Wait Until Element Is Visible    ${apt_scheduling_alert}    30s
    Run Keyword If    ${check_schedule_alert}    Scroll And Click Element    ${apt_update_therapy_btn}
    Run Keyword If    ${check_schedule_alert}    Handle Alert    ACCEPT
    Run Keyword If    ${check_schedule_alert}    Page Alert Message    The Therapy for this Appointment has been updated.
    Wait Until Element Is Visible    ${apt_assign_dossage_title}    30s
    Scroll And Click Element    ${apt_approve_dispensed_btn}
    Page Alert Message    Dosage Has Been Accepted!
    Util.Select Random From List Regression    xpath_arg=${apt_lot_number_select}    var_name=apt_lot_number_select    dic=${PatientData}
    Page Alert Message    Dispense Line Updated!
    Scroll And Click Element    ${apt_complete_dispense_btn}
    Wait Until Element Is Visible    ${apt_discrepancy_reason_select}    30s
    Util.Select Random From List Regression    xpath_arg=${apt_discrepancy_reason_select}    var_name=apt_discrepancy_reason_select    dic=${TempData}
    IF    '${TempData.apt_discrepancy_reason_select}' == 'Other'
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${apt_dispense_reason}    Testing
    END
    Scroll And Click Element    ${apt_reason_continue_btn}
    Handle Alert    ACCEPT
    ${check_advise}    Run Keyword And Return Status    Wait Until Element Is Visible    ${apt_advised_title}    30s
    Run Keyword If    '${check_advise}' == '${True}'    Run Keyword And Ignore Error    Scroll And Click Element    ${apt_accept_dispense_btn}
    Run Keyword If    '${check_advise}' == '${True}'    Run Keyword And Ignore Error    Handle Alert    ACCEPT
    Wait Until Page Does Not Contain    Appointment Dispensed!    30s
    Scroll And Click Element    ${apt_close_btn}

Get Appointment Id
    ${apt_id}    Replace Variables    ${apt_id}
    Scroll Element Into View    ${apt_id}
    ${apt_id_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_id}
    Set Test Variable    ${apt_id_txt}

Get Primary Medication
    ${apt_primary_medication}    Replace Variables    ${apt_primary_medication}
    Scroll Element Into View    ${apt_primary_medication}
    ${apt_primary_medication_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_primary_medication}
    Set Test Variable    ${apt_primary_medication_txt}

Dispense Appointments For Patient Payments
    [Arguments]    ${loops}
    FOR    ${i}    IN RANGE    ${loops}
        Schedule Appointment Without PO And Office Visit    ${PatientData.drug_PO}
        Set Test Variable    ${apt_date}    ${PatientData.APT_Date}
        Open Appointments Tab
        Get Appointment Id
        Get Primary Medication
        Dispense Created Appoinment
        Set To Dictionary    ${APT_data}    apt_date[${i+1}]=${apt_date}
        Set To Dictionary    ${APT_data}    apt_id[${i+1}]=${apt_id_txt}
    END

Verify Appointments Transaction Rows Are Visible
    [Arguments]    ${loops}
    FOR    ${line}    IN RANGE    ${loops}
        ${line}    Set Variable    ${line + 1}
        ${apt_id}    Set Variable    ${APT_data['apt_id[${line}]']}
        ${apt_transaction_row}    Replace Variables    ${apt_transaction_row}
        Wait Until Element Is Visible    ${apt_transaction_row}    30s
    END

Filter By Appointment No In Appointments Transaction
    [Arguments]    ${apt_id}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_apt_no_filter_input}    ${apt_id}

Filter By Date Range In Appointments Transaction
    [Arguments]    ${startdate}    ${enddate}
    Wait Until Element Is visible    ${payment_startdate_filter_input}    30s
    Clear Element Text    ${payment_startdate_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_startdate_filter_input}    ${startdate}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Wait Until Element Is visible    ${payment_enddate_filter_input}    30s
    Clear Element Text    ${payment_enddate_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_enddate_filter_input}    ${enddate}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}

Verify The Date Fomat Is MM/DD/YYYY
    ${invalid_current_date}    Get Current Date    result_format=%m-%d-%Y
    Filter By Date Range In Appointments Transaction    ${invalid_current_date}    ${invalid_current_date}
    ${start_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_startdate_filter_input}
    Should Not Contain    ${start_date_txt}    -
    ${end_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_enddate_filter_input}
    Should Not Contain    ${end_date_txt}    -

The Filter By Date Range Resets When Navigating Away From The Page
    Reload Page
    Open Patient Payments Tab
    ${start_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_startdate_filter_input}
    ${end_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_enddate_filter_input}
    Should Be Empty    ${start_date_txt}
    Should Be Empty    ${end_date_txt}

Input Filter By Appointment No Field
    [Arguments]    ${apt_id_arg}
    Wait Until Element Is Visible    ${payment_apt_no_filter_input}    30s
    Scroll Element Into View    ${payment_apt_no_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_apt_no_filter_input}    ${apt_id_arg}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${payment_loading_icon_i}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${payment_loading_icon_i}    5s

Filter By Appointment No Field Has Default Value
    Wait Until Element Is Visible    ${payment_apt_no_filter_input}    30s
    Scroll Element Into View    ${payment_apt_no_filter_input}
    ${apt_filter_default}    SeleniumLibrary.Get Element Attribute    ${payment_apt_no_filter_input}    placeholder
    Should Be Equal    ${apt_filter_default}    Search by Appointment No

Appointments Transaction Table Is Sorted By Latest Date Of Service
    [Arguments]    ${apt_date_arg}
    Wait Until Element Is Visible    ${apt_transaction_date_column}    30s
    Scroll Element Into View    ${apt_transaction_date_column}
    ${latest_date_row}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_transaction_date_column}
    Should Contain    ${latest_date_row}    ${apt_date_arg}

Verify All Column Of Dispensed Appoinment
    ${appt_num_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_transaction_id_column}
    Should Be Equal    ${appt_num_column_txt}    ${APT_data['apt_id[1]']}
    ${primary_medication_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_transaction_med_column}
    Should Be Equal    ${primary_medication_txt}    ${apt_primary_medication_txt}
    ${check_edit_allowed_payment}    Run Keyword And Return Status    Input Text    ${apt_transaction_allowed_column}    edit_testing
    Should Not Be True    ${check_edit_allowed_payment}
    ${check_edit_amt_due}    Run Keyword And Return Status    Input Text    ${apt_transaction_due_column}    edit_testing
    Should Not Be True    ${check_edit_amt_due}
    Scroll And Click Element    ${open_billable_event_btn}
    Wait Until Element Is Visible    ${open_billable_event_table}    30s

Open Account Assignments Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${account_assignments_tab}
    Scroll And Click Element    ${account_assignments_tab}
    Wait Until Element Is Visible    ${assigned_accounts_title}    30s
Open Patient History Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    ${patient_history_tab}
    Scroll And Click Element    ${patient_history_tab}
    Wait Until Element Is Visible    ${summary_treatment_title}    30s

Create PO For Patient History
    [Arguments]    ${med_arg}
    Navigate to Patient by Generated MRN
    Open Provider Orders tab
    Scroll And Click Element    ${create_PO_btn}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${protocol_loading_icon_i}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${protocol_loading_icon_i}    5s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${med_select}    ${med_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${icd_code_select}    1
    ${icdCode_selected_text}    Get Selected List Label    ${icd_code_select}
    Set To Dictionary    ${PO_data}    icdCode_value=${icdCode_selected_text}
    Scroll And Click Element    ${PO_modal_create_btn}
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_exist_alert}    5s
    IF    ${check_exist} == ${True}
        Scroll And Click Element Modal   ${PO_accept_btn}
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${physician_input}    ${PatientData.Refering_Provider}
    ${reffering_strong}    Util.Replace Xpath    xpath=//div//strong[contains(text(),'${PatientData.Refering_Provider}')]
    Scroll And Click Element    ${reffering_strong}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${ordering_physician}    ${PatientData.referto_provider_NPI_PO}
    ${physician_selected_text}    Get Selected List Label    ${ordering_physician}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${weight_PO_input}    ${PatientData.Weight_KG}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_ft}    ${Fake_dict.height_fake}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${height_PO_inch}    ${Fake_dict.height_fake}
    Scroll And Click Element    ${weight_PO_checkbox}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${PO_dosage_assign}    ${Fake_dict.num_rand}
    Util.Select Random From List Regression    xpath_arg=${PO_frequency_value}    var_name=PO_frequency_value    dic=${TempData}
    Util.Select Random From List Regression    xpath_arg=${PO_dose_frequency}    var_name=PO_dose_frequency    dic=${TempData}
    Scroll And Click Element Modal    ${PO_modal_create_btn}
    ${check_advised}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_advise_title}    2s
    IF    ${check_advised} == ${True}
        Scroll And Click Element Modal    ${PO_accept_btn}
    END
    Page Alert Message    Provider Order Successfully Created!
    Scroll And Click Element    ${PO_modal_close_btn}

Dispense Appointment For Patient History
    [Arguments]    ${med_arg}    ${loops}
    FOR    ${loop}    IN RANGE    ${loops}
        ${loop}    Set Variable    ${loop+1}
        ${result}    Get Next Date
        ${past_date}    Get From Dictionary    ${result}    past_date
        Set Test Variable    ${past_date}
        Open Appointments Tab
        Select Therapy Retrieve Data From PO    therapy_arg=${med_arg}
        Schedule Normal Appointment    day_arg=${past_date}    start_time=10:20 am    Lenght=10    dict=${PatientData}
        Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
        Scroll And Click Element    ${add_APT_to_queue_btn}
        Handle DOS Before Suggested Alert
        Wait Until Element Is Not Visible    ${apt_loading_icon}    120s
        Scroll And Click Element    ${schedule_btn}
        Set Test Variable    ${apt_date}    ${past_date}
        Sleep    5s
        Reload Page
        Open Appointments Tab
        Dispense Created Appoinment
        Reload Page
        ${apt_date}    Convert Date    ${apt_date}    date_format=%m/%d/%Y    result_format=%#m/%#d/%Y
        Set To Dictionary    ${APT_data}    
        ...    quantity_therapy_value[${loop}]=${quantity_therapy_value}
        ...    apt_date[${loop}]=${apt_date}
    END
    Sleep    5s
    Reload Page

Select Therapy Retrieve Data From PO
    [Arguments]    ${therapy_arg}
    Set Test Variable    ${drug_po}    ${therapy_arg}
    Scroll And Click Element    ${sche_new_apt_btn}
    Wait Until Element Is Visible    ${Therapy_Selected_Text}    60s
    ${therapy_have_po}    Replace Variables    ${therapy_have_po}
    ${therapy_value}    SeleniumLibrary.Get Element Attribute    ${therapy_have_po}    value
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${apt_therapy_select}    ${therapy_value}
    Wait Until Element Is Visible    ${apt_quantity_therapy_input}    30s
    ${quantity_therapy_value}    Get Value    ${apt_quantity_therapy_input}
    Set Test Variable    ${quantity_therapy_value}
    Wait Until Keyword Succeeds    30s    1s    Click Element     ${Begin_And_Schedule}
    
Verify All Column In Summary Of All Treatments Table
    [Arguments]    ${first_row_list}    ${last_row_list}
    ${compare_list}    Create List    
    ...    Active
    ...    ${row_total}
    ...    ${first_row_list.date_os_value}
    ...    ${first_row_list.calc_dose_value}
    ...    ${first_row_list.mg_per_kg_value}mg/kg
    ...    ${first_row_list.pain_level_value}
    ...    ${last_row_list.date_os_value}
    ...    ${last_row_list.calc_dose_value}
    ...    ${last_row_list.mg_per_kg_value}mg/kg
    ...    ${last_row_list.pain_level_value}
    ...    N/A
    ...    N/A
    FOR    ${treatment_column}    ${compare_value}    IN ZIP    ${treatment_list}    ${compare_list}
        Should Be Equal    ${treatment_column}    ${compare_value}
    END

Calculate Treatment Row Total In Encounter Table
    ${row_total}    SeleniumLibrary.Get Element Count    ${encounter_row_total}
    ${row_total}    Convert To String   ${row_total}
    Set Test Variable    ${row_total}

Get Data From Treatment Row In Encounter Table
    [Arguments]    ${row_arg}    ${list_arg}
    ${date_os_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[3]
    ${mg_per_kg_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[5]
    ${calc_dose_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[6]
    ${pain_level_value}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${row_arg}//child::td[10]
    Set To Dictionary    ${list_arg}    
    ...    date_os_value=${date_os_value}
    ...    mg_per_kg_value=${mg_per_kg_value}
    ...    calc_dose_value=${calc_dose_value}
    ...    pain_level_value=${pain_level_value}
    Set Test Variable    ${list_arg}

Get Data From Summary Of All Treatments Table
    [Arguments]    ${med_arg}
    ${drug_po}    Set Variable    ${med_arg}
    ${history_primary_med_column}    Replace Variables    ${history_primary_med_column}
    Set Test Variable    ${history_primary_med_column}
    ${treatment_list}    Create List  
    ${treatment_column_list}    Create List    
    ...    ${patient_history_status_column}
    ...    ${total_treatment_column}
    ...    ${startdate_column}
    ...    ${startdose_column}
    ...    ${startdose_per_kg_column}
    ...    ${starting_pain_level_column}
    ...    ${last_treatment_date_column}
    ...    ${lastdose_column}
    ...    ${lastdose_per_kg_column}
    ...    ${last_pain_level_column}
    ...    ${dcd_date_column}
    ...    ${reason_for_dc_column}
    
    FOR    ${treatment_column}    IN    @{treatment_column_list}
        ${treatment_column}    Replace Variables    ${treatment_column}
        ${treatment_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${treatment_column}
        Append To List    ${treatment_list}    ${treatment_column_txt}
    END
    Set Test Variable    ${treatment_list}

Expand Encounter Summary Table
    [Arguments]    ${med_arg}
    ${drug_po}    Set Variable    ${med_arg}
    ${history_primary_med_column}    Replace Variables    ${history_primary_med_column}
    ${show_encounter_btn}    Replace Variables    ${show_encounter_btn}
    ${expand_btn_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${show_encounter_btn}
    Should Be Equal    ${expand_btn_txt}    Expand
    Scroll And Click Element    ${show_encounter_btn}
    Wait Until Element Is Visible    ${encounter_summary_title}    30s
    ${expand_btn_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${show_encounter_btn}
    Should Be Equal    ${expand_btn_txt}    Hide

Handle Data Treatment Note 
    [Arguments]    ${date_arg}    ${med_arg}
    Open Patient History Tab
    Expand Encounter Summary Table    med_arg=${med_arg}
    Set Test Variable    ${past_date}    ${date_arg}
    ${date_os_column}    Replace Variables    ${date_os_column}
    Set Test Variable    ${date_os_column}
    ${encounter_view_apt_btn}    Replace Variables    ${encounter_view_apt_btn}
    Scroll And Click Element    ${encounter_view_apt_btn}
    Wait Until Element Is Visible    ${apt_dispense_medication_title}    30s
    Get Dx Code In The Appointment Information Tab
    Get Patient Weight In The Appointment Information Tab
    Get Total Dispensed Dose Of Primary Medication In The Appointment Information Tab
    Scroll And Click Element    ${tnote_tab_link}
    Wait Until Page Does Not Contain Element    ${treat_loading}    30s
    # assess site
    Get Reported Pain Level In The Appointment Information Tab
    Get Encounter Lenght In The Appointment Information Tab
    # reaction
    Get Treatment Clinician In The Appointment Information Tab
    Scroll And Click Element    ${APT_page_close_PO_btn}
    Reload Page

Verify Default Account Select Shows All Locations Have Same HeadOffice
    Scroll And Click Element    ${adjust_default_location_btn}
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${default_account_list}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${default_account_select}
    ${accounts_have_same_headoffice}    Create List    ${PatientData.account_name1}    ${PatientData.account_name2}    ${PatientData.account_name3}
    Lists Should Be Equal    ${default_account_list}    ${accounts_have_same_headoffice}
Get Dx Code In The Appointment Information Tab
    Wait Until Element Is Visible    ${apt_assigned_dxcode}    30s
    ${assigned_dxcode_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_assigned_dxcode}
    Set To Dictionary    ${APT_data}    assigned_dxcode_txt=${assigned_dxcode_txt}
    
Selecting Defualt Account Triggers A Confirmation Popup
    [Arguments]    ${location_arg}    ${status}
    Scroll And Click Element    ${adjust_default_location_btn}
    Wait Until Element Is Visible    ${default_account_select}    30s
    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${default_account_select}    ${location_arg}
    IF    '${status}' == 'yes'
        ${alert_text}    Handle Alert    action=ACCEPT
        Should Be Equal    ${alert_text}    Are you sure you would like to change the default location for this patient?
        Page Alert Message    Patient Default Account Successfully Assigned
    ELSE IF    '${status}' == 'no'
        Handle Alert    action=DISMISS
        Reload Page
        Open Account Assignments Tab
    END
Get Patient Weight In The Appointment Information Tab
    Wait Until Element Is Visible    ${apt_patient_weight}    30s
    ${patient_weight_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${apt_patient_weight}
    Set To Dictionary    ${APT_data}    patient_weight_txt=${patient_weight_txt}

Check The Default Account Remains Changed
    [Arguments]    ${location_arg}
    Scroll And Click Element    ${adjust_default_location_btn}
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${account_selected}   Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${default_account_select}
    Should Be Equal     ${account_selected}    ${location_arg}
    ${account_name}   Wait Until Keyword Succeeds    30s    1s    Get Text    ${assigned_default_accounts_checkbox}
    Should Contain    ${account_name}    ${location_arg}
Get Total Dispensed Dose Of Primary Medication In The Appointment Information Tab
    Wait Until Element Is Visible    ${apt_base_qty}    30s
    ${base_qty_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_base_qty}
    ${unit_therapy_value}    Get Text    ${apt_unit_therapy}
    ${unit_therapy_value}    Fetch From Right    ${unit_therapy_value}    Dosage: \
    Set To Dictionary    ${APT_data}    base_qty_txt=${base_qty_txt}    unit_therapy_txt=${unit_therapy_value}

Return Defualt Location
    Scroll And Click Element    ${adjust_default_location_btn}
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${selected_value}    Get Selected List Label    ${default_account_select}
    IF    '${selected_value}' != '${PatientData.account_name1}'
        Selecting Defualt Account Triggers A Confirmation Popup    location_arg=${PatientData.account_name1}    status=yes
    END
    ${checkbox_visible}    SeleniumLibrary.Get Element Attribute    ${assigned_checked_checkbox}    checked
    IF    '${checkbox_visible}' == 'true'
        Scroll And Click ELement    ${assigned_checked_checkbox}
        Page Alert Message    Patient Account Removed
    END
Get Reported Pain Level In The Appointment Information Tab
    Wait Until Element Is Visible    ${apt_pain_scale_select}    30s
    Scroll Element Into View    ${apt_pain_scale_select}
    Util.Select Random From List Regression    xpath_arg=${apt_pain_scale_select}    var_name=apt_pain_scale_select    dic=${APT_data}

Verify The Date Fomat Is MM/DD/YYYY In PAlerts
    ${start_date_txt}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${alerts_startdate}    value
    ${is_valid_start}=    Is Date In Format    ${start_date_txt}    %m/%d/%Y
    Should Be True    ${is_valid_start}
    ${end_date_txt}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${alerts_enddate}    value
    ${is_valid_end}=    Is Date In Format    ${end_date_txt}    %m/%d/%Y
    Should Be True    ${is_valid_end}

Input Event Timestamp And Check Datepicker In PAlerts
    [Arguments]    ${startdate}    ${enddate}
    Wait Until Element Is visible    ${alerts_startdate}    30s
    Clear Element Text    ${alerts_startdate}
    Click Element    ${alerts_startdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${alerts_startdate}    ${startdate}
    Check Elements Visible    ${datepick}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Wait Until Element Is visible    ${alerts_enddate}    30s
    Clear Element Text    ${alerts_enddate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${alerts_enddate}    ${enddate}
    Check Elements Visible    ${datepick}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}

Verify Dropdown Has Only Option
    [Arguments]    ${dropdown_locator}    ${option_locator}    ${expected_value}
    Click Element    ${dropdown_locator}
    ${options}=    Get WebElements    ${option_locator}
    ${filtered}=    Create List
    FOR    ${el}    IN    @{options}
        ${text}=    Get Text    ${el}
        Run Keyword If    "${text}" != "" and not "select" in "${text.lower()}"    Append To List    ${filtered}    ${text}
    END 
    Length Should Be    ${filtered}    1
    Should Be Equal    ${filtered[0]}    ${expected_value}

Check Status Textbox
    Click Element    ${other_radio_btn}
    Element Should Be Enabled    ${duration_text}
    Input Text    ${duration_text}    ${Fake_dict.decimal_2d_2f}
    ${actionreason_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${actionreason}
    Should Be True    ${actionreason_disabled}

Check Error If Not Selected    
    Click Element    ${alerts_save}
    Page Alert Message    You must select an Event Description.
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${event_desc}    1
    Click Element    ${alerts_save}
    Page Alert Message    You must select a Priority.
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${priority}    1
    Check Status Textbox
    Click Element    ${alerts_save}
    Page Alert Message    The Duration value must be a valid and positive number.

Check Action Duration Options
    ${expected}=    Create List    15 Min.    30 Min.    45 Min.    60 Min.    Other
    ${actual_1}=    Get Text    ((//div[@class='col-xs-12 CenterInlineChildDivs'])[2]//following::label[@class='radio-inline'])[1]
    ${actual_2}=    Get Text    ((//div[@class='col-xs-12 CenterInlineChildDivs'])[2]//following::label[@class='radio-inline'])[2]
    ${actual_3}=    Get Text    ((//div[@class='col-xs-12 CenterInlineChildDivs'])[2]//following::label[@class='radio-inline'])[3]
    ${actual_4}=    Get Text    ((//div[@class='col-xs-12 CenterInlineChildDivs'])[2]//following::label[@class='radio-inline'])[4]
    ${actual_5}=    Get Text    ((//div[@class='col-xs-12 CenterInlineChildDivs'])[2]//following::label[@class='radio-inline'])[5]
    ${actual}=    Create List    ${actual_1}    ${actual_2}    ${actual_3}    ${actual_4}    ${actual_5}
    Should Be Equal    ${actual}    ${expected}

Verify Textarea Allows Max 255 Characters
	[Arguments]    ${locator}    ${text_result}
	${long_text}=    Generate Random String    300    [LETTERS]
	Input Text    ${locator}    ${long_text}
    Click Element    ${alerts_save}
	Page Alert Message    Patient Alert Created
    Click Element    ${showcomplete_checkbox}
    ${value}=    Get Value    ${text_result}
	${length}=    Get Length    ${value}
	Should Be Equal As Integers    ${length}    255

Input Required Field In PAlert Popup
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${event_desc}    1
	Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${priority}    1
    ${text_event}=    Get Selected List Label    ${event_desc}
    ${text_priority}=    Get Selected List Label    ${priority}
    Set Test Variable    ${text_event}
    Set To Dictionary    ${TempData}    text_event=${text_event}
    Set Test Variable    ${text_priority}
    Set To Dictionary    ${TempData}    text_event=${text_priority}
    Click Element	//input[@name='ModalDuration' and @data-val='30']
	Element Should Be Enabled	//*[@id='ModalActionReason']

Create Patient Alerts Successfully
    Click Element    ${create_PAlerts}
    Get Current Date Time
	Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${event_desc}    1
	Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${priority}    1
    Click Element	//input[@name='ModalDuration' and @data-val='30']
    ${long_text}=    Generate Random String    100    [LETTERS]
	Input Text    ${actionreason}    ${long_text}
    Click Element    ${alerts_save}
	Page Alert Message    Patient Alert Created

Compare Account Name List With Default Location Select
    Scroll And Click Element    ${adjust_default_location_btn}
    Wait Until Element Is Visible    ${default_account_select}    30s
    ${default_account_select_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${default_account_select}
    ${account_name_list}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get WebElements    ${assigned_account_name_row_total}
    ${default_account_name_list}    Create List
    FOR    ${account_name}    IN    @{account_name_list}
        ${account_name_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${account_name}
        ${account_name_txt}    Fetch From Left    ${account_name_txt}    \ (\
        Append To List    ${default_account_name_list}    ${account_name_txt}
    END
    Lists Should Be Equal    ${default_account_select_list}    ${default_account_name_list}
Get Encounter Lenght In The Appointment Information Tab
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${treat_assessment_btn}
    Wait Until Element Is Visible    ${treat_assessment_title}    30s
    Input Appointment Start Time In Assessment Modal 
    Input Appointment End Time In Patient Discharge Modal
    Sleep    1s
    ${duration_txt}    SeleniumLibrary.Get Value    ${patient_discharge_duration}    
    Set To Dictionary    ${APT_data}    duration_txt=${duration_txt}
    
Check Filter Alerts Using Both Start Date And End Date
    ${current_date}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}    Subtract Time From Date    ${current_date}    2 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${current_date}    2 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Input Event Timestamp And Check Datepicker In PAlerts    ${start_date}    ${end_date}
    Click Element    ${showcomplete_checkbox}
    ${result_datetime}=    Get Text    ${event_timestamp_column}
    ${date_event}=    Fetch From Left    ${result_datetime}    \ at
    ${event_date_obj}=     Convert Date    ${date_event}     result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${start_date_obj}=     Convert Date    ${start_date}     result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${end_date_obj}=       Convert Date    ${end_date}       result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${check_date}    Subtract Date From Date    ${event_date_obj}    ${start_date_obj}     result_format=number    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    Should Be True    ${check_date} > 0 
    ${check_date}    Subtract Date From Date    ${event_date_obj}    ${end_date_obj}     result_format=number    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    Should Be True    ${check_date} < 0

Create Patient Alerts No Action Reason And Get Datetime
	Click Element    ${create_PAlerts}
	Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${event_desc}    1
	Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${priority}    1
    Get Current Date Time
	Click Element    ${alerts_save}
	Page Alert Message    Patient Alert Created
    ${result_datetime}=    Get Text    ${event_timestamp_column}
    ${is_equal}    Run Keyword And Return Status    Should Be Equal    ${result_datetime}    ${expected_datetime}
    IF    '${is_equal}' == '${False}'
        Should Be Equal    ${result_datetime}    ${expected_plus_1}
    END

Check Patient Field Correct Information
    Click Element    ${create_PAlerts}
    Wait Until Element Is Visible    ${patientfield_popup}    30s
    ${patient_value}    SeleniumLibrary.Get Element Attribute    ${patientfield_popup}    value
    ${DOB}=    Convert Date    ${PatientData.DOB}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${expected_value}    Set Variable    ${PatientData.First_Name} ${PatientData.Middle_Name} ${PatientData.Last_Name} \(${DOB}\) MRN: ${PatientData.MRN} - (${PatientData.Location})
    Should Be Equal As Strings    ${patient_value}    ${expected_value}

Get Current Date Time
    ${now}=    Get Current Date    
    ${adjusted}=    Add Time To Date    ${now}    -12h
    ${expected_datetime}=      Convert Date     ${adjusted}    result_format=%m/%d/%Y at %#I:%M %p
    ${adjusted}=    Add Time To Date    ${adjusted}    1 minutes
    ${expected_plus_1}=      Convert Date     ${adjusted}    result_format=%m/%d/%Y at %#I:%M %p
    Set Test Variable    ${expected_datetime}
    Set Test Variable    ${expected_plus_1}

Check Field Event Date
    Click Element    ${event_date}
	${date}=    SeleniumLibrary.Get Element Attribute   ${event_date}   value
	${is_valid}=    Is Date In Format    ${date}    %m/%d/%Y
    Should Be True    ${is_valid}

Is Date In Format
    [Arguments]    ${date_string}    ${format}
    ${status}=    Run Keyword And Return Status
    ...    Convert Date    ${date_string}    result_format=datetime    date_format=${format}
    RETURN    ${status}

Verify Completed Alerts Visible
    Wait Until Element Is Not Visible    ${hide_alert}
    Page Should Not Contain Element    ${hide_alert}

Verify Completed Alerts Hide
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${showcomplete_checkbox}
    Page Should Contain Element    ${hide_alert}

Check If Checkbox Is Not Checked
    ${is_checked}=    SeleniumLibrary.Get Element Attribute    ${showcomplete_checkbox}    checked
    ${is_checked}=    Convert To Boolean    ${is_checked}
    Should Be Equal    ${is_checked}    ${False}

Check The Patient Column
    Wait Until Element Is Visible    ${patient_column}
    ${infor}=    Get Text    ${patient_column}
    Should Be Equal As Strings    ${infor}    ${PatientData.First_Name} ${PatientData.Middle_Name} ${PatientData.Last_Name}\nMRN: ${PatientData.MRN}

Check The Event Column
    Wait Until Element Is Visible    ${event_column}
    ${option}=    Get Text    ${event_column}
    Should Be Equal As Strings    ${option}    ${text_event}\nPriority: ${text_priority}

Check Completed Timestamp Column Updated
    [Arguments]    ${locator}
    Click Element    (//*[@id="PatientAlertsList"]//following::input)[1]
	${long_text}=    Generate Random String    100    [LETTERS]
	Input Text    ${locator}    ${long_text}
    Set Test Variable    ${long_text}
    Get Current Date Time
    Click Element    ${alerts_confirm}
    Page Alert Message    Patient Alert Updated.
    Click Element    ${showcomplete_checkbox}
    Sleep    2s
    Get User Name
    ${infor}=    Get Text    //textarea[contains(text(),'${long_text}')]//ancestor::tr/td[5]    #${completed_timestamp_column_text}
    ${is_equal}    Run Keyword And Return Status    Should Be Equal    ${infor}    By: ${user_name_txt}\n${expected_datetime}
    IF    '${is_equal}' == '${False}'
        Should Be Equal    ${infor}    By: ${user_name_txt}\n${expected_plus_1}
    END
Check Confirm Button Disable
    Click Element    ${other_input}
    Input Text    ${other_textbox}    ${Fake_dict.decimal_2d_2f}
    ${class}=    SeleniumLibrary.Get Element Attribute    ${alerts_confirm}    class
    Should Contain    ${class}    disabled


Account Name Has Disabled Checkbox
    ${location_name}    Set Variable    ${PatientData.account_name1}
    ${assigned_accounts_checkbox}    Replace Variables    ${assigned_accounts_checkbox}
    ${checkbox_disabled}    SeleniumLibrary.Get Element Attribute    ${assigned_accounts_checkbox}    disabled
    Should Be Equal    ${checkbox_disabled}    true
Input Appointment Start Time In Assessment Modal 
    ${starttime_value}    Evaluate    f"{random.randint(0, 200):04d}"    modules=random
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${assessment_starttime_input}    ${starttime_value}
    ${check_timepicker}    Run Keyword And Return Status    Wait Until Element Is Visible    ${assessment_starttime_picker}    5s
    IF    '${check_timepicker}' == '${True}'
        Click ELement    ${assessment_starttime_picker}
        Set Test Variable    ${starttime_value}
    ELSE
        Input Appointment Start Time In Assessment Modal 
    END

Checking An "Assigned" checkbox
    [Arguments]    ${status}    ${msg}    ${location_arg}
    ${location_name}    Set Variable    ${location_arg}
    ${assigned_accounts_checkbox}    Replace Variables    ${assigned_accounts_checkbox}
    Scroll And Click Element    ${assigned_accounts_checkbox}
    IF    '${status}' == 'select'
        Page Alert Message    Patient Account Successfully Assigned
    ELSE IF    '${status}' == 'unselect'
        Page Alert Message    Patient Account Removed
    END
Input Appointment End Time In Patient Discharge Modal
    Scroll And Click Element    ${patient_discharge_btn}
    Wait Until Element Is Visible    ${patient_discharge_title}    30s
    ${endtime_value}    Evaluate    f"{random.randint(int('${starttime_value}')+1, 300):04d}"    modules=random
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${patient_discharge_endtime}    ${endtime_value}
    ${check_timepicker}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_discharge_endtime_picker}    5s
    IF    '${check_timepicker}' == '${True}'
        Click ELement    ${patient_discharge_endtime_picker}
    ELSE
        Input Appointment End Time In Patient Discharge Modal
    END

Verify "Account Name" Shows Fomat Exactly
    ${location_name}    Set Variable    ${PatientData.account_name2}
    ${assigned_account_name}    Replace Variables    ${assigned_account_name}
    ${account_name_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${assigned_account_name}
    Should Match Regexp    ${account_name_txt}    ^${location_name}\\s\\(\\d+\\)$

Input Unlimited Characters Into Note Textbox
    ${location_name}    Set Variable    ${PatientData.account_name1}
    ${note_accounts_checkbox}    Replace Variables    ${note_accounts_checkbox}
    Set Test Variable    ${note_accounts_checkbox}
    Input Long Characters    input_arg=${note_accounts_checkbox}    length=500

Get Treatment Clinician In The Appointment Information Tab
    Scroll Element Into View    ${apt_clinician_select}
    Wait Until Element Is Visible    ${apt_clinician_select}    30s
    ${trearment_clinician}    SeleniumLibrary.Get Selected List Label    ${apt_clinician_select}
    Set To Dictionary    ${APT_data}    trearment_clinician=${trearment_clinician}

Save "Note" Textbox By Clicking Outside
    Input Unlimited Characters Into Note Textbox
    Scroll And Click Element    ${assigned_note_column_title}
    Run Keyword And Ignore Error    Page Alert Message    Patient Account Successfully Updated
    Clear Input Field Until Empty    ${note_accounts_checkbox}
    Scroll And Click Element    ${assigned_note_column_title}
    Run Keyword And Ignore Error    Page Alert Message    Patient Account Successfully Updated

Compare Encounter Summary Data With Treatment Note Data
    ${mg_per_kg_calculated}    Evaluate    round((${APT_data['quantity_therapy_value[1]']} / ${APT_data.patient_weight_txt}),2)
    ${mg_per_kg_calculated}    Convert To String    ${mg_per_kg_calculated}
    ${encounter_pain_level_column}    Get Regexp Matches    ${encounter_pain_level_column}    \\d+
    ${pain_scale_column}    Get Regexp Matches    ${APT_data.apt_pain_scale_select}    \\d+
    ${treatment_list}    Create List    
    ...    ${APT_data.assigned_dxcode_txt}
    ...    ${APT_data.patient_weight_txt}
    ...    ${mg_per_kg_calculated}
    ...    ${APT_data['quantity_therapy_value[1]']}
    ...    ${APT_data.base_qty_txt}
    ...    ${APT_data.unit_therapy_txt} Every ${Temp_data.PO_frequency_value} ${Temp_data.PO_dose_frequency}
    ...    N/A
    ...    ${pain_scale_column}[0] of 10
    ...    N
    ...    ${APT_data.duration_txt}
    ...    ${APT_data.trearment_clinician}
    FOR    ${encounter}    ${treatment}    IN ZIP    ${encounter_dict}    ${treatment_list}
        Should Contain    ${encounter}    ${treatment}
    END

Get Encounter Summary Treatment Data
    [Arguments]    ${date_arg}    ${med_arg}
    Open Patient History Tab
    Expand Encounter Summary Table    med_arg=${med_arg}
    Set Test Variable    ${past_date}    ${date_arg}
    ${date_os_column}    Replace Variables    ${date_os_column}
    Set Test Variable    ${date_os_column}
    ${encounter_dict}    Create List
    ${encounter_list}    Create List    
    ...    ${encounter_dxcode_column}
    ...    ${encounter_weight_column}
    ...    ${encounter_mg_per_kg_column}
    ...    ${encounter_calc_dose_column}
    ...    ${encounter_actual_dose_column}
    ...    ${encounter_dose_frequency_column}
    ...    ${encounter_access_site_column}
    ...    ${encounter_pain_level_column}
    ...    ${encounter_reaction_column}
    ...    ${encounter_lenght_column}
    ...    ${encounter_caregiver_column}
    FOR    ${encounter_column}    IN    @{encounter_list}
        ${encounter_column}    Replace Variables    ${encounter_column}
        ${encounter_column}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${encounter_column}
        Append To List    ${encounter_dict}    ${encounter_column}
    END
    Set Test Variable    ${encounter_dict}

Save "Note" Textbox By Pressing Tab Key
    Input Unlimited Characters Into Note Textbox
    Press Keys    None    TAB
    Run Keyword And Ignore Error    Page Alert Message    Patient Account Successfully Updated
    Clear Input Field Until Empty    ${note_accounts_checkbox}
    Press Keys    None    TAB
    Run Keyword And Ignore Error    Page Alert Message    Patient Account Successfully Updated
Verify System Returns The Corresponding Result With Valid Input
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    Click Assigned Checkbox    ${icdcode_arg}
    Click Primary Checkbox    ${icdcode_arg}
    Scroll And Click Element    ${ICD_clear}

Select Multiple Checkboxes In "Assigned" Column
    ${location_list}    Create List    ${PatientData.account_name2}    ${PatientData.account_name3}
    FOR    ${location_index}    IN    @{location_list}
        Checking An "Assigned" checkbox    status=select    msg=Patient Account Successfully Assigned    location_arg=${location_index}
    END
    ${checked_checkbox_list}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get WebElements    ${assigned_checked_checkbox}
    FOR    ${checkbox_index}    IN    @{checked_checkbox_list}
        ${checked}    Wait Until Keyword Succeeds    30s     1s    SeleniumLibrary.Get Element Attribute    ${checkbox_index}    checked
        Should Be Equal    ${checked}    true
    END
    FOR    ${location_index}    IN    @{location_list}
        Checking An "Assigned" checkbox    status=unselect    msg=Patient Account Removed    location_arg=${location_index}
    END
Find Diagnosis
    [Arguments]    ${icdcode_arg}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${search_ICD}    ${icdcode_arg}
    Scroll And Click Element    ${find_ICD}
    Wait Until Element Is Not Visible    ${diagnosis_loading_icon}    30s

Click Assigned Checkbox
    [Arguments]    ${icdcode_arg}
    ${icd_code}    Set Variable    ${icdcode_arg}
    ${diagnosis_assigned_checkbox}    Replace Variables    ${diagnosis_assigned_checkbox}
    Scroll And Click Element    ${diagnosis_assigned_checkbox}
    Page Alert Message    ICD Code Added to Patient.
    Wait Until Element Is Visible    ${diagnosis_assigned_section}    30s

Click Primary Checkbox
    [Arguments]    ${icdcode_arg}
    ${icd_code}    Set Variable    ${icdcode_arg}
    ${diagnosis_primary_checkbox}    Replace Variables    ${diagnosis_primary_checkbox}
    Scroll And Click Element    ${diagnosis_primary_checkbox}
    Page Alert Message    ICD Code Set as a Primary.
    Wait Until Element Is Visible    ${diagnosis_primary_section}    30s

Verify System Displays Message With Invalid Input
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    Wait Until Element Is Visible    ${diagnosis_no_icd_msg}    30s
    Scroll And Click Element    ${ICD_clear}

Unassigned Diagnosis
    [Arguments]    ${icdcode_arg}
    Find Diagnosis    ${icdcode_arg}
    ${icd_code}    Set Variable    ${icdcode_arg}
    ${diagnosis_assigned_checkbox}    Replace Variables    ${diagnosis_assigned_checkbox}
    Scroll And Click Element    ${diagnosis_assigned_checkbox}
    Page Alert Message    ICD Code Removed from Patient.

Check Diagnosis Is Assigned To Patient In Appointment Tab
    [Arguments]    ${icdcode_arg}
    ${apt_diagnosis}    Replace Variables    ${apt_diagnosis}
    Scroll And Click Element    ${apt_diagnosis}
    Wait Until Element Is Visible    ${apt_assign_dxcode_title}
    ${icd_code}    Set Variable    ${icdcode_arg}
    ${apt_assign_dxcode_to_patient}    Replace Variables    ${apt_assign_dxcode_to_patient}
    Wait Until Element Is Visible    ${apt_assign_dxcode_to_patient}
    Scroll And Click Element    ${assign_dxcode_close_btn}

Check Default Value Of Patient Assessments Dropdown
    ${default}=    Get Selected List Label    ${template_dropdown}
    Should Be Equal    ${default}    - Select a Template -

Generate Meaningful Alpha Template Name
    ${random}=    Generate Random String    6    [LETTERS]
    ${template_name}=    Catenate    SEPARATOR=    Template_    ${random}
    Set Test Variable    ${template_name}
    ${random2}=    Generate Random String    6    [LETTERS]
    ${template_name_2}=    Catenate    SEPARATOR=    Template_    ${random2}
    Set Test Variable    ${template_name_2}

Verify That New Template Is Created Unsuccessfuly
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_template_btn}
    Generate Meaningful Alpha Template Name
    Input Text    ${assessment_name_texbox}    ${template_name}
    Click Element    ${cancel_assessment_btn}
    Wait Until Element Is Visible    ${template_dropdown}
    ${options}=    Get List Items    ${template_dropdown}
    List Should Not Contain Value    ${options}    ${template_name}
    
Verify That New Template Is Created Successfuly
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_template_btn}
    Generate Meaningful Alpha Template Name
    Input Text    ${assessment_name_texbox}    ${template_name}
    Click Element    ${save_assessment_btn}
    Page Alert Message    New Assessment Template Created
    ${options}=    Get List Items    ${template_dropdown}
    List Should Contain Value    ${options}    ${template_name}

Check System Shows "New Assessment" Or "Edit Selected Template
    Wait Until Element Is Visible    ${template_dropdown}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label	${template_dropdown}    ${template_name}
    Check Elements Visible    ${new_assessment_btn}    ${edit_selectedtemp_btn}

Verify Edit Selected Template Button
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_selectedtemp_btn}         # PaMan_TC229
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_assessment_btn}
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${assessment_name_texbox}
    Input Text    ${assessment_name_texbox}    ${template_name_2}
    Click Element    ${save_update_assessment}
    Page Alert Message    Assessment Template Updated
    Wait Until Element Is Visible    ${add_question_btn}        # PaMan_TC230
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_question_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${desc_assessment}    Test
    Scroll And Click Element   ${save_question}
    Page Alert Message    New Question Created
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_question}        # PaMan_TC231
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${numberofcolumn}    1
    Scroll And Click Element   ${save_update_question}
    Page Alert Message    Question Updated
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_question_element}        # PaMan_TC233
    Wait Until Element Is Visible    ${add_question_element_title}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${desc_assessment}    Test
    Wait Until Keyword Succeeds    30s    1s    Select From List By Index	${datatype}    1
    Scroll And Click Element    ${save_question_element}
    Page Alert Message    New Question Element Created
    Wait Until Element Is Visible    ${update_question_element}    # PaMan_TC234
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_question_element}
    Scroll And Click Element    ${optional_checkbox}
    Scroll And Click Element    ${save_update_question_element}
    Page Alert Message    Question Element Updated

Verify The System Navigates The User Into The "New Assessment"
    Wait Until Element Is Visible    ${template_dropdown}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label	${template_dropdown}    ${template_name2}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${new_assessment_btn}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${question_element_input}    Test Assessment tab
    Click Element    ${save_question_element_input}
    Page Alert Message    New Assessment Created

Verify That View Information Assessment Detail Successful
    Wait Until Element Is Visible    ${info_assessment_detail}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${info_assessment_detail}
    Wait Until Element Is Visible    ${assessment_name}
    ${title}    Get Text    ${assessment_name} 
    Should Be Equal    ${title}    ${template_name_2} 
    Click Element    ${close_assessment_btn}

Verify Deleted SuccessFully
    Wait Until Element Is Visible    ${edit_selectedtemp_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_selectedtemp_btn} 
    Wait Until Element Is Visible    ${update_question_element}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_question_element}
    Scroll And Click Element    ${delete_quesion_element_btn}
    Handle Alert    ACCEPT    30s
    Page Alert Message    Question Element Removed
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_question}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${delete_quesion}
    Handle Alert    ACCEPT    30s
    Page Alert Message    Question Removed
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_assessment_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${delete_assessment_btn}
    Handle Alert    ACCEPT    30s
    Page Alert Message    Assessment Template Removed

Create List Assessment
    ${template_list}    Create List    ${template_name}    ${template_name_2}
    Sort List    ${template_list}
    Set Test Variable    ${template_list}
    FOR    ${template}    IN    @{template_list}
        Wait Until Element Is Visible    ${add_template_btn}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_template_btn}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${assessment_name_texbox}    ${template}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${save_assessment_btn}
        Page Alert Message    New Assessment Template Created
    END

Delete Assessment Templates
    [Arguments]    ${expected_assessment}
    FOR    ${template}    IN    @{expected_assessment}
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${template_dropdown}    ${template}
        ${item}=    Get Selected List Label    ${template_dropdown}
        Wait Until Element Is Visible    ${edit_selectedtemp_btn}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${edit_selectedtemp_btn}
        Wait Until Element Is Visible    //*[@id="AssessmentTemplateWrapper"]//following::div[contains(text(),'Assessment Template ')]//following::strong[text()="${item}"]
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_assessment_btn}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${delete_assessment_btn}
        Handle Alert    ACCEPT    30s
        Page Alert Message    Assessment Template Removed
        Wait Until Element Is Visible    ${template_dropdown}    30s
    END

Delete All Assessment Template From Dropdown
    ${all_items}=    Get List Items    ${template_dropdown}
    ${count}=    Get Length    ${all_items}
    Run Keyword If    ${count} > 1    Delete Assessment Templates    ${all_items[1:]}


