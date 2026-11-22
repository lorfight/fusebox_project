*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/PayerManagement/PayerManagement.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    PrimeSmokeAssoPay    test:retry(3)    ADM_036

*** Test Cases ***
Verify Map Master Payer
    [Documentation]    ADM-36: Map Master Payer
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    PayerManagement.Go To Payer Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Payer Management
    PayerManagement.Select Account    acc=${location} \(${location_id})
    PayerManagement.View Map Master Payers    is_view=${True}
    PayerManagement.Click Clear
    PayerManagement.Input To Find Payer    text=auto master payer
    PayerManagement.Click Find
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10 times    3s   PayerManagement.Click Map Payers    payer=auto master payer
    IF    ${check} == ${False}
        PayerManagement.Select Account    acc=-- System Payers --\
        Sleep    3s
        PayerManagement.Click Create New Payer
        Wait Until Element Is Visible    id=ModalPopup    60s
        PayerManagement.Input Payer Name    name=auto master payer
        PayerManagement.Input Address Line    add=test add
        PayerManagement.Check Master Payer
        PayerManagement.Input Master Payer ID    id=12345
        Sleep    2s
        PayerManagement.Submit Modal
        Wait Until Element Is Not Visible    id=ModalPopup    60s
        PayerManagement.Select Account    acc=${location} \(${location_id})
        PayerManagement.Input To Find Payer    text=auto master payer
        PayerManagement.Click Map Payers    payer=auto master payer
    END
    Wait Until Element Is Visible    id=SubModalPopup    60s
    Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Close Submodal

Verify Create And Update Payer
    [Documentation]    ADM-38: Create Payer    ADM-39: UpdateCreate Payer
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    PayerManagement.Go To Payer Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Payer Management
    PayerManagement.Select Account    acc=${location} \(${location_id})
    PayerManagement.View Map Master Payers    is_view=${False}
    PayerManagement.Click Clear
    PayerManagement.Input To Find Payer    text=auto payer
    PayerManagement.Click Find
    ${check}    Run Keyword And Return Status    PayerManagement.Click Update Payer    payer=auto payer
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Click Delete
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    END
    Sleep    3s
    PayerManagement.Click Create New Payer
    Wait Until Element Is Visible    id=ModalPopup    60s
    PayerManagement.Input Payer Name    name=auto payer
    PayerManagement.Input Address Line    add=test add
    PayerManagement.Submit Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    PayerManagement.Select Account    acc=${location} \(${location_id})
    PayerManagement.View Map Master Payers    is_view=${False}
    Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Click Clear
    PayerManagement.Input To Find Payer    text=auto payer
    PayerManagement.Click Find
    Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Click Update Payer    payer=auto payer
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${name}    Get Value    id=PayerName
    IF    "updated" in "${name}"
        PayerManagement.Input Payer Name    name=auto payer
    ELSE
        PayerManagement.Input Payer Name    name=auto payer updated
    END
    ${desc}    Get Value    id=Address1
    IF    "updated" in "${desc}"
        PayerManagement.Input Address Line    add=test add
    ELSE
        PayerManagement.Input Address Line    add=test add updated
    END
    Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Close Modal

Verify Import Payer
    [Documentation]    ADM-37: Import Payer
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    PayerManagement.Go To Payer Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Payer Management
    PayerManagement.Select Account    acc=${location} \(${location_id})
    PayerManagement.View Map Master Payers    is_view=${False}
    PayerManagement.Click Clear
    PayerManagement.Input To Find Payer    text=${import_payer}
    PayerManagement.Click Find
    ${check}    Run Keyword And Return Status    PayerManagement.Click Update Payer    payer=${import_payer}
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Click Delete
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    END
    Sleep    3s
    PayerManagement.Click Payer Import
    Wait Until Element Is Visible    id=ModalPopup    60s
    Run Keyword And Ignore Error    Remove File    path=${file_path}/PayerImportTemplate.xlsx
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@class='ImportItem']
    IF    ${check} == ${True}
        PayerManagement.Remove Import File
    END
    PayerManagement.Click Download Template
    ${path}    Set Import File Path
    Wait Until Keyword Succeeds    5 times    3s   Should Exist    ${path}
    ${data}    CustomLibrary.Read Excel File    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Payer Name    value=${import_payer}    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Address    value=test add    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Country    value=United States    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Account #\    value=${location_id}    path=${path}
    PayerManagement.Upload File    path=${path}    file_name=PayerImportTemplate.xlsx
    Set Test Variable    ${path}
    PayerManagement.Click Process File
    Wait Until Keyword Succeeds    5 times    3s    PayerManagement.Click Confirm Import
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
    ${path}    Set Variable    ${file_path}/PayerImportTemplate.xlsx
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
    Set Suite Variable    ${import_payer}    ${data_input}[import_payer]