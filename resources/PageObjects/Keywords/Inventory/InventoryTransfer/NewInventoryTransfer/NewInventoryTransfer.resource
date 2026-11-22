*** Settings ***
Resource    ../../Common/InventoryUtils.resource

*** Variables ***
${transfer_id_input}    //input[@id="TransferId" and @value!=""]

*** Keywords ***
Select The Account To Transfer From
    [Arguments]    ${from_location}
    Wait Until Element Is Enabled    id=FromAccount    30s
    Wait Until Element Contains    id=FromAccount    ${from_location}    
    Select From List By Label    id=FromAccount    ${from_location}
    Waiting For Loading

From Inventory
    [Arguments]    ${from_facility}
    Wait Until Element Is Enabled    id=FromFacility    30s
    Wait Until Element Contains    id=FromFacility    ${from_facility}    
    Select From List By Label    id=FromFacility    ${from_facility}
    Waiting For Loading

Select The Account To Transfer To
    [Arguments]    ${to_location}
    Wait Until Element Is Enabled    id=ToAccount    30s
    Wait Until Element Contains    id=ToAccount    ${to_location}    
    Select From List By Label    id=ToAccount    ${to_location}
    Waiting For Loading

Select Backstock From
    [Arguments]    ${from_backstock}
    Wait Until Element Is Enabled    id=FromBackstock    30s
    Select From List By Label    id=FromBackstock    ${from_backstock}
    Waiting For Loading

Select Backstock To
    [Arguments]    ${to_backstock}
    Wait Until Element Is Enabled    id=ToBackstock    30s
    Select From List By Label    id=ToBackstock    ${to_backstock}
    Waiting For Loading

Select Lot Transfer
    [Arguments]    ${price}
    ${option_with_price}    Set Variable    //select[@id="Price"]/option[contains(.,"${price}")]
    Wait Until Element Is Enabled    ${option_with_price}    30s
    Click Element    ${option_with_price}

To Inventory
    [Arguments]    ${to_facility}
    Wait Until Element Is Enabled    id=ToFacility    30s
    Wait Until Element Contains    id=ToFacility    ${to_facility}    
    Select From List By Label    id=ToFacility    ${to_facility}
    Waiting For Loading

Submit Transfer
    Click Element    link:Submit Transfer
    Handle Alert    timeout=10s
    Waiting For Loading

Complete Later
    Click Element    link:Complete Later
    Waiting For Loading

Delete Transfer
    Click Element    link:Delete Transfer
    Handle Alert And Return Its Text
    Waiting For Loading

Scan Transfer ${other_changes_qty} ${ndc}
    ${list_barcode}=     Evaluate   random.sample(${BARCODES_TRANSFER},${other_changes_qty})
    Scan List Barcode    $list_barcode=${list_barcode}

Get Id Transfer
    Wait Until Page Contains Element    ${transfer_id_input}    30s
    ${id_transfer}    SeleniumLibrary.Get Element Attribute    ${transfer_id_input}    value
    RETURN    ${id_transfer}