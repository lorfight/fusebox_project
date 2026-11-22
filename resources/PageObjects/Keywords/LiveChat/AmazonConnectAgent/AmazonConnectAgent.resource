*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${task_view_iframe}    iframe[title="Contact Control Panel Task View"]
${number_pad_iframe}    iframe[title="Contact Control Panel Number Pad"]

*** Keywords ***
Select Current Agent Status
    [Arguments]    ${status_arg}
    Click    ${task_view_iframe} >>> div[data-testid="agent-status-current"] 
    Click    ${task_view_iframe} >>> xpath=//li//span[text()="${status_arg}"] 

Choose Client
    [Arguments]    ${client_name_arg}
    ${client_row}    Set Variable    ${task_view_iframe} >>> xpath=//h4[text()="${client_name_arg}"]
    Wait For Elements State    ${client_row}    visible
    Click    ${client_row}

Click Accept Chat Button
    Click    ${number_pad_iframe} >>> button[aria-label="Accept chat"] 
    Wait For Elements State    ${number_pad_iframe} >>> xpath=//div[text()="Connected chat"]    visible
    ${chat_container}    Set Variable    ${number_pad_iframe} >>> xpath=//p[contains(text(),"Chat started with")]
    Wait For Elements State    ${chat_container}    visible

Click Reject Chat Button
    Click    ${number_pad_iframe} >>> button[aria-label="Reject chat"] 

Input Message
    [Arguments]    ${description_arg}
    Fill Text    ${number_pad_iframe} >>> textarea[aria-label="Type a message and press enter to send"]     ${description_arg}

Click Send Message Button
    Click    ${number_pad_iframe} >>> div[id="chat-send-message-button"] >> nth=0

Get Message Realtime
    ${sending_text}    Set Variable    ${number_pad_iframe} >>> div[data-testid="message-header-status"]:has-text("Sending") >> nth=-1
    Wait For Elements State    ${sending_text}    hidden
    ${agent_timestamp_text}    Set Variable    ${number_pad_iframe} >>> div[data-testid="message-header-status"] >> nth=-1
    Wait For Elements State    ${agent_timestamp_text}    visible
    ${agent_message_timestamp}    Browser.Get Text    ${agent_timestamp_text}
    RETURN    ${agent_message_timestamp}

Send Message
    ${Fake_dict}    Generate Fake Data    sentence
    ${agent_message}    Set Variable    ${Fake_dict['sentence']} 
    Input Message     ${agent_message}
    Click Send Message Button
    ${agent_message_timestamp}    Get Message Realtime
    RETURN    ${agent_message}    ${agent_message_timestamp}

Verify Received Message Data
    [Arguments]    ${customer_message}    ${customer_message_timestamp}
    ${received_message}    Browser.Get Text    ${number_pad_iframe} >>> div[direction="Incoming"] >> nth=-1
    ${received_timestamp}    Browser.Get Text    ${number_pad_iframe} >>> div[data-testid="message-header-status"] >> nth=-1
    Should Be Equal    ${received_message}    ${customer_message} 
    ${received_timestamp}    Convert Date    ${received_timestamp}    result_format=%I:%M %p    date_format=%H:%M
    ${received_timestamp}    Handle Datetime Format    fmt={h}:{mi} {ampm}    dt=${received_timestamp}
    Should Contain    ${received_timestamp}    ${customer_message_timestamp}

Click End Chat Button
    Click    ${number_pad_iframe} >>> xpath=//span[text()="End chat"] 
    Wait For Elements State    ${number_pad_iframe} >>> textarea[aria-label="Type a message and press enter to send"]    hidden

Click Close Contact Button
    ${close_contact_btn}    Set Variable    ${number_pad_iframe} >>> xpath=//span[text()="Close contact"] 
    Wait For Elements State    ${close_contact_btn}    visible
    Click    ${close_contact_btn} 
    Wait For Elements State    ${close_contact_btn}    hidden

Click Remove Missed Chat Button
    ${remove_chat_btn}    Set Variable    ${number_pad_iframe} >>> button[title="Remove Missed chat"]
    Wait For Elements State    ${remove_chat_btn}    visible
    Click    ${remove_chat_btn}

Handle Missed Chat
    ${remove_chat_btn}    Set Variable    ${number_pad_iframe} >>> button[title="Remove Missed chat"]
    ${check_visible}    Run Keyword And Return Status    Wait For Elements State    ${remove_chat_btn}    visible    2s
    Run Keyword If    ${check_visible}    Click Remove Missed Chat Button

Handle Incoming Chat
    ${accept_chat_btn}    Set Variable    ${number_pad_iframe} >>> button[aria-label="Accept chat"] 
    ${check_visible}    Run Keyword And Return Status    Wait For Elements State    ${accept_chat_btn}    visible    2s
    Run Keyword If    ${check_visible}    Click Accept Chat Button

End All Chats In Task List    #78-TC146    78-TC151   
    Handle Incoming Chat
    Handle Missed Chat
    ${customer_list}    Browser.Get Element Count    ${task_view_iframe} >>> div[data-testid="task-list-row-popover-container"]
    IF    "${customer_list}" > "0"
        FOR    ${customer_row}    IN RANGE    ${customer_list}
            Click    ${task_view_iframe} >>> div[data-testid="task-list-row-popover-container"] >> nth=0
            Click End Chat Button
            Click Close Contact Button
        END
    END

Verify Client Information In Pre Chat Form Contact
    [Arguments]    ${client_info}
    ${pre_chat_form_msg}    Set Variable    ${number_pad_iframe} >>> xpath=//span[contains(text(),"Pre-chat form")] >> nth=0
    ${pre_chat_form_msg_txt}    Browser.Get Text    ${pre_chat_form_msg}
    ${pre_chat_form_expected}    Catenate    SEPARATOR=\n 
        ...    Pre-chat form
        ...
        ...    Name:
        ...    ${client_info.first_name} ${client_info.last_name}
        ...
        ...    E-mail:
        ...    ${client_info.email}
        ...
        ...    Preferred Phone Number:
        ...    ${client_info.phone}
        ...
        ...    Account Name:
        ...    FUSEBOX
    Should Be Equal    ${pre_chat_form_msg_txt}    ${pre_chat_form_expected}