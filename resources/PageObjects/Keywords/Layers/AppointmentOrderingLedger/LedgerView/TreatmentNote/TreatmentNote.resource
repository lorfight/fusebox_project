*** Settings ***
Resource    LastTreatment/LastTreatment.resource
Resource    Assessment/Assessment.resource
Resource    Access&Admin/Access&Admin.resource
Resource    Meds&Fluids/Meds&Fluids.resource
Resource    ProceduralDetails/ProceduralDetails.resource
Resource    PatientDischarge/PatientDischarge.resource
Resource    PostDCActivity/PostDCActivity.resource

*** Variables ***
${treatment_date_of_service}    //u[contains(text(),'DATE OF SERVICE:')]//following::dd[1]

*** Keywords ***
Create Treatment Note Dictionary
    &{TreatmentNote_dict}    Create Dictionary
    RETURN    ${TreatmentNote_dict}

Open Treatment Note Tab
    Wait Until Keyword Succeeds    30S    1    Scroll Element Into View    //*[@id='EncounterNote']
    Common.Scroll And Click Element    //*[@id='EncounterNote']
    Common.Element Is Not Visible    //*[@id='EncounterNoteTab']//*[contains(@class,'fa-spinner')]

Get Date Of Service Text
    Wait Until Element Is Visible    ${treatment_date_of_service}    30s
    ${treatment_date_of_service_txt}    Wait Until Keyword Succeeds    30s    1s    Get Text    ${treatment_date_of_service}
    ${treatment_date_of_service_txt}    Get Regexp Matches    ${treatment_date_of_service_txt}    \\d{2}/\\d{2}/\\d{2}
    ${treatment_date_of_service_txt}    Set Variable    ${treatment_date_of_service_txt}[0]
    RETURN    ${treatment_date_of_service_txt}

Get Treatment Clinician In The Treatment Note Tab
    ${treatment_clinician_select}    Set Variable    //select[@id="NurseId"]
    Scroll Element Into View    ${treatment_clinician_select}
    Wait Until Element Is Enabled    ${treatment_clinician_select}    30s
    ${treatment_clinician_value}    SeleniumLibrary.Get Selected List Label    ${treatment_clinician_select}
    RETURN    ${treatment_clinician_value}

