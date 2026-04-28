*** Settings ***
Documentation    E2E Golden Path: Searching and Adding Items to the Shopping Cart.
Library          Browser    timeout=30s
Library          String

*** Variables ***
${URL}           http://localhost:3000/

*** Test Cases ***
Registered User Can Add Item To Basket
    [Documentation]    Registers a dynamic user, searches for a product, adds it, and verifies cart.
    
    # 1. Modern Browser Setup
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${URL}
    
    # --- ENVIRONMENT SETUP & DYNAMIC DATA ---
    Click    css=button[aria-label="Close Welcome Banner"]
    Click    css=a[aria-label="dismiss cookie message"]

    ${random_string}=    Generate Random String    8    [LOWER]
    ${USER_EMAIL}=       Set Variable    shopper_${random_string}@example.com
    ${USER_PASSWORD}=    Set Variable    SuperSecretPassword123!

    # --- PREREQUISITE: REGISTER & LOG IN ---
    Click        id=navbarAccount
    Click        id=navbarLoginButton
    Click        id=newCustomerLink
    Fill Text    id=emailControl            ${USER_EMAIL}
    Fill Text    id=passwordControl         ${USER_PASSWORD}
    Fill Text    id=repeatPasswordControl   ${USER_PASSWORD}
    Click        css=[name="securityQuestion"]
    Click        css=mat-option >> nth=1 
    Fill Text    id=securityAnswerControl   TestAnswer
    Click        id=registerButton
    Wait For Elements State    text=Registration completed successfully.    visible    timeout=5s

    Fill Text    id=email       ${USER_EMAIL}
    Fill Text    id=password    ${USER_PASSWORD}
    Click        id=loginButton
    # Wait for the cart icon to appear, proving the login was successful
    Wait For Elements State    css=button[routerlink="/basket"]    visible    timeout=5s


    # --- STEP 1: SEARCH FOR A PRODUCT ---
    Click         id=searchQuery
    Fill Text     css=#searchQuery input    Apple Juice
    Press Keys    css=#searchQuery input    Enter
    
    
    # --- STEP 2: ADD TO BASKET ---
    Wait For Elements State    text=Apple Juice (1000ml)    visible    timeout=5s
    
    # Use nth=0 to ensure we click the very first "Add to Basket" button on the page
    Click    css=button[aria-label="Add to Basket"] >> nth=0
    
    Wait For Elements State    text=Placed Apple Juice (1000ml) into basket.    visible    timeout=5s
    Take Screenshot    filename=EMBED


    # --- STEP 3: NAVIGATE TO BASKET ---
    Click    css=button[routerlink="/basket"]
    Get Url    contains    /basket
    
    
    # --- STEP 4: VERIFY CART CONTENTS ---
    Wait For Elements State    css=mat-cell >> text=Apple Juice (1000ml)    visible    timeout=5s
    Take Screenshot    filename=EMBED
    
    Sleep    2s