*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${electronic_appointment_location_select}    //select[@id="CurrentAccount"]
${date_of_service_input}    //input[@id="DateOfService"]
${appointment_list_table}    //div[@id="AppointmentList"]

*** Keywords ***
Go To Electronic Dispense Sheet
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Electronic Dispense Sheet

Go To Electronic Dispense Records Page
    Switch Window    title=Electronic Dispense Records
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Electronic Dispense Records
    Set Window Size    1920    1080

Verify Appointment List View Successfully
    Wait Until Element Is Visible    ${electronic_appointment_location_select}    30s
    Wait Until Element Is Visible    ${date_of_service_input}    30s
    Wait Until Element Is Visible    ${appointment_list_table}    30s

Close Electronic Dispense Records Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}
