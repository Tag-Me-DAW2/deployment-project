FROM node:22.19.0 AS build

RUN apt-get install -y git

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH=main
ARG CACHE_BUST=1
RUN git clone --branch ${GIT_BRANCH} https://github.com/Tag-Me-DAW2/bank-frontend.git

WORKDIR /opt/app/bank-frontend

ARG BUILD_ENV=prod

RUN npm ci
RUN npm run build -- --configuration=${BUILD_ENV}

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/bank-frontend/dist/a/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

