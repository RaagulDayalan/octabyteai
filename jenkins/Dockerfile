FROM nginx:alpine

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/log/nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
