*** Settings ***
Resource    ../../Layers/ContractsAndPricingSets/ContractsAndPricingSets.resource

*** Variables ***
${price_changelog_search_contract}    //*[@id='ContractInformationSearchValues']
${price_changelog_find_btn}    //*[@id='ContractInformationFindButton']

*** Keywords ***
Search Contract
    [Arguments]    ${contract_arg}
    Input Text Into Field    ${price_changelog_search_contract}    ${contract_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${price_changelog_find_btn}

Click Contract Item
    [Arguments]    ${contract_arg}
    Waiting For Loading
    ${contract_item}    Set Variable    //*[@id='PriceChangelogList']//following::*[contains(text(),'${contract_arg}')]
    Wait Until Element Is Visible    ${contract_item}
    Scroll And Click Element    ${contract_item}

Go To Contracts Price Changelog
    Scroll And Click Element    link:Administration
    Click Element    link:Contract Price Changelog

Navigate To Contract And Pricing Sets
    Go To Contracts And Pricing Set

Create Contract And Change Price
    [Arguments]    ${owner_arg}    ${ndc_arg}    ${dict_arg}
    Add New Contract    ${owner_arg}    ${dict_arg}
    Add Available Item    ${ndc_arg}
    Update Base Price    ${ndc_arg}

Check Price Changelog List Display
    [Arguments]    ${contract_arg}
    Search Contract    ${contract_arg}
    Click Contract Item    ${contract_arg}