#!/bin/sh

if [ -d /var/lib/mysql/mysql ]; then
    echo "Mariadb is already installed"
else

    echo "Installing mariadb"
    mysql_install_db --user=mysql --basedir=/usr --ldata=/var/lib/mysql

    cat << EOF > /tmp/setup.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';
FLUSH PRIVILEGES;
EOF

    echo "[MARIADB - build] Setting up mariadb"

    echo "[MARIADB - build] Setting up the wordpress database"
    /usr/share/mariadb/mysql.server start
    mysql < /tmp/setup.sql
    mysql -p$MARIADB_ROOT_PASSWORD -h 127.0.0.1 < /tmp/wordpress.sql
    /usr/share/mariadb/mysql.server stop

    echo "[MARIADB - build] Done!"

fi

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0
