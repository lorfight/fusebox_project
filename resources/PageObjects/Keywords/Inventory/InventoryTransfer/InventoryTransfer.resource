*** Settings ***
Resource   ./NewInventoryTransfer/NewInventoryTransfer.resource

*** Variables ***
${upload_document_element_xpath}    //a[@onclick="UploadDocumentModal();"]
${upload_document_input_xpath}    //input[@id="UploadFile"]
${upload_document_desc_xpath}    //input[@id="DocumentDescription"]
${upload_document_button_xpath}    //div[@id="SubModalPopup"]//button[@id="SaveBtn"]

*** Keywords ***

Go To Inventory Transfer
    Click Element    link:Inventory
    Click Element    link:Inventory Transfers
    Title Should Be    Inventory Transfers

Filter By From Location
    [Arguments]    ${from_location}
    Click Element    id=FromAccountId
    Select From List By Label    id=FromAccount    ${from_location}
    Waiting For Loading

Filter By To Location
    [Arguments]    ${to_location}
    Click Element    id=ToAccountId
    Select From List By Label    id=ToAccount    ${to_location}
    Waiting For Loading

New Inventory Transfer
    Click Element    link:New Inventory Transfer
    Waiting For Loading
    Title Should Be    Build Transfer

Create Transfer
    [Arguments]    ${from_account}    ${from_facility}    ${to_account}    ${to_facility}    ${list_barcode}
	Go To Inventory Transfer
    New Inventory Transfer
    NewInventoryTransfer.Select The Account To Transfer From    ${from_account}
    NewInventoryTransfer.From Inventory    ${from_facility}
    NewInventoryTransfer.Select The Account To Transfer To    ${to_account}
    NewInventoryTransfer.To Inventory    ${to_facility}
    ${transfer_id}    NewInventoryTransfer.Get Id Transfer
    InventoryUtils.Scan List Barcode    ${list_barcode}
	NewInventoryTransfer.Submit Transfer
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Inventory Transfers
    RETURN    ${transfer_id}    

Create Transfter To Backstock
    [Arguments]    ${from_account}    ${from_facility}    ${from_backstock}    ${to_backstock}    ${list_barcode}
    NewInventoryTransfer.Select The Account To Transfer From    ${from_account}
    NewInventoryTransfer.From Inventory    ${from_facility}
    NewInventoryTransfer.Select Backstock From    ${from_backstock}
    NewInventoryTransfer.Select Backstock To    ${to_backstock}
    ${transfer_id}    NewInventoryTransfer.Get Id Transfer
    InventoryUtils.Scan List Barcode    ${list_barcode}
	NewInventoryTransfer.Submit Transfer
    RETURN    ${transfer_id}

Click View Transfer Slip Complete
    [Arguments]    ${transfer_id}
    ${transfer_slip_element_xpath}    Set Variable    //a[contains(@href,"/Report/InventoryTransferSlip/${transfer_id}")]
    Wait Until Element Is Enabled    ${transfer_slip_element_xpath}    30s
    Click Element    ${transfer_slip_element_xpath}

Get Transfer Code From Completed Transfer
    [Arguments]    ${transfer_id}
    ${transfer_slip_element_xpath}    Set Variable    //a[contains(@href,"/Report/InventoryTransferSlip/${transfer_id}")]
    Wait Until Element Is Enabled    ${transfer_slip_element_xpath}    30s
    ${transfer_code}    Get Text    ${transfer_slip_element_xpath}
    RETURN    ${transfer_code}

Click Download Document
    [Arguments]    ${document_description}
    ${download_document_button_xpath}    Set Variable    //tr[./td[contains(.,"${document_description}")]]//a[@onclick]
    Wait Until Element Is Enabled    ${download_document_button_xpath}
    Click Element    ${download_document_button_xpath} 

Click View Document
    [Arguments]    ${transfer_id}
    ${view_document_element_xpath}    Set Variable    //a[@onclick="ViewInventoryTransferDocumentModal('${transfer_id}')"]
    Wait Until Element Is Enabled    ${view_document_element_xpath}    30s
    Click Element    ${view_document_element_xpath}
    Wait Until Element Contains    //*[@id="ModalPopup"]    View Inventory Transfer Documents    30s
    Util.Waiting For Loading

Click Upload Document
    Wait Until Element Is Enabled    ${upload_document_element_xpath}        30s
    Click Element    ${upload_document_element_xpath}
    Wait Until Element Contains    //*[@id="SubModalPopup"]    Upload Inventory Transfer Document    30s
    Util.Waiting For Loading

Choose Upload Document File
    [Arguments]    ${path_upload_file}
    Wait Until Element Is Enabled    ${upload_document_input_xpath}    30s    
    Choose File     ${upload_document_input_xpath}    ${path_upload_file}

Input Description Document
    [Arguments]    ${document_description}
    Wait Until Element Is Enabled    ${upload_document_desc_xpath}        30s
    Input Text    ${upload_document_desc_xpath}    ${document_description}

Click Upload Document File
    Wait Until Element Is Enabled    ${upload_document_button_xpath}    30s
    Click Button        ${upload_document_button_xpath}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    # Wait Until Element Is Not Visible    //*[@id="SubModalPopup"]    30s
    Util.Waiting For Loading
    Wait Until Page Contains Element    //*[@class="upload-success"]//*[text()="OK"]    30s
    Click Button    //*[@class="upload-success"]//*[text()="OK"]

Complete Upload Document To Inventory Transfer
    [Arguments]    ${transfer_id}    ${pdf_file_path}    ${document_description}
    Click View Document    ${transfer_id}
    Click Upload Document
    Choose Upload Document File    ${pdf_file_path}
    Input Description Document    ${document_description}
    Click Upload Document File
