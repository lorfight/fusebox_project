*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/LiveChat/LiveChat.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Variables    ../../../resources/PageObjects/TestData/Testdata.py

Suite Setup    Suite Setup Live Chat
Test Setup    Test Setup Live Chat
Test Teardown    Test Teardown Live Chat
# Suite Teardown    Suite Teardown Live Chat
Test Tags    test:retry(1)    AMZ_LIV    livechat    Prime_physician

*** Test Cases ***
Verify that the system show error message when the user has no input data in all fields and click on "Submit" button
    [Documentation]    78-TC47
    [Tags]    report.label.owner: Hai Nguyen
    ChatWidget.Click Chat Widget Icon
    ChatWidget.Click Submit Button
    Wait For Elements State    ${first_name} >> xpath=following::span[text()="This field is required"][1]    visible    2s
    Wait For Elements State    ${last_name} >> xpath=following::span[text()="This field is required"][1]    visible    2s
    Wait For Elements State    ${email} >> xpath=following::span[text()="This field is required"][1]    visible    2s
    Wait For Elements State    ${phone_number} >> xpath=following::span[text()="This field is required"][1]    visible    2s

Verify that every field is displayed required error on the pre-chat form if missing
    [Documentation]    78-TC48    78-TC64    78-TC81    78-TC107
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    email    phone
    ${errors_list}    Create List    
        ...    FirstName
        ...    LastName
        ...    email
        ...    phoneNumber
    ChatWidget.Click Chat Widget Icon
    FOR    ${error}    IN    @{errors_list}
        ChatWidget.Clear All Required Fields
        Run Keyword If    "${error}" != "FirstName"    Input First Name    ${Fake_dict['first_name']}
        Run Keyword If    "${error}" != "LastName"    Input Last Name    ${Fake_dict['last_name']}
        Run Keyword If    "${error}" != "email"    Input Email    ${Fake_dict['email']}
        Run Keyword If    "${error}" != "phoneNumber"    Input Preferred Phone Number    +12312312312
        ChatWidget.Click Submit Button
        Wait For Elements State    ${chat_widget_iframe} >>> input[name="${error}"] >> xpath=following::span[text()="This field is required"][1]    visible    2s
    END

Verify that every field is displayed required error on the pre-chat form if only cointains spaces
    [Documentation]    78-TC49    78-TC65    78-TC82    78-TC108
    [Tags]    report.label.owner: Hai Nguyen
    ${space_characters}    Set Variable    ${SPACE}${SPACE}
    ${Fake_dict}    Generate Fake Data    first_name    last_name    email    phone
    ${errors_list}    Create List    
        ...    FirstName
        ...    LastName
        ...    email
        ...    phoneNumber
    ChatWidget.Click Chat Widget Icon
    FOR    ${error}    IN    @{errors_list}
        ChatWidget.Clear All Required Fields
        ChatWidget.Input Required Fields On The Pre-chat Form    
            ...    first_name_arg=${Fake_dict['first_name']}   
            ...    last_name_arg=${Fake_dict['last_name']}    
            ...    email_arg=${Fake_dict['email']}    
            ...    phone_number_arg=+12345123
        Run Keyword If    "${error}" == "FirstName"    Input First Name    ${space_characters}
        Run Keyword If    "${error}" == "LastName"    Input Last Name    ${space_characters}
        Run Keyword If    "${error}" == "email"    Input Email    ${space_characters}
        Run Keyword If    "${error}" == "phoneNumber"    Input Preferred Phone Number    ${space_characters}
        ChatWidget.Click Submit Button
        IF    "${error}" == "email"
            Wait For Elements State    ${chat_widget_iframe} >>> input[name="${error}"] >> xpath=following::span[text()="This field is required"][1]    visible    2s
        ELSE
            Wait For Elements State    ${chat_widget_iframe} >>> input[name="${error}"] >> xpath=following::span[text()="Value is invalid, it does not match the custom pattern"][1]    visible    2s
        END
        # Wait For Elements State    ${chat_widget_iframe} >>> input[name="${error}"] >> xpath=following::span[text()="This field is required"][1]    visible    2s
    END

