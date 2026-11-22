*** Settings ***
Resource    ../../../Layers/PriorAuthorizations/PriorAuthorizations.resource

*** Variables ***
${prior_authorizations_tab}    //a[@id='PriorAuthorization']

*** Keywords ***
Open Prior Authorizations Tab
    Wait Until Keyword Succeeds    30s    1    Scroll Element Into View    ${prior_authorizations_tab}
    Common.Scroll And Click Element    ${prior_authorizations_tab}
    Wait Until Element Is Visible    //th[contains(text(),'Expires In')]    30s

Hanlde Provider Order MDF
    Input Total Dosage In MDF    dosage_value=10
    Input Total Approved Visits In MDF    visit_value=20

Handle PA Status and Confirmation
    [Arguments]    ${status_list}    ${startdate_arg}    ${enddate_arg}    ${authdate_arg}    ${dict_arg}
    ${Fake_dict}    Generate Fake Data    num_rand    sentence
    Handle Prior Auth status    ${status_list}    ${dict_arg}
    Input Confirmation Number In PA Status and Confirmation    ${Fake_dict['num_rand']}
    Input Start Date In PA Status and Confirmation    ${startdate_arg}
    Input End Date In PA Status and Confirmation    ${enddate_arg}
    Input Auth Entry Date In PA Status and Confirmation    ${authdate_arg}
    Input RX Number    ${Fake_dict['num_rand']}
    Handle PA Medication Type    ${dict_arg}
    # Select Pharmacy    ${dict_arg}
    Input Other Payer Label    ${Fake_dict['sentence']}
    Set To Dictionary    ${dict_arg}
        ...    confirmation_number=${Fake_dict['num_rand']}
        ...    startdate=${startdate_arg}
        ...    enddate=${enddate_arg}
        ...    entrydate=${authdate_arg}
        ...    rx_number=${Fake_dict['num_rand']}
        ...    payer_label=${Fake_dict['sentence']}

Handle Payor Information and Margin Calculator
    [Arguments]    ${payer_name_arg}
    # Scroll Element Into View    //div[normalize-space()='Payor Information and Margin Calculator']//following-sibling::div[normalize-space()='Benefits Investigation']
    # Add New Payer With Required Fields    payer_name_arg=PA_PayerTest    address_arg=address_test
    Choose Payer In Payer Information and Margin Calculator    payer_name_arg=${payer_name_arg}
    Click Search Payer Button
    Verify Additional Prior Auth View
    Verify Payer Medication Search Results     label_arg=${payer_name_arg}

Handle Notes
    [Arguments]    ${utc}
    Scroll Element Into View    //div[normalize-space()='Notes']//following-sibling::div[@id="CoPayPanelDiv"]
    Page Should Contain    No Prior Authorization Notes Available
    ${random_txt}    Generate Random String    300    [LETTERS]
    Input Notes    ${random_txt}
    ${created_note_time}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    utc=${utc}
    ${created_note_time_add_1_minute}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    utc=${utc}    add_minutes=1
    Click Add Note
    ${user_name_txt}    Common.Get User Name
    ${note_txt}    Get Text    //div[@id="PriorAuthorizationNoteView"]//td
    ${check_equal}    Run Keyword And Return Status    Should Be Equal    ${note_txt}    ${created_note_time} - ${user_name_txt} : ${random_txt}
    Run Keyword If    "${check_equal}" == "${False}"    Should Be Equal    ${note_txt}    ${created_note_time_add_1_minute} - ${user_name_txt} : ${random_txt}

Handle Coding Details
    [Arguments]    ${expected_count}    ${expected_code_txt}
    Scroll Element Into View    //div[normalize-space()='Coding Details']//following-sibling::div[normalize-space()='Additional Tools']
    ${CPT_line}    Set Variable    //div[@id="AssignableCPTCodePreference"]//tr[not(@style="border-top: none;")]
    ${count}    SeleniumLibrary.Get Element Count    ${CPT_line}
    Should Be Equal    ${count}    ${expected_count}
    ${CPT_ckbx}    Set Variable    //*[contains(@onclick,'Toggle')]
    Checkbox Should Be Selected    ${CPT_ckbx}

Handle Addtional Tools
    Scroll Element Into View    //*[@id='ModalPopup']//*[contains(@class,'footer')]
    Wait Until Element Is Visible    //*[@id='PAModalProgressNote']/preceding::*[text()='Additional Tools'][1]    30s
    Element Should Be Visible    //*[normalize-space(text())='Trigger Reminder:']
    Element Attribute Value Should Be    //*[contains(@class,'Reminder') and @placeholder]    value    5
    Click Set Reminder Button

View PA Changelog
    PriorAuthorizations.Click View Change Button
    PriorAuthorizations.Click Close PA Changelog

Handle Prior Auth status
    [Arguments]    ${status_list}    ${dict_arg}
    ${status}    Evaluate    random.choice(${status_list})
    Check Prior Auth Status Has Default Value
    Select Prior Auth Status In PA Status and Confirmation    ${status}
    Set To Dictionary    ${dict_arg}    status=${status}

Check Prior Auth Status Has Default Value
    Wait Until Element Is Visible    ${pa_prior_auth_status_select}    30s
    ${list_status}    Wait Until Keyword Succeeds    30s    1    Get List Items    ${pa_prior_auth_status_select}
    ${option_status}    Create List    
        ...    -- Select A Status --
        ...    Waiting for PA Specialist
        ...    Gathering Information
        ...    Submitted/Pending
        ...    Approved
        ...    No Auth Req
        ...    SP Controls Auth
        ...    Denied/Peer to Peer
        ...    Denied/Appealed
        ...    Denied
        ...    Pending Financial
    Should Be Equal   ${list_status}    ${option_status}

