FROM debian:bullseye

RUN apt-get update \
	apt-get upgrade -y \
	nginx \
	openssl

RUN openssl req -x509 -newkey rsa:2048 \
	-keyout etc/nginx/ssl/key.pem \
	-out etc/nginx/ssl/req.pem \
	-subj "/C=CH/L=Lausanne/O=42/CN=ktintim-"

COPY conf/nginx.conf etc/nginx/conf.d/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]