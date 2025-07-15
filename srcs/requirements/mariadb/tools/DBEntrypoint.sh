#!/bin/sh

# Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting MariaDB initialization script..."

# Ensure required environment variables are set
: "${DB_NAME:?Environment variable DB_NAME is required}"
: "${DB_USER:?Environment variable DB_USER is required}"
: "${DB_PASS:?Environment variable DB_PASS is required}"
: "${DB_ROOT_USER:?Environment variable DB_ROOT_USER is required}"
: "${DB_ROOT_PASS:?Environment variable DB_ROOT_PASS is required}"


# Check if database is already initialized

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "MariaDB not yet initialized. Bootstrapping database..."

	mariadbd --user=mysql --bootstrap <<EOF
		USE mysql;
		FLUSH PRIVILEGES;

		CREATE DATABASE IF NOT EXISTS ${DB_NAME};

		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
		GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION;

		CREATE USER IF NOT EXISTS '${DB_ROOT_USER}'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
		ALTER USER '${DB_ROOT_USER}'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';

		FLUSH PRIVILEGES;
EOF

	echo "Database initialization complete."
else
	echo "MariaDB already initialized. Skipping bootstrap."
fi

# Start MariaDB in the foregroundWw
echo "Starting MariaDB server..."
exec mariadbd --user=mysql --console


#ALTER USER ${MYSQL_ROOT_USER}@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
