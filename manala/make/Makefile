# Manala
MANALA_DIR = $(abspath $(patsubst %/make/Makefile,%,$(firstword $(filter %manala/make/Makefile,$(MAKEFILE_LIST)))))

# Docker
DOCKER_IMAGE   = manala/hugo
DOCKER_OPTIONS = $(if $(shell nc -z localhost 1313 > /dev/null 2>&1 && echo 0),,--publish 1313:1313)
DOCKER_TAG    ?=

# Hugo
HUGO_OPTIONS += --cleanDestinationDir

include $(MANALA_DIR)/make/Makefile.manala
include $(MANALA_DIR)/make/Makefile.docker
include $(MANALA_DIR)/make/Makefile.vm.docker
include $(MANALA_DIR)/make/Makefile.hugo
include $(MANALA_DIR)/make/Makefile.laravel-mix
include $(MANALA_DIR)/make/Makefile.rsync

-include $(MANALA_DIR)/../Makefile.local

################
# Environments #
################

# Development
%@development: HUGO_OPTIONS       += --buildDrafts --buildFuture
%@development: export NODE_ENV     = development
%@development: LARAVEL_MIX_OPTIONS = --progress

# Staging
%@staging: HUGO_OPTIONS   += --buildDrafts --buildFuture
%@staging: export NODE_ENV = production

# Production
%@production: export NODE_ENV = production
