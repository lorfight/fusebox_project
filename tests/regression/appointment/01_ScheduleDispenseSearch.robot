*** Settings ***
Documentation      Verify APT Regression
Library    DependencyLibrary
Library    Dialogs
Library    Screenshot
Variables    ../../../resources/PageObjects/Locators/Appointment.py
Variables    ../../../resources/PageObjects/Locators/Billable.py
Resource   ../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/PriorAuthorization.resource
Resource    ../../../resources/PageObjects/Keywords/Appointment.resource
Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Resource    ../../../resources/PageObjects/Keywords/Billable.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryTransfer.resource
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup Appointment
Test Setup    Test Setup Appointment
Test Teardown    RePatient.Test Teardown Keyword
Suite Teardown    RePatient.Log Data And Close Browser
Test Tags    test:retry(5)    APTMan_001    appointment    Admin

*** Test Cases ***
Schedule Early APT
    [Documentation]    ESA-1, ESA-2, ESA-3, ESA-4, ESA-5
    [Tags]    Regression    Early Schedule
    Appointment.Select Therapy Before Scheduling
    Appointment.Cannot Schedule Early Appointment For Empty Reason
    Appointment.Schedule Early Appointment For A Reason
    Util.Scroll To Top
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_DOS}    time_arg=9:21 am
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_Visit_DOS_1}    time_arg=9:26 am
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_Early_DOS}    time_arg=9:21 am
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_Visit_DOS_2}    time_arg=9:26 am

Dispense And Verify Under/Over Dose APT In Changelog - Ledger View
    [Documentation]    [19954]-1, [19954]-2, [19954]-3
    [Tags]    Regression    Under/Over Dose    Ledger View
    Appointment.Schedule APT With Different Dose
    Random Select Under Or Over Dose
    Wait Until Keyword Succeeds    10s    1s    Search By Location    Location_arg=${PatientData.Location}
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Set Test Variable    ${View}    Tall View
    Appointment.Filter Appointment    date_time=${AppointmentData.APT_Time}    medication=Actemra    appointment_status=Requires Approval
    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.APT_Time}    xpath_header_arg=${open_APT_header_text}
    Dispense Different Dose In APT Ledger
    Continue With No select droplist No Reason
    Continue With No Reason
    Continue With Reason
    Check View Change Reason
    Check Question Mark After Dispense With Reason
    Check Medication After Dispense With Reason
    Util.Scroll To Top
    Appointment.Filter Appointment    date_time=${AppointmentData.APT_DOS}    medication=\-- All Medications --\    appointment_status=\-- All Statuses --\
    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=9:21 am    xpath_header_arg=${open_APT_dispensed_header_text}
    Appointment.Return Medication To Inventory
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_DOS}    time_arg=9:21 am
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_Visit_DOS}    time_arg=9:26 am

Dispense And Verify Under/Over Dose APT In Changelog - Dispense Now
    [Documentation]    [19954]-1, [19954]-2, [19954]-3
    [Tags]    Regression    Under/Over Dose    Dispense Now
    Appointment.Create Dictionary Of Appointment Data
    Appointment.Go Dispensing
    Wait Until Keyword Succeeds    10 times    3s    Search By Location    Location_arg=${PatientData.Location}
    Dispense.Go Dispense Now Screen
    Select Therapy In Dispense Now
    ${check}    Run Keyword And Return Status    Wait Until Page Contains Element    //*[contains(@class,'line')][2]//*[normalize-space(text())='Remove Line' and @onclick]    10s    #issue
    IF    ${check} == ${True}
        Scroll Element Into View    //*[contains(@class,'line')][2]//*[normalize-space(text())='Remove Line' and @onclick]
        Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[contains(@class,'line')][2]//*[normalize-space(text())='Remove Line' and @onclick]
        Wait Until Page Does Not Contain    //*[contains(@class,'line')][2]//*[normalize-space(text())='Remove Line' and @onclick]    10s
    END
    Appointment.Close Clinical Statement Modal
    Set Date-Time-Dose In Dispense Now
    Random Select Under Or Over Dose
    Dispense Different Dose In APT Ledger
    Continue With No select droplist No Reason
    Continue With No Reason
    Continue With Reason
    Set Test Variable    ${Patient_Select}    id=PatientId
    Set Test Variable    ${patient_suggestion}    //*[contains(@class,'suggestion') and contains(@class,'selectable') and *[text()='${patient_info}']]
    Check View Change Reason
    Check Question Mark After Dispense With Reason
    Check Medication After Dispense With Reason
    Util.Scroll To Top
    Appointment.Filter Appointment    date_time=${AppointmentData.APT_DOS}    medication=\-- All Medications --\    appointment_status=\-- All Statuses --\
    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.APT_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    Appointment.Return Medication To Inventory
    Appointment.Find APT And Cancel    DOS_arg=${AppointmentData.APT_DOS}    time_arg=${AppointmentData.APT_Time}

