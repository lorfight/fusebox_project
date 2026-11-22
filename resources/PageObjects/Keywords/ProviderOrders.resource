*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library         Collections
Library    String
Library    ../../../libraries/CustomLibrary.py
Library    FakerLibrary
Variables       ../Locators/CommonLocator.py
Variables       ../Locators/ProviderOrdersLocator.py
Resource        ../../../libraries/Util.resource

*** Variables ***

*** Keywords ***
Create Dictionary Of PO Data
    &{PO_data}    Create Dictionary
    Set Suite Variable    ${PO_data}

Maximize Browser
    Maximize Browser Window

Go to Provider Orders
    Click Element    ${DispensingLink}
    Click Element    ${PO_link}
    Wait Until Keyword Succeeds    5    1    Title Should Be    Provider Orders

Select Location Provider Orders
    Filter Location    location_arg=${PatientData.Location}
    Wait Until Element Is Enabled    ${CreatePriderOrder}

Calculate PO End Date
    ${today}    Check Time Zone
    ${end_date}    Add Time To Date    ${today}    364 days    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Set Test Variable    ${end_date}

Filter Location
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${LocationProviderOrders}
    Select From List By Label    ${LocationProviderOrders}    ${location_arg}

Filter Patient
    [Arguments]    ${patient_arg}
    Wait Until Element Is Enabled    ${clear_patient_btn}    60s
    Scroll Element Into View    ${clear_patient_btn}
    Wait Until Element Is Visible    ${clear_patient_btn}    60s
    Wait Until Keyword Succeeds    10 times    3s    Click Button    ${clear_patient_btn}
    Sleep    5s
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${filter_patient_input}    ${patient_arg}
    Set Test Variable    ${patient}    ${PatientData.Last_Name}, ${PatientData.First_Name} \(${PatientData.DOB}\) MRN:
    Set Test Variable    ${MRN}    ${patient_arg}
    ${PO_patient_suggestion}    Util.Replace Xpath    xpath=${PO_patient_suggestion}
    Wait Until Element Is Visible    ${PO_patient_suggestion}    120s
    Wait Until Keyword Succeeds    60s    1s    Click Element    ${PO_patient_suggestion}

