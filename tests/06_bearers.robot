*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Add bearer successfully
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify add bearer status bearer_added
    verify UE-1 has bearer-1

TC02 Add bearer out of range
    Attach UE-1
    Verify attach status attached
    Add bearer-10 to UE-1
    Verify add bearer response should be error
    Add bearer-0 to UE-1
    Verify add bearer response should be error

TC03 Delete default bearer 9 should be rejected
    Attach UE-1
    Verify attach status attached
    Delete bearer-9 from UE-1
    Verify delete bearer response should be error
    verify UE-1 has bearer-9

TC04 Delete added bearer successfully
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify add bearer status bearer_added
    Delete bearer-1 from UE-1
    Verify delete bearer status bearer_deleted
    verify UE-1 does not have bearer-1

TC05 Active bearers list contains correctly added bearers
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify add bearer status bearer_added
    Add bearer-2 to UE-1
    Verify add bearer status bearer_added
    verify UE-1 has bearer-9
    verify UE-1 has bearer-1
    verify UE-1 has bearer-2

*** Keywords ***
Delete bearer-${bearer_id} from UE-${ue_id}
    ${response}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

Verify add bearer status ${expected_status}
    Verify operation status ${expected_status}

Verify delete bearer status ${expected_status}
    Verify operation status ${expected_status}

Verify add bearer response should be error
    Verify operation response should be error

Verify delete bearer response should be error
    Verify operation response should be error

verify UE-${ue_id} does not have bearer-${bearer_id}
    ${response}=    Get UE    ${ue_id}
    ${bearers}=    Get From Dictionary    ${response}    bearers
    Dictionary Should Not Contain Key    ${bearers}    ${bearer_id}
