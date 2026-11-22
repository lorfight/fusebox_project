*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Prime    administration    smoke.aws    ADM_03    report.label.owner:Quoc Nguyen
*** Variables ***
${input_data}

*** Test Cases ***
Verify Category Item Feature
    [Documentation]    Verify Create Category, Add And Remove Item From Category Sucessfully
    ...      ADM-66    ADM-67    ADM-68    ADM-69    ADM-70    ADM-71    ADM-72
    CategorizeItems.Go To Categorize Items
    CategorizeItems.Complete Create New Category    ${input_data}[category]
    CategorizeItems.Complete Add Item To Category    ${input_data}[ndc]    ${input_data}[category]
    ${file_path}    Get Path Exported Item Categories File    
    InventoryItems.Go To Inventory Items
    InventoryItems.Complete Export Item Categories    ${input_data}[ndc]
    Verify Export Item Categories File Sucessfully    ${file_path}
    CategorizeItems.Go To Categorize Items
    CategorizeItems.Complete Remove Item From Category    ${input_data}[ndc]    ${input_data}[category]
    InventoryItems.Go To Inventory Items
    InventoryItems.Complete Import Item Categories    ${file_path}
    CategorizeItems.Go To Categorize Items
    CategorizeItems.Complete Remove Item From Category    ${input_data}[ndc]    ${input_data}[category]

*** Keywords ***
Setup Suite
    ${input_data}    Get Data
    Login To Fusebox    user_name=${Username}    password=${Password}
    Set Suite Variable    ${input_data}

Setup Test Case
    Random New Category
    @{category_list}    InventoryItems.Complete Get List Category Item    ${input_data}[ndc]    
    FOR    ${category}    IN    @{category_list}
        CategorizeItems.Go To Categorize Items
        CategorizeItems.Complete Remove Item From Category    ${input_data}[ndc]    ${category}
    END
   
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

Random New Category
    ${date_time}    Get Time Now    result_format=%Y%m%d%H%M%S
    ${category}    Set Variable   Category_${date_time}
    Set To Dictionary    ${input_data}    category=${category}

Get Path Exported Item Categories File
    ${file_name}    Set Variable    ItemCategoryImportTemplate.xlsx    
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${download_file_path}    Join Path    ${export_path}    ${file_name}
    ${exists}    Run Keyword And Return Status    File Should Not Be Empty    ${download_file_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${download_file_path}
    RETURN    ${download_file_path}

 Verify Export Item Categories File Sucessfully
    [Arguments]    ${path}
    Wait Until Created    ${path}    60s
    File Should Exist    ${path}

