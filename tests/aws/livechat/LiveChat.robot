*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LiveChat/LiveChat.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Variables    ../../../resources/PageObjects/TestData/Testdata.py
Suite Setup    Suite Setup Live Chat
Suite Teardown    Suite Teardown Live Chat
Test Tags    test:retry(1)    SMK_LIV    livechat    Prime_physician

*** Test Cases ***
Verify that the client and agent can interact with each other in real-time 
    [Documentation]    78-TC139    78-TC134    78-TC137    78-TC139    78-TC140    78-TC143    78-TC145
    [Tags]    report.label.owner: Hai Nguyen
    ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Click Accept Chat Button
    AmazonConnectAgent.Verify Client Information In Pre Chat Form Contact    ${chatwidget_dict}
    Switch Page    ${fusebox_page}
    ${customer_message}    ${customer_message_timestamp}    ChatWidget.Send Message
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Verify Received Message Data    ${customer_message}    ${customer_message_timestamp}
    ${agent_message}    ${agent_message_timestamp}    AmazonConnectAgent.Send Message
    Switch Page    ${fusebox_page}
    ChatWidget.Verify Received Message Data    ${agent_message}    ${agent_message_timestamp}
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Click End Chat Button
    AmazonConnectAgent.Click Close Contact Button
    Switch Page    ${fusebox_page}
    ChatWidget.Verify Agent Has Left The Chat
    ChatWidget.Click Close Chat Button

*** Keywords ***
Suite Setup Live Chat
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    LiveChat.Open Browser
    LiveChat.Open Amazon Connect    ${data_input}[amazon_connect_url]
    AmazonConnectAgent.Select Current Agent Status    Available
    AmazonConnectAgent.End All Chats In Task List
    LiveChat.Open CCPA    ${data_input}[ccpa_js]      
    LiveChat.Login To Fusebox    username_arg=${Username}    password_arg=${Password}
    ${main_page}    Get Page Ids
    Set Suite Variable    ${amazon_page}    ${main_page}[0]
    Set Suite Variable    ${fusebox_page}    ${main_page}[1]

Suite Teardown Live Chat
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Select Current Agent Status    Offline
    AmazonConnectAgent.End All Chats In Task List
    Browser.Close Browser
