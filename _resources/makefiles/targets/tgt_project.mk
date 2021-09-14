#----------------------------------------------------------------------------
# Build targets: Project Output Files
#----------------------------------------------------------------------------

$(BOOK_TOPDIR)/$(FILENAME).pdf: checkrequired $(INPUT_FILES) $(PANDOC_METADATA_FILE)
	$(call target_banner_build, Print Book, PDF (final))
	$(PANDOC) $(COMMON_OPTS) $(PDF_BASE_OPTS) $(PDF_FINAL_OPTS) $(INPUT_FILES) -o $(BOOK_TOPDIR)/$(FILENAME).tex
	$(PERL) $(SCRIPTS_DIR)/fixup_xelatex.pl $(BOOK_TOPDIR)/$(FILENAME).tex final $(BOOK_TITLE) $(SERIES_TITLE) $(AUTHOR)
	$(XELATEX) $(BOOK_TOPDIR)/$(FILENAME).tex
	$(XELATEX) $(BOOK_TOPDIR)/$(FILENAME).tex
	$(GS) -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
		-o $(BOOK_TOPDIR)/$(FILENAME)_optimized.pdf $(FILENAME).pdf
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME).aux \
		$(BOOK_TOPDIR)/$(FILENAME).log \
		$(BOOK_TOPDIR)/$(FILENAME).toc \
		$(BOOK_TOPDIR)/$(FILENAME).dvi \
		$(BOOK_TOPDIR)/$(FILENAME).tex

$(BOOK_TOPDIR)/$(BETA_PDF_FILE).pdf: checkrequired $(CONTENT_FILES) $(PANDOC_METADATA_FILE)
	$(call target_banner_build, Print Book, PDF (beta readers))
	$(PANDOC) $(COMMON_OPTS) $(PDF_BASE_OPTS) $(PDF_BETA_OPTS) $(CONTENT_FILES) \
		$(PANDOC_METADATA_FILE) -o $(BOOK_TOPDIR)/$(BETA_PDF_FILE).tex
	$(PERL) $(SCRIPTS_DIR)/fixup_xelatex.pl $(BOOK_TOPDIR)/$(BETA_PDF_FILE).tex final $(BOOK_TITLE) $(SERIES_TITLE) $(AUTHOR)
	$(XELATEX) $(BOOK_TOPDIR)/$(BETA_PDF_FILE).tex
	$(XELATEX) $(BOOK_TOPDIR)/$(BETA_PDF_FILE).tex
	$(RM) -f $(BOOK_TOPDIR)/$(BETA_PDF_FILE).aux \
		$(BOOK_TOPDIR)/$(BETA_PDF_FILE).log \
		$(BOOK_TOPDIR)/$(BETA_PDF_FILE).toc \
		$(BOOK_TOPDIR)/$(BETA_PDF_FILE).dvi \
		$(BOOK_TOPDIR)/$(BETA_PDF_FILE).tex

$(BOOK_TOPDIR)/$(FILENAME)_journal.pdf: checkrequired $(JOURNAL_FILES) $(PANDOC_METADATA_FILE)
	$(call target_banner_build, Book Journal, PDF)
	$(PANDOC) $(COMMON_OPTS) $(PDF_BASE_OPTS) $(PDF_JOURNAL_OPTS) \
		-o $(BOOK_TOPDIR)/$(FILENAME)_journal.pdf \
		$(JOURNAL_FILES)

$(BOOK_TOPDIR)/$(FILENAME)_draft.pdf: checkrequired $(INPUT_FILES) $(PANDOC_METADATA_FILE)
	$(call target_banner_build, Print Book, PDF (draft))
	$(PANDOC) $(COMMON_OPTS) $(PDF_BASE_OPTS) $(PDF_DRAFT_OPTS) \
		-o $(BOOK_TOPDIR)/$(FILENAME)_draft.pdf \
		$(INPUT_FILES)

betapdf: checkrequired $(BOOK_TOPDIR)/$(BETA_PDF_FILE).pdf

pdf: checkrequired $(BOOK_TOPDIR)/$(FILENAME).pdf

mobi: checkrequired $(BOOK_TOPDIR)/$(FILENAME).mobi

epub: checkrequired $(BOOK_TOPDIR)/$(FILENAME).epub

draftpdf: checkrequired $(BOOK_TOPDIR)/$(FILENAME)_draft.pdf

journal: checkrequired $(BOOK_TOPDIR)/$(FILENAME)_journal.pdf

.PHONY: betapdf pdf mobi epub draftpdf journal
