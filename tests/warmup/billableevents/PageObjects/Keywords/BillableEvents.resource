*** Settings ***
Library    SeleniumLibrary
Library    ../../../../../libraries/CustomLibrary.py
Resource    Dispensenow.resource
*** Keywords ***
Verify payer field work correctly
    [Arguments]    ${AptID}    ${PA payer name}
    Verify PA payer is chosen before    ${AptID}    ${PA payer name}
    Verify choosing payer    ${AptID}
    Verify unchoosing payer    ${AptID}
Verify PA payer is chosen before
    [Arguments]    ${AptID}    ${PA payer name}
    Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/parent::div/following-sibling::div/select    30
    ${PA payer}    Get Selected List Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/parent::div/following-sibling::div/select
    Should Be Equal As Strings    ${PA payer}    ${PA payer name}
Verify unchoosing payer
    [Arguments]    ${AptID}
    @{Payer type}    Create List    Tertiary    Secondary    Primary
    FOR    ${payer}    IN    @{Payer type}
        IF    '${payer}' == 'Primary'
            Exit For Loop
        ELSE
            Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select
            Select From List By Label   //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select    - Select a Payor -
            Verify payer is displayed correctly    ${AptID}    ${payer}    Disabled
            ${Chosen payer}    Get Selected List Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select
            Should Be Equal As Strings    ${Chosen payer}    - Select a Payor -
        END
    END
Verify choosing payer
    [Arguments]    ${AptID}
    @{Payer type}    Create List    Primary    Secondary    Tertiary
    FOR    ${payer}    IN    @{Payer type}
        IF    '${payer}' == 'Primary'
            Continue For Loop
        ELSE
            Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select
            Sleep    3s
            Select From List By Label   //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select    ${payer} billing payer
            Verify payer is displayed correctly    ${AptID}    ${payer}    Enabled
            ${Chosen payer}    Get Selected List Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer} Payor')]/parent::div/following-sibling::div/select
            Should Be Equal As Strings    ${Chosen payer}    ${payer} billing payer
        END
    END
Verify payer is displayed correctly
    [Arguments]    ${AptID}    ${payer type}    ${Enabled/Disabled}
    ${Payer line items}    SeleniumLibrary.Get Element Count    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer type} Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"]
    ${Total line items}    Evaluate    ${Payer line items} + 1
    IF    '${Enabled/Disabled}' == 'Enabled'
        FOR    ${i}    IN RANGE    1    ${Total line items} 
            Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer type} Payor')]/ancestor::div[2]/following-sibling::div[1][contains(@class,'collapse in')]    60
            Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]//tr[2]//*[contains(text(),'${payer type} Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class='PayerBillingResultRow' and @data-isdisabled=''][${i}]
        END 
    ELSE
        FOR    ${i}    IN RANGE    1    ${Total line items}
            Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'${payer type} Payor')]/ancestor::div[2]/following-sibling::div[1][contains(@class,'collapse ')]    60 
            Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]//tr[2]//*[contains(text(),'${payer type} Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class='PayerBillingResultRow' and @data-isdisabled='disabled'][${i}]
        END
    END
    
Verify lines items are displayed right between 1500 and payer table
    [Arguments]    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}    @{Code}    
    Verify lines items are displayed right    ${Aptid}    ${Root-CPT code}    ${Root-HCPCS}    @{Code}
    Compare line items between 1500 and payer table    ${Aptid}

