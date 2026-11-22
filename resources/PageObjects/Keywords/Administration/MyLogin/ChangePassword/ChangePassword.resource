*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../../libraries/Util.resource

*** Keywords ***
Input Old Password
    [Arguments]    ${pwd}
    SeleniumLibrary.Input Text    id=OldPassword    ${pwd}
    Execute JavaScript    document.activeElement.blur()

Input New Password
    [Arguments]    ${pwd}
    SeleniumLibrary.Input Text    id=NewPassword    ${pwd}
    Execute JavaScript    document.activeElement.blur()

Confirm Password
    [Arguments]    ${pwd}
    SeleniumLibrary.Input Text    id=ConfirmPassword    ${pwd}
    Execute JavaScript    document.activeElement.blur()

Click To Change Password
    Util.Scroll To Bottom
    Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[@value='Change password']