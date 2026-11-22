*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/GLCodes/GLCodes.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Keyword
Test Tags    ClinicSmokeLogImp    test:retry(3)    ADM_024

*** Test Cases ***
Verify Create GL Code
    [Documentation]    ADM-24: Create GL Code
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    GLCodes.Go To GL Code Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    GL Code Management
    GLCodes.Select Account    acc=${location}
    List Selection Should Be    id=AccountId    ${location}
    ${btns}    Get WebElements    //*[@href and text()='12345']/following::*[contains(@onclick,'Delete')][1]
    FOR    ${btn}    IN    @{btns}
        Scroll Element Into View    ${btn}
        Execute Javascript    window.scrollBy(0,30)
        Sleep    3s
        Wait Until Keyword Succeeds    5 times    3s    Click Element    ${btn}
        Handle Alert
    END
    ${is_available}    Run Keyword And Return Status    Select GL Code    code=12345
    IF    ${is_available} == ${True}
        Wait Until Keyword Succeeds    5 times    3s    GLCodes.Click Delete GL Code
        Handle Alert
    END
    Sleep    5s
    GLCodes.Create GL Code    code=12345    desc=test desc    pay=12346    re=12347
    Wait Until Page Contains    GL Code created successfully    60s

Verify Display GL Code
    [Documentation]    ADM-23: Display GL Code
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    GLCodes.Go To GL Code Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    GL Code Management
    GLCodes.Select Account    acc=${location}
    List Selection Should Be    id=AccountId    ${location}
    Wait Until Keyword Succeeds    5 times    3s    Element Should Be Visible    //tbody/*[@class='MainView'][1]//*[contains(@onclick,'SetGLCode')]

Verify Update GL Code
    [Documentation]    ADM-26: Update GL Code
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    GLCodes.Go To GL Code Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    GL Code Management
    GLCodes.Select Account    acc=${location}
    List Selection Should Be    id=AccountId    ${location}
    ${is_available}    Run Keyword And Return Status    Select GL Code    code=54321
    IF    ${is_available} == ${True}
        Wait Until Keyword Succeeds    5 times    3s    GLCodes.Click Delete GL Code
        Handle Alert
    END
    ${is_available}    Run Keyword And Return Status    Select GL Code    code=12345
    IF    ${is_available} == ${False}
        Sleep    5s
        GLCodes.Create GL Code    code=12345    desc=test desc    pay=12346    re=12347
        Wait Until Page Contains    GL Code created successfully    60s
    END
    ${btns}    Get WebElements    //*[@href and text()='54321']/following::*[contains(@onclick,'Delete')][1]
    FOR    ${btn}    IN    @{btns}
        Scroll Element Into View    ${btn}
        Execute Javascript    window.scrollBy(0,30)
        Wait Until Keyword Succeeds    5 times    3s    Click Element    ${btn}
        Handle Alert
    END
    Wait Until Keyword Succeeds    5 times    3s    GLCodes.Open Edit GL Code Modal    code=12345
    Wait Until Element Is Visible    id=ModalPopup    60s
    GLCodes.Input GL Code    code=54321
    ${desc}    Get Value    id=Description
    IF    "updated" in "${desc}"
        ${desc}    Set Variable    test desc
    ELSE
        ${desc}    Set Variable    test desc updated
    END
    GLCodes.Input GL Desscription    desc=${desc}
    ${pay}    Get Value    //*[contains(@placeholder,'Payable Code')]
    IF    "${pay}" == "12346"
        ${pay}    Set Variable    64321
    ELSE
        ${pay}    Set Variable    12346
    END
    GLCodes.Input Payable Code    code=${pay}
    ${re}    Get Value    //*[contains(@placeholder,'Receivable Code')]
    IF    "${re}" == "12347"
        ${re}    Set Variable    74321
    ELSE
        ${re}    Set Variable    12347
    END
    GLCodes.Input Recievable Code    code=${re}
    GLCodes.Click To Save
    Wait Until Page Contains    GL Code updated successfully!    15s
    Wait Until Element Is Not Visible    id=ModalPopup    60s
    Sleep    3s
    GLCodes.Open Edit GL Code Modal    code=54321
    Wait Until Element Is Visible    id=ModalPopup    60s
    ${gl_val}    Get Value    //*[contains(@placeholder,'General Ledger Code')]
    Should Be Equal    ${gl_val}    54321
    ${pay_val}    Get Value    //*[contains(@placeholder,'Payable Code')]
    Should Be Equal    ${pay_val}    ${pay}
    ${re_val}    Get Value    //*[contains(@placeholder,'Receivable Code')]
    Should Be Equal    ${re_val}    ${re}
    GLCodes.Close Modal
    Wait Until Element Is Not Visible    id=ModalPopup    60s

