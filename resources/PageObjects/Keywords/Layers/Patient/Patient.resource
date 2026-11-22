*** Settings ***
Resource   PatientList/PatientList.resource
Resource   CreateAPatient/CreateAPatient.resource
Resource   UpdateAPatient/UpdateAPatient.resource

*** Keywords ***
Create Patient With All Information
    [Arguments]    ${location_arg}    ${mrn_arg}    ${mrn_merge_arg}    ${refering_provider_arg}
    &{PatientCreate}    Create Dictionary
    PatientList.Go To Patients Page
    PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
    ${check_alert_visible}    Delete Patient In Patient Information    ${mrn_arg}
    IF    '${check_alert_visible}' == '${False}'
        PatientList.Go To Patients Page
        PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_merge_arg}    location_arg=${location_arg}
        Create Merged Patient If Not Available    mrn_merge_arg=${mrn_merge_arg}
        PatientList.Open Patient Merge Helper Popup
        ${check_merged}    PatientMerge.Megre Patient In Patient Merge Helper    removing_mrn_arg=${mrn_arg}    keeping_mrn_arg=${mrn_merge_arg}
        IF    "${check_merged}" == "${False}"    
            PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
            ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${mrn_arg}']/preceding::td[2]//a
            Wait Until Element Is Not Visible    ${patient_mrn_row}    3s
        END
    END
    PatientList.Go To Patients Page
    PatientList.Select Location In Patient List    ${location_arg}
    PatientList.Go To Create New Patient Page
    CreateAPatient.Create Patient With Full Info    ${mrn_arg}    ${refering_provider_arg}    ${PatientCreate}
    RETURN    ${PatientCreate}

Create Patient With Necessary Information
    [Arguments]    ${location_arg}    ${mrn_arg}    ${mrn_merge_arg}    ${refering_provider_arg}
    &{PatientCreate}    Create Dictionary
    PatientList.Go To Patients Page
    PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
    ${check_alert_visible}    Delete Patient In Patient Information    ${mrn_arg}
    IF    '${check_alert_visible}' == '${False}'
        PatientList.Go To Patients Page
        PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_merge_arg}    location_arg=${location_arg}
        Create Merged Patient If Not Available    mrn_merge_arg=${mrn_merge_arg}
        PatientList.Open Patient Merge Helper Popup
        ${check_merged}    PatientMerge.Megre Patient In Patient Merge Helper    removing_mrn_arg=${mrn_arg}    keeping_mrn_arg=${mrn_merge_arg}
        IF    "${check_merged}" == "${False}"    
            PatientList.Filter Patient In Patient Page    mrn_arg=${mrn_arg}    location_arg=${location_arg}
            ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${mrn_arg}']/preceding::td[2]//a
            Wait Until Element Is Not Visible    ${patient_mrn_row}    3s
        END
    END
    PatientList.Go To Patients Page
    PatientList.Select Location In Patient List    ${location_arg}
    PatientList.Go To Create New Patient Page
    CreateAPatient.Create Patient With Necessary Fields    mrn_arg=${mrn_arg}    refering_provider_arg=${refering_provider_arg}    dict_arg=${PatientCreate}
    RETURN    ${PatientCreate}

Create Merged Patient If Not Available
    [Arguments]    ${mrn_merge_arg}
    ${patient_mrn_row}    Set Variable    xpath=//*[@class='table table-bordered']//th[contains(text(),'MRN')]/following::td[text()='${mrn_merge_arg}']/preceding::td[2]//a
    ${check_mrn_visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${patient_mrn_row}    3s    
    IF    "${check_mrn_visible}" == "${False}"
        PatientList.Go To Create New Patient Page
        ${Fake_dict}    Generate Fake Data    first_name    last_name    dob
        Input First Name In Patient Information    ${Fake_dict['first_name']}
        Input Last Name In Patient Information    ${Fake_dict['last_name']}
        Input MRN In Patient Information    ${mrn_merge_arg}  
        Input DOB In Patient Information    ${Fake_dict['dob']}
        Wait Until Keyword Succeeds    30    1s    Select From List By Label    ${gender_select}    Male
        Click Save Patient Button
        Click Update Patient Button
    END
