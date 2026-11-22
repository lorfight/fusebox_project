*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Prime    administration    smoke.aws    ADM_02    report.label.owner:Quoc Nguyen
*** Variables ***
${input_data}

*** Test Cases ***
Verify Add Vendor Item Number Blacklist
    [Documentation]    Verify Add Vendor Item Number To Blacklist Sucessfully
    ...  VEN-3
    VendorItemNumbers.Go To Inventory Items
    VendorItemNumbers.Complete Add Vendor Number Item Blacklist    ${input_data}[blacklist][vendor] (${input_data}[blacklist][vendor_id])    ${input_data}[blacklist][vendor_item_number]
    VendorItemNumbers.Complete Delete Vendor Number Item Blacklist     ${input_data}[blacklist][vendor] (${input_data}[blacklist][vendor_id])    ${input_data}[blacklist][vendor_item_number]

Verify Import Vendor Item Number
    [Documentation]    Verify Import Vendor Item Number Sucessfully
    ...  VEN-4
    
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${folder_exists}    Run Keyword And Return Status    Directory Should Exist       ${export_path}
    Run Keyword If    '${folder_exists}' == 'False'    Create Directory    ${export_path}
    ${export_path}    Join Path    ${export_path}    ImportVendorItemNumberExcelFile.xlsx
    ${file_exists}    Run Keyword And Return Status    File Should Not Be Empty    ${export_path}
    Run Keyword If    '${file_exists}' == 'True'    Remove File    ${export_path}
    ${data}    Set Variable    ${{[["Item Number", "NDC Package Code", "Manufacturer Name", "Vendor Name", "Vendor Item Number"], ["${input_data}[changed][ndc]","","${input_data}[changed][manufacturer]","${input_data}[changed][vendor]", "${input_data}[changed][vendor_item_number]"]]}}    
    Create Excel File    ${export_path}    ${data}       
    VendorItemNumbers.Go To Inventory Items
    VendorItemNumbers.Complete Import Vendor Item Number    ${export_path}

Verify Change Vendor Item Number
    [Documentation]    Verify Change Vendor Item Number Sucessfully
    ...  VEN-5
    VendorItemNumbers.Go To Inventory Items
    VendorItemNumbers.Complete Change Vendor Item Number    ${input_data}[changed][vendor] (${input_data}[blacklist][vendor_id])    ${input_data}[changed][ndc]    ${input_data}[changed][vendor_item_number]    

*** Keywords ***
Setup Suite
    ${input_data}    Get Data
    Login To Fusebox    user_name=${Username}    password=${Password}
    Set Suite Variable    ${input_data}

Setup Test Case
    Random Vendor Item Number 

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

Random Vendor Item Number 
    ${random_blacklist_item_number}    Evaluate    ''.join(str(random.randint(0,9)) for _ in range(6))    random
    ${random_changed_item_number}    Evaluate    ''.join(str(random.randint(0,9)) for _ in range(6))    random
    Set To Dictionary    ${input_data}[blacklist]    vendor_item_number=${random_blacklist_item_number}
    Set To Dictionary    ${input_data}[changed]    vendor_item_number=${random_changed_item_number}