USER_DIR = /home/psergio-
DATA_DIR = $(USER_DIR)/data

WP_VOLUME = $(DATA_DIR)/wordpress
DB_VOLUME = $(DATA_DIR)/mariadb

VOLUMES = $(WP_VOLUME) \
		  $(DB_VOLUME)

$(DATA_DIR):
	sudo mkdir -p $(USER_DIR)
	sudo chown $$USER -R $(USER_DIR)
	mkdir -p $(DATA_DIR)

$(VOLUMES):
	mkdir -p $@

purge:
	sudo rm -rf $(USER_DIR)
