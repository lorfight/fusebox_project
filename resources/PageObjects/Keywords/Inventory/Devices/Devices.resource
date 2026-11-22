*** Settings ***
Resource    ../Common/InventoryFilter.resource

*** Variables ***
${assign_new_device_button_xpath}    //a[@onclick="DeviceMaitenanceModal();"]
${assign_new_deivce_to_patient_button_xpath}    //a[@id="AssignDeviceToPatientBtn"]
${assigned_account_select_xpath}    //select[@id="_AssignedAccountLoader"]/following-sibling::div
${current_account_select_xpath}    //select[@id="CurrentAccount"]
${device_type_select_xpath}    //select[@id="DeviceType"]
${patient_input_xpath}    //input[@id="DevicePatientID"]
${device_name_input_xpath}    //input[@id="DeviceName"]
${serial_number_input_xpath}    //input[@id="SerialNumber"]
${edit_device_input_xpath}     //div[@id="AccountDeviceList"]//tbody/tr/td[@class="col-xs-8"]/div[1]/strong

*** Keywords ***
Go To Devices
    Click Element    link:Inventory
    Click Element    link:Devices
    Title Should Be    Account Devices
    Util.Waiting For Loading

Select Current Account
    [Arguments]    ${current_account}
    Wait Until Element Is Enabled    ${current_account_select_xpath}    30s
    Wait Until Element Contains    ${current_account_select_xpath}    ${current_account}    30s
    Select From List By Label    ${current_account_select_xpath}    ${current_account}
    Util.Waiting For Loading

Click Assign New Device To Patient Button
    Wait Until Element Is Enabled    ${assign_new_deivce_to_patient_button_xpath}    30s
    Click Element    ${assign_new_deivce_to_patient_button_xpath}

Click Assign New Device Button
    Wait Until Element Is Enabled    ${assign_new_device_button_xpath}    30s
    Click Element    ${assign_new_device_button_xpath}

Select Assigned Account Option
    [Arguments]    ${assigned_account}
    Wait Until Element Is Enabled    ${assigned_account_select_xpath}    30s
    Click Element    ${assigned_account_select_xpath}
    Wait Until Element Is Visible    //select[@id="_AssignedAccountLoader"]/following-sibling::div//div[@class="bs-searchbox"]/input    30s
    Input Text    //select[@id="_AssignedAccountLoader"]/following-sibling::div//div[@class="bs-searchbox"]/input    ${assigned_account} 
    Wait Until Element Is Visible    //select[@id="_AssignedAccountLoader"]/following-sibling::div//ul/li[contains(.,"${assigned_account} ")]    30s   
    Click Element    //select[@id="_AssignedAccountLoader"]/following-sibling::div//ul/li[contains(.,"${assigned_account} ")]       

Select Device Type Option
    [Arguments]    ${device_type}
    Wait Until Element Is Enabled    ${device_type_select_xpath}    30s
    Wait Until Element Contains    ${device_type_select_xpath}    ${device_type}    30s
    Select From List By Label    ${device_type_select_xpath}    ${device_type}

Get Device Type Labels
    Wait Until Element Is Enabled    ${device_type_select_xpath}    30s
    ${labels}    Get List Items    ${device_type_select_xpath}
    RETURN       ${labels}

Get All Device Ids On Screen
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${edit_device_input_xpath}    10s  
    ${edit_device_inputs}    Get WebElements    ${edit_device_input_xpath}
    ${device_ids}    Create List
    FOR    ${edit_device_input}    IN    @{edit_device_inputs}
        ${device_id}    Get Text    ${edit_device_input}
        Append To List    ${device_ids}    ${device_id}     
    END
    RETURN    ${device_ids}

Get Device Id From Alert Message
    ${alert_message}    Util.Get Text Alert Message
    Should Match Regexp    ${alert_message}    ^Device: .+ Successfully Assigned!$
    ${device_id}     Get Regexp Matches   ${alert_message}    ^Device: (.+) Successfully Assigned!$    1
    RETURN    ${device_id}[0]

Click Edit Device
    [Arguments]    ${device_id}
    ${device_edit_button_xpath}    Set Variable    //tr[.//strong[text()="${device_id}"]]//a[@title="Edit"]
    Wait Until Element Is Enabled    ${device_edit_button_xpath}    30s
    Click Element    ${device_edit_button_xpath}

Fill Patient MRN Input
    [Arguments]    ${mrn}
    Wait Until Element Is Enabled    ${patient_input_xpath}    30s
    Input Text    ${patient_input_xpath}    ${mrn}   

Fill Device Name Input
    [Arguments]    ${device_name}
    Wait Until Element Is Enabled    ${device_name_input_xpath}    30s
    Input Text    ${device_name_input_xpath}    ${device_name}

