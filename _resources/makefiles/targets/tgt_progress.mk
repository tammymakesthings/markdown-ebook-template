#----------------------------------------------------------------------------
# Build targets: Word count and progress
#----------------------------------------------------------------------------

wordcount: checkrequired ;
	$(call target_banner_generic, Display word count)
	@$(PYTHON) $(SCRIPTS_DIR)/wordcount.py -f $(WORDCOUNT_FILE) \
		-g $(WORDCOUNT_GOAL) $(CONTENT_FILES)

count: wordcount

logcount: checkrequired ;
	$(call target_banner_generic, Update daily word count)
	@$(PYTHON) $(SCRIPTS_DIR)/wordcount.py -f $(WORDCOUNT_FILE) \
		-g $(WORDCOUNT_GOAL) -l $(CONTENT_FILES)
	$(GIT) add $(WORDCOUNT_FILE)
	$(GIT) commit -m "Updated daily word count via 'make logcount'"

progress: checkrequired ;
	$(call target_banner_generic, Display daily progress (today))
	@$(PYTHON) $(SCRIPTS_DIR)/wordcount.py -q -p -f $(WORDCOUNT_FILE) \
		-g $(WORDCOUNT_GOAL) $(CONTENT_FILES)

lprogress: checkrequired ;
	$(call target_banner_generic, Display daily progress (logged))
	@$(PYTHON) $(SCRIPTS_DIR)/wordcount.py -q -p -f $(WORDCOUNT_FILE) \
		-g $(WORDCOUNT_GOAL)

progressgraph: checkrequired ;
	$(call target_banner_generic, Generate progress graph)
	gnuplot -p $(BOOK_TOPDIR)/metadata/wordcount.gnuplot

.PHONY: wordcount count logcount progress lprogress progressgraph
