#----------------------------------------------------------------------------
# Build targets: Utility
#----------------------------------------------------------------------------

open: checkrequired
	@$(VSCODE) $(BASE_DIR)/nikkiverse.code-workspace

environment : variables

toolpaths: checkrequired
	@echo ""
	@echo "******************************************************************************"
	@echo "* Makefile Tool Paths"
	@echo "******************************************************************************"
	@echo "*"
	@echo "*    RM            = $(RM)"
	@echo "*    GIT           = $(GIT)"
	@echo "*    PANDOC        = $(PANDOC)"
	@echo "*    EBOOK_CONVERT = $(EBOOK_CONVERT)"
	@echo "*    PDF_ENGINE    = $(PDF_ENGINE)"
	@echo "*    PERL          = $(PERL)"
	@echo "*    XELATEX       = $(XELATEX)"
	@echo "*    PYTHON        = $(PYTHON)"
	@echo "*    SPELL         = $(SPELL)"
	@echo "*    GS            = $(GS)"
	@echo "*    VSCODE        = $(VSCODE)"
	@echo "*"
	@echo "******************************************************************************"
	@echo ""

variables: checkrequired
	@echo ""
	@echo "******************************************************************************"
	@echo "* Makefile Environment"
	@echo "******************************************************************************"
	@echo "*"
	@echo "* => Environment Paths"
	@echo "*       BOOK_BASE            = $(BOOK_BASE)"
	@echo "*       BOOK_TOPDIR          = $(BOOK_TOPDIR)"
	@echo "*       SHARED_RESOURCES     = $(SHARED_RESOURCES)"
	@echo "*           TEXINC_DIR       = $(TEXINC_DIR)"
	@echo "*           FONTS_DIR        = $(FONTS_DIR)"
	@echo "*           SCRIPTS_DIR      = $(SCRIPTS_DIR)"
	@echo "*"
	@echo "* => Book File Information"
	@echo "*       FILENAME             = $(FILENAME)"
	@echo "*       BOOK_TAG             = $(BOOK_TAG)"
	@echo "*       BOOK_NUM             = $(BOOK_NUM)"
	@echo "*       BOOK_NUM_PADDED      = $(BOOK_NUM_PADDED)"
	@echo "*"
	@echo "* => Book Metadata"
	@echo "*       BOOK_TITLE           = $(BOOK_TITLE)"
	@echo "*       SERIES_TITLE         = $(SERIES_TITLE)"
	@echo "*       AUTHOR               = $(AUTHOR)"
	@echo "*       BETA_PDF_FILE        = $(BETA_PDF_FILE)"
	@echo "*       PANDOC_METADATA_FILE = $(PANDOC_METADATA_FILE)"
	@echo "*       EPUB_METADATA_FILE   = $(EPUB_METADATA_FILE)"
	@echo "*"
	@echo "* => Word Count"
	@echo "*      WORDCOUNT_FILE  = $(WORDCOUNT_FILE)"
	@echo "*      WORDCOUNT_GOAL  = $(WORDCOUNT_GOAL)"
	@echo "*"
	@echo "******************************************************************************"
	@echo ""

.PHONY: open variables environment toolpaths
