USER_DIR = /home/psergio-
DATA_DIR = $(USER_DIR)/data

WP_VOLUME = $(DATA_DIR)/wordpress
DB_VOLUME = $(DATA_DIR)/mariadb

VOLUMES = $(WP_VOLUME) \
		  $(DB_VOLUME)

up:  $(VOLUMES)
	sudo sed -i '/\(\<psergio-\.42\.fr\>\)/!s/\(127.0.0.1\)\(.\+\)/\1\2 psergio-.42.fr/' /etc/hosts
	docker-compose -f ./srcs/docker-compose.yml up -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

fclean: down
	sudo sed -i '/\(127.0.0.1\)/s/ psergio-.42.fr//' /etc/hosts
	sudo rm -rf $(USER_DIR); \
	docker rm $$(docker ps -a -q); \
	docker rmi $$(docker image ls -a -q); \
	docker volume rm $$(docker volume ls -q); \
	docker network rm $$(docker network ls -q); true

re: fclean up

$(DATA_DIR):
	sudo mkdir -p $(USER_DIR)
	sudo chown $$USER -R $(USER_DIR)
	mkdir -p $(DATA_DIR)

$(VOLUMES): $(DATA_DIR)
	mkdir -p $@	
