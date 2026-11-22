*** Settings ***
Resource    OpenAppointment/OpenAppointment.resource
Resource    RescheduleAppointment/RescheduleAppointment.resource
Resource    CancelAppointment/CancelAppointment.resource
Resource    TreatmentNote/TreatmentNote.resource
Resource    AdjustPatientProtocol/AdjustPatientProtocol.resource

*** Variables ***
${last_page}    (//a[contains(text(),'Next')]/preceding::a[1])[1]
${assign_dosage_to_apt_title}    //h4[contains(text(),'Assign Dosage To Appointment')]
${warn_future_apt_title}    //h4[contains(text(),"Warning - Opening Future Appointment")]
${apt_warn_yes_btn}    //button[contains(text(),'Yes / Continue')]
${early_scheduled_apt_title}    //p[contains(text(),'Early Scheduled Appointment')]
${early_confirm_textarea}    //textarea[@id="EarlyConfirm"]
${accept_early_apt_btn}    //button[@id="AcceptBtnModal"]
${requires_attention_title}   //form[@id="frm_SchedulingAlertMessage"]
${apt_update_therapy_btn}    //a[@id="UpdateApptTherapyBtn"]

*** Keywords ***
Verify Appointment Is Visible
    [Arguments]    ${apt_date_arg}
    ${appointment_row}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_date_arg}']
    Wait Until Element Is Visible    ${appointment_row}    30s

