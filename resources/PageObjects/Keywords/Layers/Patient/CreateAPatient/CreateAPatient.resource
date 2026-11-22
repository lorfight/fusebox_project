*** Settings ***
Resource    ../../PatientInformation/PatientInformation.resource

*** Variables ***

*** Keywords ***
Create Patient With Full Info
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    Fill In And Select All Fields     ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    Click Save Patient Button
    Click Update Patient Button

Create Patient With Necessary Fields
    [Arguments]    ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    Input Valid Data In Necessary Fields    ${mrn_arg}    ${refering_provider_arg}    ${dict_arg}
    Click Save Patient Button
    Click Update Patient Button
