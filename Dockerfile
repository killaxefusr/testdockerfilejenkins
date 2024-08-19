FROM tomcat:9.0.91-jdk8-temurin
COPY ./boxfuse-sample-java-war-hello/target/hello-1.0.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
