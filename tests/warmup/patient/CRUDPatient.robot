*** Settings ***
Documentation      Verify Patient
Variables    ../../../resources/PageObjects/Locators/Patient.py
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/Patient.resource
Suite Setup    Suite Setup Keyword
Test Teardown    Sleep    3s
Suite Teardown    CommonKeywords.Close Browser Session
Library    DependencyLibrary
Default Tags    STG    Patient    Admin
*** Test Cases ***
Create Patient And Get Data To Verify
	[Documentation]   Verify that Create Patient And Get Data
	...    [AP-P001]_TC01
	[Tags]    Smoke    Regression    Patient
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Patient
    ...  report.label.story:Create Patient
    Patient.Create Patient    First_Name_arg=${first_Name}    Last_Name_arg=${last_Name}    DOB_arg=${DOB}    Weight_arg=${weight}    Height_arg=${height}
    Patient.Check Patient Created

Update Patient
    [Documentation]   Update Patient
	...    [AP-]
	[Tags]    Smoke    Patient
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Patient
    ...  report.label.story:Update Patient
    Depends On Test    Create Patient And Get Data To Verify
    Patient.Update Patient
    Set Suite Variable    ${PatientData}

Delete Patient And Verify
	[Documentation]   Verify that Delete Patient And Verify
	...    [AP-P003]_TC03    [AP-P003]_TC04
	[Tags]    Smoke    Regression    Patient
    ...  report.label.owner:Vu Nguyen
    ...  report.label.severity:normal
    ...  report.label.epic:Appointment
    ...  report.label.feature:Patient
    ...  report.label.story:Delete Patient
    Patient.Go To Patients Page
    Patient.Delete Patient    xpath_arg=${Patient_MRN_Text}    Merge_MRN_arg=${PatientData.MRN}
    Patient.Check Patient Deleted
    Click Button    ${Patients_Clear_Btn}

*** Keywords ***
Suite Setup Keyword
    Setup Data
    LoginKeywords.Login To Fusebox    ${Username}    ${Password}
    Maximize Browser Window
	Sleep    3s
    Patient.Create Dictionary Of Patient Data
    Patient.Go To Patients Page
    Patient.Filter Location In Patients Page    Location_arg=${location_inventory}
    Set To Dictionary    ${PatientData}    Location=${location_inventory}    Location_ID=${location_ID}
    Patient.Check Patient In Patients Page    MRN_arg_1=${MRN_1}    MRN_arg_2=${MRN_2}    MRN_arg_3=${MRN_merge}   #MRN_arg_3 to be merged
    # Setup Data
    
Setup Data
    ${data_input}    Get Data    #
    Set Suite Variable    ${location_inventory}    ${data_input}[location_inventory]    #QCA1
    Set Suite Variable    ${location_ID}    ${data_input}[location_ID]    #113464
    Set Suite Variable    ${MRN_1}    ${data_input}[MRN_1]    #01010
    Set Suite Variable    ${MRN_2}    ${data_input}[MRN_2]    #09090
    Set Suite Variable    ${MRN_merge}    ${data_input}[MRN_merge]    #08080
    Set Suite Variable    ${first_Name}    ${data_input}[first_name]    #Autotest
    Set Suite Variable    ${last_Name}    ${data_input}[last_name]    #Patient
    Set Suite Variable    ${DOB}    ${data_input}[DOB]    #01/01/1974
    Set Suite Variable    ${weight}    ${data_input}[weight]    #29    #weight: kgs
    Set Suite Variable    ${height}    ${data_input}[height]    #2.9    #height: in