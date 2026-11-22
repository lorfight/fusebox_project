*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource

Suite Setup     Setup Suite
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Admin    inventory    smoke    aws    INV_03

*** Variables ***
${data_input}

*** Test Cases ***
Build Transfer And Verify In Inventory Transfer
    [Documentation]    Verify Build Transfer Sucessfully And Check It In Inventory Transfer
    ...    INV_11    INV_12    INV_13    INV_14
    ...  report.label.owner:Quoc Nguyen
    ${barcodes}    Prepare List Barcode To Transfer    ${data_input}[items]    
    ${transfer_id}    InventoryTransfer.Create Transfer      
        ...    ${data_input}[checked_location]    ${data_input}[from_facility] ( ${data_input}[from_facility_type] )    
        ...    ${data_input}[checked_location]    ${data_input}[to_facility] ( ${data_input}[to_facility_type] )   
        ...    ${barcodes}
    ${trasfer_code}    InventoryTransfer.Get Transfer Code From Completed Transfer    ${transfer_id}    
    InventoryTransfer.Click View Transfer Slip Complete    ${transfer_id}
    Switch Window    Report Viewer
    ${pdf_file_path}    Download Report PDF File Report    PurchaseOrderConfirmation.pdf      
    ${transfer_item_data_dict}    Get Data Transfer In Report
    Verify Address Info Transfer Slip    
    ...    ${trasfer_code}
    ...    ${data_input}[checked_location]    ${data_input}[checked_location]
    ...    ${data_input}[from_facility]    ${data_input}[to_facility]
    ...    ${data_input}[from_facility_type]    ${data_input}[to_facility_type]
    Close Window
    Switch Window    Inventory Transfers
    ${time_current_upload}    Get Time Now    result_format=%Y%m%d%H%M%S
    Complete Upload Document To Inventory Transfer    ${transfer_id}    ${pdf_file_path}    ${time_current_upload}    
    Remove File    ${pdf_file_path}
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${previous_file_count}    Count Files In Directory    ${export_path}    
    InventoryTransfer.Click Download Document       ${time_current_upload}
    Wait Until Keyword Succeeds    30s    1s   Check Latest Download File Exist     ${export_path}    ${previous_file_count}    ${transfer_id}
    Verify Transfer Item Data In Transfer Slip    ${transfer_item_data_dict}    ${data_input}[items]    

*** Keywords ***
Setup Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}    
    Login To Fusebox    user_name=${Username}    password=${Password}

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter
    Reset Qty In Inventory    ${data_input}[checked_location]    ${data_input}[from_facility]    ${data_input}[items]
    Reset Qty In Inventory    ${data_input}[checked_location]    ${data_input}[to_facility]    ${data_input}[items]  

Reset Qty In Inventory
    [Arguments]    ${checked_location}    ${checked_facility}    ${items}
    FOR    ${item}    IN    @{items}
        InventoryLevels.Go To Inventory Level And Select Location And Facility    ${checked_location}    ${checked_facility}    
        InventoryLevels.Search NDC To Open Inventory Adjustment Then Adjust Qty    ${item}[ndc]    ${item}[uom]    ${item}[lot]    ${item}[expired_date]   0
    END

Teardown Suite
    Close Browser

Prepare List Barcode To Transfer
    [Arguments]    ${items}
    ${barcodes}    Create List
    FOR    ${item}    IN    @{items}
        FOR    ${barcode}    IN    @{item}[barcodes]
            Append To List    ${barcodes}    ${barcode}    
        END
    END
    RETURN    ${barcodes}

Download Report PDF File Report
    [Arguments]   ${file_name}
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${export_path}    Join Path    ${export_path}    ${file_name}
    ${exists}    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
    Wait Until Element Is Visible    //div[contains(text(),'Done. Total')]    30s
    Wait Until Element Is Visible    //div[@class="trv-nav"]//a[@title="Export"]    30s
    Click Element    //div[@class="trv-nav"]//a[@title="Export"]
    Util.Waiting For Loading
    Wait Until Element Is Enabled   //a[@data-command-parameter="PDF"]    30s
    Click Element    //a[@data-command-parameter="PDF"]
    Wait Until Created    ${export_path}    60s
    File Should Exist    ${export_path}
    RETURN    ${export_path}

