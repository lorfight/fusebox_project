*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Physiscians
    Click Element    link:Administration
    Click Element    link:Physicians

Click Assigned Tab
    Click Element    link:Assigned Physicians

Click Referring Tab
    Click Element    link:Referring Physicians

Click Remove Physician
    [Arguments]    ${npi}
    ${xpath}    Set Variable    //*[text()[contains(.,'${npi}')]]/following::*[@onclick and contains(text(),'Remove Physician')][1]
    Scroll Element Into View    ${xpath}
    Click Element    ${xpath}

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Select Account
    [Arguments]    ${acc}
    Select From List By Label    id=CurrentAccount    ${acc}

Click Assign New Physician
    Click Element    link:Assign New Physician

Input NPI
    [Arguments]    ${npi}
    Input Text    id=NPI_Search    ${npi}
    Execute JavaScript    document.activeElement.blur()

Click Clear Search
    Click Element    link:Clear Search

Click Search
    Click Element    link:Search

Click Clear Account Assignment
    Click Button    Clear

Input Account Assignment
    [Arguments]    ${acc}
    Input Text    id=AccountAssignedSearchText    ${acc}

Click Find
    Click Button    Find

Select Account To Assign
    [Arguments]    ${acc}
    Scroll Element Into View    //*[@id='AccountAssignedList']//*[contains(text(),'${acc}')]/following::*[@type='checkbox'][1]
    Select Checkbox    //*[@id='AccountAssignedList']//*[contains(text(),'${acc}')]/following::*[@type='checkbox'][1]

Click Assign Physician
    Scroll Element Into View    //*[contains(text(),"Assign Physician")]
    Click Element    //*[contains(text(),"Assign Physician")]

Click Assign New Referral
    Click Element    link:Assign New Referral

Click Assign Referral
    Scroll Element Into View    //*[contains(text(),"Assign Referral")]
    Click Element    //*[contains(text(),"Assign Referral")]

Click Import Physicians
    Click Element    link:Import Physicians

Click Download Template
    Click Element    link:Download Template

Click Download Export
    Click Element    link:Download Export

Upload File
    [Arguments]    ${path}
    Choose File    id=UploadFile    ${path}

Click Process File
    Click Button    Process File

Click Confirm Import
    Click Button    Confirm Import

Remove Import File
    Click Element    link:Remove