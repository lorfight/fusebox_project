*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py

*** Variables ***
${kit_seach_value_input}    //input[@id="SearchValues"]
${kit_find_btn}    //button[@id="FindButton"]
${kit_clear_btn}    //button[@id="ClearButton"]
${build_new_kit_btn}    //a[text()='Build New Kit']
${create_a_new_kit_title}    //h4[text()='Create A New Kit']
${kit_upload_image}    //input[@id="imageFile"]
${kit_number_input}    //input[@id="KitNumber"]
${kit_description_input}    //input[@id="Description"]
${kit_save_btn}    //button[@id="SaveBtn"]
${kit_delete_btn}    //button[@id="DeleteBtn"]
${kit_close_btn}    //div[@id="ModalPopup"]//button[@id="CloseBtn"]
${kit_update_btn}     //button[@id="SaveBtn" and text()='Update']
${update_your_kit_title}    //h4[text()='Update Your Kit']

*** Keywords ***
Go To Available Kits Page
    Common.Scroll And Click Element    link: Dispensing
    Common.Scroll And Click Element    link: Available Kits
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Available Kits

Search For Kit
    [Arguments]    ${kit_value}
    Click Clear Search For Kit Button
    Input Search Kit Values Field    ${kit_value}
    Click Find Search For Kit Button

Input Search Kit Values Field
    [Arguments]    ${kit_value}
    Wait Until Element Is Visible    ${kit_seach_value_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${kit_seach_value_input}    ${kit_value}

Click Clear Search For Kit Button
    Common.Scroll And Click Element    ${kit_clear_btn}

Click Find Search For Kit Button
    Common.Scroll And Click Element    ${kit_find_btn}

Open Create A New Kit ModalPopup
    Common.Scroll And Click Element    ${build_new_kit_btn}
    Wait Until Element Is Visible    ${create_a_new_kit_title}    30s

Upload New Kit Image
    [Arguments]    ${img_url_arg}
    Choose File    ${kit_upload_image}    ${img_url_arg}

Input Kit Number
    [Arguments]    ${kit_number_arg}
    Wait Until Element Is Visible    ${kit_number_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${kit_number_input}    ${kit_number_arg}

Input Kit Description
    [Arguments]    ${kit_description_arg}
    Wait Until Element Is Visible    ${kit_description_input}    30s
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${kit_description_input}    ${kit_description_arg}

Click Create Kit Button
    Common.Scroll And Click Element    ${kit_save_btn}

Click Delete Kit Button
    Common.Scroll And Click Element    ${kit_delete_btn}

Click Close Kit Button
    Common.Scroll And Click Element    ${kit_close_btn}

Click Update Kit Button
    Common.Scroll And Click Element    ${kit_update_btn}

Create A New Kit
    [Arguments]    ${kit_number_arg}    ${kit_description_arg}
    Input Kit Number    ${kit_number_arg}
    Input Kit Description    ${kit_description_arg}
    Click Create Kit Button
    Common.Page Alert Message    Kit Successfully Created.

Edit Kit Row Is Visible In Available Kits List
    [Arguments]    ${update_kit_number_arg}    ${update_kit_description_arg}
    Input Kit Number    ${update_kit_number_arg}
    Input Kit Description    ${update_kit_description_arg}
    Click Update Kit Button
    Common.Page Alert Message    Kit Successfully Updated.

Open Update Kit ModalPopup
    [Arguments]    ${created_kit_number_arg}
    ${kit_edit_btn}    Set Variable    //a[@class="prevent_default" and text()='${created_kit_number_arg}']//following::a[contains(text(),'Edit')][1]
    Common.Scroll And Click Element    ${kit_edit_btn}
    Wait Until Element Is Visible    ${update_your_kit_title}    30s

Delete Kit Row Is Visible In Available Kits List
    [Arguments]    ${update_kit_number_arg}
    Open Update Kit ModalPopup    ${update_kit_number_arg}
    Click Delete Kit Button
    Alert Should Be Present    Are you sure you want to delete this kit?    Accept
    Common.Page Alert Message    Kit Successfully Removed.

Prepare Data For Kit
    ${Fake_dict}    Generate Fake Data    sentence    num_rand
    ${kit_number}    Set Variable    ${Fake_dict['num_rand']}
    ${kit_description}    Set Variable    ${Fake_dict['sentence']}
    RETURN    ${kit_number}    ${kit_description}