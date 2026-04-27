# AI-Assisted Testing Project
# 🚀 Full-Stack Testing & Automation Reference

## 1. Environment Setup (Docker & Python)
* **Docker:** Used to run the **OWASP Juice Shop** (the vulnerable target) locally.
    * `docker pull bkimminich/juice-shop`: Downloads the application image.
    * `docker run --rm -p 3000:3000 bkimminich/juice-shop`: Starts the app on `http://localhost:3000`.
* **Virtual Environments (`venv`):** Isolated "buckets" for Python projects to prevent version conflicts.
    * `python3 -m venv .venv`: Creates the environment.
    * `source .venv/bin/activate`: Activates it (crucial for Mac/Linux).
    * `pip install robotframework robotframework-seleniumlibrary`: Installs the testing tools inside the bucket.

## 2. Version Control (Git & GitHub)
* **Basic Flow:**
    1.  `git status`: Check what has changed.
    2.  `git add <file>`: Stage files for saving.
    3.  `git commit -m "Message"`: Take a permanent snapshot.
    4.  `git push`: Upload to GitHub.
* **`.gitignore`:** A file telling Git which files to ignore (like `.venv/` or auto-generated test reports `.html`).
    * `*` is a wildcard (e.g., `*.png` ignores all screenshots).

## 3. Security Testing Concepts
* **SQL Injection (SQLi):** Manipulating a database query by entering code into input fields.
    * **Payload:** `' OR 1=1 --`
    * `'`: Closes the data field.
    * `OR 1=1`: A math statement that is always true, bypassing the password check.
    * `--`: Comments out the rest of the original query.
* **User Enumeration:** When an app leaks whether an email exists (e.g., "Email must be unique").
* **Rate Limiting:** A defense that blocks a user after too many failed login attempts to prevent **Brute Force** (automated guessing).

## 4. Robot Framework Automation
* **Syntax Structure:**
    * `*** Settings ***`: Imports libraries and documentation.
    * `*** Variables ***`: Stores reusable data (URLs, browser types).
    * `*** Test Cases ***`: The high-level "what" of the test.
    * `*** Keywords ***`: The low-level "how" (the refactored building blocks).
* **Headless Mode:** Running the browser without a visible window (`headlesschrome`). Essential for CI/CD servers.

## 5. Troubleshooting Cheat Sheet

| Error / Issue | Cause | Fix |
| :--- | :--- | :--- |
| `bash: robot: command not found` | The terminal doesn't know where the `robot` tool is hidden. | Use `python3 -m robot <file>.robot` or ensure `.venv` is activated. |
| `No module named robot` | Running a command in a Python version that doesn't have the tool installed. | Activate your virtual environment (`source .venv/bin/activate`). |
| `ElementClickInterceptedException` | A popup or banner is physically sitting on top of the button you want to click. | Use `Click Button` or `Click Element` on the "Dismiss" banner first. |
| `Element not visible` (Headless only) | Headless browsers default to tiny windows, causing UI elements to move or hide. | Add `Set Window Size 1920 1080` to your opening keyword. |