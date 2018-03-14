.SILENT:

include ../../manala/make/Makefile

###########
# Install #
###########

## Install - All
install@%:
	$(call log,Clean)
	rm -Rf node_modules
	$(call log,Yarn)
	yarn install

#########
# Build #
#########

## Build - All
build@%:
	$(call log,Laravel mix)

#########
# Watch #
#########

## Watch - Development
watch@development:
	$(call log,Laravel mix - Watch)
