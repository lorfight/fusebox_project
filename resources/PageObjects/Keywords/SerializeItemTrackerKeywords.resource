*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py

Variables    ../Locators/SerializeItemTrackerLocator.py
Variables    ../Locators/CommonLocator.py
Variables    ../TestData/Testdata.py

Resource    ../../../libraries/Util.resource

*** Keywords ***
# Behaviour

## Inventory Reconcile
Verify Go Inventory Reconcile
    Title Should Be    Inventory Reconcile Ledger

    
Select Inventory
    [Arguments]    ${inventory_name}
    Wait Until Element Is Enabled    //a[contains(text(),"${inventory_name}")]
    Scroll Element Into View    //a[contains(text(),"${inventory_name}")]
    Click Element    //a[contains(text(),"${inventory_name}")]


## Serialize Item Tracker
Open Serialize Item Tracker
    Wait Until Element Is Enabled    ${ShowSerializeItem}
    Click Element    ${ShowSerializeItem}
    Wait Until Element Is Visible    //*[contains(text(),"Serialized Item Tracker") and not(contains(@class,"hidden"))]    timeout=30s

Close Serialize Item Tracker
    Wait Until Element Is Enabled    ${CloseSerializeItem}
    SeleniumLibrary.Click Button    ${CloseSerializeItem}

Go Tab Pricing Item
    Wait Until Element Is Enabled    ${PricingItemTab}
    Click Element    ${PricingItemTab}

Go Tab Lost Item
    Wait Until Element Is Enabled    ${LostItemTab}
    Click Element    ${LostItemTab}

Get Maximized Page Size
    [Arguments]    ${screen}
    Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//div[@class='pager-navigation']    timeout=30s
    ${html_content}=    SeleniumLibrary.Get Element Attribute    xpath=//div[@id='${screen}']//div[@class='pager-navigation']    outerHTML
    ${maximize_page_size}=    Get Max Page Size    ${html_content}
    RETURN    ${MAXIMIZE_PAGE_SIZE}

Get Medication From Table Serialize
    # Get list Medication for search
    ${list_ndc}=    Create List
    Wait Until Element Is Enabled    ${SerializedTable}    timeout=60s
    ${html_table}=    SeleniumLibrary.Get Element Attribute    ${SerializedTable}    outerHTML  
    ${ndcs}=   Get Ndc From Html Table    ${html_table}    serialized_table
    Convert To List    ${ndcs}
    ${list_ndc}    Combine Lists    ${list_ndc}    ${ndcs}    
    ${list_ndc}=    Remove Duplicates    ${list_ndc}
    RETURN    ${list_ndc}

Get Barcode From Table Serialize
    ${list_barcode}=    Create List
    Wait Until Element Is Enabled    ${SerializedTable}    timeout=60s
    ${count}=    Get WebElements    ${CopyBarcode}
    FOR   ${var}    IN    @{count}
        ${barcode}=    SeleniumLibrary.Get Element Attribute    ${var}    data-barcode
        Append To List    ${list_barcode}    ${barcode}
    END
    RETURN    ${list_barcode}

Get Barcode From Table Serialize In Tab Lost Item Tracker
    ${list_barcode}=    Create List
    Wait Until Element Is Enabled    //*[@id='LostItemTab']//table    timeout=60s
    ${count}    Get WebElements    //*[@id='LostItemTab']//span[contains(@class, 'copyBarcodeToClipboard')]
    FOR   ${var}    IN    @{count}
        ${barcode}    SeleniumLibrary.Get Element Attribute    ${var}    data-barcode
        Append To List    ${list_barcode}    ${barcode}
    END
    RETURN    ${list_barcode}

Remove prices Less Than 10$
    Wait Until Element Is Enabled    ${RemovePricesLessThanBtn}
    Click Element    ${RemovePricesLessThanBtn}
    
Assign First Price For All Empty Items
    Wait Until Element Is Enabled    ${AssignFirstPriceForALlEmptyItemsBtn}
    Click Element    ${AssignFirstPriceForALlEmptyItemsBtn}
    Wait Until Keyword Succeeds    5 seconds    1 second    Handle Alert And Return Its Text
    Wait Until Element Is Enabled    ${AssignFirstPriceForALlEmptyItemsBtn}

# ------------------- VERIFY ---------------------------
# ------------------------------------------------------

    
Verify Pagination Serialize Item tracker
    ${screen}    Set Variable    LastActivityAccountList
    TRY
        Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//div[@class='pager-navigation']    timeout=60s
        ${html_content}=    SeleniumLibrary.Get Element Attribute    xpath=//div[@id='${screen}']//div[@class='pager-navigation']    outerHTML
        ${MAXIMIZE_PAGE_SIZE}=    Get Max Page Size    ${html_content}
        FOR    ${page}    IN RANGE    1    ${MAXIMIZE_PAGE_SIZE}+1
            Click Page    ${page}    ${screen}
        END
        Click Element    xpath=//div[@id='${screen}']//a[@data-pageno="${MAXIMIZE_PAGE_SIZE}"]
        # Test Prev Page btn
        FOR    ${page}    IN RANGE    1    ${MAXIMIZE_PAGE_SIZE}
            Click Prev Page    ${page}    ${screen}    ${MAXIMIZE_PAGE_SIZE}
        END
        # Test Next Page btn 
        FOR    ${page}    IN RANGE    1    ${MAXIMIZE_PAGE_SIZE}
            Click Next Page    ${page}    ${screen}
        END
    FINALLY
        Close Serialize Item Tracker
    END

