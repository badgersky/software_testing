*** Settings ***
Library          Collections
Variables        ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library          ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource         ${CURDIR}/../resources/common_keywords.robot
Test Setup       Reset Simulator

*** Test Cases ***
TC01 Check current traffic for default bearer
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Check traffic for UE-1 bearer-9
    Verify traffic check response contains UE-1 bearer-9
    Verify checked traffic target should be-5000 kbps

TC02 Check current traffic for dedicated bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Start udp traffic-2500 kbps on UE-1 bearer-5
    Verify traffic status traffic_started
    Check traffic for UE-1 bearer-5
    Verify traffic check response contains UE-1 bearer-5
    Verify checked traffic target should be-2500 kbps

TC03 Check summary traffic for UE with multiple active bearers
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start udp traffic-2500 kbps on UE-1 bearer-5
    Verify traffic status traffic_started
    Check summary traffic for UE-1
    Verify traffic summary should contain transfer fields
    Verify traffic summary should show UE count-1
    Verify traffic summary should show bearer count-2

TC04 Check traffic default unit is kbps
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Check traffic for UE-1 bearer-9
    Verify checked traffic value in default unit should be-5000

TC05 Check summary traffic without bearer ID
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Check summary traffic for UE-1
    Verify traffic summary should contain transfer fields
    Verify traffic summary should show UE count-1
    Verify traffic summary should show bearer count-1

TC06 Check traffic for inactive bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Check traffic for UE-1 bearer-5
    Verify traffic check response should be error

*** Keywords ***
Check traffic for UE-${ue_id} bearer-${bearer_id}
    ${response}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify traffic check response contains UE-${ue_id} bearer-${bearer_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${ue_id_as_int}=    Convert To Integer    ${ue_id}
    ${bearer_id_as_int}=    Convert To Integer    ${bearer_id}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    ue_id    ${ue_id_as_int}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    bearer_id    ${bearer_id_as_int}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    target_bps
    Dictionary Should Contain Key    ${LAST_RESPONSE}    tx_bps
    Dictionary Should Contain Key    ${LAST_RESPONSE}    rx_bps
    Dictionary Should Contain Key    ${LAST_RESPONSE}    duration

Verify checked traffic target should be-${expected_value} kbps
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${target_bps}=    Get From Dictionary    ${LAST_RESPONSE}    target_bps
    ${expected_bps}=    Evaluate    int($expected_value) * 1000
    Should Be Equal As Integers    ${target_bps}    ${expected_bps}

Verify checked traffic value in default unit should be-${expected_value}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${target_bps}=    Get From Dictionary    ${LAST_RESPONSE}    target_bps
    ${actual_kbps}=    Evaluate    int($target_bps) // 1000
    Should Be Equal As Integers    ${actual_kbps}    ${expected_value}

Check summary traffic for UE-${ue_id}
    ${response}=    Get Ues Stats    ${ue_id}    ${True}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify traffic summary should contain transfer fields
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    scope
    Dictionary Should Contain Key    ${LAST_RESPONSE}    ue_count
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearer_count
    Dictionary Should Contain Key    ${LAST_RESPONSE}    total_tx_bps
    Dictionary Should Contain Key    ${LAST_RESPONSE}    total_rx_bps
    Dictionary Should Contain Key    ${LAST_RESPONSE}    details

Verify traffic summary should show UE count-${expected_count}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${expected_count_as_int}=    Convert To Integer    ${expected_count}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    ue_count    ${expected_count_as_int}

Verify traffic summary should show bearer count-${expected_count}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${expected_count_as_int}=    Convert To Integer    ${expected_count}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    bearer_count    ${expected_count_as_int}