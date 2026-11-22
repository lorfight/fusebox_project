*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Associations
    Click Element    link:Administration
    Click Element    link:Associations

Accept Modal
    Scroll Element Into View    id=AcceptBtn
    Wait Until Keyword Succeeds    10 times    3s    Click Button    Accept

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Select Association
    [Arguments]    ${assoc}
    Select From List By Label    id=AssociationID    ${assoc}

Click Create Assocation
    Click Element    link:Create Assocation

Input Association Name
    [Arguments]    ${name}
    Input Text    id=Name    ${name}
    Execute JavaScript    document.activeElement.blur()

Click Clear Tag
    Scroll Element Into View    //*[@onclick and text()='Clear']
    Click Button    //*[@onclick and text()='Clear']

Input Association Tag
    [Arguments]    ${tag}
    Input Text    id=AssociationTagAutocomplete    ${tag}
    Execute JavaScript    document.activeElement.blur()

Click Tag Suggestion
    [Arguments]    ${tag}
    Click Element    //*[contains(@class,'suggestion') and *[text()='${tag}']]

Click Assign
    Click Button    Assign

Click Remove
    Click Element    link:Remove

Input Description
    [Arguments]    ${text}
    Input Text    id=Description    ${text}
    Execute JavaScript    document.activeElement.blur()

Click Edit Association
    Click Element    link:Edit Assocation

Input Account Search
    [Arguments]    ${acc}
    Input Text    id=SearchValues    ${acc}
    Execute JavaScript    document.activeElement.blur()

Click Find
    Click Button    Find

Click Clear Account
    Click Button    id=ClearButton

Assign Account
    [Arguments]    ${acc}
    Scroll Element Into View    //*[@id='AccountSearch']//*[contains(text(),'\(${acc})')]/following::*[@type='checkbox'][1]
    Select Checkbox    //*[@id='AccountSearch']//*[contains(text(),'${acc}')]/following::*[@type='checkbox'][1]

Unassign Account
    [Arguments]    ${acc}
    Scroll Element Into View    //*[@id='CurrentlyAssociated']//*[contains(text(),'\(${acc})')]/following::*[@type='checkbox'][1]
    Unselect Checkbox    //*[@id='CurrentlyAssociated']//*[contains(text(),'${acc}')]/following::*[@type='checkbox'][1]

Click Delete Association
    Click Element    link:Delete Assocation

Click View Changes
    Click Element    link:View Changes