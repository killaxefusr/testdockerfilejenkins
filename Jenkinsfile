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
                    docker.withRegistry('http://192.168.56.106:8123/repository/mydockerrepo', 'nexusdocker') {
                    docker.image('192.168.56.106:8123/repository/mydockerrepo/maven_build:0.1').inside('-u root:sudo') {
                        sh 'ls -liah'
                        sh 'rm -rf *'
                        sh 'rm -rf .??*'
                        sh 'ls -liah'
                        checkout scm
                        sh 'ls -liah'
                    }
                }
            }
        }
    }
}
}
