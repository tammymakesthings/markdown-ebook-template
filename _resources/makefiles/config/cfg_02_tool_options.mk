#----------------------------------------------------------------------------
# Tool Options
#----------------------------------------------------------------------------

SPELL_OPTS=check --mode=markdown

#---------------------------------------------------------------------------
# Common Pandoc options
#---------------------------------------------------------------------------

COMMON_OPTS=--css=ebook.css \
			--from=markdown+space_in_atx_header+header_attributes \
			--standalone \
			--metadata-file=$(PANDOC_METADATA_FILE) \
			--resource-path=.:$(BOOK_TOPDIR)/metadata:$(BOOK_TOPDIR)/images:$(TEXINC_DIR):$(FONTS_DIR)

PDF_BASE_OPTS=--pdf-engine=xelatex \
		-V classoption="twoside" \
		-V fontsize=12pt \
 		-V linkcolor:blue \
 		--include-in-header=$(TEXINC_DIR)/xelatex_chapterbreak.tex \
 		--include-in-header=$(TEXINC_DIR)/xelatex_bullets.tex  \
 		--include-in-header=$(TEXINC_DIR)/xelatex_codeblocks.tex \
 		--include-in-header=metadata/xelatex_hyperref.tex \
		--highlight-style=metadata/pygments.theme

#---------------------------------------------------------------------------
# Format Specific Options
#---------------------------------------------------------------------------

PDF_FINAL_OPTS=-V documentclass="book" \
			   --top-level-division=chapter \
			   --include-in-header=$(TEXINC_DIR)/xelatex_papersize.tex \
			   --include-in-header=$(TEXINC_DIR)/xelatex_titlespacing.tex \
			   -V mainfont="Crimson Text" \
			   -V monofont="Anonymous Pro"

PDF_BETA_OPTS=-V documentclass="book" \
			  --top-level-division=chapter \
			  --include-in-header=$(TEXINC_DIR)/xelatex_titlespacing.tex \
			  -V mainfont="Crimson Text" \
			  -V monofont="Anonymous Pro" \
			  --include-in-header=$(TEXINC_DIR)/xelatex_draftwatermark.tex

PDF_SINGLE_OPTS=-V documentclass="article" \
				--include-in-header=$(TEXINC_DIR)/xelatex_chapterbreak.tex \
				-V mainfont="Crimson Text" \
				-V monofont="Anonymous Pro" \
				--include-in-header=$(TEXINC_DIR)/xelatex_draftwatermark.tex

EPUB_OPTS=--css=ebook.css \
 		  --epub-metadata=$(BOOK_TOPDIR)/metadata/epub_metadata.yaml \
 		  --data-dir=. \
 		  --epub-cover-image=$(BOOK_TOPDIR)/images/ebook-cover.jpg \
 		  --epub-embed-font='$(SHARED_RESOURCES)/fonts/*.ttf'

MOBI_OPTS=--output-profile generic_eink_hd \
		  --mobi-file-type=both


PDF_DRAFT_OPTS=-V mainfont="Dark Courier" \
			   -V monofont="Dark Courier" \
			   --include-in-header=$(TEXINC_DIR)/xelatex_doublespace.tex \
			   --include-in-header=$(TEXINC_DIR)/xelatex_draftwatermark.tex

PDF_JOURNAL_OPTS=--toc \
			     --toc-depth=3 \
				 -V fontsize=12pt