Handle PA Medication Type
    [Arguments]    ${dict_arg}
    Check PA Medication Type Has Default Value
    Select PA Medication Type    ${dict_arg}

Check PA Medication Type Has Default Value
    Wait Until Element Is Visible    ${PA_medication_type_select}    30s
    ${list_type}    Wait Until Keyword Succeeds    30s    1    Get List Items    ${PA_medication_type_select}
    ${option_type}    Create List    
        ...    -- Select a Medication Type --
        ...    Buy and Bill
        ...    Specialty Pharmacy
        ...    Research
        ...    Medication Provided
        ...    Sample Drug
        ...    Private Pay
        ...    340B
    Should Be Equal   ${list_type}    ${option_type}

Verify Additional Prior Auth View
    ${element_list}    Create List
        ...    //*[contains(text(),'CPT 1') and contains(text(),'Allowable')]/following::*[@type='text'][1]
        ...    //*[contains(text(),'CPT') and contains(text(),'Extended')]/following::*[@type='text'][1]
        ...    //*[contains(text(),'HCPCS') and contains(text(),'Allowable')]/following::*[@type='text'][1]
        ...    //*[text()='Total Billable Units']/following::*[@type='text'][1]
        ...    //*[contains(text(),'HCPCS') and contains(text(),'Extended')]/following::*[@type='text'][1]
        ...    //*[contains(text(),'Total') and contains(text(),'Allowable')]/following::*[@type='text'][1]
        ...    //*[text()='Expected Cost']/following::*[@type='text'][1]
        ...    //*[text()='Excepted Margin']/following::*[@type='text'][1]

    FOR    ${element}    IN    @{element_list}
        Wait Until Element Is Visible    ${element}        
    END

Verify Payer Medication Search Results 
    [Arguments]    ${label_arg}
    Element Should Be Visible    //*[@id='RequiresPA']
    Element Should Be Visible    //*[@id='PayerDeniedLoadingDose']
    List Selection Should Be    ${PA_label_select}    \-- Select a Label --\
    Add Billing Label    ${label_arg}
    
Check Number of Active PAs
    SeleniumLibrary.Element Text Should Be    //*[@id='TotalActivePAs']    1

Check Location
    [Arguments]    ${location_arg}
    SeleniumLibrary.Element Text Should Be    //select[@id="ModalLocationID"]    ${location_arg}

Check Physician Order Num
    [Arguments]    ${po_num_arg}
    ${physician_order}    Get Text    //*[normalize-space(text())='Physician Order #:']/parent::* 
    Should Be Equal    ${physician_order}    Physician Order #: ${po_num_arg}    strip_spaces=True

Check Patient
    [Arguments]    ${patient_name_arg}
    ${pa_patient_select}    Set Variable    //*[@id='SelectedPatient']
    List Selection Should Be    ${pa_patient_select}    ${patient_name_arg}
    ${check}    SeleniumLibrary.Get Element Attribute    ${pa_patient_select}    class
    Should Contain    ${check}    disabled

Check DX Code
    [Arguments]    ${dx_arg}
    ${dxcode_txt}    Get Text   //div[label[text()='DX Code: ']]//a
    Should Contain    ${dx_arg}    ${dxcode_txt}    strip_spaces=True

Check Physician
    [Arguments]    ${physician_arg}
    ${pa_physician_select}    Set Variable    //*[@id='PerscribingPhysician']
    ${check}    Get Selected List Label    ${pa_physician_select}
    Should Contain    ${check}   ${physician_arg}
    Element Should Be Disabled    ${pa_physician_select}

Check Medication
    [Arguments]    ${medicaiton_arg}
    List Selection Should Be    ${pa_medication_select}    ${medicaiton_arg}
    Element Should Be Disabled    ${pa_medication_select}

Check Visit Dose
    [Arguments]    ${maint_dose_arg}
    Element Attribute Value Should Be    ${pa_visit_dose_input}    value    ${maint_dose_arg}
    Element Should Be Disabled    ${pa_visit_dose_input}

Check Route
    [Arguments]    ${route_arg}
    ${route_value}    SeleniumLibrary.Get Value    ${pa_route_input}
    Should Be Equal    ${route_value}    ${route_arg}    ignore_case=true
    Element Should Be Disabled    ${pa_route_input}

Check Frequency
    [Arguments]    ${frequency_value}    ${frequency_unit}
    List Selection Should Be    ${pa_frequency_value_select}    ${frequency_value}
    List Selection Should Be    ${pa_frequency_unit_select}    ${frequency_unit}
    Element Should Be Disabled    ${pa_frequency_value_select}
    Element Should Be Disabled    ${pa_frequency_unit_select}

Check Infused Over
    [Arguments]    ${infused_arg}
    List Selection Should Be    ${pa_infused_over_select}    ${infused_arg}
    Element Should Be Disabled    ${pa_infused_over_select}

Check Container Type
    [Arguments]    ${container_type_arg}
    Element Attribute Value Should Be    ${pa_container_type_input}    value    ${container_type_arg}
    Element Should Be Disabled    ${pa_container_type_input}

