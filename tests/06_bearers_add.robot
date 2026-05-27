*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Add dedicated bearer to UE successfully
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-1

TC02 Add bearer requires valid UE ID
    Add bearer-1 to UE-999
    Verify operation response should be error

TC03 Add bearer out of range should be rejected
    Attach UE-1
    Verify attach status attached
    Add bearer-10 to UE-1
    Verify operation response should be error
    Add bearer-0 to UE-1
    Verify operation response should be error

TC04 Add already existing bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify operation status bearer_added
    Add bearer-1 to UE-1
    Verify operation response should be error

TC05 Add same bearer to two different UEs successfully
    Attach UE-1
    Verify attach status attached
    Attach UE-2
    Verify attach status attached

    Add bearer-1 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-1

    Add bearer-1 to UE-2
    Verify operation status bearer_added
    verify UE-2 has bearer-1

TC06 Add minimum valid bearer ID
    Attach UE-1
    Verify attach status attached

    Add bearer-1 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-1

TC07 Add maximum valid bearer ID
    Attach UE-1
    Verify attach status attached

    Add bearer-2 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-2

TC08 Add remove and re-add bearer successfully
    Attach UE-1
    Verify attach status attached

    Add bearer-1 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-1

    Delete bearer-1 from UE-1
    Verify operation status bearer_deleted

    Add bearer-1 to UE-1
    Verify operation status bearer_added
    verify UE-1 has bearer-1

*** Keywords ***
Verify attach status ${expected_status}
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    Dictionary Should Contain Item    ${LAST_RESPONSE}    status    ${expected_status}

verify UE-${ue_id} has bearer-${bearer_id}
    ${response}=    Get UE    ${ue_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}
    Dictionary Should Contain Key    ${LAST_RESPONSE}    bearers
    ${bearers}=    Get From Dictionary    ${LAST_RESPONSE}    bearers
    Dictionary Should Contain Key    ${bearers}    ${bearer_id}

Verify operation response should be error
    Should Not Be Equal    ${LAST_RESPONSE}    ${None}
    ${has_detail}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${LAST_RESPONSE}    detail
    
    IF    ${has_detail}
        Pass Execution    Error response validated successfully via 'detail' field.
    ELSE
        Fail    Expected an error response payload containing 'detail', but got: ${LAST_RESPONSE}
    END

Delete bearer-${bearer_id} from UE-${ue_id}
    ${response}=    Delete Bearer    ${ue_id}    ${bearer_id}
    Set Test Variable    ${LAST_RESPONSE}    ${response}