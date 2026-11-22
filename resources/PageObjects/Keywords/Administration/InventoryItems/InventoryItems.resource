*** Settings ***
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${new_inventory_item_element_xpath}    //a[@onclick="ItemMaintenancePopup('New','');"]
${item_no_input_xpath}    //input[@id="ItemNo"]
${manufacturer_account_select_xpath}    //div[@id="ModalPopup"]//select[@id="ManufacturerAccountId"]
${add_new_inventory_item_button_xpath}    //div[@id="ModalPopup"]//button[@id="SaveBtn"]
${save_inventory_item_button_xpath}    //div[@id="ModalPopup"]//button[@id="SaveBtn"]
${close_inventory_item_button_xpath}    //div[@id="ModalPopup"]//button[@id="CloseBtn"]
${delete_inventory_item_button_xpath}    //div[@id="ModalPopup"]//button[@id="DeleteBtn"]
${import_management_button_xpath}    //a[@onclick="toggleImportManagement()"]

${search_input_xpath}    //input[@id="SearchValues"]
${find_button_xpath}    //button[@id="FindButton"]
${clear_search_button_xpath}    //button[@id="ClearButton"]

${reason_change_contract_input_xpath}    //input[@id="Reason"]
${authority_change_select_xpath}    //select[@id="AuthorizedBy"]
${accept_change_contract_button}    //div[@id="MiniModalPopup"]//button[@id="AcceptBtn"]

${input_new_lot_xpath}    //input[@id="newLotNumber"]
${input_new_expired_date_xpath}    //input[@id="newExpirationDate"]
${add_lot_button_xpath}    //a[@id="addLot"]
${import_setting_element_xpath}    //div[@id="ImportSettings"]
${export_item_selection_button_xpath}    //a[@onclick="ExportSelection();"]
${import_invetory_item_button_xpath}    //a[@onclick="ImportInventoryItems(1);"]
${import_file_input_xpath}    //input[@id="UploadFile"]
${import_summary_select_xpath}    //select[@id="ImportSummaryId"]
${import_item_category_button_xpath}    //a[@onclick="ImportItemCategories(1);"]
${export_item_category_button_xpath}    //a[@onclick="ExportItemCategories();"]

*** Keywords ***
Go To Inventory Items
    Click Element    link:Administration
    Click Element    link:Inventory Items
    Title Should Be    Inventory Items
    Util.Waiting For Loading

Fill Search Input
    [Arguments]    ${ndc}
    Wait Until Element Is Enabled    ${search_input_xpath}    30s
    Input Text    ${search_input_xpath}    ${ndc}

Click Clear Search
    Wait Until Element Is Enabled    ${clear_search_button_xpath}    30s
    Click Button    ${clear_search_button_xpath}
    
Click Find Button
    Wait Until Element Is Enabled    ${find_button_xpath}    30s
    Click Button    ${find_button_xpath}

Click Import Management Button
    Wait Until Element Is Enabled    ${import_management_button_xpath}    30s
    Click Element    ${import_management_button_xpath}

Click Export Item Selection Button
    Wait Until Element Is Enabled    ${export_item_selection_button_xpath}    30s
    Click Element    ${export_item_selection_button_xpath}

Click Import Inventory Item Button
    Wait Until Element Is Enabled    ${import_invetory_item_button_xpath}    30s
    Click Element    ${import_invetory_item_button_xpath}

Click Export Item Categories Button
    Wait Until Element Is Enabled    ${export_item_category_button_xpath}    30s
    Click Element    ${export_item_category_button_xpath}

Click Import Item Categories Button
    Wait Until Element Is Enabled    ${import_item_category_button_xpath}    30s
    Click Element    ${import_item_category_button_xpath}

    
Open Import Management
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${import_setting_element_xpath}
    Run Keyword If    '${status}' == '${False}'    Click Import Management Button
    Wait Until Element Is Visible    ${import_setting_element_xpath}    30s

Close Import Management
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${import_setting_element_xpath}
    Run Keyword If    '${status}' == '${True}'    Click Import Management Button
    Wait Until Element Is Not Visible    ${import_setting_element_xpath}    30s

Export Item Selection
    Click Export Item Selection Button
    Alert Should Be Present    action=ACCEPT    timeout=30s

