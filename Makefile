DATA_DIR 		= /home/shachowd/data
MYSQL_DIR 		= $(DATA_DIR)/db
WP_DIR 			= $(DATA_DIR)/wp

COMPOSE_FILE 	= ./srcs/docker-compose.yml
ENV_FILE 		= ./srcs/.env
DC 				= docker compose --env-file $(ENV_FILE) --file $(COMPOSE_FILE)

all: up

mkdirs:
	@mkdir -p $(MYSQL_DIR) $(WP_DIR)

up: mkdirs
	$(DC) up --build

down:
	$(DC) down

stop:
	$(DC) stop

start:
	$(DC) start

re: fclean all

logs:
	$(DC) logs --follow

clean: down
	@sudo rm -rf $(DATA_DIR)

fclean: clean
	docker system prune --all --volumes --force

.PHONY : all up down stop start re logs clean fclean mkdirs
