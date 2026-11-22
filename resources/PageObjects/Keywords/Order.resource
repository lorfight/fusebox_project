*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime

Variables    ../Locators/CreateOrderLocator.py
Variables    ../Locators/CommonLocator.py 
# Variables    ../TestData/Testdata.py
Resource    ../../../libraries/Util.resource

*** Keywords ***
# Behaviour
Built New Order   
    Wait Until keyword Succeeds    3times    1    Go Order
    Config Order
    ...    location=${location}
    ...    ndc=${ndc}
    ...    vendor=${vendor}
    ...    order_qty=${order_qty}
    Config My Cart
    Submit Order

Go Order
    Click Element    link:Ordering
    Click Element   link:New Order
    Title Should Be    Build Order

Config Order
    [Arguments]    ${location}    ${ndc}    ${vendor}    ${order_qty}
    Select Customer Account    ${location}
    Find NDC    ${ndc}
    Filter By Vendor    ${Vendor}
    Wait Until Keyword Succeeds    2 times    1    Add Quality     ${order_qty}

Select Customer Account
    [Arguments]    ${customer_account}
    Wait Until Element Is Enabled    id=CustomerId
    Util.Verify Loading And Select By Label    CustomerId    ${customer_account}

Filter By Vendor
    [Arguments]    ${vendor}
    Set Test Variable    ${vendor}
    Wait Until Element Is Enabled    id=VendorAccountId    timeout=10s    error=Select Vendor Is Not Enabled
    Util.Verify Loading And Select By Label    VendorAccountId    ${vendor}
    # Wait Until Keyword Succeeds    5 times    1    Select From List By Label    id=VendorAccountId    ${vendor}

Find NDC
    [Arguments]    ${ndc}
    Wait Until Element Is Enabled    id=SearchValues
    Input Text    id=SearchValues    ${ndc}
    Click Button    Find
    Wait Until Page Does Not Contain Element    (//*[@id="loading-indicator"])[4]    timeout=15s    error=Loading page takes too long
    # Set Test Variable    ${ndc}

Add Quality
    [Arguments]    ${order_qty}
    Util.Scroll To Bottom
    Util.Verify Loading And Select By Label    item_DefaultContractAndVendor    ${vendor}
    Wait Until Element Is Not Visible    //*[@id="loading-indicator" and not(contains(@class,"hidden"))]    timeout=10s
    Input Text    ${SearchOrder_input}    ${order_qty}
    ${add_qty_js}    SeleniumLibrary.Get Element Attribute    ${AddQty_button}    onclick
    execute Javascript    ${add_qty_js}

# Verify Vendor
#     [Arguments]    ${expect}
#     ${actual}=    Get Selected List Label    id=VendorAccountId
#     Should Be Equal    ${actual}    ${expect}

Config My Cart
    Wait Until Element Is Enabled    link:Order Note    timeout=15s    error=Loading page takes too long
    ${date_time}=    Get Current Date Time
    ${po_number}=    Set Variable    AT-${date_time}
    Set Test Variable    ${po_number}
    Config PO Number ${po_number}

Config PO Number ${po_number}
    Wait Until Element Is Enabled    id=SetDistibutorPONumberButton
    ${set_distributor_po_number_js}    SeleniumLibrary.Get Element Attribute    id=SetDistibutorPONumberButton    onclick
    execute Javascript    ${set_distributor_po_number_js}
    Wait Until Page Contains Element    //*[@aria-hidden="false"]//*[@id="modalDialogText"]    timeout=15s    error=Loading page takes too long
    Util.Input Text When Enabled    locator=//*[@aria-hidden="false"]//*[@id="modalDialogText"]    text=${po_number}
    Click Button    Save

# Config Acc Number ${po_number}
#      Wait Until Keyword Succeeds    5s    1s    Click Button     id=SetDistibutorAccountNumberButton
#     Wait Until Page Contains Element    //*[@id="modalDialogLabel"]    timeout=15s    error=Loading page takes too long
#     Wait Until Keyword Succeeds    5s    1s    Element Text Should Be    //*[@id="modalDialogLabel"]    Nan Tech : Account Number
#     Input Text    //*[@id="modalDialogText"]    ${po_number}
#     Click Button    Save
Get Current Date Time
    ${date}=    Get Time Now   result_format=%m%d%H%M
    RETURN    ${date}

Submit Order
    Wait Until Element Is Enabled    link:Submit Order
    Wait Until Keyword Succeeds    5s    1s    Click Element    link: Submit Order
    Wait Until Keyword Succeeds    15s    3s    Handle Alert And Return Its Text
    # Wait Until Page Contains Element    //*[@id="processing-indicator"]    timeout=30s    error=Loading page takes too long
    Wait Until Page Does Not Contain Element   //*[@id="processing-indicator"]    timeout=60s    error=Loading page takes too long
    Waiting For Loading


Cancel Build Order
    Wait Until Element Is Enabled    link: Cancel Build
    Wait Until Keyword Succeeds    15s    3s    Click Element    link: Cancel Build