Open Appointment
    [Arguments]    ${apt_datetime}
    ${open_apt_btn}    Set Variable    (//*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(text(),'Open Appointment')])[1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${open_apt_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${open_apt_btn}
    Check Appointment Popup Is Visible
    Common.Element Is Not Visible     //[@id='_CurrentAppointmentTab']//[contains(@class,'fa-spinner')]    60s

Open Treatment Note
    [Arguments]    ${apt_datetime}
    ${treatment_note_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[@id='print' and *[normalize-space(text())='Treatment Note']][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${treatment_note_btn}    5s
    IF    ${check} == ${False}
        Scroll And Click Element    ${last_page}
    END
    Scroll And Click Element    ${treatment_note_btn}
    Check Appointment Popup Is Visible
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-4x fa-spin"]

Check Appointment Popup Is Visible
    Check Warning Future Appointment
    Check Early Scheduled Appoinment
    Check Requires Attention Popup

Check Warning Future Appointment
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${warn_future_apt_title}    3s
    IF    ${check} == ${True}
        Common.Scroll And Click Element    ${apt_warn_yes_btn}
    END

Check Early Scheduled Appoinment
    ${check_early}    Run Keyword And Return Status    Wait Until Element Is Visible    ${early_scheduled_apt_title}    3s
    IF    ${check_early} == ${True}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${early_confirm_textarea}    Testing
        Common.Scroll And Click Element    ${accept_early_apt_btn}
    END

Check Requires Attention Popup
    ${check_schedule_alert}    Run Keyword And Return Status    Wait Until Element Is Visible    ${requires_attention_title}    3s
    IF    '${check_schedule_alert}' == '${True}'
        Common.Scroll And Click Element    ${apt_update_therapy_btn}
        Handle Alert    ACCEPT
        Common.Page Alert Message    The Therapy for this Appointment has been updated.
    END

Open Work Order
    [Arguments]    ${apt_datetime}
    ${work_order_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@href,'PatientWorkOrder')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${work_order_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${work_order_btn}

Open Delivery Ticket
    [Arguments]    ${apt_datetime}
    ${delivery_ticket_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@href,'PatientProductPicking')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${delivery_ticket_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${delivery_ticket_btn}

Open Packing Label
    [Arguments]    ${apt_datetime}
    ${packing_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'PrintXLAppointmentBagLabel')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${packing_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${packing_btn}

Open Informed Consent
    [Arguments]    ${apt_datetime}
    ${informed_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@href,'PatientInformed')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${informed_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${informed_btn}

Open Nurse Prep Sheet
    [Arguments]    ${apt_datetime}
    ${nurse_prep_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@href,'NursePrep')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${nurse_prep_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${nurse_prep_btn}

Open Superbill
    [Arguments]    ${apt_datetime}
    ${superbill_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@href,'Superbill')][1]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible   ${superbill_btn}    5s
    IF    ${check} == ${False}
        Common.Scroll And Click Element    ${last_page}
    END
    Common.Scroll And Click Element    ${superbill_btn}

Get Data In APT Page
    [Arguments]    ${dict_arg}    @{steps}
    FOR    ${step}    IN    @{steps}
        Run Keyword    ${step}    ${dict_arg}
    END

Get Appointment ID
    [Arguments]    ${apt_datetime}
    ${apt_id_text}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/preceding::strong[starts-with(text(),'APT')][1]
    ${apt_id}    Get Text    ${apt_id_text}
    RETURN    ${apt_id}

Get Status APT
    [Arguments]    ${apt_datetime}
    ${status_apt}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::span[contains(@class,'appointmentStatusBadge')]
    ${status_apt_txt}    Get Text    ${status_apt}   
    RETURN    ${status_apt_txt}

Get Start Time APT
    [Arguments]    ${apt_datetime}
    ${starttime}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::div[1]/strong
    ${starttime_txt}    Get Text    ${starttime}   
    RETURN    ${starttime_txt}

Get Dosage Medication
    [Arguments]    ${apt_datetime}
    ${dosage_medication}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::div[contains(@class,'ApptMedications')]//strong
    ${dosage_medication_txt}    Get Text    ${dosage_medication}   
    RETURN    ${dosage_medication_txt}

Change Appointment Status
    [Arguments]    ${apt_datetime}    ${status_apt_arg}
    ${status_apt}    Set Variable    (//*[@class='DateOfServiceLabel' and text()='${apt_datetime}']//following::span[contains(@class,'appointmentStatusBadge')])[1]
    Common.Scroll And Click Element    ${status_apt}
    ${status_apt_checkbox}    Set Variable    //div[contains(text(),'${status_apt_arg}')]//following-sibling::div/input
    Common.Scroll And Click Element    ${status_apt_checkbox}
    Common.Scroll And Click Element    //button[text()='Accept']
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s

Go To View Changes
    [Arguments]    ${apt_datetime}
    ${view_changes_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'AppointmentViewChangelog')]
    Click Element    ${view_changes_btn}

Go To Assign Devices
    [Arguments]    ${apt_datetime}
    ${assign_devices_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'AssignDevicesToAppointmentModal')]
    Click Element    ${assign_devices_btn}

Click Cancel Appointment
    [Arguments]    ${apt_datetime}
    ${cancel_apt_icon}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@title,'Cancel Appointment')][1]
    Common.Scroll And Click Element    ${cancel_apt_icon}
    Wait Until Element Is Visible    //h4[contains(text(),'Cancel Appointment Confirmation')]    30s

Click Reschedule Appointment
    [Arguments]    ${apt_datetime}
    ${reschedule_apt_icon}    Set Variable    //div[strong[@class='DateOfServiceLabel' and text()='${apt_datetime}']]//following::a[@title="Reschedule Appointment"][1]
    Common.Scroll And Click Element    ${reschedule_apt_icon}
    Wait Until Element Is Visible    //h4[contains(text(),'Reschedule Appointment Confirmation')]    30s

Get Patient Name In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${patient_name}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(text(),'Patient:')][1]/parent::* 
    ${text}    Get Text    ${patient_name}
    ${patient_text}    Fetch From Right    ${text}    \: \
    Set To Dictionary    ${dict_name_arg}
    ...    patient_text=${patient_text}

Get Patient DOB In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${patient_DOB}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(text(),'DOB:')][1]/parent::*
    ${text}    Get Text    ${patient_DOB}
    ${dob_result}    Fetch From Right    ${text}    \: \
    Set To Dictionary    ${dict_name_arg}
    ...    dob_result=${dob_result}

Get Service Type In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${service_type}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(text(),'Service Type:')][1]/parent::* 
    ${text}    Get Text    ${service_type}
    ${service_type_result}    Fetch From Right    ${text}    \: \
    Set To Dictionary    ${dict_name_arg}
    ...    service_type_result=${service_type_result}

Get Diagnosis In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${diagnosis}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(text(),'Diagnosis:')][1]/parent::* 
    ${text}    Get Text    ${diagnosis}
    ${diagnosis_result}    Fetch From Right    ${text}    \: \
    Set To Dictionary    ${dict_name_arg}
    ...    diagnosis_result=${diagnosis_result}

Get Patient Weight In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${weight}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(@id,'WeightButton')][1]
    ${weight_value}    SeleniumLibrary.Get Element Attribute    ${weight}    value
    Set To Dictionary    ${dict_name_arg}
    ...    weight_value=${weight_value}

Get Payer In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${payer}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[contains(text(),'Payer:')][1]/parent::*
    ${text}    Get Text    ${payer}
    ${payer_result}    Fetch From Right    ${text}    \: \
    Set To Dictionary    ${dict_name_arg}
    ...    payer_result=${payer_result}

Get Treatment Duration In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${treatment_duration}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Treatment Duration: '][1]/following::*[1]
    ${treatment_text}    Get Text    ${treatment_duration}
    Set To Dictionary    ${dict_name_arg}
    ...    treatment_text=${treatment_text}

