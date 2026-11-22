*** Settings ***
Resource    AddCharge/AddCharge.resource
Resource    AddPayment/AddPayment.resource
Resource    AddAdjustment/AddAdjustment.resource

*** Variables ***
${payment_current_balance_amount}    //strong[@id="PatientPaymentCurrentBalance"]
${payment_transaction_method_select}    //select[@id="TransactionMethodFilter"]
${payment_transaction_type_select}    //select[@id="TransactionTypeFilter"]
${payment_transaction_date_select}    //input[@id="TransactionDateFilter"]
# Patient Payment tab - Tansactions Table
${patient_payment_next_btn}    //a[contains(text(),"Next")]
${filter_transaction_method_select}    //select[@id="TransactionMethodFilter"]
${filter_transaction_type_select}    //select[@id="TransactionTypeFilter"]
${filter_transaction_date_input}    //input[@id="TransactionDateFilter"]
${total_line}    //div[@id="PatientPaymentTransactions"]//child::tbody//tr
${edit_transaction_title}    //h4[contains(text(),"Edit Transaction")]

# # Patient Payment tab - Appointments Table
${payment_apt_no_filter_input}    //input[@id="AppointmentNoFilter"]
${payment_startdate_filter_input}    //input[@id="AppointmentStartDateFilter"]
${payment_enddate_filter_input}    //input[@id="AppointmentEndDateFilter"]

*** Keywords ***
Created Patient Payment Dictionary
    &{patientpayment_dict}    Create Dictionary
    RETURN    ${patientpayment_dict}

Get Current Balance Amount
    [Arguments]    ${balance_amount_element_arg}
    Wait Until Element Is Visible    ${balance_amount_element_arg}    30s
    ${current_balance_amount_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${balance_amount_element_arg}
    ${current_balance_amount}    Get Regexp Matches    ${current_balance_amount_txt}    (?<=\\$)\\d+.*\\d+
    ${current_balance_amount}    Replace String    ${current_balance_amount}[0]    ,    ${EMPTY}
    IF    '${current_balance_amount}' != '0.00'
        ${balance_color_style}    SeleniumLibrary.Get Element Attribute    ${balance_amount_element_arg}    style
        ${balance_color}    Get Regexp Matches    ${balance_color_style}    \\d+,\\s\\d+,\\s\\d+
        ${balance_color}    Set Variable    ${balance_color}[0]
    ELSE
        ${balance_color}    Set Variable    none
    END
    RETURN    ${balance_color}    ${current_balance_amount}

Calculate Current Balance Amount
    [Arguments]    ${status_arg}    ${amount_total_arg}    ${balance_amount_element_arg}    ${current_balance_amount}    ${balance_color}
    ${new_balance_color}    ${new_current_balance_amount}    Get Current Balance Amount    ${balance_amount_element_arg}
    ${amount_total_arg}    Evaluate    abs(${amount_total_arg})
    IF    '${balance_color}' == '71, 159, 118' or '${balance_color}' == 'none'    #green
        IF    "${status_arg}" == "increase"
            ${amount_increase}    Evaluate    round((${current_balance_amount} + ${amount_total_arg}),2)
            ${amount_increase}    Evaluate    abs(${amount_increase})
            ${amount_increase}    Evaluate    f"{${amount_increase}:.2f}"
            Should Be Equal As Strings    ${amount_increase}    ${new_current_balance_amount}
        ELSE IF    "${status_arg}" == "decrease"
            ${amount_decrease}    Evaluate    round((${current_balance_amount} - ${amount_total_arg}),2)
            ${amount_decrease}    Evaluate    abs(${amount_decrease})
            ${amount_decrease}    Evaluate    f"{${amount_decrease}:.2f}"
            Should Be Equal As Strings    ${amount_decrease}    ${new_current_balance_amount}
        END
    ELSE IF    '${balance_color}' == '220, 53, 69' or '${balance_color}' == 'none'    #red
        IF    "${status_arg}" == "increase"
            ${amount_increase}    Evaluate    round((${current_balance_amount} - ${amount_total_arg}),2)
            ${amount_increase}    Evaluate    abs(${amount_increase})
            ${amount_increase}    Evaluate    f"{${amount_increase}:.2f}"
            Should Be Equal As Strings    ${amount_increase}    ${new_current_balance_amount}
        ELSE IF    "${status_arg}" == "decrease"
            ${amount_decrease}    Evaluate    round((${current_balance_amount} + ${amount_total_arg}),2)
            ${amount_decrease}    Evaluate    abs(${amount_decrease})
            ${amount_decrease}    Evaluate    f"{${amount_decrease}:.2f}"
            Should Be Equal As Strings    ${amount_decrease}    ${new_current_balance_amount}
        END
    END
    RETURN    ${new_balance_color}    ${new_current_balance_amount}

Check Current Balance Value In Modal
    [Arguments]    ${current_balance_arg}    ${current_balance_amount}
    ${balance_color}    ${current_balance_amount_txt}    Get Current Balance Amount    ${current_balance_arg}
    Should Be Equal    ${current_balance_amount_txt}    ${current_balance_amount}

Set Transaction Data
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f    full_name    num_rand    sentence
    ${amount_value}    Set Variable    ${Fake_dict['decimal_2d_2f']}
    ${reference_number_value}    Set Variable    ${Fake_dict['full_name']} ${Fake_dict['num_rand']}
    ${transaction_date}    Get Current Date    result_format=%m/%d/%Y
    ${reason_value}    Set Variable    ${Fake_dict['sentence']}
    RETURN    ${amount_value}    ${reference_number_value}    ${transaction_date}    ${reason_value}

Verify Value Of Transaction Date Field
    [Arguments]    ${transaction_date_arg}    ${utc}
    ${transaction_date_input}    Set Variable    ${transaction_date_arg}
    ${transaction_date_default}    SeleniumLibrary.Get Element Attribute    ${transaction_date_input}    placeholder
    ${placeholder_transaction_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}
    Should Be Equal    ${transaction_date_default}    ${placeholder_transaction_date}

Verify Current Balance Change New Value
    [Arguments]    ${expected_color_arg}    ${expected_amount_arg}    ${xpath}
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${xpath}
    Should Be Equal    ${balance_color}    ${expected_color_arg}
    Should Be Equal    ${current_balance_amount}    ${expected_amount_arg}

Filter By Transaction Method In Transactions Table
    [Arguments]    ${value}
    Wait Until Element Is Enabled    ${filter_transaction_method_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_method_select}    ${value}

Filter By Transaction Type In Transactions Table
    [Arguments]    ${value}
    Wait Until Element Is Enabled    ${filter_transaction_type_select}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_type_select}    ${value}

