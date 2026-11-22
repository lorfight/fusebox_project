*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/ModifierManagement/ModifierManagement.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Suite Teardown    Close All Browsers
Test Tags    PrimeSmokeAssoPay    test:retry(3)    ADM_040

*** Test Cases ***
Verify Create Modifier Mapping
    [Documentation]    ADM-40: Create Modifier Mapping
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    ModifierManagement.Go To Modifier Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Modifier Management
    ModifierManagement.Click Modifier Mapping
    Wait Until Element Is Visible    id=ModalModifierMappingPopup    60s
    Sleep    2s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Click To Remove Modifier Mapping    route=INTRAVENOUS    site=Abdomen \(Left)    mod=26
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Click Delete
    END
    ModifierManagement.Select Route Of Admin    route=INTRAVENOUS
    Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Select Site Of Therapy    site=Abdomen \(Left)
    Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Select Modifier    mod=${modifier}
    ModifierManagement.Click To Add Modifier Mapping
    ModifierManagement.Accept Mapping Modal
    Wait Until Element Is Not Visible    id=ModalModifierMappingPopup    60s

Verify Create Update Modifier Category
    [Documentation]    ADM-41: Create Modifier Category    ADM-42: Update Modifier Category
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    ModifierManagement.Go To Modifier Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Modifier Management
    ModifierManagement.Click Modifier Category
    Wait Until Element Is Visible    id=ModalModifierCategory    60s
    ModifierManagement.Clear Search Cagtegory
    ModifierManagement.Input Search Category    cat=test modifier category
    ModifierManagement.Click Find Cagtegory
    ${check}    Run Keyword And Return Status    ModifierManagement.Click Delete Category    cat=test modifier category
    ModifierManagement.Click Add Modifier Category
    Wait Until Element Is Visible    id=ModalCategoryPopup    60s
    ModifierManagement.Close Category Modal
    Wait Until Element Is Not Visible    id=ModalCategoryPopup    60s
    ModifierManagement.Close Category Management Modal

Verify Create Edit Modifier
    [Documentation]    ADM-43: Create Modifier    ADM-44: Edit Modifier
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    ModifierManagement.Go To Modifier Management
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Modifier Management
    ModifierManagement.Click Modifier Mapping
    Wait Until Element Is Visible    id=ModalModifierMappingPopup    60s
    ${xpaths}    Get WebElements    //tbody//*[@value='${modifier}']/following::*[@id='removeMapping'][1]
    FOR    ${xpath}    IN    @{xpaths}
        Click Element    ${xpath}
        Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Click Delete
    END
    Wait Until Keyword Succeeds    5times    5s    ModifierManagement.Accept Mapping Modal
    Wait Until Element Is Not Visible    id=ModalModifierMappingPopup    60s
    ModifierManagement.Click Clear Modifier
    ModifierManagement.Input Search Modifier    mod=${modifier}
    ModifierManagement.Click Find Modifier
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    1s    ModifierManagement.Click Delete Modifier    mod=26
    IF    ${check} == ${True}
        Sleep    2s
        ModifierManagement.Click Delete
        Wait Until Element Is Not Visible    id=ModalConfirmPopup    60s
    END
    ModifierManagement.Click Create New Modifier
    Wait Until Element Is Visible    id=ModalPopup    60s
    ModifierManagement.Select Category    cat=${category}
    ModifierManagement.Input Modifier    mod=${modifier}
    ModifierManagement.Input Definition    def=test def
    Sleep    1s
    ModifierManagement.Click Create
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    ModifierManagement.Input Search Modifier    mod=${modifier}
    ModifierManagement.Click Find Modifier
    Wait Until Keyword Succeeds    5 times    3s    ModifierManagement.Click Edit Modifier    mod=${modifier}
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${def}    Get Value    id=Definition
    IF    "updated" in "${def}"
        ModifierManagement.Input Definition    def=test def
    ELSE
        ModifierManagement.Input Definition    def=test def updated
    END
    ModifierManagement.Click Save

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
    Switch To Another Window    Home
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

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
    Set Suite Variable    ${modifier}    ${data_input}[modifier]
    Set Suite Variable    ${category}    ${data_input}[category]