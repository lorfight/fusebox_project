** Settings **
Documentation      Appointment Save
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Resource    ../../../resources/ApiObjects/Keywords/Appointment.resource
Resource   ../../../resources/PageObjects/Keywords/RePatient.resource
Suite Setup    Suite Setup
Test Setup    Test Setup
# Suite Teardown    Suite Teardown
** Test Cases **
Sending Request With All Optional Fields And Required Fields
    [Documentation]    AA33629_TC01    AA33629_TC25    AA33629_TC38    AA33629_TC92
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=20
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID, MRN Match With Fusebox And Id, EmrAppointmentID Do Not Exist In Group Account With Same Patient Nextwork
    [Documentation]    AA33629_TC02
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending request with emrPatientID,MRN match with fusebox and have no id, emrAppointmentID match with FB in AccountNumber
    [Documentation]    AA33629_TC05
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID, MRN Match With Fusebox And Have No EmrAppointmentID, Id Match With FB In AccountNumber
    [Documentation]    AA33629_TC06
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID, MRN, EmrAppointmentID, Id Match With FB In AccountNumber
    [Documentation]    AA33629_TC07
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID, MRN Match With Fusebox And Have No EmrAppointmentID, Id Exist In Group Account With Same Patient Nextwork
    [Documentation]    AA33629_TC08
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With EmrPatientID, MRN Match With Fusebox And Have No Id, EmrAppointmentID Exist In Group Account With Same Patient Nextwork
    [Documentation]    AA33629_TC09
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc2}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With EmrPatientID, MRN Match With Fusebox And AppointmentID Has Value And Doesn't Exist In AccountNumber
    [Documentation]    AA33629_TC10
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc2}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404
    
Sending Request With EmrPatientID, MRN, AppointmentID Match With Fusebox And EmrAppointmentID Exist In Group Account With Same Patient Network
    [Documentation]    AA33629_TC11
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc2}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404
    
Sending Request With EmrPatientID, MRN, AppointmentID Match With Fusebox And AppointmentID, EmrAppointmentID Exist In AccountNumber But Not Same As Patient
    [Documentation]    AA33629_TC12
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=400
    Should Contain    ${APT_response_json['detail']}    The patient found does not match the patient associated with the appointment.

Sending Request With EmrPatientID=Blank, Has MRN And AppointmentID, EmrAppointmentID Do Not Exist In AccountNumber And Group HeadAccount
    [Documentation]    AA33629_TC13
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID=Blank, Has MRN And AppointmentID, EmrAppointmentID Exist In AccountNumber
    [Documentation]    AA33629_TC14
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With EmrPatientID=Blank, Has MRN And AppointmentID, EmrAppointmentID Exist In Group HeadAccount
    [Documentation]    AA33629_TC15
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc2}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With MRN=Blank, Has EmrPatientID And AppointmentID, EmrAppointmentID Do Not Exist In AccountNumber And Group HeadAccount
    [Documentation]    AA33629_TC16
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    
Sending Request With MRN=Blank, Has EmrPatientID And AppointmentID, EmrAppointmentID Exist In AccountNumber
    [Documentation]    AA33629_TC17
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With MRN=Blank, Has EmrPatientID And AppointmentID, EmrAppointmentID Exist In Group HeadAccount
    [Documentation]    AA33629_TC18
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc2}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc2}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=404

Sending Request With EmrPatientID=Blank, MRN=Blank
    [Documentation]    AA33629_TC19
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=400
    Should Contain    ${APT_response_json['detail']}    Patient with the provided ID, EMR Patient ID or MRN could not be found.

Sending Request With AccountNumber=Blank
    [Documentation]    AA33629_TC20
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${APT_dict.emrAppointmentID_fake}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The field AccountNumber must match the regular expression '^[0-9]+$'.

Sending Request With End Time > Start Time
    [Documentation]    AA33629_TC21
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${end_date}
    ...    end_date_send=${start_date}
    ...    expected_status=400
    Should Contain    ${APT_response_json['detail']}    Invalid start time and end time for the appointment.

Sending Request With Start Time < = End Time
    [Documentation]    AA33629_TC22
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${start_date}
    ...    end_date_send=${end_date}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Dosage < 0
    [Documentation]    AA33629_TC23
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= -${APT_dict.num_rand}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The value must commence at 0 and reach a maximum of 1000000.

Sending Request With Dosage > = 0
    [Documentation]    AA33629_TC24
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${APT_dict.num_rand}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    expected_status=200
    Should Be Equal As Numbers    ${APT_response_json["dosage"]}    464

