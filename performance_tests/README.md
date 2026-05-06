📖 Glossary: Concepts for Dummies
If you are new to this repository, here is what all the buzzwords actually mean:

1. E2E (End-to-End Testing)
What it is: Testing a software application exactly how a real human would use it, from start to finish.

Why we do it: Instead of just testing the database or the code in isolation, E2E testing proves that all the pieces (the website, the backend server, and the database) successfully talk to each other when a user clicks a button.

2. Playwright
What it is: A modern, incredibly fast UI automation tool created by Microsoft. It acts as a robot that can open a real web browser (like Chrome or Safari), click buttons, type text, and read what is on the screen.

Where we used it: It lives inside our e2e_ui_tests/ folder. We paired it with the Robot Framework to write human-readable scripts that automatically click through the Juice Shop to verify the UI isn't broken.

3. Locust
What it is: A Python-based performance and load-testing tool.

Where we used it: It lives inside our performance_tests/ folder. While Playwright simulates one user clicking around slowly, Locust simulates thousands of invisible virtual users hammering the server all at once to see when it crashes.

4. DDT (Data-Driven Testing)
What it is: Instead of hard-coding a single email address into a test, the test is "driven" by a pool of external "data" (like a list of 100 unique usernames and passwords).

Why it matters: Servers are smart. If you ask a server the exact same question 1,000 times, it will just memorize the answer (cache it) and hand it back instantly. By feeding the test unique data every time, we prevent the server from cheating and force it to do the hard work for every single user.

5. Cryptographic Hashing
What it is: When you type your password into a login box, the server doesn't just read it. It runs the password through an extremely complex mathematical blender (a hash) to securely verify it.

Why it broke our server: Doing this complex math takes a lot of CPU power. When we used DDT to fire 4,000 unique logins at the server at the exact same time, the server's CPU got completely overwhelmed trying to do the math for everyone simultaneously, causing a Denial of Service (crash).

6. GIL (Global Interpreter Lock)
What it is: The GIL is basically a traffic cop that lives inside the Python programming language. It forces a standard Python script to only use one core of your computer's CPU at a time, no matter how powerful your computer is.

How we beat it: Because the GIL limited our Locust test to one CPU core, we couldn't generate enough traffic to crash the server. We solved this by using a Master/Worker Architecture—spinning up multiple Locust "Worker" terminals. This bypassed the GIL and unlocked all of our Mac's CPU cores, allowing us to generate over 3,000 requests per second.

7. SLA (Service Level Agreement)
What it is: A formal promise about how fast an application will perform. For example, a company's SLA might be: "99% of users will be able to log in in under 2 seconds."

How we measure it: In our tests, we check the 99%ile (ms) column. When that number jumped to 21,000 milliseconds (21 seconds), we officially proved the application failed to meet its SLA.

8. Headless Execution
What it is: Running a program completely through the terminal, without opening any visual windows, web browsers, or dashboards.

Why we use it: Robots don't have eyeballs. When we want this test to run automatically every night in the cloud (CI/CD pipelines like GitHub Actions), there is no human to click a "Start" button. Headless mode allows the script to run, finish, and generate a report entirely on its own.

🚀 How to Run the Tests
1. Start the Target Application:
We use Docker to create a perfectly clean, local version of the Juice Shop server.
docker run --rm -p 3000:3000 bkimminich/juice-shop

2. Run a Distributed Performance Test:
Open three separate terminals to bypass the Python GIL and unleash the swarm.

Terminal 1 (Master): locust -f performance_tests/locustfile_ddt.py --master

Terminal 2 (Worker): locust -f performance_tests/locustfile_ddt.py --worker

Terminal 3 (Worker): locust -f performance_tests/locustfile_ddt.py --worker

Dashboard: Open http://localhost:8089 to start the attack.

3. Run the Automated CI/CD Pipeline Test (Headless):
locust -f performance_tests/locustfile_ddt.py --headless -u 500 -r 50 -H http://localhost:3000 -t 30s --html performance_tests/automated_report.html