#!/bin/bash

set -e

# 1. On vérifie si le dossier système 'mysql' existe.
# S'il n'existe pas, c'est que MariaDB n'est pas installé ou que le volume est vide.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de MariaDB..."

    # Installation des fichiers systèmes et des tables de base
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Préparation du SQL d'initialisation
    cat << EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;

-- Création de la DB du projet
CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\`;

-- Création de l'utilisateur
CREATE USER IF NOT EXISTS \`$SQL_USER\`@'%' IDENTIFIED BY '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$SQL_DATABASE\`.* TO \`$SQL_USER\`@'%';

-- Sécurisation Root
ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

    # Exécution du bootstrap
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql

    echo "Base de données configurée avec succès."
fi

# 2. Lancement officiel
# On utilise exec pour que mysqld prenne le PID 1
echo "Démarrage du serveur MariaDB..."
# exec mysqld_safe
exec mariadbd --user=mysql --console