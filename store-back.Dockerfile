FROM maven:3.9.11-eclipse-temurin-21-noble
 
ENV DEBIAN_FRONTEND=noninteractive
 
RUN apt-get update
RUN apt-get install -y git
 
RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone https://github.com/Tag-Me-DAW2/store-backend.git
WORKDIR /opt/app/store-backend
RUN git switch --detach origin/develop
RUN mvn clean install -DskipTests
 
EXPOSE 8080

CMD ["java","-jar", "target/tagme-store-back-0.0.1-SNAPSHOT.jar"]

