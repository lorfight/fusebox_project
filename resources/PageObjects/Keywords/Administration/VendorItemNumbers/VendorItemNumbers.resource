*** Settings ***
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${vendor_select_xpath}    //select[@id="DistributerAccountId"]
${vendor_item_number_blacklist_button_xpath}    //span[@id="ShowVendorItemNumberBlacklist"]
${add_vendor_item_number_blacklist_button_xpath}    //span[@id="ShowAddVendorItemNumberBlacklistSectionButton"]
${add_vendor_item_blacklist_element_xpath}    //div[@id="AddVendorItemNumberBlacklist"]
${vendor_item_blacklist_input_xpath}    //input[@id="VendorItemNumber"]
${save_vendor_item_blacklist_buton_xpath}    //span[@id="AddVendorItemNumberBlacklistButton"]
${search_input_xpath}    //input[@id="SearchValues"]
${clear_button_xpath}    //button[@id="ClearButton"]
${update_all_button_xpath}    //button[@id="updateAll"]
${find_button_xpath}    //button[@id="FindButton"]
${import_vendor_item_number_xpath}    //a[@onclick="ImportVendorItemNumbers(1);"]
${import_file_vendor_item_number_xpath}    //input[@id="UploadFile"]

*** Keywords ***
Go To Inventory Items
    Click Element    link:Administration
    Click Element    link:Vendor Item Numbers
    Title Should Be    Vendor Item Numbers
    Util.Waiting For Loading

Select Vendor Option
    [Arguments]    ${vendor}
    Wait Until Element Is Enabled    ${vendor_select_xpath}    30s
    Select From List By Label    ${vendor_select_xpath}    ${vendor}

Click Vendor Item Number Blacklist Button
    Wait Until Element Is Enabled    ${vendor_item_number_blacklist_button_xpath}    30s
    Click Element    ${vendor_item_number_blacklist_button_xpath}

Click Add Vendor Item Number Blacklist Button
    Wait Until Element Is Enabled    ${add_vendor_item_number_blacklist_button_xpath}    30s
    Click Element    ${add_vendor_item_number_blacklist_button_xpath}

Fill Vendor Item Blacklist Input
    [Arguments]    ${vendor_item_number}
    Wait Until Element Is Enabled    ${vendor_item_blacklist_input_xpath}    30s
    Input Text    ${vendor_item_blacklist_input_xpath}    ${vendor_item_number}

Click Save Vendor Item Number Blacklist Button
    Wait Until Element Is Enabled    ${save_vendor_item_blacklist_buton_xpath}    30s
    Click Element    ${save_vendor_item_blacklist_buton_xpath}

Click Delete Backlist Vendor Number Button
    [Arguments]    ${vendor_item_number}
    ${delete_blacklist_vendor_item_number_button_xpath}    Set Variable    //tr[./td[text()="${vendor_item_number}"]]//span[contains(@class,"removeVendorItemNumberBlacklistButton")]
    Wait Until Element Is Enabled    ${delete_blacklist_vendor_item_number_button_xpath}    30s
    Click Element    ${delete_blacklist_vendor_item_number_button_xpath}

Click Close Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="CloseBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="CloseBtn"]

Click Process On Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="SaveBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="SaveBtn"]

Click Import Vendor Item Numbers
    Wait Until Element Is Enabled    ${import_vendor_item_number_xpath}    30s
    Click Element    ${import_vendor_item_number_xpath}

Click Find Button
    Wait Until Element Is Enabled    ${find_button_xpath}    30s
    Click Button    ${find_button_xpath}

Click Clear Search Button
    Wait Until Element Is Enabled    ${clear_button_xpath}    30s
    Click Button    ${clear_button_xpath}

Click Update All Button
    Wait Until Element Is Enabled    ${update_all_button_xpath}    30s
    Click Button    ${update_all_button_xpath}

Fill Search Vendor Item Input
    [Arguments]    ${keyword}
    Wait Until Element Is Enabled    ${search_input_xpath}    30s
    Input Text    ${search_input_xpath}    ${keyword}

Fill Vendor Item Number Input
    [Arguments]    ${ndc}    ${vendor_item_number}
    ${vendor_item_number_input_xpath}    Set Variable    //tr[.//a[text()="${ndc}"]]//input[contains(@class,"vendorItemNumberInput")]
    Wait Until Element Is Enabled    ${vendor_item_number_input_xpath}    30s
    Input Text    ${vendor_item_number_input_xpath}    ${vendor_item_number}

Choose File Import To Input
    [Arguments]    ${path}
    Wait Until Element Is Enabled    ${import_file_vendor_item_number_xpath}    30s
    Choose File    ${import_file_vendor_item_number_xpath}    ${path}    

Open Vendor Item Number Blacklist
    Click Vendor Item Number Blacklist Button
    Wait Until Element Contains    id=ModalPopup    Vendor Item Number Blacklist    30s
    Util.Waiting For Loading

Complete Add Vendor Number Item Blacklist
    [Arguments]    ${vendor}    ${vendor_item_number}
    Select Vendor Option    ${vendor}
    Util.Waiting For Loading
    Open Vendor Item Number Blacklist
    Click Add Vendor Item Number Blacklist Button
    Wait Until Element Is Visible    ${add_vendor_item_blacklist_element_xpath}    30s
    Fill Vendor Item Blacklist Input    ${vendor_item_number}
    Click Save Vendor Item Number Blacklist Button
    Util.Wait Alert Message Show And Disappear    Vendor Item Number added to Blacklist
    Util.Waiting For Loading
    Click Close Modal    
    Wait Until Element Is Not Visible    id=ModalPopup    30s

Complete Delete Vendor Number Item Blacklist
    [Arguments]    ${vendor}    ${vendor_item_number}
    Select Vendor Option    ${vendor}
    Util.Waiting For Loading
    Open Vendor Item Number Blacklist
    Click Delete Backlist Vendor Number Button    ${vendor_item_number}    
    Alert Should Be Present    action=ACCEPT    timeout=30s
    Util.Wait Alert Message Show And Disappear    Vendor Item Number removed to Blacklist
    Wait Until Element Is Not Visible    //tr[./td[text()="${vendor_item_number}"]]//span[contains(@class,"removeVendorItemNumberBlacklistButton")]    30s    
    Util.Waiting For Loading
    Click Close Modal    
    Wait Until Element Is Not Visible    id=ModalPopup    30s

Complete Change Vendor Item Number
    [Arguments]    ${vendor}    ${ndc}    ${vendor_item_number}
    Select Vendor Option    ${vendor}
    Util.Waiting For Loading
    Fill Search Vendor Item Input    ${ndc}
    Click Find Button
    Util.Waiting For Loading
    Fill Vendor Item Number Input    ${ndc}    ${vendor_item_number}
    Click Update All Button
    Util.Waiting For Loading

Complete Import Vendor Item Number
    [Arguments]    ${file_path}
    Click Import Vendor Item Numbers
    Wait Until Element Contains    id=ModalPopup    Import Vendor Item Numbers    30s
    Util.Waiting For Loading
    Choose File Import To Input    ${file_path}
    Click Process On Modal
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Visible    //tr[@class="ImportItem"]    30s
    Click Process On Modal
    Alert Should Be Present    timeout=30s
    Util.Wait Alert Message Show And Disappear    File Successfully Imported!
    Util.Waiting For Loading
    Wait Until Element Is Not Visible    id=ModalPopup    30s    

    