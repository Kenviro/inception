#!/bin/bash

cd /var/www/html

until mysqladmin ping -h"$SQL_HOST" -u"${SQL_USER}" -p"${SQL_PASSWORD}" --silent 2>/dev/null; do
    sleep 2
done

if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
    wp core download --allow-root --path='/var/www/html'
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "avant wp config create"
    wp config create    --allow-root \
        --dbname="${SQL_DATABASE}" \
        --dbuser="${SQL_USER}" \
        --dbpass="${SQL_PASSWORD}" \
        --dbhost=${SQL_HOST}:3306 \
        --path='/var/www/html'
    wp core install        --allow-root \
                        --url="https://${DOMAIN_NAME}" \
                        --title="42 Inception ${DOMAIN_NAME}" \
                        --admin_user="${WP_ADMIN_USER}" \
                        --admin_password="${WP_ADMIN_PASSWORD}" \
                        --admin_email="${WP_ADMIN_EMAIL}" \
                        --path='/var/www/html'
    wp user create        --allow-root \
                        "${WP_USER}" \
                        "${WP_USER_EMAIL}" \
                        --user_pass="${WP_PASSWORD}" \
                        --role=author \
                        --path='/var/www/html'
fi

exec /usr/sbin/php-fpm8.2 -F