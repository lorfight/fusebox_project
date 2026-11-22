*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library         Collections
Library    ../../../libraries/CustomLibrary.py
Library    String
Library    DateTime
Library    XML
Variables       ../Locators/CommonLocator.py
Variables       ../Locators/PriorAuthorizationLocator.py
Variables       ../TestData/Testdata.py
Resource        ../../../libraries/Util.resource
Resource    ../../../resources/PageObjects/Keywords/RePatient.resource

*** Keywords ***

Create Dictionary Of PA Data
    &{PA_data}    Create Dictionary
    Set Suite Variable    ${PA_data}

Go to Prior Authorization Page
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${DispensingLink}
    Click Element    ${DispensingLink}
    Click Element    ${PA_link}
    Wait Until Keyword Succeeds    10    1    Title Should Be    Prior Authorization Ledger

Filter Location
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${location_PA_select}
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${location_PA_select}    ${location_arg}

Filter Patient
    [Arguments]    ${patient_arg}
    Wait Until Element Is Enabled    ${clear_patient_PA_btn}    60s
    Scroll Element Into View    ${clear_patient_PA_btn}
    Wait Until Element Is Visible    ${clear_patient_PA_btn}    60s
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${clear_patient_PA_btn}
    Sleep    2s
    Wait Until Keyword Succeeds    60s    1s    Input Text    ${filter_patient_PA_input}    ${patient_arg}
    Set Test Variable    ${patient}    ${PatientData.Last_Name}, ${PatientData.First_Name} \(${PatientData.DOB}\) MRN: ${PatientData.MRN}
    ${patient_PA_suggestion}    Util.Replace Xpath    xpath=${patient_PA_suggestion}
    Wait Until Element Is Visible    ${patient_PA_suggestion}    60s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${patient_PA_suggestion}

Filter Status
    [Arguments]    ${status_arg}
    Select From List By Label    ${filter_status_PA_select}    ${status_arg}