Filter By Transaction Date In Transactions Table
    [Arguments]    ${value}
    Common.Input Text Into Field    ${filter_transaction_date_input}    ${value}
    Common.Choose Date In Onset Date Input    date_arg=${value}

Update "Current Balance" Amount Is Displayed 0.00 Value
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    IF    '${balance_color}' == '71, 159, 118'    #green
        ${charge_dict}    Created Charge Dictionary
        ${charge_amount_value}    ${charge_reference_number_value}    ${charge_transaction_date}    Prepare Charge Data
        Open Add Charge Modal
        Input Amount In Add Charge Modal    ${current_balance_amount}    1
        Select Change Type In Add Charge Modal    ${charge_dict}    random
        Input Reference Number In Add Charge Modal    ${charge_reference_number_value}    1
        Input Transaction Date In Add Charge Modal    ${charge_transaction_date}    1
        Click Add Charge Line Button
        Click Save Charge Button    Patient Balance Updated.
    ELSE IF    '${balance_color}' == '220, 53, 69'    #red
        ${payment_dict}    Created Payment Dictionary
        ${payment_amount_value}    ${payment_reference_number_value}    ${payment_transaction_date}    Prepare Payment Data
        Open Add Payment Modal
        Input Amount In Add Payment Modal    ${current_balance_amount}    1
        Select Payment Method In Add Payment Modal    ${payment_dict}
        Select Payment Type In Add Payment Modal    ${payment_dict}
        Input Reference Number In Add Payment Modal    ${payment_reference_number_value}    1
        Input Transaction Date In Add Payment Modal    ${payment_transaction_date}    1
        Click Add Payment Line Button
        Click Save Payment Button    Patient Balance Updated.
    END

