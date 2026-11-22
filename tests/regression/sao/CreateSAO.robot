*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Suite Setup    Suite Setup Scheduled Appointment Ordering
Test Setup    Test Setup Scheduled Appointment Ordering
Test Teardown    Common.Return Previous Window    window_arg=${original_window}[0]
Suite Teardown    Close Browser
Test Tags    test:retry(1)    SAO_REG    sao    Admin_SAO

*** Test Cases ***
Verify Navigation SAO From Scheduling Dispensing
    [Documentation]    SAO_REG_003    SAO_REG_022
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    Navigation SAO From Scheduling Dispensing
    Go To Scheduled Appointment Ordering
    Close Scheduled Appointments Popup

Verify Account Action On SAO Screen When Location Default Is Present
    [Documentation]    SAO_REG_001    SAO_REG_004    SAO_REG_005    SAO_REG_006    SAO_REG_007    SAO_REG_008    
    ...    SAO_REG_013a   SAO_REG_014    SAO_REG_019    SAO_REG_020    SAO_REG_021
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Verify Checkbox Is Checked and Disable By Default    ${data_input}[location_default]
    Verify Account Display Matching By Keyword Search    QC    ${data_input}[account_list]
    Verify Linked Account Are Display When Selected An Association     ${data_input}[association]    ${data_input}[account_list]
    Check Account Disable    ${data_input}[location]
    System Allows Searching And Selecting Or Unselecting Accounts Successfully    ${data_input}[location]
    Collapse Assigned Account Table
    Expand Assigned Account Table

Verify Account Unchecked When Has Last Order
    [Documentation]    SAO_REG_009    SAO_REG_015    SAO_REG_016    
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    # Check Auto Create Default Inventory Facility In Inventory Level    ${data_input}[location] (${data_input}[account_num])    Default Inventory
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Waiting For Loading
    Go To Scheduled Appointment Ordering
    Check Account Disable    ${data_input}[location]
    Choose SAO Account    ${data_input}[location]

Verify Account Action On SAO Screen When Location Default Is Not Present
    [Documentation]    SAO_REG_010    SAO_REG_011    SAO_REG_013    SAO_REG_053    SAO_REG_054    
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    Select All Account When Account Limit Is Empty
    Close Scheduled Appointments Popup
    Select All With Configured Account Limit    10
    Verify All Accounts Are Unselected When Clicking Unselect All Button
    Check Account Disable    ${data_input}[location_no_apt]
    Verify Can Not Create Order Without Required Data And Appointment    ${data_input}[location_no_apt]    ${appointment_no_therapy.apt_date}

Verify Order Type Selection Rules
    [Documentation]    SAO_REG_002    SAO_REG_023    SAO_REG_024    SAO_REG_025    SAO_REG_026    SAO_REG_027
    ...    SAO_REG_028    SAO_REG_029    SAO_REG_030    SAO_REG_032    SAO_REG_033    SAO_REG_040
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Verify Default Order Type Selection
    Verify Select Order Product By Date Range
    Verify Select Order Product Through End Date
    Verify No Stale Data After Switching
    
Verify Data Persistence When Switch Back
    [Documentation]    SAO_REG_034    SAO_REG_035    SAO_REG_036
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Verify Data Persistence Behavior

Verify Fix UnFulfilled Appointment Table When Schedule Appointment Without Therapy
    [Documentation]    SAO_REG_057    SAO_REG_061    SAO_REG_065    SAO_REG_067    SAO_REG_070    SAO_REG_071    SAO_REG_073
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Verify Note Format When Schedule Without Therapy    startdate_arg=${appointment_no_therapy.apt_date}    enddate_arg=${appointment_no_therapy.apt_date}
    Verify Action With Refresh Unfulfielled Appt
    Verify Data In Patient Column    ${patient_name_txt}    ${data_input}[patient_mrn]
    Table Reflects Correct Date Range    startdate_arg=${appointment_no_therapy.apt_date}    enddate_arg=${appointment_no_therapy.apt_date}

