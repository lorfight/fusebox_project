*** Settings ***
Resource    LedgerView/LedgerView.resource
Resource    ScheduleNewAppointment/ScheduleNewAppointment.resource
Resource    ScheduledAppointmentOrdering/ScheduledAppointmentOrdering.resource
Resource    Manage/Manage.resource
Resource    DispenseNow/DispenseNow.resource

*** Variables ***
${selectlocation_select}    //*[@id='LocationID']
${filter_location_select}    //*[@id='MemberId']
${filter_medication_select}    id=Medication
${filter_patient_select}    id=PatientId
${clear_patient_btn}    //*[contains(@class,'patientClearButton') and @type='button']
${filter_status_select}    id=StatusId
${filter_startdate_input}    //*[@id='StartDate']
${filter_enddate_input}    //*[@id='EndDate']
${datepicker_close}    //button[text()='Done']
${early_apt_checkbox}    //*[@id='showEarly']
${canceled_apt_checkbox}    //*[@id='showCanceled']
${search_apt_link}    link:Search
${sao_title}    //h4[text()='Scheduled Appointment Ordering']
${apt_loading}    //*[@id='AppointmentList']//*[contains(@class,'fa-spinner')]
${apt_list}    //*[@id='AppointmentList']//table[contains(@class,'table-bordered')]
${office_visit_list}    //*[@id='OfficeVisitAppointments']//table[contains(@class,'table-bordered')]
${today_report_button}    //*[@type='button' and normalize-space(text())=\Today's Reports\]
${view_btn}    id=appointmentViewsDropdown
${ledger_select}    //select[@id='AppointmentLedgerView']
${ledger_view}    link:Ledger View
${calendar_view}    link:Calendar View
${checkin_view}    link:Check-In View
${office_visit_view}    link:Office Visit View
${manage_btn}    //*[contains(text(),'Manage') and @type='button']
${manage_therapies_link}    //a[@onclick='TherapyManagementModal()']
${manage_protocol_link}    //a[@onclick='ProtocolManagementModal()']
${manage_nursing_schedule_link}    //a[@id="ShowScheduledNursesCalendarButton"]
${manage_regiments_link}    //a[@onclick='RegimenManagementModal()']
${manage_encounter_note_visibility_link}    //a[@onclick='LoadEncounterNoteTemplateModal()']
${apt_page_close_btn}    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
${dispense_now_btn}    //*[contains(text(),'Dispense Now ') and @onclick]

*** Keywords ***
Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    Click Element    link:Ordering
    Click Element   link:Scheduled Appointment Ordering
    Title Should Be    Appointment Ordering Ledger

Go To Appointment Ordering Ledger Via New Dispense Link
    Click Element    link:Dispensing
    Click Element   link:New Dispense
    Title Should Be    Appointment Ordering Ledger
    
Go To Appointment Ordering Ledger Via Historical Dispenses Link
    Click Element    link:Dispensing
    Click Element   link:Historical Dispenses
    Title Should Be    Appointment Ordering Ledger
    Wait Until Element Is Visible    //li[text()='Historical Appointment Ledger']

Go To Scheduled Appointment Ordering
    Common.Scroll And Click Element   link:Scheduled Appointment Ordering
    Wait Until Element Is Visible    ${sao_title}    30s

Go To Schedule New Appointment
    Scroll Element Into View    link: Schedule New Appointment
    Wait Until Element Is Visible    link: Schedule New Appointment    30s
    Click Element    link: Schedule New Appointment
    Common.Element Is Not Visible    //div[@id="SchduleDosageContainer"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Go To Therapy Management Modal
    Common.Scroll And Click Element    ${manage_btn}
    Common.Scroll And Click Element    ${manage_therapies_link}
    Wait Until Element Is Visible    //h4[text()='Therapy Management Modal']    30s

Go To Protocol Management Modal
    Common.Scroll And Click Element    ${manage_btn}
    Common.Scroll And Click Element    ${manage_protocol_link}
    Wait Until Element Is Visible    //h4[text()='Protocol Management Modal']    30s

