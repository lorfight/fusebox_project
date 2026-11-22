*** Settings ***
Documentation      Verify the functionality of various inventory reports.
# Library    SeleniumLibrary    plugins=${EXECDIR}/libraries/AllureSeleniumPlugin.py    run_on_failure=Capture Page Screenshot
Resource   ../../../resources/PageObjects/Keywords/InventoryLevel.resource
Resource   ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource   ../../../resources/PageObjects/Keywords/CommonKeywords.resource

Suite Setup    Setup Suite
Test Setup    Test Setup  
Test Teardown    Close Browser Session

*** Variables ***
${data_input}

*** Test Cases ***
Verify Inventory Report: Grams On Hand
    [Tags]    Admin    Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Report
    ...  report.label.story:Grams On Hand
  ${type_report}=    Set Variable    Grams On Hand
  # Get Inventory Level Table
  Click Inventory Reports
  Select Inventory Report    ${type_report}
  Switch Tab
  Read Inventory Report PDF     ${type_report}

Verify Inventory Report: Print Inventory
    [Tags]    Admin    Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Report
    ...  report.label.story:Print Inventory
  ${type_report}=    Set Variable    Print Inventory
  Click Inventory Reports
  Select Inventory Report    ${type_report}
  Switch Tab
  Read Inventory Report PDF    ${type_report}

Verify Inventory Report: Inventory In Transit
    [Tags]    Admin    Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Report
    ...  report.label.story:Inventory In Transit
  ${type_report}=    Set Variable    Inventory In Transit
  Click Inventory Reports
  Select Inventory Report    ${type_report}
  Switch Tab
  Read Inventory Report PDF    ${type_report}

Verify Inventory Report: Print Detailed Inventory
    [Tags]    Admin    Regression    Inventory
    ...  report.label.owner:Cuong Pham
    ...  report.label.severity:normal
    ...  report.label.epic:Inventory Management
    ...  report.label.feature:Inventory Report
    ...  report.label.story:Inventory In Transit
  ${type_report}=    Set Variable    Print Detailed Inventory
  Click Inventory Reports
  Select Inventory Report    ${type_report}
  Switch Tab
  Read Inventory Report CSV   ${type_report}


# Verify Inventory Report: Inventory Transaction Report
#   ${type_report}=    Set Variable    Inventory Transaction Report
#   Click Inventory Reports
#   Select Inventory Report    ${type_report}
#   Switch Tab
#   Read Inventory Report CSV    ${type_report}


# Verify Inventory Report: Inventory History Report
#   ${type_report}=    Set Variable    Inventory History Report
#   Click Inventory Reports
#   Select Inventory Report    ${type_report}
#   Switch Tab
#   Read Inventory Report CSV    ${type_report}

*** Keywords ***
Setup Suite
  ${data_input}    Get Data
  Set Suite Variable    ${data_input}
  

Test Setup
  LoginKeywords.Login To Fusebox    ${Username}    ${Password}
  Go Inventory Level
  CommonKeywords.Select Location    AccountId    ${data_input}[checked_location]