*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime
Library    String
Library    pandas
Library    FakerLibrary    AS    faker
Variables    ../Locators/CommonLocator.py
Variables    ../TestData/Testdata.py
Variables    ../Locators/Patient.py
Resource    ../../../libraries/Util.resource
*** Keywords ***
Create Dictionary Of Patient Data
    &{PatientData}    Create Dictionary
    Set Suite Variable    ${PatientData}
Go To Patients Page
    Click Element    ${PatientsLink}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Patients
Close Modal
    Sleep    1s
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']    60s
    Wait Until Keyword Succeeds    60s    1s    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    30s
Filter Location In Patients Page
    [Arguments]    ${Location_arg}
    Select From List By Label    ${Patients_Location_Select}    ${Location_arg}
    Sleep    2s
    Wait Until Keyword Succeeds    10 times    3s    List Selection Should Be    ${Patients_Location_Select}    ${Location_arg}
    Wait Patient List Loading

Check Patient In Patients Page
    [Arguments]    ${MRN_arg_1}    ${MRN_arg_2}    ${MRN_arg_3}
    Set Suite Variable    ${Inactive_Patient}    ${False}
    Check Patient Duplicated Or Not    MRN_arg=${MRN_arg_1}
    Set Suite variable    ${Check_Merge_Patient}    ${False}
    IF    ${Check_2} == ${True} or ${Check_3} == ${True}
        Check Patient Duplicated Or Not    MRN_arg=${MRN_arg_2}   
        IF    ${Check_2} == ${True} or ${Check_3} == ${True}
            ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_Text}
            Delete Patient    xpath_arg=${Patient_MRN_Text}    Merge_MRN_arg=${MRN_arg_3}
            Check Patient Deleted
        END
    END
    Set Suite Variable    ${PatientData}

Check Patient Duplicated Or Not
    [Arguments]    ${MRN_arg}
    Set Suite Variable    ${MRN}    ${MRN_arg}
    Find Patient In Patients Page    MRN_arg=${MRN_arg}
    ${Check_1}    Run Keyword And Return Status    Wait Until Page Contains    No Patients Available    #check 1: if MRN displayed or not
    Set Suite Variable    ${Check_2}    ${False}    #check 2: if exact MRN displayed or not
    Set Suite Variable    ${Check_3}    ${False}    #check 3: if inactive patient or not
    IF    ${Check_1} == ${False}
        ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_Text}
        ${Check_2}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s     Scroll Element Into View    ${Patient_MRN_Text}
        Set Suite Variable    ${Check_2}
        ${Inactive_Patient}    Run Keyword And Return Status    Element Should Be Visible    ${Patient_MRN_Text}/following::*[contains(@class,'fa-check')]
        Set Suite Variable    ${Inactive_Patient}
    ELSE
        Check Inactive Patient
    END
    Set To Dictionary    ${PatientData}    MRN=${MRN}
    Set Suite Variable    ${PatientData}

Find Patient In Patients Page
    [Arguments]    ${MRN_arg}
    Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Click Button    ${Patients_Clear_Btn}
    ${name_search}    Get Value    ${Find_Patient_Input}
    Should Be Equal    ${name_search}    ${EMPTY}
    Input Text    ${Find_Patient_Input}    ${MRN_arg}
    Sleep    10s
    Wait Until Keyword Succeeds    10 times    3s    Click Button    ${Find_Patient_Btn}
    Wait Patient List Loading
    Sleep    5s
    Select Advanced Search
    Check Inactive Checkbox
    Wait Patient List Loading
    execute javascript    ClearAdvancedSearch()
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@id='PatientList']//*[contains(@class,'table')]
    Wait Until Element Is Visible    //*[@id='PatientList']//*[contains(@class,'table')]    30s