Verify Search Button Visible And Flashing When Filtering In Ledger View
    [Documentation]    SB-1, SB-2, SB-3
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Check Search Button Flashing
    Appointment.Filter By Status Appointment    appointment_status=Requires Approval
    Appointment.Check Search Button Flashing
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Appointment.Check Search Button Flashing
    Sleep    3s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s

Verify Click Search Button Filtering By Location
    [Documentation]    SB-4
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Filter By Status Appointment    appointment_status=\-- All Statuses --\
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=\-- All Medications --\
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    IF    ${count} > 0
       ${text}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${Ledger_DOS_Row}
       Should Contain    ${text}    \(${PatientData.Location_ID})\ ${PatientData.Location}
    END

Verify Click Search Button Filtering By Medication
    [Documentation]    SB-5
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Filter By Status Appointment    appointment_status=\-- All Statuses --\
    Sleep    3s
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=${drug_PO}
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    IF    ${count} > 0
        FOR    ${i}    IN RANGE    ${count}
            Set Test Variable    ${row}    ${i+1}
            ${row_medication}    Util.Replace Xpath    xpath=${ledger_APT_row_medication_text}
            Scroll Element Into View    ${row_medication}
            Wait Until Element Is Visible    ${row_medication}    30s
            ${medication}    Get Text    ${row_medication}
            Should Contain    ${medication}    ${drug_PO}
        END
    END

Verify Click Search Button Filtering By Date Range
    [Documentation]    SB-7, SB-8, SB-9
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Filter By Status Appointment    appointment_status=\-- All Statuses --\
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=\-- All Medications --\
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    ${today}    Util.Check Time Zone
    IF    ${count} > 0
        FOR    ${i}    IN RANGE    ${count}
            Set Test Variable    ${row}    ${i+1}
            ${row_DOS}    Util.Replace Xpath    xpath=${ledger_APT_row_DOS}
            Scroll Element Into View    ${row_DOS}
            Wait Until Element Is Visible    ${row_DOS}    30s
            ${DOS}    Get Text    ${row_DOS}
            ${check}    Subtract Date From Date    ${DOS}    ${today}    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y    result_format=verbose
            ${check}    Fetch From Left    ${check}    ${SPACE}
            ${check}    Evaluate    ${check}
            Should Be True    ${check} >= 0
        END
    END

