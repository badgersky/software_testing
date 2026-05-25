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
