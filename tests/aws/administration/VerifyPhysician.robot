*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Physicicians/Physicians.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    PrimeSmokeAssoPay    test:retry(3)    ADM_049

*** Test Cases ***
Verify Assign Physician
    [Documentation]    ADM-49: Assign Physician
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Physicians.Go To Physiscians
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Physicians
    Physicians.Select Account    acc=${location} \(${location_id})
    Physicians.Click Assign New Physician
    Wait Until Element Is Visible    id=ModalPopup    60s
    Physicians.Click Clear Search
    Physicians.Input NPI    npi=${npi_physician}
    Physicians.Click Search
    Wait Until Keyword Succeeds    5 times    3s    Physicians.Click Assign Physician
    Wait Until Element Is Not Visible    id=ModalPopup    60s

Verify Assign Referral
    [Documentation]    ADM-50: Assign Referral
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Physicians.Go To Physiscians
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Physicians
    Physicians.Select Account    acc=${location} \(${location_id})
    Physicians.Click Assign New Referral
    Wait Until Element Is Visible    id=ModalPopup    60s
    Physicians.Click Clear Search
    Physicians.Input NPI    npi=${npi_referral}
    Physicians.Click Search
    Wait Until Keyword Succeeds    5 times    3s    Physicians.Click Assign Referral
    Wait Until Element Is Not Visible    id=ModalPopup    60s

Verify Import Physician
    [Documentation]    ADM-51: Import Physician
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Physicians.Go To Physiscians
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Physicians
    Physicians.Select Account    acc=${location} \(${location_id})
    Physicians.Click Assigned Tab
    ${check}    Run Keyword And Return Status    Physicians.Click Remove Physician    npi=${npi_import}
    Physicians.Click Referring Tab
    ${check}    Run Keyword And Return Status    Physicians.Click Remove Physician    npi=${npi_import}
    Util.Scroll To Top
    Physicians.Click Import Physicians
    Wait Until Element Is Visible    id=ModalPopup    60s
    Run Keyword And Ignore Error    Remove File    path=${file_path}/PhysicianImportTemplate.xlsx
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@class='ImportItem']
    IF    ${check} == ${True}
        Physicians.Remove Import File
        Wait Until Element Is Not Visible    link: Remove    60s
    END
    Physicians.Click Download Template
    ${path}    Set Import File Path
    Wait Until Keyword Succeeds    5 times    3s   Should Exist    ${path}
    ${data}    CustomLibrary.Read Excel File    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Account #\    value=${location_id}    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Physician NPI #\    value=${npi_import}   path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Is Referring    value=FALSE    path=${path}
    Physicians.Upload File    path=${path}
    Physicians.Click Process File
    Wait Until Keyword Succeeds    5 times    3s    Physicians.Click Confirm Import
    Handle Alert
    Wait Until Element Is Not Visible    id=ModalPopup    60s

*** Keywords ***
Suite Setup Keyword
    [Documentation]    Suite Setup
    [Tags]    Setup
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    LoginKeywords.Check Newsletter

Test Setup Keyword
    ${check}    Run Keyword And Return Status    Switch To Another Window    Home
    Return From Keyword If    ${check} == ${True}
    Open New Window    ${SiteUrl}
    Close Window
    Wait Until Keyword Succeeds    20 times    3s    Switch To Another Window    Home
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

Set Import File Path
    ${path}    Set Variable    ${file_path}/PhysicianImportTemplate.xlsx
    RETURN    ${path}

Open New Window
    [Arguments]    ${url}
    Execute Javascript    window.open('${url}','_blank')
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Set Window Size    1920    1080
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title}
    Switch Window    ${title}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    ${title}
    Wait Until Keyword Succeeds    10 times    3s    LoginKeywords.Check Newsletter
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

Setup Data
    ${data_input}    CommonKeywords.Get Data
    Set Suite Variable    ${mode}    headless
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${location_id}    ${data_input}[location_id]
    Set Suite Variable    ${npi_physician}    ${data_input}[npi_physician]
    Set Suite Variable    ${npi_referral}    ${data_input}[npi_referral]
    Set Suite Variable    ${npi_import}    ${data_input}[npi_import]