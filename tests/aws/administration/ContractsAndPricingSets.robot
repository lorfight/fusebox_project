*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_103    report.label.owner:Nga Phan
*** Test Cases ***
View Available Items And Contracted Items In New Contract Pricing Sets
    [Documentation]    
    ...    Admin
    ...    test_id:[ADM-75]    [ADM-76]
    Go To Contracts And Pricing Set
    ${ContractData}    Add New Contract    ${ContractData.owner}    ${ContractData}
    Check Available Items List Displayed
    Add Available Item    ${ContractData.ndc}
    Check Contracted Items List Displayed    ${ContractData.ndc}
    Add Member Assignment    ${ContractData.owner}    ${ContractData.member}
    Click Close Contracts
    Search By Contract Information    ${ContractData.contract_num}
    Click Delete Contract Item    ${ContractData.contract_num}

Export Pre-Filled Template And Import MemberShip
    [Documentation]    
    ...    Admin
    ...    test_id:[ADM-74]
    ...  report.label.owner:Nga Phan
    Go To Contracts And Pricing Set
    ${ContractData}    Add New Contract    ${ContractData.owner}    ${ContractData}
    Add Member Assignment    ${ContractData.owner}    ${ContractData.member}
    Click Close Contracts
    ${latest}    Export Pre-Filled Template    ${ContractData.headoffice}    ${ContractData.contract_num}    ${ContractData.current_date}    ${ContractData.end_date}
    Import Contract Membership Required Field    ${latest}
    Search By Contract Information    ${ContractData.contract_num}
    Click Delete Contract Item    ${ContractData.contract_num}
    
Verify Copy And View Copy Contract List
    [Documentation]    
    ...    Admin
    ...    test_id:[ADM-77]    [ADM-78]
    ...  report.label.owner:Nga Phan
    Go To Contracts And Pricing Set
    ${ContractData}    Add New Contract    ${ContractData.owner}    ${ContractData}    
    Add Member Assignment    ${ContractData.owner}    ${ContractData.member}
    Click Close Contracts
    Copy Contract    ${ContractData.contract_num}
    View Copy Contract List    ${ContractData}    ${ContractData.contract_num}    ${ContractData.current_date}    ${ContractData.end_date}
    Click Close Copy Contract
    Delete Contract Copy    ${ContractData.contract_num_copy}
    Search By Contract Information    ${ContractData.contract_num}
    Click Delete Contract Item    ${ContractData.contract_num}

Verify Edit Copy And Delete Contract
    [Documentation]    
    ...    Admin
    ...    test_id:[ADM-79]
    ...  report.label.owner:Nga Phan
    Go To Contracts And Pricing Set
    ${ContractData}    Add New Contract    ${ContractData.owner}    ${ContractData}
    Add Member Assignment    ${ContractData.owner}    ${ContractData.member}
    Click Close Contracts
    Edit Contract    ${ContractData.contract_num}
    Copy Contract Item    ${ContractData.contract_num}    ${ContractData}
    Search By Contract Information    ${ContractData.contract_num}
    Click Delete Contract Item    ${ContractData.contract_num}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${ContractData}    
    ...    owner=${data_input}[owner]  
    ...    headoffice=${data_input}[headoffice]
    ...    ndc=${data_input}[ndc]
    ...    member=${data_input}[member]

Create Folder Download
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    Create Directory    ${export_path}

Test Setup Keyword
    ${check_logout}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    Log In
    IF    "${check_logout}" == "${True}"
        LoginKeywords.Login account    ${Username}    ${Password}
    END
    Open New Window

Test Teardown Keyword
    Close Window
    Switch To Another Window    title_arg=Home
    Reload Page

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{ContractData}    Create Dictionary
    Set Suite Variable    ${ContractData}
    Setup Data
    Create Folder Download

Open New Window
    Execute Javascript    window.open('${SiteUrl}','_blank')
    Set Window Size    1920    1080
    Switch To Another Window    title_arg=Home
    LoginKeywords.Check Newsletter

Switch To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}
    Set Window Size    1920    1080
