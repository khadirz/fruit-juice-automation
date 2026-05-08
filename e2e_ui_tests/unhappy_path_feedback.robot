*** Settings ***
Documentation    Happy path test for Customer Feedback submission.
Library          Browser    timeout=30s

*** Variables ***
${URL}           https://juice-shop-104226998836.us-central1.run.app

*** Test Cases ***
Customer Feedback Submission - Happy Path
    [Documentation]    Navigate via UI, fill form, solve CAPTCHA, and submit.
    
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

    # --- STEP 2: FILL OUT FORM ---
    Fill Text     id=comment    This is a completely normal, non-malicious customer review! The juice is great.
    
    # Set rating to 4 stars
    Click         id=rating
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight
    Press Keys    id=rating    ArrowRight

    # --- STEP 3: SOLVE CAPTCHA ---
    ${math_equation}=    Get Text    id=captcha
    ${answer}=           Evaluate    ${math_equation}
    # Using Type Text mimics human keystrokes to ensure Angular registers the input
    Type Text            id=captchaControl    ${answer}

    # --- STEP 4: SUBMIT & VERIFY ---
    Wait For Elements State    id=submitButton    enabled    timeout=5s
    Click                      id=submitButton

    # Verify the submission was successful via the Angular snackbar container
    Wait For Elements State    css=simple-snack-bar    visible    timeout=10s
    Get Text                   css=simple-snack-bar    contains   Thank you
    
    Sleep    2s