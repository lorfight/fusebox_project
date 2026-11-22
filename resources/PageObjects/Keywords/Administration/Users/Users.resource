*** Settings ***
Resource    ./UserDetail/UserDetail.resource

*** Keywords ***
Go To User List
    Click Element    link: Administration
    Click Element    link: Users
    Common.Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']

New User
    Wait Until Element Is Enabled    link: New User    timeout=10s
    Click Element    link: New User 
    Title Should Be    New User

Viewing Account
    [Arguments]    ${viewing_account}
    Select From List By Label   id=_MyAccountLoader    ${viewing_account}

Edit User
    [Arguments]    ${user_name}
    Click Element    //*[text()="${user_name}"]//preceding::a[1]
    Title Should Be    Edit User
    Waiting For Loading

Find User
    [Arguments]    ${user_name}=""    ${view_inactive}=${False}    ${role_filter}=-- All Roles --
    Wait Until Element Is Enabled    id=UserSearchValues    timeout=10s
    IF    ${view_inactive} == ${True}
        Select Checkbox    id=ViewInactiveUsers
    ELSE IF   ${view_inactive} == ${False}
        Unselect Checkbox    id=ViewInactiveUsers
    END
    Input Text    id=UserSearchValues    ${user_name}
    Select From List By Label    id=UserRole    ${role_filter}
    Click Button    Find
    Waiting For Loading

Go To Edit User Page
    [Arguments]    ${user}
    Scroll Element Into View    //*[text()='${user}']/preceding::*[@href][1]
    Click Element    //*[text()='${user}']/preceding::*[@href][1]

Open Import Modal
    Click Element    //*[contains(@onclick,'ImportUserModal')]

Click To Remove Import File
    Click Element    link: Remove

Download Template
    [Arguments]    ${down_path}
    Click Element    //*[contains(@onclick,'ImportTemplate')]

Upload File
    [Arguments]    ${path}    ${file_name}
    Choose File    id=UploadFile   ${path}
    ${file}    Execute JavaScript    return document.getElementById('UploadFile').files[0].name;
    Should Be Equal    ${file}    ${file_name}

Export Users File
    Click Element    //*[contains(@onclick,'UsersExport')]

Click To Save
    Scroll Element Into View    //*[@id='SaveBtn']
    Click Button    //*[@id='SaveBtn']

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Click Next Page Navigation
    Click Element    //table/following::*[@href and text()='Next']

Check Data Fee Only Mode View Checkbox Status
    [Arguments]    ${status}
    ${datafee_checkbox}    Set Variable    //input[@id="DataFeeOnlyMode"]
    ${checkbox_status}    Run Keyword And Return Status    Checkbox Should Be Selected    ${datafee_checkbox}
    IF    "${checkbox_status}" != "${status}"
        Wait Until Keyword Succeeds    30s    1s    Click Element    //input[@id="DataFeeOnlyMode"]
        Scroll Element Into View    //input[@id="SaveButton"]
        Click Element    //input[@id="SaveButton"]
    END

Select Account In Users Page
    [Arguments]    ${account}
    Wait Until Element Is Enabled    //select[@id="LocationID"]    30s
    Select From List By Label   //select[@id="LocationID"]    ${account}
    Util.Waiting For Loading