Sending Request With Medication Match In EMR Mapping And Has PO, Previous Appointment And Dosage In Json > 0
    [Documentation]    AA33629_TC29
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=20
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=30
    ...    expected_status=200
    Should Be Equal As Numbers    ${APT_response_json["dosage"]}    ${body_request_APT["doseQuantity"]}.0

Sending Request With Medication Match In EMR Mapping And Has PO, Previous Appointment And Dosage In Json = 0
    [Documentation]    AA33629_TC30
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= 20
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}

Sending Request With Medication Match In EMR Mapping And Has PO, Previous Appointment And ICD Code, Phycician In Json Is Blank
    [Documentation]    AA33629_TC31
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= 20
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}
    Should Be Equal    ${PO_data.PO_refering}    ${APT_response_json["referringProviderNPI"]}
    Should Contain    ${PO_data.PO_referto}    ${APT_response_json["referToProviderNPI"]}

# Sending Request With Medication Match In EMR Mapping And Has PO, Previous Appointment And ICD Code, Phycician In Json And PO Is Blank
#     [Documentation]    AA33629_TC32
# 	[Tags]    API    Appointment Save
#     ...  report.label.owner: Hai Nguyen
#     Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${False}
#     Create New Appointment    
#     ...    head_account_arg=${head_multi_data}
#     ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
#     ...    account_number_send=${head_multi_acc1}
#     ...    emrPatientID_send=${response_json["emrPatientID"]}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    dose_send= 20
#     ...    expected_status=200
#     ${temp_data}    Create Dictionary    APT_pre_dosage=${APT_response_json["dosage"]}    APT_pre_refering=${APT_response_json["referringProviderNPI"]}    APT_pre_referto=${APT_response_json["referToProviderNPI"]}
#     Set Test Variable    ${temp_data}
#     Get StartDate And EndDate
#     Create New Appointment    
#     ...    head_account_arg=${head_multi_data}
#     ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
#     ...    account_number_send=${head_multi_acc1}
#     ...    emrPatientID_send=${response_json["emrPatientID"]}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    dose_send= ${0}
#     ...    icd_code_send=${EMPTY}
#     ...    referringProviderNPI_send=${None}
#     ...    preferredInternalProviderNPI_send=${None}
#     ...    expected_status=200
#     Should Be Equal As Numbers    ${temp_data.APT_pre_dosage}    ${APT_response_json["dosage"]}
#     Should Be Equal    ${temp_data.APT_pre_refering}    ${APT_response_json["referringProviderNPI"]}
#     Should Contain    ${temp_data.APT_pre_referto}    ${APT_response_json["referToProviderNPI"]}

Sending Request With Medication Match In EMR Mapping And Has PO And ICD Code, Phycician In Json Is Blank
    [Documentation]    AA33629_TC34
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}
    Should Be Equal    ${PO_data.PO_refering}    ${APT_response_json["referringProviderNPI"]}
    Should Contain    ${PO_data.PO_referto}    ${APT_response_json["referToProviderNPI"]}

Sending Request With Medication Match In EMR Mapping And Has PO And ICD Code, Phycician In Json And PO Is Blank
    [Documentation]    AA33629_TC35
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${False}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${APT_response_json["dosage"]}    464

Sending Request With Medication Match In EMR Mapping And No PO, Previous Appointment
    [Documentation]    AA33629_TC39
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${APT_response_json["dosage"]}    464
    Should Be Equal As Numbers    ${APT_response_json["referringProviderNPI"]}    ${0}
    Should Be Equal As Numbers    ${APT_response_json["referToProviderNPI"]}    ${0}

Sending Request With Medication Not Exist In EMR Mapping
    [Documentation]    AA33629_TC40
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    med_send=ABC
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=400
    Should Contain    ${APT_response_json['detail']}    No medication found with the name '${body_request_APT.primaryMedication}'.

Sending Request With Start Time < Schedule Iteration Date And Conflict Reason Has Data
    [Documentation]    AA33629_TC41
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${pre_date}
    ...    end_date_send=${EMPTY}
    ...    expected_status=200
    ...    reason_send=${EMPTY}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${end_date}
    ...    end_date_send=${EMPTY}
    ...    expected_status=200

