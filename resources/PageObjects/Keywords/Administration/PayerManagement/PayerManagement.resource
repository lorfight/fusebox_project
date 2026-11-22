*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Payer Management
    Click Element    link:Administration
    Click Element    link:Payer Management

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Close Submodal
    Scroll Element Into View    //*[@id='SubModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='SubModalPopup']//*[@id='CloseBtn']

View Map Master Payers
    [Arguments]    ${is_view}
    IF    ${is_view} == ${True}
        Select Checkbox    id=FilterMasterPayers
    ELSE
        Unselect Checkbox    id=FilterMasterPayers
    END

Select Account
    [Arguments]    ${acc}
    Select From List By Label    id=LocationID    ${acc}

Input To Find Payer
    [Arguments]    ${text}
    Input Text    id=SearchValues    ${text}
    Execute JavaScript    document.activeElement.blur()

Click Find
    Click Button    id=FindButton

Click Clear
    Click Button    id=ClearButton

Click Create New Payer
    Click Element    link:Create New Payer

Input Payer Name
    [Arguments]    ${name}
    Input Text    id=PayerName    ${name}
    Execute JavaScript    document.activeElement.blur()

Input Address Line
    [Arguments]    ${add}
    Input Text    id=Address1    ${add}
    Execute JavaScript    document.activeElement.blur()

Check Master Payer
    Scroll Element Into View    id=IsMasterPayer
    Select Checkbox    id=IsMasterPayer

Input Master Payer ID
    [Arguments]    ${id}
    Input Text    id=MasterPayerID    ${id}
    Execute JavaScript    document.activeElement.blur()

Submit Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='SaveBtn']
    Execute Javascript    window.scrollBy(0,10)
    Click Button    //*[@id='ModalPopup']//*[@id='SaveBtn']

Click Update Payer
    [Arguments]    ${payer}
    Scroll Element Into View    //*[text()='${payer}']/following::*[@onclick and contains(text(),'Update Payer')][1]
    Execute Javascript    window.scrollBy(0,5)
    Click Element    //*[text()='${payer}']/following::*[@onclick and contains(text(),'Update Payer')][1]

Click Delete
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='DeleteBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='DeleteBtn']

Click Map Payers
    [Arguments]    ${payer}
    Scroll Element Into View    //*[text()='${payer}']/following::*[@onclick and text()='Map Payers'][1]
    Execute Javascript    window.scrollBy(0,30)
    Click Element    //*[text()='${payer}']/following::*[@onclick and text()='Map Payers'][1]

Click Find All Payers
    Click Button    id=AllPayerFindBtn

Input To Find All Payers
    [Arguments]    ${text}
    Input Text    id=AllPayerSearch    ${text}
    Execute JavaScript    document.activeElement.blur()

Click Clear All Payers
    Click Button    id=AllPayerClearBtn

Assign Payer
    [Arguments]    ${payer}
    Scroll Element Into View    //*[text()='${payer}']/following::*[@type='checkbox' and contains(@class,'UnassignedPayer')][1]
    Select Checkbox    //*[text()='${payer}']/following::*[@type='checkbox' and contains(@class,'UnassignedPayer')][1]

Click Payer Import
    Click Element    link:Payer Import

Click Download Template
    Click Element    link:Download Template

Click Process File
    Click Button    Process File

Click Export Payer
    Click Element    link:Export Payers

Upload File
    [Arguments]    ${path}    ${file_name}
    Choose File    id=UploadFile   ${path}
    ${file}    Execute JavaScript    return document.getElementById('UploadFile').files[0].name;
    Should Be Equal    ${file}    ${file_name}

Remove Import File
    Click Element    link:Remove

Click Confirm Import
    Click Button    Confirm Import