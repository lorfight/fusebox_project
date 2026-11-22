*** Settings ***
Resource    ../../Layers/Common/Common.resource

*** Variables ***
${report_viewer_title}    //div[text()='Condensed Appointment Prior Authorizations']
${aps_start_date_input}    //div[text()='Start Date']//following::input[@data-role="datepicker"][1]
${aps_end_date_input}    //div[text()='End Date']//following::input[@data-role="datepicker"][1]
${aps_search_by_patient_input}    //div[text()='Search By Patient']//following::input[1]
${aps_search_by_medication_input}    //div[text()='Search By Medication']//following::input[1]
${aps_selected_account_table}    //div[text()='Selected Account']//following::div[2]

*** Keywords ***
Go To Appointment Prior Auth Status
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Appointment Prior Auth Status

Go To Condensed Appointment Prior Authorizations Page
    Switch Window    title=Report Viewer
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Report Viewer
    Set Window Size    1920    1080

Verify Condensed Appointment Prior Authorizations Is Displayed All Fields Correctly
    ${column_name_list}    Create List    
    ...    Account Name    
    ...    Date Of Service
    ...    Time
    ...    Patient First Name
    ...    Patient Last Name
    ...    DOB
    ...    ICD10
    ...    Therapy / Drug
    ...    Dose
    ...    UoM
    ...    Route
    ...    Cv1 Plan Name
    ...    Cv2 Plan Name
    ...    Appointment Type
    ...    Prior Auth Status
    ...    Prior Auth Start
    ...    Prior Auth End
    ...    Auth #
    ...    Used Visits to Date
    ...    Approved Visits Total

    FOR    ${column_name}    IN    @{column_name_list}
        ${column}    Set Variable    //div[normalize-space(.)='${column_name}']
        Wait Until Element Is Visible    ${column}    120s
    END

Verify Condensed Appointment Prior Authorizations Document Map Area Is Displayed All Fields Correctly
    ${element_list}    Create List    
    ...    ${aps_start_date_input}
    ...    ${aps_end_date_input}
    ...    ${aps_search_by_patient_input}
    ...    ${aps_search_by_medication_input}
    ...    ${aps_selected_account_table}

    FOR    ${element}    IN    @{element_list}
        Wait Until Element Is Visible    ${element}    30s
    END 
    
Close Condensed Appointment Prior Authorizations Window
    [Arguments]    ${window_arg}
    Close Window
    Switch Window    ${window_arg}
