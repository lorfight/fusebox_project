*** Settings ***
Resource    ../../Common/Common.resource
Resource    ../../../../../../libraries/Util.resource
# Library    ../../Fakedata/FakeData.py
# Library    Collections
*** Variables ***
${shcedule_appointment_title}    //h4[text()='Schedule Appointment']
${apt_loading_icon}    //div[@id="SchedulingCalendarLoadingDiv"]
${apt_popup_location_select}    //*[@id='LocationID']
${apt_popup_patient_input}    //input[@id="SelectedPatient"]
${schedule_btn}    //a[@id='ScheduleApptBtn']
${accept_btn}    //button[contains(text(),'Accept')]
${therapy_selected_text}    //*[text()='Selected Therapy']
# ${therapy_select}    id=Therapy #//*[text()='Selected Therapy']
${therapy_select}    //select[@id="Therapy"]
${add_quantity_dosage_input}    xpath://*[contains(@class,'AddonDosageQty')]
${recommended_nurse_select}    //*[@id='AssignedNurse'and contains(@class,'footerSelectors')]
${office_visit_checkbox}    //*[@id='ScheduleOfficeVisit']
${patient_complexity_select}    //*[@id='OfficeVisit']
${provider_select}    //*[@id='AccountProvider']
${normal_date_Box}    //*[@id='AppointmentDate' and contains(@class,'DatePickerRequired')]
${done_filter_date_btn}    //button[text()='Done']
${new_start_time_input}    //*[@id='SchedulerView']//*[@id='RequireTime']
${apt_lenght_select}    //div[@id="SchedulerView"]//select[@id="RequiredLength"]
${apt_location_select}    //*[@id='SchedulerView']//*[@id='Location']
${visit_date_box}    //*[@id='AdditionalAppointmentDate']
${visit_new_start_time_input}    //*[@id='AdditionalRequireTime']
${visit_lenght_select}    id=AdditionalAppointmentLenght
${visit_apt_location_select}    //*[@id='SchedulerView']//*[@id='AdditionalLocation']
${dos_before_suggessted_reason_innput}    //*[@id='ConflictReason']
${save_btn}    //*[@id='SaveBtn' and text()='Continue']
${schedule_alert_popup_header}    //*[text()='Scheduling Alert - Link Appointment']
${standalone_apt_radio_btn}    //div[contains(text(),'Standalone Appointment - Unlinked')]/following-sibling::div/input
${schedule_alert_popup}    //*[@class='modal-title' and text()='Scheduling Alert - Link Appointment']/ancestor::*[@class='modal-content']
${sched_continue_btn}    //button[@id='SaveBtn' and contains(text(),'Continue')]
${begin_scheduling_btn}    //div[@id="ModalPopup"]//following::a[@id="btnApproveAndScheduling"]
${add_to_queue_btn}    //*[@onclick and text()='Add To Queue']
${dos_suggested_alert_title}    //h4[contains(text(),'Scheduling Alert -- Requires Attention')]

*** Keywords ***
Create Appointment Dictionary
    &{appointment_dict}    Create Dictionary
    RETURN    ${appointment_dict}

Select A Location In Schedule Appointment Popup
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${apt_popup_location_select}    ${location_arg}
    
