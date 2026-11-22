*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../libraries/Util.resource


*** Keywords ***

Save Button
    Util.Scroll Into View    locator="//*[@id='SaveButton']"    inline=end
    Click Button    Save

Select RoleId
    Select From List By Value    id=RoleId    1

Input UserName
    [Arguments]    ${user_name}
    Input Text    id=UserName    ${user_name}

Input FirstName
    [Arguments]    ${first_name}
    Input Text    id=FirstName    ${first_name}

Input LastName
    [Arguments]    ${last_name}
    Input Text    id=LastName    ${last_name}

Input Password
    [Arguments]    ${pwd}
    Input Text    id=Password    ${pwd}

Input Confirm Password
    [Arguments]    ${confirm_pwd}
    Input Text    id=ConfirmPassword    ${confirm_pwd}

Checkbox Inactive
    Wait Until Element Is Enabled    //input[@id="Inactive"]
    Select Checkbox    //input[@id="Inactive"]

Switch Tab
    [Arguments]    ${tab_name}
    Click Element    //a[@id="${tab_name}"]
    Wait Until Page Contains Element    //a[@id="${tab_name}" and contains(@aria-expanded,"true")]

Assigned Permission
    [Arguments]    ${permission}
    Util.Scroll Into View    locator="//*[contains(text(),'${permission}')]//parent::tr//input"    inline=end

    Select Checkbox    //*[contains(text(),"${permission}")]//parent::tr//input

Unassigned Permission
    [Arguments]    ${permission}
    Util.Scroll Into View    locator="//*[contains(text(),'${permission}')]//parent::tr//input"    inline=end
    Unselect Checkbox    //*[contains(text(),"${permission}")]//parent::tr//input