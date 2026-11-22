*** Settings ***
Documentation      Verify Schedule Appointment, Provider Order, Prior Auhtorization, Treatment Note, Patient
Library    DependencyLibrary
Library    Dialogs
Resource   ../../../resources/PageObjects/Keywords/ProviderOrders.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/PriorAuthorization.resource
Resource    ../../../resources/PageObjects/Keywords/Appointment.resource
Resource    ../../../resources/PageObjects/Keywords/Dispense.resource
Suite Setup    Suite Setup Keyword
Test Setup    Test Setup Appointment
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    test:retry(2)    Appointment    AP_101

*** Test Cases ***
Verify Appointment Scheduled And Dispensed With PO-PA
    [Documentation]    AP-OI001_TC01, AP-OI002_TC01, AP-OI004_TC01, AP-OI004_TC02, AP-OI001_TC04
    ...    AP-OI001_TC01, AP-OI001_TC02, AP-OI001_TC03
    [Tags]    Smoke    Accounting    Schedule    Dispense
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Scheduling
    ...  report.label.story:Schedule APT with PO/PA
    Wait Until Keyword Succeeds    10 times    3s    Open New Window    url_arg=${homepage}
    Close Window
    Switch To Another Window    title_arg=Home
    Appointment.Create Dictionary Of Appointment Data
    Set Suite Variable    ${Office_Visit_Scheduled}    ${True}    #check IF Office Visit Scheduled along with Appointment OR not
    Set Suite Variable    ${Office_Visit}    ${False}    #check IF Office Visit tested OR not
    Appointment.Schedule Appointment    Medication=Actemra    Therapy=${PO_data.PO_Num}    Dose=20    StartTime=09:21 am    Length=10    visit_starttime=09:26 am    visit_length=15    Location_arg=${PatientData.Location}    #rituxan
    Set To Dictionary    ${AppointmentData}    Nurse=${testing_user}
    Set Suite Variable    ${AppointmentData}
    Set Test Variable    ${View}    Tall View
    Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
    Appointment.Select Ledger View
    Appointment.Check Tall View
    ${is_modal_open}    Run Keyword And Return Status    Wait Until Element Is Visible    ${APT_modal}    10s    #modal issue
    IF    ${is_modal_open} == ${True}
        Appointment.Close Modal
    END
    Wait Until Keyword Succeeds    10 times    3s   Appointment.Filter Appointment    date_time=${LastAppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
    Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${LastAppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    Set Test Variable    ${is_last_APT}    ${True}
    Dispense APT
    Appointment.Close Modal
    Util.Scroll To Top
    Wait Until Keyword Succeeds    10 times    3s    Appointment.Filter Appointment    date_time=${AppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
    Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    Set Test Variable    ${is_last_APT}    ${False}
    Dispense APT
    Appointment.Close Modal
    ${fail}    Run Multiple Keywords And Return Status
    ...    Verify Tall View
    ...    Verify Condensed View
    ...    Verify Calendar View
    # ...    Verify Checkin View
    Set Suite Variable    ${LastAppointmentData}
    Set Suite Variable    ${AppointmentData}
    Run Keyword If    ${fail} > 0    Fail    1 or more views failed

Verify Update PO
    [Documentation]    AP-PO001_TC02, AP-PO002_TC01, AP-PO003_TC01, AP-PO003_TC02
    [Tags]    Smoke    Accounting    PO
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Provider Order
    ...  report.label.story:Verify PO updated in PO page
    Wait Until Keyword Succeeds    10 times    3s    Open New Window    url_arg=${SiteUrl}
    Close Window
    Switch To Another Window    title_arg=Home
    ProviderOrders.Go to Provider Orders
    ProviderOrders.Select Location Provider Orders
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${view_discontinued_service_checkbox}
    ProviderOrders.Click Search PO
    ProviderOrders.Update PO    PO_arg=${PO_data.PO_Num}    freq_arg=${PO_data.Visit_Frequency}    height_arg=${new_height}    container_arg=${PO_data.Container}    num_arg=${PO_data.Num_Of_Treatmtents}
    ProviderOrders.Close Modal
    ProviderOrders.Find PO    PO_arg=${PO_data.PO_Num}
    ProviderOrders.Check Frequency In PO    freq_arg=${PO_data.Visit_Frequency}
    ProviderOrders.Check Weight And Height    weight_arg=${PO_data.Weight}    height_arg=${PO_data.Height}
    ProviderOrders.Check Place Of Service    place_arg=${PO_data.Place_Of_Service}    requested_arg=${PO_data.Requested_Dose}    container_arg=${PO_data.Container}    maint_split_arg=${PO_data.Maint_Dose_Split}    num_split_arg=${PO_data.Num_Of_Treatmtents}
    ProviderOrders.Close Modal
    Inactivate PO
    Set Suite Variable    ${PO_data}

Verify Update PA
    [Documentation]    AP-PA002_TC02, AP-PA003_TC01, AP-PA003_TC02, AP-PA003_TC04
    [Tags]    Smoke    Accounting    PA
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Prior Auhtorization
    ...  report.label.story:Verify PA updated in PA page
    Wait Until Keyword Succeeds    10 times    3s    Open New Window    url_arg=${SiteUrl}
    Close Window
    Switch To Another Window    title_arg=Home
    PriorAuthorization.Go to Prior Authorization Page
    PriorAuthorization.Filter Location    location_arg=${PatientData.Location}
    PriorAuthorization.Filter Patient    patient_arg=${PatientData.MRN}
    PriorAuthorization.Filter Status    status_arg=\-- All Statuses --\
    PriorAuthorization.Filter Date Range    date_arg=${EMPTY}    #first PA created with no start/exp date
    PriorAuthorization.Clear Medication
    PriorAuthorization.Clear Payer And Confirmation Num Search
    PriorAuthorization.Filter Medication Type    type_arg=\-- All Medication Types --\
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${PA_view_discontinued_service_checkbox}
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
    Inactivate PA
    Set Suite Variable    ${PA_data}

Verify Treatment Note After Dispense
    [Documentation]    HD_01, HD_02, HD_03
    [Tags]    Smoke    Accounting    Treatment Note
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Treatment Note
    ...  report.label.story:Set Value To Treatment Note
    ${is_APT_available}    Run Keyword And Return Status    Dictionary Should Contain Key    ${AppointmentData}    DOS
    Run Keyword If    ${is_APT_available} == ${False}    Appointment.Create Dictionary Of Appointment Data
    Set Suite Variable    ${Office_Visit_Scheduled}    ${True}    #check IF Office Visit Scheduled along with Appointment OR not
    Set Suite Variable    ${Office_Visit}    ${False}    #check IF Office Visit tested OR not
    # check PO inactive
    Wait Until Keyword Succeeds    10 times    3s    Open New Window    url_arg=${SiteUrl}
    Close Window
    Switch To Another Window    title_arg=Home
    ProviderOrders.Go to Provider Orders
    ProviderOrders.Select Location Provider Orders
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    Util.Check Or Uncheck Box    view_arg=${True}    xpath_arg=${view_discontinued_service_checkbox}
    ProviderOrders.Click Search PO
    ProviderOrders.Select PO Row To Update    PO_arg=${PO_data.PO_Num}
    Scroll Element Into View    ${discontinue_service_checkbox}
    Wait Until Element Is Visible    ${discontinue_service_checkbox}    30s
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${discontinue_service_checkbox}
    Scroll Element Into View    ${save_PO_bottom_btn}
    Wait Until Element Is Visible    ${save_PO_bottom_btn}    30s
    Sleep    1s
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${save_PO_bottom_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    //*[@id='SaveBtn' and text()='Accept & Continue']
        IF    ${check} == ${True}
            Click Button    //*[@id='SaveBtn' and text()='Accept & Continue']
        END
        Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    ${PO_accept_button}
        Wait Until Element Is Visible     ${PO_accept_button}    60s
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${PO_accept_button}
    END
    Util.Wait For Page Loading    element_arg=Provider Order Successfully Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Run Keyword And Ignore Error    Appointment.Close Modal
    Open New Window    url_arg=${homepage}
    Close Window
    Switch To Another Window    title_arg=Home
    Appointment.Go Dispensing
    Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
    ${is_APT_available}    Run Keyword And Return Status    Dictionary Should Contain Key    ${AppointmentData}    DOS
    IF    ${is_APT_available} == ${False}
        Appointment.Schedule Appointment    Medication=Actemra    Therapy=${PO_data.PO_Num}    Dose=20    StartTime=09:21 am    Length=10    visit_starttime=09:26 am    visit_length=15    Location_arg=${PatientData.Location}
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Set Test Variable    ${View}    Tall View
        Appointment.Select Ledger View
        Appointment.Check Tall View
        Appointment.Filter Appointment    date_time=${LastAppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
        Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
        Set Test Variable    ${is_last_APT}    ${True}
        Dispense APT
        Get Last Treatment Note Data
        Appointment.Close Modal
        Sleep    5s
        Appointment.Filter Appointment    date_time=${AppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
        Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
        Set Test Variable    ${is_last_APT}    ${False}
        Dispense APT
    ELSE
        Set Test Variable    ${View}    Tall View
        Appointment.Filter Appointment    date_time=${LastAppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
        Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
        ${is_dispensed}    Run Keyword And Return Status    Dictionary Should Contain Item    ${LastAppointmentData}    Is_Dispensed    ${True}
        IF    ${is_dispensed} == ${False}
            Set Test Variable    ${is_last_APT}    ${True}
            Dispense APT
        END
        Get Last Treatment Note Data
    END
    Appointment.Close Modal
    Util.Scroll To Top
    Set Test Variable    ${View}    Tall View
    Appointment.Filter Appointment    date_time=${AppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=\-- All Statuses --\
    ${is_dispensed}    Run Keyword And Return Status    Dictionary Should Contain Item    ${AppointmentData}    Is_Dispensed    ${True}
    IF    ${is_dispensed} == ${False}
        Run Keyword And Ignore Error    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
        Set Test Variable    ${is_last_APT}    ${False}
        Dispense APT
        Appointment.Close Modal
        Set Test Variable    ${View}    Tall View
        Appointment.Filter Appointment    date_time=${AppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
    END
    Appointment.Open Treatment Note
    ${is_publi}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    Appointment.Check If Treatment Note Published
    IF    ${is_publi} == ${True}
        Scroll Element Into View    id=UnpublishEncounterNoteCheckbox
        Wait Until Keyword Succeeds    10 times    3s    Select Checkbox    id=UnpublishEncounterNoteCheckbox
        Wait Until Keyword Succeeds    10 times    3s    Click Element    link: Unlock Treatment Note
        Util.Wait For Page Loading    element_arg=Treatment Note Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    END
    @{values}    Create list    ${bld_pressure}    ${hrt_rate}    ${temp_F}    ${resp_rate}    ${SPO2}    ${oxygen}    #list of values to input
    ${check_asm}    Run Keyword And Return Status   Appointment.Set Value To Assessment    time_arg=${tnote_start_time}    values_arg=${values}
    ${check_acam}    Run Keyword And Return Status    Appointment.Set Value To Access And Admin    values_arg=None
    ${check_mefl}    Run Keyword And Return Status    Appointment.Set Value To Meds And Fluids    size_arg=${medication_size}    vol_wdrawn_arg=${volumn_wdrawn}    med_arg=${second_med}    qty_arg=${second_med_qty}    time_arg=${second_med_time}    lot_arg=${lot_second}
    @{values}    Create list    ${drip_rate}    ${bld_pressure_proc}    ${hrt_rate_proc}    ${temp_F_proc}    ${resp_rate_proc}    ${SPO2_proc}    ${oxygen}    #procedural
    ${check_pddt}    Run Keyword And Return Status    Appointment.Set Value To Procedural Details    rate_arg=${max_drip_rate}    values_arg=${values}
    @{values}    Create list    ${bld_pressure_proc}    ${hrt_rate_proc}    ${temp_F_proc}    ${resp_rate_proc}    ${SPO2_proc}    ${oxygen}
    ${check_rtdt}    Run Keyword And Return Status    Appointment.Set Value To Reaction Details    values_arg=${values}
    ${check_ptdc}    Run Keyword And Return Status    Appointment.Set Value To Patient Discharge    time_arg=${tnote_end_time}    PIN_arg=${PIN}
    @{values}    Create list    Test Note
    ${check_pdca}    Run Keyword And Return Status    Appointment.Set Value To Post DC Activity    values_arg=${values}
    ${list}    Create List    ${check_asm}    ${check_acam}    ${check_mefl}    ${check_pddt}    ${check_rtdt}    ${check_ptdc}    ${check_pdca}
    ${fail}    Evaluate    0
    FOR    ${check}    IN    @{list}
        IF    ${check} == ${False}
            ${fail}    Evaluate    ${fail} + 1
        END
    END
    Wait Until Keyword Succeeds    10 times    3s    Appointment.Close Modal
    Set Suite Variable    ${TNoteData}
    Run Keyword If    ${fail} > 0    Fail    1 or more sections failed

Verify Update Patient
    [Documentation]   AP-P002_TC01
	[Tags]    Smoke    Accounting    Patient
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Patient
    ...  report.label.story:Update Patient
    Wait Until Keyword Succeeds    10 times    3s    Open New Window    url_arg=${SiteUrl}
    Close Window
    Switch To Another Window    title_arg=Home
    Patient.Update Patient
    Set Suite Variable    ${PatientData}
    Run Keyword If    ${fail} > 0    Fail    1 or more fields failed

*** Keywords ***
Open New Window
    [Arguments]    ${url_arg}
    Execute Javascript    window.open('${url_arg}','_blank')
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Set Window Size    1920    1080
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title_arg}
    Switch Window    title=${title_arg}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    ${title_arg}
    Wait Until Keyword Succeeds    30s    1s    Check Newsletter

Suite Setup Keyword    #Keyword
    [Documentation]    Suite Setup
    [Tags]    Setup
    # Register Keyword To Run On Failure    NONE
    Setup Data
    Patient.Create Dictionary Of Patient Data
    ProviderOrders.Create Dictionary Of PO Data
    Create Dictionary Of Inventory Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    Check Newsletter
    Create Patient    #TC AP-P001_TC01

PO Teardown
    Depends On Test    Schedule Appointment With PO-PA
    Depends On Test    Verify PO Created
    Switch To Another Window    title_arg=Provider Orders
    ProviderOrders.Filter Location    location_arg=${PatientData.Location}
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    ProviderOrders.Click Search PO
    ProviderOrders.Find PO Row    PO_arg=${PO_data.PO_Num}
    ProviderOrders.Select PO Row To Update    PO_arg=${PO_data.PO_Num}
    CommonKeywords.Close Browser Session

Test Setup Appointment
    ${is_PO_created}    Run Keyword And Return Status    Dictionary Should Contain Key    ${PO_data}    PO_Num
    Return From Keyword If    ${is_PO_created}    PO created
    Create PO
    Update PA    #AP-PA002_TC02

Create Dictionary Of Inventory Data
    &{invent_data}    Create Dictionary
    Set Suite Variable    ${invent_data}

Create Patient
    Patient.Go To Patients Page
    Patient.Filter Location In Patients Page    Location_arg=${location_PO}
    Set To Dictionary    ${PatientData}    Location=${location_PO}    Location_ID=${location_ID}
    Patient.Check Patient In Patients Page    MRN_arg_1=${MRN_1}    MRN_arg_2=${MRN_2}    MRN_arg_3=${MRN_merge}   #MRN_merge: patient to be merged only
    Patient.Create Patient    First_Name_arg=${first_Name}    Last_Name_arg=${last_Name}    DOB_arg=${DOB}    Weight_arg=${weight}    Height_arg=${height}
    Set Suite Variable    ${PatientData}

Create PO
    Open New Window    url_arg=${homepage}
    Close Window
    Switch To Another Window    title_arg=Home
    ProviderOrders.Go to Provider Orders
    ProviderOrders.Select Location Provider Orders
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Calculate PO End Date
    ProviderOrders.Filter Date Range    date_arg=${end_date}
    ProviderOrders.Click Search PO
    # ProviderOrders.Check PO List
    ProviderOrders.Select Ordering Location    location_arg=${PatientData.Location}
    ProviderOrders.Input A Patient    patient_arg=${PatientData.MRN}
    IF    "aws" in "${SiteUrl}"
        Unselect Checkbox    id=FilterMedsByPrimaryICDs
        Wait Until Keyword Succeeds    10 times    3s    Checkbox Should Not Be Selected    id=FilterMedsByPrimaryICDs
    END
    ProviderOrders.Select Treatment Drug    drug_arg=${drug_PO}
    ProviderOrders.Click Diagnosis    DX_arg=M05.669
    ProviderOrders.Click Create Button
    ProviderOrders.Get PO Number
    ProviderOrders.Get PO Dates
    ProviderOrders.Input Referring/Ordering Provider    refer_arg=${referring_NPI_PO}
    ProviderOrders.Select Refer To Provider    refer_to_arg=${referto_provider_NPI_PO}
    ProviderOrders.Select Visit Frequency    frequency_arg=Day
    ProviderOrders.Input Weight And Height    patient_weight_arg=${patient_weight_PO}    patient_height_arg=${patient_height_PO}
    ProviderOrders.Input Dose And Frequency    dosageAssignedValue_arg=${dosage_assigned_value_PO}    calculated_dosage_arg=${calculated_dosage_PO}    dose_frequency_arg=${dosage_assigned_value_PO}    time_frequency_arg=${time_frequency_PO}
    ProviderOrders.Select Place Of Service And Preferred UoM And Container Type    placeOfserviceValue_arg=${placeof_service_value_PO}    requested_dose_arg=10    containerTypeValue_arg=${container_type_value_PO}    splitDoseValue_arg=${split_dose_value_PO}    numberOfsplitDosetreatmentsValue_arg=${numberof_split_dose_treatments_value_PO}
    Wait Until Keyword Succeeds    10 times    3s    ProviderOrders.Close Modal

Verify PO created
    ProviderOrders.Filter Location    location_arg=${PatientData.Location}
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${view_signed_PO_checkbox}
    ProviderOrders.Click Search PO
    ProviderOrders.Find PO    PO_arg=${PO_data.PO_Num}
    ProviderOrders.Check Location    location_arg=${PatientData.Location}
    ProviderOrders.Check PO Num    num_arg=${PO_data.PO_Num}
    ProviderOrders.Check Patient
    ProviderOrders.Check Dates    entry_arg=${PO_data.Entry_Date}    start_arg=${PO_data.Start_Date}    exp_arg=${PO_data.Exp_Date}
    ProviderOrders.Check Providers    referring_arg=${PO_data.Referring_Provider}    referral_arg=${PO_data.Referral_Source}    refer_to_arg=${PO_data.Refer_To_Provider}
    ProviderOrders.Check Frequency In PO    freq_arg=${PO_data.Visit_Frequency}
    ProviderOrders.Check Weight And Height    weight_arg=${PO_data.Weight}    height_arg=${PO_data.Height}
    ProviderOrders.Check Dose And Frequency    route_arg=${PO_data.Route}    maint_arg=${PO_data.Maint_Dose}    freq_arg=${PO_data.Dose_Frequency}    calculated_arg=${PO_data.Calculated_Dose}    weight_arg=${PO_data.Weight}
    ProviderOrders.Check Place Of Service    place_arg=${PO_data.Place_Of_Service}    requested_arg=${PO_data.Requested_Dose}    container_arg=${PO_data.Container}    maint_split_arg=${PO_data.Maint_Dose_Split}    num_split_arg=${PO_data.Num_Of_Treatmtents}
    ProviderOrders.Close Modal

Update PA
    PriorAuthorization.Create Dictionary Of PA Data
    Open New Window    url_arg=${SiteUrl}
    Close Window
    Switch To Another Window    title_arg=Home
    PriorAuthorization.Go to Prior Authorization Page
    PriorAuthorization.Filter Location    location_arg=${PatientData.Location}
    PriorAuthorization.Filter Patient    patient_arg=${PatientData.MRN}
    PriorAuthorization.Filter Status    status_arg=\-- All Statuses --\
    PriorAuthorization.Filter Date Range    date_arg=${EMPTY}    #first PA created with no start/exp date
    PriorAuthorization.Clear Medication
    PriorAuthorization.Clear Payer And Confirmation Num Search
    PriorAuthorization.Filter Medication Type    type_arg=\-- All Medication Types --\
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}
    PriorAuthorization.Click Edit PA Button
    PriorAuthorization.Initialize PA    status_arg=Approved    start_date_arg=${PO_data.Start_Date}    end_date_arg=${PO_data.Exp_Date}    type_arg=Buy and Bill
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
    Set Suite Variable    ${PA_data}

Dispense APT
    ${is_auto_approved}    Run Keyword And Return Status    Element Should Be Visible    ${open_APT_dispensed_header_text}
    IF    ${is_auto_approved} == ${False}
        Select Qty And Med To Dispense    qty_arg=${qty_dispense}    med_arg=${NDC}    lot_arg=${lot}
        Add To Dictionary    dic_arg=${invent_data}    key_arg=Dispense_Facility    val_arg=${selected}
        Complete Dispense For PO Flow    facility_arg=${invent_data.Dispense_Facility}
    ELSE
        ${is_auto_dispensed}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View     //*[@id='AppointmentDispenseTable']//*[contains(text(),'Dispensed by')]
        Scroll Element Into View    //*[contains(text(),'Adjust') and contains(@onclick,'confirm')]
        Wait Until Keyword Succeeds    10 times    3s    Click Element   //*[contains(text(),'Adjust') and contains(@onclick,'confirm')]
        Handle Alert    ACCEPT    30s
        Wait For Page Loading    element_arg=//*[@id='DosageCalculation']//*[contains(@class,'loading-spinner')]    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
        IF    ${is_auto_dispensed} == ${False}
            Select Qty And Med To Dispense    qty_arg=${qty_dispense}    med_arg=${NDC}    lot_arg=${lot}
            Add To Dictionary    dic_arg=${invent_data}    key_arg=Dispense_Facility    val_arg=${selected}
            Complete Dispense For PO Flow    facility_arg=${invent_data.Dispense_Facility}
        ELSE
            ${check_NDC}    Get Selected List Label    //*[@id='DosageCalculation']//*[@class="lineDetail"]//*[@id="SelectedItem"]
            Should Contain    ${check_NDC}    ${NDC}    strip_spaces=True
            ${check_qty}    SeleniumLibrary.Get Element Attribute    ${DispenseQty_input}    value
            Should Be Equal As Numbers    ${check_qty}    1
            Scroll Element Into View    link:Change Dispense Dosage 
            Wait Until Keyword Succeeds    30s    1s    Click Element    link:Change Dispense Dosage 
            Wait Until Page Contains    Dosage Has Been Accepted!    timeout=20s
            Wait Until Element Is Visible    ${asdos_show_all_lots_checkbox}    30s
            Scroll Element Into View    //*[@id='DosageCalculation']//*[contains(@id,'AppointmentDispenseTable')]//select[@id='Facility']
            ${check_facility}    Get Selected List Label    //*[@id='DosageCalculation']//*[contains(@id,'AppointmentDispenseTable')]//select[@id='Facility']
            ${check_facility}    Fetch From Left    ${check_facility}    \ \)\
            ${check_facility}    Set Variable    ${check_facility}\)
            Add To Dictionary    dic_arg=${invent_data}    key_arg=Dispense_Facility    val_arg=${check_facility}
            Complete Dispense For PO Flow    facility_arg=${invent_data.Dispense_Facility}
        END
    END

Verify Tall View
    ${check}    Run Keyword And Return Status    Element Should Be Visible    //*[@id='ModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        Run Keyword And Ignore Error    Scroll Element Into View    ${APT_page_close_PO_btn}
        Run Keyword And Ignore Error    Click Button    ${APT_page_close_PO_btn}
    END
    Appointment.Select Ledger View
    Set Test Variable    ${View}    Tall View
    Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
    Appointment.Check Tall View
    ${date_time}    Set Variable    ${AppointmentData.DOS}
    Appointment.Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
    Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
    Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
    Appointment.Get Appointment ID    Type=APT_ID
    Appointment.Check Date Of Service Label
    Appointment.Check Appointment Place    Place=${AppointmentData.Place}
    Appointment.Check Appointment Status
    Appointment.Check Treatment Clinician    #Nurse to be set up next
    Appointment.Check Patient
    Appointment.Check DX Code
    Appointment.Check Medication    Type=Appointment
    Appointment.Check Refer To Provider
    Appointment.Check PO And PA In Tall View
    Appointment.Close Modal
    Appointment.Check Weight In Tall View
    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    Appointment.Check Patient In AsDos Modal
    Appointment.Close Modal
    Set Suite Variable    ${AppointmentData}

Verify Condensed View
    Set Test Variable    ${View}    Condensed View
    Appointment.Select Condensed View    #Check Condensed View
    Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
    Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
    Appointment.Check Appointment ID    Check_ID=${AppointmentData.APT_ID}
    Appointment.Check Date Of Service Label
    Appointment.Check Appointment Place    Place=${AppointmentData.Place}
    Appointment.Check Appointment Status
    Appointment.Check Treatment Clinician    #Nurse to be set up next
    Appointment.Check Patient
    Appointment.Check DX Code    
    Appointment.Check Medication    Type=Appointment
    Appointment.Check PO In Condensed View
    Appointment.Check PA In Condensed View
    Appointment.Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    Appointment.Check Patient In AsDos Modal
    Appointment.Close Modal

Verify Calendar View
    Appointment.Select Calendar View
    Appointment.Check Number Of Places
    # Check Calendar Table
    Appointment.Check Time - Calendar    StartTime=${AppointmentData.Start_Time}    Place=${AppointmentData.Place}
    Appointment.Check Name - Calendar
    Appointment.Check DOB - Calendar
    Appointment.Check Medication - Calendar    Type=Appointment
    Appointment.Check Status - Calendar
    # Check Popover Table when hovering mouse
    Appointment.Check Location - Popover
    Appointment.Check Date Of Service - Popover    Date=${AppointmentData.DOS}
    Appointment.Check Patient - Popover
    Appointment.Check DOB - Popover
    Appointment.Check DX Code - Popover
    Appointment.Check Description - Popover    Type=Appointment
    Appointment.Check Dose - Popover
    Appointment.Check UoM - Popover
    Execute JavaScript    document.activeElement.blur()
    Sleep    1s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${APT_Time_XPath}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${open_APT_dispensed_header_text}    30s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Select Calendar View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Appointment.Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${APT_Time_XPath}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Time_XPath}
        Wait Until Element Is Visible    ${open_APT_dispensed_header_text}    30s
    END
    Wait For Page Loading    element_arg=${assign_dosage_modal_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Appointment.Check Patient In AsDos Modal
    Appointment.Close Modal

Verify Checkin View
    Set Test Variable    ${View}    Check-In View
    Appointment.Select Check-In View
    Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
    Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
    Appointment.Check Appointment Status
    Appointment.Check Location - Check-In
    Appointment.Check Patient
    Appointment.Check Medication    Type=Appointment
    Appointment.Check PO In Check-In View
    Appointment.Check PA In Check-In View
    ${check}    Run Keyword And Return Status    Appointment.Click Open APT Button    btn_arg=${view_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    IF    ${check} == ${False}    #issue
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Appointment.Filter Appointment    date_time=${AppointmentData.DOS}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Appointment.Select Check-In View
        Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
        Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
        Appointment.Check Appointment Status
        Appointment.Check Location - Check-In
        Appointment.Check Patient
        Appointment.Check Medication    Type=Appointment
        Appointment.Check PO In Check-In View
        Appointment.Check PA In Check-In View
        Appointment.Click Open APT Button    btn_arg=${view_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
    END
    Appointment.Check Patient In AsDos Modal
    Appointment.Close Modal

Select Qty And Med To Dispense
    [Arguments]    ${qty_arg}    ${med_arg}    ${lot_arg}
    FOR    ${i}    IN RANGE    10
        Dispense.Select Item Therapy    therapy_item=${med_arg}
        ${selected}    Get Selected List Label    //*[@class="lineDetail"]//*[@id="SelectedItem"]
        ${check}    Run Keyword And Return Status    Should Contain    ${selected}    ${med_arg}
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    3s
    END
    Should Be True    ${check} == ${True}
    Wait Until Keyword Succeeds    10 times    6s    Dispense.Input Qty ${qty_arg}
    Click Element    link:Refresh Items    #issue
    Sleep    5s
    ${selected}    Get Selected List Label    //*[@class="lineDetail"]//*[@id="SelectedItem"]
    ${check}    Run Keyword And Return Status    Should Contain    ${selected}    ${med_arg}
    IF    ${check} == ${False}
        Dispense.Select Item Therapy    therapy_item=${med_arg}
    END
    ${qty}    Get Value    ${DispenseQty_input}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${qty}    ${qty_arg}
    Run Keyword If    ${check} == ${False}    Dispense.Input Qty ${qty_arg}
    FOR    ${i}    IN RANGE    2
        Execute JavaScript    document.activeElement.blur()
    END
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    link:Start Dispense 
    IF    ${check} == ${True}
        Wait Until Element Is Enabled    link:Start Dispense 
        Wait Until Keyword Succeeds    30s    1s    Click Element    link:Start Dispense 
    ELSE
        Scroll Element Into View    link:Approve Container Sizes 
        Wait Until Element Is Enabled    link:Approve Container Sizes 
        Wait Until Keyword Succeeds    30s    1s    Click Element    link:Approve Container Sizes 
    END
    Wait Until Page Contains    Dosage Has Been Accepted!    timeout=20s
    Wait Until Element Is Visible    ${asdos_show_all_lots_checkbox}    30s
    ${check}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Attribute    ${asdos_show_all_lots_checkbox}    checked
    ${check}    Run Keyword And Return Status    Element Attribute Value Should Be    ${asdos_show_all_lots_checkbox}    checked    true
    IF    ${check} == ${False}
        Sleep    2s
        Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${asdos_show_all_lots_checkbox}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${asdos_show_all_lots_checkbox}
        Sleep    1s
    END
    Scroll Element Into View    ${asdos_lot_num_selection_text}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${asdos_lot_select}    ${lot_arg}
    Wait For Page Loading    element_arg=Dispense Line Updated    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Visible    timeout_arg=30s
    Run Keyword And Ignore Error    Wait Until Keyword Succeeds    30s    1s    Select From List By Index    //*[@id='SiteOfTherapyId_0']    1    #med to set up
    Run Keyword And Ignore Error    Wait For Page Loading    element_arg=Dispense Line Updated    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Visible    timeout_arg=30s
    Scroll Element Into View    ${SelectFacilityDispense_select}
    Util.Select Random From List    xpath_arg=${SelectFacilityDispense_select}    remove_default_arg=${False}
    ${selected}    Fetch From Left    ${selected}    \ \)\
    ${selected}    Set Variable    ${selected}\)
    Add To Dictionary    dic_arg=${invent_data}    key_arg=Dispense_Facility    val_arg=${selected}
    Set To Dictionary    ${AppointmentData}    Qty_Dispense=${qty_arg}    NDC=${med_arg}    Lot=${lot_arg}
    Set Suite Variable    ${AppointmentData}

Complete Dispense For PO Flow
    [Arguments]    ${facility_arg}
    Wait Until Element Is Enabled    ${CompleteDispense_button}    30s
    Click Element    ${CompleteDispense_button}
    TRY
        Handle Alert    ACCEPT    10s
    EXCEPT
        Wait Until Page Contains     - Check Total Dispense Amount    30s
        Dispense.Handle Alert Under/Over Vs Assigned Dose
    FINALLY
        Run Keyword If    ${is_last_APT} == ${True}    Run Keywords
        IF    ${is_last_APT} == ${True}
            Set To Dictionary    ${LastAppointmentData}    Is_Dispensed=${True}
            Set Test Variable    ${LastAppointmentData}
        ELSE
            Set To Dictionary    ${AppointmentData}    Is_Dispensed=${True}
            Set Test Variable    ${AppointmentData}
        END
        ${type}    Replace String    ${PA_data.Medication_Type}    and    \&
        ${facility_arg}    Remove String    ${facility_arg}    \ \(${type}\ \)
        Wait Until Page Contains    Dispensed from ${facility_arg}    timeout=30s
        Wait Until Element Is Not Visible    ${CompleteDispense_button}    30s
    END

Inactivate PO
    Util.Scroll To Top
    ProviderOrders.Filter Location    location_arg=${PatientData.Location}
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${view_signed_PO_checkbox}
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${view_discontinued_service_checkbox}    #true
    ProviderOrders.Click Search PO
    ProviderOrders.Select PO Row To Update    PO_arg=${PO_data.PO_Num}
    ProviderOrders.Discontinue PO    xpath_arg=${discontinue_service_checkbox}
    Appointment.Close Modal
    ProviderOrders.Filter Location    location_arg=${PatientData.Location}
    ProviderOrders.Filter Patient    patient_arg=${PatientData.MRN}
    ProviderOrders.Filter Date Range    date_arg=${PO_data.Exp_Date}
    Util.Check Or Uncheck Box    view_arg=${True}    xpath_arg=${view_discontinued_service_checkbox}    #
    ProviderOrders.Click Search PO
    ProviderOrders.Check PO Discontinued    PO_arg=${PO_data.PO_Num}
    Set To Dictionary    ${PO_data}    Is_Active=${False}
    Set Test Variable    ${PO_data}

Inactivate PA
    Util.Scroll To Top
    PriorAuthorization.Filter Location    location_arg=${PatientData.Location}
    PriorAuthorization.Filter Patient    patient_arg=${PatientData.MRN}
    PriorAuthorization.Filter Status    status_arg=Approved
    PriorAuthorization.Filter Date Range    date_arg=${PA_data.End_Date}
    PriorAuthorization.Filter Medication Type    type_arg=${PA_data.Medication_Type}
    PriorAuthorization.Clear Payer And Confirmation Num Search
    Util.Check Or Uncheck Box    view_arg=${False}    xpath_arg=${PA_view_discontinued_service_checkbox}
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}    #find PA by PO num
    PriorAuthorization.Click Edit PA Button
    PriorAuthorization.Discontinue PA    xpath_arg=${PA_discontinue_service_checkbox}
    PriorAuthorization.Close Modal
    PriorAuthorization.Check PA Discontinued    PO_arg=${PO_Num}
    Set To Dictionary    ${PA_data}    Is_Active=${False}
    Set Test Variable    ${PA_data}

Get Last Treatment Note Data
    ${dosage}    Get Text    ${asdos_dosage_text}
    ${dosage}    Get Regexp Matches    ${dosage}    (?<=Dosage:\ ).*(?=\ Milligram)
    ${dispensed_dose}    Get Text    ${asdos_dispensed_dose_text}
    ${dispensed_dose}    Strip String    ${dispensed_dose}
    Set To Dictionary    ${LastAppointmentData}    Dosage=${dosage}[0]    Dispensed_Dose=${dispensed_dose}    Qty_Dispense=1    NDC=${NDC}    Lot=${lot}
    Set Suite Variable    ${LastAppointmentData}

Cancel Appointment After Scheduling
    Set Suite Variable    ${View}    Ledger View
    Appointment.Select Ledger View
    Appointment.Check Tall View
    Appointment.Find Appointment To Cancel    medication_arg=${PO_data.Medication}    time_arg=${AppointmentData.Start_Time}    dos_arg=${AppointmentData.DOS}    #find appointment
    Check Office Visit Scheduled OR not
    Appointment.Find Appointment To Cancel    medication_arg=\-- No Medication Assigned / Empty --\    time_arg=${AppointmentData.Visit_Start_Time}    dos_arg=${AppointmentData.Visit_DOS}    #find office visit

Run Multiple Keywords And Return Status
    [Arguments]    @{kw_args}
    ${count}    Evaluate    0
    FOR    ${kw}    IN    @{kw_args}
        ${status}    Run Keyword And Return Status    ${kw}
        IF    ${status} == ${False}
            ${count}    Evaluate    ${count} + 1
        END
    END
    RETURN    ${count}

Setup Data
    # Common data
    ${data_input}    Get Data
    Set Suite Variable    ${testing_type}    ${data_input}[testing_type]    #smoke
    Set Suite Variable    ${mode}    headless    #UI
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${testing_user}    ${data_input}[testing_user]
    Set Suite Variable    ${PIN}    ${data_input}[PIN_physician]
    # Patient data
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]
    Set Suite Variable    ${location_PO}    ${data_input}[location_PO]
    Set Suite Variable    ${location_PO_2}    ${data_input}[location_PO_2]    #location on system with 2 labels (names)
    Set Suite Variable    ${first_Name}    ${data_input}[first_name]
    Set Suite Variable    ${last_Name}    ${data_input}[last_Name]
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
    Set Suite Variable    ${time_frequency_PO}    ${data_input}[time_frequency_PO]
    Set Suite Variable    ${placeof_service_value_PO}    ${data_input}[placeof_service_value_PO]
    Set Suite Variable    ${container_type_value_PO}    ${data_input}[container_type_value_PO]
    Set Suite Variable    ${split_dose_value_PO}    ${data_input}[split_dose_value_PO]
    Set Suite Variable    ${numberof_split_dose_treatments_value_PO}    ${data_input}[numberof_split_dose_treatments_value_PO]
    Set Suite Variable    ${time_zone}    ${data_input}[time_zone]
    Set Suite Variable    ${new_height}    ${data_input}[new_height]
    # APT data
    Set Suite Variable    ${qty_dispense}    ${data_input}[qty_dispense]
    Set Suite Variable    ${NDC}    ${data_input}[NDC]
    Set Suite Variable    ${lot}    ${data_input}[lot]
    # TNote data
    Set Suite Variable    ${tnote_start_time}    ${data_input}[tnote_start_time]
    Set Suite Variable    ${tnote_end_time}    ${data_input}[tnote_end_time]
    Set Suite Variable    ${bld_pressure}    ${data_input}[bld_pressure]
    Set Suite Variable    ${hrt_rate}    ${data_input}[hrt_rate]
    Set Suite Variable    ${temp_F}    ${data_input}[temp_F]
    Set Suite Variable    ${resp_rate}    ${data_input}[resp_rate]
    Set Suite Variable    ${SPO2}    ${data_input}[SPO2]
    Set Suite Variable    ${oxygen}    ${data_input}[oxygen]
    Set Suite Variable    ${medication_size}    ${data_input}[medication_size]
    Set Suite Variable    ${volumn_wdrawn}    ${data_input}[volumn_wdrawn]
    Set Suite Variable    ${second_med}    ${data_input}[second_med]
    Set Suite Variable    ${second_med_qty}    ${data_input}[second_med_qty]
    Set Suite Variable    ${second_med_time}    ${data_input}[second_med_time]
    Set Suite Variable    ${lot_second}    ${data_input}[lot_second]
    Set Suite Variable    ${max_drip_rate}    ${data_input}[max_drip_rate]
    Set Suite Variable    ${drip_rate}    ${data_input}[drip_rate]
    Set Suite Variable    ${bld_pressure_proc}    ${data_input}[bld_pressure_proc]
    Set Suite Variable    ${hrt_rate_proc}    ${data_input}[hrt_rate_proc]
    Set Suite Variable    ${temp_F_proc}    ${data_input}[temp_F_proc]
    Set Suite Variable    ${resp_rate_proc}    ${data_input}[resp_rate_proc]
    Set Suite Variable    ${SPO2_proc}    ${data_input}[SPO2_proc]
    # Different data for each flow (full or partial)
    Set Suite Variable    ${MRN_1}    ${data_input}[MRN_1]
    Set Suite Variable    ${MRN_2}    ${data_input}[MRN_2]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]    #patient to be merged only