Filter Date Range
    [Arguments]    ${date_arg}
    Clear Element Text    ${range_start_date_input}
    Input Text    ${range_start_date_input}    ${date_arg}
    Clear Element Text    ${range_end_date_input}
    Input Text    ${range_end_date_input}    ${date_arg}
    Wait Until Keyword Succeeds    30s    1s   Scroll Element Into View    ${select_date_done_btn}
    Wait Until Element Is Visible    ${select_date_done_btn}    30s
    Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${select_date_done_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Click Search PO
    Click Element    ${search_PO_btn}
    Util.Wait For Page Loading    element_arg=${PO_list_loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Check PO List
    Check View Discountinued Service    view_arg=${False}
    Sleep    1s
    Click Search PO
    ${PO_list}    Wait Until Keyword Succeeds    15s    1s    Get WebElements    ${PO_row_2}
    ${num_PO}    Get Length    ${PO_list}
    IF    ${num_PO} == 25    #if page with 25 PO lines - maxinum lines in a page
        Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${PO_row_2}\[1]
        Click Element    ${edit_PO_btn_2}
        Wait For Page Loading    element_arg=${PO_Loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s
        Discontinue PO    PO_arg=${PO_row_2}\[1]    edit_PO_arg=${edit_PO_btn_2}   #first PO line - oldest PO

    END

Check View Discountinued Service
    [Arguments]    ${view_arg}
    ${check}    Wait Until Keyword Succeeds    5s    1s    SeleniumLibrary.Get Element Attribute    ${view_discontinued_service_checkbox}    checked
    ${check}    Run Keyword And Return Status    Should Be Equal As Strings    ${check}    true
    IF    ${check} == ${True}
        IF    ${view_arg} == ${False}
            Wait Until Keyword Succeeds    5s    1s    Click Element    ${view_discontinued_service_checkbox}    #uncheck the box
        END
    ELSE    #if checkbox not checked
        IF    ${view_arg} == ${True}
            No Operation
        ELSE
            Wait Until Keyword Succeeds    5s    1s    Click Element    ${view_discontinued_service_checkbox}    #check the box
        END
    END

Discontinue PO
    [Arguments]    ${xpath_arg}
    Util.Scroll Into Element And Click    xpath_arg=${xpath_arg}    retry_arg=20    time_arg=3s    kw_arg=Click Element
    Scroll Element Into View    ${save_PO_bottom_btn}
    Wait Until Element Is Visible    ${save_PO_bottom_btn}    30s
    Sleep    1s
    Wait Until Keyword Succeeds    60s    1s    Click Button    ${save_PO_bottom_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s   Scroll Element Into View    //*[@id='SaveBtn' and text()='Accept & Continue']
        IF    ${check} == ${True}
            Click Button    //*[@id='SaveBtn' and text()='Accept & Continue']
        END
        Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    ${PO_accept_button}
        Wait Until Element Is Visible     ${PO_accept_button}    60s
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${PO_accept_button}
    END
    Util.Wait For Page Loading    element_arg=Provider Order Successfully Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s
    Scroll Element Into View    ${xpath_arg}
    Wait Until Element Is Visible    ${xpath_arg}    30s
    ${is_discontinued}    SeleniumLibrary.Get Element Attribute    ${xpath_arg}    checked
    Should Be Equal As Strings    ${is_discontinued}    true    ignore_case=True    #None

Find PO
    [Arguments]    ${PO_arg}
    Set Test Variable    ${PO_num}    ${PO_arg}
    ${PO_row}    Util.Replace Xpath    xpath=${PO_row}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PO_row}
    WHILE    ${check} == ${False}
        Wait Until Keyword Succeeds    10s    1s    Click Element    ${next_page_link}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PO_row}
    END
    Check PO Not Duplicated    xpath_arg=${PO_row}    # only 1 PO row with exact PO number on PO page
    # Check PO Row
    # Scroll Element Into View    ${PO_row}
    Util.Scroll To Bottom
    Sleep    2s
    Wait Until Keyword Succeeds    14s    1s    Click Element    ${PO_row}
    Wait Until Element Is Visible    ${PO_header_text}    30
    Util.Wait For Page Loading    element_arg=${PO_Loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=60s
    Set Test Variable    ${PO_row}

Find PO Row
    [Arguments]    ${PO_arg}
    ${PO_num}    Set Variable    ${PO_data.PO_Num}
    ${PO_row}    Replace Variables    ${PO_row}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PO_row}
    WHILE    ${check} == ${False}
        Wait Until Keyword Succeeds    3s    1s    Click Element    ${next_page_link}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Scroll Element Into View    ${PO_row}
    END

Check PO Not Duplicated
    [Arguments]    ${xpath_arg}
    ${check_list}    Wait Until Keyword Succeeds    10s    1s    Get WebElements    ${xpath_arg}
    ${check_count}    Get Length    ${check_list}
    Should Be Equal As Integers    ${check_count}    1

Check PO Row
    ${aging}    Get Text    ${PO_row}/*[@data-column='0']/*[contains(text(),' Days')]
    ${aging}    Get Regexp Matches    ${aging}    \d+
    ${today_location}    Util.Check Time Zone
    ${check}    Subtract Date From Date    ${today_location}    ${PO_data.Start_Date}    result_format=verbose    date1_format=%m/%d/%Y    date2_format=%m/%d/%Y
    ${check}    Fetch From Left    ${check}    \Day\
    Should Be Equal    ${check}    ${aging}[0]

Check Location
    [Arguments]    ${location_arg}
    List Selection Should Be    ${ModalAccountID}    ${location_arg}

Check PO Num
    [Arguments]    ${num_arg}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Element Should Be Visible    ${PO_Loading}
    IF    ${check} == ${True}
        Wait Until Element Is Not Visible    ${PO_Loading}    30s
    END
    SeleniumLibrary.Element Text Should Be    ${PO_num_text}    Viewing PO: ${num_arg}

Check Patient
    SeleniumLibrary.Element Text Should Be    ${patient_PO_text}    ${PatientData.First_Name} ${PatientData.Last_Name} \(${PatientData.DOB}\) MRN: ${PatientData.MRN}

Check Dates
    [Arguments]    ${entry_arg}    ${start_arg}    ${exp_arg}
    # ${today_location}    Util.Check Time Zone
    ${today_location}    Convert Date    ${PO_data.Today}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${today_location}    Evaluate    "/".join(part.lstrip("0") for part in "${today_location}".split("/"))
    ${entry_arg}    Convert Date    ${entry_arg}    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y
    ${entry_arg}    Evaluate    "/".join(part.lstrip("0") for part in "${entry_arg}".split("/"))
    Should Be Equal    ${today_location}    ${entry_arg}
    Element Attribute Value Should Be    ${entry_date_input}    value    ${entry_arg}
    Should Be Equal    ${start_arg}    ${entry_arg}   #entry date = start date by default
    Element Attribute Value Should Be    ${start_date_input}    value    ${start_arg}
    ${date}    Add Time To Date    ${start_arg}    364 days    result_format=%#m/%#d/%Y    date_format=%m/%d/%Y    #exp date = 364 days later from start date
    ${date}    Evaluate    "/".join(part.lstrip("0") for part in "${date}".split("/"))
    Should Be Equal    ${date}    ${exp_arg}
    Element Attribute Value Should Be    ${exp_date_input}    value    ${exp_arg}

Check Providers
    [Arguments]    ${referring_arg}    ${referral_arg}    ${refer_to_arg}
    Element Attribute Value Should be    ${ReferralPhysician}    value    ${referring_arg}
    List Selection Should Be    ${referral_source_select}    ${referral_arg}
    List Selection Should Be    ${SelectReferToProvider}    ${refer_to_arg}

Check Frequency In PO
    [Arguments]    ${freq_arg}
    ${value}    Fetch From Left    ${freq_arg}    \ \
    ${frequency}    Fetch From Right    ${freq_arg}    \ \
    List Selection Should Be    ${visit_frequency_value_select}    ${value}
    Sleep    10s
    ${check}    Get Selected List Label    ${visit_frequency_select}
    List Selection Should Be    ${visit_frequency_select}    ${frequency}

Check Weight And Height
    [Arguments]    ${weight_arg}    ${height_arg}
    ${weight}    Fetch From Left    ${weight_arg}    \ \
    ${height}    Fetch From Left    ${height_arg}    \ \
    Element Attribute Value Should Be    ${WeightPO_input}    value    ${weight}
    Element Attribute Value Should Be    ${HeightPO_input}    value    ${height} ft
    Element Attribute Value Should Be    ${Radiobuton_KG}    checked    true
    ${BMI}    Get Text    ${PO_BMI_text}
    ${BMI_check}    Evaluate    round(${weight}/((${height}*0.3048)**2),2)    # BMI = w/(h^2)    #formula:kg-m    #UI:kg-ft    #1 ft = 30.4c8m
    Should Be Equal As Numbers    ${BMI_check}    ${BMI}
    ${BSA}    Get Text    ${BSA_text}
    ${BSA}    Remove String    ${BSA}    m²
    ${BSA_check}    Evaluate    round((${weight}*${height}*30.48/3600)**0.5,2)    # BSA = squareroot(w*h)/60    #formula:kg-cm    #UI:kg-ft
    Should Be Equal As Numbers    ${BSA_check}    ${BSA}

Check Dose And Frequency
    [Arguments]    ${route_arg}    ${maint_arg}    ${freq_arg}    ${calculated_arg}    ${weight_arg}
    List Selection Should Be    ${route_PO_select}    ${route_arg}
    ${maint_dose}    Remove String    ${maint_arg}    \ mgs
    Element Attribute Value Should Be    ${DosageAssigned}    value    ${maint_dose}
    ${value}    Fetch From Left    ${freq_arg}    \ \
    ${frequency}    Fetch From Right    ${freq_arg}    \ \
    List Selection Should Be    ${FrequencyValue}    ${value}
    List Selection Should Be    ${FrequencyTime}    ${frequency}
    ${calculated_dose}    Remove String    ${calculated_arg}    \ mgs
    Element Attribute Value Should Be    ${DosageCalculated}    value    ${calculated_dose}
    ${indexed_dose}    Get Value    ${indexed_dose_input}
    ${calculated_arg}    Fetch From Left    ${calculated_arg}    \ \
    ${weight_arg}    Fetch From Left    ${weight_arg}    \ \
    ${indexed_dose_check}    Evaluate    round(${calculated_arg}/${weight_arg},2)

Check Place Of Service
    [Arguments]    ${place_arg}    ${requested_arg}    ${container_arg}    ${maint_split_arg}    ${num_split_arg}
    List Selection Should Be    ${PlaceOfService}    ${place_arg}
    Element Attribute Value Should Be    ${requested_dose_input}    value    ${requested_arg}
    # List Selection Should Be    ${ContainerType}    ${container_arg}
    Element Attribute Value Should Be    ${SplitDose}    value    ${maint_split_arg}
    List Selection Should Be    ${NumberOfSplitDoseTreatments}    ${num_split_arg}

Select Ordering Location
    [Arguments]    ${location_arg}
    Click Element    ${CreatePriderOrder}
    Wait Until Element Is Enabled    ${ModalAccountID}
    Wait Until Keyword Succeeds    5s    1s    Select From List By Label    ${ModalAccountID}    ${location_arg}
    Execute JavaScript  document.activeElement.blur()
    
Input A Patient
    [Arguments]    ${patient_arg}
    Sleep    2s
    Wait Until Keyword Succeeds    5    1    Input Text    ${SelectedPatient}    ${patient_arg}
    Click Element    ${SelectedPatient}
    Set Test Variable    ${patient}    ${patient_arg}
    ${HighlightPatient}    Util.Replace Xpath    xpath=${HighlightPatient}
    Wait Until Element Is Enabled    ${HighlightPatient}    30
    Wait Until Keyword Succeeds    5s    1s    Click Element    ${HighlightPatient}
    Wait Until Page Contains Element    xpath=${select_patient_text}
    Wait Until Keyword Succeeds    10 times    3s    Click Element    xpath=${select_patient_text}
    Sleep    4s

Select Treatment Drug
    [Arguments]    ${drug_arg}  
    Select From List By Label    ${SelectTreatmentDrug}    ${drug_arg}
    Execute JavaScript  document.activeElement.blur()
    ${check}    Run Keyword And Return Status    Element Should Be Visible    ${PO_Loading}
    IF    ${check} == ${True}
        Wait Until Element Is Not Visible    ${PO_Loading}    30s
    END
    Util.Add To Dictionary    dic_arg=${PO_data}    key_arg=Medication    val_arg=${drug_arg}

Click Diagnosis
    [Arguments]    ${DX_arg}
    Wait Until Keyword Succeeds    5s    1s    Verify Loading And Select By Label    locator=PrimaryICDCode    selected_label=${DX_arg}\ -\
    Util.Add To Dictionary    dic_arg=${PO_data}    key_arg=DX_Code    val_arg=${DX_arg}

Click Create Button
    Wait Until Keyword Succeeds    5    1    Scroll Element Into View    ${ButtonCreatePO}
    Click Button    ${ButtonCreatePO}
    ${element_visible}   Run Keyword And Return Status     Wait Until Page Contains Element    ${Accept_Continue}    timeout=5s
    Run Keyword If    ${element_visible}    Wait Until Keyword Succeeds    2 times    1    Click Element    ${Accept_Continue}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Element Should Be Visible    ${PO_Loading}
    IF    ${check} == ${True}
        Wait Until Element Is Not Visible    ${PO_Loading}    30s
    END

Get PO Number
    ${PO_num}    Get Text    ${PO_num_text}
    ${PO_num}    Fetch From Right    ${PO_num}    \ \
    Util.Add To Dictionary    dic_arg=${PO_data}    key_arg=PO_Num    val_arg=${PO_num}

Get PO Dates    #Expiration Date
    ${entry_date}    Get Value    ${entry_date_input}
    ${start_date}    Get Value    ${start_date_input}
    ${exp_date}    Get Value    ${exp_date_input}
    ${today}    Util.Check Time Zone
    Set To Dictionary    ${PO_data}    Entry_Date=${entry_date}    Start_Date=${start_date}    Exp_Date=${exp_date}    Today=${today}
    Set Suite Variable    ${PO_data}

Input Referring/Ordering Provider
    [Arguments]    ${refer_arg}
    Wait Until Element Is Visible    xpath=${referring_provider_text}    30
    Sleep    3s
    Input Text    ${ReferralPhysician}    ${refer_arg}    #NPI-dataset
    Set Test Variable    ${NPI}    ${refer_arg}
    ${HighlightReferring}    Util.Replace Xpath    xpath=${HighlightReferring}
    Wait Until Element Is Visible    ${HighlightReferring}     60
    Sleep    3s
    ${referring}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${HighlightReferring}/parent::*
    FOR    ${i}    IN RANGE    20
        ${referring}    Get Text    ${HighlightReferring}/parent::*
        IF    "${referring}" != ""
            BREAK
        END
        Sleep    3s
    END
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${HighlightReferring}
    ${referral_source}    Get Selected List Label    ${referral_source_select}
    Set To Dictionary    ${PO_data}    Referring_Provider=${referring}    Referral_Source=${referral_source}
    Set Test Variable    ${PO_data}

Select Refer To Provider
    [Arguments]    ${refer_to_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Value   ${SelectReferToProvider}    ${refer_to_arg}    #referprovider-dataset
    ${refer_to}    Get Selected List Label    ${SelectReferToProvider}
    Set To Dictionary    ${PO_data}    Refer_To_Provider=${refer_to}    Refer_To_NPI=${refer_to_arg}
    Set Test Variable    ${PO_data}

Select Visit Frequency
    [Arguments]    ${frequency_arg}
    ${value}    Evaluate    random.randint(1,7)
    Select From List By Value    ${visit_frequency_value_select}    ${value}
    Select From List By Label    ${visit_frequency_select}    ${frequency_arg}\(s)
    Set To Dictionary    ${PO_data}    Visit_Frequency=${value} ${frequency_arg}\(s)
    Set Test Variable    ${PO_data}

Input Weight And Height
    [Arguments]    ${patient_weight_arg}    ${patient_height_arg}
    Input Text    ${WeightPO_input}    ${patient_weight_arg}
    Click Element    ${Radiobuton_KG}
    Input Text    ${HeightPO_input}    ${patient_height_arg}
    Set To Dictionary    ${PO_data}    Weight=${patient_weight_arg} kg    Height=${patient_height_arg} ft
    Set Test Variable    ${PO_data}

Input Dose And Frequency
    [Arguments]    ${dosageAssignedValue_arg}    ${calculated_dosage_arg}     ${dose_frequency_arg}    ${time_frequency_arg}
    ${route}    Get Selected List Label    ${route_PO_select}
    Sleep    1
    Scroll Element Into View    ${DosageAssigned}
    Wait Until Keyword Succeeds    10 times    3s    Input Text    ${DosageAssigned}    ${dosageAssignedValue_arg}
    Input Text    ${DosageCalculated}    ${calculated_dosage_arg}
    Select From List By Label    ${FrequencyValue}    ${dose_frequency_arg}
    Select From List By Label    ${FrequencyTime}    ${time_frequency_arg}
    Set To Dictionary    ${PO_data}    Route=${route}    Maint_Dose=${dosageAssignedValue_arg} mgs    Calculated_Dose=${calculated_dosage_arg} mgs    Dose_Frequency=${dose_frequency_arg} ${time_frequency_arg}
    Set Test Variable    ${PO_data}

Select Place Of Service And Preferred UoM And Container Type
    [Arguments]    ${placeOfserviceValue_arg}    ${requested_dose_arg}    ${containerTypeValue_arg}    ${splitDoseValue_arg}    ${numberOfsplitDosetreatmentsValue_arg}
    Select From List By Label    ${PlaceOfService}    ${placeOfserviceValue_arg}
    Input Text    ${requested_dose_input}    ${requested_dose_arg}
    ${check}    Get Location
    ${count_options}    Get List Items    ${preferred_UoM_select}
    ${index}    Evaluate    random.randint(1,len(${count_options})-1)
    Select From List By Index    ${preferred_UoM_select}    ${index}
    ${UoM}    Get Selected List Label    ${preferred_UoM_select}
    Set To Dictionary    ${PO_data}    UoM=${UoM}
    Select From List By Label    ${ContainerType}    ${containerTypeValue_arg}
    Input Text    ${SplitDose}    ${splitDoseValue_arg}
    Select From List By Label    ${NumberOfSplitDoseTreatments}    ${numberOfsplitDosetreatmentsValue_arg}
    Click Element    ${save_PO_btn}
    ${check}    Run Keyword And Return Status    Wait Until Page Contains    Provider Order Successfully Created!    30s
    IF    ${check} == ${False}
       Element Should Be Visible    //*[@id='SaveBtn' and text()='Accept & Continue' or text()='Accept']
       Click Button    //*[@id='SaveBtn' and text()='Accept & Continue' or text()='Accept']
       Wait Until Page Contains    Provider Order Successfully Created!    30s
    END
    Wait Until Page Does Not Contain    Provider Order Successfully Created!    30s
    Set To Dictionary    ${PO_data}    Place_Of_Service=${placeOfserviceValue_arg}    Requested_Dose=${requested_dose_arg}    Container=${UoM}    Maint_Dose_Split=${splitDoseValue_arg}    Num_Of_Treatmtents=${numberOfsplitDosetreatmentsValue_arg}
    Set Test Variable    ${PO_data}

Close Modal
    Sleep    5s
    Wait Until Keyword Succeeds    5    1    Scroll Element Into View    ${close_PO_btn}
    Wait Until Element Is Visible    ${close_PO_btn}    30s
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10s    1s    Click Button    ${close_PO_btn}
    IF    ${check} == ${False}    #button covered    #PROD
        Wait Until Keyword Succeeds    10 times    3s    Execute JavaScript    return document.evaluate("${close_PO_btn}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    END
    Wait Until Element Is Not Visible    css:#ModalPopup > div.modal-dialog > div > div.modal-body.clearfix    timeout=30s
    
Open PA
    Set Test Variable    ${PO_num}    ${PO_data.PO_Num}
    ${view_PA_btn}    Util.Replace Xpath    xpath=${view_PA_btn}
    Sleep    1s
    Wait Until Keyword Succeeds    10s    1s    Scroll Element Into View    ${view_PA_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5s    1s    Click Element    ${view_PA_btn}
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    10s    1s    Util.Scroll To Bottom
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${view_PA_btn}
    END
    Wait Until Element Is Visible    ${PA_header_text}    30s

Check PA Header
    [Arguments]    ${location_arg}
    Check Location In PA    location_arg=${location_arg}
    Check Physician Order Num
    Check Patient In PA
    Check DX
    Check Physician
    Set To Dictionary    ${PatientData}    Location_2=${location_arg}
    Set Test Variable    ${PatientData}

Check Location In PA
    [Arguments]    ${location_arg}
    ${location}    Get Text    ${PO_page_PA_location_text}
    ${location}    Get Regexp Matches    ${location}    (?<=Location: ).*?(?=\ *$)
    Should Be Equal    ${location}[0]    ${location_arg}    strip_spaces=True

Check Physician Order Num
    ${physician_order}    Get Text    ${PO_page_PA_physician_order_text}    
    Should Be Equal    ${physician_order}    Physician Order #: ${PO_data.PO_Num}    strip_spaces=True

Check Patient In PA
    List Selection Should Be    ${PO_page_PA_patient_select}    ${PatientData.Patient}

Check DX
    ${DX}    Get Text    ${PO_page_PA_DX_link}
    Should Be Equal    ${DX}    ${PO_data.DX_Code}    strip_spaces=True

Check Physician
    ${name}    Fetch From Left    ${PO_data.Referring_Provider}    \ NPI\
    ${name}    Convert To Lower Case    ${name}
    ${name}    Convert To Title Case    ${name}
    ${npi}    Fetch From Right    ${PO_data.Referring_Provider}    \NPI: \
    ${check}    Get Selected List Label    ${PO_page_PA_physician_select}
    Should Be Equal    ${check}    ${name} ( NPI# : ${npi} )

Check Provider Order MDF
    [Arguments]    ${dose_freq_arg}    ${num_arg}    ${container_arg}
    Check Medication
    Check Visit Dose
    Check Frequency    dose_freq_arg=${dose_freq_arg}
    Check Infused Over    dose_freq_arg=${dose_freq_arg}    num_arg=${num_arg}
    Check Container Type    container_arg=${container_arg}

Check Medication
    List Selection Should Be    ${PO_page_PA_medication_select}    ${PO_data.Medication}

Check Visit Dose
    ${check}    Fetch From Left    ${PO_data.Maint_Dose}    ${SPACE}
    Element Attribute Value Should Be    ${PO_page_PA_visit_dose}    value    ${check}

Check Frequency
    [Arguments]    ${dose_freq_arg}
    ${dose}    Fetch From Left    ${PO_data.Dose_Frequency}    ${SPACE}
    ${time}    Fetch From Right    ${PO_data.Dose_Frequency}    ${SPACE}
    List Selection Should Be    ${PO_page_PA_frequency_select}    ${dose}
    ${check}    Get Selected List Label    ${PO_page_PA_frequency_time_select}
    Should Be Equal    ${check}    ${time}

Check Infused Over
    [Arguments]    ${dose_freq_arg}    ${num_arg}
    ${time}    Fetch From Right    ${PO_data.Dose_Frequency}    ${SPACE}
    ${time}    Remove String    ${time}    (    )
    List Selection Should Be    ${PO_page_PA_infused_over_select}    ${PO_data.Maint_Dose_Split} ${time}

Check Container Type
    [Arguments]    ${container_arg}
    Element Attribute Value Should Be    ${PO_page_PA_container_type_select}    value    ${PO_data.Container}

Check PA Status And Confirmation
    Scroll Element Into View    ${PO_page_PA_status_confirmation_text}
    Check PA Status
    Check Confirmation Num
    Check Date Range
    Check Medication Type

Check PA Status
    List Selection Should Be    ${PO_page_PA_status_select}    Gathering Information

Check Confirmation Num
    Element Attribute Value Should Be    ${PO_page_PA_confirm_num_input}    value    ${PA_data.PA_Num}

Check Date Range
    Element Attribute Value Should Be    ${PO_page_PA_start_date_input}    value    ${PA_data.Start_Date}
    Element Attribute Value Should Be    ${PO_page_PA_end_date_input}    value    ${PA_data.End_Date}

Check Medication Type
    List Selection Should Be    ${PO_page_PA_medication_type_select}    ${PA_data.Medication_Type}

Check Payor Info And Margin Calculator
    Check Payor Information

Check Payor Information
    List Selection Should Be    ${PO_page_PA_payor_medication_select}    ${PO_data.Medication}

Update PO
    [Arguments]    ${PO_arg}    ${freq_arg}    ${height_arg}    ${container_arg}    ${num_arg}
    Select PO Row To Update    PO_arg=${PO_arg}
    Update Visit Frequency    freq_arg=${freq_arg}
    Update Height    height_arg=${height_arg}
    Update Place Of Service And UoM And Container Type    container_arg=${container_arg}    num_arg=${num_arg}

Select PO Row To Update
    [Arguments]    ${PO_arg}
    ${PO_num}    Set Variable    ${PO_data.PO_Num}
    ${PO_row}    Replace Variables    ${PO_row}
    ${edit_PO_btn}    Replace Variables    ${edit_PO_btn}
    ${check}    Run Keyword And Return Status   Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    ${edit_PO_btn}
    IF    ${check} == ${False}
        Dictionary Should Contain Item    ${PA_data}    Is_Active    ${False}
        Pass Execution    PO inactive
    END
    ${check}    Run Keyword And Return Status    Click Element    ${edit_PO_btn}
    IF    ${check} == ${False}
        Wait Until Keyword Succeeds    5s    1s    Util.Scroll To Bottom
        Wait Until Keyword Succeeds    5s    1s    Click Element    ${edit_PO_btn}
    END
    Wait Until Element Is Visible    ${PO_header_text}    30s
    Util.Wait For Page Loading    element_arg=${PO_Loading}    keyword_arg_1=Element Should Be Visible    keyword_arg_2=Wait Until Element Is Not Visible    timeout_arg=30s

Update Date Range
    ${new_start_date}    Add Time To Date    ${PO_data.Start_Date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Update Text Field    xpath_arg=${start_date_input}    new_value_arg=${new_start_date}
    ${new_exp_date}    Add Time To Date    ${PO_data.Exp_Date}    1 day    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Update Text Field    xpath_arg=${exp_date_input}    new_value_arg=${new_exp_date}
    Set To Dictionary    ${PO_data}    Old_Start_Date=${PO_data.Start_Date}    Start_Date=${new_start_date}    Old_Exp_Date=${PO_data.Exp_Date}    Exp_Date=${new_exp_date}
    Set Test Variable    ${PO_data}

Update Visit Frequency
    [Arguments]    ${freq_arg}
    ${old_frequency_value}    Fetch From Left    ${freq_arg}    \ \
    ${new_frequency_value}    Reselect field    xpath_arg=${visit_frequency_value_select}    remove_default_arg=${True}    old_value_arg=${old_frequency_value}
    ${frequency}    Fetch From Right    ${freq_arg}    \ \
    Set To Dictionary    ${PO_data}    Old_Visit_Frequency=${freq_arg}    Visit_Frequency=${new_frequency_value} ${frequency}
    Set Test Variable    ${PO_data}

Update Height
    [Arguments]    ${height_arg}
    Update Text Field    xpath_arg=${HeightPO_input}    new_value_arg=${height_arg}
    Set To Dictionary    ${PO_data}    Old_Height=${height_arg}    Height=${height_arg} ft

Update Place Of Service And UoM And Container Type
    [Arguments]    ${container_arg}    ${num_arg}
    ${check}    Get Location
    ${new_container_type}    Reselect field    xpath_arg=${ContainerType}    remove_default_arg=${True}    old_value_arg=${container_arg}
    ${new_number_split_dose}    Reselect field    xpath_arg=${NumberOfSplitDoseTreatments}    remove_default_arg=${True}    old_value_arg=${num_arg}
    Set To Dictionary    ${PO_data}    Old_Container=${container_arg}    Old_Num_Of_Treatments=${num_arg}    Container=${new_container_type}    Num_Of_Treatmtents=${new_number_split_dose}
    Set Test Variable    ${PO_data}
    Sleep    3s
    Click Element    ${save_PO_btn}
    ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    15s    1s    Element Should Be Visible    //*[@id='SubModalPopup']//*[@class='modal-content']
    IF    ${check} == ${True}
        ${check}    Run Keyword And Return Status    Wait Until Keyword Succeeds    5 times    2s   Scroll Element Into View    //*[@id='SaveBtn' and text()='Accept & Continue']
        IF    ${check} == ${True}
            Click Button    //*[@id='SaveBtn' and text()='Accept & Continue']
        END
        Wait Until Keyword Succeeds    5 times    2s    Scroll Element Into View    ${PO_accept_button}
        Wait Until Element Is Visible     ${PO_accept_button}    60s
        Wait Until Keyword Succeeds    30s    1s    Click Button    ${PO_accept_button}
    END
    Util.Wait For Page Loading    element_arg=Provider Order Successfully Updated    keyword_arg_1=Wait Until Page Contains    keyword_arg_2=Wait Until Page Does Not Contain    timeout_arg=10s

Update Text Field
    [Arguments]    ${xpath_arg}    ${new_value_arg}
    Wait Until Keyword Succeeds    5s    1s    Clear Element Text    ${xpath_arg}
    Input Text    ${xpath_arg}    ${new_value_arg}
    Wait Until Keyword Succeeds    5s    1s    Execute JavaScript  document.activeElement.blur()

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

# "Patient" page
Go to Patient
    Click Element    link: Patients
    Title Should Be    Patients

Select LoacationPatient
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${LocationPatient}
    Select From List By Label    ${LocationPatient}    ${location_arg}
    
Find Patient & go to Provider Orders
    [Arguments]    ${MRN_arg}
    Input Text    ${SearchValues}    ${MRN_arg}
    Click Element    FindButton
    Wait Until Element Is Enabled    //*[contains(text(),'Automaion, QC')]    30
    Click Element       //*[contains(text(),'Automaion, QC')]
    Click Element     //a[@id="PhysicianOrder"][contains(text(),'Provider Orders')]
    Click Element    ${CreateNewPoPatient}

Verify Loading And Select By Label
    [Arguments]    ${locator}    ${selected_label}
    ${contains_xpath}=    Run Keyword And Return Status    Should Contain    ${locator}    xpath
    IF    ${contains_xpath} == ${False}
        ${locator}=    Set Variable    id=${locator}
    END
    @{list_label}=    Wait Until Keyword Succeeds    5s    1s    Get List Items    ${locator}
    ${first_element}=    Get From List    ${list_label}    0
    ${list_length}=     Get Length    ${list_label}
    ${first_item_is_selected}    Run Keyword And Return Status    Should Contain    ${first_element}    Select
    Run Keyword if   ${list_length} <= ${1} and ${first_item_is_selected} == ${True}
    ...    Fail    No item in list
    FOR    ${element}    IN    @{list_label}
        ${Condition}=     Run Keyword And Return Status
        ...    Should Contain    ${element}    ${selected_label}
        IF    ${Condition} == ${True}
            Wait Until Keyword Succeeds    5s    1    Select From List By Label    ${locator}    ${element}
            BREAK
        END
    END
    Set Test Variable    ${element}

Check PO Discontinued
    [Arguments]    ${PO_arg}
    Set Test Variable    ${PO_num}    ${PO_arg}
    ${PO_discontinue_text}    Util.Replace Xpath    xpath=${PO_discontinue_text}
    Wait Until Keyword Succeeds    30s    1s    Scroll Element Into View    ${PO_discontinue_text}
    ${check}    Get Text    ${PO_discontinue_text}
    Should Be Equal    ${check}    Service Discontinued - ${PO_data.Medication}    strip_spaces=True