USER_DIR = /home/psergio-
DATA_DIR = $(USER_DIR)/data

WP_VOLUME = $(DATA_DIR)/wordpress
DB_VOLUME = $(DATA_DIR)/mariadb

VOLUMES = $(WP_VOLUME) \
		  $(DB_VOLUME)

all:  $(VOLUMES)
	sudo sed -i '/\(\<psergio-\.42\.fr\>\)/!s/\(127.0.0.1\)\(.\+\)/\1\2 psergio-.42.fr/' /etc/hosts

$(DATA_DIR):
	sudo mkdir -p $(USER_DIR)
	sudo chown $$USER -R $(USER_DIR)
	mkdir -p $(DATA_DIR)

$(VOLUMES): $(DATA_DIR)
	mkdir -p $@

fclean:
	sudo sed -i '/\(127.0.0.1\)/s/ psergio-.42.fr//' /etc/hosts

re: fclean all

purge:
	sudo rm -rf $(USER_DIR)
