#!/bin/sh

# Exit immediately if a command exits with error (non-zero status)
set -e

echo "Starting nginx initialization script..."

# Ensure required environment variables are set
: "${DOMAIN_NAME:?Environment variable DOMAIN_NAME is required}"

# OPEN SSL: Setting up Secure Sockets Layer(SSL) certificate
if [ ! -f /etc/nginx/ssl/cert.crt ] || [ ! -f /etc/nginx/ssl/cert.key ]; then
    echo "Generating new SSL certificate."
	openssl req -x509 \
		-days 365 \
		-newkey rsa:2048 \
		-nodes \
		-keyout /etc/nginx/ssl/cert.key \
		-out /etc/nginx/ssl/cert.crt \
		-subj "/CN=$DOMAIN_NAME"
		echo "Certificate generation done."
else
	echo "SSL certificate already exists."
fi
echo "End of if."
# Setting read/write permission of key for owner
chmod 600 /etc/nginx/ssl/cert.key
echo "chmod 600 done."

# # Setting read permission of sertificate for all
chmod 644 /etc/nginx/ssl/cert.crt
echo "chmod 644 done."

# Run NGINX in the foreground
exec nginx -g "daemon off;"
echo "NGINX up......"