Sending Request With Start Time < Schedule Iteration Date And Conflict Reason Has No Data
    [Documentation]    AA33629_TC42
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${pre_date}
    ...    end_date_send=${EMPTY}
    ...    expected_status=200
    ...    reason_send=${EMPTY}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${end_date}
    ...    end_date_send=${EMPTY}
    ...    expected_status=200
    ...    reason_send=${EMPTY}

Sending Request With Start Time > Schedule Iteration Date And Conflict Reason Has Data
    [Documentation]    AA33629_TC43
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    ...    reason_send=${EMPTY}
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200

Sending Request With Appointment Type Has Data In Json
    [Documentation]    AA33629_TC44
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200

Sending Request With Appointment Type Has No Data In Json And Has In PO
    [Documentation]    AA33629_TC45
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Appointment.Create New PO    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=${EMPTY}
    ...    expected_status=200

Sending Request With Appointment Type Has No Data In Json And PO, Has In Previous Appt
    [Documentation]    AA33629_TC46
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=${EMPTY}
    ...    expected_status=200

Verify That Medication Items Are Updated According To The Latest Information When Updating Appointment Information
    [Documentation]    AA33629_TC47
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    med_send=Walk In Fasenra
    ...    expected_status=200

Sending Request With The ICD Code Is Updated Correctly In The Fusebox When The JSON Have 3 ICD Codes.
    [Documentation]    AA33629_TC48
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    # Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    ${icd_code_list}    Create List    I10    E11.9    A01.02
    Set Test Variable    ${icd_code_list}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    icd_code_send=${icd_code_list}
    ...    expected_status=200
    Appointment.Check Data In Scheduled Appointments Tab    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Should Be Equal    ${icd_code_list}    ${diagnosis_list}

Sending Request With The ICD Code Is Updated Correctly In The Fusebox When The JSON Have 4 ICD Codes.
    [Documentation]    AA33629_TC49
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    # Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    ${icd_code_list}    Create List    I10    E11.9    A01.02    B95.3
    Set Test Variable    ${icd_code_list}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    icd_code_send=${icd_code_list}
    ...    expected_status=200
    Appointment.Check Data In Scheduled Appointments Tab    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}
    Should Not Contain    ${diagnosis_list}    B95.3




















#Validation
Sending Request With Number On ID And accountNumber
    [Documentation]    AA33629_TC72    AA33629_TC73    AA33629_TC76
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    id_send=${${APT_response_json["id"]}}
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    
Sending Request With Blank On accountNumber
    [Documentation]    AA33629_TC77
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The field AccountNumber must match the regular expression '^[0-9]+$'.
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The field AccountNumber must match the regular expression '^[0-9]+$'.
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${None}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    
Sending Request With Missing On accountNumber
    [Documentation]    AA33629_TC78
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=missing
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=missing
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=missing
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
Sending Request With Blank Fields
    [Documentation]    AA33629_TC80    AA33629_TC85    AA33629_TC90
    ...    AA33629_TC98    AA33629_TC107    AA33629_TC110    AA33629_TC115
    ...    AA33629_TC118    AA33629_TC121    AA33629_TC124    AA33629_TC127
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${EMPTY}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=${EMPTY}
    ...    end_date_send=${EMPTY}
    ...    emrAptID_send=${EMPTY}
    ...    note_send=${EMPTY}
    ...    location_num_send=${None}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    reason_send=${EMPTY}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${EMPTY}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Blank StartDate
    [Documentation]    AA33629_TC95
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=${None}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}    The StartTime field is required.

Sending Request With Blank doseQuantity
    [Documentation]    AA33629_TC104
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=${None}
    ...    expected_status=400
    # Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    Error converting value {null} to type 'System.Decimal'.
Sending Request With Missing ID
    [Documentation]    AA33629_TC74
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    id_send=missing
    ...    head_account_arg=${head_multi_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Missing Fields
    [Documentation]    AA33629_TC81    AA33629_TC86    AA33629_TC91
    ...    AA33629_TC99    AA33629_TC108    AA33629_TC111    AA33629_TC116
    ...    AA33629_TC119    AA33629_TC122    AA33629_TC125    AA33629_TC128
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=missing
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=missing
    ...    end_date_send=missing
    ...    emrAptID_send=missing
    ...    note_send=missing
    ...    location_num_send=missing
    ...    icd_code_send=missing
    ...    referringProviderNPI_send=missing
    ...    preferredInternalProviderNPI_send=missing
    ...    reason_send=missing
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=missing
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Missing StartDate
    [Documentation]    AA33629_TC96
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    start_date_send=missing
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}    The StartTime field is required.

