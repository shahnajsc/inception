# inception – A Docker Infrastructure Project
Inception – Docker Infrastructure Project
A system administration and DevOps project to build a secure, multi-service Docker environment using
Docker Compose inside a virtual machine.
This project aims to deepen your understanding of **system administration, containerization**, and **Docker networking**. You will virtualize several services using Docker, configure them securely, and run them in isolated containers — all within a Debian-based virtual machine.

The architecture includes:
- **NGINX** with HTTPS
- **WordPress** with PHP-FPM
- **MariaDB** as the database engine
- Docker volumes and networks for persistent and isolated infrastructure

## 🧰 Tech Stack

- 🐳 Docker & Docker Compose
- 🐧 Debian 11 "Bullseye" (penultimate stable)
- 🌐 NGINX with TLSv1.2+ only
- 🐘 PHP-FPM for WordPress
- 🐬 MariaDB (no NGINX inside DB container)
- 🔐 Self-signed SSL via OpenSSL
- 🗃️ Volumes for data persistence
- 🔄 Auto-restarting containers

✅ Project Requirements Checklist
 - Custom Dockerfiles for each service (no image pulling except Alpine/Debian)
 - Use of Debian 11 as base image
 - Docker Compose setup via Makefile
 - TLSv1.2+ support via NGINX on port 443 only
 - WordPress + PHP-FPM container
 - MariaDB container with init config
 - 2 named volumes (DB & WordPress files)
 - Secure credentials using environment variables
 - Restart policies for all containers
 - No tail -f, infinite loops, or bash loops in entrypoints
 - .env file for config separation
 - No use of latest Docker tags

## 🔐 Security Best Practices
- No credentials hardcoded in Dockerfiles
- Use .env + Docker secrets (optionally) to secure passwords
- TLS enforced by NGINX (self-signed certs via OpenSSL)
- Admin username restrictions for WordPress

## 📁 Directory Structure
```
.
├── Makefile
├── docker-compose.yml
├── .env
├── srcs/
│   ├── nginx/
│   │   ├── Dockerfile
│   │   └── default.conf
│   ├── wordpress/
│   │   ├── Dockerfile
│   │   └── wp-config.php
│   ├── mariadb/
│   │   ├── Dockerfile
│   │   └── custom-init.sql
└── data/
    ├── db/        # Volume for MariaDB data
    └── wp/        # Volume for WordPress files
```

## 🚀 Setup Instructions
 ⚠️ All steps must be done inside a Debian VM (e.g., VirtualBox).
 1. Clone the repository
```bash
git clone .................
cd inception
```

2. Configure the .env file
   Set all necessary environment variables
```env
  DOMAIN=yourlogin.42.fr
  WP_ADMIN_USER=myadmin
  WP_ADMIN_PASS=securepassword
  WP_DB_NAME=wordpress
  WP_DB_USER=wp_user
  WP_DB_PASS=wp_password
  MYSQL_ROOT_PASSWORD=rootpass
  ```

3. Build and Run the Infrastructure
```
make
```
  This will:
  - Build custom Docker images
  - Start all services via docker-compose
  - Mount data volumes to /home/yourlogin/data/

## Project Status
Submission and peer evaluation is done. Secured 101%
