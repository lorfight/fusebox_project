*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Dispensing/Dispensing.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/Patient/Patient.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Setup Provider Orders
Test Setup    Test Setup Provider Orders
Test Teardown    Test Teardown Provider Orders
Suite Teardown    Save Captured Api And Close Browser
Test Tags    test:retry(2)    Prime_physician    DIS_POS

*** Test Cases ***
Provider Order Creation Process
	[Documentation]    DIS-11    DIS-12    DIS-14    DIS-15
	[Tags]    smoke    Provider Orders    report.label.owner: Hai Nguyen
    Config Emr Mapping
    Go To Provider Orders Page
    ${provider_dict}    Create PO Required Fields    
        ...    location_arg=${data_input}[location] (${data_input}[account_id])
        ...    mrn_arg=${data_input}[mrn] 
        ...    drug_arg=${data_input}[medication_first]  
        ...    refer_arg=${data_input}[referring_provider]
        ...    refer_to_arg=${data_input}[npi_number] 
        ...    patient_weight_arg=70 
        ...    dosageAssignedValue_arg=10
        # ...    dose_arg=10    
        # ...    activate_arg=Maintenance Dose
    ${po_num}    Set Variable    ${provider_dict.po_num}
    Filter PO Navigate Mrn    
        ...    location_arg=${data_input}[location] (${data_input}[account_id])
        ...    mrn_arg=${data_input}[mrn] 
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click Search PO
    Edit PO    
        ...    po_num=${po_num}
        ...    patient_height_arg=120
        ...    dict_arg=${provider_dict}
    Print Order Successfully    
        ...    po_arg=${po_num}    
        ...    mrn_arg=${data_input}[mrn] 
        ...    date_arg=${provider_dict.start_date}
    Open Documents Successfully    ${po_num}
    View PA Successfully    ${po_num}
    Publish Provider Order Successfully    ${po_num}    ${True}
    Verify Provider Order Is Published    ${po_num}    ${True}
    Assign Provider Order Successfully    ${po_num}    ${True}
    Verify Provider Order Is Assigned    ${po_num}    ${True}

Import Provider Order
	[Documentation]    DIS-13
	[Tags]    Smoke    Provider Orders    report.label.owner: Hai Nguyen
    Go To Provider Orders Page
    ${df}   ${path}    Get Provider Order Import Template File
    ${keys}    Create List     
        ...    Account #  
        ...    Patient MRN   
        ...    Medication
        ...    ICD10 Code
        ...    Order Date
        ...    Expiration Date
        ...    Referring/Ordering Provider - NPI
        ...    Refer To Provider - NPI
        ...    Patient Weight in KG
        ...    Route Of Administration
        ...    Assigned Dose
        ...    Dose Frequency Qty
        ...    Frequency Qty Unit
        ...    Infused Over Days
        ...    Number Of Doses
    ${order_date}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=+7
    ${exp_date}    Handle Datetime Format    fmt={m}/{d}/{y}    utc=+7    add_days=7
    Prepare Provider Order Data
        ...    keys=${keys}
        ...    df=${df}    
        ...    path=${path}
        ...    account_arg=${data_input}[account_id] 
        ...    mrn_arg=${data_input}[mrn] 
        ...    medication_arg=${data_input}[medication_second] 
        ...    icdecode_arg=${data_input}[icd_code] 
        ...    order_date_arg=${order_date}
        ...    exp_date_arg=${exp_date}
        ...    referring_arg=${data_input}[npi_number] 
        ...    referto_arg=${data_input}[npi_number] 
        ...    weight_arg=70
        ...    route_arg=${data_input}[route] 
        ...    assigned_dose_arg=10
        ...    dose_quantity_arg=10
        ...    quantity_unit_arg=Week(s)
        ...    over_days_arg=10
        ...    number_doses_arg=10 
    Import Provider Order Excel File
        ...    path=${path}    
        ...    msg=File Successfully Imported!
        ...    color_arg=green
        ...    text_arg=Success
    Confirm Import Provider Order File
    Filter PO Navigate Mrn    
        ...    location_arg=${data_input}[location] (${data_input}[account_id])
        ...    mrn_arg=${data_input}[mrn] 
    Clear Filter Checkbox
        ...    expect_status=${False}
    Click Search PO
    ${po_row}    Set Variable    //div[normalize-space(.)='${data_input}[medication_second]']
    Wait Until Element Is Visible    ${po_row}    30s
    Run Keyword And Return Status    Remove File    ${path}

*** Keywords ***
Suite Setup Provider Orders
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    ${original_window}    Get Window Handles 
    Set Suite Variable    ${original_window}
    Create Patient

Create Patient
    ${PatientCreate}    Patient.Create Patient With Necessary Information    
        ...    location_arg=${data_input}[location]    
        ...    mrn_arg=${data_input}[mrn]    
        ...    mrn_merge_arg=${data_input}[mrn_merge]
        ...    refering_provider_arg=${data_input}[referring_provider]

Test Setup Provider Orders
    Execute Javascript    window.open(window.location.href, '_blank')
    Switch Window    NEW

Test Teardown Provider Orders
    Close Window
    Switch Window    ${original_window}[0]

Open Documents Successfully
    [Arguments]    ${po_arg}
    Click Document Button    ${po_arg}
    Verify Document Popup Shows Remain Fields
    Common.Close Modal Popup

View PA Successfully
    [Arguments]    ${po_arg}
    Click Prior Auth Button    ${po_arg}
    Wait Until Element Is Visible    //h4[text()='Prior Authorization']    30s
    Common.Close Modal Popup

Config Emr Mapping
    Accounts.Go To Accounts
    Accounts.Filter Account In Accounts Page    ${data_input}[location] 
    Accounts.Choose Account In Accounts Page    ${data_input}[account_id] 
    Accounts.Click Technical Button
    Accounts.Select Emr Mapping    ${data_input}[emr_name] 
    Accounts.Click Save Button In Edit Account Page
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Accounts

