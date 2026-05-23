*** Settings ***
Library         Collections

*** Keywords ***
Attach UE-${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

verify attach status ${expected_status}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}