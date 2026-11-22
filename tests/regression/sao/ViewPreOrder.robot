*** Settings ***
Documentation    Scheduled Appointment Ordering
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Test Tags    test:retry(2)    SAO_03    SAO    ClinicRegresSAO
Suite Setup    PreOrder Suite Setup
Test Setup    PreOrder Test Setup
Library    CustomLibrary

*** Test Cases ***
Verify View SAO PreOrder Screen
    [Documentation]    SAO_REG_083    SAO_REG_084
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Wait Until Element Is Visible    //*[@id='QtyToOrder']//following::*[@class='badge' and text()='Recommended'][1]    30s
    Wait Until Element Is Visible    //*[contains(@class,'OrderTableRow')]//*[contains(text(),'${med}')]//following::text()[contains(.,'${ndc}')][1]//parent::*

Verify SAO Export To Excel
    [Documentation]    SAO_REG_087    SAO_REG_088
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    ${date_exp}    Set Variable    ${date}
    Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date_exp}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date_exp}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Export Excel File
    ${data}    CustomLibrary.Read Excel File    path=${path}    header=${null}
    Set Test Variable    ${data}
    Verify Date Range Export File    start=${date_exp}    end=${date_exp}
    Verify User Export File    user=${user}
    Verify Description Export File    med=${med}
    Verify Qty To Order Export File    qty=2

Verify Other Contracted Primary Therapies
    [Documentation]    SAO_REG_089    SAO_REG_090    SAO_REG_091    SAO_REG_092    SAO_REG_093    SAO_REG_094    SAO_REG_095    SAO_REG_096    SAO_E2E_005
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    ${ndc_prim}    Set Variable    ${ndc}
    Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Expand And Collapse Other Contracted
    Click Add Other Contracted
    ${num_tab}    Set Variable    1
    Wait Until Page Contains Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'PrimaryTherapiesSection') and @aria-expanded='true']
    Input To Search Other Contracted    ndc=${ndc_other}
    Click Find Other Contracted Button
    # ${is_loading}    Run Keyword And Return Status    Page Should Contain Element    //*[contains(@id,'PrimaryTherapiesTable')]//*[contains(@class,'spinner')]
    # Run Keyword If    ${is_loading} == ${True}    Wait Until Page Does Not Contain Element    //*[contains(@id,'PrimaryTherapiesTable')]//*[contains(@class,'spinner')]    30s
    Wait Until Keyword Succeeds    10 times    3s    Verify Display Other Contracted Therapy    ndc=${ndc_other}
    Wait Until Keyword Succeeds    10 times    3s    Verify Default Qty Required    ndc=${ndc_other}    qty=N/A
    Wait Until Keyword Succeeds    10 times    3s    Input Qty To Order Other Contracted    ndc=${ndc_other}    qty=1
    Click To Add Item To Order    ndc=${ndc_other}
    ${ndc}    Set Variable    ${ndc_other}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][1]//*[contains(@class,'AppointmentOrderTable')]//text()[contains(.,'${ndc}')][1]//ancestor::*[contains(@class,'otherTherapyRow')]
    ${ndc}    Set Variable    ${ndc_prim}
    Input To Search Other Contracted    ndc=${ndc_prim}
    Click Find Other Contracted Button
    ${is_loading}    Run Keyword And Return Status    Page Should Contain Element    //*[contains(@id,'PrimaryTherapiesTable')]//*[contains(@class,'spinner')]
    Run Keyword If    ${is_loading} == ${True}    Wait Until Page Does Not Contain Element    //*[contains(@id,'PrimaryTherapiesTable')]//*[contains(@class,'spinner')]    15s
    Wait Until Page Contains   No Items    30s

Verify Unfulfilled Appointments Table
    [Documentation]    SAO_REG_097    SAO_REG_098    SAO_REG_099    SAO_REG_100    SAO_REG_101    SAO_REG_102    SAO_REG_103    SAO_REG_104    SAO_REG_105    SAO_REG_106    SAO_REG_107
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date_empty}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date_empty}
    Click Refresh Unfulfilled Button
    ${date}    Remove String Using Regexp    ${date_empty}    ^0|((?<=/)0)
    ${xpath_time_ptn_1}    Verify Time Of Service    date=${date}    time=7:00 AM
    ${date}    Remove String Using Regexp    ${date_empty}    ^0|((?<=/)0)
    ${xpath_time_ptn_2}    Wait Until Keyword Succeeds    10 times    3s    Verify Time Of Service    date=${date}    time=8:00 AM
    Set Test Variable    ${xpath_time}    ${xpath_time_ptn_1}
    Verify Patient Info    patient=${patient}    dob=${dob}    mrn=${mrn}
    Set Test Variable    ${xpath_time}    ${xpath_time_ptn_2}
    Verify Patient Info    patient=${patient}     dob=${dob_2}    mrn=${mrn_2}
    Set Test Variable    ${xpath_time}    ${xpath_time_ptn_1}
    Verify Treating Therapy    therapy=${med}
    Verify Status    status=Scheduled

