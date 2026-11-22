*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${intake_location}    //*[@id='IntakeLocation']
${intake_search_btn}    //*[@id='SearchIntakeBtn']
${view_document_btn}    (//*[@class and contains(text(),'Documents')])[1]

*** Keywords ***
Go To Intake Status Queue
    Click Element    link:Administration
    Click Element    link:Intake Status Queue

Filter Location In Intake Status Queue
    [Arguments]    ${location_arg}
    Select From List By Label    ${intake_location}    ${location_arg}

Click Search Intake Status Queue
    Scroll And Click Element    ${intake_search_btn}

Click View Document
    Wait Until Element Is Visible    ${view_document_btn}    30s
    Scroll And Click Element    ${view_document_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Patient Document Center')]
    Scroll And Click Element    //*[@id='ModalPopup']//*[@id='CloseBtn']

Check Intake Status Queue Displays
    [Arguments]    ${location_arg}
    Filter Location In Intake Status Queue    ${location_arg}
    Click Search Intake Status Queue
    Click View Document