Verify lines items are displayed right
    [Arguments]    ${Aptid}    @{Code}
    [Documentation]    Input the AptID and the list of expected codes needed to verified
    ${Total line items}    SeleniumLibrary.Get Element Count    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"]
    ${Expected line items}    Get Length    ${Code}
    Should Be Equal As Strings    ${Total line items}    ${Expected line items}
    ${Total line items}    Evaluate    ${Total line items} + 1
    FOR    ${i}    IN RANGE    1    ${Total line items}
        FOR    ${HCPCS/CPT}    IN    @{Code}
            IF    '${HCPCS/CPT}' == '${Code}[-1]'
                ${status}    Run Keyword And Return Status   Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
                IF    ${status} == ${True}
                    ${1500 CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
                    Should Be Equal As Strings    ${1500 CPT/HCPCS}    ${HCPCS/CPT}
                    Exit For Loop
                ELSE
                    ${1500 CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]
                    Should Be Equal As Strings    ${1500 CPT/HCPCS}    ${HCPCS/CPT}
                    Exit For Loop
                END    
            ELSE
                ${status}    Run Keyword And Return Status   Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
                IF    ${status} == ${True}
                    ${1500 CPT/HCPCS}    Wait Until Keyword Succeeds    10 times     3s    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
                    ${status1}    Run Keyword And Return Status    Should Be Equal As Strings    ${1500 CPT/HCPCS}    ${HCPCS/CPT}
                    Continue For Loop If    ${status1} == ${False}
                    Exit For Loop If    ${status1} == ${True}
                ELSE
                    ${1500 CPT/HCPCS}    Wait Until Keyword Succeeds    10 times     3s    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]
                    ${1status}    Run Keyword And Return Status    Should Be Equal As Strings    ${1500 CPT/HCPCS}    ${HCPCS/CPT}
                    Continue For Loop If    ${1status} == ${False}
                    Exit For Loop If    ${1status} == ${True}
                END    
            END
        END
    END
    #Using IF for '//*[contains(@selected,'selected')]' to check if the element is a list value or not, if it is a list value, it will be selected and the text will be in the selected list, otherwise it will be in the text of the element.

Unlock billing
    [Arguments]    ${AptID}
    ${status}    Run Keyword And Return Status    Element Should Be Enabled    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Add Line')]
    WHILE    ${status} == ${False}
        click element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(@class,'UnlockLockBillingFieldsBtn')]
        ${status}    Run Keyword And Return Status    Element Should Be Enabled    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Add Line')]
    END
Choose random Modifiers
    [Arguments]    ${AptID}
    Unlock billing    ${AptID}
    ${Total line items}    SeleniumLibrary.Get Element Count    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"]
    ${Total line items}    Evaluate    ${Total line items} + 1
    FOR    ${i}    IN RANGE    1    ${Total line items}
        FOR    ${i2}    IN RANGE    4    8
            ${Modifiers list}    Get List Items    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[${i2}]/select
            ${random}    Evaluate    random.choice(${Modifiers list})    modules=random
            Select From List By Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[${i2}]/select    ${random}
            Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[${i2}]/select//*[contains(@selected,'selected') and contains(text(),'${random}')]    60
        END
    END

