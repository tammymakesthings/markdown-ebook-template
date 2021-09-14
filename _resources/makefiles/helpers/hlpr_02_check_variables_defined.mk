#----------------------------------------------------------------------------
# Check if the required variables from the project makefile are defined
#----------------------------------------------------------------------------

checkrequired: checkrequired_book_metadata \
	checkrequired_project_metadata \
	checkrequired_build_opts \
	checkrequired_book_filepaths

checkrequired_book_metadata: ;
	$(call check_defined, BOOK_BASE, base directory for series)
	$(call check_defined, FILENAME, book file name)
	$(call check_defined, BOOK_TAG, book tag)
	$(call check_defined, BOOK_NUM, book number (numeric))
	$(call check_defined, BOOK_NUM_PADDED, book number (zero-padded))
	$(call check_defined, BOOK_TITLE, book title)
	$(call check_defined, SERIES_TITLE, series title)
	$(call check_defined, AUTHOR, author name)
	$(call check_defined, BOOK_TOPDIR, top directory for book)

checkrequired_project_metadata:
	$(call check_defined, WORDCOUNT_FILE, word count file)
	$(call check_defined, WORDCOUNT_GOAL, word count goal)
	$(call check_defined, BETA_PDF_FILE, beta PDF file name)
	$(call check_defined, PANDOC_METADATA_FILE, Pandoc metadata file)
	$(call check_defined, EPUB_METADATA_FILE, EPub metadata file)

checkrequired_build_opts: ;
	$(call check_defined, SPELL_OPTS, build options - SPELL_OPTS)
	$(call check_defined, COMMON_OPTS, build options - COMMON_OPTS)
	$(call check_defined, PDF_BASE_OPTS, build options - PDF_BASE_OPTS)
	$(call check_defined, PDF_FINAL_OPTS, build options - PDF_FINAL_OPTS)
	$(call check_defined, PDF_SINGLE_OPTS, build options - PDF_SINGLE_OPTS)
	$(call check_defined, EPUB_OPTS, build options - EPUB_OPTS)
	$(call check_defined, MOBI_OPTS, build options - MOBI_OPTS)
	$(call check_defined, PDF_DRAFT_OPTS, build options - PDF_DRAFT_OPTS)
	$(call check_defined, PDF_JOURNAL_OPTS, build options - PDF_JOURNAL_OPTS)

checkrequired_book_filepaths: ;
	$(call check_defined FRONTMATTER_FILES, FRONTMATTER_FILES)
	$(call check_defined MAINMATTER_FILES, MAINMATTER_FILES)
	$(call check_defined ENDMATTER_FILES, ENDMATTER_FILES)
	$(call check_defined JOURNAL_FILES, JOURNAL_FILES)
	$(call check_defined INPUT_FILES, INPUT_FILES)
	$(call check_path_exists, $(PANDOC_METADATA_FILE), $(notdir $(PANDOC_METADATA_FILE)))
	$(call check_path_exists, $(EPUB_METADATA_FILE), $(notdir $(EPUB_METADATA_FILE)))

.PHONY: checkrequired checkrequired_book_metadata checkrequired_build_opts
.PHONY: checkrequired_project_metadata checkrequired_book_filepaths
