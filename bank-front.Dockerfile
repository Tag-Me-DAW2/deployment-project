FROM node:22.19.0 AS build

RUN mkdir /opt/app
WORKDIR /opt/app

ARG GIT_BRANCH
ARG BUILD_ENV

COPY ./repos/bank-frontend /opt/app/bank-frontend

WORKDIR /opt/app/bank-frontend

RUN npm ci
RUN npm run build -- --configuration=${BUILD_ENV}

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/bank-frontend/dist/a/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

