*** Settings ***
Library    Collections
Library    ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Test Setup    Reset Simulator

*** Variables ***
${BASE_URL}    http://192.168.0.146:8000/ues

*** Test Cases ***
TC01 Attach UE successfully
    Attach UE-1
    UE-1 should be attached    # zmienić konwencję bardziej jako verify/ coś sprawdzam, a nie zdaniem twierdzącym)
    UE-1 should have bearer-9
# dopisać czy status attach (sprawdzić pełną odpwowiedź)
*** Keywords ***
Attach UE-${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

UE-${ue_id} should be attached
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Should Not Be Equal    ${response}    ${None}

UE-${ue_id} should have bearer-${bearer_id}
    ${bearers}=    Set Variable    ${LAST_RESPONSE}[bearers]
    Dictionary Should Contain Key    ${bearers}    ${bearer_id}