Compare line items between 1500 and payer table
    [Arguments]    ${AptID}
    FOR    ${i}    IN RANGE    1    4
        ${1500 line items}    SeleniumLibrary.Get Element Count    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"]
        ${Payer line items}    SeleniumLibrary.Get Element Count    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"]
        ${Total line items}    Evaluate    ${1500 line items} + 1
        ${status}    Run Keyword And Return Status    Should Be Equal As Integers    ${1500 line items}    ${Payer line items}
        IF    ${status} == $False
            Sleep    2
            Continue For Loop
        ELSE
            Exit For Loop
        END
    END
    FOR    ${i}    IN RANGE    1    ${Total line items}
        ${1500 DOS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[1]
        ${1500 POS}    Get Selected List Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[2]/select
        ${1500 Units}    Wait Until Keyword Succeeds    10 times    3s    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[10]/input
        ${status}    Run Keyword And Return Status   Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
        IF    ${status} == ${True}
            ${1500 CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]//*[contains(@selected,'selected')]
        ELSE
            ${1500 CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[3]
        END
        ${1500 Charge Amount}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[9]
        @{1500 Modifiers}    Create List
        FOR    ${i2}    IN RANGE    4    8
            ${Mod}    Wait Until Keyword Succeeds    10 times    3s    Get Selected List Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingResultTable "]//tbody/*[@class="BillingResultTableRow"][${i}]/td[${i2}]/select
            Append To List    ${1500 Modifiers}    ${Mod}
        END
        Remove Values From List    ${1500 Modifiers}    -
        ${1500 table}    Create Dictionary    DOS=${1500 DOS}    POS=${1500 POS}    Units=${1500 Units}    CPT/HCPCS=${1500 CPT/HCPCS}    Charge Amount=${1500 Charge Amount}    Modifiers=${1500 Modifiers}
        FOR    ${i3}    IN RANGE    1    ${Total line items}
            IF    '${i3}' == '${Payer line items}'
                ${Payer CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[4]
                ${Payer DOS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[1]
                ${Payer POS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[2]
                ${Payer Units}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[3]
                ${Payer Charge Amount}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[6]
                ${Payer Modifiers}    Get text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[5]
                ${Payer Modifiers}    Split String    ${Payer Modifiers}    \n
                Remove Values From List    ${Payer Modifiers}    ,    ${EMPTY}
                ${Payer table}    Create Dictionary    DOS=${Payer DOS}    POS=${Payer POS}    Units=${Payer Units}    CPT/HCPCS=${Payer CPT/HCPCS}    Charge Amount=${Payer Charge Amount}    Modifiers=${Payer Modifiers}
                Dictionaries Should Be Equal    ${1500 table}    ${Payer table}
                Exit For Loop
            ELSE
                ${Payer CPT/HCPCS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[4]
                ${Payer DOS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[1]
                ${Payer POS}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[2]
                ${Payer Units}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[3]
                ${Payer Charge Amount}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[6]
                ${Payer Modifiers}    Get text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Primary Payor')]/ancestor::div[2]/following-sibling::div[1]//*[@class="PayerBillingResultRow"][${i3}]/td[5]
                ${Payer Modifiers}    Split String    ${Payer Modifiers}    \n
                Remove Values From List    ${Payer Modifiers}    ,    ${EMPTY}
                ${Payer table}    Create Dictionary    DOS=${Payer DOS}    POS=${Payer POS}    Units=${Payer Units}    CPT/HCPCS=${Payer CPT/HCPCS}    Charge Amount=${Payer Charge Amount}    Modifiers=${Payer Modifiers}
                ${status}    Run Keyword And Return Status    Dictionaries Should Be Equal    ${1500 table}    ${Payer table}
                Continue For Loop If    ${status} == ${False}
                Exit For Loop If    ${status} == ${True}
            END
        END      
    END
Go Billable Events
    Click Element    ${DispensingLink}
    Click Element    link:Billable Events       
    Title Should Be    Billable Event Ledger
Open Dx code modal
    [Arguments]    ${date}    ${AptID}    ${mrn}    ${PA-DXcode}    ${accountid}    ${accountid1}
    ${MAX_RETRIES}    Set Variable    3
    ${status}         Set Variable    ${False}
    FOR    ${index}    IN RANGE    ${MAX_RETRIES}
        Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@title="Assign ICD Code"]
        ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="SubModalPopup"]//*[contains(text(),'Assign Appointment DX Code')]    30
        Run Keyword If    ${status}    Exit For Loop
        Go to Billable Events    ${date}    ${AptID}    ${mrn}    ${accountid}    ${accountid1}
        Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'1500 Form')]
    END
    Wait Until Element Is Visible    //*[(@class="icdCodeName") and contains(text(),'${PA-DXcode}')]    30

Add and remove DXcodes
    [Arguments]    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}
    @{DXcode-number}    Create List    B)    C)
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'1500 Form')]
    Element Should Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'DX Code:')]/following-sibling::strong//*[contains(text(),'A)')]/parent::*    ${PA-DXcode}
    Add DX codes    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}
    Remove Dx codes    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}

Remove Dx codes
    [Arguments]    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'DX Code:')]    30
    Open Dx code modal    ${date}    ${AptID}    ${mrn}     ${PA-DXcode}    ${accountid}    ${accountid1}
    ${picked code}    Evaluate    random.choice(@{DXcodes})    modules=random
    Wait Until Element Is Visible    //*[@id="ICDModalList"]//*[contains(text(),'${picked code}')]/parent::td/following-sibling::td//*[contains(text(),'Unassign Code ')]    10
    Click Element    //*[@id="ICDModalList"]//*[contains(text(),'${picked code}')]/parent::td/following-sibling::td//*[contains(text(),'Unassign Code ')]
    Wait Until Element Is Not Visible    //*[@id="SubModalPopup"]//*[contains(text(),'Assign Appointment DX Code')]    30
    Go to Billable Events    ${date}    ${AptID}    ${mrn}    ${accountid}    ${accountid1}
    Wait Until Keyword Succeeds    10 times    3s   Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'1500 Form')]
    Element Should not Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'DX Code:')]/following-sibling::strong//*[contains(text(),'A)')]/parent::*    ${picked code}

    
