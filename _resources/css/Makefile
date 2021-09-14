# Makefile for ebook.css

TOP_DIR=$(shell cd ../.. ; pwd)
SASS_COMPILER=/home/tammy/.nvm/versions/node/v14.2.0/bin/sass
CP=/usr/bin/cp

SASSC_OPTIONS=--load-path=$(TOP_DIR)/_resources/css \
			  --update

SCSS_FILES=$(wildcard *.scss)
CSS_FILES=$(shell find $(TOP_DIR) -name $(OUTPUT_FILE).css -print | grep -v '_resources/css')

OUTPUT_FILE=ebook

all: compile distribute

compile: $(OUTPUT_FILE).css

$(OUTPUT_FILE).css: $(SCSS_FILES)
	$(SASS_COMPILER) $(SASSC_OPTIONS) $(OUTPUT_FILE).scss $(OUTPUT_FILE).css

distribute: $(OUTPUT_FILE).css
	for f in $(CSS_FILES); do $(CP) $(OUTPUT_FILE).css $$f; done

.PHONY: all compile distribute
