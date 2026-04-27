*** Settings ***
Documentation    API Fuzzing: Data-Driven SQL Injection Testing
Library          RequestsLibrary
Library          Collections
# This tells Robot Framework to use our custom keyword as a loop for every test case below!
Test Template    Verify API Rejects Malicious Login

*** Variables ***
${BASE_URL}      https://juice-shop-104226998836.us-central1.run.app/

*** Keywords ***
Verify API Rejects Malicious Login
    [Arguments]    ${email_payload}
    
    Create Session    juice_shop    ${BASE_URL}
    ${login_data}=    Create Dictionary    email=${email_payload}    password=random_garbage
    
    # Send the request. We use 'expected_status=any' so the robot doesn't crash if it gets a 200.
    ${response}=      POST On Session    juice_shop    /rest/user/login    json=${login_data}    expected_status=any
    
    # THE QA RULE: The application must properly sanitize the input and reject us.
    Should Be Equal As Integers    ${response.status_code}    401

*** Test Cases *** 
# To see if the Juice Shop's backend database could be tricked into bypassing security.
# Instead of testing just one thing, your robot took a long list of malicious database payloads
# -------------------------------------------------------------------------
# Test Name                      # EMAIL_PAYLOAD (passed to ${email_payload})
# -------------------------------------------------------------------------
Classic OR Bypass                ' OR 1=1 --
Admin Email Comment Bypass       admin@juice-sh.op'--
Double Quote Bypass              " OR ""="
Standard Boolean Bypass          ' OR '1'='1
Union Select Injection           ' UNION SELECT * FROM Users--
Random Harmless Typo             user@email.com'