Verify Click Search Button Filtering By Patient
    [Documentation]    SB-6
    [Tags]    Regression    Search button
    Appointment.Schedule APT With Different Dose
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Filter By Status Appointment    appointment_status=\-- All Statuses --\
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=\-- All Medications --\
    Appointment.Filter By Patient    patient_arg=${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Appointment.Filter By Date Range    date_time=${EMPTY}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    IF    ${count} > 0
        FOR    ${i}    IN RANGE    ${count}
            Set Test Variable    ${row}    ${i+1}
            ${row_patient}    Util.Replace Xpath    xpath=${ledger_APT_row_patient_text}
            Scroll Element Into View    ${row_patient}
            Wait Until Element Is Visible    ${row_patient}    30s
            ${patient}    Get Text    ${row_patient}
            Should Be Equal    ${patient}    \MRN: ${PatientData.MRN}\    strip_spaces=True
        END
    END

Verify Click Search Button Filtering Early Schedule APT
    [Documentation]    SB-10
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Filter By Status Appointment    appointment_status=\-- All Statuses --\
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=\-- All Medications --\
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Appointment.Filter By Date Range    date_time=${EMPTY}
    Util.Check Or Uncheck Box    view_arg=${True}    xpath_arg=${view_early_APT_input}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    IF    ${count} > 0
        FOR    ${i}    IN RANGE    ${count}
            Set Test Variable    ${row}    ${i+1}
            ${row_early}    Util.Replace Xpath    xpath=${ledger_APT_row_early_badge}
            Scroll Element Into View    ${row_early}
            Wait Until Element Is Visible    ${row_early}    30s
        END 
    END

Verify Click Search Button Filtering By Status
    [Documentation]    SB-11, SB-12
    [Tags]    Regression    Search button
    Appointment.Go Dispensing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Filter By Status Appointment    appointment_status=Requires Approval
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter By Medication    medication=\-- All Medications --\
    Wait Until Element Is Enabled    ${Patient_Select}
    Click Button    ${clear_patient_btn}
    Appointment.Filter By Date Range    date_time=${EMPTY}
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    ${count}    Appointment.Count APT Filtered    time_arg=10s
    IF    ${count} > 0
        FOR    ${i}    IN RANGE    ${count}
            Set Test Variable    ${row}    ${i+1}
            ${row_status}    Util.Replace Xpath    xpath=${ledger_APT_row_status_badge}
            Scroll Element Into View    ${row_status}
            Wait Until Element Is Visible    ${row_status}    30s
            SeleniumLibrary.Element Text Should Be    ${row_status}    Requires Approval
        END
    END

Verify Click Search Button Filtering With By Critera
    [Documentation]    SB-13, SB-14
    [Tags]    Regression    Search button
    Appointment.Schedule APT With Different Dose
    Appointment.Search By Location    Location_arg=${PatientData.Location}
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Set Test Variable    ${View}    Tall View
    Appointment.Filter Appointment    date_time=${AppointmentData.APT_DOS}    medication=${drug_PO}    appointment_status=Requires Approval
    Appointment.Check Date Of Service Row    Date=${AppointmentData.APT_DOS}
    Appointment.Scroll To Appointment - Check Time    StartTime=9:21 am
    Appointment.Check Date Of Service Label
    ${APT_Status_Element}    Util.Replace Xpath    xpath=${APT_Status_Element}
    ${Style}    SeleniumLibrary.Get Element Attribute    ${APT_Status_Element}    style
    IF    "staging" in "${SiteUrl}" or "dev" in "${SiteUrl}"
        Should Contain    ${Style}    background-color: firebrick;
    ELSE
        Should Contain    ${Style}    background-color: rgb\(255, 193, 7);
    END
    Appointment.Check Patient
    Appointment.Check Medication    Type=Appointment

*** Keywords ***
Suite Setup Appointment
    Suite Setup With Required Patient Information

Test Setup Appointment
    RePatient.Test Setup Keyword
    ${is_PO_created}    Run Keyword And Return Status    Dictionary Should Contain Key    ${PO_data}    PO_Num
    Return From Keyword If    ${is_PO_created}    PO created
    Create PO
    Initialize PA
    Update PA

Open New Window
    [Arguments]    ${url_arg}
    Execute Javascript    window.open('${url_arg}','_blank')
    # Maximize Browser Window
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    5s    1s    Title Should Be    ${title_arg}
    Wait Until Keyword Succeeds    10s    1s    Check Newsletter

Create Dictionary Of Inventory Data
    &{invent_data}    Create Dictionary
    Set Suite Variable    ${invent_data}

Select Qty And Med To Dispense
    [Arguments]    ${qty_arg}    ${med_arg}    ${lot_arg}
    Util.Verify Loading And Select By Label    SelectedItem    ${med_arg}
    Wait Until Keyword Succeeds    3 times    1    Dispense.Input Qty ${qty_arg}
    Sleep    2s
    Execute JavaScript    document.activeElement.blur()
    Dispense.Select Item Therapy    therapy_item=${med_arg}
    Sleep    3s
    ${dispense_dose}    Get Text    //*[@id='AppointmentItemTable']//*[@class='lineDetail']/*[6]
    ${dispense_dose}    Strip String    ${dispense_dose}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    link:Approve & Dispense 
    IF    ${check} == ${True}
        Wait Until Element Is Visible    link:Approve & Dispense     60s
        Wait Until Keyword Succeeds    10 times    3s    Click Element    link:Approve & Dispense 
    ELSE
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    link:Approve Container Sizes 
        Wait Until Element Is Visible    link:Approve Container Sizes     60s
        Wait Until Keyword Succeeds    10 times    3s    Click Element    link:Approve Container Sizes 
    END
    Wait Until Page Contains    Dosage Has Been Accepted!    timeout=20s
    Wait Until Element Is Visible    ${asdos_show_all_lots_checkbox}    30s
    ${check}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Attribute    ${asdos_show_all_lots_checkbox}    checked
    ${check}    Run Keyword And Return Status    Element Attribute Value Should Be    ${asdos_show_all_lots_checkbox}    checked    true
    IF    ${check} == ${False}
        Sleep    2s
        Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${asdos_show_all_lots_checkbox}
        Wait Until Keyword Succeeds    10s    1s    Click Element    ${asdos_show_all_lots_checkbox}
        Sleep    1s
    END
    Scroll Element Into View    ${asdos_lot_num_selection_text}
    ${qty}    Convert To Integer    ${qty_arg}
    FOR    ${num}    IN RANGE    ${qty}
        Set Test Variable    ${num}
        ${dispensed_xpath}    Util.Replace Xpath    xpath=${asdos_dispensed_check_input}
        ${check}    Run Keyword And Return Status    Checkbox Should Be Selected    ${dispensed_xpath}
        Run Keyword If    ${check} == ${False}    Click Element    ${dispensed_xpath}
        ${lot_xpath}    Util.Replace Xpath    xpath=${asdos_multi_line_lot_select}
        ${site_xpath}    Util.Replace Xpath   xpath=${asdos_site_admin_select}
        Scroll Element Into View    ${lot_xpath}
        ${check}    Run Keyword And Return Status    Element Should Be Visible    ${site_xpath}
        IF    ${check} == ${True}
            ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${site_xpath}    Arm\ \(Right)
            IF    ${check} == ${False}
                Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${site_xpath}    Eye\ \(Right)
            END
        END
        Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${lot_xpath}    ${lot_arg}
        Wait For Page Loading    element_arg=Dispense Line Updated    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Visible    timeout_arg=30s
    END
    Scroll Element Into View    ${SelectFacilityDispense_select}
    Util.Select Random From List    xpath_arg=${SelectFacilityDispense_select}    remove_default_arg=${False}
    ${selected}    Fetch From Left    ${selected}    \ \)\
    ${selected}    Set Variable    ${selected}\)
    Add To Dictionary    dic_arg=${invent_data}    key_arg=Dispense_Facility    val_arg=${selected}
    Set To Dictionary    ${AppointmentData}    Qty_Dispense=${qty_arg}    NDC=${med_arg}    Lot=${lot_arg}    Dispense_Dose=${dispense_dose}
    Set Test Variable    ${AppointmentData}

