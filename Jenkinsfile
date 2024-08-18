pipeline {
    agent none

    stages {
        stage('Build and Push Docker Image') {
            agent { 
    docker {
label 'DevNode08'
        image '192.168.56.106:8123/repository/mydockerrepo/mnv_dckr_builder:0.4'
        registryUrl 'http://192.168.56.106:8123/repository/mydockerrepo'
        registryCredentialsId 'nexusdocker'
        args '--privileged'
    }
}
            steps {
                script {
                    //подключение к личному репозиторию, подтягивание образа
                        sh 'pwd'
                       // sh 'rm -rf *'
                       //  sh 'rm -rf .??*'
                       // checkout scm
                        sh 'ls -liah'
                    sh '''dockerd &'''
                    sh 'ps aux'
                    echo 'export DOCKER_HOST=unix://var/run/docker.sock'
                    sh 'docker info'
withCredentials([usernamePassword(credentialsId: 'nexusdocker', passwordVariable: 'nexusdockerPassword', usernameVariable: 'nexusdockerUser')]){
          echo 'start pushing with tag $TAG_NUMBER'
          sh '''
          BUILDKIT_NO_CLIENT_TOKEN=true docker login  http://192.168.56.106:8123/repository/mydockerrepo -u "$nexusdockerUser" -p "$nexusdockerPassword"'''
          }
                    }
                }
            }
        }
    }
