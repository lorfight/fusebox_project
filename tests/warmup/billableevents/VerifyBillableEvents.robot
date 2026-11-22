*** Settings ***
Library    SeleniumLibrary
Library    ../../../libraries/CustomLibrary.py
Library    OperatingSystem
Library    Collections

Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../billableevents/PageObjects/Keywords/BillableEvents.resource



Suite Setup    Set Up Suite
Suite Teardown    Close Browser
Task Tags    Smoke    Admin    EOB_100    eob    test:retry(2)    report.label.owner:Hieu Huynh

*** Test Cases ***

Vertify create Dispense Now appointment
    [Documentation]    Verify Billable Events works correctly
    ${check}    Run Keyword And Return Status    Scroll Element Into View    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
    IF    ${check} == ${True}
        Sleep    3s
        Wait Until Keyword Succeeds    10 times    3s    Click Button    //*[@id='ModalPopup']//*[@id='CloseBtn' and text()='Close']
        Wait Until Element Is Not Visible    id=ModalPopup    30s
    END
    ${PO_number}    ${Units}    ${Route}    ${Medication}    ${PA-DXcode}    ${Lot}    ${date}    ${time}    ${AptID}    Dispense now.Create dispense now appointment    ${accountid}    ${mrn}    ${Assign PO}    ${accountid1}
    Go to Billable Events    ${date}    ${AptID}    ${mrn}    ${accountid}    ${accountid1}
    Set Suite Variable    ${PO_number}    ${PO_number}
    Set Suite Variable    ${Units}    ${Units}
    Set Suite Variable    ${Route}    ${Route}
    Set Suite Variable    ${Medication}    ${Medication}
    Set Suite Variable    ${PA-DXcode}    ${PA-DXcode}
    Set Suite Variable    ${Lot}    ${Lot}
    Set Suite Variable    ${date}    ${date}
    Set Suite Variable    ${time}    ${time}
    Set Suite Variable    ${AptID}    ${AptID}

Verify Billable Events information   
    Verify billing data with appointment data    ${AptID}    ${PO_number}    ${mrn}    ${PA-DXcode}    ${Date}    ${Units}    ${Route}    ${Medication}
    Verify lines items are displayed right between 1500 and payer table    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

Verify Office Visit   
    Verify Office Visit    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

Verify length of time
    Set up length of time for CPT Code    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}    ${Cpt code office}
    
Verify add and remove lines item
    Add and remove lines item    ${AptID}    ${AddedCPT}    ${AddedUnits}    ${AddedHCPCS}    ${Root-CPT code}    ${Root-HCPCS}
    Clear and rebuild items    ${AptID}    ${Root-CPT code}    ${Root-HCPCS}

Verify Modifiers
    Choose random Modifiers    ${AptID}

Verify choosing provider
    Change billing provider information    ${AptID}

Verify DXcodes 
    Add and remove DXcodes    ${date}    ${AptID}    ${mrn}    ${DXcodes}    ${PA-DXcode}    ${accountid}    ${accountid1}

Verify choosing & removing payer
    Verify payer field work correctly    ${AptID}    ${PA payer name}

*** Keywords ***

Set Up Suite
    ${data_input}    Get Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Set Suite Variable    ${data_input}
    Set Suite Variable    ${Root-HCPCS}    ${data_input}[Root-HCPCS]
    Set Suite Variable    ${Root-CPT code}    ${data_input}[Root-CPT code]
    Set Suite Variable    ${DXcodes}    ${data_input}[DXcodes]
    Set Suite Variable    ${AddedCPT}    ${data_input}[AddedCPT]
    Set Suite Variable    ${AddedHCPCS}    ${data_input}[AddedHCPCS]
    Set Suite Variable    ${AddedUnits}    ${data_input}[AddedUnits]
    Set Suite Variable    ${Cpt code office}    ${data_input}[Cpt code office]
    Set Suite Variable    ${PA payer name}    ${data_input}[PA payer name]
    Set Suite Variable    ${accountid}    ${data_input}[accountid]
    Set Suite Variable    ${accountid1}    ${data_input}[accountid1]
    Set Suite Variable    ${mrn}    ${data_input}[mrn]
    Set Suite Variable    ${Assign PO}    ${data_input}[Assign PO]