Sending Request With Missing doseQuantity
    [Documentation]    AA33629_TC105
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=missing
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Blank primaryMedication
    [Documentation]    AA33629_TC101
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    med_send=${EMPTY}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The PrimaryMedication field is required.

Sending Request With Missing primaryMedication
    [Documentation]    AA33629_TC102
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    med_send=missing
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The PrimaryMedication field is required.

Sending Request With Value Outside The List On Type
    [Documentation]    AA33629_TC93
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    type_send=type
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    Error converting value \"type\" to type

Sending Request With 255 Characters On Note
    [Documentation]    AA33629_TC113
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    ${rand_str_255}    Appointment.Get Random Data    fake_data=rand_str_255
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    note_send=${rand_str_255}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With 256 Characters On Note
    [Documentation]    AA33629_TC114
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    ${rand_str_256}    Appointment.Get Random Data    fake_data=rand_str_256
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    note_send=${rand_str_256}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    Should Contain    ${actual_errors}[0]    The field Note must be a string or array type with a maximum length of '255'.

Sending Request With 51 Characters On patientMRN And emrPatientID
    [Documentation]    AA33629_TC84    AA33629_TC89
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    ${rand_str_51}    Appointment.Get Random Data    fake_data=rand_str_51
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${rand_str_51}
    ...    emrPatientID_send=${rand_str_51}
    ...    expected_status=400
    ${actual_errors}    Evaluate    [err for errors in ${APT_response_json['errors']}.values() for err in errors]
    ${response_errors}    Create List    
    ...    The field PatientMRN must be a string or array type with a maximum length of '50'.
    ...    The field EMRPatientID must be a string or array type with a maximum length of '50'.
    FOR    ${response_error}    ${actual_error}    IN ZIP    ${response_errors}    ${actual_errors}
        Should Contain    ${actual_error}    ${response_error}
    END

Sending Request With 50 Characters On patientMRN And emrPatientID
    [Documentation]    AA33629_TC83    AA33629_TC88
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Patient.Create Fake Patient Data With Required Fields
    ${rand_str_50}    Patient.Get Random Data    fake_data=rand_str_50
    Patient.Get URL API Patient
    Patient.Get Access Token    head_account=${head_multi_data}
    Create Session    mysession    ${base_url}
    ${headers}    Create Dictionary
    ...    Authorization=Bearer ${access_token}
    ...    Content-Type=application/json
    Patient.Sending Body Request With Required Fields
    ...    account_number_arg=${head_multi_acc1}
    ...    first_name_arg=${Fake_dict.first_name_fake}
    ...    last_name_arg=${Fake_dict.last_name_fake}
    ...    dob_arg=${Fake_dict.DOB_fake}
    ...    mrn_arg=${rand_str_50}
    ...    id_arg=${None}
    ...    emr_patient_id_arg=${rand_str_50}
    ...    gender_arg=${Fake_dict.gender_value}
    ...    expected_status=200
    ${response}    POST On Session    mysession    ${patient_path}    json=${body_request}    headers=${headers}    expected_status=200
    ${response_json}    Set Variable    ${response.json()}
    Set Test Variable    ${response_json}
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

