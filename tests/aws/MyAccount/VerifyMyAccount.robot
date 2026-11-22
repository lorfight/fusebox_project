*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot

Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Setup Suite
Suite Teardown    Close All Browsers
Test Tags    Prime    ACC_100    report.label.owner:Cuong Pham

*** Test Cases ***
Verify Edit Technical Setting
    MyAccount.Go To My Account
    MyAccount.Viewing Account    ${data_input}[account]
    MyAccount.Config Location Time Zone    (UTC-06:00) Central Time (US & Canada)
    MyAccount.Save Change

Verify View Users
    MyAccount.Go To My Account
    MyAccount.Viewing Account    ${data_input}[account]
    MyAccount.View Users
    Users.Find User    ${Username}
    Users.Edit User    ${Username}

Verify View Account
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    QCA1
    Accounts.Choose Account In Accounts Page    QC Automation 01


Verify View Users in Account
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    QCA1
    Accounts.Choose Account In Accounts Page    QC Automation 01
    Click Element    link:View Users
    Title Should Be    Users

Verify View Contact in Account
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    QCA1
    Accounts.Choose Account In Accounts Page    QC Automation 01
    Click Element    link:View Contacts
    Title Should Be    Contacts

Verify View Physicians in Account
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    QCA1
    Accounts.Choose Account In Accounts Page    QC Automation 01
    Click Element    link:View Physicians
    Title Should Be    Physicians

    
Verify View Users In New Account
    Accounts.Go To Accounts
    Click Element    link: New Account
    Title Should Be    New Account
    Click Element    link:View Users
    Title Should Be    Users

# Verify View Contacts In New Account
#     Accounts.Go To Accounts
#     Click Element    link: New Account
#     Title Should Be    New Account
#     Click Element    link:View Contacts
#     Title Should Be    Contacts

Verify View Physicians New Account
    Accounts.Go To Accounts
    Click Element    link: New Account
    Title Should Be    New Account
    Click Element    link:View Physicians
    Title Should Be    Physicians

Verify Import Account
    Accounts.Go To Accounts
    Waiting For Loading
    Click Element    link:Import Accounts
    Wait Until Page Contains Element    //*[@id="ModalPopup" and @aria-hidden="false"]/div/div/div[1]/h4
    [Teardown]    Click Element    //*[@id="ModalPopup" and @aria-hidden="false"]//button[text()="Close"]

Verify View Changes in Account
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    QCA1
    Accounts.Choose Account In Accounts Page    QC Automation 01
    Waiting For Loading
    Click Element    link:View Changes
    Wait Until Page Contains Element    //*[@id="ViewOnlyModalPopup" and @aria-hidden="false"]//*[text()="Account Changelog"]

*** Keywords ***
Setup Suite
    Login To Fusebox    ${Username}    ${Password}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
