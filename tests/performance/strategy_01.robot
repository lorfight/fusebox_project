*** Settings ***
Resource    ../../resources/PageObjects/Keywords/Layers/AppointmentOrderingLedger/AppointmentOrderingLedger.resource
Resource    ../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../resources/PageObjects/Keywords/Inventory/Inventory.resource
Resource    ../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../resources/PageObjects/Keywords/Patient/Patient.resource
Library    ../../libraries/cdp_helper.py

Suite Setup    Init CSV File
Test Teardown    Close All Browsers
Test Tags    test:retry(5)
*** Variables ***
${PERF_DURATION}    600
${CSV_FILE}    ${EXECDIR}\\results\\export\\${Username}.csv
*** Test Cases ***
Perf Endpoints Core System
    [Tags]    Prime    Core
    Login To Fusebox    user_name=${Username}    password=${Password}
    WHILE   True
        Measure Endpoint Performance    Appointment/AppointmentList    POST
        ...    Appointment list
        Measure Endpoint Performance    Inventory/LoadReconciledItems    POST
        ...    Load Reconciled Items
        Measure Endpoint Performance    Inventory/LevelList    POST
        ...    Inventory Level List
        Measure Endpoint Performance    Order/List    POST
        ...    Order List
        Measure Endpoint Performance    Patient/PatientList    POST
        ...    Patient List
        Measure Endpoint Performance    Appointment/getMemberMedications    GET
        ...    Appointment Get Member Medications
        Measure Endpoint Performance    Appointment/LoadPatientAppointmentModal    GET
        ...    Appointment Load Patient AppointmentModal
    END

Perf Endpoints Report
    [Tags]    Prime    Report
    Login To Fusebox    user_name=${Username}    password=${Password}
    Go to Reports
    ${driver}    Get Webdriver Instance
    Enable Network    ${driver}
    Set Test Variable    ${driver}
    WHILE   True
        Measure Endpoint Performance    Report/ComprehensiveInventoryReportParameterSelector    GET
        ...    Comprehensive Inventory Report Parameter Selector

        Measure Endpoint Performance    Report/ComprehensiveOnHandInventoryReport    POST
        ...    Comprehensive On Hand Inventory Report Parameter Selector

        Measure Endpoint Performance    Report/ComprehensivePurchaseOrderReport    POST
        ...    Comprehensive Purchase Order Report Paramaeter Selector

        Measure Endpoint Performance    Report/ComprehensiveEncounterCostReport    POST
        ...    Comprehensive Encounter Cost Report

        Measure Endpoint Performance    Report/ComprehensiveEndOfMonthSummaryReport    POST 
        ...    Comprehensive End Of Month Summary Report Parameter Selector

        Measure Endpoint Performance    Report/ComprehensiveProviderOrderReport    POST 
        ...    Comprehensive Provider Order Report
        
    END

*** Keywords ***
Appointment list
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location    QCA1
    AppointmentOrderingLedger.Click Search Button
    Waiting For Loading
    ${duration}    Get Endpoint    Appointment/AppointmentList
    RETURN    ${duration}
    
Load Reconciled Items
    InventoryReconcile.Go To Inventory Reconcile And Select Location And Facility    QCA1    Default Inventory
    ${duration}    Get Endpoint    Inventory/LoadReconciledItems
    RETURN    ${duration}

Inventory Level List
    InventoryLevels.Go To Inventory Level And Select Location And Facility    QCA1    Default Inventory
    ${duration}    Get Endpoint    Inventory/LevelList
    RETURN    ${duration}

Order List
    Go To Open Orders
    OrderFilter.Filter By Location    QCA1
    Click Search
    ${duration}    Get Endpoint    Order/List
    RETURN    ${duration}

Patient List
    Go To Patients Page
    Select Location In Patient List    QCA1
    ${duration}    Get Endpoint    Patient/PatientList
    RETURN    ${duration}

Appointment Get Member Medications
    Go to Provider Orders
    Click Create Provider Order
    Waiting For Loading
    Click Close Provider Order Popup
    ${duration}    Get Endpoint    Appointment/getMemberMedications
    RETURN    ${duration}

