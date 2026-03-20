FROM	debian:bookworm

RUN 	apt-get update && \
		apt-get upgrade -y && \
		apt-get install -y \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

RUN		mkdir /var/run/mysqld && \
		chown -R mysql:mysql /var/run/mysqld && \
		chmod 777 /var/run/mysqld

COPY	./tools/script.sh /usr/local/bin/
COPY	./conf/50-server.cnf /etc/mysql/mariaDB.conf.d/

RUN		chmod +x /usr/local/bin/script.sh

EXPOSE	3306

ENTRYPOINT ["/usr/local/bin/script.sh"]

CMD ["mysqld"]