*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

*** Keywords ***
Create Or Use Jenkins Session
    [Documentation]    Create or use an existing session for Jenkins API
    [Arguments]    ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}
    ${auth}=    Create List    ${JENKINS_USER}    ${JENKINS_API_TOKEN}
    ${session_exists}=    Session Exists    Jenkins
    Run Keyword Unless    ${session_exists}    Create Session    Jenkins    ${JENKINS_URL}    auth=${auth}

Get Current Build Number
    [Arguments]    ${Project_Name}
    ${response}=    GET On Session    Jenkins    /job/${Project_Name}/lastSuccessfulBuild/buildNumber
    Should Be Equal As Strings    ${response.status_code}    200    Failed to get last build number: ${response.status_code} 
    RETURN    ${response.json()}

Trigger Jenkins Build
    [Documentation]    Trigger a Jenkins build now for the specified project
    [Arguments]    ${Project_Name}
    ${response}=    POST On Session    Jenkins    /job/${Project_Name}/build
    Should Be Equal As Strings    ${response.status_code}    201    Failed to trigger build: ${response.status_code}
    Log    Jenkins build triggered successfully.

Verify Jenkins Build Success
    [Arguments]    ${Project_Name}    ${initID}    ${timeout}=120    ${interval}=5    
    ${elapsed_time}=    Set Variable    0
    WHILE    ${elapsed_time} < ${timeout}
        ${currentBuild}=    Get Current Build Number    ${Project_Name}
        Exit For Loop If    ${currentBuild} > ${initID}
        Sleep    ${interval}s
        ${elapsed_time}=    Evaluate    ${elapsed_time} + ${interval}
    END

    Should Be True    ${currentBuild} > ${initID}    Jenkins build failed to start: ${currentBuild}
    Log    Jenkins build completed successfully: ${currentBuild}



