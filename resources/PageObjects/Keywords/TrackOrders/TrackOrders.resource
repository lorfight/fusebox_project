*** Settings ***
Resource    ./Common/TrackOrdersCommon.resource

*** Variables ***
${order_search_input_xpath}    //input[@id="SearchValues"]
${search_button_xpath}    //div[@class="row"]//a[contains(@class,"TrackingLedgerSearchBtn")]
${carrier_select_xpath}    //select[@id="item_Carrier"]
${tracking_number_input_xpath}    //input[@id="item_TrackingNumber"]
${apply_to_empty_item_checkbox_xpath}    //input[@id="FillEmpty"]
${add_shipment_location_input_xpath}    //tr[.//a[contains(@class,"quickSave")]]/td[1]/input
${add_shipment_date_input_xpath}    //tr[.//a[contains(@class,"quickSave")]]/td[2]/input
${add_shipment_time_input_xpath}    //tr[.//a[contains(@class,"quickSave")]]/td[3]/input
${add_shipment_activity_input_xpath}    //tr[.//a[contains(@class,"quickSave")]]/td[4]/input
${add_shipment_button_xpath}    //a[contains(@class,"quickSave")]

*** Keywords ***
Go To Track Orders
    Click Element    link:Track Orders
    Title Should Be    Track Orders
    Util.Waiting For Loading

Fill Search Order
    [Arguments]    ${order_number}
    Wait Until Element Is Enabled    ${order_search_input_xpath}    30s
    Input Text    ${order_search_input_xpath}    ${order_number}

Click Search Button
    Wait Until Element Is Enabled    ${search_button_xpath}    30s
    Click Element    ${search_button_xpath}

Get Order Number Id
    [Arguments]    ${order_number}
    ${order_element_xpath}    Set Variable    //a[@data-original-title="View Confirmation" and contains(text(),"${order_number}")]
    Wait Until Element Is Visible    ${order_element_xpath}    30s
    ${order_href}    Get Element Attribute    ${order_element_xpath}    href
    ${order_ids}    Get Regexp Matches    ${order_href}    orderId=(.*)    1
    RETURN    ${order_ids}[0]

Get Item Line Id
    [Arguments]    ${order_number}    ${ndc}
    ${item_line_element_xpath}    Set Variable    //tr[.//a[contains(text(),"${order_number}")]]//tr[.//td[contains(.,"${ndc}")]]
    Wait Until Element Is Visible    ${item_line_element_xpath}    30s
    ${item_line_id}    Get Element Attribute    ${item_line_element_xpath}    data-item
    RETURN    ${item_line_id}

Select Item Status Option
    [Arguments]    ${item_id}    ${status}
    ${item_status_select_xpath}    Set Variable    //select[@id="Status" and @data-lineid="${item_id}"]
    Select From List By Label    ${item_status_select_xpath}    ${status}

Select Carrier Option
    [Arguments]    ${carrier}
    Wait Until Element Is Enabled    ${carrier_select_xpath}    30s
    Select From List By Label    ${carrier_select_xpath}    ${carrier}

Fill Tracking Number Input
    [Arguments]    ${tracking_number}
    Wait Until Element Is Enabled    ${tracking_number_input_xpath}    30s
    Input Text    ${tracking_number_input_xpath}    ${tracking_number}

Tick Apply to All Empty Items Checkbox
    Wait Until Element Is Enabled    ${apply_to_empty_item_checkbox_xpath}    30s
    Select Checkbox    ${apply_to_empty_item_checkbox_xpath}

Untick Apply to All Empty Items Checkbox
    Wait Until Element Is Enabled    ${apply_to_empty_item_checkbox_xpath}    30s
    Unselect Checkbox    ${apply_to_empty_item_checkbox_xpath} 

Click Track Number Button
    [Arguments]    ${order_id}    ${item_id}
    ${track_number_button_xpath}    Set Variable    //span[contains(@onclick,"TrackingNumberModal") and contains(@onclick,"${order_id}") and contains(@onclick,"${item_id}")]
    Wait Until Element Is Enabled    ${track_number_button_xpath}    30s
    Click Element    ${track_number_button_xpath}

Click Add Tracking Details Button
    [Arguments]    ${order_id}    ${item_id}
    ${add_tracking_details_xpath}    Set Variable    //a[contains(@onclick,"UpdateShippingTrackingInfoModal") and contains(@onclick,"${order_id}") and contains(@onclick,"${item_id}")]
    Wait Until Element Is Enabled    ${add_tracking_details_xpath}    30s
    Click Element    ${add_tracking_details_xpath}

Click View Shipment Event Button
    [Arguments]    ${item_id}
    ${shipment_event_button_xpath}    Set Variable    //a[@onclick="viewShipmentEvents('${item_id}');"]
    Wait Until Element Is Enabled    ${shipment_event_button_xpath}    30s
    Click Element    ${shipment_event_button_xpath}

