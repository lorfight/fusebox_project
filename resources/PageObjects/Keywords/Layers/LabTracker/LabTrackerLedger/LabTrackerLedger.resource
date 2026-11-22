*** Settings ***
Resource    ../../Common/Common.resource
Library    ../../Fakedata/FakeData.py

*** Variables ***
${tracker_loading_icon_i}    //i[@class='fa fa-spinner fa-4x fa-spin']
${tracker_ledger_location}    //select[@id='LabMemberId']
${tracker_ledger_patient}    //input[@id='PatientId']
${tracker_ledger_search_btn}    //a[contains(@class,'LabTrackerLedgerSearchBtn')]

*** Keywords ***
Filter By Location In Lab Tracker Ledger
    [Arguments]    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${tracker_ledger_location}    ${location_arg}
    Common.Element Is Not Visible    ${tracker_loading_icon_i}

Filter By Patient In Lab Tracker Ledger
    [Arguments]    ${mrn_arg}
    Common.Clear Input Field Until Empty    ${tracker_ledger_patient}
    Common.Input Text Into Field    ${tracker_ledger_patient}    ${mrn_arg}
    ${tracker_ledger_patient_strong}    Set Variable    //div[contains(text(),'${mrn_arg}')]
    Wait Until Element Is Visible    ${tracker_ledger_patient_strong}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_ledger_patient_strong}

Click Search Button In Lab Tracker Ledger
    Wait Until Element Is Visible    ${tracker_ledger_search_btn}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${tracker_ledger_search_btn}
    Common.Element Is Not Visible    ${tracker_loading_icon_i}

