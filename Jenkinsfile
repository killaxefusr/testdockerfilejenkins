pipeline {
  agent none
  
  stages {
    stage('build app and docker container') {
      agent {
        label 'DevNode08'}
      steps {
        script {
          docker.image('maven:3.8.5-eclipse-temurin-16').inside('-u root:sudo') {
        echo 'start installing git docker-ce in docker'

            echo 'start building app'
            cleanWs()
            git(url: 'https://github.com/boxfuse/boxfuse-sample-java-war-hello/', branch: 'main')
        sh 'chown -R user0723study:user0723study ./boxfuse-sample-java-war-hello/'
        sh 'ls -liah'
        sh 'cd boxfuse-sample-java-war-hello/'
        sh 'ls -liah'
        sh "sed -i 's/<source>1.6<\\/source>/<source>1.8<\\/source>/g' boxfuse-sample-java-war-hello/pom.xml"
        sh "sed -i 's/<target>1.6<\\/target>/<target>1.8<\\/target>/g' boxfuse-sample-java-war-hello/pom.xml"
        sh "sed -i 's/<version>2.5<\\/version>/<version>3.2.3<\\/version>/g' boxfuse-sample-java-war-hello/pom.xml"

            echo 'building app_file in maven'
        sh 'mvn -f boxfuse-sample-java-war-hello/pom.xml'
            

            echo 'building docker image by dockerfile and app_file'
        sh 'wget https://raw.githubusercontent.com/killaxefusr/testdockerfilejenkins/main/Dockerfile'
        sh 'chown user0723study:user0723study ./boxfuse-sample-java-war-hello/target/hello-1.0.war'
        sh 'docker build -t maven_build:v$TAG_NUMBER .'
        sh 'docker tag maven_build:v$TAG_NUMBER 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER'
        sh 'touch /etc/docker/daemon.json'
        sh """echo '{"insecure-registries": ["http://192.168.56.106:8123"]}' > /etc/docker/daemon.json"""

          withCredentials([usernamePassword(credentialsId: 'nexusdocker', passwordVariable: 'nexusdockerPassword', usernameVariable: 'nexusdockerUser')]){
          echo 'start pushing with tag $TAG_NUMBER'
          sh '''
          BUILDKIT_NO_CLIENT_TOKEN=true docker login  http://192.168.56.106:8123/repository/mydockerrepo -u "$nexusdockerUser" -p "$nexusdockerPassword"
          BUILDKIT_NO_CLIENT_TOKEN=true docker push 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER'''
          }
        }
      }
      }
      }
    
    stage('Run docker on ProdNode07') {
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
