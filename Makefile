#############################################################################
# Markdown to Ebook/Paper Book Conversion Makefile
# Version 1.00, 2020-05-14, Tammy Cravit <tammymakesthings@gmail.com>
#############################################################################
# Requires the following tools to be installed:
#
# - Pandoc
# - ebook-convert (from Calibre)
# - ConTeXt
#############################################################################

#---------------------------------------------------------------------------
# The basename for the generated files
#---------------------------------------------------------------------------

FILENAME=ColdWhispers

#---------------------------------------------------------------------------
# Tool locations
#---------------------------------------------------------------------------

RM=/usr/bin/rm
GIT=/usr/bin/git
PANDOC=/usr/bin/pandoc
EBOOK_CONVERT=/usr/bin/ebook-convert
PDF_ENGINE=/usr/bin/xelatex
PERL=/home/tammy/perl/bin/perl
XELATEX=$(PDF_ENGINE)
PYTHON=/home/tammy/.pyenv/shims/python

# Input files
PANDOC_METADATA_FILE=metadata/pandoc_metadata.yaml
EPUB_METADATA_FILE=metadata/epub_metadata.yaml
FRONTMATTER_FILES=$(shell echo ./fm_*.md | sort)
MAINMATTER_FILES=$(shell echo ./ch_*.md | sort)
ENDMATTER_FILES=$(shell echo ./em_*.md | sort)
JOURNAL_FILES=$(shell echo ./journal/*.md | sort)

# Word Count stuff
WORDCOUNT_FILE=wordcount.csv
WORDCOUNT_GOAL=75000

#---------------------------------------------------------------------------
# Common Pandoc options
#---------------------------------------------------------------------------

COMMON_OPTS=--css=ebook.css \
			--from=markdown \
			--toc \
			--toc-depth=1 \
			--strip-comments \
			--standalone \
			--metadata-file=$(PANDOC_METADATA_FILE) \
			--resource-path=.:metadata:images:tex:fonts

#---------------------------------------------------------------------------
# Format Specific Options
#---------------------------------------------------------------------------

# Pandoc options for EPub files
EPUB_OPTS=$(COMMON_OPTS) \
		  --epub-cover-image=images/cover.png \
		  --epub-embed-font=fonts/*.ttf \
		  --data-dir=.
		  --to=epub

# Pandoc options common to all PDF output targets
PDF_BASE_OPTS=$(COMMON_OPTS) \
			  --pdf-engine=xelatex \
			  -V linkcolor:blue \
			  -V documentclass="book" \
			  --include-in-header=tex/xelatex_bullets.tex  \
			  --include-in-header=tex/xelatex_hyperref.tex  \
			  --include-in-header=tex/xelatex_codeblocks.tex \
			  --highlight-style=metadata/pygments.theme

# Pandoc options for final trade paper-sized PDF book
PDF_OPTS=$(PDF_BASE_OPTS) \
		-V mainfont="Crimson Text" \
		-V monofont="Anonymous Pro" \
		-V classoption="twoside" \
		-V fontsize=11pt \
		--include-in-header=tex/xelatex_chapterbreak.tex \
		--include-in-header=tex/xelatex_papersize.tex

# Pandoc options for letter sized draft PDF
PDF_DRAFT_OPTS=$(PDF_BASE_OPTS) \
		      -V mainfont="Dark Courier" \
			  -V monofont="Dark Courier" \
			  -V fontsize=12pt \
			  --include-in-header=tex/xelatex_doublespace.tex

# Pandoc options for printing the journal file
PDF_JOURNAL_OPTS=$(PDF_BASE_OPTS) \
				 -V mainfont="Crimson Text" \
				 -V monofont="Anonymous Pro" \
				 -V fontsize=12pt

########################### End of Configuration ############################

INPUT_FILES=$(FRONTMATTER_FILES) \
			$(MAINMATTER_FILES) \
			$(ENDMATTER_FILES)

CONTENT_FILES=$(wildcard ./fm_0[1-9]*.md) \
			  $(MAINMATTER_FILES) \
			  $(ENDMATTER_FILES)

all: mobi epub pdf

veryall: clean mobi pdf epub draftpdf journal

help:
	@echo "============================================================================"
	@echo "			 Makefile for Markdown to Pandoc Book Publishing"
	@echo "============================================================================"
	@echo ""
	@echo "Available Targets:"
	@echo ""
	@echo "epub		   Generate an EPUB ebook"
	@echo "mobi		   Generate a MOBI (Kindle) ebook"
	@echo "pdf		   Generate a trade-paper PDF ready for CreateSpace printing"
	@echo "draftpdf	   Generate a letter-sized PDF with DRAFT watermark"
	@echo "journal	   Generate a PDF of the Book Journal files in journal/"
	@echo "tex         Generate the xelatex file for \"make pdf\" and then stop"
	@echo              processing (primarily for debugging)"
	@echo ""
	@echo "clean	   Remove all generated files"
	@echo "gitsnap	   Git snapshot commit of the current directory"
	@echo "all		   Generates epub, mobi and pdf files"
	@echo ""
	@echo "wordcount   Display a count of words in the manuscript
	@echo "logcount    Display a count of words and log in $(WORDCOUNT_FILE)"
	@echo "progress    Display progress toward the goal of $(WORDCOUNT_GOAL) total words"
	@echo ""
	@echo "Generated file basename: $(FILENAME)"

epub: $(INPUT_FILES) $(EPUB_METADATA_FILE)
	$(PANDOC) $(EPUB_OPTS) --to=epub -o $(FILENAME).epub $(INPUT_FILES) $(EPUB_METADATA_FILE)

tex: $(INPUT_FILES)
	$(PANDOC) $(PDF_OPTS) $(INPUT_FILES) -o $(FILENAME).tex

mobi: epub
	$(EBOOK_CONVERT) $(FILENAME).epub $(FILENAME).mobi

pdf: $(INPUT_FILES)
	$(PANDOC) $(PDF_OPTS) $(INPUT_FILES) -o $(FILENAME).tex
	$(PERL) scripts/fixup_xelatex.pl $(FILENAME).tex
	$(XELATEX) $(FILENAME).tex
	$(XELATEX) $(FILENAME).tex
	$(RM) -f $(FILENAME).aux $(FILENAME).log $(FILENAME).toc $(FILENAME).dvi $(FILENAME).tex

journal: $(JOURNAL_FILES)
	$(PANDOC) $(PDF_JOURNAL_OPTS) -o $(FILENAME)_journal.pdf $(JOURNAL_FILES)

draftpdf: $(INPUT_FILES)
	$(PANDOC) $(PDF_DRAFT_OPTS) -o $(FILENAME)_draft.pdf $(INPUT_FILES)

clean: ;
	$(RM) -f $(FILENAME).epub $(FILENAME).pdf $(FILENAME).mobi
	$(RM) -f $(FILENAME)_draft.pdf $(FILENAME)_journal.pdf
	$(RM) -f $(FILENAME).aux $(FILENAME).log $(FILENAME).tex $(FILENAME).dvi
	$(RM) -f $(FILENAME).fls* $(FILENAME).fdb*

gitsnap: ;
	$(GIT) add .
	$(GIT) commit -m "Snapshot commit at `date`"

wordcount: ;
	@$(PYTHON) ./scripts/wordcount.py -f $(WORDCOUNT_FILE) -g $(WORDCOUNT_GOAL) $(CONTENT_FILES)

count: wordcount

logcount: ;
	@$(PYTHON) ./scripts/wordcount.py -f $(WORDCOUNT_FILE) -g $(WORDCOUNT_GOAL) -l $(CONTENT_FILES)

progress: ;
	@$(PYTHON) ./scripts/wordcount.py -q -p -f $(WORDCOUNT_FILE) -g $(WORDCOUNT_GOAL) $(CONTENT_FILES)

.PHONY: epub mobi pdf clean draftpdf journal gitsnap all veryall wordcount count logcount progress
