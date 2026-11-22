*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot

*** Keywords ***
Select Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Keyword Succeeds    5 times    3s    Select Checkbox    ${permis_checkbx}

Unselect Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Keyword Succeeds    5 times    3s    Select Checkbox    ${permis_checkbx}

Open Preset Panel
    Click Element    //*[contains(@onclick,'TogglePermissionPreset')]

Select Preset Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PresetPermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Keyword Succeeds    5 times    3s    Select Checkbox    ${permis_checkbx}

Unselect Preset Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PresetPermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Keyword Succeeds    5 times    3s    Unselect Checkbox    ${permis_checkbx}