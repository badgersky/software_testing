*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Start TCP traffic in kbps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-5000000

TC02 Start TCP traffic in Mbps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-10 Mbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-10000000

TC03 Start TCP traffic in bps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-5000000 bps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-5000000

TC04 Start TCP traffic on non attached UE should be rejected
    Start tcp traffic-5000 kbps on UE-99 bearer-9
    Verify traffic response should be error

TC05 Start TCP traffic on non existing bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-5000 kbps on UE-1 bearer-10
    Verify traffic response should be error

TC06 Start TCP traffic with max allowed DL throughput
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-100 Mbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-100000000

TC07 Start TCP traffic above max DL throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-101 Mbps on UE-1 bearer-9
    Verify traffic response should be error

TC08 Start TCP traffic with minimum positive throughput
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-1 bps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-1

TC09 Start TCP traffic with fractional throughput
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-0.001 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-1

TC10 Start TCP traffic with negative fractional throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic--0.001 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC11 Start TCP traffic with negative throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic--5000 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC12 Start TCP traffic on dedicated bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify bearer status bearer_added
    Start tcp traffic-5000 kbps on UE-1 bearer-1
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-1 should be-5000000

TC13 Start TCP traffic on UE out of range should be rejected
    Start tcp traffic-5000 kbps on UE-999 bearer-9
    Verify traffic response should be error

TC14 Start TCP traffic on detached UE should be rejected
    Attach UE-1
    Verify attach status attached
    Detach UE-1
    Verify detach status detached
    Start tcp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC15 Start TCP traffic on bearer below range should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-5000 kbps on UE-1 bearer-0
    Verify traffic response should be error

TC16 Start TCP traffic with zero throughput should be error
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-0 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC17 Restart TCP traffic on running bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start tcp traffic-10000 kbps on UE-1 bearer-9
    Verify traffic response should be error
    Traffic target for UE-1 bearer-9 should be-5000000

TC18 Multiple UEs TCP traffic independently
    Attach UE-1
    Attach UE-2
    Start tcp traffic-5000 kbps on UE-1 bearer-9
    Start tcp traffic-10000 kbps on UE-2 bearer-9
    Traffic target for UE-1 bearer-9 should be-5000000
    Traffic target for UE-2 bearer-9 should be-10000000

TC19 Start UDP traffic in kbps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-5000000

TC20 Start UDP traffic in Mbps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start udp traffic-10 Mbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-10000000

TC21 Start UDP traffic in bps on active default bearer
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000000 bps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-5000000

TC22 Start UDP traffic on non attached UE should be rejected
    Start udp traffic-5000 kbps on UE-99 bearer-9
    Verify traffic response should be error

TC23 Start UDP traffic on non existing bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-10
    Verify traffic response should be error

TC24 Start UDP traffic with max allowed DL throughput
    Attach UE-1
    Verify attach status attached
    Start udp traffic-100 Mbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-100000000

TC25 Start UDP traffic above max DL throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic-101 Mbps on UE-1 bearer-9
    Verify traffic response should be error

TC26 Start UDP traffic with minimum positive throughput
    Attach UE-1
    Verify attach status attached
    Start udp traffic-1 bps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-1

TC27 Start UDP traffic with fractional throughput
    Attach UE-1
    Verify attach status attached
    Start udp traffic-0.001 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-9 should be-1

TC28 Start UDP traffic with negative fractional throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic--0.001 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC29 Start UDP traffic with negative throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic--5000 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC30 Start UDP traffic on dedicated bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify bearer status bearer_added
    Start udp traffic-5000 kbps on UE-1 bearer-1
    Verify traffic status traffic_started
    Traffic target for UE-1 bearer-1 should be-5000000

TC31 Start UDP traffic on UE out of range should be rejected
    Start udp traffic-5000 kbps on UE-999 bearer-9
    Verify traffic response should be error

TC32 Start UDP traffic on detached UE should be rejected
    Attach UE-1
    Verify attach status attached
    Detach UE-1
    Verify detach status detached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC33 Start UDP traffic on bearer below range should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-0
    Verify traffic response should be error

TC34 Start UDP traffic with zero throughput should be error
    Attach UE-1
    Verify attach status attached
    Start udp traffic-0 kbps on UE-1 bearer-9
    Verify traffic response should be error

TC35 Restart UDP traffic on running bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start udp traffic-10000 kbps on UE-1 bearer-9
    Verify traffic response should be error
    Traffic target for UE-1 bearer-9 should be-5000000

TC36 Multiple UEs UDP traffic independently
    Attach UE-1
    Attach UE-2
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Start udp traffic-10000 kbps on UE-2 bearer-9
    Traffic target for UE-1 bearer-9 should be-5000000
    Traffic target for UE-2 bearer-9 should be-10000000

*** Keywords ***
Start ${protocol} traffic-${traffic_value} ${unit} on UE-${ue_id} bearer-${bearer_id}
    ${response}=    Start Traffic    ${ue_id}    ${bearer_id}    ${protocol}    ${traffic_value}    ${unit}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Traffic target for UE-${ue_id} bearer-${bearer_id} should be-${expected_target}
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    ${bearer}=    Get From Dictionary    ${bearers}    ${bearer_id}
    ${expected_target_int}=    Convert To Integer    ${expected_target}
    Dictionary Should Contain Item    ${bearer}    target_bps    ${expected_target_int}