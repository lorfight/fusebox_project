*** Settings ***
Library    SeleniumLibrary    timeout=10s    implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot    #edt
Library    ../../../libraries/CustomLibrary.py
Library    ../../../libraries/OtpLibrary.py
Library    ../../../libraries/ApiCapture.py

Library    OperatingSystem
Variables    ../Locators/LoginLocator.py
Variables    ../Locators/CommonLocator.py
Resource    Administration/Users/Users.resource
Resource    ../../../libraries/Util.resource
Resource    Layers/Common/Common.resource
Resource    Administration/UserActivityMonitor/UserActivityMonitor.resource

*** Variables ***
${REMOTE_URL}    http://selenium-hub:4444/wd/hub
${test_execution_type}
${Userrole}
${TargetUsername}
${TargetAccount}
${secret_key}    ${secret}
*** Keywords ***
Login To Fusebox
    [Arguments]    ${user_name}    ${password}
    ${MFA}    Get Variable Value    ${MFA}    ${FALSE}
    IF    ${MFA} == ${TRUE}
        Open Browser To Login Page
        Login Okta Verify    ${user_name}    ${password}
    ELSE
        Open Browser To Login Page
        Login account    ${user_name}    ${password}
    END
    Last Login Info
    Check Newsletter
    IF    "${Userrole}" == "Impersonate"
        ${check_btn}    Run Keyword And Return Status    Element Should Be Visible    //a[text()="Stop Impersonating"]    2s
        IF    "${check_btn}" == "${True}"
            Wait Until Keyword Succeeds    5times    3s    Click Element    //a[text()="Stop Impersonating"]
            Sleep    10s
            Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home
        END
    END
    Run Keyword If    "${Userrole}" == "Impersonate"    Impersonate User

Open Browser To Login Page
    ${chrome_options}=    Config Browser
    ${IS_LINUX_PLATFORM}=    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM} == ${True} and "${test_execution_type}" == "parallel"
        Open Browser    ${SiteUrl}    ${Browser}    remote_url=${REMOTE_URL}   options=${chrome_options}
    ELSE
        Open Browser     ${SiteUrl}    ${Browser}    executable_path=${EXECDIR}\\static\\drivers\\chromedriver.exe     options=${chrome_options}
    END
    Wait Until Keyword Succeeds    3times    10s    Get Version Fusebox

Config Browser
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${EXPORT_PATH}=    Join Path     ${EXECDIR}    results/export/${Username}
    # ${chromedriver_path}=    Get Chromedriver Path    ${Browser}
    ${appState}=    Get Chrome Option
    Set Environment Variable    EXPORT_PATH    ${EXPORT_PATH}
    ${experimental_flags}=           Create List             calculate-native-win-occlusion@2
    ${excludeSwitches}=    Create List    enable-logging
    ${chromeLocalStatePrefs}=    Create Dictionary   browser.enabled_labs_experiments=${experimental_flags}
    ${prefs}    Create Dictionary    download.default_directory=${EXPORT_PATH}
    Set To Dictionary    ${prefs}    savefile.default_directory=${EXPORT_PATH}
    Set To Dictionary    ${prefs}    printing.print_preview_sticky_settings.appState=${appState}
    ${IS_LINUX_PLATFORM}=    Is Linux Platform
    Run Keyword If    ${IS_LINUX_PLATFORM}    Call Method    ${chrome_options}    add_argument    --headless
    Run Keyword If    ${IS_LINUX_PLATFORM}    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Run Keyword If    ${IS_LINUX_PLATFORM}    Call Method    ${chrome_options}    add_argument    --disable-gpu

    
    Call Method    ${chrome_options}    add_argument    --kiosk-printing
    Call Method    ${chrome_options}    add_argument    window-size\=1920,1080
    Call Method    ${chrome_options}    add_experimental_option    prefs    ${prefs}
    Call Method    ${chrome_options}    add_experimental_option    localState    ${chromeLocalStatePrefs}
    Call Method    ${chrome_options}    add_experimental_option    excludeSwitches    ${excludeSwitches}
    ${loggingPrefs}    Create Dictionary    performance=ALL 
    Call Method    ${chrome_options}    set_capability    goog:loggingPrefs    ${loggingPrefs}
    RETURN    ${chrome_options}    ${chromedriver_path}

