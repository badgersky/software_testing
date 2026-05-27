*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Start traffic on active default bearer
    Attach UE-1
    Verify attach status attached
    Start traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-5000000

TC02 Start traffic on non existing UE should be rejected
    Start traffic-5000 kbps on UE-999 bearer-9
    Verify traffic response should be error

TC03 Start traffic on non existing bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Start traffic-5000 kbps on UE-1 bearer-10
    Verify traffic response should be error

*** Keywords ***
Start traffic-${traffic_value} kbps on UE-${ue_id} bearer-${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    udp    ${0}    ${traffic_value}    ${0}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Traffic target for UE-${ue_id} bearer-${bearer_id} should be-${expected_target}
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    ${bearer}=    Get From Dictionary    ${bearers}    ${bearer_id}
    ${expected_target_int}=    Convert To Integer    ${expected_target}
    Dictionary Should Contain Item    ${bearer}    target_bps    ${expected_target_int}