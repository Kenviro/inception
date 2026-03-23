#!/bin/sh

# create socket directory
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# only do initialization if database doesn't exist
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	service mariadb start
	until mysqladmin ping >/dev/null 2>&1; do
		echo "Waiting for MariaDB..."
		sleep 1
	done

	# create database from .env
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

	# create database user from .env (allow connections from any host)
	mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

	# grant privileges for database to new user
	mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

	# change root user password
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

	# refresh to apply
	mysql -e "FLUSH PRIVILEGES;"

	# shutdown mysql
	mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
fi

# relaunch
exec mysqld --user=mysql