Export Item Categories
    Click Export Item Categories Button
    Alert Should Be Present    action=ACCEPT    timeout=30s

Open Import Inventory Item Modal
    Click Import Inventory Item Button
    Wait Until Element Contains    id=ModalPopup    Import Inventory Items    30s

Open Import Item Categories Modal
    Click Import Item Categories Button
    Wait Until Element Contains    id=ModalPopup    Import Item Categories    30s

Choose File To Upload File Input
    [Arguments]    ${path}
    Wait Until Element Is Enabled    ${import_file_input_xpath}    30s
    Choose File    ${import_file_input_xpath}    ${path}

Select Import Summary Option
    [Arguments]    ${summary}
    Wait Until Element Is Enabled    ${import_summary_select_xpath}    30s
    Select From List By Label    ${import_summary_select_xpath}    ${summary}

Get Item Inventory Id
    [Arguments]    ${ndc}
    ${item_maintained_popup_element_xpath}    Set Variable    //tr[@class="MainView"]//a[@data-rel="itemdetailpopup" and text()="${ndc}"]
    Wait Until Element Is Visible    ${item_maintained_popup_element_xpath}    30s
    ${inventory_item_id}    Get Element Attribute    ${item_maintained_popup_element_xpath}    data-itemid
    RETURN    ${inventory_item_id}

Click Edit Inventory Item
    [Arguments]    ${inventory_item_id}
    ${edit_inventory_item_element_xpath}    Set Variable    //a[@onclick="ItemMaintenancePopup('Edit','${inventory_item_id}');" and text()="Edit "]
    Wait Until Element Is Enabled    ${edit_inventory_item_element_xpath}
    Click Element    ${edit_inventory_item_element_xpath}

Click Copy Inventory Item
    [Arguments]    ${inventory_item_id}
    ${copy_inventory_item_element_xpath}    Set Variable    //a[@onclick="ItemMaintenancePopup('Copy','${inventory_item_id}');"]
    Wait Until Element Is Enabled    ${copy_inventory_item_element_xpath}
    Click Element    ${copy_inventory_item_element_xpath}

Click Manage Lot Inventory Item
    [Arguments]    ${inventory_item_id}
    ${manage_lot_inventory_item_element_xpath}    Set Variable    //a[@onclick="ManageLots('${inventory_item_id}');"]
    Wait Until Element Is Enabled    ${manage_lot_inventory_item_element_xpath}
    Click Element    ${manage_lot_inventory_item_element_xpath}

Click New Inventory Item Element
    Wait Until Element Is Enabled    ${new_inventory_item_element_xpath}    30s
    Click Element    ${new_inventory_item_element_xpath}

Fill Item Number Input
    [Arguments]    ${item_number}
    Wait Until Element Is Enabled    ${item_no_input_xpath}    30s
    Input Text    ${item_no_input_xpath}    ${item_number}

Tick Base Uom Checkbox
    [Arguments]    ${index}
    ${base_uom_checkbox_xpath}    Set Variable    //input[@id="UoMs_${index}__IsBaseUom"]
    Wait Until Element Is Enabled    ${base_uom_checkbox_xpath}    30s    
    Select Checkbox    ${base_uom_checkbox_xpath}

Tick Variable Uom Checkbox
    [Arguments]    ${index}
    ${variable_uom_checkbox_xpath}    Set Variable    //input[@id="UoMs_${index}__IsVariableUom"]
    Wait Until Element Is Enabled    ${variable_uom_checkbox_xpath}    30s    
    Select Checkbox    ${variable_uom_checkbox_xpath}

Tick Hide Inventory Checkbox
    [Arguments]    ${index}
    ${hide_inventory_checkbox_xpath}    Set Variable    //input[@id="UoMs_${index}__HideInventory"]
    Wait Until Element Is Enabled    ${hide_inventory_checkbox_xpath}    30s    
    Select Checkbox    ${hide_inventory_checkbox_xpath}

Tick Purchasing Uom Checkbox
    [Arguments]    ${index}
    ${purchasing_uom_checkbox_xpath}    Set Variable    //input[@id="UoMs_${index}__SellableUom"]
    Wait Until Element Is Enabled    ${purchasing_uom_checkbox_xpath}    30s    
    Select Checkbox    ${purchasing_uom_checkbox_xpath}

