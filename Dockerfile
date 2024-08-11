FROM maven:3.8.5-eclipse-temurin-16 AS maven
WORKDIR /tmp/maven/
RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/* 
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello /tmp/maven/
RUN sed -i 's/<source>1.6<\/source>/<source>1.8<\/source>/g' pom.xml \
    && sed -i 's/<target>1.6<\/target>/<target>1.8<\/target>/g' pom.xml \
    && sed -i 's/<version>2.5<\/version>/<version>3.2.3<\/version>/g' pom.xml
RUN mvn package

FROM tomcat:9.0.91-jdk8-temurin
COPY --from=maven /tmp/maven/target/hello-1.0.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
