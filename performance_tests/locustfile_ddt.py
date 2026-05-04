import random
from locust import HttpUser, task, between

# ==========================================
# 1. TEST DATA SETUP (Parameterization)
# ==========================================
# By providing multiple different credentials, we prevent the server
# from caching the response. If everyone used "shopper1", the server
# would just remember the answer. With a list, the server has to do
# the math every single time.

# --- OUR TEST DATA POOL ---
# In a massive enterprise test, we would read this from a CSV file.
# For today, a Python list of dictionaries works perfectly.
USER_CREDENTIALS = [
    {"email": "shopper1@example.com", "password": "SuperSecretPassword123!"},
    {"email": "shopper2@example.com", "password": "SuperSecretPassword123!"},
    {"email": "shopper3@example.com", "password": "SuperSecretPassword123!"},
    {"email": "shopper4@example.com", "password": "SuperSecretPassword123!"},
    {"email": "shopper5@example.com", "password": "SuperSecretPassword123!"}
]

# ==========================================
# 2. VIRTUAL USER DEFINITION
# ==========================================
# Inheriting from HttpUser gives every virtual user its own browser session
# to store cookies, manage connections, and fire HTTP requests.
class JuiceShopShopper(HttpUser):
    
    # 'wait_time' simulates a real human pacing. Instead of firing requests
    # continuously at the speed of light, the user will randomly pause
    # for half a second to 1.5 seconds between actions.
    wait_time = between(0.5, 1.5)

    # ==========================================
    # 3. TASKS & WEIGHTS
    # ==========================================
    # The @task decorator tells Locust what actions the user can take.
    # The number (1) is the weight. Since the login task has a weight of (5),
    # Locust will pick the login task 5 times more often than the homepage task.

    @task(1)
    def load_homepage(self):
        """Simulates light background traffic on the root URL."""
        self.client.get("/")

    @task(5)
    def heavy_login_attempt(self):
        """Simulates a heavy database write/cryptographic operation."""
        
        # We use Python's random library to grab one dictionary payload
        # from our USER_CREDENTIALS pool above.
        dynamic_user = random.choice(USER_CREDENTIALS)
        
        # 'catch_response=True' is a Senior QA trick. 
        # By default, Locust fails a test if it gets a 400 or 401 error.
        # However, since these are fake accounts, the server will rightfully
        # return a "401 Unauthorized" error. We want to tell Locust: 
        # "A 401 is expected application behavior, do not mark it as a failure!"
        with self.client.post("/rest/user/login", json=dynamic_user, catch_response=True) as response:
            
            # If the server responds with 200 (Success) or 401 (Wrong Password),
            # the server is alive and functioning correctly.
            if response.status_code in [200, 401]:
                response.success()
                
            # If the server throws a 500 (Internal Error), 503 (Unavailable),
            # or drops the connection (0), we manually mark it as a failure.
            else:
                response.failure(f"Server struggling! Status: {response.status_code}")

            # NOTE:
            # Wake up venv (if not already active): source .venv/bin/activate
            # Run the test with: locust -f performance_tests/locustfile_ddt.py