Verify Fulfill ParLevels
    [Documentation]    SAO_REG_110    SAO_REG_111    SAO_REG_112    SAO_REG_113    SAO_REG_114    SAO_E2E_006    SAO_E2E_007
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Verify ParLevels Checkbox
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Verify Badge Count

Verify Build Order
    [Documentation]    SAO_REG_086    SAO_REG_131    SAO_REG_135    SAO_E2E_003
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc}
    Go To Scheduled Appointment Ordering
    Filter SAO Account    account_arg=${loc}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc}
    Choose SAO Account    account_arg=${loc}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Input Qty To Order    num_tab=1    ndc=${ndc}    qty=1
    Click Build Order By Tab
    Count Windows Number    num=2
    Wait Until Keyword Succeeds    10 times    3s    Switch To Another Window    Build Order
    ${order}    Wait Until Keyword Succeeds    10 times    3s    Get Order Number
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Item    line=1    ndc=${ndc}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Desc    line=1    med=${med}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Qty    line=1    qty=1
    # Wait Until Keyword Succeeds    10 times    3s    Verify Order Contract    line=1    num=${cont}
    Close Window
    Wait Until Keyword Succeeds    10 times    3s    Switch To Another Window    Appointment Ordering Ledger
    Page Should Not Contain    Approve / Adjust Ordering Quantities

Verify Build All Orders
    [Documentation]    SAO_REG_085   SAO_REG_122    SAO_REG_123    SAO_REG_124    SAO_REG_125    SAO_E2E_004
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    ${loc_1}    Set Variable    ${loc}
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc_1}
    Go To Scheduled Appointment Ordering
    Wait Until Keyword Succeeds    10 times    3s    Click Clear SAO Account Button
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc_1}
    Choose SAO Account    account_arg=${loc_1}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc_2}
    Run Keyword And Ignore Error    Choose SAO Account    account_arg=${loc_2}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    ${num_tab}    Wait Until Keyword Succeeds    10 times    3s   Find Click Location Tab    loc=${loc_1}
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(@class,'SelectedAccountTabs') and text()[contains(.,'${loc}')]]    30s
    Input Qty To Order    num_tab=${num_tab}    ndc=${ndc}    qty=1
    ${num_tab}    Wait Until Keyword Succeeds    10 times    3s   Find Click Location Tab    loc=${loc_2}
    ${loc}    Set Variable    ${loc_2}
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(@class,'SelectedAccountTabs') and text()[contains(.,'${loc}')]]/self::*[@aria-expanded='true']    30s
    Input Qty To Order    num_tab=${num_tab}    ndc=${ndc}    qty=1
    Click Build All Orders Button
    Count Windows Number    num=3
    ${window}    Get Window Handles
    Switch Window    ${window}[1]
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    Build Order
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    id=CustomerId
    ${loc}    Get Selected List Label    id=CustomerId
    ${check_loc}    Run Keyword And Return Status    Should Be Equal    ${loc}    ${loc_1}
    Run Keyword If    ${check_loc} == ${False}    Switch Window    ${window}[2]
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    id=CustomerId
    ${loc}    Get Selected List Label    id=CustomerId
    ${order}    Wait Until Keyword Succeeds    10 times    3s    Get Order Number
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Item    line=1    ndc=${ndc}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Desc    line=1    med=${med}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Qty    line=1    qty=1
    # Wait Until Keyword Succeeds    10 times    3s    Verify Order Contract    line=1    num=${cont}
    Run Keyword If    ${check_loc} == ${True}    Switch Window    ${window}[2]
    ...    ELSE    Switch Window    ${window}[1]
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    id=CustomerId
    ${loc}    Get Selected List Label    id=CustomerId
    Should Be Equal    ${loc}    ${loc_2}
    ${order}    Wait Until Keyword Succeeds    10 times    3s    Get Order Number
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Item    line=1    ndc=${ndc}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Desc    line=1    med=${med}
    Wait Until Keyword Succeeds    10 times    3s    Verify Order Qty    line=1    qty=1
    # Wait Until Keyword Succeeds    10 times    3s    Verify Order Contract    line=1    num=${cont}
    Wait Until Keyword Succeeds    10 times    3s    Switch To Another Window    Appointment Ordering Ledger
    Page Should Not Contain    Approve / Adjust Ordering Quantities
    Switch Window    ${window}[1]
    Close Window
    Switch Window    ${window}[2]
    Close Window
    Wait Until Keyword Succeeds    10 times    3s    Switch To Another Window    Appointment Ordering Ledger