Verify Search By Medication
    [Arguments]    ${list_medication}
    ${random_ndc}=    Evaluate  random.sample(${list_medication},1)
    FOR    ${ndc}    IN    @{random_ndc}
        Wait Until Element Is Enabled    ${SearchMedicationInput}
        Input Text    ${SearchMedicationInput}    ${ndc}
        Wait Until Element Is Enabled    ${SearchMedicationBtn}
        SeleniumLibrary.Click Button    ${SearchMedicationBtn}
        Wait Until Element Is Not Visible    //*[@id="LastActivityAccountList"]/div/div/i    timeout=60s
        ${table}=    SeleniumLibrary.Get Element Attribute    ${LastActivityTable}    outerHTML  
        ${ndcs_searched}=   Get Ndc From Html Table    ${table}    serialized_table
        ${ndcs_searched}=    Convert To List    ${ndcs_searched}
        Length Should Be    ${ndcs_searched}    1
        ${ndcs_searched_0}=    Get From List    ${ndcs_searched}    0
        Should Be Equal    ${ndcs_searched_0}    ${ndc}
        SeleniumLibrary.Click Button    ${ClearSearchMedicationBtn}
        Sleep    2
    END

Verify Search By Barcode
    [Arguments]    ${list_barcode}
    ${random_barcode}=    Evaluate  random.sample(${list_barcode},1)
    FOR    ${barcode}    IN    @{random_barcode}
        Wait Until Element Is Enabled    ${SearchBarcodeInput}
        Input Text    ${SearchBarcodeInput}    ${barcode}
        Wait Until Element Is Enabled    ${SearchBarcodeBtn}
        SeleniumLibrary.Click Button    ${SearchBarcodeBtn}
        Wait Until Element Is Not Visible    //*[@id="LastActivityAccountList"]/div/div/i    timeout=60s
        ${barcode_searched}    Get Barcode From Table Serialize
        Length Should Be    ${barcode_searched}    1
        ${barcode_searched_0}=    Get From List    ${barcode_searched}    0
        Should Be Equal    ${barcode_searched_0}    ${barcode}
        SeleniumLibrary.Click Button    ${ClearSearchBarcodeBtn}
    END

Verify Search By Barcode In Tab Lost Item Tracker
    [Arguments]    ${list_barcode}
    ${random_barcode}=    Evaluate  random.sample(${list_barcode},1)
    FOR    ${barcode}    IN    @{random_barcode}
        Wait Until Element Is Enabled    ${SearchBarcodeInput}
        Input Text    ${SearchBarcodeInput}    ${barcode}
        Wait Until Element Is Enabled    ${SearchBarcodeBtn}
        SeleniumLibrary.Click Button    ${SearchBarcodeBtn}
        Wait Until Element Is Not Visible    //*[@id="LostItemList"]/div/div/i    timeout=60s
        ${barcode_searched}    Get Barcode From Table Serialize In Tab Lost Item Tracker
        Length Should Be    ${barcode_searched}    1
        ${barcode_searched_0}    Get From List    ${barcode_searched}    0
        Should Be Equal    ${barcode_searched_0}    ${barcode}
        SeleniumLibrary.Click Button    ${ClearSearchBarcodeBtn}
    END

Verify Tab Lost Item Tracker Successfully
    Wait Until Page Contains Element    //*[@id="LostItemList"]//*[contains(text(),"Total Value of Lost Items:")]    30s
Verify Close Serialize Item Tracker Successfully
    Wait Until Element Is Not Visible    30s    1    xpath=//*[text()="Serialized Item Tracker"]

Verify Sort Pricing Serialize Item by
    [Arguments]    ${sort_by}
    ${screen}    Set Variable    PricingAccountList
    Wait Until Element Is Enabled    xpath=//select[@id="SortSerializedItemPricing"]    120s
    Select From List By Value    xpath=//select[@id="SortSerializedItemPricing"]    ${sort_by}
    ${selected_order_0}=    Wait Until Keyword Succeeds    20s    1    Get Text    xpath=//select[@id="SortSerializedItemPricing"]//option[@selected="selected"]
    ${maximize_page_size}=    Get Maximized Page Size    ${screen}
    FOR    ${page}    IN RANGE    1    ${MAXIMIZE_PAGE_SIZE}+1
        Click Page    ${page}    ${screen}
        ${selected_order_1}=    Wait Until Keyword Succeeds    60s    10s    Get Text    xpath=//select[@id="SortSerializedItemPricing"]//option[@selected="selected"]
        Should Be Equal    ${selected_order_0}    ${selected_order_1}
    END