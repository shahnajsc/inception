#!/bin/sh

set -e

echo "Starting MariaDB initialization script..."

# Ensure required environment variables are set
: "${MYSQL_DB:?Environment variable MYSQL_DB is required}"
: "${MYSQL_USER:?Environment variable MYSQL_USER is required}"
: "${MYSQL_PASS:?Environment variable MYSQL_PASS is required}"
: "${MYSQL_ROOT_USER:?Environment variable MYSQL_ROOT_USER is required}"
: "${MYSQL_ROOT_PASS:?Environment variable MYSQL_ROOT_PASS is required}"


# Check if database is already initialized

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "MariaDB not yet initialized. Bootstrapping database..."

	mariadbd --user=mysql --bootstrap <<EOF
		USE mysql;
		FLUSH PRIVILEGES;

		CREATE DATABASE IF NOT EXISTS ${MYSQL_DB};

		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;

		CREATE USER IF NOT EXISTS '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
		ALTER USER '${MYSQL_ROOT_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';


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
