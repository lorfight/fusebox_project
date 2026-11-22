*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***
${regiment_location_select}    //select[@id="RegimenAccountID"]
${regiment_medication_select}    //select[@id="RegimenMedication"]
${regiment_create_btn}    //a[@id="CreateModalRegimenBtn"]
${regiment_description_input}    //input[@id="CreateEditRegimenDesc"]
${regiment_maintenance_select}    //select[@id="ActivateRegimen_1"]
${regiment_save_btn}    //a[@onclick="SaveRegimen()"]

*** Keywords ***
Click Create Regimen Button
    Common.Scroll And Click Element    ${regiment_create_btn}

Select Account In Regimen Management Modal
    [Arguments]    ${location_arg}
    Wait Until Element Is Enabled    ${regiment_location_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${regiment_location_select}    ${location_arg}

Select Medication In Regimen Management Modal
    [Arguments]    ${medication_arg}
    Wait Until Element Is Enabled    ${regiment_medication_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${regiment_medication_select}    ${medication_arg}
    
Input Descirption In Regimen Management Modal
    [Arguments]    ${desc_arg}
    Wait Until Element Is Visible    ${regiment_description_input}    30s
    Common.Clear Input Field Until Empty    ${regiment_description_input}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${regiment_description_input}    ${desc_arg}

Select Maintenance In Regimen Management Modal
    [Arguments]    ${maintenance_arg}
    Wait Until Element Is Enabled    ${regiment_maintenance_select}    30s
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${regiment_maintenance_select}    ${maintenance_arg}

Click Save Button In Regimen Management Modal
    Common.Scroll And Click Element    ${regiment_save_btn}

Click Edit Button In Regimen Management Modal
    [Arguments]    ${desc_arg}
    ${edit_regemen_btn}    Set Variable    //h4[text()='${desc_arg}']//following::a[contains(@class,'EditRegimenModalBtn')]
    Common.Scroll And Click Element    ${edit_regemen_btn}

Click Delete Button In Regimen Management Modal
    [Arguments]    ${desc_arg}
    ${delete_regemen_btn}    Set Variable    //h4[text()='${desc_arg}']//following::a[contains(@class,'DeleteRegimenModalBtn')]
    Common.Scroll And Click Element    ${delete_regemen_btn}

Create Regimen
    [Arguments]    ${location_arg}    ${medication_arg}    ${desc_arg}    ${maintenance_arg}
    Select Account In Regimen Management Modal    ${location_arg}
    Select Medication In Regimen Management Modal    ${medication_arg}
    Click Create Regimen Button
    Input Descirption In Regimen Management Modal    ${desc_arg}
    Select Maintenance In Regimen Management Modal    ${maintenance_arg}
    Click Save Button In Regimen Management Modal
    Common.Page Alert Message    Successfully Created Regimen.

Edit Regimen
    [Arguments]    ${desc_create_arg}    ${desc_update_arg}
    Click Edit Button In Regimen Management Modal    ${desc_create_arg}
    Input Descirption In Regimen Management Modal    ${desc_update_arg}
    Click Save Button In Regimen Management Modal
    Common.Page Alert Message    Successfully Updated Regimen.

Delete Regimen
    [Arguments]    ${desc_arg}
    Click Delete Button In Regimen Management Modal    ${desc_arg}
    Alert Should Be Present    Are you sure you would like to delete the ${desc_arg} regimen?    ACCEPT    5s
    Common.Page Alert Message    ${desc_arg} regimen deleted.
    

