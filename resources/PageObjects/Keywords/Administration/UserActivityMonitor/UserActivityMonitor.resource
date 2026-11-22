*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../../../../libraries/ApiCapture.py

*** Keywords ***
Go To User Activity Monitor
    Click Element    link:Administration
    Click Element    link:User Activity Monitor
    Wait Until Keyword Succeeds    10 times    3s    Title Should Be    User Activity Monitor
    
Filter View Account
    [Arguments]    ${account_arg}
    Sleep    10s
    Select From List By Label    //select[@id="AccountId"]    ${account_arg}
    
Filter By User
    [Arguments]    ${user_arg}
    Sleep    10s
    Select From List By Label    //select[@id="SearchUserId"]    ${user_arg}

Filter By Start Date / Time
    [Arguments]    ${date_arg}    ${time_arg}=${EMPTY}
    Input Text    //input[@id="StartDate"]    ${date_arg}
    Choose Date In Onset Date Input    ${date_arg}
    Input Text    //input[@id="StartTime"]    ${time_arg}
    Press Keys    None    TAB

Filter By End Date / Time
    [Arguments]    ${date_arg}    ${time_arg}=${EMPTY}
    Input Text    //input[@id="EndDate"]    ${date_arg}
    Choose Date In Onset Date Input    ${date_arg}
    Input Text    //input[@id="EndTime"]    ${time_arg}
    Press Keys    None    TAB

Filter By Controller
    [Arguments]    ${controller_arg}
    Select From List By Label    //select[@id="SelectedController"]    ${controller_arg}

Filter By Action
    [Arguments]    ${action_arg}
    Select From List By Label    //select[@id="SelectedAction"]    ${action_arg}

Filter By IP
    [Arguments]    ${ip_arg}
    Select From List By Label    //select[@id="IP"]    ${ip_arg}

Filter Rows Per Page
    [Arguments]    ${row_arg}
    Select From List By Label    //select[@id="RowsPerPage"]    ${row_arg}

Filter Sort By
    [Arguments]    ${sort_arg}
    Select From List By Label    //select[@id="SortBy"]    ${sort_arg}

Click Search Button In User Activity Monitor
    Click Element    //span[@id="SearchButton"]
    Common.Element Is Not Visible    //div[@id="ActionList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Click Clear Button In User Activity Monitor
    Click Element    //span[@id="ClearSearchButton"]
    Wait Until Page Contains    Please enter search criteria and click the Search button