Verify First Name Field Accepts Various Input Formats
    [Documentation]    78-TC50    78-TC51    78-TC52    78-TC53    78-TC54    78-TC55    78-TC56    
                ...    78-TC57    78-TC59    78-TC60    78-TC61    78-TC62    78-TC63
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    full_name    first_name    last_name    email    phone    num_rand
    ${alphabetic_name}    Set Variable    ${Fake_dict['first_name']}
    ${alphabetic_name_with_spaces}    Set Variable    ${Fake_dict['full_name']}
    ${hyphenated_name}    Set Variable    ${Fake_dict['first_name']}-${Fake_dict['first_name']}
    ${alphabetic_name_with_apostrophe}    Set Variable    ${Fake_dict['first_name']}'${Fake_dict['first_name']}
    ${alphabetic_name_with_numbers}    Set Variable    ${Fake_dict['first_name']}${Fake_dict['num_rand']}
    ${alphabetic_name_with_symbols}    Set Variable    @${Fake_dict['first_name']}!
    ${single_character_name}    Set Variable    A
    ${256_characters}    Generate Random String    256    [LETTERS]
    ${50_characters}    Generate Random String    50    [LETTERS]
    ${51_characters}    Generate Random String    51    [LETTERS]
    # ${space_character}    Set Variable    \ \
    ${alphabetic_name_with_unicode}    Set Variable    José
    ${emoji}    Evaluate    chr(__import__('random').randint(0x1F600,0x1F64F))
    ${script_injection}    Set Variable    <script>alert(1)</script>
    ${html_tags}    Set Variable    <b>John</b>
    ${sql_injection_pattern}    Set Variable    OR '1'='1'

    ${value_input_list}    Create List
        ...    ${alphabetic_name}
        # ...    ${alphabetic_name_with_spaces}
        ...    ${hyphenated_name}
        ...    ${alphabetic_name_with_apostrophe}
        # ...    ${alphabetic_name_with_numbers}
        # ...    ${alphabetic_name_with_symbols}
        ...    ${single_character_name}
        # ...    ${256_characters}
        ...    ${50_characters}
        # ...    ${51_characters}
        # ...    ${alphabetic_name_with_unicode}
        # ...    ${emoji}${Fake_dict['first_name']}    
        # ...    ${script_injection}
        # ...    ${html_tags}
        # ...    ${sql_injection_pattern}

    FOR    ${value}    IN    @{value_input_list}
        ChatWidget.Click Chat Widget Icon
        ChatWidget.Input Required Fields On The Pre-chat Form    
            ...    first_name_arg=${value}    
            ...    last_name_arg=${Fake_dict['last_name']}    
            ...    email_arg=${Fake_dict['email']}    
            ...    phone_number_arg=+12341234123
        ChatWidget.Click Submit Button
        ChatWidget.Verify Amazon Connect Chat Is Visible    first_name_arg=${value}
        ChatWidget.Click End Chat Button
        ChatWidget.Click Close Chat Button
        Reload
    END

Verify Last Name Field Accepts Various Input Formats
    [Documentation]    78-TC66    78-TC67    78-TC68    78-TC69    78-TC70    78-TC71    
                ...    78-TC72    78-TC73    78-TC76    78-TC77    78-TC78    78-TC79    78-TC80
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    full_name    first_name    last_name    email    phone    num_rand
    ${alphabetic_name}    Set Variable    ${Fake_dict['last_name']}
    ${alphabetic_name_with_spaces}    Set Variable    ${Fake_dict['full_name']}
    ${hyphenated_name}    Set Variable    ${Fake_dict['last_name']}-${Fake_dict['last_name']}
    ${alphabetic_name_with_apostrophe}    Set Variable    ${Fake_dict['last_name']}'${Fake_dict['last_name']}
    ${alphabetic_name_with_numbers}    Set Variable    ${Fake_dict['last_name']}${Fake_dict['num_rand']}
    ${alphabetic_name_with_symbols}    Set Variable    @${Fake_dict['last_name']}!
    ${single_character_name}    Set Variable    A
    # ${256_characters}    Generate Random String    256    [LETTERS]
    ${50_characters}    Generate Random String    50    [LETTERS]
    # ${51_characters}    Generate Random String    51    [LETTERS]
    # ${space_character}    Set Variable    \ \
    ${alphabetic_name_with_unicode}    Set Variable    José
    ${emoji}    Evaluate    chr(__import__('random').randint(0x1F600,0x1F64F))
    ${script_injection}    Set Variable    <script>alert(1)</script>
    ${html_tags}    Set Variable    <b>John</b>
    ${sql_injection_pattern}    Set Variable    OR '1'='1'

    ${value_input_list}    Create List
        ...    ${alphabetic_name}
        # ...    ${alphabetic_name_with_spaces}
        ...    ${hyphenated_name}
        ...    ${alphabetic_name_with_apostrophe}
        # ...    ${alphabetic_name_with_numbers}
        # ...    ${alphabetic_name_with_symbols}
        ...    ${single_character_name}
        # ...    ${256_characters}
        ...    ${50_characters}
        # ...    ${51_characters}
        # ...    ${space_character}
        # ...    ${alphabetic_name_with_unicode}
        # ...    ${emoji} ${Fake_dict['last_name']}    
        # ...    ${script_injection}
        # ...    ${html_tags}
        # ...    ${sql_injection_pattern}

    FOR    ${value}    IN    @{value_input_list}
        ChatWidget.Click Chat Widget Icon
        ChatWidget.Input Required Fields On The Pre-chat Form    
            ...    first_name_arg=${Fake_dict['first_name']}    
            ...    last_name_arg=${value}  
            ...    email_arg=${Fake_dict['email']}    
            ...    phone_number_arg=+12312312312
        ChatWidget.Click Submit Button
        ChatWidget.Verify Amazon Connect Chat Is Visible    first_name_arg=${Fake_dict['first_name']}
        ChatWidget.Click End Chat Button
        ChatWidget.Click Close Chat Button
        Reload
    END

