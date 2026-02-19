FROM maven:3.9.11-eclipse-temurin-21-noble

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH

COPY ./repos/bank-backend /opt/app/bank-backend

WORKDIR /opt/app/bank-backend
RUN mvn clean install -DskipTests

EXPOSE 8080
CMD ["java","-jar", "target/tagme_bank_back-0.0.1-SNAPSHOT.jar"]