Verify Fix UnFulfilled Appointment Table
    [Documentation]    SAO_REG_037    SAO_REG_038    SAO_REG_039    SAO_REG_042    SAO_REG_058    SAO_REG_062    SAO_REG_064
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Check Account Disable    ${data_input}[location_no_apt]
    Verify Fix Unfulfilled Appointment Table When Its No Data    ${data_input}[location_no_apt]
    Verify Fix UnFulfilled Appointment Table When Data Is Present    ${data_input}[location_default]    ${data_input}[medication]

Verify Appointments Count Display Per Count
    [Documentation]    SAO_REG_072    SAO_REG_075    SAO_REG_076    SAO_REG_077
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Account Action On SAO Screen    ${data_input}[location]    ${appointment_no_dose.apt_date}
    Verify All Account Appointment Accounts

Verify Appointment Badge Color By Count
    [Documentation]    SAO_REG_078    SAO_REG_079
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Account Action On SAO Screen    ${data_input}[location]    ${appointment_no_therapy.apt_date}
    Verify Badge Color And Row Count For All Accounts
    
Verify Update And Cancel Appointment In SAO Screen
    [Documentation]    SAO_REG_080    SAO_REG_081    SAO_REG_082
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Account Action On SAO Screen    ${data_input}[location]    ${appointment_no_therapy.apt_date}
    Verify DX Code And Physician Updated    ${patient_name_txt}    ${data_input}[icd10_code]    ${data_input}[physician]
    Verify Cancel Appointment In SAO Screen

Verify Fix Unfulfilled Appointment Table When Appointment Has Service Type With Status Unassigned
    [Documentation]    SAO_REG_059    SAO_REG_063
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    Create Appointment With UnAssigned Service Type
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Verify Note Format When Appointment Unassigned    ${provider_dict.po_num}    ${appointment_unassigned_dict.apt_date}
    Close Scheduled Appointments Popup
    # Setup EMR Account    account_arg=${data_input}[location_default] (${data_input}[account_id])    emr_mapping_arg=Unknown Partner

Verify Table Shows Only Unfulfilled Appointment And MRN Format Is Correct
    [Documentation]    SAO_REG_066    SAO_REG_074
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     ${data_input}[location_default] (${data_input}[account_id])
    Go To Scheduled Appointment Ordering
    Account Action On SAO Screen    ${data_input}[location]    ${appointment_dict.apt_date}
    Verify Table Shows All Appointments Are Unfulfilled    account_arg=${data_input}[location_default]
    Verity All MRN Formats Are Valid    account_arg=${data_input}[location_default]

Verify Create Order For All Schedule Appointments
    [Documentation]    SAO_REG_044    SAO_E2E_001
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    Build Order For All Scheduled Appointments With Other Account
    ${po_num_order}    Submit Order Success
    Sleep    2s
    Verify Open Order History    ${data_input}[location] (${data_input}[account_num])    ${po_num_order}

Verify Create Order For Appointments With Status Approved
	[Documentation]    SAO_REG_045    SAO_REG_055    SAO_REG_056    SAO_E2E_002
	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
    Build Order For Approved Appointments With Other Account
    ${po_num_order}    Submit Order Success
    Sleep    5s
    Verify Open Order History    ${data_input}[location] (${data_input}[account_num])    ${po_num_order}

# Verify Default Inventory Auto Create Facility
#     [Documentation]    SAO_REG_068
# 	[Tags]    regression    Create SAO    report.label.owner: Nga Phan
#     Remove Default Inventory Facility In Inventory Level    ${data_input}[location] (${data_input}[account_num])    Default Inventory
#     Build Order For Approved Appointments With Other Account
#     Check Auto Create Default Inventory Facility In Inventory Level    ${data_input}[location] (${data_input}[account_num])    Default Inventory


*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

