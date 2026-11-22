*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    XML
Library    String
Library    DateTime

Variables    ../../PageObjects/Locators/ProviderOrdersLocator.py    
Resource    ../../../resources/PageObjects/Keywords/ProviderOrders.resource

*** Keywords ***
Go To Provider Orders Page
    Click Element    //*[contains(@class, 'dropdown-toggle') and text()=' Dispensing ']
    Wait Until Element Is Visible    //*[contains(@class, 'dropdown open')]//*[contains(@class, 'dropdown-menu')]    20s
    Click Element    //*[contains(@class, 'dropdown-menu')]//*[text()='Provider Orders']
    Wait Until Element Is Visible    //h2[contains(text(), 'Provider Orders')]    10s

Create Provider Order
    [Arguments]    ${LOCATION}    ${MRN}    ${Drug_arg}    ${DX_arg}    ${referring}    ${Patient_Weight}    ${DosageAssigned}    ${DosageUnit}
    Click Element    ${CreatePriderOrder}
    Wait Until Element Is Visible    ${PO_header_text}    10s
    Click Button    //*[contains(@data-id, 'ModalAccountID')]
    Wait Until Element Is Visible    //*[@id="frm_CreateEditPatientOrderModal"]/div[1]/div[1]/div/div/div/div/div[2]/div/input    10s
    Input Text    //*[@id="frm_CreateEditPatientOrderModal"]/div[1]/div[1]/div/div/div/div/div[2]/div/input    ${LOCATION}
    Press Key    //*[@id="frm_CreateEditPatientOrderModal"]/div[1]/div[1]/div/div/div/div/div[2]/div/input    ENTER
    Input Text    ${SelectedPatient}    ${MRN}
    Click Element    //*[@class='tt-suggestion tt-selectable' and .//strong[text()='${MRN}']]
    ProviderOrders.Select Treatment Drug    ${Drug_arg}
    ProviderOrders.Click Diagnosis    ${DX_arg}
    Click Button    //*[@id="SaveBtn"]
    IF    //*[text()='EXISTING PROVIDER ORDER ALERT']
        Click Button    //*[text()='Accept & Continue']
        Input Text    ${ReferralPhysician}    ${referring}
        Input Text    ${HeightPO_input}    ${Patient_Weight}
        Click Element    ${Radiobuton_KG}
        ProviderOrders.Input Dose And Frequency    ${DosageAssigned}    ${DosageUnit}    ${DosageRoute}    ${DosageStrength}
    ELSE
        Log    No alert found, continue with the test case
    END

# Publish Provider Order
#     Click Button    ${PublishPO}
#     Wait Until Element Is Visible    ${SuccessMessage}    10s
#     Click Button    ${OKButton}
#     Wait Until Element Is Not Visible    ${SuccessMessage}    10s

            