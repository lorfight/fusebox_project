*** Settings ***
Resource    ../../Common/Common.resource
Library    ../../Fakedata/FakeData.py

*** Variables ***
${payment_add_payment_btn}    //a[contains(text(),"Add Payment")]
${add_payment_title}    //h4[contains(text(),"Add Payment")]
${add_payment_method_select}    //select[@id="PaymentMethod"]
${edit_payment_method_select}    //select[@id="item_PaymentMethod"]
${add_payment_type_select}    //select[@id="Type"]
${edit_payment_type_select}    //select[@id="item_Type"]
${add_payment_firts_row_btn}    //a[contains(@class,"AddNewPaymentBtn") and @data-index="1"]
${remove_payment_first_row_btn}    //a[contains(@class,"RemoveExisitingPaymentBtn") and @data-index="1"]
${add_payment_current_balance}    //strong[@id="PaymentModalCurrentBalance"]
${add_payment_new_balance}    //strong[@id="NewPaymentsBalance"]

*** Keywords ***
Created Payment Dictionary
    &{payment_dict}    Create Dictionary
    RETURN    ${payment_dict}

Input Amount In Add Payment Modal
    [Arguments]    ${amount_arg}    ${line}=1
    ${add_payment_amount_input}    Set Variable    (//input[contains(@class,"PaymentAmount")])[${line}]
    Common.Clear Input Field Until Empty    ${add_payment_amount_input}
    Common.Input Text Into Field    ${add_payment_amount_input}    ${amount_arg}

Select Payment Method In Add Payment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${add_payment_method_select}    var_name=payment_method[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${add_payment_method_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_payment_method_select}    ${value}
        Set To Dictionary    ${dict_arg}    payment_method[${line}]=${value}
    END

Select Payment Method In Edit Payment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_payment_method_select}    -- Select a Payment Method --
    Sleep    1s
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${edit_payment_method_select}    var_name=payment_method[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${edit_payment_method_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_payment_method_select}    ${value}
        Set To Dictionary    ${dict_arg}    payment_method[${line}]=${value}
    END

The "Payment Method" Dropdown Shows Default And Valid Value In Payment Modal
    ${payment_type_select_default}    Get Selected List Label    ${add_payment_method_select}
    Should Be Equal    ${payment_type_select_default}     -- Select a Payment Method --
    ${dropdown_options}    Create List    -- Select a Payment Method --    Check    Credit Card    Cash    Wire
    ${payment_method_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_payment_method_select}
    Lists Should Be Equal    ${dropdown_options}    ${payment_method_select_options}

Select Payment Type In Add Payment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${add_payment_type_select}    var_name=payment_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${add_payment_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_payment_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    payment_type[${line}]=${value}
    END

Select Payment Type In Edit Payment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_payment_type_select}    -- Select a Payment Type --
    Sleep    1s
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${edit_payment_type_select}    var_name=payment_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${edit_payment_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_payment_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    payment_type[${line}]=${value}
    END

The "Payment Type" Dropdown Shows Default And Valid Value In Payment Modal
    ${payment_type_select_default}    Get Selected List Label    ${add_payment_type_select}
    Should Be Equal    ${payment_type_select_default}      -- Select a Payment Type --
    ${dropdown_options}    Create List     -- Select a Payment Type --    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${payment_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_payment_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${payment_type_select_options}

Input Reference Number In Add Payment Modal
    [Arguments]    ${reference_number_arg}    ${line}=1
    ${add_payment_reference_number_input}    Set Variable    (//input[contains(@class,"PaymentReferenceNumber")])[${line}]
    Common.Clear Input Field Until Empty    ${add_payment_reference_number_input}
    Common.Input Text Into Field    ${add_payment_reference_number_input}    ${reference_number_arg}

Input Transaction Date In Add Payment Modal
    [Arguments]    ${transaction_date_arg}    ${line}=1
    ${add_payment_transaction_date_input}    Set Variable    (//input[contains(@class,"TransactionDatepicker")])[${line}]
    Clear Input Field Until Empty    ${add_payment_transaction_date_input}
    Common.Input Text Into Field    ${add_payment_transaction_date_input}    ${transaction_date_arg}
    Common.Close Calendar Table

Click Add Payment Line Button
    ${add_payment_btn}    Set Variable    //a[contains(@class,"AddNewPaymentBtn")]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_payment_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Click Save Payment Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    //button[@id="SaveBtn" and contains(text(),"Save")]
    Common.Page Alert Message    ${msg}

Click Close Payment Button
    Common.Scroll And Click Element    //button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button

Prepare Payment Data
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f    full_name    num_rand    
    ${amount_value}    Set Variable    ${Fake_dict['decimal_2d_2f']}
    ${reference_number_value}    Set Variable    ${Fake_dict['full_name']} ${Fake_dict['num_rand']}
    ${result}    Get Incremental Dates
    ${transaction_date}    Get From Dictionary    ${result}    current_date
    RETURN    ${amount_value}    ${reference_number_value}    ${transaction_date}

Input Payment Modal
    [Arguments]    ${payment_status}    ${loop}=1    ${method_value}=random    ${type_value}=random
    ${payment_dict}    Created Payment Dictionary
    ${payment_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        ${payment_amount_value}    ${payment_reference_number_value}    ${payment_transaction_date}    Prepare Payment Data
        Input Amount In Add Payment Modal    ${payment_amount_value}    ${line}
        IF    '${payment_status}' == 'Add Payment'
            Select Payment Method In Add Payment Modal    ${payment_dict}    ${line}    ${method_value}
            Select Payment Type In Add Payment Modal    ${payment_dict}    ${line}    ${type_value}
        ELSE IF    '${payment_status}' == 'Edit Payment'
            Select Payment Method In Edit Payment Modal    ${payment_dict}    ${line}    ${method_value}
            Select Payment Type In Edit Payment Modal    ${payment_dict}    ${line}    ${type_value}
        END
        Input Reference Number In Add Payment Modal    ${payment_reference_number_value}    ${line}
        Input Transaction Date In Add Payment Modal    ${payment_transaction_date}    ${line}
        IF    '${payment_status}' == 'Add Payment'
            Click Add Payment Line Button
        END
        ${new_payment_balance_value}    Get Text    ${add_payment_new_balance}
        Set To Dictionary    ${payment_dict}    
        ...    payment_amount_value[${line}]=${payment_amount_value}
        ...    payment_reference_number_value[${line}]=${payment_reference_number_value}
        ...    payment_transaction_date[${line}]=${payment_transaction_date}
        ...    new_payment_balance_value[${line}]=${new_payment_balance_value}
        ${payment_amount_total}    Evaluate    f"{(${payment_amount_total} + ${payment_amount_value}):.2f}"
    END
    RETURN    ${payment_amount_total}    ${payment_dict}
