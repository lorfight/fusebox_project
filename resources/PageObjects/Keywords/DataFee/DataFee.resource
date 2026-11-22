*** Settings ***
Resource    ../Layers/Common/Common.resource
Library    ../Layers/Fakedata/FakeData.py
Library    Common/Common.py
Library    OperatingSystem
Library    XML

*** Variables ***
${manufacturer_select}    //select[@id="ManufacturerId"]
${clinic_location_select}    //select[@id="LocationId"]
${upload_icon}    //div[@class="upload-file-form"]/i[@class="fa fa-upload"]
${browse_files_btn}    //button[text()='Browse Files']
${submit_file_btn}    //button[@id="btnSubmitFiles"]
${datafee_search_btn}    //button[@id="dataUploadSearch"]
${datafee_clear_btn}    //button[@id="dataUploadClear"]

*** Keywords ***
Create Data Fee Dictionary
    &{datafee_dict}    Create Dictionary
    RETURN    ${datafee_dict}

Verify The All Menu In Administration At Navbar Is Hidden When DataFee View Only Is Selected
    Wait Until Element Is Visible    (//a[normalize-space(.)='Administration'])[1]    30s
    Wait Until Keyword Succeeds    30s    1s    Click Element    (//a[normalize-space(.)='Administration'])[1]
    ${dropdown_list}    Get WebElements    (//a[normalize-space(.)='Administration'])[1]//following-sibling::ul/li/a    
    ${narbar_list}    Create List
    FOR    ${nar_bar}    IN    @{dropdown_list}
        ${nar_bar_txt}    Get Text    ${nar_bar}
        Append To List    ${narbar_list}    ${nar_bar_txt}
    END
    ${expected_narbar_list}    Create List    My Login    Change Password    My Account
    Lists Should Be Equal    ${narbar_list}    ${expected_narbar_list}

Verify The Interface Displays The Correct Page Title
    SeleniumLibrary.Element Text Should Be    //div[@class="upload-header"]/h3    Fusebox Data Fee Program - Data Upload
    SeleniumLibrary.Element Text Should Be    //div[@class="upload-header"]/p    Upload patient and dispense data to pharmaceutical manufacturers

Verify All Fields In Upload Data Files Form
    [Arguments]    ${expected_location_list}
    Verify UI Of "Manufacturer" Dropdown
    Verify UI Of "Clinic Location" Dropdown    ${expected_location_list}
    Verify UI Of "File" Upload Section
    Verify UI Of "Submit File For Processing" Button

Verify UI Of "Manufacturer" Dropdown
    ${manufacturer_placeholder}    SeleniumLibrary.Get Element Attribute    //button[@data-id="ManufacturerId"]    title
    Should Be Equal    ${manufacturer_placeholder}    -- Select a Manufacturer --

Verify UI Of "Clinic Location" Dropdown
    [Arguments]    ${expected_location_list}
    ${manufacturer_placeholder}    SeleniumLibrary.Get Element Attribute    //button[@data-id="LocationId"]    title
    Should Be Equal    ${manufacturer_placeholder}    -- Select a Location --
    ${clinic_location_list}    Get List Items    ${clinic_location_select}
    ${expected_location_list}    Get Dictionary Values    ${expected_location_list}
    Lists Should Be Equal    ${clinic_location_list}[1:]    ${expected_location_list}

Verify UI Of "File" Upload Section
    Wait Until Element Is Visible    ${upload_icon}
    SeleniumLibrary.Element Text Should Be    //div[@class="upload-file-form"]/p[1]    Drag and drop files here, or click to browse
    SeleniumLibrary.Element Text Should Be    //div[@class="upload-file-form"]/p[2]    Excel files only (.xlsx, .xls)
    Wait Until Element Is Visible    ${browse_files_btn}
    
Verify UI Of "Submit File For Processing" Button
    Wait Until Element Is Visible    ${submit_file_btn}

Upload File Into Data Fee Program
    [Arguments]    ${upload_files}
    ${upload_files}    Catenate    SEPARATOR=\n    @{upload_files}
    Choose File    //input[@id="fileInput"]    ${upload_files}

Remove Created Files
    [Arguments]    ${file_path_list}
    FOR    ${file_path}    IN    @{file_path_list}
        Remove File    ${file_path}
    END

Select Manufacturer
    [Arguments]    ${dict_arg}    ${manufacturer_value}=random
    IF    "${manufacturer_value}" == "random"
        Common.Choose Random Value From Select List    xpath_arg=${manufacturer_select}    var_name=manufacturer    dic=${dict_arg}
    ELSE
        Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${manufacturer_select}    ${manufacturer_value}
        Set To Dictionary    ${dict_arg}    manufacturer=${manufacturer_value}
    END

Select Clinic Location
    [Arguments]    ${location}
    Wait Until Element Is Enabled    ${clinic_location_select}
    Select From List By Label    ${clinic_location_select}    ${location}

Click Submit Files for Processing
    Common.Scroll And Click Element    ${submit_file_btn}
    Common.Scroll And Click Element    //button[text()='OK, Submit']
    Common.Element Is Not Visible    //span[@class="fas fa-spinner fa-spin fa-3x"]    300s

Click Go Back Button
    Common.Scroll And Click Element    //button[text()="Go Back"]

Click Close Virus Warning Modal Button
    Common.Scroll And Click Element    //div[@class="virus-dectected"]//button[text()="Close"]

Verify Upload File Successfully
    SeleniumLibrary.Element Text Should Be    //div[@class="upload-success"]/h4/b    Upload Successful
    Common.Scroll And Click Element    //div[@class="upload-success"]/button[text()='OK']

Verify Warning Virus Tectected
    [Arguments]    ${file_list}
    ${file_lines}    Catenate    SEPARATOR=\n    @{file_list}
    ${virus_message}    Catenate    SEPARATOR=\n
        ...    Virus detected
        ...    Security Threat Detected
        ...    The file upload process has been stopped due to a virus or malware detection.
        ...    Infected Files:
        ...    ${file_lines}
        ...    Action Required:
        ...    Remove the infected file in your system
        ...    Run a full antivirus scan on your computer
        ...    Do not attempt to upload this file again
        ...    Contact IT support if you need assistance
        ...    Close
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    //div[@class="virus-dectected"]    ${virus_message}
    Click Close Virus Warning Modal Button

Verify Upload File Fail
    [Arguments]    ${file_list}
    ${file_total}    Get Length    ${file_list}
    @{formatted_list}    Create List
    FOR    ${file}    IN    @{file_list}
        Append To List    ${formatted_list}    (Already Exists) ${file}
    END
    ${formatted_list}    Catenate    SEPARATOR=\n    @{formatted_list}
    ${failed_message}    Catenate    SEPARATOR=\n
        ...    Upload Failed
        ...    ${file_total} file failed to upload. Please check and try again.
        ...    Failed Files:
        ...    ${formatted_list}
        ...    Go Back
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    //div[@class="upload-failed"]    ${failed_message}
    Click Go Back Button

Verify Warning Message Is Displayed Invalid File Type
    [Arguments]    ${invalid_file_list}
    ${invalid_file_lines}    Catenate    SEPARATOR=\n    @{invalid_file_list}
    ${failed_message}    Catenate    SEPARATOR=\n
        ...    Invalid File
        ...    Only Excel files (.xlsx, .xls) are allowed. Invalid file(s):
        ...    ${invalid_file_lines}
        ...    OK
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    //div[@class="invalid-file"]    ${failed_message}
    Click Button    //div[@class="invalid-file"]//button[text()="OK"]

Select Manufacturer In Files Uploaded By Clinics
    [Arguments]    ${manufacturer_arg}
    Wait Until Element Is Enabled    //select[@id="QueryManufacturerId"]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    //select[@id="QueryManufacturerId"]    ${manufacturer_arg}

Select Location In Files Uploaded By Clinics
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    //select[@id="QueryLocationId"]
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    //select[@id="QueryLocationId"]    ${location_arg}

Input Start Date In Files Uploaded By Clinics
    [Arguments]    ${startdate_arg}
    Wait Until Element Is Visible    //input[@id="datafeeUploadStartDate"]
    Wait Until Keyword Succeeds    30s    1s    Input Text    //input[@id="datafeeUploadStartDate"]    ${startdate_arg}
    
Input End Date In Files Uploaded By Clinics
    [Arguments]    ${enddate_arg}
    Wait Until Element Is Visible    //input[@id="datafeeUploadEndDate"]
    Wait Until Keyword Succeeds    30s    1s    Input Text    //input[@id="datafeeUploadEndDate"]    ${enddate_arg}
    
Click Search Button In Files Uploaded By Clinics
    Common.Scroll And Click Element    ${datafee_search_btn}
    Sleep    2s

Click Clear Button In Files Uploaded By Clinics
    Common.Scroll And Click Element    ${datafee_clear_btn}
    Sleep    1s

Get Manufacturer WebElements
    ${manufacturer_row_list}    Get WebElements    //table[@id="tableFileDataUpload"]//tr[not(@class="table-upload-header")]/td[5]
    ${manufacturer_row_count}    Get Length    ${manufacturer_row_list}
    Should Be True    ${manufacturer_row_count} >= 1
    RETURN    ${manufacturer_row_list}

Get Location WebElements
    ${location_row_list}    Get WebElements    //table[@id="tableFileDataUpload"]//tr[not(@class="table-upload-header")]/td[4]
    ${location_row_count}    Get Length    ${location_row_list}
    Should Be True    ${location_row_count} >= 1
    RETURN    ${location_row_list}

Get Uploaded Date WebElements
    ${date_row_list}    Get WebElements    //table[@id="tableFileDataUpload"]//tr[not(@class="table-upload-header")]/td[2]
    ${date_row_count}    Get Length    ${date_row_list}
    Should Be True    ${date_row_count} >= 1
    RETURN    ${date_row_list}

Verify That The File List Is Filtered Correctly when Selecting A Manufacturer Value    
    [Arguments]    ${manufacturer_value}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=${manufacturer_value}
        ...    location_value=-- All Locations --
        ...    startdate_arg=${EMPTY}
        ...    enddate_arg=${EMPTY}
    ${manufacturer_row_list}    Get Manufacturer WebElements
    FOR    ${manufacturer_row}    IN    @{manufacturer_row_list}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${manufacturer_row}     ${manufacturer_value}
    END

Verify That The File List Is Filtered Correctly When Selecting A Location Value
    [Arguments]    ${location_value}    ${account_name}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=-- All Manufacturers --
        ...    location_value=${location_value}
        ...    startdate_arg=${EMPTY}
        ...    enddate_arg=${EMPTY}
    ${location_row_list}    Get Location WebElements
    FOR    ${location_row}    IN    @{location_row_list}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${location_row}     ${account_name}
    END

Verify That The File List Is Filtered Correctly When Selecting A Start Date
    [Arguments]    ${startdate_arg}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=-- All Manufacturers --
        ...    location_value=-- All Locations --
        ...    startdate_arg=${startdate_arg}
        ...    enddate_arg=${EMPTY}
    ${date_row_list}    Get Uploaded Date WebElements
    FOR    ${date_row}    IN    @{date_row_list}
        ${date_row_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${date_row}
        ${d1}    Convert Date    ${date_row_txt}    result_format=%Y%m%d%H%M    date_format=%m/%d/%Y %I:%M %p
        ${d2}    Convert Date    ${startdate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        Should Be True    ${d1} >= ${d2}
    END

Verify That The File List Is Filtered Correctly When Selecting A End Date
    [Arguments]    ${enddate_arg}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=-- All Manufacturers --
        ...    location_value=-- All Locations --
        ...    startdate_arg=${EMPTY}
        ...    enddate_arg=${enddate_arg}
    ${date_row_list}    Get Uploaded Date WebElements
    FOR    ${date_row}    IN    @{date_row_list}
        ${date_row_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${date_row}
        ${d1}    Convert Date    ${date_row_txt}    result_format=%Y%m%d%H%M    date_format=%m/%d/%Y %I:%M %p
        ${d2}    Convert Date    ${enddate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        Should Be True    ${d1} <= ${d2}
    END

Verify That The File List Is Filtered Correctly When Selecting A Start Date And End Date
    [Arguments]    ${startdate_arg}    ${enddate_arg}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=-- All Manufacturers --
        ...    location_value=-- All Locations --
        ...    startdate_arg=${startdate_arg}
        ...    enddate_arg=${enddate_arg}
    ${date_row_list}    Get Uploaded Date WebElements
    FOR    ${date_row}    IN    @{date_row_list}
        ${date_row_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${date_row}
        ${d1}    Convert Date    ${date_row_txt}    result_format=%Y%m%d%H%M    date_format=%m/%d/%Y %I:%M %p
        ${d2}    Convert Date    ${startdate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        ${d3}    Convert Date    ${enddate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        Should Be True    ${d1} >= ${d2} and ${d1} <= ${d3}
    END

Verify That File List Is Filtered Correctly When Combining Manufacturer And Location Filters
    [Arguments]    ${manufacturer_value}    ${location_value}    ${account_name}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=${manufacturer_value}
        ...    location_value=${location_value}
        ...    startdate_arg=${EMPTY}
        ...    enddate_arg=${EMPTY}
    ${location_row_list}    Get Location WebElements
    ${manufacturer_row_list}    Get Manufacturer WebElements
    FOR    ${manufacturer_row}    ${location_row}    IN ZIP    ${manufacturer_row_list}    ${location_row_list}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${location_row}    ${account_name}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${manufacturer_row}    ${manufacturer_value}
    END
    
Verify That File List Is Filtered Correctly When Applying Manufacturer, Location, Start Date And End Date Together
    [Arguments]    ${manufacturer_value}    ${location_value}    ${account_name}    ${startdate_arg}    ${enddate_arg}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=${manufacturer_value}
        ...    location_value=${location_value}
        ...    startdate_arg=${startdate_arg}
        ...    enddate_arg=${enddate_arg}
    ${location_row_list}    Get Location WebElements
    ${manufacturer_row_list}    Get Manufacturer WebElements
    ${date_row_list}    Get Uploaded Date WebElements
    FOR    ${manufacturer_row}    ${location_row}    ${date_row}    IN ZIP    ${manufacturer_row_list}    ${location_row_list}    ${date_row_list}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${manufacturer_row}     ${manufacturer_value}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${location_row}     ${account_name}
        ${date_row_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${date_row}
        ${d1}    Convert Date    ${date_row_txt}    result_format=%Y%m%d%H%M    date_format=%m/%d/%Y %I:%M %p
        ${d2}    Convert Date    ${startdate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        ${d3}    Convert Date    ${enddate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
        Should Be True    ${d1} >= ${d2} and ${d1} <= ${d3}
    END

Verify That Clicking Clear Resets All Filter Values And Reloads Default Data
    Click Clear Button In Files Uploaded By Clinics
    Verify Placeholder Of "Manufacturer" Dropdown
    Verify Placeholder Of "Clinic Location" Dropdown 
    Verify Placeholder Of "Start Date" Data Picker
    Verify Placeholder Of "End Date" Data Picker
    Verify UI Of "Search" Button
    Verify UI Of "Clear" Button

Verify Placeholder Of "Manufacturer" Dropdown 
    ${manufacturer_placeholder}    SeleniumLibrary.Get Element Attribute   //button[@data-id="QueryManufacturerId"]    title
    Should Be Equal    ${manufacturer_placeholder}    -- All Manufacturers --

Verify Placeholder Of "Clinic Location" Dropdown 
    ${location_placeholder}    SeleniumLibrary.Get Element Attribute   //button[@data-id="QueryLocationId"]    title
    Should Be Equal    ${location_placeholder}    -- All Locations --

Verify Placeholder Of "Start Date" Data Picker
    ${startdate_placeholder}    SeleniumLibrary.Get Element Attribute   //input[@id="datafeeUploadStartDate"]    placeholder
    Should Be Equal    ${startdate_placeholder}    Start Date

Verify Placeholder Of "End Date" Data Picker
    ${enddate_placeholder}    SeleniumLibrary.Get Element Attribute   //input[@id="datafeeUploadEndDate"]    placeholder
    Should Be Equal    ${enddate_placeholder}    End Date

Verify UI Of "Search" Button
    Wait Until Element Is Visible    ${datafee_search_btn}
    ${search_btn_element}    Get WebElement    ${datafee_search_btn}
    ${search_btn_color}    Execute Javascript
        ...    return window.getComputedStyle(arguments[0]).backgroundColor;
        ...    ARGUMENTS    ${search_btn_element}
    ${blue_color}    Set Variable    rgb(48, 84, 150)
    Should Be Equal    ${search_btn_color}    ${blue_color}

Verify UI Of "Clear" Button
    Wait Until Element Is Visible    ${datafee_clear_btn}
    ${datafee_clear_element}    Get WebElement    ${datafee_clear_btn}
    ${datafee_clear_color}    Execute Javascript
        ...    return window.getComputedStyle(arguments[0]).backgroundColor;
        ...    ARGUMENTS    ${datafee_clear_element}
    ${white_color}    Set Variable    rgb(255, 255, 255)
    Should Be Equal    ${datafee_clear_color}    ${white_color}

Verify UI Display The Correct Design For Record Table
    ${column_name_list}    Get WebElements    //table[@id="tableFileDataUpload"]//tr[@class="table-upload-header"]/th
    ${expected_name_list}    Create List    File Name    Uploaded On    Uploaded By    Location    Manufacturer    Status
    FOR    ${column_name}    ${expected_name}    IN ZIP    ${column_name_list}    ${expected_name_list}
        Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${column_name}    ${expected_name}
    END
    ${text}    Wait Until Keyword Succeeds    30s    1s    Get Text    (//div[@class="pager-total text-nowrap"])[1]
    Should Match Regexp    ${text}    ^Items \\(1 - \\d+\\) of \\d+$

Verify The File Information Is Uploaded
    [Arguments]    ${file_name_list}    ${manufacturer_value}    ${location_value}    ${current_date}    ${startdate_arg}    ${enddate_arg}    ${uploaded_by_txt}    ${location_name}
    Filter Files Uploaded By Clinics
        ...    manufacturer_value=${manufacturer_value}
        ...    location_value=${location_value}
        ...    startdate_arg=${startdate_arg}
        ...    enddate_arg=${enddate_arg}
    ${file_name_column}    Verify UI The File Name    ${file_name_list}
    Verify Ui The Uploaded On    ${file_name_column}    ${current_date}    ${startdate_arg}    ${enddate_arg}
    Verify Ui The Uploaded By    ${file_name_column}    ${uploaded_by_txt}
    Verify The Location Data Display    ${file_name_column}    ${location_name}
    Verify Manufacturer Display    ${file_name_column}    ${manufacturer_value}
    Verify Status Display UI    ${file_name_column}

Verify UI The File Name
    [Arguments]    ${file_name_list}
    FOR    ${file_name}    IN    @{file_name_list}
        ${file_name_column}    Set Variable    //td[a[text()="${file_name}"]]
        Wait Until Element Is Visible    ${file_name_column}    30s
    END
    RETURN    ${file_name_column}        

Verify Ui The Uploaded On
    [Arguments]    ${file_name_column}    ${current_date}    ${startdate_arg}    ${enddate_arg}
    ${updated_on_column}    Set Variable    ${file_name_column}//following-sibling::td[1]
    Wait Until Element Is Visible    ${updated_on_column}    30s
    ${updated_on_column_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${updated_on_column}
    Evaluate    datetime.datetime.strptime("${updated_on_column_txt}", "%m/%d/%Y %I:%M %p")
    ${d1}    Convert Date    ${updated_on_column_txt}    result_format=%Y%m%d%H%M    date_format=%m/%d/%Y %I:%M %p
    ${d2}    Convert Date    ${startdate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
    ${d3}    Convert Date    ${enddate_arg}       result_format=%Y%m%d%H%M    date_format=%m/%d/%Y
    Should Be True    ${d3} >= ${d1} and ${d1} >= ${d2}
    Should Contain    ${updated_on_column_txt}    ${current_date}

Verify Ui The Uploaded By
    [Arguments]    ${file_name_column}    ${uploaded_by_txt}
    ${updated_by_column}    Set Variable    ${file_name_column}//following-sibling::td[2]
    Wait Until Element Is Visible    ${updated_by_column}    30s
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${updated_by_column}    ${uploaded_by_txt}

Verify The Location Data Display
    [Arguments]    ${file_name_column}    ${location_name}
    ${location_column}    Set Variable    ${file_name_column}//following-sibling::td[3]
    Wait Until Element Is Visible    ${location_column}    30s
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${location_column}    ${location_name}

Verify Manufacturer Display
    [Arguments]    ${file_name_column}    ${manufacturer_value}
    ${manufacturer_column}    Set Variable    ${file_name_column}//following-sibling::td[4]
    Wait Until Element Is Visible    ${manufacturer_column}    30s
    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Element Text Should Be    ${manufacturer_column}    ${manufacturer_value}

Verify Status Display UI
    [Arguments]    ${file_name_column}
    ${status_column}    Set Variable    ${file_name_column}//following-sibling::td[5]
    Wait Until Element Is Visible    ${status_column}    30s
    SeleniumLibrary.Element Text Should Be    ${status_column}    Uploaded
    ${bagde_background}    Set Variable    ${status_column}//span[@class="item-status"]
    ${bagde_background_element}    Get WebElement    ${bagde_background}
    ${bagde_background_color}    Execute Javascript
        ...    return window.getComputedStyle(arguments[0]).backgroundColor;
        ...    ARGUMENTS    ${bagde_background_element}
    ${yellow_color}    Set Variable    rgb(255, 242, 204)
    Should Be Equal    ${bagde_background_color}    ${yellow_color}
    ${check_icon}    Set Variable    ${bagde_background}/i[@class="fa fa-check"]
    Element Should Be Visible    ${check_icon}

Prepare TimeStamp Data
    [Arguments]    ${utc}
    ${current_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}
    ${start_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}    add_days=-1
    ${end_date}    Handle Datetime Format    fmt={mm}/{dd}/{y}    utc=${utc}    add_days=1
    RETURN    ${current_date}    ${start_date}    ${end_date}

Create Data Fee File List
    [Arguments]    ${parent_dir}    ${file_type_list}    ${file_count}    ${target_size_mb}
    ${combine_file_path_list}    Create List
    ${combine_file_name_list}    Create List
    FOR    ${file_type}    IN    @{file_type_list}
        ${file_paths}    ${file_names}    Common.Create Files    ${parent_dir}    ${file_type}    ${file_count}    ${target_size_mb}
        Append To List    ${combine_file_path_list}    @{file_paths}
        Append To List    ${combine_file_name_list}    @{file_names}
    END
    RETURN    ${combine_file_path_list}    ${combine_file_name_list}    

Remove File In Data Fee List
    [Arguments]    ${file_name_list}
    ${removed_list}    Create List
    FOR    ${file}    IN    @{file_name_list}
        IF    not ('${file}'.endswith('.xls') or '${file}'.endswith('.xlsx'))
            Append To List    ${removed_list}    ${file}
        END
    END
    RETURN    ${removed_list}

Verify Selected File List Not Show Invalid File 
    [Arguments]    ${invalid_file_list}
    ${selected_file_list}    Get Text    //ul[@id="filesList"]
    FOR    ${invalid_file}    IN    @{invalid_file_list}
        Should Not Contain    ${selected_file_list}    ${invalid_file}
    END

Filter Files Uploaded By Clinics
    [Arguments]    ${manufacturer_value}    ${location_value}    ${startdate_arg}    ${enddate_arg}
    Click Clear Button In Files Uploaded By Clinics
    Select Manufacturer In Files Uploaded By Clinics    ${manufacturer_value}
    Select Location In Files Uploaded By Clinics    ${location_value}
    Input Start Date In Files Uploaded By Clinics    ${startdate_arg}
    Input End Date In Files Uploaded By Clinics    ${enddate_arg}
    Click Search Button In Files Uploaded By Clinics

Verify That The User Can Download A File By Clicking On The File Name
    [Arguments]    ${file_name_list}
    FOR    ${file_name}    IN    @{file_name_list}
        ${file_name_on_ui}    Set Variable    //table[@id="tableFileDataUpload"]//a[text()="${file_name}"]
        Run Keyword And Return Status    Click Element    link: 1
        FOR    ${loop}    IN RANGE    1    10
            ${check_visble}    Run Keyword And Return Status    Wait Until Element Is Visible    ${file_name_on_ui}    3s
            IF    "${check_visble}" == "${False}"
                Click Element    link: Next
            END
        END
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${file_name_on_ui}

    END

Verify That User Can Open The Downloaded File Name Matches The File Name Displayed On The UI
    [Arguments]    ${file_name_list}    ${folder_path}
    ${files}    Wait Until Keyword Succeeds    30s    1s    List Files In Directory    ${folder_path}
    ${file_status}    Set Variable    ${False}
    FOR    ${file_name}    IN    @{file_name_list}
        WHILE    True
            ${files}    Wait Until Keyword Succeeds    30s    1s    List Files In Directory    ${folder_path}
            FOR    ${file}    IN    @{files}
                ${check_equal}    Run Keyword And Return Status    Should Be Equal    ${file}    ${file_name}
                Run Keyword If    ${check_equal}    Evaluate    open(r'''${folder_path}\\${file}''', 'rb').read(1) and True
                ${file_status}    Run Keyword If    ${check_equal}    Set Variable    ${True}
            END 
            Run Keyword If    ${file_status}    Exit For Loop
            Sleep    1s
        END
    END

Remove Downloaded Files
    [Arguments]    ${folder_path}
    ${files}    Wait Until Keyword Succeeds    30s    1s    List Files In Directory    ${folder_path}
    FOR    ${file}    IN    @{files}
        Remove File    ${folder_path}/${file}
    END
