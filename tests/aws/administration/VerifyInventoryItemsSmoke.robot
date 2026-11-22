*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource

Suite Setup     Setup Suite
Test Setup    Setup Test Case
Test Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

Test Tags    test:retry(1)    Prime    administration    smoke.aws    ADM_01    report.label.owner:Quoc Nguyen

*** Variables ***
${input_data}

*** Test Cases ***
Create Inventory Item
    [Documentation]    Verify Create Edit Copy Delete Export And Import a New Inventory Item Sucessfully
    ...    INV_23    INV_24    INV_25    INV_28  
    Generate Input Data
    ${username}    Util.Get User Name
    InventoryItems.Go To Inventory Items
    InventoryItems.Complete Add New Inventory Item       ${input_data}[created_item][item_number]    ${input_data}[created_item][manufacturer]    ${input_data}[created_item][measured_units]
    InventoryItems.Complete Add Lot To Inventory Item    ${input_data}[created_item][item_number]    ${input_data}[created_item][lot]    ${input_data}[created_item][expired_date]
    InventoryItems.Complete Edit Inventory Item    ${username}    ${input_data}[created_item][item_number]    ${input_data}[updated_item][item_number]    ${input_data}[updated_item][manufacturer]    ${input_data}[updated_item][measured_units]
    InventoryItems.Complete Copy Inventory Item     ${username}    ${input_data}[updated_item][item_number]    ${input_data}[copied_item][item_number]    ${input_data}[copied_item][manufacturer]    ${input_data}[copied_item][measured_units]
    ${file_path}    Get Path Exported Inventory Item File
    InventoryItems.Complete Export Item Selection    ${input_data}[copied_item][item_number]
    Verify Export Inventory Item File Sucessfully    ${file_path}
    ${import_time}    InventoryItems.Complete Import Inventory Item    ${file_path}
    InventoryItems.Go To Inventory Items
    InventoryItems.Complete Delete Inventory Item    ${input_data}[updated_item][item_number]
    InventoryItems.Complete Delete Inventory Item    ${input_data}[copied_item][item_number]
    # Verify Import Inventory Item File Sucessfully    ${{[${input_data}[copied_item]]}}    ${username}    ${import_time}

*** Keywords ***
Setup Suite
    ${input_data}    Get Data
    Login To Fusebox    user_name=${Username}    password=${Password}
    Set Suite Variable    ${input_data}

Setup Test Case
    InventoryItems.Go To Inventory Items
    Cleanup Inventory Item Before Run Test    ${input_data}[created_item][item_number]
    Cleanup Inventory Item Before Run Test    ${input_data}[updated_item][item_number]
    Cleanup Inventory Item Before Run Test    ${input_data}[copied_item][item_number]
    
Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home
    LoginKeywords.Check Newsletter

Teardown Suite
    Close Browser

Random Item Number
    ${item_number}    Evaluate    f"{''.join(random.choices('0123456789', k=5))}-{''.join(random.choices('0123456789', k=4))}-{''.join(random.choices('0123456789', k=2))}"    random
    RETURN    ${item_number}

Random New Lot
    ${random_lot}    Evaluate    ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789', k=8))    random
    RETURN    ${random_lot}

Random Expired Date Lot
    ${current_time}    Get Time Now
    ${random_year}    Evaluate    random.randint(1, 10)    random
    ${add_day}    Evaluate    ${random_year} * 365   
    ${expired_lot}    Add Time To Date    date=${current_time}    time=${add_day} days    result_format=%m/%d/%Y    date_format=%Y-%m-%d %H:%M:%S.%f
    RETURN    ${expired_lot}
    
Cleanup Inventory Item Before Run Test
    [Arguments]    ${ndc}
    InventoryItems.Search Inventory Item    ${ndc}
    ${status}    Run Keyword And Return Status    InventoryItems.Get Item Inventory Id    ${ndc} 
    IF    ${status}
        ${inventory_item_id}    InventoryItems.Get Item Inventory Id    ${ndc}
        InventoryItems.Delete Inventory Item    ${inventory_item_id}
    ELSE
        InventoryItems.Clear Search Inventory Item
    END

Generate Input Data
    ${lot}    Random New Lot
    ${expired_date}    Random Expired Date Lot  
    Set To Dictionary    ${input_data}[created_item]    lot=${lot}
    Set To Dictionary    ${input_data}[created_item]    expired_date=${expired_date}

Get Path Exported Inventory Item File
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${date}    Get Time Now    result_format=%-m_%-d_%Y
    ELSE
        ${date}    Get Time Now    result_format=%#m_%#d_%Y
    END
    
    ${file_name}    Set Variable    InventoryItemExport-${date}.xlsx    
    ${export_path}    Get Environment Variable    EXPORT_PATH
    ${download_file_path}    Join Path    ${export_path}    ${file_name}
    ${exists}    Run Keyword And Return Status    File Should Not Be Empty    ${download_file_path}
    Run Keyword If    '${exists}' == 'True'    Remove File    ${download_file_path}
    RETURN    ${download_file_path}

 Verify Export Inventory Item File Sucessfully
    [Arguments]    ${path}
    Wait Until Created    ${path}    60s
    File Should Exist    ${path}

Verify Import Inventory Item File Sucessfully
    [Arguments]    ${items}    ${username}    ${import_time}
    ${amount}    Get Length    ${items}
    ${import_summary}    Set Variable    1 Items imported by ${username} ${import_time} 
    InventoryItems.Go To Inventory Items
    InventoryItems.Open Import Management
    InventoryItems.Select Import Summary Option    ${import_summary}
    Util.Waiting For Loading
    FOR    ${item}    IN    @{items}
        InventoryItems.Get Item Inventory Id    ${item}[item_number]
    END
    InventoryItems.Select Import Summary Option    -- Select an Import --
    Util.Waiting For Loading
    InventoryItems.Close Import Management

    
    
