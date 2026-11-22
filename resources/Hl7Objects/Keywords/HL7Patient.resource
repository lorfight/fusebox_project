*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    XML
Library    String
Library    DateTime

Variables    ../../PageObjects/Locators/Patient.py

Resource    ../../PageObjects/Keywords/Patient.resource

*** Keywords ***
Check MRN Exists In Patients Page
    [Arguments]    ${LOCATION}    ${MRN}    
    Click Element    //*[@id = 'navbar-collapse']//*[text()=' Patients']
    Click Button    //*[@data-id='CustomerAccountId']
    Wait Until Element Is Visible    //*[@class='dropdown-menu inner']    10s
    Click Element    //*[@class='dropdown-menu inner']//*[text()='${LOCATION}']
    Input Text    //*[@id='SearchValues']    ${MRN}
    Click Button    //*[@id='FindButton' and normalize-space(text()='Find')]
    Wait Until Element Is Visible    //*[@id='PatientList']//*[@class='CenterAll' and text()='${MRN}']    30s

Navigate To Patient Information Tab
    [Arguments]    ${LOCATION}    ${MRN}
    Check MRN Exists In Patients Page    ${LOCATION}    ${MRN}
    Click Element    //*[@id='PatientList']//*[@class='CenterAll' and text()='${MRN}']
    Wait Until Element Is Visible    //*[@id='PatientInfo']    30s
    
Convert Gender
    [Arguments]    ${gender_list}
    ${gender}=    Set Variable    ${gender_list}[0]
    IF    '${gender}' == 'Female'
        ${convert_gender}=    Set Variable    F
    ELSE IF    '${gender}' == 'Male'
        ${convert_gender}=    Set Variable    M
    ELSE
        ${convert_gender}=    Set Variable    Other
    END
    RETURN    ${convert_gender} 

Get Value From Patient Information Tab
    [Arguments]    ${LOCATION}    ${MRN}
    Navigate To Patient Information Tab    ${LOCATION}    ${MRN}
    ${first_name}=    Get Value    ${First_Name_Input}
    ${last_name}=    Get Value    ${Last_Name_Input}
    ${mrn}=    Get Value    ${MRN_Input}
    ${dob}=    Get Value    ${DOB_Input}
    ${dob_format}=    Convert Date    ${dob}    result_format=%Y%m%d    date_format=%m/%d/%Y
    ${gender_list}=    Get Selected List Labels   ${Gender_Select}
    ${gender}=    Convert Gender    ${gender_list}    
    ${insurance_name}=    Get Selected List Label    ${PrimaryPayer_select}
    ${subscriber}=    Get Value    ${Subscriber_Input}
    ${group}=    Get Value    ${Group_Input}
    ${effective_date}=    Get Value    ${EffectiveDate_Input}
    ${patient_data}=    Create Dictionary    
    ...                 FirstName=${first_name}
    ...                 LastName=${last_name}
    ...                 MRN=${mrn}
    ...                 DOB=${dob_format}
    ...                 Gender=${gender}
    ...                 InsuranceName=${insurance_name}
    ...                 Subscriber=${subscriber}
    ...                 Group=${group}
    ...                 EffectiveDate=${effective_date}
    RETURN    ${patient_data}

Create A Patient
    [Arguments]    ${LOCATION}    ${MRN}    ${FirstName}    ${LastName}    ${DOB}    ${HomePhone}    ${CellPhone}    ${Email}    ${AddressLine1}    ${City}    ${PostalCode}
    Click Element    //*[@id = 'navbar-collapse']//*[text()=' Patients']
    Click Button    //*[@data-id='CustomerAccountId']  
    Wait Until Element Is Visible    //*[@class='dropdown-menu inner']//*[text()='${LOCATION}']    30s
    Click Element    //*[@class='dropdown-menu inner']//*[text()='${LOCATION}']
    Wait Until Element Is Visible    ${New_Patient_Link}    5s    
    Click Element    ${New_Patient_Link}
    Wait Until Element Is Visible    //*[text()='Patient Identifiers']    5s 
    Input Text    ${FirstName_input}    ${FirstName}
    Input Text    ${LastName_input}    ${LastName}   
    Input Text    ${MRN_Input}    ${MRN}
    Input Text    ${DOB_Input}    ${DOB}
    Patient.Select Gender
    Input Text    ${HomePhone_input}    ${HomePhone}
    Input Text    ${CellPhone_input}    ${CellPhone}    
    Input Text    ${Email_input}    ${Email} 
    Input Text    ${AddressLine1_input}    ${AddressLine1}
    Input Text    ${City_input}    ${City}
    Select State
    Input Text    ${PostalCode_input}    ${PostalCode}
    Select Primary Payer
    Click Element    //*[@id='ContinueButton']
    
Select State
    Click Element    //*[@id='EmployerState']   
    Select Random From List    //*[@id='EmployerState']    0

Select Primary Payer
    Click Element    ${PrimaryPayerPlan_select}    
    Select Random From List    ${PrimaryPayerPlan_select}    0