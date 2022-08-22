#!/bin/sh

if [ -d /var/lib/mysql/mysql ]; then
    echo "Mariadb is already installed"
else

    echo "Installing mariadb"
    mysql_install_db --user=mysql --basedir=/usr --ldata=/var/lib/mysql

    cat << EOF > /tmp/setup.sql
USE mysql;
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE $MYSQL_DB_NAME;
GRANT ALL ON wordpress.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF

    echo "[MYSQL - build] Setting up mariadb"
    # $SQL_CMD < /tmp/setup.sql

    echo "[MYSQL - build] Setting up the wordpress database"
    /usr/share/mariadb/mysql.server start
    mysql < /tmp/setup.sql
    mysql -p$MYSQL_ROOT_PASSWORD -h 127.0.0.1 < /tmp/wordpress.sql
    /usr/share/mariadb/mysql.server stop

    #wait_server_startup

    # echo $SQL_SETUP | mariadb -uroot

    echo "[MYSQL - build] Done!"

fi

# mysqld --user=mysql
exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0
