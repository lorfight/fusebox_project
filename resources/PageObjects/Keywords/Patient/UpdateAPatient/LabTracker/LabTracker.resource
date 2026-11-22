*** Settings ***
Resource    ../../../Layers/LabTracker/LabTracker.resource

*** Variables ***

*** Keywords ***
Open Lab Tracker Tab
    Navigate To The Tab    
        ...    tab_name=//a[@id='LabTracker']  
        ...    title_name=//h2[normalize-space(.)='Lab Tracker']
    Common.Element Is Not Visible    //div[@id="LabTrackerTab"]//i[@class="fa fa-spinner fa-4x fa-spin"]
    Common.Element Is Not Visible    //div[@id="CriticalLabResults"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Verify Descirption Field Shows Multiple Medication Data
    [Arguments]    ${assign_lab_txt}    ${drug_first}    ${drug_second}
    Input Lab Descirption In Lab Tracker Modal    ${assign_lab_txt}    ${drug_first}
    ${description_txt1}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Input Lab Descirption In Lab Tracker Modal    ${assign_lab_txt}    ${drug_second}
    ${description_txt2}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${tracker_description}
    Should Be Equal    ${description_txt1}    ${assign_lab_txt} (${drug_first})
    Should Be Equal    ${description_txt2}    ${assign_lab_txt} (${drug_second})

Verify Options Of Frequency Value
    ${value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_frequency_value}
    Should Be Equal    ${value_list[0]}    - Select -
    ${value_list}    Evaluate    [int(i) for i in ${value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 91))
    Lists Should Be Equal    ${value_list}    ${expected_list}

