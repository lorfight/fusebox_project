*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Paperwork Documents
    Click Element    link:Administration
    Click Element    link:Paperwork & Documents

Accept Modal
    Scroll Element Into View    //*[@id='SaveBtn' and text()="Accept"]
    Click Button    //*[@id='SaveBtn' and text()="Accept"]

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Click Update
    Scroll Element Into View    //*[@id='SaveBtn' and text()="Update"]
    Click Button    //*[@id='SaveBtn' and text()="Update"]

Click Delete
    Scroll Element Into View    //*[@id='DeleteBtn']
    Click Button    //*[@id='DeleteBtn']

Click Paperwork Assign
    Click Element    link:Paperwork Assign

Click New Paperwork Template
    Click Element    link:New Paperwork Template

Input Paperwork Name
    [Arguments]    ${name}
    Input Text    id=FileName    ${name}
    Execute JavaScript    document.activeElement.blur()

Input Paperwork Description
    [Arguments]    ${desc}
    Input Text    id=FileDescription    ${desc}
    Execute JavaScript    document.activeElement.blur()

Select Importance
    [Arguments]    ${imp}
    Select From List By Label    id=AssignedImportance    ${imp}

Select Class Trade
    [Arguments]    ${trade}
    Select From List By Label    id=AssignedClassOfTrade    ${trade}

Select Association
    [Arguments]    ${assoc}
    Select From List By Label    id=AssignedAssociation    ${assoc}

Input Interval
    [Arguments]    ${inter}
    Input Text    id=FollowupInterval    ${inter}
    Execute JavaScript    document.activeElement.blur()

Input Window
    [Arguments]    ${win}
    Input Text    id=CompletionWindow    ${win}
    Execute JavaScript    document.activeElement.blur()

Click Assign Template
    [Arguments]    ${template}
    Scroll Element Into View    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Assign Template')][1]
    Execute Javascript    window.scrollBy(0,10)
    Click Element    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Assign Template')][1]

Input Search Account 
    [Arguments]    ${acc}
    Input Text    id=AccountSearchValues    ${acc}
    Execute JavaScript    document.activeElement.blur()

Click Clear
    Click Button    Clear

Click Find
    Click Button    Find

Select User To Assign
    [Arguments]    ${user}
    Select From List By Label    id=User    ${user}

Select Assigned User
    [Arguments]    ${user}
    Select From List By Label    id=UserSelect_1    ${user}

Select To Assign Paperwork
    [Arguments]    ${acc}
    Select Checkbox    //*[@id='AccountList']//*[@type='checkbox' and following::*[contains(text(),'${acc}')][1]]

Click Map Template
    [Arguments]    ${template}
    Scroll Element Into View    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Map Template')][1]
    Click Element    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Map Template')][1]

Click Edit Template
    [Arguments]    ${template}
    Scroll Element Into View    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Ediy Template')][1]
    Click Element    //*[@onclick and text()='${template}']/following::*[@onclick and contains(text(),'Edit Template')][1]
