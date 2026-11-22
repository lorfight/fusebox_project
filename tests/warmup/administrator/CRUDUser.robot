*** Settings ***
Library  DependencyLibrary
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/UserList.resource
Resource    ../../../resources/PageObjects/Keywords/UserDetail.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Suite Set Up
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session

*** Test Cases ***
Create User
    [Documentation]    AD_001: Create User
    [Tags]        Regression    Administrator    User
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Administrator
    ...  report.label.feature:User Management
    ...  report.label.story:Create User
    Create User    user_name=${user_name}    first_name=${first_name}    last_name=${last_name}    pwd=${pwd}    confirm_pwd=${pwd}
    Verify Create User Succeeds
    # [Teardown]    Run Keyword If Test Passed    Insert User To Worksheet    ${env}    ${user_name}    ${pwd}

Update User
    [Documentation]    AD_002: Update User
    [Tags]        Regression    Administrator    User
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Administrator
    ...  report.label.feature:User Management
    ...  report.label.story:Update User
    Depends On Test    Create User
    Update User
    Verify Update User Succeeds    ${user_name}
    # [Teardown]    Run Keyword If Test Passed    Update User To Worksheet    query=${user_name}    user_name=${user_name_updated}    pwd=${pwd}    inactive=False
Inactive User
    [Documentation]    AD_003: Inactive User
    [Tags]        Regression    Administrator    User
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Administrator
    ...  report.label.feature:User Management
    ...  report.label.story:Inactive User
    Depends On Test    Update User
    Inactive User
    Verify Update User Succeeds    ${user_name}    ${inactive}
    # [Teardown]    Run Keyword If Test Passed    Update User To Worksheet    query=${user_name_updated}    user_name=${user_name_updated}    pwd=${pwd}    inactive=True


*** Keywords ***
# Write User To Worksheet
#     [Arguments]    ${user_name}    ${pwd}    ${inactive}
#     ${data}    Create List    ${user_name}    ${pwd}    ${inactive}
#     Insert User To Worksheet    env=${env}    data=${data}
# Update User To Worksheet
#     [Arguments]    ${query}    ${user_name}    ${pwd}    ${inactive}
#     ${data}    Create List    ${user_name}    ${pwd}    ${inactive}
#     Update User Worksheet    env=${env}    query=${query}    data=${data}

Verify Create User Succeeds
    Title Should Be    Users
    UserList.Find User    user_name=${user_name}

Verify Update User Succeeds
    [Arguments]    ${user_name}    ${inactive}=${False}
    UserList.Find User    user_name=${user_name_updated}
    Click Element    //*[contains(text(),"${last_name_updated}, ${first_name_updated}")]
    ${last_name_actual}    Get Value    id=LastName
    Should Be Equal    ${last_name_updated}    ${last_name_actual}
    ${first_name_actual}    Get Value    id=FirstName
    Should Be Equal    ${first_name_updated}    ${first_name_actual}
    ${user_name_actual}    Get Value    id=UserName
    Should Be Equal    ${user_name_updated}    ${user_name_actual}
    ${inactive_actual}    Get Element Attribute    id=Inactive    checked
    ${inactive_actual}    Run Keyword And Return Status    Should Be Equal    ${inactive_actual}    true
    Should Be Equal    ${inactive_actual}    ${inactive}

Suite Set up
    ${data_input}    Get Data
    Login To Fusebox    ${Username}    ${Password}
    ${date}    CommonKeywords.Get Current Date Time    format=%m%d%H%M
    Set Suite Variable    ${user_name}    automation.${data_input}[env]${date}
    ${first_name}    Evaluate       """${data_input}[env]""".title()
    set Suite variable    ${first_name}
    set Suite variable    ${last_name}    Automation Test
    set Suite variable    ${pwd}    1qazZAQ!
    set Suite variable    ${inactive}    False
    UserList.Go To Create User

Create User
    [Arguments]    ${user_name}    ${first_name}    ${last_name}    ${pwd}    ${confirm_pwd}
    UserList.New User
    UserDetail.Input UserName    ${user_name}
    UserDetail.Input LastName    ${last_name}
    UserDetail.Input FirstName    ${first_name}
    UserDetail.Input Password    ${pwd}
    UserDetail.Input Confirm Password    ${confirm_pwd}
    UserDetail.Select RoleId
    UserDetail.Save Button

Update User
    UserList.Go To Create User
    UserList.Find User    user_name=${user_name}
    Wait Until Keyword Succeeds    3times    1    Click Element    //*[contains(text(),"${last_name}, ${first_name}")]
    Title Should Be    Edit User
    Set Suite Variable    ${last_name_updated}    ${last_name}_updated
    Set Suite Variable    ${first_name_updated}    ${first_name}_updated
    Set Suite Variable    ${user_name_updated}    ${user_name}.updated
    UserDetail.Input LastName    ${last_name_updated}
    UserDetail.Input FirstName    ${first_name_updated}
    UserDetail.Input UserName    ${user_name_updated}
    Select From List By Label    DefaultLocation    QCA1
    UserDetail.Save Button

Inactive User
    UserList.Go To Create User
    UserList.Find User    user_name=${user_name}
    Wait Until Keyword Succeeds    3times    1    Click Element    //*[contains(text(),"${last_name_updated}, ${first_name_updated}")]
    Title Should Be    Edit User
    Checkbox Inactive
    UserDetail.Save Button
    Set Test Variable    $inactive    ${True}