Verify Options Of Frequency Select
    ${value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${tracker_frequency_select}
    ${expected_list}    Create List    - Select -    Min(s)    Hour(s)    Day(s)    Week(s)    Month(s)    Year(s)
    Lists Should Be Equal    ${value_list}    ${expected_list}

Verify Expiration Date Value Is Changed Following Result Date Value
    ${tracker_resultdate_value}    Get Value    ${tracker_resultdate_input}
    ${tracker_expdate_value}    Get Value    ${tracker_expdate_input}
    Should Be Equal    ${tracker_resultdate_value}    ${tracker_expdate_value}
    IF    "${tracker_resultdate_value}" == "${EMPTY}"
        Should Be Empty    ${tracker_expdate_value}
    END

Check Value Expiration Date Should Be Equal Total Frequency And Result Date Value
    [Arguments]    ${frequency_value_arg}    ${frequency_select_arg}    ${resultdate_arg}    ${expdate_input_arg}
    ${tracker_expdate_value}    Get Value    ${expdate_input_arg}
    IF    "${frequency_select_arg}" == "Hour(s)" or "${frequency_select_arg}" == "Min(s)"
        Should Be Equal    ${resultdate_arg}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Day(s)"
        ${total_date_value}    Add Time To Date    ${resultdate_arg}    ${frequency_value_arg} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Week(s)"
        ${frequency_value_arg}    Evaluate    int(${frequency_value_arg}*7)
        ${total_date_value}    Add Time To Date    ${resultdate_arg}    ${frequency_value_arg} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Month(s)"
        ${total_date_value}    Evaluate    str((datetime.datetime.strptime('${resultdate_arg}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(months=${frequency_value_arg})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Year(s)"
        ${total_date_value}    Evaluate    str((datetime.datetime.strptime('${resultdate_arg}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(years=${frequency_value_arg})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    END

Lab Tracker Attributes List Shows Attribute Rows
    Show Empty Value In Lab Tracker Row
    ${total_attribute_rows}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Element Count   //div[@id="LabTrackerAttributeList"]//tbody//following-sibling::tr[1]//following::span[contains(@class,'updateLabTrackerAttributeButton')]
    Should Be True    ${total_attribute_rows} > 0
    
Input Out Of Normal Range Value
    [Arguments]    ${attribute_description}    ${min_range}    ${max_range}    ${dict_arg}
    ${out_range_value}    Evaluate    random.choice([random.randint(0, ${min_range} - 1), random.randint(${max_range} + 1, ${max_range} + 20)])    modules=random
    Set To Dictionary    ${dict_arg}    out_range_value=${out_range_value}
    IF    ${out_range_value} < ${min_range}
        Set To Dictionary    ${dict_arg}    tracker_result=Lower
    ELSE
        Set To Dictionary    ${dict_arg}    tracker_result=Higher
    END
    ${attribute_patient_value_input}    Set Variable    //td[contains(text(),'${attribute_description}')]//following::input[@name='LabTrackerAttributeResponse'][1]
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${attribute_patient_value_input}    ${out_range_value}

Check Labs Related To Provider Orders Table Displays All The Labs Of The PO
    [Arguments]    ${po_num}    ${assign_lab_list}
    Open Lab Tracker Tab
    ${tracker_po_description}    Set Variable    //thead[.//div[contains(.,'${po_num}')]]//following-sibling::tbody//td[@data-column='5']
    ${tracker_po_description_list}    Get WebElements    ${tracker_po_description}
    FOR    ${lab}    IN    @{tracker_po_description_list}
        ${lab_txt}    Get Text    ${lab}
        Should Contain    ${assign_lab_list}    ${lab_txt}
    END

Check Lab Row Is Visible In Lab Tracker Modal
    [Arguments]    ${tracker_description_element}    ${po_num}    ${assign_lab_txt}    ${expected_description_status}    ${reorder_btn_status}
    Reload Page
    Open Lab Tracker Tab
    ${check_description_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${tracker_description_element}    5s
    Should Be Equal    ${check_description_visible}    ${expected_description_status}
    IF    "${check_description_visible}" == "${True}" and "${reorder_btn_status}" == "${True}"
        ${tracker_PO_reorder_btn}    Set Variable    //div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Reorder')]
        Wait Until Element Is Visible    ${tracker_PO_reorder_btn}    30s
    END

Get Frequency Of Lab Descirption In Lab Tracker Modal
    [Arguments]    ${lab_des_arg}    ${drug_lab_arg}
    Open Lab Tracker Tab
    AddLabTracker.Open Add Lab Tracker Modal
    Input Lab Descirption In Lab Tracker Modal    ${lab_des_arg}    ${drug_lab_arg}
    ${tracker_frequency_value_txt}    Get Selected List Label    ${tracker_frequency_value}
    ${tracker_frequency_unit_txt}    Get Selected List Label    ${tracker_frequency_select}
    Click Close Lab Tracker Button
    RETURN    ${tracker_frequency_value_txt}    ${tracker_frequency_unit_txt}

Verify The Reorder Lab Will Close When Clicking Cancel Button
    [Arguments]    ${assign_lab_txt}    ${po_num}
    Click Reorder Button    ${assign_lab_txt}    ${po_num}
    Click Cancel Button    ${assign_lab_txt}

Add Lab Order UnsuccessFully With Empty Required Fields
    [Arguments]    ${assign_lab_txt}    ${po_num}
    ${error_list}    Create List
        ...    The Order Start Date field is required.
        ...    The Frequency fields are required.
    ${labtracker_dict}    Create Lab Tracker Dictionary
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    Open Lab Tracker Tab
    FOR    ${error}    IN    @{error_list}
        Click Reorder Button    ${assign_lab_txt}    ${po_num}
        Run Keyword If    "${error}" != "The Order Start Date field is required."    Input Order Start Date In Lab Order    ${assign_lab_txt}    ${start_date}
        Run Keyword If    "${error}" != "The Frequency fields are required."    Select Frequency Value In Lab Order    ${assign_lab_txt}    ${labtracker_dict}
        Run Keyword If    "${error}" != "The Frequency fields are required."    Select Frequency Unit In Lab Order    ${assign_lab_txt}    ${labtracker_dict}
        Click Save And Submit Order Button    ${assign_lab_txt}    ${error}
        Click Cancel Button    ${assign_lab_txt} 
    END

Verify Date Input In Lab Order
    [Arguments]    ${assign_lab_txt}    ${po_num}
    ${labtracker_dict}    Create Lab Tracker Dictionary
    ${start_date}    ${end_date}    ${result_date}    Get DateTime In Lab Tracker
    Input Order Start Date In Lab Order    ${assign_lab_txt}    ${start_date}
    Input Result Date In Lab Order    ${assign_lab_txt}    ${result_date}
    ${reorder_expdate_value}    Get Expiration Date In Lab Order    ${assign_lab_txt}
    Should Be Equal    ${reorder_expdate_value}    ${result_date}
    Select Frequency Value In Lab Order    ${assign_lab_txt}    ${labtracker_dict}
    Select Frequency Unit In Lab Order    ${assign_lab_txt}    ${labtracker_dict}
    ${reorder_startdate_input}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::div[contains(text(),'Order Start Date')]//following::input[1])[1]
    ${reorder_expdate_input}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'Expiration Date')]//following::input)[1]
    Check Value Expiration Date Should Be Equal Total Frequency And Result Date Value    
        ...    ${labtracker_dict.reorder_frequency_value}    
        ...    ${labtracker_dict.reorder_frequency_unit}    
        ...    ${result_date}    
        ...    ${reorder_expdate_input}
    Mouse Hover Element    ${reorder_expdate_input}    ${reorder_startdate_input}    ${tracker_expdate_tooltip}

Verify Checkbox In Lab Order
    [Arguments]    ${assign_lab_txt}
    Click Yes Checkbox In Lab Order    ${assign_lab_txt}
    Click No Checkbox In Lab Order    ${assign_lab_txt}
    Click Fasting Checkbox In Lab Order    ${assign_lab_txt}

Verify Select In Lab Order
    [Arguments]    ${assign_lab_txt}
    Verify Options Of Frequency Value In Lab Order    ${assign_lab_txt}
    Verify Options Of Frequency Select In Lab Order    ${assign_lab_txt}
    Verify Options Of Lab Company In Lab Order    ${assign_lab_txt}

Verify Options Of Frequency Value In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_frequency_value}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='FrequencyDays'])[1]
    ${value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_frequency_value}
    Should Be Equal    ${value_list[0]}    -
    ${value_list}    Evaluate    [int(i) for i in ${value_list}[1:]]
    ${expected_list}    Evaluate    list(range(1, 91))
    Lists Should Be Equal    ${value_list}    ${expected_list}

Verify Options Of Frequency Select In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_frequency_select}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='Frequency'])[1]
    ${value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_frequency_select}
    ${expected_list}    Create List    -    Min(s)    Hour(s)    Day(s)    Week(s)    Month(s)    Year(s)
    Lists Should Be Equal    ${value_list}    ${expected_list}

