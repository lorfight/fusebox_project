*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${add_newsletter_btn}    //*[@id='AddNewsletterButton']
${choose_pdf_file}    //*[@id='Pdf']
${newsletter_description}    //*[@id='Description']
${active_startdate}    //*[@id='ActiveStartDate']
${newsletter_save}    //*[@id='SaveBtn']
    

*** Keywords ***
Go To Newsletter
    Click Element    link:Administration
    Click Element    link:Newsletter

Click Add Newsletter
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_newsletter_btn}
    Wait Until Element Is Visible    //h4[contains(text(),'Create Newsletter')]

Input Newsletter Description
    Wait Until Element Is Visible    ${newsletter_description}    30s
    Input Text Into Field    ${newsletter_description}    Test Newsletter

Input Active Start Date
    [Arguments]    ${dict_arg}
    # ${active_date}    Get Current Date    result_format=%#m/%#d/%Y    increment=30 days
    ${IS_LINUX_PLATFORM}    Is Linux Platform
    IF    ${IS_LINUX_PLATFORM}
        ${active_date}    Get Current Date    result_format=%-m/%-d/%Y    increment=30 days
    ELSE
        ${active_date}    Get Current Date    result_format=%#m/%#d/%Y    increment=30 days
    END
    Input Text Into Field    ${active_startdate}    ${active_date}
    Common.Close Calendar Table
    Set To Dictionary    ${dict_arg}    active_date=${active_date} 
    RETURN    ${dict_arg}

Click Edit Newsletter
    [Arguments]    ${date_arg}
    ${newsletter_edit}    Set Variable    (//tr[.//td[normalize-space()='${date_arg}']]//span[contains(text(),'Edit')])[1]
    Wait Until Element Is Visible    ${newsletter_edit}    30s
    Click Element    ${newsletter_edit}

Click Open PDF Newsletter
    [Arguments]    ${date_arg}
    ${newsletter_open_pdf}    Set Variable    (//tr[.//td[normalize-space()='${date_arg}']]//a[contains(text(),'Open PDF')])[1]
    Wait Until Element Is Visible    ${newsletter_open_pdf}    30s
    Click Element    ${newsletter_open_pdf}

Click Delete Newsletter
    Wait Until Element Is Visible    //h4[contains(text(),'Edit Newsletter')]    30s
    Sleep    3s
    Wait Until Keyword Succeeds    30s    1s    Click Element    //*[@id='DeleteBtn']
    Handle Alert    ACCEPT
    Common.Page Alert Message    Newsletter removed

Add Newsletter Successfully
    [Arguments]    ${dict_arg}
    ${pdf_path}    CustomLibrary.Create Pdf    newsletter.pdf    Auto Test Newsletter
    Click Add Newsletter
    Wait Until Keyword Succeeds    30s    1s    Choose File    ${choose_pdf_file}    ${pdf_path}
    Input Newsletter Description
    Input Active Start Date    ${dict_arg}
    Click Element    //*[@id='SaveBtn']
    Wait Upload File
    RETURN    ${pdf_path}

Verify Newsletter PDF Opens Successfully
    [Arguments]    ${date_arg}
    Click Open PDF Newsletter    ${date_arg}
    Switch Window By Url Contains   /File/Stream
    Wait Until Keyword Succeeds    30s    1s    Close Window
    Switch Window    Newsletter

Delete Newsletter Successfully
    [Arguments]    ${date_arg}    ${pdf_path}
    Click Edit Newsletter    ${date_arg}
    Click Delete Newsletter
    Remove File    ${pdf_path}

Switch Window By Url Contains
    [Arguments]   ${partial_url}
    ${handles}=   Get Window Handles
    FOR   ${handle}    IN    @{handles}
        Switch Window   ${handle}
        ${url}=    Get Location
        IF    '${partial_url}' in '${url}'
            RETURN
        END
    END
    Fail  Window with URL containing '${partial_url}' not found

Wait Upload File
    Wait Until Element Is Not Visible    //*[contains(text(),'Uploading Files')]    30s
    Wait Until Element Is Visible    //*[contains(text(),'Upload Successful')]    30s
    Click Element    //button[contains(text(),'OK')]