Tick Scan Code Serial Number Checkbox
    [Arguments]    ${index}
    ${scan_code_serial_number_checkbox_xpath}    Set Variable    //input[@id="UoMs_${index}__ContainsSerialNumber"]
    Wait Until Element Is Enabled    ${scan_code_serial_number_checkbox_xpath}    30s    
    Select Checkbox    ${scan_code_serial_number_checkbox_xpath}

Tick Default Dispensing Checkbox
    [Arguments]    ${index}
    ${default_dispensing_checkbox_xpath}    Set Variable    //input[@id="DefaultDispensing" and @value="${index}"]
    Wait Until Element Is Enabled    ${default_dispensing_checkbox_xpath}    30s    
    Select Checkbox    ${default_dispensing_checkbox_xpath}

Select Uom Unit Option
    [Arguments]    ${index}    ${uom_unit}
    ${uom_unit_select_xpath}    Set Variable    //select[@id="UoMs[${index}].UomId"]
    Wait Until Element Is Enabled    ${uom_unit_select_xpath}    30s
    Select From List By Label    ${uom_unit_select_xpath}    ${uom_unit}

Select Manufacturer Option
    [Arguments]    ${manufacturer}
    Wait Until Element Is Enabled    ${manufacturer_account_select_xpath}    30s
    Select From List By Label    ${manufacturer_account_select_xpath}    ${manufacturer}

Fill Base Qty Per Unit Input
    [Arguments]    ${index}    ${qty}
    ${base_qty_per_unit_input}    Set Variable    //input[@id="UoMs_0__BaseQtyPerUnit"]
    Wait Until Element Is Enabled    ${base_qty_per_unit_input}    30s
    Input Text    ${base_qty_per_unit_input}    ${qty}

Fill Qty Upper Bound Input
    [Arguments]    ${index}    ${qty}
    ${qty_upper_bound_input}    Set Variable    //input[@id="UoMs_${index}__UpperBound"]
    Wait Until Element Is Enabled    ${qty_upper_bound_input}    30s
    Input Text    ${qty_upper_bound_input}    ${qty}

Fill Qty Lower Bound Input
    [Arguments]    ${index}    ${qty}
    ${qty_lower_bound_input}    Set Variable    //input[@id="UoMs_${index}__LowerBound"]
    Wait Until Element Is Enabled    ${qty_lower_bound_input}    30s
    Input Text    ${qty_lower_bound_input}    ${qty}

Fill Barcode Input
    [Arguments]    ${index}    ${barcode}
    ${barcode_input_xpath}    Set Variable    //input[@id="UoMs_${index}__Barcode"]
    Wait Until Element Is Enabled    ${barcode_input_xpath}    30s
    Input Text    ${barcode_input_xpath}    ${barcode}

Open New Inventory Item Modal
    Click New Inventory Item Element
    Wait Until Element Contains    id=ModalPopup    New Inventory Item    30s
    Util.Waiting For Loading

Open Edit Inventory Item Modal
    [Arguments]    ${inventory_item_id}
    Click Edit Inventory Item    ${inventory_item_id}
    Wait Until Element Contains    id=ModalPopup    Edit Inventory Item    30s
    Util.Waiting For Loading

Open Copy Inventory Item Modal
    [Arguments]    ${inventory_item_id}
    Click Copy Inventory Item    ${inventory_item_id}
    Wait Until Element Contains    id=ModalPopup    Copy Inventory Item    30s
    Util.Waiting For Loading

Open Manage Lot Inventory Item Modal
    [Arguments]    ${inventory_item_id}
    Click Manage Lot Inventory Item    ${inventory_item_id}
    Wait Until Element Contains    id=ModalPopup    Lot Management    30s
    Util.Waiting For Loading

Close Inventory Item Modal
    Click Close Button On Inventory Item Modal
    Wait Until Element Is Not Visible    id=ModalPopup    30s
    Util.Waiting For Loading

