*** Settings ***
Documentation    Scan Medication
Resource   ../../../resources/ApiObjects/Keywords/Medication.resource
Suite Setup    Suite Setup
Suite Teardown    Sleep    2

*** Variables ***
${medication_path}   /scan


*** Test Cases ***
Sending Request Without The "Barcode"
    [Documentation]    [ Scan medication api]_O1
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    
    ${body_request_medication}    Create Dictionary    barcode=${None}
    ${Medication_response}    POST On Session    mysession    ${medication_path}    json=${body_request_medication}    expected_status=400    headers=${headers}
    
    ${Medication_response_json}    Set Variable    ${Medication_response.json()}

    ${expected_error}=    Set Variable    The Barcode field is required.
    Medication.Validate 400 Bad Request Response    ${Medication_response}    ${expected_error}

Sending Request with The Wrong Format Barcode
    [Documentation]    [ Scan medication api]_BS01
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    
    ${body_request_medication}    Create Dictionary    barcode=${wrong_format_barcode}
    ${Medication_response}    POST On Session    mysession    ${medication_path}    json=${body_request_medication}    expected_status=400    headers=${headers}
    
    ${Medication_response_json}    Set Variable    ${Medication_response.json()}

    ${expected_error}=    Set Variable    Can not extract the medication and lot from the barcode ${wrong_format_barcode}
    Medication.Validate 400 Bad Request Response    ${Medication_response}    ${expected_error}

Sending A Request With An Invalid NDC
    [Documentation]    [ Scan medication api]_O2
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    
    ${body_request_medication}    Create Dictionary    barcode=${non_exit_ndc}
    ${Medication_response}    POST On Session    mysession    ${medication_path}    json=${body_request_medication}    expected_status=400    headers=${headers}
    
    ${Medication_response_json}    Set Variable    ${Medication_response.json()}

    ${expected_error}=    Set Variable    Not found the corresponding medication with the barcode ${non_exit_ndc}
    Medication.Validate 400 Bad Request Response    ${Medication_response}    ${expected_error}


Sending Request with Valid NDC in Barcode
    [Documentation]    [ Scan medication api]_O3
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    ${random_barcode}=    Medication.Get Random Barcode From List
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    
     ${body_request_medication}=    Create Dictionary    barcode=${random_barcode}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body_request_medication}    expected_status=200    headers=${headers}

    ${json}=    Set Variable    ${response.json()}

    ${ndc}=    Get Value From Json    ${json}    $.ndc
    ${description}=    Get Value From Json    ${json}    $.description
    ${lot_number}=    Get Value From Json    ${json}    $.lotNumber
    ${expiration_date}=    Get Value From Json    ${json}    $.lotExpirationDate

    Should Not Be Empty    ${ndc}
    Should Not Be Empty    ${description}
    Should Not Be Empty    ${lot_number}
    Should Not Be Empty    ${expiration_date}

Send Request With Specific Barcode Format
    [Documentation]    [ Scan medication api]_O4      
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    ${barcode}=    Set Variable    ${barcode04}
    Create Session    mysession    ${base_url}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body}=    Create Dictionary    barcode=${barcode}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body}    expected_status=200    headers=${headers}
    ${json}=    Set Variable    ${response.json()}


    ${ndc}=               Get From Dictionary    ${json}    ndc
    ${description}=       Get From Dictionary    ${json}    description
    ${lot_number}=        Get From Dictionary    ${json}    lotNumber
    ${expiration_date}=   Get From Dictionary    ${json}    lotExpirationDate
    
Send Request With Specific Barcode Format Next
    [Documentation]    [ Scan medication api]_O5       
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    ${barcode}=    Set Variable    ${barcode05}
    Create Session    mysession    ${base_url}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body}=    Create Dictionary    barcode=${barcode}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body}    expected_status=200    headers=${headers}
    ${json}=    Set Variable    ${response.json()}

    ${ndc}=               Get From Dictionary    ${json}    ndc
    ${description}=       Get From Dictionary    ${json}    description
    ${lot_number}=        Get From Dictionary    ${json}    lotNumber
    ${expiration_date}=   Get From Dictionary    ${json}    lotExpirationDate

    Should Not Be Empty    ${ndc}
    Should Not Be Empty    ${description}
    Should Not Be Empty    ${lot_number}
    Should Not Be Empty    ${expiration_date}

