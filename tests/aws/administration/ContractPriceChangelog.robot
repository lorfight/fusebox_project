*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_102    report.label.owner:Nga Phan
*** Test Cases ***
Verify Contract Price Changelog Update And Displays Successfully
    [Documentation]    Contract Price Changelog
    ...    Admin
    ...    test_id:[ADM-91]
      
    Navigate To Contract And Pricing Sets
    Create Contract And Change Price    ${ContractData.owner}    ${ContractData.ndc}    ${ContractData}
    Add Member Assignment    ${ContractData.owner}    ${ContractData.member}
    Go To Contracts Price Changelog
    Check Price Changelog List Display    ${ContractData.contract_num}
    Switch Window    Contract Details
    Click Close Contracts
    Search By Contract Information    ${ContractData.contract_num}
    Click Delete Contract Item    ${ContractData.contract_num}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${ContractData}
    ...    owner=${data_input}[owner]
    ...    ndc=${data_input}[ndc]
    ...    member=${data_input}[member]

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{ContractData}    Create Dictionary
    Set Suite Variable    ${ContractData}
    Setup Data

Switch To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}
    Set Window Size    1920    1080