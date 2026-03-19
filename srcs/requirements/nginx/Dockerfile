FROM debian:bullseye

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
	nginx \
	openssl && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
	-newkey rsa:2048 \
	-keyout etc/nginx/ssl/key.pem \
	-out etc/nginx/ssl/req.pem \
	-subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=ktintim-.42.fr/UID=ktintim-"

RUN rm -rf etc/nging/nginx.conf
COPY conf/nginx.conf etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]