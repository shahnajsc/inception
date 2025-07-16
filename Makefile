DATA_DIR 		= /home/shachowd/data
DB_DIR 		= $(DATA_DIR)/db
WP_DIR 			= $(DATA_DIR)/wp

DOCKER_COMPOSE_FILE 	= ./srcs/docker-compose.yml
ENV_FILE 		= ./srcs/.env
D_COMPOSE 				= docker compose --env-file $(ENV_FILE) --file $(DOCKER_COMPOSE_FILE)

all: up

mkdirs:
	@mkdir -p $(DB_DIR) $(WP_DIR)
	echo -e "$(PINK)Wordpress and MariaDB data directory created..$(RESET)"

check:
	command -v docker >/dev/null 2>&1 || { echo "$(RED)Docker is not installed.$(RESET)"; exit 1; }
	command -v docker-compose >/dev/null 2>&1 || command -v docker >/dev/null 2>&1 || { echo "$(RED)Docker Compose is not installed.$(RESET)"; exit 1; }

up: mkdirs check
	$(D_COMPOSE) up --build -d
	echo -e "$(GREEN)All services are up and running.$(RESET)"

down:
	$(D_COMPOSE) down
	echo -e "$(RED)All services are stopped and removed.$(RESET)"

stop:
	$(D_COMPOSE) stop
	echo -e "$(RED)All services are stopped..$(RESET)"

start:
	$(D_COMPOSE) start
	echo -e "$(GREEN)All services are running.$(RESET)"

re: fclean all

logs:
	$(D_COMPOSE) logs --f

clean: down
	@sudo rm -rf $(DATA_DIR)

fclean: clean
	docker system prune --all --volumes --force


# color
RED			= \033[0;31m
GREEN		= \033[0;32m
PINK		= \033[0;35m
RESET		= \033[0;36m

.PHONY : all up down stop start re logs clean fclean mkdirs