Verify Error Messages
    [Documentation]    SAO_REG_141    SAO_REG_143    SAO_REG_144    SAO_REG_145    SAO_REG_147    SAO_REG_148    SAO_REG_149    SAO_REG_151    SAO_REG_152
    [Tags]    regression    PreOrder    report.label.owner: Vu Nguyen
    ${loc_1}    Set Variable    ${loc}
    AppointmentOrderingLedger.Filter By Location    location_arg=${loc_1}
    Go To Scheduled Appointment Ordering
    Run Keyword And Ignore Error    Filter SAO Account    account_arg=${EMPTY}
    Run Keyword And Ignore Error    Click Unlock Account    acc=${loc_2}
    Choose SAO Account    account_arg=${loc_2}
    Click Order Product By Date Range Checkbox
    Input Start Date In Order Product By Date Range    order_product_enddate_arg=${date_err}
    Input End Date In Order Product By Date Range    order_product_enddate_arg=${date_err}
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    ${num_tab}    Wait Until Keyword Succeeds    10 times    3s   Find Click Location Tab    loc=${loc_2}
    ${loc}    Set Variable    ${loc_2}
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(@class,'SelectedAccountTabs') and text()[contains(.,'${loc}')]]    30s
    Wait Until Keyword Succeeds    10 times    3s    Verify Badge Count Color    color=green    num_tab=2
    ${count}    Get Badge Count    num_tab=${num_tab}
    Should Be True    ${count} == 0
    Wait Until Keyword Succeeds    10 times    3s    Verify Error Message Line    ndc=${ndc_empty}    txt=not.*have.*contract.*speak.*representative.*set    num_tab=${num_tab}
    Click Build Order By Tab    num_tab=${num_tab}
    Wait Until Page Contains    Cannot create an empty order    30s
    Wait Until Page Does Not Contain    Cannot create an empty order    30s
    Verify Warning Icon Visible Or Not    is_visible=${True}    num_tab=${num_tab}
    ${num_tab}    Wait Until Keyword Succeeds    10 times    3s   Find Click Location Tab    loc=${loc_1}
    ${loc}    Set Variable    ${loc_1}
    Wait Until Page Contains Element    //*[contains(@class,'active')]//*[contains(@class,'SelectedAccountTabs') and text()[contains(.,'${loc}')]]    30s
    Wait Until Keyword Succeeds    10 times    3s    Verify Badge Count Color    color=fire
    ${count}    Get Badge Count    num_tab=${num_tab}
    Should Be True    ${count} > 0
    Verify Warning Icon Visible Or Not    is_visible=${False}    num_tab=${num_tab}
    Click Back Button
    Handle Alert    timeout=15s
    Wait Until Page Does Not Contain    Approve / Adjust Ordering Quantities    30s

*** Keywords ***
Verify ParLevels Checkbox
    CommonKeywords.Scroll To Bottom
    Wait Until Keyword Succeeds    5 times    3s    Select Or Unselect Fulfill ParLevels Checkbox    ${True}
    Wait Until Keyword Succeeds    5 times    3s    Checkbox Should Be Selected    id\=FulfillPars
    CommonKeywords.Scroll To Bottom
    Execute Javascript    window.scrollBy(0,60)
    Select Or Unselect Fulfill ParLevels Checkbox    ${False}
    Wait Until Keyword Succeeds    5 times    3s    Checkbox Should Not Be Selected    id\=FulfillPars
    Select Or Unselect Fulfill ParLevels Checkbox    ${True}
    Wait Until Keyword Succeeds    5 times    3s    Checkbox Should Be Selected    id\=FulfillPars
    Click Create an Order for All Scheduled Appointments Button
    Wait Until Page Contains    Approve / Adjust Ordering Quantities    30s
    Click Back Button
    ${is_alert}    Run Keyword And Return Status  Handle Alert    timeout=15s
    Run Keyword If    ${is_alert} == ${False}    Click Back Button
    Wait Until Keyword Succeeds    5 times    3s    Scroll Element Into View    id\=FulfillPars
    Checkbox Should Be Selected    id\=FulfillPars

