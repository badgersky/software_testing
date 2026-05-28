*** Settings ***
Library         Collections
Variables       ${CURDIR}/../resources/config.py
Library         ${CURDIR}/../resources/epc_requests.py    ${BASE_URL}
Resource        ${CURDIR}/../resources/common_keywords.robot
Test Setup      Reset Simulator

*** Test Cases ***
TC01 Delete default bearer 9 should be rejected
    Attach UE-1
    Verify attach status attached
    Delete bearer-9 from UE-1
    Verify operation response should be error
    verify UE-1 has bearer-9

TC02 Delete added bearer successfully
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify operation status bearer_added
    Delete bearer-1 from UE-1
    Verify operation status bearer_deleted
    verify UE-1 does not have bearer-1

TC03 Delete non-existent bearer should be rejected
    Attach UE-1
    Verify attach status attached
    Delete bearer-5 from UE-1
    Verify operation response should be error

TC04 Delete bearer out of range should be rejected
    Attach UE-1
    Verify attach status attached
    Delete bearer-10 from UE-1
    Verify operation response should be error
    Delete bearer-0 from UE-1
    Verify operation response should be error

TC05 Delete bearer for non-existent UE should be rejected
    Delete bearer-1 from UE-999
    Verify operation response should be error

TC06 Delete same bearer twice should be rejected
    Attach UE-1
    Verify attach status attached
    Add bearer-1 to UE-1
    Verify operation status bearer_added
    Delete bearer-1 from UE-1
    Verify operation status bearer_deleted
    verify UE-1 does not have bearer-1
    Delete bearer-1 from UE-1
    Verify operation response should be error

TC07 Delete bearer from detached UE should be rejected
    Attach UE-1
    Verify attach status attached

    Add bearer-1 to UE-1
    Verify operation status bearer_added

    Detach UE-1
    Verify operation status detached

    Delete bearer-1 from UE-1
    Verify operation response should be error

TC08 Delete one bearer should not affect other bearers
    Attach UE-1
    Verify attach status attached

    Add bearer-1 to UE-1
    Verify operation status bearer_added

    Add bearer-2 to UE-1
    Verify operation status bearer_added

    Delete bearer-1 from UE-1
    Verify operation status bearer_deleted

    verify UE-1 does not have bearer-1
    verify UE-1 has bearer-2

*** Keywords ***
verify UE-${ue_id} does not have bearer-${bearer_id}
    ${response}=    Get UE    ${ue_id}
    ${bearers}=    Get From Dictionary    ${response}    bearers
    Dictionary Should Not Contain Key    ${bearers}    ${bearer_id}

verify UE-${ue_id} has bearer-${bearer_id}
    ${response}=    Get UE    ${ue_id}
    ${bearers}=    Get From Dictionary    ${response}    bearers
    Dictionary Should Contain Key    ${bearers}    ${bearer_id}
