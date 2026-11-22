*** Settings ***
Resource    ../../../../../libraries/Util.resource


*** Keywords ***
Go To My Account
    Click Element    link:Administration
    Click Element    link:My Account
    Wait Until Page Contains Element    id=MyAccountView
    Waiting For Loading


Config Location Time Zone
    [Arguments]    ${time_zone}
    Wait Until Element Is Enabled    id=SelectedTimezone
    Select From List By Label    SelectedTimezone    ${time_zone}
    Waiting For Loading


Save Change
    Util.Scroll Into View    locator="//*[@id='SaveMyAccount']"    inline=end
    Click Element    id=SaveMyAccount
    Wait Until Page Contains    text=Account Updated!    timeout=120s
    Waiting For Loading

Viewing Account
    [Arguments]    ${viewing_account}
    Select From List By Label   id=CurrentMyAccountID    ${viewing_account}
    Waiting For Loading

Select Inventory Reconcile Complexity
    [Arguments]    ${complexity_option}
    [Documentation]    Select Inventory Reconcile Complexity in My Account with label options: Add & Full Reconcile Only Visible | Every Reconcile Type is Visible | Add & Full Reconcile Only Visible - STRICT NOTES | Every Reconcile Type is Visible - STRICT NOTES
    Select From List By Label    id=InventoryReconcileComplexity    ${complexity_option}
    Waiting For Loading

   
View Users
    Click Element    link: View Users
    Switch Window    Users
    Title Should Be    Users

Verify Utilize Report Queue Checkbox
    [Arguments]    ${status}
    ${checkbox_status}    SeleniumLibrary.Get Element Attribute    //input[@id='UtilizeReportQueue']    checked
    Util.Scroll Into View    locator="//input[@id='UtilizeReportQueue']"    inline=end
    IF    "${status}" == "check"
        Run Keyword If    "${checkbox_status}" == "None"    Click Element    //input[@id='UtilizeReportQueue']
    ELSE IF    "${status}" == "uncheck"
        Run Keyword If    "${checkbox_status}" == "true"    Click Element    //input[@id='UtilizeReportQueue']
    END
