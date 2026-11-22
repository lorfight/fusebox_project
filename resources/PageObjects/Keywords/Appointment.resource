*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Library    DateTime
Library    String
Library    pandas
Library    XML
Library    Dialogs
Variables    ../Locators/CommonLocator.py
Variables    ../Locators/DispenseLocator.py
Variables    ../Locators/Appointment.py
Variables    ../TestData/Testdata.py
Resource    ../../../libraries/Util.resource

*** Keywords ***
Create Dictionary Of Appointment Data
    &{AppointmentData}    Create Dictionary
    Set Suite Variable    ${AppointmentData}
    &{LastAppointmentData}    Create Dictionary
    Set Suite Variable    ${LastAppointmentData}
    &{LastTNoteData}    Create Dictionary
    Set Suite Variable    ${LastTNoteData}
    &{TNoteData}    Create Dictionary
    Set Suite Variable    ${TNoteData}

Schedule Appointment
    [Arguments]    ${Medication}    ${Therapy}    ${Dose}    ${StartTime}    ${Length}    ${visit_starttime}    ${visit_length}    ${Location_arg}
    Go Dispensing
    Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${Location_arg}
    Go To Schedule New Appointment
    Select Location - Schedule Appointment Popup    Location_arg=${Location_arg}
    ${Patient}    Set Variable    ${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Sleep    5s
    Select Patient    ${Patient}
    Check Patient - Schedule Appointment
    Selected Therapy    ${Therapy}
    Select DX Code
    Select Physician
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    id=reasonSkipRequiredOfficeVisit
    IF    ${check} == ${True}
        Input Text    id=reasonSkipRequiredOfficeVisit    test
        Click Button    Continue & Schedule
        Wait Until Element Is Not Visible    id=reasonSkipRequiredOfficeVisit    30s
    END
    Select Medications And dosages For Therapy    ${Dose}
    Config Scheduling    ${StartTime}    ${Length}    ${visit_starttime}    ${visit_length}
    ${Check_APT_Created}    Run Keyword And Return Status    Wait Until Page Contains    Appointment Created!    timeout=30s
    IF    ${Check_APT_Created} == ${True}
        Wait Until Page Does Not Contain    Appointment Created!    timeout=30s
    END
    Set To Dictionary    ${AppointmentData}    Medication=${Medication}    Therapy=${Therapy}    Dose=${Dose}    DX_Code=${DX_Code}
    Set Test Variable    ${AppointmentData}

Select Therapy Before Scheduling
    Create Dictionary Of Appointment Data
    Set Suite Variable    ${Office_Visit_Scheduled}    ${True}
    Set Suite Variable    ${Office_Visit}    ${False}
    Go Dispensing
    Wait Until Keyword Succeeds    10 times    3s    Search By Location    Location_arg=${PatientData.Location}
    Go To Schedule New Appointment
    Select Location - Schedule Appointment Popup    Location_arg=${PatientData.Location}
    ${Patient}    Set Variable    ${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Select Patient    ${Patient}
    # Check Patient - Schedule Appointment
    Selected Therapy    ${PO_data.PO_Num}
    Select DX Code
    Select Physician
    Select Medications And dosages For Therapy    ${dose}
    Set To Dictionary    ${AppointmentData}    NDC=${NDC}    Dose=${dose}
    Set Suite Variable    ${AppointmentData}

Go Dispensing
    Click Element    ${DispensingLink}
    Click Element    ${NewDispenseLink}
    Title Should Be    Appointment Ordering Ledger
Go To Schedule New Appointment
    Scroll Element Into View    link: Schedule New Appointment
    Wait Until Element Is Visible    link: Schedule New Appointment    30s
    Click Element    link: Schedule New Appointment
    Page Should Contain Element    ${Sched_APT_Popup_Text}    Open Schedule Appointment Failed
Search By Location
    [Arguments]    ${Location_arg}
    Sleep    5s
    Select From List By Label    //*[@id='MemberId']    ${PatientData.Location}
    Wait Until Keyword Succeeds    10 times    3s    List Selection Should Be    //*[@id='MemberId']    ${PatientData.Location}

Select Location - Schedule Appointment Popup
    [Arguments]    ${Location_arg}
    Wait Until Element Is Enabled    ${SelectLocation_select}    timeout=10s
    Util.Verify Loading And Select By Label    ${SelectLocation_select}    ${Location_arg}
Select Patient
    [Arguments]    ${patient}
    Util.Input And Verify    ${patient}    locator_input=${SelectPatient_input}
    ${PatientSelected_click}     Replace Variables    ${PatientSelected_click}
    Wait Until Element Is Enabled    ${PatientSelected_click}
    Wait Until Element Is Visible    ${PatientSelected_click}    60s
    Wait Until Keyword Succeeds    10 times    3s    CLick ELement    ${PatientSelected_click}
Check Patient - Schedule Appointment
    Wait Until Element Is Visible    ${Sched_Popup_Patient_Name_Text}    60s
    SeleniumLibrary.Element Text Should Be    ${Sched_Popup_Patient_Name_Text}    ${PatientData.First_Name} ${PatientData.Last_Name}    #check name
    ${Check_DOB}    Convert Date    ${PatientData.DOB}    date_format=%m/%d/%Y    result_format=%#m/%#d/%Y
    ${Check_DOB}    Evaluate    "/".join(part.lstrip("0") for part in "${Check_DOB}".split("/"))
    # Robot ver. issue
    ${check}    Run Keyword And Return Status    SeleniumLibrary.Element Text Should Be    ${Sched_Popup_DOB_Text}    ${Check_DOB}    #check DOB
    IF    ${check} == ${False}
        ${text}    Get Text    ${Sched_Popup_DOB_Text}
        ${text}    Convert Date    ${text}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        Should Be Equal    ${text}    ${Check_DOB}
    END
    ${Gender_Value}    Get Text    ${Sched_Popup_Gender_Text}
    Should Be Equal    ${Gender_Value}    ${PatientData.Gender}    strip_spaces=True    #check Gender
    ${Weight_Value}    Get Text    ${Sched_Popup_Weight_Text}
    ${Weight_Value}    Remove String    ${Weight_Value}    Kgs
    ${Check_Weight}    Fetch From Left    ${PO_data.Weight}    \ kg\
    Should Be Equal As Strings    ${Weight_Value}    ${Check_Weight}    strip_spaces=True    #check Weight
Selected Therapy
    [Arguments]    ${therapy}
    Wait Until Element Is Visible    ${Therapy_Selected_Text}    30s
    Wait Until Element Is Enabled    ${Therapy_Select}    timeout=30s
    ${therapy_selected}    Util.Verify Loading And Select By Label    Therapy    ${therapy}
    Wait Until Element Is Visible    ${Description_Text}    30s    #Fasenra taking 1 min to display
    ${Route}    Get Text    ${Description_Text}
    ${Route}    Get Regexp Matches    ${Route}    (?<=\\[).*(?=])
    Set To Dictionary    ${AppointmentData}    Therapy_And_Route=${therapy_selected}    Route=${Route}[0]
    Set Test Variable    ${AppointmentData}

Select DX Code
    Set Test Variable    ${DX_Code}    ${PO_data.DX_Code}

Select Physician    #Refer To Provider
    ${ReferTo}    Set Variable    ${PO_data.Refer_To_Provider}
    ${ReferTo_NPI}    Set Variable    ${PO_data.Refer_To_NPI}
    Set To Dictionary    ${AppointmentData}    ReferTo_Provider=${ReferTo}    ReferTo_NPI=${ReferTo_NPI}
    Set Test Variable    ${AppointmentData}

Select Medications And dosages For Therapy
    [Arguments]    ${dosages_qty}
    Wait Until Element Is Enabled    ${AddQtyDosage_input}    timeout=120s    error=Can't not find Add Quality Dosage input
    Wait Until Keyword Succeeds    30s    1s    Clear Element Text    ${AddQtyDosage_input}
    Wait Until Keyword Succeeds    3 times    1    Input Text     ${AddQtyDosage_input}    ${dosages_qty}
    Wait Until Page Contains Element
    ...    ${Description_Text}
    ...    timeout=20s
    ${UoM_Scheduling}    Get Text    ${UoM_Text}
    ${UoM_Scheduling}    Strip String    ${UoM_Scheduling}
    ##select random nurse (Treatment Clinician)
    ${Nurse_List}    Get List Items    ${Nurse_Select}
    ${Num_Nurse}    Get Length    ${Nurse_List}
    ${i}    Evaluate    random.randint(0,${Num_Nurse-1})
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Nurse_Select}    ${Nurse_List}[${i}]
    #Office Visit
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    id=reasonSkipRequiredOfficeVisit
    IF    ${check} == ${True}
        Input Text    id=reasonSkipRequiredOfficeVisit    test
        Click Button    Continue & Schedule
        Wait Until Element Is Not Visible    id=reasonSkipRequiredOfficeVisit    30s
    END
    IF    ${Office_Visit_Scheduled} == ${True}
        Select Office Visit
        Select Visit Provider
    END
    Set To Dictionary    ${AppointmentData}    UoM_Scheduling=${UoM_Scheduling}    Nurse=${Nurse_List}[${i}]
    Set Suite Variable    ${AppointmentData}
    Wait Until Keyword Succeeds    3 times    1    Click Element     ${Begin_And_Schedule}

Schedule APT Date Time
    [Arguments]    ${date_arg}    ${date_xpath_arg}    ${time_xpath_arg}    ${time_arg}    ${len_xpath_arg}    ${len_arg}
    Wait Until Keyword Succeeds    9s    1s    Input Text    ${date_xpath_arg}    ${date_arg}
    Wait Until Keyword Succeeds    9s    1s    Click Button    ${Done_Filter_Date_Btn}
    Input Text    ${time_xpath_arg}    ${time_arg}
    Wait Until Keyword Succeeds    10 times    3s    Focus On Other Element    xpath_arg=${step_2_schedule_text}
    Select From List By Value    ${len_xpath_arg}    ${len_arg}
    
Select Office Visit
    Scroll Element Into View    ${Visit_Checkbox}
    Wait Until Element Is Visible    ${Visit_Checkbox}    30s
    Sleep   5s
    Click Element    ${Visit_Checkbox}
    ${atb}    SeleniumLibrary.Get Element Attribute    ${Visit_Checkbox}    checked
    ${check}    Run Keyword And Return Status   Should Be Equal    ${atb}    true    ignore_case=True
    FOR    ${i}    IN RANGE    1    12
        IF    ${check} == ${True}
            BREAK
        ELSE
            Click Element    ${Visit_Checkbox}
            ${atb}    SeleniumLibrary.Get Element Attribute    ${Visit_Checkbox}    checked
            ${check}    Run Keyword And Return Status   Should Be Equal    ${atb}    true
            Sleep    5s
        END
    END
    ${Complexity_List}    Get List Items    ${Complexity_Select}
    ${Num_Complexity}    Get Length    ${Complexity_List}
    ${j}    Evaluate    random.randint(1,${Num_Complexity-1})    #get random index from list
    Wait Until Keyword Succeeds    10 times    3s    Select From List By Label    ${Complexity_Select}    ${Complexity_List}[${j}]
Select Visit Provider
    ${Provider_List}    Get List Items    ${Provider_Select}
    ${Num_Provider}    Get Length    ${Provider_List}
    ${k}    Evaluate    random.randint(0,${Num_Provider-1})    #get random index from list
    Select From List By Label    ${Provider_Select}    ${Provider_List}[${k}]
    Set To Dictionary    ${AppointmentData}    Visit_Provider=${Provider_List}[${k}]
    Set Test Variable    ${AppointmentData}

Config Scheduling
    [Arguments]    ${start_time}    ${appointment_length}    ${visit_starttime}    ${visit_length}
    Wait Until Element Is Visible    ${Calendar_Date_Header}    120s
    Schedule The appointment    ${start_time}    ${appointment_length}    ${visit_starttime}    ${visit_length}    ${True}    ${LastAppointmentData}
    Set Test Variable    ${LastAppointmentData}
    # schedule APT 2 and visit 2
    Scroll Element Into View    ${add_APT_to_queue_btn}
    Wait Until Element Is Visible    ${add_APT_to_queue_btn}    60s
    Wait Until Keyword Succeeds    60s    1s    Click Element    ${add_APT_to_queue_btn}
    Wait For Page Loading    element_arg=//*[@id="SchedulingCalendarLoadingDiv"]/i    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=180s
    FOR    ${i}    IN RANGE    20
        Handle DOS Before Suggested Alert
        Wait Until Keyword Succeeds    10s    1s    Click Element    ${add_APT_to_queue_btn}
        ${check}    Run Keyword And Return Status    Element Should Be Visible    //*[@class='QueuedAppointmentRow'][1]//*[text()='Remove']
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    3s
    END
    Schedule The appointment    ${start_time}    ${appointment_length}    ${visit_starttime}    ${visit_length}    ${False}    ${AppointmentData}
    Scroll Element Into View    ${Schedule}
    Wait Until Element Is Visible    ${Schedule}    60s
    Wait Until Keyword Succeeds    60s    1s    Click Element    ${Schedule}
    ${check}    Handle DOS Before Suggested Alert
    Scheduling Alert
    ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${Sched_Alert_Popup}
    IF    ${Check_Popup_Showed} == ${True}
        Select Unlinked Schedule    #Alert twice
    END
    IF    ${check} == ${True}
        Scroll Element Into View    ${Schedule}
        Wait Until Element Is Visible    ${Schedule}    60s
        Wait Until Keyword Succeeds    60s    1s    Click Element    ${Schedule}
    END
    Set To Dictionary    ${AppointmentData}    Start_Time=${start_time}
    Set Test Variable    ${AppointmentData}

Handle DOS Before Suggested Alert
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //h4[contains(text(),'Scheduling Alert -- Requires Attention')]    5s
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${DOS_before_suggessted_reason_innput}    Testing
        Scroll Element Into View    ${save_btn}
        Wait Until Element Is Visible    ${save_btn}    60s
        Click Button    ${save_btn}
    END
    RETURN    ${check}

Input Early Scheduling Reason
    [Arguments]    ${reason_arg}
    Wait Until Element Is Visible    ${DOS_before_suggessted_alert_text}    60s
    Scroll Element Into View    ${save_btn}
    Click Button    ${save_btn}
    Input Text    ${DOS_before_suggessted_reason_innput}    ${reason_arg}

Close Early Scheduling Alert
    Scroll Element Into View    ${close_submodal_btn}
    Click Button    ${close_submodal_btn}
    Wait Until Element Is Not Visible    ${DOS_before_suggessted_alert_text}    10s

Scheduling Alert
    TRY
        Wait Until Element Is Visible    ${Sched_Alert_Popup_Header}    timeout=30s
        Wait Until Keyword Succeeds    30s    1    Select Unlinked Schedule
    EXCEPT
        Log    Scheduling Alert - Link Appointment is not visible
    END
Select Unlinked Schedule
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${Standalone_APT_RadioBtn}
    ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${Sched_Alert_Popup}
    FOR    ${i}    IN RANGE    3
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Standalone_APT_RadioBtn}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${sched_continue_btn}
        ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${Sched_Alert_Popup}
        IF    ${Check_Popup_Showed} == ${False}
            BREAK
        END
    END
    Page Should Not Contain    Please select a parent appointment or indicate the appointment as unlinked to continue.    30s
