*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${create_preference_btn}    //*[@onclick and contains(text(),'Create')]
${delete_preference_btn}    //*[@onclick and contains(text(),'Delete')]
${edit_preference_btn}    //*[@onclick and contains(text(),'Edit')]
${preference_desc_input}    //*[@id='PreferenceDescription']
${save_preference}    //*[@id='SavePreferenceDescriptionBtn']
${view_assign_account_btn_preference}    //*[@id='ViewModalAccountListBtn']
${view_assign_inventory_btn_preference}    //*[@id='ViewModalItemListBtn']
${close_modal_preference}    //*[@id='TopCloseBtn']
${continue_btn_preference}    //button[contains(text(),'Continue')]
${preference_id_select}    //*[@id='SelectedPreferenceID']

*** Keywords ***
Go To Product Preference Management
    Scroll And Click Element    link:Administration
    Scroll And Click Element    link:Product Preference Management

Click Create Preference
    Scroll And Click Element    ${create_preference_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Create Product Preference')]    30s

Select Preference
    [Arguments]    ${preference}
    Select From List By Label    ${preference_id_select}    ${preference}

Input Preference Description
    Clear Input Field Until Empty    ${preference_desc_input}
    ${preference}    Generate Meaningful Alpha Description    preference    3
    Input Text Into Field    ${preference_desc_input}    ${preference}
    RETURN    ${preference}

Click Save Preference
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${save_preference}

Click Close Preference
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${close_modal_preference}

Click Edit Preference
    Wait Until Element Is Not Visible    //h4[contains(text(),'Create Product Preference')]    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${edit_preference_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Edit Product Preference')]    30s

Click Delete Preference
    Waiting For Loading
    Sleep    2s
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${delete_preference_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Delete Product Preference')]    30s

Click Continue
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${continue_btn_preference}

Create Preference
    Click Create Preference
    ${preference}    Input Preference Description
    Click Save Preference
    Common.Page Alert Message    Preference Description Successfully Created.
    Click Close Preference
    RETURN    ${preference}

Edit Preference
    [Arguments]    ${preference}
    Select Preference    ${preference}
    Click Edit Preference
    ${preference}    Input Preference Description
    Click Save Preference
    Common.Page Alert Message    Preference Description Successfully Updated.
    Click Close Preference
    RETURN    ${preference}

Delete Preference
    [Arguments]    ${preference}
    Wait Until Element Is Not Visible    //h4[contains(text(),'Edit Product Preference')]    30s
    Select Preference    ${preference}
    Click Delete Preference
    Click Continue
    Common.Page Alert Message    Product Preference Deleted.
