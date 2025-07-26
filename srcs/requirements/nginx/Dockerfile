#Base image :: work as a base image to build on
FROM alpine:3.21.3

#NGINX :: NGINX and all dependency installation
RUN apk update && \
	apk add --no-cache nginx gettext openssl bash && \
	mkdir -p /etc/nginx/ssl

#Copy :: Copies config file and startup script into the image
COPY conf/nginx.conf /etc/nginx/http.d/
COPY tools/NXentrypoint.sh /usr/local/bin/

#Port :: Allow external services to connect
EXPOSE 443

#Entrypoint script permission :: Makes script executable
RUN chmod +x /usr/local/bin/NXentrypoint.sh

#Entrypoint script :: Defines what should run when container starts
ENTRYPOINT ["/usr/local/bin/NXentrypoint.sh"]
