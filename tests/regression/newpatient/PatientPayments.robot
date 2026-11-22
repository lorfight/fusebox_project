*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Patient Payments Suite
Test Setup    Test Setup Patient Payments Suite
Test Teardown    Common.Return Previous Window    window_arg=${update_patient_window}
Suite Teardown    Close Browser
Test Tags    test:retry(1)    PaMan_012    patient    Admin

*** Test Cases ***
Verify That The "Current Balance" Field Is A Non-Editable Textbox
    [Documentation]    PP-1    PP-2    PP-3    PP-4
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Update "Current Balance" Amount Is Displayed 0.00 Value
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Should Be Equal    ${current_balance_amount}    0.00

Verify That A Negative "Current Balance" Amount Is Displayed In Red With Parentheses
    [Documentation]    PP-5    PP-7    PP-11    PP-12    PP-13    PP-14    PP-126
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Update "Current Balance" Amount Is Displayed 0.00 Value
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge
    Verify Current Balance Change New Value    
        ...    expected_color_arg=${new_charge_balance_color}    
        ...    expected_amount_arg=${new_charge_balance_amount}    
        ...    xpath=${payment_current_balance_amount}
    ${amount_column}    Set Variable    //td[contains(text(),"${charge_dict['charge_reference_number_value[1]']}")]//following::td[1]//strong
    Verify Current Balance Change New Value    
        ...    expected_color_arg=220, 53, 69    #red
        ...    expected_amount_arg=${charge_dict['charge_amount_value[1]']}  
        ...    xpath=${amount_column}

Verify That A Positive "Current Balance" Amount Is Displayed In Green
    [Documentation]    PP-6    PP-8    PP-32    PP-33    PP-34    PP-35    PP-51    PP-55    PP-125
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Update "Current Balance" Amount Is Displayed 0.00 Value
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment
    Verify Current Balance Change New Value    
        ...    expected_color_arg=${new_payment_balance_color}    
        ...    expected_amount_arg=${new_payment_balance_amount}    
        ...    xpath=${payment_current_balance_amount}
    ${amount_column}    Set Variable    //td[contains(text(),"${payment_dict['payment_reference_number_value[1]']}")]//following::td[1]//strong
    Verify Current Balance Change New Value    
        ...    expected_color_arg=71, 159, 118    #green
        ...    expected_amount_arg=${payment_dict['payment_amount_value[1]']}  
        ...    xpath=${amount_column}

Verify Unique Number Is Auto-Generated Per Charge Line
    [Documentation]    PP-15    PP-23    PP-24    PP-26    PP-27    PP-30    PP-31
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge    loop=3
    Verify All Lines Are Visible On Transactions Table    payment_type=Charge    dict_arg=${charge_dict}    utc=${data_input}[utc]    loop=3    

Verify Unique Number Is Auto-Generated Per Payment Line
    [Documentation]    PP-36    PP-48    PP-50    PP-52    PP-53    PP-56    PP-60    PP-61
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment    loop=3
    Verify All Lines Are Visible On Transactions Table    payment_type=Payment    dict_arg=${payment_dict}    utc=${data_input}[utc]    loop=3

Verify Unique Number Is Auto-Generated Per Adjustment Line And "Current Balance" Is Updated Based On Total Adjustment Amount
    [Documentation]    PP-9    PP-62    PP-63    PP-64    PP-68    PP-69    PP-70   PP-72    PP-73
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment    loop=4 
    Verify All Lines Are Visible On Transactions Table    payment_type=Adjustment    dict_arg=${adjustment_dict}    utc=${data_input}[utc]    loop=4    

