*** Settings ***
Library    SeleniumLibrary    timeout=10s   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    ../../../libraries/CustomLibrary.py
Library    OperatingSystem
Library    Collections
Library    String
Library    DateTime
Library    requests
Library    ../TestData/Testdata.py
Variables    ../Locators/CommonLocator.py

*** Keywords ***
Get Data
    Log To Console    ${SUITE_NAME}
    ${parts}    Split String    ${SUITE_NAME}    .
    ${SUITE_NAME}    Get From List    ${parts}    -1
    ${data_input}    Testdata.Fetch_Test_Data    suite=${SUITE_NAME}    source=${SUITE_SOURCE}
    RETURN    ${data_input}

Close Browser Session
    Close Browser

Close Browser Sessions
    Close All Browsers

Select Location
    [Arguments]    ${locator_location}    ${location}
    Wait Until Element Is Enabled    id=${locator_location}
    Select From List By Label    id=${locator_location}    ${location}
    Sleep    2

Scroll To Bottom
    # Execute Javascript    window.scrollTo(0,document.body.scrollHeight)
    Execute Javascript    window.scrollTo(0,document.body.scrollHeight)
Scroll To Top
    Execute Javascript    window.scrollTo(0,0)

Handle Scan Barcode Reconcile
    [Arguments]    ${barcode}
    Set Selenium Timeout    10 seconds
    Execute Javascript    handleScan("${barcode}")
    Sleep    5

Handle Scan List Barcode
    [Arguments]    ${list_barcode}
    Set Selenium Timeout    80s
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${list_barcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 60000);

Input And Verify
    [Arguments]    ${text}    ${locator_input}
    Wait Until Element Is Enabled    ${locator_input}    timeout=20s
    Input Text    ${locator_input}    ${text}
    ${input_value}   SeleniumLibrary.get element attribute    ${locator_input}      value
    Should Be Equal    ${text}    ${input_value}


Verify Location
    [Arguments]     ${locator}    ${location_expected}   
    ${location_expected}    Set Variable    ${location}
    ${location_actual}=    Get Selected List Label    id=${locator}
    Should Contain    ${location_actual}    ${location_expected}

Verify Loading And Select By Label
    [Arguments]    ${locator}    ${selected_label}
    Wait Until Element Is Enabled    id=${locator}
    @{list_label}=    Get List Items    id=${locator}
    FOR    ${element}    IN    @{list_label}
        ${Condition}=     Run Keyword And Return Status
        ...    Should Contain    ${element}    ${selected_label}
        IF    ${Condition} == ${True}
            Select From List By Label    id=${locator}    ${element}
            BREAK
        END
    END

Get Current Date Time
    [Arguments]    ${format}
    ${date}=    Get Current Date    result_format=${format}
    RETURN    ${date}


Scroll Into View
    [Documentation]
    ...    \n type ScrollBehavior = "auto" | "instant" | "smooth" 
    ...    \n type ScrollLogicalPosition = "center" | "end" | "nearest" | "start";
    [Arguments]    ${locator}    ${behavior}=smooth    ${block}=start    ${inline}=nearest
    ${options}=    Evaluate    {"behavior": "${behavior}", "block": "${block}", "inline": "${inline}"}    json
    Execute JavaScript    document.evaluate(${locator}, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(${options}); 
    Sleep    2

# Insert User To Worksheet
#     [Arguments]    ${env}    ${user_name}    ${pwd}
#     CustomLibrary.update_user_gs    ${env}    ${user_name}    ${pwd}