Verify Time Of Service
    [Arguments]    ${date}    ${time}    ${num_tab}=1
    ${xpath_time}    Set Variable    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'DateOfServiceRow')]//*[contains(text(),'${date}')]//following::*[contains(text(),'${time}')][1]//ancestor::*[contains(@class,'Unfulfilled')]
    Scroll Element Into View    ${xpath_time}
    RETURN    ${xpath_time}

Verify Patient Info
    [Arguments]    ${patient}    ${dob}    ${mrn}    ${xpath_time}=${xpath_time}
    Scroll Element Into View    ${xpath_time}/*[2]/*[contains(text(),'${patient} \(${dob})')]
    Scroll Element Into View    ${xpath_time}/*[2]//*[text()[contains(.,'${mrn}')]]

Verify Treating Therapy
    [Arguments]    ${therapy}    ${xpath_time}=${xpath_time}
    Scroll Element Into View    ${xpath_time}/*[3]/*[contains(text(),'No Primary Medication Assigned')]

Verify Status
    [Arguments]    ${status}    ${xpath_time}=${xpath_time}
    Scroll Element Into View    ${xpath_time}/*[4]/*[contains(text(),'${status}')]

Display All Sections
    [Arguments]    ${med}
    Wait Until Element Is Visible    //*[@id='QtyToOrder']//following::*[@class='badge' and text()='Recommended'][1]    30s
    Wait Until Element Is Visible    //*[contains(@class,'PrimaryMedication')]//following::*[contains(text(),'Primary Medications')][1]//following::*[contains(text(),'${therapy}')][1]
    Common.Scroll And Click Element    //*[contains(@id,'ExpandButton')]//*[contains(text(),'Other Contracted')][1]
    Wait Until Element Is Visible    //*[contains(@id,'PrimaryTherapies') and contains(@class,'collapse')]//*[contains(text(),'Add Other Contracted')][1]    30s

Find Click Location Tab
    [Arguments]    ${loc}
    ${tab}    Set Variable    //*[contains(@class,'TabScrollerlist')and contains(@class,'Wrapper')]//*[\${num_tab}]//*[contains(@class,'SelectedAccountTabs')]
    ${num_tab}    Set Variable    *
    ${temp}    Replace Variables    ${tab}
    ${count}    Get Element Count    ${temp}
    FOR    ${num_tab}    IN RANGE    1    ${count+1}
        ${temp}    Replace Variables    ${tab}
        ${check}    Run Keyword And Return Status    Element Should Contain    ${temp}    ${loc}
        IF    ${check} == ${True}
            Sleep    2s
            Click Element    ${temp}
            BREAK
        END
    END
    RETURN    ${num_tab}

Click Build Order By Tab
    [Arguments]    ${num_tab}=1
    Common.Scroll And Click Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'SubmitOrderButton')]

Count Windows Number
    [Arguments]    ${num}
    ${windows}    Get Window Names
    ${check}    Run Keyword And Return Status    Length Should Be    ${windows}    ${num}

Get Order Number
    Scroll Element Into View    //*[contains(text(),'PO #')]//following::*[@id='SetDistibutorPONumberButton'][1]
    Wait Until Element Is Visible    //*[contains(text(),'PO #')]//following::*[@id='SetDistibutorPONumberButton'][1]    10s
    ${num}    Get Text    //*[contains(text(),'PO #')]//following::*[@id='SetDistibutorPONumberButton'][1]
    RETURN    ${num}

Verify Order Item
    [Arguments]    ${line}    ${ndc}
    Scroll Element Into View    //*[@data-linenumber='${line}']//*[contains(text(),'Item:')]//following::*[@id='itemId' and contains(text(),'${ndc}')][1]

Verify Order Desc
    [Arguments]    ${line}    ${med}
    Scroll Element Into View    //*[@data-linenumber='${line}']//*[contains(text(),'Desc:')]//parent::*[@class]
    ${txt}    Get Text    //*[@data-linenumber='${line}']//*[contains(text(),'Desc:')]//parent::*[@class]
    Should Contain    ${txt}    ${med}    ignore_case=True

Verify Order Qty
    [Arguments]    ${line}    ${qty}
    Scroll Element Into View    //*[@data-linenumber='${line}' and @name='item.Qty']
    Element Attribute Value Should Be    //*[@data-linenumber='${line}' and @name='item.Qty']    value    ${qty}

Verify Order Contract
    [Arguments]    ${line}    ${num}
    Scroll Element Into View    //*[@data-linenumber='${line}']//*[contains(@id,'ContractAndDistributor')]
    ${label}    Get Selected List Label    //*[@data-linenumber='${line}']//*[contains(@id,'ContractAndDistributor')]
    Should Contain    ${label}    ${num}    strip_spaces=True

Expand And Collapse Other Contracted
    [Arguments]    ${num_tab}=1
    ${is_collapse}    Run Keyword And Return Status    Wait Until Page Contains Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'PrimaryTherapiesSection') and @aria-expanded='true']
    IF    ${is_collapse} == ${False}
        Click Add Other Contracted    num_tab=${num_tab}
        Wait Until Page Contains Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'PrimaryTherapiesSection') and @aria-expanded='true']    30s
    END
    Click Add Other Contracted    num_tab=${num_tab}
    Wait Until Page Does Not Contain Element    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@id,'PrimaryTherapiesSection') and @aria-expanded='true']    30s

Verify Display Other Contracted Therapy
    [Arguments]    ${ndc}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'otherTherapyRow')]//text()[contains(.,'${ndc}')][1]//parent::*

Verify Default Qty Required
    [Arguments]    ${ndc}    ${qty}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'otherTherapyRow')]//text()[contains(.,'${ndc}')][1]//following::*[contains(@class,'QtyRequired') and text()='${qty}'][1]

Export Excel File
    ${date_ame_chi}    CustomLibrary.Get Time Now    time_zone=America/Chicago    result_format=%m/%d/%Y
    ${date_asi_sin}    CustomLibrary.Get Time Now    time_zone=Asia/Singapore    result_format=%m/%d/%Y
    ${path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${path}
    ${path_ame_chi}    Set Export Path    path=${path}    date=${date_ame_chi}    date_format=%m/%d/%Y
    Run Keyword And Return Status    Remove File    path=${path_ame_chi}
    ${path_asi_sin}    Set Export Path    path=${path}    date=${date_asi_sin}    date_format=%m/%d/%Y
    Run Keyword And Return Status    Remove File    path=${path_asi_sin}
    Click To Export SAO Data To Excel
    ${is_exist}    Run Keyword And Return Status    Wait Until Keyword Succeeds    10 times    2s    File Should Exist    ${path_ame_chi}
    IF    ${is_exist} == ${True}
        Set Test Variable    ${path}    ${path_ame_chi}
        Set Test Variable    ${date}    ${date_ame_chi}
    ELSE
        File Should Exist    ${path_asi_sin}
        Set Test Variable    ${path}    ${path_asi_sin}
        Set Test Variable    ${date}    ${date_asi_sin}
    END

Set Export Path
    [Arguments]    ${path}    ${date}    ${date_format}=%Y-%m-%d %H:%M:%S.%f
    ${m}    Convert Date    ${date}    result_format=%m    date_format=${date_format}
    ${d}    Convert Date    ${date}    result_format=%d    date_format=${date_format}
    ${Y}    Convert Date    ${date}    result_format=%Y    date_format=${date_format}
    ${m}    Remove String Using Regexp    ${m}    ^0
    ${d}    Remove String Using Regexp    ${d}    ^0
    RETURN    ${path}/ScheduledAutomatedOrdering${m}_${d}_${Y}.xlsx

Verify Date Range Export File
    [Arguments]    ${start}    ${end}    ${data}=${data}
    ${start}    Remove String Using Regexp    ${start}    ^0|((?<=/)0)
    ${end}    Remove String Using Regexp    ${end}    ^0|((?<=/)0)
    ${range}    CustomLibrary.Get Excel Field No Header    data=${data}    row=0    col=1
    Should Contain    ${range}    ${start} - ${end}

Verify User Export File
    [Arguments]    ${user}
    ${created_by}    CustomLibrary.Get Excel Field No Header    data=${data}    row=0    col=2
    Should Contain    ${created_by}    ${user}

Verify Description Export File
    [Arguments]    ${med}
    ${desc}    CustomLibrary.Get Excel Field No Header    data=${data}    row=3    col=0
    Should Contain    ${desc}    ${med}

Verify Qty To Order Export File
    [Arguments]    ${qty}
    ${qty_order}    CustomLibrary.Get Excel Field No Header    data=${data}    row=3    col=8
    Should Contain    ${qty_order}    ${qty}

Verify Badge Count
    [Arguments]    ${num_tab}=1
    ${count}    Get Badge Count
    ${line}    Get Element Count    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'OrderTableRow')]
    Should Be Equal As Numbers    ${count}    ${line}

Get Badge Count
    [Arguments]    ${num_tab}=1
    ${count}    Get Text    //*[contains(@class,'TabScrollerlist')and contains(@class,'Wrapper')]//*[contains(@class,'SAO')][${num_tab}]//*[contains(@class,'TotalCount')]
    ${count}    Convert To Integer    ${count}
    RETURN    ${count}

Verify Badge Count Color
    [Arguments]    ${color}    ${num_tab}=1
    Element Should Be Visible    //*[contains(@class,'TabScrollerlist')and contains(@class,'Wrapper')]//*[contains(@class,'SAO')][${num_tab}]//*[contains(@class,'TotalCount') and contains(@style,'${color}')]    15s

Verify Error Message Line
    [Arguments]    ${ndc}    ${txt}    ${num_tab}=1
    Scroll Element Into View    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'OrderTableRow')]//text()[contains(.,'${ndc}')][1]//following::*[*[contains(@class,'exclamation')]][1]
    ${mes}    Get Text    //*[contains(@class,'tab-panel')]/*[contains(@id,'AccTab')][${num_tab}]//*[contains(@class,'OrderTableRow')]//text()[contains(.,'${ndc}')][1]//following::*[*[contains(@class,'exclamation')]][1]
    Should Match Regexp    ${mes}    ${txt}

Verify Warning Icon Visible Or Not
    [Arguments]    ${is_visible}    ${num_tab}=1
    Run Keyword If    ${is_visible} == ${True}
    ...    Element Should Be Visible    //*[contains(@class,'TabScrollerlist')and contains(@class,'Wrapper')]//*[contains(@class,'SAO')][${num_tab}]//*[contains(@class,'exclamation-triangle')]
    ...  ELSE
    ...  Element Should Not Be Visible    //*[contains(@class,'TabScrollerlist')and contains(@class,'Wrapper')]//*[contains(@class,'SAO')][*]//*[contains(@class,'exclamation-triangle')]

PreOrder Suite Setup
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Wait Until Keyword Succeeds    30s    1s    LoginKeywords.Check Newsletter

PreOrder Test Setup
    Open New Window    ${SiteUrl}
    Close Window
    Wait Until Keyword Succeeds    20 times    3s    Switch To Another Window    Home
    Go To Appointment Ordering Ledger Via Scheduled Appointment Ordering Link

Open New Window
    [Arguments]    ${url}
    Execute Javascript    window.open('${url}','_blank')
    IF    "${mode}" != "headless"
        Maximize Browser Window
    END
    Set Window Size    1920    1080
	Sleep    3s

Switch To Another Window
    [Arguments]    ${title}
    Switch Window    ${title}
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    ${title}
    Wait Until Keyword Succeeds    10 times    3s    LoginKeywords.Check Newsletter
    ${file_path}    Get Environment Variable    EXPORT_PATH
    Set Suite Variable    ${file_path}

Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${mode}    headless
    Set Suite Variable    ${user}    ${data_input}[user]
    Set Suite Variable    ${loc}    ${data_input}[loc]
    Set Suite Variable    ${loc_2}    ${data_input}[loc_2]
    Set Suite Variable    ${date}    ${data_input}[date]
    Set Suite Variable    ${date_empty}    ${data_input}[date_empty]
    Set Suite Variable    ${date_err}    ${data_input}[date_err]
    Set Suite Variable    ${med}    ${data_input}[med]
    Set Suite Variable    ${patient}    ${data_input}[patient]
    Set Suite Variable    ${dob}    ${data_input}[dob]
    Set Suite Variable    ${mrn}    ${data_input}[mrn]
    Set Suite Variable    ${dob_2}    ${data_input}[dob_2]
    Set Suite Variable    ${mrn_2}    ${data_input}[mrn_2]
    Set Suite Variable    ${ndc}    ${data_input}[ndc]
    Set Suite Variable    ${ndc_other}    ${data_input}[ndc_other]
    Set Suite Variable    ${ndc_empty}    ${data_input}[ndc_empty]
    # Set Suite Variable    ${cont}    ${data_input}[cont]