Delete Patient
    [Arguments]    ${xpath_arg}    ${Merge_MRN_arg}
    Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Set Suite Variable    ${MRN}    ${PatientData.MRN}
    Go To Update Patient Page    xpath_arg=${xpath_arg}
    ${Patient_MRN_Input}    Util.Replace Xpath    xpath=${Patient_MRN_Input}
    Element Should Be Visible    ${Patient_MRN_Input}
    Util.Scroll To Bottom
    IF    ${Inactive_Patient} == ${False}
        ${Check}    SeleniumLibrary.Get Element Attribute    ${Inactive_Patient_Checkbox}    checked
        Should Be Equal As Strings    ${Check}    None
    ELSE
        Element Attribute Value Should Be    ${Inactive_Patient_Checkbox}    checked    true
    END
    Wait Until Element Is Visible    ${Delete_Patient_Link}    30s
    ${check}    Run Keyword And Return Status    Click Element    ${Delete_Patient_Link}    #issue (QA)
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    30s    1s    Execute JavaScript    return document.evaluate("${Delete_Patient_Link}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    ${is_warning}    Run Keyword And Return Status    Wait Until Element Is Visible    id=AlertModal    10s
    IF    ${is_warning} == ${True}
        Scroll Element Into View    id=CloseAlertModal
        Sleep    1s
        Wait Until Keyword Succeeds    10 times    3s    Click Button    id=CloseAlertModal
        Wait Until Element Is Not Visible    id=AlertModal    15s
        Delete Patient With Appointment    merge_mrn_arg=${Merge_MRN_arg}
    ELSE
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${Delete_Patient_Link}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
        ${is_alert}    Run Keyword And Return Status    Alert Should Be Present
        IF    ${is_alert} == ${True}
            Delete Patient With No Appointment
        ELSE
            Wait Until Page Does Not Contain    Can not delete patient because they have been assigned to an appointment    10s
            Delete Patient With Appointment    merge_mrn_arg=${Merge_MRN_arg}
        END
    END

Delete Patient With Appointment
    [Arguments]    ${merge_mrn_arg}
    IF    ${Inactive_Patient} == ${False}    #if inactive patient
        Click Element    ${Cancel_Update_Patient_Btn}
    ELSE
        Sleep    1s
        Wait Until Keyword Succeeds    10s    1s    Click Element    ${Inactive_Patient_Checkbox}
        Set Suite Variable    ${Inactive_Patient}    ${False}    #patient not set inactive anymore
        Click Element    ${Patients_Update_Btn}
    END
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients
    Create Patient To Merge    Merge_MRN_arg=${merge_mrn_arg}
    Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Merge Patient    Keeping_MRN_arg=${merge_mrn_arg}    #delete patient and merge all info, apt the patient another patient
    Set Suite Variable    ${Check_Merge_Patient}    ${True}

Delete Patient With No Appointment
    ${is_alert}    Run Keyword And Return Status   Handle Alert    ACCEPT    5s
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Patients

Go To Update Patient Page
    [Arguments]    ${xpath_arg}
    ${xpath_arg}    Util.Replace Xpath    xpath=${xpath_arg}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${xpath_arg}/following::tr[1]
    Element Should Not Be Visible    ${xpath_arg}\[2]
    Click Element    ${xpath_arg}/preceding::*[2]
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Update Patient
Create Patient To Merge
    [Arguments]    ${Merge_MRN_arg}
    Find Patient In Patients Page    MRN_arg=${Merge_MRN_arg}
    Set Suite Variable    ${MRN}    ${Merge_MRN_arg}
    ${Patient_MRN_Text}    Util.Replace Xpath    ${Patient_MRN_Text}
    ${Check_Merge_Patient}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3 times    3s    Scroll Element Into View    ${Patient_MRN_Text}
    Set Suite Variable    ${Check_Merge_Patient}
    IF    ${Check_Merge_Patient} == ${False}
        Patient.Create Patient    First_Name_arg=Merge    Last_Name_arg=Patient    DOB_arg=01/01/2000    Weight_arg=20    Height_arg=30
        Go To Patients Page
    ELSE
        Set Suite Variable    ${MRN}    ${Merge_MRN_arg}
        Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
        Util.Scroll To Bottom
        ${is_inactive}    SeleniumLibrary.Get Element Attribute    ${Inactive_Patient_Checkbox}    checked
        ${check}    Run Keyword And Return Status    Should Be Equal As Strings    ${is_inactive}    None
        IF    ${check} == ${True}
            Click Element    ${Patients_Update_Btn}
        ELSE
            Sleep    1s
            Wait Until Keyword Succeeds    5s    1s    Click Element    ${Inactive_Patient_Checkbox}
            Util.Scroll To Bottom
            Click Element    ${Patients_Update_Btn}
        END
        Wait Until Keyword Succeeds    5s    1s    Title Should Be    Patients
    END
Check Inactive Patient
    Select Advanced Search
    Check Inactive Checkbox
    Wait Patient List Loading
    ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_Text}
    ${Check_Inactive_Found}    Run Keyword And Return Status    Scroll Element Into View    ${Patient_MRN_Text}/following::*[contains(@class,'fa-check')]
    IF    ${Check_Inactive_Found} == ${True}
        Set Suite Variable    ${Check_3}    ${True}
        Set Suite Variable    ${Inactive_Patient}    ${True}
    END

Select Advanced Search
    ${Check_Advanced_Search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${Check_Advanced_Search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${Advanced_Search_Btn}
    END
    ${Check}    SeleniumLibrary.Get Element Attribute    ${Show_Inactive_Patient_Checkbox}    checked
    Set Suite Variable    ${Check}

Check Inactive Checkbox
    ${Check_Inactive_Selected}    Run Keyword And Return Status    Should Be Equal As Strings    ${Check}    None
    IF    ${Check_Inactive_Selected} == ${True}
        Wait Until Element Is Visible    ${Show_Inactive_Patient_Checkbox}    10s
        Click Element    ${Show_Inactive_Patient_Checkbox}
    END

Wait Patient List Loading
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Search_Patient_Loading}
    IF    ${check} == ${True}
        Wait Until Element Is Not Visible    ${Search_Patient_Loading}    60s
    END
Merge Patient
    [Arguments]    ${Keeping_MRN_arg}
    Click Button    ${Patient_Tools_Btn}
    Click Element    ${Merge_Patient_Link}
    Wait Until Element Is Visible    ${Merge_Patient_Popup}    60s
    Set Suite Variable    ${Location}    ${PatientData.Location}
    Sleep    1s
    Input Text    ${Removing_Input}    ${PatientData.MRN}
    Select Patient To Merge    mrn_arg=${PatientData.MRN}
    Input Text    ${Keeping_Input}    ${Keeping_MRN_arg}
    Select Patient To Merge    mrn_arg=${Keeping_MRN_arg}
    Sleep    5s
    ${check}    Run Keyword And Return Status    Click Button    ${Merge_Btn}
    Run Keyword If    ${check} == ${False}    Execute JavaScript    return document.evaluate("${Merge_Btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Handle Alert    ACCEPT
    Wait Until Page Contains    Appointments Successfully Merged & Patient Deleted    300s
    Wait Until Page Does Not Contain    Appointments Successfully Merged & Patient Deleted

Select Patient To Merge
    [Arguments]    ${mrn_arg}
    Set Suite Variable    ${Merge_MRN}    ${mrn_arg}
    ${Merge_Patient_Text}    Util.Replace Xpath    xpath=${Merge_Patient_Text}
    Wait Until Element Is Visible    ${Merge_Patient_Text}    60s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${Merge_Patient_Text}

Check Patient Deleted
    Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${Advanced_Search_Btn}
    Wait Patient List Loading
    ${Check}    SeleniumLibrary.Get Element Attribute    ${Show_Inactive_Patient_Checkbox}    checked
    Set Suite Variable    ${Check}
    Check Inactive Checkbox
    ${check_no_patient_found}    Run Keyword And Return Status    Wait Until Page Contains    No Patients Available
    IF    ${check_no_patient_found} == ${False}
        Set Suite Variable    ${MRN}    ${PatientData.MRN}
        ${Patient_MRN_Text}    Util.Replace Xpath    ${Patient_MRN_Text}
        ${check_no_patient_found_2}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${Patient_MRN_Text}\[2]
        Should Be Equal    ${check_no_patient_found_2}    ${False}
    END
Create Patient
    [Arguments]    ${First_Name_arg}    ${Last_Name_arg}    ${DOB_arg}    ${Weight_arg}    ${Height_arg}
    Click Element    ${New_Patient_Link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient
    Input Text    ${First_Name_Input}    ${First_Name_arg}
    Input Text    ${Last_Name_Input}    ${Last_Name_arg}
    IF    ${Check_Merge_Patient} == ${False}
        Input Text    ${MRN_Input}    ${MRN}
    ELSE
        Input Text    ${MRN_Input}    ${PatientData.MRN}
    END
    Input Text    ${DOB_Input}    ${DOB_arg}
    Select Gender    #random
    Input Text    ${Weight_Input}    ${Weight_arg}
    Input Text    ${Height_Input}    ${Height_arg}
    Util.Scroll To Bottom
    Click Element   ${Patients_Save_Btn}
    Wait Until Element Is Visible    ${MB_Logo}    30s
    Check Weight Converted    ${Weight_arg}
    Set To Dictionary    ${PatientData}    First_Name=${First_Name_arg}    Last_Name=${Last_Name_arg}    DOB=${DOB_arg}    Gender=${Gender}    Weight=${Weight_arg} kg    Height=${Height_arg} inches    #in
    Set Suite Variable    ${PatientData}

Check Weight Converted
    [Arguments]    ${Weight_arg}
    Scroll Element Into View    ${Weight_LB_Input}
    ${Weight_LB}    SeleniumLibrary.Get Element Attribute    ${Weight_LB_Input}    value
    ${Check_Weight}    Evaluate    round(${Weight_arg}*2.2046)    #1kg ~ 2.2046lb
    Should Be Equal As Numbers    ${Check_Weight}    ${Weight_LB}    precision=0.1

Check Height Converted
    [Arguments]    ${Height_arg}
    ${Height}    SeleniumLibrary.Get Element Attribute    ${Height_Input}    value
    ${Check_Height}    Evaluate    round(${Height_arg}*2.54)    #1in ~ 2.54cmS
    Should Be Equal    ${Check_Height}    ${Height}    precision=0.1

Check Patient Created
    Go To Patients Page
    Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Set Suite Variable    ${MRN}    ${PatientData.MRN}
    Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
    ${Patient_MRN_Input}    Util.Replace Xpath    xpath=${Patient_MRN_Input}
    Element Should Be Visible    ${Patient_MRN_Input}

Select Gender
    ${Gender_List}    Get List Items    ${Gender_Select}
    ${Num_Gender}    Get Length    ${Gender_List}
    ${i}    Evaluate    random.randint(1,${Num_Gender-1})    #get random index from nurse list
    Select From List By Label    ${Gender_Select}    ${Gender_List}[${i}]
    Set Suite Variable    ${Gender}    ${Gender_List}[${i}]

Update Patient
    Go To Patients Page
    Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
    ${fail}    Run Multiple Keywords And Return Status
    ...    Update First Name
    ...    Update Last_Name
    ...    Update DOB
    ...    Update Gender
    ...    Update Weight
    ...    Patient.Update Height
    Set Test Variable    ${fail}
    Save Change
    Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
    Check Patient Updated

Update First Name
    Update Text Field    xpath_arg=${First_Name_Input}    field_arg=First_Name    keyword_arg=faker.First Name

Update Last_Name
    Update Text Field    xpath_arg=${Last_Name_Input}    field_arg=Last_Name    keyword_arg=faker.Last Name
Update DOB
    Update Time Field    xpath_arg=${DOB_Input}    field_arg=DOB
    Click Button    ${Close_Calendar_Btn}
Update Gender
    Update Select Field    xpath_arg=${Gender_Select}    field_arg=Gender
Update Weight
    Update Nummeric Field    xpath_arg=${Weight_Input}    field_arg=Weight    min_arg=50    max_arg=70    decimal_pos=0    unit=kg
Update Height
    Update Nummeric Field    xpath_arg=${Height_Input}    field_arg=Height    min_arg=5    max_arg=7    decimal_pos=1    unit=in

Update Text Field
    [Arguments]    ${xpath_arg}    ${field_arg}    ${keyword_arg}
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${xpath_arg}    #mouse over
    Clear Element Text    ${xpath_arg}
    ${field_update}    Run Keyword    ${keyword_arg}  
    WHILE    "${field_update}" == "${PatientData.${field_arg}}"
        ${field_update}    Run Keyword    ${keyword_arg}
    END
    Input Text    ${xpath_arg}    Test${field_update}
    Set To Dictionary    ${PatientData}    Old_${field_arg}=${PatientData.${field_arg}}
    Set To Dictionary    ${PatientData}    ${field_arg}=Test${field_update}
    Set Test Variable    ${PatientData}

Update Time Field
    [Arguments]    ${xpath_arg}    ${field_arg}
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${xpath_arg}
    Clear Element Text    ${xpath_arg}
    ${time_update}    Evaluate    datetime.date(random.randint(1974,2024), random.randint(1,12), random.randint(1,28))
    ${d}    Set Variable    ${time_update.day}
    ${m}    Set Variable    ${time_update.month}
    ${y}    Set Variable    ${time_update.year}
    ${time_update}    Convert Date    ${m}/${d}/${y}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
    Input Text    ${xpath_arg}    ${time_update}
    Set To Dictionary    ${PatientData}    Old_${field_arg}=${PatientData.${field_arg}}
    Set To Dictionary    ${PatientData}    ${field_arg}=${time_update}
    Set Test Variable    ${PatientData}

Update Select Field
    [Arguments]    ${xpath_arg}    ${field_arg}
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${xpath_arg}
    ${select_list}    Get List Items    ${xpath_arg}
    ${length_list}    Get Length    ${select_list}
    ${select}    Get Selected List Label    ${xpath_arg}
    WHILE    "${select}" == "${PatientData.${field_arg}}" or "Select a Gender" in "${select}"
        ${index}    Evaluate    random.randint(0,${length_list-1})
        Select From List By Index    ${xpath_arg}    ${index}    #random
        ${select}    Get Selected List Label    ${xpath_arg}
    END
    Set To Dictionary    ${PatientData}    Old_${field_arg}=${PatientData.${field_arg}}
    Set To Dictionary    ${PatientData}    ${field_arg}=${select}
    Set Test Variable    ${PatientData}

Update Nummeric Field
    [Arguments]    ${xpath_arg}    ${field_arg}    ${min_arg}    ${max_arg}    ${decimal_pos}    ${unit}    #pos:position
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${xpath_arg}
    Clear Element Text    ${xpath_arg}
    ${field_update}    Set Variable    ${PatientData.${field_arg}}
    WHILE    "${field_update}" == "${PatientData.${field_arg}}"
        IF    ${decimal_pos} == 0
            ${field_update}    Evaluate    random.randint(${min_arg},${max_arg})
        ELSE
            ${field_update}    Evaluate    round(random.uniform(${min_arg},${max_arg}),${decimal_pos})
        END
        ${field_update}    Set Variable    ${field_update}
    END
    Input Text    ${xpath_arg}    ${field_update}
    Set To Dictionary    ${PatientData}    Old_${field_arg}=${PatientData.${field_arg}}
    Set To Dictionary    ${PatientData}    ${field_arg}=${field_update} ${unit}
    Set Test Variable    ${PatientData}

Save Change
    Execute JavaScript  document.activeElement.blur()
    Scroll Element Into View    ${save_changes_btn}
    Wait Until Element Is Visible    ${save_changes_btn}    30s
    Sleep    3s
    Click Element    ${save_changes_btn}
    Wait Until Keyword Succeeds    10s    1s    Title Should Be    Patients

Check Patient Updated
    Check Field Updated    xpath_arg=${First_Name_Input}    field_arg=First_Name    type_arg=input
    Check Field Updated    xpath_arg=${Last_Name_Input}    field_arg=Last_Name    type_arg=input
    Check Field Updated    xpath_arg=${DOB_Input}    field_arg=DOB    type_arg=input
    Check Field Updated    xpath_arg=${Gender_Select}    field_arg=Gender    type_arg=select
    Check Field Updated    xpath_arg=${Height_Input}    field_arg=Height    type_arg=input_unit
    Check Field Updated    xpath_arg=${Weight_Input}    field_arg=Weight    type_arg=input_unit

Check Field Updated
    [Arguments]    ${xpath_arg}    ${field_arg}    ${type_arg}
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${xpath_arg}
    IF    "${type_arg}" != "select"
        IF    "${type_arg}" == "input_unit"
            ${check}    Fetch From Left    ${PatientData.${field_arg}}    \ \    #exclude unit in value
        ELSE
            ${check}    Set Variable    ${PatientData.${field_arg}}
        END
        Element Attribute Value Should Be    ${xpath_arg}    value    ${check}
    ELSE
        List Selection Should Be    ${xpath_arg}    ${PatientData.${field_arg}}
    END
    Should Not Be Equal    ${check}    ${PatientData.Old_${field_arg}}

Verify Location Dropdown
    Element Should Be Visible    //*[@type='button' and @title='-- Select A Location --']
    ${list}    Create List    QCA1    QCA2    QCA3
    IF    "qa" in "${SiteUrl}" or "secure" in "${SiteUrl}"    #QA setting not set
        ${list}    Create List    QCA1
    END
    ${locations}    Get List Items    ${Patients_Location_Select}
    Remove From List    ${locations}    0
    Lists Should Be Equal    ${locations}    ${list}

Verify Patient Information Table
    Patient.Filter Location In Patients Page    Location_arg=QCA1
    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientData.MRN}
    Sleep    5s
    Click Button    ${Find_Patient_Btn}
    Wait Patient List Loading
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    ${patient_img}    Util.Replace Xpath    xpath=${patient_img}
    Scroll Element Into View    ${patient_img}
    Wait Until Element Is Visible    ${patient_img}    30s
    Element Should Be Visible    //*[@class='patientListImage']
    ${patient_name_text}    Util.Replace Xpath    xpath=${patient_name_text}
    ${name}    Get Text    ${patient_name_text}
    Should Be Equal    ${name}    ${PatientData.Last_Name}, ${PatientData.Middle_Name} ${PatientData.First_Name}    strip_spaces=True
    ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_text}
    Element Should Be Visible    ${Patient_MRN_text}
    ${patient_contact_text}    Util.Replace Xpath    xpath=${patient_contact_text}
    ${contact}    Get Text    ${patient_contact_text}
    Should Be Equal    ${contact}    No Available Information   strip_spaces=True
    ${patient_gender_text}    Util.Replace Xpath    xpath=${patient_gender_text}
    ${gender}    Get Text    ${patient_gender_text}
    Should Be Equal    ${gender}    ${PatientData.Gender}   strip_spaces=True
    ${patient_inactive_icn}    Util.Replace Xpath    xpath=${patient_inactive_icn}
    Element Should Not Be Visible    ${patient_inactive_icn}

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
    Set Test Variable    ${text}    ${text_arg}
    ${value}    Util.Replace Xpath    xpath=${patient_badge_link}
    ${value}    Get Text    ${value}
    Should Be Equal    ${value}    ${text} ${num_arg}\    strip_spaces=True

Verify Search Patient By MRN
    Patient.Find Patient In Patients Page    MRN_arg=${PatientData.MRN}
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_Text}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${Patient_MRN_Text}/following::tr[1]
    Wait Until Element Is Visible    ${Patient_MRN_Text}/following::tr[1]
    Element Should Not Be Visible    ${Patient_MRN_Text}\[2]
    Patient.Find Patient In Patients Page    MRN_arg=!@#$%
    Wait Until Page Contains    No Patients Available    30s

