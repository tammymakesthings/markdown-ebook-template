#----------------------------------------------------------------------------
# Build targets: File Rules
#----------------------------------------------------------------------------

%.epub: $(INPUT_FILES) $(EPUB_METADATA_FILE)
	$(call target_banner_build, Ebook, epub)
	$(PANDOC) $(COMMON_OPTS) $(EPUB_OPTS) --to=epub -o $@ $(INPUT_FILES) \
		$(EPUB_METADATA_FILE)

%.tex: $(INPUT_FILES)
	$(call target_banner_build, Print Book, TeX)
	$(PANDOC) $(COMMON_OPTS) $(PDF_OPTS) $(INPUT_FILES) -o $@

%.mobi: %.epub
	$(call target_banner_build, EBook, mobi)
	$(EBOOK_CONVERT) $< $@ $(MOBI_OPTS)

%.pdf: checkrequired %.md
	$(call target_banner_build, $<, PDF (single file))
	$(PANDOC) $(PDF_SINGLE_OPTS) -o $@ $<

%.docx: checkrequired %.md
	$(call target_banner_build, $<, DOCX (single file))
	$(PANDOC) -o $@ $<
