*** Settings ***
Library         Collections

*** Keywords ***
Attach UE-${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify ${operation} status ${expected_status}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}

Verify ${operation} response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail

Add bearer-${bearer_id} to UE-${ue_id}
    ${response}=    Add Bearer    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Delete bearer-${bearer_id} from UE-${ue_id}
    ${response}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

UEs list should be empty
    ${response}=    Get UEs
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    ${ues}=    Get From Dictionary    ${LAST_RESPONSE}    ues
    Length Should Be    ${ues}    0

Detach UE-${ue_id}
    ${response}=    Detach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}