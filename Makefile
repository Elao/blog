.SILENT:
.PHONY: install build watch

##########
# Manala #
##########

# Hugo
HUGO_THEME = 2015

# Optimize
OPTIMIZE_IMAGES = public

include manala/make/Makefile

#########
# Setup #
#########

setup@development: install

###########
# Install #
###########

## Install
install: $(call proxy,install)

## Install - All
install@%:
	# Theme
	$(MAKE_HUGO_THEME) install@$*

## Install roles (for deployment)
install-roles:
	ansible-galaxy install --roles-path deploy/roles --role-file deploy/roles/requirements.yaml --force

#########
# Build #
#########

## Build
build: $(call proxy,build)

## Build - All
build@%:
	# Theme
	$(MAKE_HUGO_THEME) build@$*

	$(call log,Hugo)
	$(HUGO)

	$(call log,Crop images - Thumbnails)
	find public/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f \
		-exec echo {} \; \
		-exec mogrify -resize 400x {} \;

	$(call log,Crop images - Headers)
	find public/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f \
		-exec echo {} \; \
		-exec mogrify -resize 2000x {} \;

#########
# Watch #
#########

## Watch
watch: $(call proxy,watch)

## Watch - Development
watch@development: SHELL = dumb-init sh
watch@development:
	# Theme
	$(MAKE_HUGO_THEME) watch@development & \
	$(call log,Hugo - Server) && \
	$(HUGO_SERVER)

##########
# Deploy #
##########

## Deploy - Staging
deploy.staging: RSYNC_RSH = $(DEPLOY_RSYNC_RSH)
deploy.staging:
	$(call log,Rsync)
	$(RSYNC) public/ $(DEPLOY_DESTINATION)$(if $(DEPLOY_DESTINATION_SUFFIX),/$(DEPLOY_DESTINATION_SUFFIX))

## Deploy - Production
deploy.production:
	$(call log,Ansible)
	ansible-playbook \
		--inventory deploy/hosts.yaml \
		--limit localhost,production \
		deploy/playbook.yaml
