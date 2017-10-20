.SILENT:

include ../../manala/make/Makefile

###########
# Install #
###########

## Install - All
install@%:
	$(call log,Yarn)
	yarn install

#########
# Build #
#########

## Build - All
build@%:
	$(call log,Laravel mix)
	rm -Rf static/assets && $(LARAVEL_MIX)

#########
# Watch #
#########

## Watch - Development
watch@development:
	$(call log,Laravel mix - Watch)
	rm -Rf static/assets && $(LARAVEL_MIX_WATCH)
