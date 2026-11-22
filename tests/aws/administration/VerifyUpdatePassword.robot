*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyLogin/MyLogin.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyLogin/ChangePassword/ChangePassword.resource
Suite Setup    Suite Setup Keyword
Library    FakerLibrary
Test Tags    ClinicSmokePas    test:retry(3)    USER_02

*** Test Cases ***
Verify Reset Password
    [Documentation]    USER_2: Reset Password    USER_10: Reset Password
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    UserDetail.Go To User UserDetail
    IF    ${check} == ${False}
        Open New Window    ${SiteUrl}
        Close Window
        Wait Until Keyword Succeeds    5 times    2s    Switch Window    MAIN
        ${is_back_link}    Run Keyword And Return Status    Wait Until Page Contains Element    //*[@href and contains(@class,'cancel')]    10s
        IF    ${is_back_link} == ${True}
            Scroll Element Into View    //*[@href and contains(@class,'cancel')]
            Execute Javascript    window.scrollBy(0,30)
            Click Element    //*[@href and contains(@class,'cancel')]
        END
        Wait Until Page Contains Element    //*[@name="identifier"]    60s
        Input Text    //*[@name="identifier"]    ${username}
        Wait Until Page Contains Element    css:[type="submit"]
        IF    "${mode}" != "headless"
                Util.Scroll To Bottom
        END
        Click Button    css:[type="submit"]
        ${OTP}    OtpLibrary.Generate Otp    ${secret_key}
        Wait Until Page Contains Element    //*[@name="credentials.passcode"]
        Input Text    //*[@name="credentials.passcode"]    text=${OTP}
        Click Button    css:[type="submit"]
        Wait Until Page Contains Element    css:[type="password"]
        Input Text    css:[type="password"]    ${password}
        Click Button    css:[type="submit"]
        Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home
        LoginKeywords.Check Newsletter
        UserDetail.Go To User UserDetail
    END
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Edit User
    ${pwd_new}    Reset Password
    Wait Until Page Contains Element    //*[@name="identifier"]    60s
    Input Text    //*[@name="identifier"]    ${username}
    Wait Until Page Contains Element    css:[type="submit"]
    Execute Javascript    window.scrollBy(0,60)
    Click Button    css:[type="submit"]
    ${check}    Run Keyword And Return Status    Wait Until Page Contains Element    //*[@data-se="google_otp"]/a    10s
    IF    ${check} == ${False}
        Scroll Element Into View    link: Verify with something else
        Execute Javascript    window.scrollBy(0,20)
        Wait Until Keyword Succeeds    5 times    3s    Click Element    //*[@href and contains(@class,'switch')]
        Scroll Element Into View    link: Back to sign in
        Execute Javascript    window.scrollBy(0,20)
        Wait Until Keyword Succeeds    5 times    3s    Click Element    //*[@href and contains(@class,'cancel')]
    END
    Login Okta    username=${Username}    password=${pwd_new}

*** Keywords ***
Suite Setup Keyword
    [Documentation]    Suite Setup
    [Tags]    Setup
    Setup Data
    Set Global Variable    ${SiteUrl}    ${SiteUrl}/Ciam/Login
    Open Browser To Login Page
    ${check}    Run Keyword And Return Status    Login Okta    ${user_name}    ${password}
    IF    ${check} == ${False}
        ${num}    Get Length    ${pwd_set}
        FOR    ${i}    IN RANGE    ${num}
            Input Text    css:[type="password"]    ${pwd_set}[${i}]    clear=True
            Sleep    3s
            IF    "${mode}" != "headless"
                Util.Scroll To Bottom
            END
            Click Button    css:[type="submit"]
            ${check_signin}    Run Keyword And Return Status    Wait Until Page Does Not Contain Element   //*[contains(@class,'infobox') and @role='alert']    10s
            IF    ${check_signin} == ${True}
                Set Suite Variable    ${password}    ${pwd_set}[${i}]
                BREAK
            END
        END
    END
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    LoginKeywords.Check Newsletter

Open New Window
    [Arguments]    ${url}
    Execute Javascript    window.open('${url}','_blank')
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Set Window Size    1920    1080
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title}
    Switch Window    ${title}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    ${title}
    Wait Until Keyword Succeeds    10 times    3s    LoginKeywords.Check Newsletter
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

Setup Data
    ${data_input}    CommonKeywords.Get Data
    Set Suite Variable    ${mode}    headless
    Set Suite Variable    ${location_id}    ${data_input}[location_id]
    Set Suite Variable    ${email}    ${data_input}[location_id]
    Set Suite Variable    ${pwd_set}    ${data_input}[pwd_set]
    ${pwd_set}    Evaluate    ${pwd_set}
    Set Suite Variable    ${pwd_set}
    Set Suite Variable    ${first_name}    firstname2
    Set Suite Variable    ${last_name}    lastname2

Click User To Go Edit User Page
    [Arguments]    ${user}
    Scroll Element Into View    //*[text()='${user}']/preceding::*[@href][1]/following::*[@href][1]
    Click Element    //*[text()='${user}']/preceding::*[@href][1]