Create PO
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    ProviderOrders.Go to Provider Orders
    ProviderOrders.Select Location Provider Orders
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Calculate PO End Date
    ProviderOrders.Filter Date Range    date_arg=${end_date}
    ProviderOrders.Click Search PO
    ProviderOrders.Select Ordering Location    location_arg=${PatientData.Location}
    ProviderOrders.Input A Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Select Treatment Drug    drug_arg=${drug_PO}
    ProviderOrders.Click Diagnosis    DX_arg=M05.669
    ProviderOrders.Click Create Button
    ProviderOrders.Get PO Number
    ProviderOrders.Get PO Dates
    ProviderOrders.Input Referring/Ordering Provider    refer_arg=${referring_NPI_PO}
    ProviderOrders.Select Refer To Provider    refer_to_arg=${referto_provider_NPI_PO}
    ProviderOrders.Select Visit Frequency    frequency_arg=Day
    ProviderOrders.Input Weight And Height    patient_weight_arg=${patient_weight_PO}    patient_height_arg=${patient_height_PO}
    ProviderOrders.Input Dose And Frequency    dosageAssignedValue_arg=${dosage_assigned_value_PO}    calculated_dosage_arg=${calculated_dosage_PO}    dose_frequency_arg=${frequency_PO}    time_frequency_arg=${time_frequency_PO}
    ProviderOrders.Select Place Of Service And Preferred UoM And Container Type    placeOfserviceValue_arg=${placeof_service_value_PO}    requested_dose_arg=10    containerTypeValue_arg=${container_type_value_PO}    splitDoseValue_arg=${split_dose_value_PO}    numberOfsplitDosetreatmentsValue_arg=${numberof_split_dose_treatments_value_PO}
    ProviderOrders.Close Modal

