#----------------------------------------------------------------------------
# Build targets: "all" and "veryall"
#----------------------------------------------------------------------------

all: checkrequired \
	$(BOOK_TOPDIR)/$(FILENAME).pdf \
	$(BOOK_TOPDIR)/$(FILENAME).epub \
	$(BOOK_TOPDIR)/$(FILENAME).mobi

veryall: checkrequired \
	$(BOOK_TOPDIR)/$(FILENAME).pdf \
	$(BOOK_TOPDIR)/$(FILENAME).epub \
	$(BOOK_TOPDIR)/$(FILENAME).mobi \
	$(BOOK_TOPDIR)/$(FILENAME)_draft.pdf \
	$(BOOK_TOPDIR)/$(FILENAME)_journal.pdf \
	$(BOOK_TOPDIR)/$(BETA_PDF_FILE).pdf

.PHONY: all veryall
