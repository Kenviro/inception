#!/bin/bash

# On se place dans le dossier du site
cd /var/www/html

# --- 1. ATTENTE DE LA BASE DE DONNÉES ---
echo "Attente de MariaDB..."


# --- DIAGNOSTIC RÉSEAU ---
echo "Test de connexion vers $SQL_HOST..."

# On tente une connexion simple sans attendre, pour voir l'erreur
mariadb-admin ping -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD"

echo "MariaDB est prête !"

# --- 2. INSTALLATION DE WORDPRESS ---
if [ ! -f wp-config.php ]; then
    echo "Installation de WordPress en cours..."

    wp core download --allow-root

    wp config create \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="$SQL_HOST" \
        --allow-root

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    wp user create \
        "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role=author \
        --allow-root
        
    echo "WordPress est installé !"
else
    echo "WordPress est déjà installé."
fi

# --- 3. LANCEMENT DE PHP-FPM ---
echo "Démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F