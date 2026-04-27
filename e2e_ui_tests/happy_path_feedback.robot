*** Settings ***
Documentation    Happy path test for Customer Feedback submission.
Library          SeleniumLibrary

*** Variables ***
${URL}           http://localhost:3000/
${BROWSER}       chrome

*** Test Cases ***
Customer Feedback Submission - Happy Path
    [Documentation]    Navigate via UI, fill form, solve CAPTCHA, and submit.
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
    
    # Click the Customer Feedback link inside the menu
    Wait Until Element Is Visible    xpath=//span[contains(text(), 'Customer Feedback')]    timeout=5s
    Click Element                    xpath=//span[contains(text(), 'Customer Feedback')]


    # --- STEP 2: FILL OUT FORM ---
    Wait Until Element Is Visible    id=comment    timeout=5s
    Input Text                       id=comment    This is a completely normal, non-malicious customer review! The juice is great.
    Press Keys                       id=comment    TAB
    
    # Set rating to 4 stars (Clicking the slider activates it, then 4 Right Arrows = 4 Stars)
    Click Element                    id=rating
    Press Keys                       id=rating    ARROW_RIGHT
    Press Keys                       id=rating    ARROW_RIGHT
    Press Keys                       id=rating    ARROW_RIGHT
    Press Keys                       id=rating    ARROW_RIGHT


    # --- STEP 3: SOLVE CAPTCHA ---
    ${math_equation}=    Get Text    id=captcha
    ${answer}=           Evaluate    ${math_equation}
    Input Text           id=captchaControl    ${answer}


    # --- STEP 4: SUBMIT & VERIFY ---
    Wait Until Element Is Enabled    id=submitButton    timeout=5s
    Click Button                     id=submitButton
    
    # Verify the submission was successful
    Wait Until Page Contains         Thank you for your feedback    timeout=5s
    
    # Leave it open for a couple of seconds to admire a passing test!
    Sleep    2s
    Close Browser