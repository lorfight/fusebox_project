*** Settings ***
Library    SeleniumLibrary    timeout=10   implicit_wait=0    screenshot_root_directory=EMBED    run_on_failure=Capture Page Screenshot
Library    Collections
Library    ../../../libraries/CustomLibrary.py
Resource    ../../../libraries/Util.resource


*** Keywords ***
Go To Contract & Pricing Sets
    Click Element    link:Administration
    Click Element    link: Contracts & Pricing Sets
    Title Should Be    Contracts & Pricing Sets

Search By Item
    [Arguments]    ${search_value}
    Wait Until Element Is Visible    id=ItemSearchValues    
    Input Text    id=ItemSearchValues    text=${search_value}
Filter By Member
    [Arguments]    ${member_value}
    Wait Until Element Is Enabled    id=MemberIdFilter    
    Util.Verify Loading And Select By Label    locator=MemberIdFilter    selected_label=${member_value}
    Waiting For Loading

Search By Contract Information
    [Arguments]    ${contract_search_values}
    Wait Until Element Is Enabled    id=ContractSearchValues
    Input Text    id=ContractSearchValues    text=${contract_search_values}
    Click Button    Find
    Waiting For Loading
    
Edit Contract
    [Arguments]    ${contract_search_values}
    Waiting For Loading
    # Wait Until Element Is Enabled    link:${contract_search_values}    10s
    Click Element    link:${contract_search_values}
    Waiting For Loading
    Title Should Be    Contract Details