Verify Email Field Accepts Various Input Formats
    [Documentation]    78-TC83    78-TC84    78-TC85    78-TC86    78-TC87    78-TC88
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    phone
    
    ${email_with_valid}    Set Variable    user@gmail.com
    ${email_with_spaces}    Set Variable    user@gmail.com${SPACE}${SPACE}
    ${email_with_dot}    Set Variable    user.name@gmail.com
    ${email_with_hyphen}    Set Variable    user-name@gmail.com
    ${email_with_plus}    Set Variable    user+test@gmail.com
    ${email_with_undercore}    Set Variable    user_name@gmail.com

    ${value_input_list}    Create List
        ...    ${email_with_valid}
        ...    ${email_with_spaces}
        ...    ${email_with_dot}
        ...    ${email_with_hyphen}
        ...    ${email_with_plus}
        ...    ${email_with_undercore}

    FOR    ${value}    IN    @{value_input_list}
        ChatWidget.Click Chat Widget Icon
        ChatWidget.Input Required Fields On The Pre-chat Form    
            ...    first_name_arg=${Fake_dict['first_name']}    
            ...    last_name_arg=${Fake_dict['last_name']}  
            ...    email_arg=${value}  
            ...    phone_number_arg=+12312312312
        ChatWidget.Click Submit Button
        ChatWidget.Verify Amazon Connect Chat Is Visible    first_name_arg=${Fake_dict['first_name']}
        ChatWidget.Click End Chat Button
        ChatWidget.Click Close Chat Button
        Reload
    END

Verify Email Field With Invalid Formats
    [Documentation]    78-TC89    78-TC90    78-TC91    78-TC92    78-TC93    78-TC95    78-TC98    78-TC102    78-TC103    78-TC104
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    phone
    
    ${email_without_@}    Set Variable    usergmail.com
    ${email_without_domain}    Set Variable    user@
    ${email_without_username}    Set Variable    @gmail.com
    ${email_with_multi_@}    Set Variable    username@@gmail.com
    ${email_without_domain_dot}    Set Variable    usertest@gmailcom
    ${email_with_consecutive_dots}    Set Variable    user..name@gmail.com
    ${email_with_spaces}    Set Variable    user name@gmail.com
    ${email_with_symbols}    Set Variable    user#name@gmail.com
    ${email_with_dot_at_start}    Set Variable    .username@gmail.com
    ${email_with_dot_at_end}    Set Variable    username.@gmail.com
    ${email_with_scripts}    Set Variable    <script>alert(1)</script>@gmail.com
    ${email_with_sql}    Set Variable    test' OR '1'='1@email.com
    ${email_with_html}    Set Variable    <b>John</b>@email.com

    ${value_input_list}    Create List
        ...    ${email_without_@}
        ...    ${email_without_domain}
        ...    ${email_without_username}
        ...    ${email_with_multi_@}
        ...    ${email_without_domain_dot}
        # ...    ${email_with_consecutive_dots}
        ...    ${email_with_spaces}
        ...    ${email_with_symbols}
        # ...    ${email_with_dot_at_start}
        # ...    ${email_with_dot_at_end}
        ...    ${email_with_scripts}
        ...    ${email_with_sql}
        ...    ${email_with_html}

    ChatWidget.Click Chat Widget Icon
    FOR    ${value}    IN    @{value_input_list}
        Clear Text    ${email}
        Input Email    ${value}
        Wait For Elements State    ${email} >> xpath=following::span[text()="Enter a valid email"][1]
    END

