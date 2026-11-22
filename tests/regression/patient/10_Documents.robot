*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Documents Suite
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_010    patient    Admin

*** Test Cases ***
Verify Document Tab Is Displayed SuccessFully With All Elements
    [Documentation]    DocPT-1    DocPT-2    DocPT-3    DocPT-4    DocPT-5    DocPT-6
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Verify Documents Tab Is Displayed Successfully With All Visible Elements
    Create New Document
    Verify Patient ID Is Displayed Correctly In Document Tab
    Verify DOB Is Displayed Correctly In Document Tab
    Verify MRN Is Displayed Correctly In Document Tab
    Verify Search Successfully With Document Type In Document Tab
    Verify Search Successfully When Entering Search Critiria In Document Tab

Verify Search Successfully When Entering Date Range
    [Documentation]    DocPT-7    DocPT-8
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Enter Date Range In Document Tab
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${document_find_btn}
    ${check_loading}    Run Keyword And Return Status    Wait Until Element Is Visible    ${document_loading_icon_i}    2s
    Run Keyword If    "${check_loading}" == "${True}"    Wait Until Element Is Not Visible    ${document_loading_icon_i}    5s
    ${doc_type}    Set Variable    ${TempData.new_document_type_select}
    ${new_document_row}    Replace Variables    ${new_document_row}
    Wait Until Element Is Visible    ${new_document_row}    30s

Verify Enter Date Range And Clear All Fields
    [Documentation]    DocPT-9    DocPT-10
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Search New Document
    Clear All Fields Successfully In Document Tab
    
Verify Show Archived And Un-Archived Successfully
    [Documentation]    DocPT-11    DocPT-12    DocPT-13    DocPT-24    DocPT-25
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Archive Or Un-Archive New Document    msg=Document Successfully Archived    #Archive
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_show_archived_checkbox}
    Wait Until Element Is Visible    ${new_document_row}    30s
    Archive Or Un-Archive New Document    msg=Document Successfully Un-Archived    #Un-Archive
    Wait Until Element Is Not Visible    ${new_document_row}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_show_archived_checkbox}
    Wait Until Element Is Visible    ${new_document_row}    30s

CURD New Document
    [Documentation]    DocPT-14    DocPT-15    DocPT-26    DocPT-30
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Edit New Document
    Delete New Document

Verify Add Document Unsuccessfully If Empty Description
    [Documentation]    DocPT-16
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Scroll And Click Element    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s
    Select Document Type
    Get Document Date
    Choose Document File
    Scroll And Click Element    ${new_document_add_btn}
    ${alert_text}    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_text}    Please enter a Description.

Verify Add Document Unsuccessfully If Empty Document Date
    [Documentation]    DocPT-17
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Scroll And Click Element    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s
    Select Document Type
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_description_textarea}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${new_document_date_input}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_viewer_msg}
    Choose Document File
    Scroll And Click Element    ${new_document_add_btn}
    ${alert_text}    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_text}    Please enter a Document Date.

Verify Add Document Unsuccessfully If Invalid Document Date
    [Documentation]    DocPT-18
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Scroll And Click Element    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s
    Select Document Type
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_description_textarea}    ${Fake_dict.sentence_str}
    Wait Until Keyword Succeeds    30s    1s    Clear Input Field Until Empty    ${new_document_date_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_date_input}    ${Fake_dict.num_rand}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${document_viewer_msg}
    Choose Document File
    Scroll And Click Element    ${new_document_add_btn}
    Handle Alert    ACCEPT
    ${alert_text}    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_text}    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.

Verify Add Document Unsuccessfully If Empty Document File
    [Documentation]    DocPT-19
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Scroll And Click Element    ${document_add_btn}
    Wait Until Element Is Visible    ${new_document_title}    30s
    Select Document Type
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${new_document_description_textarea}    ${Fake_dict.sentence_str}
    Get Document Date
    Scroll And Click Element    ${new_document_add_btn}
    ${alert_text}    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_text}    Please select a file to upload.

Show Document Successfully In Frame Document
    [Documentation]    DocPT-20    DocPT-21    DocPT-22
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar    attribute_status=false
    Verify New Document From List Displays With All Element When Expand
    Show Document Successfully In Frame Document
    Collapse And Expand Successfully When Clicking "+" Or "-" On Blue Bar    attribute_status=true
    
Verify Edit Document Unsuccessfully If Empty Description
    [Documentation]    DocPT-27
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Edit Document Unsuccessfully    element_arg=${new_document_description_textarea}    msg=Please enter a Description.

Verify Edit Document Unsuccessfully If Empty Document Date
    [Documentation]    DocPT-28
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Edit Document Unsuccessfully    element_arg=${new_document_date_input}    msg=Please enter a Document Date.

Verify Edit Document Unsuccessfully If Valid Document Date
    [Documentation]    DocPT-29
    [Tags]    Regression     Documents
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Documents Tab
    Create Fake Data List
    Check Document Type Select Has Default Value
    Create New Document
    Edit Document Unsuccessfully    element_arg=${new_document_date_input}    msg=SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}

Test Teardown Documents Suite
    Delete Fake Folder    folder_path=${CURDIR}/../../../results/export/fake_folder
    Delete New Document
    Test Teardown Keyword