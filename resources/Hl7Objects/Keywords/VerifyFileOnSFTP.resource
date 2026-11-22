*** Settings ***
Library    SeleniumLibrary
Library    SSHLibrary
Library    OperatingSystem
Library    Collections
Library    DateTime 
Library    String
Library    ../../Hl7Objects/TestData/DataHL7.py 

Resource    ../../Hl7Objects/Keywords/GetValueFromConfigs.resource

*** Keywords ***
Save Message To File
    [Arguments]    ${hl7_message}    ${file_name}    ${hl7_output_dir}
    ${timestamp}    Get Current Date    result_format=%Y%m%d%H%M%S
    ${file_name}=    Set Variable    ${file_name}_${timestamp}.hl7
    Create File    ${hl7_output_dir}${file_name}    ${hl7_message}
    RETURN    ${file_name}           
        
Upload File To sFTP Server
    [Arguments]    ${hl7_output_dir}    ${file_name}    ${remote_path}       
    Open Connection    ${SFTP_HOST}    port=${SFTP_PORT}
    Login    ${SFTP_USERNAME}    ${SFTP_PASSWORD}
    Put File    ${hl7_output_dir}${file_name}    ${remote_path}    
    Close Connection

Verify File Exists On sFTP Server
    [Arguments]    ${file_name}    ${remote_path}    
    Open Connection    ${SFTP_HOST}    port=${SFTP_PORT}
    Login    ${SFTP_USERNAME}    ${SFTP_PASSWORD}
    SSHLibrary.File Should Exist    ${remote_path}${file_name}
    Close Connection
    RETURN    ${file_name}     

Get Recently Uploaded File
    [Arguments]    ${file_list}    ${file_type}    ${target_time}    ${TIME_OFFSET}
    ${closest_file}    Set Variable    NOT_FOUND
    ${smallest_diff}    Set Variable    ${TIME_OFFSET}

    FOR    ${file}    IN    @{file_list}
        ${match}    Run Keyword And Return Status    Should Match Regexp    ${file}    ${file_type}(\\d{14})\\.hl7
        IF    ${match}
            ${file_time}    Remove String    ${file}    ${file_type}
            ${file_time}    Remove String    ${file_time}    .hl7
            ${diff}    Evaluate    abs(int(${file_time}) - int(${target_time}))
            IF    ${diff} < ${smallest_diff}
                ${smallest_diff}    Set Variable    ${diff}
                ${closest_file}    Set Variable    ${file}
            END
        END
    END

    Run Keyword If   ${closest_file} == "NOT_FOUND"
    ...    Log    No matching file found. Files in directory: ${file_list}

    RETURN    ${closest_file}

Get Message File From sFTP Server
    [Arguments]    ${remote_path}    ${hl7_output_dir}    ${time_offset}    ${file_type}
    Open Connection    ${SFTP_HOST}    port=${SFTP_PORT}
    Login    ${SFTP_USERNAME}    ${SFTP_PASSWORD}

    ${current_time}    Get Current Date    result_format=%Y%m%d%H%M%S
    ${files}    List Files In Directory    ${REMOTE_PATH}
    ${latest_file}    Get Recently Uploaded File    ${files}    ${file_type}    ${current_time}    ${TIME_OFFSET}

    Run Keyword If    "${latest_file}" != "NOT_FOUND"
    ...    SSHLibrary.Get File    ${REMOTE_PATH}${latest_file}    ${hl7_output_dir}${latest_file}
    ...    ELSE    Fail    Not file found in ${REMOTE_PATH}. Files: ${files}

    Close Connection


    