Schedule The appointment
    [Arguments]    ${start_time}    ${appointment_length}    ${visit_starttime}    ${visit_length}    ${is_last_APT_visit}    ${APT_dict}
    IF    ${is_last_APT_visit} == ${True}    #if last APT/visit
        ${today}    Util.Check Time Zone
        ${rand}    Evaluate    random.randint(2,365)
        ${date_time}    Add Time To Date    ${today}    ${rand} days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${APT_Date_Box}    ${date_time}
    ELSE
        ${date_time}    Add Time To Date    ${LastAppointmentData.DOS}    2 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y    #sequence:last visit - last APT - visit - APT
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${APT_Date_Box}    ${date_time}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${Done_Filter_Date_Btn}
    END
    Input Text    ${Start_Time_Input}    ${start_time}
    Execute JavaScript    document.activeElement.blur()
    # Focus On Other Element    xpath_arg=${step_2_schedule_text}
    Scroll Element Into View    ${step_2_schedule_text}
    Wait Until Element Is Visible    ${step_2_schedule_text}    30s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${step_2_schedule_text}
    Select From List By Value    ${APT_Length_Select}    ${appointment_length}
    #select random place
    ${Place_List}    Get List Items    ${APT_Location_Sched_Select}
    ${Num_Place}    Get Length    ${Place_List}
    ${i}    Evaluate    random.randint(0,${Num_Place-1})    #get random index from place list
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${APT_Location_Sched_Select}    ${Place_List}[${i}]    #Chair    
    #Office Visit
    ${rand}    Evaluate    random.randint(2,365)
    IF    ${Office_Visit_Scheduled} == ${True}
        ${today}    Util.Check Time Zone
        ${visit_date_time}    Subtract Time From Date    ${today}    ${rand} days    result_format=%m/%d/%Y    date_format=%m/%d/%Y    #Visit date is set 1 DAY after Appointment date
        IF    ${is_last_APT_visit} == ${True}
            Input Text    ${Visit_Date_Box}    ${visit_date_time}
            Wait Until Keyword Succeeds    30s    1s    Click Button    ${Done_Filter_Date_Btn}
        END
        Input Text    ${Visit_Start_Time_Input}    ${visit_starttime}
        Execute JavaScript    document.activeElement.blur()
        # Focus On Other Element    xpath_arg=${step_2_schedule_text}
        Scroll Element Into View    ${step_2_schedule_text}
        Wait Until Element Is Visible    ${step_2_schedule_text}    30s
        Wait Until Keyword Succeeds    20 times    3s    Click Element    ${step_2_schedule_text}
        Select From List By Value    ${Visit_Length_Select}    ${visit_length}
        ${visit_length}    Set Variable    ${visit_length} min
        ${Visit_Place_List}    Get List Items    ${Visit_Location_Sched_Select}
        ${Num_Visit_Place}    Get Length    ${Visit_Place_List}
        ${j}    Evaluate    random.randint(0,${Num_Visit_Place-1})    #get random index from visit place list
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${Visit_Location_Sched_Select}    ${Visit_Place_List}[${j}]
        Set To Dictionary    ${APT_dict}    Visit_Start_Time=${visit_starttime}    Visit_Duration=${visit_length}    Visit_Place=${Visit_Place_List}[${j}]    Visit_DOS=${visit_date_time}
    END
    Set To Dictionary    ${APT_dict}    Start_Time=${start_time}    APT_Duration=${appointment_length}    Place=${Place_List}[${i}]    DOS=${date_time}    #DOS: Date of Service, APT_Duration: in minutes    #${AppointmentData}
    Set Test Variable    ${APT_dict}

Cannot Schedule Early Appointment For Empty Reason
    Wait Until Page Contains Element    ${Calendar_Date_Header}    120s
    ${date}    Util.Check Time Zone
    Schedule APT Date Time    date_arg=${date}    date_xpath_arg=${APT_Date_Box}    time_xpath_arg=${Start_Time_Input}    time_arg=9:21 am    len_xpath_arg=${APT_Length_Select}    len_arg=20
    ${date_visit_1}    Subtract Time From Date    ${date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Schedule APT Date Time   date_arg=${date_visit_1}    date_xpath_arg=${Visit_Date_Box}    time_xpath_arg=${Visit_Start_Time_Input}    time_arg=9:26 am    len_xpath_arg=${Visit_Length_Select}    len_arg=20
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${add_APT_to_queue_btn}
    ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    //*[@id='AddElementsToSchedulingQueue']/*[1]//*[text()='Remove']    #Wait Visible
    FOR    ${i}    IN RANGE    10
        Sleep    3s
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${add_APT_to_queue_btn}
        ${is_visible}    Run Keyword And Return Status    Element Should Be Visible   //*[@id='AddElementsToSchedulingQueue']/*[1]//*[text()='Remove']
        IF    ${is_visible} == ${True}
            BREAK
        END
    END
    ${freq}    Fetch From Left    ${PO_data.Dose_Frequency}    \ \
    ${early_freq}    Evaluate    random.randint(1,${freq}-1)
    ${date_APT}    Add Time To Date    ${date}    ${early_freq} days    result_format=%m/%d/%Y    date_format=%m/%d/%Y    #sequence:last visit - last APT- visit - APT (APT is set 1 day after visit and set 2 days after last APT)
    Schedule APT Date Time    date_arg=${date_APT}    date_xpath_arg=${APT_Date_Box}    time_xpath_arg=${Start_Time_Input}    time_arg=9:21 am    len_xpath_arg=${APT_Length_Select}    len_arg=20
    ${date_visit_2}    Add Time To Date    ${date_visit_1}    2 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Schedule APT Date Time   date_arg=${date_visit_2}    date_xpath_arg=${Visit_Date_Box}    time_xpath_arg=${Visit_Start_Time_Input}    time_arg=9:26 am    len_xpath_arg=${Visit_Length_Select}    len_arg=20
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${add_APT_to_queue_btn}
    Input Early Scheduling Reason    reason_arg=${EMPTY}
    Wait For Page Loading    element_arg=A reason for selecting this date of service is required    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Close Early Scheduling Alert
    Wait Until Element Is Not Visible    ${DOS_before_suggessted_alert_text}    30s
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${Schedule}
    Input Early Scheduling Reason    reason_arg=${EMPTY}
    Wait For Page Loading    element_arg=A reason for selecting this date of service is required    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Close Early Scheduling Alert
    Set To Dictionary    ${AppointmentData}    APT_DOS=${date}    APT_Visit_DOS_1=${date_visit_1}    APT_Early_DOS=${date_APT}    APT_Visit_DOS_2=${date_visit_2}
    Set Test Variable    ${AppointmentData}

Schedule Early Appointment For A Reason
    Wait Until Keyword Succeeds    9s    1s        Click Element    ${add_APT_to_queue_btn}
    Input Early Scheduling Reason    reason_arg=Testing
    Click Button    ${save_btn}
    Wait Until Element Is Not Visible    ${DOS_before_suggessted_alert_text}    30s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${Schedule}
    ${Check_Popup_Showed}    Run Keyword And Return Status    Element Should Be Visible    ${Sched_Alert_Popup}
    IF    ${Check_Popup_Showed} == ${True}
        Select Unlinked Schedule
    END
    ${Check_APT_Created}    Run Keyword And Return Status    Wait Until Page Contains    Appointment Created!    timeout=10s
    IF    ${Check_APT_Created} == ${True}
        Wait Until Page Does Not Contain    Appointment Created!    timeout=10s
    END
    Wait Until Keyword Succeeds    9s    1s    Search By Location    Location_arg=${PatientData.Location}
    Select Ledger View
    Check Tall View
    Set Test Variable    ${View}    Tall View
    Filter Appointment    date_time=${AppointmentData.APT_Early_DOS}    medication=Actemra    appointment_status=Scheduled
    Scroll To Appointment - Check Time    StartTime=9:21 am
    ${APT_page_early_badge}    Util.Replace Xpath    xpath=${APT_page_early_badge}
    Wait Until Keyword Succeeds    9s    1s    Element Should Be Visible    ${APT_page_early_badge}

Schedule APT With Different Dose
    Select Therapy Before Scheduling
    ${date_APT}    Get Value    ${APT_Date_Box}
    Schedule APT Date Time    date_arg=${date_APT}    date_xpath_arg=${APT_Date_Box}    time_xpath_arg=${Start_Time_Input}    time_arg=9:21 am    len_xpath_arg=${APT_Length_Select}    len_arg=20
    ${date_visit}    Get Value    ${Visit_Date_Box}
    Schedule APT Date Time   date_arg=${date_visit}    date_xpath_arg=${Visit_Date_Box}    time_xpath_arg=${Visit_Start_Time_Input}    time_arg=9:26 am    len_xpath_arg=${Visit_Length_Select}    len_arg=20
    Wait Until Keyword Succeeds    9s    1s    Click Element    ${Schedule}
    ${Check_Popup_Showed}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Sched_Alert_Popup}    10s
    IF    ${Check_Popup_Showed} == ${True}
        Select Unlinked Schedule
    END
    ${Check_APT_Created}    Run Keyword And Return Status    Wait Until Page Contains    Appointment Created!    timeout=10s
    IF    ${Check_APT_Created} == ${True}
        Wait Until Page Does Not Contain    Appointment Created!    timeout=10s
    END
    Set To Dictionary    ${AppointmentData}    APT_DOS=${date_APT}    APT_Time=9:21 am    APT_Visit_DOS=${date_visit}
    Set Test Variable    ${AppointmentData}

Close Clinical Statement Modal
    ${is_with_note}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(@class,'clinicalStatement')]    10s    #issue
    IF    ${is_with_note} == ${True}
        Sleep    3s
        Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[contains(@class,'clinicalStatement')]
        Sleep    3s
        Click Button    ${tnote_modal_save_btn}
        Wait Until Element Is Not Visible    ${confirm_modal}    15s
    END

Focus On Other Element
    [Arguments]    ${xpath_arg}
    Execute JavaScript    document.activeElement.blur()
    Scroll Element Into View    ${xpath_arg}
    Wait Until Element Is Visible    ${xpath_arg}    60s
    Util.Scroll Into Element And Click    xpath_arg=${xpath_arg}    retry_arg=10    time_arg=6s    kw_arg=Click Element

Select Ledger View
    Wait Until Keyword Succeeds    30s    1s    Mouse Over    ${Home_Link}
    Wait Until Element Is Enabled    ${Views_Dropdown}    timeout=30s
    Scroll Element Into View    ${Views_Dropdown}
    Wait Until Element Is Visible    ${Views_Dropdown}    60s
    ${view}    Get Text    ${Views_Dropdown}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${view}    Ledger View    strip_spaces=True
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${Views_Dropdown}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${Ledger_View_Link}
    END

Check Date Of Service Row
    [Arguments]    ${Date}
    Sleep    2
    IF    "${View}" == "Tall View" or "${View}" == "Condensed View"
        ${DOS_Row_Text}    Wait Until Keyword Succeeds    60s    1s    Get Text    ${Ledger_DOS_Row}
        ${Check_DOS_Row}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%A -- %B %d, %Y
        ${Check_DOS_Row}    Evaluate    "${SPACE}".join(part.lstrip("0") for part in "${Check_DOS_Row}".split("${SPACE}"))
        Wait Until Keyword Succeeds    60s    1s    Should Be Equal    ${Check_DOS_Row} -- (${PatientData.Location_ID}) ${PatientData.Location}     ${DOS_Row_Text}    #Date of Service row including Date of Service, Location ID and Location Name
    ELSE IF    "${View}" == "Office Visit View"
        ${DOS_Row_Text_Right}    Wait Until Keyword Succeeds    60s    1s    Get Text    ${Office_DOS_Row}    #DOS on the right side
        ${Check_DOS_Row}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%A -- %B %#d, %Y
        Should Be Equal    ${Check_DOS_Row}     ${DOS_Row_Text_Right}
    ELSE IF    "${View}" == "Check-In View"    #Check-In View with DOS on right side & left side
        Sleep    3s
        ${DOS_Row_Text_Left}    Wait Until Keyword Succeeds    60s    1s    Get Text    ${Checkin_DOS_Row}    #DOS on the left side
        ${Check_DOS_Row}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%A -- %B %d, %Y
        ${Check_DOS_Row}    Evaluate    "${SPACE}".join(part.lstrip("0") for part in "${Check_DOS_Row}".split("${SPACE}"))
        Should Be Equal    ${Check_DOS_Row}     ${DOS_Row_Text_Left}    #Date of Service row including Date of Service, Location ID and Location Name
    END
    Set Test Variable    ${Date}
Check Tall View
    Wait Until Element Is Visible    ${Ledger_Select}    60s
    ${Check_Tall_View}    Run Keyword And Return Status    List Selection Should Be    ${Ledger_Select}    Tall View
    IF    ${Check_Tall_View} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Element    ${Ledger_Select}
        Wait Until Keyword Succeeds    60s    1s    Select From List By Label    ${Ledger_Select}    Tall View
        Wait Until Keyword Succeeds    60s    1s    Click Element    ${APT_Search_Link}
    END

Filter Appointment
    [Arguments]    ${date_time}    ${medication}    ${appointment_status}
    Sleep    3s
    Filter By Date Range    date_time=${date_time}
    Filter By Medication    medication=${medication}
    Filter By Status Appointment    appointment_status=${appointment_status}
    Filter By Patient    patient_arg=${PatientData.Last_Name}, ${PatientData.First_Name} (${PatientData.DOB}) MRN: ${PatientData.MRN}
    Sleep    5s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${APT_Search_Link}
    Wait Until Element Is Visible    ${APT_List_Loading}    timeout=30s
    Wait Until Element Is Not Visible    ${APT_List_Loading}    timeout=30s
    IF    "${View}" != "Office Visit View"
        Wait Until Element Is Visible    ${APT_List_Table}    60s
    ELSE IF    "${View}" == "Office Visit View"
        Wait Until Element Is Visible    ${Visit_List_Table}    60s
    END

