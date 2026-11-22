*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot    #edt
Library    ./CustomLibrary.py
Library    OperatingSystem
Library    requests        
Library    Collections
Library    String
Library    DateTime

Variables    ../resources/PageObjects/Locators/CommonLocator.py
Variables    ../resources/PageObjects/TestData/Testdata.py
*** Variables ***
${condition_loading}    //*[@class="ajax-loader"]
${alert_message_xpath}   //span[@data-notify="message"] 

*** Keywords ***

Waiting For Loading
    [Arguments]    ${timeout}=60s    ${error}=Page did not finish loading in 
    Wait Until Page Does Not Contain Element    ${condition_loading}    timeout=${timeout}    error=${error} ${timeout}

Get Text Alert Message
    Wait Until Element Is Visible    ${alert_message_xpath}    30s
    ${alert_message}    Get Text    ${alert_message_xpath}
    RETURN    ${alert_message}

Wait Alert Message Show And Disappear
    [Arguments]    ${message}
    Wait Until Page Contains Element   ${alert_message_xpath}    30s
    Wait Until Element Contains    ${alert_message_xpath}    ${message}    30s
    Wait Until Page Does Not Contain     ${alert_message_xpath}    30s

Handle Alert And Return Its Text
    ${alert_text}=    Handle Alert
    RETURN    ${alert_text}
Select Location
    [Arguments]    ${locator_location}    ${location}
    Wait Until Element Is Enabled    id=${locator_location}
    Select From List By Label    id=${locator_location}    ${location}

Click Page
    [Arguments]    ${page_number}    ${screen}
    Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//a[@data-pageno="${page_number}"]
    Click Element    xpath=//div[@id='${screen}']//a[@data-pageno="${page_number}"]
    Wait Until Page Contains Element    xpath=//div[@id='${screen}']//a[@class="selected" and @data-pageno="${page_number}"]    timeout=120s
    ${selected_page}    Get Text    xpath=//div[@id='${screen}']//a[@class="selected"]
    Should Be Equal As Numbers    ${selected_page}    ${page_number}

Click Next Page
    [Arguments]    ${page_number}    ${screen}
    Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//a[contains(text(), "Next")]    timeout=120s
    Click Element    xpath=//div[@id='${screen}']//a[contains(text(), "Next")]
    Wait Until Page Contains Element    xpath=//div[@id='${screen}']//a[@class="selected"]    timeout=120s
    Sleep    1
    ${selected_page}    Get Text    xpath=//div[@id='${screen}']//a[@class="selected"]
    ${expected_page}=    Evaluate    int(${page_number}) + 1
    Should Be Equal As Numbers    ${selected_page}    ${expected_page}

Click Prev Page
    [Arguments]    ${page_number}    ${screen}    ${MAXIMIZE_PAGE_SIZE}
    Wait Until Element Is Enabled    xpath=//div[@id='${screen}']//a[contains(text(), "Prev")]    timeout=120s
    Click Element    xpath=//div[@id='${screen}']//a[contains(text(), "Prev")]
    Wait Until Page Contains Element    xpath=//div[@id='${screen}']//a[@class="selected"]    timeout=120s
    Sleep    1
    ${selected_page}    Get Text    xpath=//div[@id='${screen}']//a[@class="selected"]
    ${expected_page}=    Evaluate    int(${MAXIMIZE_PAGE_SIZE}) - int(${page_number})
    Should Be Equal As Numbers    ${selected_page}    ${expected_page}

Verify Location
    [Arguments]     ${locator}    ${location_expected}   
    ${location_expected}    Set Variable    ${location}
    ${location_actual}=    Get Selected List Label    id=${locator}
    Should Be Equal    ${location_actual}    ${location_expected}

Download Report CSV SuccessFully
    [Documentation]    FB_05	Verify Full Items Reconcile
    [Arguments]   ${file_name}
    # Set up case
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    ${export_path}=    Join Path    ${export_path}    ${file_name}
    ${exists}=    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
    Wait Until Element Is Visible    xpath=//*[@id='reportViewer1']//div[contains(text(),'Done. Total')]    timeout=1min
    Sleep    4
    Wait Until Element Is Enabled   ${DropdownExport}
    Double Click Element    ${DropdownExport}
    Sleep    2
    Click Element    ${ExportCSV}
    Wait Until Created    ${export_path}    timeout=1 min
    File Should Exist    ${export_path}
    RETURN    ${export_path}

Scroll To Bottom
    Execute Javascript    window.scrollTo(0,document.body.scrollHeight)
    Sleep    2
Scroll To Top
    Execute Javascript    window.scrollTo(0,0)
    Sleep    2

# Handle Scan Barcode Reconcile
#     [Arguments]    ${barcode}
#     ${orig_timeout}=    Set Selenium Timeout    20 seconds
#     Execute Javascript    var callback= arguments[arguments.length - 1]; handleScan('${barcode}'); setTimeout(function() { callback(); }, 10000);
#     Set Selenium Timeout    ${orig_timeout}

Handle Scan Barcode Reconcile
    [Arguments]    ${barcode}
    Execute Async Javascript
    ...    var done = arguments[arguments.length -1];
    ...    var code = arguments[0];
    ...    Promise.resolve(handleScan(code)).finally(done);
    ...    ARGUMENTS    ${barcode}
    

Handle Scan List Barcode
    [Arguments]    ${list_barcode}
    ${orig_timeout}=    Set Selenium Timeout    80 seconds
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${list_barcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 60000);
    Set Selenium Timeout    ${orig_timeout}

Send GET Request And Verify Status Code
    TRY
        ${url}=    Set Variable    ${SiteUrl}
        GET    ${url}
    EXCEPT    HTTPError: 503 Server Error: Service Unavailable for url: ${url}
        Set Test Message    Service Unavailable
    EXCEPT    HTTPError: 400 Client Error: Bad Request for url: ${url}
        Set Test Message    Bad Request
    EXCEPT    HTTPError: 403 Client Error: Site Disabled for url: ${url}
        Set Test Message    Bad Request
    END

Input And Verify
    [Arguments]    ${text}    ${locator_input}
    Wait Until Element Is Enabled    ${locator_input}    timeout=10s
    Input Text    ${locator_input}    ${text}
    ${input_value}   SeleniumLibrary.get element attribute    ${locator_input}      value
    Should Be Equal    ${text}    ${input_value}

Verify Loading And Select By Label
    [Arguments]    ${locator}    ${selected_label}
    ${contains_xpath}=    Run Keyword And Return Status    Should Contain    ${locator}    xpath
    IF    ${contains_xpath} == ${False}
        ${locator}=    Set Variable    id=${locator}
    END
    @{list_label}=    Get List Items    ${locator}
    ${first_element}=    Get From List    ${list_label}    0
    ${list_length}=     Get Length    ${list_label}
    ${first_item_is_selected}    Run Keyword And Return Status    Should Contain    ${first_element}    Select
    Run Keyword if   ${list_length} <= ${1} and ${first_item_is_selected} == ${True}
    ...    Fail    No item in list
    FOR    ${element}    IN    @{list_label}
        ${Condition}=     Run Keyword And Return Status
        ...    Should Contain    ${element}    ${selected_label}
        IF    ${Condition} == ${True}
            Wait Until Keyword Succeeds    10s    2    Select From List By Label    ${locator}    ${element}
            RETURN    ${element}
            BREAK
        END
    END
    RETURN    ${element}

