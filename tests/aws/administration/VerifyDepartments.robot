*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Departments/Departments.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    ClinicSmokeLogImp    test:retry(3)    ADM_013

*** Test Cases ***
Verify Create Department
    [Documentation]    ADM-13: Create Department
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Departments.Go To Department Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Department Management
    ${is_available}    Run Keyword And Return Status    Departments.Filter Department    dept=test department - test desc
    IF    ${is_available} == ${True}
        List Selection Should Be    id=AccountDepartmentID    test department - test desc
        Reset Assigned Department
        Sleep    3s
        Wait Until Keyword Succeeds    10 times    3s    Departments.Filter Department    dept=test department - test desc
        Departments.Delete Department
    END
    ${is_orgn}    Evaluate    random.choice([${True},${False}])
    Departments.Create Department    name=test department    short=test short    desc=test desc    is_orgn=${is_orgn}
    Wait Until Page Contains    Department has been created Sucessfully    60s
    Set Suite Variable    ${department_available}    ${True}
    Departments.Close Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    Wait Until Keyword Succeeds    10 times    3s    List Selection Should Be    id=AccountDepartmentID    test department - test desc

Verify Search And Assign Department
    [Documentation]    ADM-12: Search And Assign Department
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Wait Until Keyword Succeeds    5 times    2s    Departments.Go To Department Management
    Wait Until Keyword Succeeds    5 times    2s    Title Should Be    Department Management
    ${is_available}    Run Keyword And Return Status    Departments.Filter Department    dept=test department - test desc
    IF    ${is_available} == ${False}
        Wait Until Keyword Succeeds    5 times    2s    Departments.Create Department    name=test department    short=test short    desc=test desc    is_orgn=${True}
        Wait Until Page Contains    Department has been created Sucessfully    60s
        Wait Until Keyword Succeeds    5 times    2s    Departments.Close Modal
    ELSE
        Wait Until Keyword Succeeds    5 times    3s    List Selection Should Be    id=AccountDepartmentID    test department - test desc
        Wait Until Keyword Succeeds    5 times    2s    Reset Assigned Department
    END
    Sleep    3s
    Wait Until Keyword Succeeds    5 times    2s    Departments.Filter Department    dept=test department - test desc
    IF    "${Userrole}" == "Impersonate"
        Wait Until Keyword Succeeds    5 times    2s    Departments.Search User In Navigation Pages    user=${TargetUsername}
        ${is_assigned_before}    Wait Until Keyword Succeeds    5 times    2s    Assign Or Unassign Department    user=${TargetUsername}
        Wait Until Keyword Succeeds    5 times    2s    Verify Assign Or Unassign User Department    user=${TargetUsername}    is_assigned_before=${is_assigned_before}
    ELSE
        Wait Until Keyword Succeeds    5 times    2s    Departments.Search User In Navigation Pages    user=${Username}
        ${is_assigned_before}    Wait Until Keyword Succeeds    5 times    2s    Assign Or Unassign Department    user=${Username}
        Wait Until Keyword Succeeds    5 times    2s    Verify Assign Or Unassign User Department    user=${Username}    is_assigned_before=${is_assigned_before}
    END

