*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Ordering/Reports/Reports.resource
Resource    ../../../resources/PageObjects/Keywords/Dispensing/PriorAuthorizations/PriorAuthorizations.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/MyAccount/MyAccount.resource
Suite Setup    Suite Setup PA Report Suite
Test Setup    Test Setup PA Report Suite
Test Teardown    Test Teardown PA Report Suite
Suite Teardown    Close Browser
Test Tags    test:retry(2)    Admin    Regression    ordering    OD_PAR    report.label.owner: Hai Nguyen

*** Test Cases ***
Verify report displayed correctly column Blank Cell Standard
    [Documentation]    VEFUBX729 - 1    VEFUBX729 - 10 
    Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location_second]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[medication_second]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po]
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${medication_list}    Create List    ${data_input}[medication_second]
    ${account_list}    Create List    ${data_input}[location_second]
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization Start Date  
        ...    startdate=${provider_dict.start_date}   
        ...    enddate=${provider_dict.start_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}
        
    Verify report displayed correctly and match the design specifications when column Blank Cell Standard
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
        ...    Medication Name\n(Medication on PA)=${data_input}[medication_second]

Verify report displayed exactly following data input 
    [Documentation]    VEFUBX729 - 13    VEFUBX729 - 16    VEFUBX729 - 18    VEFUBX729 - 24    VEFUBX729 - 25    VEFUBX729 - 26    VEFUBX729 - 28  
    ${current_date}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=${data_input}[utc]
    Go to Reports
    Verify Report Displays Data Following Discontinued PA and Multi Medications    ${current_date}
    Remove PA Report File    ${download_path} 
    Reload Page
    Verify Report Displays Data Following All Medications    ${current_date}
    
Verify Prior Authorization Report Matches Design Specifications And Fusebox Data
    [Documentation]    VEFUBX729 - 3    VEFUBX729 - 4    VEFUBX729 - 5    VEFUBX729 - 6    VEFUBX729 - 7    VEFUBX729 - 8    VEFUBX729 - 9    VEFUBX729 - 12    VEFUBX729 - 14    VEFUBX729 - 17    VEFUBX729 - 19    VEFUBX729 - 23    VEFUBX729 - 26
                ...    VEFUBX729 - 29    VEFUBX729 - 30    VEFUBX729 - 31    VEFUBX729 - 32    VEFUBX729 - 33    VEFUBX729 - 34    VEFUBX729 - 35    VEFUBX729 - 36    VEFUBX729 - 37    VEFUBX729 - 38    VEFUBX729 - 39    VEFUBX729 - 40    VEFUBX729 - 41    
                ...    VEFUBX729 - 42    VEFUBX729 - 43    VEFUBX729 - 44    VEFUBX729 - 45    VEFUBX729 - 46    VEFUBX729 - 47    VEFUBX729 - 48    VEFUBX729 - 49    VEFUBX729 - 50    VEFUBX729 - 51    VEFUBX729 - 52    VEFUBX729 - 53
    Setup PA Data
    ${medication_list}    Create List    ${data_input}[medication_first]  
    ${account_list}    Create List    ${data_input}[location_second]  
    ${account_count}    Get Length    ${account_list}
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization End Date  
        ...    startdate=${pa_dict.end_date}   
        ...    enddate=${pa_dict.end_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}
    Verify report displayed correctly and match the design specifications at Cell A1 - A10
        ...    ${path}
        ...    ${download_datetime}
        ...    Prior Authorization / Next DOS ( As of ${download_datetime} )
        ...    Active Filters:
        ...    All Prior Authorizations: False
        ...    Discontinued Prior Authorizations: False
        ...    Date Range Type: By Prior Authorization End Date
        ...    Date Range From: ${pa_dict.end_date}
        ...    Date Range To: ${pa_dict.end_date}
        ...    Medications: ${medication_list}[0]
        ...    Locations: ${account_count}
        ...    ${None}
    Verify report displayed correctly and match the design specifications at Report Header    ${path}
    Verify the removed Appt Chair/Room Assignment column is no longer included in the report output    ${path}
    Verify report displayed correctly and match the design specifications at Table Header    ${path}
    Verify report displayed correctly and match the design specifications at Cell Alignment    
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
    Verify report displayed correctly and match the design specifications at Borders (Table Grid)    ${path}
    Verify The Report Display Data Following Fusebox Exactly    ${path}

