*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyLogin/MyLogin.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyLogin/ChangePassword/ChangePassword.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Library    FakerLibrary
Test Tags    ClinicSmokeLogImp    test:retry(3)    USER_01

*** Test Cases ***
Verify Update User In My Login Menu
    [Documentation]    USER_1: Edit User
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    UserDetail.Go To User UserDetail
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Edit User
    UserDetail.Input FirstName    first_name=${first_name}updated
    UserDetail.Input LastName    last_name=${last_name}updated
    Select Default Location    location=QCA1
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Demographics    60s
    Verify Update User Succeeds
    Wait Until Keyword Succeeds    10 times    3s    Click Element    id=UserName
    IF    "${Userrole}" == "Impersonate"
        UserDetail.Input UserName    user_name=${TargetUsername}
    ELSE
        UserDetail.Input UserName    user_name=${Username}
    END
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Demographics    60s

Verify Apply Role Preset Permission
    [Documentation]    USER_4: Apply Role Preset Permssion    USER_12: Apply Role Preset Permssion
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    UserDetail.Go To User UserDetail
    MyLogin.Open Permissions Tab
    ${is_preset}    Run Keyword And Return Status    Wait Until Element Is Visible    id=PresetPermissionPanel
    IF    ${is_preset} == ${False}
        Sleep    3s
        Permission.Open Preset Panel
        Wait Until Element Is Visible    id=PresetPermissionPanel    60s
    END
    ${check_before_1}    Wait Until Keyword Succeeds    10 times    3s    Select Or Unselect Preset Permission    Can Re-submit DFT Files for appointments to bill.
    ${check_before_2}    Wait Until Keyword Succeeds    10 times    3s    Select Or Unselect Preset Permission    Can debug appointment HL7 Messages.
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Perimssions    60s
    UserDetail.Go To User UserDetail
    MyLogin.Open Permissions Tab
    ${is_preset}    Run Keyword And Return Status    Wait Until Element Is Visible    id=PresetPermissionPanel
    IF    ${is_preset} == ${False}
        Permission.Open Preset Panel
        Wait Until Element Is Visible    id=PresetPermissionPanel    60s
    END
    Wait Until Keyword Succeeds    10 times    3s    Verify Permission Checked Or Unchecked    Can Re-submit DFT Files for appointments to bill.    ${check_before_1}    Preset
    Wait Until Keyword Succeeds    10 times    3s    Verify Permission Checked Or Unchecked    Can debug appointment HL7 Messages.    ${check_before_2}    Preset
    Select Or Unselect Preset Permission    Can Re-submit DFT Files for appointments to bill.
    Select Or Unselect Preset Permission    Can debug appointment HL7 Messages.
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Permissions    60s

Verify Update PIN
    [Documentation]    USER_9: Update PIN
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    ${pin}    Set Variable    11111
    ${pin_update}    Set Variable    22222
    Users.Go To User List
    IF    "${Userrole}" == "Impersonate"
        Users.Find User    user_name=${TargetUsername}
        Users.Edit User    user_name=${TargetUsername}
    ELSE
        Users.Find User    user_name=${Username}
        Users.Edit User    user_name=${Username}
    END
    Util.Scroll To Bottom
    Wait Until Keyword Succeeds    5 times    3s    UserInformation.Click To Open Setup PIN
    ${is_new}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[contains(text(),'Please enter a pin you would like to use for your user')]
    ${is_old}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id='ModalPopup']//*[contains(text(),'Please Enter your Pin to Access this Area')]
    IF    ${is_new} == ${True}
        UserInformation.Input PIN    ${pin}
        UserInformation.Click Update PIN
        Wait For Page Loading    Multi-Factor Authentication Activated    Element Should Be Visible    Wait Until Element Is Not Visible    60s
        Wait Until Element Is Not Visible    //*[@id='ModalPopup']    60s
        UserInformation.Click To Open Setup PIN
        Wait Until Keyword Succeeds    5 times    3s    Update PIN    old_pin=${pin}    new_pin=${pin_update}
    ELSE IF    ${is_old} == ${True}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    Update PIN    old_pin=${pin}    new_pin=${pin_update}
        Run Keyword If    ${check} == ${False}    Update PIN    old_pin=${pin_update}    new_pin=${pin}
    END
    Wait Until Keyword Succeeds    5 times    3s    UserInformation.Click To Open Setup PIN
    Wait Until Keyword Succeeds    5 times    3s    UserInformation.Input PIN    ${pin_update}
    Sleep    2s
    UserInformation.Click Enter PIN
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    Remove PIN
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    5 times    3s    UserInformation.Input PIN    ${pin}
        Sleep    2s
        UserInformation.Click Enter PIN
        Remove PIN
    END

*** Keywords ***
Suite Setup Keyword
    [Documentation]    Suite Setup
    [Tags]    Setup
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    LoginKeywords.Check Newsletter

Test Setup Keyword
    ${check}    Run Keyword And Return Status    Switch To Another Window    Home
    Return From Keyword If    ${check} == ${True}
    Open New Window    ${SiteUrl}
    Close Window
    Wait Until Keyword Succeeds    20 times    3s    Switch To Another Window    Home

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
    Set Suite Variable    ${first_name}    testfirst3
    Set Suite Variable    ${last_name}    testlast3
    Set Suite Variable    ${import_file_name}    UserImportTemplate.xlsx

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
    [Arguments]    ${pwd}
    Util.Scroll To Bottom
    UserInformation.Go To Reset Password Page
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Reset Password
    UserInformation.Input New Password    ${pwd}
    UserDetail.Input Confirm Password    ${pwd}
    UserInformation.Click Set Password
    Handle Alert
    Wait Until Page Does Not Contain    User Demographics    60s

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
