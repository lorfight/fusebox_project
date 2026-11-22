*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${vendors_filter}    //*[@id='DistributerAccountId']
${members_filter}    //*[@id='MemberAccountId']
${export_catalog}    //*[@id='CatagoryItemDownLoadButton']
${search_item_input_catalog}    //*[@id='SearchValues']
${find_item_btn_catalog}    //*[@id='FindButton']

*** Keywords ***
Go To Vendor Catalogs
    Click Element    link:Administration
    Click Element    link:Vendor Catalogs

Filter Vendor In Catalog Page
    [Arguments]    ${vendor_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${vendors_filter}    ${vendor_arg}

Filter Members In Catalog Page
    [Arguments]    ${member_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${members_filter}    ${member_arg}
    Wait Until Element Is Visible    //*[normalize-space()='NDC:']/parent::div    60s

Filter Item In Catalog Page
    [Arguments]    ${ndc_arg}
    Input Text Into Field    ${search_item_input_catalog}    ${ndc_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${find_item_btn_catalog}

Click Export In Catalog Page
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${export_catalog}
    Handle Alert    ACCEPT

View Catalog Item List
    [Arguments]    ${vendor_arg}    ${member_arg}    ${ndc_arg}
    Filter Vendor In Catalog Page    ${vendor_arg}
    Filter Members In Catalog Page    ${member_arg}
    Filter Item In Catalog Page    ${ndc_arg}
    Wait Until Element Is Visible    (//*[normalize-space()='NDC:']/parent::div)[1]
    
Export Catalog Report
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${file_name}    Get File Name    PriceCatalogReport    %-m_%-d_%Y
    ELSE
        ${file_name}    Get File Name    PriceCatalogReport    %#m_%#d_%Y
    END
    ${export_path}=    Get Environment Variable    EXPORT_PATH
    ${export_path}=    Join Path    ${export_path}    ${file_name}
    Click Export In Catalog Page
    Wait Until Created    ${export_path}    timeout=1 min
    File Should Exist    ${export_path}
    ${exists}=    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${export_path}
