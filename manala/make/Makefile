# Manala
MANALA_DIR = $(abspath $(patsubst %/make/Makefile,%,$(firstword $(filter %manala/make/Makefile,$(MAKEFILE_LIST)))))

# Docker
DOCKER_IMAGE  = manala/hugo
DOCKER_TAG   ?=

include $(MANALA_DIR)/make/Makefile.manala
include $(MANALA_DIR)/make/Makefile.docker
include $(MANALA_DIR)/make/Makefile.vm.docker
include $(MANALA_DIR)/make/Makefile.hugo
include $(MANALA_DIR)/make/Makefile.laravel-mix
include $(MANALA_DIR)/make/Makefile.rsync
