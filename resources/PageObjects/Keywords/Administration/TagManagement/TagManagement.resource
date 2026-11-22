*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${create_tag}    //*[contains(text(),'Create Tag')]
${tag_description}    //*[@id='TagDescription']
${save_tag}    //*[@id='SaveBtn']
${tag_search}    //*[@id='TagSearchValues']
${find_btn_tag}    //*[@id='FindTagBtn']
${edit_tag}    //*[contains(text(),'Edit')]
${delete_tag}    //*[contains(text(),'Delete')]

*** Keywords ***
Go To Tag Management
    Click Element    link:Administration
    Click Element    link:Tag Management

Click Create Tag
    Click Element    ${create_tag}

Input Tag Description
    [Arguments]    ${tag_desc}
    Input Text Into Field    ${tag_description}    ${tag_desc}

Click Save Tag
    Click Element    ${save_tag}

Input Search Tag
    [Arguments]    ${tag_desc}
    Input Text Into Field    ${tag_search}    ${tag_desc}

Find Tag Management
    [Arguments]    ${tag_desc}
    Input Search Tag    ${tag_desc}
    Click Element    ${find_btn_tag}
    Wait Until Element Is Visible    //*[@id='TagManagementList']//following::strong[contains(text(),'${tag_desc}')]

Click Edit
    Wait Until Element Is Visible    ${edit_tag}
    Click Element    ${edit_tag}
    Wait Until Element Is Visible    //h4[contains(text(),'Edit Tag')]

Click Delete
    Click Element    ${delete_tag}
    Common.Page Alert Message    Tag Deleted.

Create Tag Management   
    Click Create Tag
    ${tag_desc}    Util.Generate Meaningful Alpha Description    tag_desc    3
    Util.Waiting For Loading
    Input Tag Description    ${tag_desc}
    Click Save Tag
    Common.Page Alert Message    Tag Created.
    RETURN    ${tag_desc}

Edit Tag Management
    Click Edit
    ${tag_desc}    Util.Generate Meaningful Alpha Description    tag_desc    3
    Input Tag Description    ${tag_desc}
    Click Save Tag
    Common.Page Alert Message    Tag Updated.
    RETURN    ${tag_desc}