Config Field Unit of Measure
    [Arguments]    ${index}    ${is_based_uom}    ${uom_unit}    ${qty_per_unit}    
    ...    ${is_variable_uom}=${False}    ${lower_bound_qty}=${None}    ${upper_bound_qty}=${None}    
    ...    ${is_hide_inventory}=${False}    ${is_purchasing_uom}=${False}    ${is_scan_code_serial_number}=${False}    
    ...    ${is_default_dispensing}=${False}    ${barcode}=${None}
    Select Uom Unit Option    ${index}    ${uom_unit}
    IF    '${is_based_uom}' == '${True}'    
        Tick Base Uom Checkbox    ${index}
        ${qty_per_unit}    Set Variable    1
    END
    Fill Base Qty Per Unit Input    ${index}    ${qty_per_unit}
    IF    '${is_variable_uom}' == '${True}'
        Tick Variable Uom Checkbox    ${index}
        Fill Qty Lower Bound Input     ${index}    ${lower_bound_qty}
        Fill Qty Upper Bound Input    ${index}    ${upper_bound_qty}   
    END
    Run Keyword If    '${is_hide_inventory}' == '${True}'    Tick Hide Inventory Checkbox    ${index}
    Run Keyword If    '${is_purchasing_uom}' == '${True}'    Tick Purchasing Uom Checkbox    ${index}
    Run Keyword If    '${is_scan_code_serial_number}' == '${True}'    Tick Scan Code Serial Number Checkbox    ${index}
    Run Keyword If    '${is_default_dispensing}' == '${True}'    Tick Default Dispensing Checkbox    ${index}
    Run Keyword If    '${barcode}' != '${None}'    Fill Barcode Input    ${index}    ${barcode}

Click Add Button On Inventory Item Modal
    Wait Until Element Is Enabled    ${add_new_inventory_item_button_xpath}    30s
    Click Button    ${add_new_inventory_item_button_xpath}

Click Save Button On Inventory Item Modal
    Wait Until Element Is Enabled    ${save_inventory_item_button_xpath}    30s
    Click Button    ${save_inventory_item_button_xpath}

Click Close Button On Inventory Item Modal
    Wait Until Element Is Enabled    ${close_inventory_item_button_xpath}    30s
    Click Button    ${close_inventory_item_button_xpath}

Close Modal Save Success
    Wait Until Element Contains    id=inventoryItemScanVirusModal    The item has been successfully saved    30s
    Click Button    OK
    Wait Until Element Is Not Visible    id=inventoryItemScanVirusModal    30s
    Wait Until Page Does Not Contain Element    //*[contains(@class,"updateHighlight")]    30s

Click Delete Button On Inventory Item Modal
    Wait Until Element Is Enabled    ${delete_inventory_item_button_xpath}    30s
    Click Button    ${delete_inventory_item_button_xpath}

Click Accpect Button On Inventory Item Contract Changelog Modal
    Wait Until Element Is Enabled    ${accept_change_contract_button}    30s
    Click Button    ${accept_change_contract_button}
    
Fill Fields On New Inventory Item Modal
    [Arguments]    ${item_number}    ${manufacturer}    ${measured_units}    
    Fill Item Number Input    ${item_number}
    FOR    ${index}    ${measured_unit}    IN ENUMERATE    @{measured_units}    start=0

        ${is_variable_uom}    Get From Dictionary    ${measured_unit}    is_variable_uom    ${False}
        ${lower_bound_qty}    Get From Dictionary    ${measured_unit}    lower_bound_qty    ${None}    
        ${upper_bound_qty}    Get From Dictionary    ${measured_unit}    upper_bound_qty    ${None}    
        ${is_purchasing_uom}    Get From Dictionary    ${measured_unit}    is_purchasing_uom    ${False}    
        ${is_scan_code_serial_number}    Get From Dictionary    ${measured_unit}    is_scan_code_serial_number    ${False}
        ${is_default_dispensing}    Get From Dictionary    ${measured_unit}    is_default_dispensing    ${False}
        ${barcode}    Get From Dictionary    ${measured_unit}    barcode    ${None}

        Config Field Unit of Measure        ${index}    ${measured_unit}[is_based_uom]    ${measured_unit}[uom_unit]    ${measured_unit}[qty_per_unit]    
        ...    ${is_variable_uom}    ${lower_bound_qty}    ${upper_bound_qty}
        ...    ${is_purchasing_uom}    ${is_scan_code_serial_number}
        ...    ${is_default_dispensing}    ${barcode}
    END
    Select Manufacturer Option    ${manufacturer}

