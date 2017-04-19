.SILENT:
.PHONY: install build watch

# Hugo
HUGO_THEME = 2015

include  manala/make/Makefile

#########
# Setup #
#########

setup@development: install build

###########
# Install #
###########

## Install
install: $(call proxy,install)

## Install - Development
install@development:
	# Theme
	$(MAKE_HUGO_THEME) install@development

## Install - Staging
install@staging:
	# Theme
	$(MAKE_HUGO_THEME) install@staging

## Install - Production
install@production:
	# Theme
	$(MAKE_HUGO_THEME) install@production

#########
# Build #
#########

## Build
build: $(call proxy,build)

## Build - Development
build@development:
	# Theme
	$(MAKE_HUGO_THEME) build@development

	$(call log,Hugo)
	$(HUGO)

	$(call log,Crop images)
	find public/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \;
	find public/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \;

## Build - Staging
build@staging:
	# Theme
	$(MAKE_HUGO_THEME) build@staging

	$(call log,Hugo)
	$(HUGO)

	$(call log,Crop images)
	find public/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \;
	find public/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \;

	$(call log,Optimize images)
	find public/images -iname "*.png" -type f -exec optipng -quiet -o7 {} \;
	find public/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \;

## Build - Production
build@production:
	# Theme
	$(MAKE_HUGO_THEME) build@production

	$(call log,Hugo)
	$(HUGO)

	$(call log,Crop images)
	find public/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \;
	find public/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \;

	$(call log,Optimize images)
	find public/images -iname "*.png" -type f -exec optipng -quiet -o7 {} \;
	find public/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \;

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

deploy-staging: RSYNC_RSH = $(DEPLOY_RSH)
deploy-staging:
	$(RSYNC) public/ $(DEPLOY_DESTINATION)