# Add Charge
Open Add Charge Modal
    Common.Scroll And Click Element    //a[contains(text(),"Add Charge")]
    Wait Until Element Is Visible    //h4[contains(text(),"Add Charge")]    30s

Add Charge
    [Arguments]    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Charge Modal
    Check Current Balance Value In Modal    current_balance_arg=${add_charge_current_balance}    current_balance_amount=${current_balance_amount}
    ${charge_amount_total}    ${charge_dict}    Input Charge Modal    
        ...    charge_status=Add Charge
        ...    loop=${loop}    
    ${new_balance_color}    ${new_current_balance_amount}    Calculate Current Balance Amount  
        ...    status_arg=decrease    
        ...    amount_total_arg=${charge_amount_total}    
        ...    balance_amount_element_arg=${add_charge_new_balance}    
        ...    current_balance_amount=${current_balance_amount}
        ...    balance_color=${balance_color}    
    Click Save Charge Button    Patient Balance Updated.
    RETURN    ${new_balance_color}    ${new_current_balance_amount}    ${charge_dict}

Edit Charge
    [Arguments]    ${charge_dict}    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Edit Transaction Modal    payment_type=Charge    row_value=${charge_dict['charge_reference_number_value[${loop}]']}
    ${charge_amount_total}    ${charge_dict}    Input Charge Modal    
        ...    charge_status=Edit Charge
        ...    loop=${loop}
    Click Save Charge Button    Patient Transaction Updated.
    RETURN    ${charge_dict}

# Add Payment
Open Add Payment Modal
    Common.Scroll And Click Element    ${payment_add_payment_btn}
    Wait Until Element Is Visible    ${add_payment_title}    30s

Add Payment
    [Arguments]    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Payment Modal
    Check Current Balance Value In Modal    current_balance_arg=${add_payment_current_balance}    current_balance_amount=${current_balance_amount}
    ${payment_amount_total}    ${payment_dict}    Input Payment Modal    
        ...    payment_status=Add Payment
        ...    loop=${loop}    
    ${new_balance_color}    ${new_current_balance_amount}    Calculate Current Balance Amount  
        ...    status_arg=increase    
        ...    amount_total_arg=${payment_amount_total}    
        ...    balance_amount_element_arg=${add_payment_new_balance}    
        ...    current_balance_amount=${current_balance_amount}
        ...    balance_color=${balance_color}      
    Click Save Payment Button    Patient Balance Updated.
    RETURN    ${new_balance_color}    ${new_current_balance_amount}    ${payment_dict}

Edit Payment
    [Arguments]    ${payment_dict}    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Edit Transaction Modal    payment_type=Payment    row_value=${payment_dict['payment_reference_number_value[${loop}]']}
    ${payment_amount_total}    ${payment_dict}    Input Payment Modal    
        ...    payment_status=Edit Payment
        ...    loop=${loop}    
    Click Save Payment Button    Patient Transaction Updated.
    RETURN    ${payment_dict}

# Add Adjustment
Open Add Adjustment Modal
    Common.Scroll And Click Element    ${payment_add_adjustment_btn}
    Wait Until Element Is Visible    ${add_adjustment_title}    30s

Add Adjustment
    [Arguments]    ${tool_btn}=random    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Add Adjustment Modal
    Check Current Balance Value In Modal    current_balance_arg=${add_adjustment_current_balance}    current_balance_amount=${current_balance_amount}
    ${adjustment_amount_total}    ${adjustment_dict}    Input Adjustment Modal
        ...    adjustment_status=Add Adjustment
        ...    tool_btn=${tool_btn}
        ...    loop=${loop}
    IF    ${adjustment_amount_total} >= 0
        ${new_balance_color}    ${new_current_balance_amount}    Calculate Current Balance Amount    
            ...    status_arg=increase    
            ...    amount_total_arg=${adjustment_amount_total}    
            ...    balance_amount_element_arg=${add_adjustment_new_balance}
            ...    current_balance_amount=${current_balance_amount}
            ...    balance_color=${balance_color}    
    ELSE IF    ${adjustment_amount_total} < 0
        ${new_balance_color}    ${new_current_balance_amount}    Calculate Current Balance Amount    
            ...    status_arg=decrease    
            ...    amount_total_arg=${adjustment_amount_total}    
            ...    balance_amount_element_arg=${add_adjustment_new_balance}
            ...    balance_color=${balance_color}    
            ...    current_balance_amount=${current_balance_amount}
    END
    Click Save Adjustment Button    Patient Balance Updated.
    RETURN    ${new_balance_color}    ${new_current_balance_amount}    ${adjustment_dict}

