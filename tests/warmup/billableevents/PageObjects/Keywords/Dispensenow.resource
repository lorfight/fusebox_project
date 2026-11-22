*** Settings ***
Library    Dialogs
Library    SeleniumLibrary
Library    ../../../../../libraries/CustomLibrary.py
Resource   ../../../../../resources/PageObjects/Keywords/Dispense.resource
*** Variables ***
# ${accountid}    QCA1
# ${mrn}    Billing Test
# ${Assign PO}    1
*** Keywords ***
Create dispense now appointment
    [Arguments]    ${accountid}    ${mrn}    ${Assign PO}    ${accountid1}
    Dispense.Go Dispensing
    Wait For Condition    return document.readyState == "complete"    timeout=60s
    Filter By Location    ${accountid}    ${accountid1}
    Open Dispense Now modal
    Reset appointment modal
    Input patient in dispense now    ${mrn}
    ${PO_number}    Assign PO    ${Assign PO}
    Approve Dosage
    ${date}    ${time}    Input datetime in dispense now
    ${Units}    ${Route}    ${Medication}    ${PA-DXcode}    Get appointment data
    ${Lot}    Choose Lot Number
    Sleep    2s
    Complete Dispense
    ${AptID}    Get Appointment ID    ${date}    ${time}    ${mrn}    ${accountid}    ${accountid1}
    RETURN    ${PO_number}    ${Units}    ${Route}    ${Medication}    ${PA-DXcode}    ${Lot}    ${date}    ${time}    ${AptID}
Get appointment ID
    [Arguments]    ${date}    ${time}    ${mrn}    ${accountid}    ${accountid1}
    Reload Page
    Wait For Condition    return document.readyState == "complete"    timeout=60s
    Filter By Location    ${accountid}    ${accountid1}
    Wait Until Keyword Succeeds    10 times    3s    Filter By Date Range    ${date}
    Filter By Patient    ${mrn}
    ${view}    Get text    //*[@id="appointmentViewsDropdown"]
    IF    '${view}' == 'Ledger View'
        No Operation
    ELSE
        Click element    id=appointmentViewsDropdown
        click element    //*[contains(text(),'Ledger View')]
    END 
    Wait Until Page Contains Element    //*[contains(text(),'Search')]    30s
    Click Element    //*[contains(text(),'Search')]
    Wait for calendar view loading
    Wait Until Element Is Visible    //*[@id="AppointmentList"]
    ${MAX_PAGES}    Set Variable    5
    FOR    ${i}    IN RANGE    ${MAX_PAGES}
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //tr[td[div[strong[text()="${date}"]] and div[strong[text()="${time}"]]]]/td[1]/div[1]    10
        Run Keyword If    ${status}    Exit For Loop
        Click Element    //*[@class="pager-navigation"]/*[contains(text(),'Next')]
        Wait for Loading
    END
    Wait until page contains element    //tr[td[div[strong[text()="${date}"]] and div[strong[text()="${time}"]]]]/td[1]/div[1]    10
    ${AptID}    Get Text    //tr[td[div[strong[text()="${date}"]] and div[strong[text()="${time}"]]]]/td[1]/div[1]
    RETURN    ${AptID}

Complete Dispense
    Click Element     //*[contains(text(),' Complete Dispense')]
    ${status}    Run Keyword And Return Status    Alert Should Be Present    Are you sure you would like to dispense to this appointment? Inventory will be altered.    accept
    IF    ${status} == ${True}
        ${status1}    Run Keyword And Return Status    Wait for complete dispensed
        IF    ${status1} == ${False}
            ${status1}    Run Keyword And Return Status    Check expired lot modal
            IF    ${status1} == ${False}
                Check total vial modal
                Run Keyword And Ignore Error    Check expired lot modal
                Wait for complete dispensed
            END
            Run Keyword And Ignore Error    Check total vial modal
            Wait for complete dispensed
        END
    ELSE
        ${status1}    Run Keyword And Return Status    Check expired lot modal
        IF    ${status1} == ${False}
            Check total vial modal
            Run Keyword And Ignore Error    Check expired lot modal
            Wait for complete dispensed
        END
        Run Keyword And Ignore Error    Check total vial modal
        Wait for complete dispensed
    END
