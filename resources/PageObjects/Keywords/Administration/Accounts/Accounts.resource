*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${accounts_search_input}    //input[@id="SearchValues"]
${accounts_find_btn}    //button[@id="FindButton"]
${accounts_clear_btn}    //button[@id="ClearButton"]
${accounts_technical_btn}    //a[contains(text(),'Technical')]
${accounts_save_btn}    //input[@id="SaveButton"]
${technical_emr_mapping_select}    //select[@id="EMRMapping"]
${technical_sao_account_limit}    //*[@id='SAOAccountLimit']

*** Keywords ***
Go To Accounts
    Common.Scroll And Click Element    link: Administration
    Common.Scroll And Click Element    link: Accounts
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Accounts

Click Find Account Button In Accounts Page
    Common.Scroll And Click Element    ${accounts_find_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Click Clear Account Button In Accounts Page
    Common.Scroll And Click Element    ${accounts_clear_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Input Account In Accounts Page
    [Arguments]    ${account_arg}
    Wait Until Element Is Visible    ${accounts_search_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${accounts_search_input}    ${account_arg}

Filter Account In Accounts Page
    [Arguments]    ${account_arg}
    Click Clear Account Button In Accounts Page
    Input Account In Accounts Page    ${account_arg}
    Click Find Account Button In Accounts Page

Choose Account In Accounts Page
    [Arguments]    ${account_id_arg}
    ${account_row}    Set Variable    //div[@id="AccountList"]//td/a[text()='${account_id_arg}']
    Common.Scroll And Click Element    ${account_row}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Edit Account

Click Save Button In Edit Account Page
    Common.Scroll And Click Element    ${accounts_save_btn}

Click Technical Button
    Common.Scroll And Click Element    ${accounts_technical_btn}

Select Emr Mapping
    [Arguments]    ${emr_name_arg}
    Wait Until Element Is Enabled    ${technical_emr_mapping_select}
    Scroll Element Into View    ${technical_emr_mapping_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${technical_emr_mapping_select}    ${emr_name_arg}

Input SAO Account Limit
    [Arguments]    ${quality_arg}
    Scroll Element Into View    ${technical_sao_account_limit}
    Clear Input Field Until Empty    ${technical_sao_account_limit}
    Input Text    ${technical_sao_account_limit}    ${quality_arg}
    Click Save Button In Edit Account Page 