Fill Reason Change Contract Input
    [Arguments]    ${reason}
    Wait Until Element Is Enabled    ${reason_change_contract_input_xpath}
    Input Text    ${reason_change_contract_input_xpath}    ${reason}  

Select Change Authority Option
    [Arguments]    ${authority}
    Wait Until Element Is Enabled    ${authority_change_select_xpath}
    Select From List By Label    ${authority_change_select_xpath}    ${authority}

Accept Inventory Item Contract Change
    [Arguments]    ${reason}    ${authority}    
    Fill Reason Change Contract Input    ${reason}
    Waiting For Loading
    Select Change Authority Option    ${authority}
    Waiting For Loading
    Click Accpect Button On Inventory Item Contract Changelog Modal
    Waiting For Loading
    Wait Until Element Is Not Visible    id=MiniModalPopup    30s    

Search Inventory Item
    [Arguments]    ${ndc}
    Fill Search Input    ${ndc}
    Click Find Button
    Util.Waiting For Loading

Clear Search Inventory Item
    Click Clear Search
    Util.Waiting For Loading

Complete Add Lot To Inventory Item
    [Arguments]    ${item_number}    ${lot}    ${expired_date}
    Search Inventory Item    ${item_number}
    ${inventory_item_id}    Get Item Inventory Id    ${item_number}
    Open Manage Lot Inventory Item Modal    ${inventory_item_id}
    Fill Field To Add New Lot    ${lot}    ${expired_date} 
    Click Add New Lot
    Util.Waiting For Loading
    Wait Until Lot Is Visible    ${lot}    ${expired_date}
    Close Inventory Item Modal
    Clear Search Inventory Item

Input New Lot
    [Arguments]    ${lot}
    Wait Until Element Is Enabled   ${input_new_lot_xpath}    30s
    Input Text    ${input_new_lot_xpath}    ${lot}

Input Expired Date New Lot
    [Arguments]    ${expired_date}
    Wait Until Element Is Enabled    ${input_new_expired_date_xpath}    30s
    Input Text    ${input_new_expired_date_xpath}    ${expired_date}

Click Add New Lot
    Wait Until Element Is Enabled    ${add_lot_button_xpath}    30s
    Click Element    ${add_lot_button_xpath}

Wait Until Lot Is Visible
    [Arguments]    ${lot}    ${expired_date}
    ${new_lot_row}    Set Variable    //tr[.//input[@value="${lot}"] and .//input[@value="${expired_date}"]]
    Wait Until Element Is Visible    ${new_lot_row}        30s

Fill Field To Add New Lot
    [Arguments]    ${lot}    ${expired_date}
    Input New Lot    ${lot}
    Input Expired Date New Lot    ${expired_date}

Complete Export Item Selection
    [Arguments]    ${item_number}
    Search Inventory Item    ${item_number}
    Open Import Management
    Export Item Selection
    Clear Search Inventory Item
    Close Import Management

Complete Import Inventory Item
    [Arguments]    ${path}    ${result_format}=at %#I:%M %p on %#m/%#d/%Y
    Open Import Management
    Open Import Inventory Item Modal
    Choose File To Upload File Input    ${path}
    Click Save Button On Inventory Item Modal
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Visible    //tr[@class="ImportItem"]    30s
    Click Save Button On Inventory Item Modal
    Alert Should Be Present    action=ACCEPT    timeout=30s
    ${import_time}    CustomLibrary.Get Time Now    result_format=${result_format}
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Not Visible    id=ModalPopup    30s
    Close Import Management
    RETURN    ${import_time}

Complete Export Item Categories
    [Arguments]    ${item_number}
    Search Inventory Item    ${item_number}
    Open Import Management
    Export Item Categories
    Clear Search Inventory Item
    Close Import Management

Complete Import Item Categories
    [Arguments]    ${path}    ${result_format}=at %#I:%M %p on %#m/%#d/%Y
    Open Import Management
    Open Import Item Categories Modal
    Choose File To Upload File Input    ${path}
    Click Save Button On Inventory Item Modal
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Visible    //tr[@class="ImportItem"]    30s
    Click Save Button On Inventory Item Modal
    Alert Should Be Present    action=ACCEPT    timeout=30s
    ${import_time}    CustomLibrary.Get Time Now    result_format=${result_format}
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Not Visible    id=ModalPopup    30s
    Close Import Management
    RETURN    ${import_time}

