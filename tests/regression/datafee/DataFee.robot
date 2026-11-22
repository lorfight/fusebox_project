*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/DataFee/DataFee.resource
Resource    ../../../resources/PageObjects/Keywords/Administration/Users/Users.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Suite Setup    Suite Setup Data Fee Suite
Test Setup    Common.Open New Window    title_arg=Data Fee
Test Teardown    Test Teardown Data Fee Suite
Suite Teardown    Close Browser
Test Tags    test:retry(1)    REG_DF    datafee    Datafee

*** Test Cases ***
Verify All Fields Are Visible In Fusebox Data Fee Program UI
    [Documentation]    VEFUBX4-5    VEFUBX4-16    VEFUBX4-17    VEFUBX4-18    VEFUBX4-19    VEFUBX4-20    VEFUBX4-35    VEFUBX4-36
    [Tags]    report.label.owner: Hai Nguyen
    Verify The All Menu In Administration At Navbar Is Hidden When DataFee View Only Is Selected
    Verify The Interface Displays The Correct Page Title
    Verify All Fields In Upload Data Files Form    ${data_input}[location_list]

Submit File Without Required Field
    [Documentation]    VEFUBX4-37    VEFUBX4-39    VEFUBX4-40
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    ${file_type_list}    Create List    xlsx
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    ${error_list}    Create List    
        ...    Please select a manufacturer
        ...    Please select a clinic location
        ...    Please select at least one file
    FOR    ${error}    IN    @{error_list}
        Run Keyword If    "${error}" != "Please select a manufacturer"    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
        Run Keyword If    "${error}" != "Please select a clinic location"    Select Clinic Location    ${data_input}[location_list][location_first]
        Run Keyword If    "${error}" != "Please select at least one file"    Upload File Into Data Fee Program    ${combine_file_path_list}
        Common.Scroll And Click Element    ${submit_file_btn}
        Wait Until Page Contains    ${error}
        Reload Page
    END

Verify That System Shows A Warning Message When User Uploads A File With Unsupported Extension .pdf
    [Documentation]    VEFUBX4-51
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    pdf
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Verify Warning Message Is Displayed Invalid File Type    ${combine_file_name_list}

Verify That System Shows A Warning Message When User Uploads A File With Unsupported Extension .csv
    [Documentation]    VEFUBX4-52
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    csv
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Verify Warning Message Is Displayed Invalid File Type    ${combine_file_name_list}

Verify That System Shows A Warning Message When User Uploads A File With Unsupported Extension .docx
    [Documentation]    VEFUBX4-53
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    docx
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Verify Warning Message Is Displayed Invalid File Type    ${combine_file_name_list}

Verify That System Shows A Warning When User Uploads A File Without File Extension
    [Documentation]    VEFUBX4-54
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    no_extension
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list}
    Verify Warning Message Is Displayed Invalid File Type    ${combine_file_name_list}

Verify That System Shows Warning When All Selected Files Are Invalid
    [Documentation]    VEFUBX4-57
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    docx    csv    pdf
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    Upload File Into Data Fee Program    ${combine_file_path_list} 
    Verify Warning Message Is Displayed Invalid File Type    ${combine_file_name_list}

Verify System Shows Warning When Uploading Multiple Files Including File(s) Without Extension
    [Documentation]    VEFUBX4-58
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx    xls    no_extension
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

Verify That System Auto Delete File When User Send Multiple File And One File Have Virus
    [Documentation]    VEFUBX4-61
    [Tags]    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    Select Manufacturer    ${datafee_dict}    ${data_input}[manufacturer_value]
    Select Clinic Location    ${data_input}[location_list][location_first]
    ${file_type_list}    Create List    xlsx    xls
    ${combine_file_path_list}    ${combine_file_name_list}    Create Data Fee File List  
        ...    parent_dir=${folder_path}
        ...    file_type_list=${file_type_list}
        ...    file_count=1
        ...    target_size_mb=17
    Set Test Variable    ${combine_file_path_list}
    ${file_path_list_contains_virus_file}    Create List    @{combine_file_path_list}    ${folder_path}/datafee_folder/virus_file.xlsx
    ${virus_file_name}    Create List    virus_file.xlsx
    Upload File Into Data Fee Program    ${file_path_list_contains_virus_file} 
    Click Submit Files for Processing
    Verify Warning Virus Tectected    ${virus_file_name}
    Verify Selected File List Not Show Invalid File    ${virus_file_name}

Verify That System Will Display A Warning When A File With The Same Name Is Selected
    [Documentation]    VEFUBX4-63
    [Tags]    smoke    Data Fee    report.label.owner: Hai Nguyen
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
    Upload File Into Data Fee Program    ${combine_file_path_list} 
    Click Submit Files for Processing
    Verify Upload File Fail    ${combine_file_name_list}

Action With Filter Of Upload Data Files
    [Documentation]    VEFUBX4-21    VEFUBX4-22    VEFUBX4-23    VEFUBX4-24    VEFUBX4-25    VEFUBX4-26    VEFUBX4-27    VEFUBX4-28    VEFUBX4-29    VEFUBX4-30    
                ...    VEFUBX4-31    VEFUBX4-32    VEFUBX4-41    VEFUBX4-42    VEFUBX4-43    VEFUBX4-44    VEFUBX4-45    VEFUBX4-46    VEFUBX4-47    VEFUBX4-48
    [Tags]    smoke    Data Fee    report.label.owner: Hai Nguyen
    ${datafee_dict}    Create Data Fee Dictionary
    ${current_date}    ${start_date}    ${end_date}    Prepare TimeStamp Data    utc=${data_input}[utc]
    ${user_name_txt}    Common.Get User Name
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
    Verify That The File List Is Filtered Correctly when Selecting A Manufacturer Value     manufacturer_value=${datafee_dict.manufacturer}
    Verify That The File List Is Filtered Correctly When Selecting A Location Value 
        ...    location_value=${data_input}[location_list][location_first]
        ...    account_name=${data_input}[account_name_list][account_name_first]
    Verify That The File List Is Filtered Correctly When Selecting A Start Date    startdate_arg=${start_date}
    Verify That The File List Is Filtered Correctly When Selecting A End Date    enddate_arg=${end_date}
    Verify That The File List Is Filtered Correctly When Selecting A Start Date And End Date    
        ...    startdate_arg=${start_date}
        ...    enddate_arg=${end_date}
    Verify That File List Is Filtered Correctly When Combining Manufacturer And Location Filters
        ...    manufacturer_value=${datafee_dict.manufacturer}
        ...    location_value=${data_input}[location_list][location_first]
        ...    account_name=${data_input}[account_name_list][account_name_first]
    Verify That File List Is Filtered Correctly When Applying Manufacturer, Location, Start Date And End Date Together 
        ...    manufacturer_value=${datafee_dict.manufacturer}
        ...    location_value=${data_input}[location_list][location_first]
        ...    account_name=${data_input}[account_name_list][account_name_first]
        ...    startdate_arg=${start_date}
        ...    enddate_arg=${end_date}
    Verify The File Information Is Uploaded 
        ...    file_name_list=${combine_file_name_list}
        ...    manufacturer_value=${datafee_dict.manufacturer}
        ...    location_value=${data_input}[location_list][location_first]
        ...    current_date=${current_date}
        ...    startdate_arg=${start_date}
        ...    enddate_arg=${end_date}
        ...    uploaded_by_txt=${user_name_txt}
        ...    location_name=${data_input}[account_name_list][account_name_first]
    Verify That Clicking Clear Resets All Filter Values And Reloads Default Data
    Verify UI Display The Correct Design For Record Table

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


