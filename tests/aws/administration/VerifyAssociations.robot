*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Associations/Associations.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    PrimeSmokeAssoPay    test:retry(3)    ADM_01

*** Test Cases ***
Verify Search Association
    [Documentation]    ADM-1: Search Association
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Associations.Go To Associations
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Association Management
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association
    IF    ${check} == ${False}
        Associations.Click Create Assocation
        Wait Until Element Is Visible    id=ModalPopup    60s
        Associations.Input Association Name    name=test association
        Associations.Click Clear Tag
        Associations.Input Association Tag    tag=test tag
        Associations.Input Description    text=test description
        Wait Until Keyword Succeeds    5 times    3s    Associations.Accept Modal
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    END
    Associations.Select Association    assoc=test association

Verify Create Association
    [Documentation]    ADM-2: Create Association
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Associations.Go To Associations
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Association Management
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association
    IF    ${check} == ${True}
        Reset Assigned Association
        Sleep    3s
        Associations.Click Delete Association
        Handle Alert
    END
    Sleep    3s
    Associations.Click Create Assocation
    Wait Until Element Is Visible    id=ModalPopup    60s
    Associations.Input Association Name    name=test association
    Associations.Click Clear Tag
    Associations.Input Association Tag    tag=test tag
    Associations.Input Description    text=test description
    Wait Until Keyword Succeeds    5 times    3s    Associations.Accept Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    Associations.Select Association    assoc=test association

Verify Update Association
    [Documentation]    ADM-3: Update Association
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Associations.Go To Associations
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Association Management
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association
    IF    ${check} == ${False}
        Associations.Click Create Assocation
        Wait Until Element Is Visible    id=ModalPopup    60s
        Associations.Input Association Name    name=test association
        Associations.Click Clear Tag
        Associations.Input Association Tag    tag=test tag
        Associations.Input Description    text=test description
        Wait Until Keyword Succeeds    5 times    3s    Associations.Accept Modal
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    END
    Associations.Select Association    assoc=test association
    Associations.Click Edit Association
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${name}    Get Value    id=Name
    IF    "updated" in "${name}"
        Associations.Input Association Name    name=test association
    ELSE
        Associations.Input Association Name    name=test association updated
    END
    ${desc}    Get Value    id=Description
    IF    "updated" in "${name}"
        Associations.Input Description    text=test description
    ELSE
        Associations.Input Description    text=test description updated
    END
    Associations.Accept Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association updated
    IF    ${check} == ${True}
        Reset Assigned Association
        Sleep    3s
        Associations.Click Delete Association
        Handle Alert
    END

Verify Delete Association
    [Documentation]    ADM-4: Delete Association
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Associations.Go To Associations
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Association Management
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association
    IF    ${check} == ${False}
        Associations.Click Create Assocation
        Wait Until Element Is Visible    id=ModalPopup    60s
        Associations.Input Association Name    name=test association
        Associations.Click Clear Tag
        Associations.Input Association Tag    tag=test tag
        Associations.Input Description    text=test description
        Wait Until Keyword Succeeds    5 times    3s    Associations.Accept Modal
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    ELSE
        Reset Assigned Association
    END
    Associations.Select Association    assoc=test association
    Associations.Click Delete Association
    Handle Alert

Verify View Changes Association
    [Documentation]    ADM-5: Delete Association
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Associations.Go To Associations
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Association Management
    ${check}    Run Keyword And Return Status    Associations.Select Association    assoc=test association
    IF    ${check} == ${False}
        Associations.Click Create Assocation
        Wait Until Element Is Visible    id=ModalPopup    60s
        Associations.Input Association Name    name=test association
        Associations.Click Clear Tag
        Associations.Input Association Tag    tag=test tag
        Associations.Input Description    text=test description
        Wait Until Keyword Succeeds    5 times    3s    Associations.Accept Modal
        Wait Until Element Is Not Visible    id=ModalPopup    60s
    END
    Associations.Select Association    assoc=test association
    Associations.Click View Changes
    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[contains(text(),'Association Change Log')]    60s
    Associations.Close Modal

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
    Set Suite Variable    ${location_id}    ${data_input}[location_id]

Reset Assigned Association
    ${lines}    Get Element Count    //*[@id='CurrentlyAssociated']//tbody/*[*]//*[@class='Assign'][1]
    FOR    ${line}    IN RANGE    ${lines}
        IF    ${line} < ${lines-1}
            Wait Until Keyword Succeeds    5 times    3s    Scroll Element Into View    //*[@id='CurrentlyAssociated']//tbody/*[${line+1}]//*[@class='Assign'][1]
        ELSE
            Util.Scroll To Bottom
        END
        Wait Until Keyword Succeeds    5 times    3s    Unselect Checkbox    //*[@id='CurrentlyAssociated']//tbody/*[${line+1}]//*[@class='Assign'][1]
        Checkbox Should Not Be Selected    //*[@id='CurrentlyAssociated']//tbody/*[${line+1}]//*[@class='Assign'][1]
    END