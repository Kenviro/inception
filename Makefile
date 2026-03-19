DCPATH = -f ./srcs/docker-compose.yml

RM = rm -rf

GREEN = \033[1;32m
CYAN = \033[1;36m
YELLOW = \033[1;33m
RESET = \033[0m

# Règles
all: up

up:
	@echo "$(YELLOW)Launching docker container...$(RESET)"
	@mkdir -p /home/ktintim-/data/
	@docker compose $(DCPATH) up -d
	@echo "$(CYAN)Launching completed!$(RESET)"

down:
	@echo "$(YELLOW)Stopping docker container...$(RESET)"
	@docker compose $(DCPATH) down
	@echo "$(CYAN)Docker container stopped !$(RESET)"

fclean: down
	sudo rm -rf /home/ktintim-/data
	sudo docker volume rm -f srcs_wp_database
	sudo docker volume rm -f srcs_wp_files
	sudo docker system prune -af

re: down up

.PHONY: all up down re fclean