Check Value Of Status Lab Tracker Modal
    [Arguments]    ${file_num}
    ${tracker_ledger_status}    Set Variable    //div[contains(text(),'${file_num}')]//preceding::td[1]//div[1]
    ${tracker_ledger_status_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${tracker_ledger_status}
    Should Contain    ${tracker_ledger_status_txt}    ABNORMAL

Open Lab Tracker Row
    [Arguments]    ${assign_lab_txt}
    ${tracker_lab_row}    Set Variable    //div[@id="LabTrackerTabList" or @id="LabTrackerList"]//td[contains(normalize-space(.),'${assign_lab_txt}')]
    Wait Until Element Is Enabled    ${tracker_lab_row}    30s
    Common.Scroll And Click Element    ${tracker_lab_row}
    Wait Until Element Is Visible    //a[@id="EditLabDescriptionBtn"]    30s

Create Lab Order Dictionary
    &{lab_order_dict}    Create Dictionary
    RETURN    ${lab_order_dict}

Update Lab Tracker Successfully When Input Required Fields In Lab Order
    [Arguments]    ${assign_lab_txt}    ${po_num}    ${startdate_arg}
    ${lab_order_dict}    Create Lab Order Dictionary
    Click Reorder Button    ${assign_lab_txt}    ${po_num}
    Input Order Start Date In Lab Order    ${assign_lab_txt}    ${startdate_arg}
    Select Frequency Value In Lab Order    ${assign_lab_txt}    ${lab_order_dict}
    Select Frequency Unit In Lab Order    ${assign_lab_txt}    ${lab_order_dict}
    Click Save And Submit Order Button    ${assign_lab_txt}    Lab has been Reordered.
    Verify Reorder Button Is Not Visible    ${assign_lab_txt}    ${po_num}
    RETURN    ${lab_order_dict}

Update Lab Tracker Successfully When Input All Fields In Lab Order
    [Arguments]    ${assign_lab_txt}    ${po_num}    ${startdate_arg}    ${resultdate_arg}    ${icd10_code_arg}
    ${lab_order_dict}    Create Lab Order Dictionary
    Click Reorder Button    ${assign_lab_txt}    ${po_num}
    Input Order Start Date In Lab Order    ${assign_lab_txt}    ${startdate_arg}
    Click Yes Checkbox In Lab Order    ${assign_lab_txt}
    Click Fasting Checkbox In Lab Order    ${assign_lab_txt}
    Select Lab Company In Lab Order    ${assign_lab_txt}    ${lab_order_dict}
    Select Frequency Value In Lab Order    ${assign_lab_txt}    ${lab_order_dict}
    Select Frequency Unit In Lab Order    ${assign_lab_txt}    ${lab_order_dict}
    Input Result Date In Lab Order    ${assign_lab_txt}    ${resultdate_arg}
    Input Multiple ICD10 Codes In Lab Order    ${assign_lab_txt}    ${icd10_code_arg}
    Click Save And Submit Order Button    ${assign_lab_txt}    Lab has been Reordered.
    Verify Reorder Button Is Not Visible    ${assign_lab_txt}    ${po_num}
    RETURN    ${lab_order_dict}
    
Click Reorder Button
    [Arguments]    ${assign_lab_txt}    ${po_num}
    ${tracker_PO_reorder_btn}    Set Variable    //div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Reorder')]
    Scroll And Click Element    ${tracker_PO_reorder_btn}
    ${lab_order_title}    Set Variable    //h4[contains(text(),'Create Lab Order For: ${assign_lab_txt}')]
    Wait Until Element Is Visible    ${lab_order_title}    30s

Input Order Start Date In Lab Order
    [Arguments]    ${assign_lab_txt}    ${startdate_arg}
    ${reorder_startdate}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::div[contains(text(),'Order Start Date')]//following::input[1])[1]
    Common.Clear Input Field Until Empty    ${reorder_startdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text     ${reorder_startdate}    ${startdate_arg}
    Common.Close Calendar Table

Click Yes Checkbox In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_yes_checkbox}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::span[contains(text(),'Y')]//preceding::input[contains(@class,'StatOrderCheckbox')])[1]
    Checkbox Should Not Be Selected    ${reorder_yes_checkbox}
    ${checkbox_atrribute}    SeleniumLibrary.Get Element Attribute    ${reorder_yes_checkbox}    type
    Should Be Equal    ${checkbox_atrribute}    checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element     ${reorder_yes_checkbox}
    Checkbox Should Be Selected    ${reorder_yes_checkbox}

Click No Checkbox In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_no_checkbox}    Set Variable    //h4[contains(text(),'${assign_lab_txt}')]//following::input[contains(@class,'NotStatOrderCheckbox')]
    Checkbox Should Not Be Selected    ${reorder_no_checkbox}
    ${checkbox_atrribute}    SeleniumLibrary.Get Element Attribute    ${reorder_no_checkbox}    type
    Should Be Equal    ${checkbox_atrribute}    checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element     ${reorder_no_checkbox}
    Checkbox Should Be Selected    ${reorder_no_checkbox}

Click Fasting Checkbox In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_fasting_checkbox}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::span[contains(text(),'Fasting')]//following::input[contains(@class,'FastingCheckbox')])[1]
    Checkbox Should Not Be Selected    ${reorder_fasting_checkbox}
    ${checkbox_atrribute}    SeleniumLibrary.Get Element Attribute    ${reorder_fasting_checkbox}    type
    Should Be Equal    ${checkbox_atrribute}    checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element     ${reorder_fasting_checkbox}
    Checkbox Should Be Selected    ${reorder_fasting_checkbox}

Select Lab Company In Lab Order
    [Arguments]    ${assign_lab_txt}    ${dict_arg}
    ${reorder_lab_company}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='LabCompany'])[1]
    Common.Choose Random Value From Select List    xpath_arg=${reorder_lab_company}    var_name=reorder_lab_company    dic=${dict_arg}

Input Result Date In Lab Order
    [Arguments]    ${assign_lab_txt}    ${resultdate_arg}
    ${reorder_resultdate}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'Result Date')]//following::input)[1]
    Common.Clear Input Field Until Empty    ${reorder_resultdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text     ${reorder_resultdate}    ${resultdate_arg}
    Common.Close Calendar Table

Get Expiration Date In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_expdate}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::strong[contains(text(),'Expiration Date')]//following::input)[1]
    Element Should Be Disabled    ${reorder_expdate}
    ${reorder_expdate_value}    Wait Until Keyword Succeeds    30s    1s    Get Value    ${reorder_expdate}
    RETURN    ${reorder_expdate_value}

