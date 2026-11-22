*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${export_btn_vendor_acc}    //*[@id='VendorAccountDownloadButton']
${export_file_btn_vendor_acc}    //*[@id='btnExportFile']
${account_search_vendor_acc}    //*[@id='SearchValues']
${find_btn_vendor_acc}    //*[@id='FindButton']
${vendors_select_vendor_acc}    //*[@id='ms-list-2']
${headoffice_select_vendor_acc}    //*[@id='HeadOfficeAccountId']
${association_select_vendor_acc}    //*[@id='AssociationId']
${members_input_vendor_acc}    //*[@id='ms-list-1']
${update_btn_vendor_acc}    //*[@id='updateButton']
${detail_input_vendor_acc}    //*[contains(text(),'Shipping Acct #:')]//following::input[1]
${member_list_vendor_acc}    //*[@id='MemberList']
*** Keywords ***

Go To Verdor Account Numbers
    Click Element    link:Administration
    Click Element    link:Vendor Account Numbers

Input Account Search
    [Arguments]    ${account_arg}
    Input Text Into Field    ${account_search_vendor_acc}    ${account_arg}

Click Find Account Search
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${find_btn_vendor_acc}

Click Export Vendor
    Wait Until Element Is Visible    ${export_btn_vendor_acc}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${export_btn_vendor_acc}

Click Update All
    Wait Until Element Is Visible    ${update_btn_vendor_acc}    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${update_btn_vendor_acc}

Input Detail Vendor
    Clear Input Field Until Empty    ${detail_input_vendor_acc}
    ${vendor_detail}    Util.Generate Meaningful Alpha Description    vendor_detail    3
    Input Text Into Field    ${detail_input_vendor_acc}    ${vendor_detail}
    RETURN    ${vendor_detail}

Click Export File 
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${export_file_btn_vendor_acc}

Select Head Offices
    [Arguments]    ${headoffice_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${headoffice_select_vendor_acc}    ${headoffice_arg}

Select Associations
    [Arguments]    ${association_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${association_select_vendor_acc}    ${association_arg}

Select Members
    [Arguments]    ${member_arg}
    Waiting For Loading
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${members_input_vendor_acc}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='ms-list-1']//following::*[contains(text(),'${member_arg}')]

Select Vendors
    [Arguments]    ${vendor_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${vendors_select_vendor_acc}
    Wait Until Keyword Succeeds    30s    1s    Click Element    (//*[@id='ms-list-2']//following::*[contains(text(),'${vendor_arg}')])[1]

Confirm Connection Status
    Wait Until Element Is Visible    //h4[contains(text(),'EDI Connection Status')]    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='vendorUpdateModal-primary-btn' and contains(text(),'Confirm')]

Find Vendor Account
    [Arguments]    ${account_arg}    ${headoffice_arg}    ${association_arg}    ${member_arg}    ${vendor_arg}
    Input Account Search    ${account_arg}
    Click Find Account Search
    Select Head Offices    ${headoffice_arg}
    Select Associations    ${association_arg}
    Select Members    ${member_arg}
    Select Vendors    ${vendor_arg}

Update Vendor Account Detail
    Wait Until Element Is Visible    ${member_list_vendor_acc}
    ${vendor_detail}    Input Detail Vendor
    Click Update All
    Confirm Connection Status
