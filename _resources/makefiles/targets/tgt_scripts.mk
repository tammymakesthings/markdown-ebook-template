#----------------------------------------------------------------------------
# Build targets: Helper scripts
#----------------------------------------------------------------------------

chapter: checkrequired ;
	$(call target_banner_generic, Add new chapter file)
	@$(PYTHON) $(SCRIPTS_DIR)/newchapter.py $(shell pwd)

.PHONY: chapter
