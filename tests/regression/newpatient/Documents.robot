*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Documents Suite
Test Setup    Test Setup Documents Suite
Test Teardown    Test Teardown Documents Suite
Suite Teardown    Suite Teardown Documents Suite
Test Tags    test:retry(1)    PaMan_010    patient    Admin

*** Test Cases ***
Verify Document Tab Is Displayed SuccessFully With All Elements
    [Documentation]    DocPT-1    DocPT-2    DocPT-3    DocPT-4    DocPT-5    DocPT-6
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Verify Documents Tab Is Displayed Successfully With All Visible Elements
    Create New Document    ${file_path}    ${document_dict}
    Verify Patient ID Is Displayed Correctly In Document Tab    ${PatientCreate}
    Verify DOB Is Displayed Correctly In Document Tab    ${PatientCreate}
    Verify MRN Is Displayed Correctly In Document Tab    ${PatientCreate}
    Verify Search Successfully With Document Type In Document Tab    ${document_dict.new_document_type_select}
    Verify Search Successfully When Entering Search Critiria In Document Tab    ${document_dict.description}
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}

Verify Search Successfully When Entering Date Range And Clear All Fields After That
    [Documentation]    DocPT-7    DocPT-8    DocPT-9    DocPT-10
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Search New Document    
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}    
        ...    start_date_arg=${document_dict.start_date}    
        ...    end_date_arg=${document_dict.end_date}
    Verify Created Document Is Visible    ${document_dict.new_document_type_select}
    Clear All Fields Successfully In Document Tab 
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
    
Verify Show Archived And Un-Archived Successfully
    [Documentation]    DocPT-11    DocPT-12    DocPT-13    DocPT-24    DocPT-25
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Search New Document
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}    
        ...    start_date_arg=${document_dict.start_date}    
        ...    end_date_arg=${document_dict.end_date}
    ${new_document_row}    Verify Created Document Is Visible    ${document_dict.new_document_type_select}
    Archive Or Un-Archive New Document    msg=Document Successfully Archived    description_arg=${document_dict.description}    #Archive
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_show_archived_checkbox}
    Wait Until Element Is Visible    ${new_document_row}    30s
    Archive Or Un-Archive New Document    msg=Document Successfully Un-Archived    description_arg=${document_dict.description}    #Un-Archive
    Wait Until Element Is Not Visible    ${new_document_row}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_show_archived_checkbox}
    Wait Until Element Is Visible    ${new_document_row}    30
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}

CURD New Document
    [Documentation]    DocPT-14    DocPT-15    DocPT-26
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Edit New Document    
        ...    dict_arg=${document_dict}    
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}

Verify Add Document Unsuccessfully If Empty And Invalid Field
    [Documentation]    DocPT-16    DocPT-17    DocPT-18    DocPT-19
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    sentence
    ${start_date}    ${end_date}    Get Document Date
    ${error_list}    Create List
        ...    Please enter a Description.
        ...    Please enter a Document Date.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
        ...    Please select a file to upload.
    FOR    ${error}    IN    @{error_list}
        Open New Document
        Select New Document Type    ${document_dict}
        Run Keyword If    "${error}" != "Please enter a Description."    Input Description In Documents    ${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Please enter a Document Date."    Common.Clear Input Field Until Empty    ${new_document_date_input}
        Run Keyword If    "${error}" == "Please enter a Document Date."    Click Document Viewer Message Table
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Document Date In Documents    1/1/1752
        Run Keyword If    "${error}" != "Please enter a Document Date." and "${error}" != "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Document Date In Documents    ${start_date}
        Run Keyword If    "${error}" != "Please select a file to upload."    Choose Document File
        Click Add New Document Button
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Alert Should Be Present    Upload this document?    ACCEPT
        Alert Should Be Present    ${error}    ACCEPT    30s
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="DocumentVirusScanModal"]//button[text()="Go Back"]
        Run Keyword If    "${error}" == "Please enter a Document Date."    Click Document Viewer Message Table
        Click Cancel New Document Button
    END
   
Show Document Successfully In Frame Document
    [Documentation]    DocPT-20    DocPT-21    DocPT-22
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar    
        ...    attribute_status=false
        ...    document_type_arg=${document_dict.new_document_type_select}
    Verify New Document From List Displays With All Element When Expand    
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
        ...    start_date_arg=${document_dict.start_date}
        ...    utc=${data_input}[utc]
    Open Frame Document With Created File
    Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar    
        ...    attribute_status=true
        ...    document_type_arg=${document_dict.new_document_type_select}
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
    
Verify Edit Document Unsuccessfully If Empty Description
    [Documentation]    DocPT-27
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Edit Document Unsuccessfully    
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
        ...    element_arg=${new_document_description_textarea}    
        ...    msg=Please enter a Description.
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}

Verify Edit Document Unsuccessfully If Empty Document Date
    [Documentation]    DocPT-28
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Edit Document Unsuccessfully 
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}   
        ...    element_arg=${new_document_date_input}    
        ...    msg=Please enter a Document Date.
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
    
Verify Edit Document Unsuccessfully If Invalid Document Date
    [Documentation]    DocPT-29
    [Tags]    Regression     Documents    report.label.owner: Hai Nguyen
    Create New Document    ${file_path}    ${document_dict}
    Open Edit Document Table    
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}
    Input Document Date In Documents    1/1/1752
    Click Save New Document Button
    Alert Should Be Present    Save changes?    ACCEPT
    Alert Should Be Present    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.    ACCEPT
    Delete New Document    #DocPT-30
        ...    document_type_arg=${document_dict.new_document_type_select}    
        ...    description_arg=${document_dict.description}

*** Keywords ***
Suite Setup Documents Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${original_window}    Get Window Handles

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

    ${file_path}    ${content_file}    Create Fake Folder    folder_path=${CURDIR}/../../../results/export
    Set Suite Variable    ${file_path}
    Set Suite Variable    ${content_file}

Test Setup Documents Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${document_dict}    Create Document Dictionary
    Set Test Variable    ${document_dict}
    Open Documents Tab
    Check Document Type Select Has Default Value

Test Teardown Documents Suite
    Common.Return Previous Window    window_arg=${update_patient_window}

Suite Teardown Documents Suite
    Delete Fake Folder    folder_path=${file_path}
    Close Browser

Open Frame Document With Created File
    ${iframe_src}    SeleniumLibrary.Get Element Attribute    ${new_document_frame}    src
    Execute Javascript    window.open(window.location.href, '_blank')
    Switch Window    NEW
    Go To    ${iframe_src}
    # Title Should Be    title
    Close Window
    ${original_window}    Get Window Handles
    Switch Window    ${original_window}[1]