Add DX codes
    [Arguments]    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}
    @{DXcode-number}    Create List    B)    C)
    FOR    ${i}    ${i2}    IN ZIP    ${DXcodes}    ${DXcode-number}
        Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'1500 Form')]
        Open Dx code modal    ${date}    ${AptID}    ${mrn}    ${PA-DXcode}    ${accountid}    ${accountid1}
        Scroll Element Into View    //*[contains(text(),'Assign DX Code ')]
        Click Element    //*[@id="SetPatientICD"]
        Input Text    //*[@id="ICDSearchValues"]    ${i}
        Click Element    //*[@id="ICDFindButton"]
        Wait Until Element Is Visible    //*[@id="ICDModalList"]//*[contains(text(),'${i}')]    30
        Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[@id="ICDModalList"]//*[contains(text(),'${i}')]/parent::td/preceding-sibling::td/input
        Click Element    //*[contains(text(),'Assign DX Code ')]
        Wait Until Element Is Not Visible    //*[@id="SubModalPopup"]//*[contains(text(),'Assign Appointment DX Code')]    30
        Element Should Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'DX Code:')]/following-sibling::strong//*[contains(text(),'${i2}')]/parent::*    ${i}
    END

    
Change billing provider information
    [Arguments]    ${AptID}
    @{provider}    Get List Items    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="BillingProvider"]
    Remove Values From List    ${provider}    Not Assigned
    ${pick-provider}    Evaluate    random.choice(@{provider})    modules=random
    Select From List By Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="BillingProvider"]    ${pick-provider}
    ${pick-provider}    Split String    ${pick-provider}    :
    ${provider-number}    Split String    ${pick-provider}[-1]    )
    ${provider-number}    Convert To String    ${provider-number}[0]
    ${provider-number}    Remove String    ${provider-number}    ${SPACE}
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingProviderNPI"]    ${provider-number}    30
    Select From List By Index    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="BillingProvider"]    0
    Wait Until Element Does Not Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="BillingProviderNPI"]    ${provider-number}    30

    
Clear and rebuild items
    [Arguments]    ${AptID}    ${Root-HCPCS}    ${Root-CPT code}
    Scroll Element Into View    locator=//*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Clear Items')]
    ${hcpcs unit}    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-HCPCS}')]/td[10]/input
    ${cpt unit}    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-CPT code}')]/td[10]/input
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Clear Items')]
    Alert Should Be Present    Are you sure you would like to clear this appointment's billing items? This will empty your billing items completely.    accept
    Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'No Dispensed Items to Bill Found.')]    30
    Scroll Element Into View    locator=//*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Clear Items')]
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Rebuild Items')]
    Alert Should Be Present    Are you sure you would like to build this appointment's billing items? This will reset them back to their default values.    accept
    Wait Until Page Does Not Contain Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'No Dispensed Items to Bill Found.')]    30
    ${re hcpcs unit}    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-HCPCS}')]/td[10]/input
    ${re cpt unit}    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-CPT code}')]/td[10]/input
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

    Should Be Equal As Strings    ${re hcpcs unit}    ${hcpcs unit}
    Should Be Equal As Strings    ${re cpt unit}    ${cpt unit}

    

Set up length of time for CPT Code
    [Arguments]    ${AptID}     ${Root-CPT code}    ${Root-HCPCS}    ${Cpt code office}
    ${Start-time}    Set Variable    6:00 AM
    ${Stop-time1}    Set Variable    7:30 AM
    ${Stop-time2}    Set Variable    12:00 PM
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="ApptStartTime"]    ${Start-time}
    Sleep    3s
    Execute JavaScript    document.activeElement.blur()
    Click Element    //*[contains(text(),'${AptID}')]
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class='totalTimeLabel']     NaN minute     60
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="ApptStopTime"]    ${Stop-time2}
    Click Element    //*[contains(text(),'${AptID}')]
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code="${Cpt code office}")]    30
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class='totalTimeLabel']    6 hours    30
    Verify lines items are displayed right between 1500 and payer table    ${AptID}   ${Root-CPT code}    ${Root-HCPCS}     ${Cpt code office}
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="ApptStopTime"]    ${Stop-time1}
    Click Element    //*[contains(text(),'${AptID}')]
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class='totalTimeLabel']    1 hour, 30 minutes    30
    Wait Until Element Is not Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code="${Cpt code office}")]    30
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}
    Choose and unchoose random Rendering Provider    ${AptID}    96366    ${Root-CPT code}    ${Root-HCPCS}
    
    
