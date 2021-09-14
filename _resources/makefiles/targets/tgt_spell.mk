#----------------------------------------------------------------------------
# Build targets: Spell Checking
#----------------------------------------------------------------------------

spell: checkrequired $(INPUT_FILES)
	$(call target_banner_generic, Check Spelling (all files))
	for file in $(INPUT_FILES) ; do \
		$(SPELL) $(SPELL_OPTS) $$file; \
	done

spellchanged: checkrequired
	$(call target_banner_generic, Check Spelling (changed files))
	for file in $(shell git status | grep '.md' | cut -d':' -f2); do \
		$(SPELL) $(SPELL_OPTS) $$file; \
	done

.PHONY: spell spellchanged
