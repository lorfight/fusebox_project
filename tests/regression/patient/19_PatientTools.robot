*** Settings ***
Documentation      Patient Management
Library    DependencyLibrary
Library    Dialogs
Library    ../../../libraries/CustomLibrary.py
Variables    ../../../resources/PageObjects/Locators/Patient.py
Variables    ../../../resources/PageObjects/Locators/Appointment.py
Variables    ../../../resources/PageObjects/Locators/Billable.py
Resource   ../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/PriorAuthorization.resource
Resource    ../../../resources/PageObjects/Keywords/Appointment.resource
Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Resource    ../../../resources/PageObjects/Keywords/Billable.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryTransfer.resource
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Setup Keyword
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Test Tags    test:retry(1)    PaMan_019    patient    Admin

*** Test Cases ***
Verify Import Patient In Patients Page
    [Documentation]    PaMan_TC57    PaMan_TC58    PaMan_TC59    PaMan_TC62    PaMan_TC63    PaMan_TC64    PaMan_TC67    PaMan_TC68    PaMan_TC69    PaMan_TC70
                ...    PaMan_TC71    PaMan_TC72    PaMan_TC74    PaMan_TC75    PaMan_TC76    PaMan_TC77    PaMan_TC79    PaMan_TC80    PaMan_TC81
    [Tags]    Regression     Patient Tools
    ...  allure.label.owner: Vu Nguyen
    Import File With Empty Account Number
    Import File With Empty First Name
    Import File With Empty Last Name
    Import File With Empty DOB
    Import File With Gender Field
    Import File With Same MRN To Update Patient Info
    Add To Dictionary    dic_arg=${PatientData}    key_arg=MRN    val_arg=${MRN}
    Patient.Go To Update Patient Page    xpath_arg=${Patient_MRN_Text}
    Util.Scroll To Bottom
    Wait Until Element Is Visible    ${Delete_Patient_Link}    30s
    ${check}    Run Keyword And Return Status    Click Element    ${Delete_Patient_Link}    #issue (QA)
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    30s    1s    Execute JavaScript    return document.evaluate("${Delete_Patient_Link}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    Alert Should Be Present
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Patients

Verify Merge Patient In Patient Page
    [Documentation]    PaMan_TC82    PaMan_TC83    PaMan_TC86    PaMan_TC87    PaMan_TC90    PaMan_TC91    PaMan_TC92
    [Tags]    Regression     Patient Tools
    ...  allure.label.owner: Vu Nguyen
    Set To Dictionary    ${PatientData}    Location=${location}    MRN=${MRN_merge_1}
    Set Suite Variable    ${PatientData}
    Patient.Go To Patients Page
    Patient.Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Patient.Create Patient To Merge    Merge_MRN_arg=${PatientData.MRN}
    Patient.Create Patient To Merge    Merge_MRN_arg=${MRN_merge_2}
    Patient.Filter Location In Patients Page    Location_arg=${PatientData.Location}
    Patient.Merge Patient    Keeping_MRN_arg=${MRN_merge_2}

*** Keywords ***
Setup Keyword
    # Register Keyword To Run On Failure    NONE
    Setup Data
    Patient.Create Dictionary Of Patient Data
    ProviderOrders.Create Dictionary Of PO Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser
    Wait Until Keyword Succeeds    10s    1s    Check Newsletter
    Patient.Go To Patients Page

Setup Data        #variables in data sheet to be updated
    ${data_input}    Get Data
    # Common data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    # Patient data
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${location_PO_2}    ${data_input}[location_2]    #location on system with 2 labels (names)
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${first_name}    ${data_input}[first_name]
    Set Suite Variable    ${last_name}    ${data_input}[last_name]
    Set Suite Variable    ${DOB}    ${data_input}[DOB]
    Set Suite Variable    ${MRN_merge_1}    ${data_input}[MRN_merge_1]
    Set Suite Variable    ${MRN_merge_2}    ${data_input}[MRN_merge_2]    #patient to be merged only