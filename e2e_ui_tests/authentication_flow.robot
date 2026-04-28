*** Settings ***
Documentation    E2E Golden Path: User Registration and Login.
Library          Browser    timeout=30s
Library          String     # Allows us to generate dynamic data!

*** Variables ***
${URL}           http://localhost:3000/

*** Test Cases ***
Customer Can Register and Log In
    [Documentation]    Registers a random user, verifies success, and logs into the account.
    
    # 1. Modern Browser Setup
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${URL}
    
    # --- ENVIRONMENT SETUP ---
    Click    css=button[aria-label="Close Welcome Banner"]
    Click    css=a[aria-label="dismiss cookie message"]
    Take Screenshot    filename=EMBED    # Automatically names screenshots based on the test name and step index

    # --- DYNAMIC DATA CREATION ---
    # Generates an 8-character random string (e.g., "xytpzklq") to ensure a unique email
    ${random_string}=    Generate Random String    8    [LOWER]
    ${USER_EMAIL}=       Set Variable    testuser_${random_string}@example.com
    ${USER_PASSWORD}=    Set Variable    SuperSecretPassword123!

    # --- STEP 1: NAVIGATE TO REGISTRATION ---
    Click    id=navbarAccount
    Click    id=navbarLoginButton
    Click    id=newCustomerLink
    Take Screenshot    filename=EMBED

    # --- STEP 2: FILL REGISTRATION FORM ---
    Fill Text    id=emailControl            ${USER_EMAIL}
    Fill Text    id=passwordControl         ${USER_PASSWORD}
    Fill Text    id=repeatPasswordControl   ${USER_PASSWORD}
    Take Screenshot    filename=EMBED 

    # Handle the Angular Material Dropdown Menu
    Click        css=[name="securityQuestion"]
    Click        css=mat-option >> nth=1    # Playwright syntax to click the 1st option in the list
    
    Fill Text    id=securityAnswerControl   TestAnswer
    Click        id=registerButton
    Take Screenshot    filename=EMBED 

    # Verify the green success banner appears
    Wait For Elements State    text=Registration completed successfully.    visible    timeout=5s
    Take Screenshot    filename=EMBED 

    # --- STEP 3: LOG IN WITH THE NEW ACCOUNT ---
    # Juice Shop automatically redirects to the login screen after registering
    Fill Text    id=email       ${USER_EMAIL}
    Fill Text    id=password    ${USER_PASSWORD}
    Click        id=loginButton
    Take Screenshot    filename=EMBED 

    # --- STEP 4: VERIFY SUCCESSFUL LOGIN ---
    # Click the Account menu again. If "Logout" is visible, we are officially logged in!
    Click                      id=navbarAccount
    Wait For Elements State    id=navbarLogoutButton    visible    timeout=5s
    Take Screenshot    filename=EMBED 

    # Leave it open briefly to verify visually
    Sleep    2s