Edit Transaction SuccessFully
    [Documentation]    PP-85    PP-90    PP-91    PP-92    PP-93    PP-94    PP-95    PP-96    PP-111    PP-113    
                ...    PP-114    PP-117    PP-118    PP-119    PP-120    PP-121    PP-122    PP-123    PP-124
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge  
    ${charge_dict}    Edit Charge    ${charge_dict}
    Verify All Lines Are Visible On Transactions Table    payment_type=Charge    dict_arg=${charge_dict}    utc=${data_input}[utc]
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment  
    ${payment_dict}    Edit Payment    ${payment_dict}
    Verify All Lines Are Visible On Transactions Table    payment_type=Payment    dict_arg=${payment_dict}    utc=${data_input}[utc]
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment
    ${adjustment_dict}    Edit Adjustment    ${adjustment_dict}
    Verify All Lines Are Visible On Transactions Table    payment_type=Adjustment    dict_arg=${adjustment_dict}    utc=${data_input}[utc]

Verify Add Transaction Unsuccessfully If Empty Required Fields
    [Documentation]    PP-16    PP-17    PP-20    PP-37    PP-38    PP-40    PP-41    PP-65    PP-66    PP-97    PP-98    PP-99    
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Leave Required Fields In Add Charge Modal
    Leave Required Fields In Add Payment Modal
    Leave Required Fields In Add Adjustment Modal

Verify Edit Transaction Unsuccessfully If Empty Required Fields
    [Documentation]    PP-108
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Leave Required Fields In Edit Charge Modal
    Leave Required Fields In Edit Payment Modal
    Leave Required Fields In Edit Adjustment Modal

