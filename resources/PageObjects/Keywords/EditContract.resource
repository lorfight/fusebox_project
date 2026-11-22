*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Resource    ../../../libraries/Util.resource

*** Keywords ***
Search By Item
    [Arguments]    ${search_contract}
    Wait Until Element Is Visible    id=SearchValues
    Input Text    id=SearchValues    text=${search_contract}
    Click Button    Find
    Wait Until Element Is Visible    //*[@id="searching-indicator" and not(contains(@class,"hidden"))]
    Wait Until Element Is Not Visible    //*[@id="searching-indicator" and not(contains(@class,"hidden"))]    timeout=10s

Select Tab Allocation Rules
    Wait Until Element Is Visible    link: Allocation Rules
    Click Element    link: Allocation Rules

Get Info Contract Checked Row
    ${base_price_exist}    Run Keyword And Return Status    Variable Should Exist    ${base_price}
    ${uom_exist}    Run Keyword And Return Status    Variable Should Exist    ${uom}
    ${base_qty_exist}    Run Keyword And Return Status    Variable Should Exist    ${base_qty}

    IF    ${uom_exist} == ${False}
        ${uom}    Get Text    //tr[contains(@style, 'background-color: rgba(218, 237, 204, .6)')]/td[1]
        Set Test Variable    $uom    ${uom}
    END
    IF    ${base_price_exist} == ${False}
        ${base_price}    Get Value    //tr[contains(@style, 'background-color: rgba(218, 237, 204, .6)')]//td[contains(text(),"${uom}")]/following::td[2]/input
        Set Test Variable    $base_price    ${base_price}
    END
    IF    ${base_qty_exist} == ${False}
        ${base_qty}    Get Text    //tr[contains(@style, 'background-color: rgba(218, 237, 204, .6)')]//td[contains(text(),"${uom}")]/following::td[1]
        Set Test Variable    $base_qty    ${base_qty}
    END
    
