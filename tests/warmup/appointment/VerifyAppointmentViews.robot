*** Settings ***
Documentation      Verify Appointment Scheduled
Variables  ../../../resources/PageObjects/TestData/Testdata.py
Variables    ../../../resources/PageObjects/Locators/Appointment.py
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/Dispense.resource
Resource	../../../resources/PageObjects/Keywords/ReconcileDetail.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryReconcile.resource
Resource	../../../resources/PageObjects/Keywords/Order.resource
Resource   ../../../resources/PageObjects/Keywords/Appointment.resource
Resource    ../../../resources/PageObjects/Keywords/Patient.resource
Suite Setup    LoginKeywords.Login To Fusebox
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Default Tags    STG    Appointment
*** Test Cases ***
# Create Patient And Get Data To Verify
#     Maximize Browser Window
# 	Sleep    3s
#     Patient.Create Dictionary Of Patient Data
#     Patient.Go To Patients Page
#     Patient.Filter Location In Patients Page    Location_arg=${LocationInventory}     #QCA1
#     Patient.Check Patient In Patients Page    MRN_arg_1=01010    MRN_arg_2=09090    MRN_arg_3=08080    #MRN_arg_3 to be merged
#     Patient.Create Patient    First_Name_arg=Autotest    Last_Name_arg=Patient    DOB_arg=01/01/1974    Weight_arg=29.5    #weight: kgs
#     Patient.Check Patient Created
# ## 2 testing flows: APT Flow (Appointment branch) & Patient-APT Flow (Patient branch)
# Schedule Appointment And Get Data To Verify - Patient-APT Flow
#     # Maximize Browser Window
# 	# Sleep    3s
#     Appointment.Create Dictionary Of Appointment Data
#     Set Suite Variable    ${Office_Visit_Scheduled}    ${True}    #check IF Office Visit Scheduled along with Appointment OR not
#     Set Suite Variable    ${Office_Visit}    ${False}    #check IF Office Visit tested OR not
#     #Patient-APT Flow (PaApFlo)
#     LoginKeywords.Login To Fusebox
#     Maximize Browser Window
# 	Sleep    3s
#     #
#     Appointment.Schedule Appointment     Medication=Rituxan    Therapy=Rituxan Infusion    Dose=20    StartTime=7:05 am    Length=10    visit_starttime=7:10 am    visit_length=15    Location_arg=${LocationInventory}    #Therapy-Dose-Start Time-APT Duration    #Fasenra    #Fasenra Injection    #${APT_StartTime}    ${Visit_StartTime}    #${AppointmentData.Start_Time}
#     Log To Console    \n\nAppointment\n${AppointmentData}\n\nPatient\n${PatientData}\n
# # Verify Appointment In Ledger View - Tall View
#     [Documentation]   Verify Appointment - Ledger View
# 	...    TC:
# 	[Tags]    STG    Appointment
#     ...  report.label.owner:Vu Nguyen
#     ...  report.label.severity:normal
#     ...  report.label.epic:Appointment
#     ...  report.label.feature:Ledger View
#     ...  report.label.story:View Appointment
#     Set Test Variable    ${View}    Tall View
#     Appointment.Select Ledger View
#     Appointment.Check Tall View
#     ${date_time}    Get Current Date    result_format=%m/%d/%Y
#     Appointment.Filter Appointment    date_time=${date_time}    medication=${AppointmentData.Medication}    appointment_status=Requires Approval
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
#     Appointment.Get Appointment ID    Type=APT_ID
#     Appointment.Check Date Of Service Label
#     Appointment.Check Appointment Place    Place=${AppointmentData.Place}
#     Appointment.Check Appointment Status
#     # Appointment.Check Treatment Clinician    #Nurse to be set up next
#     Appointment.Check Patient
#     Appointment.Check DX Code
#     Appointment.Check Medication    Type=Appointment
#     # Appointment.Check Refer To Provider    
# Verify Appointment In Ledger View - Condensed View
#     Set Test Variable    ${View}    Condensed View
#     Appointment.Select Condensed View    #Check Condensed View
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
#     Appointment.Check Appointment ID    Check_ID=${AppointmentData.APT_ID}
#     Appointment.Check Date Of Service Label
#     Appointment.Check Appointment Place    Place=${AppointmentData.Place}
#     Appointment.Check Appointment Status
#     # Appointment.Check Treatment Clinician    #Nurse to be set up next
#     Appointment.Check Patient
#     Appointment.Check DX Code    
#     Appointment.Check Medication    Type=Appointment
# Verify Appointment In Calendar View
#     Appointment.Select Calendar View
#     Appointment.Check Number Of Places
#     # Check Calendar Table
#     Appointment.Check Time - Calendar    StartTime=${AppointmentData.Start_Time}    Place=${AppointmentData.Place}
#     Appointment.Check Name - Calendar
#     Appointment.Check DOB - Calendar
#     Appointment.Check Medication - Calendar    Type=Appointment
#     Appointment.Check Status - Calendar
#     # Check Popover Table when hovering mouse
#     Appointment.Check Location - Popover
#     Appointment.Check Date Of Service - Popover    Date=${AppointmentData.DOS}
#     Appointment.Check Patient - Popover
#     Appointment.Check DOB - Popover
#     Appointment.Check DX Code - Popover
#     Appointment.Check Description - Popover    Type=Appointment
#     Appointment.Check Dose - Popover
#     Appointment.Check UoM - Popover
# Verify Appointment In Check-In View
#     Set Test Variable    ${View}    Check-In View
#     Appointment.Select Check-In View
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Start_Time}
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.DOS}
#     Appointment.Check Appointment Status
#     Appointment.Check Location - Check-In
#     Appointment.Check Patient
#     Appointment.Check Medication    Type=Appointment
# # Verify OFFICE VISIT
# Verify Office Visit In Ledger View - Tall View
#     Check Office Visit Scheduled OR not
#     Set Test Variable    ${View}    Tall View
#     Appointment.Select Ledger View
#     Appointment.Check Tall View
#     Appointment.Filter Appointment    date_time=${AppointmentData.Visit_DOS}    medication=\-- No Medication Assigned / Empty --\    appointment_status=Requires Approval
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.Visit_DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Visit_Start_Time}
#     Appointment.Get Appointment ID    Type=Visit_ID
#     Appointment.Check Date Of Service Label
#     Appointment.Check Office Visit Mark
#     Appointment.Check Appointment Place    Place=${AppointmentData.Visit_Place}
#     Appointment.Check Appointment Status
#     # Appointment.Check Treatment Clinician    #Nurse to be set up next
#     Appointment.Check Patient
#     Appointment.Check DX Code
#     Appointment.Check Medication    Type=Visit
#     # Appointment.Check Refer To Provider
# Verify Office Visit In Ledger View - Condensed View
#     Check Office Visit Scheduled OR not
#     Set Test Variable    ${View}    Condensed View
#     Appointment.Select Condensed View    #Check Condensed View
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.Visit_DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Visit_Start_Time}
#     Appointment.Check Appointment ID    Check_ID=${AppointmentData.Visit_ID}
#     Appointment.Check Date Of Service Label
#     Appointment.Check Office Visit Mark
#     Appointment.Check Appointment Place    Place=${AppointmentData.Visit_Place}
#     Appointment.Check Appointment Status
#     # Appointment.Check Treatment Clinician    #Nurse to be set up next
#     Appointment.Check Patient
#     Appointment.Check DX Code    
#     Appointment.Check Medication    Type=Visit
# Verify Office Visit In Calendar View
#     Check Office Visit Scheduled OR not
#     Appointment.Select Calendar View
#     Appointment.Check Number Of Places
#     # Check Calendar Table
#     Appointment.Check Time - Calendar    StartTime=${AppointmentData.Visit_Start_Time}    Place=${AppointmentData.Visit_Place}
#     Appointment.Check Name - Calendar
#     Appointment.Check DOB - Calendar
#     Appointment.Check Medication - Calendar    Type=Visit
#     Appointment.Check Status - Calendar
#     # Check Popover Table when hovering mouse
#     Appointment.Check Location - Popover
#     Appointment.Check Date Of Service - Popover    Date=${AppointmentData.Visit_DOS}
#     Appointment.Check Patient - Popover
#     Appointment.Check DOB - Popover
#     Appointment.Check DX Code - Popover
#     Appointment.Check Description - Popover    Type=Visit
# Verify Office Visit In Check-In View
#     Check Office Visit Scheduled OR not
#     Set Test Variable    ${View}    Check-In View
#     Appointment.Select Check-In View
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.Visit_DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Visit_Start_Time}
#     Appointment.Check Appointment Status
#     Appointment.Check Location - Check-In
#     Appointment.Check Patient
#     Appointment.Check Medication    Type=Visit
# Verify Office Visit In Office Visit View
#     Check Office Visit Scheduled OR not
#     Set Test Variable    ${View}    Office Visit View
#     Log To Console    \n\nDICT 2: ${AppointmentData}\n
#     Appointment.Temp - Filter Office Visit    #issue STG
#     Wait Until Keyword Succeeds    10s    1s    Click Element    link:Search
#     Appointment.Select Office Visit View
#     Appointment.Check Date Of Service Row    Date=${AppointmentData.Visit_DOS}
#     Appointment.Scroll To Appointment - Check Time    StartTime=${AppointmentData.Visit_Start_Time}
#     Appointment.Check Appointment ID    Check_ID=${AppointmentData.Visit_ID}
#     Appointment.Check Date Of Service Label
#     Appointment.Check Office Visit Label
#     Appointment.Check Appointment Status
#     Appointment.Check Patient
#     Appointment.Check Provider - Office Visit
#     Appointment.Check Cancel Office Visit Selections