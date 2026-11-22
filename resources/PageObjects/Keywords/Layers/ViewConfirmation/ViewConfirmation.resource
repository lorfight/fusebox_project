*** Settings ***
Resource    ../../../../../libraries/Util.resource

*** Keywords ***
Vendor Contact
    [Arguments]    ${vendor_contact}=Customer Service - Phone
    Wait Until Page Contains Element    id=VendorContact    error=Vendor Contact element isn't available
    Select From List By Label    id=VendorContact    ${vendor_contact}
    Waiting For Loading

View Confirmation PDF
    ${view_confirmation_pdf}    Get Element Attribute    //*[@onClick="ViewConfirmationPDF();"]    onClick
    Execute Javascript    ${view_confirmation_pdf}
    Waiting For Loading

Generate Confirmation Email
    Waiting For Loading
    Scroll Element Into View    //*[@onClick="SendConfirmationEmail();"]
    ${generate_confirmation_email}    Get Element Attribute    //*[@onClick="SendConfirmationEmail();"]    onClick
    Execute Javascript    ${generate_confirmation_email}
    Waiting For Loading

Send Confirmation Email
    Send Mail
    Close Modal Popup

Send Mail
    Waiting For Loading
    Wait Until Keyword Succeeds    3times    3s    Click Button    Send Email
    Handle Alert
    Wait Until Page Contains   Email Confirmation Successfully Sent!
    Waiting For Loading

Close Modal Popup
    Click Element    //*[@id="ModalPopup" and @aria-hidden="false"]//*[@id="CloseBtn"]
    Waiting For Loading