Go To Number of Nurses Available Modal
    Common.Scroll And Click Element    ${manage_btn}
    Common.Scroll And Click Element    ${manage_nursing_schedule_link}
    Wait Until Element Is Visible    //h4[text()='Number of Nurses Available']    30s

Go To Regimen Management Modal
    Common.Scroll And Click Element    ${manage_btn}
    Common.Scroll And Click Element    ${manage_regiments_link}
    Wait Until Element Is Visible    //h4[text()='Regimen Management']    30s

Go To Encounter Note Visibility Settings Modal
    Common.Scroll And Click Element    ${manage_btn}
    Common.Scroll And Click Element    ${manage_encounter_note_visibility_link}
    Wait Until Element Is Visible    //h4[text()='Encounter Note Visibility Settings']    30s

Go To Dispense Now
    Wait Until Element Is Visible    ${dispense_now_btn}    10s
    Click Element    ${dispense_now_btn}
    Wait Until Element Is Visible    //h4[text()='Dispense Medication To Patient']    30s

Filter By Location
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${filter_location_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_location_select}    ${location_arg}

Filter By Medication
    [Arguments]    ${medication_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_medication_select}    ${medication_arg}

Filter By Status
    [Arguments]    ${status_arg}
    Wait Until Element Is Enabled    ${filter_status_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_status_select}    ${status_arg}

Filter By Patient APT Page
    [Arguments]    ${patient_arg}
    Wait Until Element Is Enabled    ${filter_patient_select}
    ${check}    Run Keyword And Return Status    Click Button   ${clear_patient_btn}
    IF    ${check} == ${True}
        No Operation
    ELSE
        Clear Element Text    ${filter_patient_select}
    END
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_patient_select}    ${patient_arg}
    ${patient_info}    Set Variable    //*[contains(@class,'suggestion') and contains(@class,'selectable') and *[contains(text(),'${patient_arg}')]]
    Wait Until Element Is Visible    ${patient_info}    30s
    Click Element    ${patient_info}

Filter By Date Range
    [Arguments]    ${date_arg}    
    Wait Until Element Is Enabled    ${filter_startdate_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_startdate_input}    ${date_arg}
    Common.Close Calendar Table
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_enddate_input}    ${date_arg}
    Common.Close Calendar Table

Click Search Button
    Wait Until Element Is Visible    ${search_apt_link}    10s
    Click Element    ${search_apt_link}

Select Ledger View
    Wait Until Element Is Enabled    ${view_btn}    timeout=30s
    Scroll Element Into View    ${view_btn}
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${view_btn}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Ledger View    strip_spaces=True
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${view_btn}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${ledger_view}
    END

Select Tall View
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${view_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${ledger_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${ledger_select}    Tall View

Select Condensed View
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${view_btn}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${ledger_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${ledger_select}    Condensed View
    Click Element    ${search_apt_link}

Select Calendar View
    Scroll Element Into View    ${view_btn}
    Wait Until Element Is Visible    ${view_btn}    60s
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${view_btn}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Calendar View    strip_spaces=False
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${view_btn}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${calendar_view}
    END

Select Check-In View
    Scroll Element Into View    ${view_btn}
    Wait Until Element Is Visible    ${view_btn}    60s
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${view_btn}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Check-In View   strip_spaces=False
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${view_btn}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${checkin_view}
    END

Select Office Visit View
    Scroll Element Into View    ${view_btn}
    Wait Until Element Is Visible    ${view_btn}    60s
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${view_btn}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Office Visit View    strip_spaces=False
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${view_btn}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${office_visit_view}
    END

Select Reports
    [Arguments]    ${item_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${item_arg}

Filter Appointment In Ledger View
    [Arguments]    ${location_arg}    ${patient_mrn_arg}    ${apt_date_arg}    ${status_arg}
    Filter By Status    ${status_arg}
    Filter By Location     ${location_arg}
    Filter By Patient APT Page    ${patient_mrn_arg}
    Filter By Date Range    ${apt_date_arg}
    Select Ledger View
    Select Tall View
    Click Search Button