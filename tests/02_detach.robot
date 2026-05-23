*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Detach attached UE successfully
    Attach UE-1
    Verify attach status attached
    Detach UE-1
    Verify detach status detached
    UE-1 should not exist

*** Keywords ***
Detach UE-${ue_id}
    ${response}=    Detach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

UE-${ue_id} should not exist
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    verify detach response should be error

verify detach response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail