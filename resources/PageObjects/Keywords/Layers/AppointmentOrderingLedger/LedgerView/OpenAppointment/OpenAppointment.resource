*** Settings ***
Resource    ../../../Common/Common.resource
Library    ../../../Fakedata/FakeData.py

*** Variables ***
${apt_cancel_btn}    //a[@id="InnerAppointmentCancelButton"]
${apt_reschedule_btn}    //a[contains(@class,'RescheduleBtn')]
${last_page}    (//a[contains(text(),'Next')]/preceding::a[1])[1]
${overview_tab}    //a[@id="AppointmentTotalView"]
${apt_advised_title}    //h4[contains(text(),"PLEASE BE ADVISED")]
${approve_and_dispense_btn}    (//span[contains(text(),"Start Dispense")])[2]
${apt_lot_number_select}    //select[@id="Lot_0"]
${apt_complete_dispense_btn}    //strong[normalize-space(text())="Complete Dispense"]
${apt_discrepancy_reason_select}    //select[@id="DiscrepancyDropdownReason"]
${apt_dispense_reason}    //textarea[@id="DispenseAmountReason"]
${apt_reason_continue_btn}    //button[@id="SaveBtn" and contains(text(),"Continue")]
${apt_close_btn}    //div[@id="ModalPopup"]//button[@id="CloseBtn" and contains(text(),"Close")]
${apt_accept_and_dispense_btn}    //button[contains(text(),"Accept & Dispense")]
${apt_approve_and_save_medication}    //span[contains(text(),"Approve Appointment Assignments")]

*** Keywords ***
Create Dispense Dictionary
    &{dispense_dict}    Create Dictionary
    RETURN    ${dispense_dict}

Click Cancel Appoinment Button In Assign Dosage To Appointment Modal
    Common.Scroll And Click Element    ${apt_cancel_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Cancel Appointment Confirmation')]    30s

Click Rechedule Appoinment Button In Assign Dosage To Appointment Modal
    Common.Scroll And Click Element    ${apt_reschedule_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Reschedule Appointment Confirmation')]    30s

# Click Approve And Dispense Button
#     Common.Scroll And Click Element    ${approve_and_dispense_btn}
#     Common.Page Alert Message    Dosage Has Been Accepted!

Click Start Dispense Button
    Wait Until Keyword Succeeds    30s    1s    Click Element    //div[@id="DosageCalculation"]//child::span[text()="Start Dispense"]
    Common.Page Alert Message    Dosage Has Been Accepted!

Handle Approve Dosage Button
    # ${check_approve_dosage_btn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${approve_and_dispense_btn}    2s
    # IF    '${check_approve_dosage_btn_visible}' == '${False}'
    #     Common.Scroll And Click Element    ${overview_tab}
    # END
    # Click Approve And Dispense Button
    Click Start Dispense Button

Select Lot Number In Primary Medications
    [Arguments]    ${dic_arg}
    ${lot}    Check Lot Expiration
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${apt_lot_number_select}    ${lot}
    Set To Dictionary    ${dic_arg}    apt_lot_number_select=${lot}

Check Lot Expiration
    ${lot_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${apt_lot_number_select}
    Reverse List    ${lot_list}
    IF    $lot_list == ["-- Create New Lot --", "-- Select Lot --"]
        ${Fake_dict}    Generate Fake Data    6_integers
        ${exp_date}    Get Current Date    result_format=%m/%d/%Y    increment=365 days
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${apt_lot_number_select}    -- Create New Lot --
        Wait Until Keyword Succeeds    30s    1s    Input Text    //input[contains(@placeholder,"Enter New Lot Number")]    ${Fake_dict['6_integers']}
        Wait Until Keyword Succeeds    30s    1s    Input Text    //input[contains(@placeholder,"Enter New Expiration Date")]    ${exp_date}
        Common.Close Calendar Table
        Wait Until Keyword Succeeds    30s    1s    Click Element    //a[contains(@class,'submitLot')]
        Common.Page Alert Message    Dispense Line Updated!
        ${formated_exp_date}    Handle Datetime Format    fmt={m}/{d}/{y}    dt=${exp_date}
        ${lot}    Set Variable    ${Fake_dict['6_integers']} -- [Exp: ${formated_exp_date}] 
    ELSE
        ${current_date}    Get Current Date    result_format=%m/%d/%Y    increment=1 days
        ${accepted_date}    Handle Datetime Format    fmt={m}/{d}/{y}    dt=${current_date}
        ${accepted_date}    Convert Date    ${accepted_date}    result_format=datetime    date_format=%m/%d/%Y
        FOR    ${lot}    IN    @{lot_list}
            IF    "${lot}" in ["-- Create New Lot --","-- Select Lot --"]
                CONTINUE
            END
            ${lot_expdate}    Fetch From Right    ${lot}    \Exp: \
            ${lot_expdate}    Fetch From Left    ${lot_expdate}    ]
            ${lot_expdate}    Convert Date    ${lot_expdate}    result_format=datetime    date_format=%m/%d/%Y
            ${status}    Run Keyword And Return Status    Should Be True    "${lot_expdate}" > "${accepted_date}"
            Run Keyword If    "${status}" == "${True}"    Exit For Loop    
        END
    END
    RETURN    ${lot}

Click Complete Dispense Button
    Common.Scroll And Click Element    ${apt_complete_dispense_btn}

Check Please Be Advised Alert
    [Arguments]    ${dic_arg}
    Wait Until Element Is Visible    ${apt_advised_title}    3s
    Common.Choose Random Value From Select List    xpath_arg=${apt_discrepancy_reason_select}    var_name=apt_discrepancy_reason_select    dic=${dic_arg}
    IF    '${dic_arg.apt_discrepancy_reason_select}' == 'Other'
        Common.Input Text Into Field    ${apt_dispense_reason}    Testing
    END
    Common.Scroll And Click Element    ${apt_reason_continue_btn}
    Handle Alert    ACCEPT
    # ${check_button_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${apt_accept_and_dispense_btn}    3s
    # IF    "${check_button_visible}" == "${True}"
    #     Common.Scroll And Click Element    ${apt_accept_and_dispense_btn}
    #     Handle Alert    ACCEPT
    # END

Dispense Created Appoinment
    ${dispense_dict}    Create Dispense Dictionary
    Handle Approve Dosage Button
    Select Lot Number In Primary Medications    ${dispense_dict}
    Click Complete Dispense Button
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Appointment Dispensed!    30s
    IF    "${check_msg}" == "${False}"
        Check Please Be Advised Alert    ${dispense_dict}
        Common.Page Alert Message    Appointment Dispensed!    30s
    END
    RETURN    ${dispense_dict}

Get Dosage Quality Therapy
    Wait Until Element Is Visible    //div[@id="DynamicDosageView"]/div[contains(.,"Dosage")]    30s
    ${quantity_therapy_value}    Get Text    //div[@id="DynamicDosageView"]/div[contains(.,"Dosage")]
    ${quantity_therapy_value}    Fetch From Right    ${quantity_therapy_value}    \Dosage: \
    ${quantity_therapy_value}    Fetch From Left    ${quantity_therapy_value}    \ Milligrams\
    RETURN    ${quantity_therapy_value}

Get Dx Code In The Appointment Information Tab
    Wait Until Element Is Visible    //strong[contains(text(),"Assigned DX Code")]//following::a[1]    30s
    ${assigned_dxcode_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    //strong[contains(text(),"Assigned DX Code")]//following::a[1]
    RETURN    ${assigned_dxcode_txt}

Get Patient Weight In The Appointment Information Tab
    Wait Until Element Is Visible    //label[@for="PatientWeight"]//following::input[@name="PatientWeight"][1]    30s
    ${patient_weight_txt}    Wait Until Keyword Succeeds    30s    1s    Get Value    //label[@for="PatientWeight"]//following::input[@name="PatientWeight"][1]
    RETURN    ${patient_weight_txt}

Get Total Dispensed Dose Of Primary Medication In The Appointment Information Tab
    Wait Until Element Is Visible    //strong[@name="BaseQty"]    30s
    ${base_qty_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    //strong[@name="BaseQty"]
    ${unit_therapy_value}    Get Text    //strong[contains(text(),'Dosage')]//parent::div
    ${unit_therapy_value}    Fetch From Right    ${unit_therapy_value}    \Dosage: \
    RETURN    ${base_qty_txt}    ${unit_therapy_value}

Click Approve Dosage And Save Medication
    Common.Scroll And Click Element    ${apt_approve_and_save_medication}
    Common.Page Alert Message    Dosage Has Been Accepted!

Check Requires Attention
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    id=frm_SchedulingAlertMessage   30s
    IF    ${check} == ${True}
        Common.Scroll And Click Element    //*[@id='frm_SchedulingAlertMessage']//following::*[@id='CloseBtn'][1]
    END 