Initialize PA
    Open New Window    url_arg=${homepage}
    Switch To Another Window    title_arg=Home
    PriorAuthorization.Create Dictionary Of PA Data
    PriorAuthorization.Go to Prior Authorization Page
    PriorAuthorization.Filter Location    location_arg=${PatientData.Location}
    PriorAuthorization.Filter Patient    patient_arg=${PatientData.MRN}
    PriorAuthorization.Filter Status    status_arg=\-- All Statuses --\
    PriorAuthorization.Filter Date Range    date_arg=${EMPTY}
    PriorAuthorization.Clear Medication
    PriorAuthorization.Clear Payer And Confirmation Num Search
    PriorAuthorization.Filter Medication Type    type_arg=\-- All Medication Types --\
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}
    PriorAuthorization.Click Edit PA Button
    PriorAuthorization.Initialize PA    start_date_arg=${PO_data.Start_Date}    end_date_arg=${PO_data.Exp_Date}
    PriorAuthorization.Click Update Button
    PriorAuthorization.Close Modal

Update PA
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}
    PriorAuthorization.Click Edit PA Button
    PriorAuthorization.Update PA    status_arg=Approved    start_arg=${PA_data.Start_Date}    end_arg=${PA_data.End_Date}    type_arg=${PA_data.Medication_Type}
    PriorAuthorization.Click Update Button
    PriorAuthorization.Close Modal
    PriorAuthorization.Filter Status    status_arg=${PA_data.Status}
    PriorAuthorization.Filter Date Range    date_arg=${PA_data.End_Date}
    PriorAuthorization.Filter Medication Type    type_arg=${PA_data.Medication_Type}
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}
    PriorAuthorization.Click PA Row
    PriorAuthorization.Check PA Status And Confirmation    status_arg=Approved
    PriorAuthorization.Close Modal

Random Select Under Or Over Dose
    ${random}    Evaluate    random.randint(0,1)    #if 0, dispense under dose, if 1, dispense over dose
    IF    ${random} == 0
        Set To Dictionary    ${AppointmentData}    Is_Dose_Under=${True}
    ELSE
        Set To Dictionary    ${AppointmentData}    Is_Dose_Under=${False}
    END
    Set Test Variable    ${AppointmentData}

Dispense Different Dose In APT Ledger
    &{invent_data}    Create Dictionary
    Set Test Variable    ${invent_data}
    ${is_under}    Run Keyword And Return Status    Should Be True    ${AppointmentData.Is_Dose_Under} == ${True}
    IF    ${is_under} == ${True}
        ${qty_dose}    Set Variable    1
    ELSE
        ${qty_dose}    Set Variable    2
    END
    Add To Dictionary    dic_arg=${AppointmentData}    key_arg=Qty    val_arg=${qty_dose}
    Select Qty And Med To Dispense    qty_arg=${AppointmentData.Qty}    med_arg=${NDC}    lot_arg=${lot}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${CompleteDispense_button}
    Wait Until Element Is Visible    ${CompleteDispense_button}    30s
    Sleep    5s
    Click Element    ${CompleteDispense_button}
    Wait Until Page Contains    Please either continue with dispense by entering a reason for discrepancy or return to previous screen to fix dispense
    Wait Until Element Is Visible    id=DiscrepancyDropdownReason    30s
    List Selection Should Be    id=DiscrepancyDropdownReason    \-- Select a Discrepancy Reason --\
    ${list}    Get List Items    id=DiscrepancyDropdownReason
    ${options}    Create List    \-- Select a Discrepancy Reason --\    Weight Change    Provider Order Change    Waste \(Vial Size)\    Other
    Should Be Equal    ${list}    ${options}

Continue With No select droplist No Reason
    Click Button    //*[contains(@id,"SubModalPopup")]//*[@id="SaveBtn" and contains(text(),"Continue")]
    Wait Until Page Contains    A reason for discrepancy must be entered    30s
    Wait Until Page Does Not Contain    A reason for discrepancy must be entered    30s

