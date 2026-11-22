*** Settings ***
Resource    ../Common/Common.resource
Library    ../Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
# contract index
${contract_membership_tools_btn}    //*[@onclick and contains(text(),' Contract Membership Tools ')]
${new_contract/pricing_set}    //*[@id='NewButton']
${copy_contract_list}    //*[@id='ViewCopyableContractListBtn']
${contract_owner_filter}    //*[@id='OwnerIdFilter']
${view_copied_btn}    //*[@id='ViewCopiedContractListBtn']
${copy_contract_btn}    //*[@id='SubmitCopyContract']
${search_contract_infor}    //*[@id='ContractSearchValues']
${find_contract_infor_btn}    //*[@id='ContractFindButton']
# import contract
${contract_download_template}    //*[@onclick and contains(text(),' Download Template ')]
${contract_export_pre-filled}    //*[@onclick and contains(text(),'Export Pre-Filled Template')]
${contract_choose_file}    //*[@id='uploadContractMembershipFile']
${contract_process_file}    //*[@id='saveBtnImportContractMembership']
${contract_association_select}    //*[@id='ContractPrefilledAssociationId']
${contract_head_office_select}    //*[@id='ContractPrefilledHeadOfficeAccountId']
${contract_location_select}    //*[@id='ContractPrefilledMemberAccountId']
${contract_select}    //*[@id='ContractPrefilledContractId']
${contract_start_date}    //*[@id='contractPrefilledStartDate']
${contract_end_date}    //*[@id='contractPrefilledEndDate']
${contract_process_export}    //*[@id='btnProcessExportContract']
${contract_reasons_input}    //*[@id='Reason']
${contract_authorized_by_select}    //*[@id='AuthorizedBy']
${contract_confirm_import_btn}    //*[@id='saveBtnImportContractMembership']
${contract_close_modal_btn}    //*[@id='closebtnImportContractMembership']
# create contract
${contract_id}    //*[@id='ContractNo']
${contract_description_input}    //*[@id='Description']
${contract_owner_select}    //*[@id='OwnerId']
${start_date_contract}    //*[@id='StartDate']
${end_date_contract}    //*[@id='EndDate']
${contract_type}    //*[@id='ContractTypeId']
${close_contract}    //*[@id='CancelButton']
${save_contract}    //*[@id='SaveButton']
${view_changelog}    //*[@id='ViewChangelog']
${available_items}    //*[@id='ContractItemSearchResults']
${search_item_input}    //*[@id='InventoryItemSearchValues']
${contract_find_ndc_btn}    //*[@id='InventoryItemSearchFindButton']
${contract_base_price_input}    //*[@id='BasePrice']
${contract_complete_btn}    //*[@id='SaveBtn' and contains(text(),'Complete')]
${item_base_price}    //*[@id='item_BasePrice']
${update_item_btn}    //*[contains(@onclick,'UpdateContractedItem')]
${contract_changelog}    //*[contains(text(),'You are about to alter a contract, please enter the following information to continue.')]

*** Keywords ***

# contract list
Go To Contracts And Pricing Set
    Click Element    link:Administration
    Click Element    link:Contracts & Pricing Sets