Barcode With Format Pipe And 7004
    [Documentation]    [ Scan medication api]_O6
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    ${barcode}=    Set Variable    ${barcode06}
    Create Session    mysession    ${base_url}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body}=    Create Dictionary    barcode=${barcode}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body}    expected_status=200    headers=${headers}
    ${json}=    Set Variable    ${response.json()}

    ${ndc}=               Get From Dictionary    ${json}    ndc
    ${description}=       Get From Dictionary    ${json}    description
    ${lot_number}=        Get From Dictionary    ${json}    lotNumber
    ${expiration_date}=   Get From Dictionary    ${json}    lotExpirationDate

    Should Not Be Empty    ${ndc}
    Should Not Be Empty    ${description}
    Should Not Be Empty    ${lot_number}
    Should Not Be Empty    ${expiration_date}

Scan Medication With Multiple NDCs Configured
    [Documentation]    [ Scan medication api]_O7 
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    Medication.Get Access Token    ${head_multi_data}
    ${barcode}=    Set Variable    ${barcode07}

    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body}=    Create Dictionary    barcode=${barcode}
    Create Session    mysession    ${base_url}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body}    expected_status=200    headers=${headers}

    ${json}=    Set Variable    ${response.json()}
    ${ndc_list}=    Get Value From Json    ${json}    $.ndc
    ${description}=    Get Value From Json    ${json}    $.description
    ${lot_number}=    Get Value From Json    ${json}    $.lotNumber
    ${expiration}=    Get Value From Json    ${json}    $.lotExpirationDate

    ${ndc}=    Get From List    ${ndc_list}    0
    Should Not Be Empty    ${ndc}
    Should Not Be Empty    ${description}
    Should Not Be Empty    ${lot_number}
    Should Not Be Empty    ${expiration}

Verify the data type of the NDC field in the JSON response
    [Documentation]    [ Scan medication api]_O9    [ Scan medication api]_O10    [ Scan medication api]_O11    [ Scan medication api]_O12
    [Tags]    API    Scan Medication
    ...  report.label.owner: Nga Phan
    ${random_barcode}=    Medication.Get Random Barcode From List
    Medication.Get Access Token    ${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    ${body}=    Create Dictionary    barcode=${random_barcode}
    ${response}=    POST On Session    mysession    ${medication_path}    json=${body}    expected_status=200    headers=${headers}

    ${json}=    Set Variable    ${response.json()}
    ${ndc_list}=    Get Value From Json    ${json}    $.ndc
    ${ndc}=    Get From List    ${ndc_list}    0
    ${description}=       Get Value From Json    ${json}    $.description
    ${lot_number}=        Get Value From Json    ${json}    $.lotNumber
    ${expiration_date}=   Get Value From Json    ${json}    $.lotExpirationDate


    ${is_ndc_str}=    Evaluate    isinstance("""${ndc}""", str)
    Should Be True    ${is_ndc_str}

    ${is_desc_valid}=     Evaluate    isinstance("""${description}""", str) or ${description} is None
    Should Be True        ${is_desc_valid}    msg=Description field is not valid: ${description}

    ${is_lot_valid}=      Evaluate    isinstance("""${lot_number}""", str) or ${lot_number} is None
    Should Be True        ${is_lot_valid}    msg=LotNumber field is not valid: ${lot_number}

    ${is_exp_valid}=      Evaluate    isinstance("""${expiration_date}""", str) or ${expiration_date} is None
    Should Be True        ${is_exp_valid}    msg=ExpirationDate field is not valid: ${expiration_date}



*** Keywords ***
Suite Setup
    Medication.Setup Data
    Get URL API Medication

