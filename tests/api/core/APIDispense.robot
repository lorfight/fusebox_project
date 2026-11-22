*** Settings ***
Documentation      Dispense
Resource    ../../../resources/ApiObjects/Keywords/Dispense.resource
Resource    ../../../resources/ApiObjects/Keywords/Billing.resource
Suite Setup    Suite Setup
Test Setup    Test Setup
# Suite Teardown    Suite Teardown
*** Variables ***

    
*** Test Cases ***
Sending Request To Dispense With All Field But Type Empty
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O2
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field_list}    Create List    appointment.type
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field_list}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request To Dispense But EmrAppointmentID Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_01
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    emrAppointmentID    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["emrAppointmentID"][0]}
    ${error}    Set Variable    The EMRAppointmentID field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But StartTime Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_03
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.startTime    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.StartTime"][0]}
    ${error}    Set Variable    The StartTime field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But PrimaryMedication Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_04
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.primaryMedication    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.PrimaryMedication"][0]}
    ${error}    Set Variable    The PrimaryMedication field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But PatientMRN Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_05
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.patientMRN    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.PatientMRN"][0]}
    ${error}    Set Variable    The PatientMRN field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But FirstName Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_06
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.patient.firstName    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.Patient.FirstName"][0]}
    ${error}    Set Variable    The FirstName field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But LastName Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_07
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.patient.lastName    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.Patient.LastName"][0]}
    ${error}    Set Variable    The LastName field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But Dob Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_08
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.patient.dob    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.Patient.DOB"][0]}
    ${error}    Set Variable    The DOB field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But Gender Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_09
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    appointment.patient.gender    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["appointment.Patient.Gender"][0]}
    ${error}    Set Variable    The Gender field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But MedicationDispenses Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_010
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    medicationDispenses    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["medicationDispenses"][0]}
    ${error}    Set Variable    The MedicationDispenses field is required.
    Should Be Equal    ${response_error}    ${error}  
Sending Request To Dispense But NDC Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_011
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    medicationDispenses[0].ndc    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["medicationDispenses[0].NDC"][0]}
    ${error}    Set Variable    The NDC field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But LotNumber Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_011
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    medicationDispenses[0].lotNumber    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["medicationDispenses[0].LotNumber"][0]}
    ${error}    Set Variable    The LotNumber field is required.
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But LotExpirationDate Field Missing
    [Documentation]        
    ...    [ Appointment Dispensing Api]_BS1
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${removed_field}    Create List    medicationDispenses[0].lotExpirationDate    
    Sending Body Request With All Dispense Fields
    ...    removed_field_list_arg=${removed_field}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["medicationDispenses[0].LotExpirationDate"][0]}
    ${error}    Set Variable    The LotExpirationDate field is required.
    Should Be Equal    ${response_error}    ${error}         
Sending Request Out Of Range Some Field
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O0
    ...    [ Appointment Dispensing Api]_O13    [ Appointment Dispensing Api]_O14    
    ...    [ Appointment Dispensing Api]_O15    [ Appointment Dispensing Api]_O16    
    [Tags]
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen    
    ${medicine_have_field_quantity_wrong}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=51
    ...    barcodes=${medicine_primary.barcodes}
    ${list_medicine_have_field_quantity_wrong}    Create List    ${medicine_have_field_quantity_wrong}
    Sending Body Request With All Dispense Fields   
    ...    dose_arg=1000001
    ...    patient_mrn_arg=${appointment_dispense_dict.rand_str_51}
    ...    first_name_arg=${appointment_dispense_dict.rand_str_51}
    ...    last_name_arg=${appointment_dispense_dict.rand_str_51}
    ...    medication_arg=${list_medicine_have_field_quantity_wrong}
    ...    expected_status=400
    ${reponse_json_errors}    Set Variable    ${appoinment_dispensing_response_json["errors"]}
    Validate JSON List Errors    ${reponse_json_errors}    ${errors_out_range}        

