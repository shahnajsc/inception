#!/bin/sh

# Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting Wordpress initialization script..."

# Ensure required environment variables are set
: "${WP_TITLE:?Environment variable WP_TITLE is required}"
: "${WP_USER:?Environment variable WP_USER is required}"
: "${WP_USER_PASS:?Environment variable WP_USER_PASS is required}"
: "${WP_USER_EMAIL:?Environment variable WP_USER_EMAIL is required}"
: "${WP_ADMIN_USER:?Environment variable WP_ADMIN_USER is required}"
: "${WP_ADMIN_PASS:?Environment variable WP_ADMIN_PASS is required}"
: "${WP_ADMIN_EMAIL:?Environment variable WP_ADMIN_EMAIL is required}"

: "${DOMAIN_NAME:?Environment variable DOMAIN_NAME is required}"

: "${DB_HOST:?Environment variable DB_HOST is required}"
: "${DB_NAME:?Environment variable DB_NAME is required}"
: "${DB_USER:?Environment variable DB_USER is required}"
: "${DB_PASS:?Environment variable DB_PASS is required}"

cd /var/www/html

if [ ! -e .firstmount]; then
	mariadb-admin ping --protocol=tcp --host=mariadb -u$DB_USER -p$DB_PASS --wait >/dev/null 2>/dev/null

	if [ ! -f wp-config.php]; then
		./wp-cli.phar core download --allow-root || true
		./wp-cli.phar config create --allow-root \
			--dbname="$DB_NAME" \
			--dbuser="$DB_USER" \
			--dbpass="$DB_PASS" \
			--dbhost="$DB_HOST"
		./wp-cli.phar core install --allow-root \
			--skip-email \
			--url="$DOMAIN_NAME" \
			--title="$WP_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PASS" \
			--admin_email="$WP_ADMIN_EMAIL"
		./wp-cli.phar user create  "$WP_USER" "$WP_USER_EMAIL" \
			 --allow-root \
			 --user_pass="$WP_USER_PASS" \
			 --role=randomuser
	else
		echo "Wordpress already exists."
	fi
	chmod o+w -R /var/www/html/wp-content
	touch .firstmount
fi

exec php-fpm83 -F
