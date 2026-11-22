*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot


*** Keywords ***
Go To User List
    Click Element    link: Administration
    Click Element    link: Users

New User
    Wait Until Element Is Enabled    link: New User    timeout=10s
    Click Element    link: New User 
    Title Should Be    New User

Viewing Account
    [Arguments]    ${viewing_account}
    Select From List By Label   id=_MyAccountLoader    ${viewing_account}

Edit User
    [Arguments]    ${user_name}
    Click Element    //*[text()='${user_name}']
    Title Should Be    Edit User

Find User
    [Arguments]    ${user_name}=""    ${view_inactive}=${False}    ${role_filter}="-- All Roles --"
    Wait Until Element Is Enabled    id=UserSearchValues    timeout=10s
    IF    ${view_inactive} == ${True}
        Select Checkbox    id=ViewInactiveUsers
    ELSE IF   ${view_inactive} == ${False}
        Unselect Checkbox    id=ViewInactiveUsers
    END
    Input Text    id=UserSearchValues    ${user_name}
    Select From List By Label    id=UserRole    ${role_filter}
    Click Button    Find
    Wait Until Page Contains Element    //div[@class="ajax-loader"]
    Wait Until Page Does Not Contain Element    //div[@class="ajax-loader"]