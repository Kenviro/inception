FROM debian:bullseye

RUN 	apt-get update && \
		apt-get upgrade -y && \
		apt-get install -y \
		curl \
		php8.2-common \
		php8.2-fpm \
		php8.2-mysql \
		php8.2-cli \
		php8.2-opcache \
		php8.2-readline \
		php8.2-redis \
		redis-tools \
		mariadb-client \
		&& rm -rf /var/lib/apt/lists/*

COPY	./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN		chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY	./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY	./tools/auto_config.sh /usr/local/bin/

RUN		chmod +x /usr/local/bin/auto_config.sh

WORKDIR	/var/www/html

EXPOSE	9000

ENTRYPOINT	["/usr/local/bin/auto_config.sh"]