Click Prev
    Click Element    (//a[text()="Prev"])[1]
    Common.Element Is Not Visible    //div[@id="ActionList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Click Next
    Click Element    (//a[text()="Next"])[1]
    Common.Element Is Not Visible    //div[@id="ActionList"]//i[@class="fa fa-spinner fa-4x fa-spin"]

Find Parameter Row
    [Arguments]    ${timestamp}    ${action}    ${direction}=Next
    ${status}    ${loop}    Run Keyword And Ignore Error    Get Text    (//a[text()="Next"])[1]//preceding-sibling::a[1]

    IF    $status == "FAIL"
        ${loop}    Set Variable    1
    END

    ${parameter}    Set Variable    //tr[td[text()="${timestamp}"] and td[text()="${action}"]]/td[5]
    FOR    ${i}    IN RANGE    ${loop}
        ${check_paramerter_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${parameter}    2s
        IF    "${check_paramerter_visible}" == "${False}"
            ${timestamp_plus_1}    Add Time To Date    ${timestamp}    1 second    date_format=%m/%d/%Y %I:%M:%S %p    result_format=%m/%d/%Y %I:%M:%S %p
            ${timestamp_plus_1}    Handle Datetime Format    fmt={m}/{d}/{y} {h}:{mi}:{s} {ampm}    dt=${timestamp_plus_1}
            ${parameter_plus_1}    Set Variable    //tr[td[text()="${timestamp_plus_1}"] and td[text()="${action}"]]/td[5]
            ${check_paramerter_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${parameter_plus_1}    2s
        END
        IF    "${check_paramerter_visible}" == "${False}" and "${direction}" == "Next" and $status != "FAIL"
            Click Next
        ELSE IF    "${check_paramerter_visible}" == "${False}" and "${direction}" == "Previous" and $status != "FAIL"
            Click Prev
        ELSE IF    "${check_paramerter_visible}" == "${True}"
            Exit For Loop
        END
    END
    RETURN    ${check_paramerter_visible}

# Get Parameter Text
#     [Arguments]    ${timestamp}    ${action}
#     ${parameter}    Set Variable    (//tr[td[text()="${timestamp}"] and td[text()="${action}"]]/td[5])[last()]
#     ${parameter_txt}    Get Text    ${parameter}
#     RETURN    ${parameter_txt}

# Verify API Capture
#     [Arguments]    ${capture_api}    ${activity_log}

#     FOR    ${api}    IN    @{capture_api}
#         ${status}    Get From Dictionary    ${api}    status    default=${EMPTY}

#         IF    '${status}' == 'NOT_FOUND'
#             Log To Console    SKIP: ${api}[endpoint]
#             CONTINUE
#         END

#         ${request_time}    Get From Dictionary    ${api}    requestTime
#         ${endpoint}        Get From Dictionary    ${api}    endpoint
#         ${found}           Set Variable    ${False}

#         # Lần 1: match requestTime chính xác
#         FOR    ${activity}    IN    @{activity_log}
#             ${activity_text}    Convert To String    ${activity}

#             IF    '${request_time}' in '${activity_text}' and '${endpoint}' in '${activity_text}'
#                 ${found}    Set Variable    ${True}
#                 BREAK
#             END
#         END

#         # Lần 2: nếu không match thì +1 giây
#         IF    not ${found}
#             ${request_time_plus_1s}    Add Time To Date    ${request_time}    1 second    date_format=%m/%d/%Y %I:%M:%S %p    result_format=%m/%d/%Y %I:%M:%S %p
#             ${request_time_plus_1s}    Handle Datetime Format    fmt={m}/{d}/{y} {h}:{mi}:{s} {ampm}    dt=${request_time_plus_1s}
#             FOR    ${activity}    IN    @{activity_log}
#                 ${activity_text}    Convert To String    ${activity}

#                 IF    '${request_time_plus_1s}' in '${activity_text}' and '${endpoint}' in '${activity_text}'
#                     ${found}    Set Variable    ${True}
#                     BREAK
#                 END
#             END
#         END

#         IF    ${found}
#             Log To Console    FOUND: ${endpoint}
#         ELSE
#             Log To Console    NOT FOUND: ${endpoint}
#         END
#     END


Get Action Log Following Impersonated User Activity
    ${impersonate_starttime}    Set Variable    ${API_CAPTURE}[${TargetRole}][${SUITE NAME}][beforeSuite][0][apis][0][requestTime]
    ${impersonate_endtime}    Set Variable    ${API_CAPTURE}[${TargetRole}][${SUITE NAME}][afterSuite][0][apis][0][requestTime]
    Setup Activity Monitor    ${impersonate_starttime}    ${impersonate_endtime}
    ${activity_log}    Create List
    ${pagination}    Run Keyword And Return Status    Wait Until Element Is Visible    (//a[text()="Next"])[1]    2s
    IF    ${pagination}
        Collect Paginated Activity    ${impersonate_starttime}    ${impersonate_endtime}    ${activity_log}
    ELSE
        Collect Same Page Activity    ${impersonate_starttime}    ${impersonate_endtime}    ${activity_log}
    END
    ${verify_result}    Run Keyword And Return Status    Verify Suite API Capture    ${activity_log}

Setup Activity Monitor
    [Arguments]    ${starttime}    ${endtime}
    ${user_name_txt}    Common.Get User Name
    Go To User Activity Monitor
    Click Clear Button In User Activity Monitor
    Filter View Account    account_arg=${UserAccount}
    Filter By User    user_arg=${user_name_txt}
    ${requestTime}    ${startdate}    ${starttime}    ${startampm}    Should Match Regexp    ${starttime}    ^([^ ]+) +([0-9]+:[0-9]+):[0-9]+ +(AM|PM)$
    Filter By Start Date / Time    date_arg=${startdate}    time_arg=${starttime}${startampm}
    ${requestTime}    ${enddate}    ${endtime}    ${endampm}    Should Match Regexp    ${endtime}    ^([^ ]+) +([0-9]+:[0-9]+):[0-9]+ +(AM|PM)$
    ${endtime}    Handle Datetime Format    fmt={h}:{mi}    dt=${endtime}    add_minutes=1
    Filter By End Date / Time    date_arg=${enddate}    time_arg=${endtime}${endampm}
    Filter Rows Per Page    row_arg=100
    Click Search Button In User Activity Monitor

Collect Same Page Activity
    [Arguments]    ${starttime}    ${endtime}    ${activity_log}
    ${after_found}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${endtime}"] and td[text()="User -- ImpersonateUser"]]    2s
    ${before_found}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]    2s
    IF    ${after_found} and ${before_found}
        ${action_list}    Get WebElements    //tr[following-sibling::tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]][preceding-sibling::tr[td[text()="${endtime}"] and td[text()="User -- ImpersonateUser"]]]
        Append Activity Rows    ${activity_log}    ${action_list}
    END

Collect Paginated Activity
    [Arguments]    ${starttime}    ${endtime}    ${activity_log}
    ${last_page}    Get Text    (//a[text()="Next"])[1]//preceding-sibling::a[1]
    ${after_found}    Find After Suite    ${endtime}    ${last_page}
    IF    not ${after_found}
        RETURN
    END
    ${before_found}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]    2s
    IF    ${before_found}
        ${action_list}    Get WebElements    //tr[following-sibling::tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]][preceding-sibling::tr[td[text()="${endtime}"] and td[text()="User -- ImpersonateUser"]]]
        Append Activity Rows    ${activity_log}    ${action_list}
        RETURN
    END
    ${action_list}    Get WebElements    //tr[td[text()="${endtime}"] and td[text()="User -- ImpersonateUser"]]/following-sibling::tr
    Append Activity Rows    ${activity_log}    ${action_list}
    Find Before Suite    ${starttime}    ${last_page}    ${activity_log}

Append Activity Rows
    [Arguments]    ${activity_log}    ${action_list}
    FOR    ${action}    IN    @{action_list}
        ${action_text}    Get Text    ${action}
        IF    '${action_text}' != ''
            Append To List    ${activity_log}    ${action_text}
        END
    END

Find Before Suite
    [Arguments]    ${starttime}    ${last_page}    ${activity_log}
    ${before_found}    Set Variable    ${False}
    WHILE    not ${before_found}
        ${current_page}    Get Text    (//div[@class="pager-navigation"])[1]/a[@class="selected"]
        ${can_next}    Evaluate    int($current_page) < int($last_page)
        IF    not ${can_next}
            BREAK
        END
        Click Next
        ${before_found}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]    2s
        IF    ${before_found}
            ${action_list}    Get WebElements    //tr[td[text()="${starttime}"] and td[text()="User -- ImpersonateUser"]]/preceding-sibling::tr
            Append Activity Rows    ${activity_log}    ${action_list}
        ELSE
            ${action_list}    Get WebElements    //table//tbody/tr
            Append Activity Rows    ${activity_log}    ${action_list}
        END
    END

Find After Suite
    [Arguments]    ${endtime}    ${last_page}
    ${after_found}    Set Variable    ${False}
    WHILE    not ${after_found}
        ${after_status}    Run Keyword And Return Status    Wait Until Element Is Visible    //tr[td[text()="${endtime}"] and td[text()="User -- ImpersonateUser"]]    2s
        IF    ${after_status}
            ${after_found}    Set Variable    ${True}
            BREAK
        END
        ${current_page}    Get Text    (//div[@class="pager-navigation"])[1]/a[@class="selected"]
        ${can_next}    Evaluate    int($current_page) < int($last_page)
        IF    not ${can_next}
            BREAK
        END
        Click Next
    END
    RETURN    ${after_found}

Verify Suite API Capture
    [Arguments]    ${activity_log}
    ${suite_capture}    Set Variable    ${API_CAPTURE}[${TargetRole}][${SUITE NAME}]
    ${overall_status}    Set Variable    ${TRUE}
    FOR    ${testcase}    ${testcase_data}    IN    &{suite_capture}
        IF    '${testcase}' == 'verification'
            CONTINUE
        END
        FOR    ${action}    IN    @{testcase_data}
            FOR    ${api}    IN    @{action}[apis]
                ${status}=    Collections.Get From Dictionary    ${api}    status
                ${url}=    Collections.Get From Dictionary    ${api}    url
                ${endpoint}=    Evaluate    __import__('urllib.parse', fromlist=['urlparse']).urlparse("${url}").path.strip("/").split("/")[-2] + " -- " + __import__('urllib.parse', fromlist=['urlparse']).urlparse("${url}").path.strip("/").split("/")[-1]
                IF    "${endpoint}" == "User -- ImpersonateUser"
                    Set To Dictionary    ${api}    uiStatus=FOUND
                    CONTINUE
                END
                IF    '${status}' == 'NOT_FOUND'
                    Set To Dictionary    ${api}    uiStatus=NOT_FOUND
                    ${overall_status}    Set Variable    ${FALSE}
                    CONTINUE
                END
                ${capture_time}    Get From Dictionary    ${api}    requestTime
                ${found}    Set Variable    ${FALSE}
                FOR    ${log}    IN    @{activity_log}
                    ${endpoint_match}    Run Keyword And Return Status    Should Contain    ${log}    ${endpoint}
                    IF    ${endpoint_match}
                        ${time_match}    Run Keyword And Return Status    Should Contain    ${log}    ${capture_time}
                        IF    ${time_match}
                            ${found}    Set Variable    ${TRUE}
                            Exit For Loop
                        END
                    END
                END
                IF    not ${found}
                    ${plus_one_time}    Add Time To Date    ${capture_time}    1 second    date_format=%m/%d/%Y %I:%M:%S %p    result_format=%m/%d/%Y %I:%M:%S %p
                    ${plus_one_time}    Handle Datetime Format    fmt={m}/{d}/{y} {h}:{mi}:{s} {ampm}    dt=${plus_one_time}
                    FOR    ${log}    IN    @{activity_log}
                        ${endpoint_match}    Run Keyword And Return Status    Should Contain    ${log}    ${endpoint}
                        IF    ${endpoint_match}
                            ${time_match}    Run Keyword And Return Status    Should Contain    ${log}    ${plus_one_time}
                            IF    ${time_match}
                                ${found}    Set Variable    ${TRUE}
                                Exit For Loop
                            END
                        END
                    END
                END
                IF    ${found}
                    Set To Dictionary    ${api}    uiStatus=FOUND
                ELSE
                    Set To Dictionary    ${api}    uiStatus=NOT_FOUND
                    ${overall_status}    Set Variable    ${FALSE}
                END
            END
        END
    END
    Save API Capture Verification    ${overall_status}