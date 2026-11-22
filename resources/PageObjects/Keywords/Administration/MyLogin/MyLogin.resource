*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource
Resource    UserInformation.resource
Resource    Permission.resource

*** Keywords ***
Open User Information Tab
    Click Element    id=UserInformation

Open Permissions Tab
    Click Element    id=Permission