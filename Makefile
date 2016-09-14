.SILENT:
.PHONY: help

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Help
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

#######
# Dev #
#######

## Dev
shell:
	docker run \
		--hostname blog.dev \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/home \
		--user `id -u` \
		--publish 1313:1313 \
		--tty --interactive \
		manala/hugo-debian \
		bash

###########
# Install #
###########

## Install
install:
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/home \
		--user `id -u` \
		--tty \
		manala/hugo-debian \
		bash -c "\
			NPM_CONFIG_CACHE=/tmp/npm npm install \
		"
#########
# Build #
#########

## Build
build: install
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/home \
		--user `id -u` \
		--tty \
		manala/hugo-debian \
		bash -c "\
			node_modules/.bin/gulp build \
			&& hugo --theme=blog --config=config_fr.yaml \
		"

## Build and optimize
build-and-optimize: build crop optimize

#########
# Watch #
#########

## Watch
watch:
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/srv \
		--user `id -u` \
		--tty -i \
		--publish 1313:1313 \
		manala/hugo-debian \
		hugo server --bind=0.0.0.0 --theme=blog --config=config_fr.yaml --buildDrafts --watch --ignoreCache=true

## Images compression
optimize:
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/srv \
		--user `id -u` \
		--tty \
		manala/hugo-debian \
		bash -c "\
			find public/fr/images -iname "*.png" -type f -exec optipng -o7 {} \; \
			&& find public/en/images -iname "*.png" -type f -exec optipng -o7 {} \; \
			&& find public/fr/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \; \
			&& find public/en/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \; \
		"
## Crop thumbnail and header files
crop: crop-thumbnails crop-headers

crop-thumbnails:
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/srv \
		--user `id -u` \
		--tty \
		manala/hugo-debian \
		bash -c "\
			find public/fr/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \; \
			&& find public/en/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \; \
		"
crop-headers:
	docker run \
		--rm \
		--volume `pwd`:/srv \
		--env HOME=/srv \
		--user `id -u` \
		--tty \
		manala/hugo-debian \
		bash -c "\
			find public/fr/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \; \
			&& find public/en/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \; \
		"
## Deploy app to production (after static build and images optimization)
deploy_and_optimize@prod: build-and-optimize
	echo "google-site-verification: google98e08ccbf4b44d9b.html" > public/google98e08ccbf4b44d9b.html
	rsync -arzv --delete public deploy@blog.elao.elao.local:/srv/app

## Deploy app to production (after static build)
deploy@prod: build
	echo "google-site-verification: google98e08ccbf4b44d9b.html" > public/google98e08ccbf4b44d9b.html
	rsync -arzv --delete --exclude '*/images' public deploy@blog.elao.elao.local:/srv/app
