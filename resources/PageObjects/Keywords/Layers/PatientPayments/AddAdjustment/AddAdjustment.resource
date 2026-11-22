*** Settings ***
Resource    ../../Common/Common.resource
Library    ../../Fakedata/FakeData.py

*** Variables ***
${payment_add_adjustment_btn}    //a[contains(text(),"Add Adjustment")]
${add_adjustment_title}    //h4[contains(text(),"Add Adjustment")]
${add_adjustment_type_select}    //select[@id="Type"]
${edit_adjustment_type_select}    //select[@id="item_Type"]
${add_adjustment_add_btn}    //a[contains(text(),"Add to Balance")]
${add_adjustment_add_first_row_btn}    //a[contains(@class,"AddAdjustmentToBalanceBtn") and @data-index="1"]
${add_adjustment_subtract_btn}    //a[contains(text(),"Subtract from Balance")]
${add_adjustment_subtract_first_row_btn}    //a[contains(@class,"RemoveAdjustmentFromBalanceBtn") and @data-index="1"]
${remove_adjustment_first_row_btn}    //a[contains(@class,"RemoveExisitingAdjustmentBtn") and @data-index="1"]
${add_adjustment_current_balance}    //strong[@id="AdjustmentModalCurrentBalance"]
${add_adjustment_new_balance}    //strong[@id="NewAdjustmentsBalance"]

*** Keywords ***
Created Adjustment Dictionary
    &{adjustment_dict}    Create Dictionary
    RETURN    ${adjustment_dict}

