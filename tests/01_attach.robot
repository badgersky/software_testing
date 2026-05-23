*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Attach UE successfully
    Attach UE-1
    verify attach status attached
    verify UE-1 is attached 
    verify UE-1 has bearer-9

TC02 Attach UE second time 
    Attach UE-2
    verify attach status attached
    Attach UE-2
    verify attach response is duplicate
    verify UE-2 is attached

TC03 Attach UE max id
    Attach UE-100
    verify attach status attached
    verify UE-100 is attached
    verify UE-100 has bearer-9

TC04 Attach UE min id
    Attach UE-0
    verify attach status attached
    verify UE-0 is attached
    verify UE-0 has bearer-9

TC05 Attach UE above max id
    Attach UE-101
    Verify attach response should be error

TC06 Attach UE below min id
    Attach UE--1
    Verify attach response should be error

*** Keywords ***
Attach UE-${ue_id}
    ${response}=    Attach UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

verify UE-${ue_id} is attached
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Should Not Be Equal    ${response}    ${None}

verify UE-${ue_id} has bearer-${bearer_id}
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    Dictionary Should Contain Key    ${bearers}    ${bearer_id}

verify attach response is duplicate
    Dictionary Should Contain Item    ${LAST_RESPONSE}    detail    UE already attached

verify attach status ${expected_status}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}

Verify attach response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail