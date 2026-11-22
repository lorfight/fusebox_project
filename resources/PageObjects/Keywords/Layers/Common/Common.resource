*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    String
Library    DateTime
Library    OperatingSystem
Library    ../Fakedata/FakeData.py

*** Keywords ***
Choose Random Value From Select List
    [Arguments]    ${xpath_arg}    ${var_name}    ${dic}
    Wait Until Element Is Enabled    ${xpath_arg}    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${xpath_arg}
    Execute Javascript    window.scrollBy(0, 200)
    ${list_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${xpath_arg}
    ${list_length}    Get Length    ${list_options}
    IF    ${list_length} == 1
        ${selected}    Get From List    ${list_options}    0
    ELSE
        ${selected}    Evaluate    random.choice(${list_options}[1:])
    END
    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${xpath_arg}    ${selected}
    Set To Dictionary    ${dic}    ${var_name}    ${selected}

Page Alert Message
    [Arguments]    ${alert}    ${timeout}=30s
    Wait Until Page Contains    ${alert}    ${timeout}
    Wait Until Page Does Not Contain    ${alert}    ${timeout}

Element Is Not Visible
    [Arguments]    ${element}    ${timeout}=30s
    ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${element}    3s
    Run Keyword If    '${check_visible}' == '${True}'    Wait Until Element Is Not Visible    ${element}    ${timeout}

Get User Name
    ${user_name_element}    Set Variable    //h4[@class='HelloUserMessage']
    Wait Until Element Is Visible    ${user_name_element}    30s
    ${user_name_txt}    Get Text    ${user_name_element}
    ${user_name_txt}    Get Regexp Matches    ${user_name_txt}    (?<=,\ ).*(?=\ of)
    RETURN    ${user_name_txt}[0]

Scroll And Click Element
    [Arguments]    ${element}
    Wait Until Element Is Visible    ${element}    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${element}
    Execute Javascript    window.scrollBy(0, 200)
    ${type_name}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${element}    tagName
    IF    "${type_name}" == "BUTTON"
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${element}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${element}
    END

# Scroll And Click Element Modal
#     [Arguments]    ${element}
#     Wait Until Element Is Visible    ${element}    30s
#     Sleep    1s
#     Execute Javascript    var el = document.evaluate("${element}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; el.scrollIntoView({behavior: "smooth", block: "center"}); setTimeout(() => { window.scrollBy(0, 400); });
#     Wait Until Element Is Enabled    ${element}    10s
#     ${type_name}    Wait Until Keyword Succeeds    30s    1ss    SeleniumLibrary.Get Element Attribute    ${element}    tagName
#     Sleep    1s
#     IF    "${type_name}" == "BUTTON"
#         Wait Until Keyword Succeeds    30s    1s    Click Button    ${element}
#     ELSE
#         Wait Until Keyword Succeeds    30s    1s    Click Element    ${element}
#     END

Input Text Into Field
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    30s
    Scroll Element Into View    ${locator}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${locator}    ${text}

Clear Input Field Until Empty
    [Arguments]    ${locator}
    Scroll And Click Element    ${locator}
    Press Keys    ${locator}    CTRL+A+BACKSPACE
    ${value}     Get Value     ${locator}
    IF    '${value}' != '${EMPTY}'
        Clear Input Field Until Empty    ${locator}
    ELSE
        Should Be Empty    ${value}
    END

Mouse Hover Element
    [Arguments]    ${locator}    ${other_locator}    ${tooltip}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${locator}
    FOR    ${i}    IN RANGE    10
        Mouse Over    ${locator}
        ${check_toolip}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tooltip}    2s
        IF    "${check_toolip}" == "${False}"
            Mouse Over    ${other_locator}
        ELSE IF    "${check_toolip}" == "${True}"
            Exit For Loop
        END
    END

Navigate To The Tab
    [Arguments]    ${tab_name}    ${title_name}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${tab_name}
    Scroll And Click Element    ${tab_name}
    Wait Until Element Is Visible    ${title_name}    30s

Check Elements Visible
    [Arguments]    @{elements}
    FOR    ${element}    IN    @{elements}
        Element Should Be Visible    ${element}
    END

Close Calendar Table
    ${datepicker_table}    Set Variable    //*[@id='ui-datepicker-div']
    ${done_datepicker_btn}    Set Variable    //*[@type='button' and contains(@class,'datepicker') and text()='Done']
    Wait Until Element Is Visible    ${datepicker_table}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${done_datepicker_btn}

Close Modal Popup
    ${close_modal_btn}    Set Variable    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
    Scroll And Click Element    ${close_modal_btn}

Close Ultra SubModal Popup
    ${close_submodal_btn}    Set Variable    //*[@id='UltraSubModalPopup']//*[@id='CloseBtn' and text()='Close']
    Scroll And Click Element    ${close_submodal_btn}

Close SubModal Popup
    ${close_submodal_btn}    Set Variable    //*[@id='SubModalPopup']//*[@id='CloseBtn' and text()='Close']
    Scroll And Click Element    ${close_submodal_btn}

Return Previous Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}

Open New Window
    [Arguments]    ${title_arg}
    Execute Javascript    window.open(window.location.href, '_blank')
    Switch Window    NEW
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}

Choose Date In Onset Date Input
    [Arguments]    ${date_arg}
    Wait Until Element Is Visible    //div[@id='ui-datepicker-div']    30s
    ${datetime}    Convert Date    ${date_arg}    result_format=datetime    date_format=%m/%d/%Y
    ${date}    Handle Datetime Format    fmt={d}    dt=${datetime} 
    ${date_choose}    Set Variable    //td[@data-handler='selectDay']/a[text()='${date}']
    Wait Until Element Is Visible    ${date_choose}    30s
    Click Element    ${date_choose}