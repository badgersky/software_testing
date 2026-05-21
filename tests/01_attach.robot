*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Attach UE successfully
    Attach UE-1
    verify UE-1 is attached   # zmienić konwencję bardziej jako verify/ coś sprawdzam, a nie zdaniem twierdzącym)
    verify UE-1 has bearer-9
# dopisać czy status attach (sprawdzić pełną odpwowiedź)

TC02 Attach UE second time 
    Attach UE-2
    Attach UE-2
    verify attach response is duplicate
    verify UE-2 is attached

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