Verify Pagination To Navigate To Page List
    Click Button    ${Patients_Clear_Btn}
    Click Button    ${Find_Patient_Btn}
    Wait Patient List Loading
    ${is_with_pagination}    Run Keyword And Return Status    Page Should Contain Element    //*[contains(@class,'pager-navigation') and contains(@class,'TopPage')]
    IF    ${is_with_pagination} == ${True}
        Set Test Variable    ${num}    3
        ${page_nav}    Set Variable    //*[contains(@class,'pager-navigation') and contains(@class,'TopPage')]//*[@href and text()=${num}]
        ${page}    Util.Replace Xpath    xpath=${page_nav}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${page}
        Wait Until Keyword Succeeds    10 times    3s    Element Attribute Value Should Be    ${page}    class    selected
        Input Text    //*[@type='number' and contains(@class,'TopPage') and @placeholder='Page']    1
        Click Button    //*[@type='button' and contains(@class,'TopPage') and text()='Go']
        Set Test Variable    ${num}    1
        ${page}    Util.Replace Xpath    xpath=${page_nav}
        Wait Until Keyword Succeeds    10 times    3s    Element Attribute Value Should Be    ${page}    class    selected
    END
    ${last_page}    SeleniumLibrary.Get Element Attribute    //*[@type='number' and contains(@class,'TopPage') and @placeholder='Page']    max
    ${num_invalid}    Evaluate    ${last_page} + 1
    Sleep    2s
    Input Text    //*[@type='number' and contains(@class,'TopPage') and @placeholder='Page']    ${num_invalid}
    Wait Until Keyword Succeeds    10 times    3s   Click Button    //*[@type='button' and contains(@class,'TopPage') and text()='Go']
    Handle Alert    ACCEPT    30s

