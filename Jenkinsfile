pipeline {
    agent any
    tools {
        maven 'Maven3' 
    }


    environment {
        DOCKER_HUB_CREDENTIALS =credentials('docker-cred')
        DOCKER_HUB_REPO = 'naveenanm/jkdocker'
    }

    stages {
        stage('Checkout') {
            steps {
               checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/NaveenaNM/maven-docker.git']])
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    // Use a Maven Docker image to build the Java project
                    docker.image('maven:3.6.3-jdk-11').inside {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                        docker.image("${DOCKER_HUB_REPO}:latest").push()
                    }
                }
            }
        }
        stage('Pull Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                        docker.image("${DOCKER_HUB_REPO}:latest").pull()
                    }
                }
            }
        }
        stage('Run Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    docker.image("${DOCKER_HUB_REPO}:latest").inside('-p 8000:8000') {
                        sh 'java -jar target/my-java-app-1.0-SNAPSHOT.jar' // Adjust the command based on your app
                    }
                    }
                }
            }
        }
      
    }

    post {
        always {
            cleanWs()
        }
    }
}
