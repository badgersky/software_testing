*** Settings ***
Library          Collections
Variables        ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library          ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource         ${CURDIR}/../resources/common_keywords.robot
Test Setup       Reset Simulator


*** Test Cases ***
TC01 Stop traffic for default bearer
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Stop traffic on UE-1 bearer-9
    Verify stop traffic response contains UE-1 bearer-9
    Verify UE-1 bearer-9 traffic is stopped

TC02 Stop traffic for dedicated bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Start udp traffic-2500 kbps on UE-1 bearer-5
    Verify traffic status traffic_started
    Stop traffic on UE-1 bearer-5
    Verify stop traffic response contains UE-1 bearer-5
    Verify UE-1 bearer-5 traffic is stopped

TC03 Stop all traffic for UE
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start udp traffic-2500 kbps on UE-1 bearer-5
    Verify traffic status traffic_started
    Stop all traffic for UE-1
    Verify all traffic for UE-1 is stopped

TC04 Stop traffic for inactive default bearer
    Attach UE-1
    Verify attach status attached
    Stop traffic on UE-1 bearer-9
    Verify stop traffic response contains UE-1 bearer-9
    Verify UE-1 bearer-9 traffic is stopped

TC05 Stop traffic for not attached UE should be rejected
    Stop traffic on UE-99 bearer-9
    Verify stop traffic response should be error

TC06 Stop traffic for inactive dedicated bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Stop traffic on UE-1 bearer-5
    Verify stop traffic response contains UE-1 bearer-5
    Verify UE-1 bearer-5 traffic is stopped

TC07 Traffic info after stop traffic should be rejected
    Attach UE-1
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Stop traffic on UE-1 bearer-9
    Verify stop traffic response contains UE-1 bearer-9
    Verify UE-1 bearer-9 traffic is stopped
    Get traffic info for UE-1 bearer-9
    Verify stopped traffic info response should be rejected

TC08 Stop traffic for not added bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Stop traffic on UE-1 bearer-5
    Verify stop traffic response should be error

TC09 Stop traffic for one bearer should not stop other active bearer
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start udp traffic-2500 kbps on UE-1 bearer-5
    Verify traffic status traffic_started
    Stop traffic on UE-1 bearer-5
    Verify stop traffic response contains UE-1 bearer-5
    Verify UE-1 bearer-5 traffic is stopped
    Verify UE-1 bearer-9 traffic is active

TC10 Stop traffic for one UE should not affect traffic on another UE
    Attach UE-1
    Verify attach status attached
    Attach UE-2
    Verify attach status attached
    Start udp traffic-5000 kbps on UE-1 bearer-9
    Verify traffic status traffic_started
    Start udp traffic-2500 kbps on UE-2 bearer-9
    Verify traffic status traffic_started
    Stop traffic on UE-1 bearer-9
    Verify stop traffic response contains UE-1 bearer-9
    Verify UE-1 bearer-9 traffic is stopped
    Verify UE-2 bearer-9 traffic is active


*** Keywords ***
Verify traffic status ${expected_status}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    status
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}

Stop traffic on UE-${ue_id} bearer-${bearer_id}
    ${response}=    Stop Traffic    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Stop all traffic for UE-${ue_id}
    ${response}=    Get UE    ${ue_id}
    Dictionary Should Contain Key    ${response}    bearers
    ${bearers}=    Get From Dictionary    ${response}    bearers

    FOR    ${bearer_id}    ${bearer_config}    IN    &{bearers}
        Dictionary Should Contain Key    ${bearer_config}    active
        ${is_active}=    Get From Dictionary    ${bearer_config}    active
        Run Keyword If    ${is_active}    Stop traffic on UE-${ue_id} bearer-${bearer_id}
    END

    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify stop traffic response contains UE-${ue_id} bearer-${bearer_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${ue_id_as_int}=    Convert To Integer    ${ue_id}
    ${bearer_id_as_int}=    Convert To Integer    ${bearer_id}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    ue_id    ${ue_id_as_int}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    bearer_id    ${bearer_id_as_int}

Verify UE-${ue_id} bearer-${bearer_id} traffic is stopped
    ${response}=    Get UE    ${ue_id}
    Dictionary Should Contain Key    ${response}    bearers
    ${bearers}=    Get From Dictionary    ${response}    bearers
    ${bearer_id_as_string}=    Convert To String    ${bearer_id}
    Dictionary Should Contain Key    ${bearers}    ${bearer_id_as_string}
    ${bearer_config}=    Get From Dictionary    ${bearers}    ${bearer_id_as_string}
    Dictionary Should Contain Key    ${bearer_config}    active
    ${is_active}=    Get From Dictionary    ${bearer_config}    active
    Should Be Equal    ${is_active}    ${False}

Verify all traffic for UE-${ue_id} is stopped
    ${response}=    Get UE    ${ue_id}
    Dictionary Should Contain Key    ${response}    bearers
    ${bearers}=    Get From Dictionary    ${response}    bearers

    FOR    ${bearer_id}    ${bearer_config}    IN    &{bearers}
        Dictionary Should Contain Key    ${bearer_config}    active
        ${is_active}=    Get From Dictionary    ${bearer_config}    active
        Should Be Equal    ${is_active}    ${False}
    END

Verify stop traffic response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${has_detail}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail
    ${has_error_status}=    Run Keyword And Return Status    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    error
    Should Be True    ${has_detail} or ${has_error_status}

Verify UE-${ue_id} bearer-${bearer_id} traffic is active
    ${response}=    Get UE    ${ue_id}
    Dictionary Should Contain Key    ${response}    bearers
    ${bearers}=    Get From Dictionary    ${response}    bearers
    ${bearer_id_as_string}=    Convert To String    ${bearer_id}
    Dictionary Should Contain Key    ${bearers}    ${bearer_id_as_string}
    ${bearer_config}=    Get From Dictionary    ${bearers}    ${bearer_id_as_string}
    Dictionary Should Contain Key    ${bearer_config}    active
    ${is_active}=    Get From Dictionary    ${bearer_config}    active
    Should Be Equal    ${is_active}    ${True}

Get traffic info for UE-${ue_id} bearer-${bearer_id}
    ${response}=    Get Traffic Stats    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify stopped traffic info response should be rejected
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${has_detail}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail
    ${has_error_status}=    Run Keyword And Return Status    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    error
    Should Be True    ${has_detail} or ${has_error_status}