Sending Request To Dispense With TreatmentStartTime TreatmentEndTime Swap Together
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O20, [ Appointment Dispensing Api]_O21
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    ...    treatment_start_time_arg=${treatment_next_date}
    ...    treatment_end_time_arg=${treatment_start_date}
    ...    expected_status=400
    ${response_errors_json}    Set Variable    ${appoinment_dispensing_response_json["errors"]}
    Validate JSON List Errors    ${response_errors_json}    ${errors_start_end_time}    
  
Sending Request To Dispense With WasteDose Greater
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O18
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${waste_dose_large}    Evaluate    ${medicine_primary.wasteDose} + 100
    ${medicine_have_field_wrong_waste_dose}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${waste_dose_large}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${list_medicine_have_field_wrong_waste_dose}    Create List    ${medicine_have_field_wrong_waste_dose}
    Sending Body Request With All Dispense Fields   
    ...    medication_arg=${list_medicine_have_field_wrong_waste_dose}
    ...    expected_status=400  
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The waste dose (${waste_dose_large}) must be less than the base quantity per unit of the medication
    Should Contain    ${response_error}    ${error} 
Sending Request To Dispense With Barcode Larger Than Quantity
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O19
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${barcodes}    Create List    ${medicine_primary.barcodes}[0]    ${medicine_secondary.barcodes}[0]
    ${medicine_have_field_wrong_barcodes}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${barcodes}
    ${list_medicine_have_field_wrong_barcodes}    Create List    ${medicine_have_field_wrong_barcodes}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${list_medicine_have_field_wrong_barcodes}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["errors"]["medicationDispenses[0].Barcodes"][0]}
    Should Be Equal    ${response_error}    Number of barcodes must be less than or equal to the quantity 
Sending Request To Dispense Appointment Not Exist In Account List But Patient Info Wrong Except MRN
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O28,
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen    
    Dispense.Create Fake Data List
    Sending Body Request With All Dispense Fields
    ...    emr_apt_arg=${appointment_dispense_dict.emrAppointmentID_fake} 
    ...    first_name_arg=${appointment_dispense_dict.first_name_fake}
    ...    last_name_arg=${appointment_dispense_dict.first_name_fake}
    ...    dob_arg=${appointment_dispense_dict.DOB_fake}
    ...    gender_arg=${appointment_dispense_dict.gender_value}
Sending Request To Dispense Appointment Primary Medication Not Exist In Account List
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O29,
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen    
    Dispense.Create Fake Data List
    Sending Body Request With All Dispense Fields
    ...    emr_apt_arg=${appointment_dispense_dict.emrAppointmentID_fake}
    ...    pri_med_arg=${appointment_dispense_dict.rand_str_15}
    ...    removed_field_list_arg=@{list_not_required_field_path}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    No medication found with the name '${appointment_dispense_dict.rand_str_15}'.
    Should Be Equal     ${response_error}     ${error} 

Sending Request To Dispense Appointment Already Dispensed
    [Documentation]    
    ...    [ Appointment Dispensing Api]_030
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Sending Body Request With All Dispense Fields
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    Can not dispense the appointment with status: Dispensed
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But NDC Field Not Exist
    [Documentation]    
    ...    [ Appointment Dispensing Api]_031
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medicine_wrong_ndc}    Create Dictionary
    ...    ndc=${appointment_dispense_dict.rand_str_15}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${medicine_wrong_ndc_list}    Create List    ${medicine_wrong_ndc}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${medicine_wrong_ndc_list}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    Not found medication with NDC: ${appointment_dispense_dict.rand_str_15}
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense But NDC Field Not Drug
    [Documentation]    
    ...    [ Appointment Dispensing Api]_032
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${list_medicine}    Create List    ${medicine_not_drug}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${list_medicine}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The medication ${medicine_not_drug["ndc"]} is not ready to dispense.
    Should Be Equal As Strings    ${response_error}    ${error}
