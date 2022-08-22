USER_DIR = /home/psergio-
DATA_DIR = $(USER_DIR)/data

WP_VOLUME = $(DATA_DIR)/wordpress
DB_VOLUME = $(DATA_DIR)/mariadb

VOLUMES = $(WP_VOLUME) \
		  $(DB_VOLUME)

$(DATA_DIR):
	sudo mkdir $(USER_DIR)
	sudo chown -R $$USER $(USER_DIR)
	mkdir -p $(DATA_DIR)

$(VOLUMES):
	mkdir -p $@

purge:
	rm -rf $(USER_DIR)