Continue With No Reason
    Select From List By Label    id=DiscrepancyDropdownReason    Other
    Set Test Variable    ${selected}    Other
    ${reason}    Appointment.Set Reason For Over Or Under Dose    reason_arg=${EMPTY}
    Wait Until Page Contains    A reason for discrepancy must be entered    30s
    Wait Until Page Does Not Contain    A reason for discrepancy must be entered    30s

Continue With Reason
    Util.Select Random From List    xpath_arg=id=DiscrepancyDropdownReason    remove_default_arg=${True}
    ${reason}    Appointment.Set Reason For Over Or Under Dose    reason_arg=Auto_test
    Sleep    5s
    Handle Alert
    ${is_dispened}    Run Keyword And Return Status    Wait Until Page Contains    Appointment Dispensed    30s
    IF    ${is_dispened} == ${True}
        Wait Until Page Does Not Contain    Appointment Dispnesed    30s
    ELSE
        ${is_alert}    Run Keyword And Return Status    Handle Alert
    END
    Appointment.Close Modal
    Add To Dictionary    dic_arg=${AppointmentData}    key_arg=Reason    val_arg=${reason}

Check View Change Reason
    Set Test Variable    ${View}    Tall View
    Appointment.Filter Appointment    date_time=${AppointmentData.APT_DOS}    medication=Actemra    appointment_status=Requires Approval
    Appointment.Filter By Status Appointment    appointment_status=Dispensed
    Sleep    3s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${APT_Search_Link}
    Util.Wait For Page Loading    element_arg=${APT_List_Loading}    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    ${StartTime}    Convert To Upper Case    ${AppointmentData.APT_Time}
    Set Test Variable    ${StartTime}
    ${Xpath_Time}   Util.Replace Xpath    ${Ledger_APT_Time_Xpath}
    Set Suite Variable    ${Xpath_Time}
    ${APT_page_view_changes_btn}    Util.Replace Xpath    xpath=${APT_page_view_changes_btn}
    Scroll Element Into View    ${APT_page_view_changes_btn}
    Scroll Element Into View    ${Xpath_Time}/following::tr[1]
    Wait Until Element Is Visible    ${Xpath_Time}/following::tr[1]    30s
    Wait Until Keyword Succeeds    9s    1s    Click Element    ${APT_page_view_changes_btn}
    Wait Until Element Is Visible    ${APT_changelog_modal}    30s
    Appointment.Close Submodal

Check Question Mark After Dispense With Reason
    Set Test Variable   ${reason}    ${AppointmentData.Reason}
    ${Ledger_med_ques_mark}    Util.Replace Xpath    xpath=${Ledger_med_ques_mark}
    Wait Until Keyword Succeeds    10 times    3s   Mouse Over    ${Ledger_med_ques_mark}
    ${Ledger_med_tooltip}    Util.Replace Xpath    xpath=${Ledger_med_tooltip}
    Wait Until Element Is Visible    ${Ledger_med_tooltip}    30s
    Sleep    1s
    Execute JavaScript    document.activeElement.blur()

Check Medication After Dispense With Reason
    ${Tall_Medication_Text}    Util.Replace Xpath    xpath=${Tall_Medication_Text}
    ${med}    Get Text    ${Tall_Medication_Text}/parent::*
    ${dose}    Get Regexp Matches    ${med}    (?<=-\ \).*(?=\n)
    ${dispense_dose}    Fetch From Left    ${AppointmentData.Dispense_Dose}    ${SPACE}
    Should Be Equal    ${dose}[0]    ${dispense_dose} / ${AppointmentData.Dose} ${AppointmentData.UoM_Scheduling}
    Set Test Variable    ${dose}    ${dispense_dose}
    ${Tall_discrepancy_dose_text}    Util.Replace Xpath    xpath=${Tall_discrepancy_dose_text}
    Element Should Be Visible    ${Tall_discrepancy_dose_text}

