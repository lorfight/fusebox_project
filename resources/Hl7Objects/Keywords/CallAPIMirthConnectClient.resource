*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    DateTime
Library    XML

*** Keywords ***
Create Or Use Mirth Session
    [Documentation]    Create or use an existing session for Mirth Connect API
    [Arguments]    ${URL}
    ${headers}=    Create Dictionary    Accept=application/json
    ${auth}=    Create List    admin    admin
    ${session_exists}=    Session Exists    Mirth_HL7
    Run Keyword Unless    ${session_exists}    Create Session    Mirth_HL7    ${URL}    headers=${headers}    auth=${auth}    verify=False

Deploy Channel On Mirth Connect
    [Documentation]    Deploy channel base on channel ID
    [Arguments]    ${URL}    ${CHANNEL_ID}
    Create Or Use Mirth Session    ${URL}
    ${response}=    POST On Session    Mirth_HL7    ${URL}/channels/${CHANNEL_ID}/_deploy
    Status Should Be    204    ${response}

Get Latest Message ID
    [Documentation]    Get the latest message ID from the channel base on channel ID
    [Arguments]    ${URL}    ${CHANNEL_ID}
    Create Or Use Mirth Session    ${URL}
    ${response}=    GET On Session    Mirth_HL7    /channels/${CHANNEL_ID}/messages/maxMessageId
    Status Should Be    200    ${response}
    ${message_id}=    Convert To String    ${response.json()['long']}
    RETURN    ${message_id}

Verify Status In Channel Messages
    [Documentation]    Verify status of message in channel processing on Mirth Connect    
    [Arguments]    ${URL}    ${CHANNEL_ID}
    Create Or Use Mirth Session    ${URL}
    ${message_id}=    Get Latest Message ID    ${URL}    ${CHANNEL_ID}
    ${response}=    GET On Session    Mirth_HL7    /channels/${CHANNEL_ID}/messages/${message_id}
    Status Should Be    200    ${response}
    ${response_json}=    Set Variable    ${response.json()} 
    ${message}=    Get From Dictionary    ${response_json}    message
    ${connector_messages}=    Get From Dictionary    ${message}    connectorMessages
    ${entries}=    Get From Dictionary    ${connector_messages}    entry
    ${list_status}=    Create List
    
    ${is_dict}=    Evaluate    isinstance(${entries}, dict)
    IF    ${is_dict} == True
        ${entries}=    Create List    ${entries}
    END

    FOR    ${entry}    IN    @{entries}
        ${connector_msg}=    Get From Dictionary    ${entry}    connectorMessage
        ${connector_name}=    Get From Dictionary    ${connector_msg}    connectorName
        ${status}=    Get From Dictionary    ${connector_msg}    status
        Append To List    ${list_status}    ${status}

        IF    "${status}" == "ERROR"
            ${processing_error_content}=    Get From Dictionary    ${connector_msg}    processingErrorContent
            ${error_content}=    Get From Dictionary    ${processing_error_content}    content
            Log    ${error_content}
            FAIL    ${error_content}
        END
    END

    RETURN    ${list_status}
