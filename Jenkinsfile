pipeline {
    agent any

    environment {
        IMAGE_NAME = "docker-ci-demo"  // your local image name
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Checkout ==='
                checkout scm
                sh 'pwd && ls -la'
            }
        }

        stage('Build Docker image') {
            steps {
                echo '=== Build Docker image ==='
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                sh "docker images | head -n 10"
            }
        }

        stage('Run tests in Docker') {
            steps {
                echo '=== Run tests in Docker ==='
                sh "docker run --rm ${IMAGE_NAME}:${BUILD_NUMBER} npm test"
            }
        }

        stage('Run API container (smoke test)') {
            steps {
                echo '=== Smoke test API ==='
                sh '''
                    # Remove old test container if present
                    docker rm -f docker-ci-demo-test || true

                    # Start new container from YOUR image
                    docker run -d --name docker-ci-demo-test docker-ci-demo:${BUILD_NUMBER}

                    # Wait a bit for the app to start
                    sleep 5

                    # Call the app from INSIDE the container
                    docker exec docker-ci-demo-test curl -f http://localhost:3000
                '''
            }
        }

        stage('Cleanup container') {
            steps {
                echo '=== Cleanup test container ==='
                sh 'docker rm -f docker-ci-demo-test || true'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'SUCCESS: Image built, tested and smoke-tested.'
        }
        failure {
            echo 'FAILURE: See logs above.'
        }
    }
}