Get End Time In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${visit_end_time_text}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='to'][1]/following::*[1]
    ${endtime}    Get Text    ${visit_end_time_text}   
    Set To Dictionary    ${dict_name_arg}
    ...    endtime=${endtime}

Input Start Time In APT
    [Arguments]    ${apt_datetime}    ${start_time_arg}
    ${start_time_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Start Time: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${start_time_input}    ${start_time_arg}
    Page Alert Message    Treatment Time Successfully Assigned!

Input Stop Time In APT
    [Arguments]    ${apt_datetime}    ${stop_time_arg}
    ${stop_time_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Stop Time: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${stop_time_input}    ${stop_time_arg}
    Page Alert Message    Treatment Time Successfully Assigned!

Get Start Time In APT
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${start_time}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Start Time: '][1]/following::*[1]
    ${start_time_txt}    Get Text    ${start_time}   
    Set To Dictionary    ${dict_name_arg}
    ...    start_time_txt=${start_time_txt}

Get Stop Time In APT
    [Arguments]    ${apt_datetime}
    ${stop_time}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Start Time: '][1]/following::*[1]
    ${stop_time_txt}    Get Text    ${stop_time}   
    RETURN    ${stop_time_txt}

Get Primary Medication
    [Arguments]    ${apt_datetime}
    ${apt_primary_medication}    Set Variable    //*[@class="DateOfServiceLabel"]/following::hr[1]/preceding::strong[text()="${apt_datetime}"]//following::div[contains(@id,"ApptMedColumn")][1]//following-sibling::strong
    Scroll Element Into View    ${apt_primary_medication}
    ${apt_primary_medication_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_primary_medication}
    RETURN    ${apt_primary_medication_txt}

Input Appointment Note
    [Arguments]    ${apt_datetime}    ${apt_note_arg}
    ${apt_note_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Appointment Note:'][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${apt_note_input}    ${apt_note_arg}
    Page Alert Message    Note Added!

Get Appointment Note
    [Arguments]    ${dict_name_arg}    ${apt_datetime}
    ${apt_note}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Appointment Note:'][1]/following::*[1]
    ${apt_note_txt}    Get Value    ${apt_note}   
    Set To Dictionary    ${dict_name_arg}
    ...    apt_note_txt=${apt_note_txt}

Select Therapy Assigner In APT
    [Arguments]    ${apt_datetime}    ${therapy_arg}
    ${therapy_select}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Assign a Medication: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${therapy_select}    ${therapy_arg}

Input Referring Provider In APT
    [Arguments]    ${apt_datetime}    ${referring_arg}
    ${referring_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Referring Provider: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${referring_input}    ${referring_arg}
    Handle Alert    ACCEPT    30s
    Page Alert Message    Referring Provider Assigned!

Input Refer to Provider In APT
    [Arguments]    ${apt_datetime}    ${refer_arg}
    ${refer_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Refer to Provider: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${refer_input}    ${refer_arg}
    Handle Alert    ACCEPT    30s
    Page Alert Message    Provider Assigned!

Input Supervising Provider In APT
    [Arguments]    ${apt_datetime}    ${supervising_arg}
    ${supervising_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Supervising Provider: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${supervising_input}    ${supervising_arg}
    Page Alert Message    Supervisor Assigned!

Input Rendering Billable Provider In APT
    [Arguments]    ${apt_datetime}    ${rendering_arg}
    ${rendering_input}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::*[text()='Rendering (Billable) Provider: '][1]/following::*[1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${rendering_input}    ${rendering_arg}
    Page Alert Message    Rendering Provider Added!

View Provider Order In APT
    [Arguments]    ${apt_datetime}
    ${view_PO_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'CreateEditPatientOrderModal')]
    Click Element    ${view_PO_btn}

View Prior Authorization In APT
    [Arguments]    ${apt_datetime}
    ${view_PA_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'ViewOnlyPriorAuthorizationModal')]
    Click Element    ${view_PA_btn}

Go To Ledger Add Delivery Instructions
    [Arguments]    ${apt_datetime}
    ${add_delivery}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'AppointmentViewChangelog')]
    Click Element    ${add_delivery}

Go To Manage Patient Protocol
    [Arguments]    ${apt_datetime}
    ${protocol_btn}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'ManagePatientProtocolModal')]
    Click Element    ${protocol_btn}

Go To Index Dosage
    [Arguments]    ${apt_datetime}
    ${index_dose}    Set Variable    //*[@class='DateOfServiceLabel' and text()='${apt_datetime}']/following::a[contains(@onclick,'LoadIndexDosageCalculator')]
    Click Element    ${index_dose}