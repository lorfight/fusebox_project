*** Settings ***
Resource    ../Common/Common.resource

*** Variables ***
${chat_widget_iframe}    iframe#amazon-connect-chat-widget-iframe
${chat_widget_icon}    //button[@id="amazon-connect-open-widget-button"]
${pre_chat_form}    ${chat_widget_iframe} >>> div[class="stargate-panel loaded"]
${first_name}    ${chat_widget_iframe} >>> input[name="FirstName"]
${last_name}    ${chat_widget_iframe} >>> input[name="LastName"]
${email}    ${chat_widget_iframe} >>> input[name="email"]
${phone_number}    ${chat_widget_iframe} >>> input[name="phoneNumber"]
${submit_btn}    ${chat_widget_iframe} >>> button[type="submit"]
${amazone_connect_chat_form}    ${chat_widget_iframe} >>> div[data-testid="amazon-connect-chat-wrapper"]
${end_chat_btn}    ${chat_widget_iframe} >>> button[aria-label="End chat"]
${close_chat_btn}    ${chat_widget_iframe} >>> button[aria-label="Close chat"]

*** Keywords ***
Create Chat Widget Dictionary
    &{chatwidget_dict}    Create Dictionary
    RETURN    ${chatwidget_dict}

Click Chat Widget Icon
    Click    ${chat_widget_icon}
    Wait For Elements State    ${pre_chat_form}    visible

Input First Name
    [Arguments]    ${first_name_arg}
    Clear Text    ${first_name}
    Fill Text    ${first_name}    ${first_name_arg}

Input Last Name
    [Arguments]    ${last_name_arg}
    Clear Text    ${last_name}
    Fill Text    ${last_name}    ${last_name_arg}

Input Email
    [Arguments]    ${email_arg}
    Clear Text    ${email}
    Fill Text    ${email}    ${email_arg}

Input Preferred Phone Number
    [Arguments]    ${phone_number_arg}
    Clear Text    ${phone_number}
    Fill Text    ${phone_number}    ${phone_number_arg}

Click Submit Button
    Click    ${submit_btn}

Verify Amazon Connect Chat Is Visible
    [Arguments]    ${first_name_arg}
    Wait For Elements State    ${amazone_connect_chat_form}    visible
    Wait For Elements State    ${chat_widget_iframe} >>> xpath=//li[text()="${first_name_arg} has joined the chat"]    visible

Click End Chat Button
    Click    ${end_chat_btn}

Click Close Chat Button
    Click    ${close_chat_btn}
    Wait For Elements State    ${pre_chat_form}    hidden

Input Required Fields On The Pre-chat Form
    [Arguments]    ${first_name_arg}    ${last_name_arg}    ${email_arg}    ${phone_number_arg}
    Input First Name    ${first_name_arg}
    Input Last Name    ${last_name_arg}
    Input Email    ${email_arg}
    Input Preferred Phone Number    ${phone_number_arg}

Clear All Required Fields
    Clear Text    ${first_name}
    Clear Text    ${last_name}
    Clear Text    ${email}
    Clear Text    ${phone_number}

Start Chat From Customer Browser
    ${Fake_dict}    Generate Fake Data    first_name    last_name    email
    ${chatwidget_dict}    Create Chat Widget Dictionary
    Click Chat Widget Icon
    ChatWidget.Input Required Fields On The Pre-chat Form    
        ...    first_name_arg=${Fake_dict['first_name']}    
        ...    last_name_arg=${Fake_dict['last_name']}    
        ...    email_arg=${Fake_dict['email']}    
        ...    phone_number_arg=+12341234123
    Click Submit Button
    Verify Amazon Connect Chat Is Visible    first_name_arg=${Fake_dict['first_name']} 
    Set To Dictionary    ${chatwidget_dict}
        ...    first_name=${Fake_dict['first_name']}  
        ...    last_name=${Fake_dict['last_name']}  
        ...    email=${Fake_dict['email']}  
        ...    phone=+12341234123 
    RETURN    ${chatwidget_dict}

Input Message
    [Arguments]    ${msg_arg}
    ${customer_chat_input}    Set Variable    ${chat_widget_iframe} >>> textarea[data-testid="customer-chat-text-input"]
    Wait For Elements State    ${customer_chat_input}    visible
    Fill Text    ${customer_chat_input}    ${msg_arg}

Click Send Message Button
    Click    ${chat_widget_iframe} >>> div[id="chat-send-message-button"] >> nth=0

Get Message Realtime
    ${customer_timestamp_text}    Set Variable    ${chat_widget_iframe} >>> div[data-testid="message-timestamp"] >> nth=-1
    Wait For Elements State    ${customer_timestamp_text}    visible
    ${customer_message_timestamp}    Browser.Get Text    ${customer_timestamp_text}
    RETURN    ${customer_message_timestamp}
    
Send Message
    ${Fake_dict}    Generate Fake Data    sentence
    ${customer_message}    Set Variable    ${Fake_dict['sentence']} 
    Input Message     ${customer_message}
    Click Send Message Button
    ${customer_message_timestamp}    Get Message Realtime
    RETURN    ${customer_message}    ${customer_message_timestamp}

Verify Received Message Data
    [Arguments]    ${agent_message}    ${agent_message_timestamp}
    ${received_message}    Browser.Get Text    ${chat_widget_iframe} >>> div[direction="Incoming"] >> nth=-1
    ${received_timestamp}    Browser.Get Text    ${chat_widget_iframe} >>> div[data-testid="message-timestamp"] >> nth=-1
    Should Be Equal    ${received_message}    ${agent_message}
    ${agent_message_timestamp}    Convert Date    ${agent_message_timestamp}    result_format=%I:%M %p    date_format=%H:%M
    ${agent_message_timestamp}    Handle Datetime Format    fmt={h}:{mi} {ampm}    dt=${agent_message_timestamp}
    Should Contain    ${received_timestamp}    ${agent_message_timestamp}

Verify Agent Has Left The Chat
    ${inform_leave_chat}    Set Variable    ${chat_widget_iframe} >>> xpath=//li[contains(text(),"has left the chat")]
    ${inform_end_chat}    Set Variable    ${chat_widget_iframe} >>> xpath=//li[text()="Chat has ended!"]
    Wait For Elements State    ${inform_leave_chat}    visible
    Wait For Elements State    ${inform_end_chat}    visible