Search Item
    # Field_search: Item Filter:, Status Filter:, Search for an Order:, Filter By Distributor:, Filter By Member:, Filter By Date Range:
    # Value2 is end date
    [Arguments]    ${field_search}    ${value1}    ${value2}
    @{list_field_search}    Set Variable    Filter By Sender    Filter By File Type    Filter By Location    Status Filter    Filter By Status


    @{xpath_item_search}    Set Variable    //div[label[contains(text(),'${field_search}')]]//input
    ...    //div[label[contains(text(),'${field_search}')]]//select[not(contains(@class,"hideBoxShadows"))]//option[contains(text(),'${value1}')]

    IF    "${field_search}" in "@{list_field_search}"
        ${item_search}    Get WebElement    ${xpath_item_search}[1]
        Click Button    ${item_search}
    ELSE
        ${item_search}    Get WebElement    ${xpath_item_search}[0]
        IF    "${field_search}" in "Filter By Date Range"
            ${End_day}    Get WebElement    //input[@id="EndDate"]
            Input Text    ${item_search}    ${value1}
            Input Text    ${End_day}    ${value2}
        ELSE
            Input Text    ${item_search}    ${value1}
        END
        Press Keys    NONE    RETURN
    END

Scroll Into View
    # type ScrollBehavior = "auto" | "instant" | "smooth";
    # type ScrollLogicalPosition = "center" | "end" | "nearest" | "start";
    [Arguments]    ${locator}    ${behavior}=smooth    ${block}=start    ${inline}=nearest
    ${options}=    Evaluate    {"behavior": "${behavior}", "block": "${block}", "inline": "${inline}"}    json
    Execute JavaScript    document.evaluate(${locator}, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.scrollIntoView(${options}); 
    Sleep    2

Input Text When Enabled
    [Arguments]    ${locator}    ${text}
    Wait Until Page Contains Element    ${locator}    timeout=20s
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Enabled    ${locator}    timeout=10s
    Run Keyword If    '${status}' == 'True'    Input Text    ${locator}    ${text}

Replace Xpath
    [Arguments]    ${xpath}
    ${xpath}    Replace Variables    ${xpath}
    RETURN    ${xpath}    #replace variables in xpath with their value

Wait For Page Loading
    [Arguments]    ${element_arg}    ${keyword_arg_1}    ${keyword_arg_2}    ${timeout_arg}
    ${check}    Run Keyword And Return Status    ${keyword_arg_1}    ${element_arg}
    IF    ${check} == ${True}
        Run Keyword    ${keyword_arg_2}    ${element_arg}    ${timeout_arg}
    END

Add To Dictionary
    [Arguments]    ${dic_arg}    ${key_arg}    ${val_arg}
    Set To Dictionary    ${dic_arg}    ${key_arg}=${val_arg}
    Set Suite Variable    ${dic_arg}

Check Time Zone
    ${today_location}    CustomLibrary.Get Time Now
    ${today_location}    Convert Date    ${today_location}    result_format=%m/%d/%Y
    RETURN    ${today_location}

Select Random From List
    [Arguments]    ${xpath_arg}    ${remove_default_arg}
    Sleep    2s
    FOR    ${i}    IN RANGE    10
        ${list_options}    Wait Until Keyword Succeeds    10 times    3s    Get List Items    ${xpath_arg}
        ${is_empty}    Run Keyword And Return Status    Should Not Be Empty    ${list_options}
        IF    ${is_empty} == ${False}
            BREAK
        END
        Sleep    3s
    END
    IF    ${remove_default_arg} == ${True}
        Remove From List    ${list_options}    0
    END
    ${selected}    Evaluate    random.choice(${list_options})
    Wait Until Keyword Succeeds    10 times    3s    Select From List By Label    ${xpath_arg}    ${selected}
    Set Test Variable    ${selected}
    
Check Or Uncheck Box
    [Arguments]    ${view_arg}    ${xpath_arg}
    ${is_checked}    SeleniumLibrary.Get Element Attribute    ${xpath_arg}    checked
    ${check}    Run Keyword And Return Status   Should Be Equal As Strings    ${is_checked}    true
    IF    ${check} == ${True} and ${view_arg} == ${False} or ${check} == ${False} and ${view_arg} == ${True}
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${xpath_arg}
    END
    IF    ${view_arg} == ${True}
        Element Attribute Value Should Be    ${xpath_arg}    checked    true
    END

Scroll Into Element And Click
    [Arguments]    ${xpath_arg}    ${retry_arg}    ${time_arg}    ${kw_arg}
    FOR    ${i}    IN RANGE    1    ${retry_arg}
        Scroll Element Into View    ${xpath_arg}
        ${check}    Run Keyword And Return Status    Element Should Be Visible    ${xpath_arg}
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    ${time_arg}
    END
    Element Should Be Visible    ${xpath_arg}
    FOR    ${i}    IN RANGE    ${retry_arg}
        Sleep    2s
        ${check}    Run Keyword And Return Status    ${kw_arg}    ${xpath_arg}
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    ${time_arg}
    END
    Should Be Equal    ${check}    ${True}

Get User Name
    ${user_name}=    Get Text    //*[@class="HelloUserMessage"]
    ${user_name}=    Get Regexp Matches    ${user_name}    ,\\s*(.*?)\\s+of    1
    RETURN    ${user_name}[0]

Generate Meaningful Alpha Description
    [Arguments]    ${var_name}    ${length}
    ${rand}   Generate Random String   ${length}    [LETTERS]
    ${value}  Catenate    SEPARATOR=    Test    ${rand}
    Set Test Variable    ${${var_name}}    ${value}
    RETURN    ${value}

Get File Name
    [Arguments]    ${file_detail}    ${date_format}
    ${date}    Get Time Now    result_format=%Y_%m_%d_%H%M%S
    ${date}    Convert Date    ${date}    result_format=${date_format}
    # ${date}    Subtract Time From Date    ${date}    13 hour    result_format=${date_format}
    ${file_name}=    Set Variable  ${file_detail}-${date}.xlsx
    RETURN    ${file_name}

Download Report 
    [Arguments]   ${file_name}    ${export_btn_xpath}
    # Set up case
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    ${export_path}=    Join Path    ${export_path}    ${file_name}
    # ${exists}=    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    # Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
    Click Element    ${export_btn_xpath}
    Wait Until Created    ${export_path}    timeout=2 min
    File Should Exist    ${export_path}
    # RETURN    ${export_path}
    Remove File    ${export_path}

Check Latest Download File 
    [Arguments]    ${path}    ${previous_file_count}    ${detail}    ${date}
    Wait Until Keyword Succeeds    30s    1s    Check File Increase For Download    ${path}    ${previous_file_count}

    ${files}    List Files In Directory    ${path}
    ${file_paths}    Create List
    FOR    ${file}    IN    @{files}
        ${full}    Join Path    ${path}    ${file}
        Append To List    ${file_paths}    ${full}

    END
    ${latest}    Evaluate    max(${file_paths}, key=lambda f: os.path.getctime(f))    os
    File Should Exist    ${latest}
    Should Contain    ${latest}    ${detail}-${date}
    RETURN    ${latest}
    #Remove File    ${latest}

Check File Increase For Download
    [Arguments]    ${path}    ${old_count}
    ${current_count}    Count Files In Directory    ${path}
    Should Be True    ${current_count} > ${old_count}

Select Random From List Regression
    [Arguments]    ${xpath_arg}    ${var_name}    ${dic}
    ${list_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${xpath_arg}
    ${list_length}    Get Length    ${list_options}
    IF    ${list_length} == 1
        ${selected}    Get From List    ${list_options}    0
    ELSE
        ${selected}    Evaluate    random.choice(${list_options}[1:])
    END
    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${xpath_arg}    ${selected}
    Set To Dictionary    ${dic}    ${var_name}=${selected}
    Set Suite Variable    ${dic}

Covert Time Now
    [Arguments]    ${format_arg}
    ${today_location}    CustomLibrary.Get Time Now
    ${today_location}    Convert Date    ${today_location}    result_format=${format_arg}
    RETURN    ${today_location}