Wait for complete dispensed
    Wait Until Page Contains Element    //*[contains(text(),'Dispensed from')]    60
Check total vial modal
    Wait Until Element Is Visible    //*[@class="modal-dialog"]//*[contains(text(),' - Check Total Dispense Amount')]
    Select From List By Index    //*[@id="DiscrepancyDropdownReason"]    1
    Click Element    //*[@id="DispenseConflictAppointmentID"]/ancestor::div/following-sibling::div/*[contains(text(),'Continue')]
    Alert Should Be Present    Are you sure you would like to dispense to this appointment? Inventory will be altered.    accept

Check expired lot modal
    Wait Until Element Is Visible    //*[@id="frm_AppointmentDispenseConflictAlertModal"]//*[contains(text(),'EXPIRED')]
    Click Element    //*[@id="frm_AppointmentDispenseConflictAlertModal"]/ancestor::div/following-sibling::div/*[contains(text(),'Accept & Dispense')]
    Alert Should Be Present    Are you sure you would like to dispense to this appointment? Inventory will be altered.    accept

Choose Lot Number
    Select From List By Index  //*[@name="LotID"]  2        
    ${Lot}    Get Selected List Label    //*[@name="LotID"]
    RETURN    ${Lot}
Get appointment data
    ${PO}      Get Selected List Label    //*[@id="appointmentTherapy"]
    ${Medication}    Get Medication    ${PO}
    ${Units}    Get text after colon from xpath    //*[contains(text(),'Dosage:')]/parent::*
    ${Route}    Get text after colon from xpath    //*[contains(text(),'Route:')]/parent::*
    ${PA-DXcode}    Get Text    //*[contains(text(),'Assigned DX Code')]/following-sibling::a
    RETURN    ${Units}    ${Route}    ${Medication}    ${PA-DXcode}    
Get text after colon from xpath
    [Arguments]    ${Xpath}
    ${Text}    Get Text    ${Xpath}
    ${match}    Split String    ${Text}    :    -1
    ${string}    Convert To String    ${match}[1]
    ${string}    Strip String    ${string}
    RETURN    ${string}
Input datetime in dispense now
    ${date}    Get Current Date    result_format=%m/%d/%Y
    ${time}    Get Current Date    result_format=%#I:%M %p
    Input Text    //*[@id="RequireDate"]    ${date}
    click element  //*[@id="ui-datepicker-div"]/div[5]/button[2]
    Wait Until Page Contains Element    //*[contains(text(),'Information Successfully Assigned to Appointment.')]    10
    Wait Until Page Does Not Contain Element    //*[contains(text(),'Information Successfully Assigned to Appointment.')]    10
    Input Text    //*[@id="RequireTimeStart"]    ${time}
    Click Element    //*[contains(text(),'New Start Time')]
    Wait Until Page Contains Element    //*[contains(text(),'Information Successfully Assigned to Appointment.')]    10
    Wait Until Page Does Not Contain Element    //*[contains(text(),'Information Successfully Assigned to Appointment.')]    10
    RETURN    ${date}    ${time}
Approve Dosage
    Wait Until Page Contains Element    //*[contains(text(),'Approve Container Sizes ')]    120
    Scroll Element Into View    //*[contains(text(),'Approve Container Sizes ')]
    Sleep    5s
    Click Element     //*[contains(text(),'Approve Container Sizes ')]
    Wait Until Page Contains Element   //*[contains(text(),'Scan or check off items as you dispense them to the patient.')]    120
Reset appointment modal
    Scroll Element Into View    //*[contains(text(),'Reset Quick Dispense')]
    Wait Until Element Is Enabled    //*[contains(text(),'Reset Quick Dispense')]    30s    
    Click Element    //*[contains(text(),'Reset Quick Dispense')]
    Alert Should Be Present    Are you sure you would like to restart this Quick Dispense? You will lose all progress if you do.      accept    timeout=30
    # Wait Until Page Does Not Contain Element    //*[contains(text(),'No Primary Medications Assigned to this Appointment.')]    30    
    Wait Until Page Contains Element    //*[contains(text(),'No Primary Medications Assigned to this Appointment.')]    30
    Sleep    2