Suite Setup Scheduled Appointment Ordering
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Create Patient
    Get Patient Name Text
        ...    location_arg=${data_input}[location_default]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${PatientCreate_Order}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn_qca2]    
        ...    mrn_merge_arg=929292
        ...    refering_provider_arg=${data_input}[refering_provider]
    Set Suite Variable    ${PatientCreate_Order}
    Create Appointment
    Create Appointment Without Dose
    Create Appointment Without Therapy
    ${po_dict}    Approve PA
    ${original_window}    Get Window Handles
    Set Suite Variable    ${original_window}

Test Setup Scheduled Appointment Ordering
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    Test Setup Patient Management
        ...    title_arg=Appointment Ordering Ledger
        ...    location_arg=${data_input}[location_default]    
        ...    mrn_arg=${data_input}[patient_mrn]

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location_default]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[refering_provider]
    Set Suite Variable    ${PatientCreate}

Create Appointment
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location_default] (${data_input}[account_id])
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
    Set Suite Variable    ${appointment_dict}

Create Appointment Without Dose
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_no_dose}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location_default] (${data_input}[account_id])
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]   
        ...    dose_arg=0
    Set Suite Variable    ${appointment_no_dose}

Create Appointment Without Therapy
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_no_therapy}    ScheduleNewAppointment.Schedule Appointment Without Therapy
        ...    location_arg=${data_input}[location_default] (${data_input}[account_id])
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=Empty Therapy   
    Set Suite Variable    ${appointment_no_therapy}

Create Appointment With UnAssigned Service Type
    # Setup EMR Account
    # ...    account_arg=${data_input}[location_default] (${data_input}[account_id])
    # ...    emr_mapping_arg=${data_input}[emr_mapping]
    ProviderOrders.Go to Provider Orders
    ${provider_dict}    Create PO For SAO    
        ...    location_arg=${data_input}[location_default] (${data_input}[account_id])
        ...    mrn_arg=${data_input}[patient_mrn] 
        ...    drug_arg=${data_input}[medication]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[physician] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10

    Set Suite Variable    ${provider_dict}
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_unassigned_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location_default] (${data_input}[account_id])
        ...    patient_arg=${data_input}[patient_mrn]
        ...    po_number_arg=${provider_dict.po_num}
        ...    therapy_arg=${data_input}[medication]
        ...    dose_arg=10
    Set Suite Variable    ${appointment_unassigned_dict}
    
Setup EMR Account
    [Arguments]    ${account_arg}    ${emr_mapping_arg}
    EMRAccountSetup.Go To Emr Account Setup
    EMRAccountSetup.Select Current Account    ${account_arg}
    Waiting For Loading
    EMRAccountSetup.Select Emr Mapping    ${emr_mapping_arg}
    Wait Until Page Contains    EMR Settings Successfully Updated.    120s

Get Patient Name Text
    [Arguments]    ${mrn_arg}    ${location_arg}
    Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
    ${patient_name_txt}    PatientList.Get Patient Name    ${mrn_arg}
    Set Suite Variable    ${patient_name_txt}

Verify Build Order Window Is Visible
    Wait Until Keyword Succeeds    60s    1s    Switch Window    Build Order
    Wait Until Element Is Visible    //div[@id="OrderDetails"]    60s
    Close Window
    ${original_window}    Get Window Handles
    Switch Window    ${original_window}[1]

Submit Order Success
    Wait Until Keyword Succeeds    60s    1s    Switch Window    Build Order
    Sleep    2s
    Wait Until Element Is Visible    //div[@id="OrderDetails"]    120s
    ${po_num_order}    NewOrder.Get PO Number In Order
    Check Lock Account Num    ${data_input}[account_num]
    Sleep    3s
    NewOrder.Submit Order
    Wait Until Page Contains    Order History    120s
    RETURN    ${po_num_order}

Navigation SAO From Scheduling Dispensing
    Click Element    link:Home
    Waiting For Loading
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='AppointmentsButton']
    Title Should Be    Appointment Ordering Ledger

Verify Cancel Appointment In SAO Screen
    Scroll And Click Element    //*[@id='InnerAppointmentView']//following-sibling::a[contains(text(),'Cancel Appointment')]
    CancelAppointment.Cancel Appointment    Other    Testing
    Waiting For Loading
    Click Refresh Unfulfilled Button