Add and remove lines item
    [Arguments]    ${AptID}    ${Cpt code}    ${unit}    ${hcpcs}    ${Root-CPT code}    ${Root-HCPCS}
    Unlock and add line    ${AptID}
    Add CPT line    ${AptID}    ${Cpt code}    ${unit}
    Choose and unchoose random Rendering Provider    ${AptID}    ${Cpt code}    ${Root-CPT code}    ${Root-HCPCS}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}    ${Cpt code}
    Remove line    ${AptID}    ${Cpt code}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}
    Unlock and add line    ${AptID}
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]    30
    Add HCPCS line    ${AptID}    ${hcpcs}    ${unit}
    Choose and unchoose random Rendering Provider    ${AptID}    ${hcpcs}    ${Root-CPT code}    ${Root-HCPCS}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}    ${hcpcs}
    Remove line    ${AptID}    ${hcpcs}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

Add HCPCS line
    [Arguments]    ${AptID}    ${hcpcs}    ${unit}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[@class="CPTCodeHCPCSCheckbox CheckedCPTCode"]    30
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[@class="CPTCodeHCPCSCheckbox CheckedHCPCS"]
    Wait Until Element Is Enabled    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//button/*[contains(text(),'-- Select a HCPCS Code --')]    30
    Select From List By Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[@id="BillingResultLineHCPCS" and not(contains(@class,'hidden'))]    ${hcpcs}
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[contains(@class,'HCPCSNDCList')]    30
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Wait Until Element Is Visible    (//*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[contains(@class,'HCPCSNDCList')]//*[@type="radio"])[1]    30
    Click Element    (//*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]//*[contains(@class,'HCPCSNDCList')]//*[@type="radio"])[1]
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="form-control DaysUnits"]    ${unit}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Save')]
    Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${hcpcs}')]    30
    ${hcpcs unit}    Get Value    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${hcpcs}')]/td[10]/input
    Should Be Equal As Strings    ${hcpcs unit}    ${unit}

    

Remove line
    [Arguments]    ${AptID}    ${code}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${code}')]/preceding-sibling::tr//*[contains(text(),'Remove')]
    Wait Until Page Does Not Contain Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${code}')]    30
Add CPT line
    [Arguments]    ${AptID}    ${Cpt code}    ${unit}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="form-control CPTCodeBillingResult tt-input"]    30
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="form-control CPTCodeBillingResult tt-input"]    ${Cpt code}
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="tt-dataset tt-dataset-BillingCPTCodes"]/parent::*    30
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="tt-dataset tt-dataset-BillingCPTCodes"]/div[1]
    Input Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="form-control DaysUnits"]    ${unit}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Charge Total:')]
    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Save')]
    Wait Until Page Contains Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Cpt code}')]    30
    ${cpt code unit}    Get Value   //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Cpt code}')]/td[10]/input
    Should Be Equal As Strings    ${cpt code unit}    ${unit}    

Unlock and add line
    [Arguments]    ${AptID}
    ${status}    Run Keyword And Return Status    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Add Line')]
    WHILE    ${status} == ${False}
        click element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(@class,'UnlockLockBillingFieldsBtn')]
        ${status}    Run Keyword And Return Status    Click Element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Add Line')]
    END
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="AdditionalBillingResultLineRow"]    30

Choose and unchoose random Rendering Provider
    [Arguments]    ${AptID}    ${cpt-code}    ${Root-HCPCS}    ${Root-CPT code}
    @{provider}    Get List Items    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="PhysicianName"]
    Remove Values From List    ${provider}    Not Assigned
    ${pick-provider}    Evaluate    random.choice(@{provider})    modules=random
    Select From List By Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="PhysicianName"]    ${pick-provider}
    ${pick-provider}    Split String    ${pick-provider}    :
    ${provider-number}    Split String    ${pick-provider}[-1]    )
    ${provider-number}    Convert To String    ${provider-number}[0]
    ${provider-number}    Remove String    ${provider-number}    ${SPACE}
    Line items billing contains provider number    ${AptID}    ${cpt-code}    ${provider-number}    ${Root-HCPCS}    ${Root-CPT code}
    Select From List By Index    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@id="PhysicianName"]    0
    Line items billing doesn't contain provider number    ${AptID}    ${cpt-code}    ${provider-number}    ${Root-HCPCS}    ${Root-CPT code}

