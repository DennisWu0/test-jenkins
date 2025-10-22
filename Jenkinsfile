pipeline {
    agent any

    environment {
        APP_NAME = "simple-web"
        IMAGE_NAME = "my-simple-web"
        CONTAINER_NAME = "my-simple-web"
        DOCKER_PORT = "7070"
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }

    triggers {
        // Auto-trigger build when pushing to main branch
        pollSCM('H/5 * * * *')
    }
    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🏗️ Building Docker image..."
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Stop Old Container') {
            steps {
                echo "🛑 Stopping old container (if exists)..."
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }

        stage('Run New Container') {
            steps {
                echo "🚀 Running new container..."
                sh "docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:80 ${IMAGE_NAME}"
            }
        }

        stage('Test Deployment') {
            steps {
                echo "🔍 Checking if container is running..."
                sh "docker ps | grep ${CONTAINER_NAME}"
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded! Visit: http://192.168.0.143:${DOCKER_PORT}"
            script {
                currentBuild.description = "✅ Docker deployment success"
            }
        }
        failure {
            echo "❌ Deployment failed!"
            script {
                currentBuild.description = "❌ Docker deployment failed"
            }
        }
        always {
            echo "🧹 Cleaning workspace..."
            cleanWs()
        }
    }
}