#----------------------------------------------------------------------------
# Build targets: Git Helper Commands
#----------------------------------------------------------------------------

gitsnap: checkrequired ;
	$(call target_banner_generic, Create Git Snapshot)
	$(GIT) add $(BOOK_TOPDIR)
	$(GIT) commit -m "Snapshot commit at `date`"

.PHONY: gitsnap
