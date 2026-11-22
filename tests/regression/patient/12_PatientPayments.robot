*** Settings ***
Documentation      Patient Management
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup With Required Patient Information
Test Setup    Test Setup Keyword
Test Teardown    Test Teardown Keyword
Suite Teardown    Log Data And Close Browser
Test Tags    test:retry(1)    PaMan_012    patient    Admin

*** Test Cases ***
Verify That The "Current Balance" Field Is A Non-Editable Textbox
    [Documentation]    PP-1    PP-2    PP-3    PP-4
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Should Be Equal    ${current_balance_amount}    0.00

Verify That A Negative "Current Balance" Amount Is Displayed In Red With Parentheses
    [Documentation]    PP-5    PP-7    PP-11    PP-12    PP-13    PP-14    PP-126
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Create Fake Data List
    ${amount_value}    Evaluate    round((${current_balance_amount} + ${Fake_dict.decimal_2d_2f}),2)
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    charge_amount_value=${amount_value}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    The Balance's Color Should Be    xpath=${payment_current_balance_amount}    color=220, 53, 69    #red
    ${reference_number_value}    Set Variable    ${TempData['charge_reference_number_value[1]']}
    ${amount_column_value}    Replace Variables    ${amount_column_value}
    The Balance's Color Should Be    xpath=${amount_column_value}    color=220, 53, 69    #red

Verify That A Positive "Current Balance" Amount Is Displayed In Green
    [Documentation]    PP-6    PP-8    PP-32    PP-33    PP-34    PP-35    PP-51    PP-55    PP-125
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Create Fake Data List
    ${amount_value}    Evaluate    round((${current_balance_amount} + ${Fake_dict.decimal_2d_2f}),2)
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    payment_amount_value=${amount_value}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    The Balance's Color Should Be    xpath=${payment_current_balance_amount}    color=71, 159, 118    #green
    ${reference_number_value}    Set Variable    ${TempData['payment_reference_number_value[1]']}
    ${amount_column_value}    Replace Variables    ${amount_column_value}
    The Balance's Color Should Be    xpath=${amount_column_value}    color=71, 159, 118    #green

Verify Unique Number Is Auto-Generated Per Payment Line
    [Documentation]    PP-36    PP-48    PP-50    PP-52    PP-53    PP-56    PP-60    PP-61
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.
    ...    payment_amount_value=${None}
    ...    loop=3
    ...    add_payment_btn_status=${True}
    Verify All Lines Are Visible On Transactions Table    loop=3    payment_type=Payment

Verify That "Current Balance" Is Updated Based On Total Adjustment Amount
    [Documentation]    PP-9    PP-62    PP-63    PP-68    PP-69    PP-70
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=${add_adjustment_add_btn}    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=${add_adjustment_subtract_btn}    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1

Verify Unique Number Is Auto-Generated Per Charge Line
    [Documentation]    PP-15    PP-23    PP-24    PP-26    PP-27    PP-30    PP-31
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.
    ...    charge_amount_value=${None}
    ...    loop=3
    ...    add_charge_btn_status=${True}
    Verify All Lines Are Visible On Transactions Table    loop=3    payment_type=Charge

Verify Add Charge Unsuccessfully If Empty Required Fields
    [Documentation]    PP-16    PP-17    PP-20
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Leave Required Fields In Add Charge Modal

