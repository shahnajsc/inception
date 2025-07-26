#!/bin/sh

# Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting Wordpress Initialization Script..."

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

echo "ENV Variables Check Done..."

cd /var/www/html

if [ ! -e ".initialized" ]; then

	echo "Waiting for MariaDB at $DB_HOST..."
	mariadb-admin ping --protocol=tcp --host="$DB_HOST" --user="$DB_USER" --password="$DB_PASS" --wait >/dev/null 2>&1
	echo "Database $DB_NAME is Connected."

	if [ ! -f wp-config.php ]; then
		echo "Downloading Wordpress..."
		./wp-cli.phar core download --allow-root --locale=en_US || true

		./wp-cli.phar config create --allow-root \
			--dbname="${DB_NAME}" \
			--dbuser="${DB_USER}" \
			--dbpass="${DB_PASS}" \
			--dbhost="${DB_HOST}"
		echo "Wordpress Config Create Done..."

		./wp-cli.phar core install --allow-root \
			--skip-email \
			--url="${DOMAIN_NAME}" \
			--title="${WP_TITLE}" \
			--admin_user="${WP_ADMIN_USER}" \
			--admin_password="${WP_ADMIN_PASS}" \
			--admin_email="${WP_ADMIN_EMAIL}"
		echo "Wordpress Core Installation and Admin User Creation Done..."

		./wp-cli.phar user create  "$WP_USER" "$WP_USER_EMAIL" \
			 --allow-root \
			 --user_pass="$WP_USER_PASS" \
			 --role=subscriber
		echo "Additional User Creation Done..."
	else
		echo "Wordpress Already Exists."
	fi

	chmod o+w -R /var/www/html/wp-content
	echo "Wordpress File Access Permission Done..."
	touch ".initialized"
else
	echo "Wordpress Already Installled....."
fi

echo "Running Wordpress..."
exec php-fpm83 --nodaemonize
