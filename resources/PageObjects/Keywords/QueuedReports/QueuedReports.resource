*** Settings ***
Resource    ./Common/QueuedReportsCommon.resource

*** Keywords ***
Go To Queue Reports
    Wait Until Element Is Enabled    //span[@class="badge" and contains(.,"Report Queue")]    30s
    Click Element    //span[@class="badge" and contains(.,"Report Queue")]
    Title Should Be    Queued Reports

Get All Queue Report Ids
    ${report_queue_row_xpath}    Set Variable    //tr[@id="ReportQueueTableRow"]
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${report_queue_row_xpath}    15s  
    ${report_queue_rows}    Get WebElements    ${report_queue_row_xpath}
    ${report_queue_ids}    Create List
    FOR    ${report_queue_row}    IN    @{report_queue_rows}
        ${report_queue_id}    Get Element Attribute    ${report_queue_row}    data-reportqueueid
        Append To List    ${report_queue_ids}    ${report_queue_id}     
    END
    RETURN    ${report_queue_ids}

Cancel Queue Report
    [Arguments]    ${report_queue_id}
    ${report_queue_cancel_button_xpath}    Set Variable    //a[contains(@class,"CancelReportQueueReportBtn") and @data-reportqueueid="${report_queue_id}"]    
    Wait Until Element Is Enabled    ${report_queue_cancel_button_xpath}    30s
    Click Element    ${report_queue_cancel_button_xpath}    
    Util.Wait Alert Message Show And Disappear    Report Canceled.
    Util.Waiting For Loading

