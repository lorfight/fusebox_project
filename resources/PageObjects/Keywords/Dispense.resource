*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime
Library    XML
Variables    ../Locators/CommonLocator.py
Variables    ../Locators/DispenseLocator.py
Variables    ../TestData/Testdata.py
Resource    ../../../libraries/Util.resource


*** Keywords ***
Select Item Therapy
    [Arguments]    ${therapy_item}
    Wait Until Element Is Visible    //*[@class="lineDetail"]//*[@id="SelectedItem"]    timeout=20s
    Util.Verify Loading And Select By Label    locator=xpath://*[@class="lineDetail"]//*[@id="SelectedItem"]    selected_label=${therapy_item}

Go Dispensing
    Waiting For Loading
    Click Element    ${DispensingLink}
    Click Element    ${NewDispenseLink}
    Title Should Be    Appointment Ordering Ledger
    Waiting For Loading

Go Dispense Now Screen
    Wait Until Element Is Enabled    ${DispenseNow_button}
    click element    ${DispenseNow_button}

Select Therapy Medication
    [Arguments]    ${medication}
    Wait Until Page Contains Element    id=AppointmentPropName
    Util.Verify Loading And Select By Label    AppointmentPropName    ${medication}

Input Dose
    [Arguments]    ${dose}
    Wait Until Element Is Enabled    id=UoMQty
    Util.Input And Verify    ${dose}    id=UoMQty

Add Medication
    Wait Until Element Is Enabled    link:Add Medication
    click element    link:Add Medication
    Wait Until Page Contains    Add Primary Medication

