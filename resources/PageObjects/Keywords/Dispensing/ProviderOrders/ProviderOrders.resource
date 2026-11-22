*** Settings ***
Resource    ../../Layers/ProviderOrders/ProviderOrders.resource
Library    OperatingSystem

*** Keywords ***
Go To Provider Orders Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Provider Orders
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Provider Orders

Filter PO Navigate Mrn
    [Arguments]    ${location_arg}    ${mrn_arg}
    Select Location Provider Orders    ${location_arg}
    Filter Patient - PO Page    ${mrn_arg}

Clear Filter Checkbox
    [Arguments]    ${expect_status}
    Click Publish Provider Orders Checkbox    ${expect_status}
    Click Sign Provider Orders Checkbox    ${expect_status}
    Click View Expired Checkbox    ${expect_status}
    Click View Signed Checkbox    ${expect_status}
    Click View Unsigned Checkbox    ${expect_status}
    Click View Published Checkbox    ${expect_status}
    Click View Unpublished Checkbox    ${expect_status}
    Click View Progress Note Checkbox    ${expect_status}
    Click View Discontinued Service Checkbox    ${expect_status}

Print Order Successfully
    [Arguments]    ${po_arg}    ${mrn_arg}    ${date_arg}
    ${folder_path}    Get Environment Variable    EXPORT_PATH
    Run Keyword And Return Status    Remove Files Containing Physician    ${folder_path}
    # ${before_files_lenght}    Get File Quantity    ${folder_path}
    Click Print Order    ${po_arg}
    Verify PO File Is Downloaded    ${folder_path}    ${mrn_arg}    ${date_arg}
    Run Keyword And Return Status    Remove Files Containing Physician    ${folder_path}

Handle File Name
    [Arguments]    ${mrn_arg}    ${date_arg}
    ${dt}    Convert Date    ${date_arg}    date_format=%m/%d/%Y    result_format=datetime
    ${date_formatted}    Format Date No Padding    ${dt}    {m}_{d}_{y}
    ${expected_file_name}    Set Variable    PhysicianOrder-${date_formatted}-${mrn_arg}.pdf
    RETURN    ${expected_file_name}

# Get File Quantity
#     [Arguments]    ${folder_path}
#     ${files}    List Files In Directory    ${folder_path}
#     ${files_lenght}    Get Length    ${files}
#     RETURN    ${files_lenght}

Verify PO File Is Downloaded
    [Arguments]    ${folder_path}    ${mrn_arg}    ${date_arg}
    ${expected_file_name}    Handle File Name    ${mrn_arg}    ${date_arg}
    ${file_status}    Set Variable    ${False}
    WHILE    True
        ${files}    Wait Until Keyword Succeeds    30s    1s    List Files In Directory    ${folder_path}
        FOR    ${file}    IN    @{files}
            Run Keyword If    'PhysicianOrder' in '${file}'    Should Contain    ${file}    ${expected_file_name}
            ${file_status}    Run Keyword If    'PhysicianOrder' in '${file}'    Set Variable    ${True}
            Run Keyword If    'PhysicianOrder' in '${file}'    Exit For Loop
        END 
        Run Keyword If    ${file_status}    Exit For Loop
        Sleep    1s
    END
    
Remove Files Containing Physician
    [Arguments]    ${folder_path}
    ${files}    List Files In Directory    ${folder_path}
    FOR    ${file}    IN    @{files}
        Run Keyword If    'Physician' in '${file}'    Remove File    ${folder_path}/${file}
    END

Publish Provider Order Successfully
    [Arguments]    ${po_num}    ${expect_status}
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click Publish Provider Orders Checkbox    ${expect_status}
    Click Search PO
    Click Publish Button    ${po_num}
    Click Confirm Publish Button    ${po_num}

Verify Provider Order Is Published
    [Arguments]    ${po_num}    ${expect_status}
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click View Published Checkbox    ${expect_status}
    Click Search PO
    ${po_published_icon}    Set Variable    //span[normalize-space(.)='${po_num}']//following::a[contains(@data-original-title,"Published")]
    Run Keyword And Return Status     Wait Until Element Is Visible    ${po_published_icon}    5s

