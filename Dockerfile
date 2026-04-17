FROM nginx:alpine
ARG BUILD_VERSION=dev
COPY blockage-buster.html /usr/share/nginx/html/index.html
RUN sed -i "s/__BUILD_VERSION__/${BUILD_VERSION}/g" /usr/share/nginx/html/index.html
EXPOSE 80
