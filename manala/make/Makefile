###############
# Environment #
###############

ifdef ENV
MANALA_ENV = $(ENV)
endif

##########
# Docker #
##########

MANALA_DOCKER_IMAGE   = manala/hugo
MANALA_DOCKER_OPTIONS = $(if $(shell nc -z localhost 1313 > /dev/null 2>&1 && echo 0),,--publish 1313:1313)
MANALA_DOCKER_TAG    ?=

########
# Hugo #
########

MANALA_HUGO_OPTIONS  = --theme $(HUGO_THEME)
MANALA_HUGO_OPTIONS += $(if $(APP_URL),--baseURL $(subst ://,://$(if $(APP_URL_SUBDOMAIN),$(APP_URL_SUBDOMAIN).),$(APP_URL)))
MANALA_HUGO_OPTIONS += --cleanDestinationDir

HUGO            = $(MANALA_HUGO)
HUGO_SERVER     = $(MANALA_HUGO_SERVER)
MAKE_HUGO_THEME = make --silent --directory themes/$(HUGO_THEME)

# Development
%@development: MANALA_HUGO_OPTIONS += --buildDrafts --buildFuture

# Staging
%@staging: MANALA_HUGO_OPTIONS += --buildDrafts --buildFuture

###############
# Laravel Mix #
###############

LARAVEL_MIX       = $(MANALA_LARAVEL_MIX)
LARAVEL_MIX_WATCH = $(MANALA_LARAVEL_MIX_WATCH)

# Development
%@development: MANALA_LARAVEL_MIX_OPTIONS = --progress

########
# Node #
########

# Development
%@development: export NODE_ENV = development

# Staging
%@staging: export NODE_ENV = production

# Production
%@production: export NODE_ENV = production

############
# Optimize #
############

ifdef OPTIMIZE_IMAGES
MANALA_OPTIMIZE_IMAGES = $(OPTIMIZE_IMAGES)
endif

#########
# Rsync #
#########

MANALA_RSYNC_RSH = $(RSYNC_RSH)

RSYNC = $(MANALA_RSYNC)

##########
# Manala #
##########

MANALA_DIR = $(abspath $(patsubst %/make/Makefile,%,$(firstword $(filter %manala/make/Makefile,$(MAKEFILE_LIST)))))

include $(MANALA_DIR)/make/Makefile.manala
include $(MANALA_DIR)/make/Makefile.docker
include $(MANALA_DIR)/make/Makefile.vm.docker
include $(MANALA_DIR)/make/Makefile.hugo
include $(MANALA_DIR)/make/Makefile.laravel-mix
include $(MANALA_DIR)/make/Makefile.optimize
include $(MANALA_DIR)/make/Makefile.rsync

-include $(MANALA_DIR)/../.env