Click Contract Membership Tools
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${contract_membership_tools_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Import Contract Membership')]

Click New Contract / Pricing Set
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${new_contract/pricing_set}

Click Copy Contract List
    Click Element    ${copy_contract_list}
    Wait Until Element Is Visible    //h4[contains(text(),'Copy Contract List')]

Filter Owner
    [Arguments]    ${owner_arg}
    Select From List By Label    ${contract_owner_filter}    ${owner_arg}

Search By Contract Information
    [Arguments]    ${contract_arg}
    Input Text Into Field    ${search_contract_infor}    ${contract_arg}
    Waiting For Loading
    Click Element    ${find_contract_infor_btn}
    Wait Until Element Is Visible    //*[@id='ContractList']//a[@onclick and contains(text(),'${contract_arg}')]    30s

Click Edit Contract Item
    [Arguments]    ${contract_arg}
    ${edit_contract}    Set Variable    (//a[@onclick and contains(text(),'${contract_arg}')]//following::a[contains(text(),'Edit')])[1]
    Scroll And Click Element    ${edit_contract}

Click Copy Contract Item
    [Arguments]    ${contract_arg}
    ${copy_contract}    Set Variable    (//a[@onclick and contains(text(),'${contract_arg}')]//following::a[contains(text(),'Copy')])[1]
    Scroll And Click Element    ${copy_contract}
    Wait Until Element Is Visible    //h4[contains(text(),'Copy - Contract No: ${contract_arg}')]

Click Accept Copy Contract
    Click Element    //*[@id='SaveBtn' and contains(text(),'Accept')]

Click Delete Contract Item
    [Arguments]    ${contract_arg}
    ${delete_contract}    Set Variable    (//a[@onclick and contains(text(),'${contract_arg}')]//following::a[contains(text(),'Delete')])
    Wait Until Element Is Visible    ${delete_contract}    30s
    Scroll And Click Element    ${delete_contract}
    Handle Alert    ACCEPT

# contract membership tool
Click Download Template
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${contract_download_template}

Click Export Pre-Filed Template
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${contract_export_pre-filled}

Select Associations
    [Arguments]    ${association_arg}
    Select From List By Label    ${contract_association_select}    ${association_arg}

Select Head Offices Export
    [Arguments]    ${headoffice_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='ContractPrefilledHeadOfficeAccountId']//preceding::button[1]
    Input Text    //*[@id='ContractPrefilledHeadOfficeAccountId']//preceding::input[1]    ${headoffice_arg}
    Select From List By Label    ${contract_head_office_select}    ${headoffice_arg}

Select Contract Set/No
    [Arguments]    ${contract_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='ContractPrefilledContractId']//preceding::button[1]
    Input Text    //*[@id='ContractPrefilledContractId']//preceding::input[1]    ${contract_arg}
    Select From List By Label    ${contract_select}    ${contract_arg}

Input Start Date
    [Arguments]    ${startdate_arg}
    Input Text Into Field    ${contract_start_date}    ${startdate_arg}
    Press Keys    None    TAB
    Check DatePicker

Input End Date
    [Arguments]    ${enddate_arg}
    Input Text Into Field    ${contract_end_date}    ${enddate_arg}
    Press Keys    None    TAB
    Check DatePicker

Click Process Export
    Wait Until Element Is Visible    ${contract_process_export}    30s
    Scroll And Click Element    ${contract_process_export}

Click Choose File
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${contract_choose_file}

Click Comfirm Import
    Wait Until Element Is Visible    ${contract_confirm_import_btn}
    Common.Scroll And Click Element    ${contract_confirm_import_btn}
    Handle Alert    ACCEPT

Click Close Modal Import
    Common.Scroll And Click Element    ${contract_close_modal_btn}

# copy contract list
Click Checkbox Contract Number
    [Arguments]    ${contract_arg}
    Wait Until Element Is Visible    //h4[contains(text(),'Copy Contract List')]
    Click Element    //label[contains(normalize-space(), '${contract_arg}')]//input

Click View Copied Contract List
    Wait Until Element Is Visible    ${view_copied_btn}
    Click Element    ${view_copied_btn}

Click Copy Contract
    Click Element    ${copy_contract_btn}

Confirm Copy Contract
    Wait Until Element Is Visible    //h4[contains(text(),'Confirmation')]
    Click Element    //*[@id="ActivateOnCopy"]
    Click Element    //button[contains(text(),'Confirm')]

Filter Date Range View Copy
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Input Text Into Field    CopiedContractListStartDate    ${startdate_arg}
    Input Text Into Field    CopiedContractListEndDate    ${enddate_arg}
    Press Keys    None    TAB

Get Contract Number Copy
    [Arguments]    ${dict_arg}    ${contract_arg}
    ${contract_num_copy}    Get Text    //td[normalize-space(.)='${contract_arg}']/preceding-sibling::td[1]
    Set To Dictionary    ${dict_arg}    contract_num_copy=${contract_num_copy}
    RETURN    ${dict_arg}

Click Close Copy Contract
    Scroll And Click Element    //*[@id='CopyableContractListCloseBtn']

# create contract
Update Contract Number
    Wait Until Element Is Visible    ${contract_id}
    Clear Input Field Until Empty    ${contract_id}
    Input Text Into Field    ${contract_id}    Simple Contract 2026 Automation Test

Get Contract Number
    [Arguments]    ${dict_arg}
    ${contract_num}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${contract_id}
    Set To Dictionary    ${dict_arg}    contract_num=${contract_num}
    RETURN    ${dict_arg}

Input Description Contract
    Common.Clear Input Field Until Empty    ${contract_description_input}
    Input Text Into Field    ${contract_description_input}    Test

Get Description After Copy
    [Arguments]    ${dict_arg}
    ${desc_txt}    Get Value    ${contract_description_input}
    Set To Dictionary    ${dict_arg}    desc_txt=${desc_txt}
    RETURN    ${dict_arg}

Define Current Date
    ${date}    Get Current Date    #result_format=%m/%d/%Y
    ${currentdate}    Subtract Time From Date    ${date}    13 hour    result_format=%m/%d/%Y
    RETURN    ${currentdate}

Input Start Date - New Contract
    [Arguments]    ${dict_arg}
    ${currentdate}    Define Current Date
    Input Text Into Field    ${start_date_contract}    ${current_date}
    Set To Dictionary    ${dict_arg}    current_date=${current_date}
    RETURN    ${dict_arg}

Input End Date - New Contract
    [Arguments]    ${dict_arg}
    ${currentdate}    Define Current Date
    ${end_date}    Add Time To Date    ${current_date}    3 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Input Text Into Field    ${end_date_contract}    ${end_date}
    Set To Dictionary    ${dict_arg}    end_date=${end_date}
    RETURN    ${dict_arg}

Select Contract Owner
    [Arguments]    ${owner_arg}
    Select From List By Label    ${contract_owner_select}    ${owner_arg}

Select Contract Type
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${contract_type}    Regular Contract
    # Common.Page Alert Message    Save succesfully 

Check DatePicker
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //button[contains(text(),'Done')]
    Run Keyword If    ${is_visible}    Click Element    //button[contains(text(),'Done')]
    
Click Save Contract
    Check DatePicker
    Wait Until Element Is Visible    ${save_contract}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${save_contract}

Click View Changelog
    Wait Until Element Is Visible    ${view_changelog}
    Click Element    ${view_changelog}

Click Inactive Checkbox
    Click Element    //*[@id='Inactive']

Click Close Contracts
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${close_contract}
    Waiting For Loading

Add New Contract
    [Arguments]    ${owner_arg}    ${dict_arg}
    Click New Contract / Pricing Set
    # Update Contract Number
    ${dict_arg}    Get Contract Number    ${dict_arg}
    Input Description Contract
    Select Contract Owner    ${owner_arg}
    Input Start Date - New Contract    ${dict_arg}
    Input End Date - New Contract    ${dict_arg}
    Click Save Contract
    Sleep    3s
    Select Contract Type
    Click Save Contract
    Check Contract Changelog
    RETURN    ${dict_arg}

Check Contract Changelog
    ${check_exist}    Run Keyword And Return Status    Wait Until Element Is Visible    ${contract_changelog}    5s
    IF    ${check_exist} == ${True}
        Input Text Into Field    //*[@id='Reason']    Test
        ${user_name_txt}    Common.Get User Name
        Select From List By Label    //*[@id='AuthorizedBy']    ${user_name_txt}
        Scroll And Click Element   //*[@id="SaveBtn" and normalize-space(text())='Accept']
    END

Add Available Item
    [Arguments]    ${ndc_arg}
    Input Text Into Field    ${search_item_input}    ${ndc_arg}
    Scroll And Click Element    ${contract_find_ndc_btn}
    Wait Until Element Is Visible    ${available_items}
    ${add_btn}    Set Variable    //*[contains(text(),'${ndc_arg}')]//following::*[@onclick and contains(text(),'Add')][1]
    Scroll And Click Element    ${add_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Insert new item into Contract')]
    Input Text Into Field    ${contract_base_price_input}    30
    Scroll And Click Element    ${contract_complete_btn}
    Common.Page Alert Message    Contract Lines Successfully Added!

Add Member Assignment
    [Arguments]    ${owner_arg}    ${member_arg}
    Scroll And Click Element    //*[contains(text(),'Member Assignments')]
    Input Text Into Field    //*[@id='MemberSearchValues']    ${owner_arg}
    Click Element    //*[@id='MemberFindButton']
    ${member_input}    Set Variable    //td[contains(normalize-space(.),'${member_arg}')]//input
    Waiting For Loading
    Wait Until Element Is Visible        ${member_input}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${member_input}

Update Base Price
    [Arguments]    ${ndc_arg}
    Wait Until Element Is Visible    //*[@id='ContractedItemsTable']//following::*[@onclick and contains(text(),'${ndc_arg}')]
    Scroll Element Into View    ${item_base_price}
    Input Text Into Field    ${item_base_price}    10
    Scroll And Click Element    ${update_item_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Price Change Popup')]
    Select From List By Label    //*[@id='PriceDataSource']    Other
    Click Element    //*[@id='SaveBtn']
    Common.Page Alert Message    Contract Lines Successfully Updated!