Verify Advanced Search To Sort Patient
    Check Patient Sorted    sort_arg=MRN    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[3]
    Check Patient Sorted    sort_arg=Date Of Birth    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[2]
    Check Patient Sorted    sort_arg=Last Name    xpath_arg=//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[1]
    Scroll Element Into View    //*[@id='SortBy']
    Wait Until Element Is Visible    //*[@id='SortBy']    30s
    Select From List By Label    //*[@id='SortBy']    Recently Changed
    Select From List By Label    //*[@id='RowsPerPage']    10
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element     ${Advanced_Search_Btn}
        Wait Until Element Is Visible    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]    30s
    END
    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Patient.Wait Patient List Loading
    ${is_patient_not_found}    Run Keyword And Return Status    Page Should Contain    No Patients Available
    IF    ${is_patient_not_found} == ${False}
        ${elements}    Wait Until Keyword Succeeds    10 times    3s    Get WebElements    //*[@id='PatientList']//*[@class='patientListImage']/parent::*//following::*[contains(text(),'Last Updated:')]/parent::*
        ${count}    Get Length    ${elements}
        @{list}    Create List
        FOR    ${i}    IN RANGE    ${count}
            Scroll Element Into View    ${elements}[${i}]
            ${timestamp}    Wait Until Keyword Succeeds    10 times    3s    Get Text    ${elements}[${i}]
            ${timestamp}    Fetch From Right    ${timestamp}    Last Updated:
            ${timestamp}    Strip String    ${timestamp}
            Append To List    ${list}    ${timestamp}
        END
        ${count}    Get Length    ${list-1}
        IF    ${count} > 1
            FOR    ${i}    IN RANGE    ${count}
                ${check}    Subtract Date From Date    ${list}[${i}]    ${list}[${i+1}]    result_format=number    date1_format=%m/%d/%Y at %I:%M %p    date2_format=%m/%d/%Y at %I:%M %p
                Should Be True    ${check} >= 0
            END
        END
    END