Sending Request To Dispense But NDC Field Not Ready As Therapy
    [Documentation]    
    ...    [ Appointment Dispensing Api]_033
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${list_medicine}    Create List    ${medicine_not_therapy}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${list_medicine}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The medication ${medicine_not_therapy["ndc"]} is not ready to dispense.
    Should Be Equal As Strings    ${response_error}    ${error}
Sending Request To Dispense But BillForWaste Field Is True
    [Documentation]    
    ...    [ Appointment Dispensing Api]_035
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medicine_have_field_bill_for_waste_change}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${True}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${medicine_have_field_bill_for_waste_change_list}    Create List    ${medicine_have_field_bill_for_waste_change}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${medicine_have_field_bill_for_waste_change_list}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request To Dispense But BillForWaste Field Is False
    [Documentation]    
    ...    [ Appointment Dispensing Api]_036
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medicine_have_field_bill_for_waste_change}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${False}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${medicine_have_field_bill_for_waste_change_list}    Create List    ${medicine_have_field_bill_for_waste_change}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${medicine_have_field_bill_for_waste_change_list}
    ...    expected_status=400
    ${ndc_for_error}    Set Variable    ${medicine_primary.ndc}[:-3]
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The medication (${ndc_for_error}) is single-use, so it must be billed for waste
    Should Be Equal    ${response_error}    ${error}
    
Sending Request To Dispense But Barcode Wrong
    [Documentation]    
    ...    [ Appointment Dispensing Api]_038
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${barcodes}    Set Variable    ${medicine_secondary.barcodes}
    ${medicine_have_field_wrong_barcodes}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${barcodes}
    ${list_medicine_have_field_wrong_barcodes}    Create List    ${medicine_have_field_wrong_barcodes}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${list_medicine_have_field_wrong_barcodes}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The barcode ${medicine_secondary.barcodes[0]} does not match the dispensing medication information
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense Appointment But Wrong Info Lot and Expired Date
    [Documentation]    
    ...    [ Appointment Dispensing Api]_039
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medicine_have_field_wrong_info}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${appointment_dispense_dict.rand_str_3}
    ...    lotExpirationDate=${treatment_start_date}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ${list_medicine_have_field_wrong_info}    Create List    ${medicine_have_field_wrong_info}
    Sending Body Request With All Dispense Fields
    ...    medication_arg=${list_medicine_have_field_wrong_info}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request To Dispense Appointment But Wrong Info Appointment
    [Documentation]    
    ...    [ Appointment Dispensing Api]_040
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Dispense.Create Fake Data List
    Get TreatmentStartDate And TreatmentEndDate
    ${icd_code_arg}   Create List    ${appointment_dispense_dict.icdCodes_value}
    Sending Body Request With All Dispense Fields    
    ...    type_arg=${appointment_dispense_dict.types_value}
    ...    icd_code_arg=${icd_code_arg}
    ...    start_time_arg=${treatment_start_date}
    ...    dose_arg=${appointment_dispense_dict.num_rand}
    ...    patient_mrn_arg=${appointment_dispense_dict.MRN_fake}
    ...    first_name_arg=${appointment_dispense_dict.first_name_fake}
    ...    last_name_arg=${appointment_dispense_dict.last_name_fake}
    ...    dob_arg=${appointment_dispense_dict.DOB_fake}
    ...    gender_arg=${appointment_dispense_dict.gender_value}
    ...    treatment_start_time_arg=${treatment_start_date}
    ...    treatment_end_time_arg= ${treatment_start_date}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request With AccountNumber Blank ListAccount Large Than 1
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O75
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    ...    account_number_arg=${None}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The account must be selected  
    Should Be Equal    ${response_error}    ${error}
Sending Request With AccountNumber Not Exist ListAccount Large Than 1
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O76, [ Appointment Dispensing Api]_O22    
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request With All Dispense Fields
    ...    account_number_arg=${random_account_number}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json}[detail]
    ${error}    Set Variable    You do not have permission to access the account with the specified Account Number: ${random_account_number}     
    Should Be Equal    ${response_error}    ${error}
