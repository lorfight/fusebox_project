*** Settings ***
Resource    ../../../Layers/PatientPayments/PatientPayments.resource

*** Variables ***
# Patient Payment tab
${patient_payment_tab}    //a[@id='PatientPayments']
${payment_current_balance_title}    //strong[contains(text(),"Current Balance")]//parent::div

*** Keywords ***
Open Patient Payments Tab
    Navigate To The Tab    
        ...    tab_name=${patient_payment_tab}    
        ...    title_name=${payment_current_balance_title}
    Common.Element Is Not Visible    //i[@class='fa fa-spinner fa-4x fa-spin']

Verify All Lines Are Visible On Transactions Table
    [Arguments]    ${payment_type}    ${dict_arg}    ${utc}    ${loop}=1    
    ${created_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}
    ${user_name_txt}    Common.Get User Name
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        IF    '${payment_type}' == 'Charge' or '${payment_type}' == 'Payment'
            IF    '${payment_type}' == 'Charge'
                ${reference_number_value}    Set Variable    ${dict_arg['charge_reference_number_value[${line}]']}
            ELSE IF    '${payment_type}' == 'Payment'
                ${reference_number_value}    Set Variable    ${dict_arg['payment_reference_number_value[${line}]']}
            END
            ${transaction_date_column_value}    Set Variable    //td[contains(text(),"${reference_number_value}")]//preceding::td[2]//div[1]
            ${type_column_value}    Set Variable    //td[contains(text(),"${reference_number_value}")]//preceding::td[1]
            ${reference_number_column_value}    Set Variable    //td[contains(text(),"${reference_number_value}")]
            ${amount_column_value}    Set Variable    //td[contains(text(),"${reference_number_value}")]//following::td[1]//strong
            ${running_total_column_value}    Set Variable    //td[contains(text(),"${reference_number_value}")]//following::td[2]//strong
        ELSE IF    '${payment_type}' == 'Adjustment'
            ${adjustment_reason_value}    Set Variable    ${dict_arg['adjustment_reason_value[${line}]']}
            ${transaction_date_column_value}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//preceding::td[1]//div[1]
            ${type_column_value}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//ancestor::td
            ${reference_number_column_value}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//following::td[1]
            ${amount_column_value}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//following::td[2]//strong
            ${running_total_column_value}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//following::td[3]
        END
        FOR    ${check_loop}    IN RANGE    10
            ${check_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${transaction_date_column_value}    5s
            IF    '${check_visible}' == '${True}'
                Exit For Loop
            ELSE
                Common.Scroll And Click Element    ${patient_payment_next_btn}
            END
        END
        IF    '${payment_type}' == 'Charge'
            SeleniumLibrary.Element Text Should Be    ${transaction_date_column_value}    ${dict_arg['charge_transaction_date[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${type_column_value}    ${payment_type} - ${dict_arg['charge_type[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${reference_number_column_value}    ${dict_arg['charge_reference_number_value[${line}]']}\nCreated Date: ${created_date} by ${user_name_txt}
            Verify Current Balance Change New Value    
                ...    expected_color_arg=220, 53, 69    #red
                ...    expected_amount_arg=${dict_arg['charge_amount_value[${line}]']}
                ...    xpath=${amount_column_value}
            SeleniumLibrary.Element Text Should Be    ${running_total_column_value}    ${dict_arg['new_charge_balance_value[${line}]']}
            
        ELSE IF    '${payment_type}' == 'Payment'
            SeleniumLibrary.Element Text Should Be    ${transaction_date_column_value}    ${dict_arg['payment_transaction_date[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${type_column_value}    ${payment_type} - ${dict_arg['payment_type[${line}]']}\nPayment Method: ${dict_arg['payment_method[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${reference_number_column_value}    ${dict_arg['payment_reference_number_value[${line}]']}\nCreated Date: ${created_date} by ${user_name_txt}
            Verify Current Balance Change New Value    
                ...    expected_color_arg=71, 159, 118    #green
                ...    expected_amount_arg=${dict_arg['payment_amount_value[${line}]']}  
                ...    xpath=${amount_column_value}
            SeleniumLibrary.Element Text Should Be    ${running_total_column_value}    ${dict_arg['new_payment_balance_value[${line}]']}
        ELSE IF    '${payment_type}' == 'Adjustment'
            SeleniumLibrary.Element Text Should Be    ${transaction_date_column_value}    ${dict_arg['adjustment_transaction_date[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${type_column_value}    ${payment_type} - ${dict_arg['adjustment_type[${line}]']}\nAdjustment Reason: ${dict_arg['adjustment_reason_value[${line}]']}
            SeleniumLibrary.Element Text Should Be    ${reference_number_column_value}    N/A\nCreated Date: ${created_date} by ${user_name_txt}
            IF    '${dict_arg['tool_btn[${line}]']}' == '${add_adjustment_add_btn}'
                Verify Current Balance Change New Value    
                    ...    expected_color_arg=71, 159, 118    #green
                    ...    expected_amount_arg=${dict_arg['adjustment_amount_value[${line}]']}  
                    ...    xpath=${amount_column_value}
            ELSE IF    '${dict_arg['tool_btn[${line}]']}' == '${add_adjustment_subtract_btn}'
                Verify Current Balance Change New Value    
                    ...    expected_color_arg=220, 53, 69    #red
                    ...    expected_amount_arg=${dict_arg['adjustment_amount_value[${line}]']}  
                    ...    xpath=${amount_column_value}
            END
            SeleniumLibrary.Element Text Should Be    ${running_total_column_value}    ${dict_arg['new_adjustment_balance_value[${line}]']}
        END
    END

Clicking The Delete Button To Remove The Charge Line
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Charge Modal
    ${charge_amount_total}    ${charge_dict}    Input Charge Modal    charge_status=Add Charge
    Wait Until Element Is Not Visible    ${add_charge_first_row_btn}    30s
    Verify Remove Transaction Line When Clicking Delete Button    
        ...    remove_first_row_btn=${remove_charge_first_row_btn}
        ...    transaction_row=//input[@value="${charge_dict['charge_reference_number_value[1]']}"]//ancestor::tr    
        ...    new_balance=${add_charge_new_balance}
        ...    current_balance_amount=${current_balance_amount}
    Click Close Charge Button

Clicking The Delete Button To Remove The Payment Line
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Payment Modal
    ${payment_amount_total}    ${payment_dict}    Input Payment Modal    payment_status=Add Payment  
    Wait Until Element Is Not Visible    ${add_payment_firts_row_btn}    30s
    Verify Remove Transaction Line When Clicking Delete Button    
        ...    remove_first_row_btn=${remove_payment_first_row_btn}
        ...    transaction_row=//input[@value="${payment_dict['payment_reference_number_value[1]']}"]//ancestor::tr    
        ...    new_balance=${add_payment_new_balance}
        ...    current_balance_amount=${current_balance_amount}
    Click Close Payment Button

Clicking The Delete Button To Remove The Adjustment Line
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Adjustment Modal
    ${adjustment_amount_total}    ${adjustment_dict}    Input Adjustment Modal    adjustment_status=Add Adjustment    tool_btn=${add_adjustment_add_btn}    
    Wait Until Element Is Not Visible    ${add_adjustment_add_first_row_btn}    30s
    Wait Until Element Is Not Visible    ${add_adjustment_subtract_first_row_btn}    30s
    Verify Remove Transaction Line When Clicking Delete Button    
        ...    remove_first_row_btn=${remove_adjustment_first_row_btn}    
        ...    transaction_row=//textarea[contains(text(),"${adjustment_dict['adjustment_reason_value[1]']}")]//ancestor::tr
        ...    new_balance=${add_adjustment_new_balance}
        ...    current_balance_amount=${current_balance_amount}
    Click Close Adjustment Button

Verify Remove Transaction Line When Clicking Delete Button
    [Arguments]    ${remove_first_row_btn}    ${transaction_row}    ${new_balance}    ${current_balance_amount}
    Wait Until Element Is Visible    ${remove_first_row_btn}    30s
    Wait Until Element Is Visible    ${transaction_row}    30s
    Common.Scroll And Click Element    ${remove_first_row_btn}
    Wait Until Element Is Not Visible    ${transaction_row}    30s
    ${new_balance_after_action}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${new_balance}
    ${new_balance_after_action}    Get Regexp Matches    ${new_balance_after_action}    (?<=\\$)\\d+.*\\d+
    Should Be Equal    ${current_balance_amount}    ${new_balance_after_action}[0]

Verify Filtered Transaction Results On UI
    [Arguments]    ${expect_line}    
    FOR    ${page_index}    IN RANGE    1    11
        Sleep    2s
        ${expect_transaction_filter_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${expect_line}
        ${transaction_total_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${total_line}
        Wait Until Keyword Succeeds    10s    1s    Should Be Equal    ${expect_transaction_filter_lines}    ${transaction_total_lines}
        ${page_index}    Set Variable    ${page_index + 1}
        ${page_num_visible}    Set Variable    //div[@class="pager-navigation"]//a[contains(text(),"${page_index}")]
        ${page_isvisible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${page_num_visible}    2s
        IF    '${page_isvisible}' == '${True}'
            Common.Scroll And Click Element    ${page_num_visible}
        ELSE
            Exit For Loop
        END
    END

Verify Payments Shows On UI Following Transaction Date
    [Arguments]    ${expect_datetime}  
    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Element Text Should Be    (//div[@id="PatientPaymentTransactions"]//tr//div)[1]    ${expect_datetime}    

Filter All Transaction Methods On Transactions Table
    Filter By Transaction Method In Transactions Table    All Transaction Methods
    @{method_list}    Create List    Charge    Payment    Adjustment
    FOR    ${method_index}    IN    @{method_list}
        ${expect_line}    Set Variable    //strong[contains(text(),"${method_index}")]//ancestor::td
        ${expect_transaction_filter_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${expect_line}
        ${transaction_total_lines}    Wait Until Keyword Succeeds    10s    1s    SeleniumLibrary.Get Element Count    ${total_line}
        Should Be True    ${expect_transaction_filter_lines} >= 1 and ${expect_transaction_filter_lines} <= ${transaction_total_lines}
    END
Leave Required Fields In Add Charge Modal
    ${charge_dict}    Created Charge Dictionary
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Charge Type.
        ...    Reference Number can't be empty.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    ${charge_amount_value}    ${charge_reference_number_value}    ${charge_transaction_date}    ${charge_reason_value}    Set Transaction Data
    FOR    ${error}    IN    @{error_list}
        Open Add Charge Modal
        Input Amount In Add Charge Modal    ${charge_amount_value}
        Select Change Type In Add Charge Modal    ${charge_dict}
        Input Reference Number In Add Charge Modal    ${charge_reference_number_value}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Charge Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Charge Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Charge Type."    Select Change Type In Add Charge Modal   dict_arg=${charge_dict}    value=-- Select a Charge Type --
        Run Keyword If    "${error}" == "Reference Number can't be empty."    Input Reference Number In Add Charge Modal    reference_number_arg=${EMPTY}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Charge Modal    transaction_date_arg=01/01/1752
        ${add_charge_btn}    Set Variable    //a[contains(@class,"AddNewChargeBtn")]
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_charge_btn}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Click Save Charge Button    ${error}
        Run Keyword If    "${error}" != "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Common.Page Alert Message    ${error}
        Click Close Charge Button
    END

Leave Required Fields In Add Payment Modal
    ${payment_dict}    Created Payment Dictionary
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Payment Method.
        ...    Please select a Payment Type.
        ...    Reference Number can't be empty.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    ${payment_amount_value}    ${payment_reference_number_value}    ${payment_transaction_date}    Prepare Payment Data
    FOR    ${error}    IN    @{error_list}
        Open Add Payment Modal
        Input Amount In Add Payment Modal    amount_arg=${payment_amount_value}
        Select Payment Method In Add Payment Modal    dict_arg=${payment_dict}
        Select Payment Type In Add Payment Modal    dict_arg=${payment_dict}
        Input Reference Number In Add Payment Modal    reference_number_arg=${payment_reference_number_value}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Payment Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Payment Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Payment Method."    Select Payment Method In Add Payment Modal    dict_arg=${payment_dict}    value=-- Select a Payment Method --
        Run Keyword If    "${error}" == "Please select a Payment Type."    Select Payment Type In Add Payment Modal   dict_arg=${payment_dict}    value=-- Select a Payment Type --
        Run Keyword If    "${error}" == "Reference Number can't be empty."    Input Reference Number In Add Payment Modal    reference_number_arg=${EMPTY}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Payment Modal    transaction_date_arg=01/01/1752
        ${add_payment_btn}    Set Variable    //a[contains(@class,"AddNewPaymentBtn")]
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_payment_btn}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Click Save Payment Button    ${error}
        Run Keyword If    "${error}" != "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Common.Page Alert Message    ${error}
        Click Close Payment Button
    END
Leave Required Fields In Add Adjustment Modal
    ${adjustment_dict}    Created Adjustment Dictionary
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Adjustment Type.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    ${new_adjustment_amount_value}    ${adjustment_reference_number_value}    ${adjustment_transaction_date}    ${adjustment_reason_value}    Set Transaction Data
    FOR    ${error}    IN    @{error_list}
        Open Add Adjustment Modal
        Input Amount In Add Adjustment Modal    amount_arg=${new_adjustment_amount_value}
        Select Adjustment Type In Add Adjustment Modal    dict_arg=${adjustment_dict}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Adjustment Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Adjustment Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Adjustment Type."    Select Adjustment Type In Add Adjustment Modal   dict_arg=${adjustment_dict}    value=-- Select a Adjustment Type --
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Adjustment Modal    transaction_date_arg=01/01/1752
        ${tool_btn}    Random Adjustment Button
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${tool_btn}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Click Save Adjustment Button    ${error}
        Run Keyword If    "${error}" != "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Common.Page Alert Message    ${error}
        Click Close Adjustment Button
    END

Leave Required Fields In Edit Charge Modal
    ${new_charge_balance_color}    ${new_charge_balance_amount}    ${charge_dict}    Add Charge
    ${charge_amount_value}    ${charge_reference_number_value}    ${charge_transaction_date}    ${charge_reason_value}    Set Transaction Data
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Charge Type.
        ...    Must enter a Reference Number.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    FOR    ${error}    IN    @{error_list}
        Open Edit Transaction Modal    payment_type=Charge    row_value=${charge_dict['charge_reference_number_value[${1}]']}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Charge Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Charge Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Charge Type."    Select Change Type In Edit Charge Modal   dict_arg=${charge_dict}    value=-- Select a Charge Type --
        Run Keyword If    "${error}" == "Must enter a Reference Number."    Input Reference Number In Add Charge Modal    reference_number_arg=${EMPTY}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Charge Modal    transaction_date_arg=01/01/1752
        Click Save Charge Button    ${error}
        Click Close Charge Button
    END

Leave Required Fields In Edit Payment Modal
    ${new_payment_balance_color}    ${new_payment_balance_amount}    ${payment_dict}    Add Payment
    ${payment_amount_value}    ${payment_reference_number_value}    ${payment_transaction_date}    Prepare Payment Data
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Payment Method.
        ...    Please select a Payment Type.
        ...    Must enter a Reference Number.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    FOR    ${error}    IN    @{error_list}
        Open Edit Transaction Modal    payment_type=Payment    row_value=${payment_dict['payment_reference_number_value[${1}]']}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Payment Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Payment Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Payment Method."    Select Payment Method In Edit Payment Modal    dict_arg=${payment_dict}    value=-- Select a Payment Method --
        Run Keyword If    "${error}" == "Please select a Payment Type."    Select Payment Type In Edit Payment Modal   dict_arg=${payment_dict}    value=-- Select a Payment Type --
        Run Keyword If    "${error}" == "Must enter a Reference Number."    Input Reference Number In Add Payment Modal    reference_number_arg=${EMPTY}
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Payment Modal    transaction_date_arg=01/01/1752
        Click Save Payment Button    ${error}
        Click Close Payment Button
    END

Leave Required Fields In Edit Adjustment Modal
    ${new_adjustment_balance_color}    ${new_adjustment_balance_amount}    ${adjustment_dict}    Add Adjustment
    ${new_adjustment_amount_value}    ${adjustment_reference_number_value}    ${adjustment_transaction_date}    ${adjustment_reason_value}    Set Transaction Data
    ${Fake_dict}    Generate Fake Data    sentence
    ${error_list}    Create List
        ...    Amount must be a valid number.
        ...    Amount can't be empty.
        ...    Please select a Adjustment Type.
        ...    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    FOR    ${error}    IN    @{error_list}
        Open Edit Transaction Modal    payment_type=Adjustment    row_value=${adjustment_dict['adjustment_reason_value[${1}]']}
        Run Keyword If    "${error}" == "Amount must be a valid number."    Input Amount In Add Adjustment Modal    amount_arg=${Fake_dict['sentence']}
        Run Keyword If    "${error}" == "Amount can't be empty."    Input Amount In Add Adjustment Modal    amount_arg=${EMPTY}
        Run Keyword If    "${error}" == "Please select a Adjustment Type."    Select Adjustment Type In Edit Adjustment Modal   dict_arg=${adjustment_dict}    value=-- Select a Adjustment Type --
        Run Keyword If    "${error}" == "SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM."    Input Transaction Date In Add Adjustment Modal    transaction_date_arg=01/01/1752
        Click Save Adjustment Button    ${error}
        Click Close Adjustment Button
    END

Verify Appointments Transaction Rows Are Visible
    [Arguments]    ${loops}    ${appointment_dict}
    FOR    ${line}    IN RANGE    ${loops}
        IF    "${loops}" == "1"
            ${apt_date}    Set Variable    ${appointment_dict.apt_date}
        ELSE
            ${line}    Set Variable    ${line+1}
            ${apt_date}    Set Variable    ${appointment_dict.apt_date_${line}}
        END
        ${apt_transaction_row}    Set Variable    //td[contains(text(),"${apt_date}")]//ancestor::tr
        Wait Until Element Is Visible    ${apt_transaction_row}    30s
    END

Verify The Date Fomat Is MM/DD/YYYY
    [Arguments]    ${utc}
    ${invalid_current_date}    Get Current Date    result_format=%m-%d-%Y
    ${start_date}    Handle Datetime Format    fmt={mm}-{dd}-{y}    utc=${utc}
    Filter By Date Range In Appointments Transaction    ${invalid_current_date}    ${invalid_current_date}
    Element Text Should Not Be    //input[@id="AppointmentStartDateFilter"]    -
    Element Text Should Not Be    //input[@id="AppointmentEndDateFilter"]    -

The Filter By Date Range Resets When Navigating Away From The Page
    Reload Page
    Open Patient Payments Tab
    ${start_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_startdate_filter_input}
    ${end_date_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${payment_enddate_filter_input}
    Should Be Empty    ${start_date_txt}
    Should Be Empty    ${end_date_txt}

Filter By Appointment No Field Has Default Value
    Wait Until Element Is Visible    ${payment_apt_no_filter_input}    30s
    Scroll Element Into View    ${payment_apt_no_filter_input}
    ${apt_filter_default}    SeleniumLibrary.Get Element Attribute    ${payment_apt_no_filter_input}    placeholder
    Should Be Equal    ${apt_filter_default}    Search by Appointment No

Appointments Transaction Table Is Sorted By Latest Date Of Service
    [Arguments]    ${apt_date_arg}
    ${apt_transaction_date_column}    Set Variable    (//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[1]
    Wait Until Element Is Visible    ${apt_transaction_date_column}    30s
    Scroll Element Into View    ${apt_transaction_date_column}
    ${latest_date_row}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${apt_transaction_date_column}
    Should Contain    ${latest_date_row}    ${apt_date_arg}

Verify All Column Of Dispensed Appoinment
    [Arguments]    ${apt_id}    ${apt_medication}
    ${apt_transaction_id_column}    Set Variable    (//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[2]
    SeleniumLibrary.Element Text Should Be    ${apt_transaction_id_column}    ${apt_id}
    ${apt_transaction_med_column}    Set Variable    (//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[4]
    SeleniumLibrary.Element Text Should Be    ${apt_transaction_med_column}    ${apt_medication}
    ${apt_transaction_allowed_column}    Set Variable    (//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[5]//strong
    ${apt_transaction_due_column}    Set Variable    (//div[@id="PatientPaymentAppointments"]//tbody//following-sibling::tr)[1]//td[6]//strong
    ${check_edit_allowed_payment}    Run Keyword And Return Status    Input Text    ${apt_transaction_allowed_column}    edit_testing
    Should Not Be True    ${check_edit_allowed_payment}
    ${check_edit_amt_due}    Run Keyword And Return Status    Input Text    ${apt_transaction_due_column}    edit_testing
    Should Not Be True    ${check_edit_amt_due}
    ${open_billable_event_btn}    Set Variable    //a[contains(text(),"Open Billable Event")]
    ${open_billable_event_table}    Set Variable    //table[contains(@class,"BillableEventsTable")]
    Common.Scroll And Click Element    ${open_billable_event_btn}
    Wait Until Element Is Visible    ${open_billable_event_table}    30s