Select Frequency Value In Lab Order
    [Arguments]    ${assign_lab_txt}    ${dict_arg}
    ${reorder_frequency_value}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='FrequencyDays'])[1]
    ${old_frequency_value}    Get Selected List Label    ${reorder_frequency_value}
    Common.Choose Random Value From Select List    xpath_arg=${reorder_frequency_value}    var_name=reorder_frequency_value    dic=${dict_arg}
    IF    "${dict_arg.reorder_frequency_value}" == "${old_frequency_value}"
        Select Frequency Value In Lab Order    ${assign_lab_txt}    ${dict_arg}
    END

Select Frequency Unit In Lab Order
    [Arguments]    ${assign_lab_txt}    ${dict_arg}
    ${reorder_frequency_unit}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::select[@id='Frequency'])[1]
    ${old_frequency_value}    Get Selected List Label    ${reorder_frequency_unit}
    Common.Choose Random Value From Select List    xpath_arg=${reorder_frequency_unit}    var_name=reorder_frequency_unit    dic=${dict_arg}
    IF    "${dict_arg.reorder_frequency_unit}" == "${old_frequency_value}"
        Select Frequency Unit In Lab Order    ${assign_lab_txt}    ${dict_arg}
    END

Input ICD10 Code In Lab Order
    [Arguments]    ${assign_lab_txt}    ${icd_code}
    ${reorder_diagnosis_input}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::div[contains(text(),'Diagnoses To Add To Order')]//following::input)[2]
    Common.Input Text Into Field    ${reorder_diagnosis_input}    ${icd_code}

Click Add ICD10 Code Button In Lab Order
    [Arguments]    ${assign_lab_txt}
    ${reorder_add_btn}    Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::button[contains(text(),'Add')])[1]
    Wait Until Keyword Succeeds    30s    1s    Click Button    ${reorder_add_btn}

Input Multiple ICD10 Codes In Lab Order
    [Arguments]    ${assign_lab_txt}    ${icd10_code_arg}
    FOR    ${diagnose_value}    IN    @{icd10_code_arg.values()}
        Input ICD10 Code In Lab Order    ${assign_lab_txt}    ${diagnose_value}
        Click Add ICD10 Code Button In Lab Order    ${assign_lab_txt}
    END

Click Save And Submit Order Button
    [Arguments]    ${assign_lab_txt}    ${msg}
    ${reorder_save_btn}     Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Save and Submit Order')])[1]
    Common.Scroll And Click Element    ${reorder_save_btn}
    Page Alert Message    ${msg}

Click Cancel Button
    [Arguments]    ${assign_lab_txt}
    ${reorder_cacel_btn}     Set Variable    (//h4[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Cancel')])[1]
    Common.Scroll And Click Element    ${reorder_cacel_btn}

Verify Reorder Button Is Not Visible
    [Arguments]    ${assign_lab_txt}    ${po_num}
    ${tracker_PO_reorder_btn}    Set Variable    //div[contains(text(),'${po_num}')]//following::td[@data-column='5']//strong[contains(text(),'${assign_lab_txt}')]//following::a[contains(text(),'Reorder')]
    Wait Until Element Is Not Visible    ${tracker_PO_reorder_btn}    30s

Get Frequency Of Lab Descirption In Lab Order
    [Arguments]    ${lab_des_arg}    ${po_num}
    ${lab_order_dict}    Create Lab Order Dictionary
    Click Reorder Button    ${lab_des_arg}    ${po_num}
    ${reorder_frequency_value}    Set Variable    (//h4[contains(text(),'${lab_des_arg}')]//following::select[@id='FrequencyDays'])[1]
    ${reorder_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${reorder_frequency_value}
    ${reorder_frequency_unit}    Set Variable    (//h4[contains(text(),'${lab_des_arg}')]//following::select[@id='Frequency'])[1]
    ${reorder_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${reorder_frequency_unit}
    Wait Until Keyword Succeeds    30s    1s    Click Cancel Button    ${lab_des_arg}
    RETURN    ${reorder_frequency_value_txt}    ${reorder_frequency_unit_txt}