Select Therapy In Dispense Now
    Set Test Variable    ${Patient_Select}    ${dispense_now_patient_input}
    Set Test Variable    ${patient_suggestion}    //*[@id='QuickSelectedPatient']//following::*${patient_suggestion}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@id='DeleteBtn' and text()='Reset Quick Dispense']
    Wait Until Element Is Visible    //*[@id='DeleteBtn' and text()='Reset Quick Dispense']    30s
    Wait Until Keyword Succeeds    10 times    3s    Click Button    //*[@id='DeleteBtn' and text()='Reset Quick Dispense']
    Handle Alert    ACCEPT    10s
    Util.Wait For Page Loading    element_arg=//*[@data-notify='message']    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    Appointment.Filter By Patient    patient_arg=${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Wait Until Page Contains    Patient Successfully Assigned to Appointment    30s
    Wait Until Page Does Not Contain    Patient Successfully Assigned to Appointment    30s
    Util.Verify Loading And Select By Label    appointmentTherapy    ${PO_data.PO_Num}
    Util.Wait For Page Loading    element_arg=${dispense_now_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Set Date-Time-Dose In Dispense Now
    ${date}    Wait Until Keyword Succeeds    10 times    3s   Get Value    ${dispense_now_date_input}
    Input Text    ${dispense_now_date_input}    ${date}    clear=True
    ${time}    Wait Until Keyword Succeeds    10 times    3s   Get Value    ${dispense_now_time_input}
    Clear Element Text    ${dispense_now_time_input}
    Input Text    ${dispense_now_time_input}    ${time}
    Execute JavaScript    document.activeElement.blur()
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${asdos_medication_select}
    Wait Until Element Is Visible    ${asdos_medication_select}    30s
    ${UoM}    Get Text    //*[@name='TotalDosage']/parent::*/preceding::*[1]
    ${UoM}    Fetch From Right    ${UoM}    \ \
    ${assigned_dose}    Fetch From Left    ${PO_data.Maint_Dose}    ${SPACE}
    Set To Dictionary    ${AppointmentData}    APT_DOS=${date}    APT_Time=${time}    UoM_Scheduling=${UoM}    Dose=${assigned_dose}
    Set Test Variable    ${AppointmentData}

Setup Data
    ${data_input}    Get Data
    # Setup Testing Flow
    Set Suite Variable    ${testing_flow}    ${data_input}[testing_flow]
    # Common data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${testing_type}    ${data_input}[testing_type]
    # Patient data
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]
    Set Suite Variable    ${location_PO}    ${data_input}[location_PO]
    Set Suite Variable    ${location_PO_2}    ${data_input}[location_PO_2]
    Set Suite Variable    ${first_name}    ${data_input}[first_name]
    Set Suite Variable    ${last_name}    ${data_input}[last_name]
    Set Suite Variable    ${DOB}    ${data_input}[DOB]
    Set Suite Variable    ${weight}    ${data_input}[weight]
    Set Suite Variable    ${height}    ${data_input}[height]
    # PO-PA data
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    Set Suite Variable    ${referring_NPI_PO}    ${data_input}[referring_NPI_PO]
    Set Suite Variable    ${referto_provider_NPI_PO}    ${data_input}[referto_provider_NPI_PO]
    Set Suite Variable    ${patient_weight_PO}    ${data_input}[patient_weight_PO]
    Set Suite Variable    ${patient_height_PO}    ${data_input}[patient_height_PO]
    Set Suite Variable    ${dosage_assigned_value_PO}    ${data_input}[dosage_assigned_value_PO]
    Set Suite Variable    ${calculated_dosage_PO}    ${data_input}[calculated_dosage_PO]
    Set Suite Variable    ${frequency_PO}    5
    Set Suite Variable    ${time_frequency_PO}    ${data_input}[time_frequency_PO]
    Set Suite Variable    ${placeof_service_value_PO}    ${data_input}[placeof_service_value_PO]
    Set Suite Variable    ${container_type_value_PO}    ${data_input}[container_type_value_PO]
    Set Suite Variable    ${split_dose_value_PO}    ${data_input}[split_dose_value_PO]
    Set Suite Variable    ${numberof_split_dose_treatments_value_PO}    ${data_input}[numberof_split_dose_treatments_value_PO]
    # APT data
    Set Suite Variable    ${dose}    ${data_input}[dose]
    Set Suite Variable    ${qty_dispense}    ${data_input}[qty_dispense]
    Set Suite Variable    ${NDC}    ${data_input}[NDC]
    Set Suite Variable    ${lot}    ${data_input}[lot]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${gender}    ${data_input}[gender]
    Set To Dictionary    ${PatientData}    
    ...    Location=${location_PO}
    ...    Location_ID=${location_ID}
    ...    Weight_LB=${weight}    
    ...    Weight_KG=${weight}    
    ...    Refering_Provider=${referring_NPI_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}