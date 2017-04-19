.SILENT:
.PHONY: install build watch

include ../../manala/make/Makefile

###########
# Install #
###########

## Install - Development
install@development:
	$(call log,Yarn)
	yarn install

## Install - Staging
install@staging:
	$(call log,Yarn)
	yarn install

## Install - Production
install@production:
	$(call log,Yarn)
	yarn install

#########
# Build #
#########

## Build - Development
build@development:
	$(call log,Laravel mix)
	rm -Rf static/assets && $(LARAVEL_MIX)

## Build - Staging
build@staging:
	$(call log,Laravel mix)
	rm -Rf static/assets && $(LARAVEL_MIX)

## Build - Production
build@production:
	$(call log,Laravel mix)
	rm -Rf static/assets && $(LARAVEL_MIX)

#########
# Watch #
#########

## Watch - Development
watch@development:
	$(call log,Laravel mix - Watch)
	rm -Rf static/assets && $(LARAVEL_MIX_WATCH)
