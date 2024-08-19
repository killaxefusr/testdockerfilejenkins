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
					args '--privileged --user root'
					//подключение к личному репозиторию, подтягивание образа
					}
				}
            steps {
                script {
					//очистка workspace
				    sh 'pwd'
				    sh 'rm -rf *'
				    sh 'rm -rf .??*'
				    checkout scm
				    sh 'ls -liah'
					
					//скачиваем файлы приложения
					sh "git clone 'https://github.com/boxfuse/boxfuse-sample-java-war-hello'"
			
            		// Edit the pom.xml file
					sh "sed -i 's/<source>1.6<\\/source>/<source>1.8<\\/source>/g' ./boxfuse-sample-java-war-hello/pom.xml"
					sh "sed -i 's/<target>1.6<\\/target>/<target>1.8<\\/target>/g' ./boxfuse-sample-java-war-hello/pom.xml"
					sh "sed -i 's/<version>2.5<\\/version>/<version>3.2.3<\\/version>/g' ./boxfuse-sample-java-war-hello/pom.xml"
					sh 'chmod -R 777 .'
					sh 'ls -liah ./boxfuse-sample-java-war-hello/'
					//собираем приложение
					sh 'mvn -f ./boxfuse-sample-java-war-hello/pom.xml install'
					sh 'ls -liah'
					
                    // Запускаем Docker daemon в фоновом режиме
                    sh 'dockerd --host=unix:///var/run/docker.sock &'
                    // Небольшая пауза, чтобы dockerd успел стартовать
                    sh 'sleep 10'
                    sh 'docker info'

                    //забираем докерфайл и билдим образ
					echo 'building docker image by dockerfile and app_file'
					sh 'wget https://raw.githubusercontent.com/killaxefusr/testdockerfilejenkins/main/Dockerfile'
					sh 'chmod -R 777 .'
					sh 'docker build -t maven_build:v$TAG_NUMBER .'
					sh 'docker tag maven_build:v$TAG_NUMBER 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER'

                    //логинимся и пушим в локальное репо созданный образ
					withCredentials([usernamePassword(credentialsId: 'nexusdocker', passwordVariable: 'nexusdockerPassword', usernameVariable: 'nexusdockerUser')]){
						echo 'start pushing with tag $TAG_NUMBER'
						sh '''
						BUILDKIT_NO_CLIENT_TOKEN=true docker login  http://192.168.56.106:8123/repository/mydockerrepo -u "$nexusdockerUser" -p "$nexusdockerPassword"
						BUILDKIT_NO_CLIENT_TOKEN=true docker push 192.168.56.106:8123/repository/mydockerrepo/maven_build:$TAG_NUMBER'''
					}

                    }
                }
            }
		stage('Run docker and app on devbe-srv01') {
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
    	post {
        failure {
		node {'DevNode08'}
            // Команда, которая будет выполнена, если пайплайн завершится с ошибкой
            	sh 'chmod -R 777 .'
        }
    }	
    }