Fill Serial Number Input
    [Arguments]    ${serial_number}
    Wait Until Element Is Enabled    ${serial_number_input_xpath}    30s
    Input Text    ${serial_number_input_xpath}    ${serial_number}

Click Assign Button On Device Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="SaveBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="SaveBtn"]

Click Close Button On Device Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="CloseBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="CloseBtn"]

Click Update Button On Device Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="SaveBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="SaveBtn"]

Click Dispose Button On Device Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="DeleteBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="DeleteBtn"]

Click Auto Complete Patient Input
    [Arguments]    ${mrn}
    ${auto_completed_patient_select_xpath}    Set Variable    //div[@class="tt-dataset tt-dataset-DevicePatients"]/div[contains(.,"${mrn}")]
    Wait Until Element Is Visible    ${auto_completed_patient_select_xpath}    30s
    Click Element    ${auto_completed_patient_select_xpath}    
    
Open Assign New Device Modal
    Click Assign New Device Button
    Wait Until Element Contains    //div[@id="ModalPopup"]    Assign a New Device    30s
    Util.Waiting For Loading

Open Assign New Device To Patient Modal
    Click Assign New Device To Patient Button
    Wait Until Element Contains    //div[@id="ModalPopup"]    Assign a New Device To Patient    30s
    Util.Waiting For Loading

Close Assign New Device Modal
    Click Close Button On Device Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Open Edit Device Modal
    [Arguments]    ${device_id}
    Click Edit Device    ${device_id}
    Wait Until Element Contains    //div[@id="ModalPopup"]    Update a Device    30s
    Util.Waiting For Loading

Open Edit Patient Device Modal
    [Arguments]    ${device_id}
    Click Edit Device    ${device_id}
    Wait Until Element Contains    //div[@id="ModalPopup"]    Update a Patient Device    30s
    Util.Waiting For Loading

Fill Data To Device Modal
    [Arguments]    ${assign_account}    ${device_type}    ${device_name}    ${serial_number}
    Select Assigned Account Option    ${assign_account}    
    Select Device Type Option    ${device_type}
    Fill Device Name Input   ${device_name}
    Fill Serial Number Input    ${serial_number}

Fill Data To Device To Patient Modal
    [Arguments]    ${assign_account}    ${mrn}    ${device_name}    ${serial_number}
    Fill Patient MRN Input    ${mrn}
    Click Auto Complete Patient Input    ${mrn}
    Select Assigned Account Option    ${assign_account}
    Fill Device Name Input   ${device_name}
    Fill Serial Number Input    ${serial_number}

Fill Data To Update Patient Device Modal
    [Arguments]    ${device_name}    ${serial_number}
    Fill Device Name Input   ${device_name}
    Fill Serial Number Input    ${serial_number}

Complete Get Device Type Labels
    Open Assign New Device Modal
    ${device_type_labels}    Get Device Type Labels
    Close Assign New Device Modal
    RETURN    ${device_type_labels}

Complete Assign New Device
    [Arguments]    ${assign_account}    ${device_type}    ${device_name}    ${serial_number}
    Open Assign New Device Modal
    Fill Data To Device Modal    ${assign_account}    ${device_type}    ${device_name}    ${serial_number}
    Click Assign Button On Device Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    ${device_id}    Get Device Id From Alert Message
    Util.Waiting For Loading
    RETURN    ${device_id}

Complete Assign New Device To Patient
    [Arguments]    ${assign_account}    ${mrn}    ${device_name}    ${serial_number}
    Open Assign New Device To Patient Modal
    Fill Data To Device To Patient Modal    ${assign_account}    ${mrn}    ${device_name}    ${serial_number}
    Click Assign Button On Device Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    ${device_id}    Get Device Id From Alert Message
    Util.Waiting For Loading
    RETURN    ${device_id}

Complete Update Device
    [Arguments]    ${device_id}    ${assign_account}    ${device_type}    ${device_name}    ${serial_number}
    Open Edit Device Modal    ${device_id}
    Fill Data To Device Modal    ${assign_account}    ${device_type}    ${device_name}    ${serial_number}
    Click Update Button On Device Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Complete Update Patient Device 
    [Arguments]    ${device_id}   ${device_name}    ${serial_number}
    Open Edit Patient Device Modal    ${device_id}
    Fill Data To Update Patient Device Modal    ${device_name}    ${serial_number}
    Click Update Button On Device Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Complete Dispose Patient Device
    [Arguments]    ${device_id}
    Open Edit Patient Device Modal    ${device_id}
    Click Dispose Button On Device Modal
    Handle Alert    ACCEPT    30s
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Complete Dispose Device
    [Arguments]    ${device_id}
    Open Edit Device Modal    ${device_id}
    Click Dispose Button On Device Modal
    Handle Alert    ACCEPT    30s
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Go To Devices And Select Current Account
    [Arguments]    ${account}
    Go To Devices
    Select Current Account    ${account}