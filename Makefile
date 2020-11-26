SLIDE_DIR  := src/slides/asciidoc
SITE_DIR := target/site
BOOK_DIR := target/book
RESOURCE_SOURCE_DIR := src/images
RESOURCE_TARGET_DIR := $(SITE_DIR)/images

# Reveal.js
REVEALJS_DIR=$(SITE_DIR)/reveal.js
MDE=$(SITE_DIR)/mde-languages.min.js
STEREOPTICON=$(REVEALJS_DIR)/css/theme/stereopticon.css

SLIDE_SOURCES := $(wildcard $(SLIDE_DIR)/*.adoc)
SLIDE_TARGETS := $(patsubst $(SLIDE_DIR)/%.adoc, $(SITE_DIR)/%.html, $(SLIDE_SOURCES))

.PHONY: clean slides book

$(SITE_DIR)/%.html: $(SLIDE_DIR)/%.adoc 
	@echo '[Generating Reveal.js website]'
	bundle exec asciidoctor-revealjs \
		-r asciidoctor-diagram \
		-o $@ $<

$(BOOK_DIR)/book.pdf: src/book/asciidoc/book.adoc
	@echo '[Generating PDF files]'
	bundle exec asciidoctor-pdf \
		-r asciidoctor-diagram \
		--attribute imagesdir=../../images \
		--attribute allow-uri-read=true \
		-o $@ $<

slides: resources $(SLIDE_TARGETS)

book: $(BOOK_DIR)/book.pdf

resources: prepare 
	@echo '[Preparing resources]'
	mkdir -p $(RESOURCE_TARGET_DIR)
	rsync -r $(RESOURCE_SOURCE_DIR)/  $(RESOURCE_TARGET_DIR)

prepare: $(REVEALJS_DIR) $(STEREOPTICON) $(MDE)

$(REVEALJS_DIR):
	git clone -b 3.9.2 --depth 1 https://github.com/hakimel/reveal.js.git $(REVEALJS_DIR) 2> /dev/null || (cd $(REVEALJS_DIR) ; git pull)

$(MDE):
	wget --directory-prefix=$(SITE_DIR) https://github.com/highlightjs/highlightjs-mde-languages/releases/download/0.1.0/mde-languages.min.js 

$(STEREOPTICON): 
	cd $(REVEALJS_DIR); curl -sL https://gitlab.univ-nantes.fr/bousse-e/stereopticon/raw/develop/install-or-update-stereopticon.sh | bash -

clean:
	rm -rf target
