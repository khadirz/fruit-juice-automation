*** Settings ***
Documentation    E2E UI Testing with BrowserLibrary
Library          Browser    timeout=30s

*** Variables ***
${BASE_URL}      https://juice-shop-104226998836.us-central1.run.app

*** Test Cases ***
Customer Can Search and View a Product
    [Documentation]    Verifies a user can load the site, dismiss popups, and search for juice.
    
    # 1. Open the browser invisibly (headless) and go to the site
    New Browser    chromium    headless=True
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${BASE_URL}

    # 2. Dismiss the welcome banner and cookie message
    Click    button[aria-label="Close Welcome Banner"]
    Click    a[aria-label="dismiss cookie message"]

    # 3. Search for "Apple Juice"
    Click        id=searchQuery
    Fill Text    css=#searchQuery input    Apple
    Press Keys   css=#searchQuery input    Enter

    # 4. Wait 10s for Aplle Juice to be visible in the search results
    Wait For Elements State    text=Apple Juice    visible    timeout=10s
    # *= (body contains Apple Juice)
    Get Text                   body    *=    Apple Juice