Verify Phone Field Accepts Various Input Formats
    [Documentation]    78-TC109    78-TC113    78-TC123
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    email    
    ${15_numbers}    Generate Random String    15    [NUMBERS]
    ${phone_with_plus_at_start}    Set Variable    +${15_numbers}
    # ${phone_with_spaces}    Set Variable    ${SPACE}${SPACE}+${15_numbers}${SPACE}${SPACE}
    # ${phone_with_15_digits}    Set Variable    +${15_numbers}
    
    ${value_input_list}    Create List
        ...    ${phone_with_plus_at_start}
        # ...    ${phone_with_spaces}
        # ...    ${phone_with_15_digits}

    FOR    ${value}    IN    @{value_input_list}
        ChatWidget.Click Chat Widget Icon
        ChatWidget.Input Required Fields On The Pre-chat Form    
            ...    first_name_arg=${Fake_dict['first_name']}    
            ...    last_name_arg=${Fake_dict['last_name']}  
            ...    email_arg=${Fake_dict['email']}  
            ...    phone_number_arg=${value} 
        ChatWidget.Click Submit Button
        ChatWidget.Verify Amazon Connect Chat Is Visible    first_name_arg=${Fake_dict['first_name']}
        ChatWidget.Click End Chat Button
        ChatWidget.Click Close Chat Button
        Reload
    END

Verify Phone Field With Invalid Formats
    [Documentation]    78-TC111    78-TC112    78-TC114    78-TC115    78-TC116    78-TC117    78-TC118    78-TC119    
    ...    78-TC120    78-TC121    78-TC124    78-TC125    78-TC126    78-TC127    78-TC128    78-TC129    78-TC130
    ...    
    [Tags]    report.label.owner: Hai Nguyen
    ${Fake_dict}    Generate Fake Data    first_name    last_name    email 
    ${emoji}    Evaluate    chr(__import__('random').randint(0x1F600,0x1F64F))
    ${phone_without_plus_at_start}    Set Variable    1234567890
    ${phone_with_spaces}    Set Variable    +1${SPACE}234567890
    ${phone_contains_letters}    Set Variable    1A23B45C67D890
    ${phone_with_letters_and_special_characters}    Set Variable    ABC!@#
    ${phone_with_text}    Set Variable    Call me at 1234567890
    ${phone_with_extension_included}    Set Variable    1234567890 ext 123
    ${phone_with_multi_number}    Set Variable    1234567890 / 1234567890
    ${phone_with_emoji}    Set Variable    ${emoji}1234567890
    ${phone_with_hyphens}    Set Variable    +1-234-567-890
    ${phone_with_parenttheses}    Set Variable    +(123)4567890
    ${phone_with_minimum_lenghet}    Set Variable    +1
    ${phone_with_multi_plus}    Set Variable    ++1234567890
    ${phone_with_plus_in_middle}    Set Variable    1234+567890
    ${phone_with_lose_focus}    Set Variable    +1234 567890
    ${phone_with_special_characters}    Set Variable    +1234!5@67890
    ${phone_with_only_plus}    Set Variable    +
    ${phone_with_dot}    Set Variable    +1234567.890
    ${phone_with_script}    Set Variable    <script>alert(1)</script>
    ${phone_with_sql}    Set Variable    OR '1'='1

    ${value_input_list}    Create List
        ...    ${phone_without_plus_at_start}
        ...    ${phone_with_spaces}
        ...    ${phone_contains_letters}
        ...    ${phone_with_letters_and_special_characters}
        ...    ${phone_with_text}
        ...    ${phone_with_extension_included}
        ...    ${phone_with_multi_number}
        ...    ${phone_with_emoji}
        ...    ${phone_with_hyphens}
        ...    ${phone_with_parenttheses}
        ...    ${phone_with_minimum_lenghet}
        ...    ${phone_with_multi_plus}
        ...    ${phone_with_plus_in_middle}
        ...    ${phone_with_lose_focus}
        ...    ${phone_with_special_characters}
        ...    ${phone_with_only_plus}
        ...    ${phone_with_dot}
        ...    ${phone_with_script}
        ...    ${phone_with_sql}

    ChatWidget.Click Chat Widget Icon
    FOR    ${value}    IN    @{value_input_list}
        Clear Text    ${phone_number}
        Input Preferred Phone Number    ${value}
        Wait For Elements State    ${phone_number} >> xpath=following::span[text()="Value is invalid, it does not match the custom pattern"][1]
        Wait For Elements State    ${phone_number} >> xpath=following::div[text()="Format: +18605551234"][1]
        # Wait For Elements State    ${phone_number} >> xpath=following::span[text()="Enter a valid telephone number"][1]
    END

