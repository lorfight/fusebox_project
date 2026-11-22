*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/DataFee/DataFee.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Data Fee Suite
Test Setup    Common.Open New Window    title_arg=Data Fee
Test Teardown    Test Teardown Data Fee Suite
Suite Teardown    Close Browser
Test Tags    test:retry(1)    SMK_DF    datafee    Datafee

*** Test Cases ***
Verify That System Allows Uploading File With .xlsx Extension Successfully
    [Documentation]    VEFUBX4-49
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Click Submit Files for Processing
    Verify Upload File Successfully

Verify That System Allows Uploading File With .xls Extension Successfully
    [Documentation]    VEFUBX4-50
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xls
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Click Submit Files for Processing
    Verify Upload File Successfully

Verify That System Allows Uploading Multiple Files At The Same Time When All Selected Files Have Valid Extensions .xlsx / .xls
    [Documentation]    VEFUBX4-55
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx    xls
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=2
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list} 
    Click Submit Files for Processing
    Verify Upload File Successfully

Verify System Behavior When Uploading Multiple Files Where Some Files Are Valid (.xlsx / .xls) And Some Are Invalid
    [Documentation]    VEFUBX4-56
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx    xls    docx    csv    pdf    no_extension
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list} 
    ${invalid_file_list}    Remove File In Data Fee List    ${combine_file_name_list}
    Verify Warning Message Is Displayed Invalid File Type    ${invalid_file_list}
    Click Submit Files for Processing
    Verify Upload File Successfully

Verify That System Shows A Warning Message When User Uploads A File Have Virus
    [Documentation]    VEFUBX4-60
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_path_list}    Create List    ${folder_path}/datafee_folder/virus_file.xlsx
    Upload File Into Data Fee Program    ${file_path_list}
    Click Submit Files for Processing
    ${virus_file_name}    Create List    virus_file.xlsx
    Verify Warning Virus Tectected    ${virus_file_name}

Verify That System Accept File Contains A Large Number Of MB
    [Documentation]    VEFUBX4-62
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=100
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Click Submit Files for Processing
    Verify Upload File Successfully

Verify User Can Download File By Clicking File Name And Downloaded File Name Matches UI
    [Documentation]    VEFUBX4-68    VEFUBX4-69    VEFUBX4-70    VEFUBX4-71
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    ${current_date}    ${start_date}    ${end_date}    Prepare TimeStamp Data    utc=${data_input}[utc]
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list} 
    Click Submit Files for Processing
    Verify Upload File Successfully
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=${datafee_dict.manufacturer}
        ...    location_value=${data_input}[location_list][location_first]
        ...    startdate_arg=${start_date}
        ...    enddate_arg=${end_date}
    Verify That The User Can Download A File By Clicking On The File Name    ${combine_file_name_list}
    ${folder_path}    Get Environment Variable    EXPORT_PATH
    Verify That User Can Open The Downloaded File Name Matches The File Name Displayed On The UI    ${combine_file_name_list}    ${folder_path}
    Remove Downloaded Files    ${folder_path}

*** Keywords ***
Suite Setup Data Fee Suite
    ${data_input}    Get Data
    Set Suite Variable    ${data_input}
    # Config Data Fee Only Mode View    status=${True}
    Login Fusebox Via DataFee    title_name=Data Fee    newsletter_status=not visible    # VEFUBX4-2    VEFUBX4-4
    ${original_window}    Get Window Handles
    Set Suite Variable    ${original_window}
    Set Suite Variable    ${folder_path}    ${EXECDIR}/resources/PageObjects/Keywords/DataFee

Login Fusebox Via DataFee
    [Arguments]    ${title_name}    ${newsletter_status}
    LoginKeywords.Open Browser To Login Page
    Input Text    ${LoginUsernameInputBox}    ${Username}
    Input Text    ${LoginPasswordInputBox}    ${Password}
    Click Button    ${LoginButton}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be   ${title_name}
    IF    "${newsletter_status}" == "visible"
        Wait Until Element Is Visible    //*[@id="NewsletterModalPopup"]    10s
        Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id="NewsletterModalPopup"]//button[contains(@class,"closeBtn")]
    END

Config Data Fee Only Mode View
    [Arguments]    ${status}
    LoginKeywords.Login To Fusebox    ${data_input}[username_prime]    ${data_input}[password_prime]
    Users.Go To User List
    Users.Select Account In Users Page    ${data_input}[location_list][location_first] (${data_input}[account_id][account_id_first])
    Users.Find User    ${Username}
    Users.Go To Edit User Page    ${Username}
    Users.Check Data Fee Only Mode View Checkbox Status    ${status}
    Wait Until Keyword Succeeds    30s    1s    Click Element    link: Log Out

Test Teardown Data Fee Suite
    ${is_existed}    Run Keyword And Return Status    Variable Should Exist    @{combine_file_path_list}
    IF    "${is_existed}" == "${True}"
        Remove Created Files    ${combine_file_path_list}
    END
    Common.Return Previous Window    window_arg=${original_window}[0]
