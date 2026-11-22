*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Scheduled Appointment Ordering
Test Setup    Test Setup Scheduled Appointment Ordering
Test Teardown    Common.Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Prime_physician    OD_SAO

*** Test Cases ***
Action With Account Section
	[Documentation]    SAO-1    SAO-2
	[Tags]    smoke    Scheduled Appointment Ordering    report.label.owner: Hai Nguyen
    Go To Scheduled Appointment Ordering
    System Allows Searching And Selecting Or Unselecting Accounts Successfully    ${data_input}[location]
    Collapse Assigned Account Table
    Expand Assigned Account Table
    Verify Assigned Account Table Shows All Accounts    ${data_input}[account_list]
    ${check_unlock_btn}    Run Keyword And Return Status    Page Should Contain Element    //a[contains(text(),"Unlock")]
    Run Keyword If    ${check_unlock_btn}    Click Element    //a[contains(text(),"Unlock")]
    Verify All Accounts Are Selected When Clicking Select All Button
    Verify All Accounts Are Unselected When Clicking Unselect All Button

Create Order For Appointments
	[Documentation]    SAO-3    SAO-5    SAO-6    SAO-7
	[Tags]    smoke    Scheduled Appointment Ordering    report.label.owner: Hai Nguyen
    Create Order For All Scheduled Appointment
    Create Order For Approved Appointment

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

Suite Setup Scheduled Appointment Ordering
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Create Patient
    Get Patient Name Text
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Create Appointment
    ${original_window}    Get Window Handles
    Set Suite Variable    ${original_window}

Test Setup Scheduled Appointment Ordering
    Test Setup Patient Management
        ...    title_arg=Appointment Ordering Ledger
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Sleep    10s
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]
    Set Suite Variable    ${PatientCreate}

Create Appointment
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location] (${data_input}[account_id])
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
    Set Suite Variable    ${appointment_dict}

Get Patient Name Text
    [Arguments]    ${mrn_arg}    ${location_arg}
    Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
    ${patient_name_txt}    PatientList.Get Patient Name    ${mrn_arg}
    Set Suite Variable    ${patient_name_txt}

Verify Build Order Window Is Visible
    Wait Until Keyword Succeeds    30s    1s    Switch Window    Build Order
    Wait Until Element Is Visible    //div[@id="OrderDetails"]    30s
    Close Window
    ${original_window}    Get Window Handles
    Switch Window    ${original_window}[1]
    
Create Order For All Scheduled Appointment
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Go To Scheduled Appointment Ordering
    Choose SAO Account    ${data_input}[location]
    Order Product Through End Date Are Displayed Correctly When Entering End Date    required_product_enddate_value=${appointment_dict.apt_date}
    Scheduled Appointment List Is Opened And Data Loads Successfully    
        ...    apt_date=${appointment_dict.apt_date}    
        ...    patient_name=${patient_name_txt} 
        ...    apt_status=Scheduled
    Click Create an Order for All Scheduled Appointments Button
    Click Build Order Button
    Verify Build Order Window Is Visible

Create Order For Approved Appointment
    AppointmentOrderingLedger.Filter Appointment In Ledger View    
        ...    status_arg=-- All Statuses --   
        ...    location_arg=${data_input}[location] (${data_input}[account_id])    
        ...    patient_mrn_arg=${data_input}[patient_mrn]       
        ...    apt_date_arg=${appointment_dict.apt_date}
    LedgerView.Change Appointment Status    
        ...    apt_datetime=${appointment_dict.apt_date}    
        ...    status_apt_arg=Approved
    Go To Scheduled Appointment Ordering
    Order Product By Date Range Are Displayed Correctly When Entering Date Range    
        ...    restock_product_startdate_value=${appointment_dict.apt_date}    
        ...    restock_product_enddate_value=${appointment_dict.apt_date}
    Scheduled Appointment List Is Opened And Data Loads Successfully
        ...    apt_date=${appointment_dict.apt_date}    
        ...    patient_name=${patient_name_txt}
        ...    apt_status=Approved
    Click Create an Order for Approved Appointments Button
    Click Build Order Button
    Verify Build Order Window Is Visible