Verify Add GL Code To Selection
    [Documentation]    ADM-23: Add GL Code
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    GLCodes.Go To GL Code Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    GL Code Management
    Select Account    acc=${location}
    List Selection Should Be    id=AccountId    ${location}
    ${is_available}    Run Keyword And Return Status    Select GL Code    code=12345
    IF    ${is_available} == ${False}
        Sleep    5s
        Create GL Code    code=12345    desc=test desc    pay=12346    re=12347
        Wait Until Page Contains    GL Code created successfully    60s
    END
    Wait Until Keyword Succeeds    10 times    3s    GLCodes.Select GL Code    code=12345
    List Selection Should Be    id=GLCodeId    12345
    GLCodes.Select Department    dept=\-- Default Account Department --\
    List Selection Should Be    id=DepartmentId    \-- Default Account Department --\
    GLCodes.Select Vendors    vend=\-- Select a Vendor --\
    List Selection Should Be    id=DistributerAccountId    \-- Select a Vendor --\
    GLCodes.Select Manufacturers    manuf=\-- Select a Manufacturer --\
    List Selection Should Be    id=ManufacturerAccountId    \-- Select a Manufacturer --\
    GLCodes.Clear Field
    GLCodes.Input Search    text=${actem_ndc}
    GLCodes.Click To Find
    GLCodes.Click To Assign Multiple GL Code
    Handle Alert
    Wait Until Page Contains    GL Code Assigned Successfully    15s

Verify Assign And Unassign GL Code
    [Documentation]    ADM-27: Assign GL Code
    [Tags]        Smoke    Administrator    report.label.owner:Vu Nguyen
    GLCodes.Go To GL Code Management
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    GL Code Management
    Select Account    acc=${location}
    List Selection Should Be    id=AccountId    ${location}
    ${is_available}    Run Keyword And Return Status    Select GL Code    code=12345
    IF    ${is_available} == ${False}
        Sleep    5s
        Create GL Code    code=12345    desc=test desc    pay=12346    re=12347
        Wait Until Page Contains    GL Code created successfully    60s
    END
    GLCodes.Select GL Code    code=12345
    List Selection Should Be    id=GLCodeId    12345
    GLCodes.Select Department    dept=\-- Default Account Department --\
    List Selection Should Be    id=DepartmentId    \-- Default Account Department --\
    GLCodes.Select Vendors    vend=\-- Select a Vendor --\
    List Selection Should Be    id=DistributerAccountId    \-- Select a Vendor --\
    GLCodes.Select Manufacturers    manuf=\-- Select a Manufacturer --\
    List Selection Should Be    id=ManufacturerAccountId    \-- Select a Manufacturer --\
    GLCodes.Clear Field
    GLCodes.Input Search    text=${actem_ndc}
    GLCodes.Click To Find
    Wait Until Keyword Succeeds    5 times    3s    GLCodes.Click To Assign Single GL Code
    Wait Until Page Contains    GL Code Assigned Successfully    15s
    GLCodes.Clear Field
    GLCodes.Input Search    text=${fasen_ndc}
    GLCodes.Click To Find
    Wait Until Keyword Succeeds    5 times    3s    GLCodes.Click To Assign Single GL Code
    Wait Until Page Contains    GL Code Assigned Successfully    15s
    GLCodes.Select GL Code    code=\-- Unassign GL Code --\
    List Selection Should Be    id=GLCodeId    \-- Unassign GL Code --\
    Wait Until Keyword Succeeds    5 times    3s    GLCodes.Click To Assign Single GL Code
    Wait Until Page Contains    GL Code Removed Successfully    15s

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
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${location_id}    ${data_input}[location_id]
    Set Suite Variable    ${actem_ndc}    ${data_input}[actem_ndc]
    Set Suite Variable    ${fasen_ndc}    ${data_input}[fasen_ndc]

Verify GL Code Assigned
    ${lines}    Get Element Count    //*[@class='MainView'][*]//*[contains(@onclick,'AssignGLCode') and *]
    FOR    ${line}    IN RANGE    ${lines}
        Scroll Element Into View    //*[@class='MainView'][${line+1}]//*[contains(@onclick,'AssignGLCode') and *]
        ${color}    Execute Javascript    return window.getComputedStyle(arguments[0].background-color);    //*[@class='MainView'][${line+1}]//*[contains(@onclick,'AssignGLCode') and *]
        Should Be Equal    ${color}    rgb\(92, 184, 92)    ignore_case=True
    END

Verify GL Code Unassigned
    ${lines}    Get Element Count    //*[@class='MainView'][*]//*[contains(@onclick,'AssignGLCode') and *]
    FOR    ${elm}    IN RANGE    ${lines}
        Scroll Element Into View    //*[@class='MainView'][${line+1}]//*[contains(@onclick,'AssignGLCode') and *]
        ${color}    Execute Javascript    return window.getComputedStyle(arguments[0].background-color);    //*[@class='MainView'][${line+1}]//*[contains(@onclick,'AssignGLCode') and *]
        Should Be Equal    ${color}    rgb\(217, 83, 79)    ignore_case=True
    END