The "Charge Type" Dropdown Shows Default And Valid Value In Charge Modal
    [Documentation]    PP-18    PP-19
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Scroll And Click Element    ${payment_add_charge_btn}
    Wait Until Element Is Visible    ${add_charge_title}    30s
    ${charge_type_select_default}    Get Selected List Label    ${add_charge_type_select}
    Should Be Equal    ${charge_type_select_default}     -- Select a Charge Type --
    ${dropdown_options}    Create List    -- Select a Charge Type --    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${charge_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_charge_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${charge_type_select_options}

The "Transaction Date" Field Shows Default Value In Charge Modal
    [Documentation]    PP-21    PP-22
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${None}    
    ...    msg=${None} 
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${False}
    ${line}    Set Variable    1
    ${add_charge_transaction_date_input}    Replace Variables    ${add_charge_transaction_date_input}
    Clear Input Field Until Empty    ${add_charge_transaction_date_input}
    ${transaction_date_default}    SeleniumLibrary.Get Element Attribute    ${add_charge_transaction_date_input}    placeholder
    ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    Should Be Equal    ${transaction_date_default}    ${current_day}

Clicking The Delete Button To Remove The Charge Line
    [Documentation]    PP-25    PP-28    PP-29
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${None}    
    ...    msg=${None} 
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    Wait Until Element Is Not Visible    ${add_charge_first_row_btn}    30s
    ${line}    Set Variable    1
    Set Test Variable    ${charge_line}    ${TempData['charge_reference_number_value[${line}]']}
    Verify Remove Transaction Line When Clicking Delete Button    
    ...    remove_first_row_btn=${remove_charge_first_row_btn}    
    ...    transaction_row=${charge_row}    
    ...    new_balance=${add_charge_new_balance}

Verify Add Payment Unsuccessfully If Empty Required Fields
    [Documentation]    PP-37    PP-38    PP-40    PP-41
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Leave Required Fields In Add Payment Modal

The "Payment Method" Dropdown Shows Default And Valid Value In Payment Modal
    [Documentation]    PP-39    PP-40    PP-41    PP-44
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Scroll And Click Element    ${payment_add_payment_btn}
    Wait Until Element Is Visible    ${add_payment_title}    30s
    ${payment_type_select_default}    Get Selected List Label    ${add_payment_method_select}
    Should Be Equal    ${payment_type_select_default}     -- Select a Payment Method --
    ${dropdown_options}    Create List    -- Select a Payment Method --    Check    Credit Card    Cash    Wire
    ${payment_method_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_payment_method_select}
    Lists Should Be Equal    ${dropdown_options}    ${payment_method_select_options}

The "Payment Type" Dropdown Shows Default And Valid Value In Payment Modal
    [Documentation]    PP-42    PP-43
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Scroll And Click Element    ${payment_add_payment_btn}
    Wait Until Element Is Visible    ${add_payment_title}    30s
    ${payment_type_select_default}    Get Selected List Label    ${add_payment_type_select}
    Should Be Equal    ${payment_type_select_default}      -- Select a Payment Type --
    ${dropdown_options}    Create List     -- Select a Payment Type --    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${payment_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_payment_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${payment_type_select_options}

The "Transaction Date" Field Shows Default Value In Payment Modal
    [Documentation]    PP-45    PP-46
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${None}    
    ...    msg=${None} 
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${False}
    ${line}    Set Variable    1
    ${add_payment_transaction_date_input}    Replace Variables    ${add_payment_transaction_date_input}
    Clear Input Field Until Empty    ${add_payment_transaction_date_input}
    ${transaction_date_default}    SeleniumLibrary.Get Element Attribute    ${add_payment_transaction_date_input}    placeholder
    ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    Should Be Equal    ${transaction_date_default}    ${current_day}

Clicking The Delete Button To Remove The Payment Line
    [Documentation]    PP-47    PP-49    PP_54    PP-57    PP-58    PP-59
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${None}    
    ...    msg=${None} 
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    Wait Until Element Is Not Visible    ${add_payment_firts_row_btn}    30s
    ${line}    Set Variable    1
    Set Test Variable    ${payment_line}    ${TempData['payment_reference_number_value[${line}]']}
    Verify Remove Transaction Line When Clicking Delete Button    
    ...    remove_first_row_btn=${remove_payment_first_row_btn}    
    ...    transaction_row=${payment_row}    
    ...    new_balance=${add_payment_new_balance}

Verify Unique Number Is Auto-Generated Per Adjustment Line
    [Documentation]    PP-64    PP-72    PP-73
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=4
    Verify All Lines Are Visible On Transactions Table    loop=4    payment_type=Adjustment

Verify Add Adjustment Unsuccessfully If Empty Required Fields
    [Documentation]    PP-65    PP-66
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Leave Required Fields In Add Adjustment Modal

Clicking The Delete Button To Remove The Adjustment Line
    [Documentation]    PP-71
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${None}    
    ...    msg=${None} 
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    Wait Until Element Is Not Visible    ${add_adjustment_add_first_row_btn}    30s
    Wait Until Element Is Not Visible    ${add_adjustment_subtract_first_row_btn}    30s
    ${line}    Set Variable    1
    Set Test Variable    ${adjustment_line}    ${TempData['adjustment_reason_value[${line}]']}
    Verify Remove Transaction Line When Clicking Delete Button    
    ...    remove_first_row_btn=${remove_adjustment_first_row_btn}    
    ...    transaction_row=${adjustment_row}    
    ...    new_balance=${add_adjustment_new_balance}

The "Filter By Transaction Method" Dropdown Shows Default And Valid Value In Transactions Section
    [Documentation]    PP-74
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    ${transaction_method_select_default}    Get Selected List Label    ${filter_transaction_method_select}
    Should Be Equal    ${transaction_method_select_default}     All Transaction Methods
    ${dropdown_options}    Create List    All Transaction Methods    Adjustment    Charge    Payment
    ${transaction_method_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${filter_transaction_method_select}
    Lists Should Be Equal    ${dropdown_options}    ${transaction_method_select_options}

The "Filter By Transaction Type" Dropdown Shows Default And Valid Value In Transactions Section
    [Documentation]    PP-75
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    ${transaction_type_select_default}    Get Selected List Label    ${filter_transaction_type_select}
    Should Be Equal    ${transaction_type_select_default}     All Transaction Types
    ${dropdown_options}    Create List    All Transaction Types    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${transaction_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${filter_transaction_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${transaction_type_select_options}

The "Filter By Transaction Date" Field Shows Default Value In Transactions Section
    [Documentation]    PP-76    PP-77
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    ${transaction_date_default}    SeleniumLibrary.Get Element Attribute    ${filter_transaction_date_input}    placeholder
    ${current_day}    Get Current Date    result_format=%m/%d/%Y %H:%M:%S
    ${current_day}    Subtract Time From Date    ${current_day}    12 hour    result_format=%m/%d/%Y    date_format=%m/%d/%Y %H:%M:%S
    Should Be Equal    ${transaction_date_default}    ${current_day}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${filter_transaction_date_input} 
    Wait Until Element Is Visible    ${date_picker_table}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}

Selecting A Transaction Method Filters The Transaction List
    [Documentation]    PP-78    PP-82
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random  
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    ${method_list}    Create List    All Transaction Methods    Adjustment    Charge    Payment
    FOR    ${method_index}    IN ZIP    ${method_list}
        Set Test Variable    ${method_index}
        IF    '${method_index}' == 'All Transaction Methods'
            Filter All Transaction Methods On Transactions Table
        ELSE
            Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_method_select}    ${method_index}
            Verify Filtered Transaction Results On UI    expect_line=${method_line}
        END
    END

Selecting A Transaction Type Filters The Transaction List
    [Documentation]    PP-79    PP-83
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    @{type_list}    Create List    Office Copay Debit    Coinsurance Debit    Deductible Debit
    FOR    ${type_index}    IN    @{type_list}
        Get Current Balance Amount
        Add Charge    
        ...    btn_arg=${None}    
        ...    msg=${None}    
        ...    charge_amount_value=${None}
        ...    loop=1
        ...    add_charge_btn_status=${False}
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_charge_type_select}    ${type_index}
        Scroll And Click Element    ${add_charge_btn}
        Scroll And Click Element    ${add_charge_save_btn}
        Page Alert Message    Patient Balance Updated.
        Get Current Balance Amount
        Add Payment    
        ...    btn_arg=${None}    
        ...    msg=${None}    
        ...    payment_amount_value=${None}
        ...    loop=1
        ...    add_payment_btn_status=${False}
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_payment_type_select}    ${type_index}
        Scroll And Click Element    ${add_payment_btn}
        Scroll And Click Element    ${add_payment_save_btn}
        Page Alert Message    Patient Balance Updated.
        Get Current Balance Amount
        Add Adjustment    
        ...    tool_btn=${None}  
        ...    btn_arg=${None}    
        ...    msg=${None}  
        ...    adjustment_amount_value=${None}    
        ...    loop=1
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_adjustment_type_select}    ${type_index}
        Random Adjustment Button
        Scroll And Click Element    ${add_adjustment_save_btn}
        Page Alert Message    Patient Balance Updated.
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_type_select}    ${type_index}
        Set Test Variable    ${type_index}
        Verify Filtered Transaction Results On UI    expect_line=${type_line}
    END
    Filter All Transaction Types On Transactions Table
        
