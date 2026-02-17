FROM node:22.19.0 AS build

RUN apt-get install -y git

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH
ARG BUILD_ENV

RUN git clone --branch ${GIT_BRANCH} --depth 1 https://github.com/Tag-Me-DAW2/store-client-frontend.git

WORKDIR /opt/app/store-client-frontend

RUN npm ci
RUN npm run build -- --configuration=${BUILD_ENV}

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/store-client-frontend/dist/store-client-frontend/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