Verify that the agent does not receive chats when set to "Offline"
    [Documentation]    78-TC141
    [Tags]    report.label.owner: Hai Nguyen
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Select Current Agent Status    Offline
    Switch Page    ${fusebox_page}
    ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
    Switch Page    ${amazon_page}
    ${chat_container}    Set Variable    ${number_pad_iframe} >>> xpath=//p[text()="Chat started with ${chatwidget_dict.first_name}"]
    ${check_visible}    Run Keyword And Return Status    Wait For Elements State    ${chat_container}    visible    
    Should Be True    "${check_visible}" == "${False}"

Verify Agent And Customer Can Exchange Messages In Real Time 
    [Documentation]    78-TC140    78-TC143    78-TC145
    [Tags]    report.label.owner: Hai Nguyen
    ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Click Accept Chat Button
    Switch Page    ${fusebox_page}
    ${customer_message}    ${customer_message_timestamp}    ChatWidget.Send Message
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Verify Received Message Data    ${customer_message}    ${customer_message_timestamp}
    ${agent_message}    ${agent_message_timestamp}    AmazonConnectAgent.Send Message
    Switch Page    ${fusebox_page}
    ChatWidget.Verify Received Message Data    ${agent_message}    ${agent_message_timestamp}

Verify that the agent can handle a maximum of 4 concurrent chats
    [Documentation]    78-TC148    78-TC149    78-TC150
    [Tags]    report.label.owner: Hai Nguyen
    FOR    ${chat_counts}    IN RANGE    1    6
        New Page   ${SiteUrl}
        ${main_page}    Get Page Ids
        Set Test Variable    ${test_page}    ${main_page}[2]
        ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
        Switch Page    ${amazon_page}
        IF    "${chat_counts}" <= "4"
            AmazonConnectAgent.Click Accept Chat Button
            ${customer_list}    Browser.Get Element Count    ${task_view_iframe} >>> div[data-testid="task-list-row-popover-container"]
            Should Be Equal As Strings    ${customer_list}    ${chat_counts} 
        ELSE IF    "${chat_counts}" == "5"
            ${chat_container}    Set Variable    ${number_pad_iframe} >>> xpath=//p[text()="Chat started with ${chatwidget_dict.first_name}"]
            ${check_visible}    Run Keyword And Return Status    Wait For Elements State    ${chat_container}    visible    
            Should Be True    "${check_visible}" == "${False}"
            Click    ${task_view_iframe} >>> div[data-testid="task-list-row-popover-container"] >> nth=0
            AmazonConnectAgent.Click End Chat Button
            AmazonConnectAgent.Click Close Contact Button
            AmazonConnectAgent.Click Accept Chat Button
        END
        Close Page    ${main_page}[2]
    END

Verify that the customer is informed when the agent logs out during active chat
    [Documentation]    78-TC153
    [Tags]    report.label.owner: Hai Nguyen
    ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Click Accept Chat Button
    Click    button[data-testid="user-settings-dropdown"]
    Click    button[data-testid="sign-out"]
    Wait For Load State    load
    Switch Page    ${fusebox_page}
    Verify Agent Has Left The Chat

Verify that the agent is notified when the customer closes the browser tab during an active chat
    [Documentation]    78-TC154
    [Tags]    report.label.owner: Hai Nguyen
    ${chatwidget_dict}    ChatWidget.Start Chat From Customer Browser
    Switch Page    ${amazon_page}
    AmazonConnectAgent.Click Accept Chat Button
    Switch Page    ${fusebox_page}
    


*** Keywords ***
Suite Setup Live Chat
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}

Test Setup Live Chat
    LiveChat.Open Browser
    LiveChat.Open Amazon Connect    ${data_input}[amazon_connect_url]
    AmazonConnectAgent.Select Current Agent Status    Available
    AmazonConnectAgent.End All Chats In Task List
    LiveChat.Open CCPA    ${data_input}[ccpa_js]      
    LiveChat.Login To Fusebox    username_arg=${Username}    password_arg=${Password}
    ${main_page}    Get Page Ids
    Set Test Variable    ${amazon_page}    ${main_page}[0]
    Set Test Variable    ${fusebox_page}    ${main_page}[1]

Test Teardown Live Chat
    LiveChat.Open Amazon Connect    ${data_input}[amazon_connect_url]
    AmazonConnectAgent.Select Current Agent Status    Offline
    AmazonConnectAgent.End All Chats In Task List
    Browser.Close Browser

Suite Teardown Live Chat
    LiveChat.Open Amazon Connect    ${data_input}[amazon_connect_url]
    AmazonConnectAgent.End All Chats In Task List