Verify Clear Button In Advanced Search
    Scroll Element Into View    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    10 times    3s    Click Button    ${Patients_Clear_Btn}
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element     ${Advanced_Search_Btn}
    END
    
    Scroll Element Into View    ${advanced_clear_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${advanced_clear_btn}
    Sleep    2s
    Wait Until Element Is Visible    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]    30s
    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Wait Patient List Loading

Verify Number Of Patient Filtered
    Check Number Of Patients Filtered    size_arg=10
    Check Number Of Patients Filtered    size_arg=25
    Check Number Of Patients Filtered    size_arg=50

Verify Advanced Search To Search Patient
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientFirstNameSearch']    value_arg=${PatientData.First_Name}    invalid_arg=!@#$%
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientLastNameSearch']    value_arg=${PatientData.Last_Name}    invalid_arg=!@#$%
    ${invalid_DOB}    Add Time To Date    ${PatientData.DOB}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientDOBSearch']    value_arg=${PatientData.DOB}    invalid_arg=${invalid_DOB}
    Find Patient With Advanced Search    xpath_arg=//*[@id='PatientMRNSearch']    value_arg=${PatientData.MRN}    invalid_arg=!@#$%

Find Patient With Advanced Search
    [Arguments]    ${xpath_arg}    ${value_arg}    ${invalid_arg}
    Patient.Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientData.MRN}
    Execute JavaScript    document.activeElement.blur()
    ${Check_Advanced_Search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${Check_Advanced_Search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${Advanced_Search_Btn}
    END
    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'AdvancedSearch') and text()='Close']
    Wait Until Element Is Not Visible    ${advanced_search_text}    30s
    Sleep    1s
    Click Element    ${Advanced_Search_Btn}
    Wait Until Element Is Visible    ${advanced_search_text}    30s
    Wait Until Element Is Visible    ${advanced_clear_btn}    30s
    Sleep    3s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${advanced_clear_btn}
    Input Text    ${xpath_arg}    ${value_arg}
    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Wait Patient List Loading
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@id='PatientList']//*[contains(@class,'table')]
    Wait Until Element Is Visible    //*[@id='PatientList']//*[contains(@class,'table')]    30s
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    ${patient_img}    Util.Replace Xpath    xpath=${patient_img}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${patient_img}
    Wait Until Element Is Visible    ${patient_img}    30s
    Element Should Be Visible    //*[@class='patientListImage']
    ${patient_name_text}    Util.Replace Xpath    xpath=${patient_name_text}
    ${name}    Get Text    ${patient_name_text}
    Should Be Equal    ${name}    ${PatientData.Last_Name}, ${PatientData.Middle_Name} ${PatientData.First_Name}    strip_spaces=True
    ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_text}
    Element Should Be Visible    ${Patient_MRN_text}
    ${patient_contact_text}    Util.Replace Xpath    xpath=${patient_contact_text}
    ${contact}    Get Text    ${patient_contact_text}
    Should Be Equal    ${contact}    No Available Information   strip_spaces=True
    ${patient_gender_text}    Util.Replace Xpath    xpath=${patient_gender_text}
    ${gender}    Get Text    ${patient_gender_text}
    Should Be Equal    ${gender}    ${PatientData.Gender}   strip_spaces=True
    ${patient_inactive_icn}    Util.Replace Xpath    xpath=${patient_inactive_icn}
    Element Should Not Be Visible    ${patient_inactive_icn}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${advanced_clear_btn}
    Input Text    ${xpath_arg}    ${invalid_arg}
    Sleep    1s
    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Wait Patient List Loading
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@id='PatientList']//*[contains(@class,'table')]
    Wait Until Element Is Visible    //*[@id='PatientList']//*[contains(@class,'table')]    30s
    Wait Until Page Contains    No Patients Available    30s

Check Patient Sorted
    [Arguments]    ${sort_arg}    ${xpath_arg}
    Scroll Element Into View    //*[@id='SortBy']
    Wait Until Element Is Visible    //*[@id='SortBy']    30s
    Select From List By Label    //*[@id='SortBy']    ${sort_arg}
    Select From List By Label    //*[@id='RowsPerPage']    10
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element     ${Advanced_Search_Btn}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${advanced_clear_btn}
        Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
        Patient.Wait Patient List Loading
    END
    @{values}    Create List
    ${elements}    Wait Until Keyword Succeeds    10 times    3s    Get WebElements    ${xpath_arg}    #//*[@id='PatientList']//*[@class='patientListImage']/parent::*/following-sibling::*[3]
    FOR    ${element}    IN    @{elements}
        Scroll Element Into View    ${element}
        Wait Until Element Is Visible    ${element}    30s
        ${value}    Get Text    ${element}
        Append To List    ${values}    ${value}
    END
    ${list_origin}    Copy List    ${values}
    Sort List    ${values}
    Should Be Equal    ${values}    ${list_origin}