Input Amount In Add Adjustment Modal
    [Arguments]    ${amount_arg}    ${line}=1
    ${add_adjustment_amount_input}    Set Variable    (//input[contains(@class,"AdjustmentAmount")])[${line}]
    Common.Clear Input Field Until Empty    ${add_adjustment_amount_input}
    Common.Input Text Into Field    ${add_adjustment_amount_input}    ${amount_arg}

Select Adjustment Type In Add Adjustment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${add_adjustment_type_select}    var_name=adjustment_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${add_adjustment_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${add_adjustment_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    adjustment_type[${line}]=${value}
    END

Select Adjustment Type In Edit Adjustment Modal
    [Arguments]    ${dict_arg}    ${line}=1    ${value}=random
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_adjustment_type_select}    -- Select a Adjustment Type --
    Sleep    1s
    IF    '${value}' == 'random'
        Common.Choose Random Value From Select List    xpath_arg=${edit_adjustment_type_select}    var_name=adjustment_type[${line}]    dic=${dict_arg}
    ELSE
        Wait Until Element Is Enabled    ${edit_adjustment_type_select}    30s
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${edit_adjustment_type_select}    ${value}
        Set To Dictionary    ${dict_arg}    adjustment_type[${line}]=${value}
    END

The "Adjustment Type" Dropdown Shows Default And Valid Value In Charge Modal
    ${adjustment_type_select_default}    Get Selected List Label    ${add_adjustment_type_select}
    Should Be Equal    ${adjustment_type_select_default}      -- Select a Adjustment Type --
    ${dropdown_options}    Create List     -- Select a Adjustment Type --    Office Copay Debit    Coinsurance Debit    Deductible Debit
    ${adjustment_method_select_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${add_adjustment_type_select}
    Lists Should Be Equal    ${dropdown_options}    ${adjustment_method_select_options}

Input Adjustment Reason In Add Adjustment Modal
    [Arguments]    ${reason_arg}    ${line}=1
    ${add_adjustment_reason_input}    Set Variable    (//textarea[contains(@class,"PatientAdjustmentReason")])[${line}]
    Common.Clear Input Field Until Empty    ${add_adjustment_reason_input}
    Common.Input Text Into Field    ${add_adjustment_reason_input}    ${reason_arg}

Input Transaction Date In Add Adjustment Modal
    [Arguments]    ${transaction_date_arg}    ${line}=1
    ${add_adjustment_transaction_date_input}    Set Variable    (//input[contains(@class,"TransactionDatepicker")])[${line}]
    Common.Clear Input Field Until Empty    ${add_adjustment_transaction_date_input}
    Common.Input Text Into Field    ${add_adjustment_transaction_date_input}    ${transaction_date_arg}
    Common.Close Calendar Table

Random Adjustment Button
    ${tool_btn_list}    Create List    ${add_adjustment_add_btn}    ${add_adjustment_subtract_btn}
    ${tool_btn_random}    Evaluate    random.choice(${tool_btn_list})
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tool_btn_random}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]
    RETURN    ${tool_btn_random}

Click Add To Balance Button
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_adjustment_add_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Click Subtract From Balance Button
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_adjustment_subtract_btn}
    Common.Element Is Not Visible    //i[@class="fa fa-spinner fa-spin"]

Click Save Adjustment Button
    [Arguments]    ${msg}
    Common.Scroll And Click Element    //button[@id="SaveBtn" and contains(text(),"Save")]
    Common.Page Alert Message    ${msg}

Click Close Adjustment Button
    Common.Scroll And Click Element    //button[@id="SaveBtn" and contains(text(),"Save")]//following-sibling::button

Prepare Adjustment Data
    ${Fake_dict}    Generate Fake Data    decimal_2d_2f    sentence  
    ${amount_value}    Set Variable    ${Fake_dict['decimal_2d_2f']}
    ${result}    Get Incremental Dates
    ${transaction_date}    Get From Dictionary    ${result}    current_date
    ${reason_value}    Set Variable    ${Fake_dict['sentence']}
    RETURN    ${amount_value}    ${reason_value}    ${transaction_date}    

Input Adjustment Modal
    [Arguments]    ${adjustment_status}    ${loop}=1    ${tool_btn}=random    ${type_value}=random    
    ${adjustment_dict}    Created Adjustment Dictionary
    ${adjustment_amount_total}    Set Variable    0
    FOR    ${line}    IN RANGE    ${loop}
        ${line}    Set Variable    ${line+1}
        ${adjustment_amount_value}    ${adjustment_reason_value}    ${adjustment_transaction_date}    Prepare Adjustment Data
        Input Amount In Add Adjustment Modal    ${adjustment_amount_value}    ${line}
        IF    '${adjustment_status}' == 'Add Adjustment'
            Select Adjustment Type In Add Adjustment Modal    ${adjustment_dict}    ${line}    ${type_value}
        ELSE IF    '${adjustment_status}' == 'Edit Adjustment'
            Select Adjustment Type In Edit Adjustment Modal    ${adjustment_dict}    ${line}    ${type_value}
        END
        Input Adjustment Reason In Add Adjustment Modal    ${adjustment_reason_value}    ${line}
        Input Transaction Date In Add Adjustment Modal    ${adjustment_transaction_date}    ${line}
        IF    '${adjustment_status}' == 'Add Adjustment'
            IF    '${tool_btn}' == 'random'
                ${tool_btn}    Random Adjustment Button
                IF    '${tool_btn}' == '${add_adjustment_add_btn}'
                    ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} + ${adjustment_amount_value}):.2f}"
                ELSE IF    '${tool_btn}' == '${add_adjustment_subtract_btn}'
                    ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} - ${adjustment_amount_value}):.2f}"
                END
            ELSE IF    '${tool_btn}' == '${add_adjustment_add_btn}'
                Click Add To Balance Button
                ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} + ${adjustment_amount_value}):.2f}"
            ELSE IF    '${tool_btn}' == '${add_adjustment_subtract_btn}'
                Click Subtract From Balance Button
                ${adjustment_amount_total}    Evaluate    f"{(${adjustment_amount_total} - ${adjustment_amount_value}):.2f}"
            END
        END
        ${new_adjustment_balance_value}    Get Text    ${add_adjustment_new_balance}
        Set To Dictionary    ${adjustment_dict}    
            ...    adjustment_amount_value[${line}]=${adjustment_amount_value}
            ...    adjustment_reason_value[${line}]=${adjustment_reason_value}
            ...    adjustment_transaction_date[${line}]=${adjustment_transaction_date}
            ...    new_adjustment_balance_value[${line}]=${new_adjustment_balance_value}
            ...    tool_btn[${line}]=${tool_btn}
    END
    RETURN    ${adjustment_amount_total}    ${adjustment_dict}
