*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/PaperworkDocuments/PaperworkDocuments.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    PrimeSmokeAssoPay    test:retry(3)    ADM_047

*** Test Cases ***
Verify Create Assign Paperwork
    [Documentation]    ADM-47: Assign Paperwork    ADM-48: Create Paperwork
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    PaperworkDocuments.Go To Paperwork Documents
    Wait Until Keyword Succeeds    5 times    3s    Title Should Be    Paperwork Manager
    PaperworkDocuments.Click Paperwork Assign
    Wait Until Element Is Visible    link:New Paperwork Template
    Search To Delete Duplicated Templates    template=test paperwork
    PaperworkDocuments.Click New Paperwork Template
    Wait Until Element Is Visible    id=ModalPopup    60s
    PaperworkDocuments.Input Paperwork Name    name=test paperwork
    PaperworkDocuments.Input Paperwork Description    desc=test desc
    PaperworkDocuments.Select Importance    imp=Required
    PaperworkDocuments.Select Class Trade    trade=No Class Of Trade
    PaperworkDocuments.Select Association    assoc=Auto Test association
    PaperworkDocuments.Input Interval    inter=2
    PaperworkDocuments.Input Window    win=3
    PaperworkDocuments.Accept Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    Search To Assign Template In Pages    template=test paperwork
    Wait Until Keyword Succeeds    5 times    3s    PaperworkDocuments.Click Assign Template    template=test paperwork
    PaperworkDocuments.Click Clear
    PaperworkDocuments.Input Search Account    acc=${location}
    PaperworkDocuments.Click Find
    PaperworkDocuments.Select User To Assign    user=${user_assign}
    Wait Until Keyword Succeeds    5 times    3s    PaperworkDocuments.Select Assigned User    user=${user_assign}
    Wait Until Keyword Succeeds    5 times    3s    PaperworkDocuments.Select To Assign Paperwork    acc=${location_name}
    PaperworkDocuments.Close Modal

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
    Set Suite Variable    ${location_name}    ${data_input}[location_name]
    Set Suite Variable    ${user_assign}    ${data_input}[user_assign]

Search To Delete Duplicated Templates
    [Arguments]    ${template}
    ${num}    Get Text    //table/following::*[@href and text()='Next']/preceding-sibling::*[contains(@href,'page')][1]
    ${num}    Evaluate    ${num}
    Return From Keyword If    ${num} > 10
    FOR    ${i}    IN RANGE    ${num}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2 times    5s    Scroll Element Into View    //*[@id='CompleteTab']//following::*[text()='${template}' and @onclick ][1]
        IF    ${check} == ${True}
            Execute Javascript    window.scrollBy(0,10)
            Click Element    //*[@id='CompleteTab']//following::*[text()='${template}' and @onclick ][1]
            Wait Until Keyword Succeeds    5 times    3s    PaperworkDocuments.Click Delete
            Handle Alert
            Wait Until Element Is Not Visible    id=ModalPopup    60s
            BREAK
        END
        Click Next Page Navigation
        Sleep    1s
    END
    Return From Keyword If    ${check} == ${False}
    FOR    ${j}    IN RANGE    ${num}
        FOR    ${k}    IN RANGE    ${i}
            Click Next Page Navigation
            Sleep    1s
        END
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2 times    5s    Scroll Element Into View    //*[@id='CompleteTab']//following::*[text()='${template}' and @onclick ][1]
        IF    ${check} == ${True}
            Execute Javascript    window.scrollBy(0,10)
            Click Element    //*[@id='CompleteTab']//following::*[text()='${template}' and @onclick ][1]
            Wait Until Keyword Succeeds    5 times    3s    PaperworkDocuments.Click Delete
            Handle Alert
            Wait Until Element Is Not Visible    id=ModalPopup    60s
        ELSE
            BREAK
        END
    END

Search To Assign Template In Pages
    [Arguments]    ${template}
    ${num}    Get Text    //table/following::*[@href and text()='Next']/preceding-sibling::*[contains(@href,'page')][1]
    ${num}    Evaluate    ${num}
    FOR    ${i}    IN RANGE    ${num}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2 times    5s    Scroll Element Into View    //*[@id='CompleteTab']//following::*[text()='${template}' and @onclick ][1]
        IF    ${check} == ${True}
            Execute Javascript    window.scrollBy(0,10)
            BREAK
        END
        Click Next Page Navigation
        Sleep    1s
    END

Click Next Page Navigation
    Util.Scroll To Bottom
    Click Element    //table/following::*[@href and text()='Next']