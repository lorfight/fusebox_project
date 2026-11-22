*** Settings ***
Resource    ../../../Layers/Patient/PatientList/PatientTools/ImportPatients.resource
Library    OperatingSystem
Library    ../../../../../../libraries/CustomLibrary.py

*** Keywords ***
Get Patient Import Excel File
    ${download_path}    Get Environment Variable    EXPORT_PATH
    ${path}    Set Variable    ${download_path}/PatientImportTemplate.xlsx
    Run Keyword And Return Status    Remove File    ${path}
    Click Download Template Button
    Wait Until Keyword Succeeds    30s    1s    Should Exist    ${path}
    ${df}    CustomLibrary.Read Excel File    path=${path}
    RETURN    ${df}    ${path}

Set Gender Value
    ${gender_code}    Evaluate    random.choice(["M","F","O"])
    IF    '${gender_code}' == 'M'
        ${gender_text}    Set Variable    Male
    ELSE IF    '${gender_code}' == 'F'
        ${gender_text}    Set Variable    Female
    ELSE IF    '${gender_code}' == 'O'
        ${gender_text}    Set Variable    Other
    END
    RETURN    ${gender_text}    ${gender_code}

Prepare Invalid Patient Data
    [Arguments]    ${df}    ${path}    ${invalid_id}    ${first_name}    ${last_name}    ${mrn}    ${dob}    ${gender}
    Set Value To Excel Field    df=${df}    field=Account # (Must get location account# from Mainbridge staff)      value=${invalid_ID}
    Set Value To Excel Field    df=${df}    field=First Name    value=${first_name}
    Set Value To Excel Field    df=${df}    field=Last Name    value=${last_name}
    Set Value To Excel Field    df=${df}    field=MRN    value=${MRN}
    Set Value To Excel Field    df=${df}    field=DOB (MM/DD/YYYY)    value=${DOB}
    Set Value To Excel Field    df=${df}    field=Gender (M / F / O)    value=${gender}
    CustomLibrary.Save Excel File    path=${path}    df=${df}

Clear Patient Import Template
    [Arguments]    ${df}    ${path}    ${keys}
    FOR    ${col}    IN    @{df.keys()}
        Set Value To Excel Field    df=${df}    field=${col}    value=${EMPTY}
    END
    CustomLibrary.Save Excel File    path=${path}    df=${df}

Import Patient File
    [Arguments]    ${path}    ${msg}    ${color_arg}    ${text_arg}
    Upload Patient File    color_arg=${color_arg}    text_arg=${text_arg}    path=${path}
    Wait Until Page Contains    ${msg}    30s

Remove All Erorr Lines
    Click Remove Error Lines Button
    Common.Page Alert Message    All Erorr Lines Removed
    Wait Until Element Is Visible    ${patient_upload_file_input}    30s

Confirm Import Patient File
    Click Confirm Import Button
    Alert Should Be Present    Are you sure you want to process this import?    Accept
    Common.Page Alert Message    File Successfully Imported!
    Wait Until Element Is Not Visible    //*[@id='ModalPopup']    30s

Set Value To Excel Field
    [Arguments]    ${df}    ${field}    ${value}
    CustomLibrary.Edit Excel Field    df=${df}    field=${field}    value=${value}

Upload Patient File
    [Arguments]    ${color_arg}    ${text_arg}    ${path}
    Choose File    ${patient_upload_file_input}    ${path}
    Click Button    ${patient_process_file_button}
    ${status_text}    Set Variable    //*[@id='PreProcess']//*[@style='color:${color_arg}' and normalize-space(text())='${text_arg}']    #green-success
    Wait Until Element Is Visible    ${status_text}    30s