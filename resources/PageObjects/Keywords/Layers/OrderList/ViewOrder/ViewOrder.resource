*** Settings ***
Resource    ../../../../../../libraries/Util.resource

*** Keywords ***
Receive To Inventory
    [Arguments]    ${Facility}
    Select From List By Value    id=Facility    ${Facility}

Apply Item
    [Arguments]    ${barcode}    ${checked_facility}    ${order_qty}
    Util.Handle Scan Barcode Reconcile    barcode=${BarcodeItem}
    Util.Verify Loading And Select By Label    Facility    ${checked_facility}
    Sleep    3s
    ${order_qty_actual}=    Get Text    //div[contains(@class,"QtyOrdered")]
    Should Be Equal    ${${order_qty_actual}}    ${${order_qty}}
    Wait Until Keyword Succeeds    2times    1    Input Text    id=LineNumber1Qty    ${order_qty}
    Click Element    //*[contains(text(),"Receive to Inventory")]  `/  #set out focus input
    Wait Until Element Is Enabled    link:Save
    Click Element    link:Save