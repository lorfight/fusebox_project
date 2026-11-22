*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Test Setup    Setup Test case
Suite Teardown    Close All Browsers
Test Tags    Prime    OD_110    test:retry(2)    Manager    report.label.owner:Cuong Pham

*** Variables ***
${data_input}

*** Test Cases ***
Verify Viewing Account Filter
    [Documentation]    ORD_13    ORD_14
    PendingOrders.Viewing Account    account=${data_input}[checked_location]
    Verify Viewing Account Filter    account=QCA1

Verify New Order
    [Documentation]    ORD_15
    PendingOrders.New Order
    

Verify Build Name
    [Documentation]    ORD_15
    Waiting For Loading
    ${build_name}    Get Text    //*[@id="OrderList"]//tbody//tr/td[1]
    PendingOrders.Build Name    build_name=${build_name}
    ${build_name_ui}    Get Value    id=BuildName
    Should Be Equal As Strings    ${build_name_ui}    ${build_name}


*** Keywords ***
Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    
Setup Test case
    PendingOrders.Go To Pending Orders
    
Verify Viewing Account Filter
    [Arguments]    ${account}
    Page Should Not Contain Element    //*[@id="OrderList"]//tbody//tr[td[2][normalize-space(text()) != "${account}"]]