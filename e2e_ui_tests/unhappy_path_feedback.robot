*** Settings ***
Documentation    Unhappy path test for Customer Feedback submission.
Library          SeleniumLibrary

*** Variables ***
${URL}           http://localhost:3000/
${BROWSER}       chrome

*** Test Cases ***
Customer Feedback Submission - Unhappy Path (Invalid CAPTCHA)
    [Documentation]    Submit a wrong CAPTCHA and verify the server rejects it.
    Open Browser    ${URL}    ${BROWSER}
    Set Window Size    1920    1080
    
    # --- ENVIRONMENT SETUP ---
    Wait Until Element Is Visible    css=button[aria-label="Close Welcome Banner"]    timeout=5s
    Click Button                     css=button[aria-label="Close Welcome Banner"]
    Wait Until Element Is Visible    css=a[aria-label="dismiss cookie message"]    timeout=5s
    Click Element                    css=a[aria-label="dismiss cookie message"]

    # --- STEP 1: NAVIGATION VIA HAMBURGER MENU ---
    Wait Until Element Is Visible    css=button[aria-label="Open Sidenav"]    timeout=5s
    Click Button                     css=button[aria-label="Open Sidenav"]
    
    Wait Until Element Is Visible    xpath=//span[contains(text(), 'Customer Feedback')]    timeout=5s
    Click Element                    xpath=//span[contains(text(), 'Customer Feedback')]

    # --- STEP 2: FILL OUT FORM PERFECTLY ---
    Wait Until Element Is Visible    id=comment    timeout=5s
    Input Text                       id=comment    I am a bad robot trying to bypass the rules!
    Press Keys                       id=comment    TAB
    
    Click Element                    id=rating
    Press Keys                       id=rating    ARROW_RIGHT
    Press Keys                       id=rating    ARROW_RIGHT

    # --- STEP 3: INTENTIONALLY FAIL CAPTCHA ---
    Input Text                       id=captchaControl    99999999
    Press Keys                       id=captchaControl    TAB

    # --- STEP 4: VERIFY THE SERVER REJECTS IT ---
    Wait Until Element Is Enabled    id=submitButton    timeout=5s
    Click Button                     id=submitButton
    
    # THE PROOF: Wait for the red error banner to appear on the screen
    Wait Until Page Contains         Wrong answer to CAPTCHA. Please try again.    timeout=5s
    
    Sleep    2s
    Close Browser