FROM node:alpine3.18 as build

ARG REACT_APP_BASE_URL

ENV REACT_APP_BASE_URL=$REACT_APP_BASE_URL

# build app
WORKDIR /app
COPY package.json .
RUN yarn
COPY . .
RUN yarn build

# serve with nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf  *
COPY --from=build /app/build .
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off" ]
