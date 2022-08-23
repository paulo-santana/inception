FROM alpine:3.15

ARG MARIADB_ROOT_PASSWORD

ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_PASSWORD
ARG WORDPRESS_DB_NAME

RUN apk add mariadb mariadb-client --no-cache  \
	&& mkdir /var/run/mysqld  \
	&& chown -R mysql:root /var/run/mysqld  \
	&& chown -R mysql:root /var/lib/mysql

COPY ./conf/wordpress.sql /tmp/wordpress.sql
COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY ./tools/setup-db.sh /root/setup-db.sh

RUN chmod u+x /root/setup-db.sh

ENTRYPOINT [ "/root/setup-db.sh" ]
