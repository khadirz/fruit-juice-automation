# 🚀 Full-Stack Testing & Automation Framework

[![Enterprise QA Pipeline](https://github.com/khadirz/fruit-juice-automation/actions/workflows/qa_pipeline.yml/badge.svg)](https://github.com/khadirz/fruit-juice-automation/actions/workflows/qa_pipeline.yml)

An enterprise-grade Continuous Testing framework for the OWASP Juice Shop application. This repository contains automated API tests, security vulnerability checks (Fuzzing, BFLA, XSS, IDOR), Performance load testing, and End-to-End (E2E) UI Customer Journey tests powered by Robot Framework and GitHub Actions.

## 📂 1. Framework Structure
* `.github/workflows/` - CI/CD pipeline configurations (GitHub Actions).
* `/api_tests` - Functional backend API validations.
* `/e2e_ui_tests` - Customer journey UI tests powered by Robot Framework `BrowserLibrary` (Playwright).
* `/performance_tests` - Distributed load testing scripts utilizing `Locust`.
* `/security_tests` - Automated security auditing and vulnerability exploitation scripts.
* `/results` - Local directory for HTML reports and logs (Ignored by Git).

---

## ☁️ 2. Environments

### A. Staging Environment (Cloud)
The primary target for our CI/CD pipeline is a live staging deployment hosted on Google Cloud Run:
`https://juice-shop-104226998836.us-central1.run.app`

### B. Local Debug Environment (Docker)
If you wish to test locally without hitting the cloud server, you can spin up the application via Docker:
* `docker pull bkimminich/juice-shop`
* `docker run --rm -p 3000:3000 bkimminich/juice-shop`
*(Note: You will need to change the `${URL}` variable in the test files to `http://localhost:3000`)*

---

## 🛠️ 3. Local Setup & Execution
To run tests locally, use an isolated Python Virtual Environment:
1. `python3 -m venv .venv`
2. `source .venv/bin/activate` (Mac/Linux)
3. `pip install -r requirements.txt`
4. `rfbrowser init` (Downloads Playwright browser binaries)

**Execution Commands:**
* **UI Tests:** `robot -d results e2e_ui_tests/`
* **API/Security Tests:** `robot -d results security_tests/`
* **Performance Tests:** `locust -f performance_tests/locustfile_ddt.py --headless -u 50 -r 10 -t 15s`

---

## 🤖 4. CI/CD Pipeline (GitHub Actions)
This repository utilizes GitHub Actions for continuous integration. Upon every push to the `main` branch, an ephemeral Ubuntu server is provisioned to:
1. Install Python, Playwright, and dependencies.
2. Execute Security & API fuzzing against the cloud endpoint.
3. Simulate an X-Server display using `xvfb-run` to execute headed Playwright UI tests in a headless Linux environment.
4. Execute Locust performance smoke tests.
5. Upload all HTML test reports as downloadable GitHub Artifacts.

---

## 🛡️ 5. Security Testing Concepts
* **SQL Injection (SQLi):** Manipulating a database query by entering code into input fields (e.g., `' OR 1=1 --`).
* **Broken Function Level Authorization (BFLA):** Testing if a standard user can access admin-only API endpoints.
* **Insecure Direct Object Reference (IDOR):** Testing if a user can steal another user's data by modifying an ID in the request.
* **Cross-Site Scripting (XSS):** Injecting malicious JavaScript into inputs.
* **User Enumeration:** Identifying system behavior that leaks whether an account exists.

---

## 📚 6. Framework Syntax & Version Control

### A. Robot Framework Structure
* `*** Settings ***`: Imports libraries (like `Browser`) and suite documentation.
* `*** Variables ***`: Stores reusable environment data (URLs, browser configurations).
* `*** Test Cases ***`: The high-level execution steps of the test.
* **Headless Rule:** Playwright requires a virtual display to run headed tests on a Linux server. In our CI/CD pipeline, we handle this automatically using `xvfb-run`.

### B. Git Version Control Cheat Sheet
* `git status`: Check modified files.
* `git add .`: Stage all non-ignored files for saving.
* `git commit -m "Message"`: Take a permanent snapshot of the code.
* `git push`: Upload to GitHub and trigger the automated CI/CD pipeline.

---

## 🚑 7. Troubleshooting Cheat Sheet

| Error / Issue | Cause | Fix |
| :--- | :--- | :--- |
| `bash: robot: command not found` | The terminal doesn't know where the tool is. | Ensure your `.venv` is activated (`source .venv/bin/activate`). |
| `npm not found` during build | Base image lacks Node.js. | Use the official `marketsquare` Docker image instead of standard Playwright. |
| `TimeoutError: page.goto` | Serverless Cold Start. | Add `timeout=30s` to the `Library Browser` import. |
| `TimeoutError: locator.fill` | Element is hidden or ID changed. | Ensure you click the UI element to expose the input first, and use static selectors. |