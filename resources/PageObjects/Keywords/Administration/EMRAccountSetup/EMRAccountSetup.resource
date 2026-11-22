*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py

*** Variables ***
# EMR Tools / Settings
${emr_tools_title}    //h3[text()='EMR Tools / Settings']
${current_account_select}    //select[@id="CurrentAccount"]
${emr_mapping_select}    //select[@id="EMRMapping"]
${analyzerIdentifier_input}    //input[@id="AnalyzerIdentifier"]
${prevent_creating_editing_patients_checkbox}    //input[@id="PreventCreatingEditingPatientsCheckbox"]
${prevent_payer_creation_checkbox}    //input[@id="PreventPayerCreationCheckbox"]
${prevent_scheduling_checkbox}    //input[@id="PreventSchedulingCheckbox"]
${disable_calendar_view_checkbox}    //input[@id="DisableCalendarViewCheckbox"]

# Medication Type
${medication_type_tab}    //a[@id="MedicationConversions"]
${medication_type_title}    //h3[text()='Adjust EMR Medication Mappings']
${emr_proprietary_name_input}    //input[@id="NewEMRPropName"]
${system_proprietary_name_select}    //select[@id="NewSystemPropName"]
${calendar_banner_color_input}    //input[@id="NewCalendarMedColor"]
${banner_text_color_input}    //input[@id="NewCalenderTextColor"]
${medication_type_tools_add_btn}    //a[contains(@onclick,"CreateUpdateEMRMedicationMapping")]//i[@class="fa fa-plus-circle"]
${medication_type_tools_remove_btn}    //a[contains(@onclick,"RemoveEMRMedicationMapping")]//i[@class="fa fa-trash"]

# Event Type
${event_type_tab}    //a[@id="EventType"]
${event_type_title}    //h3[text()='Adjust EMR Event Type Mappings']
${emr_event_code_input}    //input[@id="NewEMREventCode"]
${emr_description_input}    //input[@id="NewEventDescription"]
${related_medication_select}    //select[@id="NewRelatedMedication"]
${category_select}    //select[@id="NewEventTypeCategory"]
${first_only_checkbox}    //input[@id="NewFirstOnlyCheckbox"]
${hidden_checkbox}    //input[@id="NewHiddenMappingCheckbox"]
${event_type_tools_add_btn}    //a[contains(@onclick,"CreateUpdateEMREventTypeMapper")]//i[@class="fa fa-plus-circle"]

# Location Type
${location_type_tab}    //a[@id="LocationDescription"]
${location_type_title}    //h3[text()='Adjust Location Descriptions']
${default_location_name_input}    //input[@id="NewDefaultLocationName"]
${default_location_count_select}    //select[@id="NewLocationCount"]
${location_type_tools_update_location_btn}    //a[@id="UpdateLocationDescriptionBtn"]

# Employee Scheduling
${employee_scheduling_tab}    //a[@id="EmployeeScheduling"]
${employee_scheduling_title}    //h3[text()='Employee Scheduling']
${max_number_of_nurses_select}    //select[@id="MaxNumberOfNurses"]
${max_number_of_appts_per_day_select}    //select[@id="MaxNumberOfAppointmentsPerDay"]
${max_appt_starts_per_hour_select}    //select[@id="MaxNumberOfAppointmentStartsPerHour"]

# EMR Cancelation Codes
${emr_cancelation_codes_tab}    //a[@id="EmrCancelationCode"]
${emr_cancelation_codes_title}    //h3[text()='Manage EMR Cancelation Codes']
${emr_cancelation_code_input}    //input[@id="NewEmrCancelationCode"]
${emr_cacelation_codes_tools_create_btn}    //span[@id="CreateNewEmrCancelationCode"]
${emr_cacelation_codes_tools_create_btn}    //span[@id="CreateNewEmrCancelationCode"]

*** Keywords ***
# EMR Tools / Settings
Go To Emr Account Setup
    Common.Scroll And Click Element    link: Administration
    Common.Scroll And Click Element    link: EMR Account Setup
    Wait Until Element Is Visible    ${emr_tools_title}    30s

