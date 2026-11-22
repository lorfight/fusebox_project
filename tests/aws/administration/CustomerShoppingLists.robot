*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Test Setup    Test Setup Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_104    report.label.owner:Nga Phan

*** Test Cases ***
Verify Customer Shopping Lists
    [Documentation]    Customer Shopping Lists
    ...    Admin
    ...    test_id:[ADM-80]    [ADM-81]
    ...  report.label.owner:Nga Phan
    Go To Customer Shopping Lists
    Check Shopping List Item    ${ShoppingData.shoppingname}    ${ShoppingData.owner}
    Search Available Items    ${ShoppingData.ndc}
    Click Add Item
    Search List Items    ${ShoppingData.ndc}
    Click Remove From List

Check Shopping List Update Successfully
    [Documentation]    Customer Shopping Lists
    ...    Admin
    ...    test_id:[ADM-82]    [ADM-83]
    ...  report.label.owner:Nga Phan
    Go To Customer Shopping Lists
    Update Shopping List Item    ${ShoppingData.shoppingname}
    Verify Assign/Unassign Member    ${ShoppingData.association}    ${ShoppingData.member}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${ShoppingData}
    ...    owner=${data_input}[owner]  
    ...    ndc=${data_input}[ndc]
    ...    association=${data_input}[association]
    ...    member=${data_input}[member]
    ...   shoppingname=${data_input}[shoppingname]

Test Setup Keyword
    ${check_logout}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    Log In
    IF    "${check_logout}" == "${True}"
        LoginKeywords.Login account    ${Username}    ${Password}
    END
    Open New Window

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

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{ShoppingData}    Create Dictionary
    Set Suite Variable    ${ShoppingData}
    Setup Data
