pipeline {
    // 1. The Execution Environment
    agent {
    docker { 
        image 'mcr.microsoft.com/playwright/python:v1.40.0-jammy' 
    }
    }

    // 2. Global Variables
    environment {
        TARGET_URL = "https://juice-shop-104226998836.us-central1.run.app"
    }

    // 3. The Test Execution Steps
    stages {
        stage('Checkout Code') {
            steps {
                // This replaces the actions/checkout@v4 step
                checkout scm 
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install -r requirements.txt
                    rfbrowser init
                '''
            }
        }

        stage('API & Security Fuzzing') {
            steps {
                sh '''
                    . .venv/bin/activate
                    robot -d results security_tests/
                '''
            }
        }

        stage('UI End-to-End Tests') {
            steps {
                // We still use xvfb-run for the virtual display!
                sh '''
                    . .venv/bin/activate
                    xvfb-run robot -d results e2e_ui_tests/
                '''
            }
        }

        stage('Performance Load Testing') {
            steps {
                sh '''
                    . .venv/bin/activate
                    locust -f performance_tests/locustfile_ddt.py --headless -u 50 -r 10 -t 15s --host=${TARGET_URL}
                '''
            }
        }

        stage('OWASP ZAP Dynamic Scan') {
            steps {
                // Since Jenkins doesn't have "GitHub Actions", we run the ZAP Docker container natively
                sh '''
                    chmod -R 777 $WORKSPACE
                    docker run -v $WORKSPACE:/zap/wrk/:rw -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t ${TARGET_URL} -r zap_report.html || true
                '''
            }
        }
    }

    // 4. Teardown & Artifact Uploads
    post {
        always {
            // This replaces the actions/upload-artifact step
            archiveArtifacts artifacts: 'results/*.html, zap_report.html', allowEmptyArchive: true
        }
        success {
            echo "🎉 Pipeline Passed successfully!"
        }
        failure {
            echo "🚨 Pipeline Failed! Sending alert..."
            // You could put a Slack or email notification step here
        }
    }
}