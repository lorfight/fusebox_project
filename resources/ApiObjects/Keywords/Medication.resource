
*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    FakerLibrary
Library    ../../PageObjects/TestData/Fakedata/FakeData.py
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Variables    ../../PageObjects/TestData/Testdata.py
*** Variables ***
@{expeted_errors}
...    The Barcode field is required.
...    Not found the corresponding medication with the barcode ,{barcode}
...    Can not extract the medication and lot from the barcode ,{barcode}
${BASE_URL}       https://api.example.com
${ENDPOINT}       /scan

*** Keywords ***

Send Body Request With The Barcode
    [Arguments]
    ...    ${barcode}
    ${body_request_medication}    Create Dictionary
    ...    barcode=${barcode}
    
    Set Test Variable    ${body_request_medication}

Get Random Barcode Data
    ${barcode_obj}=    Evaluate    GetRandomFakeBarcode()    modules=FakeData
    ${barcode}=    Get From Dictionary    ${barcode_obj}    barcode
    ${desc}=        Get From Dictionary    ${barcode_obj}    description
    ${ndc}=        Get From Dictionary    ${barcode_obj}    ndc
    ${lot}=        Get From Dictionary    ${barcode_obj}    lotNumber
    ${exp}=        Get From Dictionary    ${barcode_obj}    lotExpirationDate
    Set Test Variable    ${barcode}
    Set Test Variable    ${expected_desc}
    Set Test Variable    ${expected_ndc}
    Set Test Variable    ${expected_lot}
    Set Test Variable    ${expected_exp}

Parse Barcode To Fields
    [Arguments]    ${barcode_string}
    ${parsed}=    Evaluate    ParseBarcode("""${barcode_string}""")    modules=FakeData
    Set Test Variable    ${gtin}=    Get From Dictionary    ${parsed}    gtin
    Set Test Variable    ${serial_number}=    Get From Dictionary    ${parsed}    serial_number
    Set Test Variable    ${expiration_date}=    Get From Dictionary    ${parsed}    expiration_date
    Set Test Variable    ${lot_number}=    Get From Dictionary    ${parsed}    lot_number
    Set Test Variable    ${product_potency}=    Get From Dictionary    ${parsed}    product_potency

Compare Barcode With Medication Response
    [Arguments]    ${barcode_string}    ${response_json}

    ${parsed}=    Evaluate    ParseBarcode("""${barcode_string}""")    modules=FakeData
    ${gtin}=    Get From Dictionary    ${parsed}    gtin
    ${lot_number}=    Get From Dictionary    ${parsed}    lot_number
    ${expiry_yyMMdd}=    Get From Dictionary    ${parsed}    expiration_date

    ${expiry_mmddyyyy}=    Evaluate    FormatDateYYMMDDToMMDDYYYY("""${expiry_yyMMdd}""")    modules=FakeData

    ${resp_ndc}=    Get From Dictionary    ${response_json}    ndc
    ${resp_lot}=    Get From Dictionary    ${response_json}    lotNumber
    ${resp_exp}=    Get From Dictionary    ${response_json}    lotExpirationDate

    Should Be Equal    ${resp_lot}    ${lot_number}
    Should Be Equal    ${resp_exp}    ${expiry_mmddyyyy}

Get URL API Medication
    ${config_path}    Testdata.Get Api Configs     ${env}
    ${json_data}    Set Variable    ${config_path}
    ${base_url}    Get From Dictionary    ${json_data}    baseUrl
    ${medication_path}    Get From Dictionary    ${json_data}    barcode
    ${token_url}    Get From Dictionary    ${json_data}    tokenUrl
    Set Suite Variable    ${base_url}
    Set Suite Variable    ${medication_path}
    Set Suite Variable    ${token_url}

Get Access Token
    [Arguments]    ${head_account}
    Create Session    auth_session    ${base_url}
    ${headers}    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    ${response}    POST On Session    auth_session    ${token_url}    data=${head_account}    headers=${headers}    expected_status=200
    ${access_token}    Set Variable    ${response.json()["access_token"]}
    Set Suite Variable    ${access_token}

Send Scan Medication Request
    [Arguments]    ${barcode}    ${access_token}
    Create Session    mysession    ${BASE_URL}
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json

    ${body_request_medication}=    Create Dictionary
    IF    "${barcode}" != "${None}"
        Set To Dictionary    ${body_request_medication}    barcode=${barcode}
    END

    ${response}=    POST On Session
    ...    mysession
    ...    ${medication_path}
    ...    json=${body_request_medication}
    ...    headers=${headers}

    ${json}=    To JSON    ${response.content}

    RETURN    ${response}

Validate 400 Bad Request Response
    [Arguments]  ${response}  ${expected_error}
    Should Be Equal As Numbers  ${response.status_code}  400
    ${json}=    Set Variable   ${response.json()}

    ${has_errors}=    Run Keyword And Return Status    Set Variable    ${json["errors"]}
    ${has_detail}=    Run Keyword And Return Status    Set Variable  ${json["detail"]}

    Run Keyword If    ${has_errors}    Validate Barcode Error Message    ${response}    ${expected_error}
    Run Keyword If    ${has_detail} and not ${has_errors}    Validate Detail Error Message    ${json}    ${expected_error}
    Run Keyword If    not ${has_errors} and not ${has_detail}    FAIL    Field 'errors' or 'detail' not found in response.

Validate Barcode Error Message
    [Arguments]    ${response}    ${expected_error}
    ${actual_error}=    Set Variable    ${response.json()['errors']['barcode'][0]}
    Should Be Equal    ${actual_error}    ${expected_error}