Verify Fields In Charge Modal Show Default And Valid Value Exactly
    [Documentation]    PP-18    PP-19    PP-21    PP-22
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Open Add Charge Modal
    The "Charge Type" Dropdown Shows Default And Valid Value In Charge Modal
    Verify Value Of Transaction Date Field    transaction_date_arg=(//input[contains(@class,"TransactionDatepicker")])[1]    utc=${data_input}[utc]

Verify Fields In Payment Modal Show Default And Valid Value Exactly
    [Documentation]    PP-39    PP-40    PP-41    PP-42    PP-43    PP-44    PP-45    PP-46
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Open Add Payment Modal
    The "Payment Method" Dropdown Shows Default And Valid Value In Payment Modal
    The "Payment Type" Dropdown Shows Default And Valid Value In Payment Modal
    Verify Value Of Transaction Date Field    transaction_date_arg=(//input[contains(@class,"TransactionDatepicker")])[1]    utc=${data_input}[utc]

Verify Fields In Adjustment Modal Show Default And Valid Value Exactly
    [Documentation]    
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Open Add Adjustment Modal
    The "Adjustment Type" Dropdown Shows Default And Valid Value In Charge Modal
    Verify Value Of Transaction Date Field    transaction_date_arg=(//input[contains(@class,"TransactionDatepicker")])[1]    utc=${data_input}[utc]

Clicking The Delete Button To Remove The Transaction Line
    [Documentation]    PP-25    PP-28    PP-29    PP-47    PP-49    PP_54    PP-57    PP-58    PP-59    PP-71
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    Clicking The Delete Button To Remove The Charge Line
    Clicking The Delete Button To Remove The Payment Line
    Clicking The Delete Button To Remove The Adjustment Line

Verify The Filters In Transactions Section Show Default And Valid Value Exactly
    [Documentation]    PP-74    PP-75    PP-76    PP-77
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    The "Filter By Transaction Method" Dropdown Shows Default And Valid Value In Transactions Section
    The "Filter By Transaction Type" Dropdown Shows Default And Valid Value In Transactions Section
    The "Filter By Transaction Date" Field Shows Default Value In Transactions Section    utc=${data_input}[utc]

Selecting A Transaction Method Filters The Transaction List
    [Documentation]    PP-78    PP-82
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment
    ${method_list}    Create List    All Transaction Methods    Adjustment    Charge    Payment
    FOR    ${method_index}    IN    @{method_list}
        IF    '${method_index}' == 'All Transaction Methods'
            Filter All Transaction Methods On Transactions Table
        ELSE
            Filter By Transaction Method In Transactions Table    value=${method_index}
            Verify Filtered Transaction Results On UI    expect_line=//strong[contains(text(),"${method_index}")]//ancestor::td
        END
    END

Selecting A Transaction Type Filters The Transaction List
    [Documentation]    PP-79    PP-83;
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    @{type_list}    Create List    Office Copay Debit    Coinsurance Debit    Deductible Debit
    FOR    ${type_index}    IN    @{type_list}
        Open Add Charge Modal
        ${charge_amount_total}    ${charge_dict}    Input Charge Modal    charge_status=Add Charge    type_value=${type_index}
        Click Save Charge Button    Patient Balance Updated.

        Open Add Payment Modal
        ${payment_amount_total}    ${payment_dict}    Input Payment Modal    payment_status=Add Payment    method_value=random    type_value=${type_index}
        Click Save Payment Button    Patient Balance Updated.

        Open Add Adjustment Modal
        ${adjustment_amount_total}    ${adjustment_dict}    Input Adjustment Modal    adjustment_status=Add Adjustment    type_value=${type_index} 
        Click Save Adjustment Button    Patient Balance Updated.

        Filter By Transaction Type In Transactions Table    ${type_index}
        Set Test Variable    ${type_index}
        Verify Filtered Transaction Results On UI    expect_line=//strong[contains(text(),"${type_index}")]//ancestor::td
    END

Selecting A Transaction Date Filters The Transaction List
    [Documentation]    PP-80
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment
    ${date_list}    Create List    
            ...    ${charge_dict['charge_transaction_date[1]']}
            ...    ${payment_dict['payment_transaction_date[1]']}
            ...    ${adjustment_dict['adjustment_transaction_date[1]']}
    FOR    ${date_index}    IN ZIP    ${date_list}
        Filter By Transaction Date In Transactions Table    ${date_index}
        Verify Payments Shows On UI Following Transaction Date    expect_datetime=${date_index}
    END

Selecting All Three Filters Together Applies Corect Filtering
    [Documentation]    PP-81    PP-84    PP-112
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment
    ${method_list}    Create List    
            ...    Charge
            ...    Payment
            ...    Adjustment
    ${type_list}    Create List    
            ...    ${charge_dict['charge_type[1]']}
            ...    ${payment_dict['payment_type[1]']}
            ...    ${adjustment_dict['adjustment_type[1]']}
    ${date_list}    Create List    
            ...    ${charge_dict['charge_transaction_date[1]']}
            ...    ${payment_dict['payment_transaction_date[1]']}
            ...    ${adjustment_dict['adjustment_transaction_date[1]']}
    FOR    ${method_index}    ${type_index}    ${date_index}    IN ZIP    ${method_list}    ${type_list}    ${date_list}
        Filter By Transaction Method In Transactions Table    ${method_index}
        Filter By Transaction Type In Transactions Table    ${type_index}
        Filter By Transaction Date In Transactions Table    ${date_index}
        Verify Filtered Transaction Results On UI    expect_line=//strong[contains(text(),"${method_index}")]//ancestor::td
        Verify Filtered Transaction Results On UI    expect_line=//strong[contains(text(),"${type_index}")]//ancestor::td
        Verify Payments Shows On UI Following Transaction Date    expect_datetime=${date_index}
    END

Validation Of Date Range Filter Behavior And Input Rules
    [Documentation]    PP-127    PP-128    PP-132    PP-133    PP-134    PP-135    PP-136    PP-137    PP-147    PP-148
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${appointment_dict}    Dispense Appointments For Patient Payments    loops=2
    Open Patient Payments Tab
    Verify Appointments Transaction Rows Are Visible    loops=2    appointment_dict=${appointment_dict}
    Filter By Date Range In Appointments Transaction    ${appointment_dict.apt_date_1}    ${appointment_dict.apt_date_2}
    Verify Appointments Transaction Rows Are Visible    loops=2    appointment_dict=${appointment_dict}
    Filter By Date Range In Appointments Transaction    ${appointment_dict.apt_date_1}    ${EMPTY}
    Verify Appointments Transaction Rows Are Visible    loops=2    appointment_dict=${appointment_dict}
    Verify The Date Fomat Is MM/DD/YYYY    utc=${data_input}[utc]  
    The Filter By Date Range Resets When Navigating Away From The Page
    
Verify "Filter By Appointment No" Field Functionality And Input Behavior
    [Documentation]    PP-138    PP-139    PP-140    PP-141    PP-142    PP-143    PP-144    PP-146
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${appointment_dict}    Dispense Appointments For Patient Payments    loops=1
    Open Patient Payments Tab
    Filter By Appointment No Field Has Default Value
    Filter By Appointment No In Appointments Transaction    apt_id=${appointment_dict.apt_id_1}
    Verify Appointments Transaction Rows Are Visible    loops=1    appointment_dict=${appointment_dict}
    Filter By Appointment No In Appointments Transaction    apt_id=invalid appointment number
    Wait Until Page Contains    No Appointments Available
    ${apt_id_has_space}    Set Variable    '    ${appointment_dict.apt_id_1}    '
    Filter By Appointment No In Appointments Transaction    Appointments =${apt_id_has_space}
    Verify Appointments Transaction Rows Are Visible    loops=1    appointment_dict=${appointment_dict}

Verify Appointments Transaction Table Has All Valid Columns
    [Documentation]    PP-149    PP-150    PP-152    PP-154    PP-155    PP-159
    [Tags]    Regression     Patient Payments    report.label.owner: Hai Nguyen
    ${appointment_dict}    Dispense Appointments For Patient Payments    loops=1
    Open Patient Payments Tab
    Appointments Transaction Table Is Sorted By Latest Date Of Service    apt_date_arg=${appointment_dict.apt_date}
    Filter By Appointment No In Appointments Transaction    apt_id=${appointment_dict.apt_id_1}
    Verify Appointments Transaction Rows Are Visible    loops=1    appointment_dict=${appointment_dict}
    Verify All Column Of Dispensed Appoinment    apt_id=${appointment_dict.apt_id_1}    apt_medication=${appointment_dict.apt_primary_medication_txt_1}

*** Keywords ***
Suite Setup Patient Payments Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${PatientCreate}    Patient.Create Patient With Necessary Information
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]    
        ...    refering_provider_arg=${data_input}[refering_provider] 
    PatientList.Navigate to Patient by Generated MRN
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    ${original_window}    Get Window Handles

    Set Suite Variable    ${data_input}
    Set Suite Variable    ${PatientCreate}
    Set Suite Variable    ${update_patient_window}    ${original_window}[0]

Test Setup Patient Payments Suite
    Test Setup Patient Management
        ...    title_arg=Update Patient
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[patient_mrn]
    Open Patient Payments Tab

Dispense Appointments For Patient Payments
    [Arguments]    ${loops}
    Open Appointments Tab
    AppointmentOrderingLedger.Go To Schedule New Appointment
    ${appointment_dict}    ScheduleNewAppointment.Schedule Appointment Without Office Visit   
        ...    location_arg=${data_input}[location]
        ...    patient_arg=${data_input}[patient_mrn]   
        ...    therapy_arg=${data_input}[therapy]  
        ...    dose_arg=10
        ...    loops=${loops}
    Reload Page
    Open Appointments Tab
    FOR    ${loop}    IN RANGE    ${loops}
        ${loop}    Set Variable    ${loop+1}
        IF    "${loops}" == "1"
            ${apt_date}    Set Variable    ${appointment_dict.apt_date}
        ELSE
            ${apt_date}    Set Variable    ${appointment_dict.apt_date_${loop}}
        END
        ${apt_id}    Get Appointment ID    apt_datetime=${apt_date}
        ${apt_primary_medication_txt}    Get Primary Medication    apt_datetime=${apt_date}
        LedgerView.Open Appointment    ${apt_date}
        ${dispense_dict}    OpenAppointment.Dispense Created Appoinment
        Common.Close Modal Popup
        Set To Dictionary    ${appointment_dict}    apt_id_${loop}=${apt_id}    apt_primary_medication_txt_${loop}=${apt_primary_medication_txt}
    END
    RETURN    ${appointment_dict}

