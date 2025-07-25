# Base image :: work as a base image to build on
FROM alpine:3.21.3

#MariaDB :: DB installation, directory creation (volume and log) and permission
RUN apk update && \
	apk add --no-cache mariadb mariadb-client bash && \
	mkdir -p /run/mysqld /var/lib/mysql /etc/mysql /var/log/mysql  && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql && \
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	## which mariadb-install-db        ls /usr/bin | grep install_db

#Copy :: Copies config file and startup script into the image
COPY ./conf/mariadb.cnf /etc/my.cnf
COPY tools/DBEntrypoint.sh /usr/local/bin

#VOLUME :: Persist database data
# better option to define in compose as it can be nammed, manageable (ls, rm..)
# persistant accross restart, defined and version controlled

#Entrypoint script permission :: Makes script executable
RUN chmod 644 /etc/my.cnf
RUN chmod +x /usr/local/bin/DBEntrypoint.sh

#Port :: Allow external services to connect
EXPOSE 3306

#Entrypoint script :: Defines what should run when container starts
ENTRYPOINT ["/usr/local/bin/DBEntrypoint.sh"]


#conf file location ******
