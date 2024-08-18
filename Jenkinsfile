pipeline {
    agent none

    stages {
        stage('Build and Push Docker Image') {
            agent {
                node {
                    label 'DevNode08'
                }
            }
            steps {
                script {
                    docker.image('maven:3.8.5-eclipse-temurin-16').inside('-u root:sudo') {
                        sh 'ls'
                    }
                }
            }
        }
    }
}