Build Order For All Scheduled Appointments With Other Account
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_order_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location] (${data_input}[account_num])
        ...    patient_arg=${data_input}[patient_mrn_qca2]   
        ...    po_number_arg=${po_dict.po_num}
        ...    therapy_arg=${data_input}[medication]
        ...    dose_arg=10
    Set Suite Variable    ${appointment_order_dict}
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Waiting For Loading
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Go To Scheduled Appointment Ordering
    Check Account Disable    ${data_input}[location]
    Choose SAO Account    ${data_input}[location]
    Order Product By Date Range Are Displayed Correctly When Entering Date Range    ${appointment_order_dict.apt_date}    ${appointment_order_dict.apt_date}
    Click Create an Order for All Scheduled Appointments Button
    Click Build Order Button

Build Order For Approved Appointments With Other Account
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_approve_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location] (${data_input}[account_num])
        ...    patient_arg=${data_input}[patient_mrn_qca2]   
        ...    po_number_arg=${po_dict.po_num}
        ...    therapy_arg=${data_input}[medication]
        ...    dose_arg=10
    Set Suite Variable    ${appointment_approve_dict}
    AppointmentOrderingLedger.Filter Appointment In Ledger View    
        ...    status_arg=-- All Statuses --   
        ...    location_arg=${data_input}[location] (${data_input}[account_num])    
        ...    patient_mrn_arg=${data_input}[patient_mrn_qca2]        
        ...    apt_date_arg=${appointment_approve_dict.apt_date}
    Change Appointment Status With Button Approve Dosage And save Medication    ${appointment_approve_dict.apt_date}
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Waiting For Loading
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Go To Scheduled Appointment Ordering
    Check Account Disable    ${data_input}[location]
    Choose SAO Account    ${data_input}[location]
    Order Product By Date Range Are Displayed Correctly When Entering Date Range    
        ...    restock_product_startdate_value=${appointment_approve_dict.apt_date}    
        ...    restock_product_enddate_value=${appointment_approve_dict.apt_date}
    Click Create an Order for Approved Appointments Button
    Click Build Order Button

Change Appointment Status With Button Approve Dosage And save Medication
    [Arguments]    ${apt_date_arg}
    LedgerView.Open Appointment    ${apt_date_arg}
    Click Approve Dosage And Save Medication
    Common.Close Modal Popup

Check Lock Account Num
    [Arguments]    ${account_num_arg}
    ${account_num_btn}    Get WebElement    //a[contains(@class,'toggleAccountNumberEdit') and contains(@class,'unlock')]
    ${class_lock}    SeleniumLibrary.Get Element Attribute    ${account_num_btn}    class
    Return From Keyword If    'hidden' in '${class_lock}'
    Wait Until Keyword Succeeds    30s    1s    Click Element    id=SetDistibutorAccountNumberButton
    Sleep    2s
    Wait Until Element Is Enabled    //*[@id='modalDialogText']    60s
    Common.Clear Input Field Until Empty    //*[@id='modalDialogText']
    Wait Until Keyword Succeeds    30s    1s    Input Text    //*[@id='modalDialogText']    ${account_num_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='SaveBtn' and contains(text(),'Save')]

Navigation Accounts
    [Arguments]    ${prime_id_arg}
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    ${prime_id_arg}
    Accounts.Choose Account In Accounts Page     ${prime_id_arg}
    Accounts.Click Technical Button

Config Account Limit Is Empty
    Navigation Accounts     ${data_input}[prime_id]
    Clear Input Field Until Empty    ${technical_sao_account_limit}
    ${value}    SeleniumLibrary.Get Element Attribute    ${technical_sao_account_limit}    value
    Should Be Empty    ${value}
    Click Save Button In Edit Account Page

Select All Account When Account Limit Is Empty
    Config Account Limit Is Empty
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Waiting For Loading
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Go To Scheduled Appointment Ordering
    Verify Select All Behavior With More Than N Accounts    1

