*** Settings ***
Resource    PatientTools/PatientMerge.resource
Resource    PatientTools/ImportPatients.resource

*** Variables ***
${patients_link}    link:Patients
${new_patient_link}    //*[starts-with(@onclick,'CreateNewPatient')]
${patients_location_select}    //select[@id="CustomerAccountId"]
${find_patient_btn}    //*[@id='FindButton' and starts-with(text(),'Find')]
${find_patient_input}    //*[@id='SearchValues']
${patients_clear_btn}    //*[@id='ClearButton']
${search_patient_loading}    //*[@id='loading-indicator']
${top_page}    //*[contains(@class,'pager-navigation') and contains(@class,'TopPage')]
${pagination_input}    //*[@type='number' and contains(@class,'TopPage') and @placeholder='Page']
${got_to_page_btn}    //*[@type='button' and contains(@class,'TopPage') and text()='Go']
${patient_list_table}    //*[@id='PatientList']//*[contains(@class,'table')]

# Patient Tools
${patient_tools_btn}    //*[@type='button'and contains(text(),'Patient Tools')]

# Patient Tools - Merge Patient
${merge_patient_link}    //*[@id='MergePatients' and contains(@onclick,'PatientMergeModal')]
${merge_patient_title}    //*[@class='modal-title' and text()='Patient Merge Helper']

# Patient Tools - Import Patient
${import_patients_link}    //*[@id='ImportPatients']
${import_patient_title}    //*[@class='modal-title' and text()='Import Patients']

# Advanced Search
${advanced_search_btn}    //*[starts-with(@onclick,'DisplayAdvancedSearch') and text()='Advanced Search']
${advanced_search_text}    //h4[contains(text(),'Advanced Search')]
${advanced_search_close_btn}    //a[contains(text(),'Close")]
${advanced_search_firstname_input}    //input[@id="PatientFirstNameSearch"]
${advanced_search_lastname_input}    //input[@id="PatientLastNameSearch"]
${advanced_search_dob_input}    //input[@id="PatientDOBSearch"]
${advanced_search_mrn_input}    //input[@id="PatientMRNSearch"]
${advanced_search_sortby_select}    //select[@id="SortBy"]
${advanced_search_pagesize_select}    //select[@id="RowsPerPage"]
${show_inactive_patient_checkbox}    //*[@id='showInactive']
${patient_search_btn}    //a[contains(@onclick,'RefreshWithIndicator')]
${advanced_clear_btn}    //a[contains(text(),'Clear')]
${advanced_close_btn}    //*[@id='AdvancedSearchDiv']//*[contains(@onclick,'AdvancedSearch') and text()='Close']

*** Keywords ***
Go To Patients Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${patients_link}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Patients

Go To Create New Patient Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${new_patient_link}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    Create Patient

Open Patient Merge Helper Popup
    Click Button    ${patient_tools_btn}
    Click Element    ${merge_patient_link}
    Wait Until Element Is Visible    ${merge_patient_title}    30s

Open Import Patients Popup
    Click Button    ${patient_tools_btn}
    Click Element    ${import_patients_link}
    Wait Until Element Is Visible    ${import_patient_title}    30s

Navigate to Patient by Generated MRN
    [Arguments]    ${mrn_arg}    ${location_arg}
    Go To Patients Page
    Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
    Select Patient From List    mrn_arg=${mrn_arg}

Select Patient From List
    [Arguments]    ${mrn_arg}
    ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${mrn_arg}']/preceding::td[2]//a
    Wait Until Element Is Visible    ${patient_mrn_row}    30s
    Common.Scroll And Click Element    ${patient_mrn_row}

Filter Patient In Patient Page 
    [Arguments]    ${mrn_arg}    ${location_arg}
    Select Location In Patient List    ${location_arg}
    Input MRN In Patient List    ${mrn_arg}
    Handle Advanced Search In Patient List

Select Location In Patient List
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${patients_location_select}    ${location_arg}
    Element Is Not Visible    ${search_patient_loading}

Input MRN In Patient List
    [Arguments]    ${mrn_arg}
    Wait Until Element Is Visible    ${find_patient_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${patients_clear_btn}
    Element Is Not Visible    ${search_patient_loading}
    Input Text Into Field    ${find_patient_input}    ${mrn_arg}

Get Location List
    ${location_user_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${patients_location_select}
    RETURN    ${location_user_list}

#Advance Search
Handle Advanced Search In Patient List
    Open Display Advanced Search
    Wait Until Element Is Visible    ${advanced_search_text}    30s
    Click Clear Advance Search Button
    Click Advance Search Button

Open Display Advanced Search
    ${is_advanced_search}    Run Keyword And Return Status    Element Should Be Visible    ${advanced_search_text}    2s
    IF    ${is_advanced_search} == ${False}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${advanced_search_btn}
        Wait Until Element Is Visible    ${advanced_search_text}    30s
    END

Choose Value In Sort By Select
    [Arguments]    ${sort_arg}
    Wait Until Element Is Visible    ${advanced_search_sortby_select}    30s
    Select From List By Label    ${advanced_search_sortby_select}    ${sort_arg}

Select Page Size
    [Arguments]    ${page_size_arg}=10
    Select From List By Label    ${advanced_search_pagesize_select}    ${page_size_arg}

Click Show Inactive Patients Checkbox
    Wait Until Element Is Visible    ${show_inactive_patient_checkbox}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${show_inactive_patient_checkbox}

Click Clear Advance Search Button
    Common.Scroll And Click Element    ${advanced_clear_btn}
    Element Is Not Visible    ${search_patient_loading}

Click Advance Search Button
    Common.Scroll And Click Element    ${patient_search_btn}
    Element Is Not Visible    ${search_patient_loading}

Click Close Advance Search Button
    Common.Scroll And Click Element    ${advanced_close_btn}
    Wait Until Element Is Not Visible    ${advanced_search_text}    30s

# Patient Table
Patient List Table Is Visible
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${patient_list_table}
    Wait Until Element Is Visible    ${patient_list_table}    30s

Get Patient Name
    [Arguments]    ${mrn_arg}
    ${patient_name_column}    Set Variable    //td[text()='${mrn_arg}']//preceding-sibling::td//a
    ${patient_name_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${patient_name_column}
    RETURN    ${patient_name_txt}