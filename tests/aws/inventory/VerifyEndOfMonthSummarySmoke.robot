*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup     Setup Suite
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Admin_QCA2    inventory    Smoke    aws    INV_05

*** Test Cases ***
Generate On Hand Inventory Report
    [Documentation]    Verify Download End of Month Summary Report Sucessfully
    ...    INV_19    INV_20
    ...  report.label.owner:Quoc Nguyen
    Click Element    link:Inventory
    Click Element    link:End of Month Summary
    Switch Window    Report Viewer
    Wait Until Page Contains    End Of Month Inventory Summary    30s    
    ${pdf_file_path}    Download Report PDF File Report    EndOfMonthInventorySummary.pdf 
    

*** Keywords ***
Setup Suite  
    Login To Fusebox    user_name=${Username}    password=${Password}
    
Teardown Test Case
    Close Window
    Switch Window    Home

Teardown Suite
    Close Browser

Download Report PDF File Report
    [Arguments]   ${file_name}
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${export_path}    Join Path    ${export_path}    ${file_name}
    ${exists}    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
    Wait Until Element Is Visible    //div[contains(text(),'Done. Total')]    30s
    Wait Until Element Is Visible    //div[@class="trv-nav"]//a[@title="Export"]    30s
    Click Element    //div[@class="trv-nav"]//a[@title="Export"]
    Util.Waiting For Loading
    Wait Until Element Is Enabled   //a[@data-command-parameter="PDF"]    30s
    Click Element    //a[@data-command-parameter="PDF"]
    Wait Until Created    ${export_path}    60s
    File Should Exist    ${export_path}
    RETURN    ${export_path}
    
