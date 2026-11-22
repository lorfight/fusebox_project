*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    XML
Library    String
Library    DateTime

Resource    ../../../resources/PageObjects/Keywords/ProviderOrders.resource

*** Keywords ***
Nevigate To HL7 Tools Page
    [Arguments]    ${File_Type}    ${Sendor}
    Click Element    //*[@id="navbar-collapse"]/ul[2]/li[2]/a
    Wait Until Element Is Visible    //*[@id="navbar-collapse"]/ul[2]/li[2]/ul    10s
    Click Element    //*[@id="navbar-collapse"]/ul[2]/li[2]/ul/li[10]/a
    Click Button    //*[@id="ddlFileTypeFilter"]/div/button
    Input Text    //*[@id="ddlFileTypeFilter"]/div/button    ${File_Type}
    Press Key    //*[@id="ddlFileTypeFilter"]/div/button    \\13
    Click Button    //*[@id="ddlSenderFilter"]/div/button
    Input Text    //*[@id="ddlSenderFilter"]/div/div/div/input    ${Sendor}
    Click Element    //*[@id="SearchButton"]      

# Get data from Edit Account Page
Navigate To Edit Account Page
    Click Element    //*[@id="navbar-collapse"]/ul[2]/li[2]/a
    Wait Until Element Is Visible    //*[@id="navbar-collapse"]/ul[2]/li[2]/ul    10s
    Click Element    //*[@id="navbar-collapse"]/ul[2]/li[2]/ul/li[5]/a
    Wait Until Element Is Visible    //*[@id="SearchValues"]    10s
    Input Text    //*[@id="SearchValues"]    112103
    Click Button    //*[@id="FindButton"]    

Get Value From Edit Account Page
    Navigate To Edit Account Page
    Wait Until Element Is Visible    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a    10s
    ${account_number}=    Get Text    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a 
    Click Element    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a
    Wait Until Element Is Visible    //*[@id="Technical"]    30s
    Click Element    //*[@id="Technical"]
    
    ${emr_mapping}=    Get Selected List Label    //*[@id="EMRMapping"]
    ${convert_emr_mapping_ui}=    Replace String    ${emr_mapping}    Meditab North Texas Allergy and Asthma    Meditab_NTAA
    ${practice_analyzer_id}=    Get Value    //*[@id="PracticeAnalyzerIdentifier"]

    ${account_data}=    Create Dictionary
    ...                 AccountNumber=${account_number}
    ...                 EMRMapping=${convert_emr_mapping_ui}
    ...                 PracticeAnalyzerID=${practice_analyzer_id}
    
    RETURN    ${account_data}

Get Value System ProprietaryName From Edit Account Page
    [Arguments]    ${emr_proprietary_name}
    Navigate To Edit Account Page
    Wait Until Element Is Visible    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a    10s
    Click Element    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a
    Wait Until Element Is Visible    //*[@id="Technical"]    30s
    Click Element    //*[@id="Technical"]
    Util.Scroll To Bottom
    Wait Until Element Is Visible    //*[contains(text(), 'EMR Medication Name Conversions ')]    30s
    Click Element    //*[contains(text(), 'EMR Medication Name Conversions ')]
    Wait Until Element Is Visible    //*[@id="ModalPopup"]/div[2]/div/div[2]    5s
    ${xpath_system_prop_name}=    Set Variable    //*[td[1]//input[@id='EMRPropName' and @value='${emr_proprietary_name}']]/td[2]//button/span[1]
    ${system_prop_name}=    Get Text    ${xpath_system_prop_name}   
    RETURN    ${system_prop_name}

Get Value EMR Proprietary Name From Edit Account Page
    Navigate To Edit Account Page
    Wait Until Element Is Visible    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a    10s
    Click Element    //*[@id="AccountList"]/div[2]/table/tbody/tr[1]/td[1]/a
    Wait Until Element Is Visible    //*[@id="Technical"]    30s
    Click Element    //*[@id="Technical"]
    Util.Scroll To Bottom
    Click Element    //*[contains(text(), 'EMR Medication Name Conversions ')]
    Wait Until Element Is Visible    //*[@id="ModalPopup"]/div[2]/div/div[2]    5s
    ${emr_proprietary_name_count}=    Get Element Count     //*[td[2]//*[@data-id='SystemPropName']//*[text()='Xolair']][*]/td[1]//*[@id='EMRPropName']
    ${emr_proprietary_name_list}=    Create List
    FOR    ${index}    IN RANGE    1    ${emr_proprietary_name_count}+1
        ${element_emr_proprietary_name}=    Get Value    //*[td[2]//*[@data-id='SystemPropName']//*[text()='Xolair']][${index}]/td[1]//*[@id='EMRPropName']
        Append To List    ${emr_proprietary_name_list}    ${element_emr_proprietary_name}
    END
    RETURN    ${emr_proprietary_name_list}

    







