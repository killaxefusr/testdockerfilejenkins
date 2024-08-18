pipeline {
    agent none

    stages {
        stage('Build and Push Docker Image') {
            agent { 
    docker {
label 'DevNode08'
        image '192.168.56.106:8123/repository/mydockerrepo/mnv_dckr_builder:0.1'
        registryUrl 'http://192.168.56.106:8123/repository/mydockerrepo'
        registryCredentialsId 'nexusdocker'
        args '-u root:sudo --privileged --insecure-registries http://192.168.56.106:8123'
    }
}
            steps {
                script {
                    //подключение к личному репозиторию, подтягивание образа
                        sh 'pwd'
                        sh 'ls -liah'
                        sh 'rm -rf *'
                        sh 'rm -rf .??*'
                        sh 'ls -liah'
                        checkout scm
                        sh 'ls -liah'
                    sh 'docker pull maven:3.8.5-eclipse-temurin-16'
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
