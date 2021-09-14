#----------------------------------------------------------------------------
# Build targets: Project Output Files
#----------------------------------------------------------------------------

clean_intermediate: checkrequired
	$(call target_banner_generic, Clean temporary build files)
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.aux
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.log
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.tex
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.dvi
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.fls*
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.fdb*
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)*.docx

clean_outputs: checkrequired
	$(call target_banner_generic, Clean project output files)
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME).pdf
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME).mobi
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME).epub
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)_draft.pdf
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)_journal.pdf
	$(RM) -f $(BOOK_TOPDIR)/$(BETA_PDF_FILE).pdf
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)_beta_*.pdf
	$(RM) -f $(BOOK_TOPDIR)/$(FILENAME)_optimized.pdf

clean: checkrequired clean_intermediate clean_outputs

.PHONY: clean clean_intermediate clean_outputs
