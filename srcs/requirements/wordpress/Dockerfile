# Base image :: work as a base image to build on
FROM alpine:3.21.3

#Wordpress :: php installation with all extensions, www-data group and user creation
#Directory creation (root) and permission
RUN apk update && apk add --no-cache \
    bash curl wget mariadb-client \
    php83 php83-fpm php83-mysqli php83-json php83-mbstring php83-phar \
    php83-session php83-openssl php83-curl php83-xml php83-dom && \
	addgroup -S www-data || true && \
	adduser -S -G www-data www-data || true && \
	mkdir -p /var/www/html /run/php && \
	chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www/html

# Working directory set
WORKDIR /var/www/html

# Wordpress CLI setup
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar

#Copy :: Copies config file and startup script into the image
COPY conf/www.conf /etc/php83/php-fpm.d/
COPY tools/WPEntrypoint.sh /usr/local/bin/

#Entrypoint & PHP Memory set :: Makes script executable and set memory limit to 512
RUN chmod +x /usr/local/bin/WPEntrypoint.sh && \
	sed -i '/^memory_limit\s*=/c\memory_limit = 512M' /etc/php83/php.ini || \
	echo "memory_limit = 512M" >> /etc/php83/php.ini

#Port :: Allow external services to connect
EXPOSE 9000

#Entrypoint script :: Defines what should run when container starts
ENTRYPOINT ["/usr/local/bin/WPEntrypoint.sh"]