Verify Options Of Lab Company In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_lab_company_select}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='LabCompany'])[1]
    ${value_list}    Wait Until Keyword Succeeds    30s    1s    Get List Items    ${reorder_lab_company_select}
    ${expected_list}    Create List    -- Select a Lab Company --    Lab Corp    Other    Quest
    Lists Should Be Equal    ${value_list}    ${expected_list}

Verify Result Date Column In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${expect_value}    Convert Date    ${expect_value}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${tracker_row_resultdate}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='1']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_resultdate}    ${expect_value}

Verify Order Date Column In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${tracker_row_orderdate}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='3']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_orderdate}    ${expect_value}

Verify Lab Code Column In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${tracker_row_labcode}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='6']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_labcode}    ${expect_value}

Verify Status Column In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${tracker_row_status}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='7']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_status}    ${expect_value}

Verify Order End Date In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${tracker_row_order_enddate}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='8']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_order_enddate}    ${expect_value}

Verify File Number Column In Lab Table
    [Arguments]    ${po_num}    ${assign_lab_txt}    ${expect_value}
    ${tracker_row_file_number}    Set Variable    (//div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//ancestor::tr//td[@data-column='9']//strong)[1]
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${tracker_row_file_number}    ${expect_value}

Verify The Primary And Additional ICD10 Codes Shows Correct Data
    [Arguments]    ${icd10_code_arg}
    ${primary_ICD10_txt}    Get Text    ${tracker_primary_ICD10_list}
    ${additional_ICD10_txt}    Get Text    ${tracker_additional_ICD10_list}
    Should Be Equal    ${primary_ICD10_txt}    ${icd10_code_arg}[icd10_code_1]
    Should Contain    ${additional_ICD10_txt}    ${icd10_code_arg}[icd10_code_2]
    Should Contain    ${additional_ICD10_txt}    ${icd10_code_arg}[icd10_code_3]

Check Value Expiration Date Should Be Equal Total Frequency And Result Date Value In Lab Order
    [Arguments]    ${frequency_value_arg}    ${frequency_select_arg}    ${resultdate_arg}    ${expdate_input_arg}
    ${tracker_expdate_value}    Get Text    ${expdate_input_arg}
    IF    "${frequency_select_arg}" == "Hour(s)" or "${frequency_select_arg}" == "Min(s)"
        Should Be Equal    ${resultdate_arg}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Day(s)"
        ${total_date_value}    Add Time To Date    ${resultdate_arg}    ${frequency_value_arg} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Week(s)"
        ${frequency_value_arg}    Evaluate    int(${frequency_value_arg}*7)
        ${total_date_value}    Add Time To Date    ${resultdate_arg}    ${frequency_value_arg} days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Month(s)"
        ${total_date_value}    Evaluate    str((datetime.datetime.strptime('${resultdate_arg}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(months=${frequency_value_arg})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    ELSE IF    "${frequency_select_arg}" == "Year(s)"
        ${total_date_value}    Evaluate    str((datetime.datetime.strptime('${resultdate_arg}', '%m/%d/%Y') + dateutil.relativedelta.relativedelta(years=${frequency_value_arg})).strftime('%#m/%#d/%Y'))    modules=datetime,dateutil.relativedelta
        Should Be Equal    ${total_date_value}    ${tracker_expdate_value}
    END
