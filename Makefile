DATA_DIR 		= /home/shachowd/data
MYSQL_DIR 		= $(DATA_DIR)/db
WP_DIR 			= $(DATA_DIR)/wp

COMPOSE_FILE 	= ./srcs/docker-compose.yml
ENV_FILE 		= ./srcs/.env
DC 				= docker compose --env-file $(ENV_FILE) --file $(COMPOSE_FILE)

all: up

mkdirs:
	@mkdir -p $(MYSQL_DIR) $(WP_DIR)

check:
	command -v docker >/dev/null 2>&1 || { echo "$(RED)Error: Docker is not installed.$(RESET)"; exit 1; }
	command -v docker-compose >/dev/null 2>&1 || command -v docker >/dev/null 2>&1 || { echo "$(RED)Error: Docker Compose is not installed.$(RESET)"; exit 1; }

up: mkdirs check
	$(DC) up --build -d
	echo -e "$(GREEN)All services are up and running.$(RESET)"

down:
	$(DC) down

stop:
	$(DC) stop

start:
	$(DC) start

re: fclean all

logs:
	$(DC) logs --f

clean: down
	@sudo rm -rf $(DATA_DIR)

fclean: clean
	docker system prune --all --volumes --force

help:
	echo "Available targets:"
	echo "  all, up      Build and start containers"
	echo "  down         Stop containers"
	echo "  ps           Show container status"
	echo "  logs         Show container logs"
	echo "  clean        Stop containers and remove data directories"
	echo "  fclean       Remove all Docker data and volumes"
	echo "  re           Rebuild everything"
	echo "  help         Show this help message"

.PHONY : all up down stop start re logs clean fclean mkdirs
