*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Select Default Location
    [Arguments]    ${location}
    Select From List By Label    DefaultLocation    ${location}

Click To Open Setup PIN
    Scroll Element Into View    //*[contains(@onclick,'SetupUserPin')]
    Sleep    1s
    Click Element    //*[contains(@onclick,'SetupUserPin')]

Input PIN
    [Arguments]    ${pin}
    Input Text    id=EnteredPin    ${pin}
    Execute JavaScript    document.activeElement.blur()

Click Update PIN
    Click Button    Update

Click Enter PIN
    Click Button    Enter

Click Change PIN
    Click Element    id=ChangePinButton

Input Update PIN
    [Arguments]    ${pin}
    Input Text    id=UpdatePin    ${pin}
    Execute JavaScript    document.activeElement.blur()

Click Remove PIN
    Click Element    id=RemovePinButton

Go To Reset Password Page
    Click Element    //*[@href and text()='Reset Password']    

Click Delete
    Click Element    //*[contains(@onclick,'Delete')]

Input New Password
    [Arguments]    ${pwd}
    Input Text    id=NewPassword    ${pwd}

Click Set Password
    Click Element    //*[@value='Set Password']