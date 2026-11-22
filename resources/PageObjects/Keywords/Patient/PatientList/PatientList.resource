*** Settings ***
Resource    ../../Layers/Patient/PatientList/PatientList.resource
Resource    PatientTools/ImportPatients.resource

*** Keywords ***
Verify Location Dropdown
    [Arguments]    ${expected_list}
    ${location_default_value}    Get Selected List Label    ${patients_location_select}
    Should Be Equal    ${location_default_value}    -- Select A Location --
    ${location_user_list}    Get Location List
    Lists Should Be Equal    ${location_user_list[1:]}    ${expected_list}
    
Verify Patient Information Table
    [Arguments]    ${mrn_arg}    ${location_arg}    ${dict_arg}
    Filter Patient In Patient Page    ${mrn_arg}    ${location_arg}
    ${patient_mrn_row}    Verify Patient MRN Is Visible    ${mrn_arg}
    Verify Patient Image Is Visible    patient_img=${patient_mrn_row}//preceding-sibling::*[3]/*[@class='patientListImage']
    Verify Patient Name Is Visible    patient_name=${patient_mrn_row}//preceding-sibling::*[2]/*[@href]    dict_arg=${dict_arg}
    Verify Patient Contact Information Is Visible    patient_contact_information=${patient_mrn_row}//following-sibling::*[1]/*
    Verify Patient Gender Is Visible    patient_gender=${patient_mrn_row}//following-sibling::*[2]    dict_arg=${dict_arg}
    Verify Patient Inactive Icon Is Not Visible    patient_inactive_icon=${patient_mrn_row}//following-sibling::*[3]/*[contains(@class,'fa-check')]

Verify Patient Image Is Visible
    [Arguments]    ${patient_img}
    Scroll Element Into View    ${patient_img}
    Wait Until Element Is Visible    ${patient_img}    30s

Verify Patient Name Is Visible
    [Arguments]    ${patient_name}    ${dict_arg}
    ${patient_name_text}    Get Text    ${patient_name}
    Should Be Equal    ${patient_name_text}    ${dict_arg.last_name}, ${dict_arg.first_name} ${dict_arg.middle_name}    strip_spaces=True

Verify Patient Contact Information Is Visible
    [Arguments]    ${patient_contact_information}
    ${patient_contact_text}    Get Text    ${patient_contact_information}
    Should Be Equal    ${patient_contact_text}    No Available Information   strip_spaces=True

Verify Patient Gender Is Visible
    [Arguments]    ${patient_gender}    ${dict_arg}
    ${patient_gender_text}    Get Text    ${patient_gender}
    Should Be Equal    ${patient_gender_text}    ${dict_arg.gender}   strip_spaces=True

Verify Patient Inactive Icon Is Not Visible
    [Arguments]    ${patient_inactive_icon}
    Element Should Not Be Visible    ${patient_inactive_icon}

Verify Patient Information Badges
    Check Badge In Patients Page    text_arg=Addresses:    num_arg=0
    Check Badge In Patients Page    text_arg=ICD Codes:    num_arg=0
    Check Badge In Patients Page    text_arg=Payers:    num_arg=0
    Check Badge In Patients Page    text_arg=Provider Orders:    num_arg=0
    Check Badge In Patients Page    text_arg=Scheduled Appointments:    num_arg=0
    Check Badge In Patients Page    text_arg=Medications:    num_arg=0
    Check Badge In Patients Page    text_arg=Active Labs:    num_arg=0

Check Badge In Patients Page
    [Arguments]    ${text_arg}    ${num_arg}
    ${value}    Set Variable    //*[contains(@class,'badge') and contains(text(),'${text_arg}')]/parent::*[@href]/*
    ${value}    Get Text    ${value}
    # Should Be Equal    ${value}    ${text_arg} ${num_arg}\    strip_spaces=True
    Should Be Equal    ${value}    ${text_arg} ${num_arg}    strip_spaces=True

Verify Patient MRN Is Visible
    [Arguments]    ${mrn_arg}
    ${patient_mrn_row}    Set Variable    //*[@id='PatientList']//*[@class='CenterAll' and text()='${mrn_arg}']
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${patient_mrn_row}/following::tr[1]
    Wait Until Element Is Visible    ${patient_mrn_row}/following::tr[1]
    Element Should Not Be Visible    ${patient_mrn_row}\[2]
    RETURN    ${patient_mrn_row}

Verify Search Patient With Invalid MRN
    [Arguments]    ${mrn_arg}    ${location_arg}
    Filter Patient In Patient Page    ${mrn_arg}    ${location_arg}
    Wait Until Page Contains    No Patients Available    30s

Verify Pagination To Navigate To Page List
    [Arguments]    ${mrn_arg}    ${location_arg}
    Filter Patient In Patient Page    ${mrn_arg}    ${location_arg}
    Verify Page Is Selected By Clicking Page Number    page_num=3
    Verify Page Is Selected By Inputing Page Number    page_num=1
    Verify Can Not Find Page Number When Input Out Of Range Value

Verify Page Is Selected By Clicking Page Number
    [Arguments]    ${page_num}
    ${page_nav}    Set Variable    ${top_page}//*[@href and text()=${page_num}]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${page_nav}
    Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    ${page_nav}    class    selected

Verify Page Is Selected By Inputing Page Number
    [Arguments]    ${page_num}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${pagination_input}    ${page_num}
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${got_to_page_btn}
    Set Test Variable    ${num}    1
    ${page_nav}    Set Variable    ${top_page}//*[@href and text()=${page_num}]
    Wait Until Keyword Succeeds    30s    1s    Element Attribute Value Should Be    ${page_nav}    class    selected

