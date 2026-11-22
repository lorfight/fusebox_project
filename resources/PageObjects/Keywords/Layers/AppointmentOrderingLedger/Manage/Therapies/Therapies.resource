*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${therapies_location_select}    //select[@id="LocationID"]
${therapies_patient_select}    //select[@id="SelectedPatient"]
${available_account_therapies_table}    //div[@id="TherapyAccountManagementView"]
${therapies_accept_btn}    //button[text()='Accept']
${therapies_close_btn}    //div[@id="ModalPopup"]//button[@id="CloseBtn" and text()='Close']

*** Keywords ***
Click Accept Button In Therapy Management Modal
    Common.Scroll And Click Element    ${therapies_accept_btn}









