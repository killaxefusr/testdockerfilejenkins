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

                    docker.image('maven_build:0.1').inside('-u root:sudo') {
                        sh 'ls'
                    }
                }
            }
        }
    }
}
}
