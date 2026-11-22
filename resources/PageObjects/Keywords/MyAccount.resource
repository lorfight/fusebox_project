*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime

Variables    ../Locators/CommonLocator.py 
Resource    ../../../libraries/Util.resource


*** Keywords ***
Go To My Account
    Click Element    link:Administration
    Click Element    link:My Account
    Wait Until Page Contains Element    id=MyAccountView

Config Location Time Zone
    [Arguments]    ${time_zone}
    Wait Until Element Is Enabled    id=SelectedTimezone
    Select From List By Label    SelectedTimezone    ${time_zone}

Save Change
    Util.Scroll Into View    locator="//*[@id='SaveMyAccount']"    inline=end
    Click Element    id=SaveMyAccount
    Wait Until Page Contains    text=Account Updated!

Viewing Account
    [Arguments]    ${viewing_account}
    Select From List By Label   id=_MyAccountLoader    ${viewing_account}

Select Inventory Reconcile Complexity
    [Arguments]    ${complexity_option}
    Select From List By Label    id=InventoryReconcileComplexity    ${complexity_option}
   