Select A Patient In Schedule Appointment Popup
    [Arguments]    ${patient_arg}
    Wait Until Page Does Not Contain Element    //*[@class="ajax-loader"]    200s
    Common.Clear Input Field Until Empty    ${apt_popup_patient_input}
    Common.Input Text Into Field    ${apt_popup_patient_input}    ${patient_arg}
    ${patient_info_dropdown}    Set Variable    //div[strong[contains(text(),'${patient_arg}')]]
    ${check_patient_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_info_dropdown}    2s
    IF    '${check_patient_visible}' == '${False}'
        Select A Patient In Schedule Appointment Popup    ${patient_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${patient_info_dropdown}
        Wait Until Page Does Not Contain Element    //*[@class="ajax-loader"]    200s
    END

Select Therapy In Schedule Appointment Popup
    [Arguments]    ${therapy_arg}
    Wait Until Element Is Enabled    ${therapy_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${therapy_select}    ${therapy_arg}

Select Therapy Following PO In Schedule Appointment Popup
    [Arguments]    ${therapy_arg}    ${po_number_arg}
    ${option_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    //option[contains(text(),'${po_number_arg}') and contains(text(),'${therapy_arg}') ]
    Wait Until Element Is Enabled    ${therapy_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value    ${therapy_select}    ${option_value}

Input Dosage In Schedule Appointment Popup
    [Arguments]    ${dose_arg}
    Wait Until Element Is Enabled    ${add_quantity_dosage_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${add_quantity_dosage_input}
    Common.Input Text Into Field     ${add_quantity_dosage_input}    ${dose_arg}

Select Recommended Nurse In Schedule Appointment Popup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${recommended_nurse_select}    var_name=Nurse    dic=${dict_arg}

Select Office Visit In Schedule Appointment Popup
    [Arguments]    ${dict_arg}
    Common.Scroll And Click Element    ${office_visit_checkbox}
    Common.Choose Random Value From Select List    xpath_arg=${patient_complexity_select}    var_name=visit_complexity    dic=${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${provider_select}    var_name=visit_provider    dic=${dict_arg}

Click Approve Therapy And Begin Scheduling Button
    Common.Scroll And Click Element    ${begin_scheduling_btn}
    Common.Element Is Not Visible    ${apt_loading_icon}    timeout=120s

Input New Date
    [Arguments]    ${day_arg}
    Common.Clear Input Field Until Empty    ${normal_date_Box}
    Common.Input Text Into Field    ${normal_date_Box}    ${day_arg}
    Common.Close Calendar Table

Input New Start Time
    [Arguments]    ${start_time}
    Common.Clear Input Field Until Empty    ${new_start_time_input}
    Common.Input Text Into Field    ${new_start_time_input}    ${start_time}
    Press Keys    ${new_start_time_input}    RETURN

Select Appointment Length
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${apt_lenght_select}    var_name=apt_lenght_sched    dic=${dict_arg}

Select Appointment Location
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${apt_location_select}    var_name=apt_location_sched    dic=${dict_arg}

Input Office Visit New Date
    [Arguments]    ${day_arg}
    Common.Clear Input Field Until Empty    ${visit_date_box}
    Common.Input Text Into Field    ${visit_date_box}    ${day_arg}
    Common.Close Calendar Table

Input Office Visit New Start Time
    [Arguments]    ${start_time}
    Common.Clear Input Field Until Empty    ${visit_new_start_time_input}
    Common.Input Text Into Field    ${visit_new_start_time_input}    ${start_time}
    Press Keys    ${visit_new_start_time_input}    RETURN

Select Office Visit Length
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${visit_lenght_select}    var_name=visit_lenght_sched    dic=${dict_arg}

Select Office Visit Location
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${visit_apt_location_select}    var_name=visit_location_sched    dic=${dict_arg}

Click Add To Queue Button
    Common.Element Is Not Visible    ${apt_loading_icon}    timeout=120s
    Common.Scroll And Click Element    ${add_to_queue_btn}

Schedule Normal Appointment
    [Arguments]    ${day_arg}    ${start_time}    ${dict_arg}
    Input New Date    ${day_arg}
    Input New Start Time    ${start_time}
    Select Appointment Length    ${dict_arg}
    Select Appointment Location    ${dict_arg}

Schedule OV Appointment
    [Arguments]    ${day_arg}    ${visit_starttime}    ${dict_arg}
    Input Office Visit New Date    ${day_arg}
    Input Office Visit New Start Time    ${visit_starttime}
    Select Office Visit Length    ${dict_arg}
    Select Office Visit Location    ${dict_arg}

Handle DOS Before Suggested Alert
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${dos_suggested_alert_title}    5s
    IF    ${check} == ${True}
        Common.Input Text Into Field    ${dos_before_suggessted_reason_innput}    Testing
        Common.Scroll And Click Element    ${save_btn}
    END
    RETURN    ${check}

Scheduling Alert
    TRY
        Wait Until Element Is Visible    ${schedule_alert_popup_header}    timeout=10s
        Wait Until Keyword Succeeds    30s    1    Select Unlinked Schedule
    EXCEPT
        Log    Scheduling Alert - Link Appointment is not visible
    END

Select Unlinked Schedule
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${standalone_apt_radio_btn}
    ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${schedule_alert_popup}
    FOR    ${i}    IN RANGE    3
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${standalone_apt_radio_btn}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${sched_continue_btn}
        ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${schedule_alert_popup}
        IF    ${Check_Popup_Showed} == ${False}
            BREAK
        END
    END
    Page Should Not Contain    Please select a parent appointment or indicate the appointment as unlinked to continue.    30s

Click Random Button
    Wait Until Element Is Not Visible    ${apt_loading_icon}    30
    ${buttons}    Create List    ${schedule_btn}    ${accept_btn}
    ${random_button}    Evaluate    random.choice(${buttons})
    IF    "${random_button}" == "${schedule_btn}"
        Common.Scroll And Click Element    ${schedule_btn}
    ELSE
        Common.Scroll And Click Element    ${accept_btn}
    END

Schedule Appointment Has Office Visit
    [Arguments]    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${dose_arg}    ${loops}=1
    ${appointment_dict}    Create Appointment Dictionary
    Select A Location In Schedule Appointment Popup    ${location_arg}
    Select A Patient In Schedule Appointment Popup    ${patient_arg}
    Select Therapy In Schedule Appointment Popup    ${therapy_arg}
    Input Dosage In Schedule Appointment Popup    ${dose_arg}
    Select Recommended Nurse In Schedule Appointment Popup    ${appointment_dict}
    Select Office Visit In Schedule Appointment Popup    ${appointment_dict}
    Click Approve Therapy And Begin Scheduling Button
    FOR    ${i}    IN RANGE    ${loops}
        ${result}    Get Incremental Dates
        ${apt_date}    Get From Dictionary    ${result}    current_date
        Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${appointment_dict}
        ${visit_date}    Subtract Time From Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
        Schedule OV Appointment    day_arg=${visit_date}        visit_starttime=11:20 am    dict_arg=${appointment_dict}
        Click Add To Queue Button
        Handle DOS Before Suggested Alert
        IF    ${loops} == 1
            Set To Dictionary    ${appointment_dict}    
                ...    apt_date=${apt_date}
                ...    visit_date=${visit_date}
        ELSE IF    ${loops} > 1
            ${i}    Evaluate    ${i}+1
            Set To Dictionary    ${appointment_dict}    
                ...    apt_date_${i}=${apt_date}    
                ...    visit_date_${i}=${visit_date}
        END
    END
    Click Random Button
    Scheduling Alert
    RETURN    ${appointment_dict}

Schedule Appointment Without Office Visit
    [Arguments]    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${dose_arg}    ${loops}=1    ${po_number_arg}=${None}
    ${appointment_dict}    Create Appointment Dictionary
    Select A Location In Schedule Appointment Popup    ${location_arg}
    Select A Patient In Schedule Appointment Popup    ${patient_arg}
    IF    "${po_number_arg}" == "${None}"
        Select Therapy In Schedule Appointment Popup    ${therapy_arg}
    ELSE
        Select Therapy Following PO In Schedule Appointment Popup    ${therapy_arg}    ${po_number_arg}
    END
    Input Dosage In Schedule Appointment Popup    ${dose_arg}
    Select Recommended Nurse In Schedule Appointment Popup    ${appointment_dict}
    Click Approve Therapy And Begin Scheduling Button
    FOR    ${i}    IN RANGE    ${loops}
        ${result}    Get Incremental Dates
        ${apt_date}    Get From Dictionary    ${result}    current_date
        Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 AM    dict_arg=${appointment_dict}
        Click Add To Queue Button
        Handle DOS Before Suggested Alert
        IF    ${loops} == 1
            Set To Dictionary    ${appointment_dict}    apt_date=${apt_date}    start_time=10:20 AM
        ELSE IF    ${loops} > 1
            ${i}    Evaluate    ${i}+1
            Set To Dictionary    ${appointment_dict}    apt_date_${i}=${apt_date}    start_time${i}=10:20 AM
        END
    END
    Click Random Button
    Scheduling Alert
    RETURN    ${appointment_dict}

# Schedule Appointment Has PO Without Office Visit
#     [Arguments]    ${dict_arg}    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${dose_arg}    ${loops}=1
#     Select A Location In Schedule Appointment Popup    ${location_arg}
#     Select A Patient In Schedule Appointment Popup    ${patient_arg}
#     Select Therapy In Schedule Appointment Popup    ${therapy_arg}
#     Input Dosage In Schedule Appointment Popup    ${dose_arg}    ${dict_arg}
#     Select Recommended Nurse In Schedule Appointment Popup    ${dict_arg}
#     Click Approve Therapy And Begin Scheduling Button
#     FOR    ${i}    IN RANGE    ${loops}
#         ${result}    Get Incremental Dates
#         ${apt_date}    Get From Dictionary    ${result}    current_date
#         Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${dict_arg}
#         Click Add To Queue Button
#         Handle DOS Before Suggested Alert
#         Set To Dictionary    ${dict_arg}    apt_date_${i}=${apt_date}
#     END
#     Click Random Button
#     Scheduling Alert
#     RETURN    ${dict_arg}

# Schedule Appointment Has Office Visit Without PO
#     [Arguments]    ${dict_arg}    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${dose_arg}    ${loops}=1
#     Select A Location In Schedule Appointment Popup    ${location_arg}
#     Select A Patient In Schedule Appointment Popup    ${patient_arg}
#     Select Therapy In Schedule Appointment Popup    ${therapy_arg}
#     Input Dosage In Schedule Appointment Popup    ${dose_arg}    ${dict_arg}
#     Select Recommended Nurse In Schedule Appointment Popup    ${dict_arg}
#     Select Office Visit In Schedule Appointment Popup    ${dict_arg}
#     Click Approve Therapy And Begin Scheduling Button
#     FOR    ${i}    IN RANGE    ${loops}
#         ${result}    Get Incremental Dates
#         ${apt_date}    Get From Dictionary    ${result}    current_date
#         Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${dict_arg}
#         ${visit_date}    Subtract Time From Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
#         Schedule OV Appointment    day_arg=${visit_date}        visit_starttime=11:20 am    dict_arg=${dict_arg}
#         Click Add To Queue Button
#         Handle DOS Before Suggested Alert
#         Set To Dictionary    ${dict_arg}    apt_date_${i}=${apt_date}    visit_date_${i}=${visit_date}
#     END
#     Click Random Button
#     Scheduling Alert
#     RETURN    ${dict_arg}

Schedule Appointment Has No Office Visit With Past Date
    [Arguments]    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${dose_arg}    ${loops}=1    ${po_number_arg}=${None}
    ${appointment_dict}    Create Appointment Dictionary
    Select A Location In Schedule Appointment Popup    ${location_arg}
    Select A Patient In Schedule Appointment Popup    ${patient_arg}
    IF    "${po_number_arg}" == "${None}"
        Select Therapy In Schedule Appointment Popup    ${therapy_arg}
    ELSE
        Select Therapy Following PO In Schedule Appointment Popup    ${therapy_arg}    ${po_number_arg}
    END
    Input Dosage In Schedule Appointment Popup    ${dose_arg}
    Select Recommended Nurse In Schedule Appointment Popup    ${appointment_dict}
    Click Approve Therapy And Begin Scheduling Button
    FOR    ${i}    IN RANGE    ${loops}
        ${result}    Get Incremental Dates
        ${apt_date}    Get From Dictionary    ${result}    past_date
        Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${appointment_dict}
        Click Add To Queue Button
        Handle DOS Before Suggested Alert
        IF    ${loops} == 1
            Set To Dictionary    ${appointment_dict}    apt_date=${apt_date}
        ELSE IF    ${loops} > 1
            ${i}    Evaluate    ${i}+1
            Set To Dictionary    ${appointment_dict}    apt_date_${i}=${apt_date}
        END
    END
    Click Random Button
    Scheduling Alert
    RETURN    ${appointment_dict}

Schedule Appointment Without Therapy
    [Arguments]    ${location_arg}    ${patient_arg}    ${therapy_arg}    ${loops}=1    ${po_number_arg}=${None}
    ${appointment_dict}    Create Appointment Dictionary
    Select A Location In Schedule Appointment Popup    ${location_arg}
    Select A Patient In Schedule Appointment Popup    ${patient_arg}
    IF    "${po_number_arg}" == "${None}"
        Select Therapy In Schedule Appointment Popup    ${therapy_arg}
    ELSE
        Select Therapy Following PO In Schedule Appointment Popup    ${therapy_arg}    ${po_number_arg}
    END
    Select Recommended Nurse In Schedule Appointment Popup    ${appointment_dict}
    Click Approve Therapy And Begin Scheduling Button
    FOR    ${i}    IN RANGE    ${loops}
        ${result}    Get Incremental Dates
        ${apt_date}    Get From Dictionary    ${result}    current_date
        Schedule Normal Appointment    day_arg=${apt_date}    start_time=10:20 am    dict_arg=${appointment_dict}
        Click Add To Queue Button
        Handle DOS Before Suggested Alert
        IF    ${loops} == 1
            Set To Dictionary    ${appointment_dict}    apt_date=${apt_date}
        ELSE IF    ${loops} > 1
            ${i}    Evaluate    ${i}+1
            Set To Dictionary    ${appointment_dict}    apt_date_${i}=${apt_date}
        END
    END
    Click Random Button
    Scheduling Alert
    RETURN    ${appointment_dict}