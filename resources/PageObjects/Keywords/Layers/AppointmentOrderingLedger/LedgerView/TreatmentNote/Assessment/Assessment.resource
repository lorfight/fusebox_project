*** Settings ***
Resource    ../../../../Common/Common.resource

*** Variables ***
${assessment_tab}    //form[@id='frm_AssignDosageToAppointment']//a[contains(text(),'Assessment')]
${assessment_title}    //h2[contains(text(),'Assessment')]
${assessment_starttime_input}    //input[@id="AssessmentStartTime"]
${assessment_weight}    //input[@id='AssessmentWeight']
${assessment_weight_title}    //h4[contains(text(),'Enter Weight')]
${assessment_weight_pounds}    //input[@id="LBs"]
${assessment_weight_kilograms}    //input[@id='KGs']


${assessment_height}    //input[@id='AssessmentHeight']
${assessment_height_title}    //h4[contains(text(),'Enter Height')]
${assessment_height_ft}    //input[@id='PatientHeightFeet']
${assessment_height_inch}    //input[@id='PatientHeightInches']
${assessment_last_treatment_weight}    //strong[text()='LAST TREATMENT WEIGHT: ']//following-sibling::span
${assessment_bmi}    //span[@id='assessment-bmi']
${assessment_bsa}    //span[@id='assessment-bsa']
${assessment_accept_btn}    //button[contains(text(),'Accept')]
${assessment_starttime_picker}    //div[@class="ui-timepicker-wrapper"]//li[@class="ui-timepicker-am ui-timepicker-selected"]

${apt_pain_scale_select}    //label[contains(text(),"Pain Scale")]//following::select[@id="symptomRating"]

*** Keywords ***
Create Treatment Note Assessment Dictionary
    &{Assessment_dict}    Create Dictionary
    RETURN    ${Assessment_dict}

Go To Assessment
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${assessment_tab}
    Wait Until Element Is Visible    ${assessment_title}    30s

Input Appointment Start Time In Assessment
    ${apt_starttime_value}    Evaluate    f"{random.randint(0,23):02d}{random.randint(0,59):02d}"    modules=random
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${assessment_starttime_input}    ${apt_starttime_value}
    Press Keys    ${assessment_starttime_input}    RETURN

Get Weight Value In Assessment
    Wait Until Element Is Visible    ${assessment_weight}    30s
    Scroll Element Into View    ${assessment_weight}
    ${assessment_weight_value}    Get Value    ${assessment_weight}
    RETURN    ${assessment_weight_value}

Get Weight Pounds In Assessment
    Wait Until Element Is Visible    ${assessment_weight_pounds}    30s
    ${assessment_weight_pounds_value}    Get Value    ${assessment_weight_pounds}
    RETURN    ${assessment_weight_pounds_value}

Get Weight Kilograms In Assessment
    Wait Until Element Is Visible    ${assessment_weight_kilograms}    30s
    ${assessment_weight_kilograms_value}    Get Value    ${assessment_weight_kilograms}
    RETURN    ${assessment_weight_kilograms_value}

Get Weight Value In Enter Weight Popup
    FOR    ${i}    IN RANGE    10
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${assessment_weight}
        ${visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${assessment_weight_title}    5s
        Exit For Loop If    ${visible} == True
    END
    ${assessment_weight_pounds_value}    Get Weight Pounds In Assessment
    ${assessment_weight_kilograms_value}    Get Weight Kilograms In Assessment
    Common.Close SubModal Popup
    RETURN    ${assessment_weight_pounds_value}    ${assessment_weight_kilograms_value}

Get Height Value In Assessment
    Wait Until Element Is Visible    ${assessment_height}    30s
    ${assessment_height_value}    Get Value    ${assessment_height}
    RETURN    ${assessment_height_value}

Get Height Feet In Assessment
    Wait Until Element Is Visible    ${assessment_height_ft}    30s
    ${assessment_height_ft_value}    Get Value    ${assessment_height_ft}
    RETURN    ${assessment_height_ft_value}

Get Height Inches In Assessment
    Wait Until Element Is Visible    ${assessment_height_inch}    30s
    ${assessment_height_inch_value}    Get Value    ${assessment_height_inch}
    RETURN    ${assessment_height_inch_value}

Get Height Value In Enter Height Popup
    FOR    ${i}    IN RANGE    10
        Wait Until Keyword Succeeds    30s    1s    Click Element    ${assessment_height}
        ${visible}    Run Keyword And Return Status    Wait Until Element Is Visible    ${assessment_height_title}    5s
        Exit For Loop If    ${visible} == True
    END
    ${assessment_height_ft_value}    Get Height Feet In Assessment
    ${assessment_height_inch_value}    Get Height Inches In Assessment
    Common.Close SubModal Popup
    RETURN    ${assessment_height_ft_value}    ${assessment_height_inch_value}

Get Last Treatment Weight Value In Assessment
    Wait Until Element Is Visible    ${assessment_last_treatment_weight}    30s
    ${assessment_last_treatment_weight_value}    Get Value    ${assessment_last_treatment_weight}
    RETURN    ${assessment_last_treatment_weight_value}

Get BMI Value In Assessment
    Wait Until Element Is Visible    ${assessment_bmi}    30s
    ${assessment_bmi_value}    Get Text    ${assessment_bmi}
    RETURN    ${assessment_bmi_value}

Get BSA Value In Assessment
    Wait Until Element Is Visible    ${assessment_bsa}    30s
    ${assessment_bsa_value}    Get Text    ${assessment_bsa}
    RETURN    ${assessment_bsa_value}

Click Accept Button
    Common.Scroll And Click Element    ${assessment_accept_btn}

Get Data In Assessment
    Go To Assessment
    ${Assessment_dict}    Create Treatment Note Assessment Dictionary
    ${assessment_weight_value}    Get Weight Value In Assessment
    ${assessment_height_value}    Get Height Value In Assessment
    ${assessment_height_ft_value}    ${assessment_height_inch_value}    Get Height Value In Enter Height Popup
    ${assessment_bmi_value}    Get BMI Value In Assessment
    ${assessment_bsa_value}    Get BSA Value In Assessment
    
    Set To Dictionary    ${Assessment_dict}    
        ...    assessment_weight_value=${assessment_weight_value}    
        ...    assessment_height_value=${assessment_height_value}    
        ...    assessment_bmi_value=${assessment_bmi_value}    
        ...    assessment_bsa_value=${assessment_bsa_value}
        ...    assessment_height_ft_value=${assessment_height_ft_value}    
        ...    assessment_height_inch_value=${assessment_height_inch_value}

    RETURN    ${Assessment_dict}

Select Pain Scale In The Assessment Tab
    [Arguments]    ${dict_arg}
    Wait Until Element Is Visible    ${apt_pain_scale_select}    30s
    Scroll Element Into View    ${apt_pain_scale_select}
    Common.Choose Random Value From Select List    xpath_arg=${apt_pain_scale_select}    var_name=apt_pain_scale_select    dic=${dict_arg}
    Common.Page Alert Message    Updated successfully!

Input Appointment Start Time In Assessment Modal 
    ${hour}    Evaluate    str(random.randint(1,23)).zfill(2)    random
    ${minute}    Evaluate    str(random.randint(0,59)).zfill(2)    random
    ${starttime_value}    Set Variable    ${hour}${minute}
    Wait Until Keyword Succeeds    30s    1s    Input Text    ${assessment_starttime_input}    ${starttime_value}
    Press Keys    NONE    TAB
    RETURN    ${starttime_value}






