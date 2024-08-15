pipeline {
  agent none
  
  stages {
    stage('build app + docker container') {
      agent {
        docker {
          image 'maven:3.8.5-eclipse-temurin-16'
          args '-u root:sudo'
          customWorkspace '/tmp/'
          }
        }
      steps {
        echo 'start installing docker-ce in docker'
        sh '''
        apt apt-get -y install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
        apt-get update
        apt-get -y install docker-ce 
        EOF'''
        }
      steps {
        echo 'start building app'
        git branch: 'main', url: 'https://github.com/boxfuse/boxfuse-sample-java-war-hello'
        sh '''sed -i 's/<source>1.6<\/source>/<source>1.8<\/source>/g' pom.xml \
        && sed -i 's/<target>1.6<\/target>/<target>1.8<\/target>/g' pom.xml \
        && sed -i 's/<version>2.5<\/version>/<version>3.2.3<\/version>/g' pom.xml
        EOF'''
        }
      steps {
        echo 'building app_file in maven'
        sh 'mvn package'
        }
      steps {
        echo 'building docker image by dockerfile and app_file'
        sh 'docker build -t maven_build:v$TAG_NUMBER .'
        sh 'docker tag maven_build:v$TAG_NUMBER 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER'
        sh 'touch /etc/docker/daemon.json'
        sh """echo '{"insecure-registries": ["http://192.168.56.106:8123"]}' > /etc/docker/daemon.json"""
        }
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexusdocker', passwordVariable: 'nexusdockerPassword', usernameVariable: 'nexusdockerUser')]){
          echo 'start pushing with tag $TAG_NUMBER'
          sh '''
          BUILDKIT_NO_CLIENT_TOKEN=true docker login  http://192.168.56.106:8123/repository/mydockerrepo -u "$nexusdockerUser" -p "$nexusdockerPassword"
          BUILDKIT_NO_CLIENT_TOKEN=true docker push 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER
          EOF'''
          }
        }
      }
    
    stage('Run docker on devbe-srv01') {
      agent {
        label 'ProdNode07'}
      steps {
        withCredentials([usernamePassword(credentialsId: 'nexusdocker', passwordVariable: 'nexusdockerPassword', usernameVariable: 'nexusdockerUser')]){
          echo 'start pulling with tag $TAG_NUMBER'
          sh '''
          BUILDKIT_NO_CLIENT_TOKEN=true docker login  http://192.168.56.106:8123/repository/mydockerrepo -u "$nexusdockerUser" -p "$nexusdockerPassword"
          BUILDKIT_NO_CLIENT_TOKEN=true docker pull 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER
          docker run -d -p 8080:8080 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER
          '''
          }
        }
      }
    }
  }
