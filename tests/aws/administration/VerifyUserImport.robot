*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    ClinicSmokeLogImp    test:retry(3)    USER_016
Library    FakerLibrary

*** Test Cases ***
Verify Import User
    [Documentation]    USER_16: Download Template    USER_17: Import User
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Users.Go To User List
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Users
    Sleep    2s
    Users.Find User    user_name=${user_import}
    ${check}    Run Keyword And Return Status   Wait Until Keyword Succeeds    5 times    1s    Users.Go To Edit User Page    user=${user_import}
    IF    ${check} == ${True}    
        UserDetail.Click Delete User
        Handle Alert
        Wait Until Page Does Not Contain    User Demographics    60s
        Users.Go To User List
    END
    Users.Open Import Modal
    Wait Until Element Is Visible    id=ModalPopup    60s
    Run Keyword And Ignore Error    Remove File    path=${file_path}/UserImportTemplate.xlsx
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@class='ImportItem']
    IF    ${check} == ${True}
        Sleep    5s
        Users.Click To Remove Import File
        Util.Wait For Page Loading    Import Row Successfully Removed    Element Should Be Visible    Wait Until Element Is Not Visible    60s
    END
    ${check}    Run Keyword And Return Status    Users.Download Template    down_path=${file_path}
    IF    ${check} == ${False}
        Users.Click To Remove Import File
        Wait Until Keyword Succeeds    10 times    3s    Users.Download Template    down_path=${file_path}
    END
    
    ${path}    Set Import File Path
    Wait Until Keyword Succeeds    10 times    3s   Should Exist    ${path}
    ${data}    CustomLibrary.Read Excel File    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Build Account #\    value=${location_id}    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Username    value=${user_import}    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Email Address    value=test@mail.com    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=First Name    value=testfirst    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Last Name    value=testlast    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=System Role    value=Administrator    path=${path}
    ${data}    CustomLibrary.Edit Excel Field And Save    data=${data}    row=0    field=Clinical Role    value=Unspecified    path=${path}
    Users.Upload File    path=${path}    file_name=UserImportTemplate.xlsx
    Set Test Variable    ${path}
    Sleep    5s
    Wait Until Keyword Succeeds    2 times    5s     Users.Click To Save
    Wait Until Page Contains    File Successfully Imported    60s
    Sleep    5s
    Wait Until Keyword Succeeds    2 times    5s    Users.Click To Save
    ${check}    Run Keyword And Return Status   Handle Alert
    IF    ${check} == ${False}
        Search Navigation Pages To Delete User    user=${user_import}
    END
    Wait Until Page Contains    File Successfully Imported    60s
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    UserDetail.Go To User UserDetail
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Edit User

Verify Export User
    [Documentation]    USER_18: Export User
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Users.Go To User List
    Users.Open Import Modal
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${path_achi}    Set Export Path    timezone=America/Chicago    date_format=%m_%d_%Y
    ${path_asin}    Set Export Path    timezone=Asia/Singapore    date_format=%m_%d_%Y
    Run Keyword And Return Status    Remove File    path=${path_achi}
    Run Keyword And Return Status    Remove File    path=${path_asin}
    Users.Export Users File
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    File Should Exist    ${path_achi}
    IF    ${check} == ${True}
        ${path}    Set Variable    ${path_achi}
    ELSE
        Wait Until Keyword Succeeds    10 times    3s    File Should Exist    ${path_asin}
        ${path}    Set Variable    ${path_asin}
    END
    ${data}    CustomLibrary.Read Excel File    path=${path}
    ${account}    Run Keyword And Ignore Error    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=Build Account #\
    Run Keyword If    "${account}[0]" == "FAIL"    Pass Execution    User deleted
    Should Be Equal As Strings    ${account}[1]    ${location_id}
    ${email}    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=Email
    Should Be Equal    ${email}    test@mail.com
    ${first}    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=First Name
    Should Be Equal    ${first}    testfirst
    ${last}    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=Last Name
    Should Be Equal    ${last}    testlast
    ${cli_role}    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=Clinical Role
    Should Be Equal    ${cli_role}    Unspecified
    ${is_inactive}    CustomLibrary.Get Excel Field    data=${data}    field=Username    field_value=${user_import}    field_reference=Inactive
    Should Be Equal As Strings   ${is_inactive}    FALSE    ignore_case=True

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
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    20 times    3s    Switch To Another Window    Home

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
    Set Suite Variable    ${user_import}    ${data_input}[user_import]

Set Import File Path
    ${path}    Set Variable    ${file_path}/UserImportTemplate.xlsx
    RETURN    ${path}

Search Navigation Pages To Delete User
    [Arguments]    ${user}
    Wait Until Keyword Succeeds    2 times    5s    Users.Close Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    Users.Find User    user_name=${EMPTY}
    Select From List By Label    id=SortBy    Recently Updated
    Wait Until Keyword Succeeds     10 times    3s    List Selection Should Be    id=SortBy    Recently Updated
    Sleep    3s
    Search User In Pages And Click    user=${user}
    ${user}    FakerLibrary.User Name
    ${id}    FakerLibrary.Random Number    digits=5
    UserDetail.Input UserName    user_name=${user}${id}
    UserDetail.Save Button
    Wait Until Page Does Not Contain    User Demographics    60s
    Users.Go To User List
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Users
    Search User In Pages And Click    user=${user}${id}
    UserDetail.Click Delete User
    Handle Alert
    Wait Until Page Does Not Contain    User Demographics    60s
    Users.Go To User List
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Users
    Users.Open Import Modal
    Users.Upload File    path=${path}    file_name=UserImportTemplate.xlsx
    Wait Until Keyword Succeeds    2 times    5s     Users.Click To Save
    Wait Until Page Contains    File Successfully Imported    60s
    Wait Until Keyword Succeeds    2 times    5s    Users.Click To Save
    Wait Until Keyword Succeeds    2 times    5s   Handle Alert

Set Export Path
    [Arguments]    ${timezone}    ${date_format}
    ${date}    CustomLibrary.Get Time Now    time_zone=${timezone}
    ${date}    Convert Date    ${date}    result_format=${date_format}    date_format=%Y-%m-%d %H:%M:%S.%f
    ${m}    Convert Date    ${date}    result_format=%m    date_format=${date_format}
    ${d}    Convert Date    ${date}    result_format=%d    date_format=${date_format}
    ${Y}    Convert Date    ${date}    result_format=%Y    date_format=${date_format}
    ${m}    Remove String Using Regexp    ${m}    ^0|((?<=_)0)
    ${d}    Remove String Using Regexp    ${d}    ^0|((?<=_)0)
    RETURN    ${file_path}/UserExport-${m}_${d}_${Y}.xlsx

Search User In Pages And Click
    [Arguments]    ${user}
    Util.Scroll To Bottom
    ${num}    Wait Until Keyword Succeeds    10 times    3s    Get Text    //table/following::*[@href and text()='Next']/preceding-sibling::*[contains(@href,'page')][1]
    ${num}    Evaluate    ${num}
    FOR    ${i}    IN RANGE    ${num}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    2 times    5s    Scroll Element Into View    //*[text()='${user}']/preceding::*[@href][1]
        IF    ${check} == ${True}
            Users.Go To Edit User Page    ${user}
            Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Edit User
            BREAK
        END
        Util.Scroll To Bottom
        Users.Click Next Page Navigation
    END