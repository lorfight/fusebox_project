*** Settings ***
Documentation      Order Received
Library    BuiltIn
Library    ../../../resources/EdiObjects/TestData/edi_curascript_create_855_856_810.py
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Takeda_997    takeda

*** Test Cases ***
Order Received
    Generate EDI 997 from 850
    Send sFTP
    Trigger Jenkins MirthProcessor Build    ${jenkins_url}    ${jenkins_user}    ${jenkins_api_token}    ${job_name_takeda}
    OpenOrder.Open Orders
    Clear Button
    Filter Distributor
    Filter Location
    EDI Search For An Order ${edi_po_number}
    Sleep    2
    Check Order Received Message Status

*** Keywords ***
Set Up Suite
    ${data_input}    ${data_configs}    Get Data EDI
    Set Suite Variable    ${jenkins_url}    ${data_configs}[edi][jenkins_url]
    Set Suite Variable    ${jenkins_user}    ${data_configs}[edi][jenkins_user]
    Set Suite Variable    ${jenkins_api_token}    ${data_configs}[edi][jenkins_api_token]
    Set Suite Variable    ${job_name_takeda}    ${data_configs}[edi][takeda][job_name]
    Set Suite Variable    ${takeda_hostname}    ${data_configs}[edi][takeda][hostname]
    Set Suite Variable    ${takeda_username}    ${data_configs}[edi][takeda][username]
    Set Suite Variable    ${takeda_password}    ${data_configs}[edi][takeda][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]

Generate EDI 997 from 850
    ${edi_po_number}    Read Edi File    ${EXECDIR}\\tests\\edi\\PONumber.txt
    Set Global Variable    ${edi_po_number}
    ${edi_data_850}    Read Edi File    ${EXECDIR}\\tests\\edi\\message_ui\\${edi_po_number}_850.txt
    ${parsed_850_data}    Parse Edi 850    ${edi_data_850}
    ${edi_data_855}    Create Edi 997    ${parsed_850_data}
    Create File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_997.txt    ${edi_data_855}

Send sFTP
    Connect to SFTP Takeda
    Put File    ${EXECDIR}/tests/edi/message_ui/${edi_po_number}_997.txt    ${inbound_path}
    Close All Connections