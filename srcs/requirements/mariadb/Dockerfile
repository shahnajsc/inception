# Base image :: work as a base image to build on
FROM alpine:3.21.3

#MariaDB :: DB installation, directory creation (volume and log) and permission
RUN apk update && \
	apk add --no-cache mariadb mariadb-client && \
	mkdir -p /var/lib/mysql  /run/mysqld /var/log/mysql && \
	chown -R mysql:mysql /var/lib/mysql  /run/mysqld /var/log/mysql && \
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	## which mariadb-install-db        ls /usr/bin | grep install_db

#Copy :: Copies config file and startup script into the image
COPY conf/mariadb.cnf /etc/my.cnf.d/
COPY tools/DBEntrypoint.sh /usr/local/bin

#VOLUME :: Persist database data
# better option to define in compose as it can be nammed, manageable (ls, rm..)
# persistant accross restart, defined and version controlled

#Port :: Allow external services to connect
EXPOSE 3306

#Entrypoint script permission :: Makes script executable
RUN chmod +x /usr/local/bin/DBEntrypoint.sh

#Entrypoint script :: Defines what should run when container starts
ENTRYPOINT ["/usr/local/bin/DBEntrypoint.sh"]
