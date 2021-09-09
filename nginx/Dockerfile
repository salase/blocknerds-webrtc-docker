FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /usr/share/nginx/html/*
COPY /nginx/config/*.conf ./etc/nginx/conf.d/
COPY /cert/domain/domain-selfsigned.crt /etc/ssl/certs/
COPY /cert/domain/domain-selfsigned.key /etc/ssl/private/
COPY /cert/public/public-selfsigned.crt /etc/ssl/certs/
COPY /cert/public/public-selfsigned.key /etc/ssl/private/
COPY /cert/local/local-selfsigned.crt /etc/ssl/certs/
COPY /cert/local/local-selfsigned.key /etc/ssl/private/

RUN apk update && apk upgrade
RUN apk -q add curl nano libcap

ARG CERT="local"
ENV CERT=${CERT}
RUN sed -i "s/CERT/${CERT}/g" ./etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
