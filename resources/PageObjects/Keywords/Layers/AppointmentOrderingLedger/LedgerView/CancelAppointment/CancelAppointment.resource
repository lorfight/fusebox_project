*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${reason_select}    //select[@id='Reason']
${additional_note}    //*[@id='AdditionalNote']
${cancel_appointment_btn}    //*[@id='SaveBtn' and text()='Cancel Appointment']

*** Keywords ***
Select Reason
    [Arguments]    ${reason_arg}
    Wait Until Element Is Enabled    ${reason_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${reason_select}    ${reason_arg}

Input Additional Note
    [Arguments]    ${note_arg}
    Wait Until Element Is Visible    ${additional_note}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${additional_note}    ${note_arg}

Cancel Appointment
    [Arguments]    ${reason_arg}    ${note_arg}
    Select Reason    ${reason_arg}
    Input Additional Note    ${note_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${cancel_appointment_btn}
    Common.Page Alert Message    Appointment Canceled!