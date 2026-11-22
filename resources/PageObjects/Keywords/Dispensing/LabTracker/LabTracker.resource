*** Settings ***
Resource    ../../Layers/LabTracker/LabTracker.resource

*** Keywords ***
Open Lab Tracker Ledger
    Common.Scroll And Click Element    link:Dispensing
    Common.Scroll And Click Element    link:Lab Tracker
    Title Should Be    Lab Tracker Ledger

Filter Lab Tracker Following Mrn
    [Arguments]    ${location_arg}    ${mrn_arg}
    Filter By Location In Lab Tracker Ledger    ${location_arg}
    Filter By Patient In Lab Tracker Ledger    ${mrn_arg}
    Click Search Button In Lab Tracker Ledger

Check Value Of Stautus Lab Tracker Modal
    [Arguments]    ${file_num}    ${attribute_description_txt}    ${tracker_result}
    ${tracker_ledger_result}    Set Variable    //td[contains(text(),'${attribute_description_txt}')]//following::td[@data-column='3'][1]
    Wait Until Element Is Visible     ${tracker_ledger_result}
    ${tracker_ledger_result_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_result}
    Should Be Equal    ${tracker_ledger_result_txt}    ${tracker_result}
    Common.Close Modal Popup
    ${tracker_ledger_status}    Set Variable    //div[contains(text(),'${file_num}')]//preceding::td[1]//div[1]
    Wait Until Element Is Visible     ${tracker_ledger_status}
    ${tracker_ledger_status_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_status}
    Should Contain    ${tracker_ledger_status_txt}    ABNORMAL