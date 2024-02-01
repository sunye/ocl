SLIDE_DIR  := src/slides/asciidoc
SITE_DIR := build/site
BOOK_DIR := build/book
RESOURCE_SOURCE_DIR := static
RESOURCE_TARGET_DIR := $(SITE_DIR)/

# Reveal.js
REVEALJS_DIR=$(SITE_DIR)/reveal.js
MDE=$(SITE_DIR)/js/mde-languages.min.js

SLIDE_SOURCES := $(wildcard $(SLIDE_DIR)/*.adoc)
SLIDE_TARGETS := $(patsubst $(SLIDE_DIR)/%.adoc, $(SITE_DIR)/%.html, $(SLIDE_SOURCES))

.PHONY: clean slides serve

$(SITE_DIR)/%.html: $(SLIDE_DIR)/%.adoc 
	@echo '[Generating Reveal.js website]'
	bundle exec asciidoctor-revealjs \
		-r asciidoctor-diagram \
		--attribute kroki-fetch-diagram=true \
		--attribute kroki-server-url=http://kroki:8000 \
		--attribute kroki-plantuml-include=../../../resources/defaults/plantuml/puml-theme-sober.puml \
		--attribute kroki-plantuml-include-paths=../../../resources/defaults/plantuml/ \
		--attribute kroki-default-format=svg \
		--attribute plantuml-includedir=../../../resources/defaults/plantuml/ \
		--attribute plantuml-preprocess=true \
		--attribute plantuml-config=../../../resources/defaults/plantuml/puml-theme-sober.puml \
		--attribute diagram-format=svg \
		-v \
		-o $@ $<

slides: resources $(SLIDE_TARGETS)


resources: prepare 
	@echo '[Preparing resources]'
	rsync -r $(RESOURCE_SOURCE_DIR)/  $(RESOURCE_TARGET_DIR)

prepare: $(REVEALJS_DIR) $(MDE)

$(REVEALJS_DIR):
	git clone -b 4.5.0 --depth 1 https://github.com/hakimel/reveal.js.git $(REVEALJS_DIR) 2> /dev/null || (cd $(REVEALJS_DIR) ; git pull)

$(MDE):
	wget --directory-prefix=$(SITE_DIR) https://github.com/highlightjs/highlightjs-mde-languages/releases/download/0.1.0/mde-languages.min.js 


clean:
	rm -rf build

serve:
	live-server ./build/site	&
