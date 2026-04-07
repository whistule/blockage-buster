FROM nginx:alpine
COPY blockage-buster.html /usr/share/nginx/html/index.html
EXPOSE 80
