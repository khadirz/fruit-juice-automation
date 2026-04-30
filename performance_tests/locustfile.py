from locust import HttpUser, task, between

class JuiceShopShopper(HttpUser):
    # We are dropping the wait time to make the attack even more aggressive
    wait_time = between(0.5, 1.5)

    @task(1)
    def load_homepage(self):
        """Keep some background noise on the homepage"""
        self.client.get("/")

    @task(5)
    def heavy_login_attempt(self):
        """Hammer the login API to force CPU-heavy password hashing"""
        payload = {
            "email": "loadtest@example.com",
            "password": "SuperSecretPassword123!"
        }
        
        # We use catch_response=True because a 401 Unauthorized is an expected 
        # application response, not a server crash. We only want Locust to 
        # report a 'Failure' if the server physically drops the connection or throws a 500.
        # NOTE:
        # Install the Locust package:  # pip install locust
        # Update your requirements.txt file: # pip freeze > requirements.txt
        # Run the test with: locust -f performance_tests/locustfile.py


        with self.client.post("/rest/user/login", json=payload, catch_response=True) as response:
            if response.status_code in [200, 401]:
                response.success()
            else:
                response.failure(f"Server struggling! Status: {response.status_code}")