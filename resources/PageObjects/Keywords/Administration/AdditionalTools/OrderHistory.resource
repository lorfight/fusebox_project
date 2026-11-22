*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Click Filter Search Button
    Click Element    //*[@id='OrderList']/preceding::*[contains(@class,'SearchBtn')]

Click List Search Button
    Click Element    //*[@id='OrderList']/*[contains(@class,'SearchBtn')]

Input Item Filter
    [Arguments]    ${item}
    Input Text    id=ItemSearchValues    ${item}
    Execute JavaScript    document.activeElement.blur()

Click Find Item
    Click Button    id=ItemFindButton

Click Clear Item
    Click Button    id=ItemClearButton

Input Search Order
    [Arguments]    ${order}
    Input Text    id=SearchValues    ${order}
    Execute JavaScript    document.activeElement.blur()

Click Find Order
    Click Button    id=FindButton

Click Clear Order
    Click Button    id=ClearButton

Filter Distributor
    [Arguments]    ${distri}
    Select From List By Label    id=DistributorId    ${distri}

Filter Location
    [Arguments]    ${loc}
    Select From List By Label    id=MemberId    ${loc}

Filter Association
    [Arguments]    ${assoc}
    Select From List By Label    id=Association    ${assoc}

Filter Status
    [Arguments]    ${status}
    Select From List By Label    id=StatusFilter    ${status}

Filter Order
    [Arguments]    ${ordre}
    Select From List By Label    id=OrderPlaceStatusFilter    ${order}

Input Start Date
    [Arguments]    ${date}
    Input Text    id=StartDate    ${date}
    Execute JavaScript    document.activeElement.blur()

Input End Date
    [Arguments]    ${date}
    Input Text    id=EndDate    ${date}
    Execute JavaScript    document.activeElement.blur()