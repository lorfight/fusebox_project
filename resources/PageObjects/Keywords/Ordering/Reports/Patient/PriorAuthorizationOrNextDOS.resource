*** Settings ***
Resource    ../../../Layers/Common/Common.resource
Library    ../../../../../../libraries/CustomLibrary.py

*** Keywords ***
Click Run report for all active prior-authorizations Checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element    //input[@id="allPriorAuthorizations"]

Click Include Discontinued prior-authorizations Checkbox
    Wait Until Keyword Succeeds    30s    1s    Click Element    //input[@id="discontinuedAuthorizations"]

Select Date Range Type
    [Arguments]    ${range_type}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label   //select[@id="DateRangeType"]    ${range_type}

Input Reporting Start Date
    [Arguments]    ${startdate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    //input[@id="ReportingStartDate"]    ${startdate}
    ${startdate}    Convert Date    ${startdate}    result_format=%m/%d/%Y    date_format=%m/%d/%Y 
    Common.Choose Date In Onset Date Input    ${startdate}

Input Reporting End Date
    [Arguments]    ${enddate}
    Wait Until Keyword Succeeds    30s    1s    Input Text    //input[@id="ReportingEndDate"]    ${enddate}
    ${enddate}    Convert Date    ${enddate}    result_format=%m/%d/%Y    date_format=%m/%d/%Y
    Common.Choose Date In Onset Date Input    ${enddate}
    
Select Medication
    [Arguments]    @{medication}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label   //select[@id="ProprietaryNames"]    @{medication}

Click Unselect All Accounts Button
    Click Element    //a[text()="Unselect All"]

Click Select All Accounts Button
    Click Element    //a[text()="Select All"]

Click Account Checkbox
    [Arguments]    @{account_name}
    FOR    ${account}    IN    @{account_name}
        ${account_checkbox}    Set Variable    //div[div[normalize-space(text())='${account}']]//input
        Common.Scroll And Click Element    ${account_checkbox}
    END

Click Generate Button
    Common.Scroll And Click Element    //div[@class="modal-footer"]//button[normalize-space(text())='Generate']
    Common.Element Is Not Visible    //i[@id="loading-indicator"]    300

Generate Report
    [Arguments]    ${download_path}    ${utc}    ${range_type}    ${startdate}    ${enddate}    ${account}    ${medication}=${None}    ${all_pa_click}=${False}    ${discontinued_pa_click}=${False}
    Run Keyword If    ${all_pa_click}==${True}    Click Run report for all active prior-authorizations Checkbox
    Run Keyword If    ${discontinued_pa_click}==${True}    Click Include Discontinued prior-authorizations Checkbox
    Select Date Range Type    ${range_type}
    Input Reporting Start Date    ${startdate}
    Input Reporting End Date    ${enddate}
    Run Keyword If    ${medication}!=${None}    PriorAuthorizationOrNextDOS.Select Medication    @{medication}
    Click Unselect All Accounts Button
    Click Account Checkbox    @{account}
    Click Generate Button
    ${download_date}    Handle Datetime Format    fmt={m}_{d}_{y}    utc=${utc}
    ${download_datetime}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    utc=${utc}
    ${path}    Set Variable    ${download_path}/PriorAuthorizationNextDOS-${download_date}.xlsx
    Wait Until Keyword Succeeds    30s    1s    Should Exist    ${path}
    RETURN    ${download_datetime}    ${path}

Remove PA Report File
    [Arguments]    ${download_path}
    @{files}    List Files In Directory    ${download_path}    pattern=PriorAuthorizationNextDOS*.xlsx
    FOR    ${file}    IN    @{files}
        Remove File    ${download_path}${/}${file}
    END

Verify report displayed correctly and match the design specifications at Cell A1 - A10
    [Arguments]    ${path}    ${download_datetime}    @{expected_cell_value_list}
    ${cell_values}    Get Excel Data      ${path}    cells= A1 A2 A3 A4 A5 A6 A7 A8 A9 A10
    FOR    ${index}    ${expected_value}    IN ENUMERATE    @{expected_cell_value_list}
        ${cell_value}    Get From Dictionary    ${cell_values}    A${index+1}
        IF    ${index} == 0
            ${check_equal}    Run Keyword And Return Status    Should Be Equal As Strings    ${cell_value}    ${expected_value}
            IF    "${check_equal}" == "${False}"
                ${download_datetime_plus_1_minute}    Handle Datetime Format    fmt={m}/{d}/{y} at {h}:{mi} {ampm}    dt=${download_datetime}     add_minutes=-1
                Should Be Equal As Strings    ${cell_value}    Prior Authorization / Next DOS ( As of ${download_datetime_plus_1_minute} )
            END
        ELSE
            Should Be Equal As Strings    ${cell_value}    ${expected_value}
        END
    END

Verify report displayed correctly and match the design specifications at Report Header
    [Arguments]    ${path}
    FOR    ${cell}    IN RANGE    9
        ${cell_format}    Get Excel Data    ${path}    cells=A${cell+1}    format=True
        ${cell_format_value}    Get From Dictionary    ${cell_format}    A${cell+1}
        Should Be Equal    ${cell_format_value}[font_name]    Aptos Narrow
        Should Be Equal As Numbers    ${cell_format_value}[font_size]    12
        Run Keyword If    ${cell+1}==1    Should Be True    ${cell_format_value}[bold]
        Run Keyword If    ${cell+1}>1    Should Be True    ${cell_format_value}[italic]
        Should Be Equal    ${cell_format_value}[fill_type]    ${None}
        Should Be Equal    ${cell_format_value}[fill_color]    00000000
    END

Verify report displayed correctly and match the design specifications at Table Header
    [Arguments]    ${path}
        ${cell_list}    Create List    A11    B11    C11    D11    E11    F11    G11    H11    I11    J11    K11    L11    M11    N11    O11    P11    Q11    R11    S11    T11    U11    V11    W11    X11    Y11
        FOR    ${cell}    IN    @{cell_list}
            ${cell_format}    Get Excel Data    ${path}    cells=${cell}    format=True
            ${cell_format_value}    Get From Dictionary    ${cell_format}    ${cell}
            Should Be Equal    ${cell_format_value}[font_name]    Aptos Narrow
            Should Be Equal As Numbers    ${cell_format_value}[font_size]    11
            Should Be True    ${cell_format_value}[bold]
            Should Be True    ${cell_format_value}[wrap_text]
            Should Be Equal    ${cell_format_value}[font_color]    FF111827
            Should Be Equal    ${cell_format_value}[fill_type]    solid
            Should Be Equal    ${cell_format_value}[fill_color]    FFF3F4F6
        END
        
Verify the removed Appt Chair/Room Assignment column is no longer included in the report output
    [Arguments]    ${path}
        ${cell_list}    Create List    A11    B11    C11    D11    E11    F11    G11    H11    I11    J11    K11    L11    M11    N11    O11    P11    Q11    R11    S11    T11    U11    V11    W11    X11    Y11
        FOR    ${cell}    IN    @{cell_list}
            ${cell_format}    Get Excel Data    ${path}    cells=${cell}
            ${cell_format_value}    Get From Dictionary    ${cell_format}    ${cell}
            Should Not Contain    ${cell_format_value}    Appt Chair/Room Assignment
        END

Verify report displayed correctly and match the design specifications at Cell Alignment
    [Arguments]    ${path}    @{patient_info}
    ${left_aligned_cell_list}    Create List
        ...    Account Name\n(Location Long Name)
        ...    Last Name\n(Patient Last Name)
        ...    First Name\n(Patient First Name)
        ...    Medication Name\n(Medication on PA)
        ...    UOM\n(UOM on PA)
        ...    ROA\n(ROA on PA)
        ...    PA Medication Type\n(Medication Type on PA)
        ...    Primary ICD10\n(Primary ICD10 on PA)
        ...    Auth Assigned Specialist\n(User Name Assigned to PA)
        ...    Auth Status\n(Current Status of PA)
        ...    Auth Confirmation\n(Confirmation # on PA)
        ...    Primary Payer\n(Primary Payer Name Assigned to PA)
        ...    Secondary Payer\n(Secondary Payer Name Assigned to PA)
        ...    Auth Notes\n(Most Recent Note from PA Related Notes Section)

    ${right_aligned_cell_list}    Create List
        ...    MRN\n(Patient MRN)
        ...    DOB\n(Patient DOB)
        ...    Next Appt DOS\n(Next Sched Appt linked w/PA)
        ...    Appt Time\n(Next Sched Appt Time)
        ...    Dose\n(Dose on PA)
        ...    Auth Entry Date\n(Auth Entry Date on PA)
        ...    Auth Start Date\n(Start Date on PA)
        ...    Auth End Date\n(End Date on PA)
        ...    Days Left\n(Days on PA by Next DOS)
        ...    Approved Visits\n(Approved Visits on PA)
        ...    Used Visits\n(Used Visits on PA)

    ${cell_format}    Get Excel Data    ${path}    @{patient_info}    format=True
    FOR    ${key}    ${value}    IN    &{cell_format}[0]
        IF    $key in $left_aligned_cell_list
            Should Be Equal    ${value.horizontal}    left
        ELSE IF    $key in $right_aligned_cell_list
            Should Be Equal    ${value.horizontal}    right
        END
        Should Be Equal    ${value.vertical}    top
    END

Verify report displayed correctly and match the design specifications at Borders (Table Grid)
    [Arguments]    ${path}
    ${row_number}    Get Freeze Panes    ${path}
    Should Be Equal    ${row_number}    A12
    ${cell_list}    Create List    A11    B11    C11    D11    E11    F11    G11    H11    I11    J11    K11    L11    M11    N11    O11    P11    Q11    R11    S11    T11    U11    V11    W11    X11    Y11
    FOR    ${cell}    IN    @{cell_list}
        ${cell_format}    Get Excel Data    ${path}    cells=${cell}    format=True
        ${cell_format_value}    Get From Dictionary    ${cell_format}    ${cell}
        Should Be True    ${cell_format_value}[wrap_text]
        Should Be Equal    ${cell_format_value}[border_left_style]    thin
        Should Be Equal    ${cell_format_value}[border_right_style]    thin
        Should Be Equal    ${cell_format_value}[border_top_style]    thin
        Should Be Equal    ${cell_format_value}[border_bottom_style]    thin
        Should Be Equal    ${cell_format_value}[diagonal_up]    ${False}
        Should Be Equal    ${cell_format_value}[diagonal_down]    ${False}
    END

Verify report displayed correctly and match the design specifications when column Blank Cell Standard
    [Arguments]    ${path}    @{patient_info}
    ${cell_format}    Get Excel Data    ${path}    @{patient_info}
    ${blank_cell_list}    Create List
        ...    Next Appt DOS\n(Next Sched Appt linked w/PA)
        ...    Appt Time\n(Next Sched Appt Time)
        ...    Auth Entry Date\n(Auth Entry Date on PA)
        ...    Auth Start Date\n(Start Date on PA)
        ...    Auth End Date\n(End Date on PA)
        ...    Days Left\n(Days on PA by Next DOS)
        ...    Approved Visits\n(Approved Visits on PA)
        ...    PA Medication Type\n(Medication Type on PA)
        ...    Auth Assigned Specialist\n(User Name Assigned to PA)
        ...    Auth Confirmation\n(Confirmation # on PA)
        ...    Primary Payer\n(Primary Payer Name Assigned to PA)
        ...    Secondary Payer\n(Secondary Payer Name Assigned to PA)
     
    ${cell_format}    Get Excel Data    ${path}    @{patient_info}
    ${cell_format}    Get From List    ${cell_format}    0
    FOR    ${key}    ${value}    IN    &{cell_format}
        IF    $key in $blank_cell_list
            Should Be Equal    ${value}    -
        ELSE IF   'Auth Status' in $key
            Should Be Equal    ${value}    Requires Activation
        ELSE IF   'Used Visits' in $key
            Should Be Equal As Integers    ${value}    0
        ELSE IF   'Auth Notes' in $key
            Should Be Equal As Strings    ${value}    nan
        END
    END

