*** Settings ***
Resource    ../../Common/Common.resource
Library    ../../Fakedata/FakeData.py

*** Variables ***
${add_charge_type_select}    //select[@id="Type"]
${edit_charge_type_select}    //select[@id="item_Type"]
${add_charge_first_row_btn}    //a[contains(@class,"AddNewChargeBtn") and @data-index="1"]
${remove_charge_first_row_btn}    //a[contains(@class,"RemoveExisitingChargeBtn") and @data-index="1"]
${add_charge_current_balance}    //strong[@id="ChargeModalCurrentBalance"]
${add_charge_new_balance}    //strong[@id="NewChargesBalance"]

*** Keywords ***
Created Charge Dictionary
    &{charge_dict}    Create Dictionary
    RETURN    ${charge_dict}

Input Amount In Add Charge Modal
    [Arguments]    ${amount_arg}    ${line}=1
    ${add_charge_amount_input}    Set Variable    (//input[contains(@class,"ChargeAmount")])[${line}]
    Common.Clear Input Field Until Empty    ${add_charge_amount_input}
    Common.Input Text Into Field    ${add_charge_amount_input}    ${amount_arg}

Select Change Type In Add Charge Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${add_charge_type_select}    var_name=charge_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${add_charge_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_charge_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    charge_type[${line}]=${value}
    END

Select Change Type In Edit Charge Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_charge_type_select}    -- Select a Charge Type --
    Sleep    1s
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${edit_charge_type_select}    var_name=charge_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${edit_charge_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_charge_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    charge_type[${line}]=${value}
    END

The "Charge Type" Dropdown Shows Default And Valid Value In Charge Modal
    ${charge_type_select_default}    Get Selected List Label    ${add_charge_type_select}
    Should Be Equal    ${charge_type_select_default}     -- Select a Charge Type --
    ${dropdown_options}    Create List    -- Select a Charge Type --    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${charge_type_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_charge_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${charge_type_select_options}

Input Reference Number In Add Charge Modal
    [Arguments]    ${reference_number_arg}    ${line}=1
    ${add_charge_reference_number_input}    Set Variable    (//input[contains(@class,"ChargeReferenceNumber")])[${line}]
    Common.Clear Input Field Until Empty    ${add_charge_reference_number_input}
    Common.Input Text Into Field    ${add_charge_reference_number_input}    ${reference_number_arg}

Input Transaction Date In Add Charge Modal
    [Arguments]    ${transaction_date_arg}    ${line}=1
    ${add_charge_transaction_date_input}    Set Variable    (//input[contains(@class,"TransactionDatepicker")])[${line}]
    Common.Clear Input Field Until Empty    ${add_charge_transaction_date_input}
    Common.Input Text Into Field    ${add_charge_transaction_date_input}    ${transaction_date_arg}
    Common.Close Calendar Table

Click Add Charge Line Button
    ${add_charge_btn}    Set Variable    //a[contains(@class,"AddNewChargeBtn")]
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_charge_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Click Close Charge Button
    ${add_charge_close_btn}    Set Variable    //button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_charge_close_btn}

Click Save Charge Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    //button[@id="SaveBtn" and contains(text(),"Save")]
    Common.Page Alert Message    ${msg}

Prepare Charge Data
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f    full_name    num_rand    
    ${amount_value}    Set Variable    ${Fake_dict['decimal_2d_2f']}
    ${reference_number_value}    Set Variable    ${Fake_dict['full_name']} ${Fake_dict['num_rand']}
    ${result}    Get Incremental Dates
    ${transaction_date}    Get From Dictionary    ${result}    current_date
    RETURN    ${amount_value}    ${reference_number_value}    ${transaction_date}

Input Charge Modal
    [Arguments]    ${charge_status}    ${loop}=1    ${type_value}=random
    ${charge_dict}    Created Charge Dictionary
    ${charge_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        ${charge_amount_value}    ${charge_reference_number_value}    ${charge_transaction_date}    Prepare Charge Data
        Input Amount In Add Charge Modal    ${charge_amount_value}    ${line}
        IF    '${charge_status}' == 'Add Charge'
            Select Change Type In Add Charge Modal    ${charge_dict}    ${line}    ${type_value}
        ELSE IF    '${charge_status}' == 'Edit Charge'
            Select Change Type In Edit Charge Modal    ${charge_dict}    ${line}    ${type_value}
        END
        Input Reference Number In Add Charge Modal    ${charge_reference_number_value}    ${line}
        Input Transaction Date In Add Charge Modal    ${charge_transaction_date}    ${line}
        IF    '${charge_status}' == 'Add Charge'
            Click Add Charge Line Button
        END
        ${new_charge_balance_value}    Get Text    ${add_charge_new_balance}
        Set To Dictionary    ${charge_dict}    
            ...    charge_amount_value[${line}]=${charge_amount_value}
            ...    charge_reference_number_value[${line}]=${charge_reference_number_value}
            ...    charge_transaction_date[${line}]=${charge_transaction_date}
            ...    new_charge_balance_value[${line}]=${new_charge_balance_value}
        ${charge_amount_total}    Evaluate    f"{(${charge_amount_total} + ${charge_amount_value}):.2f}"
    END
    RETURN    ${charge_amount_total}    ${charge_dict}
