pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t demo-api:${BUILD_NUMBER} .
                """
            }
        }

        stage('Run Unit Tests in Docker') {
            steps {
                sh """
                    docker run --rm demo-api:${BUILD_NUMBER} npm test
                """
            }
        }

        stage('Run API container (smoke test)') {
            steps {
                sh """
                    docker run -d --name api-test -p 3000:3000 demo-api:${BUILD_NUMBER}
                    sleep 3
                    curl -f http://localhost:3000
                    docker rm -f api-test
                """
            }
        }

        stage('Push to Docker Hub (optional)') {
            when {
                expression { return false } // enable later
            }
            steps {
                sh """
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker tag demo-api:${BUILD_NUMBER} yourrepo/demo-api:${BUILD_NUMBER}
                    docker push yourrepo/demo-api:${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        success {
            echo "SUCCESS: Built and tested Docker image!"
        }
        failure {
            echo "FAILED: See logs above."
        }
    }
}