Filter By Date Range
    [Arguments]    ${date_time}
    Wait Until Element Is Enabled    ${FilterStartDate_input}    60s
    Wait Until Keyword Succeeds    60s    1s    Input Text    ${FilterStartDate_input}    ${date_time}
    Wait Until Keyword Succeeds    60s    1s    Input Text    ${FilterEndDate_input}    ${date_time}
    Wait Until Element Is Enabled    ${Done_Filter_Date_Btn}
    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${Done_Filter_Date_Btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Wait Until Element Is Not Visible    ${Done_Filter_Date_Btn}    60

Filter By Medication
    [Arguments]    ${medication}
    Wait Until Keyword Succeeds    60s    1s    Select From List By Label    ${Medication_Select}    ${medication}

Filter By Status Appointment
    [Arguments]    ${appointment_status}
    Sleep    1s
    Wait Until Element Is Enabled    ${Status_Select}    60s
    Wait Until Keyword Succeeds    60s    1s    Select From List By Label    ${Status_Select}    ${appointment_status}

Filter By Patient
    [Arguments]    ${patient_arg}
    Wait Until Element Is Enabled    ${Patient_Select}
    ${check}    Run Keyword And Return Status    Click Button   ${clear_patient_btn}
    IF    ${check} == ${True}
        # Wait Until Keyword Succeeds    10 times    3s    Click Button    ${clear_patient_btn}
        No Operation
    ELSE
        Sleep    2s
        Clear Element Text    ${Patient_Select}
    END
    Sleep    3s
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${Patient_Select}    ${patient_arg}
    Set Suite Variable    ${patient_info}    ${patient_arg}
    ${patient_suggestion}    Util.Replace Xpath    ${patient_suggestion}
    Wait Until Element Is Visible    ${patient_suggestion}    60s
    Click Element    ${patient_suggestion}
    Sleep    1s
    Execute JavaScript    document.activeElement.blur()

Check Search Button Flashing
    Wait Until Element Is Visible    ${APT_Search_Link}    30s
    FOR    ${i}    IN RANGE    30
        ${atb}    SeleniumLibrary.Get Element Attribute    ${APT_Search_Link}    class
        ${check}    Run Keyword And Return Status    Should Contain    ${atb}    trace-button-border
        IF    ${check} == ${True}
            BREAK
        ELSE
            Sleep    1s
        END
    END

Count APT Filtered
    [Arguments]    ${time_arg}
    Set Test Variable    ${row}    1
    ${row_1}    Util.Replace Xpath    xpath=${ledger_APT_row}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    ${time_arg}    1s    Element Should Be Visible    ${row_1}
    IF    ${check} == ${True}
        Set Test Variable    ${row}    /*
        ${ledger_APT_row}    Util.Replace Xpath    xpath=${ledger_APT_row}
        ${count}    Get WebElements    ${ledger_APT_row}
        ${count}    Get Length    ${count}
    ELSE
        ${count}    Set Variable    ${0}
    END
    RETURN    ${count}

Scroll To Appointment - Check Time
    [Arguments]    ${StartTime}
    ${StartTime}    Convert To Upper Case    ${StartTime}
    ${StartTime}    Remove String Using Regexp    ${StartTime}    \^0\
    Set Test Variable    ${StartTime}
    IF    "${View}" == "Tall View" or "${View}" == "Condensed View"
        ${Xpath_Time}    Replace Variables    ${Ledger_APT_Time_Xpath}
    ELSE IF    "${View}" == "Check-In View"
        ${Xpath_Time}    Replace Variables    ${Checkin_APT_Time_Xpath}
    END
    IF    "${View}" == "Office Visit View"
        ${Xpath_Time}    Replace Variables    ${Office_Visit_Time_Xpath}
    END
    Set Test Variable    ${Xpath_Time}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${Xpath_Time}
    Scroll Element Into View    ${Xpath_Time}/following::tr[1]
    Wait Until Element Is Visible    ${Xpath_Time}/following::tr[1]    30s
    IF    "${View}" == "Office Visit View"
        Check End Time
    END
Get Appointment ID
    [Arguments]    ${Type}    #APT_Type: Appointment OR Visit
    ${APT_ID_Text}    Util.Replace Xpath    xpath=${APT_ID_Text}
    ${ID}    Get Text    ${APT_ID_Text}
    Set To Dictionary    ${AppointmentData}    ${Type}=${ID}
    Set Test Variable    ${AppointmentData}

Check End Time
    ${Visit_End_Time_Text}    Util.Replace Xpath    xpath=${Visit_End_Time_Text}
    ${EndTime}    Get Text    ${Visit_End_Time_Text}
    ${Check_EndTime}    Add Time To Date    ${AppointmentData.Visit_Start_Time}    ${AppointmentData.Visit_Duration}    result_format=%#I:%M %p    date_format=%I:%M %p
    Should Be Equal    ${Check_EndTime}    ${EndTime}
Check Office Visit Label
    ${Office_Visit_Mark_Label}    Util.Replace Xpath    xpath=${Office_Visit_Mark_Label}
    Element Should Be Visible    ${Office_Visit_Mark_Label}
Check Appointment ID
    [Arguments]    ${Check_ID}
    ${APT_ID_Text}    Util.Replace Xpath    xpath=${APT_ID_Text}
    ${ID}    Get Text    ${APT_ID_Text}
    Should Be Equal    ${ID}    ${Check_ID}
Check Date Of Service Label
    # ${Date}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%#m/%#d/%Y
    IF    "${View}" == "Tall View" or "${View}" == "Condensed View"
        ${Ledger_DOS_Label}    Util.Replace Xpath    xpath=${Ledger_DOS_Label}
        #Robot ver. issue
        ${check}    Run Keyword And Return Status    SeleniumLibrary.Element Text Should Be    ${Ledger_DOS_Label}    ${Date}
        IF    ${check} == ${False}
            ${text}    Get Text    ${Ledger_DOS_Label}
            ${text}    Convert Date    ${text}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
            Should Be Equal    ${text}    ${Date}
        END
    ELSE    #IF Office Visit View
        ${Date}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
        ${Visit_DOS_Label}    Util.Replace Xpath    xpath=${Visit_DOS_Label}
        ${check}    Run Keyword And Return Status    SeleniumLibrary.Element Text Should Be    ${Visit_DOS_Label}    ${Date}
        IF    ${check} == ${False}
            ${Date}    Convert Date    ${Date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
            SeleniumLibrary.Element Text Should Be    ${Visit_DOS_Label}    ${Date}
        END
    END
Check Office Visit Mark
    ${Office_Visit_Mark}    Util.Replace Xpath    xpath=${Office_Visit_Mark}
    Element Should Be Visible    ${Office_Visit_Mark}
Check Appointment Status
    Check Status Color
    IF    "${View}" != "Office Visit View"
        Check Status Label
    END
    IF    "${View}" == "Check-In View"
        Check NO Option Selected    #ONLY for Check-In View
    END
Check Status Color
    ${APT_Status_Element}    Util.Replace Xpath    xpath=${APT_Status_Element}
    ${Style}    SeleniumLibrary.Get Element Attribute    ${APT_Status_Element}    style
    IF    "${View}" != "Office Visit View" and "${View}" != "Check-In View"
        Should Contain    ${Style}    background-color: forestgreen;    #color status    #red(firebrick)
        ${Office_Visit_Row}    Util.Replace Xpath    xpath=${Office_Visit_Row}
        Element Should Be Visible    ${Office_Visit_Row}    #Office Visit with white background 
    ELSE    #IF Office Visit View
        Should Contain    ${Style}    background-color: firebrick;    #color status is light blue    #5bc0de    #red:rgb(91, 192, 222)
    END
Check Status Label
    ${Status_Text}    Util.Replace Xpath    xpath=${Status_Text}
    SeleniumLibrary.Element Text Should Be    ${Status_Text}    Dispensed
Check Appointment Place
    [Arguments]    ${Place}
    ${Sched_APT_Location_Text}    Util.Replace Xpath    xpath=${Sched_APT_Location_Text}
    ${Check_Place}    Get Text    ${Sched_APT_Location_Text}
    ${Check_Place}    Get Regexp Matches    ${Check_Place}    (?<=\\( ).*(?= \\))

Check PO And PA In Tall View
    Util.Check Time Zone
    Check PO In Tall View
    Check PA In Tall View

Check PO In Tall View
    ${remaining}    Subtract Date From Date    ${PO_data.Exp_Date}    ${AppointmentData.DOS}     result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${PO_badge_link}    Util.Replace Xpath    xpath=${PO_badge_link}
    ${remaining}    Fetch From Left    ${remaining}    ${SPACE}day
    ${remaining}    Evaluate    ${remaining}
    IF    ${remaining} < 0
        SeleniumLibrary.Element Text Should Be    ${PO_badge_link}    PO: ${remaining} Days Expired    ignore_case=True
    ELSE IF    ${remaining} >= 0 and ${remaining} != 1
        SeleniumLibrary.Element Text Should Be    ${PO_badge_link}    PO: ${remaining} Days Remaining    ignore_case=True
    ELSE
        SeleniumLibrary.Element Text Should Be    ${PO_badge_link}    PO: 1 Day Remaining    ignore_case=True
    END
    Click Element    ${PO_badge_link}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_header_text}    30s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Check Tall View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PO_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PO_badge_link}
        Wait Until Element Is Visible    ${PO_header_text}    30s
    END
    Check PO Num    num_arg=${PO_data.PO_Num}
    Close Modal

Check PA In Tall View
    ${remaining}    Subtract Date From Date    ${PA_data.End_Date}    ${AppointmentData.DOS}     result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${PA_badge_link}    Util.Replace Xpath    xpath=${PA_badge_link}
    ${remaining}    Fetch From Left    ${remaining}    ${SPACE}day
    ${remaining}    Evaluate    ${remaining}
    IF    ${remaining} < 0
        SeleniumLibrary.Element Text Should Be    ${PA_badge_link}    PA: ${remaining} Days Expired    ignore_case=True
    ELSE IF    ${remaining} >= 0 and ${remaining} != 1
        SeleniumLibrary.Element Text Should Be    ${PA_badge_link}    PA: ${remaining} Days Remaining    ignore_case=True
    ELSE
        SeleniumLibrary.Element Text Should Be    ${PA_badge_link}    PA: 1 Day Remaining    ignore_case=True
    END
    Click Element    ${PA_badge_link}
    Set Test Variable   ${PO_num}    ${PO_data.PO_Num}
    ${APT_page_PO_num_text}    Util.Replace Xpath    xpath=${APT_page_PO_num_text}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${APT_page_PO_num_text}    60s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Check Tall View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PA_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PA_badge_link}
        Wait Until Element Is Visible    ${APT_page_PO_num_text}    30s
    END
    Set Test Variable    ${PA_num}    ${PA_data.PA_Num}
    ${APT_page_dispensed_PA_num_text}    Util.Replace Xpath    xpath=${APT_page_dispensed_PA_num_text}
    Wait Until Element Is Visible    ${APT_page_dispensed_PA_num_text}    60s

Close Modal
    Sleep    1s
    Scroll Element Into View    ${APT_page_close_PO_btn}
    Wait Until Element Is Visible    ${APT_page_close_PO_btn}    60s
    Wait Until Keyword Succeeds    10 times    3s    Click Button    ${APT_page_close_PO_btn}
    # Wait Until Element Is Not Visible    //*[@id='ModalPopup']//*[@class='modal-content']    60s

Close Submodal
    Sleep    1s
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${close_submodal_btn}
    Wait Until Element Is Visible    ${close_submodal_btn}    60s
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${close_submodal_btn}
    Wait Until Element Is Not Visible    //*[@id='SubModalPopup']//*[@class='modal-content']    60s

Close Ultra Submodal
    Sleep    1s
    Scroll Element Into View    ${close_ultra_submodal_btn}
    Wait Until Element Is Visible    ${close_ultra_submodal_btn}    60s
    Wait Until Keyword Succeeds    30    1    Click Button    ${close_ultra_submodal_btn}
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']//*[@class='modal-content']    60s

Check Weight In Tall View
    ${Tall_Weight_Input}    Util.Replace Xpath    xpath=${Tall_Weight_Input}
    ${Weight_Value}    SeleniumLibrary.Get Element Attribute   ${Tall_Weight_Input}    value
    ${Weight_PO}    Fetch From Left    ${PO_data.Weight}    \ kg\
    ${Check_Weight_Lb}    Evaluate    round(${Weight_PO}*2.2046)    #1kg ~ 2.2046lb
    Should Be Equal    ${Weight_PO} KG - ${Check_Weight_Lb} LB    ${Weight_Value}    ignore_case=True

Click Open APT Button
    [Arguments]    ${btn_arg}    ${xpath_arg}    ${start_time_arg}    ${xpath_header_arg}
    ${StartTime}    Convert To Upper Case    ${start_time_arg}
    ${StartTime}    Remove String Using Regexp    ${StartTime}    \^0\
    Set Test Variable    ${StartTime}    ${StartTime}
    ${Xpath_Time}    Util.Replace Xpath    xpath=${xpath_arg}
    Set Test Variable    ${Xpath_Time}
    ${btn_arg}    Util.Replace Xpath    xpath=${btn_arg}
    FOR    ${i}    IN RANGE    1    20
        Wait Until Keyword Succeeds    60s    1s    Scroll Element Into View    ${btn_arg}
        ${check}    Run Keyword And Return Status    Element Should Be Visible    ${btn_arg}
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    3s
    END
    Should Be Equal    ${check}    ${True}
    Set Test Variable    ${btn_arg}
    IF    "${View}" == "Tall View"
        ${view_work_order_btn}    Util.Replace Xpath    xpath=${view_work_order_btn}
        Sleep    1s
        Scroll Element Into View    ${view_work_order_btn}
        Wait Until Element Is Visible    ${view_work_order_btn}    60s
    END
    Sleep    5s
    FOR    ${i}    IN RANGE    12
        ${check}    Run Keyword And Return Status    Click Element    ${btn_arg}
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    5
    END
    Should Be Equal    ${check}    ${True}
    Handle Future APT Warning    #only for APT after today
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    id=reasonSkipRequiredOfficeVisit    10s
    IF    ${check} == ${True}
        Input Text    id=reasonSkipRequiredOfficeVisit    test
        Click Button    Continue & Dispense
        Wait Until Element Is Not Visible    id=reasonSkipRequiredOfficeVisit    30s
    END
    Wait Until Element Is Visible    ${xpath_header_arg}    30s
    Util.Wait For Page Loading    element_arg=${assign_dosage_modal_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    ${is_with_note}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[contains(@class,'clinicalStatement')]    10s
    IF    ${is_with_note} == ${True}
        ${text}    Get Text    ${clinical_notes_text}
        Click Element    //*[contains(@class,'clinicalStatement')]
        Click Button    ${tnote_modal_save_btn}
        Wait Until Element Is Not Visible    ${confirm_modal}    15s
    ELSE
        ${text}    Set Variable    ${null}
    END
    RETURN    ${is_with_note}    ${text}

Handle Future APT Warning
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    ${future_APT_warning_text}
    IF    ${check} == ${True}
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${continue_future_APT_warning_btn}
        ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${early_APT_reason_input}
        IF    ${check} == ${True}
            Sleep    2s
            Input Text    ${early_APT_reason_input}    Testing
            Click Button    ${early_APT_continue_btn}
        END
    END

Check Patient In AsDos Modal
    SeleniumLibrary.Element Text Should Be    ${asdos_patient_text}    ${PatientData.First_Name} ${PatientData.Last_Name}
    ${DOB}    Convert Date    ${PatientData.DOB}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${DOB}    Evaluate    "/".join(part.lstrip("0") for part in "${DOB}".split("/"))
    SeleniumLibrary.Element Text Should Be    ${asdos_DOB_text}    ${DOB}
    ${location}    Get Text    ${asdos_location_text}
    Should Be Equal    ${location}    ${PatientData.Location}    strip_spaces=True
    ${check_visit}    SeleniumLibrary.Get Element Attribute    ${asdos_office_visit_checkbox}    checked
    Should Be Equal As Strings    ${check_visit}    None
    ${date_time}    Get Text    ${asdos_APT_date_time_text}
    ${check_time}    Convert Date    ${AppointmentData.DOS}    result_format=%A, %B %#d, %Y    date_format=%m/%d/%Y
    ${check_start}    Convert To Upper Case    ${AppointmentData.Start_Time}
    ${check_start}    Remove String Using Regexp    ${check_start}    \^0\
    Should Be Equal    ${date_time}    Appointment on ${check_time} at ${check_start}    strip_spaces=True
    ${dose}    Fetch From Left    ${PO_data.Maint_Dose}    \ \
    ${order_exp}    Convert Date    ${PO_data.Exp_Date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${order_exp}    evaluate    "/".join(part.lstrip("0") for part in "${order_exp}".split("/"))
    ${auth_exp}    Convert Date    ${PA_data.End_Date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${auth_exp}    evaluate    "/".join(part.lstrip("0") for part in "${auth_exp}".split("/"))
    List Selection Should Be    ${asdos_therapy_select}    Physician Order # - \(${PO_data.PO_Num}\) - ${PO_data.Medication} ${dose} Milligrams - \[ ${PO_data.Medication} \] - Order Exp: ${order_exp} - Authorization Exp: ${auth_exp}
    ${medication}    Get Text    ${asdos_medication_dispensed_text}
    ${medication}    Fetch From Right    ${medication}    \: \
    Should Be Equal    ${medication}    ${PO_data.Medication}

Check PO In Condensed View
    ${PO_badge_link}    Util.Replace Xpath    xpath=${PO_badge_link}
    Click Element    ${PO_badge_link}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_header_text}    60s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Select Condensed View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PO_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PO_badge_link}
        Wait Until Element Is Visible    ${PO_header_text}    30s
    END
    Check PO Num    num_arg=${PO_data.PO_Num}
    Close Modal

Check PA In Condensed View
    ${remaining}    Subtract Date From Date    ${PA_data.End_Date}    ${AppointmentData.DOS}     result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${PA_badge_link}    Util.Replace Xpath    xpath=${PA_badge_link}
    Sleep    3s
    Click Element    ${PA_badge_link}
    Set Test Variable    ${PA_num}    ${PA_data.PA_Num}
    ${APT_page_dispensed_PA_num_text}    Util.Replace Xpath    xpath=${APT_page_dispensed_PA_num_text}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${APT_page_dispensed_PA_num_text}    60s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Select Condensed View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PA_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PA_badge_link}
        Wait Until Element Is Visible    ${APT_page_dispensed_PA_num_text}    30s
    END
    Close Modal

Check PO In Check-In View
    ${PO_badge_link}    Util.Replace Xpath    xpath=${PO_badge_link}
    ${num}    Get Text    ${PO_badge_link}
    Should Be Equal    ${num}    ${PO_data.PO_Num}    strip_spaces=True
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PO_badge_link}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${PO_badge_link}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${PO_header_text}    60s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Select Check-In View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PO_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PO_badge_link}
        Wait Until Element Is Visible    ${PO_header_text}    30s
    END
    Check PO Num    num_arg=${PO_data.PO_Num}
    Close Modal

Check PA In Check-In View
    ${remaining}    Subtract Date From Date    ${PA_data.End_Date}    ${AppointmentData.DOS}     result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${PA_badge_link}    Util.Replace Xpath    xpath=${PA_badge_link}
    Sleep    2s
    Click Element    ${PA_badge_link}
    Set Test Variable    ${PA_num}    ${PA_data.PA_Num}
    ${APT_page_PA_num_text}    Util.Replace Xpath    xpath=${APT_page_PA_num_text}
    ${is_visible}    Run Keyword And Return Status   Wait Until Element Is Visible    ${APT_page_PA_num_text}    30s
    IF    ${is_visible} == ${False}
        Reload Page
        Wait Until Keyword Succeeds    30s    1s    Search By Location    Location_arg=${PatientData.Location}
        Select Check-In View
        ${date_time}    Set Variable    ${AppointmentData.DOS}
        Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Dispensed
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${APT_Search_Link}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${PA_badge_link}
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PA_badge_link}
        Wait Until Element Is Visible    ${APT_page_PA_num_text}    30s
    END
    Close Modal

Check PO Num
    [Arguments]    ${num_arg}
    Util.Wait For Page Loading    element_arg=${APT_page_PO_Loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    SeleniumLibrary.Element Text Should Be    ${PO_num_text}    Viewing PO: ${num_arg}

Check Treatment Clinician
    ${Treatment_Clinician_Select}    Util.Replace Xpath    xpath=${Treatment_Clinician_Select}
    ${Nurse_Selected}    Get Selected List Label    ${Treatment_Clinician_Select}
    Should Be Equal    ${Nurse_Selected}    ${AppointmentData.Nurse}

Check Patient
    Check Name
    Check DOB
    IF    "${View}" == "Tall View" or "${View}" == "Condensed View"
        Check Age
    END
    Check MRN
Check Name
    IF    "${View}" == "Tall View"
        ${Tall_Patient_Link}    Util.Replace Xpath    xpath=${Tall_Patient_Link}
        ${Check_Name}    Get Text    ${Tall_Patient_Link}
    ELSE IF    "${View}" == "Condensed View"
        ${Condensed_Patient_Link}    Util.Replace Xpath    xpath=${Condensed_Patient_Link}
        ${Check_Name}    Get Text    ${Condensed_Patient_Link}
    ELSE IF    "${View}" == "Check-In View"
        ${Checkin_Patient_Link}    Util.Replace Xpath    xpath=${Checkin_Patient_Link}
        ${Check_Name}    Get Text    ${Checkin_Patient_Link}
    ELSE IF    "${View}" == "Office Visit View"
        ${Visit_Patient_Link}    Util.Replace Xpath    xpath=${Visit_Patient_Link}
        ${Check_Name}    Get Text    ${Visit_Patient_Link}
        ${Check_Name}    Fetch From Right    ${Check_Name}    \: \
    END
    Should Be Equal    ${Check_Name}    ${PatientData.First_Name} ${PatientData.Last_Name}
Check DOB
    # Check the View to extract the correct date field from the UI
    IF    "${View}" == "Tall View"
        ${Tall_DOB_Text}    Util.Replace Xpath    xpath=${Tall_DOB_Text}
        ${Check_DOB}    Get Text    ${Tall_DOB_Text}
    ELSE IF    "${View}" == "Condensed View"
        ${Condensed_DOB_Text}    Util.Replace Xpath    xpath=${Condensed_DOB_Text}
        ${Check_DOB}    Get Text    ${Condensed_DOB_Text}
    ELSE IF    "${View}" == "Check-In View"
        ${Checkin_DOB_Text}    Util.Replace Xpath    xpath=${Checkin_DOB_Text}
        ${Check_DOB}    Get Text    ${Checkin_DOB_Text}
    ELSE IF    "${View}" == "Office Visit View"
        ${Visit_DOB_Text}    Replace Variables    ${Visit_DOB_Text}
        ${Check_DOB}    Get Text    ${Visit_DOB_Text}
        ${Check_DOB}    Fetch From Right    ${Check_DOB}    \: \
    END

    # Extract date using regex, handling cases with or without leading zeros
    ${Check_DOB}    Get Regexp Matches    ${Check_DOB}    (\\d{1,2})/(\\d{1,2})/(\\d{4})
    ${Check_DOB}    Set Variable    ${Check_DOB}[0]

    # Normalize date format to YYYY-MM-DD for accurate comparison
    ${Check_DOB}    Convert Date    ${Check_DOB}    date_format=%m/%d/%Y    result_format=%Y-%m-%d
    ${Patient_DOB}    Convert Date    ${PatientData.DOB}    date_format=%m/%d/%Y    result_format=%Y-%m-%d

    # Compare the normalized date values
    Should Be Equal    ${Check_DOB}    ${Patient_DOB}


Check Age
    IF    "${View}" == "Tall View"
        ${Tall_Age_Text}    Util.Replace Xpath    xpath=${Tall_Age_Text}
        ${Check_Age}    Get Text    ${Tall_Age_Text}
    ELSE    #IF Condensed View
        ${Condensed_Age_Text}    Util.Replace Xpath    xpath=${Condensed_Age_Text}
        ${Check_Age}    Get Text    ${Condensed_Age_Text}
    END
    ${Check_Age}    Get Regexp Matches    ${Check_Age}    \(\\d{1,}yrs\)
    ${Check_Age}    Remove String    ${Check_Age}[0]    yrs
    ${Today}    Util.Check Time Zone
    ${Today}    Convert Date    ${Today}    result_format=datetime    date_format=%m/%d/%Y
    ${DOB}    Convert Date    ${PatientData.DOB}    result_format=datetime    date_format=%m/%d/%Y
    ${m1}    Set Variable    ${Today.month}
    ${d1}    Set Variable    ${Today.day}
    ${y2}    Set Variable    ${Today.year}
    ${m2}    Set Variable    ${DOB.month}
    ${d2}    Set Variable    ${DOB.day}
    ${y2}    Set Variable    ${DOB.year}
    ${age}    Evaluate    ${Today.year} - ${DOB.year}
    IF    ${age} <= 1
        ${age}    Evaluate    1
    ELSE IF     ${Today.month} < ${DOB.month}
        ${age}    Evaluate    ${age} - 1
    ELSE IF    ${Today.month} == ${DOB.month} and ${Today.day} <= ${DOB.day}
        ${age}    Evaluate    ${age} - 1
    END
    Should Be Equal As Numbers    ${age}    ${Check_Age}

Check MRN
    IF    "${View}" == "Tall View" or "${View}" == "Office Visit View"
        ${Tall_MRN_Text}    Util.Replace Xpath    xpath=${Tall_MRN_Text}
        ${Check_MRN}    Get Text    ${Tall_MRN_Text}
    ELSE IF    "${View}" == "Condensed View"
        ${Condensed_MRN_Text}    Util.Replace Xpath    xpath=${Condensed_MRN_Text}
        ${Check_MRN}    Get Text    ${Condensed_MRN_Text}
    ELSE IF    "${View}" == "Check-In View"
        ${Checkin_MRN_Text}    Util.Replace Xpath    xpath=${Checkin_MRN_Text}
        ${Check_MRN}    Get Text    ${Checkin_MRN_Text}
    END
    ${Check_MRN}    Strip String    ${Check_MRN}
    ${Check_MRN}    Fetch From Right   ${Check_MRN}    \: \
    IF    "${View}" == "Office Visit View"
        No Operation
    END
    ${Patient_MRN}    Set Variable    ${PatientData.MRN} 
    Should Be Equal    ${Check_MRN}    ${Patient_MRN}
Check DX Code
    IF    "${View}" == "Tall View"
        ${Tall_DX_Text}    Util.Replace Xpath    xpath=${Tall_DX_Text}
        ${Check_DX_Code}    Wait Until Keyword Succeeds    5s    1s    Get Text    ${Tall_DX_Text}
        ${Check_DX_Code}    Get Regexp Matches    ${Check_DX_Code}    (?<=Diagnosis:\ )[a-zzaA-Z0-9]{1,}(.[a-zA-Z0-9]{1,})
    ELSE    #if Condensed View
        ${Condensed_DX_Text}    Util.Replace Xpath    xpath=${Condensed_DX_Text}
        ${Check_DX_Code}    Get Text    ${Condensed_DX_Text}
        ${Check_DX_Code}    Get Regexp Matches    ${Check_DX_Code}    (?<=DX Code:\ )[a-zA-Z0-9]{1,}(.[a-zA-Z0-9]{1,})
    END
    Should Be Equal    ${Check_DX_Code}[0]    ${PO_data.DX_Code}

Check Medication
    [Arguments]    ${Type}
    IF    "${View}" == "Tall View"
        ${Tall_Medication_Text}    Util.Replace Xpath    xpath=${Tall_Medication_Text}
        ${Check_Medication}    Get Text    ${Tall_Medication_Text}
    ELSE IF    "${View}" == "Condensed View"
        ${Condensed_Medication_Text}    Util.Replace Xpath    xpath=${Condensed_Medication_Text}
        ${Check_Medication}    Get Text    ${Condensed_Medication_Text}
    ELSE IF    "${View}" == "Check-In View"
        ${Checkin_Medication_Text}    Util.Replace Xpath    xpath=${Checkin_Medication_Text}
        ${Check_Medication}    Get Text    ${Checkin_Medication_Text}
    END
    ${Check_Medication}    Fetch From Right    ${Check_Medication}    \: \
    IF    "${Type}" == "Appointment"
        ${APT_Therapy_And_Route}    Get Regexp Matches    ${AppointmentData.Therapy_And_Route}    (?<=\\[ ).*(?= \\])
        ${APT_Therapy_And_Route}    Set Variable    ${APT_Therapy_And_Route}[0]
        Should Contain    ${Check_Medication}    ${PO_data.Medication}    ignore_case=True
    ELSE IF    "${Type}" == "Visit"
        ${Check_Medication}    Strip String    ${Check_Medication}
        Should Be Equal    ${Check_Medication}    No Primary Medications Assigned
    ELSE IF    "${View}" == "Tall View" or "${View}" == "Condensed View"
        ${Ledger_Medication_Select}    Util.Replace Xpath    xpath=${Ledger_Medication_Select}
        Element Should Be Visible    ${Ledger_Medication_Select}    #droplist to select medication for office visit
        List Selection Should Be    ${Ledger_Medication_Select}    \-- Select a Therapy --\
    END
    
Check Refer To Provider
    ${Refer_To_Input}    Util.Replace Xpath    xpath=${Refer_To_Input}
    ${Check_ReferTo}    Wait Until Keyword Succeeds    5s    1s    SeleniumLibrary.Get Element Attribute    ${Refer_To_Input}    value
    ${Check_NPI}    Get Regexp Matches    ${Check_ReferTo}    (?<=NPI#\ :\ )[a-zA-Z0-9]{1,}
    ${Check_ReferTo}    Fetch From Left    ${Check_ReferTo}    \ (\
    ${Check_ReferTo}    Strip String    ${Check_ReferTo}
    ${FirstName_ReferTo}    Fetch From Left    ${AppointmentData.ReferTo_Provider}    \ \
    ${LastName_ReferTo}    Fetch From Right    ${AppointmentData.ReferTo_Provider}    \ \
    Should Be Equal As Strings    ${Check_NPI}[0]    ${AppointmentData.ReferTo_NPI}
    ${FirstName_ReferTo}    Get Regexp Matches    ${PO_data.Refer_To_Provider}    (?<=\, ).*(?=\ \\()
    ${FirstName_ReferTo}    Set Variable    ${FirstName_ReferTo}[0]
    ${LastName_ReferTo}    Fetch From Left   ${PO_data.Refer_To_Provider}    \,\
    Should Contain    ${Check_ReferTo}    ${LastName_ReferTo}, ${FirstName_ReferTo}    ignore_case=True

Select Condensed View
    Wait Until Keyword Succeeds    5 times    1s    Scroll Element Into View    ${Views_Dropdown}
    Wait Until Keyword Succeeds    5 times    1s    Click Element    ${Ledger_Select}
    Wait Until Keyword Succeeds    5 times    1s    Select From List By Label    ${Ledger_Select}    Condensed View
    Click Element    ${APT_Search_Link}
Select Calendar View
    Scroll Element Into View    ${Views_Dropdown}
    Wait Until Element Is Visible    ${Views_Dropdown}    60s
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${Views_Dropdown}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Calendar View    strip_spaces=False
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${Views_Dropdown}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${Calendar_View_Link}
    END
    Wait Until Keyword Succeeds    5s    1s    Search By Location    Location_arg=${PatientData.Location}
    Wait Until Element Is Visible    ${Calendar_Table}    30s

Check Number Of Places
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Element Should Be Visible    //*[@id='ModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        Close Modal
    END
    Sleep    1s
    ${Check_APT_Location_Modal}    Run Keyword And Return Status    Element Should Be Visible    ${Location_Count_Select}    #issue
    IF    ${Check_APT_Location_Modal} == ${False}
        Wait Until Keyword Succeeds    10s    1s    Click Button    ${APT_Room_Setting_Btn}
        Wait Until Element Is Visible    ${Location_Count_Select}    30s
    END
    ${Places_Number}    Get Selected List Label    ${Location_Count_Select}
    ${Places_Number}    Evaluate    ${Places_Number}
    Set Test Variable    ${Places_Number}
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${APT_Room_Setting_Close_Btn}
    Sleep    2s
    Wait Until Keyword Succeeds    5s    1s    Click Button    ${APT_Room_Setting_Close_Btn}
    Wait Until Element Is Not Visible    ${Cancel_APT_Popup}    30s
Check Date - Calendar
    ${Date_Calendar}    Get Text    ${Calendar_Date_Header}
    ${Check_Date_Calendar}    Convert Date    ${AppointmentData.DOS}    result_format=%b %d,%Y    date_format=%m/%d/%Y
    Should Be Equal    ${Check_Date_Calendar} - ${Check_Date_Calendar}    ${Date_Calendar}
    ${Weekday_Calendar}    Get Text    ${Calendar_Weekday_Text}
    ${Check_Weekday_Calendar}    Convert Date    ${AppointmentData.DOS}    result_format=%A %b %d,%Y    date_format=%m/%d/%Y
    Should Be Equal    ${Check_Weekday_Calendar}    ${Weekday_Calendar}
Check Time - Calendar
    [Arguments]    ${StartTime}    ${Place}
    FOR    ${i}    IN RANGE    1    ${Places_Number+1}    #i: Calendar column number
        Set Test Variable    ${i}
        ${room_xpath}    Util.Replace Xpath    xpath=${APT_Room_Header}
        ${Place_Label}    Get Text    ${room_xpath}
        IF    "${Place_Label}" == "${Place}"
            IF    ${i} != ${Places_Number}
                ${next_room_xpath}    Util.Replace Xpath    xpath=${Next_APT_Room_Header}
                Click Element    ${next_room_xpath}
            ELSE
                Click Element    ${room_xpath}
            END
            ${Check_Temp}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Click Button    ${APT_Room_Rename_Close_Btn}
            ${j}    Evaluate    1
            ${Find_Time}    Set Variable    ${False}
            WHILE    ${Find_Time} == ${False}
                Set Test Variable    ${j}
                ${time_xpath}    Util.Replace Xpath    xpath=${Calendar_APT_Time}
                ${Check_Time_Visible}    Run Keyword And Return Status    Element Should Be Visible    ${time_xpath}
                IF    ${Check_Time_Visible} == ${False}    #check Appointment visible in Calendar
                    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${time_xpath}
                END
                ${Time}    Get Text    ${time_xpath}
                ${Check_Time}    Run Keyword And Return Status    Should Be Equal As Strings    ${Time}    ${StartTime}    ignore_case=${True}
                IF    ${Check_Time} == ${True}    #IF Appointment time in Calendar is the same as time scheduled before
                    Set Test Variable    ${Place_Column}    ${i}
                    Set Test Variable    ${Time_Row}    ${j}
                    Set Test Variable    ${APT_Time_XPath}    ${time_xpath}
                    ${med_text}    Util.Replace Xpath    xpath=${Calendar_Medication_Text}
                    Wait Until Keyword Succeeds    10s    3s    Mouse Over    ${time_xpath}    #hover mouse on appointment (in calendar) to view calendar table expanded and popover table
                    Wait Until Keyword Succeeds    10s    3s   Scroll Element Into View    ${med_text}
                    Execute JavaScript  document.activeElement.blur()
                    Wait Until Keyword Succeeds    10s    3s    Mouse Over    ${time_xpath}
                    BREAK
                ELSE
                    ${j}    Evaluate    ${j} + 1
                END
            END
            IF    ${Check_Time} == ${True}
                BREAK
            END
        END
    END
    Should Be Equal    ${Check_Time}    ${True}
    Should Be Equal    ${Place_Label}    ${Place}
    Set Test Variable    ${APT_Time_XPath}    ${time_xpath}

Check Appointment Expanding On Calendar Table
    # 1 minute expanding in 2 pxls (UI)
    # check Start Time position on calendar table
    ${Calendar_APT_Details}    Util.Replace Xpath    xpath=${Calendar_APT_Details}
    ${Check_Expanding_Calendar}    SeleniumLibrary.Get Element Attribute    ${Calendar_APT_Details}    style
    ${Check_StartTime_Position_1}    Get Regexp Matches    ${Check_Expanding_Calendar}    \(?=<top: ).*(?=px)\    #Check_StartTime_Position_1: start time position in calendar
    ${Check_StartTime_Position_1}    Evaluate    ${Check_StartTime_Position_1}[0]
    ${StartTime_Calendar}    Convert To Upper Case    ${AppointmentData.Start_Time}
    ${Check_StartTime_Position_1}    Convert Date    ${Check_StartTime_Position_1}    result_format=%H:%M    date_format=%I:%M %p
    ${Check_StartTime_Position_2}    Subtract Time From Time    ${Check_StartTime_Position_1}    6:00    #Check_StartTime_Position_2: start time position compared to 6AM (calendar only showing APTs from 6AM to 8PM)
    ${Check_StartTime_Position_2}    Convert To Integer    ${Check_StartTime_Position_2}
    Should Be Equal    ${Check_StartTime_Position_1}    ${${Check_StartTime_Position_2}*2}
    # check time range on calendar table
    ${Check_Duration_Calendar}    Get Regexp Matches    ${Check_Expanding_Calendar}    \(?=<height: ).*(?=px)\
    ${Check_Duration_Calendar}    Evaluate    ${Check_Duration_Calendar}[0]
    Should Be Equal    ${Check_Duration_Calendar}    ${${AppointmentData.Duration}*2}
Check Name - Calendar
    ${Calendar_Name_Text}    Util.Replace Xpath    xpath=${Calendar_Name_Text}
    ${Check_Patient_Calendar}    Run Keyword And Return Status    Wait Until Element Is Visible    ${Calendar_Name_Text}    10s
    IF    ${Check_Patient_Calendar} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Mouse Over    ${Calendar_Weekday_Text}
        ${Calendar_APT_Time_2}    Util.Replace Xpath    xpath=${Calendar_APT_Time_2}
        Wait Until Keyword Succeeds    5s    1s    Mouse Over    ${Calendar_APT_Time_2}
    END
    ${Name_Calendar}    Wait Until Keyword Succeeds    5s    1s    Get Text    ${Calendar_Name_Text}
    Should Be Equal    ${PatientData.First_Name} ${PatientData.Last_Name}    ${Name_Calendar}
Check DOB - Calendar
    ${Calendar_DOB_Text}    Util.Replace Xpath    xpath=${Calendar_DOB_Text}
    ${DOB_Calendar}    Get Text    ${Calendar_DOB_Text}
    ${DOB_Calendar}    Fetch From Right    ${DOB_Calendar}    \: \
    ${DOB_Calendar}    Convert Date    ${DOB_Calendar}    date_format=%m/%d/%Y    result_format=datetime
    ${Check_DOB}    Convert Date    ${PatientData.DOB}    date_format=%m/%d/%Y    result_format=datetime
    Should Be Equal    ${Check_DOB}    ${DOB_Calendar}    
Check Medication - Calendar
    [Arguments]    ${Type}
    ${Calendar_Medication_Text}    Util.Replace Xpath    xpath=${Calendar_Medication_Text}
    ${Medication_Calendar}    Get Text    ${Calendar_Medication_Text}
    ${Medication_Calendar}    Fetch From Right    ${Medication_Calendar}    \Medication: \
    ${APT_Therapy_And_Route}    Get Regexp Matches    ${AppointmentData.Therapy_And_Route}    (?<=\\[ ).*(?= \\])
    ${APT_Therapy_And_Route}    Set Variable    ${APT_Therapy_And_Route}[0]
    IF    "${Type}" == "Appointment"
        Should Contain    ${Medication_Calendar}    ${PO_data.Medication}
        
    ELSE    #IF Type = Visit
        Should Be Equal    ${Medication_Calendar}    Empty Appointment
    END
Check Status - Calendar
    ${Calendar_Status_Text}    Util.Replace Xpath    xpath=${Calendar_Status_Text}
    ${Status_Calendar}    Get Text    ${Calendar_Status_Text}
    ${Status_Calendar}    Fetch From Right    ${Status_Calendar}    \: \
    ${Check_Status}    Run Keyword And Return Status    Should Be Equal    ${Status_Calendar}    Dispensed
    IF    ${Check_Status} == ${False}
        Should Be Equal    ${Status_Calendar}    Required Labs    #some location with status of Required Labs, NOT Required Approval! 
    END
Check Location - Popover    #popover: popup on calendar view when hovering mouse
    ${check_sub_mdl}    Run Keyword And Return Status    Close Submodal
    ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    ${Popup_Location_Text}
    FOR    ${i}    IN RANGE    10
        Mouse Over    //*[contains(@class,'timeslot') and contains(@class,'header') and not(@rowspan)]
        Mouse Over    ${APT_Time_XPath}
        ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    ${Popup_Location_Text}
        IF    ${is_visible} == ${True}
            ${Check_Location}    Get Text    ${Popup_Location_Text}
            BREAK
        END
        Sleep    3s
    END
    Should Be Equal    ${Check_Location}    ${PatientData.Location} (${PatientData.Location_ID})
Check Date Of Service - Popover    #DOS
    [Arguments]    ${Date}
    ${DOS}    Get Text    ${Popup_DOS_Text}
    ${DOS}    Fetch From Right    ${DOS}    \: \    
    ${Check_DOS}    Convert Date    ${Date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${Check_DOS}    Evaluate    "/".join(part.lstrip("0") for part in "${Check_DOS}".split("/"))
    Should Be Equal    ${Check_DOS}    ${DOS} 
Check Patient - Popover
    ${Patient}    Get Text    ${Popup_Patient_Text}
    ${Patient}    Fetch From Right    ${Patient}    \: \
    Should Be Equal    ${PatientData.Last_Name}, ${PatientData.First_Name}    ${Patient}
Check DOB - Popover
    ${DOB}    Get Text    ${Popup_DOB_Text}
    ${DOB}    Fetch From Right    ${DOB}    \: \
    ${DOB}    Convert Date    ${DOB}    date_format=%m/%d/%Y    result_format=datetime    
    ${Check_DOB}    Convert Date    ${PatientData.DOB}    date_format=%m/%d/%Y    result_format=datetime
    Should Be Equal    ${Check_DOB}    ${DOB}
Check DX Code - Popover
    ${DX_Code}    Get Text    ${Popup_DX_Text}
    ${DX_Code}    Fetch From Right    ${DX_Code}    \: \
    Should Be Equal    ${AppointmentData.DX_Code}    ${DX_Code}
Check Description - Popover
    [Arguments]    ${Type}
    IF    "${Type}" == "Appointment"    #${Office_Visit} == ${False}
        ${Description}    Get Text    ${Popup_Description_Text}
        Should Be Equal    ${AppointmentData.Medication} [${AppointmentData.Route}]    ${Description}    ignore_case=True
    ELSE    #IF Type = Visit
        Element Should Be Visible    ${Popup_No_Med_Description_Text}    
    END
Check Dose - Popover
    ${Qty}    Get Text    ${Popup_Dose_Text}
    Should Be Equal    ${AppointmentData.Dose}    ${Qty}
Check UoM - Popover
    ${UoM}    Get Text    ${Popup_UoM_Text}
    ${UoM}    Strip String    ${UoM}
    Should Be Equal    ${AppointmentData.UoM_Scheduling}    ${UoM}
Get Appointment List
    Check Tall View    #go to Tall View
    Sleep    5s
    ${APT_List}    Wait Until Keyword Succeeds    10s    1s    Get WebElements    ${APT_Time_Text}
    ${Count_APT}    Get Length    ${APT_List}
    Set Test Variable    ${Count_APT}
Check Appointment
    [Arguments]    ${Time_1}    ${Time_2}
    Set Test Variable    ${StartTime}    ${Time_1}
    IF    ${Count_APT} > 0
        IF    ${Count_APT} == 15
            Check Appointment Time Earlier Than Last Appointment Or Not    ${Time_1}
        END
        Check Appointment Duplicated Or Not    ${Time_1}    ${Time_2}    #Canceled ALL APTs/Visits with same start time IF found ANY in Tall View
    END
    IF    ${Office_Visit} == ${False}
        Set To Dictionary   ${AppointmentData}    Start_Time=${StartTime}
    ELSE
        Set To Dictionary   ${AppointmentData}    Visit_Start_Time=${StartTime}
    END
    Set Test Variable    ${AppointmentData}

Check Appointment Time Earlier Than Last Appointment Or Not
    [Arguments]    ${Time_1}
    Util.Scroll To Bottom
    ${Time_Last_APT}    Get Text    ${Last_APT_Time_Text}
    ${Date_Time_Last_APT}    Convert Date    ${Time_Last_APT}    date_format=%I:%M %p    ##Time_Last_APT
    ${Date_Time_APT}    Convert Date    ${Time_1}    date_format=%I:%M %p    ##Time_APT     
    ${Time_Difference}    Subtract Date From Date    ${Date_Time_Last_APT}    ${Date_Time_APT}    ##Time_Last_APT
    IF    ${Time_Difference} < 0
        Click Element    ${Cancel_Last_APT_Element}
        Cancel Appointment
        ${today}    Util.Check Time Zone
        ${Date_Time_Last_APT}    Convert Date    ${today} ${Time_Last_APT}    date_format=%m/%d/%Y %I:%M %p        
        ${StartTime}    Subtract Time From Date    ${Date_Time_Last_APT}    1 min    result_format=%#I:%M %p
        Set Test Variable    ${StartTime}
    END
Check Appointment Duplicated Or Not
    [Arguments]    ${Time_1}    ${Time_2}
    ${Time_1}    Convert To Upper Case    ${Time_1}
    Set Test Variable    ${Time_1}
    ${Time_2}    Convert To Upper Case    ${Time_2}
    Set Test Variable    ${Time_2}
    ${Check_APT_Time_Text_1}    Util.Replace Xpath    xpath=${Check_APT_Time_Text_1}
    ${Check_Time_Duplicated}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${Check_APT_Time_Text_1}
    IF    ${Check_Time_Duplicated} == ${True}
        Set Test Variable    ${StartTime}    ${Time_2}
        ${Check_APT_Time_Text_2}    Util.Replace Xpath    xpath=${Check_APT_Time_Text_2}
        ${Check_Time_Duplicated}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${Check_APT_Time_Text_2}
        IF    ${Check_Time_Duplicated} == ${True}
            WHILE    ${Check_Time_Duplicated} == ${True}
                Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${Check_APT_Time_Text_2}\[1]
                Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${Check_APT_Time_Text_2}\[1]/following::tr\[1]
                Wait Until Keyword Succeeds    10s    1s    Click Element    ${Check_APT_Time_Text_2}\[1]/following::*\[@title="Cancel Appointment"]\[1]
                Cancel Appointment
                Wait Until Element Is Visible    ${Scheduled_APTs_Title_Text}    10s
                Sleep    1s
                ${Check_Time_Duplicated}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${Check_APT_Time_Text_2}
            END
        END
    END

Find APT And Cancel
    [Arguments]    ${DOS_arg}    ${time_arg}
    Filter Appointment    date_time=${DOS_arg}    medication=\-- All Medications --\    appointment_status=\-- All Statuses --\
    Set Test Variable    ${StartTime}    ${time_arg}
    Cancel Appointment
    Select Ledger View
    Check Tall View

Cancel Appointment
    ${StartTime}    Convert To Upper Case    ${StartTime}
    ${StartTime}    Remove String Using Regexp    ${StartTime}    \^0\
    Set Test Variable    ${StartTime}    ${StartTime}
    ${xpath}    Util.Replace Xpath    ${Ledger_APT_Time_Xpath}
    Scroll Element Into View    ${xpath}/following::tr[1]
    Wait Until Element Is Visible    ${xpath}/following::tr[1]    30s
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${xpath}/following::*[@title="Cancel Appointment"][1]
    Wait Until Element Is Visible    ${Cancel_APT_Popup}    30s
    Wait Until Element Is Visible    ${Cancel_Reason_Select}    30s
    Select From List By Label    ${Cancel_Reason_Select}    Cancellation
    Click Button    ${Cancel_APT_Btn}
    Wait Until Page Contains    Appointment Canceled!    30s
    Wait Until Page Does Not Contain    Appointment Canceled!    30s
    Run Keyword And Return Status    Close Modal

Return Medication To Inventory
    Set Test Variable    ${line}    /*
    ${return_btn}    Util.Replace Xpath    xpath=${asdos_return_inventory_button}
    ${btns}    Get WebElements    ${return_btn}
    ${count}    Get Length    ${btns}
    FOR    ${i}    IN RANGE    1    ${count+1}
        Set Test Variable    ${num}
        Set Test Variable    ${line}    ${i}
        ${return_btn}    Util.Replace Xpath    xpath=${return_btn}
        Click Element    ${return_btn}
        Handle Alert
        Wait Until Page Contains    Item put back into inventory    30s
        Wait Until Page Does Not Contain    Item put back into inventory    30s
    END
    Close Modal

Check Office Visit
    [Arguments]    ${Time_1}    ${Time_2}
    Set Test Variable    ${Office_Visit}    ${True}
    Check Appointment    ${Time_1}    ${Time_2}

Select Check-In View
    Scroll Element Into View    ${Views_Dropdown}
    Wait Until Element Is Visible    ${Views_Dropdown}    60s
    ${label}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${Views_Dropdown}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${label}    Check-In View    strip_spaces=False
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    60s    1s    Click Button    ${Views_Dropdown}
        Wait Until Keyword Succeeds    60s    1s    Click Element   ${Checkin_View_Link}
    END

Check NO Option Selected    #checked-in
    ${Checkin_RadioBtn}    Util.Replace Xpath    xpath=${Checkin_RadioBtn}
    ${Check_No_Option}    SeleniumLibrary.Get Element Attribute    ${Checkin_RadioBtn}\[2]    checked
    Should Be Equal    ${Check_No_Option}    true    #NO option selected
    ${Check_Yes_Option}    SeleniumLibrary.Get Element Attribute    ${Checkin_RadioBtn}\[1]    checked
    Should Be Equal As Strings    ${Check_Yes_Option}    None    #YES option NOT selected
Check Location - Check-In
    ${Checkin_Location_Text}    Util.Replace Xpath    xpath=${Checkin_Location_Text}
    ${Location_CheckIn}    Get Text    ${Checkin_Location_Text}
    Should Be Equal    ${Location_CheckIn}    (${LocationID}) ${PatientData.Location}    #${LocationPO}
Check Office Visit Scheduled OR not
    IF    ${Office_Visit_Scheduled} == ${False}
        Pass Execution    OFFICE VISIT NOT SCHEDULED
    END
Select Office Visit View
    Wait Until Keyword Succeeds    5 times    1s    Scroll Element Into View    ${Views_Dropdown}
    Wait Until Keyword Succeeds    5 times    1    Click Button    ${Views_Dropdown}
    Click Element   ${Office_Visit_View_Link}
    Wait Until Element Is Visible    ${Office_Visits_Title_Text}    30s
Check Provider - Office Visit
    IF    "${AppointmentData.Visit_Provider}" == "-- Select a Provider --"    #IF NO Provider selected
        No Operation
    ELSE
        ${Visit_Provider_Text}    Util.Replace Xpath    xpath=${Visit_Provider_Text}
        ${Provider_Visit}    Get Text    ${Visit_Provider_Text}
        ${Provider_Visit}    Fetch From Right   ${Provider_Visit}    \Provider: \
        ${Check_Provider_Visit}    Fetch From Left    ${AppointmentData.Visit_Provider}    \ (\
        ${Check_Provider_FirstName}    Fetch From Right    ${Check_Provider_Visit}    \ \
        ${Check_Provider_LastName}    Fetch From Left   ${Check_Provider_Visit}    \,\
        ${Check_Provider_NPI}    Remove String    ${AppointmentData.Visit_Provider}    ${Check_Provider_Visit}
        Should Be Equal    ${Check_Provider_FirstName} ${Check_Provider_LastName}${Check_Provider_NPI}    ${Provider_Visit}
    END
Check Cancel Office Visit Selections
    ${Cancel_Visit_RadioBtn}    Util.Replace Xpath    xpath=${Cancel_Visit_RadioBtn}
    ${Cancel_Selections_List}    Get WebElements    ${Cancel_Visit_RadioBtn}
    FOR    ${Selection}    IN    @{Cancel_Selections_List}
        ${Check}    SeleniumLibrary.Get Element Attribute    ${Selection}    checked
        Should Not Be Equal    ${Check}    checked    #checked attr=None
    END
Temp - Filter Office Visit
    Wait Until Element Is Enabled    //*[@id="StartDate"]
    Input Text    ${FilterStartDate_input}    ${AppointmentData.Visit_DOS}
    Input Text    ${FilterEndDate_input}    ${AppointmentData.DOS}
    Wait Until Element Is Enabled    //button[text()="Done"]
    Wait Until Keyword Succeeds    5s    1s    Click Button    Done

Switch Medication Tab
    [Arguments]    ${tab_arg}    ${header_arg}
    Scroll Element Into View    ${tab_arg}
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${tab_arg}
    Scroll Element Into View    ${header_arg}
    Wait Until Element Is Visible    ${header_arg}    30s

Set Reason For Over Or Under Dose
    [Arguments]    ${reason_arg}
    IF    "${selected}" != "Other"
        ${reason}    Set Variable    ${selected}
    ELSE
        Wait Until Element Is Visible    id=DispenseAmountReason    10s
        Input Text    id=DispenseAmountReason    ${reason_arg}
        ${reason}    Set Variable    ${reason_arg}
    END
    Click Button    //*[contains(@id,"SubModalPopup")]//*[@id="SaveBtn" and contains(text(),"Continue")]
    RETURN    ${reason}

Get Data From Last Treatment Note
    ${APT_note_input}    Util.Replace Xpath    xpath=${APT_note_input}
    Scroll Element Into View    ${APT_note_input}
    ${view_tnote_btn}    Util.Replace Xpath    xpath=${view_tnote_btn}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${view_tnote_btn}
    Handle Future APT Warning
    Util.Wait For Page Loading    element_arg=${tnote_tab_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    Check PO Details Collapsed
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${tnote_PO_collapse}
    Add Value To List    PATIENT:    MRN:    TREATMENT\ #:\    DATE OF SERVICE:    DOSE:    FREQ:    xpath_arg=${tnote_header_field_text}
    Add Value To Dict    Patient    MRN    TNote_Num    DOS    Dose    Frequency
    Set To Dictionary    ${LastTNoteData}    &{dict_value}
    ${clinician}    Get Selected List Label    ${tnote_header_clinician_select}
    Set To Dictionary    ${LastTNoteData}    Clinician=${clinician}
    Set Test Variable    ${LastTNoteData}

Scroll To Section
    [Arguments]    ${sec_arg_1}    ${sec_arg_2}    ${xpath_arg}
    Set Test Variable    ${section_1}    ${sec_arg_1}
    Set Test Variable    ${section_2}    ${sec_arg_2}
    ${tnote_nav_button}    Util.Replace Xpath    xpath=${tnote_nav_button}
    Wait Until Keyword Succeeds    10s    1s    Click Element    ${tnote_nav_button}
    Wait Until Element Is Visible    ${xpath_arg}    30s

Check PO Details Collapsed
    Sleep    5s
    ${check}    Run Keyword And Return Status    Element Should Be Visible    ${tnote_PO_expand_area}
    Sleep    1s
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    9s    1s    Click Element    ${tnote_PO_collapse}
    END

Open Treatment Note
    ${random}    Evaluate    random.randint(0,1)
    IF    ${random} == 0    #open TNote in Dispense Medication modal
        Click Open APT Button    btn_arg=${open_APT_btn}    xpath_arg=${Ledger_APT_Time_Xpath}    start_time_arg=${AppointmentData.Start_Time}    xpath_header_arg=${open_APT_dispensed_header_text}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tnote_tab_link}
    ELSE    #open TNote in APT Ledger View
        ${StartTime}    Convert To Upper Case    ${AppointmentData.Start_Time}
        ${StartTime}    Remove String Using Regexp    ${StartTime}    \^0\
        Set Test Variable    ${StartTime}    ${StartTime}
        ${Xpath_Time}    Util.Replace Xpath    xpath=${Ledger_APT_Time_Xpath}
        Set Test Variable    ${Xpath_Time}
        ${APT_note_input}    Util.Replace Xpath    xpath=${APT_note_input}
        Scroll Element Into View    ${APT_note_input}
        ${view_tnote_btn}    Util.Replace Xpath    xpath=${view_tnote_btn}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${view_tnote_btn}
        Handle Future APT Warning
    END
    Util.Wait For Page Loading    element_arg=${tnote_tab_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=120s
    Wait Until Element Is Visible    ${tnote_nav_bar}    60s

Set Value To Assessment
    [Arguments]    ${time_arg}    ${values_arg}
    @{fields}    Create List    Blood_Pressure_mmHg    Heart_Rate_bpm    Temp_F    Respiratory_Rate_BPM    SPO2_%    Oxygen_L/min    O2_Delivery_Medthod
    @{fields_skipped}    Create List    1    2
    Set Value To Assessment Header    time_arg=${time_arg}    values_arg=${values_arg}    fields_arg=${fields}    fields_skipped_arg=${fields_skipped}
    Set Value To Qualifying Assessment
    Set Value To General Assessment
    Set Value To Patient Reported Assessment
    # Set Value To Review Of Systems
    # Set Value To Exam

Set Value To Assessment Header
    [Arguments]    ${time_arg}    ${fields_arg}    ${values_arg}    ${fields_skipped_arg}
    Scroll To Section    sec_arg_1=assesment    sec_arg_2=Assessment    xpath_arg=${tnote_assessment_title}
    Wait Until Keyword Succeeds    29s    1s    Input Text    ${tnote_assessment_time_input}    ${time_arg}
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
    Click Element    ${tnote_assessment_title}
    Set To Dictionary    ${TNoteData}    Start_Time=${time_arg}
    Set Test Variable    ${temp}    ${False}
    Set Value To Field    xpath_field_arg=${tnote_assessment_vital_table_field}    xpath_option_arg=None    options_arg=None    fields_arg=${fields_arg}    values_arg=${values_arg}    fields_skipped_arg=${fields_skipped_arg}    mess_arg=Updated successfully    xpath_modal_arg=None    fields_other_arg=None
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Set Test Variable    ${TNoteData}

Set Value To Qualifying Assessment
    @{list_mess}    Create List    Updated Successfully
    &{options}    Create Dictionary    Y=Yes    N=No    #yes and no
    Select Option For Yes Or No    xpath_field_arg=${tnote_assessment_quali_field}    xpath_text_arg=${tnote_assessment_quali_field_text}    xpath_option_arg=${tnote_asessment_quali_option_checkbox}    options_arg=${options}    xpath_note_text_arg=${tnote_assessment_quali_note_text}    xpath_note_input_arg=${tnote_assessment_quali_note_input}    list_mess_arg=${list_mess}    is_mess_same_arg=${True}    is_with_note=${True}    column_arg=1    fields_other_arg=None
    Set To Dictionary    ${TNoteData}    &{dict_text}
    Set Test Variable    ${TNoteData}

Set Value To General Assessment
    @{list_mess}    Create List
    Scroll Element Into View    ${tnote_assessment_pati_text}
    @{list_temp}    Create List    The Medications    The Allergies    The Labs    None
    &{options}    Create Dictionary    Y=Yes    N=No
    FOR    ${i}    IN    @{list_temp}
        Append To List    ${list_mess}    ${i} Have Been Reviewed
    END
    Select Option For Yes Or No    xpath_field_arg=${tnote_assessment_gene_field}    xpath_text_arg=${tnote_assessment_gene_field_text}    xpath_option_arg=${tnote_assessment_gene_option_checkbox}    options_arg=${options}    xpath_note_text_arg=None    xpath_note_input_arg=None    list_mess_arg=${list_mess}    is_mess_same_arg=${False}    is_with_note=${False}    column_arg=2    fields_other_arg=None
    Set To Dictionary    ${TNoteData}    &{dict_text}
    Set Test Variable    ${TNoteData}

Set Value To Patient Reported Assessment
    @{list_mess}    Create List    Updated Successfully
    Scroll Element Into View    ${tnote_assessment_revi_text}
    Select Option From List    xpath_field_arg=${tnote_assessment_pati_field}    xpath_text_arg=${tnote_assessment_pati_field_text}    xpath_option_arg=${tnote_assessement_pati_option_select}    xpath_note_arg=${tnote_assessment_pati_note_input}    #list_mess_arg=${list_mess}    is_mess_same_arg=${True}    #description
    Set To Dictionary    ${TNoteData}    &{dict_text}
    Set Test Variable    ${TNoteData}

Set Value To Review Of Systems
    @{options}    Create List    Yes    No
    Wait Until Keyword Succeeds    10 times    3s   Scroll Element Into View    ${tnote_assessment_revi_add_btn}    #${tnote_assessment_exam_add_btn}
    Add System To Review    xpath_add_arg=${tnote_assessment_revi_add_btn}    xpath_view_arg=${tnote_assessment_revi_view_all_btn}    xpath_field_arg=${tnote_assessment_revi_field}    xpath_option_arg=${tnote_assessment_revi_option_checkbox}    options_arg=${options}    xpath_note_arg=${tnote_assessment_revi_note_input}    category_arg=Test Category    desc_arg=Test Description    type_arg=Review Systems    #type_arg: Review Systems or Exam
    Set To Dictionary    ${TNoteData}    &{dict_text}
    Set Test Variable    ${TNoteData}

Set Value To Exam
    @{options}    Create List    Yes    No
    Scroll Element Into View    ${tnote_aces_admin_title}
    Add System To Review    xpath_add_arg=${tnote_assessment_exam_add_btn}    xpath_view_arg=${tnote_assessment_exam_view_all_btn}    xpath_field_arg=${tnote_assessment_exam_field}    xpath_option_arg=${tnote_assessment_exam_option_checkbox}    options_arg=${options}    xpath_note_arg=${tnote_assessment_exam_note_input}    category_arg=Test Category    desc_arg=Test Description    type_arg=Exam    #type_arg: Review Systems or Exam
    Set To Dictionary    ${TNoteData}    &{dict_text}
    Set Test Variable    ${TNoteData}

Set Value To Access And Admin
    [Arguments]    ${values_arg}
    Scroll To Section    sec_arg_1=access-and-admin    sec_arg_2=Access & Admin    xpath_arg=${tnote_aces_admin_title}
    Scroll Element Into View    ${tnote_aces_admin_add_btn}
    Click Element    ${tnote_aces_admin_add_btn}
    @{fields}    Create List    Therapy_Type    Route_Admin    Device_Type    Device_Size    Access_Admin_Size    Access_Successful    Blood_Return    Attempts_Needles    Clician
    @{fields_skipped}    Create List    1    2    10    11    #special case
    @{options}    Create List    Y    N
    Set Test Variable    ${temp}    ${False}
    Set Value To Field    values_arg=${values_arg}    xpath_field_arg=${tnote_aces_admin_field}    xpath_option_arg=${tnote_aces_admin_option_checkbox}    options_arg=${options}    fields_arg=${fields}    fields_skipped_arg=${fields_skipped}    mess_arg=Encounter Note Access Line Updated    xpath_modal_arg=${tnote_aces_admin_device_type_input}        fields_other_arg=None
    Set Test Variable    ${line}    1
    ${tnote_aces_admin_note_input}    Util.Replace Xpath    xpath=${tnote_aces_admin_note_input}
    Input Text    ${tnote_aces_admin_note_input}    Test Note
    Util.Wait For Page Loading    element_arg=Encounter Note Access Line Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=30s
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Set Test Variable    ${TNoteData}

Set Value To Meds And Fluids
    [Arguments]    ${size_arg}    ${vol_wdrawn_arg}    ${med_arg}    ${qty_arg}    ${time_arg}    ${lot_arg}
    Scroll To Section    sec_arg_1=medication    sec_arg_2=Meds & Fluids    xpath_arg=${tnote_med_flu_title}
    Util.Select Random From List    xpath_arg=${tnote_med_flu_diluent_select}    remove_default_arg=${True}
    Util.Wait For Page Loading    element_arg=Updated Successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=60s
    Input Text    ${tnote_med_flu_size_input}    ${size_arg}
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
    Util.Wait For Page Loading    element_arg=Updated Successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=60s
    Input Text    ${tnote_med_flu_volume_wdrawn_input}    ${vol_wdrawn_arg}
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
    Util.Wait For Page Loading    element_arg=Updated Successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=60s
    Scroll Element Into View    ${tnote_med_flu_add_second_med_btn}
    Click Button    ${tnote_med_flu_add_second_med_btn}
    Wait Until Page Contains    Secondary Medications \(Pre & PRN\)    60s
    Sleep    3s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${tnote_med_flu_add_second_med_btn_modal}
    Util.Wait For Page Loading    element_arg=${tnote_med_flu_second_med_loading}    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=300s
    Input Text    ${tnote_med_flu_search_second_med_input}    ${med_arg}
    Click Button    ${tnote_med_flu_search_second_med_btn}
    Util.Wait For Page Loading    element_arg=${tnote_med_flu_second_med_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=300s
    Set Test Variable    ${med}    ${med_arg}
    ${tnote_med_flu_second_med_accept_btn}    Util.Replace Xpath    xpath=${tnote_med_flu_second_med_accept_btn}
    Click Element    ${tnote_med_flu_second_med_accept_btn}
    Wait Until Element Is Visible    ${tnote_med_flu_second_med_qty_input}    60s
    Input Text    ${tnote_med_flu_second_med_qty_input}    ${qty_arg}
    ${radios}    Get WebElements    ${tnote_med_flu_second_med_type_radiobtn}
    ${num}    Get Length    ${radios}
    ${index_random}    Evaluate    random.randint(0,${num-1})
    ${radio_random}    Get From List    ${radios}    ${index_random}
    Sleep    1s
    Click Element    ${radio_random}
    Input Text    ${tnote_med_flu_second_med_time_input}    ${time_arg}
    Click Button    ${tnote_med_flu_second_med_continue_btn}
    Wait For Page Loading    element_arg=Appointment Item Successfully Created    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Wait For Page Loading    element_arg=${tnote_med_flu_second_med_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Wait Until Element Is Visible    ${tnote_med_flu_second_med_top_close_btn}    60s
    Click Button    ${tnote_med_flu_second_med_top_close_btn}
    # DEV issue
    ${check}    Get Value    ${tnote_med_flu_second_med_qty_input_2}
    IF    "${check}" != "1"
        Input Text    ${tnote_med_flu_second_med_qty_input_2}    1
    END
    Input Text    ${tnote_med_flu_second_med_note_input}    Test Note
    Scroll Element Into View    ${close_submodal_btn}
    Wait Until Keyword Succeeds    29s    1s   Click Element    ${tnote_med_flu_second_med_approve_btn}
    Util.Wait For Page Loading    element_arg=Dosage Has Been Accepted    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    # dispense second meds
    ${check}    Run Keyword And Return Status    Element Attribute Value Should Be    ${tnote_med_flu_second_med_show_all_lots_checkbox}    checked    true    #${asdos_show_all_lots_checkbox}
    IF    ${check} == ${False}
        Sleep    1s
        Wait Until Keyword Succeeds    10s    1s    Click Element    ${tnote_med_flu_second_med_show_all_lots_checkbox}
        Sleep    1s
    END
    Scroll Element Into View        ${asdos_lot_num_selection_second_med_text}
    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${tnote_med_flu_second_med_lot_select}    ${lot_arg}
    Util.Wait For Page Loading    element_arg=Dispense Line Updated    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Visible    timeout_arg=30s
    Util.Select Random From List    xpath_arg=${tnote_med_flu_second_med_facility_select}    remove_default_arg=${False}
    Click Element    ${tnote_med_flu_second_med_dispense_btn}
    Handle Alert    ACCEPT
    Util.Wait For Page Loading    element_arg=Appointment Dispensed    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Visible    timeout_arg=30s
    Sleep    1s
    Util.Scroll Into Element And Click    xpath_arg=${close_submodal_btn}    retry_arg=20    time_arg=3s    kw_arg=Click Button
    Wait Until Element Is Not Visible    //*[@id='SubModalPopup']//*[@class='modal-content']    60s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    60s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        Close Submodal
    END

Set Value To Procedural Details
    [Arguments]    ${rate_arg}    ${values_arg}
    Run Keyword And Ignore Error    Close Submodal
    Run Keyword And Ignore Error    Close Ultra Submodal
    Scroll To Section    sec_arg_1=procedural    sec_arg_2=Procedural Details    xpath_arg=${tnote_proc_det_title}
    ${check}    Run Keyword And Return Status    Element Should Be Visible    ${tnote_proc_det_title}
    IF    ${check} == ${False}
        Scroll To Section    sec_arg_1=procedural    sec_arg_2=Procedural Details    xpath_arg=${tnote_proc_det_title}
    END
    Input Text    ${tnote_proc_det_max_rate_input}    ${rate_arg}
    @{fields}    Create List    Drip_Rate    Blood_Pressure_mmHg_Proc_Measure    Heart_Rate_bpm_Proc_Measure    Temp_F_Proc_Measure    Respiratory_Rate_Proc_Measure    SPO2_%_Proc_Measure    Oxygen_L/min_Proc_Measure    O2_Delivery_Method_Proc_Measure    #Procedural Details - measure
    @{fields_skipped}    Create List    1    2    13
    @{fields_other}    Create List    3    4
    @{options}    Create List    Y    N
    Set Value To Field    xpath_field_arg=${tnote_proc_det_measurement_field}    xpath_option_arg=${tnote_proc_det_measurement_option_checkbox}    options_arg=${options}    fields_arg=${fields}    values_arg=${values_arg}    fields_skipped_arg=${fields_skipped}    mess_arg=Physical Measurement Added    xpath_modal_arg=None    fields_other_arg=${fields_other}
    Set Test Variable    ${line}    1
    ${tnote_proc_det_measurement_note_input}    Util.Replace Xpath    xpath=${tnote_proc_det_measurement_note_input}
    Input Text    ${tnote_proc_det_measurement_note_input}    Test Note
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
    Set To Dictionary    ${TNoteData}    Max_Drip_Rate=${rate_arg}    #Regimen=${regimen}
    Set Test Variable    ${TNoteData}

Set Value To Reaction Details
    [Arguments]    ${values_arg}
    Run Keyword And Ignore Error    Close Submodal
    Run Keyword And Ignore Error    Close Ultra Submodal
    Click Button    ${tnote_proc_det_proc_det_record_btn}
    @{fields}    Create List    React_Symptoms    Blood_Pressure_mmHg_Proc_React    Heart_Rate_bpm_Proc_React    Temp_F_Proc_React    Respiratory_Rate_Proc_React    SPO2_%_Proc_React    Oxygen_L/min_Proc_React    O2_Delivery_Method_Proc_React    React_Treatments    Is_Added_To_Meds_Fluids    #reaction
    @{fields_skipped}    Create List    1    12
    @{options}    Create List    Y    N
    Set Value To Field    xpath_field_arg=${tnote_proc_det_reaction_field}    xpath_option_arg=${tnote_proc_det_reaction_option_checkbox}    options_arg=${options}    fields_arg=${fields}    values_arg=${values_arg}    fields_skipped_arg=${fields_skipped}    mess_arg=Reaction Updated    xpath_modal_arg=None    fields_other_arg=None
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Util.Select Random From List    xpath_arg=${tnote_proc_det_reaction_severity_select}    remove_default_arg=${True}
    ${severity}    Set Variable    ${selected}
    Set To Dictionary    ${TNoteData}    Severity=${severity}    #Regimen_Updated=${regimen}
    Set Test Variable    ${TNoteData}

Set Value To Patient Discharge
    [Arguments]    ${time_arg}    ${PIN_arg}
    Run Keyword And Ignore Error    Close Submodal
    Run Keyword And Ignore Error    Close Ultra Submodal
    Scroll To Section    sec_arg_1=#patient-discharge    sec_arg_2=Patient Discharge    xpath_arg=${tnote_pati_dc_title}
    Input Text    ${tnote_pati_dc_stop_time_input}    ${time_arg}
    Scroll Element Into View    ${tnote_pati_dc_title}
    ${is_clickable}    Run Keyword And Return Status    Wait Until Keyword Succeeds    6 times    10s    Click Element    ${tnote_pati_dc_title}
    Run Keyword If    ${is_clickable} == ${False}    Wait Until Keyword Succeeds    6 times    10s    Execute JavaScript    return document.evaluate("${tnote_pati_dc_title}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Sleep    1s
    Scroll To Section    sec_arg_1=#patient-discharge    sec_arg_2=Patient Discharge    xpath_arg=${tnote_pati_dc_title}
    Sleep    1s
    Set To Dictionary    ${TNoteData}    End_Time=${time_arg}
    @{list_mess}    Create List    Discharge Information Updated
    &{options}    Create Dictionary    Y=Yes    N=No    #yes and no
    @{fields_other_arg}    Create List    5
    Select Option For Yes Or No    xpath_field_arg=${tnote_pati_disc_field}    xpath_text_arg=${tnote_pati_disc_field_text}    xpath_option_arg=${tnote_pati_disc_option_checkbox}    options_arg=${options}    xpath_note_text_arg=None    xpath_note_input_arg=${tnote_pati_disc_note_input}    list_mess_arg=${list_mess}    is_mess_same_arg=${True}    is_with_note=${True}    column_arg=1    fields_other_arg=${fields_other_arg}
    Set To Dictionary    ${TNoteData}    &{dict_text}
    # sign by provider - #issue
    Click Element    ${tnote_pati_disc_confirm_checkbox}
    # Sleep    10s
    Click Element    ${tnote_pati_disc_publish_btn}
    ${time}    Util.Check Time Zone
    Util.Wait For Page Loading    element_arg=Treatment Note Updated    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Util.Wait For Page Loading    element_arg=${tnote_last_tment_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Wait Treatment Note Published
    Set To Dictionary    ${TNoteData}    Time_Publish=${time}    #signature as image file    #Nusrse_Signature=${img}    
    Set Test Variable    ${TNoteData}

Wait Treatment Note Published
    ${style}    SeleniumLibrary.Get Element Attribute    ${tnote_header}    style
    ${check}    Run Keyword And Return Status    Should Contain    ${style}    background-color: forestgreen;
    FOR    ${i}    IN RANGE    40
        ${style}    SeleniumLibrary.Get Element Attribute    ${tnote_header}    style
        ${check}    Run Keyword And Return Status    Should Contain    ${style}    background-color: forestgreen;
        IF    ${check} == ${True}
            BREAK
        END
        Sleep    3s
    END

Check If Treatment Note Published
    ${style}    SeleniumLibrary.Get Element Attribute    ${tnote_header}    style
    Should Contain    ${style}    background-color: forestgreen;

Set Value To Post DC Activity
    [Arguments]    ${values_arg}
    @{fields}    Create List    Post_DC_Date    Post_DC_New_SS_Since_Treatment    Post_DC_Onset    Post_DC_Duration    Post_DC_Resolution    Post_DC_Notes    Post_User_Name    #reaction
    @{fields_skipped}    Create List    1    8
    @{fields_other}    Create List    7
    Scroll To Section    sec_arg_1=post-discharge    sec_arg_2=Post D/C Activity    xpath_arg=${tnote_post_dc_title}
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${tnote_post_dc_add_btn}
    Sleep    1s
    Util.Wait For Page Loading    element_arg=Treatment Note Updated    keyword_arg_1=Wait Until Element Is Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    Set Test Variable    ${xpath_other}    ${tnote_post_dc_user_field}
    Set Value To Field    xpath_field_arg=${tnote_post_dc_field}    xpath_option_arg=None    options_arg=None    fields_arg=${fields}    values_arg=${values_arg}    fields_skipped_arg=${fields_skipped}    mess_arg=Post Discharge Assessment Updated    xpath_modal_arg=None    fields_other_arg=${fields_other}

Check Treatment Note
    Open Treatment Note
    Check Header
    Check Last Treatment
    
Check Header
    Check PO Details Collapsed
    Add Value To List    PATIENT:    MRN:    TREATMENT\ #:\    DATE OF SERVICE:    WEIGHT:    HEIGHT:    MEDICATION:    DOSE:    FREQ:    ROUTE:    PRIMARY DIAGNOSIS:    SERVICE TYPE:    REFER TO PROVIDER:    xpath_arg=${tnote_header_field_text}
    Add Value To Dict    Patient    MRN    TNote_Num    DOS    Weight    Height    Medication    Dose    Frequency    Route    DX_Code    Service_Type    Refer_To_Provider
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Set Test Variable    ${TNoteData}
    Check Patient In Header
    Check MRN In Header
    Check Treatment Num In Header
    Check DOS In Header
    # Check Weight In Header    #assessment
    # Check Height In Header    ##assessment
    # Check Clinician In Header    #clinic acc
    Check PO Details In Header

Check Patient In Header    #clicic acc & prime acc
    ${DOB}    Convert Date    ${PatientData.DOB}    result_format=%m/%d/%y    date_format=%m/%d/%Y
    Should Be Equal    ${TNoteData.Patient}    ${PatientData.First_Name} ${PatientData.Last_Name} \(${DOB}\)    strip_spaces=True

Check MRN In Header
    Should Be Equal    ${PatientData.MRN}    ${TNoteData.MRN}    strip_spaces=True

Check Treatment Num In Header
    Should Be Equal    ${TNoteData.TNote_Num}    2    strip_spaces=True    #APT 2

Check DOS In Header
    ${DOS}    Convert Date    ${AppointmentData.DOS}    result_format=%m/%d/%y    date_format=%m/%d/%Y
    ${time}    Remove String Using Regexp    ${AppointmentData.Start_Time}    \:|\ .*\
    Should Be Equal    ${TNoteData.DOS}    ${DOS} @ ${time}    strip_spaces=True

Check Weight In Header
    ${weight_lb}    Fetch From Left    ${PatientData.Weight}    \ kg\
    ${weight_lb}    Evaluate    round(${weight}*2.2046)    #1kg ~ 2.2046lb
    Should Be Equal    ${TNoteData.Weight}    ${PatientData.Weight} \(${weight_lb} lb\)    strip_spaces=True

Check Height In Header
    ${height_cm}    Fetch From Left    ${PatientData.Height}    \ inches\
    ${height_cm}    Evaluate    round(${height_cm}*2.54,1)    #1in ~ 2.54cm
    Should Be Equal    ${TNoteData.Height}    ${height_cm} cm \(${PatientData.Height} \)    strip_spaces=True

Check Clinician In Header
    List Selection Should Be    ${tnote_header_clinician_select}
    ${check}    Get Text    ${tnote_header_clinician_text}
    Should Contain    ${check}    &nbsp

Check PO Details In Header
    Check Medication In Header
    Check Dose In Header
    Check Freq In Header
    Check Route In Header
    Check Primary Diagnosis In Header
    Check Service Type In Header
    Check Refer To Provider In Header

Check Medication In Header
    Should Be Equal    ${TNoteData.Medication}    ${AppointmentData.Medication}    strip_spaces=True

Check Dose In Header
    ${dose}    Fetch From Left    ${PO_data.Calculated_Dose}    \ mgs\
    ${weight}    Fetch From Left    ${PO_data.Weight}    \ kg\
    ${indexed_dose}    Evaluate    round(${dose}/${weight},2)
    ${indexed_dose}    Convert To String    ${indexed_dose}
    ${indexed_dose}    Remove String    ${indexed_dose}    \.0
    Should Be Equal As Strings    ${TNoteData.Dose}    ${indexed_dose} mg/kg \(${dose} mg\)    strip_spaces=True

Check Freq In Header
    Should Be Equal    ${TNoteData.Frequency}    \Every ${PO_data.Dose_Frequency}    strip_spaces=True

Check Route In Header
    Should Be Equal    ${TNoteData.Route}    ${PO_data.Route}    strip_spaces=True

Check Primary Diagnosis In Header
    Should Be Equal    ${TNoteData.DX_Code}    ${PO_data.DX_Code}    strip_spaces=True

Check Service Type In Header
    Should Be Equal    ${TNoteData.Service_Type}   ${PA_data.Medication_Type}    strip_spaces=True

Check Refer To Provider In Header
    ${first}    Get Regexp Matches    ${PO_data.Refer_To_Provider}    (?<=\, ).*(?=\ \\()
    ${last}    Get Regexp Matches    ${PO_data.Refer_To_Provider}    \.*(?=\,)
    Should Be Equal    ${TNoteData.Refer_To_Provider}    ${first}[0] ${last}[0]    strip_spaces=True

Check Last Treatment
    Check Info Of Last Treatment
    # Check Reason Of Last Treatment    #assessment
    Check Summary Table Of Last Treatment
    # Check Secondary Of Last Treatment    #meds fluids
    # Check Reaction Of Last Treatment    #proc. details
    # Check Post Discharge Of Last Treatment    #post d/c

Check Info Of Last Treatment
    Add Value To List    MEDICATION:    TREATMENT\ #:\    DATE:    TREATMENT DURATION:    xpath_arg=${tnote_last_tment_info_field}
    Add Value To Dict    Last_Medication    Last_TNote_Num    Last_DOS    Last_Duration
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Set Test Variable    ${TNoteData}
    # Check Medication Of Last Treatment    #Meds & Fluids
    # Check Regimen Of Last Treatment    #proc. details
    Check Num Of Last Treatment
    Check Date Of Last Treatment
    Check Duration Of Last Treatment
    Check Details Of Last Treatment
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${tnote_last_tment_back_btn}
    Wait Until Keyword Succeeds    5s    1s    Click Button    ${tnote_last_tment_back_btn}
    Util.Wait For Page Loading    element_arg=${tnote_tab_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
    Util.Wait For Page Loading    element_arg=${tnote_last_tment_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Check Medication Of Last Treatment
    Skip

Check Regimen Of Last Treatment
    Skip

Check Num Of Last Treatment
    Should Be Equal    ${TNoteData.Last_TNote_Num}    1    strip_spaces=True    #APT 1

Check Date Of Last Treatment
    ${time}    Subtract Date From Date    ${AppointmentData.DOS}    ${LastAppointmentData.DOS}    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${time}    Fetch From Left    ${time}    \ day\
    ${week}    Evaluate    ${time} // 7
    ${day}    Evaluate    ${time} % 7
    ${full_date}    Convert Date    ${LastAppointmentData.DOS}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${full_date}    Evaluate    "/".join(part.lstrip("0") for part in "${full_date}".split("/"))
    Should Be Equal    ${TNoteData.Last_DOS}    ${full_date} \(${week} wks ${day} days since last treatment\)    strip_spaces=True

Check Duration Of Last Treatment
    ${hr}    Evaluate    ${AppointmentData.APT_Duration} // 60
    ${min}    Evaluate    ${AppointmentData.APT_Duration} % 60
    Should Be Equal As Strings    ${TNoteData.Last_Duration}    ${hr} hrs ${min} mins    strip_spaces=True

Check Details Of Last Treatment
    Click Element    ${tnote_last_tment_link}
    Wait Until Element Is Visible    ${tnote_last_tment_water_mask}    30s
    Add Value To List    PATIENT:    MRN:    TREATMENT\ #:\    DATE OF SERVICE:    xpath_arg=${tnote_header_field_text}
    Add Value To Dict    Check_Patient    Check_MRN    Check_TNote_Num    Check_DOS
    Set To Dictionary    ${LastTNoteData}    &{dict_value}
    Should Be Equal    ${LastTNoteData.MRN}    ${LastTNoteData.Check_MRN}
    Should Be Equal    ${LastTNoteData.TNote_Num}    ${LastTNoteData.Check_TNote_Num}
    Should Be Equal    ${LastTNoteData.DOS}    ${LastTNoteData.Check_DOS}

Check Reason Of Last Treatment
    ${check}    Run Keyword And Return Status    Element Should Be Visible    ${tnote_last_tment_reason_text}
    IF    ${check} == ${False}
        Click Element    ${tnote_last_tment_collapse}
    END
    ${reason}    Get Text    ${tnote_last_tment_reason_text}

Check Summary Table Of Last Treatment
    Add Value To List    1    2    3    4    5    11    xpath_arg=${tnote_last_tment_table_row_text}
    Add Value To Dict    Last_Dose    Last_Weight    Last_Calc_Dose    Last_Actual_Dose    Last_Frequency    Last_Clinician
    Set To Dictionary    ${TNoteData}    &{dict_value}
    Set Test Variable    ${TNoteData}
    # Check Dose Of Last Treatment     #issue
    # Check Weight Of Last Treatment    #assessment
    Check Calc Dose Of Last Treatment
    Check Actual Dose Of Last Treatment
    Check Frequency Of Last Treatment
    Check Clinician Of Last Treatment

Check Dose Of Last Treatment
    ${dose}    Fetch From Left    ${LastTNoteData.Dose}   \ \(\
    Should Be Equal    ${TNoteData.Last_Dose}    ${dose}

Check Weight Of Last Treatment
    Skip

Check Calc Dose Of Last Treatment
    Should Be Equal    ${TNoteData.Last_Calc_Dose}    ${LastAppointmentData.Dosage} mg    

Check Actual Dose Of Last Treatment
    Should Be Equal    ${TNoteData.Last_Actual_Dose}    ${LastAppointmentData.Dispensed_Dose} mg

Check Frequency Of Last Treatment
    Should Be Equal    ${TNoteData.Last_Frequency}    ${LastTNoteData.Frequency}

Check Clinician Of Last Treatment
    Should Be Equal    ${TNoteData.Last_Clinician}    ${LastTNoteData.Clinician} R.N.

Check Secondary Of Last Treatment
    Skip

Check Reaction Of Last Treatment
    Skip

Check Post Discharge Of Last Treatment
    Skip

Add Value To List
    Check PO Details Collapsed
    [Arguments]    @{list_fields_arg}    ${xpath_arg}
    @{list_value}    Create List
    FOR    ${field_arg}    IN    @{list_fields_arg}
        ${xpath_check}    Set Variable    ${xpath_arg}
        Set Test Variable    ${field}    ${field_arg}
        ${xpath_check}    Util.Replace Xpath    xpath=${xpath_check}
        Wait Until Element Is Visible    ${xpath_check}    30s
        ${value}    Get Text    ${xpath_check}
        Append To List    ${list_value}    ${value}
    END
    Set Test Variable    ${list_value}

Add Value To Dict
    [Arguments]    @{list_key_arg}
    &{dict_value}    Create Dictionary
    FOR    ${key_arg}    IN    @{list_key_arg}
        Set To Dictionary    ${dict_value}    ${key_arg}=${list_value[0]}
        Remove From List    ${list_value}    0
    END
    Set Test Variable    ${dict_value}

Set Value To Field    #input or select
    [Arguments]    ${xpath_field_arg}    ${xpath_option_arg}    ${options_arg}    ${fields_arg}    ${values_arg}     ${fields_skipped_arg}    ${mess_arg}    ${xpath_modal_arg}    ${fields_other_arg}
    &{dict_value}    Create Dictionary
    Set Test Variable    ${field}    \*
    ${xpath_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
    ${elements}    Get WebElements    ${xpath_temp}
    ${num}    Get Length    ${elements}
    IF    "${options_arg}" != "None"
        ${list_option}    Set Variable    ${options_arg}
    END
    IF    "${xpath_field_arg}" == "${tnote_aces_admin_field}"    #special case - needed to select other options to test - only for Therapy - Access & Admin
        Set Test Variable    ${field}    2
        ${xpath_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
        ${options}    Wait Until Keyword Succeeds    10 times    3s    Get List Items    ${xpath_temp}
        ${is_empty}    Run Keyword And Return Status    Should Be Empty    ${options}
        FOR    ${i}    IN RANGE    10
            IF    ${is_empty} == ${False}
                BREAK
            END
            ${options}    Wait Until Keyword Succeeds    10 times    3s    Get List Items    ${xpath_temp}
            ${is_empty}    Run Keyword And Return Status    Should Be Empty    ${options}
        END
        Remove Values From List    ${options}    ${EMPTY}    Other
        ${selected}    Evaluate    random.choice(${options})
        Wait Until Keyword Succeeds    60s    1s    Select From List By Label    ${xpath_temp}    ${selected}
        Util.Wait For Page Loading    element_arg=${mess_arg}    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=60s
        Set To Dictionary    ${dict_value}    Therapy=${selected}
    END
    FOR    ${i}    IN RANGE    1    ${num+1}
        IF    "${i}" in ${fields_skipped_arg}
            CONTINUE
        END
        ${xpath_temp}    Set Variable    ${xpath_field_arg}
        Set Test Variable    ${field}    ${i}
        ${xpath_temp}    Util.Replace Xpath    xpath=${xpath_temp}
        IF    "${fields_other_arg}" != "None"
            IF    "${i}" in ${fields_other_arg}
                ${check}    Run Keyword And Return Status    Element Should Be Visible    ${xpath_temp}
                IF    ${check} == ${True}
                    ${option}    Evaluate    random.choice(${list_option})
                    Set Test Variable    ${option}
                    ${xpath_option_temp}    Util.Replace Xpath    xpath=${xpath_option_arg}
                    Scroll Element Into View    ${xpath_option_temp}
                    Wait Until Element Is Visible    ${xpath_option_temp}    60s
                    ${check_click}    Run Keyword And Return Status    Wait Until Keyword Succeeds    60s    1s    Click Element    ${xpath_option_temp}
                    IF    ${check_click} == ${False}
                        Sleep    5s
                        Wait Until Keyword Succeeds    60s    1s    Click Element    ${xpath_option_temp}
                    END
                ELSE
                    ${xpath_other}    Util.Replace Xpath    xpath=${xpath_other}    #this field in Post D/C only
                    ${value}    Get Text    ${xpath_other}
                    Set To Dictionary    ${TNoteData}    ${fields_arg[0]}=${value}
                END
                CONTINUE
            END
        END
        
        ${xpath_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
        ${tag}    Get Element Tag    xpath_arg=${xpath_temp}
        IF    "${tag}" == "input" or "${tag}" == "textarea"    #2 types of fields" input and select
            Scroll Element Into View    ${xpath_temp}
            Wait Until Element Is Visible    ${xpath_temp}    60s
            Wait Until Keyword Succeeds    6 times    10s    Click Element    ${xpath_temp}
            Wait Until Keyword Succeeds    6 times    10s    Input Text    ${xpath_temp}    ${values_arg[0]}
            Wait Until Keyword Succeeds    6 times    10s    Execute JavaScript  document.activeElement.blur()
            Set To Dictionary    ${dict_value}    ${fields_arg[0]}=${values_arg[0]}
            Remove From List    ${values_arg}    0
        ELSE IF    "${tag}" == "select"
            Util.Select Random From List    xpath_arg=${xpath_temp}    remove_default_arg=${True}
            IF    $selected == "\*Create New Value\*"
                Wait Until Element Is Visible    ${xpath_modal_arg}    60s
                Add New Option To Select List    xpath_arg=${xpath_modal_arg}    mess_arg=${mess_arg}    xpath_select_arg=${xpath_temp}
            ELSE
                No Operation
            END
            Set To Dictionary    ${dict_value}    ${fields_arg[0]}=${selected}
        ELSE
            ${option}    Evaluate    random.choice(${list_option})
            Set Test Variable    ${option}
            ${xpath_option_temp}    Util.Replace Xpath    xpath=${xpath_option_arg}
            Scroll Element Into View    ${xpath_option_temp}
            ${is_clickable}    Run Keyword And Return Status    Wait Until Keyword Succeeds    6 times    10s    Click Element    ${xpath_option_temp}
            Run Keyword If    ${is_clickable} == ${False}    Wait Until Keyword Succeeds    6 times    10s    Execute JavaScript    return document.evaluate("${xpath_option_temp}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
            Set To Dictionary    ${dict_value}    ${fields_arg[0]}=${option}
        END
        Util.Wait For Page Loading    element_arg=${mess_arg}    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=60s
        Remove From List    ${fields_arg}    0
    END
    Set Test Variable    ${dict_value}

Add New Option To Select List
    [Arguments]    ${xpath_arg}    ${mess_arg}    ${xpath_select_arg}
    Sleep    1s
    Wait Until Keyword Succeeds    10s    1s    Input Text    ${xpath_arg}    Test Type
    Wait Until Keyword Succeeds    10s    1s    Click Button    ${tnote_modal_save_btn}
    Sleep    1s
    ${check}    Run Keyword And Return Status    Page Should Contain    This item already exists
    IF    ${check} == ${True}
        Wait Until Page Does Not Contain    This item already exists    10s
        Close Submodal
        Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${xpath_select_arg}    Test Type
        Set Test Variable    ${selected}    Test Type
    END
    Util.Wait For Page Loading    element_arg=${mess_arg}    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s

Get Element Tag
    [Arguments]    ${xpath_arg}
    ${tag}    SeleniumLibrary.Get Element Attribute    ${xpath_arg}    tagName
    ${tag}    Convert To Lower Case    ${tag}
    RETURN    ${tag}
Select Option For Yes Or No
    [Arguments]    ${xpath_field_arg}    ${xpath_text_arg}    ${xpath_option_arg}    ${options_arg}    ${xpath_note_text_arg}    ${xpath_note_input_arg}    ${list_mess_arg}    ${is_mess_same_arg}    ${is_with_note}    ${column_arg}    ${fields_other_arg}
    &{dict_text}    Create Dictionary
    Set Test Variable    ${line}    \*
    Set Test Variable    ${column}    1
    ${xpath_field_arg}    Util.Replace Xpath    xpath=${xpath_field_arg}
    ${elements}    Get WebElements    ${xpath_field_arg}
    ${num}    Get Length    ${elements}
    ${list_option}    Get Dictionary Keys    ${options_arg}    sort_keys=False
    ${column_arg}    Evaluate    ${column_arg} + 1
    FOR    ${line}    IN RANGE    1    ${num+1}    #num of lines
        Set Test Variable    ${line}
        FOR    ${i}    IN RANGE    1    ${column_arg}
            Set Test Variable    ${column}    ${i}
            IF    "${fields_other_arg}" != "None" and "${line}" in ${fields_other_arg}
                ${check_note_visible}    Run Keyword And Return Status    Input Text    ${xpath_note_input_temp}    Test Note
            END
            ${xpath_field_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
            ${xpath_text_temp}    Util.Replace Xpath    xpath=${xpath_text_arg}
            ${is_field_visible}    Run Keyword And Return Status    Element Should Be Visible    ${xpath_field_temp}
            IF    ${is_field_visible} == ${False}
                Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${xpath_field_temp}
            END
            ${text}    Get Text    ${xpath_text_temp}
            Set Test Variable    ${is_disabled}    ${EMPTY}
            ${xpath_note_input_temp}    Util.Replace Xpath    xpath=${xpath_note_input_arg}
            ${check_note_visible}    Run Keyword And Return Status    Element Should Be Visible    ${xpath_note_input_temp}    Test Note
            IF    "${fields_other_arg}" != "None"
                IF    "${line}" in ${fields_other_arg}
                    Wait Until Keyword Succeeds    10s    1s    Input Text    ${xpath_note_input_temp}    Test Note
                    Set To Dictionary    ${dict_text}    ${text}=Test Note
                    CONTINUE
                END
            END
            ${option}    Evaluate    random.choice(${list_option})
            Set Test Variable    ${option}
            ${xpath_option_temp}    Util.Replace Xpath    xpath=${xpath_option_arg}
            Sleep    5s
            Scroll Element Into View    ${xpath_option_temp}
            ${is_click}    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${xpath_option_temp}
            Run Keyword If    ${is_click} == ${False}    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${xpath_option_temp}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
            Util.Wait For Page Loading    element_arg=${list_mess_arg}[0]    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
            IF    "${list_mess_arg[0]}" == "None"    #issue - message different
                No Operation
            ELSE
                Util.Wait For Page Loading    element_arg=${list_mess_arg}[0]    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
            END
            IF    ${is_mess_same_arg} == ${True}
                No Operation
            ELSE
                Remove From List    ${list_mess_arg}    0
            END
            IF    "${fields_other_arg}" != "None"
                IF    "${i}" in ${fields_other_arg} and ${check_note_visible} == ${False}
                    CONTINUE
                END
            END
            IF    ${is_with_note} == ${True}
                IF    "${xpath_note_text_arg}" == "None"
                    ${xpath_note_input_temp}    Util.Replace Xpath    xpath=${xpath_note_input_arg}
                    ${is_note_visible}    Run Keyword And Return Status    Input Text    ${xpath_note_input_temp}    Test Note
                    IF    ${is_note_visible} == ${False}
                        CONTINUE
                    END
                    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
                    Util.Wait For Page Loading    element_arg=${list_mess_arg}[0]    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
                    CONTINUE
                END
                ${xpath_note_text_temp}    Util.Replace Xpath    xpath=${xpath_note_text_arg}
                ${label}    Get Text    ${xpath_note_text_temp}
                ${label}    Get Regexp Matches    ${label}    (?<=If\ ).*(?=\, Describe:)
                IF    "${label}[0]" == "${options_arg.${option}}"
                    Set Test Variable    ${is_disabled}    ${attb_not_disabled}
                    ${xpath_note_input_temp}    Util.Replace Xpath    xpath=${xpath_note_input_arg}
                    Input Text    ${xpath_note_input_temp}    Test Note
                    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
                    Util.Wait For Page Loading    element_arg=${list_mess_arg}[0]    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
                ELSE
                    Set Test Variable    ${is_disabled}    ${attb_disabled}
                    ${xpath_note_input_temp}    Util.Replace Xpath    xpath=${xpath_note_input_arg}
                    Element Should Be Visible    ${xpath_note_input_temp}
                END
                ${text}    Evaluate    "${text}".title()
                Set To Dictionary    ${dict_text}    ${text}=${option} \(Text Note\)
            ELSE
                Set To Dictionary    ${dict_text}    ${text}=${option}
            END
        END
    END
    Set Test Variable    ${dict_text}

Select Option From List
    [Arguments]    ${xpath_field_arg}    ${xpath_text_arg}    ${xpath_option_arg}    ${xpath_note_arg}
    &{dict_text}    Create Dictionary
    Set Test Variable    ${line}    \*
    ${xpath_field_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
    ${elements}    Get WebElements    ${xpath_field_temp}
    ${num}    Get Length    ${elements}
    FOR    ${line}    IN RANGE    1    ${num+1}    #${num}: num of lines
        Set Test Variable    ${line}
        ${xpath_field_temp}    Util.Replace Xpath    xpath=${xpath_field_arg}
        ${xpath_text_temp}    Util.Replace Xpath    xpath=${xpath_text_arg}
        ${text}    Get Text    ${xpath_text_temp}
        ${xpath_option_temp}    Util.Replace Xpath    xpath=${xpath_option_arg}
        Util.Select Random From List    xpath_arg=${xpath_option_temp}    remove_default_arg=${True}
        Util.Wait For Page Loading    element_arg=Updated successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=30s
        ${xpath_note_temp}    Util.Replace Xpath    xpath=${xpath_note_arg}
        Input Text    ${xpath_note_temp}    Test Note
        Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
        Util.Wait For Page Loading    element_arg=Updated successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=30s
        ${option}    Set Variable    ${selected} \(Note: Test Note\)
        ${text}    Evaluate    "${text}".title()
        Set To Dictionary    ${dict_text}    ${text}=${option}
    END
    Set Test Variable    ${dict_text}

Add System To Review
    [Arguments]    ${xpath_add_arg}    ${xpath_view_arg}    ${xpath_field_arg}    ${xpath_option_arg}    ${options_arg}    ${xpath_note_arg}    ${category_arg}    ${desc_arg}    ${type_arg}    #type_arg: Review Systems or Exam
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${xpath_view_arg}
    Click Element    ${xpath_view_arg}
    ${option}    Evaluate    random.choice(${options_arg})
    Set Test Variable    ${option}
    Set Test Variable    ${category}    ${category_arg}
    Set Test Variable    ${desc}    ${desc_arg}
    ${xpath_field_arg}    Util.Replace Xpath    xpath=${xpath_field_arg}
    Set Test Variable    ${xpath_field_arg}
    ${xpath_option_arg}    Util.Replace Xpath    xpath=${xpath_option_arg}
    Sleep    1s
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${xpath_option_arg}
    Sleep    1s
    Click Element    ${xpath_option_arg}
    Util.Wait For Page Loading    element_arg=Updated successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=30s
    ${xpath_note_arg}    Util.Replace Xpath    xpath=${xpath_note_arg}
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${xpath_note_arg}
    Input Text    ${xpath_note_arg}   Test Note
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()
    Util.Wait For Page Loading    element_arg=Updated successfully    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=30s
    Set To Dictionary    ${TNoteData}    ${type_arg} - ${category} - ${desc}=${selected} \(Test Note\)
    Set Test Variable    ${TNoteData}