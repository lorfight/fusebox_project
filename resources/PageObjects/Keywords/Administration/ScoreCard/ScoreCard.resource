*** Settings ***
Resource    ../../Layers/Common/Common.resource
Library    ../../Layers/Fakedata/FakeData.py
Resource    ../../../../../libraries/Util.resource

*** Variables ***
${location_filter_scorecard}    //button[@data-id='MemberID']
${category_filter}    //*[@id='Category']
${date_filter_scorecard}    //*[@id='dp1763348588453']
${add_category_btn}    //*[@id='NewCategoryBtn']
${recalculate_score_btn}    //*[@id='RecalculateScore' and not(contains(@class,'disabled'))]
${category_select_scorecard}    //*[@id='AssignCategoryType']
${create_category_btn}    //*[@id='SaveCategoryBtn']
${remove_category}    //*[@class and contains(text(),'Remove Category')]
${metric_select}    //select[contains(@class,'AssignMetricType')]
${save_metric}    //*[@class and contains(text(),'Save Metric')]
${scorecard_list}    //*[@id='ScoreCardList']
${edit_metric}    //*[@class and contains(text(),'Edit Metric')]
${remove_metric}    //*[@class and contains(text(),'Remove Metric')]

*** Keywords ***
Go To Score Card
    Click Element    link:Administration
    Click Element    link:Score Card

Filter Location In Score Card
    [Arguments]    ${location_arg}
    # Select From List By Label    ${location_filter_scorecard}    ${location_arg}
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${location_filter_scorecard}
    Wait Until Keyword Succeeds    30s    1s    Click Element    //span[contains(text(),'${location_arg}')]

Filter By Date ScoreCard
    ${date}    Get Time Now    result_format=%Y_%m_%d_%H%M%S
    ${date}    Convert Date    ${date}    result_format=%m/%d/%Y
    Clear Input Field Until Empty    //input[contains(@class,'ResultDate')]
    Wait Until Keyword Succeeds    30s    1s    Input Text    //input[contains(@class,'ResultDate')]    ${date}
    Close Calendar Table
    
Click Add New Category
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${add_category_btn}

Click Recalculate Scores
    Wait Until Page Contains Element    ${recalculate_score_btn}    180s
    Wait Until Keyword Succeeds    5times    30s    Click Element    ${recalculate_score_btn}
    Common.Page Alert Message    Scores Recalculated.    180s

Select A Category
    [Arguments]    ${dict}
    ${dict}    Common.Choose Random Value From Select List    xpath_arg=${category_select_scorecard}    var_name=category_select_scorecard    dic=${dict}
    ${category_detail}    Get Selected List Label    ${category_select_scorecard}
    Set Test Variable    ${category_detail}
    RETURN    ${category_detail}

Click Create Category
    [Arguments]    ${category_detail}
    ${create_category_btn}    Set Variable    //*[contains(text(),'${category_detail}')]//following::a[@id='SaveCategoryBtn']
    Click Element    ${create_category_btn}

Click View/Add Metrics
    [Arguments]    ${category_detail}
    ${view_add_metrics}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::a[@class and contains(text(),'View/Add Metrics')]
    Click Element    ${view_add_metrics}

Click Add New Metric
    [Arguments]    ${category_detail}
    ${add_new_metric}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::tr[contains(@class,"ScoreCardMetricRow") and not(contains(@class,'hidden'))]//a[@class and contains(text(),'Add New Metric')]
    Click Element    ${add_new_metric}
    
Select A Metric
    [Arguments]    ${dict}
    ${dict}    Common.Choose Random Value From Select List    xpath_arg=${metric_select}    var_name=metric_select    dic=${dict}
    ${metric_detail}    Get Selected List Label    ${metric_select}
    Set Test Variable    ${metric_detail}
    RETURN    ${metric_detail}

Input Max Score
    [Arguments]    ${score_arg}    ${metric_detail}
    ${score_input}    Set Variable    //*[option[contains(text(),'${metric_detail}')]]//following::input[contains(@class,'MaxScore')]
    Clear Input Field Until Empty    ${score_input}
    Input Text Into Field    ${score_input}    ${score_arg}

