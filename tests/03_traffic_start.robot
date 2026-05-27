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

TC04 Start TCP traffic on non existing UE should be rejected
    Start tcp traffic-5000 kbps on UE-999 bearer-9
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

TC10 Start TCP traffic with negative throughput should be rejected
    Attach UE-1
    Verify attach status attached
    Start tcp traffic--0.001 kbps on UE-1 bearer-9
    Verify traffic response should be error

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