Filter Date Range
    [Arguments]    ${date_arg}
    Sleep    3s
    Scroll Element Into View    ${range_start_date_PA_input}
    Clear Element Text    ${range_start_date_PA_input}
    Input Text    ${range_start_date_PA_input}    ${date_arg}
    Scroll Element Into View    ${range_end_date_PA_input}
    Clear Element Text    ${range_end_date_PA_input}
    Sleep    2s
    Input Text    ${range_end_date_PA_input}    ${date_arg}
    Wait Until Keyword Succeeds    30s    1s   Scroll Element Into View    ${select_date_done_PA_btn}
    Wait Until Element Is Visible    ${select_date_done_PA_btn}    30s
    Sleep    3s
    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${select_date_done_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Wait Until Element Is Not Visible    ${select_date_done_PA_btn}    30s

Search Medication
    [Arguments]    ${med_arg}
    Clear Search Box    btn_arg=${clear_medication_btn}
    Input Text    ${filter_medication_PA_input}    ${med_arg}
    Click Button    ${find_medication_btn}

Clear Medication
    Clear Search Box    btn_arg=${clear_medication_btn}

Clear Payer And Confirmation Num Search
    Clear Search Box    btn_arg=${clear_payer_confirmation_num_btn}

Clear Search Box
    [Arguments]    ${btn_arg}
    Click Button    ${btn_arg}
    Execute JavaScript  document.activeElement.blur()

Filter Medication Type
    [Arguments]    ${type_arg}
    Select From List By Label    ${filter_medication_type_select}    ${type_arg}

Discontinue PA
    [Arguments]    ${xpath_arg}
    Util.Scroll Into Element And Click    xpath_arg=${xpath_arg}    retry_arg=20    time_arg=3s    kw_arg=Click Element
    Scroll Element Into View    ${PA_update_btn}
    Wait Until Element Is Visible    ${PA_update_btn}    60s
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${PA_update_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        Scroll Element Into View    ${PA_accept_button}
        Wait Until Element Is Visible     ${PA_accept_button}    60s
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${PA_accept_button}
    END
    Util.Wait For Page Loading    element_arg=Prior Authorization Successfully Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Scroll Element Into View    ${xpath_arg}
    Wait Until Element Is Visible    ${xpath_arg}
    ${is_discontinued}    SeleniumLibrary.Get Element Attribute    ${xpath_arg}    checked
    Should Be Equal As Strings    ${is_discontinued}    true    ignore_case=True

Click Search PA
    Sleep    3s
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${search_PA_btn}
    Util.Wait For Page Loading    element_arg=${PA_list_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Find PA
    [Arguments]    ${PO_arg}
    Set Test Variable    ${PO_num}    ${PO_arg}
    ${PA_row}    Util.Replace Xpath    xpath=${PA_row}
    ${check}    Run Keyword And Return Status   Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    ${PA_row}
    IF    ${check} == ${False}
        Dictionary Should Contain Item    ${PO_data}    Is_Active    ${False}
        Pass Execution    PA inactive
    END

    Check PA Not Duplicated    xpath_arg=${PA_row}    # only 1 PO row with exact PO number on PO page
    Set Test Variable    ${PA_row}

Click Edit PA Button
    ${edit_PA_btn}    Util.Replace Xpath    ${edit_PA_btn}
    Sleep    1s
    Util.Scroll To Bottom
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    ${edit_PA_btn}    30s
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate(" ${edit_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    ELSE
        Wait Until Keyword Succeeds    10 times    3s    Click Element    ${edit_PA_btn}
    END
    Wait Until Element Is Visible    ${PA_header_text}    30s

Check PA Not Duplicated
    [Arguments]    ${xpath_arg}
    ${check_list}    Wait Until Keyword Succeeds    10s    1s    Get WebElements    ${xpath_arg}
    ${check_count}    Get Length    ${check_list}
    Should Be Equal As Integers    ${check_count}    1

Initialize PA
    # input initial info to PA
    [Arguments]    ${status_arg}    ${start_date_arg}    ${end_date_arg}    ${type_arg}
    Scroll Element Into View    ${PA_status_confirmation_text}
    Set PA Confirmation Number
    PriorAuthorization.Update PA    status_arg=${status_arg}    start_arg=${start_date_arg}    end_arg=${end_date_arg}    type_arg=${type_arg}    #Buy and Bill

Set PA Confirmation Number
    ${confirm_num}    Remove String    ${PO_data.PO_Num}    \-\
    Wait Until Keyword Succeeds    5s    1s    Input Text    ${PA_confirm_num_input}    PA-${confirm_num}
    Util.Add To Dictionary    dic_arg=${PA_data}    key_arg=PA_Num    val_arg=PA-${confirm_num}

Set PA Date Range
    [Arguments]    ${start_date_arg}    ${end_date_arg}
    Clear Element Text    ${PA_start_date_input}
    Input Text    ${PA_start_date_input}    ${start_date_arg}
    Wait Until Element Is Visible    //*[contains(@id,'ui-datepicker')]    30s
    Clear Element Text    ${PA_end_date_input}
    Input Text    ${PA_end_date_input}    ${end_date_arg}
    Wait Until Element Is Visible   //*[contains(@id,'ui-datepicker')]    30s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Click Button    ${select_date_done_PA_btn}
    IF    ${check} == ${False}    #button covered    #PROD
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate(" ${select_date_done_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    Clear Element Text    //*[@id='ModalEntryDate']
    Input Text    ${PA_auth_date_input}    ${start_date_arg}
    Wait Until Element Is Visible   //*[contains(@id,'ui-datepicker')]    30s
    Execute JavaScript    document.activeElement.blur()
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Click Button    ${select_date_done_PA_btn}
    IF    ${check} == ${False}    #button covered    #PROD
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate(" ${select_date_done_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    Set To Dictionary    ${PA_data}    Start_Date=${start_date_arg}    End_Date=${end_date_arg}    Entry_Date=${start_date_arg}
    Set Test Variable    ${PA_data}

Select PA Medication Type
    [Arguments]    ${type_arg}
    Select From List By Label    ${PA_medication_type_select}    ${type_arg}    #Buy and Bill
    Util.Add To Dictionary    dic_arg=${PA_data}    key_arg=Medication_Type    val_arg=${type_arg}    #Buy and Bill

Click Update Button
    Sleep    1s
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PA_update_btn}
    Click Button    ${PA_update_btn}
    ${is_have_payer_plan}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id='SubModalPopup']//*[text()='Payer Plan Information']    10s
    IF    ${is_have_payer_plan} == ${True}
        Wait Until Keyword Succeeds    10 times    3s    Input Text    ${PA_payer_plan_sub_num_input}    1234
        Input Text    ${PA_payer_plan_group_num_input}    12345
        ${date}    CustomLibrary.Get Time Now
        ${date}    Convert Date    ${date}    result_format=%m/%d/%Y
        Input Text    ${PA_payer_plan_effect_date_input}    ${date}
        ${date}    Add Time To Date    ${date}    364 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
        Input Text    ${PA_payer_plan_expire_date_input}    ${date}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@type='button' and text()='Done']
        Click Button    ${select_date_done_PA_btn}
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[@type='button' and text()='Done']
        Click Button    ${PA_new_payer_add_button}
        Wait Until Page Contains    Payer added to Patient    15s
        Wait Until Page Does Not Contain    Payer added to Patient    15s
    END
    Sleep    1s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        Scroll Element Into View    //*[@id='SaveBtn' and text()='Accept']
        Wait Until Element Is Visible     //*[@id='SaveBtn' and text()='Accept']    60s
        Wait Until Keyword Succeeds    30s    1s    Click Button    //*[@id='SaveBtn' and text()='Accept']
    END
    Util.Wait For Page Loading    element_arg=Prior Authorization Successfully Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PA_update_btn}
    Click Button    ${PA_update_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s     1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[text()='Prior Authorization - Summary']
    IF    ${check} == ${True}
        Scroll Element Into View    //*[@id='SaveBtn' and text()='Accept']
        Click Button    //*[@id='SaveBtn' and text()='Accept']
        Wait Until Element Is Not Visible    //*[@id='SubModalPopup']//*[text()='Prior Authorization - Summary']    30s
    END
    Util.Wait For Page Loading    element_arg=Prior Authorization Sccuessfully Updated    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s

Check PA Row
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${PA_row}
    Check Expires In On PA Row
    Check Patient On PA Row
    Check Medication On PA Row
    Check Status On PA Row
    Check DX Code On PA Row
    Check PA Num On PA Row

Check Expires In On PA Row
    Set Test Variable    ${PO_num}    ${PO_data.PO_Num}
    ${PA_row_expires_text}    Util.Replace Xpath    ${PA_row_expires_text}
    ${expires}    Get Text    ${PA_row_expires_text}
    ${today_location}    Util.Check Time Zone
    ${time_to_today}    Subtract Date From Date    ${today_location}    ${PA_data.Start_Date}    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y    #time_to_day: time from start date to today
    ${expiration}    Subtract Date From Date    ${PA_data.End_Date}    ${PA_data.Start_Date}    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${today_location}    Convert Date    ${today_location}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${today_location}    Evaluate    "/".join(part.lstrip("0") for part in "${today_location}".split("/"))
    IF    "${today_location}" == "${PA_data.Start_Date}"
        Should Be Equal    ${time_to_today}    0 seconds
        ${time_to_today}    Set Variable    0
    ELSE
        ${time_to_today}    Get Regexp Matches    ${time_to_today}   .*(?=\ day)
    END
    ${expiration}    Get Regexp Matches    ${expiration}    .*(?=\ day)
    ${check}    Evaluate    ${expiration}[0] - ${time_to_today}[0] - 1
    Should Be Equal As Strings    ${check} Days    ${expires}    strip_spaces=True
    Set Test Variable    ${PO_num}    ${PO_data.PO_Num}
    ${PA_row_assigned_specialist_select}    Util.Replace Xpath    xpath=${PA_row_assigned_specialist_select}
    List Selection Should Be    ${PA_row_assigned_specialist_select}    \-- Assign to User --\

Check Patient On PA Row
    ${PA_row_patient_link}    Util.Replace Xpath    xpath=${PA_row_patient_link}
    SeleniumLibrary.Element Text Should Be    ${PA_row_patient_link}    ${PatientData.First_Name} ${PatientData.Last_Name}
    ${PA_row_DOB_text}    Util.Replace Xpath    xpath=${PA_row_DOB_text}
    ${DOB}    Get Text    ${PA_row_DOB_text}
    Should Be Equal    ${DOB}    DOB: ${PatientData.DOB}

Check Medication On PA Row
    ${PA_row_medication_text}    Util.Replace Xpath    xpath=${PA_row_medication_text}
    ${medication}    Get Text    ${PA_row_medication_text}
    Should Be Equal    ${medication}    ${PO_data.Medication}    strip_spaces=True    #check medication
    ${PA_row_dose_frequency_text}    Util.Replace Xpath    xpath=${PA_row_dose_frequency_text}
    ${dose_frequency}    Get Text    ${PA_row_dose_frequency_text}
    ${dose_frequency}    Fetch From Right    ${dose_frequency}    \: \
    ${maint_dose}    Replace String    ${PO_data.Maint_Dose}    mgs    Milligrams
    Should Be Equal    ${dose_frequency}    ${maint_dose} Every ${PO_data.Dose_Frequency}    #check frequency

Check Status On PA Row
    ${PA_row_status_text}    Util.Replace Xpath    xpath=${PA_row_status_text}
    ${status}    Get Text    ${PA_row_status_text}
    ${check}    Run Keyword And Return Status    Should Be Equal    ${status}    Gathering Information    strip_spaces=True    #check status    #issue
    IF    ${check} == ${False}
        Should Be Equal    ${status}    Requires Activation
    END
    ${PA_row_date_range_text}    Util.Replace Xpath    xpath=${PA_row_date_range_text}
    ${date_range}    Get Text    ${PA_row_date_range_text}
    Should Be Equal    ${date_range}    ${PA_data.Start_Date} - ${PA_data.End_Date}    strip_spaces=True    #check date range

Check DX Code On PA Row
    ${PA_row_DX_text}    Util.Replace Xpath    xpath=${PA_row_DX_text}
    ${DX}    Get Text    ${PA_row_DX_text}
    Should Be Equal    ${DX}    ${PO_data.DX_Code}    strip_spaces=True    #check DX code
    ${PA_row_medication_type_text}    Util.Replace Xpath    xpath=${PA_row_medication_type_text}
    ${medication_type}    Get Text    ${PA_row_medication_type_text}
    Should Be Equal    ${medication_type}    ${PA_data.Medication_Type}    strip_spaces=True    #check medication type

Check PA Num On PA Row
    ${PA_row_PA_num_text}    Util.Replace Xpath    xpath=${PA_row_PA_num_text}
    ${num}    Get Text    ${PA_row_PA_num_text}
    Should Be Equal    ${num}    ${PA_data.PA_Num}

Click PA Row
    Sleep    1s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PA_row}
    Wait Until Element Is Visible    ${PA_header_text}    60s

Check PA Header
    [Arguments]    ${location_arg}
    Check Location    location_arg=${location_arg}
    Check Physician Order Num
    Check Patient
    Check DX
    Check Physician
    Set To Dictionary    ${PatientData}    Location_2=${location_arg}
    Set Test Variable    ${PatientData}

Check Location
    [Arguments]    ${location_arg}
    ${location}    Get Text    ${PA_location_text}
    ${location}    Get Regexp Matches    ${location}    (?<=Location: ).*?(?=\ *$)
    Should Be Equal    ${location}[0]    ${location_arg}    strip_spaces=True

Check Physician Order Num
    ${physician_order}    Get Text    ${PA_physician_order_text}    
    Should Be Equal    ${physician_order}    Physician Order #: ${PO_data.PO_Num}    strip_spaces=True

Check Patient
    # ${check}    Run Keyword And Return Status    Select From List By Index    ${PA_patient_select}    1
    IF    '${testing_type}' == 'smoke'
        ${smoke_patientname}    Run Keyword And Return Status    List Selection Should Be    ${PA_patient_select}    ${PatientData.Last_Name}, ${PatientData.First_Name} \(${PatientData.DOB}\) MRN: ${PatientData.MRN}
    ELSE IF    '${testing_type}' == 'regression'
        ${regression_patientname}    Run Keyword And Return Status    List Selection Should Be    ${PA_patient_select}    ${PatientData.Last_Name}, ${PatientData.Middle_Name} ${PatientData.First_Name} \(${PatientData.DOB}\) MRN: ${PatientData.MRN}
    END
    ${check}    SeleniumLibrary.Get Element Attribute    ${PA_patient_select}    class
    Should Contain    ${check}    disabled

Check DX
    Click Element    ${PA_DX_link}
    ${DX}    Get Text    ${PA_DX_link}
    Should Be Equal    ${DX}    ${PO_data.DX_Code}    strip_spaces=True

Check Physician
    ${name}    Fetch From Left    ${PO_data.Referring_Provider}    \ NPI\
    ${name}    Convert To Lower Case    ${name}
    ${name}    Convert To Title Case    ${name}
    ${npi}    Fetch From Right    ${PO_data.Referring_Provider}    \NPI: \
    ${check}    Get Selected List Label    ${PA_physician_select}
    Should Be Equal    ${check}    ${name} ( NPI# : ${npi} )
    Element Should Be Disabled    ${PA_physician_select}

Check Provider Order MDF
    [Arguments]    ${dose_freq_arg}    ${num_arg}    ${container_arg}
    Check Medication
    Check Visit Dose
    Check Frequency    dose_freq_arg=${dose_freq_arg}
    Check Infused Over    dose_freq_arg=${dose_freq_arg}    num_arg=${num_arg}
    # Check Container Type    container_arg=${container_arg}

Check Medication
    List Selection Should Be    ${PA_medication_select}    ${PO_data.Medication}
    ${check}    SeleniumLibrary.Get Element Attribute    ${PA_medication_select}    class
    Element Should Be Disabled    ${PA_medication_select}

Check Visit Dose
    ${check}    Fetch From Left    ${PO_data.Maint_Dose}    ${SPACE}
    Element Attribute Value Should Be    ${PA_visit_dose}    value    ${check}
    Element Should Be Disabled    ${PA_visit_dose}

Check Frequency
    [Arguments]    ${dose_freq_arg}
    ${dose}    Fetch From Left    ${dose_freq_arg}    ${SPACE}
    ${time}    Fetch From Right    ${dose_freq_arg}    ${SPACE}
    List Selection Should Be    ${PA_frequency_select}    ${dose}
    ${check}    Get Selected List Label    ${PA_frequency_time_select}
    Should Be Equal    ${check}    ${time}
    Element Should Be Disabled    ${PA_frequency_select}
    Element Should Be Disabled    ${PA_frequency_time_select}

Check Infused Over
    [Arguments]    ${time_arg}    ${num_arg}
    ${time}    Fetch From Right    ${time_arg}    ${SPACE}
    ${time}    Remove String    ${time}    (    )
    List Selection Should Be    ${PA_infused_over_select}    ${num_arg} ${time}
    Element Should Be Disabled    ${PA_infused_over_select}

Check Container Type
    [Arguments]    ${container_arg}
    Element Attribute Value Should Be    ${PA_container_type_select}    value    ${container_arg}    #issue - PO >< PA (Vial)
    Element Should Be Disabled    ${PA_container_type_select}

Check PA Status And Confirmation
    [Arguments]    ${status_arg}
    Scroll Element Into View    ${PA_status_confirmation_text}
    IF    "${testing_type}" == "regression"
        ${style}    SeleniumLibrary.Get Element Attribute    //*[@id='PAStatusDiv']    Style
        Should Contain    ${style}    background-color: rgb\(69, 157, 44)
    END
    Check PA Status    status_arg=${status_arg}
    Check Confirmation Num
    Check Date Range
    Check Medication Type

Check PA Status
    [Arguments]    ${status_arg}
    ${check}    Run Keyword And Return Status    List Selection Should Be    ${PA_status_select}    ${status_arg}
    IF    ${check} == ${False}
        List Selection Should Be    ${PA_status_select}    \-- Select A Status --\    #issue
    END
    Element Should Be Disabled    ${PA_status_select}

Check Confirmation Num
    Element Attribute Value Should Be    ${PA_confirm_num_input}    value    ${PA_data.PA_Num}
    Element Should Be Disabled    ${PA_confirm_num_input}

Check Date Range
    ${start}    Convert Date    ${PA_data.Start_Date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${start}    Evaluate    "/".join(part.lstrip("0") for part in "${start}".split("/"))
    Element Attribute Value Should Be    ${PA_start_date_input}    value    ${start}
    Element Should Be Disabled    ${PA_start_date_input}
    ${end}    Convert Date    ${PA_data.End_Date}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${end}    Evaluate    "/".join(part.lstrip("0") for part in "${end}".split("/"))
    Element Attribute Value Should Be    ${PA_end_date_input}    value    ${end}
    Element Should Be Disabled    ${PA_end_date_input}

Check Medication Type
    List Selection Should Be    ${PA_medication_type_select}    ${PA_data.Medication_Type}

Check Payor And Margin
    Check Payor Medication

Check Payor Medication
    List Selection Should Be    ${PA_payor_medication_select}    ${PO_data.Medication}

Close Modal
    Sleep    5s
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${close_PA_btn}
    Wait Until Element Is Visible    ${close_PA_btn}    30s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Click Button    ${close_PA_btn}
    IF    ${check} == ${False}    #button covered    #PROD
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${close_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    Wait Until Element Is Not Visible    ${PA_modal}    30s

Close Submodal
    Sleep    1s
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    ${close_submodal_btn}
    Wait Until Element Is Visible    ${close_submodal_btn}    60s
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${close_submodal_btn}
    Wait Until Element Is Not Visible    //*[@id='SubModalPopup']//*[@class='modal-content']    60s

Update PA
    [Arguments]    ${status_arg}    ${start_arg}    ${end_arg}    ${type_arg}
    Update Status    status_arg=${status_arg}
    ${start_arg}    Add Time To Date    ${start_arg}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    ${end_arg}    Add Time To Date    ${end_arg}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Update Date Range    ${start_arg}    ${end_arg}
    ${is_covered}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Click Button    ${select_date_done_PA_btn}
    Run Keyword If    ${is_covered} == ${False}
    ...    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${select_date_done_PA_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Update Medication Type    type_arg=${type_arg}

Update Status
    [Arguments]    ${status_arg}
    Select From List By Label    ${PA_status_select}    ${status_arg}
    ${is_contained}    Run Keyword And Return Status    Dictionary Should Contain Key    ${PA_data}    Old_Status
    Run Keyword If    ${is_contained}    Set To Dictionary    ${PA_data}    Old_Status=${PA_data.Status}
    Set To Dictionary    ${PA_data}    Status=${status_arg}
    Set Test Variable    ${PA_data}

Update Date Range
    [Arguments]    ${start_arg}    ${end_arg}
    ${new_start_date}    Add Time To Date    ${start_arg}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Update Text Field    xpath_arg=${PA_start_date_input}    new_value_arg=${new_start_date}
    ${new_end_date}    Add Time To Date    ${end_arg}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Update Text Field    xpath_arg=${PA_end_date_input}    new_value_arg=${new_end_date}
    Set To Dictionary    ${PA_data}    Old_Start_Date=${start_arg}    Start_Date=${new_start_date}    Old_End_Date=${end_arg}    End_Date=${new_end_date}
    Set Test Variable    ${PA_data}

Update Medication Type
    [Arguments]    ${type_arg}
    Select From List By Label    ${PA_medication_type_select}    ${type_arg}
    Set To Dictionary    ${PA_data}    Medication_Type=${type_arg}
    Set Test Variable    ${PA_data}

Reselect field
    [Arguments]    ${xpath_arg}    ${remove_default_arg}    ${old_value_arg}
    ${list_options}    Wait Until Keyword Succeeds    10s    1s    Get List Items    ${xpath_arg}
    IF    ${remove_default_arg} == ${True}
        Remove From List    ${list_options}    0
    END
    Remove Values From List    ${list_options}    ${old_value_arg}
    ${new_value}    Evaluate    random.choice(${list_options})
    Wait Until Keyword Succeeds    10s    1s    Select From List By Label    ${xpath_arg}    ${new_value}
    RETURN    ${new_value}

Update Text Field
    [Arguments]    ${xpath_arg}    ${new_value_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${xpath_arg}
    Input Text    ${xpath_arg}    ${new_value_arg}
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()

Check PA Discontinued
    [Arguments]    ${PO_arg}
    Set Test Variable    ${PO_num}    ${PO_arg}
    ${PA_discontinue_text}    Util.Replace Xpath    xpath=${PA_discontinue_text}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PA_discontinue_text}
    ${check}    Get Text    ${PA_discontinue_text}
    Should Be Equal    ${check}    Service Discontinued - ${PO_data.Medication}    strip_spaces=True

Find PA Created For Regression
    PriorAuthorization.Filter Location    location_arg=${PatientData.Location}
    PriorAuthorization.Filter Patient    patient_arg=${PatientData.MRN}
    PriorAuthorization.Filter Status    status_arg=\-- All Statuses --\
    PriorAuthorization.Filter Date Range    date_arg=${EMPTY}    #first PA created with no start/exp date
    PriorAuthorization.Clear Medication
    PriorAuthorization.Clear Payer And Confirmation Num Search
    PriorAuthorization.Filter Medication Type    type_arg=\-- All Medication Types --\
    PriorAuthorization.Click Search PA
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}    #find PA by PO num

Input MDF in PA For Regression
    Scroll Element Into View    ${PA_total_dosage_input}
    Wait Until Element Is Visible    ${PA_total_dosage_input}    30s
    Input Text    ${PA_total_dosage_input}    10
    Input Text    ${PA_total_approved_visits_input}    20

Input Status And Confirmation In PA For Regression
    Scroll Element Into View    //*[text()='Payor Information and Margin Calculator' and following::*[@id='PriorAuthSearchMedication'][1]]
    Wait Until Element Is Visible    //*[text()='Payor Information and Margin Calculator' and following::*[@id='PriorAuthSearchMedication'][1]]    15s
    ${style}    SeleniumLibrary.Get Element Attribute    //*[@id='PAStatusDiv']    Style
    Should Contain    ${style}    background-color: rgb\(212, 44, 19)
    ${list_status}    Get List Items    ${PA_status_select}
    ${option_status}    Evaluate    \['-- Select A Status --','Waiting for PA Specialist','Gathering Information','Submitted/Pending','Approved','No Auth Req','SP Controls Auth','Denied/Peer to Peer','Denied/Appealed','Denied','Pending Financial']
    ${check}    Evaluate    set(${option_status}) == set(${list_status})
    Should Be Equal    ${check}    ${True}
    ${status}    Evaluate    random.choice(${PA_green_status})
    Set To Dictionary    ${PA_data}    Status=${null}
    PriorAuthorization.Update Status    status_arg=${status}
    PriorAuthorization.Set PA Confirmation Number
    ${date}    Add Time To Date    ${PO_data.Exp_Date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    PriorAuthorization.Set PA Date Range    start_date_arg=${date}    end_date_arg=${PO_data.Exp_Date}
    ${list_type}    Get List Items    ${PA_medication_type_select}
    ${option_type}    Evaluate    \['-- Select a Medication Type --','Buy and Bill','Specialty Pharmacy','Research','Medication Provided','Sample Drug','Private Pay','340B']
    ${check}    Evaluate    set(${option_type}) == set(${list_type})
    Should Be Equal    ${check}    ${True}
    Input Text    ${PA_RX_input}    12345
    Remove From List    ${list_type}    0
    ${type}    Evaluate    random.choice(${list_type})
    PriorAuthorization.Select PA Medication Type    type_arg=${type}
    Input Text    ${PA_other_label_input}    test label
    Set Test Variable    ${PA_data}

Input Payor And Margin In PA For Regression
    Scroll Element Into View    ${PA_label_select}/following::*[text()='Benefits Investigation']
    Wait Until Element Is Visible    ${PA_label_select}/following::*[text()='Benefits Investigation']    30s
    # Click Element    ${PA_add_payor_button}
    # Wait Until Element Is Visible    //*[@id='SubModalPopup']    15s
    # ${num}    CustomLibrary.Get Time Zone
    # ${num}    Fetch From Right    ${num}    \ \
    # ${num}    Remove String     ${num}    \:
    # Input Text    ${PA_payer_name_input}    Test Payer New ${num}
    # Input Text    ${PA_address_line_input}    Test Add
    # Click Button    ${PA_new_payer_add_button}
    # Wait Until Page Contains    Payer Information Added    15s
    # Wait Until Page Does Not Contain    Payer Information Added    15s
    Click Button    ${PA_clear_payor_button}
    Input Text    ${PA_payor_input}    PayerTest
    Set Test Variable    ${payor}    PayerTest
    ${PA_payor_suggesstion}    Util.Replace Xpath    xpath=${PA_payor_suggesstion}
    Wait Until Element Is Visible    ${PA_payor_suggesstion}    15s
    Click Element    ${PA_payor_suggesstion}
    Execute JavaScript    document.activeElement.blur()
    Element Should Be Visible    ${PA_CPT_1_input}
    Element Should Be Visible    ${PA_dosage_mg_input}
    Click Element    ${PA_payor_margin_search_button}
    Scroll Element Into View    ${PA_label_select}/following::*[text()='Benefits Investigation']
    Wait Until Element Is Visible    ${PA_label_select}/following::*[text()='Benefits Investigation']    30s
    Set Test Variable    ${text}    CPT 1
    ${CPT_1_allowable_input}    Util.Replace Xpath    xpath=${PA_allowable_input}
    Wait Until Element Is Visible    ${CPT_1_allowable_input}    30s
    Set Test Variable    ${text}    CPT
    ${CPT_extended_input}    Util.Replace Xpath    xpath=${PA_extended_input}
    Wait Until Element Is Visible    ${CPT_extended_input}    30s
    Set Test Variable    ${text}    HCPCS
    ${HCPCS_allowable_input}    Util.Replace Xpath    xpath=${PA_allowable_input}
    Element Should Be Visible    ${HCPCS_allowable_input}
    Scroll Element Into View    ${PA_label_select}/following::*[text()='Benefits Investigation']
    Wait Until Element Is Visible    ${PA_label_select}/following::*[text()='Benefits Investigation']    30s
    Element Should Be Visible    ${PA_total_billable_units_input}
    ${HCPCS_extended_input}    Util.Replace Xpath    xpath=${PA_extended_input}
    Element Should Be Visible    ${HCPCS_extended_input}
    Set Test Variable    ${text}    Total
    ${total_allowable_input}    Util.Replace Xpath    xpath=${PA_allowable_input}
    Wait Until Keyword Succeeds    10 times    3s    Element Should Be Visible    ${total_allowable_input}
    Element Should Be Visible    ${PA_expected_cost_input}
    Element Should Be Visible    ${PA_excepted_margin_input}
    Element Should Be Visible    ${PA_requires_PA_checkbox}
    Element Should Be Visible    ${PA_denied_loading_dose_checkbox}
    Wait Until Keyword Succeeds    10 times    3s   List Selection Should Be    ${PA_label_select}    \-- Select a Label --\
    Click Element    ${PA_add_label_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    15s
    ${label}    Set Variable    test label
    Input Text    ${PA_new_billing_label_input}    ${label}    #Test Label
    Click Button    ${PA_create_billing_label_button}
    ${check}    Run Keyword And Return Status    Wait Until Page Contains    Billing Label has been Created    10s
    IF    ${check} == ${True}
        Wait Until Page Does Not Contain    Billing Label has been Created    15s
        Wait Until Element Is Not Visible    //*[@id='SubModalPopup']    15s
    ELSE
        Util.Wait For Page Loading    element_arg=This Billing Label already exists    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=15s
        Close Submodal
    END
    ${is_selectable}    Run Keyword And Return Status    Select From List By Label    ${PA_label_select}    ${label}    #test label
    IF    ${is_selectable} == ${False}
        ${label}    Convert To Lower Case    ${label}
        ${option}    Get List Items    ${PA_label_select}
        FOR    ${select}    IN    @{option}
            ${select_2}    Convert To Lower Case    ${select}
            IF    "${select_2}" == "${label}"
                Select From List By Label    ${PA_label_select}    ${select}
                BREAK
            END
        END
    END    
    Wait Until Element Is Not Visible    //*[@id='SubModalPopup']    30s
    Waiting For Loading
    Wait Until Element Is Visible    ${PA_edit_billing_label_button}    30s
    Wait Until Keyword Succeeds    10 times    3s    Click Element    ${PA_edit_billing_label_button}
    Wait Until Element Is Visible    //*[@id='SubModalPopup']    30s
    Input Text    ${PA_new_billing_label_input}    ${label} edited    clear=True
    Sleep    2s
    Click Button    ${submodal_update_button}
    ${check}    Run Keyword And Return Status    Wait Until Page Contains    Billing Label has been Created    15s
    IF    ${check} == ${True}
        Wait Until Page Does Not Contain    Billing Label has been Created    15s
        Wait Until Element Is Not Visible    //*[@id='SubModalPopup']    15s
    ELSE
        Util.Wait For Page Loading    element_arg=This Billing Label already exists    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=15s
        Close Submodal
    END

Input Notes In PA For Regression
    Scroll Element Into View    //*[@id='CoPayPanelDiv']
    Wait Until Element Is Visible    //*[@id='CoPayPanelDiv']    30s
    Page Should Contain    No Prior Authorization Notes Available
    FOR    ${i}    IN RANGE    10
        Press Keys    ${PA_related_notes_input}    test regression prior authorization notes\ \
    END
    Click Element    ${PA_add_note_button}
    ${time}    CustomLibrary.Get Time Zone
    ${date}    CustomLibrary.Get Time Now
    ${time}    Evaluate    "${SPACE}".join(part.lstrip("0") for part in "${time}".split("${SPACE}"))
    ${date}    Convert Date    ${date}    result_format=%m/%d/%Y
    ${date}    Evaluate    "/".join(part.lstrip("0") for part in "${date}".split("/"))
    ${check}    Handle Alert And Return Its Text
    Should Be Equal    ${check}    Are you sure you are all ready to submit this note?    ignore_case=True    strip_spaces=True
    Util.Wait For Page Loading    element_arg=Prior Authorization Note Successfully Added    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=15s
    ${notes}    Get Value    ${PA_related_notes_input}
    RePatient.Get User Name
    Set Test Variable    ${user}    ${user_name_txt}
    ${timestamp_text}    Replace Xpath    xpath=${PA_notes_timestamp_text}
    ${text}    Get Text    ${timestamp_text}
    Should Be Equal    ${text}    ${date} at ${time} - ${user_name_txt} : ${notes}    strip_spaces=True    ignore_case=True

Input Coding Details In PA For Regression
    Scroll Element Into View    //*[contains(@class,'prior') and contains(@class,'CPT')]/following::*[text()='Additional Tools']
    Wait Until Element Is Visible    //*[contains(@class,'prior') and contains(@class,'CPT')]/following::*[text()='Additional Tools']    30s
    Set Test Variable    ${line}    \*
    ${CPT_line}    Util.Replace Xpath    xpath=${PA_CPT_line}
    ${CPT_line}    Get WebElements    ${CPT_line}
    ${count}    Get Length    ${CPT_line}
    Should Be Equal    ${count}    ${PO_data.Num_CPTs}
    Set Test Variable    ${line}    1
    ${CPT_ckbx}    Util.Replace Xpath    xpath=${PA_CPT_checkbox}
    Checkbox Should Be Selected    ${CPT_ckbx}
    # Set Test Variable    ${line}    2
    # ${CPT_ckbx}    Util.Replace Xpath    xpath=${PA_CPT_checkbox}
    # Click Element    ${CPT_ckbx}
    Util.Wait For Page Loading    element_arg=Successfully Assigned CPT Code    keyword_arg_1=Page Should Contain    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=15s
    Checkbox Should Be Selected    ${CPT_ckbx}

Input Addtional Tools In PA For Regression
    Scroll Element Into View    //*[@id='ModalPopup']//*[contains(@class,'footer')]
    Wait Until Element Is Visible    //*[@id='PAModalProgressNote']/preceding::*[text()='Additional Tools'][1]    30s
    Element Should Be Visible    //*[normalize-space(text())='Trigger Reminder:']
    Element Attribute Value Should Be    ${PA_reminder_input}    value    5
    Click Button    ${PA_set_reminder_button}
    Wait Until Page Contains    Prior Authorization Notifications Updated    30s
    Wait Until Page Does Not Contain    Prior Authorization Notifications Updated    30s
    Click Element    ${PA_view_changes_button}
    Wait Until Element Is Visible    //*[contains(@class,'title') and text()='Prior Authorization Changelog']    30s
    Scroll Element Into View    ${PA_close_changelog_button}
    Wait Until Element Is Visible    ${PA_close_changelog_button}    30s
    Click Button    ${PA_close_changelog_button}
    Wait Until Element Is Not Visible    //*[contains(@class,'title') and text()='Prior Authorization Changelog']    30s

Update PA With Invalid Then Valid Date Range For Regression
    Sleep    1s
    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PA_update_btn}
    Click Button    ${PA_update_btn}
    Wait Until Page Contains    The End Date must be greater than the Start Date    30s
    Wait Until Page Does Not Contain    The End Date must be greater than the Start Date    30s
    Scroll Element Into View    ${PA_start_date_input}
    Wait Until Element Is Visible    ${PA_start_date_input}    30s
    PriorAuthorization.Set PA Date Range    start_date_arg=${PO_data.Start_Date}    end_date_arg=${PO_data.Exp_Date}

Verify PA General Section Visible
    PriorAuthorization.Find PA    PO_arg=${PO_data.PO_Num}    #find PA by PO num
    PriorAuthorization.Click PA Row
    SeleniumLibrary.Element Text Should Be    ${PA_active_num_text}    1
    PriorAuthorization.Check PA Header    location_arg=${location_PO_2}
    ${check}    Get Text    ${PA_physician_order_text}/parent::*
    ${check}    Fetch From Right    ${check}    \n
    Should Be Equal    ${check}    FEIN: Not Assigned    strip_spaces=True

Verify PA Provider Order MDF Section Visible
    Scroll Element Into View    //*[@id='PAStatusDiv']/following::*[text()='Payor Information and Margin Calculator'][1]
    Wait Until Element Is Visible    //*[@id='PAStatusDiv']/following::*[text()='Payor Information and Margin Calculator'][1]    15s
    PriorAuthorization.Check Provider Order MDF    dose_freq_arg=${PO_data.Dose_Frequency}    num_arg=${PO_data.Num_Of_Treatmtents}    container_arg=${PO_data.Container}
    PriorAuthorization.Check Container Type    container_arg=${PO_data.Container}
    Element Should Be Disabled    ${PA_total_dosage_input}
    Element Should Be Disabled    ${PA_total_approved_visits_input}
    Element Should Be Disabled    ${PA_visits_used_input}

Verify PA Status And Confirmation Section Visible
    Scroll Element Into View    //*[@id='PAStatusDiv']
    Wait Until Element Is Visible    //*[@id='PAStatusDiv']    15s
    PriorAuthorization.Check PA Status And Confirmation    status_arg=${PA_data.Status}
    Element Should Be Disabled    ${PA_auth_date_input}
    Element Should Be Disabled    ${PA_medication_type_select}
    Element Should Be Disabled    ${PA_other_label_input}

Verify Payor Information And Margin Calculator Section Visible
    Scroll Element Into View    //*[@id='PAStatusDiv']/following::*[text()='Benefits Investigation'][1]
    Wait Until Element Is Visible    //*[@id='PAStatusDiv']/following::*[text()='Benefits Investigation'][1]    15s
    PriorAuthorization.Check Payor And Margin
    ${list_med}    Wait Until Keyword Succeeds    10 times    3s    Get List Items    ${PA_payor_medication_select}
    ${list_med}    Get Slice From List    ${list_med}    1