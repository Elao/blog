# Manala
MANALA_DIR = $(abspath $(patsubst %/make/Makefile,%,$(firstword $(filter %manala/make/Makefile,$(MAKEFILE_LIST)))))

# Docker
DOCKER_IMAGE   = manala/hugo
DOCKER_OPTIONS = $(if $(shell nc -z localhost 1313 &> /dev/null && echo 0),,--publish 1313:1313)
DOCKER_TAG    ?=

# Hugo
HUGO_OPTIONS += --cleanDestinationDir

include $(MANALA_DIR)/make/Makefile.manala
include $(MANALA_DIR)/make/Makefile.docker
include $(MANALA_DIR)/make/Makefile.vm.docker
include $(MANALA_DIR)/make/Makefile.hugo
include $(MANALA_DIR)/make/Makefile.laravel-mix
include $(MANALA_DIR)/make/Makefile.rsync
