*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Go To Modifier Management
    Click Element    link:Administration
    Click Element    link:Modifier Management

Click Delete
    Click Button    //*[@type='button' and @id="DeleteBtn"]

Click Find Modifier
    Click Button    id=FindButton

Click Clear Modifier
    Click Button    id=ClearButton

Input Search Modifier
    [Arguments]    ${mod}
    Input Text    id=LastSearchValues    ${mod}
    Execute JavaScript    document.activeElement.blur()

Click Modifier Mapping
    Click Element    link:Modifier Mapping

Accept Mapping Modal
    Scroll Element Into View    //*[@id='ModalModifierMappingPopup']//*[@id='CloseBtn' and text()='Accept']
    Click Button    //*[@id='ModalModifierMappingPopup']//*[@id='CloseBtn' and text()='Accept']

Close Mapping Modal
    Scroll Element Into View    //*[@id='ModalModifierMappingPopup']//*[@id='CloseBtn' and text()='Close']
    Click Button    //*[@id='ModalModifierMappingPopup']//*[@id='CloseBtn' and text()='Close']

Select Route Of Admin
    [Arguments]    ${route}
    Select From List By Label    id=RouteOfAdminID    ${route}

Select Site Of Therapy
    [Arguments]    ${site}
    Select From List By Label    id=SiteOfTherapyID    ${site}

Select Modifier
    [Arguments]    ${mod}
    Select From List By Label    id=ModifierID    ${mod}

Click To Add Modifier Mapping
    Click Element    id=addMapping

Click To Remove Modifier Mapping
    [Arguments]    ${route}    ${site}    ${mod}
    Click Element    //*[@value='${route}']/following::*[@value='${site}'][1]/following::*[@value='${mod}'][1]/following::*[@id='removeMapping'][1]

Click Modifier Category
    Click Element    link:Modifier Category

Click Add Modifier Category
    Click Element    link:Add Modifier Category

Input Category
    [Arguments]    ${cat}
    Input Text    id=Category    ${cat}
    Execute JavaScript    document.activeElement.blur()

Input Description
    [Arguments]    ${desc}
    Input Text    id=Description    ${desc}
    Execute JavaScript    document.activeElement.blur()

Click Create
    Click Button    Create

Input Search Category
    [Arguments]    ${cat}
    Input Text    id=ModifierCategorySearchValues    ${cat}
    Execute JavaScript    document.activeElement.blur()

Clear Search Cagtegory
    Click Button    id=ClearFindModifierCategoryButton

Click Find Cagtegory
    Click Button    id=FindModifierCategoryButton

Click Edit Category
    [Arguments]    ${cat}
    Click Element    //*[contains(text(),'${cat}')]/following::*[contains(text(),'Edit') and @href and contains(@class,'category')][1]

Click Save
    Click Button    Save

Close Category Modal
    Scroll Element Into View    //*[@id='ModalCategoryPopup']//*[@id='CloseBtn' and text()='Close']
    Click Button    //*[@id='ModalCategoryPopup']//*[@id='CloseBtn' and text()='Close']

Close Category Management Modal
    Scroll Element Into View    //*[@id='ModalModifierCategory']//*[@id='CloseBtn' and text()='Close']
    Click Button    //*[@id='ModalModifierCategory']//*[@id='CloseBtn' and text()='Close']

Click Delete Category
    [Arguments]    ${cat}
    Click Element    //*[contains(text(),'${cat}')]/following::*[contains(text(),'Delete') and @href and contains(@class,'category')][1]

Click Create New Modifier
    Click Element    link:Create New Modifier

Select Category
    [Arguments]    ${cat}
    Select From List By Label    id=ModifierCategoryID    ${cat}

Input Modifier
    [Arguments]    ${mod}
    Input Text    id=Modifier    ${mod}
    Execute JavaScript    document.activeElement.blur()

Input Definition
    [Arguments]    ${def}
    Input Text    id=Definition    ${def}
    Execute JavaScript    document.activeElement.blur()

Click Edit Modifier
    [Arguments]    ${mod}
    ${xpath}    Set Variable    //*[contains(text(),'${mod}')]/following::*[contains(text(),'Edit') and @href and contains(@class,'modifier')][1]
    Scroll Element Into View    ${xpath}
    Click Element    ${xpath}

Click Delete Modifier
    [Arguments]    ${mod}
    ${xpath}    Set Variable    //*[contains(text(),'${mod}')]/following::*[contains(text(),'Delete') and @href and contains(@class,'modifier')][1]
    Scroll Element Into View    ${xpath}
    Click Element    ${xpath}

Close Modifier Modal
    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']