Line items billing contains provider number
    [Arguments]    ${AptID}    ${cpt-code}    ${provider-number}    ${Root-HCPCS}    ${Root-CPT code}
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-HCPCS}')]//td[11]    ${provider-number}    30
    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-CPT code}')]//td[11]    ${provider-number}    30
    ${status}    run Keyword and return status    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${cpt-code}')]//td[11]    ${provider-number}    30
    IF    ${status} == ${False}
        No Operation
    END
Line items billing doesn't contain provider number
    [Arguments]    ${AptID}    ${cpt-code}    ${provider-number}    ${Root-HCPCS}    ${Root-CPT code}
    Wait Until Element does not Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-HCPCS}')]//td[11]    ${provider-number}    30
    Wait Until Element does not Contain    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${Root-CPT code}')]//td[11]    ${provider-number}    30
    ${status}    run Keyword and return status    Wait Until Element Contains    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code='${cpt-code}')]//td[11]    ${provider-number}    30
    IF    ${status} == ${False}
        No Operation
    END
Verify Office Visit
    [Arguments]    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}
    Click element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="largeCheckbox ScheduleOfficeVisit"]
    Element Should Be Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//select[@id="OfficeVisit"]
    @{Office visit list}    Get List Items    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//select[@id="OfficeVisit"]
    Remove Values From List    ${Office visit list}    -- Select Patient Complexity --
    ${Office visit}    Evaluate    random.choice(@{Office visit list})    modules=random
    Select From List By Label    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//select[@id="OfficeVisit"]    ${Office visit}
    ${CPT code}    Wait for CPT code of Office Visit diplays line item    ${Office visit}    ${AptID}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}    ${CPT code}
    # TODO: Add a case that re-choose the first option to make the code disappear without alert-
    Turn off office visit    ${AptID}    ${CPT code}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

   
Turn off office visit
    [Arguments]    ${AptID}    ${CPT code}
    Click element    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[@class="largeCheckbox ScheduleOfficeVisit"]
    Alert Should Be Present    Are you sure you would like to continue? This will remove the selected Patient Complexity.    accept
    Wait Until Element Is Not Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//select[@id="OfficeVisit"]    30
    Wait Until Element Is Not Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code="${CPT code}")]    30
Wait for CPT code of Office Visit diplays line item
    [Arguments]    ${Office visit}    ${AptID}
    &{office_visit_codes}    Create Dictionary
    ...    Unknown Complexity                              100
    ...    New Patient Visit Straightforward               99202
    ...    New Patient Visit Low Complexity                99203
    ...    New Patient Visit Moderate Complexity           99204
    ...    New Patient Visit High Complexity               99205
    ...    Established Patient Visit Minimal Complexity    99211
    ...    Established Patient Visit Straightforward       99212
    ...    Established Patient Visit Low Complexity        99213
    ...    Established Patient Visit Moderate Complexity   99214
    ...    Established Patient Visit High Complexity       99215

    ${code}    Set Variable    ${office_visit_codes['${Office visit}']}
    Wait Until Element Is Visible    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[(@class="BillingResultTableRow") and (@data-code="${code}")]    30
    RETURN    ${code}
Verify billing data with appointment data
    [Arguments]    ${AptID}    ${PO_number}    ${mrn}    ${DX Code}    ${Date}    ${Units}    ${Route}    ${Medication}
    Check the 1st part    ${AptID}    ${PO_number}
    Check the 2nd part    ${AptID}    ${mrn}    ${DX Code}    ${Date}
    Check the 3rd part    ${Units}    ${Route}    ${Medication}    ${AptID}
