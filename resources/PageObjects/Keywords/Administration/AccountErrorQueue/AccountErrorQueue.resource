*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${emr_mapping}    //select[@id='EMRMapping']
${startdate_error_queue}    //*[@id='StartDate']
${account_error_list}    //*[@id='AccountErrorQueueList']
${note_input}    (//*[@id="AccountErrorQueueList"]//following::textarea)[1]

*** Keywords ***
Go To Account Error Queue
    Click Element    link:Administration
    Click Element    link:Account Error Queue

Select EMR Mapping
    [Arguments]    ${emr_arg}
    Sleep    2s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${emr_mapping}    ${emr_arg}
    Waiting For Loading

Select Location Account Error Queue
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    //*[@id="AccountID"]   ${location_arg}
    Waiting For Loading

# Select Location Account Error Queue
#     [Arguments]    ${location_arg}
#     Wait Until Keyword Succeeds    30s    1s    Click Element    //button[@data-id]
#     Wait Until Keyword Succeeds    30s    1s    Click Element    //*[contains(@class,'selected active')]//span[contains(text(),'${location_arg}')]

Check DatePicker Account Error
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //button[contains(text(),'Done')]
    Run Keyword If    ${is_visible}    Click Element    //button[contains(text(),'Done')]

Input Notes
    Clear Input Field Until Empty    ${note_input}
    ${note_txt}    Util.Generate Meaningful Alpha Description    note_txt    3
    Input Text Into Field    ${note_input}    ${note_txt}
    Press Keys    None    TAB
    Common.Page Alert Message    Note has been added!

Check Account Error List Displays
    [Arguments]    ${emr_arg}    ${location_arg}
    Select EMR Mapping    ${emr_arg}
    Select Location Account Error Queue    ${location_arg}
    Clear Input Field Until Empty    ${startdate_error_queue}
    Check DatePicker Account Error
    Waiting For Loading
    Wait Until Element Is Visible    ${account_error_list}
    Input Notes