Check Latest Download File Exist
    [Arguments]    ${path}    ${previous_file_count}    ${transfer_id}
    Wait Until Keyword Succeeds    30s    1s    Check File Increase    ${path}    ${previous_file_count}       
    ${files}    List Files In Directory    ${path}
    ${env_path}    Get Environment Variable    EXPORT_PATH
    ${file_paths}    Create List
    FOR    ${file}    IN    @{files}
        ${full}    Join Path    ${env_path}    ${file}
        Append To List    ${file_paths}    ${full}        
    END
    ${latest}    Evaluate    max(${file_paths}, key=lambda f: os.path.getctime(f))    os
    File Should Exist    ${latest}
    Should Contain    ${latest}    Customer_InventoryTransfer_Document_${transfer_id}
    Remove File    ${latest}      

Check File Increase
    [Arguments]    ${path}    ${old_count}
    ${current_count}    Count Files In Directory    ${path}
    Should Be True    ${current_count} > ${old_count}

Get Data Transfer In Report
    ${list_div}    Get WebElements    //div[contains(@class,"textBox67")]/following-sibling::div[following-sibling::div[contains(@class,"textBox19 ")]]
    ${list_html}    Create List
    FOR    ${el}    IN    @{list_div}
        ${outer}    Get Element Attribute    ${el}    outerHTML
        Append To List    ${list_html}    ${outer}
    END

    ${html_string}    Catenate    SEPARATOR=    @{list_html}
    
    ${transfer_report_dict}    Utils.Get Data In Inventory Transfer Report    ${html_string}
    RETURN    ${transfer_report_dict}

Verify Transfer Item Data In Transfer Slip
    [Arguments]    ${transfer_item_data_dict}    ${items}
    ${normalized_item_data_dict}    Normalize Data Transfer From Dict    ${items}
    Should Be Equal    ${transfer_item_data_dict}    ${normalized_item_data_dict}

Normalize Data Transfer From Dict
    [Arguments]    ${items}
    FOR    ${item}    IN    @{items}
        ${transfer_qty}    Evaluate    len(${item}[barcodes])
        ${transfer_qty}    Convert To Integer    ${transfer_qty}
        Remove From Dictionary    ${item}    barcodes
        Set To Dictionary    ${item}    transfer_qty=${transfer_qty}
    END
    RETURN    ${items}

Verify Address Info Transfer Slip
    [Arguments]    ${expected_transfer_code}    ${expected_from_location}    ${expected_to_location}    ${expected_from_facility}    ${expected_to_facility}    ${expected_from_facility_type}    ${expected_to_facility_type}
    ${normalized_actual_transfer_code}    Get Text    //div[contains(@class,"textBox4 ")]
    ${normalized_expected_transfer_code}    Set Variable    Transfer #: ${expected_transfer_code}
    
    ${from_address}    Get Text    //div[contains(@class,"textBox1 ")]
    ${normalized_actual_from_address}    Normalize Actual Address In Transfer Slip    ${from_address}
    ${normalized_expected_from_address}    Normalize Expected Address To Compare Address In Transfer Slip    ${expected_from_location}    ${expected_from_facility}    ${expected_from_facility_type}    From 

    ${to_address}    Get Text    //div[contains(@class,"textBox7 ")]
    ${normalized_actual_to_address}    Normalize Actual Address In Transfer Slip    ${to_address}
    ${normalized_expected_to_address}    Normalize Expected Address To Compare Address In Transfer Slip    ${expected_to_location}    ${expected_to_facility}    ${expected_to_facility_type}    To 

    Should Be Equal As Strings    ${normalized_actual_transfer_code}    ${normalized_expected_transfer_code}
    Should Be Equal As Strings    ${normalized_actual_from_address}    ${normalized_expected_from_address}
    Should Be Equal As Strings    ${normalized_actual_to_address}    ${normalized_expected_to_address}

Normalize Actual Address In Transfer Slip
    [Arguments]    ${address}
    ${remove_address}    Replace String    ${address}    \n    ${EMPTY}
    RETURN    ${remove_address}

Normalize Expected Address To Compare Address In Transfer Slip
    [Arguments]    ${location}    ${facility}    ${facility_type}    ${direction_transfer}
    ${replace_facility_type}    Replace String    ${facility_type}    &    and      
    ${strip_facility_type}    Replace String    ${replace_facility_type}    ${SPACE}    ${EMPTY}
    ${normalized_expected_from_address}    Set Variable    Ship ${direction_transfer}: ${location} - ${facility} (${strip_facility_type})   
    RETURN    ${normalized_expected_from_address}