Edit Adjustment
    [Arguments]    ${adjustment_dict}    ${tool_btn}=random    ${loop}=1
    ${balance_color}    ${current_balance_amount}    Get Current Balance Amount    ${payment_current_balance_amount}
    Open Edit Transaction Modal    payment_type=Adjustment    row_value=${adjustment_dict['adjustment_reason_value[${loop}]']}
    ${adjustment_amount_total}    ${adjustment_dict}    Input Adjustment Modal
        ...    adjustment_status=Edit Adjustment
        ...    tool_btn=${tool_btn}
        ...    loop=${loop}
    Click Save Adjustment Button    Patient Transaction Updated.
    RETURN    ${adjustment_dict}

# Transactions Section Table
The "Filter By Transaction Method" Dropdown Shows Default And Valid Value In Transactions Section
    ${transaction_method_select_default}    Get Selected List Label    ${filter_transaction_method_select}
    Should Be Equal    ${transaction_method_select_default}     All Transaction Methods
    ${dropdown_options}    Create List    All Transaction Methods    Adjustment    Charge    Payment
    ${transaction_method_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${filter_transaction_method_select}
    Lists Should Be Equal    ${dropdown_options}    ${transaction_method_select_options}

The "Filter By Transaction Type" Dropdown Shows Default And Valid Value In Transactions Section
    ${transaction_type_select_default}    Get Selected List Label    ${filter_transaction_type_select}
    Should Be Equal    ${transaction_type_select_default}     All Transaction Types
    ${dropdown_options}    Create List    All Transaction Types    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${transaction_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${filter_transaction_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${transaction_type_select_options}

The "Filter By Transaction Date" Field Shows Default Value In Transactions Section
    [Arguments]    ${utc}
    Verify Value Of Transaction Date Field    transaction_date_arg=${filter_transaction_date_input}    utc=${utc}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${filter_transaction_date_input} 
    Common.Close Calendar Table

Open Edit Transaction Modal
    [Arguments]    ${payment_type}    ${row_value}
    IF    '${payment_type}' == 'Charge' or '${payment_type}' == 'Payment'
        ${reference_number_value}    Set Variable    ${row_value}
        ${transaction_edit_btn}    Set Variable    //td[contains(text(),"${reference_number_value}")]//preceding::td[2]//a[contains(text(),"Edit Transaction")]
        Common.Scroll And Click Element    ${transaction_edit_btn}
    ELSE IF    '${payment_type}' == 'Adjustment'
        ${adjustment_reason_value}    Set Variable    ${row_value}
        ${adjustment_transaction_edit_btn}    Set Variable    //strong[contains(text(),"${adjustment_reason_value}")]//preceding::td[1]//a[contains(text(),"Edit Transaction")]
        Common.Scroll And Click Element    ${adjustment_transaction_edit_btn}
    END
    Wait Until Element Is Visible    ${edit_transaction_title}    30s

# Appointments Transaction
Filter By Appointment No In Appointments Transaction
    [Arguments]    ${apt_id}
    Common.Clear Input Field Until Empty    ${payment_apt_no_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_apt_no_filter_input}    ${apt_id}

Filter By Start Date In Appointments Transaction
    [Arguments]    ${startdate}
    Common.Clear Input Field Until Empty    ${payment_startdate_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_startdate_filter_input}    ${startdate}
    Common.Close Calendar Table

Filter By End Date In Appointments Transaction
    [Arguments]    ${enddate}
    Common.Clear Input Field Until Empty    ${payment_enddate_filter_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${payment_enddate_filter_input}    ${enddate}
    Common.Close Calendar Table

Filter By Date Range In Appointments Transaction
    [Arguments]    ${startdate}    ${enddate}
    Filter By Start Date In Appointments Transaction    ${startdate}
    Filter By End Date In Appointments Transaction    ${enddate}