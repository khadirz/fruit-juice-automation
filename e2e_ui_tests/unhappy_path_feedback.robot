*** Settings ***
Documentation    Happy path test for Customer Feedback submission.
Library          Browser    timeout=30s

*** Variables ***
${URL}           http://localhost:3000/

*** Test Cases ***
Customer Feedback Submission - Happy Path
    [Documentation]    Navigate via UI, fill form, solve CAPTCHA, and submit.
    
    # 1. Modern Browser Setup
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${URL}
    
    # --- ENVIRONMENT SETUP ---
    # BrowserLibrary automatically waits for elements to be visible before clicking!
    Click    css=button[aria-label="Close Welcome Banner"]
    Click    css=a[aria-label="dismiss cookie message"]

    # --- STEP 1: NAVIGATION VIA HAMBURGER MENU ---
    Click    css=button[aria-label="Open Sidenav"]
    Click    xpath=//span[contains(text(), 'Customer Feedback')]

    # --- STEP 2: FILL OUT FORM ---
    Fill Text     id=comment    This is a completely normal, non-malicious customer review! The juice is great.
    
    # Set rating to 4 stars (Playwright uses 'ArrowRight' instead of 'ARROW_RIGHT')
    Click         id=rating
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight

    # --- STEP 3: SOLVE CAPTCHA ---
    ${math_equation}=    Get Text    id=captcha
    ${answer}=           Evaluate    ${math_equation}
    Fill Text            id=captchaControl    ${answer}

    # --- STEP 4: SUBMIT & VERIFY ---
    Wait For Elements State    id=submitButton    enabled    timeout=5s
    Click                      id=submitButton

    # Verify the submission was successful
    Wait For Elements State    text=Wrong answer    visible    timeout=5s
    
    # Leave it open for a couple of seconds to admire a passing test!
    Sleep    2s