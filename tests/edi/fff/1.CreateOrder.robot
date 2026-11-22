*** Settings ***
Documentation      Create Order
Variables  ../../../resources/EdiObjects/TestData/EdiTestdata.py
Resource    ../../../resources/EdiObjects/Keywords/EDIOrder.resource


Suite Setup    Run Keywords   Login To Fusebox    user_name=${Username}    password=${Password}    AND
...            Set Up Suite
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Test Tags    edi    Fff_850    fff

*** Test Cases **
Get Before Order File List sFTP
	[Documentation]   Get file list in sFTP before create order
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Connect to SFTP FFF
    Get Before Order File List sFTP

Create Order
	[Documentation]   Create order
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    EDI Create Order FFF

Open Order and Get msg 850
	[Documentation]   Open Open Order page and get msg 850
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Open Order and Get msg 850

Validate 850 GAP
	[Documentation]   Validate msg 850 with GAP 850
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Validate 850 GAP

Get After Order File List sFTP
	[Documentation]   Get file list in sFTP after create order
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Connect to SFTP FFF
    Get After Order File List sFTP

Find Difference File and Compare Files
	[Documentation]   Find difference file between the list before and after ordering
	[Tags]    Integration    Regession    Order
    ...  allure.label.owner:Do Luong
    Find Difference File
    Compare Files

*** Keywords ***
Set Up Suite
    ${data_input}    ${data_configs}    Get Data EDI
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${edi_location}    ${data_input}[edi_location]
    Set Suite Variable    ${vendor}    ${data_configs}[edi][fff][vendor]
    Set Suite Variable    ${FFF_ndc1}    ${data_input}[FFF_ndc1]
    Set Suite Variable    ${FFF_ndc2}    ${data_input}[FFF_ndc2]
    Set Suite Variable    ${fff_hostname}    ${data_configs}[edi][fff][hostname]
    Set Suite Variable    ${fff_username}    ${data_configs}[edi][fff][username]
    Set Suite Variable    ${fff_password}    ${data_configs}[edi][fff][password]
    Set Suite Variable    ${inbound_path}    ${data_configs}[edi][inbound_path]
    Set Suite Variable    ${outbound_path}    ${data_configs}[edi][outbound_path]
	Set Suite Variable    $location    ${edi_location}
    Set Suite Variable    $vendor    ${vendor}