Complete Copy Inventory Item
    [Arguments]    ${username}    ${item_number}    ${copy_item_number}    ${copy_manufacturer}    ${copy_measured_units}
    Search Inventory Item    ${item_number}
    ${inventory_item_id}    Get Item Inventory Id    ${item_number}
    Open Copy Inventory Item Modal    ${inventory_item_id}
    Fill Fields On New Inventory Item Modal    ${copy_item_number}    ${copy_manufacturer}    ${copy_measured_units}
    Click Save Button On Inventory Item Modal
    ${status}    Run Keyword And Return Status    Wait Until Element Contains    id=MiniModalPopup    Inventory Item Contract Changelog
    IF    '${status}' == '${True}'
        Accept Inventory Item Contract Change    Test    ${username}    
    END
    Close Modal Save Success
    # Util.Wait Alert Message Show And Disappear    Inventory Item Successfully Updated
    Util.Waiting For Loading
    Close Inventory Item Modal
    Clear Search Inventory Item

Complete Add New Inventory Item
    [Arguments]    ${item_number}    ${manufacturer}    ${measured_units}
    Open New Inventory Item Modal
    Fill Fields On New Inventory Item Modal    ${item_number}    ${manufacturer}    ${measured_units}    
    Click Add Button On Inventory Item Modal
    # Util.Wait Alert Message Show And Disappear    Inventory Item Successfully Updated
    Util.Waiting For Loading
    Close Modal Save Success
    Util.Waiting For Loading
    Close Inventory Item Modal

Complete Edit Inventory Item
    [Arguments]    ${username}    ${item_number}    ${updated_item_number}    ${updated_manufacturer}    ${updated_measured_units}
    Search Inventory Item    ${item_number}
    ${inventory_item_id}    Get Item Inventory Id    ${item_number}
    Open Edit Inventory Item Modal    ${inventory_item_id}
    Fill Fields On New Inventory Item Modal    ${updated_item_number}    ${updated_manufacturer}    ${updated_measured_units}
    Click Save Button On Inventory Item Modal
    ${status}    Run Keyword And Return Status    Wait Until Element Contains    id=MiniModalPopup    Inventory Item Contract Changelog    timeout=10s
    IF    '${status}' == '${True}'
        Accept Inventory Item Contract Change    Test    ${username}    
    END
    # Util.Wait Alert Message Show And Disappear    Inventory Item Successfully Updated
    Close Modal Save Success
    Util.Waiting For Loading
    Close Inventory Item Modal
    Clear Search Inventory Item

Delete Inventory Item
    [Arguments]    ${inventory_item_id}
    Open Edit Inventory Item Modal    ${inventory_item_id}
    Click Delete Button On Inventory Item Modal
    Handle Alert    ACCEPT
    Util.Wait Alert Message Show And Disappear    Inventory Item Deleted
    Util.Waiting For Loading
    Close Inventory Item Modal
    Clear Search Inventory Item

Complete Delete Inventory Item
    [Arguments]    ${item_number}
    Search Inventory Item    ${item_number}
    ${inventory_item_id}    Get Item Inventory Id    ${item_number}
    Delete Inventory Item    ${inventory_item_id}    
    

Complete Get List Category Item
    [Arguments]    ${ndc}
    Go To Inventory Items
    Search Inventory Item    ${ndc}
    ${list_category_item_xpath}    Set Variable    //tr[.//a[text()="${ndc}"] and @class="MainView"]//div[./strong[text()="Categories: "]]     
    Wait Until Element Is Visible    ${list_category_item_xpath}    
    ${category_raw}    Get Text    ${list_category_item_xpath}
    ${removed_title_category}    Remove String    ${category_raw}    Categories:${SPACE}
    @{category_list}    Create List
    IF    "${removed_title_category}" != "No Categories Assigned"
        @{category_list}    Split String    ${removed_title_category}    ,${SPACE}
    END
    RETURN    @{category_list}