Verify conditional formatting based on authorization status, dates, and visit utilization
    [Documentation]    VEFUBX729 - 55    VEFUBX729 - 56    VEFUBX729 - 57    VEFUBX729 - 58    VEFUBX729 - 59    VEFUBX729 - 60    VEFUBX729 - 61    VEFUBX729 - 62
    Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location_second]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[medication_third]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po]
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Set Test Variable    ${provider_dict}
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location_second]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[medication_third]  
        ...    dose_arg=10
        ...    po_number_arg=${provider_dict.po_num}
    Verify that the system applies conditional formating when Next appt DOS > Auth End date    apt_date=${appointment_dict.apt_date}
    Verify that the system applies conditional formating when Next appt DOS < Auth Start date    apt_date=${appointment_dict.apt_date}
    Verify that the system applies conditional formating when Auth status different, Approve, No Auth Re, SP Controls Auth    apt_date=${appointment_dict.apt_date}
    Verify that the system applies conditional formating when Used Visits > Approved Visits    apt_date=${appointment_dict.apt_date}
  
*** Keywords ***
Suite Setup PA Report Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Config Account
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location_second]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    Set Suite Variable    ${PatientCreate}
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location_second]    
        ...    mrn_arg=${data_input}[patient_mrn]
    
    ${download_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${download_path}

Test Setup PA Report Suite
    Remove PA Report File    ${download_path}  
    
Test Teardown PA Report Suite
    ${original_window}    Get Window Handles
    ${window_lenght}    Get Length    ${original_window}
    Run Keyword If    ${window_lenght} > 1    Common.Return Previous Window    window_arg=${original_window}[0]
    Reload Page
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location_second]    
        ...    mrn_arg=${data_input}[patient_mrn]

Config Account
    ${account_list}    Create List    ${data_input}[location_first]    ${data_input}[location_second]    ${data_input}[location_third]
    MyAccount.Go To My Account
    FOR    ${account}    IN    @{account_list}
        MyAccount.Viewing Account    ${account}
        MyAccount.Verify Utilize Report Queue Checkbox    status=uncheck
        MyAccount.Save Change
    END

Verify Report Displays Data Following Discontinued PA and Multi Medications
    [Arguments]    ${current_date}
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${medication_list}    Create List    ${data_input}[medication_first]    ${data_input}[medication_second]    ${data_input}[medication_third]    ${data_input}[medication_fouth]    ${data_input}[medication_fifth]
    ${account_list}    Create List    ${data_input}[location_second]    ${data_input}[location_third]
    ${account_count}    Get Length    ${account_list}
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization Start Date  
        ...    startdate=${current_date} 
        ...    enddate=${current_date} 
        ...    medication=${medication_list}      
        ...    account=${account_list}
        ...    discontinued_pa_click=${True}
    Sort List    ${medication_list}
    ${medication_list}    Evaluate    ",".join($medication_list)
    Verify report displayed correctly and match the design specifications at Cell A1 - A10
        ...    ${path}    
        ...    ${download_datetime}
        ...    Prior Authorization / Next DOS ( As of ${download_datetime} )
        ...    Active Filters:
        ...    All Prior Authorizations: False
        ...    Discontinued Prior Authorizations: True
        ...    Date Range Type: By Prior Authorization Start Date
        ...    Date Range From: ${current_date}  
        ...    Date Range To: ${current_date} 
        ...    Medications: ${medication_list}
        ...    Locations: ${account_count}
        ...    ${None}