Select All With Configured Account Limit
    [Arguments]    ${quality_arg}
    Navigation Accounts     ${data_input}[prime_id]
    Accounts.Input SAO Account Limit    ${quality_arg}
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Waiting For Loading
    AppointmentOrderingLedger.Filter By Location     -- Select A Location --
    Go To Scheduled Appointment Ordering
    Verify Select All Behavior With More Than N Accounts    ${quality_arg}

Remove Default Inventory Facility In Inventory Level
    [Arguments]    ${location_arg}    ${inventory_name}
    InventoryLevels.Go To Inventory Level And Select Location And Facility    ${location_arg}    ${inventory_name}
    InventoryFacility.Click Edit Inventory
    Wait Until Element Is Visible    //a[contains(@onclick,'RemoveInventoryFacility')]    30s
    Click Element    //a[contains(@onclick,'RemoveInventoryFacility')]
    Wait Until Keyword Succeeds    30s    1s    Handle Alert And Return Its Text
    Wait Until Keyword Succeeds    30s    1s    Handle Alert And Return Its Text
  
Check Auto Create Default Inventory Facility In Inventory Level
    [Arguments]    ${location_arg}    ${inventory_name}
    Go To Inventory Levels
    InventoryFilter.Select Location    ${location_arg}
    ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    xpath=//a[text()='${inventory_name}' and @data-toggle='tab']

Verify Open Order History
    [Arguments]    ${location_arg}    ${po_num_arg}
    OrderHistory.Go To Order History
    OrderFilter.Filter By Location    ${location_arg}
    OrderFilter.Search For An Order ${po_num_arg}
    
Create PO For SAO
    [Arguments]    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${refer_arg}    ${refer_to_arg}    ${patient_weight_arg}    ${dosageAssignedValue_arg}
    ${provider_dict}    Create Provider Order Dictionary
    Click Create Provider Order
    Enter Provider Initial Informations    ${location_arg}    ${mrn_arg}    ${drug_arg}    ${provider_dict}
    Click Create Button
    Wait Until Element Is Visible    //form[@id="frm_CreateEditPatientOrderModal"]//div[@id="Phase2"]    30s
    Get PO Number    ${provider_dict}
    Get PO Dates    ${provider_dict}
    Input Referring    ${refer_arg}  
    ${refer_to_provider}    Select Refer To Provider    ${refer_to_arg}  
    Input Weight    ${patient_weight_arg}
    Click Radio Button    
    Select Route    ${provider_dict}
    Input Dose    ${dosageAssignedValue_arg}
    Select Frequency Value    ${provider_dict}
    Select Frequency Time    ${provider_dict}
    Click Save Provider Order
    ${check_msg}    Run Keyword And Return Status    Common.Page Alert Message    Provider Order Successfully Created!    5s
    IF    "${check_msg}" == "${False}"
        Check Advised
        Check Popup Confirm PA
        Common.Page Alert Message    Provider Order Successfully Created!    5s
    END
    Click Close Provider Order Popup
    Set To Dictionary    ${provider_dict}    refer_to_provider=${refer_to_provider}    
    RETURN    ${provider_dict}

Approve PA 
    ProviderOrders.Go to Provider Orders
    ${po_dict}    Create PO For SAO    
        ...    location_arg=${data_input}[location] (${data_input}[account_num])
        ...    mrn_arg=${data_input}[patient_mrn_qca2] 
        ...    drug_arg=${data_input}[medication]  
        ...    refer_arg=${data_input}[refering_provider]
        ...    refer_to_arg=${data_input}[physician] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10

    Set Suite Variable    ${po_dict}
    PriorAuthorizations.Go to Prior Authorization Page
    ${pa_dict}    Create Prior Authorizations Dictionary
    Filter PA Navigate Mrn    ${data_input}[location] (${data_input}[account_num])    ${data_input}[patient_mrn_qca2]
    Edit Prior Authorizations Successfully    
        ...    po_num=${po_dict.po_num}    
        ...    status=Approved
        ...    dict_arg=${pa_dict}    
        ...    type=Buy and Bill
    RETURN    ${po_dict}
    