Validate Detail Error Message
    [Arguments]    ${json}    ${expected_error}
    ${actual_error}=    Get From Dictionary    ${json}    detail
    Should Be Equal    ${actual_error}    ${expected_error}

Get Random Barcode From List
    ${barcodes}=    Create List
    ...    ${barcoderan1}    ${barcoderan2}    ${barcoderan3}

    Run Keyword If    ${barcodes} == []    Fail    Barcode list is empty!
    ${random_index}=    Evaluate    random.randint(0, len(${barcodes}) - 1)    modules=random
    ${barcode}=    Get From List    ${barcodes}    ${random_index}
    RETURN    ${barcode}

Parse Barcode JSON
    [Arguments]    ${barcode_json}
    ${barcode_dict}=    Evaluate    ("${barcode_json}")
    RETURN    ${barcode_dict}


Setup Data
    ${data_input}    Get Data
    Set Suite Variable    ${scope}    ${data_input}[scope]
    Set Suite Variable    ${grantType}    ${data_input}[grantType]
    Set Suite Variable    ${referringProviderNPI}    ${data_input}[referringProviderNPI]
    Set Suite Variable    ${preferredInternalProviderNPI}    ${data_input}[preferredInternalProviderNPI]
    # Have headoffice and list account > 1
    Set Suite Variable    ${head_multi_headoffice}    ${data_input}[accounts][0][headOffice]
    Set Suite Variable    ${head_multi_acc1}    ${data_input}[accounts][0][listAccounts][0]
    Set Suite Variable    ${head_multi_acc2}    ${data_input}[accounts][0][listAccounts][1]
    Set Suite Variable    ${head_multi_clientid}    ${data_input}[accounts][0][clientId]
    Set Suite Variable    ${head_multi_clientsecret}    ${data_input}[accounts][0][clientSecret]
    # Have headoffice and list account = 1
    Set Suite Variable    ${head_1_headoffice}    ${data_input}[accounts][1][headOffice]
    Set Suite Variable    ${head_1_acc1}    ${data_input}[accounts][1][listAccounts][0]
    Set Suite Variable    ${head_1_clientid}    ${data_input}[accounts][1][clientId]
    Set Suite Variable    ${head_1_clientsecret}    ${data_input}[accounts][1][clientSecret]
    # Have head office and list account = 0
    Set Suite Variable    ${head_0_headoffice}    ${data_input}[accounts][2][headOffice]
    Set Suite Variable    ${head_0_acc1}    ${data_input}[accounts][2][listAccounts][0]
    Set Suite Variable    ${head_0_clientid}    ${data_input}[accounts][2][clientId]
    Set Suite Variable    ${head_0_clientsecret}    ${data_input}[accounts][2][clientSecret]
    # No head office and list account = 1
    Set Suite Variable    ${nohead_1_headoffice}    ${data_input}[accounts][3][headOffice]
    Set Suite Variable    ${nohead_1_acc1}    ${data_input}[accounts][3][listAccounts][0]
    Set Suite Variable    ${nohead_1_clientid}    ${data_input}[accounts][3][clientId]
    Set Suite Variable    ${nohead_1_clientsecret}    ${data_input}[accounts][3][clientSecret]

    Set Suite Variable    ${wrong_format_barcode}    ${data_input}[wrong_format_barcode]
    Set Suite Variable    ${non_exit_ndc}    ${data_input}[non_exit_ndc]
    Set Suite Variable    ${barcode04}    ${data_input}[barcode04]
    Set Suite Variable    ${barcode05}    ${data_input}[barcode05]
    Set Suite Variable    ${barcode06}    ${data_input}[barcode06]
    Set Suite Variable    ${barcode07}    ${data_input}[barcode07]
    Set Suite Variable    ${barcoderan1}    ${data_input}[barcoderan1]
    Set Suite Variable    ${barcoderan2}    ${data_input}[barcoderan2]
    Set Suite Variable    ${barcoderan3}    ${data_input}[barcoderan3]


    # Have headoffice and list account > 1
    ${head_multi_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_multi_headoffice=${head_multi_headoffice}
    ...    head_multi_acc1=${head_multi_acc1}
    ...    head_multi_acc2=${head_multi_acc2}
    ...    client_id=${head_multi_clientid}
    ...    client_secret=${head_multi_clientsecret}
    Set Suite Variable    ${head_multi_data}

    # Have headoffice and list account = 1
    ${head_1_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_1_headoffice=${head_1_headoffice}
    ...    head_1_acc1=${head_1_acc1}
    ...    client_id=${head_1_clientid}
    ...    client_secret=${head_1_clientsecret}
    Set Suite Variable    ${head_1_data}

    # ave head office and list account = 0
    ${head_0_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    head_0_headoffice=${head_0_headoffice}
    ...    head_0_acc1=${head_0_acc1}
    ...    client_id=${head_0_clientid}
    ...    client_secret=${head_0_clientsecret}
    Set Suite Variable    ${head_0_data}

    # No head office and list account = 1
    ${nohead_1_data}    Create Dictionary
    ...    scope=${scope}
    ...    grant_type=${grantType}
    ...    nohead_1_headoffice=${nohead_1_headoffice}
    ...    nohead_1_acc1=${nohead_1_acc1}
    ...    client_id=${nohead_1_clientid}
    ...    client_secret=${nohead_1_clientsecret}
    Set Suite Variable    ${nohead_1_data}