Select Current Account
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${current_account_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${current_account_select}    ${location_arg}

Select Emr Mapping
    [Arguments]    ${emr_mapping_arg}
    Wait Until Element Is Enabled    ${emr_mapping_select}  30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${emr_mapping_select}    ${emr_mapping_arg}
    Run Keyword And Return Status  Common.Page Alert Message    EMR Settings Successfully Updated.    10s

Input Emr Account Id 
    [Arguments]    ${account_id_arg}
    Wait Until Element Is Visible    ${analyzerIdentifier_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${analyzerIdentifier_input}    ${account_id_arg}
    Press Keys    None    TAB
    Run Keyword And Return Status  Common.Page Alert Message    EMR Settings Successfully Updated.    10s

Tick Prevent Creating Or Editing of Patients
    Wait Until Element Is Visible    ${prevent_creating_editing_patients_checkbox}    30s
    Common.Scroll And Click Element    ${prevent_creating_editing_patients_checkbox}

Tick Prevent Payer Creation Or Assignment
    Wait Until Element Is Visible    ${prevent_payer_creation_checkbox}    30s
    Common.Scroll And Click Element    ${prevent_payer_creation_checkbox}

Tick Prevent Scheduling of Appointments
    Wait Until Element Is Visible    ${prevent_scheduling_checkbox}    30s
    Common.Scroll And Click Element    ${prevent_scheduling_checkbox}

Tick Disable Calendar View
    Wait Until Element Is Visible    ${disable_calendar_view_checkbox}    30s
    Common.Scroll And Click Element    ${disable_calendar_view_checkbox}

# Medication Type
Open Medication Type Tab
    Common.Scroll And Click Element    ${medication_type_tab}
    Wait Until Element Is Visible    ${medication_type_title}    30s

Input Emr Proprietary Name
    [Arguments]    ${proprietary_name_arg}
    Wait Until Element Is Visible    ${emr_proprietary_name_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_proprietary_name_input}    ${proprietary_name_arg}

Select System Proprietary Name
    [Arguments]    ${medication_arg}
    Wait Until Element Is Enabled    ${system_proprietary_name_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${system_proprietary_name_select}    ${medication_arg}

Input Calendar Banner Color
    [Arguments]    ${calendar_color_arg}
    Wait Until Element Is Visible    ${calendar_banner_color_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${calendar_banner_color_input}    ${calendar_color_arg}

Input Banner Text Color
    [Arguments]    ${text_color_arg}
    Wait Until Element Is Visible    ${banner_text_color_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${banner_text_color_input}    ${text_color_arg}

Click Create Emr Medication Mapping Button
    Wait Until Element Is Visible    ${medication_type_tools_add_btn}    30s
    Common.Scroll And Click Element    ${medication_type_tools_add_btn}

Click Remove Emr Medication Mapping Button
    Wait Until Element Is Visible    ${medication_type_tools_remove_btn}    30s
    Common.Scroll And Click Element    ${medication_type_tools_remove_btn}

# Event Type
Open Event Type Tab
    Common.Scroll And Click Element    ${event_type_tab}
    Wait Until Element Is Visible    ${event_type_title}    30s

Input Emr Event Code
    [Arguments]    ${code_arg}
    Wait Until Element Is Visible    ${emr_event_code_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_event_code_input}    ${code_arg}

Input Event Description
    [Arguments]    ${description_arg}
    Wait Until Element Is Visible    ${emr_description_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_description_input}    ${description_arg}

Select Related Medication
    [Arguments]    ${medication_arg}
    Wait Until Element Is Enabled    ${related_medication_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${related_medication_select}    ${medication_arg}

Select A Category
    [Arguments]    ${category_arg}
    Wait Until Element Is Enabled    ${category_select} 
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${category_select}    ${category_arg}

Click Emr Event Type Mapper Button
    Wait Until Element Is Visible    ${event_type_tools_add_btn}    30s
    Common.Scroll And Click Element    ${event_type_tools_add_btn}

# Location Type
Open Location Type Tab
    Common.Scroll And Click Element    ${location_type_tab}
    Wait Until Element Is Visible    ${location_type_title}    30s

Input Default Location Name
    [Arguments]    ${location_name_arg}
    Wait Until Element Is Visible    ${default_location_name_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${default_location_name_input}    ${location_name_arg}

Select Default Location Count
    [Arguments]    ${count_arg}
    Wait Until Element Is Enabled    ${default_location_count_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${default_location_count_select}    ${count_arg}

Input EMR Location Category
    [Arguments]    ${location_name_arg}    ${category_arg}
    ${emr_location_category_input}    Set Variable    (//input[@value="${location_name_arg} 1"]//following::input[@id="EMRLocationCategory"])[1]
    Wait Until Element Is Visible    ${emr_location_category_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_location_category_input}    ${category_arg}

Input EMR Location Description
    [Arguments]    ${location_name_arg}    ${description_arg}
    ${emr_location_description_input}    Set Variable    (//input[@value="${location_name_arg} 1"]//following::input[@id="EMRLocationDescription"])[1]
    Wait Until Element Is Enabled    ${emr_location_description_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_location_description_input}    ${description_arg}

Click Update Location Description Button
    [Arguments]    ${location_name_arg}
    ${update_location_btn}    Set Variable    (//input[@value="${location_name_arg} 1"]//following::a[contains(@onclick,"UpdateEMRLocationDescription")])[1]
    Wait Until Element Is Visible    ${update_location_btn}    30s
    Common.Scroll And Click Element    ${update_location_btn}

# Employee Scheduling
Open Employee Scheduling Tab
    Common.Scroll And Click Element    ${employee_scheduling_tab}
    Wait Until Element Is Visible    ${employee_scheduling_title}    30s

Select Max Number Of Nurses
    [Arguments]    ${number_arg}
    Wait Until Element Is Enabled    ${max_number_of_nurses_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${max_number_of_nurses_select}    ${number_arg}

Select Max Number Of Appts Per Day
    [Arguments]    ${number_arg}
    Wait Until Element Is Enabled    ${max_number_of_appts_per_day_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${max_number_of_appts_per_day_select}    ${number_arg}

Select Max Appt Starts Per Hour
    [Arguments]    ${number_arg}
    Wait Until Element Is Enabled    ${max_appt_starts_per_hour_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${max_appt_starts_per_hour_select}    ${number_arg}

Input Max Number Of Appts Per Day
    [Arguments]    ${number_arg}    ${max_range}
    ${max_number_of_appts_per_day_input}    Set Variable    //input[@id="ApptsPerDay-${number_arg}"]
    Wait Until Element Is Visible    ${max_number_of_appts_per_day_input}    30s
    ${appts_per_day_value}    Get Element Attribute    ${max_number_of_appts_per_day_input}    value
    ${new_value}    Set Variable    ${appts_per_day_value}
    WHILE    '${new_value}' == '${appts_per_day_value}'
        ${new_value}    Evaluate    random.choice(range(1, ${max_range}+1))
    END
    Clear Element Text    ${max_number_of_appts_per_day_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${max_number_of_appts_per_day_input}    ${new_value} 

Input Max Appt Starts Per Hour
    [Arguments]    ${number_arg}    ${max_range}
    ${max_appt_starts_per_hour_input}    Set Variable    //input[@id="ApptStartPerHour-${number_arg}"]
    Wait Until Element Is Visible    ${max_appt_starts_per_hour_input}    30s
    ${number_per_value}    Get Element Attribute    ${max_appt_starts_per_hour_input}    value
    ${new_value}    Set Variable    ${number_per_value}
    WHILE    '${new_value}' == '${number_per_value}'
        ${new_value}    Evaluate    random.choice(range(1, ${max_range}+1))
    END
    Clear Element Text    ${max_appt_starts_per_hour_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${max_appt_starts_per_hour_input}    ${new_value} 

Click Update Nurse Scheduling Button
    [Arguments]    ${number_arg}
    ${update_scheduling_btn}    Set Variable   //span[@data-number-of-nurses="${number_arg}"]
    Wait Until Element Is Enabled    ${update_scheduling_btn}    30s
    Common.Scroll And Click Element    ${update_scheduling_btn}

# EMR Cancelation Codes
Open EMR Cancelation Codes Tab
    Common.Scroll And Click Element    ${emr_cancelation_codes_tab}
    Wait Until Element Is Visible    ${emr_cancelation_codes_title}    30s

Input EMR Cancelation Code
    [Arguments]    ${code_arg}
    Wait Until Element Is Enabled    ${emr_cancelation_code_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${emr_cancelation_code_input}    ${code_arg}

Click Create New Emr Cancelation Code Button
    Wait Until Element Is Visible    ${emr_cacelation_codes_tools_create_btn}    30s
    Common.Scroll And Click Element    ${emr_cacelation_codes_tools_create_btn}

Click Update Emr Cancelation Code Button
    [Arguments]    ${code_arg}
    ${update_emr_cancelation_code_btn}    Set Variable    (//input[@value="${code_arg}"]//following::span[contains(@class,'updateEmrCancelationCodeBtn')])[1]
    Wait Until Element Is Visible    ${update_emr_cancelation_code_btn}    30s
    Common.Scroll And Click Element    ${update_emr_cancelation_code_btn}

Click Confirm Update Emr Cancelation Code Button
    [Arguments]    ${code_arg}
    ${confirm_update_emr_cancelation_code_btn}    Set Variable    (//input[@value="${code_arg}"]//following::span[contains(@class,'confirmUpdateEmrCancelationCodeBtn')])[1]
    Wait Until Element Is Visible    ${confirm_update_emr_cancelation_code_btn}    30s
    Common.Scroll And Click Element    ${confirm_update_emr_cancelation_code_btn}

Click Delete Emr Cancelation Code Button
    [Arguments]    ${code_arg}
    ${delete_emr_cancelation_code_btn}    Set Variable    (//input[@value="${code_arg}"]//following::span[contains(@class,'deleteEmrCancelationCodeBtn')])[1]
    Wait Until Element Is Visible    ${delete_emr_cancelation_code_btn}    30s
    Common.Scroll And Click Element    ${delete_emr_cancelation_code_btn}

Verify EMR Tools / Settings Displays All Configuration Sections
    Wait Until Element Is Visible    ${prevent_creating_editing_patients_checkbox}    30s
    Wait Until Element Is Visible    ${prevent_payer_creation_checkbox}    30s
    Wait Until Element Is Visible    ${prevent_scheduling_checkbox}    30s
    Wait Until Element Is Visible    ${disable_calendar_view_checkbox}    30s

Set Configs For Emr Tools
    [Arguments]    ${location_arg}    ${emr_mapping_arg}    ${account_id_arg}
    Select Current Account    ${location_arg}
    Select Emr Mapping    ${emr_mapping_arg}
    Input Emr Account Id     ${account_id_arg}

Create Emr Medication Mapper
    [Arguments]    ${proprietary_name_arg}    ${medication_arg}    ${calendar_color_arg}    ${text_color_arg}
    Input Emr Proprietary Name    ${proprietary_name_arg}
    Select System Proprietary Name    ${medication_arg}
    Input Calendar Banner Color    ${calendar_color_arg}
    Input Banner Text Color    ${text_color_arg}
    Click Create Emr Medication Mapping Button
    Common.Page Alert Message    EMR Medication Mapper Successfully Added.

Remove Emr Medication Mapper
    [Arguments]    ${proprietary_name_arg}
    ${remove_btn}    Set Variable    (//input[@value="${proprietary_name_arg}"]//following::a[contains(@onclick,"RemoveEMRMedicationMapping")]//i[@class="fa fa-trash"])[1]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove_btn}
    Alert Should Be Present    Are you sure you would like to remove the medication mapping for ${proprietary_name_arg}?    ACCEPT    5s
    Common.Page Alert Message    EMR Medication Mapper Successfully Deleted.

Create Emr Event Type
    [Arguments]    ${code_arg}    ${description_arg}    ${medication_arg}    ${category_arg}
    Input Emr Event Code    ${code_arg}
    Input Event Description    ${description_arg}
    Select Related Medication    ${medication_arg}
    Select A Category    ${category_arg}
    Click Emr Event Type Mapper Button
    Common.Page Alert Message    EMR Event Type Successfully Added.

Remove Emr Event Type
    [Arguments]    ${code_arg}
    ${remove_btn}    Set Variable    (//input[@value="${code_arg}"]//following::a[contains(@onclick,"RemoveEMREventTypeMapper")]//i[@class="fa fa-trash"])[1]
    Common.Scroll And Click Element    ${remove_btn}
    Alert Should Be Present    Are you sure you would like to remove the event mapping for ${code_arg}?    ACCEPT    5s
    Common.Page Alert Message    EMR Event Type Successfully Deleted

Filter Adjust Location Descriptions Options
    [Arguments]    ${location_name_arg}    ${count_arg}
    Input Default Location Name    ${location_name_arg}
    Select Default Location Count    ${count_arg}

Update Location Description
    [Arguments]    ${location_name_arg}    ${category_arg}    ${description_arg}
    Input EMR Location Category    ${location_name_arg}    ${category_arg}
    Input EMR Location Description    ${location_name_arg}    ${description_arg}
    Click Update Location Description Button    ${location_name_arg}
    Common.Page Alert Message    Location Description Successfully Updated.

Clear Location Description
    [Arguments]    ${location_name_arg}    ${category_arg}    ${description_arg}
    Input EMR Location Category    ${location_name_arg}    ${category_arg}
    Input EMR Location Description    ${location_name_arg}    ${description_arg}
    Click Update Location Description Button    ${location_name_arg}
    Common.Page Alert Message    Location Description Successfully Updated.

Filter Employee Scheduling Options
    [Arguments]    ${number_arg}
    Select Max Number Of Nurses    ${number_arg}
    Select Max Number Of Appts Per Day    ${number_arg}
    Select Max Appt Starts Per Hour    ${number_arg}

Update Nurse Scheduling
    [Arguments]    ${number_arg}    ${max_range}
    Input Max Number Of Appts Per Day    ${number_arg}    ${max_range}
    Input Max Appt Starts Per Hour    ${number_arg}    ${max_range}
    Click Update Nurse Scheduling Button    ${number_arg}
    Common.Page Alert Message    Employee Scheduling Successfully Updated.

Create EMR Cancelation Code
    [Arguments]    ${code_arg}
    Input EMR Cancelation Code    ${code_arg}
    Click Create New Emr Cancelation Code Button
    Common.Page Alert Message    EMR Cancelation Code added.

Update EMR Cancelation Code
    [Arguments]    ${code_arg}    ${new_code_value_arg}
    Click Update Emr Cancelation Code Button    ${code_arg} 
    ${update_emr_cancelation_code_input}    Set Variable    //input[@value="${code_arg}"]
    Wait Until Element Is Enabled    ${update_emr_cancelation_code_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${update_emr_cancelation_code_input}    ${new_code_value_arg}
    Click Confirm Update Emr Cancelation Code Button    ${code_arg} 
    Common.Page Alert Message    EMR Cancelation Code updated.

Delete EMR Cancelation Code
    [Arguments]    ${code_arg}
    Click Delete Emr Cancelation Code Button    ${code_arg}
    Alert Should Be Present    Are you sure you would like to remove this EMR Cancelation Code? This action cannot be undone!    ACCEPT    5s
    Common.Page Alert Message    EMR Cancelation Code '${code_arg}' deleted.