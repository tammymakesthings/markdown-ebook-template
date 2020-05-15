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

FILENAME=mybook

#---------------------------------------------------------------------------
# Tool locations
#---------------------------------------------------------------------------

RM=/usr/bin/rm
GIT=/usr/bin/git
PANDOC=/usr/bin/pandoc
EBOOK_CONVERT=/usr/bin/ebook-convert
CONTEXT=/usr/local/texlive/2020/bin/x86_64-linux/context

#---------------------------------------------------------------------------
# Common Pandoc options
#---------------------------------------------------------------------------

COMMON_OPTS=--css ebook.css \
			--from=markdown \
			--toc \
			--toc-depth=1 \
			--strip-comments \

#---------------------------------------------------------------------------
# Format Specific Options
#---------------------------------------------------------------------------

# Pandoc options for EPub files
EPUB_OPTS=$(COMMON_OPTS) \
		  --epub-cover-image=images/cover.jpg \
		  --to=epub

# Pandoc options common to all PDF output targets
PDF_BASE_OPTS=$(COMMON_OPTS) \
			  --to=context \
			  --pdf-engine=$(CONTEXT)

# Pandoc options for final trade paper-sized PDF book
PDF_OPTS=$(PDF_BASE_OPTS) \
		 --include-in-header=tex/papersize.tex \
		 --include-in-header=tex/bodyfont.tex

# Pandoc options for letter sized draft PDF
PDF_DRAFT_OPTS=$(PDF_BASE_OPTS) \
		 --include-in-header=tex/draft.tex

# Pandoc options for printing the journal file
PDF_JOURNAL_OPTS=$(PDF_BASE_OPTS) \
				 --include-in-header=tex/bodyfont.tex

# Input files
METADATA_FILE=metadata.yaml
FRONTMATTER_FILES=$(wildcard ./fm_*.md)
MAINMATTER_FILES=$(wildcard ./ch_*.md)
ENDMATTER_FILES=$(wildcard ./em_*.md)
JOURNAL_FILES=$(wildcard ./journal/*.md)

########################### End of Configuration ############################

INPUT_FILES=$(METADATA_FILE) \
			$(FRONTMATTER_FILES) \
			$(MAINMATTER_FILES) \
			$(ENDMATTER_FILES)

all: mobi epub pdf

veryall: clean mobi pdf epub draftpdf journal

help:
	@echo "============================================================================"
	@echo "             Makefile for Markdown to Pandoc Book Publishing"
	@echo "============================================================================"
	@echo ""
	@echo "Available Targets:"
	@echo ""
	@echo "epub        Generate an EPUB ebook"
	@echo "mobi        Generate a MOBI (Kindle) ebook"
	@echo "pdf         Generate a trade-paper PDF ready for CreateSpace printing"
	@echo "draftpdf    Generate a letter-sized PDF with DRAFT watermark"
	@echo "journal     Generate a PDF of the Book Journal files in journal/"
	@echo ""
	@echo "clean       Remove all generated files"
	@echo "gitsnap     Git snapshot commit of the current directory"
	@echo "all         Generates epub, mobi and pdf files."
	@echo ""
	@echo "Generated file basename: $(FILENAME)"

epub: $(INPUT_FILES)
	$(PANDOC) $(EPUB_OPTS) --to=epub -o $(FILENAME).epub $(INPUT_FILES)

mobi: epub
	$(EBOOK_CONVERT) $(FILENAME).epub $(FILENAME).mobi

pdf: $(INPUT_FILES)
	$(PANDOC) $(PDF_OPTS) -o $(FILENAME).pdf $(INPUT_FILES)

journal: $(JOURNAL_FILES)
	$(PANDOC) $(PDF_JOURNAL_OPTS) -o $(FILENAME)_journal.pdf $(JOURNAL_FILES)

draftpdf: $(INPUT_FILES)
	$(PANDOC) $(PDF_DRAFT_OPTS) -o $(FILENAME)_draft.pdf $(INPUT_FILES)

clean:
	$(RM) -f $(FILENAME).epub $(FILENAME).pdf $(FILENAME).mobi
	$(RM) -f $(FILENAME)_draft.pdf $(FILENAME)_journal.pdf

gitsnap:
	$(GIT) add .
	$(GIT) commit -m "Snapshot commit at `date`"

.PHONY: epub mobi pdf clean draftpdf journal gitsnap all veryall
