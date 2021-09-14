#----------------------------------------------------------------------------
# Definition of the content file loctions for the book
#----------------------------------------------------------------------------

FRONTMATTER_FILES=$(shell echo $(BOOK_TOPDIR)/mss_01_front/*.md | sort)
MAINMATTER_FILES=$(shell echo $(BOOK_TOPDIR)/mss_02_main/*.md | sort)
ENDMATTER_FILES=$(shell echo $(BOOK_TOPDIR)/mss_03_end/*.md | sort)
JOURNAL_FILES=$(shell echo $(BOOK_TOPDIR)/journal/*.md | sort)

INPUT_FILES=$(FRONTMATTER_FILES) \
			$(MAINMATTER_FILES) \
			$(ENDMATTER_FILES)

# INPUT_FILES, minus the dedication, acknowledgements, and copyright pages
# Those pages have numbers starting with fm_00, so all files with that base
# number are excluded.
CONTENT_FILES=$(wildcard $(BOOK_TOPDIR)/mss_01_front/fm_0[1-9]*.md) \
			  $(wildcard $(BOOK_TOPDIR)/mss_01_front/fm_[1-9]*.md) \
			  $(MAINMATTER_FILES) \
			  $(ENDMATTER_FILES)

