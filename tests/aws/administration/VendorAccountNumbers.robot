*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Test Setup    Test Setup Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_111

*** Test Cases ***
Verify Update Detail Verdor Account Number
    [Documentation]    Verdor Account Number
    [Tags]    Admin
    ...    test_id:[VEN-1]
    ...  report.label.owner:Nga Phan
    Go To Verdor Account Numbers
    Find Vendor Account    account_arg=${VendorData.account}    headoffice_arg=${VendorData.headoffice}    association_arg=${VendorData.association}    member_arg=${VendorData.account}    vendor_arg=${VendorData.vendor}
    Update Vendor Account Detail

Verify Export Member Ship Report
    [Documentation]    Verdor Account Number
    [Tags]    Admin
    ...    test_id:[VEN-2]
    ...  report.label.owner:Nga Phan
    Go To Verdor Account Numbers
    Find Vendor Account    account_arg=${VendorData.account}    headoffice_arg=${VendorData.headoffice}    association_arg=${VendorData.association}    member_arg=${VendorData.account}    vendor_arg=${VendorData.vendor}
    Click Export Vendor
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${file_name}    Get File Name    VendorAccountExport    %-m_%-d_%Y
    ELSE
        ${file_name}    Get File Name    VendorAccountExport    %#m_%#d_%Y
    END
    Download Report    ${file_name}    ${export_file_btn_vendor_acc}


*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${VendorData}    
    ...    account=${data_input}[account]  
    ...    headoffice=${data_input}[headoffice]
    ...    association=${data_input}[association]
    ...    vendor=${data_input}[vendor]

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
    &{VendorData}    Create Dictionary
    Set Suite Variable    ${VendorData}
    Setup Data