Verify Update Department
    [Documentation]    ADM-14: Update Department
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Departments.Go To Department Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Department Management
    ${is_available}    Run Keyword And Return Status    Departments.Filter Department    dept=test department - test desc
    IF    ${is_available} == ${False}
        Departments.Create Department    name=test department    short=test short    desc=test desc    is_orgn=${True}
        Wait Until Page Contains    Department has been created Sucessfully    60s
        Departments.Close Modal
    END
    Wait Until Keyword Succeeds    10 times    3s    Departments.Open Edit Department Modal
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${text}    Get Value    id=Name
    IF    "updated" in "${text}"
        Departments.Input Department Name    name=test department
    ELSE
        Departments.Input Department Name    name=test department updated
    END
    ${text}    Get Value    id=ShortName
    IF    "updated" in "${text}"
        Departments.Input Department Short Name  name=test short
    ELSE
        Departments.Input Department Short Name    name=test short updated
    END
    ${text}    Get Value    id=Description
    IF    "updated" in "${text}"
        Departments.Input Department Description    desc=test desc
    ELSE
        Departments.Input Department Description    desc=test desc updated
    END
    Departments.Accept Modal
    Wait Until Page Contains    Department has been updated Sucessfully    60s
    Departments.Close Modal
    ${check}    Run Keyword And Return Status    List Selection Should Be    id=AccountDepartmentID    test department updated - test desc updated
    IF    ${check} == ${True}
        Reset Assigned Department
        Sleep    3s
        Departments.Delete Department
    END

Verify Delete Department
    [Documentation]    ADM-15: Delete Department
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    Departments.Go To Department Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Department Management
    ${is_available}    Run Keyword And Return Status    Departments.Filter Department    dept=test department - test desc    #Check Department Available
    IF    ${is_available} == ${False}
        Departments.Create Department    name=test department    short=test short    desc=test desc    is_orgn=${True}
        Wait Until Page Contains    Department has been created Sucessfully    60s
        Departments.Close Modal
    ELSE
        List Selection Should Be    id=AccountDepartmentID    test department - test desc
        Reset Assigned Department
    END
    Wait Until Keyword Succeeds    10 times    3s    Departments.Filter Department    dept=test department - test desc
    Sleep    5s
    Departments.Delete Department
    ${check}    Run Keyword And Return Status    Select From List By Label    id=AccountDepartmentID    test department
    Should Not Be True    ${check} == ${True}

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
    Switch To Another Window    Home

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

Check Department Available
    Variable Should Exist    ${department_available}

Reset Assigned Department
    ${lines}    Get Element Count    //*[@id='CurrentlyDepartmented']//tbody/*[*]//*[@class='Assign'][1]
    FOR    ${line}    IN RANGE    ${lines}
        IF    ${line} < ${lines-1}
            Wait Until Keyword Succeeds    5 times    3s    Scroll Element Into View    //*[@id='CurrentlyDepartmented']//tbody/*[${line+1}]//*[@class='Assign'][1]
        ELSE
            Util.Scroll To Bottom
        END
        Sleep    3s
        Wait Until Keyword Succeeds    5 times    3s    Unselect Checkbox    //*[@id='CurrentlyDepartmented']//tbody/*[${line+1}]//*[@class='Assign'][1]
        Checkbox Should Not Be Selected    //*[@id='CurrentlyDepartmented']//tbody/*[${line+1}]//*[@class='Assign'][1]
    END

Assign Or Unassign Department
    [Arguments]    ${user}
    ${xpath}    Set Variable    //*[@id='UserSearch']//*[contains(text(),'(${user})')]/following::*[@class='Assign'][1]
    ${is_assigned_before}    Run Keyword And Return Status    Checkbox Should Be Selected    ${xpath}
    IF    ${is_assigned_before} == ${False}
        Assign Department    user=${user}
        Wait Until Page Contains    User Added to Department    60s
        Checkbox Should Be Selected    ${xpath}
    ELSE
        Unassign Department    user=${user}
        Wait Until Page Contains    User Removed from Department    60s
        Checkbox Should Not Be Selected    ${xpath}
    END
    RETURN    ${is_assigned_before}

Verify Assign Or Unassign User Department
    [Arguments]    ${user}    ${is_assigned_before}
    ${xpath}    Set Variable    //*[@id='CurrentlyDepartmented']//*[contains(text(),'(${user})')]/following::*[@class='Assign'][1]
    Scroll Element Into View   ${xpath}
    IF    ${is_assigned_before} == ${False}
        Checkbox Should Be Selected    ${xpath}
    ELSE
        Page Should Not Contain Checkbox    ${xpath}
    END