Selecting A Transaction Date Filters The Transaction List
    [Documentation]    PP-80
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    ${transaction_date}    Get Current Date    result_format=%m/%d/%Y
    ${transaction_date}    Subtract Time From Date    ${transaction_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Set Test Variable    ${line}    1
    Add Charge    
    ...    btn_arg=${None}    
    ...    msg=${None}    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${False}
    ${add_charge_transaction_date_input}    Replace Variables    ${add_charge_transaction_date_input}
    Clear Input Field Until Empty    ${add_charge_transaction_date_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_transaction_date_input}    ${transaction_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Scroll And Click Element    ${add_charge_btn}
    Scroll And Click Element    ${add_charge_save_btn}
    Page Alert Message    Patient Balance Updated.
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${None}    
    ...    msg=${None}    
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${False}
    ${add_payment_transaction_date_input}    Replace Variables    ${add_payment_transaction_date_input}
    Clear Input Field Until Empty    ${add_payment_transaction_date_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_payment_transaction_date_input}    ${transaction_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Scroll And Click Element    ${add_payment_btn}
    Scroll And Click Element    ${add_payment_save_btn}
    Page Alert Message    Patient Balance Updated.
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=${None}  
    ...    btn_arg=${None}    
    ...    msg=${None}  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    ${add_adjustment_transaction_date_input}    Replace Variables    ${add_adjustment_transaction_date_input}
    Clear Input Field Until Empty    ${add_adjustment_transaction_date_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_adjustment_transaction_date_input}    ${transaction_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Random Adjustment Button
    Scroll And Click Element    ${add_adjustment_save_btn}
    Page Alert Message    Patient Balance Updated.
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_transaction_date_input}    ${transaction_date}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Set Test Variable    ${date_index}    ${transaction_date}
    Verify Filtered Transaction Results On UI    expect_line=${date_line}

Selecting All Three Filters Together Applies Corect Filtering
    [Documentation]    PP-81    PP-84    PP-112
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    ${line}    Set Variable    1
    ${method_list}    Create List    
            ...    Charge
            ...    Payment
            ...    Adjustment
    ${type_list}    Create List    
            ...    ${TempData['add_charge_type_select[${line}]']}
            ...    ${TempData['add_payment_type_select[${line}]']}
            ...    ${TempData['add_adjustment_type_select[${line}]']}
    ${date_list}    Create List    
            ...    ${TempData['charge_transaction_date[${line}]']}
            ...    ${TempData['payment_transaction_date[${line}]']}
            ...    ${TempData['adjustment_transaction_date[${line}]']}
    FOR    ${method_index}    ${type_index}    ${date_index}    IN ZIP    ${method_list}    ${type_list}    ${date_list}
        Set Test Variable    ${method_index}
        Set Test Variable    ${type_index}
        Set Test Variable    ${date_index}
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_method_select}    ${method_index}
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${filter_transaction_type_select}    ${type_index}
        Wait Until Keyword Succeeds    30s    1s    Input Text    ${filter_transaction_date_input}    ${date_index}
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
        Verify Filtered Transaction Results On UI    expect_line=${method_line}
        Verify Filtered Transaction Results On UI    expect_line=${type_line}
        Filter All Three Filters With Default Value And Return Result
    END
    
Edit Transaction SuccessFully
    [Documentation]    PP-85    PP-90    PP-91    PP-92    PP-93    PP-94    PP-95    PP-96    PP-111    PP-113    
                ...    PP-114    PP-117    PP-118    PP-119    PP-120    PP-121    PP-122    PP-123    PP-124
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    Get Current Balance Amount
    Edit Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Transaction Updated.    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    Verify All Lines Are Visible On Transactions Table    loop=1    payment_type=Charge
    Get Current Balance Amount
    Add Payment    
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    Get Current Balance Amount
    Edit Payment
    ...    btn_arg=${add_payment_save_btn}    
    ...    msg=Patient Transaction Updated.  
    ...    payment_amount_value=${None}
    ...    loop=1
    ...    add_payment_btn_status=${True}
    Verify All Lines Are Visible On Transactions Table    loop=1    payment_type=Payment
    Get Current Balance Amount
    Add Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Balance Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    Get Current Balance Amount
    Edit Adjustment    
    ...    tool_btn=random    
    ...    btn_arg=${add_adjustment_save_btn}    
    ...    msg=Patient Transaction Updated.  
    ...    adjustment_amount_value=${None}    
    ...    loop=1
    Verify All Lines Are Visible On Transactions Table    loop=1    payment_type=Adjustment

Verify Validation Errors For Invalid Amount
    [Documentation]    PP-97    PP-98
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated.    
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    ${line}    Set Variable    1
    Open Edit Transaction Modal    payment_type=Charge    row_value=${TempData['charge_reference_number_value[${line}]']}
    ${add_charge_amount_input}    Replace Variables    ${add_charge_amount_input}
    Clear Input Field Until Empty    ${add_charge_amount_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_amount_input}    ${Fake_dict.sentence_str}
    Scroll And Click Element    ${add_charge_save_btn}
    Page Alert Message    Amount must be a valid number.
    Scroll And Click Element    ${add_charge_close_btn}
    
Verify Validation Errors For Restricted Transaction Dates
    [Documentation]    PP-99
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Get Current Balance Amount
    Add Charge    
    ...    btn_arg=${add_charge_save_btn}    
    ...    msg=Patient Balance Updated. 
    ...    charge_amount_value=${None}
    ...    loop=1
    ...    add_charge_btn_status=${True}
    ${line}    Set Variable    1
    Open Edit Transaction Modal    payment_type=Charge    row_value=${TempData['charge_reference_number_value[${line}]']}
    ${add_charge_transaction_date_input}    Replace Variables    ${add_charge_transaction_date_input}
    Clear Input Field Until Empty    ${add_charge_transaction_date_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${add_charge_transaction_date_input}    01/01/1752
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${Close_Calendar_Btn}
    Scroll And Click Element    ${add_charge_save_btn}
    Page Alert Message    SqlDateTime overflow. Must be between 1/1/1753 12:00:00 AM and 12/31/9999 11:59:59 PM.
    Scroll And Click Element    ${add_charge_close_btn}

Verify Edit Transaction Unsuccessfully If Empty Required Fields
    [Documentation]    PP-108
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Open Patient Payments Tab
    Leave Required Fields In Edit Charge Modal
    Leave Required Fields In Edit Payment Modal
    Leave Required Fields In Edit Adjustment Modal

Validation Of Date Range Filter Behavior And Input Rules
    [Documentation]    PP-127    PP-128    PP-132    PP-133    PP-134    PP-135    PP-136    PP-137    PP-147    PP-148
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Dispense Appointments For Patient Payments    loops=2
    Open Patient Payments Tab
    Verify Appointments Transaction Rows Are Visible    loops=2
    ${current_date}    Get Current Date    result_format=%m/%d/%Y
    ${start_date}    Subtract Time From Date    ${current_date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_date}    Add Time To Date    ${current_date}    30 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Filter By Date Range In Appointments Transaction    ${start_date}    ${end_date}
    Verify Appointments Transaction Rows Are Visible    loops=2
    Filter By Date Range In Appointments Transaction    ${start_date}    ${EMPTY}
    Verify Appointments Transaction Rows Are Visible    loops=2
    Verify The Date Fomat Is MM/DD/YYYY
    The Filter By Date Range Resets When Navigating Away From The Page
    
Verify "Filter By Appointment No" Field Functionality And Input Behavior
    [Documentation]    PP-138    PP-139    PP-140    PP-141    PP-142    PP-143    PP-144    PP-146
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Dispense Appointments For Patient Payments    loops=1
    Open Patient Payments Tab
    Filter By Appointment No Field Has Default Value
    Input Filter By Appointment No Field    apt_id_arg=${APT_data['apt_id[1]']}
    Verify Appointments Transaction Rows Are Visible    loops=1
    Input Filter By Appointment No Field    apt_id_arg=invalid appointment number
    Wait Until Element Is Visible    ${no_apt_available}    30s
    ${apt_id_has_space}    Set Variable    '    ${APT_data['apt_id[1]']}    '
    Input Filter By Appointment No Field    apt_id_arg=${apt_id_has_space}
    Verify Appointments Transaction Rows Are Visible    loops=1

Verify Appointments Transaction Table Has All Valid Columns
    [Documentation]    PP-149    PP-150    PP-152    PP-154    PP-155    PP-159
    [Tags]    Regression     Patient Payments
    ...  allure.label.owner: Hai Nguyen
    Navigate to Patient by Generated MRN
    Dispense Appointments For Patient Payments    loops=1
    Open Patient Payments Tab
    Appointments Transaction Table Is Sorted By Latest Date Of Service    apt_date_arg=${APT_data['apt_date[1]']}
    Input Filter By Appointment No Field    apt_id_arg=${APT_data['apt_id[1]']}
    Verify Appointments Transaction Rows Are Visible    loops=1
    Verify All Column Of Dispensed Appoinment

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${homepage}    ${SiteUrl}
    Set Suite Variable    ${location}    ${data_input}[location]
    Set Suite Variable    ${MRN}    ${data_input}[MRN]
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]
    Set Suite Variable    ${refering_provider}    ${data_input}[refering_provider]
    Set Suite Variable    ${weight_LB}    ${data_input}[weight_LB]
    Set Suite Variable    ${weight_KG}    ${data_input}[weight_KG]
    Set Suite Variable    ${drug_PO}    ${data_input}[drug_PO]
    
    Set To Dictionary    ${PatientData}    
    ...    Location=${location}    
    ...    Weight_LB=${weight_LB}    
    ...    Weight_KG=${weight_KG}    
    ...    Refering_Provider=${refering_provider}
    ...    drug_PO=${drug_PO}
    ...    MRN=${MRN}
    ...    MRN_merge=${MRN_merge}