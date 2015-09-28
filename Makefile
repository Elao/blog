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

## Images optimization
optimize: optimize-thumbnails optimize-headers
	find public/fr/images -iname "*.png" -type f -exec optipng -o7 {} \;
	find public/en/images -iname "*.png" -type f -exec optipng -o7 {} \;
	find public/fr/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \;
	find public/en/images \( -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec jpegtran -copy none -optimize -progressive -outfile {} {} \;

optimize-thumbnails:
	find public/fr/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \;
	find public/en/images/posts/thumbnails \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 400x {} \;

optimize-headers:
	find public/fr/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \;
	find public/en/images/posts/headers \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -type f -exec mogrify -resize 2000x {} \;

## Install
install:
	brew update
	brew install hugo
	sudo easy_install Pygments

clean-up:
	rm -rf public/*

build-fr: clean-up
	hugo --theme=blog --config=config_fr.yaml
	chmod -R a+r static/images

build-en: clean-up
	hugo --theme=blog --config=config_en.yaml
	chmod -R a+r static/images

build-hugo:	build-fr build-en

build-assets:
	gulp build

## Build
build: build-hugo build-assets optimize

## Hugo server (Dev only)
server-start:
	hugo server --theme=blog --buildDrafts --watch --ignoreCache=true

## Hugo server FR (Dev only)
server-start-fr:
	hugo server --theme=blog --buildDrafts --watch --ignoreCache=true --config=config_fr.yaml

## Hugo server EN (Dev only)
server-start-en:
	hugo server --theme=blog --buildDrafts --watch --ignoreCache=true --config=config_en.yaml

## Deploy app to production
deploy@prod: build
	echo "google-site-verification: google98e08ccbf4b44d9b.html" > public/google98e08ccbf4b44d9b.html
	rsync -arzv --delete public deploy@blog.elao.elao.local:/srv/app
