** Settings **
Documentation      Billing 
Resource   ../../../resources/ApiObjects/Keywords/Patient.resource
Resource    ../../../resources/ApiObjects/Keywords/Appointment.resource
Resource    ../../../resources/ApiObjects/Keywords/Dispense.resource
Resource    ../../../resources/ApiObjects/Keywords/Billing.resource
Suite Setup    Suite Setup
Test Setup    Test Setup
# Suite Teardown    Suite Teardown
** Test Cases **
Sending Request With All Optional Fields And Required Fileds In Request Body And Response Body Have All Field (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC01    B33629_TC48
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Create New Payer Plan    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=2
    Sending Body Request With All Billing Fields
    ...    expected_status=200
    
Sending Request With Accountid Have No Value (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC02
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Create New Payer Plan    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=2
    Sending Body Request With All Billing Fields
    ...    account_number_arg=${EMPTY}
    ...    expected_status=200

Sending Request With EMR Appointment ID Not Matches AccountNumber In Fusebox (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC04
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Sending Request With EMR Appointment ID Not Matches AccountNumber In Fusebox    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}    head_account_no_match=${head_multi_data}    account_num__no_match=${head_multi_acc1}

Sending Request With Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC05
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Request With Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}

Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval" (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC06
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval"    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    
Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC07
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}

Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC08
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}

Sending Request With Fields Has Type=Array Containing Multiple Data (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC09
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Request With Fields Has Type=Array Containing Multiple Data    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}    locationPO_arg=${head_multi_PO1}

Check The API Response Error When No Authentication Token Is Present (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC10
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Check The API Response Error When No Authentication Token Is Present    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}

Verify Response Format and Match with Request Body, Fusebox For All Fields (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC1
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Create New Payer Plan    locationPO_arg=${head_multi_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=4
    Sending Body Request With All Billing Fields
    ...    expected_status=200
    ${bill_response_string}  Evaluate    json.dumps(${bill_response_json})    json
    Set Test Variable    ${bill_response_string}
    Billing.Validate JSON Fields Max Length    response_arg=${bill_response_string}
    # Billing.Compare Request And Response With All Fields

Sending Request With Empty/Blank Space EMRAppointmentID (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC45
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    emr_apt_id_arg=${EMPTY}
    ...    expected_status=400

Sending Request With Missing EMRAppointmentID Key and Value (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC46
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    emr_apt_id_arg=missing
    ...    expected_status=400

Sending Request With Empty/Blank Space AccountNumber (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC49
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    account_number_arg=${EMPTY}
    ...    expected_status=200

Sending Request With Missing AccountNumber Key And Value (Listaccount > 1, AccountNumber = valid)
    [Documentation]    B33629_TC50
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    account_number_arg=missing
    ...    expected_status=200

Sending Request With All Optional Fields And Required Fields In Request Body And Response Body Have All Field (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC52
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 1
    # Create New Payer Plan    locationPO_arg=${head_1_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=2
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_1_data}
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=200

Sending Request With All Accountid Have No Value (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC53
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 1
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_1_data}
    ...    account_number_arg=${EMPTY}
    ...    expected_status=200

# Sending Request With EMR Appointment ID Not Matches EMR Appointment ID In Fusebox (Listaccount = 1, AccountNumber = valid)
#     [Documentation]    B33629_TC54
# 	[Tags]    API    Billing
#     ...  report.label.owner: Hai Nguyen
#     Sending Body Request With All Billing Fields
#     ...    head_account_arg=${head_1_data}
#     ...    account_number_arg=${head_1_acc1}
#     ...    expected_status=400
#     Should Contain    ${bill_response_json['detail']}    Can not find the appointment.

Sending Request With EMR Appointment ID Not Matches AccountNumber In Fusebox (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC55
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_1_data}
    ...    account_number_arg=${head_1_acc1}
    ...    expected_status=400
    Should Contain    ${bill_response_json['detail']}    Can not find the appointment.

Sending Request With All Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC56
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 1
    Sending Request With Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval" (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC57
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval"    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC58
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    # Test Setup With List Account = 1
    Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC59
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    # Test Setup With List Account = 1
    Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Sending Request With Fields Has Type=Array Containing Multiple Data (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC60
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 1
    Sending Request With Fields Has Type=Array Containing Multiple Data    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}        locationPO_arg=${head_1_PO1}

Check The API Response Error When No Authentication Token Is Present (Listaccount = 1, AccountNumber = valid)
    [Documentation]    B33629_TC61
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 1
    Check The API Response Error When No Authentication Token Is Present    head_account_arg=${head_1_data}    account_num_arg=${head_1_acc1}

Sending Request With All Optional Fields And Required Fields In Request Body And Response Body Have All Field (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC62
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 0
    Create New Payer Plan    locationPO_arg=${head_0_PO1}    mrn_arg=${response_json["mrn"]}    loop_arg=2
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_0_data}
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=200

Sending Request With All Accountid Have No Value (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC63
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 0
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_0_data}
    ...    account_number_arg=${EMPTY}
    ...    expected_status=200

Sending Request With EMR Appointment ID Not Matches AccountNumber In Fusebox (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC65
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Sending Body Request With All Billing Fields
    ...    head_account_arg=${head_0_data}
    ...    account_number_arg=${head_0_acc1}
    ...    expected_status=400
    Should Contain    ${bill_response_json['detail']}    Can not find the appointment.

Sending Request With All Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC66
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 0
    Sending Request With Accountid Valid And EMR Appointment ID Doesn't Exist In The Fusebox System    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval" (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC67
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Sending Request With All Accountid Valid And Appointment Has Status Is "RequiresApproval"    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC68
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    # Test Setup With List Account = 0
    Sending Request With All Fileds In Request Body And Response Body Not Include CPT Code    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC69
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    # Test Setup With List Account = 0
    Sending Request With All Fileds In Request Body And Response Body Not Include NPI, ICDCodes, CPT Code, EffectiveDate, Payor Type    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

Sending Request With Fields Has Type=Array Containing Multiple Data (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC70
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    [Setup]    NONE
    Test Setup With List Account = 0
    Sending Request With Fields Has Type=Array Containing Multiple Data    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}    locationPO_arg=${head_0_PO1}

Check The API Response Error When No Authentication Token Is Present (Listaccount = 0, AccountNumber = valid)
    [Documentation]    B33629_TC71
	[Tags]    API    Billing
    ...  report.label.owner: Hai Nguyen
    Check The API Response Error When No Authentication Token Is Present    head_account_arg=${head_0_data}    account_num_arg=${head_0_acc1}

*** Keywords ***
Suite Setup
    Billing.Setup Data
    Get URL API Patient
    Get URL API Appointment
    Get URL API Dispense
    Get URL API Billing
    ${patient_list}=    Create List
    Set Suite Variable    ${patient_list}

Test Setup
    Patient.Create New Patient    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Appointment.Sending Request To Create New Appointment    head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}
    Dispense.Sending Request To Dispense Appointment     head_account_arg=${head_multi_data}    account_num_arg=${head_multi_acc1}

Suite Teardown
    Delete Patient From Patient List
    Close Browser

