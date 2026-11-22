*** Settings ***
Documentation      Verify the order creation and cancellation functionality.
Variables  ../../../resources/PageObjects/TestData/Testdata.py

Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/InventoryTransfer.resource
Resource   ../../../resources/PageObjects/Keywords/Order.resource
Resource    ../../../resources/PageObjects/Keywords/OpenOrder.resource


Suite Setup    Set Up Suite
Test Teardown    Close Browser
Test Setup    Setup Test Case
Test Tags    test:retry(2)    OD_100


*** Test Cases ***
Verify Ordering
	[Documentation]   Verify that create order successful in case the data is valid.
	...    TC: [Ord-O001]_TC01
	[Tags]    Admin    Smoke    order
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Order
    ...  report.label.feature:Create Order
    ...  report.label.story:Order
	Create Order
	Open Order And Verify Create Order Succeeds

Verify Cancel Order
	[Documentation]   Verify Cancel Order
	[Tags]    Admin    order
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Order
    ...  report.label.feature:Cancel Order
    ...  report.label.story:Order
	Order.Go Order
	Order.Cancel Build Order
	Verify Cancel Order Success


*** Keywords ***
Create Order
	Order.Built New Order

Open Order And Verify Create Order Succeeds
	Open Orders
	Wait Until Keyword Succeeds    2times    5s    Search For An Order ${po_number}

Verify Cancel Order Success
    Title Should Be    Pending Orders

Set Up Suite
    ${data_input}    Get Data
	# Set Suite Variable    ${data_input}
	Set Suite Variable    $location   ${data_input}[checked_location]
	Set Suite Variable    $ndc    ${data_input}[ndc]
	Set Suite Variable    $vendor    ${data_input}[order_vendor]
	${order_qty}    Evaluate    random.choice(range(1, 10))    random
	Set Suite Variable    ${order_qty}
Setup Test Case
	LoginKeywords.Login To Fusebox    ${Username}    ${Password}

	