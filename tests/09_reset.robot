*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Reset simulator clears active sessions
    Attach UE-1
    Verify attach status attached
    Attach UE-2
    Verify attach status attached
    Reset Simulator
    UEs list should be empty

TC02 Reset simulator clears stats
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Start udp traffic-50 Mbps on UE-1 bearer-9
    Verify operation status traffic_started
    Reset Simulator
    ${stats}=    Get UEs Stats
    ${ues_count}=    Get From Dictionary    ${stats}    ue_count
    Should Be Equal As Integers    ${ues_count}    0
    ${bearer_count}=    Get From Dictionary    ${stats}    bearer_count
    Should Be Equal As Integers    ${bearer_count}    0
    ${total_tx_bps}=    Get From Dictionary    ${stats}    total_tx_bps
    Should Be Equal As Integers    ${total_tx_bps}    0