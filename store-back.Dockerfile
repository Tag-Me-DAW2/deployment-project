FROM maven:3.9.11-eclipse-temurin-21-noble

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH

COPY ./repos/store-backend /opt/app/store-backend

WORKDIR /opt/app/store-backend
RUN mvn clean install -DskipTests

EXPOSE 8080

CMD ["java","-jar", "target/tagme-store-back-0.0.1-SNAPSHOT.jar"]