Check Number Of Patients Filtered
    [Arguments]    ${size_arg}
    Select From List By Label    //*[@id='RowsPerPage']    ${size_arg}
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element     ${Advanced_Search_Btn}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${advanced_clear_btn}
        ${first}    Get Value    //*[@id='PatientFirstNameSearch']
        Should Be Equal    ${first}    ${null}
        ${last}    Get Value    //*[@id='PatientLastNameSearch']
        Should Be Equal    ${last}    ${null}
        ${DOB}    Get Value    //*[@id='PatientDOBSearch']
        Should Be Equal    ${DOB}    ${null}
        ${MRN}    Get Value    //*[@id='PatientMRNSearch']
        Should Be Equal    ${MRN}    ${null}
        Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
        Patient.Wait Patient List Loading
    END
    ${is_patient_found}    Run Keyword And Return Status    Page Should Contain    No Patients Available
    IF    ${is_patient_found} == ${False}
        ${list}    Wait Until Keyword Succeeds    10 times    3s    Get WebElements    //*[@id='PatientList']//*[@class='patientListImage']/ancestor::*[2]
        ${count}    Get Length    ${list}
        Should Be True    ${count} <= ${size_arg}
    END

Set Value To Excel Field
    [Arguments]    ${df}    ${field}    ${value}
    FOR    ${i}    IN    @{keys}
        IF    "${field}" in "${i}"
            ${df}    CustomLibrary.Edit Excel Field    df=${df}    field=${i}    value=${value}
            BREAK
        END
    END
    RETURN    ${df}

Open Import Patient Modal
    Click Button    //*[@type='button' and normalize-space(text())="Patient Tools"]
    Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[@id='ImportPatients']
    Wait Until Element Is Visible    //*[@id='ModalPopup']    30s
    ${is_new_import}    Run Keyword And Return Status    Element Should Not Be Visible    //*[@id='RestartBtn']
    IF    ${is_new_import} == ${False}
        Click Button    //*[@id='RestartBtn']
    END
    Wait Until Element Is Visible    //*[@id='UploadFile']    30s

Upload Patient File
    [Arguments]    ${color_arg}    ${text_arg}
    Choose File    ${patient_upload_file_input}    ${path}
    ${filename}    Execute JavaScript    return document.getElementById('UploadFile').files[0].name;
    Should Be Equal    ${filename}    ${file_patient}
    Click Button    ${patient_process_file_button}
    Set Suite Variable    ${color}    ${color_arg}
    Set Suite Variable    ${text}    ${text_arg}
    ${status_text}    Util.Replace Xpath    xpath=${patient_preimport_status_text}
    Wait Until Element Is Visible    ${status_text}    30s

Import File With Empty Account Number
    Patient.Go To Patients Page
    Patient.Filter Location In Patients Page    Location_arg=${location}
    Patient.Open Import Patient Modal
    ${path}    Get Environment Variable    EXPORT_PATH
    Set Test Variable    ${file_patient}    PatientImportTemplate.xlsx
    Set Suite Variable    ${path}    ${path}/${file_patient}
    ${check}    Run Keyword And Return Status    Remove File    ${path}
    Click Element    ${patient_template_download_button}
    Wait Until Keyword Succeeds    20 times    3s   Should Exist    ${path}
    ${df}    CustomLibrary.Read Excel File    path=${path}
    ${keys}    Set Variable    ${df.keys()}
    ${keys}    Convert To List    ${keys}
    Set Suite Variable    ${keys}
    ${df}    CustomLibrary.Read Excel File    path=${path}
    ${invalid_ID}    Evaluate    random.choice(["testid","test12","test!#","test12!#","123#$%","!#$%&*"])
    ${df}    Set Value To Excel Field    df=${df}    field=Account\ \#    value=${invalid_ID}
    ${df}    Set Value To Excel Field    df=${df}    field=First Name    value=${first_name}
    ${df}    Set Value To Excel Field    df=${df}    field=Last Name    value=${last_name}
    ${df}    Set Value To Excel Field    df=${df}    field=MRN    value=${MRN}
    ${df}    Set Value To Excel Field    df=${df}    field=DOB    value=${DOB}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Set Test Variable    ${path}
    Patient.Upload Patient File    color_arg=red    text_arg=Error
    Wait Until Page Contains    Could not find an account with identifiers provided    30s
    Click Button    //*[@id='SaveBtn' and normalize-space(text())='Remove Error Lines']
    Wait Until Page Contains    All Erorr Lines Removed    30s
    Wait Until Element Is Visible    //*[@id='UploadFile']    30s
    ${df}    Set Value To Excel Field    df=${df}    field=Account\ \#    value=${location_ID}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Set Suite Variable    ${df}
    Patient.Close Modal

Import File With Empty First Name
    Patient.Open Import Patient Modal
    ${df}    Set Value To Excel Field    df=${df}    field=First Name    value=${EMPTY}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Patient.Upload Patient File    color_arg=red    text_arg=Error
    Wait Until Page Contains    First Name Missing    30s
    ${df}    Set Value To Excel Field    df=${df}    field=First Name    value=${first_name}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Set Suite Variable    ${df}
    Patient.Close Modal

Import File With Empty Last Name
    Patient.Open Import Patient Modal
    ${df}    Set Value To Excel Field    df=${df}    field=Last Name    value=${EMPTY}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Patient.Upload Patient File    color_arg=red    text_arg=Error
    Wait Until Page Contains    Last Name Missing    30s
    ${df}    Set Value To Excel Field    df=${df}    field=Last Name    value=${last_name}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Set Suite Variable    ${df}
    Patient.Close Modal

