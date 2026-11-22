*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Ordering/Ordering.resource
Resource    ../../../resources/PageObjects/Keywords/TrackOrders/TrackOrders.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Test Tags    test:retry(1)    Prime    trackOders    Smoke    aws    TO_01

Suite Setup    Setup Suite
Test Setup    Setup Test Case
Task Teardown    Teardown Test Case
Suite Teardown    Teardown Suite

*** Variables ***
${input_data}

*** Test Cases ***
Create Track Order To View Shipment Event
    [Documentation]    Verify View Shipment Event Sucessfully
    [Tags]    SHIP-1
    ...  report.label.owner:Quoc Nguyen
    TrackOrders.Go To Track Orders
    TrackOrders.Search Order    ${po_number}
    ${order_id}    TrackOrders.Get Order Number Id    ${po_number}
    ${item_id}    TrackOrders.Get Item Line Id    ${po_number}    ${input_data}[ndc]
    TrackOrders.Complete Set Tracking Number    ${order_id}    ${item_id}    ${input_data}[carrier]    ${input_data}[track_number]
    TrackOrders.Complete Add Shipment Event    ${order_id}    ${item_id}    ${input_data}[location]    ${input_data}[date]    ${input_data}[time]    ${input_data}[activity]
    TrackOrders.View Shipment Event    ${item_id}    ${input_data}[location]    ${input_data}[date]    ${input_data}[time]    ${input_data}[activity]

*** Keywords ***
Setup Suite  
    ${input_data}    Get Data
    Login To Fusebox    user_name=${Username}    password=${Password}
    Set Suite Variable    ${input_data}   

Setup Test Case
    Create New Order
    Generate Data Test

Teardown Test Case
    Go To    ${SiteUrl}
    Wait Until Keyword Succeeds    30s    1s    Title Should Be    Home

Teardown Suite
    Close Browser

Create New Order
    NewOrder.Go Order
    NewOrder.Select Customer Account    ${input_data}[checked_location]
    NewOrder.Find NDC    ${input_data}[ndc]
    NewOrder.Filter By Vendor    ${input_data}[order_vendor]
    NewOrder.Add Quality    1
    NewOrder.Config My Cart
    NewOrder.Submit Order
    Wait Until Keyword Succeeds    30s    1s    Title Should Be   Open Orders

Generate Data Test
    ${current_time}    Get Time Now
    ${random_track_number}    Evaluate    ''.join(str(random.randint(0,9)) for _ in range(6))    random
    ${random_time}    Convert Date    ${current_time}    result_format=%H:%M    date_format=%Y-%m-%d %H:%M:%S.%f          
    ${random_day}    Evaluate    random.randint(1, 365)    random
    ${random_date}    Add Time To Date    date=${current_time}    time=${random_day} days    result_format=%#m/%#d/%Y    date_format=%Y-%m-%d %H:%M:%S.%f
    Set To Dictionary    ${input_data}    track_number=${random_track_number}
    Set To Dictionary    ${input_data}    time=${random_time}
    Set To Dictionary    ${input_data}    date=${random_date}
