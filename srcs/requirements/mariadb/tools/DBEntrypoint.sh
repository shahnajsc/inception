#!/bin/sh

# Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting MariaDB Initialization Script..."

# Ensure required environment variables are set
: "${DB_NAME:?Environment variable DB_NAME is required}"
: "${DB_USER:?Environment variable DB_USER is required}"
: "${DB_PASS:?Environment variable DB_PASS is required}"
: "${DB_ROOT_USER:?Environment variable DB_ROOT_USER is required}"
: "${DB_ROOT_PASS:?Environment variable DB_ROOT_PASS is required}"
echo "ENV Variables Check Done..."

# Check if database is already initialized

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "MariaDB Installing..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "MariaDB Not Yet Initialized. Bootstrapping Database..."
mysqld --user=mysql --bootstrap <<EOF
	USE mysql;
	FLUSH PRIVILEGES;

	CREATE DATABASE IF NOT EXISTS ${DB_NAME};

	CREATE USER IF NOT EXISTS ${DB_USER}@'%' IDENTIFIED BY '${DB_PASS}';
	GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_USER}@'%' WITH GRANT OPTION;

	CREATE USER IF NOT EXISTS ${DB_ROOT_USER}@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
	ALTER USER ${DB_ROOT_USER}@'%' IDENTIFIED BY '${DB_ROOT_PASS}';

	FLUSH PRIVILEGES;
EOF
echo "Database Initialization Done..."

# Start MariaDB in the foreground
echo "Starting MariaDB Server..."
exec mysqld --user=mysql
