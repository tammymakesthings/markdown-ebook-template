#----------------------------------------------------------------------------
# Variable Definitions
#----------------------------------------------------------------------------

SHARED_RESOURCES ?= $(BOOK_BASE)/_resources
TEXINC_DIR ?= $(SHARED_RESOURCES)/tex
FONTS_DIR ?= $(SHARED_RESOURCES)/fonts
SCRIPTS_DIR ?= $(SHARED_RESOURCES)/scripts

FILEDATE ?= $(shell date +%Y%m%d)

WORDCOUNT_FILE ?= $(BOOK_TOPDIR)/wordcount.csv
WORDCOUNT_GOAL ?= 70000

BETA_PDF_FILE ?= $(FILENAME)_beta_$(shell date +%Y%m%d)

PANDOC_METADATA_FILE ?= $(BOOK_TOPDIR)/metadata/pandoc_metadata.yaml
EPUB_METADATA_FILE ?=  $(BOOK_TOPDIR)/metadata/epub_metadata.yaml

BOOK_NUM_PADDED ?= $(shell python -c "print('$(BOOK_NUM)'.zfill(3))")
