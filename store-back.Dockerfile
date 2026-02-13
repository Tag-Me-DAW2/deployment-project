FROM maven:3.9.11-eclipse-temurin-21-noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH=main
ARG CACHE_BUST=1   # <--- cache bust para invalidar git clone

RUN git clone --branch ${GIT_BRANCH} https://github.com/Tag-Me-DAW2/store-backend.git .

WORKDIR /opt/app/store-backend
RUN mvn clean install -DskipTests

EXPOSE 8080

CMD ["java","-jar", "target/tagme-store-back-0.0.1-SNAPSHOT.jar"]
