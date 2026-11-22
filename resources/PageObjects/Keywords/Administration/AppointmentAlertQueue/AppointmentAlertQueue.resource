*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${filter_location}    //*[@id='AccountID']
${alert_queue_search_btn}    //*[@id='SearchAlertQueueBtn']
${view_history_btn}    (//*[@onclick and contains(text(),'View History')])[1]

*** Keywords ***
Go To Appointment Alert Queue
    Click Element    link:Administration
    Click Element    link:Appointment Alert Queue

Filter Location In Appointment Alert Queue
    [Arguments]    ${location_arg}
    Select From List By Label    ${filter_location}    ${location_arg}

Click Search Alert Queue
    Scroll And Click Element    ${alert_queue_search_btn}

Click View History
    Wait Until Element Is Visible    ${view_history_btn}
    Scroll And Click Element    ${view_history_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Appointment Alert Queue History')]
    Scroll And Click Element    //*[@id='SubModalPopup']//*[@id='CloseBtn']

Check Alert Queue History Displays
    [Arguments]    ${location_arg}
    Filter Location In Appointment Alert Queue    ${location_arg}
    Click Search Alert Queue
    Click View History
