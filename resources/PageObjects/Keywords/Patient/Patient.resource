*** Settings ***
Resource    ../Layers/Patient/Patient.resource
Resource    PatientList/PatientList.resource
Resource    UpdateAPatient/UpdateAPatient.resource
# Resource    ../LoginKeywords.resource

*** Keywords ***
Test Setup Patient Management
    [Arguments]    ${title_arg}    ${mrn_arg}    ${location_arg}
    # Reload Page
    # ${check_logout}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    Log In
    # ${check_disconnect}    Run Keyword And Return Status    Wait Until Keyword Succeeds    3s    1s    Title Should Be    fusebox-portal-staging.azurewebsites.net
    # IF    "${check_logout}" == "${True}"
    #     LoginKeywords.Login account    ${Username}    ${Password}
    #     PatientList.Navigate to Patient by Generated MRN    ${mrn_arg}    ${location_arg}
    # ELSE IF    "${check_disconnect}" == "${True}"
    #     Wait Until Keyword Succeeds    15 min    10s    Wait Until Page Is Connected
    #     PatientList.Navigate to Patient by Generated MRN    ${mrn_arg}    ${location_arg}
    # END
    Common.Open New Window    ${title_arg}

# Wait Until Page Is Connected
#     Reload Page
#     Title Should Be    Home