Update Max Score
    [Arguments]    ${score_arg}    ${category_detail}    ${metric_detail}
    ${score_input}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::strong[@class and contains(text(),'${metric_detail}')]//following::input[contains(@class,'MaxScore')]
    Clear Input Field Until Empty    ${score_input}
    Input Text Into Field    ${score_input}    ${score_arg}

Click Create Metric
    [Arguments]    ${metric_detail}
    ${create_metric_btn}    Set Variable    (//*[option[contains(text(),'${metric_detail}')]]//following::a[@class and contains(text(),'Create Metric')])[1]
    Click Element    ${create_metric_btn}

Click Edit Metric
    [Arguments]    ${category_detail}    ${metric_detail}
    ${edit_metric}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::strong[@class and contains(text(),'${metric_detail}')]//following::a[@class and contains(text(),'Edit Metric')]
    Wait Until Page Contains Element    ${edit_metric}    200s
    Click Element    ${edit_metric}

Click Save Metric
    [Arguments]    ${category_detail}    ${metric_detail}
    ${save_metric}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::strong[@class and contains(text(),'${metric_detail}')]//following::*[@class and contains(text(),'Save Metric')]
    Wait Until Page Contains Element    ${save_metric}    200s
    Click Element    ${save_metric}

Click Remove Metric
    [Arguments]    ${category_detail}
    ${remove_metric}    Set Variable    (//strong[contains(text(),'${category_detail}')]//following::a[@class and contains(text(),'Remove Metric')])[1]
    Wait Until Page Contains Element    ${remove_metric}    200s
    
    Wait Until Keyword Succeeds    30s    1s    Click Element    ${remove_metric}

Click Remove Category
    [Arguments]    ${category_detail}
    ${add_new_metric}    Set Variable    //strong[contains(text(),'${category_detail}')]//following::a[@class and contains(text(),'Remove Category')]
    Click Element    ${remove_category}

Create New Category
    [Arguments]    ${dict}
    Click Add New Category
    ${category_detail}    Select A Category    ${dict}
    Click Create Category    ${category_detail}
    Common.Page Alert Message    Category Successfully Added.
    RETURN    ${category_detail}

Add New Metrics
    [Arguments]    ${dict}    ${score_arg}    ${category_detail}
    Click View/Add Metrics    ${category_detail}
    Click Add New Metric    ${category_detail}
    ${metric_detail}    Select A Metric    ${dict}
    Input Max Score    ${score_arg}    ${metric_detail}
    Click Create Metric    ${metric_detail}
    Common.Page Alert Message    Metric Successfully Added.
    RETURN    ${metric_detail}

Edit Metric
    [Arguments]    ${category_detail}    ${metric_detail}    ${score_arg}
    Click Edit Metric    ${category_detail}    ${metric_detail}
    Update Max Score    ${score_arg}    ${category_detail}    ${metric_detail}
    Click Save Metric    ${category_detail}    ${metric_detail}
    Common.Page Alert Message    Metric Successfully Added.

Remove Metric And Category
    [Arguments]    ${category_detail}
    Click View/Add Metrics    ${category_detail}
    WHILE    True
        ${count}=    Get Element Count    //strong[contains(text(),'${category_detail}')]//following::a[@class and contains(text(),'Edit Metric')]
        Run Keyword If    ${count}==0    Exit For Loop
        Click Element    (//strong[contains(text(),'${category_detail}')]//following::a[@class and contains(text(),'Edit Metric')])[1]
        Click Remove Metric    ${category_detail}
        Common.Page Alert Message    Metric Successfully Removed.
    END
    Click Remove Category    ${category_detail}
    Common.Page Alert Message    Category Successfully Removed.
    
Check Score Card List Is Visible
    [Arguments]    ${category_detail}
    Wait Until Element Is Visible        ${scorecard_list}
    ${category_item}    Set Variable    //strong[contains(text(),'${category_detail}')]
    # Wait Until Element Is Visible    ${category_item}

