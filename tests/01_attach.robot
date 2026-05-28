*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Attach UE successfully
    Attach UE-1
    Verify attach status attached
    verify UE-1 is attached 
    verify UE-1 has bearer-9

TC02 Attach UE second time 
    Attach UE-2
    Verify attach status attached
    Attach UE-2
    verify attach response is duplicate
    verify UE-2 is attached

TC03 Attach UE max id
    Attach UE-100
    Verify attach status attached
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

TC07 Failed attach should not affect UE list
    Attach UE-101
    Verify attach response should be error
    UEs list should be empty

TC08 Multiple UEs attached independently
    Attach UE-1
    Verify attach status attached
    Attach UE-2
    Verify attach status attached
    Attach UE-3
    Verify attach status attached
    verify UE-1 is attached
    verify UE-2 is attached
    verify UE-3 is attached
    UEs list should contain UE-1
    UEs list should contain UE-2
    UEs list should contain UE-3

TC09 Newly attached UE has exactly one bearer
    Attach UE-5
    Verify attach status attached
    UE-5 should have exactly one bearer

*** Keywords ***
verify UE-${ue_id} is attached
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Should Not Be Equal    ${response}    ${None}

verify UE-${ue_id} has bearer-${bearer_id}
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    Dictionary Should Contain Key    ${bearers}    ${bearer_id}

verify attach response is duplicate
    Dictionary Should Contain Item    ${LAST_RESPONSE}    detail    UE already attached

UEs list should contain UE-${ue_id}
    ${response}=    Get UEs
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    ${ues}=    Get From Dictionary    ${LAST_RESPONSE}    ues
    ${ue_id_as_int}=    Convert To Integer    ${ue_id}
    List Should Contain Value    ${ues}    ${ue_id_as_int}

UE-${ue_id} should have exactly one bearer
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    Length Should Be    ${bearers}    1

verify attach status ${expected_status}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}

verify attach response is above of range
    ${detail_list}=    Get From Dictionary    ${LAST_RESPONSE}    detail
    ${error_obj}=    Get From List    ${detail_list}    0
    Dictionary Should Contain Item    ${error_obj}    type    less_than_equal
    Dictionary Should Contain Item    ${error_obj}    msg     Input should be less than or equal to 100

verify attach response is below of range
    ${detail_list}=    Get From Dictionary    ${LAST_RESPONSE}    detail
    ${error_obj}=    Get From List    ${detail_list}    0
    Dictionary Should Contain Item    ${error_obj}    type    greater_than_equal
    Dictionary Should Contain Item    ${error_obj}    msg     Input should be greater than or equal to 1