Verify Report Displays Data Following All Medications
    [Arguments]    ${current_date}
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${account_list}    Create List    ${data_input}[location_second]
    ${account_count}    Get Length    ${account_list}
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization Entry Date  
        ...    startdate=${current_date}    
        ...    enddate=${current_date}  
        ...    medication=${None}  
        ...    account=${account_list}
    Verify report displayed correctly and match the design specifications at Cell A1 - A10
        ...    ${path}
        ...    ${download_datetime}
        ...    Prior Authorization / Next DOS ( As of ${download_datetime} )
        ...    Active Filters:
        ...    All Prior Authorizations: False
        ...    Discontinued Prior Authorizations: False
        ...    Date Range Type: By Prior Authorization Entry Date
        ...    Date Range From: ${current_date}   
        ...    Date Range To: ${current_date}  
        ...    Medications: All Medications
        ...    Locations: ${account_count}
        ...    ${None}

Setup PA Data
    Open Provider Orders Tab
    ${provider_dict}    ProviderOrders.Create PO Required Fields    
        ...    location_arg=${data_input}[location_second]
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[medication_first]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[referring_npi_po]
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
    Set Test Variable    ${provider_dict}
   
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit 
        ...    location_arg=${data_input}[location_second]   
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[medication_first]  
        ...    dose_arg=10
        ...    po_number_arg=${provider_dict.po_num}
    Set Test Variable    ${appointment_dict}
    
    Open Payer Information Tab
    ${primary_payer_dict}    PayerInformation.Create A New Medical Payer Plan    ${data_input}[utc]
    ${secondary_payer_dict}    PayerInformation.Create A New Medical Payer Plan    ${data_input}[utc]
    Set Test Variable    ${primary_payer_dict} 
    Set Test Variable    ${secondary_payer_dict} 

    ${pa_dict}    Create Prior Authorizations Dictionary
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    ${route_value}    Get Value    //input[@id="ModalRouteOfAdmin"]
    ${dose_value}    Get Value    //input[@id="ModalDoseFrequencyQty"]
    ${unit_value}    Get Text    //span[@id="UnitOfMeasureBaseUnits"]
    ${icdcode_value}    Get Text   //a[contains(@class,'assignICDButton')]
    Input Total Approved Visits In MDF    10
    ${status}    Evaluate    random.choice(${data_input}[accepted_status])
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Input Confirmation Number In PA Status and Confirmation    1234
    Input Start Date In PA Status and Confirmation    ${provider_dict.start_date}
    Input End Date In PA Status and Confirmation    ${provider_dict.exp_date}   
    Input Auth Entry Date In PA Status and Confirmation    ${provider_dict.entry_date} 
    Select PA Medication Type    ${pa_dict}    Buy and Bill
    # Add New Payer With Required Fields    payer_name_arg=PA_PayerTest    address_arg=address_test
    # Choose Payer In Payer Information and Margin Calculator    payer_name_arg=PA_PayerTest
    Choose Payer In Payer Information and Margin Calculator    payer_name_arg=${primary_payer_dict.plan_payer_name}
    Select Secondary Payer    ${secondary_payer_dict.plan_payer_name}
    Scroll Element Into View    //div[normalize-space()='Notes']//following-sibling::div[@id="CoPayPanelDiv"]
    ${random_txt}    Generate Random String    300    [LETTERS]
    Input Notes    ${random_txt}
    Click Add Note
    Priorauthorizations.Click Update Button
    Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Prior Authorization Successfully Updated!    5s
    IF    "${check_msg}" == "${False}"
        Add Medical Payer Plan
            ...    number_arg=123
            ...    date_arg=${provider_dict.start_date}
        Priorauthorizations.Click Update Button
        Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
        Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    END

    Click Edit Visits Used
    Input Visits Used In MDF    5
    Priorauthorizations.Click Update Button
    Run Keyword And Return Status    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    Common.Close Modal Popup

    Go to Prior Authorization Page   
    Filter PA Navigate Mrn    
        ...    location_arg=${data_input}[location_second]
        ...    mrn_arg=${data_input}[patient_mrn] 
    Select Assigned Specialist    ${pa_dict}    ${provider_dict.po_num}  

    Set To Dictionary    ${pa_dict}
        ...    dose=${dose_value}
        ...    unit=${unit_value}
        ...    route=${route_value}
        ...    medication_type=Buy and Bill
        ...    primary_icd10=${icdcode_value}
        ...    auth_status=${status}
        ...    entry_date=${provider_dict.entry_date} 
        ...    start_date=${provider_dict.start_date}
        ...    end_date=${provider_dict.exp_date} 
        ...    confirmation_number=1234
        ...    approve_visit=10
        ...    used_visit=5
        # ...    primary_payer=PA_PayerTest
        ...    note=${random_txt}

    Set Test Variable    ${pa_dict}

