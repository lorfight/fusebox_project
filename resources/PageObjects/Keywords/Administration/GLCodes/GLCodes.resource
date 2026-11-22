*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To GL Code Management
    Click Element    link: Administration
    Click Element    link: GL Codes

Open GL Code Modal
    Click Element    link: Create New GL Code

Close Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn']

Click To Save
    Scroll Element Into View    //*[@id='SaveBtn']
    Click Button    //*[@id='SaveBtn']

Clear Field
    Click Button    Clear

Input Search
    [Arguments]    ${text}
    Input Text    id=SearchValues    ${text}
    Execute JavaScript    document.activeElement.blur()

Click To Find
    Click Button    Find

Click To Assign Multiple GL Code
    Click Element    link: Add GL Code To Selection

Click To Assign Single GL Code
    Scroll Element Into View    //*[contains(@onclick,'AssignGLCode') and *]
    Execute JavaScript    return document.evaluate("//*[contains(@onclick,'AssignGLCode') and *]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Create GL Code
    [Arguments]    ${code}    ${desc}    ${pay}    ${re}
    Open GL Code Modal
    Wait Until Element Is Visible    id=ModalPopup    60s
    Input GL Code    code=${code}
    Input GL Desscription    desc=${desc}
    Input Payable Code    code=${pay}
    Input Recievable Code    code=${re}
    Wait Until Keyword Succeeds    5 times    3s    Click To Save

Click Delete GL Code
    Click Element    //*[contains(@onclick,'Delete')]

Input GL Code
    [Arguments]    ${code}
    Input Text    //*[contains(@placeholder,'General Ledger Code')]    ${code}
    Execute JavaScript    document.activeElement.blur()

Input GL Desscription
    [Arguments]    ${desc}
    Input Text    id=Description    ${desc}
    Execute JavaScript    document.activeElement.blur()

Input Payable Code
    [Arguments]    ${code}
    Input Text    //*[contains(@placeholder,'Payable Code')]    ${code}
    Execute JavaScript    document.activeElement.blur()

Input Recievable Code
    [Arguments]    ${code}
    Input Text    //*[contains(@placeholder,'Receivable Code')]    ${code}
    Execute JavaScript    document.activeElement.blur()

Open Edit GL Code Modal
    [Arguments]    ${code}
    Scroll Element Into View    //*[@id='GLCodeList']//*[@onclick and text()='${code}']/following::*[contains(@onclick,'newGLCode')][1]
    Execute Javascript    window.scrollBy(0,30)
    Click Element    //*[@id='GLCodeList']//*[@onclick and text()='${code}']/following::*[contains(@onclick,'newGLCode')][1]

Assign GL Code
    [Arguments]    ${code}    ${ndc}
    Select GL Code    ${code}
    Clear Field
    Input Search    ${ndc}
    Click To Find
    Click To Assign Single GL Code
    IF    "Unassign GL Code" in "${code}"
        Wait Until Page Contains    GL Code Removed Successfully    15s
    ELSE
        Wait Until Page Contains    GL Code Assigned Successfully    15s
    END

Select GL Code
    [Arguments]    ${code}
    Select From List By Label    id=GLCodeId    ${code}

Select Account
    [Arguments]    ${acc}
    Select From List By Label    id=AccountId    ${acc}

Select Department
    [Arguments]    ${dept}
    Select From List By Label    id=DepartmentId    ${dept}

Select Vendors
    [Arguments]    ${vend}
    Select From List By Label    id=DistributerAccountId    ${vend}

Select Manufacturers
    [Arguments]    ${manuf}
    Select From List By Label    id=ManufacturerAccountId    ${manuf}