Appointment Load Patient AppointmentModal
    AppointmentOrderingLedger.Go To Appointment Ordering Ledger Via New Dispense Link
    AppointmentOrderingLedger.Filter By Location    QCA1
    AppointmentOrderingLedger.Click Search Button
    Waiting For Loading
    Click Element    link:Open Appointment
    Waiting For Loading
    ${future_apt}    Run Keyword And Return Status    Wait Until Page Contains ELement   //*[@id="SubModalPopup" and @aria-hidden="false"]//*[contains(text(),"Yes / Continue")]    10s
    IF    ${future_apt} == ${True}
        Click Button    //*[@id="SubModalPopup" and @aria-hidden="false"]//*[contains(text(),"Yes / Continue")]
    END
    Waiting For Loading
    Common.Close Modal Popup
    ${duration}    Get Endpoint    Appointment/LoadPatientAppointmentModal
    RETURN    ${duration}
# Inventory Level

Comprehensive On Hand Inventory Report Parameter Selector
    # Go to Reports
    Comprehensive Excel Reports Inventory    On Hand Report
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    Waiting For Loading
    ${duration}    Get Endpoint Report    Report/ComprehensiveOnHandInventoryReport
    Close SubModal Popup
    RETURN    ${duration}


Comprehensive Purchase Order Report Paramaeter Selector
    # Go to Reports
    Comprehensive Excel Reports Purchase Order    Purchase Order Excel
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    Waiting For Loading
    ${duration}    Get Endpoint    Report/ComprehensivePurchaseOrderReport
    Close SubModal Popup
    RETURN    ${duration}

Comprehensive Encounter Cost Report
    # Go to Reports
    Comprehensive Excel Reports Dispense     Encounter Cost Report
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    Waiting For Loading
    ${duration}    Get Endpoint Report    Report/ComprehensiveEncounterCostReport
    Close SubModal Popup
    RETURN    ${duration}

Comprehensive Inventory Report Parameter Selector
    Comprehensive Excel Reports Log    Insurance API Calls
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    ${duration}    Get Endpoint    Report/ComprehensiveInventoryReportParameterSelector
    Close SubModal Popup
    RETURN    ${duration}

Comprehensive End Of Month Summary Report Parameter Selector
    Comprehensive Excel Reports Inventory    End of Month Summary
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    Waiting For Loading
    Wait Until Page Does Not Contain Element    //*[@id="loading-indicator" and not(contains(@class,"hidden"))]    60s
    ${duration}    Get Endpoint    Report/ComprehensiveEndOfMonthSummaryReport
    Close SubModal Popup
    RETURN    ${duration}

Comprehensive Provider Order Report
    Comprehensive Excel Reports Patient    Provider Order/Authorization Report
    Click Element    //*[@id="SaveBtn" and contains(text(),"Generate")]
    Waiting For Loading
    ${duration}    Get Endpoint Report    Report/ComprehensiveProviderOrderReport
    Close SubModal Popup
    RETURN    ${duration}

Get Endpoint
    [Arguments]    ${endpoint}
    ${entries}=    Execute Javascript    return performance.getEntriesByType('resource')
    ${apis}=    Evaluate    [e for e in $entries if '${endpoint}' in e['name']]
    ${api}=    Set Variable    ${apis}[-1]
    ${duration}=    Set Variable    ${api}[duration]
    RETURN    ${duration}

Get Endpoint Report
    [Arguments]    ${endpoint}
    # Log    ${endpoint} duration: ${duration}
    ${urls}    Get Document Requests    ${driver}
    ${apis}=    Evaluate    [e for e in $urls if '${endpoint}' in e['url']]
    ${api}=    Set Variable    ${apis}[-1]
    ${duration}=    Set Variable    ${api}[duration_ms]
    RETURN    ${duration}

Measure Endpoint Performance
    [Arguments]    ${endpoint_id}    ${method}    ${action_keyword}    @{action_args}
    ${start}=    Get Current Date    result_format=epoch
    
    ${duration}    Run Keyword    ${action_keyword}    @{action_args}
    ${duration}    Evaluate    round(${duration},4)
    Waiting For Loading
    
    Log To Console    [${method}] ${endpoint_id} responded in ${duration} ms
    ${timestamp}    Get Current Date
    ${line}    Set Variable    ${timestamp},${Username},${method},${endpoint_id},${duration}\n
    Append To File    ${CSV_FILE}    ${line}

Init CSV File
    ${exists}    Run Keyword And Return Status    File Should Exist    ${CSV_FILE}
    IF    not ${exists}
        Create File    ${CSV_FILE}    timestamp,user,method,endpoint,duration\n
    END