Import File With Empty DOB
    Patient.Open Import Patient Modal
    ${df}    Set Value To Excel Field    df=${df}    field=DOB    value=${EMPTY}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Patient.Upload Patient File    color_arg=red    text_arg=Error
    Wait Until Page Contains    Invalid DOB Supplied    30s
    ${df}    Set Value To Excel Field    df=${df}    field=DOB    value=${DOB}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Set Suite Variable    ${df}
    Patient.Close Modal

Import File With Gender Field
    Patient.Open Import Patient Modal
    ${gender}    Evaluate    random.choice(["M","F","O"])
    ${df}    Set Value To Excel Field    df=${df}    field=Gender    value=${gender}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    IF    "${gender}" == "M"
        ${gender}    Set Variable    Male
    ELSE IF    "${gender}" == "F"
        ${gender}    Set Variable    Female
    ELSE
        ${gender}    Set Variable    Other
    END
    Set Test Variable    ${gender}
    Patient.Upload Patient File    color_arg=green    text_arg=Success
    Click Button    //*[@type='submit' and @id='SaveBtn']
    Wait Until Keyword Succeeds    10 times    3s    Handle Alert
    Wait Until Page Contains    File Successfully Imported    30s
    Wait Until Page Does Not Contain    File Successfully Imported    30s
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    30s
    Set Suite Variable    ${df}
    Add To Dictionary    dic_arg=${PatientData}    key_arg=Location    val_arg=${location}
    Patient.Find Patient In Patients Page    MRN_arg=${MRN}
    Set Test Variable    ${MRN}    ${MRN}
    ${patient_gender_text}    Util.Replace Xpath    xpath=${patient_gender_text}
    ${text}    Wait Until Keyword Succeeds    10 times    3s    Get Text    ${patient_gender_text}
    Should Be Equal    ${gender}    ${text}    strip_spaces=True

Import File With Same MRN To Update Patient Info
    Patient.Open Import Patient Modal
    ${df}    Set Value To Excel Field    df=${df}    field=First Name    value=update_${first_name}
    ${df}    Set Value To Excel Field    df=${df}    field=Last Name    value=update_${last_name}
    ${DOB}    Add Time To Date    ${DOB}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${df}    Set Value To Excel Field    df=${df}    field=DOB    value=${DOB}
    ${df}    CustomLibrary.Save Excel File    path=${path}    df=${df}
    Patient.Upload Patient File    color_arg=green    text_arg=Success
    Click Button    //*[@type='submit' and @id='SaveBtn']
    Wait Until Keyword Succeeds    10 times    3s    Handle Alert
    Wait Until Page Contains    File Successfully Imported    30s
    Wait Until Page Does Not Contain    File Successfully Imported    30s
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    30s
    Set Suite Variable    ${df}
    Patient.Find Patient In Patients Page    MRN_arg=${MRN}
    Set Test Variable    ${MRN}    ${MRN}
    ${patient_name_text}    Util.Replace Xpath    xpath=${patient_name_text}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${patient_name_text}
    ${text}    Wait Until Keyword Succeeds    10 times    3s    Get Text    ${patient_name_text}
    Should Be Equal    ${text}    update_${last_name}, update_${first_name}    strip_spaces=True
    ${patient_DOB_text}    Util.Replace Xpath    xpath=${patient_DOB_text}
    ${text}    Get Text    ${patient_DOB_text}
    Should Be Equal    ${text}    ${DOB}    strip_spaces=True
    ${patient_gender_text}    Util.Replace Xpath    xpath=${patient_gender_text}
    ${text}    Get Text    ${patient_gender_text}
    Should Be Equal    ${gender}    ${text}    strip_spaces=True

Inactivate Patient And Search Patient
    Patient.Go To Patients Page
    Patient.Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientData.MRN}
    Execute JavaScript    document.activeElement.blur()
    Patient.Verify Clear Button In Advanced Search
    Wait Until Element Is Visible    //*[@id='PatientList']//*[contains(@class,'table')]    30s
    Scroll Element Into View    //*[@id='PatientList']//*[contains(@class,'table')]
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    ${Patient_MRN_Text}    Util.Replace Xpath    xpath=${Patient_MRN_Text}
    Patient.Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
    Util.Scroll To Bottom
    Util.Check Or Uncheck Box    view_arg=${True}    xpath_arg=${Inactive_Patient_Checkbox}
    Util.Scroll To Bottom
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${Patients_Update_Btn}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Patients
    Patient.Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Scroll Element Into View    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    10 times    3s    Click Button    ${Patients_Clear_Btn}
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${Find_Patient_Input}    ${PatientData.MRN}
    Execute JavaScript    document.activeElement.blur()

Search Inactive Patient With Advanced Search
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Click Element     ${Advanced_Search_Btn}
    END
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${advanced_clear_btn}
    Util.Check Or Uncheck Box    view_arg=${True}    xpath_arg=${Show_Inactive_Patient_Checkbox}
    Sleep    2s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'Refresh')]
    Patient.Wait Patient List Loading

Verify Inactive Patient
    Set Test Variable    ${MRN}    ${PatientData.MRN}
    ${patient_inactive_icn}    Util.Replace Xpath    xpath=${patient_inactive_icn}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${patient_inactive_icn}
    Wait Until Element Is Visible    ${patient_inactive_icn}    30s