Sending Request With AccountNumber Blank ListAccount Equal 1
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O77
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_1_data}    ${head_1_acc1}
    Sending Body Request To Save Appointment    ${head_1_data}    ${head_1_acc1}
    Sending Body Request With All Dispense Fields
    ...    head_data=${head_1_data}
    ...    account_number_arg=${None}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request With AccountNumber Not Exist ListAccount Equal 1
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O78
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_1_data}    ${head_1_acc1}
    Sending Body Request To Save Appointment    ${head_1_data}    ${head_1_acc1}
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request With All Dispense Fields
    ...    head_data=${head_1_data}
    ...    account_number_arg=${random_account_number}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}
Sending Request With AccountNumber Blank ListAccount Equal 0
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O79
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_0_data}    ${head_0_acc1}
    Sending Body Request To Save Appointment    ${head_0_data}    ${head_0_acc1}
    Sending Body Request With All Dispense Fields
    ...    head_data=${head_0_data}
    ...    account_number_arg=${None}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json["detail"]}
    ${error}    Set Variable    The account must be selected  
    Should Be Equal    ${response_error}    ${error}
Sending Request With AccountNumber Not Exist ListAccount Equal 0
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O80
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_0_data}    ${head_0_acc1}
    Sending Body Request To Save Appointment    ${head_0_data}    ${head_0_acc1}
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request With All Dispense Fields
    ...    head_data=${head_0_data}
    ...    account_number_arg=${random_account_number}
    ...    expected_status=400
    ${response_error}    Set Variable    ${appoinment_dispensing_response_json}[detail]
    ${error}    Set Variable    Not found account with Account Number: ${random_account_number}     
    Should Be Equal    ${response_error}    ${error}
Sending Request To Dispense Wrong Format For Field Not String To Validate Field
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O56, [ Appointment Dispensing Api]_O57
    ...    [ Appointment Dispensing Api]_O59, [ Appointment Dispensing Api]_O67
    ...    [ Appointment Dispensing Api]_O68, [ Appointment Dispensing Api]_O69
    ...    [ Appointment Dispensing Api]_O70, [ Appointment Dispensing Api]_O71, 
    ...    [ Appointment Dispensing Api]_O72, [ Appointment Dispensing Api]_O73
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medicine_have_field_wrong_format}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${appointment_dispense_dict.num_rand}
    ...    wasteDose=${appointment_dispense_dict.rand_str_3}
    ...    billForWaste=${appointment_dispense_dict.rand_str_3}
    ...    quantity=${appointment_dispense_dict.rand_str_3}
    ...    barcodes=${medicine_primary.barcodes}
    ${list_medicine_have_field_wrong_format}    Create List    ${medicine_have_field_wrong_format}
    Sending Body Request With All Dispense Fields  
    ...    icd_code_arg=${appointment_dispense_dict.rand_str_3}
    ...    start_time_arg=${appointment_dispense_dict.rand_str_3}
    ...    dose_arg=${appointment_dispense_dict.rand_str_3}
    ...    dob_arg=${appointment_dispense_dict.num_rand}
    ...    medication_arg=${list_medicine_have_field_wrong_format}
    ...    treatment_start_time_arg=${appointment_dispense_dict.num_rand}
    ...    treatment_end_time_arg= ${appointment_dispense_dict.num_rand}
    ...    expected_status=400
    FOR    ${field}    IN    @{list_not_string_field_path}
        ${reponse_json_errors}    Set Variable    ${appoinment_dispensing_response_json["errors"]["${field}"]}
        Variable Should Exist    ${reponse_json_errors}
    END 
