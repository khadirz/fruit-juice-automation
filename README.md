# 🚀 Full-Stack Testing & Automation Framework

An enterprise-grade Continuous Testing framework for the OWASP Juice Shop application. This repository contains automated API tests, security vulnerability checks (Fuzzing, BFLA, XSS, IDOR), and End-to-End (E2E) UI Customer Journey tests powered by Robot Framework.

## 📂 1. Framework Structure
* `/api_tests` - Functional backend API validations.
* `/e2e_ui_tests` - Customer journey UI tests powered by Robot Framework `BrowserLibrary` (Playwright).
* `/security_tests` - Automated security auditing and vulnerability exploitation scripts.
* `/results` - Local directory for HTML reports and logs (Ignored by Git).

---

## 🛠️ 2. Environment Setup

### A. The Target Application (OWASP Juice Shop)
We run the vulnerable target application locally using Docker.
* `docker pull bkimminich/juice-shop`: Downloads the application image.
* `docker run --rm -p 3000:3000 bkimminich/juice-shop`: Starts the app on `http://localhost:3000`.

### B. The Local Testing Environment (Python)
To run tests locally (outside of Docker), we use isolated Python Virtual Environments to prevent dependency conflicts.
1. `python3 -m venv .venv`: Creates the isolated bucket.
2. `source .venv/bin/activate`: Activates the environment (crucial for Mac/Linux).
3. `pip install -r requirements.txt`: Installs Robot Framework and BrowserLibrary.
4. `rfbrowser init`: Downloads the required browser binaries for local UI testing.

---

## 🐳 3. Running UI Tests in Docker
Because `BrowserLibrary` requires complex Linux graphical dependencies and Node.js, the safest and most reliable way to execute our E2E tests is inside a pre-configured Docker container.

**1. Build the Test Image:**
Run this from the root directory to build our custom testing container:
`docker build -t juice-shop-e2e .`

**2. Execute the Tests:**
Run the container and extract the test reports to your local machine using a volume mount:
`docker run --rm -v $(pwd)/results:/app/results juice-shop-e2e`

*Note: We use `FROM marketsquare/robotframework-browser:latest` as our base Docker image because it comes pre-installed with the correct Node.js version and browser binaries.*

---

## 🛡️ 4. Security Testing Concepts
* **SQL Injection (SQLi):** Manipulating a database query by entering code into input fields (e.g., `' OR 1=1 --`).
* **Broken Function Level Authorization (BFLA):** Testing if a standard user can access admin-only API endpoints.
* **Insecure Direct Object Reference (IDOR):** Testing if a user can steal another user's data by simply changing an ID number in the API request (e.g., `/api/Basket/1` to `/api/Basket/2`).
* **Cross-Site Scripting (XSS):** Injecting malicious JavaScript into inputs. *Stored XSS* is highly dangerous because the script is saved to the database and attacks every user who views that page.
* **User Enumeration:** When an app leaks whether an email exists (e.g., "Email must be unique").
* **Rate Limiting:** A defense that blocks a user after too many failed login attempts to prevent Brute Force attacks.

---

## 🤖 5. Robot Framework & UI Guidelines
* **Syntax Structure:**
    * `*** Settings ***`: Imports libraries and documentation.
    * `*** Variables ***`: Stores reusable data (URLs, browser types).
    * `*** Test Cases ***`: The high-level "what" of the test.
* **Headless Mode:** When debugging locally, set `headless=False` to watch the browser. **Crucial:** Before building the Docker image or running in CI/CD, you MUST change it back to `headless=True`, or the container will crash!
* **Dynamic Locators:** OWASP Juice Shop uses Angular Material. Do not trust auto-generated IDs like `mat-input-0`. Always use structural CSS selectors or static IDs (like `id=searchQuery`).

---

## 🌿 6. Version Control (Git) Cheat Sheet
1.  `git status`: Check what has changed.
2.  `git add .`: Stage all non-ignored files for saving.
3.  `git commit -m "Message"`: Take a permanent snapshot.
4.  `git push`: Upload to GitHub.
*(Note: Ensure your `.gitignore` contains `results/`, `.venv/`, and `browser/` so you don't upload massive or temporary files).*

---

## 🚑 7. Troubleshooting Cheat Sheet

| Error / Issue | Cause | Fix |
| :--- | :--- | :--- |
| `bash: robot: command not found` | The terminal doesn't know where the tool is. | Ensure your `.venv` is activated (`source .venv/bin/activate`). |
| `npm not found` during build | Base image lacks Node.js. | Use the official `marketsquare` Docker image instead of standard Playwright. |
| `TimeoutError: page.goto` | Serverless Cold Start. | Add `timeout=30s` to the `Library Browser` import. |
| `TimeoutError: locator.fill` | Element is hidden or ID changed. | Ensure you click the UI element to expose the input first, and use static selectors. |