Assign PO
    [Arguments]    ${Assign PO}
    Execute JavaScript    document.activeElement.blur()
    SeleniumLibrary.Wait Until Element Is Enabled    locator=//*[@id="appointmentTherapy"]    timeout=30s
    Wait Until Keyword Succeeds    10 times    3s    Select From List By Index    //*[@id="appointmentTherapy"]    ${Assign PO}
    Click Element    //*[@id="ModalPopup"]
    Wait for Loading
    Get Text    //*[@id="appointmentTherapy"]
    ${PO}    Get Selected List label    //*[@id="appointmentTherapy"]
    ${PO_number}    Get PO number    ${PO}  
    RETURN    ${PO_number}
Open Dispense Now modal
    Click Element    //*[contains(text(),'Dispense Now')]
    ${check}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[@id="frm_QuickDispenseModal"]    60
    IF    ${check} == ${False}
        Click Element    //*[contains(text(),'Dispense Now')]
        Wait Until Element Is Visible    //*[@id="frm_QuickDispenseModal"]    60
    END
    
Filter By Location
    [Arguments]    ${accountid}    ${accountid1}
    ${status}    Run Keyword And Return Status     Wait Until Keyword Succeeds    5x    500ms    Select From List By Label   //*[@id="MemberId"]    ${accountid}
    Run Keyword If    $status == ${False}    Wait Until Keyword Succeeds    5x    500ms    Select From List By Label   //*[@id="MemberId"]    ${accountid1}
Input patient in dispense now
    [Arguments]    ${mrn}
    Wait Until Page Contains Element    //*[contains(text(),'No Primary Medications Assigned to this Appointment.')]
    Input text    //*[@id='QuickSelectedPatient']    ${mrn}
    Wait Until Element Is Visible    //*[@class="tt-suggestion tt-selectable"]//*[contains(text(),'${mrn}')]    60
    Click Element    //*[@class="tt-suggestion tt-selectable"]//*[contains(text(),'${mrn}')]
    Click Element    //*[@id="ModalPopup"]
    Wait Until Element Is Visible    //*[contains(text(),'Select A Therapy')]    30
    Wait for Loading
    
Get PO number
    [Arguments]    ${text}
    ${list}=    Split String    ${text}    \ \-\     -1
    ${po_number1}   Split String    ${list}[1]    (     -1
    ${po_number2}   Split String    ${po_number1}[1]    )     -1
    ${po_number}  Convert To String    ${po_number2}[0]
    RETURN   ${po_number}
Get Medication
    [Arguments]    ${text}
    ${match}=    Split String    ${text}    \ \-\     -1
    ${text}   Split String    ${match}[3]    [     -1
    ${text}   Split String    ${text}[1]    ]     -1
    ${new}  Convert To String    ${text}[0]
    ${new}  Strip String    ${new}
    RETURN    ${new}
Wait for Loading
    # Wait Until Page Contains Element    //*[@class="ajax-loader"]    30
    Wait Until Page Does Not Contain Element    //*[@class="ajax-loader"]    30
Filter By Date Range
    [Arguments]    ${date}
    Input Text    //*[@id='StartDate']    ${date}
    Input Text    //*[@id='EndDate']    ${date}
    Wait Until Element Is Visible    //*[contains(text(),'Done')]
    Run Keyword And Ignore Error    Click Element    //*[contains(text(),'Done')]
Filter By patient
    [Arguments]    ${mrn}
    Click element    //button[contains(@class,'patientClearButton')]
    Input Text    //*[@id[contains(., 'PatientId')]]    ${mrn}
    Wait Until Page Contains Element    //*[contains(text(),'${mrn}')]    30
    ${status}    Run Keyword And Return Status    Click Element    //*[contains(text(),'${mrn}')]
    IF    ${status} == ${False}
        FOR    ${i}    IN RANGE    1    10
            Wait Until Page Contains Element    (//*[contains(text(),'${mrn}')])[${i}]    timeout=60s
            ${status}    Run Keyword And Return Status    Click Element    (//*[contains(text(),'${mrn}')])[${i}]
            IF    ${status} == ${True}
                Exit For Loop
            END
        END        
    END
Wait for calendar view loading
    Wait Until Page Contains Element    //*[contains(text(),'Open Appointment')]    30
