*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource


Suite Setup    Setup Suite
Test Setup    Setup Test Case
Suite Teardown    Close All Browsers
Test Tags    Prime    OD_103    test:retry(2)    report.label.owner:Cuong Pham

*** Variables ***
${data_input}

*** Test Cases ***


Submit Requisition Order
    NewOrder.Submit Requisition

Submit Order
    NewOrder.Submit Order

Verify Favorite Tab
    Verify Favorite Tab

Verify History Tab
    Verify History Tab

Complete Later
    NewOrder.Complete Later

Verify Updated Cart Count
    Verify Updated Cart Count

Delete Draft
    NewOrder.Delete Draft


*** Keywords ***
Setup Suite
    LoginKeywords.Login To Fusebox    ${USERNAME}    ${PASSWORD}
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

Setup Test Case
    Wait Until Keyword Succeeds    3times    3s    NewOrder.Go Order
    NewOrder.Select Customer Account    ${data_input}[checked_location]
    NewOrder.Find NDC    ${data_input}[ndc]
    NewOrder.Filter By Vendor    ${data_input}[order_vendor]
    NewOrder.Filter By Manufacturer    ${data_input}[manufacturer]
    NewOrder.Ship To Alternate Address    QC auto (New York, NY)
    NewOrder.Select Contract Search Tab    contract=${data_input}[contract]
    NewOrder.Select UOM Search Tab    uom=${data_input}[uom]
    NewOrder.Add Quality    1
    NewOrder.Config My Cart

Verify History Tab
    Click Element    id=History
    Wait Until Page Contains Element    //li[@class="historyTint active"]    timeout=10s
    Page Should Contain Element    //*[@id="ProductSelectorHistory"]//*[text()="${data_input}[ndc]"]

Verify Favorite Tab
    Click Element    id=Favorites
    Wait Until Page Contains Element    //li[@class="favoritesTint active"]    timeout=10s

Verify Updated Cart Count
    ${expected_contract_update}    Set Variable    ${data_input}[update_contract]
    ${expected_uom_update}    Set Variable    ${data_input}[update_uom]
    ${expected_qty_update}    Set Variable    2
    Input Text    id=Qty_1    ${expected_qty_update}
    Execute Javascript    document.activeElement.blur();
    Click Element    id=ContractAndDistributor_1
    Wait Until Page Contains    ${expected_contract_update}
    Wait Until Keyword Succeeds    3times    3s    Select From List By Label    id=ContractAndDistributor_1    ${expected_contract_update}
    Waiting For Loading
    Click Element    id=UomId_1
    Wait Until Keyword Succeeds    3times    3s    Select From List By Label    id=UomId_1    ${expected_uom_update}
    Waiting For Loading
    Wait Until Page Contains Element    css:[style="background-color: rgb(255, 255, 0);"]    timeout=10s
    Click Element    id=UpdateButton
    Wait Until Page Does Not Contain Element    css:[style="background-color: rgb(255, 255, 0);"]    timeout=10s

    ${actual_contract}    Get Selected List Label    id=ContractAndDistributor_1
    ${actual_uom}    Get Selected List Label    id=UomId_1
    ${actual_qty}    Get Value    id=Qty_1
    Should Be Equal    ${actual_contract}    ${expected_contract_update}
    Should Be Equal    ${actual_uom}    ${expected_uom_update}
    Should Be Equal    ${actual_qty}    ${expected_qty_update}
