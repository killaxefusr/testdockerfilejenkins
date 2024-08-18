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
                    //подключение к личному репозиторию, подтягивание образа
                    docker.withRegistry('http://192.168.56.106:8123/repository/mydockerrepo', 'nexusdocker') {
                    docker.image('192.168.56.106:8123/repository/mydockerrepo/maven_build:0.1').inside('-u root:sudo') {
                        //необходим аппрув через администратора на использование таких методов
                        //очистка workspace, а затем подтягивание свежих артефактов с гита
                        sh 'pwd'
                        sh 'ls -liah'
                        sh 'rm -rf *'
                        sh 'rm -rf .??*'
                        sh 'ls -liah'
                        checkout scm
                        sh 'ls -liah'
                        sh 'docker info | grep -A 20 "Insecure Registries"'
                    }
                }
            }
        }
    }
}
}
