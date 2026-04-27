# 1. Use the official image built by the library creators 
FROM marketsquare/robotframework-browser:latest

# 2. Switch to root temporarily to set up our custom folder
USER root

# 3. Set the working directory
WORKDIR /app

# 4. Copy your test file directly
COPY e2e_test.robot .

# 5. Fix permissions so the built-in user can write the "results" folder
RUN chown -R pwuser:pwuser /app

# 6. Switch back to the safe, default user. Running tests as root or other non pwuser can cause problems!
USER pwuser

# 7. Execute the test
CMD ["robot", "-d", "results", "e2e_test.robot"]
