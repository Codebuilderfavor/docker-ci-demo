pipeline {
    agent any

    environment {
        IMAGE_NAME = "docker-ci-demo"   // Local Docker image name
    }

    stages {
        stage('Checkout') {
            steps {
                echo "=== Checkout ==="
                checkout scm
                sh 'pwd && ls -la'
            }
        }

        stage('Build Docker image') {
            steps {
                echo "=== Build Docker image ==="
                sh """
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    echo "Built image: ${IMAGE_NAME}:${BUILD_NUMBER}"
                    docker images | head -n 10
                """
            }
        }

        stage('Run tests in Docker') {
            steps {
                echo "=
