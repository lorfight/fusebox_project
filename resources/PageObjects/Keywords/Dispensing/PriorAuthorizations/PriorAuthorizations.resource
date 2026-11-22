*** Settings ***
Resource    ../../Layers/PriorAuthorizations/PriorAuthorizations.resource

*** Keywords ***
Filter PA Navigate Mrn
    [Arguments]    ${location_arg}    ${mrn_arg}
    Filter Location    ${location_arg}
    Filter Patient    ${mrn_arg}
    Click Search PA

Edit Prior Authorizations Successfully
    [Arguments]    ${po_num}    ${status}    ${dict_arg}    ${type}
    Click Edit PA Button    ${po_num}
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Select PA Medication Type    ${dict_arg}    ${type}
    Common.Scroll And Click Element    ${pa_update_btn}
    Common.Page Alert Message    Prior Authorization Successfully Updated!
    Common.Close Modal Popup

Verify Insurance Verification Details Displays Correctly
    [Arguments]    ${po_num}
    Click Insurance Verification Button In PA Page    ${po_num}
    ${insurance_title}    Set Variable    //h4[text()='Insurance Call Method']
    Wait Until Element Is Visible    ${insurance_title}    30s
    ${verify_checkbox}    Set Variable    //input[@id="verify"]
    Wait Until Element Is Visible    ${verify_checkbox}    30s
    ${discovery_checkbox}    Set Variable    //input[@id="discovery"]
    Wait Until Element Is Visible    ${discovery_checkbox}    30s
    ${perform_btn}    Set Variable    //button[contains(text(),'Perform')]
    Wait Until Element Is Visible    ${perform_btn}    30s
    Common.Close SubModal Popup

View PO Popup In PA Page
    [Arguments]    ${po_num}
    Click PO Button In PA Page    ${po_num}
    Common.Close Modal Popup
    
View Billing Invoice Report Successfully
    Click Print Billing Invoice Button
    Go To Billing Invoice Report Page
    Wait Until Element Is Visible    //div[contains(@id,'reportViewer')]    30s

Go To Billing Invoice Report Page
    Switch Window    title=Report Viewer
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Report Viewer
    Set Window Size    1920    1080

Close Patient Billing Invoice Report In Report Reviewer Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}
    