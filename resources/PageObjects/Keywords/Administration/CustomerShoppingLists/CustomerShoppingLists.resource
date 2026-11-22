*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${shopping_list_title}    //*[@id='Title']
${description_input_shopping}    //*[@id='Description']
${owner_select_shopping}    //*[@id='OwnerId']
${save_shopping_list_btn}    //*[@id='SaveButton']
${close_btn_shopping}    //*[@id='CancelButton']
${search_input_shopping}    //*[@id='InventoryItemSearchValues']
${find_btn_shopping}    //*[@id='InventoryItemSearchFindButton']
${add_btn_shopping}    //*[@onclick and contains(text(),' Add')]
${remove_btn_shopping}    //*[@onclick and contains(text(),' Remove From List ')]
${search_shopping_list_input}    //*[@id='SearchValues']
${find_shopping_list_btn}    //*[@id='FindButton']
${association_select_shopping}    //*[@id='AssociationId']
${assigned_members_checkbox_shopping}    //*[@id='memberAssignedOnlyCheckbox']

*** Keywords ***
Go To Customer Shopping Lists
    Click Element    link:Administration
    Click Element    link:Customer Shopping Lists

Click New Customer Shopping List
    Wait Until Keyword Succeeds    30s    1s    Click Element    link: New Customer Shopping List 

Click Member Assignments
    Wait Until Keyword Succeeds    30s    1s    Click Element    link:Member Assignments

Input Shopping List Title
    [Arguments]    ${title_customer_shopping}
    Input Text Into Field    ${shopping_list_title}    ${title_customer_shopping}

Select Owner/List Origin
    [Arguments]    ${owner_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${owner_select_shopping}    ${owner_arg}

Click Save Shopping List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${save_shopping_list_btn}

Click Close Shopping List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${close_btn_shopping}

Search Available Items
    [Arguments]    ${ndc_arg}
    Input Text Into Field    ${search_input_shopping}    ${ndc_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${find_btn_shopping}

Click Add Item
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_btn_shopping}
    Common.Page Alert Message    Shopping List Line Successfully Added!

Search List Items
    [Arguments]    ${ndc_arg}
    Scroll Element Into View    ${find_shopping_list_btn}
    Input Text Into Field    ${search_shopping_list_input}    ${ndc_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${find_shopping_list_btn}

Click Remove From List
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove_btn_shopping}
    Common.Page Alert Message    Shopping List Line Successfully Removed!

Select An Association
    [Arguments]    ${association_arg}
    Wait Until Element Is Visible    ${association_select_shopping}    10s
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${association_select_shopping}    ${association_arg}

Assigned Member
    [Arguments]    ${member_arg}
    ${member_input}    Set Variable    //td[contains(normalize-space(.),'${member_arg}')]//input
    Wait Until Element Is Visible    ${member_input}    30s
    ${is_check}    Run Keyword And Return Status    Checkbox Should Be Selected    ${member_input}
    IF    '${is_check}'=='False'
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${member_input}
    END

Unassigned Member
    [Arguments]    ${member_arg}
    ${member_input}    Set Variable    //td[contains(normalize-space(.),'${member_arg}')]//input
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${member_input}


Show Assigned Member
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${assigned_members_checkbox_shopping}

Input Description
    [Arguments]    ${shopping_desc}
    Clear Input Field Until Empty    ${description_input_shopping}
    Input Text Into Field    ${description_input_shopping}    ${shopping_desc}

Create Shopping List
    [Arguments]    ${title_customer_shopping}    ${owner_arg}
    Input Shopping List Title    ${title_customer_shopping}
    Select Owner/List Origin    ${owner_arg}
    Click Save Shopping List

Update Shopping List Item
    [Arguments]    ${title_customer_shopping}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[normalize-space()='${title_customer_shopping}']
    Run Keyword If    ${is_visible}    Click Element    //span[normalize-space()='${title_customer_shopping}']//ancestor::td[1]
    ${shopping_desc}    Generate Meaningful Alpha Description    shopping_desc    3
    Input Description    ${shopping_desc}
    Click Save Shopping List
    Common.Page Alert Message    Shopping List Saved!

# Get Description In Shopping List Item
#     [Arguments]    ${title_customer_shopping}
#     Wait Until Element Is Visible    //span[normalize-space()='${title_customer_shopping}']    30s
#     ${desc_txt}    Fetch From Right    //span[normalize-space()='AutoTest']//following::div[1]    Description: 
#     RETURN    ${desc_txt}

Check Shopping List Item
    [Arguments]    ${title_customer_shopping}    ${owner_arg}
    ${is_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    //span[normalize-space()='${title_customer_shopping}']
    IF    ${is_visible}
        Wait Until Keyword Succeeds    30s    1s    Click Element    //span[normalize-space()='${title_customer_shopping}']//ancestor::td[1]
        # ${shopping_desc}    Generate Meaningful Alpha Description    shopping_desc    3
        # Input Description    ${shopping_desc}
        # Click Save Shopping List
        # Common.Page Alert Message    Shopping List Saved!
    ELSE
        Click New Customer Shopping List
        Create Shopping List    ${title_customer_shopping}    ${owner_arg}
    END

Verify Assign/Unassign Member
    [Arguments]    ${association_arg}    ${member_arg}
    Click Member Assignments
    Select An Association    ${association_arg}
    Waiting For Loading
    Assigned Member    ${member_arg}
    Show Assigned Member
    Verify Checkbox Assign Member    ${member_arg}
    Unassigned Member    ${member_arg}

Verify Checkbox Assign Member
    [Arguments]    ${member_arg}
    ${assign_checkbox}    Set Variable    //td[contains(normalize-space(.),'${member_arg}')]//input
    Wait Until Element Is Visible    ${assign_checkbox}    30s