Open Update Shipment Information Modal
    [Arguments]    ${order_id}    ${item_id}
    Util.Scroll To Bottom
    Click Add Tracking Details Button    ${order_id}    ${item_id}
    Wait Until Element Contains    id=ModalPopup    Update Shipment Information    30s
    Util.Waiting For Loading

Click Accept On Popup Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="AcceptBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="AcceptBtn"]

Click Close On Popup Modal
    Wait Until Element Is Enabled    //div[@id="ModalPopup"]//button[@id="CloseBtn"]    30s
    Click Button    //div[@id="ModalPopup"]//button[@id="CloseBtn"]

Fill Shipment Location Input
    [Arguments]    ${location}
    Wait Until Element Is Enabled    ${add_shipment_location_input_xpath}    30s
    Input Text    ${add_shipment_location_input_xpath}    ${location}

Fill Shipment Date Input
    [Arguments]    ${date}
    Wait Until Element Is Enabled    ${add_shipment_date_input_xpath}    30s
    Input Text    ${add_shipment_date_input_xpath}    ${date}

Fill Shipment Time Input
    [Arguments]    ${time}
    Wait Until Element Is Enabled    ${add_shipment_time_input_xpath}    30s
    Input Text    ${add_shipment_time_input_xpath}    ${time}

Fill Shipment Activity Input
    [Arguments]    ${activity}
    Wait Until Element Is Enabled    ${add_shipment_activity_input_xpath}    30s
    Input Text    ${add_shipment_activity_input_xpath}    ${activity}

Click Add Shipment Button
    Wait Until Element Is Enabled    ${add_shipment_button_xpath}    30s
    Click Element    ${add_shipment_button_xpath}

Search Order
    [Arguments]    ${order_number}
    Fill Search Order    ${order_number}
    Click Search Button
    Util.Waiting For Loading

Open Set Tracking Number
    [Arguments]    ${order_id}    ${item_id}
    Click Track Number Button    ${order_id}    ${item_id}
    Wait Until Element Contains    id=ModalPopup    Set Tracking Number    30s
    Util.Waiting For Loading

Fill Fields In Set Tracking Number Modal
    [Arguments]    ${carrier}    ${tracking_number}    ${is_fill_to_all_item}=${False}   
    Select Carrier Option    ${carrier}
    Fill Tracking Number Input    ${tracking_number}
    IF    ${is_fill_to_all_item}
        Tick Apply to All Empty Items Checkbox
    ELSE
        Untick Apply to All Empty Items Checkbox
    END

Fill Fields In Add Shipment Event
    [Arguments]    ${location}    ${date}    ${time}    ${activity}   
    Fill Shipment Location Input    ${location}
    Fill Shipment Date Input    ${date}
    Fill Shipment Time Input    ${time}
    Fill Shipment Activity Input    ${activity}

Complete Set Tracking Number
    [Arguments]    ${order_id}    ${item_id}    ${carrier}    ${tracking_number}    ${is_fill_to_all_item}=${False}
    Util.Scroll To Bottom
    Open Set Tracking Number    ${order_id}    ${item_id}
    Fill Fields In Set Tracking Number Modal    ${carrier}    ${tracking_number}    ${is_fill_to_all_item}
    Click Accept On Popup Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Complete Add Shipment Event
    [Arguments]    ${order_id}    ${item_id}    ${location}    ${date}    ${time}    ${activity}
    Util.Scroll To Bottom
    Open Update Shipment Information Modal    ${order_id}    ${item_id} 
    Fill Fields In Add Shipment Event    ${location}    ${date}    ${time}    ${activity}
    Click Add Shipment Button
    Util.Wait Alert Message Show And Disappear    Tracking Details Set!
    Util.Waiting For Loading
    Click Close On Popup Modal
    Wait Until Element Is Not Visible    //div[@id="ModalPopup"]    30s
    Util.Waiting For Loading

Wait Until Shipment Event Visible
    [Arguments]    ${item_id}    ${location}    ${date}    ${time}    ${activity}
    ${shipment_event_element_xpath}    Set Variable    //tr[@class="viewShipmentEvents" and @data-lineid="${item_id}"]//tr[./td/input[@value="${date}"] and ./td/input[@value="${time}"] and ./td/input[@value="${location}"] and ./td/input[@value="${activity}"]]
    Wait Until Element Is Visible    ${shipment_event_element_xpath}    30s

View Shipment Event
    [Arguments]    ${item_id}    ${location}    ${date}    ${time}    ${activity}
    Click View Shipment Event Button    ${item_id}
    ${shipment_event_view_element_xpath}    Set Variable    //tr[@class="viewShipmentEvents" and @data-lineid="${item_id}"]
    Wait Until Element Contains    ${shipment_event_view_element_xpath}    Shipping Activity / Events    30s
    Wait Until Shipment Event Visible    ${item_id}    ${location}    ${date}    ${time}    ${activity}



    


    
    
    