Sending Request To Dispense Only Required Field
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O74
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields    
    ...    removed_field_list_arg=@{list_not_required_field_path}
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json} 
Sending Request To Dispense Appoinment And Respronse Field
    [Documentation]    
    ...    [ Appointment Dispensing Api]_O34, [ Appointment Dispensing Api]_O37 
    ...    [ Appointment Dispensing Api]_081, [ Appointment Dispensing Api]_082
    ...    [ Appointment Dispensing Api]_083, [ Appointment Dispensing Api]_084
    ...    [ Appointment Dispensing Api]_086, [ Appointment Dispensing Api]_087
    ...    [ Appointment Dispensing Api]_088, [ Appointment Dispensing Api]_089
    ...    [ Appointment Dispensing Api]_090, [ Appointment Dispensing Api]_091
    ...    [ Appointment Dispensing Api]_092, [ Appointment Dispensing Api]_093
    ...    [ Appointment Dispensing Api]_094, [ Appointment Dispensing Api]_095
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Verify Successful Response In Appoinment Dispensing    ${appoinment_dispensing_response_json}     
   
# Dispensing Medication 
Sending Request To Dispense Medication With All Fields
    [Documentation]    
    ...    [Dispensing Api]_TC01, [Dispensing Api]_TC02, [Dispensing Api]_TC03
    ...    [Dispensing Api]_TC04, [Dispensing Api]_TC05, [Dispensing Api]_TC06
    ...    [Dispensing Api]_TC07, [Dispensing Api]_TC08, [Dispensing Api]_TC09
    ...    [Dispensing Api]_TC10, [Dispensing Api]_TC11, [Dispensing Api]_TC12
    ...    [Dispensing Api]_TC13, [Dispensing Api]_TC14, [Dispensing Api]_TC15
    [Tags]    
    ...  API    Appointment Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Sending Body Request To Dispense Medication
    Verify Successful Response In Medication Dispensing    ${medication_dispensing_response_json}
Sending Request To Dispense Medication Only Required Field
    [Documentation]    
    ...    [Dispensing Api]_TC17
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    @{removed_field_list}    Create List    AccountNumber
    Sending Body Request To Dispense Medication    
    ...    removed_field_list_arg=@{removed_field_list}
    Verify Successful Response In Medication Dispensing    ${medication_dispensing_response_json}
Sending Request To Dispense Medication But Account Number Null
    [Documentation]    
    ...    [Dispensing Api]_TC19
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Sending Body Request To Dispense Medication
    ...    account_number_arg=${None}
    Verify Successful Response In Medication Dispensing    ${medication_dispensing_response_json}
Sending Request To Dispense Medication But EMRAppointment Null
    [Documentation]    
    ...    [Dispensing Api]_TC21
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Sending Body Request To Dispense Medication
    ...    emr_apt_arg=${None}
    ...    expected_status=400
    ${response_errors}    Set Variable    ${medication_dispensing_response_json["errors"]["emrAppointmentID"][0]}
    ${error}    Set Variable    The EMRAppointmentID field is required.
    Should Be Equal As Strings    ${response_errors}    ${error}
Sending Request To Dispense Medication But Account Number And EMRAppointment Null
    [Documentation]    
    ...    [Dispensing Api]_TC22
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    Sending Body Request To Dispense Medication
    ...    account_number_arg=${None}
    ...    emr_apt_arg=${None}
    ...    expected_status=400
    ${response_errors}    Set Variable    ${medication_dispensing_response_json["errors"]["emrAppointmentID"][0]}
    ${error}    Set Variable    The EMRAppointmentID field is required.
    Should Be Equal As Strings    ${response_errors}    ${error}
Sending Request To Dispense Medication For Appoinment Have Multi Medicine
    [Documentation]
    ...    [Dispensing Api]_TC23, [Dispensing Api]_TC25, [Dispensing Api]_TC29
    [Tags]
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    ${medication_dispenses_first}    Create Dictionary
    ...    ndc=${medicine_primary.ndc}
    ...    lotNumber=${medicine_primary.lotNumber}
    ...    lotExpirationDate=${medicine_primary.lotExpirationDate}
    ...    wasteDose=${medicine_primary.wasteDose}
    ...    billForWaste=${medicine_primary.billForWaste}
    ...    quantity=${medicine_primary.quantity}
    ...    barcodes=${medicine_primary.barcodes}
    ${medication_dispenses_second}    Create Dictionary
    ...    ndc=${medicine_secondary.ndc}
    ...    lotNumber=${medicine_secondary.lotNumber}
    ...    lotExpirationDate=${medicine_secondary.lotExpirationDate}
    ...    wasteDose=${medicine_secondary.wasteDose}
    ...    billForWaste=${medicine_secondary.billForWaste}
    ...    quantity=${medicine_secondary.quantity}
    ...    barcodes=${medicine_secondary.barcodes}
    ${medication_dispenses_list}    Create List    ${medication_dispenses_first}    ${medication_dispenses_second} 
    Sending Body Request With All Dispense Fields    medication_arg=${medication_dispenses_list} 
    Sending Body Request To Dispense Medication
    Verify Successful Response In Medication Dispensing    ${medication_dispensing_response_json} 
