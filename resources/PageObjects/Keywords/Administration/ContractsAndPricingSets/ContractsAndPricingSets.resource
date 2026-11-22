*** Settings ***
Resource    ../../Layers/ContractsAndPricingSets/ContractsAndPricingSets.resource

*** Variables ***
${contract_remove_error}    //*[@id='saveBtnImportContractMembership' and contains(text(),'Remove Error Lines')]
${contact_new_import_btn}    //*[@id='newBtnImportContractMembership' and contains(text(),'New Import')]

*** Keywords ***

Check Available Items List Displayed
    Wait Until Element Is Visible    ${available_items}

Check Contracted Items List Displayed
    [Arguments]    ${ndc_arg}
    Wait Until Element Is Visible    //*[@id='ContractedItemsTable']//following::*[@onclick and contains(text(),'${ndc_arg}')]

Select Field Export Pre-Filled Contract Membership
    [Arguments]    ${headoffice_arg}    ${contract_arg}    ${startdate_arg}    ${enddate_arg}
    Click Contract Membership Tools
    ${is_check}    Run Keyword And Return Status    Element Should Be Visible    ${contract_remove_error}   
    IF    ${is_check}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${contract_remove_error}
    END
    Check Import Contract Line
    Click Export Pre-Filed Template
    Wait Until Element Is Visible    //*[@id='contractExportPreFilled']
    Select Head Offices Export    ${headoffice_arg}
    Select Contract Set/No    ${contract_arg}
    Input Start Date    ${startdate_arg}
    Input End Date    ${enddate_arg}

Get Date Time For File Name
    [Arguments]    ${file_detail}
    ${date}    Get Time Now    result_format=%Y_%m_%d_%H%M%S
    ${date}    Convert Date    ${date}    result_format=%Y_%m_%d
    # ${date}    Subtract Time From Date    ${date}    13 hour    result_format=%Y_%m_%d
    ${file_name}=    Set Variable  ${file_detail}-${date}.xlsx
    RETURN    ${date}

Export Pre-Filled Template
    [Arguments]    ${headoffice_arg}    ${contract_arg}    ${startdate_arg}    ${enddate_arg}
    Select Field Export Pre-Filled Contract Membership    ${headoffice_arg}    ${contract_arg}    ${startdate_arg}    ${enddate_arg}
    ${date}    Get Date Time For File Name    ContractMembershipReport
    #Util.Download Report    ${file_name}    ${contract_process_export}
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    ${previous_file_count}    Count Files In Directory    ${export_path}
    Wait Until Keyword Succeeds    30s    1s    Click Process Export
    ${latest}    Check Latest Download File    ${export_path}    ${previous_file_count}    ContractMembershipReport    ${date}
    Click Close Modal Import
    RETURN    ${latest}

Import Contract Membership Required Field
    [Arguments]    ${file_path}
    Waiting For Loading
    Click Contract Membership Tools
    Wait Until Element Is Visible    ${contract_choose_file}    10s
    Choose File    ${contract_choose_file}    ${file_path}
    Click Element    ${contract_process_file}
    Wait Until Element Is Visible    //h4[contains(text(),'Import Contract Membership')]
    Input Text Into Field    //*[@id='Reason']    Test
    ${user_name_txt}    Common.Get User Name
    Select From List By Label    //*[@id='AuthorizedBy']    ${user_name_txt}
    Click Comfirm Import
    Remove File    ${file_path}
    
Copy Contract
    [Arguments]    ${contract_arg}
    Click Copy Contract List
    Click Checkbox Contract Number    ${contract_arg}
    Click Copy Contract
    Confirm Copy Contract
    Common.Page Alert Message    Save Success

View Copy Contract List
    [Arguments]    ${dict_arg}    ${contract_arg}    ${startdate_arg}    ${enddate_arg}
    Wait Until Element Is Visible    //h4[contains(text(),'View Copied Contract List')]
    Filter Date Range View Copy     ${startdate_arg}    ${enddate_arg}
    Wait Until Element Is Visible    //span[contains(text(),'${contract_arg}')]    30s
    ${is_pending}=  Run Keyword And Return Status
    ...  Element Should Be Visible
    ...  //tr[.//td[normalize-space(.)='${contract_arg}']]//td[position()=last()-1][normalize-space(.)='Pending']
    IF  ${is_pending}
        Fail    Contract ${contract_arg} is in Pending status. Test case failed by business rule.
    END
    ${dict_arg}    Get Contract Number Copy    ${dict_arg}    ${contract_arg}
    Click Element    //*[@id='CopiedContractListCloseBtn']
    RETURN    ${dict_arg}

Delete Contract Copy
    [Arguments]    ${contract_arg}
    Wait Until Element Is Not Visible    //h4[contains(text(),'Copy Contract List')]
    Search By Contract Information    ${contract_arg}
    Click Delete Contract Item    ${contract_arg}
    Reload Page

Edit Contract
    [Arguments]    ${contract_arg}
    Search By Contract Information    ${contract_arg}
    Click Edit Contract Item    ${contract_arg}
    ${desc}    Get Value    ${contract_description_input}
    Set Test Variable    ${desc}
    Wait Until Element Is Visible    ${contract_description_input}
    Clear Input Field Until Empty    ${contract_description_input}
    Input Text    ${contract_description_input}    Edit Text
    Click Save Contract
    Check Contract Changelog
    Click Close Contracts

Copy Contract Item
    [Arguments]    ${contract_arg}    ${dict_arg}
    Search By Contract Information    ${contract_arg}
    Click Copy Contract Item    ${contract_arg}
    Wait Until Element Is Visible    //h4[contains(text(),'Copy - Contract No: ${contract_arg}')]
    Click Element    //*[contains(text(),'Accept')]
    Waiting For Loading
    Wait Until Element Is Visible    ${contract_id}
    Clear Input Field Until Empty    ${contract_id}
    Input Text Into Field    ${contract_id}    Copy Contract: Simple Contract 2026 Automation Test
    Click Inactive Checkbox
    Click Save Contract
    ${contract_number}    Get Value    ${contract_id}
    Set Test Variable    ${contract_number}
    Click Close Contracts
    Delete Contract Copy    ${contract_number}

Check Import Contract Line
    ${is_check}    Run Keyword And Return Status    Element Should Be Visible    //*[contains(text(),'You are about to alter a contract, please enter the following information to continue.')]   
    IF    ${is_check}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${contact_new_import_btn}
        Handle Alert    ACCEPT
        Waiting For Loading
    END