Verify The Report Display Data Following Fusebox Exactly
    [Arguments]    ${path}
    ${report_data}    Get Excel Data
        ...    ${path}
        ...    MRN\n(Patient MRN)=${data_input}[patient_mrn] 
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
    ${report_data}    Set Variable    ${report_data}[0]

    Should Be Equal    ${report_data}[Account Name\n(Location Long Name)]    ${data_input}[location_name_second] (${data_input}[account_id_second])
    Should Be Equal    ${report_data}[MRN\n(Patient MRN)]    ${data_input}[patient_mrn]
    Should Be Equal    ${report_data}[Last Name\n(Patient Last Name)]    ${PatientCreate.last_name}
    Should Be Equal    ${report_data}[First Name\n(Patient First Name)]    ${PatientCreate.first_name}
    ${dt}    Convert Date    ${PatientCreate.dob}    date_format=%m/%d/%Y    result_format=datetime
    ${dob_formatted}    Format Date No Padding    ${dt}    {m}/{d}/{y}
    Should Be Equal    ${report_data}[DOB\n(Patient DOB)]    ${dob_formatted}
    Should Be Equal    ${report_data}[Next Appt DOS\n(Next Sched Appt linked w/PA)]    ${appointment_dict.apt_date}
    Should Be Equal    ${report_data}[Appt Time\n(Next Sched Appt Time)]    ${appointment_dict.start_time}
    Should Be Equal    ${report_data}[Medication Name\n(Medication on PA)]    ${data_input}[medication_first]  
    Should Be Equal As Integers    ${report_data}[Dose\n(Dose on PA)]    ${pa_dict.dose}
    Should Be Equal    ${report_data}[UOM\n(UOM on PA)]    ${pa_dict.unit}
    Should Be Equal    ${report_data}[ROA\n(ROA on PA)]    ${pa_dict.route}
    Should Be Equal    ${report_data}[PA Medication Type\n(Medication Type on PA)]    ${pa_dict.medication_type}
    Should Contain    ${report_data}[Primary ICD10\n(Primary ICD10 on PA)]    ${pa_dict.primary_icd10}  
    Should Be Equal    ${report_data}[Auth Assigned Specialist\n(User Name Assigned to PA)]    ${pa_dict.assigned_specialist} 
    Should Be Equal    ${report_data}[Auth Status\n(Current Status of PA)]    ${pa_dict.auth_status} 

    ${entry_date_formatted}    Convert Date    ${pa_dict.entry_date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y

    Should Be Equal    ${report_data}[Auth Entry Date\n(Auth Entry Date on PA)]    ${entry_date_formatted} 

    ${start_date_formatted}    Convert Date    ${pa_dict.start_date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
    Should Be Equal    ${report_data}[Auth Start Date\n(Start Date on PA)]    ${start_date_formatted} 
    
    ${end_date_formatted}    Convert Date    ${pa_dict.end_date}    date_format=%m/%d/%Y    result_format=%m/%d/%Y
    Should Be Equal    ${report_data}[Auth End Date\n(End Date on PA)]    ${end_date_formatted} 
    
    ${date_left}    Subtract Date From Date    
        ...    ${report_data}[Auth End Date\n(End Date on PA)]    
        ...    ${report_data}[Next Appt DOS\n(Next Sched Appt linked w/PA)]
        ...    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    Should Be Equal    ${report_data}[Days Left\n(Days on PA by Next DOS)] days    ${date_left}     #Days Left = Auth End Date - Next Appt DOS 
    Should Be Equal    ${report_data}[Auth Confirmation\n(Confirmation # on PA)]    ${pa_dict.confirmation_number}  
    Should Be Equal As Integers    ${report_data}[Approved Visits\n(Approved Visits on PA)]    ${pa_dict.approve_visit}  
    Should Be Equal As Integers    ${report_data}[Used Visits\n(Used Visits on PA)]    ${pa_dict.used_visit}  
    Should Be Equal    ${report_data}[Primary Payer\n(Primary Payer Name Assigned to PA)]    ${primary_payer_dict.plan_payer_name}  
    Should Be Equal    ${report_data}[Auth Notes\n(Most Recent Note from PA Related Notes Section)]    ${pa_dict.note} 


Verify that the system applies conditional formating when Next appt DOS > Auth End date
    [Arguments]    ${apt_date}
    ${end_date}    Add Time To Date    ${apt_date}    -1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${pa_dict}    Create Prior Authorizations Dictionary
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    ${status}    Evaluate    random.choice(${data_input}[accepted_status])
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Select PA Medication Type    ${pa_dict}    Buy and Bill
    Input End Date In PA Status and Confirmation    ${end_date}   
    Priorauthorizations.Click Update Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    Common.Close Modal Popup

    ${medication_list}    Create List    ${data_input}[medication_third]  
    ${account_list}    Create List    ${data_input}[location_second]  
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization End Date  
        ...    startdate=${end_date}   
        ...    enddate=${end_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}

    ${formats}    Get Excel Display Format
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
        ...    Medication Name\n(Medication on PA)=${data_input}[medication_third]
   
    Should Be True    ${formats}[Auth End Date\n(End Date on PA)][bold]
    Should Be Equal    ${formats}[Auth End Date\n(End Date on PA)][fill_color]    \#FDE7E9\
    Should Be Equal    ${formats}[Auth End Date\n(End Date on PA)][font_color]    \#9C0006\
    FOR    ${key}    ${value}    IN    &{formats}
        Should Be Equal    ${value}[fill_color]    \#FDE7E9\
    END
    Remove PA Report File    ${download_path}  
    ${original_window}    Get Window Handles
    Common.Return Previous Window    window_arg=${original_window}[0]

Verify that the system applies conditional formating when Next appt DOS < Auth Start date
    [Arguments]    ${apt_date}
    ${start_date}    Add Time To Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${pa_dict}    Create Prior Authorizations Dictionary
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    ${status}    Evaluate    random.choice(${data_input}[accepted_status])
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Select PA Medication Type    ${pa_dict}    Buy and Bill
    Input Start Date In PA Status and Confirmation    ${start_date}
    Clear Element Text    ${pa_end_date_input}
    Priorauthorizations.Click Update Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    Common.Close Modal Popup

    ${medication_list}    Create List    ${data_input}[medication_third]  
    ${account_list}    Create List    ${data_input}[location_second]  
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization Start Date  
        ...    startdate=${start_date}   
        ...    enddate=${start_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}

    ${formats}    Get Excel Display Format
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
        ...    Medication Name\n(Medication on PA)=${data_input}[medication_third]

    Should Be True    ${formats}[Auth Start Date\n(Start Date on PA)][bold]
    Should Be Equal    ${formats}[Auth Start Date\n(Start Date on PA)][fill_color]    \#FDE7E9\
    Should Be Equal    ${formats}[Auth Start Date\n(Start Date on PA)][font_color]    \#9C0006\
    FOR    ${key}    ${value}    IN    &{formats}
        Should Be Equal    ${value}[fill_color]    \#FDE7E9\
    END
    Remove PA Report File    ${download_path}  
    ${original_window}    Get Window Handles
    Common.Return Previous Window    window_arg=${original_window}[0]

Verify that the system applies conditional formating when Used Visits > Approved Visits
    [Arguments]    ${apt_date}
    ${start_date}    Add Time To Date    ${apt_date}    -1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${pa_dict}    Create Prior Authorizations Dictionary
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    Input Total Approved Visits In MDF    10
    ${status}    Evaluate    random.choice(${data_input}[accepted_status])
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Select PA Medication Type    ${pa_dict}    Buy and Bill
    Click Edit Visits Used
    Input Visits Used In MDF    15
    Input Start Date In PA Status and Confirmation    ${start_date}
    Input End Date In PA Status and Confirmation    ${end_date}   
    Priorauthorizations.Click Update Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    Common.Close Modal Popup

    ${medication_list}    Create List    ${data_input}[medication_third]  
    ${account_list}    Create List    ${data_input}[location_second]  
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization End Date  
        ...    startdate=${end_date}   
        ...    enddate=${end_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}

    ${formats}    Get Excel Display Format
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
        ...    Medication Name\n(Medication on PA)=${data_input}[medication_third]

    Should Be True    ${formats}[Used Visits\n(Used Visits on PA)][bold]
    Should Be Equal    ${formats}[Used Visits\n(Used Visits on PA)][fill_color]    \#FDE7E9\
    Should Be Equal    ${formats}[Used Visits\n(Used Visits on PA)][font_color]    \#9C0006\
    FOR    ${key}    ${value}    IN    &{formats}
        Should Be Equal    ${value}[fill_color]    \#FDE7E9\
    END
    Remove PA Report File    ${download_path}  

Verify that the system applies conditional formating when Auth status different, Approve, No Auth Re, SP Controls Auth
    [Arguments]    ${apt_date}
    ${start_date}    Add Time To Date    ${apt_date}    -1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${apt_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${pa_dict}    Create Prior Authorizations Dictionary
    Open Prior Authorizations Tab
    Click Edit PA Button    ${provider_dict.po_num}
    Input Total Approved Visits In MDF    10
    Select Prior Auth Status In PA Status and Confirmation    Denied
    Select PA Medication Type    ${pa_dict}    Buy and Bill
    Input Start Date In PA Status and Confirmation    ${start_date}
    Input End Date In PA Status and Confirmation    ${end_date}   
    Priorauthorizations.Click Update Button
    Wait Until Keyword Succeeds    30s    1s    Click Button    //div[@id="SubModalPopup"]//button[text()='Accept']
    Common.Page Alert Message    Prior Authorization Successfully Updated!    30s
    Common.Close Modal Popup

    ${medication_list}    Create List    ${data_input}[medication_third]  
    ${account_list}    Create List    ${data_input}[location_second]  
    Go to Reports
    Comprehensive Excel Reports    report_generate=Patient    select_report=Prior Authorization / Next DOS
    ${download_datetime}    ${path}    Generate Report
        ...    download_path=${download_path}    
        ...    utc=${data_input}[utc] 
        ...    range_type=By Prior Authorization End Date  
        ...    startdate=${end_date}   
        ...    enddate=${end_date} 
        ...    medication=${medication_list}     
        ...    account=${account_list}

    ${formats}    Get Excel Display Format
        ...    ${path}
        ...    MRN\n(Patient MRN)=${PatientCreate.mrn}
        ...    Last Name\n(Patient Last Name)=${PatientCreate.last_name}
        ...    First Name\n(Patient First Name)=${PatientCreate.first_name}
        ...    Medication Name\n(Medication on PA)=${data_input}[medication_third]

    Should Be True    ${formats}[Auth Status\n(Current Status of PA)][bold]
    Should Be Equal    ${formats}[Auth Status\n(Current Status of PA)][fill_color]    \#FDE7E9\
    Should Be Equal    ${formats}[Auth Status\n(Current Status of PA)][font_color]    \#9C0006\
    FOR    ${key}    ${value}    IN    &{formats}
        Should Be Equal    ${value}[fill_color]    \#FDE7E9\
    END

    Remove PA Report File    ${download_path}  
    ${original_window}    Get Window Handles
    Common.Return Previous Window    window_arg=${original_window}[0]
