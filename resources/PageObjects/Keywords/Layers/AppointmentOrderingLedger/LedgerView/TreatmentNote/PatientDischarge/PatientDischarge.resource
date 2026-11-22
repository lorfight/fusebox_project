*** Settings ***
Resource    ../../../../Common/Common.resource

*** Variables ***


*** Keywords ***
Go To Patient Discharge
    Wait Until Keyword Succeeds    30s    1s    Click Element    //form[@id='frm_AssignDosageToAppointment']//a[contains(text(),'Patient Discharge')]
    Wait Until Element Is Visible    //h2[contains(text(),'Patient Discharge')]    30s

Input Appointment Stop Time In Patient Discharge Modal
    [Arguments]    ${starttime_value}
    ${hour}    Evaluate    str(random.randint(1,23)).zfill(2)    random
    ${minute}  Evaluate    str(random.randint(0,59)).zfill(2)    random
    ${endtime_value}    Set Variable    ${hour}${minute}
    IF    "${starttime_value}" < "${endtime_value}"
        Wait Until Keyword Succeeds    30s    1s    Input Text    //input[@id="endTime"]    ${endtime_value}
        Press Keys    NONE    TAB
        RETURN    ${endtime_value}
    ELSE
        Input Appointment Stop Time In Patient Discharge Modal    ${starttime_value}
    END

Get Treatment Duration Value
    Wait Until Element Is Visible    //input[@id="TimeAdminCalculation"]    30s
    ${treatment_duration_value}    Wait Until Keyword Succeeds    30s    1s    SeleniumLibrary.Get Value    //input[@id="TimeAdminCalculation"]
    RETURN    ${treatment_duration_value}