Go to Billable Events
    [Arguments]    ${date}    ${AptID}    ${mrn}    ${accountid}    ${accountid1}
    Wait Until Keyword Succeeds    10 times    3s    Go Billable Events
    Wait For Condition    return document.readyState == "complete"    timeout=60s
    Title Should Be    Billable Event Ledger
    Dispense now.Filter By Location    ${accountid}    ${accountid1}
    Dispense now.Filter By patient    ${mrn}
    Dispense now.Filter By Date Range    ${date}
    Click Element    //*[contains(text(),'Search')]
    Wait for billing finish its loading
    ${MAX_PAGES}    Set Variable    5
    ${status}       Set Variable    ${False}
    FOR    ${i}    IN RANGE    ${MAX_PAGES}
        ${status}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    10 times    3s    Page Should Contain    ${AptID}
        Run Keyword If    ${status}    Exit For Loop
        Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[contains(text(),'Next')]
        Wait Until Keyword Succeeds    10 times    3s    Click Element    //*[contains(text(),'Next')]
        Wait for billing finish its loading
    END

Check the 1st part
    [Arguments]    ${AptID}    ${PO_number}
    Wait Until Keyword Succeeds    10 times    3s    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[1]
    ${Billing-PO-number}    Wait Until Keyword Succeeds    10 times    3s    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[1]//*[contains(text(),'Physician Order:')]/following-sibling::div
    Should Be Equal As Strings    ${PO_number}    ${Billing-PO-number}
Check the 2nd part
    [Arguments]    ${AptID}    ${mrn}    ${DX Code}    ${Date}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]/td/div/div[1]
    ${billing-mrn}    Get text after colon from xpath    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'MRN')]/parent::div
    Should Be Equal As Strings    ${mrn}    ${billing-mrn}
    ${Billing DX codes}    Get text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/descendant::tr[2]//*[contains(text(),'DX Code')]/parent::div
    @{Billing DX codes}    Split String    ${Billing DX codes}   ${SPACE}
    Should Be Equal As Strings    ${DX Code}    ${Billing DX codes}[3]
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]/td/div/div[2]
    ${Billing-date}    Get text after colon from xpath    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]//*[contains(text(),'Date of Service')]/parent::div
    Should Be Equal As Strings    ${Date}    ${Billing-date}
Check the 3rd part
    [Arguments]    ${Units}    ${Route}    ${Medication}    ${AptID}
    Scroll Element Into View    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]/td/div/div[4]
    ${Billing_Med_Vial_Route}    Get Text    //*[contains(text(),'${AptID}')]/ancestor::tbody[1]/tr[2]/td/div/div[4]/div[1]
    @{Billing_Med_Vial_Route}    Split String    ${Billing_Med_Vial_Route}    ${SPACE}-${SPACE}
    Should Be Equal As Strings    ${Medication}    ${Billing_Med_Vial_Route}[0]
    Should Be Equal As Strings    ${Units}    ${Billing_Med_Vial_Route}[1]
    Should Be Equal As Strings    ${Route.lower()}    ${Billing_Med_Vial_Route[2].lower()}
Open appointment
    Click Button    //*[contains(text(),'Open Appointment')]
    Wait Until Page Contains Element    //*[@id="SubModalPopup"]//*[contains(text(),'Warning - Opening Future Appointment')]    30
    Click Button    //*[contains(text(),'Yes / Continue')]
    Wait Until Page Contains Element    //*[@id="frm_AssignDosageToAppointment"]    30
Get data to Verify
   ${Patientid}    Get Text    //*[@id="findContentHeight"]/div[1]/div[1]/a
   ${DOB}    get text    //*[contains(text(),'DOB: ')]/following-sibling::strong
   ${Clinician}    get text    //*[contains(text(),'Clinician: ')]/following-sibling::strong
   ${PO-number}    Get Text    //*[contains(text(),'Physician Order:')]/following-sibling::div
   ${Provider}    Get provider
Get provider
    ${provider_list}    Get List Items     xpath=//*[@id="PhysicianName"]
    ${provider}    Evaluate    random.choice(@{provider_list})    modules=random
    Select From List By Label    xpath=//*[@id="PhysicianName"]    ${provider}
    RETURN    ${provider}
Wait for billing finish its loading
    Wait Until Page Does Not Contain element    //*[@class="BillingResultTable "]    30
    Wait Until Page Contains element    //*[@class="BillingResultTable "]    30

