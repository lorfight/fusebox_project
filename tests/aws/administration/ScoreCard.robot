*** Settings ***
Resource    ../../../resources/PageObjects/Keywords/Administration/Administration.resource
Resource    ../../../resources/PageObjects/Keywords/LoginKeywords.resource
Resource    ../../../resources/PageObjects/Keywords/CommonKeywords.resource
Suite Setup    Suite Set Up Keyword
Suite Teardown    Close Browser

Test Tags    PrimeSmoke_ADM    test:retry(2)    ADM_109

*** Test Cases ***
Verify Score Card Functionality
    [Documentation]    Score Card
    [Tags]    Admin
    ...    test_id:[ADM-59]    [ADM-60]    [ADM-61]    [ADM-62]    [ADM-63]
    ...  report.label.owner:Nga Phan
    Go To Score Card
    Filter Location In Score Card    ${ad_data.location}
    Filter By Date ScoreCard
    ${category_detail}    Create New Category    ${ad_data}
    ${Fake_dict}    Generate Fake Data
    ${metric_detail}    Add New Metrics    ${ad_data}    ${Fake_dict['demical_2d']}    ${category_detail}
    Edit Metric    ${category_detail}    ${metric_detail}    ${Fake_dict['demical_2d']}
    Check Score Card List Is Visible    ${category_detail}
    Click Recalculate Scores
    Remove Metric And Category    ${category_detail}

*** Keywords ***
Setup Data
    ${data_input}    Get Data
    Set To Dictionary    ${ad_data}    
    ...    location=${data_input}[location]

Suite Set Up Keyword
    LoginKeywords.Login To Fusebox    user_name=${Username}    password=${Password}
    &{ad_data}    Create Dictionary
    Set Suite Variable    ${ad_data}
    Setup Data