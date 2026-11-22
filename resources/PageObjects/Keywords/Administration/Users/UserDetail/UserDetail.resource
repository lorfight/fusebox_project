*** Settings ***
Resource    ../Common/UserCommon.resource


*** Keywords ***
Go To User UserDetail
    Click Element    link:Administration
    Click Element    link:My Login

Save Button
    Util.Scroll Into View    locator="//*[@id='SaveButton']"    inline=end
    Click Button    Save

Select RoleId
    Select From List By Value    id=RoleId    1

Input UserName
    [Arguments]    ${user_name}
    Waiting For Loading
    Click Element    //input[@id="UserName"]
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

Input Email
    [Arguments]    ${email}
    Input Text    id=Email    ${email}
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

Click Delete User
    Util.Scroll To Bottom
    Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[contains(@onclick,'Delete')]