Verify Update User Succeeds
    UserDetail.Go To User UserDetail
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Edit User
    ${last_name_actual}    Get Value    id=LastName
    Should Be Equal    ${last_name}updated    ${last_name_actual}
    ${first_name_actual}    Get Value    id=FirstName
    Should Be Equal    ${first_name}updated    ${first_name_actual}
    Checkbox Should Not Be Selected    id=Inactive

Reset Password
    Util.Scroll To Bottom
    UserInformation.Go To Reset Password Page
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Reset Password
    ${num}    Get Length    ${pwd_set}
    FOR    ${i}    IN RANGE    ${num}
        ${pwd}    Set Variable    ${pwd_set}[${i}]
        Wait Until Keyword Succeeds    5 times    3s    UserInformation.Input New Password    ${pwd}
        Wait Until Keyword Succeeds    5 times    3s    UserDetail.Input Confirm Password    ${pwd}
        UserInformation.Click Set Password
        Handle Alert
        ${check}    Run Keyword And Return Status    Wait Until Page Contains Element    //*[contains(@class,'validation') and contains(@class,'errors')]    10s
        IF    ${check} == ${False}
            BREAK
        ELSE
            IF    ${i} == 0
                ${is_set_before}    Run Keyword And Return Status    Page Should Contain    You must wait 24 hours before changing your password again
                IF    ${is_set_before} == ${True}
                    Pass Execution    Password set before
                END
            END
        END
    END
    IF    ${i} == ${num-1} and ${check} == ${True}
        Pass Execution    Password set currently
    END
    Should Be True    ${check} == ${False}
    RETURN    ${pwd}

Select RoleId
    [Arguments]    ${role}
    Select From List By Label    id=RoleId    ${role}

Select Or Unselect Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Element Is Visible    ${permis_checkbx}    60s
    ${is_checked_before}    Run Keyword And Return Status    Checkbox Should Be Selected    ${permis_checkbx}
    IF    ${is_checked_before} == ${True}
        Permission.Unselect Permission    permis=${permis}
        Util.Wait For Page Loading    Permission Successfully Removed    Wait Until Element Is Visible    Wait Until Element Is Not Visible    60s
        Wait Until Keyword Succeeds    10 times    3s    Checkbox Should Not Be Selected    ${permis_checkbx}
    ELSE
        Permission.Select Permission    permis=${permis}
        Util.Wait For Page Loading    Permission Successfully Added    Wait Until Element Is Visible    Wait Until Element Is Not Visible    60s
        Wait Until Keyword Succeeds    10 times    3s    Checkbox Should Be Selected    ${permis_checkbx}
    END
    RETURN    ${is_checked_before}

Select Or Unselect Preset Permission
    [Arguments]    ${permis}
    ${permis_checkbx}    Set Variable    //*[@id='PresetPermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Element Is Visible    ${permis_checkbx}    60s
    ${is_checked_before}    Run Keyword And Return Status    Checkbox Should Be Selected    ${permis_checkbx}
    IF    ${is_checked_before} == ${True}
        Permission.Unselect Preset Permission    permis=${permis}
        Util.Wait For Page Loading    Permission Successfully Removed    Wait Until Element Is Visible    Wait Until Element Is Not Visible    60s
        Wait Until Keyword Succeeds    10 times    3s    Checkbox Should Not Be Selected    ${permis_checkbx}
    ELSE
        Permission.Select Preset Permission    permis=${permis}
        Util.Wait For Page Loading    Permission Successfully Added    Wait Until Element Is Visible    Wait Until Element Is Not Visible    60s
        Wait Until Keyword Succeeds    10 times    3s    Checkbox Should Be Selected    ${permis_checkbx}
    END
    RETURN    ${is_checked_before}

Verify Permission Checked Or Unchecked
    [Arguments]    ${permis}    ${is_checked_before}    ${is_preset}
    ${permis_checkbx}    Set Variable    //*[@id='${is_preset}PermissionPanel']//*[contains(text(),'${permis}')]/preceding::*[@type='checkbox'][1]
    Scroll Element Into View    ${permis_checkbx}/following::input[1]
    Wait Until Element Is Visible    ${permis_checkbx}    60s
    IF    ${is_checked_before} == ${True}
        Checkbox Should Not Be Selected    ${permis_checkbx}
    ELSE
        Checkbox Should Be Selected    ${permis_checkbx}
    END

Go To Manage Page
    Click Element    link:Administration
    Click Element    link:Change Password

Update PIN
    [Arguments]    ${old_pin}    ${new_pin}
    UserInformation.Input PIN    ${old_pin}
    Sleep    2s
    UserInformation.Click Enter PIN
    Wait Until Keyword Succeeds    10 times    3s    UserInformation.Click Change PIN
    Wait Until Keyword Succeeds    10 times    3s    UserInformation.Input Update PIN    ${new_pin}
    UserInformation.Click Update PIN
    Wait For Page Loading    User pin updated    Page Should Contain    Wait Until Page Contains    60s
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    60s

Remove PIN
    UserInformation.Click Remove PIN
    Handle Alert
    Util.Wait For Page Loading    User pin removed    Page Should Contain    Wait Until Page Does Not Contain    60s
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    60s