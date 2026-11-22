*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${nurse_location_select}    //select[@id="ScheduledNursesCurrentAccount"]

*** Keywords ***
Select Account In Number of Nurses Available Modal
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${nurse_location_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${nurse_location_select}    ${location_arg}
    
Select Number Of Nurses In Number of Nurses Available Modal
    [Arguments]    ${date_arg}    ${number_arg}
    ${nurse_number_select}    Set Variable    //select[@id="NumberOfNurses" and @data-scheduled-nurses-available-date="${date_arg}"]
    Wait Until Element Is Enabled    ${nurse_number_select}    30s
    ${nurse_number_value}    Get Selected List Label    ${nurse_number_select}
    IF    "${nurse_number_value}" != "0"
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${nurse_number_select}    0
        Common.Page Alert Message    Schedule updated.
    END
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${nurse_number_select}    ${number_arg}
    Common.Page Alert Message    Schedule updated.