#Response
Verify Response Format and Match with Request Body For All Fields
    [Documentation]    AA33629_TC54    AA33629_TC55    AA33629_TC56
    ...    AA33629_TC57    AA33629_TC58    AA33629_TC59    AA33629_TC60
    ...    AA33629_TC61    AA33629_TC63    AA33629_TC65    AA33629_TC66
    ...    AA33629_TC67    AA33629_TC69
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    Create New Appointment    
    ...    head_account_arg=${head_multi_data}
    ...    account_number_send=${head_multi_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    ${APT_response_string}  Evaluate    json.dumps(${APT_response_json})    json
    Set Test Variable    ${APT_response_string}
    Appointment.Validate JSON Fields For Appointment Save    APT_response_arg=${APT_response_string}
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With ID, Emr Appointment ID Do Not Exist In The Fusebox System (List Account=1, AccountNumber=null)
    [Documentation]    AA33629_TC130
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${None}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With ID And EmrappointmentID Not Match With Patient_Account ID In Fusebox (List Account=1, AccountNumber=null)
    [Documentation]    AA33629_TC131
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${None}
    ...    id_send=${APT_dict.emrAppointmentID_fake}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With ID, EmrappointmentID Already Exists In Fusebox System (List Account=1, AccountNumber=null)
    [Documentation]    AA33629_TC132
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${None}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With ID, Emr Appointment ID Do Not Exist In The Fusebox System (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC133
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}  
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With AccountNumber Not Match With AccountList (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC134
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_multi_acc1}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200

Sending Request With AccountNumber Not Match With Accounlist (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC135
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With The ICD Code Is Updated Correctly In The Fusebox When The JSON Have 3 ICD Codes (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC137
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_list}    Create List    I10    E11.9    A01.02
    Set Test Variable    ${icd_code_list}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    icd_code_send=${icd_code_list}
    ...    expected_status=200
    Appointment.Check Data In Scheduled Appointments Tab    locationPO_arg=${head_1_PO1}    mrn_arg=${response_json["mrn"]}
    Should Be Equal    ${icd_code_list}    ${diagnosis_list}
    
Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC138
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Appointment.Create New PO    locationPO_arg=${head_1_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    account_number_send=${head_1_acc1}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=20
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    emrAptID_send=${EMPTY}
    ...    account_number_send=${head_1_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send=30
    ...    expected_status=200
    Should Be Equal As Numbers    ${APT_response_json["dosage"]}    ${body_request_APT["doseQuantity"]}.0

Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment And ICD Code, Phycician In Json Is Blank (List Account=1, AccountNumber=valid)
    [Documentation]    AA33629_TC139
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Appointment.Create New PO    locationPO_arg=${head_1_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_1_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= 20
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_1_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_1_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}
    Should Be Equal    ${PO_data.PO_refering}    ${APT_response_json["referringProviderNPI"]}
    Should Contain    ${PO_data.PO_referto}    ${APT_response_json["referToProviderNPI"]}

# Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment And ICD Code, Phycician In Json And Previous Has Value (List Account=1, AccountNumber=valid)
#     [Documentation]    AA33629_TC140
# 	[Tags]    API    Appointment Save
#     ...  report.label.owner: Hai Nguyen
#     Patient.Create New Patient    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}
#     Create New Appointment    
#     ...    head_account_arg=${head_1_data}
#     ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
#     ...    account_number_send=${head_1_acc1}
#     ...    emrPatientID_send=${response_json["emrPatientID"]}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    start_date_send=${pre_date}
#     ...    end_date_send=${EMPTY}
#     ...    dose_send= 20
#     ...    expected_status=200
#     ${temp_data}    Create Dictionary    APT_pre_dosage=${APT_response_json["dosage"]}    APT_pre_emrAptID=${APT_response_json["emrAppointmentID"]}
#     Get StartDate And EndDate
#     # ${emrAppointmentID}    Appointment.Get Random Data    fake_data=emrAppointmentID
#     Create New Appointment    
#     ...    head_account_arg=${head_1_data}
#     ...    emrAptID_send=${temp_data.APT_pre_emrAptID}
#     ...    account_number_send=${head_1_acc1}
#     ...    emrPatientID_send=${EMPTY}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    dose_send= ${0}
#     ...    icd_code_send=${EMPTY}
#     ...    start_date_send=${start_date}
#     ...    end_date_send=${EMPTY}
#     ...    referringProviderNPI_send=${None}
#     ...    preferredInternalProviderNPI_send=${None}
#     ...    expected_status=200
#     Should Be Equal As Numbers    ${temp_data.APT_pre_dosage}    ${APT_response_json["dosage"]}
#     Should Be equal    ${APT_response_json["referringProviderNPI"]}    ${None}
#     Should Contain    ${APT_response_json["referToProviderNPI"]}    ${None}

Sending Request With ID, Emr Appointment ID Do Not Exist In The Fusebox System (List Account=0, AccountNumber=null)
    [Documentation]    AA33629_TC143
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${None}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With ID, Emr Appointment ID Do Not Exist In The Fusebox System (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC144
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With AccountNumber Not Match With Group HeadAccount (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC145
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_multi_acc1}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=404

Sending Request With AccountNumber Has Data And ID, EmrAppointmentID Already Exists In Fusebox System (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC146
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With The ICD Code Is Updated Correctly In The Fusebox When The JSON Have 3 ICD Codes (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC148
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_list}    Create List    I10    E11.9    A01.02
    Set Test Variable    ${icd_code_list}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    icd_code_send=${icd_code_list}
    ...    expected_status=200
    Appointment.Check Data In Scheduled Appointments Tab    locationPO_arg=${head_0_PO1}    mrn_arg=${response_json["mrn"]}
    Should Be Equal    ${icd_code_list}    ${diagnosis_list}

Sending Request With Medication Matchin EMR Medication Mapping And Has PO, Previous Appointment (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC150
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Appointment.Create New PO    locationPO_arg=${head_0_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${None}
    ...    emrAptID_send=${EMPTY}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    account_number_send=${head_0_acc1}
    ...    id_send=${APT_response_json["id"]}
    ...    emrAptID_send=${APT_response_json["emrAppointmentID"]}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    expected_status=200
    Appointment.Compare Request And Response With All Fields    ${APT_response_json}

Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment And ICD Code, Physician In Json Is Blank (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC151
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Appointment.Create New PO    locationPO_arg=${head_0_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= 20
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}
    Should Be Equal    ${PO_data.PO_refering}    ${APT_response_json["referringProviderNPI"]}
    Should Contain    ${PO_data.PO_referto}    ${APT_response_json["referToProviderNPI"]}

# Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment And ICD Code, Physician In Json And Previous Has Data (List Account=0, AccountNumber=valid)
#     [Documentation]    AA33629_TC152
# 	[Tags]    API    Appointment Save
#     ...  report.label.owner: Hai Nguyen
    # [Setup]    None
#     Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
#     Create New Appointment    
#     ...    head_account_arg=${head_0_data}
#     ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
#     ...    account_number_send=${head_0_acc1}
#     ...    emrPatientID_send=${response_json["emrPatientID"]}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    dose_send= 20
#     ...    expected_status=200
#     ${temp_data}    Create Dictionary    APT_pre_dosage=${APT_response_json["dosage"]}
#     Get StartDate And EndDate
#     Create New Appointment    
#     ...    head_account_arg=${head_0_data}
#     ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
#     ...    account_number_send=${head_0_acc1}
#     ...    emrPatientID_send=${response_json["emrPatientID"]}
#     ...    patientMRN_send=${response_json["mrn"]}
#     ...    dose_send= ${0}
#     ...    icd_code_send=${EMPTY}
#     ...    referringProviderNPI_send=${None}
#     ...    preferredInternalProviderNPI_send=${None}
#     ...    expected_status=200
#     Should Be Equal As Numbers    ${temp_data.APT_pre_dosage}    ${APT_response_json["dosage"]}

Sending Request With Medication Match In EMR Medication Mapping And Has PO, Previous Appointment And ICD Code, Physician In Json And Previous Appointment Is Blank (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC153
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Appointment.Create New PO    locationPO_arg=${head_0_PO1}    mrn_arg=${response_json["mrn"]}    reffering_arg=${referringProviderNPI}    med_arg=${primaryMedication}    PO_dosage_arg=10    status=${True}
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Get StartDate And EndDate
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=200
    Should Be Equal As Numbers    ${PO_data.PO_dosage}    ${APT_response_json["dosage"]}
    Should Be Equal    ${PO_data.PO_refering}    ${APT_response_json["referringProviderNPI"]}
    Should Contain    ${PO_data.PO_referto}    ${APT_response_json["referToProviderNPI"]}

Sending Request With Medication Not Exist In EMR Mapping (List Account=0, AccountNumber=valid)
    [Documentation]    AA33629_TC158
	[Tags]    API    Appointment Save
    ...  report.label.owner: Hai Nguyen
    [Setup]    None
    Patient.Create New Patient    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}
    Get StartDate And EndDate
    Appointment.Create Fake Appointment Data With Required Fields
    Create New Appointment    
    ...    head_account_arg=${head_0_data}
    ...    emrAptID_send=${APT_dict.emrAppointmentID_fake}
    ...    account_number_send=${head_0_acc1}
    ...    emrPatientID_send=${response_json["emrPatientID"]}
    ...    patientMRN_send=${response_json["mrn"]}
    ...    dose_send= ${0}
    ...    icd_code_send=${EMPTY}
    ...    med_send=ABC
    ...    referringProviderNPI_send=${None}
    ...    preferredInternalProviderNPI_send=${None}
    ...    expected_status=400
    Should Contain    ${APT_response_json['detail']}    No medication found with the name '${body_request_APT.primaryMedication}'.















** Keywords **
Suite Setup
    Appointment.Setup Data
    Get URL API Appointment
    ${patient_list}=    Create List
    Set Suite Variable    ${patient_list}

Test Setup
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Appointment.Create Fake Appointment Data With Required Fields
    ${icd_code_value}    Create List    ${APT_dict.icd_code_value}
    Set Test Variable    ${icd_code_value}
    Get StartDate And EndDate

Suite Teardown
    Delete Patient From Patient List
    Close Browser
