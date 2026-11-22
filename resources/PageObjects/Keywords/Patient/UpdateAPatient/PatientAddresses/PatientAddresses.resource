*** Settings ***
Resource    ../../../Layers/PatientAddresses/PatientAddresses.resource

*** Variables ***
${patient_address_tab}    //a[@id='Address']
${address_title}    //h3[text()=' Addresses ']
${address_id_column}    (//th[contains(text(),'#')])[1]
${address_address_column}    (//th[contains(text(),'Address Line')])[1]
${address_city_column}    (//th[contains(text(),'City')])[1]
${address_state_column}    (//th[contains(text(),'State')])[1]
${address_zipcode_column}    (//th[contains(text(),'Zip Code')])[1]
${address_inactive_column}    (//th[contains(text(),'Inactive')])[1]

*** Keywords ***
Open Patient Addresses Tab
    Navigate To The Tab    
    ...    tab_name=${patient_address_tab}    
    ...    title_name=${address_title}

Open Created Patient Address
    [Arguments]    ${address_arg}
    ${address_row}    Set Variable    //tr[@class='addressRow']/td/span[1][contains(text(),'${address_arg}')]
    ${check_address_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${address_row}    3s
    IF    '${check_address_visible}' == '${True}'
        Common.Scroll And Click Element    ${address_row}
        Wait Until Element Is Visible    ${update_patient_addess_title}    30s
    ELSE
        Common.Scroll And Click Element    //a[contains(text(),"Next")]
        Open Created Patient Address    ${address_arg}
    END

Verify Inactive Icon Is Visible With Corresponding Patient Address
    [Arguments]    ${address_arg}
    ${address_inactive_icon}    Set Variable    //tr[@class='addressRow']/td/span[1][contains(text(),'${address_arg}')]//following::td[4]/span[@class="fa fa-check fa-lg"]
    Wait Until Element Is Visible    ${address_inactive_icon}    30s

Check Table Displays All Required Columns
    Wait Until Element Is Visible    ${address_id_column}    30s
    ${input_value_list}    Create List    ${address_id_column}    ${address_address_column}    ${address_city_column}    ${address_state_column}    ${address_zipcode_column}    ${address_inactive_column}
    ${compare_value_list}    Create List    '#'    'Address Line'    'City'    'State'    'Zip Code'    'Inactive'
    FOR    ${input_value}    ${compare_value}    IN ZIP    ${input_value_list}    ${compare_value_list}
        ${column_name}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${input_value}    
        Should Be Equal    '${column_name}'    ${compare_value}
    END