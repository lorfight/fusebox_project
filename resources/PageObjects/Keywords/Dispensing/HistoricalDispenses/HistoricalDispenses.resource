*** Settings ***
Resource    ../../Layers/AppointmentOrderingLedger/AppointmentOrderingLedger.resource

*** Variables ***
${exit_history_mode_btn}    //a[text()='Exit History Mode']

*** Keywords ***
Click Exit History Mode Button
    Common.Scroll And Click Element    ${exit_history_mode_btn}
