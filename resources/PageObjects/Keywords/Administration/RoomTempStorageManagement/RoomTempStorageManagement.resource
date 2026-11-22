*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${create_room_temp_btn}    //*[@id='CreateRoomTempStorageBtn']
${delete_room_temp_btn}    //*[@id='DeleteRoomTempStorageBtn']
${edit_room_temp_btn}    //*[@id='EditRoomTempStorageBtn']
${room_temp_desc_input}    //*[@id='RoomTempDescription']
${save_room_temp}    //*[@id='SaveRoomTempDescriptionBtn']
${view_assign_account_btn_room_temp}    //*[@id='ViewRoomTempAccountsBtn']
${view_assign_room_temp_btn}    //*[@id='ViewRoomTempItemsBtn']
${close_modal_room_temp}    //*[@id='TopCloseBtn']
${continue_btn_room_temp}    //button[contains(text(),'Continue')]
${room_temp_id_select}    //*[@id='StorageManagement']

*** Keywords ***
Go To Room Temp Storage Management
    Scroll And Click Element    link:Administration
    Scroll And Click Element    link:Room Temp Storage Management

Click Create Room Temp Storage
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${create_room_temp_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Create Room Temp Storage List')]    30s

Select Room Temp Storage
    [Arguments]    ${room_temp}
    Select From List By Label    ${room_temp_id_select}    ${room_temp}

Input Room Temp Storage Description
    Clear Input Field Until Empty    ${room_temp_desc_input}
    ${room_temp}    Util.Generate Meaningful Alpha Description    room_temp    3
    Input Text Into Field    ${room_temp_desc_input}    ${room_temp}
    RETURN    ${room_temp}

Click Save Room Temp Storage
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${save_room_temp}

Click Close Room Temp Storage
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${close_modal_room_temp}

Click Edit Room Temp Storage
    Wait Until Element Is Not Visible    //h4[contains(text(),'Create Room Temp Storage List')]    30s
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${edit_room_temp_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Edit Room Temp Storage List')]    30s

Click Delete Room Temp Storage
    Waiting For Loading
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${delete_room_temp_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Delete Room Temp Storage Management')]    30s

Click Continue
    Wait Until Keyword Succeeds    30s    1s    Scroll And Click Element    ${continue_btn_room_temp}

Create Room Temp Storage
    Click Create Room Temp Storage
    ${room_temp}    Input Room Temp Storage Description
    Click Save Room Temp Storage
    Common.Page Alert Message    Room Temp Storage Description Successfully Created.
    Click Close Room Temp Storage
    RETURN    ${room_temp}

Edit Room Temp Storage
    [Arguments]    ${room_temp}
    Select Room Temp Storage    ${room_temp}
    Click Edit Room Temp Storage
    ${room_temp}    Input Room Temp Storage Description
    Click Save Room Temp Storage
    Common.Page Alert Message    Room Temp Storage Description Successfully Updated.
    Click Close Room Temp Storage
    RETURN    ${room_temp}

Delete Room Temp Storage
    [Arguments]    ${room_temp}
    Select Room Temp Storage    ${room_temp}
    Click Delete Room Temp Storage
    Click Continue
    Common.Page Alert Message    Room Temp Storage Management Successfully Deleted.