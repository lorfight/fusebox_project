*** Settings ***
Library    JSONLibrary
Library    Collections
Library    String

*** Keywords ***
Initialize Global Config
    [Arguments]    ${config_file}
    ${json_data}=    Load Json From File    ${config_file}
    ${hl7}=    Get From Dictionary    ${json_data}    hl7

    # Account HL7 Config
    ${account_hl7}=    Get From Dictionary    ${hl7}    meditab_ntaa
    Set Global Variable    ${LOCATION}    ${account_hl7['account']['account_name']}

    # Database HL7 Config
    ${database_hl7}=    Get From Dictionary    ${hl7}    database
    Set Global Variable    ${DB_HOST}        ${database_hl7['host']}
    Set Global Variable    ${DB_PORT}        ${database_hl7['port']}
    Set Global Variable    ${DB_USER_NAME}   ${database_hl7['user']}
    Set Global Variable    ${DB_PASSWORD}    ${database_hl7['password']}
    Set Global Variable    ${DB_NAME}        ${database_hl7['name']}

    # Jenkins HL7 Config
    ${jenkins_hl7}=    Get From Dictionary    ${hl7}    jenkins
    Set Global Variable    ${JENKINS_URL}         ${jenkins_hl7['url']}
    Set Global Variable    ${JENKINS_USER}        ${jenkins_hl7['username']}
    Set Global Variable    ${JENKINS_API_TOKEN}   ${jenkins_hl7['api_token']}
    Set Global Variable    ${PROJECT_NAME_ADT}    ${jenkins_hl7['project_name_adt']}
    Set Global Variable    ${PROJECT_NAME_SIU}    ${jenkins_hl7['project_name_siu']}    

    # SFTP HL7 Config
    ${sftp_hl7}=    Get From Dictionary    ${hl7}    sftp
    Set Global Variable    ${SFTP_HOST}        ${sftp_hl7['hostname']}
    Set Global Variable    ${SFTP_USERNAME}    ${sftp_hl7['username']}
    Set Global Variable    ${SFTP_PASSWORD}    ${sftp_hl7['password']}
    Set Global Variable    ${SFTP_PORT}        ${sftp_hl7['port']}    

    # Mirth Connect HL7 Config
    ${mirth_connect_hl7}=    Get From Dictionary    ${account_hl7}    mirth_connect
    Set Global Variable    ${MIRTH_CLIENT_URL}    ${mirth_connect_hl7['url']}

Get Value By Key Path
    [Arguments]    ${config_file}    ${key_path}
    ${json_data}=    Load Json From File    ${config_file}    
    ${keys}=    String.Split String    ${key_path}    .
    ${value}=    Set Variable    ${json_data}
    FOR    ${key}    IN    @{keys}
        ${value}=    Get From Dictionary    ${value}    ${key}        
    END
    RETURN    ${value}

