*** Settings ***
Library          Collections
Variables        ${CURDIR}/../resources/config.py    # STWORZYC PLIK config.py i utworzyć w nim zmienna BASE_URL: BASE_URL = 'https://...'
Library          ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource         ${CURDIR}/../resources/common_keywords.robot
Test Setup       Reset Simulator

*** Test Cases ***
TC01 Check default bearer after UE attach
    Attach UE-1
    Verify attach status attached
    Check bearers for UE-1
    Verify bearers check response contains UE-1
    Verify checked bearers include bearer-9
    Verify checked bearers count is 1

TC02 Check dedicated bearer after adding it to UE
    Attach UE-1
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Check bearers for UE-1
    Verify bearers check response contains UE-1
    Verify checked bearers include bearer-9
    Verify checked bearers include bearer-5
    Verify checked bearers count is 2

TC03 Check multiple dedicated bearers for UE
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify add bearer response contains UE-1 bearer-1
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Add bearer-8 to UE-1
    Verify add bearer response contains UE-1 bearer-8
    Check bearers for UE-1
    Verify bearers check response contains UE-1
    Verify checked bearers include bearer-9
    Verify checked bearers include bearer-1
    Verify checked bearers include bearer-5
    Verify checked bearers include bearer-8
    Verify checked bearers count is 4

TC04 Check bearers when no dedicated bearer was added
    Attach UE-1
    Verify attach status attached
    Check bearers for UE-1
    Verify bearers check response contains UE-1
    Verify checked bearers include bearer-9
    Verify checked bearers do not include bearer-1
    Verify checked bearers do not include bearer-5
    Verify checked bearers do not include bearer-8
    Verify checked bearers count is 1

TC05 Check bearers for not attached UE should be rejected
    Check bearers for UE-99
    Verify bearers check response should be error

TC06 Check bearers independently for two attached UEs
    Attach UE-1
    Verify attach status attached
    Attach UE-2
    Verify attach status attached
    Add bearer-5 to UE-1
    Verify add bearer response contains UE-1 bearer-5
    Add bearer-3 to UE-2
    Verify add bearer response contains UE-2 bearer-3

    Check bearers for UE-1
    Verify bearers check response contains UE-1
    Verify checked bearers include bearer-9
    Verify checked bearers include bearer-5
    Verify checked bearers do not include bearer-3
    Verify checked bearers count is 2

    Check bearers for UE-2
    Verify bearers check response contains UE-2
    Verify checked bearers include bearer-9
    Verify checked bearers include bearer-3
    Verify checked bearers do not include bearer-5
    Verify checked bearers count is 2


*** Keywords ***
Verify add bearer response contains UE-${ue_id} bearer-${bearer_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${ue_id_as_int}=    Convert To Integer    ${ue_id}
    ${bearer_id_as_int}=    Convert To Integer    ${bearer_id}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    ue_id    ${ue_id_as_int}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    bearer_id    ${bearer_id_as_int}

Check bearers for UE-${ue_id}
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify bearers check response contains UE-${ue_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${ue_id_as_int}=    Convert To Integer    ${ue_id}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    ue_id
    Dictionary Should Contain Item    ${LAST_RESPONSE}    ue_id    ${ue_id_as_int}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers

Verify checked bearers include bearer-${bearer_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    ${bearer_id_as_string}=    Convert To String    ${bearer_id}
    Dictionary Should Contain Key    ${bearers}    ${bearer_id_as_string}

Verify checked bearers do not include bearer-${bearer_id}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    ${bearer_id_as_string}=    Convert To String    ${bearer_id}
    Dictionary Should Not Contain Key    ${bearers}    ${bearer_id_as_string}

Verify checked bearers count is ${expected_count}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    ${bearer_count}=    Get Length    ${bearers}
    Should Be Equal As Integers    ${bearer_count}    ${expected_count}

Verify bearers check response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${has_detail}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail
    ${has_error_status}=    Run Keyword And Return Status    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    error
    Should Be True    ${has_detail} or ${has_error_status}