Sending Request To Dispense Medication But EMR Not Exist
    [Documentation]    
    ...    [Dispensing Api]_TC32
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    ${emr_appointment}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(6))    random
    Sending Body Request With All Dispense Fields
    Sending Body Request To Dispense Medication
    ...    emr_apt_arg=${emr_appointment}
    ...    expected_status=404
Sending Request To Dispense Medication But Appoinment Not Dispense
    [Documentation]    
    ...    [Dispensing Api]_TC33
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request To Dispense Medication
    ...    account_number_arg=${head_multi_acc1}
    ...    emr_apt_arg=${APT_response_json["emrAppointmentID"]}
    ...    expected_status=400
    ${response_error}    Set Variable    ${medication_dispensing_response_json["detail"]}
    ${error}    Set Variable    This appointment is in the Requires Approval status. The valid status for obtaining a list of medications is: { Dispensed }.
    Should Be Equal As Strings    ${response_error}    ${error}
Sending Request To Dispense Medication With List Account Large Than 1 But Number Account Not Exist
    [Documentation]    
    ...    [Dispensing Api]_TC31, [Dispensing Api]_TC35
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    Sending Body Request With All Dispense Fields
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request To Dispense Medication
    ...    account_number_arg=${random_account_number}
    ...    expected_status=404
Sending Request To Dispense Medication With List Account Equal 1 But Number Account Not Exist
    [Documentation]    
    ...    [Dispensing Api]_TC37
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_1_data}    ${head_1_acc1}
    Sending Body Request To Save Appointment    ${head_1_data}    ${head_1_acc1}
    Sending Body Request With All Dispense Fields    
    ...    head_data=${head_1_data}    
    ...    account_number_arg=${head_1_acc1}    
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request To Dispense Medication
    ...    head_data=${head_1_data}    
    ...    account_number_arg=${random_account_number}
    Verify Successful Response In Medication Dispensing    ${medication_dispensing_response_json}
Sending Request To Dispense Medication With List Account Equal 0 But Number Account Not Exist
    [Documentation]    
    ...    [Dispensing Api]_TC39
    [Tags]    
    ...  API    Medication Dispense
    ...  report.label.owner: Quoc Nguyen
    [Setup]    None
    Dispense.Create Fake Data List
    Sending Body Request To Save Patient    ${head_0_data}    ${head_0_acc1}
    Sending Body Request To Save Appointment    ${head_0_data}    ${head_0_acc1}
    Sending Body Request With All Dispense Fields    
    ...    head_data=${head_0_data}    
    ...    account_number_arg=${head_0_acc1}  
    ${random_account_number}    Evaluate    str(1) + ''.join(str(random.randint(0,9)) for _ in range(5))    random
    Sending Body Request To Dispense Medication
    ...    head_data=${head_0_data}    
    ...    account_number_arg=${random_account_number}
    ...    expected_status=404
*** Keywords ***
Suite Setup
    Dispense.Setup Data
    Patient.Get URL API Patient
    Appointment.Get URL API Appointment
    Dispense.Get URL API Dispense
    ${patient_list}    Create List
    Set Suite Variable    ${patient_list}
Test Setup
    Dispense.Create Fake Data List
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
Suite Teardown
    Delete Patient From Patient List
    Close Browser
