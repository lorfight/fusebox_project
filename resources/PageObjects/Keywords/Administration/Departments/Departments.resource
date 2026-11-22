*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Department Management
    Click Element    link: Administration
    Click Element    link: Departments

Accept Modal
    Scroll Element Into View    id=AcceptBtn
    Wait Until Keyword Succeeds    10 times    3s    Click Button    Accept

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Filter Department
    [Arguments]    ${dept}
    Select From List By Label    id=AccountDepartmentID    ${dept}

Create Department
    [Arguments]    ${name}    ${short}    ${desc}    ${is_orgn}
    Open Create Department Modal
    Wait Until Element Is Visible    id=ModalPopup    30s
    Input Department Name    ${name}
    Input Department Short Name    ${short}
    Input Department Description    ${desc}
    IF    ${is_orgn} == ${True}
        Select Orgnization
        Checkbox Should Be Selected    id=MultiAccount
    ELSE
        Select Managerial
        Checkbox Should Be Selected    id=Managerial
    END
    Accept Modal

Open Create Department Modal
    Click Element    link: Create Department

Input Department Name
    [Arguments]    ${name}
    Input Text    id=Name    ${name}    clear=True
    Execute JavaScript    document.activeElement.blur()

Input Department Short Name
    [Arguments]    ${name}
    Input Text    id=ShortName    ${name}    clear=True
    Execute JavaScript    document.activeElement.blur()

Input Department Description
    [Arguments]    ${desc}
    Input Text    id=Description    ${desc}    clear=True
    Execute JavaScript    document.activeElement.blur()

Select Managerial
    Select Checkbox    id=Managerial

Select Orgnization
    Select Checkbox    id=MultiAccount

Delete Department
    Click Delete Department
    Handle Alert    timeout=30s
    Wait Until Page Contains    Department has been deleted Sucessfully    15s

Click Delete Department
    Click Element    link: Delete Department

Assign Department
    [Arguments]    ${user}
    ${xpath}    Set Variable    //*[@id='UserSearch']//*[contains(text(),'(${user})')]/following::*[@class='Assign'][1]
    Scroll Element Into View    ${xpath}
    Execute Javascript    window.scrollBy(0,30)
    Select Checkbox    ${xpath}

Unassign Department
    [Arguments]    ${user}
    ${xpath}    Set Variable    //*[@id='UserSearch']//*[contains(text(),'(${user})')]/following::*[@class='Assign'][1]
    Scroll Element Into View    ${xpath}
    Unselect Checkbox    ${xpath}

Open Edit Department Modal
    Click Element    link: Edit Department

Search User In Navigation Pages
    [Arguments]    ${user}
    ${check}    Run Keyword And Return Status    Page Should Contain Element    //table/following::*[@href and text()='Next']/preceding-sibling::*[contains(@href,'page')][1]
    Return From Keyword If    ${check} == ${False}
    ${num}    Get Text    //table/following::*[@href and text()='Next']/preceding-sibling::*[contains(@href,'page')][1]
    ${num}    Evaluate    ${num}
    FOR    ${i}    IN RANGE    ${num-1}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2 times    5s    Scroll Element Into View    //*[@id='UserSearch']//*[contains(text(),'(${user})')]/following::*[@class='Assign'][1]
        IF    ${check} == ${True}
            BREAK
        END
        Util.Scroll To Bottom
        Sleep    3s
        Click Element    //table/following::*[@href and text()='Next']
    END