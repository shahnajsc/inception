#!/bin/sh

#Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting nginx Initialization Script..."

#Ensure required environment variables are set
: "${DOMAIN_NAME:?Environment variable DOMAIN_NAME is required}"

echo "ENV Variables Check Done..."

#OPEN SSL: Setting up Secure Sockets Layer(SSL) certificate
if [ ! -f /etc/nginx/ssl/cert.crt ] || [ ! -f /etc/nginx/ssl/cert.key ]; then
    echo "Generating New SSL certificate..."

	openssl req -x509 \
		-days 365 \
		-newkey rsa:2048 \
		-nodes \
		-keyout /etc/nginx/ssl/cert.key \
		-out /etc/nginx/ssl/cert.crt \
		-subj "/CN=$DOMAIN_NAME"
	echo "SSL Certificate Generation Done..."
else
	echo "SSL Certificate Already Exists..."
fi
#Setting read/write permission of key for owner
chmod 600 /etc/nginx/ssl/cert.key

#Setting read permission of certificate for all
chmod 644 /etc/nginx/ssl/cert.crt
echo "SSL Certificate and Key File Permission Done..."

# Run NGINX in the foreground
echo "Starting nginx Server..."
exec nginx -g "daemon off;"
