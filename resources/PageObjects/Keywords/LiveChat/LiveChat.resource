*** Settings ***
Resource    AmazonConnectAgent/AmazonConnectAgent.resource
Resource    ChatWidget/ChatWidget.resource
Library    ../../../../libraries/OtpLibrary.py

*** Keywords ***
Login To Fusebox
    [Arguments]    ${username_arg}    ${password_arg}
    IF    ${MFA} == ${True}
        ${SiteUrl}    Set Variable    ${SiteUrl}/Ciam/Login
        Browser.Go To    ${SiteUrl}
        Wait For Load State    networkidle
        Login Account Via Okta    ${username_arg}    ${password_arg}
    ELSE
        Browser.Go To    ${SiteUrl}
        Wait For Load State    networkidle
        Login Account    ${username_arg}    ${password_arg}
    END
    Set Global Variable    ${SiteUrl}

Open Browser
    ${MFA}    Get Variable Value    ${MFA}    ${FALSE}
    Set Global Variable    ${MFA}
    IF    ${MFA} == ${True}
        New Browser    chromium    headless=True
        New Context    viewport={"width":1920,"height":1080}
    ELSE
        New Browser    chromium    headless=False    args=["--start-maximized"]
        New Context    viewport=None
    END

Login Account
    [Arguments]    ${username_arg}    ${password_arg}
    Fill Text    //*[@id='UserName']    ${username_arg}
    Fill Text    //*[@id='Password']    ${password_arg}
    Run Keyword And Return Status    Click    //input[@value="Log in"]
    Wait For Load State    load

Login Account Via Okta
    [Arguments]    ${username_arg}    ${password_arg}
    Fill Text    //*[@name="identifier"]    ${username_arg}
    Click    //*[@type="submit"]
    Click    //*[@data-se="google_otp"]/a
    ${OTP}    OtpLibrary.Generate Otp    ${Secret}
    Fill Text    //*[@name="credentials.passcode"]    ${OTP}
    Click    //*[@type="submit"]
    Fill Text    css:[@type="password"]    ${password_arg}
    Click    //*[@type="submit"]
    Wait For Load State    load

Open Amazon Connect    #78-TC139
    [Arguments]    ${url}
    New Page    ${url}
    Wait For Load State    networkidle
    Click    //button[@class="citrix"]
    Wait For Elements State    //h1[text()="Amazon Connect"][1]    visible    60s

Open CCPA
    [Arguments]    ${url}
    New Page    ${url}
    Wait For Load State    networkidle
