*** Settings ***
Resource    ../../PatientInformation/PatientInformation.resource

*** Keywords ***
Update All Info Patient
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}
    &{PatientUpdate}    Create Dictionary
    Fill In And Select All Fields    ${mrn_arg}    ${refering_provider_arg}    ${PatientUpdate}
    Verify Save Change Button Visible
    Click Update Patient Button
    RETURN    ${PatientUpdate}