Login Okta Google Authenticator
    Set Log Level    NONE
    [Arguments]    ${username}    ${password}
    Wait Until Page Contains Element    //*[@name="identifier"]
    Input Text    //*[@name="identifier"]    ${username}
    Wait Until Page Contains Element    css:[type="submit"]
    Click Button    css:[type="submit"]
    Wait Until Page Contains Element    //*[@data-se="google_otp"]/a
    Click Element    //*[@data-se="google_otp"]/a
    ${OTP}    OtpLibrary.Generate Otp    ${secret_key}
    Wait Until Page Contains Element    //*[@name="credentials.passcode"]
    Input Text    //*[@name="credentials.passcode"]    text=${OTP}
    Click Button    css:[type="submit"]
    Wait Until Page Contains Element    css:[type="password"]
    Input Text    css:[type="password"]    ${password}
    Click Button    css:[type="submit"]
    Set Log Level    INFO
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home

Login Okta Verify
    Set Log Level    NONE
    [Arguments]    ${username}    ${password}
    Wait Until Page Contains Element    //*[@name="identifier"]
    Input Text    //*[@name="identifier"]    ${username}
    Click Button    css:[type="submit"]
    Wait Until Page Contains Element    css:[type="password"]
    Input Text    css:[type="password"]    ${password}
    Click Button    css:[type="submit"]
    Wait Until Page Contains Element    //*[@data-se="okta_verify-totp"]/a
    click element    //*[@data-se="okta_verify-totp"]/a
    ${OTP}    OtpLibrary.Generate Otp    ${secret_key}
    Wait Until Page Contains Element    //*[@name="credentials.totp"]
    Input Text    //*[@name="credentials.totp"]    text=${OTP}
    Click Button    css:[type="submit"]
    Set Log Level    INFO
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home

Login Account
    Set Log Level    NONE
    [Arguments]    ${username}    ${password}
    Input Text    ${LoginUsernameInputBox}    ${username}
    Input Text    ${LoginPasswordInputBox}    ${password}
    Set Log Level    INFO
    SeleniumLibrary.Click Button    ${LoginButton}
    Wait Until Keyword Succeeds    10 times    30s    Title Should Be    Home

Get Version Fusebox
    # Get attribute value for the element xpath //*[@id="app-version"] and store it in a variable environment system
    ${version}=    SeleniumLibrary.Get Element Attribute    //*[@id="app-version"]  value
    Set Environment Variable    FuseboxVersion    ${version}
    ${version}=    Convert To String    ${version}
    ${json}=    Read File Properties    ${EXECDIR}/results/temp_report/environment.properties
    Edit File Properties    ${EXECDIR}/results/temp_report/environment.properties    fusebox_version    ${version}

Check Newsletter
    ${Newsletter_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="NewsletterModalPopup"]    timeout=10s
    Run Keyword If    ${Newsletter_visible}    Wait Until Keyword Succeeds    5times    3s    Click Button    Do Not Show Again

Last Login Info
    ${popup_last_login_info}    Run Keyword And Return Status    Wait Until Page Contains Element   //*[@class="LastLoginIconRow"]    timeout=10s
    Waiting For Loading
    Run Keyword If    ${popup_last_login_info}    Wait Until Keyword Succeeds    5times    3s        Click Button    This Was Me

Impersonate User
    Go To User List
    Select Account In Users Page    ${TargetAccount}
    Find User    ${TargetUsername}
    FOR    ${i}    IN RANGE    10
        ${button_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${TargetUsername}"]]//following::a[contains(text(),"Impersonate User")][1]    2s
        Run Keyword If     ${button_visible}    Exit For Loop
        Run Keyword If     "${button_visible}"=="${False}"    Wait Until Keyword Succeeds    5times    3s    Click Element    (//a[text()="Next"])[1]
    END
    Common.Scroll And Click Element    //tr[td[text()='${TargetUsername}']]//following::a[contains(text(),'Impersonate User')][1]
    Wait Until Keyword Succeeds    5times    3s    Click Button    Accept and Impersonate
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home
    Last Login Info
    Check Newsletter

Save Captured Api And Close Browser
    IF    "${Userrole}" == "Impersonate"
        Wait Until Keyword Succeeds    5times    3s    Click Element    //a[text()="Stop Impersonating"]
        Sleep    10s
        Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Home
        Save After Suite Api
        Wait Until Keyword Succeeds    3times    10s    Get Action Log Following Impersonated User Activity
    END
    Close Browser
