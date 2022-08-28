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

cat << EOF > /tmp/user-setup.sql
USE wordpress;
/*!40000 ALTER TABLE wp_users DISABLE KEYS */;
INSERT INTO wp_users VALUES
(1
    ,'Paulo'
    ,MD5('$OWNER_PASSWORD')
    ,'paulo'
    ,'paulo@example.com'
    ,'https://psergio-.42.fr'
    ,'2022-08-25 22:09:10'
    ,''
    ,0
    ,'Paulo')
,(2
    ,'santana'
    ,MD5('$SECOND_USER_PASSWORD')
    ,'santana'
    ,'santana@example.com'
    ,''
    ,'2022-08-25 22:18:55'
    ,''
    ,0,
    'San Tana');
/*!40000 ALTER TABLE wp_users ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
EOF

    echo "[MARIADB - build] Setting up mariadb"

    echo "[MARIADB - build] Setting up the wordpress database"
    /usr/share/mariadb/mysql.server start
    mysql < /tmp/setup.sql
    mysql -p$MARIADB_ROOT_PASSWORD -h localhost < /tmp/wordpress.sql
    mysql -p$MARIADB_ROOT_PASSWORD -h localhost < /tmp/user-setup.sql
    /usr/share/mariadb/mysql.server stop
    rm -rf /tmp/setup.sql
    rm -rf /tmp/wordpress.sql
    rm -rf /tmp/user-setup.sql
    #cat /tmp/user-setup.sql

    echo "[MARIADB - build] Done!"

fi

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0
