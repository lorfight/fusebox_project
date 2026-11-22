*** Settings ***
# Library    RequestsLibrary
Library    RequestsLibrary

*** Variables ***


** Keywords **
Trigger Jenkins MirthProcessor Build
    [Arguments]    ${JENKINS_URL}    ${JENKINS_USER}    ${JENKINS_API_TOKEN}    ${JOB_NAME} 
    [Documentation]    Call Jenkins API to trigger build webjob
    Evaluate    __import__('urllib3').disable_warnings()    modules=__main__
    ${auth}=    Create List    ${JENKINS_USER}    ${JENKINS_API_TOKEN}        
    Create Session    Jenkins    ${JENKINS_URL}    auth=${auth}
    ${buildID}=    RequestsLibrary.GET On Session    Jenkins    ${JENKINS_URL}/${JOB_NAME}/lastSuccessfulBuild/buildNumber
    ${initID}    Set Variable    ${buildID.json()}
    ${response}=    RequestsLibrary.POST On Session    Jenkins    ${JENKINS_URL}/${JOB_NAME}/build
    IF    ${response.status_code} == ${201}
        ${IDSuccess}    Set Variable    ${0}
        WHILE    ${IDSuccess} <= ${initID}
            ${buildIDSuccess}=    RequestsLibrary.GET On Session    Jenkins    ${JENKINS_URL}/${JOB_NAME}/lastSuccessfulBuild/buildNumber
            ${IDSuccess}    Set Variable    ${buildIDSuccess.json()}
        END
    ELSE
        Fatal Error    An error during running WJ with status: ${response.status_code}
    END    
    Log    Jenkins build triggered successfully.