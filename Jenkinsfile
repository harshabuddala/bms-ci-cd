pipeline {
    agent any

    environment {
        // Define variables for reusability
        IMAGE_NAME = "bookmyshow-app"
        CONTAINER_NAME = "bms-app"
        HOST_PORT = "3001"
        CONTAINER_PORT = "3000"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image...'
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Cleanup Old Container') {
            steps {
                script {
                    echo 'Cleaning up any existing container...'
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    // Remove dangling images (intermediate builder layers)
                    sh "docker image prune -f"
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    echo 'Running Docker Container...'
                    // Run the container in detached mode
                    sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying container status...'
                    // Wait a few seconds for startup
                    sleep 5
                    // Check if container is listed in docker ps
                    sh "docker ps | grep ${CONTAINER_NAME}"
                }
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Please check logs.'
        }
        success {
            echo 'Pipeline succeeded. Application is running on port ${HOST_PORT}'
        }
    }
}
