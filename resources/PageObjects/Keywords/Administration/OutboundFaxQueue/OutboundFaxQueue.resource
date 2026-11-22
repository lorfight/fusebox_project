*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${account_id}    //select[@id='AccountId']
${outbound_fax_list}    //*[@id='OutboundFaxQueueList']

*** Keywords ***
Go To Outbound Fax Queue
    Click Element    link:Administration
    Click Element    link:Outbound Fax Queue

Select Account
    [Arguments]    ${account_arg}
    Wait Until Keyword Succeeds    30s    1s    Select From List By Label    ${account_id}    ${account_arg}

Check Fax Queue List Displays
    [Arguments]    ${account_arg}
    Select Account    ${account_arg}
    Wait Until Element Is Visible    ${outbound_fax_list}    30s