Click Accept Item Expired
    ${element_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${Expired_Alert}
    Run Keyword If    ${element_visible}    Click Button    ACCEPT & CONTINUE    ELSE    Log    Element is not visible

Click Accept Dosage
    ${element_visible}=    Run Keyword And Return Status    Element Should Be Visible     //*[@id="acceptDosage"]
    Run Keyword If    ${element_visible}     Click Element    //*[@id="acceptDosage"]    ELSE    Log    Element is not visible

Click Complete Dispense Button
    Wait Until Element Is Enabled    ${CompleteDispense_button}
    Click Element    ${CompleteDispense_button}


Accept Advised Alert
    ${element_visible}=    Run Keyword And Return Status    Element Should Be Visible    ${Advised_Alert}
    Run Keyword If    ${element_visible}    Click Button    Accept & Dispense    ELSE    Log    Element is not visible
    Wait Until Keyword Succeeds    5s    1s    Handle Alert And Return Its Text

Dispense Item
    Wait Until Element Is Visible    //*[@id="AppointmentSection"]/div[4]/h3
    Util.Handle Scan Barcode Reconcile    ${BarcodeItem}
    Click Accept Item Expired
    Click Accept Dosage
    Click Complete Dispense Button
    Accept Advised Alert

Close Dispense Modal
    Wait Until Element Is Visible    ${CloseDispense_button}
    Click Element    ${CloseDispense_button}


Filter Appointment
    [Arguments]    ${date_time}    ${medication}    ${appointment_status}
    Filter By Date Range    date_time=${date_time}
    Filter By Medication    medication=${medication}
    Filter By Status Appointment    appointment_status=${appointment_status}
    Filter By Patient    patient=${Patient}
    Click Element    link:Search
    Waiting For Loading

Filter By Date Range
    [Arguments]    ${date_time}
    
    Wait Until Element Is Enabled    //*[@id="StartDate"]
    Input Text    ${FilterStartDate_input}    ${date_time}
    Input Text    ${FilterEndDate_input}    ${date_time}
    Wait Until Element Is Enabled    //button[text()="Done"]
    Click Button    Done

Filter By Status Appointment
    [Arguments]    ${appointment_status}
    Wait Until Element Is Enabled    id=StatusId
    Select From List By Label    id=StatusId    ${appointment_status}

Filter By Location
    [Arguments]    ${location}
    Wait Until Page Contains Element    //*[contains(@class,"hidden") and @id="_MemberLoader"]    timeout=10s
    Wait Until Element Is Enabled    id=MemberId    timeout=10s
    Select From List By Label    id=MemberId    ${location}

Filter By Medication
    [Arguments]    ${medication}
    Select From List By Label    id=Medication    ${medication}

Filter By Patient
    [Arguments]    ${patient}
    Wait Until Element Is Enabled    id=PatientId
    Input Text    id=PatientId    ${patient}

Go To Schedule New Appointment
    Wait Until Element Is Enabled    link: Schedule New Appointment
    Click Element    link: Schedule New Appointment
    Wait Until Page Contains Element     //*[text()="Schedule Appointment"]     15s    Open Schedule Appointment Failed
    Waiting For Loading


Select Patient
    [Arguments]    ${patient}
    Util.Input And Verify    ${Patient}    locator_input=${SelectPatient_input}
    Wait Until Keyword Succeeds    3times    2s    Click Element Patient Selected    ${patient}

Click Element Patient Selected
    [Arguments]    ${patient}
   ${PatientSelected_click}     Replace Variables    ${PatientSelected_click}
    CLick Element    ${SelectPatient_input}
    Wait Until Page Contains Element    ${PatientSelected_click}
    CLick ELement    ${PatientSelected_click}
    Wait Until Page Contains   text=Select your medications and dosages for this patient's therapy    timeout=60s

Selected Therapy
    [Arguments]    ${therapy}
    Wait Until Element Is Enabled    id=Therapy    timeout=30s
    Util.Verify Loading And Select By Label    Therapy    ${therapy}
Select Medications And dosages For Therapy
    [Arguments]    ${dosages_qty}
    Wait Until Element Is Enabled    ${AddQtyDosage_input}    timeout=180s    error=Can't not find Add Quality Dosage input
    Wait Until Keyword Succeeds    3 times    1    Input Text     ${AddQtyDosage_input}    ${dosages_qty}
    Wait Until Page Contains Element
    ...    //*[@id="TherapyDosageSelector"]/table/tbody/tr[2]/td[2]
    ...    timeout=20s
Approve Therapy And Begin Scheduling
    Click Element     link: Approve Therapy & Begin Scheduling
    Wait Until Page Contains    Schedule in the appointment time & length
Config Scheduling
    [Arguments]    ${start_time}    ${appointment_length}
    Schedule The appointment    ${start_time}    ${appointment_length}
    Scheduling Alert

Schedule The appointment
    [Arguments]    ${start_time}=${None}    ${appointment_length}=${None}    ${date_time}=${None}
    ${date_time}    Run Keyword If    '${date_time}' == '${None}'
    ...    Get Time Now    result_format=%m/%d/%Y
    Input Text    //*[@id="RequireTime"]    ${start_time}
    Input Text    id=AppointmentDate    ${date_time}
    Select From List By Value    id=RequiredLength    ${appointment_length}
    Execute JavaScript  $('#ModalPopup #SaveBtn').trigger('click');

Scheduling Alert
    TRY
        Wait Until Element Is Visible    xpath://*[text()="Scheduling Alert - Link Appointment"]    timeout=10s
        Wait Until Keyword Succeeds    3times    1    Select Unlinked Schedule    
    EXCEPT
        Log    Scheduling Alert - Link Appointment is not visible
    END
Select Unlinked Schedule
    Click Element    //div[contains(text(),"Standalone Appointment - Unlinked")]/following-sibling::div/input
    Click Button    Continue
    Page Should Not Contain    Please select a parent appointment or indicate the appointment as unlinked to continue.

Select Ledger View
    Wait Until Element Is Enabled    id=appointmentViewsDropdown    timeout=5s
    Wait Until Keyword Succeeds    5 times    1    Click Button    id=appointmentViewsDropdown
    Click Element   link:Ledger View
    

Open Appointment
    Util.Scroll To Bottom
    Click Element    link: Open Appointment

Input Qty ${dispensed_qty}
    Wait Until Element Is Enabled    ${DispenseQty_input}
    Scroll Element Into View    ${DispenseQty_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text     ${DispenseQty_input}    ${dispensed_qty}
    ${actual}    SeleniumLibrary.Get Element Attribute    ${DispenseQty_input}    value
    Should Be Equal    ${actual}    ${dispensed_qty}
    # Run Keyword And Ignore Error    Handle Alert
    Execute JavaScript    document.activeElement.blur()
    Waiting For Loading

Approve And Dispense
    Wait Until Element Is Enabled    (//a[@id='acceptDosage']//*[contains(text(),'Start Dispense')])[2]
    Util.Scroll Into View    locator="(//a[@id='acceptDosage']//*[contains(text(),'Start Dispense')])[2]"
    Wait Until Keyword Succeeds    30s    1s    Click Element    (//a[@id='acceptDosage']//*[contains(text(),'Start Dispense')])[2]
    Wait Until Page Contains    Dosage Has Been Accepted!    timeout=20s

Scan ${dispensed_qty} ${BARCODES_TRANSFER}
    ${list_barcode}=     Evaluate   random.sample(${BARCODES_TRANSFER},${dispensed_qty})
    Wait Until Page Contains    Complete Dispense    timeout=60s
    Scan Barcode To Dispense    $list_barcode=${list_barcode}
    Scroll Element Into View    ${CompleteDispense_button}
    Wait Until Element Is Visible    ${SelectFacilityDispense_select}    timeout=20s

Scan Barcode To Dispense
    [Arguments]    ${list_barcode}
    Set Selenium Timeout    20 seconds
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${list_barcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, 10000);

Select Facility And Complete Dispense
    [Arguments]    ${facility_verify}
    Util.Scroll Into View    locator="//*[contains(@id,'AppointmentDispenseTable')]//select[@id='Facility']"
    Util.Verify Loading And Select By Label    ${SelectFacilityDispense_select}    ${facility_verify}
    Click Complete Dispense Button
    TRY
        Handle Alert
    EXCEPT
        Wait Until Page Contains     - Check Total Dispense Amount
        Handle Alert Under/Over Vs Assigned Dose
    FINALLY
        Wait Until Page Contains    Dispensed from ${facility_verify}    timeout=30s
        Wait Until Element Is Not Visible    ${CompleteDispense_button}
    END

Close Appointment Modal
    Wait Until Element Is Enabled    ${CloseAppointModal_button}
    Click Button    ${CloseAppointModal_button}

Close Appointment
    Wait Until Element Is Enabled    ${CloseAppointment_button}
    Click Element    ${CloseAppointment_button}
    Wait Until Element Is Not Visible    //*[contains(@action,"/Appointment/AssignDosageToAppointment")]

Handle Alert Under/Over Vs Assigned Dose
    Wait Until Element Is Enabled    id=DispenseAmountReason
    Wait Until Page Contains    Please either continue with dispense by entering a reason for discrepancy or return to previous screen to fix dispense.
    Wait Until Keyword Succeeds    3times    1    Select Overdose Reason
    Click Button    //*[contains(@id,"SubModalPopup")]//*[@id="SaveBtn" and contains(text(),"Continue")]
    Wait Until Keyword Succeeds    5s    1    Handle Alert

Select Overdose Reason
    Wait Until Element Is Visible    id=DiscrepancyDropdownReason    10s
    Select From List By Label    id=DiscrepancyDropdownReason    Other
    Wait Until Element Is Visible    id=DispenseAmountReason    10s
    Input Text    id=DispenseAmountReason    Auto-Test

Approve Container Sizes
    Wait Until Page Contains Element    link:Approve Container Sizes
    Click Element    link:Approve Container Sizes
    Wait Until Page Contains    Complete Dispense

Click Close Dispense Now Modal
    Wait Until Page Contains Element    //div[@id="ModalPopup" and @aria-hidden="false"]//button[@id="CloseBtn"]
    Click Button    //div[@id="ModalPopup" and @aria-hidden="false"]//button[@id="CloseBtn"]