Verify Can Not Find Page Number When Input Out Of Range Value
    ${last_page}    SeleniumLibrary.Get Element Attribute    ${pagination_input}    max
    ${num_invalid}    Evaluate    ${last_page} + 1
    Wait Until Keyword Succeeds    30s    1s   Input Text    ${pagination_input}    ${num_invalid}
    Wait Until Keyword Succeeds    30s    1s   Click Button    ${got_to_page_btn}
    ${msg}    Set Variable    Please enter a valid page number between 1 and ${last_page}
    Alert Should Be Present    ${msg}    ACCEPT

Verify Advanced Search To Search Patient
    [Arguments]    ${dict_arg}    ${location_arg}
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientFirstNameSearch']    value_arg=${dict_arg.first_name}    invalid_arg=!@#$%    dict_arg=${dict_arg}    location_arg=${location_arg}
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientLastNameSearch']    value_arg=${dict_arg.last_name}    invalid_arg=!@#$%    dict_arg=${dict_arg}    location_arg=${location_arg}
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientDOBSearch']    value_arg=${dict_arg.dob}    invalid_arg=01/01/1753    dict_arg=${dict_arg}    location_arg=${location_arg}
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientMRNSearch']    value_arg=${dict_arg.mrn}    invalid_arg=!@#$%    dict_arg=${dict_arg}    location_arg=${location_arg}

Find Patient With Advanced Search
    [Arguments]    ${xpath_arg}    ${value_arg}    ${invalid_arg}    ${dict_arg}    ${location_arg}
    Select Location In Patient List    location_arg=${location_arg}
    Input MRN In Patient List    mrn_arg=${dict_arg.mrn}
    Open Display Advanced Search
    Click Clear Advance Search Button
    Patient Row Is Visible With Valid Data    ${xpath_arg}    ${value_arg}    ${dict_arg}
    Click Clear Advance Search Button
    Patient Row Is Not Visible With Invalid Data    ${xpath_arg}    ${invalid_arg}
    Click Close Advance Search Button

Patient Row Is Visible With Valid Data
    [Arguments]    ${xpath_arg}    ${value_arg}    ${dict_arg}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${xpath_arg}    ${value_arg}
    Click Advance Search Button
    Patient List Table Is Visible
    ${patient_mrn_row}    Verify Patient MRN Is Visible    ${dict_arg.mrn}
    Verify Patient Image Is Visible    patient_img=${patient_mrn_row}//preceding-sibling::*[3]/*[@class='patientListImage']
    Verify Patient Name Is Visible    patient_name=${patient_mrn_row}//preceding-sibling::*[2]/*[@href]    dict_arg=${dict_arg}
    Verify Patient Contact Information Is Visible    patient_contact_information=${patient_mrn_row}//following-sibling::*[1]/*
    Verify Patient Gender Is Visible    patient_gender=${patient_mrn_row}//following-sibling::*[2]    dict_arg=${dict_arg}
    Verify Patient Inactive Icon Is Not Visible    patient_inactive_icon=${patient_mrn_row}//following-sibling::*[3]/*[contains(@class,'fa-check')]

Patient Row Is Not Visible With Invalid Data
    [Arguments]    ${xpath_arg}    ${invalid_arg}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${xpath_arg}    ${invalid_arg}
    Click Advance Search Button
    Patient List Table Is Visible
    Wait Until Page Contains    No Patients Available    30s

Verify Advanced Search To Sort Patient
    Check Patient Sorted    sort_arg=MRN    page_size_arg=10    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[3]
    Check Patient Sorted    sort_arg=Date Of Birth    page_size_arg=25    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[2]
    Check Patient Sorted    sort_arg=Last Name    page_size_arg=50    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[1]
    Check Patient Sorted    sort_arg=Recently Changed    page_size_arg=10    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*//following::*[contains(text(),'Last Updated:')]/parent::*
    
Check Patient Sorted
    [Arguments]    ${sort_arg}    ${page_size_arg}    ${xpath_arg}
    Common.Clear Input Field Until Empty    ${find_patient_input}
    Open Display Advanced Search
    Choose Value In Sort By Select    ${sort_arg}
    Select Page Size    ${page_size_arg}
    Click Clear Advance Search Button
    Click Advance Search Button
    Sleep    1s
    ${patient_list_lenght}    SeleniumLibrary.Get Element Count    ${xpath_arg}
    Should Be Equal As Integers    ${patient_list_lenght}    ${page_size_arg} 

Search Inactive Patient With Advanced Search
    ${check_advanced_search_visIble}    Run Keyword And Return Status    Wait Until Element Is Visible    ${advanced_search_text}    2s
    IF    '${check_advanced_search_visIble}' == '${False}'
        Open Display Advanced Search
    END
    Click Clear Advance Search Button
    ${check_show_inactive_checked}    Run Keyword And Return Status    Checkbox Should Be Selected    ${show_inactive_patient_checkbox}
    IF    '${check_show_inactive_checked}' == '${False}'
        Click Show Inactive Patients Checkbox
    END
    Click Advance Search Button

Verify Inactive Patient
    [Arguments]    ${mrn_arg}
    ${patient_inactive_icon}    Set Variable    xpath=//*[@id='PatientList']//*[@class='CenterAll' and text()='${mrn_arg}']//following-sibling::*[2]
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${patient_inactive_icon}
    Wait Until Element Is Visible    ${patient_inactive_icon}    30s