Assign Provider Order Successfully
    [Arguments]    ${po_num}    ${expect_status}
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click Sign Provider Orders Checkbox    ${expect_status}
    Click Search PO
    Click Sign Button    ${po_num}
    Wait Until Element Is Not Visible    //span[normalize-space(.)='${po_num}']    30s

Verify Provider Order Is Assigned
    [Arguments]    ${po_num}    ${expect_status}
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click View Signed Checkbox    ${expect_status}
    Click Search PO
    ${po_signed_icon}    Set Variable    //span[normalize-space(.)='${po_num}']//following::a[@data-original-title="Signed"]
    Wait Until Element Is Visible    ${po_signed_icon}    30s

Get Provider Order Import Template File
    ${download_path}    Get Environment Variable    EXPORT_PATH
    ${path}    Set Variable    ${download_path}/ProviderOrderImportTemplate.xlsx
    Run Keyword And Return Status    Remove File    ${path}
    Click Import Provider Orders
    Check Old File Is Visible
    Click Download Provider Order Import Template
    Wait Until Keyword Succeeds    30s    1s    Should Exist    ${path}
    ${df}    CustomLibrary.Read Excel File    path=${path}
    RETURN    ${df}    ${path}

Check Old File Is Visible
    ${remove_btn}    Set Variable    //a[contains(text(),'Remove')]
    ${check_remove_btn}    Run Keyword And Return Status    Wait Until Element Is Visible    ${remove_btn}    3s
    IF    '${check_remove_btn}' == '${True}'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove_btn}
        Common.Page Alert Message    Import Row Successfully Removed!
    END

Prepare Provider Order Data
    [Arguments]    
    ...    ${keys}    
    ...    ${df}    
    ...    ${path}
    ...    ${account_arg}
    ...    ${mrn_arg}
    ...    ${medication_arg}
    ...    ${icdecode_arg}
    ...    ${order_date_arg}
    ...    ${exp_date_arg}
    ...    ${referring_arg}
    ...    ${referto_arg}
    ...    ${weight_arg}
    ...    ${route_arg}
    ...    ${assigned_dose_arg}
    ...    ${dose_quantity_arg}
    ...    ${quantity_unit_arg}
    ...    ${over_days_arg}
    ...    ${number_doses_arg}  
    ${data_po}    Create List
    ...    ${account_arg}
    ...    ${mrn_arg}
    ...    ${medication_arg}
    ...    ${icdecode_arg}
    ...    ${order_date_arg}
    ...    ${exp_date_arg}
    ...    ${referring_arg}
    ...    ${referto_arg}
    ...    ${weight_arg}
    ...    ${route_arg}
    ...    ${assigned_dose_arg}
    ...    ${dose_quantity_arg}
    ...    ${quantity_unit_arg}
    ...    ${over_days_arg}
    ...    ${number_doses_arg}
    
    FOR    ${excel_column}    ${data_column}    IN ZIP    ${keys}    ${data_po}
        Set Value To Provider Order Excel Field    df=${df}    field=${excel_column}      value=${data_column}
    END
    CustomLibrary.Save Excel File    path=${path}    df=${df}
    
Set Value To Provider Order Excel Field
    [Arguments]    ${df}    ${field}    ${value}
    CustomLibrary.Edit Excel Field    df=${df}    field=${field}    value=${value}

Import Provider Order Excel File
    [Arguments]    ${path}    ${msg}    ${color_arg}    ${text_arg}
    Choose File    ${choose_po_file_input}    ${path}
    Click Process Provider Order File Button
    ${status_text}    Set Variable    //*[@id='PreProcess']//*[@style='color:${color_arg}' and normalize-space(text())='${text_arg}']    #green-success
    Wait Until Element Is Visible    ${status_text}    30s
    Common.Page Alert Message    ${msg}

Confirm Import Provider Order File
    Click Confirm Import Provider Order Button
    Alert Should Be Present    Are you sure you want to process this import?    Accept
    Common.Page Alert Message    File Successfully Imported!
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    30s

