*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${create_patient_addess_title}    //h4[contains(text(),'Create Patient Address')]
${update_patient_addess_title}    //h4[contains(text(),'Update Patient Address')]
${address_description}    //input[@id='Description']
${ship_to_address_line_1_input}    //input[@id='Address1']
${ship_to_address_line_2_input}    //input[@id='Address2']
${address_city_input}    //input[@id='City']
${address_state_select}    //select[@id='State']
${address_postal_code_input}    //input[@id='ZipCode']
${address_country_region_select}    //select[@id='CountryRegion']
${address_create_btn}    //button[@id='SaveBtn' and contains(text(),'Create')]
${address_close_btn}    (//button[@id='SaveBtn']/following::button)[1]
${address_update_btn}    //button[@id='SaveBtn' and contains(text(),'Update')]
${address_inactive_checkbox}    //input[@id='InactiveAddress']

*** Keywords ***
Create Address Create Dictionary
    &{AddressCreate_dict}    Create Dictionary
    RETURN    ${AddressCreate_dict}

Create Address Update Dictionary
    &{AddressUpdate_dict}    Create Dictionary
    RETURN    ${AddressUpdate_dict}

Input Description In Patient Address Popup
    [Arguments]    ${description_arg}
    Clear Input Field Until Empty    ${address_description}
    Input Text Into Field    ${address_description}    ${description_arg}
    
Input Ship To Address Line 1 In Patient Address Popup
    [Arguments]    ${address_first_arg}
    Clear Input Field Until Empty    ${ship_to_address_line_1_input}
    Input Text Into Field    ${ship_to_address_line_1_input}    ${address_first_arg}

Input Ship To Address Line 2 In Patient Address Popup
    [Arguments]    ${address_second_arg}
    Clear Input Field Until Empty    ${ship_to_address_line_2_input}
    Input Text Into Field    ${ship_to_address_line_2_input}    ${address_second_arg}

Input City In Patient Address Popup
    [Arguments]    ${city_arg}
    Clear Input Field Until Empty    ${address_city_input}
    Input Text Into Field    ${address_city_input}    ${city_arg}

Select State In Patient Address Popup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${address_state_select}    var_name=state    dic=${dict_arg}

Input Postal Code In Patient Address Popup
    [Arguments]    ${postal_code_arg}
    Clear Input Field Until Empty    ${address_postal_code_input}
    Input Text Into Field    ${address_postal_code_input}    ${postal_code_arg}

Select Country In Patient Address Popup
    [Arguments]    ${dict_arg}
    Common.Choose Random Value From Select List    xpath_arg=${address_country_region_select}    var_name=country_region    dic=${dict_arg}

Click Create Address Button
    Common.Scroll And Click Element    ${address_create_btn}

Click Close Address Button
    Common.Scroll And Click Element    ${address_close_btn}

Click Update Address Button
    Common.Scroll And Click Element    ${address_update_btn}

Click Update Inactive Checkbox
    Common.Scroll And Click Element    ${address_inactive_checkbox}

Fill In Valid Data Into Patient Address Popup
    [Arguments]    ${description_arg}    ${address_first_arg}    ${address_second_arg}    ${city_arg}    ${postal_code_arg}    ${dict_arg}
    Input Description In Patient Address Popup    ${description_arg}
    Input Ship To Address Line 1 In Patient Address Popup    ${address_first_arg}
    Input Ship To Address Line 2 In Patient Address Popup    ${address_second_arg}
    Input City In Patient Address Popup    ${city_arg}
    Select State In Patient Address Popup    ${dict_arg}
    Input Postal Code In Patient Address Popup    ${postal_code_arg}
    Select Country In Patient Address Popup    ${dict_arg}

Create Patient Address
    ${Fake_dict}    Generate Fake Data    sentence    address    country    postal_code
    ${AddressCreate_dict}    Create Address Create Dictionary
    Fill In Valid Data Into Patient Address Popup    
        ...    description_arg=${Fake_dict['sentence']}    
        ...    address_first_arg=${Fake_dict['address']}    
        ...    address_second_arg=${Fake_dict['address']}    
        ...    city_arg=${Fake_dict['country']}    
        ...    postal_code_arg=${Fake_dict['postal_code']}    
        ...    dict_arg=${AddressCreate_dict}
    Click Create Address Button
    Common.Page Alert Message    Address Successfully Created
    Click Close Address Button

    Set To Dictionary    ${AddressCreate_dict}    
        ...    description=${Fake_dict['sentence']}
        ...    address_first=${Fake_dict['address']} 
        ...    address_second=${Fake_dict['address']}   
        ...    city=${Fake_dict['country']}   
        ...    postal_code=${Fake_dict['postal_code']}  
    
    RETURN    ${AddressCreate_dict}

Update Patient Address
    ${Fake_dict}    Generate Fake Data    sentence    address    country    postal_code
    ${AddressUpdate_dict}    Create Address Update Dictionary
    Fill In Valid Data Into Patient Address Popup    
        ...    description_arg=${Fake_dict['sentence']}    
        ...    address_first_arg=${Fake_dict['address']}    
        ...    address_second_arg=${Fake_dict['address']}    
        ...    city_arg=${Fake_dict['country']}    
        ...    postal_code_arg=${Fake_dict['postal_code']}    
        ...    dict_arg=${AddressUpdate_dict}
    Click Update Address Button
    Common.Page Alert Message    Address Successfully Update
    Click Close Address Button 

    Set To Dictionary    ${AddressUpdate_dict}    
        ...    description=${Fake_dict['sentence']}
        ...    address_first=${Fake_dict['address']} 
        ...    address_second=${Fake_dict['address']}   
        ...    city=${Fake_dict['country']}   
        ...    postal_code=${Fake_dict['postal_code']}  

    RETURN    ${AddressUpdate_dict}

Remove Required Field In Patient Address Popup
    [Arguments]    ${locator}    ${msg_error}
    ${tag_name}    SeleniumLibrary.Get Element Attribute    ${locator}    tagName
    IF    '${tag_name}' == 'INPUT'
        Common.Clear Input Field Until Empty    ${locator}
    ELSE IF    '${tag_name}' == 'SELECT'
        Wait Until Keyword Succeeds    30s    1s    Select From List By Index    ${locator}    0
    END
    Click Update Address Button
    Common.Page Alert Message    ${msg_error}
    Click Close Address Button

Inactive Patient Address Row
    Click Update Inactive Checkbox
    Click Update Address Button
    Common.Page Alert Message    Address Successfully Updated.
    Click Close Address Button
    