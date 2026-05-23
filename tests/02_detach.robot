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

TC02 Detach non attached UE should be rejected
    Detach UE-1
    Verify detach response should be error

TC03 Detach UE twice should be rejected on second attempt
    Attach UE-1
    Verify attach status attached
    Detach UE-1
    Verify detach status detached
    Detach UE-1
    Verify detach response should be error

TC04 Detach below range should be error
    Detach UE--1
    Verify detach response should be error

TC05 Detach above range should be error
    Detach UE-101
    Verify detach response should be error

TC06 Detach UE with active traffic
    Attach UE-1
    Verify attach status attached
    Start traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
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
    Verify detach response should be error

Start traffic-${traffic_value} kbps on UE-${ue_id} bearer-${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    udp    ${0}    ${traffic_value}    ${0}
    Set Test Variable    ${LAST_RESPONSE}    ${response}