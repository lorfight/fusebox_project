*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case    
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Prime    inventory    smoke    aws    INV_04    report.label.owner:Quoc Nguyen

*** Variables ***
${data_input}
${device_type_labels}

*** Test Cases ***
Assign A New Device To Patient
    [Documentation]    Verify Assign a New Device To Patient, Update And Dispose It Sucessfully
    ...    INV_15
    Generate Random Data Input
    ${device_id}    Devices.Complete Assign New Device To Patient    ${data_input}[checked_location] (${data_input}[checked_location_id])    ${data_input}[assigned_patient_mrn]    ${data_input}[device_name]    ${data_input}[serial_number]
    Generate Random Data Input
    Devices.Complete Update Patient Device    ${device_id}    ${data_input}[device_name]    ${data_input}[serial_number]  
    Devices.Complete Dispose Patient Device   ${device_id}

Assign A New Device
    [Documentation]    Verify Assign a New Device, Update And Dispose It Sucessfully
    ...    INV_16    INV_17
    Generate Random Data Input
    ${device_id}    Devices.Complete Assign New Device    ${data_input}[checked_location] (${data_input}[checked_location_id])    ${data_input}[device_type]    ${data_input}[device_name]    ${data_input}[serial_number]
    Generate Random Data Input
    Devices.Complete Update Device    ${device_id}    ${data_input}[checked_location] (${data_input}[checked_location_id])    ${data_input}[device_type]    ${data_input}[device_name]    ${data_input}[serial_number]  
    Devices.Complete Dispose Device    ${device_id}

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Login To Fusebox    user_name=${Username}    password=${Password}
    Devices.Go To Devices And Select Current Account    ${data_input}[checked_location] (${data_input}[checked_location_id])
    ${device_type_labels}    Devices.Complete Get Device Type Labels
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${device_type_labels}   

Setup Test Case
    Devices.Go To Devices And Select Current Account    ${data_input}[checked_location] (${data_input}[checked_location_id])
    ${device_ids}    Get All Device Ids On Screen
    FOR    ${device_id}    IN    @{device_ids}
        IF    'Patient' in '${device_id}'
            Devices.Complete Dispose Patient Device    ${device_id}
        ELSE
            Devices.Complete Dispose Device    ${device_id}
        END
    END 
    
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser
    
Generate Random Data Input
    ${device_type}    Evaluate    random.choice(${device_type_labels})
    ${serial_number}    Evaluate    ''.join(str(random.randint(0,9)) for _ in range(6))    random
    Set To Dictionary    ${data_input}    device_type=${device_type}
    Set To Dictionary    ${data_input}    serial_number=${serial_number}