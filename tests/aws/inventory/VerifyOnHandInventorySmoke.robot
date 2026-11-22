*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyAccount/MyAccount.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Admin    inventory    Smoke    aws    INV_06    report.label.owner:Quoc Nguyen

*** Test Cases ***
Generate On Hand Inventory Report
    [Documentation]    Verify Generate On Hand Inventory Report Sucessfully
    ...    INV_18
    OnHandInventory.Complete Generate On Hand Inventory Report    
    ...    ${input_data}[checked_location]    ${input_data}[start_day]    
    ...    ${input_data}[report_type]    ${input_data}[medication_name]    
    ...    ${input_data}[association]    
    Verify Report File Download Successfully

*** Keywords ***
Setup Suite  
    Login To Fusebox    user_name=${Username}    password=${Password}
    ${input_data}    Get Data
    MyAccount.Go To My Account
    MyAccount.Verify Utilize Report Queue Checkbox    uncheck
    MyAccount.Save Change
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    OnHandInventory.Go To On Hand Inventory
    ${file_path}    Get Generate Report File Path
    ${report_type_labels}    OnHandInventory.Get Report Type Labels
    ${medication_name_labels}    OnHandInventory.Get Medication Labels
    ${association_labels}    OnHandInventory.Get Assocciation Labels
    Set Suite Variable    ${input_data}
    Set Suite Variable    ${file_path}
    Set Suite Variable    ${report_type_labels}
    Set Suite Variable    ${medication_name_labels}
    Set Suite Variable    ${association_labels}
    OnHandInventory.Click Close Button On Modal

Setup Test Case
    OnHandInventory.Go To On Hand Inventory
    Generate Random Data Input
    
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

Generate Random Data Input
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${start_day}    Get Time Now    result_format=%-m/%-d/%Y
    ELSE
        ${start_day}    Get Time Now    result_format=%#m/%#d/%Y
    END
    ${report_type}    Evaluate    random.choice(${report_type_labels})
    ${medication_name}    Evaluate    random.choice(${medication_name_labels})
    ${association}    Evaluate    random.choice(${association_labels})
    Set To Dictionary    ${input_data}    start_day=${start_day}
    Set To Dictionary    ${input_data}    report_type=${report_type}
    Set To Dictionary    ${input_data}    medication_name=${medication_name}
    Set To Dictionary    ${input_data}    association=${association}

Get Generate Report File Path
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${start_day}    Get Time Now    result_format=%-m_%-d_%Y
    ELSE
        ${start_day}    Get Time Now    result_format=%#m_%#d_%Y
    END
    ${file_name}    Set Variable    ComprehensiveOnHandInventoryReport-${start_day}.xlsx
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${file_path}    Join Path    ${export_path}    ${file_name}
    ${exists}    Run Keyword And Return Status    File Should Not Be Empty    ${file_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${file_path}
    RETURN    ${file_path}

Verify Report File Download Successfully
    Wait Until Created    ${file_path}    120s
    File Should Exist    ${file_path}

