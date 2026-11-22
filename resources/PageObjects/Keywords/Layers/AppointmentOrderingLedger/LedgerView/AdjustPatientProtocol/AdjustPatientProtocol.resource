*** Settings ***
Resource    ../../../Common/Common.resource

*** Variables ***




*** Keywords ***
Open Patient Protocol Popup
    [Arguments]    ${apt_datetime}
    ${apt_patient_protocol_icon}    Set Variable    //*[@class='DateOfServiceLabel']/following::hr[1]/preceding::strong[text()='${apt_datetime}']//following::a[@data-original-title='Protocol']
    Common.Scroll And Click Element    ${apt_patient_protocol_icon}
    Wait Until Page Contains    Adjust the protocol for this patient.    30s

Click Edit Patient Protocol Button
    ${edit_patient_protocol_btn}    Set Variable    //a[contains(@class,'EditPatientProtocolBtn')]
    Common.Scroll And Click Element    ${edit_patient_protocol_btn}

Select Frequency Value Of Lab Descirption In Patient Protocol Popup
    [Arguments]    ${lab_des_arg}    ${dict_arg}
    ${patient_protocol_frequency_value}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyValueDropdown')][1]
    ${patient_protocol_frequency_value_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${patient_protocol_frequency_value}
    Common.Choose Random Value From Select List    xpath_arg=${patient_protocol_frequency_value}    var_name=patient_protocol_frequency_value    dic=${dict_arg}
    IF    "${dict_arg.patient_protocol_frequency_value}" == "${patient_protocol_frequency_value_txt}"
        Select Frequency Value Of Lab Descirption In Patient Protocol Popup    ${lab_des_arg}    ${dict_arg}
    END

Select Frequency Unit Of Lab Descirption In Patient Protocol Popup
    [Arguments]    ${lab_des_arg}    ${dict_arg}
    ${patient_protocol_frequency_unit}    Set Variable    //strong[contains(text(),'${lab_des_arg}')]//following::select[contains(@id,'FrequencyUnitDropdown')][1]
    ${patient_protocol_frequency_unit_txt}    Wait Until Keyword Succeeds    30s    1s    Get Selected List Label    ${patient_protocol_frequency_unit}
    Common.Choose Random Value From Select List    xpath_arg=${patient_protocol_frequency_unit}    var_name=patient_protocol_frequency_unit    dic=${dict_arg}
    IF    "${dict_arg.patient_protocol_frequency_unit}" == "${patient_protocol_frequency_unit_txt}"
        Select Frequency Unit Of Lab Descirption In Patient Protocol Popup    ${lab_des_arg}    ${dict_arg}
    END

Click Close Patient Protocol Button
    Common.Close SubModal Popup