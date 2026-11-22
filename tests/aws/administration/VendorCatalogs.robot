*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_112

*** Test Cases ***
Verify Vendor Catalogs List Displays And Export Catalog Item
    [Documentation]    Vendor Catalogs
    [Tags]    Admin
    ...    test_id:[ADM-96]    [ADM-97]
    ...  report.label.owner:Nga Phan
    Go To Vendor Catalogs
    View Catalog Item List    ${VendorCatalog.vendor}    ${VendorCatalog.member}    ${VendorCatalog.ndc}
    Export Catalog Report

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${VendorCatalog}
    ...    vendor=${data_input}[vendor] 
    ...    member=${data_input}[member]
    ...    ndc=${data_input}[ndc]

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{VendorCatalog}    Create Dictionary
    Set Suite Variable    ${VendorCatalog}
    Setup Data