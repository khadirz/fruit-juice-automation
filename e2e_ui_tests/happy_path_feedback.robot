*** Settings ***
Documentation    Unhappy path test for Customer Feedback submission.
Library          Browser    timeout=30s

*** Variables ***
${URL}           http://localhost:3000/

*** Test Cases ***
Customer Feedback Submission - Unhappy Path (Invalid CAPTCHA)
    [Documentation]    Submit a wrong CAPTCHA and verify the server rejects it.
    
    # 1. Modern Browser Setup
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${URL}
    
    # --- ENVIRONMENT SETUP ---
    Click    css=button[aria-label="Close Welcome Banner"]
    Click    css=a[aria-label="dismiss cookie message"]

    # --- STEP 1: NAVIGATION VIA HAMBURGER MENU ---
    Click    css=button[aria-label="Open Sidenav"]
    Click    xpath=//span[contains(text(), 'Customer Feedback')]

    # --- STEP 2: FILL OUT FORM PERFECTLY ---
    Fill Text     id=comment    I am a bad robot trying to bypass the rules!
    Press Keys    id=comment    Tab
    
    Click         id=rating
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight

    # --- STEP 3: INTENTIONALLY FAIL CAPTCHA ---
    Fill Text     id=captchaControl    99999999
    Press Keys    id=captchaControl    Tab

    # --- STEP 4: VERIFY THE SERVER REJECTS IT ---
    Wait For Elements State    id=submitButton    enabled    timeout=5s
    Click                      id=submitButton
    
    # THE PROOF: Wait for the red error banner to appear on the screen
    Wait For Elements State    text=Wrong answer    visible    timeout=5s
    
    Sleep    2s